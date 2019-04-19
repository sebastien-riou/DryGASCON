
build/demo.elf:     file format elf32-littleriscv


Disassembly of section .vector:

80000000 <crtStart>:
.global crtStart
.global main
.global irqCallback

crtStart:
  j crtInit
80000000:	0b00006f          	j	800000b0 <crtInit>
  nop
80000004:	00000013          	nop
  nop
80000008:	00000013          	nop
  nop
8000000c:	00000013          	nop
  nop
80000010:	00000013          	nop
  nop
80000014:	00000013          	nop
  nop
80000018:	00000013          	nop
  nop
8000001c:	00000013          	nop

80000020 <trap_entry>:

.global  trap_entry
trap_entry:
  sw x1,  - 1*4(sp)
80000020:	fe112e23          	sw	ra,-4(sp)
  sw x5,  - 2*4(sp)
80000024:	fe512c23          	sw	t0,-8(sp)
  sw x6,  - 3*4(sp)
80000028:	fe612a23          	sw	t1,-12(sp)
  sw x7,  - 4*4(sp)
8000002c:	fe712823          	sw	t2,-16(sp)
  sw x10, - 5*4(sp)
80000030:	fea12623          	sw	a0,-20(sp)
  sw x11, - 6*4(sp)
80000034:	feb12423          	sw	a1,-24(sp)
  sw x12, - 7*4(sp)
80000038:	fec12223          	sw	a2,-28(sp)
  sw x13, - 8*4(sp)
8000003c:	fed12023          	sw	a3,-32(sp)
  sw x14, - 9*4(sp)
80000040:	fce12e23          	sw	a4,-36(sp)
  sw x15, -10*4(sp)
80000044:	fcf12c23          	sw	a5,-40(sp)
  sw x16, -11*4(sp)
80000048:	fd012a23          	sw	a6,-44(sp)
  sw x17, -12*4(sp)
8000004c:	fd112823          	sw	a7,-48(sp)
  sw x28, -13*4(sp)
80000050:	fdc12623          	sw	t3,-52(sp)
  sw x29, -14*4(sp)
80000054:	fdd12423          	sw	t4,-56(sp)
  sw x30, -15*4(sp)
80000058:	fde12223          	sw	t5,-60(sp)
  sw x31, -16*4(sp)
8000005c:	fdf12023          	sw	t6,-64(sp)
  addi sp,sp,-16*4
80000060:	fc010113          	addi	sp,sp,-64
  call irqCallback
80000064:	5d8000ef          	jal	ra,8000063c <irqCallback>
  lw x1 , 15*4(sp)
80000068:	03c12083          	lw	ra,60(sp)
  lw x5,  14*4(sp)
8000006c:	03812283          	lw	t0,56(sp)
  lw x6,  13*4(sp)
80000070:	03412303          	lw	t1,52(sp)
  lw x7,  12*4(sp)
80000074:	03012383          	lw	t2,48(sp)
  lw x10, 11*4(sp)
80000078:	02c12503          	lw	a0,44(sp)
  lw x11, 10*4(sp)
8000007c:	02812583          	lw	a1,40(sp)
  lw x12,  9*4(sp)
80000080:	02412603          	lw	a2,36(sp)
  lw x13,  8*4(sp)
80000084:	02012683          	lw	a3,32(sp)
  lw x14,  7*4(sp)
80000088:	01c12703          	lw	a4,28(sp)
  lw x15,  6*4(sp)
8000008c:	01812783          	lw	a5,24(sp)
  lw x16,  5*4(sp)
80000090:	01412803          	lw	a6,20(sp)
  lw x17,  4*4(sp)
80000094:	01012883          	lw	a7,16(sp)
  lw x28,  3*4(sp)
80000098:	00c12e03          	lw	t3,12(sp)
  lw x29,  2*4(sp)
8000009c:	00812e83          	lw	t4,8(sp)
  lw x30,  1*4(sp)
800000a0:	00412f03          	lw	t5,4(sp)
  lw x31,  0*4(sp)
800000a4:	00012f83          	lw	t6,0(sp)
  addi sp,sp,16*4
800000a8:	04010113          	addi	sp,sp,64
  mret
800000ac:	30200073          	mret

800000b0 <crtInit>:


crtInit:
  .option push
  .option norelax
  la gp, __global_pointer$
800000b0:	00002197          	auipc	gp,0x2
800000b4:	c2018193          	addi	gp,gp,-992 # 80001cd0 <__global_pointer$>
  .option pop
  la sp, _stack_start
800000b8:	ae018113          	addi	sp,gp,-1312 # 800017b0 <_stack_start>

800000bc <bss_init>:

bss_init:
  la a0, _bss_start
800000bc:	81018513          	addi	a0,gp,-2032 # 800014e0 <max_time>
  la a1, _bss_end
800000c0:	8d818593          	addi	a1,gp,-1832 # 800015a8 <_bss_end>

800000c4 <bss_loop>:
bss_loop:
  beq a0,a1,bss_done
800000c4:	00b50863          	beq	a0,a1,800000d4 <bss_done>
  sw zero,0(a0)
800000c8:	00052023          	sw	zero,0(a0)
  add a0,a0,4
800000cc:	00450513          	addi	a0,a0,4
  j bss_loop
800000d0:	ff5ff06f          	j	800000c4 <bss_loop>

800000d4 <bss_done>:
bss_done:

ctors_init:
  la a0, _ctors_start
800000d4:	00001517          	auipc	a0,0x1
800000d8:	3fc50513          	addi	a0,a0,1020 # 800014d0 <_ctors_end>
  addi sp,sp,-4
800000dc:	ffc10113          	addi	sp,sp,-4

800000e0 <ctors_loop>:
ctors_loop:
  la a1, _ctors_end
800000e0:	00001597          	auipc	a1,0x1
800000e4:	3f058593          	addi	a1,a1,1008 # 800014d0 <_ctors_end>
  beq a0,a1,ctors_done
800000e8:	00b50e63          	beq	a0,a1,80000104 <ctors_done>
  lw a3,0(a0)
800000ec:	00052683          	lw	a3,0(a0)
  add a0,a0,4
800000f0:	00450513          	addi	a0,a0,4
  sw a0,0(sp)
800000f4:	00a12023          	sw	a0,0(sp)
  jalr  a3
800000f8:	000680e7          	jalr	a3
  lw a0,0(sp)
800000fc:	00012503          	lw	a0,0(sp)
  j ctors_loop
80000100:	fe1ff06f          	j	800000e0 <ctors_loop>

80000104 <ctors_done>:
ctors_done:
  addi sp,sp,4
80000104:	00410113          	addi	sp,sp,4


  li a0, 0x880     //880 enable timer + external interrupts
80000108:	00001537          	lui	a0,0x1
8000010c:	88050513          	addi	a0,a0,-1920 # 880 <_stack_size+0x680>
  csrw mie,a0
80000110:	30451073          	csrw	mie,a0
  li a0, 0x1808     //1808 enable interrupts
80000114:	00002537          	lui	a0,0x2
80000118:	80850513          	addi	a0,a0,-2040 # 1808 <_stack_size+0x1608>
  csrw mstatus,a0
8000011c:	30051073          	csrw	mstatus,a0

  call main
80000120:	49d000ef          	jal	ra,80000dbc <end>

80000124 <infinitLoop>:
infinitLoop:
  j infinitLoop
80000124:	0000006f          	j	80000124 <infinitLoop>

Disassembly of section .memory:

80000128 <drygascon128hw_get_c.constprop.5>:
    for(unsigned int i=0;i<10;i++){
        hw->C = c[i];
    }
}

static void drygascon128hw_get_c(Drygascon128_Regs *hw, uint32_t *const c){
80000128:	02850793          	addi	a5,a0,40
    for(unsigned int i=0;i<10;i++){
        c[i] = hw->C;
8000012c:	f00306b7          	lui	a3,0xf0030
80000130:	0046a703          	lw	a4,4(a3) # f0030004 <__global_pointer$+0x7002e334>
80000134:	00450513          	addi	a0,a0,4
80000138:	fee52e23          	sw	a4,-4(a0)
    for(unsigned int i=0;i<10;i++){
8000013c:	fef51ae3          	bne	a0,a5,80000130 <drygascon128hw_get_c.constprop.5+0x8>
    }
}
80000140:	00008067          	ret

80000144 <drygascon128hw_set_c.constprop.6>:
static void drygascon128hw_set_c(Drygascon128_Regs *hw, const uint32_t *const c){
80000144:	02850793          	addi	a5,a0,40
        hw->C = c[i];
80000148:	f0030737          	lui	a4,0xf0030
8000014c:	00052683          	lw	a3,0(a0)
80000150:	00450513          	addi	a0,a0,4
80000154:	00d72223          	sw	a3,4(a4) # f0030004 <__global_pointer$+0x7002e334>
    for(unsigned int i=0;i<10;i++){
80000158:	fef51ae3          	bne	a0,a5,8000014c <drygascon128hw_set_c.constprop.6+0x8>
}
8000015c:	00008067          	ret

80000160 <uart_write.constprop.11>:
	enum UartStop stop;
	uint32_t clockDivider;
} Uart_Config;

static uint32_t uart_writeAvailability(Uart_Reg *reg){
	return (reg->STATUS >> 16) & 0xFF;
80000160:	f0010737          	lui	a4,0xf0010
80000164:	00472783          	lw	a5,4(a4) # f0010004 <__global_pointer$+0x7000e334>
80000168:	0107d793          	srli	a5,a5,0x10
8000016c:	0ff7f793          	andi	a5,a5,255
static uint32_t uart_readOccupancy(Uart_Reg *reg){
	return reg->STATUS >> 24;
}

static void uart_write(Uart_Reg *reg, uint32_t data){
	while(uart_writeAvailability(reg) == 0);
80000170:	fe078ae3          	beqz	a5,80000164 <uart_write.constprop.11+0x4>
	reg->DATA = data;
80000174:	00a72023          	sw	a0,0(a4)
}
80000178:	00008067          	ret

8000017c <drygascon128_benchmark>:
    hw->IO = i[0];
8000017c:	88018693          	addi	a3,gp,-1920 # 80001550 <drygascon128_state>
80000180:	0286a603          	lw	a2,40(a3)
80000184:	f0030737          	lui	a4,0xf0030
80000188:	88018793          	addi	a5,gp,-1920 # 80001550 <drygascon128_state>
8000018c:	00c72423          	sw	a2,8(a4) # f0030008 <__global_pointer$+0x7002e338>
    hw->IO = i[1];
80000190:	02c6a603          	lw	a2,44(a3)
80000194:	00c72423          	sw	a2,8(a4)
    hw->IO = i[2];
80000198:	0306a603          	lw	a2,48(a3)
8000019c:	00c72423          	sw	a2,8(a4)
    hw->IO = i[3];
800001a0:	0346a683          	lw	a3,52(a3)
800001a4:	00d72423          	sw	a3,8(a4)
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
800001a8:	10700693          	li	a3,263
800001ac:	00d72023          	sw	a3,0(a4)
    return hw->CTRL & DRYGASCON128_IDLE_MASK;
800001b0:	00072683          	lw	a3,0(a4)
    while(!drygascon128hw_idle(hw));
800001b4:	fe06dee3          	bgez	a3,800001b0 <drygascon128_benchmark+0x34>
    o[0] = hw->IO;
800001b8:	00872683          	lw	a3,8(a4)
800001bc:	02d7a423          	sw	a3,40(a5)
    o[1] = hw->IO;
800001c0:	00872683          	lw	a3,8(a4)
800001c4:	02d7a623          	sw	a3,44(a5)
    o[2] = hw->IO;
800001c8:	00872683          	lw	a3,8(a4)
800001cc:	02d7a823          	sw	a3,48(a5)
    o[3] = hw->IO;
800001d0:	00872703          	lw	a4,8(a4)
800001d4:	02e7aa23          	sw	a4,52(a5)

		if(i+1==nblocks) ds = DRYSPONGE_DSINFO(0, DRYSPONGE_DM, 1);
		drygascon128_f(drygascon128_state,(uint32_t*)(io+(i+1)*2),ds,7);
	}
	memcpy(io+nblocks*2,drygascon128_state+DRYSPONGE_CAPACITYSIZE64,DRYSPONGE_BLOCKSIZE);*/
}
800001d8:	00008067          	ret

800001dc <memcpy>:
{
800001dc:	00c50633          	add	a2,a0,a2
  char *d = dest;
800001e0:	00050793          	mv	a5,a0
  while (len--)
800001e4:	00c79463          	bne	a5,a2,800001ec <memcpy+0x10>
}
800001e8:	00008067          	ret
    *d++ = *s++;
800001ec:	00158593          	addi	a1,a1,1
800001f0:	fff5c703          	lbu	a4,-1(a1)
800001f4:	00178793          	addi	a5,a5,1
800001f8:	fee78fa3          	sb	a4,-1(a5)
800001fc:	fe9ff06f          	j	800001e4 <memcpy+0x8>

80000200 <memcmp>:
{
80000200:	00c58633          	add	a2,a1,a2
  while (count-- > 0)
80000204:	00c59663          	bne	a1,a2,80000210 <memcmp+0x10>
  return 0;
80000208:	00000513          	li	a0,0
}
8000020c:	00008067          	ret
      if (*s1++ != *s2++)
80000210:	00150513          	addi	a0,a0,1
80000214:	00158593          	addi	a1,a1,1
80000218:	fff54703          	lbu	a4,-1(a0)
8000021c:	fff5c783          	lbu	a5,-1(a1)
80000220:	fef702e3          	beq	a4,a5,80000204 <memcmp+0x4>
	  return s1[-1] < s2[-1] ? -1 : 1;
80000224:	fff00513          	li	a0,-1
80000228:	fef762e3          	bltu	a4,a5,8000020c <memcmp+0xc>
8000022c:	00100513          	li	a0,1
80000230:	00008067          	ret

80000234 <memset>:
{
80000234:	00c50633          	add	a2,a0,a2
  unsigned char *ptr = dest;
80000238:	00050793          	mv	a5,a0
  while (len-- > 0)
8000023c:	00c79463          	bne	a5,a2,80000244 <memset+0x10>
}
80000240:	00008067          	ret
    *ptr++ = val;
