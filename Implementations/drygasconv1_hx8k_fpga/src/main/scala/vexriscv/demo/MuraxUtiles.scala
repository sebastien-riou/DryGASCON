package vexriscv.demo

import java.nio.{ByteBuffer, ByteOrder}

import spinal.core._
//import spinal.core.src.main.scala.spinal.core.Blackbox
//import spinal.core.Blackbox
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config, Apb3SlaveFactory}
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.misc.{HexTools, InterruptCtrl, Prescaler, Timer}
import spinal.lib._
import spinal.lib.bus.simple._
import vexriscv.plugin.{DBusSimpleBus, IBusSimpleBus}
import spinal.lib.bus.misc.BusSlaveFactory

class MuraxMasterArbiter(pipelinedMemoryBusConfig : PipelinedMemoryBusConfig) extends Component{
  val io = new Bundle{
    val iBus = slave(IBusSimpleBus(false))
    val dBus = slave(DBusSimpleBus())
    val masterBus = master(PipelinedMemoryBus(pipelinedMemoryBusConfig))
  }

  io.masterBus.cmd.valid   := io.iBus.cmd.valid || io.dBus.cmd.valid
  io.masterBus.cmd.write      := io.dBus.cmd.valid && io.dBus.cmd.wr
  io.masterBus.cmd.address := io.dBus.cmd.valid ? io.dBus.cmd.address | io.iBus.cmd.pc
  io.masterBus.cmd.data    := io.dBus.cmd.data
  io.masterBus.cmd.mask    := io.dBus.cmd.size.mux(
    0 -> B"0001",
    1 -> B"0011",
    default -> B"1111"
  ) |<< io.dBus.cmd.address(1 downto 0)
  io.iBus.cmd.ready := io.masterBus.cmd.ready && !io.dBus.cmd.valid
  io.dBus.cmd.ready := io.masterBus.cmd.ready


  val rspPending = RegInit(False) clearWhen(io.masterBus.rsp.valid)
  val rspTarget = RegInit(False)
  when(io.masterBus.cmd.fire && !io.masterBus.cmd.write){
    rspTarget  := io.dBus.cmd.valid
    rspPending := True
  }

  when(rspPending && !io.masterBus.rsp.valid){
    io.iBus.cmd.ready := False
    io.dBus.cmd.ready := False
    io.masterBus.cmd.valid := False
  }

  io.iBus.rsp.valid := io.masterBus.rsp.valid && !rspTarget
  io.iBus.rsp.inst  := io.masterBus.rsp.data
  io.iBus.rsp.error := False

  io.dBus.rsp.ready := io.masterBus.rsp.valid && rspTarget
  io.dBus.rsp.data  := io.masterBus.rsp.data
  io.dBus.rsp.error := False
}


case class MuraxPipelinedMemoryBusRam(onChipRamSize : BigInt, onChipRamHexFile : String, pipelinedMemoryBusConfig : PipelinedMemoryBusConfig) extends Component{
  val io = new Bundle{
    val bus = slave(PipelinedMemoryBus(pipelinedMemoryBusConfig))
  }

  val ram = Mem(Bits(32 bits), onChipRamSize / 4)
  io.bus.rsp.valid := RegNext(io.bus.cmd.fire && !io.bus.cmd.write) init(False)
  io.bus.rsp.data := ram.readWriteSync(
    address = (io.bus.cmd.address >> 2).resized,
    data  = io.bus.cmd.data,
    enable  = io.bus.cmd.valid,
    write  = io.bus.cmd.write,
    mask  = io.bus.cmd.mask
  )
  io.bus.cmd.ready := True

  if(onChipRamHexFile != null){
    HexTools.initRam(ram, onChipRamHexFile, 0x80000000l)
  }
}



