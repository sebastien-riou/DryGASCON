package vexriscv.plugin

import vexriscv.{plugin, _}
import vexriscv.ip._
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer

//class IBusCachedPlugin(config : InstructionCacheConfig, memoryTranslatorPortConfig : Any = null) extends Plugin[VexRiscv] {
//  var iBus  : InstructionCacheMemBus = null
//  override def build(pipeline: VexRiscv): Unit = ???
//}

case class TightlyCoupledBus() extends Bundle with IMasterSlave {
  val enable = Bool()
  val address = UInt(32 bits)
  val data = Bits(32 bits)

  override def asMaster(): Unit = {
    out(enable, address)
    in(data)
  }
}

case class TightlyCoupledPortParameter(name : String, hit : UInt => Bool)
case class TightlyCoupledPort(p : TightlyCoupledPortParameter, var bus : TightlyCoupledBus)
class IBusCachedPlugin(resetVector : BigInt = 0x80000000l,
                       relaxedPcCalculation : Boolean = false,
                       prediction : BranchPrediction = NONE,
                       historyRamSizeLog2 : Int = 10,
                       compressedGen : Boolean = false,
                       keepPcPlus4 : Boolean = false,
                       config : InstructionCacheConfig,
                       memoryTranslatorPortConfig : Any = null,
                       injectorStage : Boolean = false,
                       withoutInjectorStage : Boolean = false)  extends IBusFetcherImpl(
  resetVector = resetVector,
  keepPcPlus4 = keepPcPlus4,
  decodePcGen = compressedGen,
  compressedGen = compressedGen,
  cmdToRspStageCount = (if(config.twoCycleCache) 2 else 1) + (if(relaxedPcCalculation) 1 else 0),
  pcRegReusedForSecondStage = true,
  injectorReadyCutGen = false,
  prediction = prediction,
  historyRamSizeLog2 = historyRamSizeLog2,
  injectorStage = (!config.twoCycleCache && !withoutInjectorStage) || injectorStage){
  import config._

  assert(!(withoutInjectorStage && injectorStage))

  var iBus  : InstructionCacheMemBus = null
  var mmuBus : MemoryTranslatorBus = null
  var privilegeService : PrivilegeService = null
  var redoBranch : Flow[UInt] = null
  var decodeExceptionPort : Flow[ExceptionCause] = null
  val tightlyCoupledPorts = ArrayBuffer[TightlyCoupledPort]()


  def newTightlyCoupledPort(p : TightlyCoupledPortParameter) = {
    val port = TightlyCoupledPort(p, null)
    tightlyCoupledPorts += port
    this
  }


  object FLUSH_ALL extends Stageable(Bool)
  object IBUS_ACCESS_ERROR extends Stageable(Bool)
  object IBUS_MMU_MISS extends Stageable(Bool)
  object IBUS_ILLEGAL_ACCESS extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    super.setup(pipeline)

    def MANAGEMENT  = M"-----------------100-----0001111"

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(FLUSH_ALL, False)
    decoderService.add(MANAGEMENT,  List(
        FLUSH_ALL -> True
    ))


    redoBranch = pipeline.service(classOf[JumpService]).createJumpInterface(pipeline.decode, priority = 1) //Priority 1 will win against branch predictor

    if(catchSomething) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1)
    }

    if(pipeline.serviceExist(classOf[MemoryTranslator]))
      mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(MemoryTranslatorPort.PRIORITY_INSTRUCTION, memoryTranslatorPortConfig)

    privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())

    if(pipeline.serviceExist(classOf[ReportService])){
      val report = pipeline.service(classOf[ReportService])
      report.add("iBus" -> {
        val e = new BusReport()
        val c = new CacheReport()
        e.kind = "cached"
        e.flushInstructions.add(0x400F) //invalid instruction cache
        e.flushInstructions.add(0x13)
        e.flushInstructions.add(0x13)
        e.flushInstructions.add(0x13)

        e.info = c
        c.size = cacheSize
        c.bytePerLine = bytePerLine

        e
      })
    }
  }


  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    pipeline plug new FetchArea(pipeline) {
      val cache = new InstructionCache(IBusCachedPlugin.this.config)
      iBus = master(new InstructionCacheMemBus(IBusCachedPlugin.this.config)).setName("iBus")
      iBus <> cache.io.mem
      iBus.cmd.address.allowOverride := cache.io.mem.cmd.address
      
      val stageOffset = if(relaxedPcCalculation) 1 else 0
      def stages = iBusRsp.stages.drop(stageOffset)

      tightlyCoupledPorts.foreach(p => p.bus = master(TightlyCoupledBus()).setName(p.p.name))

      val s0 = new Area {
        //address decoding
        val tightlyCoupledHits = Vec(tightlyCoupledPorts.map(_.p.hit(stages(0).input.payload)))
        val tightlyCoupledHit = tightlyCoupledHits.orR

        for((port, hit) <- (tightlyCoupledPorts, tightlyCoupledHits).zipped){
          port.bus.enable := stages(0).input.fire && hit
          port.bus.address := stages(0).input.payload(31 downto 2) @@ U"00"
        }

        //Connect prefetch cache side
        cache.io.cpu.prefetch.isValid := stages(0).input.valid && !tightlyCoupledHit
        cache.io.cpu.prefetch.pc := stages(0).input.payload
        stages(0).halt setWhen (cache.io.cpu.prefetch.haltIt)


        cache.io.cpu.fetch.isRemoved := flush
      }


      val s1 = new Area {
        val tightlyCoupledHits = RegNextWhen(s0.tightlyCoupledHits, stages(1).input.ready)
        val tightlyCoupledHit = RegNextWhen(s0.tightlyCoupledHit, stages(1).input.ready)

        cache.io.cpu.fetch.dataBypassValid := tightlyCoupledHit
        cache.io.cpu.fetch.dataBypass := (if(tightlyCoupledPorts.isEmpty) B(0) else MuxOH(tightlyCoupledHits, tightlyCoupledPorts.map(e => CombInit(e.bus.data))))

        //Connect fetch cache side
        cache.io.cpu.fetch.isValid := stages(1).input.valid && !tightlyCoupledHit
        cache.io.cpu.fetch.isStuck := !stages(1).input.ready
        cache.io.cpu.fetch.pc := stages(1).input.payload

        if (!twoCycleCache) {
          cache.io.cpu.fetch.isUser := privilegeService.isUser(decode)
        }
      }

      val s2 = twoCycleCache generate new Area {
        val tightlyCoupledHit = RegNextWhen(s1.tightlyCoupledHit, stages(2).input.ready)
        cache.io.cpu.decode.isValid := stages(2).input.valid && !tightlyCoupledHit
        cache.io.cpu.decode.isStuck := !stages(2).input.ready
        cache.io.cpu.decode.pc := stages(2).input.payload
        cache.io.cpu.decode.isUser := privilegeService.isUser(decode)

        if ((!twoCycleRam || wayCount == 1) && !compressedGen && !injectorStage) {
          decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck, decode.input(INSTRUCTION), cache.io.cpu.fetch.data)
        }
      }

      val rsp = new Area {
        val iBusRspOutputHalt = False

        val cacheRsp = if (twoCycleCache) cache.io.cpu.decode else cache.io.cpu.fetch
        val cacheRspArbitration = stages(if (twoCycleCache) 2 else 1)
        var issueDetected = False
        val redoFetch = False //RegNext(False) init(False)
        when(cacheRsp.isValid && cacheRsp.cacheMiss && !issueDetected) {
          issueDetected \= True
          redoFetch := iBusRsp.readyForError
        }


        //Refill / redo
        assert(decodePcGen == compressedGen)
        cache.io.cpu.fill.valid := redoFetch
        cache.io.cpu.fill.payload := cacheRsp.physicalAddress
        redoBranch.valid := redoFetch
        redoBranch.payload := (if (decodePcGen) decode.input(PC) else cacheRsp.pc)

        if (catchSomething) {
          val accessFault = if (catchAccessFault) cacheRsp.error else False
          val mmuMiss = if (catchMemoryTranslationMiss) cacheRsp.mmuMiss else False
          val illegalAccess = if (catchIllegalAccess) cacheRsp.illegalAccess else False

          decodeExceptionPort.valid := False
          decodeExceptionPort.code := mmuMiss ? U(14) | 1
          decodeExceptionPort.badAddr := cacheRsp.pc
          when(cacheRsp.isValid && (accessFault || mmuMiss || illegalAccess) && !issueDetected) {
            issueDetected \= True
            decodeExceptionPort.valid := iBusRsp.readyForError
          }
        }

        cacheRspArbitration.halt setWhen (issueDetected || iBusRspOutputHalt)
        iBusRsp.output.valid := cacheRspArbitration.output.valid
        cacheRspArbitration.output.ready := iBusRsp.output.ready
        iBusRsp.output.rsp.inst := cacheRsp.data
        iBusRsp.output.pc := cacheRspArbitration.output.payload
      }

      if (mmuBus != null) {
        cache.io.cpu.fetch.mmuBus <> mmuBus
        (if (twoCycleCache) stages(1).halt else rsp.iBusRspOutputHalt) setWhen (mmuBus.cmd.isValid && !mmuBus.rsp.hit && !mmuBus.rsp.miss)
      } else {
        cache.io.cpu.fetch.mmuBus.rsp.physicalAddress := cache.io.cpu.fetch.mmuBus.cmd.virtualAddress
        cache.io.cpu.fetch.mmuBus.rsp.allowExecute := True
        cache.io.cpu.fetch.mmuBus.rsp.allowRead := True
        cache.io.cpu.fetch.mmuBus.rsp.allowWrite := True
        cache.io.cpu.fetch.mmuBus.rsp.allowUser := True
        cache.io.cpu.fetch.mmuBus.rsp.isIoAccess := False
        cache.io.cpu.fetch.mmuBus.rsp.miss := False
        cache.io.cpu.fetch.mmuBus.rsp.hit := False
      }

      val flushStage = if(memory != null) memory else execute
      flushStage plug new Area {
        import flushStage._

        cache.io.flush.cmd.valid := False
        when(arbitration.isValid && input(FLUSH_ALL)) {
          cache.io.flush.cmd.valid := True

          when(!cache.io.flush.cmd.ready) {
            arbitration.haltItself := True
          }
        }
      }
    }
  }
}