80000244:	00178793          	addi	a5,a5,1
80000248:	feb78fa3          	sb	a1,-1(a5)
8000024c:	ff1ff06f          	j	8000023c <memset+0x8>

80000250 <nibble_to_hexstr>:
	n = n & 0xF;
80000250:	00f5f593          	andi	a1,a1,15
	if(n<10) str[0] = '0'+n;
80000254:	00900713          	li	a4,9
80000258:	0ff5f793          	andi	a5,a1,255
8000025c:	00b76863          	bltu	a4,a1,8000026c <nibble_to_hexstr+0x1c>
80000260:	03078793          	addi	a5,a5,48
	else str[0] = 'A'-10+n;
80000264:	00f50023          	sb	a5,0(a0)
}
80000268:	00008067          	ret
	else str[0] = 'A'-10+n;
8000026c:	03778793          	addi	a5,a5,55
80000270:	ff5ff06f          	j	80000264 <nibble_to_hexstr+0x14>

80000274 <u8_to_hexstr>:
void u8_to_hexstr(uint8_t*str,uint8_t b){
80000274:	ff010113          	addi	sp,sp,-16
80000278:	00812423          	sw	s0,8(sp)
8000027c:	00058413          	mv	s0,a1
	nibble_to_hexstr(str,b>>4);
80000280:	0045d593          	srli	a1,a1,0x4
void u8_to_hexstr(uint8_t*str,uint8_t b){
80000284:	00912223          	sw	s1,4(sp)
80000288:	00112623          	sw	ra,12(sp)
8000028c:	00050493          	mv	s1,a0
	nibble_to_hexstr(str,b>>4);
80000290:	fc1ff0ef          	jal	ra,80000250 <nibble_to_hexstr>
	nibble_to_hexstr(str+1,b);
80000294:	00040593          	mv	a1,s0
}
80000298:	00812403          	lw	s0,8(sp)
8000029c:	00c12083          	lw	ra,12(sp)
	nibble_to_hexstr(str+1,b);
800002a0:	00148513          	addi	a0,s1,1
}
800002a4:	00412483          	lw	s1,4(sp)
800002a8:	01010113          	addi	sp,sp,16
	nibble_to_hexstr(str+1,b);
800002ac:	fa5ff06f          	j	80000250 <nibble_to_hexstr>

800002b0 <bin_to_hexstr>:
void bin_to_hexstr(uint8_t*str,const uint8_t *const buf, size_t len){
800002b0:	ff010113          	addi	sp,sp,-16
800002b4:	00812423          	sw	s0,8(sp)
800002b8:	00912223          	sw	s1,4(sp)
800002bc:	01212023          	sw	s2,0(sp)
800002c0:	00112623          	sw	ra,12(sp)
800002c4:	00058413          	mv	s0,a1
800002c8:	00050493          	mv	s1,a0
800002cc:	00c58933          	add	s2,a1,a2
	for(size_t i=0;i<len;i++){
800002d0:	01241e63          	bne	s0,s2,800002ec <bin_to_hexstr+0x3c>
}
800002d4:	00c12083          	lw	ra,12(sp)
800002d8:	00812403          	lw	s0,8(sp)
800002dc:	00412483          	lw	s1,4(sp)
800002e0:	00012903          	lw	s2,0(sp)
800002e4:	01010113          	addi	sp,sp,16
800002e8:	00008067          	ret
		u8_to_hexstr(str+2*i,buf[i]);
800002ec:	00044583          	lbu	a1,0(s0)
800002f0:	00048513          	mv	a0,s1
800002f4:	00140413          	addi	s0,s0,1
800002f8:	f7dff0ef          	jal	ra,80000274 <u8_to_hexstr>
800002fc:	00248493          	addi	s1,s1,2
80000300:	fd1ff06f          	j	800002d0 <bin_to_hexstr+0x20>

80000304 <u32_to_hexstr>:
void u32_to_hexstr(uint8_t*str,uint32_t b){
80000304:	ff010113          	addi	sp,sp,-16
80000308:	00812423          	sw	s0,8(sp)
8000030c:	00058413          	mv	s0,a1
	u8_to_hexstr(str+0,b>>24);
80000310:	0185d593          	srli	a1,a1,0x18
void u32_to_hexstr(uint8_t*str,uint32_t b){
80000314:	00112623          	sw	ra,12(sp)
80000318:	00912223          	sw	s1,4(sp)
8000031c:	00050493          	mv	s1,a0
	u8_to_hexstr(str+0,b>>24);
80000320:	f55ff0ef          	jal	ra,80000274 <u8_to_hexstr>
	u8_to_hexstr(str+2,b>>16);
80000324:	01045593          	srli	a1,s0,0x10
80000328:	00248513          	addi	a0,s1,2
8000032c:	0ff5f593          	andi	a1,a1,255
80000330:	f45ff0ef          	jal	ra,80000274 <u8_to_hexstr>
	u8_to_hexstr(str+4,b>> 8);
80000334:	00845593          	srli	a1,s0,0x8
80000338:	00448513          	addi	a0,s1,4
8000033c:	0ff5f593          	andi	a1,a1,255
80000340:	f35ff0ef          	jal	ra,80000274 <u8_to_hexstr>
	u8_to_hexstr(str+6,b);
80000344:	0ff47593          	andi	a1,s0,255
}
80000348:	00812403          	lw	s0,8(sp)
8000034c:	00c12083          	lw	ra,12(sp)
	u8_to_hexstr(str+6,b);
80000350:	00648513          	addi	a0,s1,6
}
80000354:	00412483          	lw	s1,4(sp)
80000358:	01010113          	addi	sp,sp,16
	u8_to_hexstr(str+6,b);
8000035c:	f19ff06f          	j	80000274 <u8_to_hexstr>

80000360 <benchmark>:
void benchmark(void (*fun_ptr)(void)){
80000360:	fd010113          	addi	sp,sp,-48
80000364:	02912223          	sw	s1,36(sp)
80000368:	01312e23          	sw	s3,28(sp)
8000036c:	01412c23          	sw	s4,24(sp)
80000370:	01512a23          	sw	s5,20(sp)
80000374:	01612823          	sw	s6,16(sp)
80000378:	01712623          	sw	s7,12(sp)
8000037c:	02112623          	sw	ra,44(sp)
80000380:	02812423          	sw	s0,40(sp)
80000384:	03212023          	sw	s2,32(sp)
80000388:	01812423          	sw	s8,8(sp)
8000038c:	00050a93          	mv	s5,a0
80000390:	01000493          	li	s1,16
		TIMER_A->VALUE=0;
80000394:	f0020b37          	lui	s6,0xf0020
		if(exec_time>max_time) max_time = exec_time;
80000398:	80001a37          	lui	s4,0x80001
		TIMER_A->VALUE=0;
8000039c:	040b2423          	sw	zero,72(s6) # f0020048 <__global_pointer$+0x7001e378>
		uint32_t start = TIMER_A->VALUE;
800003a0:	048b2903          	lw	s2,72(s6)
		uint32_t end = TIMER_A->VALUE;
800003a4:	048b2783          	lw	a5,72(s6)
		memset(io,0,sizeof(io));
800003a8:	06000613          	li	a2,96
800003ac:	00000593          	li	a1,0
800003b0:	81818513          	addi	a0,gp,-2024 # 800014e8 <io>
		const uint32_t overhead=end-start;
800003b4:	41278933          	sub	s2,a5,s2
		memset(io,0,sizeof(io));
800003b8:	e7dff0ef          	jal	ra,80000234 <memset>
		TIMER_A->VALUE=0;
800003bc:	040b2423          	sw	zero,72(s6)
		start = TIMER_A->VALUE;
800003c0:	048b2c03          	lw	s8,72(s6)
		fun_ptr();
800003c4:	000a80e7          	jalr	s5
		end = TIMER_A->VALUE;
800003c8:	048b2783          	lw	a5,72(s6)
		if(exec_time<min_time) min_time = exec_time;
800003cc:	8081a703          	lw	a4,-2040(gp) # 800014d8 <min_time>
		uint32_t exec_time = (end-start)-overhead;
800003d0:	418787b3          	sub	a5,a5,s8
800003d4:	412787b3          	sub	a5,a5,s2
		if(exec_time<min_time) min_time = exec_time;
800003d8:	00e7f463          	bleu	a4,a5,800003e0 <benchmark+0x80>
800003dc:	80f1a423          	sw	a5,-2040(gp) # 800014d8 <min_time>
		if(exec_time>max_time) max_time = exec_time;
800003e0:	4e0a2703          	lw	a4,1248(s4) # 800014e0 <__global_pointer$+0xfffff810>
800003e4:	00f77463          	bleu	a5,a4,800003ec <benchmark+0x8c>
800003e8:	4efa2023          	sw	a5,1248(s4)
800003ec:	fff48493          	addi	s1,s1,-1
	for(unsigned int i = 0;i<16;i++){
800003f0:	fa0496e3          	bnez	s1,8000039c <benchmark+0x3c>
}
800003f4:	02c12083          	lw	ra,44(sp)
800003f8:	02812403          	lw	s0,40(sp)
800003fc:	02412483          	lw	s1,36(sp)
80000400:	02012903          	lw	s2,32(sp)
80000404:	01c12983          	lw	s3,28(sp)
80000408:	01812a03          	lw	s4,24(sp)
8000040c:	01412a83          	lw	s5,20(sp)
80000410:	01012b03          	lw	s6,16(sp)
80000414:	00c12b83          	lw	s7,12(sp)
80000418:	00812c03          	lw	s8,8(sp)
8000041c:	03010113          	addi	sp,sp,48
80000420:	00008067          	ret

80000424 <test_drygascon128_g>:
    }
}