case class Apb3Rom(onChipRamBinFile : String) extends Component{
  import java.nio.file.{Files, Paths}
  val byteArray = Files.readAllBytes(Paths.get(onChipRamBinFile))
  val wordCount = (byteArray.length+3)/4
  val buffer = ByteBuffer.wrap(Files.readAllBytes(Paths.get(onChipRamBinFile))).order(ByteOrder.LITTLE_ENDIAN);
  val wordArray = (0 until wordCount).map(i => {
    val v = buffer.getInt
    if(v < 0)  BigInt(v.toLong & 0xFFFFFFFFl) else  BigInt(v)
  })

  val io = new Bundle{
    val apb = slave(Apb3(log2Up(wordCount*4),32))
  }

  val rom = Mem(Bits(32 bits), wordCount) initBigInt(wordArray)
//  io.apb.PRDATA := rom.readSync(io.apb.PADDR >> 2)
  io.apb.PRDATA := rom.readAsync(RegNext(io.apb.PADDR >> 2))
  io.apb.PREADY := True
}



class MuraxPipelinedMemoryBusDecoder(master : PipelinedMemoryBus, val specification : Seq[(PipelinedMemoryBus,SizeMapping)], pipelineMaster : Boolean) extends Area{
  val masterPipelined = PipelinedMemoryBus(master.config)
  if(!pipelineMaster) {
    masterPipelined.cmd << master.cmd
    masterPipelined.rsp >> master.rsp
  } else {
    masterPipelined.cmd <-< master.cmd
    masterPipelined.rsp >> master.rsp
  }

  val slaveBuses = specification.map(_._1)
  val memorySpaces = specification.map(_._2)

  val hits = for((slaveBus, memorySpace) <- specification) yield {
    val hit = memorySpace.hit(masterPipelined.cmd.address)
    slaveBus.cmd.valid   := masterPipelined.cmd.valid && hit
    slaveBus.cmd.payload := masterPipelined.cmd.payload.resized
    hit
  }
  val noHit = !hits.orR
  masterPipelined.cmd.ready := (hits,slaveBuses).zipped.map(_ && _.cmd.ready).orR || noHit

  val rspPending  = RegInit(False) clearWhen(masterPipelined.rsp.valid) setWhen(masterPipelined.cmd.fire && !masterPipelined.cmd.write)
  val rspNoHit    = RegNext(False) init(False) setWhen(noHit)
  val rspSourceId = RegNextWhen(OHToUInt(hits), masterPipelined.cmd.fire)
  masterPipelined.rsp.valid   := slaveBuses.map(_.rsp.valid).orR || (rspPending && rspNoHit)
  masterPipelined.rsp.payload := slaveBuses.map(_.rsp.payload).read(rspSourceId)

  when(rspPending && !masterPipelined.rsp.valid) { //Only one pending read request is allowed
    masterPipelined.cmd.ready := False
    slaveBuses.foreach(_.cmd.valid := False)
  }
}

class MuraxApb3Timer extends Component{
  val io = new Bundle {
    val apb = slave(Apb3(
      addressWidth = 8,
      dataWidth = 32
    ))
    val interrupt = out Bool
  }

  val prescaler = Prescaler(16)
  val timerA,timerB = Timer(16)

  val busCtrl = Apb3SlaveFactory(io.apb)
  val prescalerBridge = prescaler.driveFrom(busCtrl,0x00)

  val timerABridge = timerA.driveFrom(busCtrl,0x40)(
    ticks  = List(True, prescaler.io.overflow),
    clears = List(timerA.io.full)
  )

  val timerBBridge = timerB.driveFrom(busCtrl,0x50)(
    ticks  = List(True, prescaler.io.overflow),
    clears = List(timerB.io.full)
  )

  val interruptCtrl = InterruptCtrl(2)
  val interruptCtrlBridge = interruptCtrl.driveFrom(busCtrl,0x10)
  interruptCtrl.io.inputs(0) := timerA.io.full
  interruptCtrl.io.inputs(1) := timerB.io.full
  io.interrupt := interruptCtrl.io.pendings.orR
}