//#define DRYSPONGE_REF
#define DRYSPONGE_HW
void test_drygascon128_g(void){
80000424:	f6010113          	addi	sp,sp,-160
	const uint8_t s[]={//c r x
80000428:	800015b7          	lui	a1,0x80001
void test_drygascon128_g(void){
8000042c:	08812c23          	sw	s0,152(sp)
	const uint8_t s[]={//c r x
80000430:	04800613          	li	a2,72
80000434:	2e058413          	addi	s0,a1,736 # 800012e0 <__global_pointer$+0xfffff610>
80000438:	00010513          	mv	a0,sp
8000043c:	2e058593          	addi	a1,a1,736
void test_drygascon128_g(void){
80000440:	08112e23          	sw	ra,156(sp)
80000444:	08912a23          	sw	s1,148(sp)
	const uint8_t s[]={//c r x
80000448:	d95ff0ef          	jal	ra,800001dc <memcpy>
	0x4D,0xFF,0x6B,0xD6,0xA9,0xBA,0xE4,0x4C,0x19,0xA1,0xB5,0x6D,0xFA,0x9B,0x82,0x72,
	0xC3,0x37,0x7D,0xD6,0x7C,0xC7,0x1C,0x86,
	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
	0xA4,0x09,0x38,0x22,0x29,0x9F,0x31,0xD0,0x08,0x2E,0xFA,0x98,0xEC,0x4E,0x6C,0x89
	};
	const uint8_t expected[] = {
8000044c:	04840593          	addi	a1,s0,72
80000450:	04800613          	li	a2,72
80000454:	04810513          	addi	a0,sp,72
80000458:	d85ff0ef          	jal	ra,800001dc <memcpy>
	0x16,0x73,0xD4,0xA1,0x62,0x06,0x66,0xC2,0xAC,0x3D,0x27,0x71,0xA2,0xBD,0x48,0x04,
	0xED,0x99,0x8E,0xAB,0xD7,0x1F,0x84,0x92,
	0xCD,0xE2,0xDE,0xE0,0x23,0x53,0x45,0xCB,0xFA,0x51,0xEC,0x2C,0xE5,0x74,0x35,0x71,
	0xA4,0x09,0x38,0x22,0x29,0x9F,0x31,0xD0,0x08,0x2E,0xFA,0x98,0xEC,0x4E,0x6C,0x89
	};
	memcpy(drygascon128_state,s,sizeof(s));
8000045c:	04800613          	li	a2,72
80000460:	00010593          	mv	a1,sp
80000464:	88018513          	addi	a0,gp,-1920 # 80001550 <drygascon128_state>
80000468:	d75ff0ef          	jal	ra,800001dc <memcpy>
#ifdef DRYSPONGE_REF
	drygascon128_g_ref(drygascon128_state,7);
#else
#ifdef DRYSPONGE_HW
	drygascon128hw_set_c(DRYGASCON128,drygascon128_state32);
8000046c:	800014b7          	lui	s1,0x80001
80000470:	4d04a503          	lw	a0,1232(s1) # 800014d0 <__global_pointer$+0xfffff800>
80000474:	cd1ff0ef          	jal	ra,80000144 <drygascon128hw_set_c.constprop.6>
	drygascon128hw_set_x(DRYGASCON128,drygascon128_state32+10+4);
80000478:	4d04a503          	lw	a0,1232(s1)
    hw->X = x[0];
8000047c:	f00307b7          	lui	a5,0xf0030
80000480:	03852703          	lw	a4,56(a0)
80000484:	00e7a623          	sw	a4,12(a5) # f003000c <__global_pointer$+0x7002e33c>
    hw->X = x[1];
80000488:	03c52703          	lw	a4,60(a0)
8000048c:	00e7a623          	sw	a4,12(a5)
    hw->X = x[2];
80000490:	04052703          	lw	a4,64(a0)
80000494:	00e7a623          	sw	a4,12(a5)
    hw->X = x[3];
80000498:	04452703          	lw	a4,68(a0)
8000049c:	00e7a623          	sw	a4,12(a5)
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
800004a0:	10700713          	li	a4,263
800004a4:	00e7a023          	sw	a4,0(a5)
    return hw->CTRL & DRYGASCON128_IDLE_MASK;
800004a8:	0007a703          	lw	a4,0(a5)
    while(!drygascon128hw_idle(hw));
800004ac:	fe075ee3          	bgez	a4,800004a8 <test_drygascon128_g+0x84>
    o[0] = hw->IO;
800004b0:	0087a703          	lw	a4,8(a5)
800004b4:	02e52423          	sw	a4,40(a0)
    o[1] = hw->IO;
800004b8:	0087a703          	lw	a4,8(a5)
800004bc:	02e52623          	sw	a4,44(a0)
    o[2] = hw->IO;
800004c0:	0087a703          	lw	a4,8(a5)
800004c4:	02e52823          	sw	a4,48(a0)
    o[3] = hw->IO;
800004c8:	0087a783          	lw	a5,8(a5)
800004cc:	02f52a23          	sw	a5,52(a0)
	drygascon128hw_g(DRYGASCON128,drygascon128_state32+10,7);
	drygascon128hw_get_c(DRYGASCON128,drygascon128_state32);
800004d0:	c59ff0ef          	jal	ra,80000128 <drygascon128hw_get_c.constprop.5>
#else
	drygascon128_g(drygascon128_state,7);
#endif
#endif
	if( memcmp(drygascon128_state,expected,DRYSPONGE_CAPACITYSIZE+DRYSPONGE_BLOCKSIZE)){
800004d4:	03800613          	li	a2,56
800004d8:	04810593          	addi	a1,sp,72
800004dc:	88018513          	addi	a0,gp,-1920 # 80001550 <drygascon128_state>
800004e0:	d21ff0ef          	jal	ra,80000200 <memcmp>
800004e4:	00050463          	beqz	a0,800004ec <test_drygascon128_g+0xc8>
800004e8:	0000006f          	j	800004e8 <test_drygascon128_g+0xc4>
        while(1);
    }
}
800004ec:	09c12083          	lw	ra,156(sp)
800004f0:	09812403          	lw	s0,152(sp)
800004f4:	09412483          	lw	s1,148(sp)
800004f8:	0a010113          	addi	sp,sp,160
800004fc:	00008067          	ret

80000500 <test_drygascon128_f>:

void test_drygascon128_f(void){
80000500:	f5010113          	addi	sp,sp,-176
80000504:	0a812423          	sw	s0,168(sp)
	const uint8_t s[]={//c r x
80000508:	80001437          	lui	s0,0x80001
8000050c:	2e040413          	addi	s0,s0,736 # 800012e0 <__global_pointer$+0xfffff610>
80000510:	09040593          	addi	a1,s0,144
80000514:	04800613          	li	a2,72
80000518:	00010513          	mv	a0,sp
void test_drygascon128_f(void){
8000051c:	0a112623          	sw	ra,172(sp)
80000520:	0a912223          	sw	s1,164(sp)
80000524:	0b212023          	sw	s2,160(sp)
80000528:	09312e23          	sw	s3,156(sp)
8000052c:	09412c23          	sw	s4,152(sp)
80000530:	09512a23          	sw	s5,148(sp)
	const uint8_t s[]={//c r x
80000534:	ca9ff0ef          	jal	ra,800001dc <memcpy>
	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
	0xA4,0x09,0x38,0x22,0x29,0x9F,0x31,0xD0,0x08,0x2E,0xFA,0x98,0xEC,0x4E,0x6C,0x89,
	};
    const uint8_t in[]={0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    uint32_t ds = 0xb;
    const uint8_t expected[] = {
80000538:	04840593          	addi	a1,s0,72
8000053c:	04800613          	li	a2,72
80000540:	04810513          	addi	a0,sp,72
    const uint8_t in[]={0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
80000544:	0d842a83          	lw	s5,216(s0)
80000548:	0dc42a03          	lw	s4,220(s0)
8000054c:	0e042983          	lw	s3,224(s0)
80000550:	0e442903          	lw	s2,228(s0)
    const uint8_t expected[] = {
80000554:	c89ff0ef          	jal	ra,800001dc <memcpy>
    	0x34,0x46,0x16,0xA2,0xDC,0x4B,0x29,0xB8,0xE1,0xF7,0x5F,0x43,0xB1,0x38,0xAC,0x80,0x16,0x73,0xD4,0xA1,0x62,0x06,0x66,0xC2,0xAC,0x3D,0x27,0x71,0xA2,0xBD,0x48,0x04,0xED,0x99,0x8E,0xAB,0xD7,0x1F,0x84,0x92,
    	0xCD,0xE2,0xDE,0xE0,0x23,0x53,0x45,0xCB,0xFA,0x51,0xEC,0x2C,0xE5,0x74,0x35,0x71,
    	0xA4,0x09,0x38,0x22,0x29,0x9F,0x31,0xD0,0x08,0x2E,0xFA,0x98,0xEC,0x4E,0x6C,0x89
    	};
	memcpy(drygascon128_state,s,sizeof(s));
80000558:	04800613          	li	a2,72
8000055c:	00010593          	mv	a1,sp
80000560:	88018513          	addi	a0,gp,-1920 # 80001550 <drygascon128_state>
80000564:	c79ff0ef          	jal	ra,800001dc <memcpy>
	memcpy(ctx.x,drygascon128_state+DRYSPONGE_CAPACITYSIZE64+DRYSPONGE_BLOCKSIZE64,16);
	DRYSPONGE_f(&ctx,in);
	memcpy(drygascon128_state,ctx.c,DRYSPONGE_CAPACITYSIZE);
#else
#ifdef DRYSPONGE_HW
	drygascon128hw_set_c(DRYGASCON128,drygascon128_state32);
80000568:	800014b7          	lui	s1,0x80001
8000056c:	4d04a503          	lw	a0,1232(s1) # 800014d0 <__global_pointer$+0xfffff800>
80000570:	bd5ff0ef          	jal	ra,80000144 <drygascon128hw_set_c.constprop.6>
	drygascon128hw_set_x(DRYGASCON128,drygascon128_state32+10+4);
80000574:	4d04a503          	lw	a0,1232(s1)
    hw->X = x[0];
80000578:	f00307b7          	lui	a5,0xf0030
8000057c:	03852703          	lw	a4,56(a0)
80000580:	00e7a623          	sw	a4,12(a5) # f003000c <__global_pointer$+0x7002e33c>
    hw->X = x[1];
80000584:	03c52703          	lw	a4,60(a0)
80000588:	00e7a623          	sw	a4,12(a5)
    hw->X = x[2];
8000058c:	04052703          	lw	a4,64(a0)
80000590:	00e7a623          	sw	a4,12(a5)
    hw->X = x[3];
80000594:	04452703          	lw	a4,68(a0)
80000598:	00e7a623          	sw	a4,12(a5)
    hw->IO = i[0];
8000059c:	02852703          	lw	a4,40(a0)
800005a0:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[1];
800005a4:	02c52703          	lw	a4,44(a0)
800005a8:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[2];
800005ac:	03052703          	lw	a4,48(a0)
800005b0:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[3];
800005b4:	03452703          	lw	a4,52(a0)
800005b8:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[0];
800005bc:	0157a423          	sw	s5,8(a5)
    hw->IO = i[1];
800005c0:	0147a423          	sw	s4,8(a5)
    hw->IO = i[2];
800005c4:	0137a423          	sw	s3,8(a5)
    hw->IO = i[3];
800005c8:	0127a423          	sw	s2,8(a5)
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
800005cc:	1b700713          	li	a4,439
800005d0:	00e7a023          	sw	a4,0(a5)
    return hw->CTRL & DRYGASCON128_IDLE_MASK;
800005d4:	0007a703          	lw	a4,0(a5)
    while(!drygascon128hw_idle(hw));
800005d8:	fe075ee3          	bgez	a4,800005d4 <test_drygascon128_f+0xd4>
    o[0] = hw->IO;
800005dc:	0087a703          	lw	a4,8(a5)
800005e0:	02e52423          	sw	a4,40(a0)
    o[1] = hw->IO;
800005e4:	0087a703          	lw	a4,8(a5)
800005e8:	02e52623          	sw	a4,44(a0)
    o[2] = hw->IO;
800005ec:	0087a703          	lw	a4,8(a5)
800005f0:	02e52823          	sw	a4,48(a0)
    o[3] = hw->IO;
800005f4:	0087a783          	lw	a5,8(a5)
800005f8:	02f52a23          	sw	a5,52(a0)
	drygascon128hw_set_io(DRYGASCON128,drygascon128_state32+10);
	drygascon128hw_f(DRYGASCON128,drygascon128_state32+10,(const uint32_t*const)in,ds,7);
	drygascon128hw_get_c(DRYGASCON128,drygascon128_state32);
800005fc:	b2dff0ef          	jal	ra,80000128 <drygascon128hw_get_c.constprop.5>
#else
	drygascon128_f(drygascon128_state,(const uint32_t*const)in,ds,7);
#endif
#endif
	if( memcmp(drygascon128_state,expected,DRYSPONGE_CAPACITYSIZE)){
80000600:	02800613          	li	a2,40
80000604:	04810593          	addi	a1,sp,72
80000608:	88018513          	addi	a0,gp,-1920 # 80001550 <drygascon128_state>
8000060c:	bf5ff0ef          	jal	ra,80000200 <memcmp>
80000610:	00050463          	beqz	a0,80000618 <test_drygascon128_f+0x118>
80000614:	0000006f          	j	80000614 <test_drygascon128_f+0x114>
        while(1);
    }
}
80000618:	0ac12083          	lw	ra,172(sp)
8000061c:	0a812403          	lw	s0,168(sp)
80000620:	0a412483          	lw	s1,164(sp)
80000624:	0a012903          	lw	s2,160(sp)
80000628:	09c12983          	lw	s3,156(sp)
8000062c:	09812a03          	lw	s4,152(sp)
80000630:	09412a83          	lw	s5,148(sp)
80000634:	0b010113          	addi	sp,sp,176
80000638:	00008067          	ret

8000063c <irqCallback>:
		TIMER_INTERRUPT->PENDINGS = 1;
	}
	while(UART->STATUS & (1 << 9)){ //UART RX interrupt
		UART->DATA = (UART->DATA) & 0xFF;
	}*/
}
8000063c:	00008067          	ret

80000640 <drygascon128_g>:

.section .text
.type	drygascon128_g, %function
drygascon128_g:
//save context
    addi    sp,sp,-32
80000640:	fe010113          	addi	sp,sp,-32
	sw		s0, 0(sp)
80000644:	00812023          	sw	s0,0(sp)
	sw		s1, 4(sp)
80000648:	00912223          	sw	s1,4(sp)
	sw		gp, 8(sp)
8000064c:	00312423          	sw	gp,8(sp)
	sw		tp,12(sp)
80000650:	00412623          	sw	tp,12(sp)
	sw 		ra,16(sp)
80000654:	00112823          	sw	ra,16(sp)
//set stack frame
	sw		a0,G_STATE(sp)
80000658:	00a12a23          	sw	a0,20(sp)
	//round=rounds-1
	addi	x1,a1,-1
8000065c:	fff58093          	addi	ra,a1,-1
	sw		x1,G_ROUND(sp)
80000660:	00112e23          	sw	ra,28(sp)
	//base = round_cst+12-round
    la      x14,round_cst
80000664:	00001717          	auipc	a4,0x1
80000668:	e5c70713          	addi	a4,a4,-420 # 800014c0 <round_cst>
    addi	x14,x14,12
8000066c:	00c70713          	addi	a4,a4,12
    sub		x3,x14,a1
80000670:	40b701b3          	sub	gp,a4,a1
	sw		x3,G_ROUNDS(sp)
80000674:	00312c23          	sw	gp,24(sp)
//load state
	mv		x15,a0
80000678:	00050793          	mv	a5,a0
	lw		x4, 0(x15)
8000067c:	0007a203          	lw	tp,0(a5)
	lw		x5, 4(x15)
80000680:	0047a283          	lw	t0,4(a5)
	lw		x6, 8(x15)
80000684:	0087a303          	lw	t1,8(a5)
	lw		x7,12(x15)
80000688:	00c7a383          	lw	t2,12(a5)
	lw		x8,16(x15)
8000068c:	0107a403          	lw	s0,16(a5)
	lw		x9,20(x15)
80000690:	0147a483          	lw	s1,20(a5)
	lw		x10,24(x15)
80000694:	0187a503          	lw	a0,24(a5)
	lw		x11,28(x15)
80000698:	01c7a583          	lw	a1,28(a5)
	lw		x12,32(x15)
8000069c:	0207a603          	lw	a2,32(a5)
	lw		x13,36(x15)
800006a0:	0247a683          	lw	a3,36(a5)

800006a4 <drygascon128_g_entry_from_f>:

drygascon128_g_entry_from_f:
//init R
	sw		zero,R32_0(x15)
800006a4:	0207a423          	sw	zero,40(a5)
	sw		zero,R32_1(x15)
800006a8:	0207a623          	sw	zero,44(a5)
	sw		zero,R32_2(x15)
800006ac:	0207a823          	sw	zero,48(a5)
	sw		zero,R32_3(x15)
800006b0:	0207aa23          	sw	zero,52(a5)

800006b4 <drygascon128_g_main_loop>:
	//assume r1>0 at entry
drygascon128_g_main_loop:
    //x15: state pointer
    //x3: base for round constants
    //x1: round, counting from rounds-1 to 0
    add     x3,x3,x1
800006b4:	001181b3          	add	gp,gp,ra
    lbu   	x3,0(x3)
800006b8:	0001c183          	lbu	gp,0(gp) # 80001cd0 <__global_pointer$>
        // addition of round constant
    xor	    x8,x8,x3
800006bc:	00344433          	xor	s0,s0,gp

    // substitution layer, lower half
	xor 	x4,x4,x12
800006c0:	00c24233          	xor	tp,tp,a2
    xor 	x12,x12,x10
800006c4:	00a64633          	xor	a2,a2,a0
    xor 	x8,x8,x6
800006c8:	00644433          	xor	s0,s0,t1
	not 	x1,x4
800006cc:	fff24093          	not	ra,tp
    not 	x3,x10
800006d0:	fff54193          	not	gp,a0
    not 	x14,x12
800006d4:	fff64713          	not	a4,a2
	and 	x1,x1,x6
800006d8:	0060f0b3          	and	ra,ra,t1
    and 	x3,x3,x12
800006dc:	00c1f1b3          	and	gp,gp,a2
    xor 	x12,x12,x1
800006e0:	00164633          	xor	a2,a2,ra
    and 	x14,x14,x4
800006e4:	00477733          	and	a4,a4,tp
    not 	x1,x8
800006e8:	fff44093          	not	ra,s0
    and 	x1,x1,x10
800006ec:	00a0f0b3          	and	ra,ra,a0
    xor 	x10,x10,x14
800006f0:	00e54533          	xor	a0,a0,a4
    not 	x14,x6
800006f4:	fff34713          	not	a4,t1
    and 	x14,x14,x8
800006f8:	00877733          	and	a4,a4,s0
    xor 	x8,x8,x3
800006fc:	00344433          	xor	s0,s0,gp
    xor 	x10,x10,x8
80000700:	00854533          	xor	a0,a0,s0
    not 	x8,x8
80000704:	fff44413          	not	s0,s0
    xor 	x4,x4,x14
80000708:	00e24233          	xor	tp,tp,a4
    xor 	x6,x6,x1
8000070c:	00134333          	xor	t1,t1,ra
	xor 	x6,x6,x4
80000710:	00434333          	xor	t1,t1,tp
    xor 	x4,x4,x12
80000714:	00c24233          	xor	tp,tp,a2

    // substitution layer, upper half
	xor 	x5,x5,x13
80000718:	00d2c2b3          	xor	t0,t0,a3
    xor 	x13,x13,x11
8000071c:	00b6c6b3          	xor	a3,a3,a1
    xor 	x9,x9,x7
80000720:	0074c4b3          	xor	s1,s1,t2
	not 	x1,x5
80000724:	fff2c093          	not	ra,t0
    not 	x3,x11
80000728:	fff5c193          	not	gp,a1
    not 	x14,x13
8000072c:	fff6c713          	not	a4,a3
	and 	x1,x1,x7
80000730:	0070f0b3          	and	ra,ra,t2
    and 	x3,x3,x13
80000734:	00d1f1b3          	and	gp,gp,a3
    xor 	x13,x13,x1
80000738:	0016c6b3          	xor	a3,a3,ra
    and 	x14,x14,x5
8000073c:	00577733          	and	a4,a4,t0
    not 	x1,x9
80000740:	fff4c093          	not	ra,s1
    and 	x1,x1,x11
80000744:	00b0f0b3          	and	ra,ra,a1
    xor 	x11,x11,x14
80000748:	00e5c5b3          	xor	a1,a1,a4
    not 	x14,x7
8000074c:	fff3c713          	not	a4,t2
    and 	x14,x14,x9
80000750:	00977733          	and	a4,a4,s1
    xor 	x9,x9,x3
80000754:	0034c4b3          	xor	s1,s1,gp
    xor 	x11,x11,x9
80000758:	0095c5b3          	xor	a1,a1,s1
    not 	x9,x9
8000075c:	fff4c493          	not	s1,s1
    xor 	x5,x5,x14
80000760:	00e2c2b3          	xor	t0,t0,a4
    xor 	x7,x7,x1
80000764:	0013c3b3          	xor	t2,t2,ra
	xor 	x7,x7,x5
80000768:	0053c3b3          	xor	t2,t2,t0
    xor 	x5,x5,x13
8000076c:	00d2c2b3          	xor	t0,t0,a3

    // linear diffusion layer
    //c4 ^= gascon_rotr64_interleaved(c4, 40) ^ gascon_rotr64_interleaved(c4, 7);
    //c4 high part
    mv      x3,x13
80000770:	00068193          	mv	gp,a3
    slli    x1,x3,12
80000774:	00c19093          	slli	ra,gp,0xc
    srli    x3,x3,20
80000778:	0141d193          	srli	gp,gp,0x14
    or      x3,x3,x1
8000077c:	0011e1b3          	or	gp,gp,ra
    xor     x13,x13,x3
80000780:	0036c6b3          	xor	a3,a3,gp
    mv      x1,x12
80000784:	00060093          	mv	ra,a2
    slli    x14,x1,28
80000788:	01c09713          	slli	a4,ra,0x1c
    srli    x1,x1,4
8000078c:	0040d093          	srli	ra,ra,0x4
    or      x1,x1,x14
80000790:	00e0e0b3          	or	ra,ra,a4
    xor     x13,x13,x1
80000794:	0016c6b3          	xor	a3,a3,ra
    //c4 low part
    mv      x1,x12
80000798:	00060093          	mv	ra,a2
    slli    x14,x3,17
8000079c:	01119713          	slli	a4,gp,0x11
    srli    x3,x3,(32-20+3)%32
800007a0:	00f1d193          	srli	gp,gp,0xf
    or      x3,x3,x14
800007a4:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x12
800007a8:	00c1c1b3          	xor	gp,gp,a2
    slli    x14,x1,12
800007ac:	00c09713          	slli	a4,ra,0xc
    srli    x1,x1,20
800007b0:	0140d093          	srli	ra,ra,0x14
    or      x1,x1,x14
800007b4:	00e0e0b3          	or	ra,ra,a4
    xor     x12,x3,x1
800007b8:	0011c633          	xor	a2,gp,ra

    //c0 ^= gascon_rotr64_interleaved(c0, 28) ^ gascon_rotr64_interleaved(c0, 19);
    //c0 high part
    mv      x3,x5
800007bc:	00028193          	mv	gp,t0
    slli    x1,x3,18
800007c0:	01219093          	slli	ra,gp,0x12
    srli    x3,x3,14
800007c4:	00e1d193          	srli	gp,gp,0xe
    or      x3,x3,x1
800007c8:	0011e1b3          	or	gp,gp,ra
    xor     x5,x5,x3
800007cc:	0032c2b3          	xor	t0,t0,gp
    mv      x1,x4
800007d0:	00020093          	mv	ra,tp
    slli    x14,x1,22
800007d4:	01609713          	slli	a4,ra,0x16
    srli    x1,x1,10
800007d8:	00a0d093          	srli	ra,ra,0xa
    or      x1,x1,x14
800007dc:	00e0e0b3          	or	ra,ra,a4
    xor     x5,x5,x1
800007e0:	0012c2b3          	xor	t0,t0,ra
    lw      x14,R32_1(x15)
800007e4:	02c7a703          	lw	a4,44(a5)
    xor     x14,x14,x5
800007e8:	00574733          	xor	a4,a4,t0
    sw      x14,R32_1(x15)
800007ec:	02e7a623          	sw	a4,44(a5)
    //c0 low part
    mv      x1,x4
800007f0:	00020093          	mv	ra,tp
    slli    x14,x3,5
800007f4:	00519713          	slli	a4,gp,0x5
    srli    x3,x3,(32-14+9)%32
800007f8:	01b1d193          	srli	gp,gp,0x1b
    or      x3,x3,x14
800007fc:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x4
80000800:	0041c1b3          	xor	gp,gp,tp
    slli    x14,x1,18
80000804:	01209713          	slli	a4,ra,0x12
    srli    x1,x1,14
80000808:	00e0d093          	srli	ra,ra,0xe
    or      x1,x1,x14
8000080c:	00e0e0b3          	or	ra,ra,a4
    xor     x4,x3,x1
80000810:	0011c233          	xor	tp,gp,ra
    lw      x14,R32_0(x15)
80000814:	0287a703          	lw	a4,40(a5)
    xor     x14,x14,x4
80000818:	00474733          	xor	a4,a4,tp
    sw      x14,R32_0(x15)
8000081c:	02e7a423          	sw	a4,40(a5)

    //c1 ^= gascon_rotr64_interleaved(c1, 38) ^ gascon_rotr64_interleaved(c1, 61);
    //c1 high part
    mv      x3,x7
80000820:	00038193          	mv	gp,t2
    slli    x1,x3,13
80000824:	00d19093          	slli	ra,gp,0xd
    srli    x3,x3,19
80000828:	0131d193          	srli	gp,gp,0x13
    or      x3,x3,x1
8000082c:	0011e1b3          	or	gp,gp,ra
    xor     x7,x7,x3
80000830:	0033c3b3          	xor	t2,t2,gp
    mv      x1,x6
80000834:	00030093          	mv	ra,t1
    slli    x14,x1,1
80000838:	00109713          	slli	a4,ra,0x1
    srli    x1,x1,31
8000083c:	01f0d093          	srli	ra,ra,0x1f
    or      x1,x1,x14
80000840:	00e0e0b3          	or	ra,ra,a4
    xor     x7,x7,x1
80000844:	0013c3b3          	xor	t2,t2,ra
    lw      x14,R32_3(x15)
80000848:	0347a703          	lw	a4,52(a5)
    xor     x14,x14,x7
8000084c:	00774733          	xor	a4,a4,t2
    sw      x14,R32_3(x15)
80000850:	02e7aa23          	sw	a4,52(a5)
    //c1 low part
    mv      x1,x6
80000854:	00030093          	mv	ra,t1
    slli    x14,x3,21
80000858:	01519713          	slli	a4,gp,0x15
    srli    x3,x3,(32-19+30)%32
8000085c:	00b1d193          	srli	gp,gp,0xb
    or      x3,x3,x14
80000860:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x6
80000864:	0061c1b3          	xor	gp,gp,t1
    slli    x14,x1,13
80000868:	00d09713          	slli	a4,ra,0xd
    srli    x1,x1,19
8000086c:	0130d093          	srli	ra,ra,0x13
    or      x1,x1,x14
80000870:	00e0e0b3          	or	ra,ra,a4
    xor     x6,x3,x1
80000874:	0011c333          	xor	t1,gp,ra
    lw      x14,R32_2(x15)
80000878:	0307a703          	lw	a4,48(a5)
    xor     x14,x14,x6
8000087c:	00674733          	xor	a4,a4,t1
    sw      x14,R32_2(x15)
80000880:	02e7a823          	sw	a4,48(a5)

    //c2 ^= gascon_rotr64_interleaved(c2, 6) ^ gascon_rotr64_interleaved(c2, 1);
    //c2 high part
    mv      x3,x9
80000884:	00048193          	mv	gp,s1
    slli    x1,x3,29
80000888:	01d19093          	slli	ra,gp,0x1d
    srli    x3,x3,3
8000088c:	0031d193          	srli	gp,gp,0x3
    or      x3,x3,x1
80000890:	0011e1b3          	or	gp,gp,ra
    xor     x9,x9,x3
80000894:	0034c4b3          	xor	s1,s1,gp
    mv      x1,x8
80000898:	00040093          	mv	ra,s0
    slli    x14,x1,31
8000089c:	01f09713          	slli	a4,ra,0x1f
    srli    x1,x1,1
800008a0:	0010d093          	srli	ra,ra,0x1
    or      x1,x1,x14
800008a4:	00e0e0b3          	or	ra,ra,a4
    xor     x9,x9,x1
800008a8:	0014c4b3          	xor	s1,s1,ra
    lw      x14,R32_0(x15)
800008ac:	0287a703          	lw	a4,40(a5)
    xor     x14,x14,x9
800008b0:	00974733          	xor	a4,a4,s1
    sw      x14,R32_0(x15)
800008b4:	02e7a423          	sw	a4,40(a5)
    //c2 low part
    mv      x1,x8
800008b8:	00040093          	mv	ra,s0
    slli    x14,x3,3
800008bc:	00319713          	slli	a4,gp,0x3
    srli    x3,x3,(32-3+0)%32
800008c0:	01d1d193          	srli	gp,gp,0x1d
    or      x3,x3,x14
800008c4:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x8
800008c8:	0081c1b3          	xor	gp,gp,s0
    slli    x14,x1,29
800008cc:	01d09713          	slli	a4,ra,0x1d
    srli    x1,x1,3
800008d0:	0030d093          	srli	ra,ra,0x3
    or      x1,x1,x14
800008d4:	00e0e0b3          	or	ra,ra,a4
    xor     x8,x3,x1
800008d8:	0011c433          	xor	s0,gp,ra
    lw      x14,R32_3(x15)
800008dc:	0347a703          	lw	a4,52(a5)
    xor     x14,x14,x8
800008e0:	00874733          	xor	a4,a4,s0
    sw      x14,R32_3(x15)
800008e4:	02e7aa23          	sw	a4,52(a5)

    //c3 ^= gascon_rotr64_interleaved(c3, 10) ^ gascon_rotr64_interleaved(c3, 17);
    //c3 high part
    mv      x3,x11
800008e8:	00058193          	mv	gp,a1
    slli    x1,x3,27
800008ec:	01b19093          	slli	ra,gp,0x1b
    srli    x3,x3,5
800008f0:	0051d193          	srli	gp,gp,0x5
    or      x3,x3,x1
800008f4:	0011e1b3          	or	gp,gp,ra
    xor     x11,x11,x3
800008f8:	0035c5b3          	xor	a1,a1,gp
    mv      x1,x10
800008fc:	00050093          	mv	ra,a0
    slli    x14,x1,23
80000900:	01709713          	slli	a4,ra,0x17
    srli    x1,x1,9
80000904:	0090d093          	srli	ra,ra,0x9
    or      x1,x1,x14
80000908:	00e0e0b3          	or	ra,ra,a4
    xor     x11,x11,x1
8000090c:	0015c5b3          	xor	a1,a1,ra
    lw      x14,R32_2(x15)
80000910:	0307a703          	lw	a4,48(a5)
    xor     x14,x14,x11
80000914:	00b74733          	xor	a4,a4,a1
    sw      x14,R32_2(x15)
80000918:	02e7a823          	sw	a4,48(a5)
    //c3 low part
    mv      x1,x10
8000091c:	00050093          	mv	ra,a0
    slli    x14,x3,29
80000920:	01d19713          	slli	a4,gp,0x1d
    srli    x3,x3,(32-5+8)%32
80000924:	0031d193          	srli	gp,gp,0x3
    or      x3,x3,x14
80000928:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x10
8000092c:	00a1c1b3          	xor	gp,gp,a0
    slli    x14,x1,27
80000930:	01b09713          	slli	a4,ra,0x1b
    srli    x1,x1,5
80000934:	0050d093          	srli	ra,ra,0x5
    or      x1,x1,x14
80000938:	00e0e0b3          	or	ra,ra,a4
    xor     x10,x3,x1
8000093c:	0011c533          	xor	a0,gp,ra
    lw      x14,R32_1(x15)
80000940:	02c7a703          	lw	a4,44(a5)
    xor     x14,x14,x10
80000944:	00a74733          	xor	a4,a4,a0
    sw      x14,R32_1(x15)
80000948:	02e7a623          	sw	a4,44(a5)

    lw      x3,G_ROUNDS(sp)
8000094c:	01812183          	lw	gp,24(sp)
    lw      x1,G_ROUND(sp)
80000950:	01c12083          	lw	ra,28(sp)
    addi    x1,x1,-1
80000954:	fff08093          	addi	ra,ra,-1
    blt     x1,zero,drygascon128_g_exit
80000958:	0000c663          	bltz	ra,80000964 <drygascon128_g_exit>

    sw      x1,G_ROUND(sp)
8000095c:	00112e23          	sw	ra,28(sp)
	j    	drygascon128_g_main_loop
80000960:	d55ff06f          	j	800006b4 <drygascon128_g_main_loop>

80000964 <drygascon128_g_exit>:
drygascon128_g_exit:

//store state
    sw		x4, 0(x15)
80000964:	0047a023          	sw	tp,0(a5)
    sw		x5, 4(x15)
80000968:	0057a223          	sw	t0,4(a5)
    sw		x6, 8(x15)
8000096c:	0067a423          	sw	t1,8(a5)
    sw		x7,12(x15)
80000970:	0077a623          	sw	t2,12(a5)
    sw		x8,16(x15)
80000974:	0087a823          	sw	s0,16(a5)
    sw		x9,20(x15)
80000978:	0097aa23          	sw	s1,20(a5)
    sw		x10,24(x15)
8000097c:	00a7ac23          	sw	a0,24(a5)
    sw		x11,28(x15)
80000980:	00b7ae23          	sw	a1,28(a5)
    sw		x12,32(x15)
80000984:	02c7a023          	sw	a2,32(a5)
    sw		x13,36(x15)
80000988:	02d7a223          	sw	a3,36(a5)

//restore context
	lw		s0, 0(sp)
8000098c:	00012403          	lw	s0,0(sp)
	lw		s1, 4(sp)
80000990:	00412483          	lw	s1,4(sp)
    lw      gp, 8(sp)
80000994:	00812183          	lw	gp,8(sp)
	lw		tp,12(sp)
80000998:	00c12203          	lw	tp,12(sp)
	lw 		ra,16(sp)
8000099c:	01012083          	lw	ra,16(sp)
    addi    sp,sp,32
800009a0:	02010113          	addi	sp,sp,32
    ret
800009a4:	00008067          	ret

800009a8 <drygascon128_f>:
    //a0:state c r x
    //a1:input -> shall be 32 bit aligned
    //a2:ds
    //a3:rounds
//save context
    addi    sp,sp,-32
800009a8:	fe010113          	addi	sp,sp,-32
	sw		s0, 0(sp)
800009ac:	00812023          	sw	s0,0(sp)
	sw		s1, 4(sp)
800009b0:	00912223          	sw	s1,4(sp)
	sw		gp, 8(sp)
800009b4:	00312423          	sw	gp,8(sp)
	sw		tp,12(sp)
800009b8:	00412623          	sw	tp,12(sp)
	sw 		ra,16(sp)
800009bc:	00112823          	sw	ra,16(sp)
//set stack frame
	sw		a0,G_STATE(sp)
800009c0:	00a12a23          	sw	a0,20(sp)
    sw      a3,G_ROUNDS(sp)
800009c4:	00d12c23          	sw	a3,24(sp)
    addi    sp,sp,-MIX_STACK_SIZE
800009c8:	fe410113          	addi	sp,sp,-28

    li      x1,0x3FF
800009cc:	3ff00093          	li	ra,1023

    lw      x15, 0(a1)
800009d0:	0005a783          	lw	a5,0(a1)
    and     x3,x15,x1
800009d4:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+26(sp)
800009d8:	00311d23          	sh	gp,26(sp)

    srli    x15,x15,10
800009dc:	00a7d793          	srli	a5,a5,0xa
    and     x3,x15,x1
800009e0:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+24(sp)
800009e4:	00311c23          	sh	gp,24(sp)

    srli    x15,x15,10
800009e8:	00a7d793          	srli	a5,a5,0xa
    and     x3,x15,x1
800009ec:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+22(sp)
800009f0:	00311b23          	sh	gp,22(sp)

    srli    x3,x15,10
800009f4:	00a7d193          	srli	gp,a5,0xa
    lw      x15, 4(a1)
800009f8:	0045a783          	lw	a5,4(a1)
    slli    x14,x15,2
800009fc:	00279713          	slli	a4,a5,0x2
    srli    x15,x15,8
80000a00:	0087d793          	srli	a5,a5,0x8
    or      x14,x14,x3
80000a04:	00376733          	or	a4,a4,gp
    and     x3,x14,x1
80000a08:	001771b3          	and	gp,a4,ra
    sh      x3,MIX_BUF+20(sp)
80000a0c:	00311a23          	sh	gp,20(sp)
    and     x3,x15,x1
80000a10:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+18(sp)
80000a14:	00311923          	sh	gp,18(sp)

    srli    x15,x15,10
80000a18:	00a7d793          	srli	a5,a5,0xa
    and     x3,x15,x1
80000a1c:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+16(sp)
80000a20:	00311823          	sh	gp,16(sp)

    srli    x3,x15,10
80000a24:	00a7d193          	srli	gp,a5,0xa
    lw      x15, 8(a1)
80000a28:	0085a783          	lw	a5,8(a1)
    slli    x14,x15,4
80000a2c:	00479713          	slli	a4,a5,0x4
    srli    x15,x15,6
80000a30:	0067d793          	srli	a5,a5,0x6
    or      x14,x14,x3
80000a34:	00376733          	or	a4,a4,gp
    and     x3,x14,x1
80000a38:	001771b3          	and	gp,a4,ra
    sh      x3,MIX_BUF+14(sp)
80000a3c:	00311723          	sh	gp,14(sp)
    and     x3,x15,x1
80000a40:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+12(sp)
80000a44:	00311623          	sh	gp,12(sp)

    srli    x15,x15,10
80000a48:	00a7d793          	srli	a5,a5,0xa
    and     x3,x15,x1
80000a4c:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+10(sp)
80000a50:	00311523          	sh	gp,10(sp)

    srli    x3,x15,10
80000a54:	00a7d193          	srli	gp,a5,0xa
    lw      x15, 12(a1)
80000a58:	00c5a783          	lw	a5,12(a1)
    slli    x14,x15,6
80000a5c:	00679713          	slli	a4,a5,0x6
    srli    x15,x15,4
80000a60:	0047d793          	srli	a5,a5,0x4
    or      x14,x14,x3
80000a64:	00376733          	or	a4,a4,gp
    and     x3,x14,x1
80000a68:	001771b3          	and	gp,a4,ra
    sh      x3,MIX_BUF+8(sp)
80000a6c:	00311423          	sh	gp,8(sp)
    and     x3,x15,x1
80000a70:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+6(sp)
80000a74:	00311323          	sh	gp,6(sp)

    srli    x15,x15,10
80000a78:	00a7d793          	srli	a5,a5,0xa
    and     x3,x15,x1
80000a7c:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+4(sp)
80000a80:	00311223          	sh	gp,4(sp)

    srli    x3,x15,10
80000a84:	00a7d193          	srli	gp,a5,0xa
    mv      x15, a2
80000a88:	00060793          	mv	a5,a2
    slli    x14,x15,8
80000a8c:	00879713          	slli	a4,a5,0x8
    srli    x15,x15,2
80000a90:	0027d793          	srli	a5,a5,0x2
    or      x14,x14,x3
80000a94:	00376733          	or	a4,a4,gp
    and     x3,x14,x1
80000a98:	001771b3          	and	gp,a4,ra
    sh      x3,MIX_BUF+2(sp)
80000a9c:	00311123          	sh	gp,2(sp)
    and     x3,x15,x1
80000aa0:	0017f1b3          	and	gp,a5,ra
    sh      x3,MIX_BUF+0(sp)
80000aa4:	00311023          	sh	gp,0(sp)

//load state
	mv		x15,a0
80000aa8:	00050793          	mv	a5,a0
	lw		x4, 0(x15)
80000aac:	0007a203          	lw	tp,0(a5)
	lw		x5, 4(x15)
80000ab0:	0047a283          	lw	t0,4(a5)
	lw		x6, 8(x15)
80000ab4:	0087a303          	lw	t1,8(a5)
	lw		x7,12(x15)
80000ab8:	00c7a383          	lw	t2,12(a5)
	lw		x8,16(x15)
80000abc:	0107a403          	lw	s0,16(a5)
	lw		x9,20(x15)
80000ac0:	0147a483          	lw	s1,20(a5)
	lw		x10,24(x15)
80000ac4:	0187a503          	lw	a0,24(a5)
	lw		x11,28(x15)
80000ac8:	01c7a583          	lw	a1,28(a5)
	lw		x12,32(x15)
80000acc:	0207a603          	lw	a2,32(a5)
	lw		x13,36(x15)
80000ad0:	0247a683          	lw	a3,36(a5)

    li      x1,26
80000ad4:	01a00093          	li	ra,26
    sw      x1,F_ROUND(sp)
80000ad8:	02112c23          	sw	ra,56(sp)

80000adc <drygascon128_f_mix128_main_loop>:
drygascon128_f_mix128_main_loop:
    //x1 is the offset in stack to the 10 bits input
    add     x1,x1,sp
80000adc:	002080b3          	add	ra,ra,sp
    lh      x1,0(x1)
80000ae0:	00009083          	lh	ra,0(ra)
    //x1 is the 10 bits input

    //x15 is the pointer to the state C
    //x14 is the pointer to X
    addi    x14,x15,40+16
80000ae4:	03878713          	addi	a4,a5,56

    andi    x3,x1,0x3
80000ae8:	0030f193          	andi	gp,ra,3
    slli    x3,x3,2
80000aec:	00219193          	slli	gp,gp,0x2
    add     x3,x3,x14
80000af0:	00e181b3          	add	gp,gp,a4
    lw      x3,0(x3)
80000af4:	0001a183          	lw	gp,0(gp) # 80001cd0 <__global_pointer$>
    xor     x4,x4,x3
80000af8:	00324233          	xor	tp,tp,gp

    andi    x3,x1,0xc
80000afc:	00c0f193          	andi	gp,ra,12
    add     x3,x3,x14
80000b00:	00e181b3          	add	gp,gp,a4
    lw      x3,0(x3)
80000b04:	0001a183          	lw	gp,0(gp) # 80001cd0 <__global_pointer$>
    xor     x6,x6,x3
80000b08:	00334333          	xor	t1,t1,gp

    srli    x1,x1,2
80000b0c:	0020d093          	srli	ra,ra,0x2
    andi    x3,x1,0xc
80000b10:	00c0f193          	andi	gp,ra,12
    add     x3,x3,x14
80000b14:	00e181b3          	add	gp,gp,a4
    lw      x3,0(x3)
80000b18:	0001a183          	lw	gp,0(gp) # 80001cd0 <__global_pointer$>
    xor     x8,x8,x3
80000b1c:	00344433          	xor	s0,s0,gp

    srli    x1,x1,2
80000b20:	0020d093          	srli	ra,ra,0x2
    andi    x3,x1,0xc
80000b24:	00c0f193          	andi	gp,ra,12
    add     x3,x3,x14
80000b28:	00e181b3          	add	gp,gp,a4
    lw      x3,0(x3)
80000b2c:	0001a183          	lw	gp,0(gp) # 80001cd0 <__global_pointer$>
    xor     x10,x10,x3
80000b30:	00354533          	xor	a0,a0,gp

    srli    x1,x1,2
80000b34:	0020d093          	srli	ra,ra,0x2
    andi    x3,x1,0xc
80000b38:	00c0f193          	andi	gp,ra,12
    add     x3,x3,x14
80000b3c:	00e181b3          	add	gp,gp,a4
    lw      x3,0(x3)
80000b40:	0001a183          	lw	gp,0(gp) # 80001cd0 <__global_pointer$>
    xor     x12,x12,x3
80000b44:	00364633          	xor	a2,a2,gp

    lw      x1,F_ROUND(sp)
80000b48:	03812083          	lw	ra,56(sp)
    addi    x1,x1,-2
80000b4c:	ffe08093          	addi	ra,ra,-2
    blt     x1,zero,drygascon128_f_mix128_exit
80000b50:	2400c263          	bltz	ra,80000d94 <drygascon128_f_mix128_exit>

80000b54 <drygascon128_f_mix128_coreround>:
drygascon128_f_mix128_coreround:
    sw      x1,F_ROUND(sp)
80000b54:	02112c23          	sw	ra,56(sp)
    li      x3,0xf0
80000b58:	0f000193          	li	gp,240
        // addition of round constant
    xor	    x8,x8,x3
80000b5c:	00344433          	xor	s0,s0,gp

    // substitution layer, lower half
	xor 	x4,x4,x12
80000b60:	00c24233          	xor	tp,tp,a2
    xor 	x12,x12,x10
80000b64:	00a64633          	xor	a2,a2,a0
    xor 	x8,x8,x6
80000b68:	00644433          	xor	s0,s0,t1
	not 	x1,x4
80000b6c:	fff24093          	not	ra,tp
    not 	x3,x10
80000b70:	fff54193          	not	gp,a0
    not 	x14,x12
80000b74:	fff64713          	not	a4,a2
	and 	x1,x1,x6
80000b78:	0060f0b3          	and	ra,ra,t1
    and 	x3,x3,x12
80000b7c:	00c1f1b3          	and	gp,gp,a2
    xor 	x12,x12,x1
80000b80:	00164633          	xor	a2,a2,ra
    and 	x14,x14,x4
80000b84:	00477733          	and	a4,a4,tp
    not 	x1,x8
80000b88:	fff44093          	not	ra,s0
    and 	x1,x1,x10
80000b8c:	00a0f0b3          	and	ra,ra,a0
    xor 	x10,x10,x14
80000b90:	00e54533          	xor	a0,a0,a4
    not 	x14,x6
80000b94:	fff34713          	not	a4,t1
    and 	x14,x14,x8
80000b98:	00877733          	and	a4,a4,s0
    xor 	x8,x8,x3
80000b9c:	00344433          	xor	s0,s0,gp
    xor 	x10,x10,x8
80000ba0:	00854533          	xor	a0,a0,s0
    not 	x8,x8
80000ba4:	fff44413          	not	s0,s0
    xor 	x4,x4,x14
80000ba8:	00e24233          	xor	tp,tp,a4
    xor 	x6,x6,x1
80000bac:	00134333          	xor	t1,t1,ra
	xor 	x6,x6,x4
80000bb0:	00434333          	xor	t1,t1,tp
    xor 	x4,x4,x12
80000bb4:	00c24233          	xor	tp,tp,a2

    // substitution layer, upper half
	xor 	x5,x5,x13
80000bb8:	00d2c2b3          	xor	t0,t0,a3
    xor 	x13,x13,x11
80000bbc:	00b6c6b3          	xor	a3,a3,a1
    xor 	x9,x9,x7
80000bc0:	0074c4b3          	xor	s1,s1,t2
	not 	x1,x5
80000bc4:	fff2c093          	not	ra,t0
    not 	x3,x11
80000bc8:	fff5c193          	not	gp,a1
    not 	x14,x13
80000bcc:	fff6c713          	not	a4,a3
	and 	x1,x1,x7
80000bd0:	0070f0b3          	and	ra,ra,t2
    and 	x3,x3,x13
80000bd4:	00d1f1b3          	and	gp,gp,a3
    xor 	x13,x13,x1
80000bd8:	0016c6b3          	xor	a3,a3,ra
    and 	x14,x14,x5
80000bdc:	00577733          	and	a4,a4,t0
    not 	x1,x9
80000be0:	fff4c093          	not	ra,s1
    and 	x1,x1,x11
80000be4:	00b0f0b3          	and	ra,ra,a1
    xor 	x11,x11,x14
80000be8:	00e5c5b3          	xor	a1,a1,a4
    not 	x14,x7
80000bec:	fff3c713          	not	a4,t2
    and 	x14,x14,x9
80000bf0:	00977733          	and	a4,a4,s1
    xor 	x9,x9,x3
80000bf4:	0034c4b3          	xor	s1,s1,gp
    xor 	x11,x11,x9
80000bf8:	0095c5b3          	xor	a1,a1,s1
    not 	x9,x9
80000bfc:	fff4c493          	not	s1,s1
    xor 	x5,x5,x14
80000c00:	00e2c2b3          	xor	t0,t0,a4
    xor 	x7,x7,x1
80000c04:	0013c3b3          	xor	t2,t2,ra
	xor 	x7,x7,x5
80000c08:	0053c3b3          	xor	t2,t2,t0
    xor 	x5,x5,x13
80000c0c:	00d2c2b3          	xor	t0,t0,a3

    // linear diffusion layer
    //c4 ^= gascon_rotr64_interleaved(c4, 40) ^ gascon_rotr64_interleaved(c4, 7);
    //c4 high part
    mv      x3,x13
80000c10:	00068193          	mv	gp,a3
    slli    x1,x3,12
80000c14:	00c19093          	slli	ra,gp,0xc
    srli    x3,x3,20
80000c18:	0141d193          	srli	gp,gp,0x14
    or      x3,x3,x1
80000c1c:	0011e1b3          	or	gp,gp,ra
    xor     x13,x13,x3
80000c20:	0036c6b3          	xor	a3,a3,gp
    mv      x1,x12
80000c24:	00060093          	mv	ra,a2
    slli    x14,x1,28
80000c28:	01c09713          	slli	a4,ra,0x1c
    srli    x1,x1,4
80000c2c:	0040d093          	srli	ra,ra,0x4
    or      x1,x1,x14
80000c30:	00e0e0b3          	or	ra,ra,a4
    xor     x13,x13,x1
80000c34:	0016c6b3          	xor	a3,a3,ra
    //c4 low part
    mv      x1,x12
80000c38:	00060093          	mv	ra,a2
    slli    x14,x3,17
80000c3c:	01119713          	slli	a4,gp,0x11
    srli    x3,x3,(32-20+3)%32
80000c40:	00f1d193          	srli	gp,gp,0xf
    or      x3,x3,x14
80000c44:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x12
80000c48:	00c1c1b3          	xor	gp,gp,a2
    slli    x14,x1,12
80000c4c:	00c09713          	slli	a4,ra,0xc
    srli    x1,x1,20
80000c50:	0140d093          	srli	ra,ra,0x14
    or      x1,x1,x14
80000c54:	00e0e0b3          	or	ra,ra,a4
    xor     x12,x3,x1
80000c58:	0011c633          	xor	a2,gp,ra

    //c0 ^= gascon_rotr64_interleaved(c0, 28) ^ gascon_rotr64_interleaved(c0, 19);
    //c0 high part
    mv      x3,x5
80000c5c:	00028193          	mv	gp,t0
    slli    x1,x3,18
80000c60:	01219093          	slli	ra,gp,0x12
    srli    x3,x3,14
80000c64:	00e1d193          	srli	gp,gp,0xe
    or      x3,x3,x1
80000c68:	0011e1b3          	or	gp,gp,ra
    xor     x5,x5,x3
80000c6c:	0032c2b3          	xor	t0,t0,gp
    mv      x1,x4
80000c70:	00020093          	mv	ra,tp
    slli    x14,x1,22
80000c74:	01609713          	slli	a4,ra,0x16
    srli    x1,x1,10
80000c78:	00a0d093          	srli	ra,ra,0xa
    or      x1,x1,x14
80000c7c:	00e0e0b3          	or	ra,ra,a4
    xor     x5,x5,x1
80000c80:	0012c2b3          	xor	t0,t0,ra
    //c0 low part
    mv      x1,x4
80000c84:	00020093          	mv	ra,tp
    slli    x14,x3,5
80000c88:	00519713          	slli	a4,gp,0x5
    srli    x3,x3,(32-14+9)%32
80000c8c:	01b1d193          	srli	gp,gp,0x1b
    or      x3,x3,x14
80000c90:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x4
80000c94:	0041c1b3          	xor	gp,gp,tp
    slli    x14,x1,18
80000c98:	01209713          	slli	a4,ra,0x12
    srli    x1,x1,14
80000c9c:	00e0d093          	srli	ra,ra,0xe
    or      x1,x1,x14
80000ca0:	00e0e0b3          	or	ra,ra,a4
    xor     x4,x3,x1
80000ca4:	0011c233          	xor	tp,gp,ra

    //c1 ^= gascon_rotr64_interleaved(c1, 38) ^ gascon_rotr64_interleaved(c1, 61);
    //c1 high part
    mv      x3,x7
80000ca8:	00038193          	mv	gp,t2
    slli    x1,x3,13
80000cac:	00d19093          	slli	ra,gp,0xd
    srli    x3,x3,19
80000cb0:	0131d193          	srli	gp,gp,0x13
    or      x3,x3,x1
80000cb4:	0011e1b3          	or	gp,gp,ra
    xor     x7,x7,x3
80000cb8:	0033c3b3          	xor	t2,t2,gp
    mv      x1,x6
80000cbc:	00030093          	mv	ra,t1
    slli    x14,x1,1
80000cc0:	00109713          	slli	a4,ra,0x1
    srli    x1,x1,31
80000cc4:	01f0d093          	srli	ra,ra,0x1f
    or      x1,x1,x14
80000cc8:	00e0e0b3          	or	ra,ra,a4
    xor     x7,x7,x1
80000ccc:	0013c3b3          	xor	t2,t2,ra
    //c1 low part
    mv      x1,x6
80000cd0:	00030093          	mv	ra,t1
    slli    x14,x3,21
80000cd4:	01519713          	slli	a4,gp,0x15
    srli    x3,x3,(32-19+30)%32
80000cd8:	00b1d193          	srli	gp,gp,0xb
    or      x3,x3,x14
80000cdc:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x6
80000ce0:	0061c1b3          	xor	gp,gp,t1
    slli    x14,x1,13
80000ce4:	00d09713          	slli	a4,ra,0xd
    srli    x1,x1,19
80000ce8:	0130d093          	srli	ra,ra,0x13
    or      x1,x1,x14
80000cec:	00e0e0b3          	or	ra,ra,a4
    xor     x6,x3,x1
80000cf0:	0011c333          	xor	t1,gp,ra

    //c2 ^= gascon_rotr64_interleaved(c2, 6) ^ gascon_rotr64_interleaved(c2, 1);
    //c2 high part
    mv      x3,x9
80000cf4:	00048193          	mv	gp,s1
    slli    x1,x3,29
80000cf8:	01d19093          	slli	ra,gp,0x1d
    srli    x3,x3,3
80000cfc:	0031d193          	srli	gp,gp,0x3
    or      x3,x3,x1
80000d00:	0011e1b3          	or	gp,gp,ra
    xor     x9,x9,x3
80000d04:	0034c4b3          	xor	s1,s1,gp
    mv      x1,x8
80000d08:	00040093          	mv	ra,s0
    slli    x14,x1,31
80000d0c:	01f09713          	slli	a4,ra,0x1f
    srli    x1,x1,1
80000d10:	0010d093          	srli	ra,ra,0x1
    or      x1,x1,x14
80000d14:	00e0e0b3          	or	ra,ra,a4
    xor     x9,x9,x1
80000d18:	0014c4b3          	xor	s1,s1,ra
    //c2 low part
    mv      x1,x8
80000d1c:	00040093          	mv	ra,s0
    slli    x14,x3,3
80000d20:	00319713          	slli	a4,gp,0x3
    srli    x3,x3,(32-3+0)%32
80000d24:	01d1d193          	srli	gp,gp,0x1d
    or      x3,x3,x14
80000d28:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x8
80000d2c:	0081c1b3          	xor	gp,gp,s0
    slli    x14,x1,29
80000d30:	01d09713          	slli	a4,ra,0x1d
    srli    x1,x1,3
80000d34:	0030d093          	srli	ra,ra,0x3
    or      x1,x1,x14
80000d38:	00e0e0b3          	or	ra,ra,a4
    xor     x8,x3,x1
80000d3c:	0011c433          	xor	s0,gp,ra

    //c3 ^= gascon_rotr64_interleaved(c3, 10) ^ gascon_rotr64_interleaved(c3, 17);
    //c3 high part
    mv      x3,x11
80000d40:	00058193          	mv	gp,a1
    slli    x1,x3,27
80000d44:	01b19093          	slli	ra,gp,0x1b
    srli    x3,x3,5
80000d48:	0051d193          	srli	gp,gp,0x5
    or      x3,x3,x1
80000d4c:	0011e1b3          	or	gp,gp,ra
    xor     x11,x11,x3
80000d50:	0035c5b3          	xor	a1,a1,gp
    mv      x1,x10
80000d54:	00050093          	mv	ra,a0
    slli    x14,x1,23
80000d58:	01709713          	slli	a4,ra,0x17
    srli    x1,x1,9
80000d5c:	0090d093          	srli	ra,ra,0x9
    or      x1,x1,x14
80000d60:	00e0e0b3          	or	ra,ra,a4
    xor     x11,x11,x1
80000d64:	0015c5b3          	xor	a1,a1,ra
    //c3 low part
    mv      x1,x10
80000d68:	00050093          	mv	ra,a0
    slli    x14,x3,29
80000d6c:	01d19713          	slli	a4,gp,0x1d
    srli    x3,x3,(32-5+8)%32
80000d70:	0031d193          	srli	gp,gp,0x3
    or      x3,x3,x14
80000d74:	00e1e1b3          	or	gp,gp,a4
    xor     x3,x3,x10
80000d78:	00a1c1b3          	xor	gp,gp,a0
    slli    x14,x1,27
80000d7c:	01b09713          	slli	a4,ra,0x1b
    srli    x1,x1,5
80000d80:	0050d093          	srli	ra,ra,0x5
    or      x1,x1,x14
80000d84:	00e0e0b3          	or	ra,ra,a4
    xor     x10,x3,x1
80000d88:	0011c533          	xor	a0,gp,ra

    lw      x1,F_ROUND(sp)
80000d8c:	03812083          	lw	ra,56(sp)
    j       drygascon128_f_mix128_main_loop
80000d90:	d4dff06f          	j	80000adc <drygascon128_f_mix128_main_loop>

80000d94 <drygascon128_f_mix128_exit>:

drygascon128_f_mix128_exit:
    lw      x3,F_ROUNDS(sp)
80000d94:	03412183          	lw	gp,52(sp)
    //round=rounds-1
    addi	x1,x3,-1
80000d98:	fff18093          	addi	ra,gp,-1 # 80001ccf <_stack_start+0x51f>
    sw		x1,F_ROUND(sp)
80000d9c:	02112c23          	sw	ra,56(sp)
    //base = round_cst+12-round
    la      x14,round_cst
80000da0:	00000717          	auipc	a4,0x0
80000da4:	72070713          	addi	a4,a4,1824 # 800014c0 <round_cst>
    addi	x14,x14,12
80000da8:	00c70713          	addi	a4,a4,12
    sub		x3,x14,x3
80000dac:	403701b3          	sub	gp,a4,gp
    sw		x3,F_ROUNDS(sp)
80000db0:	02312a23          	sw	gp,52(sp)

    addi    sp,sp,MIX_STACK_SIZE
80000db4:	01c10113          	addi	sp,sp,28
    j       drygascon128_g_entry_from_f
80000db8:	8edff06f          	j	800006a4 <drygascon128_g_entry_from_f>

Disassembly of section .text.startup:

80000dbc <main>:
void main() {
80000dbc:	f7010113          	addi	sp,sp,-144
	volatile uint32_t a = 1, b = 2, c = 3;
80000dc0:	00100713          	li	a4,1
80000dc4:	00e12023          	sw	a4,0(sp)
80000dc8:	00200793          	li	a5,2
80000dcc:	00f12223          	sw	a5,4(sp)
80000dd0:	00300793          	li	a5,3
80000dd4:	00f12423          	sw	a5,8(sp)
	char buf[10] = {0};
80000dd8:	00012623          	sw	zero,12(sp)
80000ddc:	00012823          	sw	zero,16(sp)
80000de0:	00011a23          	sh	zero,20(sp)
void main() {
80000de4:	08112623          	sw	ra,140(sp)
80000de8:	08812423          	sw	s0,136(sp)
80000dec:	08912223          	sw	s1,132(sp)
80000df0:	09212023          	sw	s2,128(sp)
80000df4:	07312e23          	sw	s3,124(sp)
80000df8:	07412c23          	sw	s4,120(sp)
80000dfc:	07512a23          	sw	s5,116(sp)
80000e00:	07612823          	sw	s6,112(sp)
80000e04:	07712623          	sw	s7,108(sp)
  volatile uint32_t PENDINGS;
  volatile uint32_t MASKS;
} InterruptCtrl_Reg;

static void interruptCtrl_init(InterruptCtrl_Reg* reg){
	reg->MASKS = 0;
80000e08:	f00207b7          	lui	a5,0xf0020
80000e0c:	0007aa23          	sw	zero,20(a5) # f0020014 <__global_pointer$+0x7001e344>
	reg->PENDINGS = 0xFFFFFFFF;
80000e10:	fff00613          	li	a2,-1
80000e14:	00c7a823          	sw	a2,16(a5)
  volatile uint32_t LIMIT;
  volatile uint32_t VALUE;
} Timer_Reg;

static void timer_init(Timer_Reg *reg){
	reg->CLEARS_TICKS  = 0;
80000e18:	0407a023          	sw	zero,64(a5)
	reg->VALUE = 0;
80000e1c:	0407a423          	sw	zero,72(a5)
	TIMER_PRESCALER->LIMIT = 0;
80000e20:	0007a023          	sw	zero,0(a5)
	TIMER_A->LIMIT = 0xFFFFFFFF;
80000e24:	04c7a223          	sw	a2,68(a5)
	TIMER_A->CLEARS_TICKS = 1;//bypass prescaler, no auto-clear
80000e28:	04e7a023          	sw	a4,64(a5)
	GPIO_A->OUTPUT_ENABLE = 0x000000FF;
80000e2c:	f00007b7          	lui	a5,0xf0000
80000e30:	0ff00713          	li	a4,255
80000e34:	00e7a423          	sw	a4,8(a5) # f0000008 <__global_pointer$+0x6fffe338>
	GPIO_A->OUTPUT = 0x000000F0;
80000e38:	0f000713          	li	a4,240
80000e3c:	00e7a223          	sw	a4,4(a5)
	UART->DATA = 'A';
80000e40:	f00107b7          	lui	a5,0xf0010
80000e44:	04100713          	li	a4,65
80000e48:	00e7a023          	sw	a4,0(a5) # f0010000 <__global_pointer$+0x7000e330>
    return hw->CTRL & DRYGASCON128_IDLE_MASK;
80000e4c:	f00307b7          	lui	a5,0xf0030
80000e50:	0007a783          	lw	a5,0(a5) # f0030000 <__global_pointer$+0x7002e330>
    drygascon128hw_get_io(hw,r);
}

//return 0 if success or error code
static unsigned int drygascon128hw_test_ctrl(Drygascon128_Regs *hw){
    if(!drygascon128hw_idle(hw)) return 0x2;
80000e54:	00200593          	li	a1,2
80000e58:	0a07d463          	bgez	a5,80000f00 <main+0x144>
    for(unsigned int i=0;i<256;i++){
        hw->CTRL = i;
        if(i!=(hw->CTRL & ~DRYGASCON128_IDLE_MASK)) return 0x01000000 | i;
80000e5c:	800007b7          	lui	a5,0x80000
    for(unsigned int i=0;i<256;i++){
80000e60:	00000593          	li	a1,0
        hw->CTRL = i;
80000e64:	f0030737          	lui	a4,0xf0030
        if(i!=(hw->CTRL & ~DRYGASCON128_IDLE_MASK)) return 0x01000000 | i;
80000e68:	fff7c793          	not	a5,a5
    for(unsigned int i=0;i<256;i++){
80000e6c:	10000613          	li	a2,256
        hw->CTRL = i;
80000e70:	00b72023          	sw	a1,0(a4) # f0030000 <__global_pointer$+0x7002e330>
        if(i!=(hw->CTRL & ~DRYGASCON128_IDLE_MASK)) return 0x01000000 | i;
80000e74:	00072683          	lw	a3,0(a4)
80000e78:	00f6f6b3          	and	a3,a3,a5
80000e7c:	00b68863          	beq	a3,a1,80000e8c <main+0xd0>
80000e80:	010007b7          	lui	a5,0x1000
        }
        drygascon128hw_set_io(hw,c);
        drygascon128hw_get_io(hw,c);
        for(unsigned int j=0;j<4;j++){
            q = i*16 + j;
            if(c[j] != q) return 0x03000000 | i;
80000e84:	00f5e5b3          	or	a1,a1,a5
80000e88:	0780006f          	j	80000f00 <main+0x144>
    for(unsigned int i=0;i<256;i++){
80000e8c:	00158593          	addi	a1,a1,1
80000e90:	fec590e3          	bne	a1,a2,80000e70 <main+0xb4>
    hw->CTRL = 0xFFFFFE00;
80000e94:	e0000693          	li	a3,-512
80000e98:	00d72023          	sw	a3,0(a4)
    uint32_t z = hw->CTRL & ~DRYGASCON128_IDLE_MASK;
80000e9c:	00072583          	lw	a1,0(a4)
80000ea0:	00f5f5b3          	and	a1,a1,a5
    if(z) return z;
80000ea4:	04059e63          	bnez	a1,80000f00 <main+0x144>
    for(unsigned int i=0;i<256;i++){
80000ea8:	00000413          	li	s0,0
        for(unsigned int j=0;j<10;j++){
80000eac:	00a00913          	li	s2,10
    for(unsigned int i=0;i<256;i++){
80000eb0:	10000993          	li	s3,256
            p = i*16 + j;
80000eb4:	00441493          	slli	s1,s0,0x4
80000eb8:	01810713          	addi	a4,sp,24
        for(unsigned int j=0;j<10;j++){
80000ebc:	00000793          	li	a5,0
            p = i*16 + j;
80000ec0:	00f486b3          	add	a3,s1,a5
            c[j] = p;
80000ec4:	00d72023          	sw	a3,0(a4)
        for(unsigned int j=0;j<10;j++){
80000ec8:	00178793          	addi	a5,a5,1 # 1000001 <_stack_size+0xfffe01>
80000ecc:	00470713          	addi	a4,a4,4
80000ed0:	ff2798e3          	bne	a5,s2,80000ec0 <main+0x104>
        drygascon128hw_set_c(hw,c);
80000ed4:	01810513          	addi	a0,sp,24
80000ed8:	a6cff0ef          	jal	ra,80000144 <drygascon128hw_set_c.constprop.6>
        drygascon128hw_get_c(hw,c);
80000edc:	01810513          	addi	a0,sp,24
80000ee0:	a48ff0ef          	jal	ra,80000128 <drygascon128hw_get_c.constprop.5>
80000ee4:	01810713          	addi	a4,sp,24
        for(unsigned int j=0;j<10;j++){
80000ee8:	00000793          	li	a5,0
            if(c[j] != q) return 0x02000000 | i;
80000eec:	00072603          	lw	a2,0(a4)
            q = i*16 + j;
80000ef0:	00f486b3          	add	a3,s1,a5
            if(c[j] != q) return 0x02000000 | i;
80000ef4:	2ac68063          	beq	a3,a2,80001194 <main+0x3d8>
80000ef8:	020005b7          	lui	a1,0x2000
80000efc:	00b465b3          	or	a1,s0,a1
	u32_to_hexstr(buf,res);
80000f00:	00c10513          	addi	a0,sp,12
80000f04:	c00ff0ef          	jal	ra,80000304 <u32_to_hexstr>
	for(unsigned int i=0;i<8;i++){
80000f08:	00000413          	li	s0,0
80000f0c:	00800493          	li	s1,8
		uart_write(UART,buf[i]);
80000f10:	00c10793          	addi	a5,sp,12
80000f14:	008787b3          	add	a5,a5,s0
80000f18:	0007c503          	lbu	a0,0(a5)
	for(unsigned int i=0;i<8;i++){
80000f1c:	00140413          	addi	s0,s0,1
		uart_write(UART,buf[i]);
80000f20:	a40ff0ef          	jal	ra,80000160 <uart_write.constprop.11>
	for(unsigned int i=0;i<8;i++){
80000f24:	fe9416e3          	bne	s0,s1,80000f10 <main+0x154>
	uart_write(UART,'\n');
80000f28:	00a00513          	li	a0,10
80000f2c:	a34ff0ef          	jal	ra,80000160 <uart_write.constprop.11>
	test_drygascon128_g();
80000f30:	cf4ff0ef          	jal	ra,80000424 <test_drygascon128_g>
	test_drygascon128_f();
80000f34:	dccff0ef          	jal	ra,80000500 <test_drygascon128_f>
	uart_write(UART,'\n');
80000f38:	00a00513          	li	a0,10
80000f3c:	a24ff0ef          	jal	ra,80000160 <uart_write.constprop.11>
	uart_write(UART,'O');
80000f40:	04f00513          	li	a0,79
80000f44:	a1cff0ef          	jal	ra,80000160 <uart_write.constprop.11>
	uart_write(UART,'K');
80000f48:	04b00513          	li	a0,75
80000f4c:	a14ff0ef          	jal	ra,80000160 <uart_write.constprop.11>
	uart_write(UART,'\n');
80000f50:	00a00513          	li	a0,10
80000f54:	a0cff0ef          	jal	ra,80000160 <uart_write.constprop.11>
80000f58:	00300493          	li	s1,3
		GPIO_A->OUTPUT = ((GPIO_A->OUTPUT + 1) & 0xFF);  //Counter on LED[7:0]
80000f5c:	f0000937          	lui	s2,0xf0000
		min_time=0xFFFFFFFF;
80000f60:	fff00b93          	li	s7,-1
		max_time=0;
80000f64:	80001a37          	lui	s4,0x80001
		benchmark(drygascon128_benchmark);
80000f68:	80000b37          	lui	s6,0x80000
		for(unsigned int i=0;i<8;i++){
80000f6c:	00800a93          	li	s5,8
		GPIO_A->OUTPUT = ((GPIO_A->OUTPUT + 1) & 0xFF);  //Counter on LED[7:0]
80000f70:	00492783          	lw	a5,4(s2) # f0000004 <__global_pointer$+0x6fffe334>
		benchmark(drygascon128_benchmark);
80000f74:	17cb0513          	addi	a0,s6,380 # 8000017c <__global_pointer$+0xffffe4ac>
		for(unsigned int i=0;i<8;i++){
80000f78:	00000413          	li	s0,0
		GPIO_A->OUTPUT = ((GPIO_A->OUTPUT + 1) & 0xFF);  //Counter on LED[7:0]
80000f7c:	00178793          	addi	a5,a5,1
80000f80:	0ff7f793          	andi	a5,a5,255
80000f84:	00f92223          	sw	a5,4(s2)
		a++;
80000f88:	00012783          	lw	a5,0(sp)
		min_time=0xFFFFFFFF;
80000f8c:	8171a423          	sw	s7,-2040(gp) # 800014d8 <min_time>
		max_time=0;
80000f90:	4e0a2023          	sw	zero,1248(s4) # 800014e0 <__global_pointer$+0xfffff810>
		a++;
80000f94:	00178793          	addi	a5,a5,1
80000f98:	00f12023          	sw	a5,0(sp)
		benchmark(drygascon128_benchmark);
80000f9c:	bc4ff0ef          	jal	ra,80000360 <benchmark>
		u32_to_hexstr(buf,min_time);
80000fa0:	8081a583          	lw	a1,-2040(gp) # 800014d8 <min_time>
80000fa4:	00c10513          	addi	a0,sp,12
80000fa8:	b5cff0ef          	jal	ra,80000304 <u32_to_hexstr>
			uart_write(UART,buf[i]);
80000fac:	00c10793          	addi	a5,sp,12
80000fb0:	008787b3          	add	a5,a5,s0
80000fb4:	0007c503          	lbu	a0,0(a5)
		for(unsigned int i=0;i<8;i++){
80000fb8:	00140413          	addi	s0,s0,1
			uart_write(UART,buf[i]);
80000fbc:	9a4ff0ef          	jal	ra,80000160 <uart_write.constprop.11>
		for(unsigned int i=0;i<8;i++){
80000fc0:	ff5416e3          	bne	s0,s5,80000fac <main+0x1f0>
		uart_write(UART,' ');
80000fc4:	02000513          	li	a0,32
80000fc8:	998ff0ef          	jal	ra,80000160 <uart_write.constprop.11>
		u32_to_hexstr(buf,max_time);
80000fcc:	4e0a2583          	lw	a1,1248(s4)
80000fd0:	00c10513          	addi	a0,sp,12
		for(unsigned int i=0;i<8;i++){
80000fd4:	00000413          	li	s0,0
		u32_to_hexstr(buf,max_time);
80000fd8:	b2cff0ef          	jal	ra,80000304 <u32_to_hexstr>
			uart_write(UART,buf[i]);
80000fdc:	00c10793          	addi	a5,sp,12
80000fe0:	008787b3          	add	a5,a5,s0
80000fe4:	0007c503          	lbu	a0,0(a5)
		for(unsigned int i=0;i<8;i++){
80000fe8:	00140413          	addi	s0,s0,1
			uart_write(UART,buf[i]);
80000fec:	974ff0ef          	jal	ra,80000160 <uart_write.constprop.11>
		for(unsigned int i=0;i<8;i++){
80000ff0:	ff5416e3          	bne	s0,s5,80000fdc <main+0x220>
		uart_write(UART,'\n');
80000ff4:	00a00513          	li	a0,10
80000ff8:	fff48493          	addi	s1,s1,-1
80000ffc:	964ff0ef          	jal	ra,80000160 <uart_write.constprop.11>
	for(unsigned int i=0;i<3;i++){
80001000:	f60498e3          	bnez	s1,80000f70 <main+0x1b4>
		const uint8_t s[]={//c r x
80001004:	80001937          	lui	s2,0x80001
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
80001008:	000019b7          	lui	s3,0x1
8000100c:	37090913          	addi	s2,s2,880 # 80001370 <__global_pointer$+0xfffff6a0>
			uart_read(UART,drygascon128_state8+40+i);
80001010:	80001a37          	lui	s4,0x80001
	return reg->STATUS >> 24;
80001014:	f00104b7          	lui	s1,0xf0010
80001018:	80001ab7          	lui	s5,0x80001
8000101c:	ff098993          	addi	s3,s3,-16 # ff0 <_stack_size+0xdf0>
		const uint8_t s[]={//c r x
80001020:	04800613          	li	a2,72
80001024:	00090593          	mv	a1,s2
80001028:	01810513          	addi	a0,sp,24
8000102c:	9b0ff0ef          	jal	ra,800001dc <memcpy>
		memcpy(drygascon128_state,s,sizeof(s));
80001030:	04800613          	li	a2,72
80001034:	01810593          	addi	a1,sp,24
80001038:	88018513          	addi	a0,gp,-1920 # 80001550 <drygascon128_state>
8000103c:	9a0ff0ef          	jal	ra,800001dc <memcpy>
80001040:	02800713          	li	a4,40
			GPIO_A->OUTPUT = ((GPIO_A->OUTPUT + 1) & 0xFF);  //Counter on LED[7:0]
80001044:	f0000637          	lui	a2,0xf0000
		for(unsigned int i=0;i<16;i++){
80001048:	03800593          	li	a1,56
			uart_read(UART,drygascon128_state8+40+i);
8000104c:	4d4a2783          	lw	a5,1236(s4) # 800014d4 <__global_pointer$+0xfffff804>
80001050:	00e787b3          	add	a5,a5,a4
80001054:	0044a683          	lw	a3,4(s1) # f0010004 <__global_pointer$+0x7000e334>
80001058:	0186d693          	srli	a3,a3,0x18
	while(uart_readOccupancy(reg) == 0);
8000105c:	fe068ce3          	beqz	a3,80001054 <main+0x298>
	*data = reg->DATA;
80001060:	0004a683          	lw	a3,0(s1)
80001064:	00170713          	addi	a4,a4,1
80001068:	00d78023          	sb	a3,0(a5)
			GPIO_A->OUTPUT = ((GPIO_A->OUTPUT + 1) & 0xFF);  //Counter on LED[7:0]
8000106c:	00462783          	lw	a5,4(a2) # f0000004 <__global_pointer$+0x6fffe334>
80001070:	00178793          	addi	a5,a5,1
80001074:	0ff7f793          	andi	a5,a5,255
80001078:	00f62223          	sw	a5,4(a2)
			a++;
8000107c:	00012783          	lw	a5,0(sp)
80001080:	00178793          	addi	a5,a5,1
80001084:	00f12023          	sw	a5,0(sp)
		for(unsigned int i=0;i<16;i++){
80001088:	fcb712e3          	bne	a4,a1,8000104c <main+0x290>
8000108c:	0044a783          	lw	a5,4(s1)
80001090:	0187d793          	srli	a5,a5,0x18
	while(uart_readOccupancy(reg) == 0);
80001094:	fe078ce3          	beqz	a5,8000108c <main+0x2d0>
		GPIO_A->OUTPUT = ((GPIO_A->OUTPUT + 1) & 0xFF);  //Counter on LED[7:0]
80001098:	f0000737          	lui	a4,0xf0000
	*data = reg->DATA;
8000109c:	0004a403          	lw	s0,0(s1)
		GPIO_A->OUTPUT = ((GPIO_A->OUTPUT + 1) & 0xFF);  //Counter on LED[7:0]
800010a0:	00472783          	lw	a5,4(a4) # f0000004 <__global_pointer$+0x6fffe334>
800010a4:	4d0aa503          	lw	a0,1232(s5) # 800014d0 <__global_pointer$+0xfffff800>
800010a8:	00178793          	addi	a5,a5,1
800010ac:	0ff7f793          	andi	a5,a5,255
800010b0:	00f72223          	sw	a5,4(a4)
		a++;
800010b4:	00012783          	lw	a5,0(sp)
800010b8:	00178793          	addi	a5,a5,1
800010bc:	00f12023          	sw	a5,0(sp)
		if(ds & 0xF0){
800010c0:	0f047793          	andi	a5,s0,240
800010c4:	18079c63          	bnez	a5,8000125c <main+0x4a0>
		drygascon128hw_set_c(DRYGASCON128,drygascon128_state32);
800010c8:	87cff0ef          	jal	ra,80000144 <drygascon128hw_set_c.constprop.6>
		drygascon128hw_set_x(DRYGASCON128,drygascon128_state32+10+4);
800010cc:	4d0aa503          	lw	a0,1232(s5)
    hw->X = x[0];
800010d0:	f00307b7          	lui	a5,0xf0030
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
800010d4:	00441413          	slli	s0,s0,0x4
    hw->X = x[0];
800010d8:	03852703          	lw	a4,56(a0)
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
800010dc:	01347433          	and	s0,s0,s3
800010e0:	10746413          	ori	s0,s0,263
    hw->X = x[0];
800010e4:	00e7a623          	sw	a4,12(a5) # f003000c <__global_pointer$+0x7002e33c>
    hw->X = x[1];
800010e8:	03c52703          	lw	a4,60(a0)
800010ec:	00e7a623          	sw	a4,12(a5)
    hw->X = x[2];
800010f0:	04052703          	lw	a4,64(a0)
800010f4:	00e7a623          	sw	a4,12(a5)
    hw->X = x[3];
800010f8:	04452703          	lw	a4,68(a0)
800010fc:	00e7a623          	sw	a4,12(a5)
    hw->IO = i[0];
80001100:	02852703          	lw	a4,40(a0)
80001104:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[1];
80001108:	02c52703          	lw	a4,44(a0)
8000110c:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[2];
80001110:	03052703          	lw	a4,48(a0)
80001114:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[3];
80001118:	03452703          	lw	a4,52(a0)
8000111c:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[0];
80001120:	02852703          	lw	a4,40(a0)
80001124:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[1];
80001128:	02c52703          	lw	a4,44(a0)
8000112c:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[2];
80001130:	03052703          	lw	a4,48(a0)
80001134:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[3];
80001138:	03452703          	lw	a4,52(a0)
8000113c:	00e7a423          	sw	a4,8(a5)
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
80001140:	0087a023          	sw	s0,0(a5)
    return hw->CTRL & DRYGASCON128_IDLE_MASK;
80001144:	0007a703          	lw	a4,0(a5)
    while(!drygascon128hw_idle(hw));
80001148:	fe075ee3          	bgez	a4,80001144 <main+0x388>
    o[0] = hw->IO;
8000114c:	0087a703          	lw	a4,8(a5)
		drygascon128hw_get_c(DRYGASCON128,drygascon128_state32);
80001150:	02800413          	li	s0,40
		for(unsigned int i=0;i<16;i++){
80001154:	03800b93          	li	s7,56
80001158:	02e52423          	sw	a4,40(a0)
    o[1] = hw->IO;
8000115c:	0087a703          	lw	a4,8(a5)
80001160:	02e52623          	sw	a4,44(a0)
    o[2] = hw->IO;
80001164:	0087a703          	lw	a4,8(a5)
80001168:	02e52823          	sw	a4,48(a0)
    o[3] = hw->IO;
8000116c:	0087a783          	lw	a5,8(a5)
80001170:	02f52a23          	sw	a5,52(a0)
		drygascon128hw_get_c(DRYGASCON128,drygascon128_state32);
80001174:	fb5fe0ef          	jal	ra,80000128 <drygascon128hw_get_c.constprop.5>
			uart_write(UART,drygascon128_state8[40+i]);
80001178:	4d4a2783          	lw	a5,1236(s4)
8000117c:	008787b3          	add	a5,a5,s0
80001180:	0007c503          	lbu	a0,0(a5)
80001184:	00140413          	addi	s0,s0,1
80001188:	fd9fe0ef          	jal	ra,80000160 <uart_write.constprop.11>
		for(unsigned int i=0;i<16;i++){
8000118c:	ff7416e3          	bne	s0,s7,80001178 <main+0x3bc>
80001190:	e91ff06f          	j	80001020 <main+0x264>
        for(unsigned int j=0;j<10;j++){
80001194:	00178793          	addi	a5,a5,1
80001198:	00470713          	addi	a4,a4,4
8000119c:	d52798e3          	bne	a5,s2,80000eec <main+0x130>
    for(unsigned int i=0;i<256;i++){
800011a0:	00140413          	addi	s0,s0,1
800011a4:	d13418e3          	bne	s0,s3,80000eb4 <main+0xf8>
800011a8:	00000713          	li	a4,0
    for(unsigned int i=0;i<256;i++){
800011ac:	00000593          	li	a1,0
    hw->IO = i[0];
800011b0:	f00307b7          	lui	a5,0xf0030
        for(unsigned int j=0;j<4;j++){
800011b4:	00400813          	li	a6,4
    for(unsigned int i=0;i<256;i++){
800011b8:	10000893          	li	a7,256
            p = i*16 + j;
800011bc:	00270613          	addi	a2,a4,2
            c[j] = p;
800011c0:	02c12023          	sw	a2,32(sp)
            p = i*16 + j;
800011c4:	00370613          	addi	a2,a4,3
            c[j] = p;
800011c8:	02c12223          	sw	a2,36(sp)
    hw->IO = i[0];
800011cc:	00e7a423          	sw	a4,8(a5) # f0030008 <__global_pointer$+0x7002e338>
            p = i*16 + j;
800011d0:	00170693          	addi	a3,a4,1
    hw->IO = i[1];
800011d4:	00d7a423          	sw	a3,8(a5)
    hw->IO = i[2];
800011d8:	02012683          	lw	a3,32(sp)
    o[3] = hw->IO;
800011dc:	01810613          	addi	a2,sp,24
    hw->IO = i[2];
800011e0:	00d7a423          	sw	a3,8(a5)
    hw->IO = i[3];
800011e4:	02412683          	lw	a3,36(sp)
800011e8:	00d7a423          	sw	a3,8(a5)
    o[0] = hw->IO;
800011ec:	0087a683          	lw	a3,8(a5)
800011f0:	00d12c23          	sw	a3,24(sp)
    o[1] = hw->IO;
800011f4:	0087a683          	lw	a3,8(a5)
800011f8:	00d12e23          	sw	a3,28(sp)
    o[2] = hw->IO;
800011fc:	0087a683          	lw	a3,8(a5)
80001200:	02d12023          	sw	a3,32(sp)
    o[3] = hw->IO;
80001204:	0087a683          	lw	a3,8(a5)
80001208:	02d12223          	sw	a3,36(sp)
        for(unsigned int j=0;j<4;j++){
8000120c:	00000693          	li	a3,0
            if(c[j] != q) return 0x03000000 | i;
80001210:	00062303          	lw	t1,0(a2)
            q = i*16 + j;
80001214:	00d70533          	add	a0,a4,a3
            if(c[j] != q) return 0x03000000 | i;
80001218:	00650663          	beq	a0,t1,80001224 <main+0x468>
8000121c:	030007b7          	lui	a5,0x3000
80001220:	c65ff06f          	j	80000e84 <main+0xc8>
        for(unsigned int j=0;j<4;j++){
80001224:	00168693          	addi	a3,a3,1
80001228:	00460613          	addi	a2,a2,4
8000122c:	ff0692e3          	bne	a3,a6,80001210 <main+0x454>
    for(unsigned int i=0;i<256;i++){
80001230:	00158593          	addi	a1,a1,1 # 2000001 <_stack_size+0x1fffe01>
80001234:	01070713          	addi	a4,a4,16
80001238:	f91592e3          	bne	a1,a7,800011bc <main+0x400>
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
8000123c:	10100713          	li	a4,257
80001240:	f00307b7          	lui	a5,0xf0030
80001244:	00e7a023          	sw	a4,0(a5) # f0030000 <__global_pointer$+0x7002e330>
    return hw->CTRL & DRYGASCON128_IDLE_MASK;
80001248:	f0030737          	lui	a4,0xf0030
8000124c:	00072783          	lw	a5,0(a4) # f0030000 <__global_pointer$+0x7002e330>
    while(!drygascon128hw_idle(hw));
80001250:	fe07dee3          	bgez	a5,8000124c <main+0x490>
        }
    }
    //purge the internal state
    drygascon128hw_start(hw, 0, 1);
    drygascon128hw_wait_idle(hw);
    return 0;
80001254:	00000593          	li	a1,0
80001258:	ca9ff06f          	j	80000f00 <main+0x144>
	uint32_t leds=0;
8000125c:	00000693          	li	a3,0
		GPIO_A->OUTPUT = 1|((leds>>6) & 0xFF);//force lsb to 1 to have clean trigger
80001260:	f0000637          	lui	a2,0xf0000
    hw->IO = i[0];
80001264:	f00307b7          	lui	a5,0xf0030
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
80001268:	10700593          	li	a1,263
8000126c:	0066d713          	srli	a4,a3,0x6
80001270:	0ff77713          	andi	a4,a4,255
80001274:	00176713          	ori	a4,a4,1
80001278:	00e62223          	sw	a4,4(a2) # f0000004 <__global_pointer$+0x6fffe334>
    hw->IO = i[0];
8000127c:	02852703          	lw	a4,40(a0)
80001280:	00e7a423          	sw	a4,8(a5) # f0030008 <__global_pointer$+0x7002e338>
    hw->IO = i[1];
80001284:	02c52703          	lw	a4,44(a0)
80001288:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[2];
8000128c:	03052703          	lw	a4,48(a0)
80001290:	00e7a423          	sw	a4,8(a5)
    hw->IO = i[3];
80001294:	03452703          	lw	a4,52(a0)
80001298:	00e7a423          	sw	a4,8(a5)
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
8000129c:	00b7a023          	sw	a1,0(a5)
    return hw->CTRL & DRYGASCON128_IDLE_MASK;
800012a0:	0007a703          	lw	a4,0(a5)
    while(!drygascon128hw_idle(hw));
800012a4:	fe075ee3          	bgez	a4,800012a0 <main+0x4e4>
    o[0] = hw->IO;
800012a8:	0087a703          	lw	a4,8(a5)
		leds++;
800012ac:	00168693          	addi	a3,a3,1
800012b0:	02e52423          	sw	a4,40(a0)
    o[1] = hw->IO;
800012b4:	0087a703          	lw	a4,8(a5)
800012b8:	02e52623          	sw	a4,44(a0)
    o[2] = hw->IO;
800012bc:	0087a703          	lw	a4,8(a5)
800012c0:	02e52823          	sw	a4,48(a0)
    o[3] = hw->IO;
800012c4:	0087a703          	lw	a4,8(a5)
800012c8:	02e52a23          	sw	a4,52(a0)
		GPIO_A->OUTPUT = 0;
800012cc:	00062223          	sw	zero,4(a2)
800012d0:	f9dff06f          	j	8000126c <main+0x4b0>