case class drygascon128() extends BlackBox {
  val io = new Bundle {
    val clk    = in  Bool
    val clk_en = in Bool
    val rst    = in Bool
    val din    = in  Bits(32 bits)
    val ds     = in  Bits(4 bits)
    val wr_i   = in Bool
    val wr_c   = in Bool
    val wr_x   = in Bool
    val rounds = in  Bits(4 bits)
    val start  = in Bool
    val rd_r   = in Bool
    val rd_c   = in Bool
    val dout   = out Bits(32 bits)
    val idle   = out Bool
  }

  def driveFrom(busCtrl : BusSlaveFactory,baseAddress : BigInt)
               () = new Area {

  }

  // Map the clk
  mapCurrentClockDomain(io.clk, io.rst, io.clk_en)

  // Remove io_ prefix
  noIoPrefix()

  // Add all rtl dependencies
  addRTLPath("./src/drygascon128.v")
}

class MuraxApb3Drygascon128 extends Component{
  val io = new Bundle {
    val apb = slave(Apb3(
      addressWidth = 8,
      dataWidth = 32
    ))
  }

  //Instantiate the blackbox
  val core = new drygascon128()

  //val busCtrl = Apb3SlaveFactory(io.apb)
  //val drygascon128Bridge = core.driveFrom(busCtrl,0x00)()

  val selId = 0
  val selected = io.apb.PSEL(selId) && io.apb.PENABLE
  val askWrite = (selected &&  io.apb.PWRITE).allowPruning()
  val askRead  = (selected && !io.apb.PWRITE).allowPruning()
  val doWrite  = (selected &&  io.apb.PREADY &&  io.apb.PWRITE).allowPruning()
  val doRead   = (selected &&  io.apb.PREADY && !io.apb.PWRITE).allowPruning()

  val start = Reg(Bool) init(False)
  val ds = Reg(Bits(4 bits)) init(0)
  val rounds = Reg(Bits(4 bits)) init(0xB)

  val core_read = Reg(Bool) init(False)

  val rd_c = Bool
  val wr_c = Bool
  val rd_r = Bool
  val wr_x = Bool
  val wr_i = Bool

  start  <> core.io.start
  ds     <> core.io.ds
  rounds <> core.io.rounds
  rd_c   <> core.io.rd_c
  wr_c   <> core.io.wr_c
  rd_r   <> core.io.rd_r
  wr_x   <> core.io.wr_x
  wr_i   <> core.io.wr_i

  val ctrl = Bits(32 bits)

  val zeroes = B(32 bits, default -> False)
  ctrl := core.io.idle ## zeroes(30 downto 9) ## start ## ds ## rounds

  if(io.apb.config.useSlaveError) io.apb.PSLVERROR := False
  core.io.din := io.apb.PWDATA

  val ctrl_hit = selected && (io.apb.PADDR === U(0, 8 bits))

  io.apb.PREADY := askWrite | ctrl_hit | core_read

  start  := False
  rd_c := False
  wr_c := False
  rd_r := False
  wr_x := False
  wr_i := False
  io.apb.PRDATA := U(0x0EADBEEF, 32 bits).asBits

  when(doWrite && ctrl_hit){
    rounds := io.apb.PWDATA(3 downto 0)
    ds     := io.apb.PWDATA(7 downto 4)
    start  := io.apb.PWDATA(8)
  }

  core_read := False
  when(askRead && !ctrl_hit){
    core_read := True
  }

  //combo logic
  when(selected){
      switch(io.apb.PADDR){
          is(0){//read/write CTRL reg
            io.apb.PRDATA := ctrl
          }
          is(4){//read/write c
            io.apb.PRDATA := core.io.dout
            rd_c := !doWrite & !core_read
            wr_c := doWrite
          }
          is(8){//read r, write i
            io.apb.PRDATA := core.io.dout
            rd_r := !doWrite & !core_read
            wr_i := doWrite
          }
          is(12){//write x
            wr_x := doWrite
          }
      }
  }
}
