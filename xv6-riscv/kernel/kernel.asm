
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	83010113          	addi	sp,sp,-2000 # 80009830 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	06e000ef          	jal	ra,80000084 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 10000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	6709                	lui	a4,0x2
    8000003a:	71070713          	addi	a4,a4,1808 # 2710 <_entry-0x7fffd8f0>
    8000003e:	963a                	add	a2,a2,a4
    80000040:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000042:	0057979b          	slliw	a5,a5,0x5
    80000046:	078e                	slli	a5,a5,0x3
    80000048:	00009617          	auipc	a2,0x9
    8000004c:	fe860613          	addi	a2,a2,-24 # 80009030 <mscratch0>
    80000050:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000052:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000054:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000056:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005a:	00006797          	auipc	a5,0x6
    8000005e:	1e678793          	addi	a5,a5,486 # 80006240 <timervec>
    80000062:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000066:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006a:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000006e:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000072:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000076:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007a:	30479073          	csrw	mie,a5
}
    8000007e:	6422                	ld	s0,8(sp)
    80000080:	0141                	addi	sp,sp,16
    80000082:	8082                	ret

0000000080000084 <start>:
{
    80000084:	1141                	addi	sp,sp,-16
    80000086:	e406                	sd	ra,8(sp)
    80000088:	e022                	sd	s0,0(sp)
    8000008a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000090:	7779                	lui	a4,0xffffe
    80000092:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd77ff>
    80000096:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000098:	6705                	lui	a4,0x1
    8000009a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000009e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a0:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a4:	00001797          	auipc	a5,0x1
    800000a8:	e0278793          	addi	a5,a5,-510 # 80000ea6 <main>
    800000ac:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b0:	4781                	li	a5,0
    800000b2:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b6:	67c1                	lui	a5,0x10
    800000b8:	17fd                	addi	a5,a5,-1
    800000ba:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000be:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c6:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000ca:	10479073          	csrw	sie,a5
  timerinit();
    800000ce:	00000097          	auipc	ra,0x0
    800000d2:	f4e080e7          	jalr	-178(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000da:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000dc:	823e                	mv	tp,a5
  asm volatile("mret");
    800000de:	30200073          	mret
}
    800000e2:	60a2                	ld	ra,8(sp)
    800000e4:	6402                	ld	s0,0(sp)
    800000e6:	0141                	addi	sp,sp,16
    800000e8:	8082                	ret

00000000800000ea <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ea:	715d                	addi	sp,sp,-80
    800000ec:	e486                	sd	ra,72(sp)
    800000ee:	e0a2                	sd	s0,64(sp)
    800000f0:	fc26                	sd	s1,56(sp)
    800000f2:	f84a                	sd	s2,48(sp)
    800000f4:	f44e                	sd	s3,40(sp)
    800000f6:	f052                	sd	s4,32(sp)
    800000f8:	ec56                	sd	s5,24(sp)
    800000fa:	0880                	addi	s0,sp,80
    800000fc:	8a2a                	mv	s4,a0
    800000fe:	84ae                	mv	s1,a1
    80000100:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000102:	00011517          	auipc	a0,0x11
    80000106:	72e50513          	addi	a0,a0,1838 # 80011830 <cons>
    8000010a:	00001097          	auipc	ra,0x1
    8000010e:	af2080e7          	jalr	-1294(ra) # 80000bfc <acquire>
  for(i = 0; i < n; i++){
    80000112:	05305b63          	blez	s3,80000168 <consolewrite+0x7e>
    80000116:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000118:	5afd                	li	s5,-1
    8000011a:	4685                	li	a3,1
    8000011c:	8626                	mv	a2,s1
    8000011e:	85d2                	mv	a1,s4
    80000120:	fbf40513          	addi	a0,s0,-65
    80000124:	00003097          	auipc	ra,0x3
    80000128:	95e080e7          	jalr	-1698(ra) # 80002a82 <either_copyin>
    8000012c:	01550c63          	beq	a0,s5,80000144 <consolewrite+0x5a>
      break;
    uartputc(c);
    80000130:	fbf44503          	lbu	a0,-65(s0)
    80000134:	00000097          	auipc	ra,0x0
    80000138:	796080e7          	jalr	1942(ra) # 800008ca <uartputc>
  for(i = 0; i < n; i++){
    8000013c:	2905                	addiw	s2,s2,1
    8000013e:	0485                	addi	s1,s1,1
    80000140:	fd299de3          	bne	s3,s2,8000011a <consolewrite+0x30>
  }
  release(&cons.lock);
    80000144:	00011517          	auipc	a0,0x11
    80000148:	6ec50513          	addi	a0,a0,1772 # 80011830 <cons>
    8000014c:	00001097          	auipc	ra,0x1
    80000150:	b64080e7          	jalr	-1180(ra) # 80000cb0 <release>

  return i;
}
    80000154:	854a                	mv	a0,s2
    80000156:	60a6                	ld	ra,72(sp)
    80000158:	6406                	ld	s0,64(sp)
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	7942                	ld	s2,48(sp)
    8000015e:	79a2                	ld	s3,40(sp)
    80000160:	7a02                	ld	s4,32(sp)
    80000162:	6ae2                	ld	s5,24(sp)
    80000164:	6161                	addi	sp,sp,80
    80000166:	8082                	ret
  for(i = 0; i < n; i++){
    80000168:	4901                	li	s2,0
    8000016a:	bfe9                	j	80000144 <consolewrite+0x5a>

000000008000016c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016c:	7159                	addi	sp,sp,-112
    8000016e:	f486                	sd	ra,104(sp)
    80000170:	f0a2                	sd	s0,96(sp)
    80000172:	eca6                	sd	s1,88(sp)
    80000174:	e8ca                	sd	s2,80(sp)
    80000176:	e4ce                	sd	s3,72(sp)
    80000178:	e0d2                	sd	s4,64(sp)
    8000017a:	fc56                	sd	s5,56(sp)
    8000017c:	f85a                	sd	s6,48(sp)
    8000017e:	f45e                	sd	s7,40(sp)
    80000180:	f062                	sd	s8,32(sp)
    80000182:	ec66                	sd	s9,24(sp)
    80000184:	e86a                	sd	s10,16(sp)
    80000186:	1880                	addi	s0,sp,112
    80000188:	8aaa                	mv	s5,a0
    8000018a:	8a2e                	mv	s4,a1
    8000018c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000018e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000192:	00011517          	auipc	a0,0x11
    80000196:	69e50513          	addi	a0,a0,1694 # 80011830 <cons>
    8000019a:	00001097          	auipc	ra,0x1
    8000019e:	a62080e7          	jalr	-1438(ra) # 80000bfc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a2:	00011497          	auipc	s1,0x11
    800001a6:	68e48493          	addi	s1,s1,1678 # 80011830 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001aa:	00011917          	auipc	s2,0x11
    800001ae:	71e90913          	addi	s2,s2,1822 # 800118c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b2:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b4:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001b6:	4ca9                	li	s9,10
  while(n > 0){
    800001b8:	07305863          	blez	s3,80000228 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001bc:	0984a783          	lw	a5,152(s1)
    800001c0:	09c4a703          	lw	a4,156(s1)
    800001c4:	02f71463          	bne	a4,a5,800001ec <consoleread+0x80>
      if(myproc()->killed){
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	d54080e7          	jalr	-684(ra) # 80001f1c <myproc>
    800001d0:	591c                	lw	a5,48(a0)
    800001d2:	e7b5                	bnez	a5,8000023e <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d4:	85a6                	mv	a1,s1
    800001d6:	854a                	mv	a0,s2
    800001d8:	00002097          	auipc	ra,0x2
    800001dc:	5c4080e7          	jalr	1476(ra) # 8000279c <sleep>
    while(cons.r == cons.w){
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fef700e3          	beq	a4,a5,800001c8 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001ec:	0017871b          	addiw	a4,a5,1
    800001f0:	08e4ac23          	sw	a4,152(s1)
    800001f4:	07f7f713          	andi	a4,a5,127
    800001f8:	9726                	add	a4,a4,s1
    800001fa:	01874703          	lbu	a4,24(a4)
    800001fe:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000202:	077d0563          	beq	s10,s7,8000026c <consoleread+0x100>
    cbuf = c;
    80000206:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020a:	4685                	li	a3,1
    8000020c:	f9f40613          	addi	a2,s0,-97
    80000210:	85d2                	mv	a1,s4
    80000212:	8556                	mv	a0,s5
    80000214:	00003097          	auipc	ra,0x3
    80000218:	818080e7          	jalr	-2024(ra) # 80002a2c <either_copyout>
    8000021c:	01850663          	beq	a0,s8,80000228 <consoleread+0xbc>
    dst++;
    80000220:	0a05                	addi	s4,s4,1
    --n;
    80000222:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000224:	f99d1ae3          	bne	s10,s9,800001b8 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	60850513          	addi	a0,a0,1544 # 80011830 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a80080e7          	jalr	-1408(ra) # 80000cb0 <release>

  return target - n;
    80000238:	413b053b          	subw	a0,s6,s3
    8000023c:	a811                	j	80000250 <consoleread+0xe4>
        release(&cons.lock);
    8000023e:	00011517          	auipc	a0,0x11
    80000242:	5f250513          	addi	a0,a0,1522 # 80011830 <cons>
    80000246:	00001097          	auipc	ra,0x1
    8000024a:	a6a080e7          	jalr	-1430(ra) # 80000cb0 <release>
        return -1;
    8000024e:	557d                	li	a0,-1
}
    80000250:	70a6                	ld	ra,104(sp)
    80000252:	7406                	ld	s0,96(sp)
    80000254:	64e6                	ld	s1,88(sp)
    80000256:	6946                	ld	s2,80(sp)
    80000258:	69a6                	ld	s3,72(sp)
    8000025a:	6a06                	ld	s4,64(sp)
    8000025c:	7ae2                	ld	s5,56(sp)
    8000025e:	7b42                	ld	s6,48(sp)
    80000260:	7ba2                	ld	s7,40(sp)
    80000262:	7c02                	ld	s8,32(sp)
    80000264:	6ce2                	ld	s9,24(sp)
    80000266:	6d42                	ld	s10,16(sp)
    80000268:	6165                	addi	sp,sp,112
    8000026a:	8082                	ret
      if(n < target){
    8000026c:	0009871b          	sext.w	a4,s3
    80000270:	fb677ce3          	bgeu	a4,s6,80000228 <consoleread+0xbc>
        cons.r--;
    80000274:	00011717          	auipc	a4,0x11
    80000278:	64f72a23          	sw	a5,1620(a4) # 800118c8 <cons+0x98>
    8000027c:	b775                	j	80000228 <consoleread+0xbc>

000000008000027e <consputc>:
{
    8000027e:	1141                	addi	sp,sp,-16
    80000280:	e406                	sd	ra,8(sp)
    80000282:	e022                	sd	s0,0(sp)
    80000284:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000286:	10000793          	li	a5,256
    8000028a:	00f50a63          	beq	a0,a5,8000029e <consputc+0x20>
    uartputc_sync(c);
    8000028e:	00000097          	auipc	ra,0x0
    80000292:	55e080e7          	jalr	1374(ra) # 800007ec <uartputc_sync>
}
    80000296:	60a2                	ld	ra,8(sp)
    80000298:	6402                	ld	s0,0(sp)
    8000029a:	0141                	addi	sp,sp,16
    8000029c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	54c080e7          	jalr	1356(ra) # 800007ec <uartputc_sync>
    800002a8:	02000513          	li	a0,32
    800002ac:	00000097          	auipc	ra,0x0
    800002b0:	540080e7          	jalr	1344(ra) # 800007ec <uartputc_sync>
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	536080e7          	jalr	1334(ra) # 800007ec <uartputc_sync>
    800002be:	bfe1                	j	80000296 <consputc+0x18>

00000000800002c0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c0:	1101                	addi	sp,sp,-32
    800002c2:	ec06                	sd	ra,24(sp)
    800002c4:	e822                	sd	s0,16(sp)
    800002c6:	e426                	sd	s1,8(sp)
    800002c8:	e04a                	sd	s2,0(sp)
    800002ca:	1000                	addi	s0,sp,32
    800002cc:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ce:	00011517          	auipc	a0,0x11
    800002d2:	56250513          	addi	a0,a0,1378 # 80011830 <cons>
    800002d6:	00001097          	auipc	ra,0x1
    800002da:	926080e7          	jalr	-1754(ra) # 80000bfc <acquire>

  switch(c){
    800002de:	47d5                	li	a5,21
    800002e0:	0af48663          	beq	s1,a5,8000038c <consoleintr+0xcc>
    800002e4:	0297ca63          	blt	a5,s1,80000318 <consoleintr+0x58>
    800002e8:	47a1                	li	a5,8
    800002ea:	0ef48763          	beq	s1,a5,800003d8 <consoleintr+0x118>
    800002ee:	47c1                	li	a5,16
    800002f0:	10f49a63          	bne	s1,a5,80000404 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f4:	00002097          	auipc	ra,0x2
    800002f8:	7e4080e7          	jalr	2020(ra) # 80002ad8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fc:	00011517          	auipc	a0,0x11
    80000300:	53450513          	addi	a0,a0,1332 # 80011830 <cons>
    80000304:	00001097          	auipc	ra,0x1
    80000308:	9ac080e7          	jalr	-1620(ra) # 80000cb0 <release>
}
    8000030c:	60e2                	ld	ra,24(sp)
    8000030e:	6442                	ld	s0,16(sp)
    80000310:	64a2                	ld	s1,8(sp)
    80000312:	6902                	ld	s2,0(sp)
    80000314:	6105                	addi	sp,sp,32
    80000316:	8082                	ret
  switch(c){
    80000318:	07f00793          	li	a5,127
    8000031c:	0af48e63          	beq	s1,a5,800003d8 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000320:	00011717          	auipc	a4,0x11
    80000324:	51070713          	addi	a4,a4,1296 # 80011830 <cons>
    80000328:	0a072783          	lw	a5,160(a4)
    8000032c:	09872703          	lw	a4,152(a4)
    80000330:	9f99                	subw	a5,a5,a4
    80000332:	07f00713          	li	a4,127
    80000336:	fcf763e3          	bltu	a4,a5,800002fc <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000033a:	47b5                	li	a5,13
    8000033c:	0cf48763          	beq	s1,a5,8000040a <consoleintr+0x14a>
      consputc(c);
    80000340:	8526                	mv	a0,s1
    80000342:	00000097          	auipc	ra,0x0
    80000346:	f3c080e7          	jalr	-196(ra) # 8000027e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000034a:	00011797          	auipc	a5,0x11
    8000034e:	4e678793          	addi	a5,a5,1254 # 80011830 <cons>
    80000352:	0a07a703          	lw	a4,160(a5)
    80000356:	0017069b          	addiw	a3,a4,1
    8000035a:	0006861b          	sext.w	a2,a3
    8000035e:	0ad7a023          	sw	a3,160(a5)
    80000362:	07f77713          	andi	a4,a4,127
    80000366:	97ba                	add	a5,a5,a4
    80000368:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000036c:	47a9                	li	a5,10
    8000036e:	0cf48563          	beq	s1,a5,80000438 <consoleintr+0x178>
    80000372:	4791                	li	a5,4
    80000374:	0cf48263          	beq	s1,a5,80000438 <consoleintr+0x178>
    80000378:	00011797          	auipc	a5,0x11
    8000037c:	5507a783          	lw	a5,1360(a5) # 800118c8 <cons+0x98>
    80000380:	0807879b          	addiw	a5,a5,128
    80000384:	f6f61ce3          	bne	a2,a5,800002fc <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000388:	863e                	mv	a2,a5
    8000038a:	a07d                	j	80000438 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038c:	00011717          	auipc	a4,0x11
    80000390:	4a470713          	addi	a4,a4,1188 # 80011830 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000039c:	00011497          	auipc	s1,0x11
    800003a0:	49448493          	addi	s1,s1,1172 # 80011830 <cons>
    while(cons.e != cons.w &&
    800003a4:	4929                	li	s2,10
    800003a6:	f4f70be3          	beq	a4,a5,800002fc <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003aa:	37fd                	addiw	a5,a5,-1
    800003ac:	07f7f713          	andi	a4,a5,127
    800003b0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b2:	01874703          	lbu	a4,24(a4)
    800003b6:	f52703e3          	beq	a4,s2,800002fc <consoleintr+0x3c>
      cons.e--;
    800003ba:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003be:	10000513          	li	a0,256
    800003c2:	00000097          	auipc	ra,0x0
    800003c6:	ebc080e7          	jalr	-324(ra) # 8000027e <consputc>
    while(cons.e != cons.w &&
    800003ca:	0a04a783          	lw	a5,160(s1)
    800003ce:	09c4a703          	lw	a4,156(s1)
    800003d2:	fcf71ce3          	bne	a4,a5,800003aa <consoleintr+0xea>
    800003d6:	b71d                	j	800002fc <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d8:	00011717          	auipc	a4,0x11
    800003dc:	45870713          	addi	a4,a4,1112 # 80011830 <cons>
    800003e0:	0a072783          	lw	a5,160(a4)
    800003e4:	09c72703          	lw	a4,156(a4)
    800003e8:	f0f70ae3          	beq	a4,a5,800002fc <consoleintr+0x3c>
      cons.e--;
    800003ec:	37fd                	addiw	a5,a5,-1
    800003ee:	00011717          	auipc	a4,0x11
    800003f2:	4ef72123          	sw	a5,1250(a4) # 800118d0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f6:	10000513          	li	a0,256
    800003fa:	00000097          	auipc	ra,0x0
    800003fe:	e84080e7          	jalr	-380(ra) # 8000027e <consputc>
    80000402:	bded                	j	800002fc <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000404:	ee048ce3          	beqz	s1,800002fc <consoleintr+0x3c>
    80000408:	bf21                	j	80000320 <consoleintr+0x60>
      consputc(c);
    8000040a:	4529                	li	a0,10
    8000040c:	00000097          	auipc	ra,0x0
    80000410:	e72080e7          	jalr	-398(ra) # 8000027e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000414:	00011797          	auipc	a5,0x11
    80000418:	41c78793          	addi	a5,a5,1052 # 80011830 <cons>
    8000041c:	0a07a703          	lw	a4,160(a5)
    80000420:	0017069b          	addiw	a3,a4,1
    80000424:	0006861b          	sext.w	a2,a3
    80000428:	0ad7a023          	sw	a3,160(a5)
    8000042c:	07f77713          	andi	a4,a4,127
    80000430:	97ba                	add	a5,a5,a4
    80000432:	4729                	li	a4,10
    80000434:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000438:	00011797          	auipc	a5,0x11
    8000043c:	48c7aa23          	sw	a2,1172(a5) # 800118cc <cons+0x9c>
        wakeup(&cons.r);
    80000440:	00011517          	auipc	a0,0x11
    80000444:	48850513          	addi	a0,a0,1160 # 800118c8 <cons+0x98>
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	4d4080e7          	jalr	1236(ra) # 8000291c <wakeup>
    80000450:	b575                	j	800002fc <consoleintr+0x3c>

0000000080000452 <consoleinit>:

void
consoleinit(void)
{
    80000452:	1141                	addi	sp,sp,-16
    80000454:	e406                	sd	ra,8(sp)
    80000456:	e022                	sd	s0,0(sp)
    80000458:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000045a:	00008597          	auipc	a1,0x8
    8000045e:	bb658593          	addi	a1,a1,-1098 # 80008010 <etext+0x10>
    80000462:	00011517          	auipc	a0,0x11
    80000466:	3ce50513          	addi	a0,a0,974 # 80011830 <cons>
    8000046a:	00000097          	auipc	ra,0x0
    8000046e:	702080e7          	jalr	1794(ra) # 80000b6c <initlock>

  uartinit();
    80000472:	00000097          	auipc	ra,0x0
    80000476:	32a080e7          	jalr	810(ra) # 8000079c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047a:	00022797          	auipc	a5,0x22
    8000047e:	17e78793          	addi	a5,a5,382 # 800225f8 <devsw>
    80000482:	00000717          	auipc	a4,0x0
    80000486:	cea70713          	addi	a4,a4,-790 # 8000016c <consoleread>
    8000048a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048c:	00000717          	auipc	a4,0x0
    80000490:	c5e70713          	addi	a4,a4,-930 # 800000ea <consolewrite>
    80000494:	ef98                	sd	a4,24(a5)
}
    80000496:	60a2                	ld	ra,8(sp)
    80000498:	6402                	ld	s0,0(sp)
    8000049a:	0141                	addi	sp,sp,16
    8000049c:	8082                	ret

000000008000049e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049e:	7179                	addi	sp,sp,-48
    800004a0:	f406                	sd	ra,40(sp)
    800004a2:	f022                	sd	s0,32(sp)
    800004a4:	ec26                	sd	s1,24(sp)
    800004a6:	e84a                	sd	s2,16(sp)
    800004a8:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004aa:	c219                	beqz	a2,800004b0 <printint+0x12>
    800004ac:	08054663          	bltz	a0,80000538 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b0:	2501                	sext.w	a0,a0
    800004b2:	4881                	li	a7,0
    800004b4:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004ba:	2581                	sext.w	a1,a1
    800004bc:	00008617          	auipc	a2,0x8
    800004c0:	b8460613          	addi	a2,a2,-1148 # 80008040 <digits>
    800004c4:	883a                	mv	a6,a4
    800004c6:	2705                	addiw	a4,a4,1
    800004c8:	02b577bb          	remuw	a5,a0,a1
    800004cc:	1782                	slli	a5,a5,0x20
    800004ce:	9381                	srli	a5,a5,0x20
    800004d0:	97b2                	add	a5,a5,a2
    800004d2:	0007c783          	lbu	a5,0(a5)
    800004d6:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004da:	0005079b          	sext.w	a5,a0
    800004de:	02b5553b          	divuw	a0,a0,a1
    800004e2:	0685                	addi	a3,a3,1
    800004e4:	feb7f0e3          	bgeu	a5,a1,800004c4 <printint+0x26>

  if(sign)
    800004e8:	00088b63          	beqz	a7,800004fe <printint+0x60>
    buf[i++] = '-';
    800004ec:	fe040793          	addi	a5,s0,-32
    800004f0:	973e                	add	a4,a4,a5
    800004f2:	02d00793          	li	a5,45
    800004f6:	fef70823          	sb	a5,-16(a4)
    800004fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fe:	02e05763          	blez	a4,8000052c <printint+0x8e>
    80000502:	fd040793          	addi	a5,s0,-48
    80000506:	00e784b3          	add	s1,a5,a4
    8000050a:	fff78913          	addi	s2,a5,-1
    8000050e:	993a                	add	s2,s2,a4
    80000510:	377d                	addiw	a4,a4,-1
    80000512:	1702                	slli	a4,a4,0x20
    80000514:	9301                	srli	a4,a4,0x20
    80000516:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051a:	fff4c503          	lbu	a0,-1(s1)
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	d60080e7          	jalr	-672(ra) # 8000027e <consputc>
  while(--i >= 0)
    80000526:	14fd                	addi	s1,s1,-1
    80000528:	ff2499e3          	bne	s1,s2,8000051a <printint+0x7c>
}
    8000052c:	70a2                	ld	ra,40(sp)
    8000052e:	7402                	ld	s0,32(sp)
    80000530:	64e2                	ld	s1,24(sp)
    80000532:	6942                	ld	s2,16(sp)
    80000534:	6145                	addi	sp,sp,48
    80000536:	8082                	ret
    x = -xx;
    80000538:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053c:	4885                	li	a7,1
    x = -xx;
    8000053e:	bf9d                	j	800004b4 <printint+0x16>

0000000080000540 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000540:	1101                	addi	sp,sp,-32
    80000542:	ec06                	sd	ra,24(sp)
    80000544:	e822                	sd	s0,16(sp)
    80000546:	e426                	sd	s1,8(sp)
    80000548:	1000                	addi	s0,sp,32
    8000054a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054c:	00011797          	auipc	a5,0x11
    80000550:	3a07a223          	sw	zero,932(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    80000554:	00008517          	auipc	a0,0x8
    80000558:	ac450513          	addi	a0,a0,-1340 # 80008018 <etext+0x18>
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	02e080e7          	jalr	46(ra) # 8000058a <printf>
  printf(s);
    80000564:	8526                	mv	a0,s1
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	024080e7          	jalr	36(ra) # 8000058a <printf>
  printf("\n");
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	cea50513          	addi	a0,a0,-790 # 80008258 <digits+0x218>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	014080e7          	jalr	20(ra) # 8000058a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057e:	4785                	li	a5,1
    80000580:	00009717          	auipc	a4,0x9
    80000584:	a8f72023          	sw	a5,-1408(a4) # 80009000 <panicked>
  for(;;)
    80000588:	a001                	j	80000588 <panic+0x48>

000000008000058a <printf>:
{
    8000058a:	7131                	addi	sp,sp,-192
    8000058c:	fc86                	sd	ra,120(sp)
    8000058e:	f8a2                	sd	s0,112(sp)
    80000590:	f4a6                	sd	s1,104(sp)
    80000592:	f0ca                	sd	s2,96(sp)
    80000594:	ecce                	sd	s3,88(sp)
    80000596:	e8d2                	sd	s4,80(sp)
    80000598:	e4d6                	sd	s5,72(sp)
    8000059a:	e0da                	sd	s6,64(sp)
    8000059c:	fc5e                	sd	s7,56(sp)
    8000059e:	f862                	sd	s8,48(sp)
    800005a0:	f466                	sd	s9,40(sp)
    800005a2:	f06a                	sd	s10,32(sp)
    800005a4:	ec6e                	sd	s11,24(sp)
    800005a6:	0100                	addi	s0,sp,128
    800005a8:	8a2a                	mv	s4,a0
    800005aa:	e40c                	sd	a1,8(s0)
    800005ac:	e810                	sd	a2,16(s0)
    800005ae:	ec14                	sd	a3,24(s0)
    800005b0:	f018                	sd	a4,32(s0)
    800005b2:	f41c                	sd	a5,40(s0)
    800005b4:	03043823          	sd	a6,48(s0)
    800005b8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005bc:	00011d97          	auipc	s11,0x11
    800005c0:	334dad83          	lw	s11,820(s11) # 800118f0 <pr+0x18>
  if(locking)
    800005c4:	020d9b63          	bnez	s11,800005fa <printf+0x70>
  if (fmt == 0)
    800005c8:	040a0263          	beqz	s4,8000060c <printf+0x82>
  va_start(ap, fmt);
    800005cc:	00840793          	addi	a5,s0,8
    800005d0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d4:	000a4503          	lbu	a0,0(s4)
    800005d8:	14050f63          	beqz	a0,80000736 <printf+0x1ac>
    800005dc:	4981                	li	s3,0
    if(c != '%'){
    800005de:	02500a93          	li	s5,37
    switch(c){
    800005e2:	07000b93          	li	s7,112
  consputc('x');
    800005e6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e8:	00008b17          	auipc	s6,0x8
    800005ec:	a58b0b13          	addi	s6,s6,-1448 # 80008040 <digits>
    switch(c){
    800005f0:	07300c93          	li	s9,115
    800005f4:	06400c13          	li	s8,100
    800005f8:	a82d                	j	80000632 <printf+0xa8>
    acquire(&pr.lock);
    800005fa:	00011517          	auipc	a0,0x11
    800005fe:	2de50513          	addi	a0,a0,734 # 800118d8 <pr>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	5fa080e7          	jalr	1530(ra) # 80000bfc <acquire>
    8000060a:	bf7d                	j	800005c8 <printf+0x3e>
    panic("null fmt");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a1c50513          	addi	a0,a0,-1508 # 80008028 <etext+0x28>
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f2c080e7          	jalr	-212(ra) # 80000540 <panic>
      consputc(c);
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	c62080e7          	jalr	-926(ra) # 8000027e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000624:	2985                	addiw	s3,s3,1
    80000626:	013a07b3          	add	a5,s4,s3
    8000062a:	0007c503          	lbu	a0,0(a5)
    8000062e:	10050463          	beqz	a0,80000736 <printf+0x1ac>
    if(c != '%'){
    80000632:	ff5515e3          	bne	a0,s5,8000061c <printf+0x92>
    c = fmt[++i] & 0xff;
    80000636:	2985                	addiw	s3,s3,1
    80000638:	013a07b3          	add	a5,s4,s3
    8000063c:	0007c783          	lbu	a5,0(a5)
    80000640:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000644:	cbed                	beqz	a5,80000736 <printf+0x1ac>
    switch(c){
    80000646:	05778a63          	beq	a5,s7,8000069a <printf+0x110>
    8000064a:	02fbf663          	bgeu	s7,a5,80000676 <printf+0xec>
    8000064e:	09978863          	beq	a5,s9,800006de <printf+0x154>
    80000652:	07800713          	li	a4,120
    80000656:	0ce79563          	bne	a5,a4,80000720 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000065a:	f8843783          	ld	a5,-120(s0)
    8000065e:	00878713          	addi	a4,a5,8
    80000662:	f8e43423          	sd	a4,-120(s0)
    80000666:	4605                	li	a2,1
    80000668:	85ea                	mv	a1,s10
    8000066a:	4388                	lw	a0,0(a5)
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	e32080e7          	jalr	-462(ra) # 8000049e <printint>
      break;
    80000674:	bf45                	j	80000624 <printf+0x9a>
    switch(c){
    80000676:	09578f63          	beq	a5,s5,80000714 <printf+0x18a>
    8000067a:	0b879363          	bne	a5,s8,80000720 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4605                	li	a2,1
    8000068c:	45a9                	li	a1,10
    8000068e:	4388                	lw	a0,0(a5)
    80000690:	00000097          	auipc	ra,0x0
    80000694:	e0e080e7          	jalr	-498(ra) # 8000049e <printint>
      break;
    80000698:	b771                	j	80000624 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	addi	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006aa:	03000513          	li	a0,48
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	bd0080e7          	jalr	-1072(ra) # 8000027e <consputc>
  consputc('x');
    800006b6:	07800513          	li	a0,120
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	bc4080e7          	jalr	-1084(ra) # 8000027e <consputc>
    800006c2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c4:	03c95793          	srli	a5,s2,0x3c
    800006c8:	97da                	add	a5,a5,s6
    800006ca:	0007c503          	lbu	a0,0(a5)
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	bb0080e7          	jalr	-1104(ra) # 8000027e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d6:	0912                	slli	s2,s2,0x4
    800006d8:	34fd                	addiw	s1,s1,-1
    800006da:	f4ed                	bnez	s1,800006c4 <printf+0x13a>
    800006dc:	b7a1                	j	80000624 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006de:	f8843783          	ld	a5,-120(s0)
    800006e2:	00878713          	addi	a4,a5,8
    800006e6:	f8e43423          	sd	a4,-120(s0)
    800006ea:	6384                	ld	s1,0(a5)
    800006ec:	cc89                	beqz	s1,80000706 <printf+0x17c>
      for(; *s; s++)
    800006ee:	0004c503          	lbu	a0,0(s1)
    800006f2:	d90d                	beqz	a0,80000624 <printf+0x9a>
        consputc(*s);
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b8a080e7          	jalr	-1142(ra) # 8000027e <consputc>
      for(; *s; s++)
    800006fc:	0485                	addi	s1,s1,1
    800006fe:	0004c503          	lbu	a0,0(s1)
    80000702:	f96d                	bnez	a0,800006f4 <printf+0x16a>
    80000704:	b705                	j	80000624 <printf+0x9a>
        s = "(null)";
    80000706:	00008497          	auipc	s1,0x8
    8000070a:	91a48493          	addi	s1,s1,-1766 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070e:	02800513          	li	a0,40
    80000712:	b7cd                	j	800006f4 <printf+0x16a>
      consputc('%');
    80000714:	8556                	mv	a0,s5
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b68080e7          	jalr	-1176(ra) # 8000027e <consputc>
      break;
    8000071e:	b719                	j	80000624 <printf+0x9a>
      consputc('%');
    80000720:	8556                	mv	a0,s5
    80000722:	00000097          	auipc	ra,0x0
    80000726:	b5c080e7          	jalr	-1188(ra) # 8000027e <consputc>
      consputc(c);
    8000072a:	8526                	mv	a0,s1
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b52080e7          	jalr	-1198(ra) # 8000027e <consputc>
      break;
    80000734:	bdc5                	j	80000624 <printf+0x9a>
  if(locking)
    80000736:	020d9163          	bnez	s11,80000758 <printf+0x1ce>
}
    8000073a:	70e6                	ld	ra,120(sp)
    8000073c:	7446                	ld	s0,112(sp)
    8000073e:	74a6                	ld	s1,104(sp)
    80000740:	7906                	ld	s2,96(sp)
    80000742:	69e6                	ld	s3,88(sp)
    80000744:	6a46                	ld	s4,80(sp)
    80000746:	6aa6                	ld	s5,72(sp)
    80000748:	6b06                	ld	s6,64(sp)
    8000074a:	7be2                	ld	s7,56(sp)
    8000074c:	7c42                	ld	s8,48(sp)
    8000074e:	7ca2                	ld	s9,40(sp)
    80000750:	7d02                	ld	s10,32(sp)
    80000752:	6de2                	ld	s11,24(sp)
    80000754:	6129                	addi	sp,sp,192
    80000756:	8082                	ret
    release(&pr.lock);
    80000758:	00011517          	auipc	a0,0x11
    8000075c:	18050513          	addi	a0,a0,384 # 800118d8 <pr>
    80000760:	00000097          	auipc	ra,0x0
    80000764:	550080e7          	jalr	1360(ra) # 80000cb0 <release>
}
    80000768:	bfc9                	j	8000073a <printf+0x1b0>

000000008000076a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000774:	00011497          	auipc	s1,0x11
    80000778:	16448493          	addi	s1,s1,356 # 800118d8 <pr>
    8000077c:	00008597          	auipc	a1,0x8
    80000780:	8bc58593          	addi	a1,a1,-1860 # 80008038 <etext+0x38>
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	3e6080e7          	jalr	998(ra) # 80000b6c <initlock>
  pr.locking = 1;
    8000078e:	4785                	li	a5,1
    80000790:	cc9c                	sw	a5,24(s1)
}
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret

000000008000079c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079c:	1141                	addi	sp,sp,-16
    8000079e:	e406                	sd	ra,8(sp)
    800007a0:	e022                	sd	s0,0(sp)
    800007a2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a4:	100007b7          	lui	a5,0x10000
    800007a8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ac:	f8000713          	li	a4,-128
    800007b0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b4:	470d                	li	a4,3
    800007b6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007be:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c2:	469d                	li	a3,7
    800007c4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007cc:	00008597          	auipc	a1,0x8
    800007d0:	88c58593          	addi	a1,a1,-1908 # 80008058 <digits+0x18>
    800007d4:	00011517          	auipc	a0,0x11
    800007d8:	12450513          	addi	a0,a0,292 # 800118f8 <uart_tx_lock>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	390080e7          	jalr	912(ra) # 80000b6c <initlock>
}
    800007e4:	60a2                	ld	ra,8(sp)
    800007e6:	6402                	ld	s0,0(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret

00000000800007ec <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ec:	1101                	addi	sp,sp,-32
    800007ee:	ec06                	sd	ra,24(sp)
    800007f0:	e822                	sd	s0,16(sp)
    800007f2:	e426                	sd	s1,8(sp)
    800007f4:	1000                	addi	s0,sp,32
    800007f6:	84aa                	mv	s1,a0
  push_off();
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	3b8080e7          	jalr	952(ra) # 80000bb0 <push_off>

  if(panicked){
    80000800:	00009797          	auipc	a5,0x9
    80000804:	8007a783          	lw	a5,-2048(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000808:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080c:	c391                	beqz	a5,80000810 <uartputc_sync+0x24>
    for(;;)
    8000080e:	a001                	j	8000080e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000810:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dfe5                	beqz	a5,80000810 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000081a:	0ff4f513          	andi	a0,s1,255
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	42a080e7          	jalr	1066(ra) # 80000c50 <pop_off>
}
    8000082e:	60e2                	ld	ra,24(sp)
    80000830:	6442                	ld	s0,16(sp)
    80000832:	64a2                	ld	s1,8(sp)
    80000834:	6105                	addi	sp,sp,32
    80000836:	8082                	ret

0000000080000838 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000838:	00008797          	auipc	a5,0x8
    8000083c:	7cc7a783          	lw	a5,1996(a5) # 80009004 <uart_tx_r>
    80000840:	00008717          	auipc	a4,0x8
    80000844:	7c872703          	lw	a4,1992(a4) # 80009008 <uart_tx_w>
    80000848:	08f70063          	beq	a4,a5,800008c8 <uartstart+0x90>
{
    8000084c:	7139                	addi	sp,sp,-64
    8000084e:	fc06                	sd	ra,56(sp)
    80000850:	f822                	sd	s0,48(sp)
    80000852:	f426                	sd	s1,40(sp)
    80000854:	f04a                	sd	s2,32(sp)
    80000856:	ec4e                	sd	s3,24(sp)
    80000858:	e852                	sd	s4,16(sp)
    8000085a:	e456                	sd	s5,8(sp)
    8000085c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    80000862:	00011a97          	auipc	s5,0x11
    80000866:	096a8a93          	addi	s5,s5,150 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000086a:	00008497          	auipc	s1,0x8
    8000086e:	79a48493          	addi	s1,s1,1946 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000872:	00008a17          	auipc	s4,0x8
    80000876:	796a0a13          	addi	s4,s4,1942 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087e:	02077713          	andi	a4,a4,32
    80000882:	cb15                	beqz	a4,800008b6 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r];
    80000884:	00fa8733          	add	a4,s5,a5
    80000888:	01874983          	lbu	s3,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000088c:	2785                	addiw	a5,a5,1
    8000088e:	41f7d71b          	sraiw	a4,a5,0x1f
    80000892:	01b7571b          	srliw	a4,a4,0x1b
    80000896:	9fb9                	addw	a5,a5,a4
    80000898:	8bfd                	andi	a5,a5,31
    8000089a:	9f99                	subw	a5,a5,a4
    8000089c:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000089e:	8526                	mv	a0,s1
    800008a0:	00002097          	auipc	ra,0x2
    800008a4:	07c080e7          	jalr	124(ra) # 8000291c <wakeup>
    
    WriteReg(THR, c);
    800008a8:	01390023          	sb	s3,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008ac:	409c                	lw	a5,0(s1)
    800008ae:	000a2703          	lw	a4,0(s4)
    800008b2:	fcf714e3          	bne	a4,a5,8000087a <uartstart+0x42>
  }
}
    800008b6:	70e2                	ld	ra,56(sp)
    800008b8:	7442                	ld	s0,48(sp)
    800008ba:	74a2                	ld	s1,40(sp)
    800008bc:	7902                	ld	s2,32(sp)
    800008be:	69e2                	ld	s3,24(sp)
    800008c0:	6a42                	ld	s4,16(sp)
    800008c2:	6aa2                	ld	s5,8(sp)
    800008c4:	6121                	addi	sp,sp,64
    800008c6:	8082                	ret
    800008c8:	8082                	ret

00000000800008ca <uartputc>:
{
    800008ca:	7179                	addi	sp,sp,-48
    800008cc:	f406                	sd	ra,40(sp)
    800008ce:	f022                	sd	s0,32(sp)
    800008d0:	ec26                	sd	s1,24(sp)
    800008d2:	e84a                	sd	s2,16(sp)
    800008d4:	e44e                	sd	s3,8(sp)
    800008d6:	e052                	sd	s4,0(sp)
    800008d8:	1800                	addi	s0,sp,48
    800008da:	84aa                	mv	s1,a0
  acquire(&uart_tx_lock);
    800008dc:	00011517          	auipc	a0,0x11
    800008e0:	01c50513          	addi	a0,a0,28 # 800118f8 <uart_tx_lock>
    800008e4:	00000097          	auipc	ra,0x0
    800008e8:	318080e7          	jalr	792(ra) # 80000bfc <acquire>
  if(panicked){
    800008ec:	00008797          	auipc	a5,0x8
    800008f0:	7147a783          	lw	a5,1812(a5) # 80009000 <panicked>
    800008f4:	c391                	beqz	a5,800008f8 <uartputc+0x2e>
    for(;;)
    800008f6:	a001                	j	800008f6 <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    800008f8:	00008697          	auipc	a3,0x8
    800008fc:	7106a683          	lw	a3,1808(a3) # 80009008 <uart_tx_w>
    80000900:	0016879b          	addiw	a5,a3,1
    80000904:	41f7d71b          	sraiw	a4,a5,0x1f
    80000908:	01b7571b          	srliw	a4,a4,0x1b
    8000090c:	9fb9                	addw	a5,a5,a4
    8000090e:	8bfd                	andi	a5,a5,31
    80000910:	9f99                	subw	a5,a5,a4
    80000912:	00008717          	auipc	a4,0x8
    80000916:	6f272703          	lw	a4,1778(a4) # 80009004 <uart_tx_r>
    8000091a:	04f71363          	bne	a4,a5,80000960 <uartputc+0x96>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000091e:	00011a17          	auipc	s4,0x11
    80000922:	fdaa0a13          	addi	s4,s4,-38 # 800118f8 <uart_tx_lock>
    80000926:	00008917          	auipc	s2,0x8
    8000092a:	6de90913          	addi	s2,s2,1758 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000092e:	00008997          	auipc	s3,0x8
    80000932:	6da98993          	addi	s3,s3,1754 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000936:	85d2                	mv	a1,s4
    80000938:	854a                	mv	a0,s2
    8000093a:	00002097          	auipc	ra,0x2
    8000093e:	e62080e7          	jalr	-414(ra) # 8000279c <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000942:	0009a683          	lw	a3,0(s3)
    80000946:	0016879b          	addiw	a5,a3,1
    8000094a:	41f7d71b          	sraiw	a4,a5,0x1f
    8000094e:	01b7571b          	srliw	a4,a4,0x1b
    80000952:	9fb9                	addw	a5,a5,a4
    80000954:	8bfd                	andi	a5,a5,31
    80000956:	9f99                	subw	a5,a5,a4
    80000958:	00092703          	lw	a4,0(s2)
    8000095c:	fcf70de3          	beq	a4,a5,80000936 <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    80000960:	00011917          	auipc	s2,0x11
    80000964:	f9890913          	addi	s2,s2,-104 # 800118f8 <uart_tx_lock>
    80000968:	96ca                	add	a3,a3,s2
    8000096a:	00968c23          	sb	s1,24(a3)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    8000096e:	00008717          	auipc	a4,0x8
    80000972:	68f72d23          	sw	a5,1690(a4) # 80009008 <uart_tx_w>
      uartstart();
    80000976:	00000097          	auipc	ra,0x0
    8000097a:	ec2080e7          	jalr	-318(ra) # 80000838 <uartstart>
      release(&uart_tx_lock);
    8000097e:	854a                	mv	a0,s2
    80000980:	00000097          	auipc	ra,0x0
    80000984:	330080e7          	jalr	816(ra) # 80000cb0 <release>
}
    80000988:	70a2                	ld	ra,40(sp)
    8000098a:	7402                	ld	s0,32(sp)
    8000098c:	64e2                	ld	s1,24(sp)
    8000098e:	6942                	ld	s2,16(sp)
    80000990:	69a2                	ld	s3,8(sp)
    80000992:	6a02                	ld	s4,0(sp)
    80000994:	6145                	addi	sp,sp,48
    80000996:	8082                	ret

0000000080000998 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000998:	1141                	addi	sp,sp,-16
    8000099a:	e422                	sd	s0,8(sp)
    8000099c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000099e:	100007b7          	lui	a5,0x10000
    800009a2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009a6:	8b85                	andi	a5,a5,1
    800009a8:	cb91                	beqz	a5,800009bc <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009aa:	100007b7          	lui	a5,0x10000
    800009ae:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009b2:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009b6:	6422                	ld	s0,8(sp)
    800009b8:	0141                	addi	sp,sp,16
    800009ba:	8082                	ret
    return -1;
    800009bc:	557d                	li	a0,-1
    800009be:	bfe5                	j	800009b6 <uartgetc+0x1e>

00000000800009c0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009c0:	1101                	addi	sp,sp,-32
    800009c2:	ec06                	sd	ra,24(sp)
    800009c4:	e822                	sd	s0,16(sp)
    800009c6:	e426                	sd	s1,8(sp)
    800009c8:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009ca:	54fd                	li	s1,-1
    800009cc:	a029                	j	800009d6 <uartintr+0x16>
      break;
    consoleintr(c);
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	8f2080e7          	jalr	-1806(ra) # 800002c0 <consoleintr>
    int c = uartgetc();
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	fc2080e7          	jalr	-62(ra) # 80000998 <uartgetc>
    if(c == -1)
    800009de:	fe9518e3          	bne	a0,s1,800009ce <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009e2:	00011497          	auipc	s1,0x11
    800009e6:	f1648493          	addi	s1,s1,-234 # 800118f8 <uart_tx_lock>
    800009ea:	8526                	mv	a0,s1
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	210080e7          	jalr	528(ra) # 80000bfc <acquire>
  uartstart();
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	e44080e7          	jalr	-444(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    800009fc:	8526                	mv	a0,s1
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	2b2080e7          	jalr	690(ra) # 80000cb0 <release>
}
    80000a06:	60e2                	ld	ra,24(sp)
    80000a08:	6442                	ld	s0,16(sp)
    80000a0a:	64a2                	ld	s1,8(sp)
    80000a0c:	6105                	addi	sp,sp,32
    80000a0e:	8082                	ret

0000000080000a10 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a10:	1101                	addi	sp,sp,-32
    80000a12:	ec06                	sd	ra,24(sp)
    80000a14:	e822                	sd	s0,16(sp)
    80000a16:	e426                	sd	s1,8(sp)
    80000a18:	e04a                	sd	s2,0(sp)
    80000a1a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a1c:	03451793          	slli	a5,a0,0x34
    80000a20:	ebb9                	bnez	a5,80000a76 <kfree+0x66>
    80000a22:	84aa                	mv	s1,a0
    80000a24:	00026797          	auipc	a5,0x26
    80000a28:	5dc78793          	addi	a5,a5,1500 # 80027000 <end>
    80000a2c:	04f56563          	bltu	a0,a5,80000a76 <kfree+0x66>
    80000a30:	47c5                	li	a5,17
    80000a32:	07ee                	slli	a5,a5,0x1b
    80000a34:	04f57163          	bgeu	a0,a5,80000a76 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a38:	6605                	lui	a2,0x1
    80000a3a:	4585                	li	a1,1
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	2bc080e7          	jalr	700(ra) # 80000cf8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a44:	00011917          	auipc	s2,0x11
    80000a48:	eec90913          	addi	s2,s2,-276 # 80011930 <kmem>
    80000a4c:	854a                	mv	a0,s2
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	1ae080e7          	jalr	430(ra) # 80000bfc <acquire>
  r->next = kmem.freelist;
    80000a56:	01893783          	ld	a5,24(s2)
    80000a5a:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a5c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a60:	854a                	mv	a0,s2
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	24e080e7          	jalr	590(ra) # 80000cb0 <release>
}
    80000a6a:	60e2                	ld	ra,24(sp)
    80000a6c:	6442                	ld	s0,16(sp)
    80000a6e:	64a2                	ld	s1,8(sp)
    80000a70:	6902                	ld	s2,0(sp)
    80000a72:	6105                	addi	sp,sp,32
    80000a74:	8082                	ret
    panic("kfree");
    80000a76:	00007517          	auipc	a0,0x7
    80000a7a:	5ea50513          	addi	a0,a0,1514 # 80008060 <digits+0x20>
    80000a7e:	00000097          	auipc	ra,0x0
    80000a82:	ac2080e7          	jalr	-1342(ra) # 80000540 <panic>

0000000080000a86 <freerange>:
{
    80000a86:	7179                	addi	sp,sp,-48
    80000a88:	f406                	sd	ra,40(sp)
    80000a8a:	f022                	sd	s0,32(sp)
    80000a8c:	ec26                	sd	s1,24(sp)
    80000a8e:	e84a                	sd	s2,16(sp)
    80000a90:	e44e                	sd	s3,8(sp)
    80000a92:	e052                	sd	s4,0(sp)
    80000a94:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a96:	6785                	lui	a5,0x1
    80000a98:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a9c:	94aa                	add	s1,s1,a0
    80000a9e:	757d                	lui	a0,0xfffff
    80000aa0:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aa2:	94be                	add	s1,s1,a5
    80000aa4:	0095ee63          	bltu	a1,s1,80000ac0 <freerange+0x3a>
    80000aa8:	892e                	mv	s2,a1
    kfree(p);
    80000aaa:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aac:	6985                	lui	s3,0x1
    kfree(p);
    80000aae:	01448533          	add	a0,s1,s4
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	f5e080e7          	jalr	-162(ra) # 80000a10 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aba:	94ce                	add	s1,s1,s3
    80000abc:	fe9979e3          	bgeu	s2,s1,80000aae <freerange+0x28>
}
    80000ac0:	70a2                	ld	ra,40(sp)
    80000ac2:	7402                	ld	s0,32(sp)
    80000ac4:	64e2                	ld	s1,24(sp)
    80000ac6:	6942                	ld	s2,16(sp)
    80000ac8:	69a2                	ld	s3,8(sp)
    80000aca:	6a02                	ld	s4,0(sp)
    80000acc:	6145                	addi	sp,sp,48
    80000ace:	8082                	ret

0000000080000ad0 <kinit>:
{
    80000ad0:	1141                	addi	sp,sp,-16
    80000ad2:	e406                	sd	ra,8(sp)
    80000ad4:	e022                	sd	s0,0(sp)
    80000ad6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ad8:	00007597          	auipc	a1,0x7
    80000adc:	59058593          	addi	a1,a1,1424 # 80008068 <digits+0x28>
    80000ae0:	00011517          	auipc	a0,0x11
    80000ae4:	e5050513          	addi	a0,a0,-432 # 80011930 <kmem>
    80000ae8:	00000097          	auipc	ra,0x0
    80000aec:	084080e7          	jalr	132(ra) # 80000b6c <initlock>
  freerange(end, (void*)PHYSTOP);
    80000af0:	45c5                	li	a1,17
    80000af2:	05ee                	slli	a1,a1,0x1b
    80000af4:	00026517          	auipc	a0,0x26
    80000af8:	50c50513          	addi	a0,a0,1292 # 80027000 <end>
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	f8a080e7          	jalr	-118(ra) # 80000a86 <freerange>
}
    80000b04:	60a2                	ld	ra,8(sp)
    80000b06:	6402                	ld	s0,0(sp)
    80000b08:	0141                	addi	sp,sp,16
    80000b0a:	8082                	ret

0000000080000b0c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b0c:	1101                	addi	sp,sp,-32
    80000b0e:	ec06                	sd	ra,24(sp)
    80000b10:	e822                	sd	s0,16(sp)
    80000b12:	e426                	sd	s1,8(sp)
    80000b14:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b16:	00011497          	auipc	s1,0x11
    80000b1a:	e1a48493          	addi	s1,s1,-486 # 80011930 <kmem>
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	0dc080e7          	jalr	220(ra) # 80000bfc <acquire>
  r = kmem.freelist;
    80000b28:	6c84                	ld	s1,24(s1)
  if(r)
    80000b2a:	c885                	beqz	s1,80000b5a <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b2c:	609c                	ld	a5,0(s1)
    80000b2e:	00011517          	auipc	a0,0x11
    80000b32:	e0250513          	addi	a0,a0,-510 # 80011930 <kmem>
    80000b36:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	178080e7          	jalr	376(ra) # 80000cb0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b40:	6605                	lui	a2,0x1
    80000b42:	4595                	li	a1,5
    80000b44:	8526                	mv	a0,s1
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	1b2080e7          	jalr	434(ra) # 80000cf8 <memset>
  return (void*)r;
}
    80000b4e:	8526                	mv	a0,s1
    80000b50:	60e2                	ld	ra,24(sp)
    80000b52:	6442                	ld	s0,16(sp)
    80000b54:	64a2                	ld	s1,8(sp)
    80000b56:	6105                	addi	sp,sp,32
    80000b58:	8082                	ret
  release(&kmem.lock);
    80000b5a:	00011517          	auipc	a0,0x11
    80000b5e:	dd650513          	addi	a0,a0,-554 # 80011930 <kmem>
    80000b62:	00000097          	auipc	ra,0x0
    80000b66:	14e080e7          	jalr	334(ra) # 80000cb0 <release>
  if(r)
    80000b6a:	b7d5                	j	80000b4e <kalloc+0x42>

0000000080000b6c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b6c:	1141                	addi	sp,sp,-16
    80000b6e:	e422                	sd	s0,8(sp)
    80000b70:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b72:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b74:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b78:	00053823          	sd	zero,16(a0)
}
    80000b7c:	6422                	ld	s0,8(sp)
    80000b7e:	0141                	addi	sp,sp,16
    80000b80:	8082                	ret

0000000080000b82 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b82:	411c                	lw	a5,0(a0)
    80000b84:	e399                	bnez	a5,80000b8a <holding+0x8>
    80000b86:	4501                	li	a0,0
  return r;
}
    80000b88:	8082                	ret
{
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b94:	6904                	ld	s1,16(a0)
    80000b96:	00001097          	auipc	ra,0x1
    80000b9a:	36a080e7          	jalr	874(ra) # 80001f00 <mycpu>
    80000b9e:	40a48533          	sub	a0,s1,a0
    80000ba2:	00153513          	seqz	a0,a0
}
    80000ba6:	60e2                	ld	ra,24(sp)
    80000ba8:	6442                	ld	s0,16(sp)
    80000baa:	64a2                	ld	s1,8(sp)
    80000bac:	6105                	addi	sp,sp,32
    80000bae:	8082                	ret

0000000080000bb0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb0:	1101                	addi	sp,sp,-32
    80000bb2:	ec06                	sd	ra,24(sp)
    80000bb4:	e822                	sd	s0,16(sp)
    80000bb6:	e426                	sd	s1,8(sp)
    80000bb8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bba:	100024f3          	csrr	s1,sstatus
    80000bbe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bc8:	00001097          	auipc	ra,0x1
    80000bcc:	338080e7          	jalr	824(ra) # 80001f00 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cf89                	beqz	a5,80000bec <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	00001097          	auipc	ra,0x1
    80000bd8:	32c080e7          	jalr	812(ra) # 80001f00 <mycpu>
    80000bdc:	5d3c                	lw	a5,120(a0)
    80000bde:	2785                	addiw	a5,a5,1
    80000be0:	dd3c                	sw	a5,120(a0)
}
    80000be2:	60e2                	ld	ra,24(sp)
    80000be4:	6442                	ld	s0,16(sp)
    80000be6:	64a2                	ld	s1,8(sp)
    80000be8:	6105                	addi	sp,sp,32
    80000bea:	8082                	ret
    mycpu()->intena = old;
    80000bec:	00001097          	auipc	ra,0x1
    80000bf0:	314080e7          	jalr	788(ra) # 80001f00 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bf4:	8085                	srli	s1,s1,0x1
    80000bf6:	8885                	andi	s1,s1,1
    80000bf8:	dd64                	sw	s1,124(a0)
    80000bfa:	bfe9                	j	80000bd4 <push_off+0x24>

0000000080000bfc <acquire>:
{
    80000bfc:	1101                	addi	sp,sp,-32
    80000bfe:	ec06                	sd	ra,24(sp)
    80000c00:	e822                	sd	s0,16(sp)
    80000c02:	e426                	sd	s1,8(sp)
    80000c04:	1000                	addi	s0,sp,32
    80000c06:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c08:	00000097          	auipc	ra,0x0
    80000c0c:	fa8080e7          	jalr	-88(ra) # 80000bb0 <push_off>
  if(holding(lk))
    80000c10:	8526                	mv	a0,s1
    80000c12:	00000097          	auipc	ra,0x0
    80000c16:	f70080e7          	jalr	-144(ra) # 80000b82 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c1a:	4705                	li	a4,1
  if(holding(lk))
    80000c1c:	e115                	bnez	a0,80000c40 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c1e:	87ba                	mv	a5,a4
    80000c20:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c24:	2781                	sext.w	a5,a5
    80000c26:	ffe5                	bnez	a5,80000c1e <acquire+0x22>
  __sync_synchronize();
    80000c28:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c2c:	00001097          	auipc	ra,0x1
    80000c30:	2d4080e7          	jalr	724(ra) # 80001f00 <mycpu>
    80000c34:	e888                	sd	a0,16(s1)
}
    80000c36:	60e2                	ld	ra,24(sp)
    80000c38:	6442                	ld	s0,16(sp)
    80000c3a:	64a2                	ld	s1,8(sp)
    80000c3c:	6105                	addi	sp,sp,32
    80000c3e:	8082                	ret
    panic("acquire");
    80000c40:	00007517          	auipc	a0,0x7
    80000c44:	43050513          	addi	a0,a0,1072 # 80008070 <digits+0x30>
    80000c48:	00000097          	auipc	ra,0x0
    80000c4c:	8f8080e7          	jalr	-1800(ra) # 80000540 <panic>

0000000080000c50 <pop_off>:

void
pop_off(void)
{
    80000c50:	1141                	addi	sp,sp,-16
    80000c52:	e406                	sd	ra,8(sp)
    80000c54:	e022                	sd	s0,0(sp)
    80000c56:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c58:	00001097          	auipc	ra,0x1
    80000c5c:	2a8080e7          	jalr	680(ra) # 80001f00 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c64:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c66:	e78d                	bnez	a5,80000c90 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c68:	5d3c                	lw	a5,120(a0)
    80000c6a:	02f05b63          	blez	a5,80000ca0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c6e:	37fd                	addiw	a5,a5,-1
    80000c70:	0007871b          	sext.w	a4,a5
    80000c74:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c76:	eb09                	bnez	a4,80000c88 <pop_off+0x38>
    80000c78:	5d7c                	lw	a5,124(a0)
    80000c7a:	c799                	beqz	a5,80000c88 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c80:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c84:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c88:	60a2                	ld	ra,8(sp)
    80000c8a:	6402                	ld	s0,0(sp)
    80000c8c:	0141                	addi	sp,sp,16
    80000c8e:	8082                	ret
    panic("pop_off - interruptible");
    80000c90:	00007517          	auipc	a0,0x7
    80000c94:	3e850513          	addi	a0,a0,1000 # 80008078 <digits+0x38>
    80000c98:	00000097          	auipc	ra,0x0
    80000c9c:	8a8080e7          	jalr	-1880(ra) # 80000540 <panic>
    panic("pop_off");
    80000ca0:	00007517          	auipc	a0,0x7
    80000ca4:	3f050513          	addi	a0,a0,1008 # 80008090 <digits+0x50>
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	898080e7          	jalr	-1896(ra) # 80000540 <panic>

0000000080000cb0 <release>:
{
    80000cb0:	1101                	addi	sp,sp,-32
    80000cb2:	ec06                	sd	ra,24(sp)
    80000cb4:	e822                	sd	s0,16(sp)
    80000cb6:	e426                	sd	s1,8(sp)
    80000cb8:	1000                	addi	s0,sp,32
    80000cba:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	ec6080e7          	jalr	-314(ra) # 80000b82 <holding>
    80000cc4:	c115                	beqz	a0,80000ce8 <release+0x38>
  lk->cpu = 0;
    80000cc6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cca:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cce:	0f50000f          	fence	iorw,ow
    80000cd2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	f7a080e7          	jalr	-134(ra) # 80000c50 <pop_off>
}
    80000cde:	60e2                	ld	ra,24(sp)
    80000ce0:	6442                	ld	s0,16(sp)
    80000ce2:	64a2                	ld	s1,8(sp)
    80000ce4:	6105                	addi	sp,sp,32
    80000ce6:	8082                	ret
    panic("release");
    80000ce8:	00007517          	auipc	a0,0x7
    80000cec:	3b050513          	addi	a0,a0,944 # 80008098 <digits+0x58>
    80000cf0:	00000097          	auipc	ra,0x0
    80000cf4:	850080e7          	jalr	-1968(ra) # 80000540 <panic>

0000000080000cf8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e422                	sd	s0,8(sp)
    80000cfc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cfe:	ca19                	beqz	a2,80000d14 <memset+0x1c>
    80000d00:	87aa                	mv	a5,a0
    80000d02:	1602                	slli	a2,a2,0x20
    80000d04:	9201                	srli	a2,a2,0x20
    80000d06:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d0e:	0785                	addi	a5,a5,1
    80000d10:	fee79de3          	bne	a5,a4,80000d0a <memset+0x12>
  }
  return dst;
}
    80000d14:	6422                	ld	s0,8(sp)
    80000d16:	0141                	addi	sp,sp,16
    80000d18:	8082                	ret

0000000080000d1a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1a:	1141                	addi	sp,sp,-16
    80000d1c:	e422                	sd	s0,8(sp)
    80000d1e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d20:	ca05                	beqz	a2,80000d50 <memcmp+0x36>
    80000d22:	fff6069b          	addiw	a3,a2,-1
    80000d26:	1682                	slli	a3,a3,0x20
    80000d28:	9281                	srli	a3,a3,0x20
    80000d2a:	0685                	addi	a3,a3,1
    80000d2c:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d2e:	00054783          	lbu	a5,0(a0)
    80000d32:	0005c703          	lbu	a4,0(a1)
    80000d36:	00e79863          	bne	a5,a4,80000d46 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d3a:	0505                	addi	a0,a0,1
    80000d3c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d3e:	fed518e3          	bne	a0,a3,80000d2e <memcmp+0x14>
  }

  return 0;
    80000d42:	4501                	li	a0,0
    80000d44:	a019                	j	80000d4a <memcmp+0x30>
      return *s1 - *s2;
    80000d46:	40e7853b          	subw	a0,a5,a4
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  return 0;
    80000d50:	4501                	li	a0,0
    80000d52:	bfe5                	j	80000d4a <memcmp+0x30>

0000000080000d54 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d54:	1141                	addi	sp,sp,-16
    80000d56:	e422                	sd	s0,8(sp)
    80000d58:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d5a:	02a5e563          	bltu	a1,a0,80000d84 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d5e:	fff6069b          	addiw	a3,a2,-1
    80000d62:	ce11                	beqz	a2,80000d7e <memmove+0x2a>
    80000d64:	1682                	slli	a3,a3,0x20
    80000d66:	9281                	srli	a3,a3,0x20
    80000d68:	0685                	addi	a3,a3,1
    80000d6a:	96ae                	add	a3,a3,a1
    80000d6c:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d6e:	0585                	addi	a1,a1,1
    80000d70:	0785                	addi	a5,a5,1
    80000d72:	fff5c703          	lbu	a4,-1(a1)
    80000d76:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d7a:	fed59ae3          	bne	a1,a3,80000d6e <memmove+0x1a>

  return dst;
}
    80000d7e:	6422                	ld	s0,8(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret
  if(s < d && s + n > d){
    80000d84:	02061713          	slli	a4,a2,0x20
    80000d88:	9301                	srli	a4,a4,0x20
    80000d8a:	00e587b3          	add	a5,a1,a4
    80000d8e:	fcf578e3          	bgeu	a0,a5,80000d5e <memmove+0xa>
    d += n;
    80000d92:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d94:	fff6069b          	addiw	a3,a2,-1
    80000d98:	d27d                	beqz	a2,80000d7e <memmove+0x2a>
    80000d9a:	02069613          	slli	a2,a3,0x20
    80000d9e:	9201                	srli	a2,a2,0x20
    80000da0:	fff64613          	not	a2,a2
    80000da4:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000da6:	17fd                	addi	a5,a5,-1
    80000da8:	177d                	addi	a4,a4,-1
    80000daa:	0007c683          	lbu	a3,0(a5)
    80000dae:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000db2:	fef61ae3          	bne	a2,a5,80000da6 <memmove+0x52>
    80000db6:	b7e1                	j	80000d7e <memmove+0x2a>

0000000080000db8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000db8:	1141                	addi	sp,sp,-16
    80000dba:	e406                	sd	ra,8(sp)
    80000dbc:	e022                	sd	s0,0(sp)
    80000dbe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dc0:	00000097          	auipc	ra,0x0
    80000dc4:	f94080e7          	jalr	-108(ra) # 80000d54 <memmove>
}
    80000dc8:	60a2                	ld	ra,8(sp)
    80000dca:	6402                	ld	s0,0(sp)
    80000dcc:	0141                	addi	sp,sp,16
    80000dce:	8082                	ret

0000000080000dd0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dd0:	1141                	addi	sp,sp,-16
    80000dd2:	e422                	sd	s0,8(sp)
    80000dd4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dd6:	ce11                	beqz	a2,80000df2 <strncmp+0x22>
    80000dd8:	00054783          	lbu	a5,0(a0)
    80000ddc:	cf89                	beqz	a5,80000df6 <strncmp+0x26>
    80000dde:	0005c703          	lbu	a4,0(a1)
    80000de2:	00f71a63          	bne	a4,a5,80000df6 <strncmp+0x26>
    n--, p++, q++;
    80000de6:	367d                	addiw	a2,a2,-1
    80000de8:	0505                	addi	a0,a0,1
    80000dea:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dec:	f675                	bnez	a2,80000dd8 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dee:	4501                	li	a0,0
    80000df0:	a809                	j	80000e02 <strncmp+0x32>
    80000df2:	4501                	li	a0,0
    80000df4:	a039                	j	80000e02 <strncmp+0x32>
  if(n == 0)
    80000df6:	ca09                	beqz	a2,80000e08 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000df8:	00054503          	lbu	a0,0(a0)
    80000dfc:	0005c783          	lbu	a5,0(a1)
    80000e00:	9d1d                	subw	a0,a0,a5
}
    80000e02:	6422                	ld	s0,8(sp)
    80000e04:	0141                	addi	sp,sp,16
    80000e06:	8082                	ret
    return 0;
    80000e08:	4501                	li	a0,0
    80000e0a:	bfe5                	j	80000e02 <strncmp+0x32>

0000000080000e0c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e0c:	1141                	addi	sp,sp,-16
    80000e0e:	e422                	sd	s0,8(sp)
    80000e10:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e12:	872a                	mv	a4,a0
    80000e14:	8832                	mv	a6,a2
    80000e16:	367d                	addiw	a2,a2,-1
    80000e18:	01005963          	blez	a6,80000e2a <strncpy+0x1e>
    80000e1c:	0705                	addi	a4,a4,1
    80000e1e:	0005c783          	lbu	a5,0(a1)
    80000e22:	fef70fa3          	sb	a5,-1(a4)
    80000e26:	0585                	addi	a1,a1,1
    80000e28:	f7f5                	bnez	a5,80000e14 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e2a:	86ba                	mv	a3,a4
    80000e2c:	00c05c63          	blez	a2,80000e44 <strncpy+0x38>
    *s++ = 0;
    80000e30:	0685                	addi	a3,a3,1
    80000e32:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e36:	fff6c793          	not	a5,a3
    80000e3a:	9fb9                	addw	a5,a5,a4
    80000e3c:	010787bb          	addw	a5,a5,a6
    80000e40:	fef048e3          	bgtz	a5,80000e30 <strncpy+0x24>
  return os;
}
    80000e44:	6422                	ld	s0,8(sp)
    80000e46:	0141                	addi	sp,sp,16
    80000e48:	8082                	ret

0000000080000e4a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e4a:	1141                	addi	sp,sp,-16
    80000e4c:	e422                	sd	s0,8(sp)
    80000e4e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e50:	02c05363          	blez	a2,80000e76 <safestrcpy+0x2c>
    80000e54:	fff6069b          	addiw	a3,a2,-1
    80000e58:	1682                	slli	a3,a3,0x20
    80000e5a:	9281                	srli	a3,a3,0x20
    80000e5c:	96ae                	add	a3,a3,a1
    80000e5e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e60:	00d58963          	beq	a1,a3,80000e72 <safestrcpy+0x28>
    80000e64:	0585                	addi	a1,a1,1
    80000e66:	0785                	addi	a5,a5,1
    80000e68:	fff5c703          	lbu	a4,-1(a1)
    80000e6c:	fee78fa3          	sb	a4,-1(a5)
    80000e70:	fb65                	bnez	a4,80000e60 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e72:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <strlen>:

int
strlen(const char *s)
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e422                	sd	s0,8(sp)
    80000e80:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e82:	00054783          	lbu	a5,0(a0)
    80000e86:	cf91                	beqz	a5,80000ea2 <strlen+0x26>
    80000e88:	0505                	addi	a0,a0,1
    80000e8a:	87aa                	mv	a5,a0
    80000e8c:	4685                	li	a3,1
    80000e8e:	9e89                	subw	a3,a3,a0
    80000e90:	00f6853b          	addw	a0,a3,a5
    80000e94:	0785                	addi	a5,a5,1
    80000e96:	fff7c703          	lbu	a4,-1(a5)
    80000e9a:	fb7d                	bnez	a4,80000e90 <strlen+0x14>
    ;
  return n;
}
    80000e9c:	6422                	ld	s0,8(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ea2:	4501                	li	a0,0
    80000ea4:	bfe5                	j	80000e9c <strlen+0x20>

0000000080000ea6 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ea6:	1141                	addi	sp,sp,-16
    80000ea8:	e406                	sd	ra,8(sp)
    80000eaa:	e022                	sd	s0,0(sp)
    80000eac:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eae:	00001097          	auipc	ra,0x1
    80000eb2:	042080e7          	jalr	66(ra) # 80001ef0 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eb6:	00008717          	auipc	a4,0x8
    80000eba:	15670713          	addi	a4,a4,342 # 8000900c <started>
  if(cpuid() == 0){
    80000ebe:	c139                	beqz	a0,80000f04 <main+0x5e>
    while(started == 0)
    80000ec0:	431c                	lw	a5,0(a4)
    80000ec2:	2781                	sext.w	a5,a5
    80000ec4:	dff5                	beqz	a5,80000ec0 <main+0x1a>
      ;
    __sync_synchronize();
    80000ec6:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000eca:	00001097          	auipc	ra,0x1
    80000ece:	026080e7          	jalr	38(ra) # 80001ef0 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	20450513          	addi	a0,a0,516 # 800080d8 <digits+0x98>
    80000edc:	fffff097          	auipc	ra,0xfffff
    80000ee0:	6ae080e7          	jalr	1710(ra) # 8000058a <printf>
    kvminithart();    // turn on paging
    80000ee4:	00000097          	auipc	ra,0x0
    80000ee8:	0c8080e7          	jalr	200(ra) # 80000fac <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eec:	00002097          	auipc	ra,0x2
    80000ef0:	d2e080e7          	jalr	-722(ra) # 80002c1a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ef4:	00005097          	auipc	ra,0x5
    80000ef8:	38c080e7          	jalr	908(ra) # 80006280 <plicinithart>
  }

  scheduler();        
    80000efc:	00001097          	auipc	ra,0x1
    80000f00:	630080e7          	jalr	1584(ra) # 8000252c <scheduler>
    consoleinit();
    80000f04:	fffff097          	auipc	ra,0xfffff
    80000f08:	54e080e7          	jalr	1358(ra) # 80000452 <consoleinit>
    printfinit();
    80000f0c:	00000097          	auipc	ra,0x0
    80000f10:	85e080e7          	jalr	-1954(ra) # 8000076a <printfinit>
    printf("\n");
    80000f14:	00007517          	auipc	a0,0x7
    80000f18:	34450513          	addi	a0,a0,836 # 80008258 <digits+0x218>
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	66e080e7          	jalr	1646(ra) # 8000058a <printf>
    printf("EEE3535 Operating Systems: booting xv6-riscv kernel\n");
    80000f24:	00007517          	auipc	a0,0x7
    80000f28:	17c50513          	addi	a0,a0,380 # 800080a0 <digits+0x60>
    80000f2c:	fffff097          	auipc	ra,0xfffff
    80000f30:	65e080e7          	jalr	1630(ra) # 8000058a <printf>
    kinit();         // physical page allocator
    80000f34:	00000097          	auipc	ra,0x0
    80000f38:	b9c080e7          	jalr	-1124(ra) # 80000ad0 <kinit>
    kvminit();       // create kernel page table
    80000f3c:	00000097          	auipc	ra,0x0
    80000f40:	2a0080e7          	jalr	672(ra) # 800011dc <kvminit>
    kvminithart();   // turn on paging
    80000f44:	00000097          	auipc	ra,0x0
    80000f48:	068080e7          	jalr	104(ra) # 80000fac <kvminithart>
    procinit();      // process table
    80000f4c:	00001097          	auipc	ra,0x1
    80000f50:	e9c080e7          	jalr	-356(ra) # 80001de8 <procinit>
    trapinit();      // trap vectors
    80000f54:	00002097          	auipc	ra,0x2
    80000f58:	c9e080e7          	jalr	-866(ra) # 80002bf2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f5c:	00002097          	auipc	ra,0x2
    80000f60:	cbe080e7          	jalr	-834(ra) # 80002c1a <trapinithart>
    plicinit();      // set up interrupt controller
    80000f64:	00005097          	auipc	ra,0x5
    80000f68:	306080e7          	jalr	774(ra) # 8000626a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f6c:	00005097          	auipc	ra,0x5
    80000f70:	314080e7          	jalr	788(ra) # 80006280 <plicinithart>
    binit();         // buffer cache
    80000f74:	00002097          	auipc	ra,0x2
    80000f78:	4be080e7          	jalr	1214(ra) # 80003432 <binit>
    iinit();         // inode cache
    80000f7c:	00003097          	auipc	ra,0x3
    80000f80:	b50080e7          	jalr	-1200(ra) # 80003acc <iinit>
    fileinit();      // file table
    80000f84:	00004097          	auipc	ra,0x4
    80000f88:	aee080e7          	jalr	-1298(ra) # 80004a72 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f8c:	00005097          	auipc	ra,0x5
    80000f90:	3fc080e7          	jalr	1020(ra) # 80006388 <virtio_disk_init>
    userinit();      // first user process
    80000f94:	00001097          	auipc	ra,0x1
    80000f98:	32e080e7          	jalr	814(ra) # 800022c2 <userinit>
    __sync_synchronize();
    80000f9c:	0ff0000f          	fence
    started = 1;
    80000fa0:	4785                	li	a5,1
    80000fa2:	00008717          	auipc	a4,0x8
    80000fa6:	06f72523          	sw	a5,106(a4) # 8000900c <started>
    80000faa:	bf89                	j	80000efc <main+0x56>

0000000080000fac <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fac:	1141                	addi	sp,sp,-16
    80000fae:	e422                	sd	s0,8(sp)
    80000fb0:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fb2:	00008797          	auipc	a5,0x8
    80000fb6:	05e7b783          	ld	a5,94(a5) # 80009010 <kernel_pagetable>
    80000fba:	83b1                	srli	a5,a5,0xc
    80000fbc:	577d                	li	a4,-1
    80000fbe:	177e                	slli	a4,a4,0x3f
    80000fc0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fc2:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fc6:	12000073          	sfence.vma
  sfence_vma();
}
    80000fca:	6422                	ld	s0,8(sp)
    80000fcc:	0141                	addi	sp,sp,16
    80000fce:	8082                	ret

0000000080000fd0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fd0:	7139                	addi	sp,sp,-64
    80000fd2:	fc06                	sd	ra,56(sp)
    80000fd4:	f822                	sd	s0,48(sp)
    80000fd6:	f426                	sd	s1,40(sp)
    80000fd8:	f04a                	sd	s2,32(sp)
    80000fda:	ec4e                	sd	s3,24(sp)
    80000fdc:	e852                	sd	s4,16(sp)
    80000fde:	e456                	sd	s5,8(sp)
    80000fe0:	e05a                	sd	s6,0(sp)
    80000fe2:	0080                	addi	s0,sp,64
    80000fe4:	84aa                	mv	s1,a0
    80000fe6:	89ae                	mv	s3,a1
    80000fe8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fea:	57fd                	li	a5,-1
    80000fec:	83e9                	srli	a5,a5,0x1a
    80000fee:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000ff0:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000ff2:	04b7f263          	bgeu	a5,a1,80001036 <walk+0x66>
    panic("walk");
    80000ff6:	00007517          	auipc	a0,0x7
    80000ffa:	0fa50513          	addi	a0,a0,250 # 800080f0 <digits+0xb0>
    80000ffe:	fffff097          	auipc	ra,0xfffff
    80001002:	542080e7          	jalr	1346(ra) # 80000540 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001006:	060a8663          	beqz	s5,80001072 <walk+0xa2>
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	b02080e7          	jalr	-1278(ra) # 80000b0c <kalloc>
    80001012:	84aa                	mv	s1,a0
    80001014:	c529                	beqz	a0,8000105e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001016:	6605                	lui	a2,0x1
    80001018:	4581                	li	a1,0
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	cde080e7          	jalr	-802(ra) # 80000cf8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001022:	00c4d793          	srli	a5,s1,0xc
    80001026:	07aa                	slli	a5,a5,0xa
    80001028:	0017e793          	ori	a5,a5,1
    8000102c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001030:	3a5d                	addiw	s4,s4,-9
    80001032:	036a0063          	beq	s4,s6,80001052 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001036:	0149d933          	srl	s2,s3,s4
    8000103a:	1ff97913          	andi	s2,s2,511
    8000103e:	090e                	slli	s2,s2,0x3
    80001040:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001042:	00093483          	ld	s1,0(s2)
    80001046:	0014f793          	andi	a5,s1,1
    8000104a:	dfd5                	beqz	a5,80001006 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000104c:	80a9                	srli	s1,s1,0xa
    8000104e:	04b2                	slli	s1,s1,0xc
    80001050:	b7c5                	j	80001030 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001052:	00c9d513          	srli	a0,s3,0xc
    80001056:	1ff57513          	andi	a0,a0,511
    8000105a:	050e                	slli	a0,a0,0x3
    8000105c:	9526                	add	a0,a0,s1
}
    8000105e:	70e2                	ld	ra,56(sp)
    80001060:	7442                	ld	s0,48(sp)
    80001062:	74a2                	ld	s1,40(sp)
    80001064:	7902                	ld	s2,32(sp)
    80001066:	69e2                	ld	s3,24(sp)
    80001068:	6a42                	ld	s4,16(sp)
    8000106a:	6aa2                	ld	s5,8(sp)
    8000106c:	6b02                	ld	s6,0(sp)
    8000106e:	6121                	addi	sp,sp,64
    80001070:	8082                	ret
        return 0;
    80001072:	4501                	li	a0,0
    80001074:	b7ed                	j	8000105e <walk+0x8e>

0000000080001076 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001076:	57fd                	li	a5,-1
    80001078:	83e9                	srli	a5,a5,0x1a
    8000107a:	00b7f463          	bgeu	a5,a1,80001082 <walkaddr+0xc>
    return 0;
    8000107e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001080:	8082                	ret
{
    80001082:	1141                	addi	sp,sp,-16
    80001084:	e406                	sd	ra,8(sp)
    80001086:	e022                	sd	s0,0(sp)
    80001088:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000108a:	4601                	li	a2,0
    8000108c:	00000097          	auipc	ra,0x0
    80001090:	f44080e7          	jalr	-188(ra) # 80000fd0 <walk>
  if(pte == 0)
    80001094:	c105                	beqz	a0,800010b4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001096:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001098:	0117f693          	andi	a3,a5,17
    8000109c:	4745                	li	a4,17
    return 0;
    8000109e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010a0:	00e68663          	beq	a3,a4,800010ac <walkaddr+0x36>
}
    800010a4:	60a2                	ld	ra,8(sp)
    800010a6:	6402                	ld	s0,0(sp)
    800010a8:	0141                	addi	sp,sp,16
    800010aa:	8082                	ret
  pa = PTE2PA(*pte);
    800010ac:	00a7d513          	srli	a0,a5,0xa
    800010b0:	0532                	slli	a0,a0,0xc
  return pa;
    800010b2:	bfcd                	j	800010a4 <walkaddr+0x2e>
    return 0;
    800010b4:	4501                	li	a0,0
    800010b6:	b7fd                	j	800010a4 <walkaddr+0x2e>

00000000800010b8 <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    800010b8:	1101                	addi	sp,sp,-32
    800010ba:	ec06                	sd	ra,24(sp)
    800010bc:	e822                	sd	s0,16(sp)
    800010be:	e426                	sd	s1,8(sp)
    800010c0:	1000                	addi	s0,sp,32
    800010c2:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800010c4:	1552                	slli	a0,a0,0x34
    800010c6:	03455493          	srli	s1,a0,0x34
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
    800010ca:	4601                	li	a2,0
    800010cc:	00008517          	auipc	a0,0x8
    800010d0:	f4453503          	ld	a0,-188(a0) # 80009010 <kernel_pagetable>
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	efc080e7          	jalr	-260(ra) # 80000fd0 <walk>
  if(pte == 0)
    800010dc:	cd09                	beqz	a0,800010f6 <kvmpa+0x3e>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    800010de:	6108                	ld	a0,0(a0)
    800010e0:	00157793          	andi	a5,a0,1
    800010e4:	c38d                	beqz	a5,80001106 <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    800010e6:	8129                	srli	a0,a0,0xa
    800010e8:	0532                	slli	a0,a0,0xc
  return pa+off;
}
    800010ea:	9526                	add	a0,a0,s1
    800010ec:	60e2                	ld	ra,24(sp)
    800010ee:	6442                	ld	s0,16(sp)
    800010f0:	64a2                	ld	s1,8(sp)
    800010f2:	6105                	addi	sp,sp,32
    800010f4:	8082                	ret
    panic("kvmpa");
    800010f6:	00007517          	auipc	a0,0x7
    800010fa:	00250513          	addi	a0,a0,2 # 800080f8 <digits+0xb8>
    800010fe:	fffff097          	auipc	ra,0xfffff
    80001102:	442080e7          	jalr	1090(ra) # 80000540 <panic>
    panic("kvmpa");
    80001106:	00007517          	auipc	a0,0x7
    8000110a:	ff250513          	addi	a0,a0,-14 # 800080f8 <digits+0xb8>
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	432080e7          	jalr	1074(ra) # 80000540 <panic>

0000000080001116 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001116:	715d                	addi	sp,sp,-80
    80001118:	e486                	sd	ra,72(sp)
    8000111a:	e0a2                	sd	s0,64(sp)
    8000111c:	fc26                	sd	s1,56(sp)
    8000111e:	f84a                	sd	s2,48(sp)
    80001120:	f44e                	sd	s3,40(sp)
    80001122:	f052                	sd	s4,32(sp)
    80001124:	ec56                	sd	s5,24(sp)
    80001126:	e85a                	sd	s6,16(sp)
    80001128:	e45e                	sd	s7,8(sp)
    8000112a:	0880                	addi	s0,sp,80
    8000112c:	8aaa                	mv	s5,a0
    8000112e:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    80001130:	777d                	lui	a4,0xfffff
    80001132:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001136:	167d                	addi	a2,a2,-1
    80001138:	00b609b3          	add	s3,a2,a1
    8000113c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001140:	893e                	mv	s2,a5
    80001142:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001146:	6b85                	lui	s7,0x1
    80001148:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000114c:	4605                	li	a2,1
    8000114e:	85ca                	mv	a1,s2
    80001150:	8556                	mv	a0,s5
    80001152:	00000097          	auipc	ra,0x0
    80001156:	e7e080e7          	jalr	-386(ra) # 80000fd0 <walk>
    8000115a:	c51d                	beqz	a0,80001188 <mappages+0x72>
    if(*pte & PTE_V)
    8000115c:	611c                	ld	a5,0(a0)
    8000115e:	8b85                	andi	a5,a5,1
    80001160:	ef81                	bnez	a5,80001178 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001162:	80b1                	srli	s1,s1,0xc
    80001164:	04aa                	slli	s1,s1,0xa
    80001166:	0164e4b3          	or	s1,s1,s6
    8000116a:	0014e493          	ori	s1,s1,1
    8000116e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001170:	03390863          	beq	s2,s3,800011a0 <mappages+0x8a>
    a += PGSIZE;
    80001174:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001176:	bfc9                	j	80001148 <mappages+0x32>
      panic("remap");
    80001178:	00007517          	auipc	a0,0x7
    8000117c:	f8850513          	addi	a0,a0,-120 # 80008100 <digits+0xc0>
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	3c0080e7          	jalr	960(ra) # 80000540 <panic>
      return -1;
    80001188:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000118a:	60a6                	ld	ra,72(sp)
    8000118c:	6406                	ld	s0,64(sp)
    8000118e:	74e2                	ld	s1,56(sp)
    80001190:	7942                	ld	s2,48(sp)
    80001192:	79a2                	ld	s3,40(sp)
    80001194:	7a02                	ld	s4,32(sp)
    80001196:	6ae2                	ld	s5,24(sp)
    80001198:	6b42                	ld	s6,16(sp)
    8000119a:	6ba2                	ld	s7,8(sp)
    8000119c:	6161                	addi	sp,sp,80
    8000119e:	8082                	ret
  return 0;
    800011a0:	4501                	li	a0,0
    800011a2:	b7e5                	j	8000118a <mappages+0x74>

00000000800011a4 <kvmmap>:
{
    800011a4:	1141                	addi	sp,sp,-16
    800011a6:	e406                	sd	ra,8(sp)
    800011a8:	e022                	sd	s0,0(sp)
    800011aa:	0800                	addi	s0,sp,16
    800011ac:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800011ae:	86ae                	mv	a3,a1
    800011b0:	85aa                	mv	a1,a0
    800011b2:	00008517          	auipc	a0,0x8
    800011b6:	e5e53503          	ld	a0,-418(a0) # 80009010 <kernel_pagetable>
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	f5c080e7          	jalr	-164(ra) # 80001116 <mappages>
    800011c2:	e509                	bnez	a0,800011cc <kvmmap+0x28>
}
    800011c4:	60a2                	ld	ra,8(sp)
    800011c6:	6402                	ld	s0,0(sp)
    800011c8:	0141                	addi	sp,sp,16
    800011ca:	8082                	ret
    panic("kvmmap");
    800011cc:	00007517          	auipc	a0,0x7
    800011d0:	f3c50513          	addi	a0,a0,-196 # 80008108 <digits+0xc8>
    800011d4:	fffff097          	auipc	ra,0xfffff
    800011d8:	36c080e7          	jalr	876(ra) # 80000540 <panic>

00000000800011dc <kvminit>:
{
    800011dc:	1101                	addi	sp,sp,-32
    800011de:	ec06                	sd	ra,24(sp)
    800011e0:	e822                	sd	s0,16(sp)
    800011e2:	e426                	sd	s1,8(sp)
    800011e4:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	926080e7          	jalr	-1754(ra) # 80000b0c <kalloc>
    800011ee:	00008797          	auipc	a5,0x8
    800011f2:	e2a7b123          	sd	a0,-478(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800011f6:	6605                	lui	a2,0x1
    800011f8:	4581                	li	a1,0
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	afe080e7          	jalr	-1282(ra) # 80000cf8 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001202:	4699                	li	a3,6
    80001204:	6605                	lui	a2,0x1
    80001206:	100005b7          	lui	a1,0x10000
    8000120a:	10000537          	lui	a0,0x10000
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	f96080e7          	jalr	-106(ra) # 800011a4 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001216:	4699                	li	a3,6
    80001218:	6605                	lui	a2,0x1
    8000121a:	100015b7          	lui	a1,0x10001
    8000121e:	10001537          	lui	a0,0x10001
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f82080e7          	jalr	-126(ra) # 800011a4 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    8000122a:	4699                	li	a3,6
    8000122c:	6641                	lui	a2,0x10
    8000122e:	020005b7          	lui	a1,0x2000
    80001232:	02000537          	lui	a0,0x2000
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	f6e080e7          	jalr	-146(ra) # 800011a4 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000123e:	4699                	li	a3,6
    80001240:	00400637          	lui	a2,0x400
    80001244:	0c0005b7          	lui	a1,0xc000
    80001248:	0c000537          	lui	a0,0xc000
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f58080e7          	jalr	-168(ra) # 800011a4 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001254:	00007497          	auipc	s1,0x7
    80001258:	dac48493          	addi	s1,s1,-596 # 80008000 <etext>
    8000125c:	46a9                	li	a3,10
    8000125e:	80007617          	auipc	a2,0x80007
    80001262:	da260613          	addi	a2,a2,-606 # 8000 <_entry-0x7fff8000>
    80001266:	4585                	li	a1,1
    80001268:	05fe                	slli	a1,a1,0x1f
    8000126a:	852e                	mv	a0,a1
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	f38080e7          	jalr	-200(ra) # 800011a4 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001274:	4699                	li	a3,6
    80001276:	4645                	li	a2,17
    80001278:	066e                	slli	a2,a2,0x1b
    8000127a:	8e05                	sub	a2,a2,s1
    8000127c:	85a6                	mv	a1,s1
    8000127e:	8526                	mv	a0,s1
    80001280:	00000097          	auipc	ra,0x0
    80001284:	f24080e7          	jalr	-220(ra) # 800011a4 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001288:	46a9                	li	a3,10
    8000128a:	6605                	lui	a2,0x1
    8000128c:	00006597          	auipc	a1,0x6
    80001290:	d7458593          	addi	a1,a1,-652 # 80007000 <_trampoline>
    80001294:	04000537          	lui	a0,0x4000
    80001298:	157d                	addi	a0,a0,-1
    8000129a:	0532                	slli	a0,a0,0xc
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	f08080e7          	jalr	-248(ra) # 800011a4 <kvmmap>
}
    800012a4:	60e2                	ld	ra,24(sp)
    800012a6:	6442                	ld	s0,16(sp)
    800012a8:	64a2                	ld	s1,8(sp)
    800012aa:	6105                	addi	sp,sp,32
    800012ac:	8082                	ret

00000000800012ae <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012ae:	715d                	addi	sp,sp,-80
    800012b0:	e486                	sd	ra,72(sp)
    800012b2:	e0a2                	sd	s0,64(sp)
    800012b4:	fc26                	sd	s1,56(sp)
    800012b6:	f84a                	sd	s2,48(sp)
    800012b8:	f44e                	sd	s3,40(sp)
    800012ba:	f052                	sd	s4,32(sp)
    800012bc:	ec56                	sd	s5,24(sp)
    800012be:	e85a                	sd	s6,16(sp)
    800012c0:	e45e                	sd	s7,8(sp)
    800012c2:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012c4:	03459793          	slli	a5,a1,0x34
    800012c8:	e795                	bnez	a5,800012f4 <uvmunmap+0x46>
    800012ca:	8a2a                	mv	s4,a0
    800012cc:	892e                	mv	s2,a1
    800012ce:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012d0:	0632                	slli	a2,a2,0xc
    800012d2:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012d6:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012d8:	6b05                	lui	s6,0x1
    800012da:	0735e263          	bltu	a1,s3,8000133e <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012de:	60a6                	ld	ra,72(sp)
    800012e0:	6406                	ld	s0,64(sp)
    800012e2:	74e2                	ld	s1,56(sp)
    800012e4:	7942                	ld	s2,48(sp)
    800012e6:	79a2                	ld	s3,40(sp)
    800012e8:	7a02                	ld	s4,32(sp)
    800012ea:	6ae2                	ld	s5,24(sp)
    800012ec:	6b42                	ld	s6,16(sp)
    800012ee:	6ba2                	ld	s7,8(sp)
    800012f0:	6161                	addi	sp,sp,80
    800012f2:	8082                	ret
    panic("uvmunmap: not aligned");
    800012f4:	00007517          	auipc	a0,0x7
    800012f8:	e1c50513          	addi	a0,a0,-484 # 80008110 <digits+0xd0>
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	244080e7          	jalr	580(ra) # 80000540 <panic>
      panic("uvmunmap: walk");
    80001304:	00007517          	auipc	a0,0x7
    80001308:	e2450513          	addi	a0,a0,-476 # 80008128 <digits+0xe8>
    8000130c:	fffff097          	auipc	ra,0xfffff
    80001310:	234080e7          	jalr	564(ra) # 80000540 <panic>
      panic("uvmunmap: not mapped");
    80001314:	00007517          	auipc	a0,0x7
    80001318:	e2450513          	addi	a0,a0,-476 # 80008138 <digits+0xf8>
    8000131c:	fffff097          	auipc	ra,0xfffff
    80001320:	224080e7          	jalr	548(ra) # 80000540 <panic>
      panic("uvmunmap: not a leaf");
    80001324:	00007517          	auipc	a0,0x7
    80001328:	e2c50513          	addi	a0,a0,-468 # 80008150 <digits+0x110>
    8000132c:	fffff097          	auipc	ra,0xfffff
    80001330:	214080e7          	jalr	532(ra) # 80000540 <panic>
    *pte = 0;
    80001334:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001338:	995a                	add	s2,s2,s6
    8000133a:	fb3972e3          	bgeu	s2,s3,800012de <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000133e:	4601                	li	a2,0
    80001340:	85ca                	mv	a1,s2
    80001342:	8552                	mv	a0,s4
    80001344:	00000097          	auipc	ra,0x0
    80001348:	c8c080e7          	jalr	-884(ra) # 80000fd0 <walk>
    8000134c:	84aa                	mv	s1,a0
    8000134e:	d95d                	beqz	a0,80001304 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001350:	6108                	ld	a0,0(a0)
    80001352:	00157793          	andi	a5,a0,1
    80001356:	dfdd                	beqz	a5,80001314 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001358:	3ff57793          	andi	a5,a0,1023
    8000135c:	fd7784e3          	beq	a5,s7,80001324 <uvmunmap+0x76>
    if(do_free){
    80001360:	fc0a8ae3          	beqz	s5,80001334 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001364:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001366:	0532                	slli	a0,a0,0xc
    80001368:	fffff097          	auipc	ra,0xfffff
    8000136c:	6a8080e7          	jalr	1704(ra) # 80000a10 <kfree>
    80001370:	b7d1                	j	80001334 <uvmunmap+0x86>

0000000080001372 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001372:	1101                	addi	sp,sp,-32
    80001374:	ec06                	sd	ra,24(sp)
    80001376:	e822                	sd	s0,16(sp)
    80001378:	e426                	sd	s1,8(sp)
    8000137a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000137c:	fffff097          	auipc	ra,0xfffff
    80001380:	790080e7          	jalr	1936(ra) # 80000b0c <kalloc>
    80001384:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001386:	c519                	beqz	a0,80001394 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001388:	6605                	lui	a2,0x1
    8000138a:	4581                	li	a1,0
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	96c080e7          	jalr	-1684(ra) # 80000cf8 <memset>
  return pagetable;
}
    80001394:	8526                	mv	a0,s1
    80001396:	60e2                	ld	ra,24(sp)
    80001398:	6442                	ld	s0,16(sp)
    8000139a:	64a2                	ld	s1,8(sp)
    8000139c:	6105                	addi	sp,sp,32
    8000139e:	8082                	ret

00000000800013a0 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013a0:	7179                	addi	sp,sp,-48
    800013a2:	f406                	sd	ra,40(sp)
    800013a4:	f022                	sd	s0,32(sp)
    800013a6:	ec26                	sd	s1,24(sp)
    800013a8:	e84a                	sd	s2,16(sp)
    800013aa:	e44e                	sd	s3,8(sp)
    800013ac:	e052                	sd	s4,0(sp)
    800013ae:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013b0:	6785                	lui	a5,0x1
    800013b2:	04f67863          	bgeu	a2,a5,80001402 <uvminit+0x62>
    800013b6:	8a2a                	mv	s4,a0
    800013b8:	89ae                	mv	s3,a1
    800013ba:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013bc:	fffff097          	auipc	ra,0xfffff
    800013c0:	750080e7          	jalr	1872(ra) # 80000b0c <kalloc>
    800013c4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013c6:	6605                	lui	a2,0x1
    800013c8:	4581                	li	a1,0
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	92e080e7          	jalr	-1746(ra) # 80000cf8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013d2:	4779                	li	a4,30
    800013d4:	86ca                	mv	a3,s2
    800013d6:	6605                	lui	a2,0x1
    800013d8:	4581                	li	a1,0
    800013da:	8552                	mv	a0,s4
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	d3a080e7          	jalr	-710(ra) # 80001116 <mappages>
  memmove(mem, src, sz);
    800013e4:	8626                	mv	a2,s1
    800013e6:	85ce                	mv	a1,s3
    800013e8:	854a                	mv	a0,s2
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	96a080e7          	jalr	-1686(ra) # 80000d54 <memmove>
}
    800013f2:	70a2                	ld	ra,40(sp)
    800013f4:	7402                	ld	s0,32(sp)
    800013f6:	64e2                	ld	s1,24(sp)
    800013f8:	6942                	ld	s2,16(sp)
    800013fa:	69a2                	ld	s3,8(sp)
    800013fc:	6a02                	ld	s4,0(sp)
    800013fe:	6145                	addi	sp,sp,48
    80001400:	8082                	ret
    panic("inituvm: more than a page");
    80001402:	00007517          	auipc	a0,0x7
    80001406:	d6650513          	addi	a0,a0,-666 # 80008168 <digits+0x128>
    8000140a:	fffff097          	auipc	ra,0xfffff
    8000140e:	136080e7          	jalr	310(ra) # 80000540 <panic>

0000000080001412 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001412:	1101                	addi	sp,sp,-32
    80001414:	ec06                	sd	ra,24(sp)
    80001416:	e822                	sd	s0,16(sp)
    80001418:	e426                	sd	s1,8(sp)
    8000141a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000141c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000141e:	00b67d63          	bgeu	a2,a1,80001438 <uvmdealloc+0x26>
    80001422:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001424:	6785                	lui	a5,0x1
    80001426:	17fd                	addi	a5,a5,-1
    80001428:	00f60733          	add	a4,a2,a5
    8000142c:	767d                	lui	a2,0xfffff
    8000142e:	8f71                	and	a4,a4,a2
    80001430:	97ae                	add	a5,a5,a1
    80001432:	8ff1                	and	a5,a5,a2
    80001434:	00f76863          	bltu	a4,a5,80001444 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001438:	8526                	mv	a0,s1
    8000143a:	60e2                	ld	ra,24(sp)
    8000143c:	6442                	ld	s0,16(sp)
    8000143e:	64a2                	ld	s1,8(sp)
    80001440:	6105                	addi	sp,sp,32
    80001442:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001444:	8f99                	sub	a5,a5,a4
    80001446:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001448:	4685                	li	a3,1
    8000144a:	0007861b          	sext.w	a2,a5
    8000144e:	85ba                	mv	a1,a4
    80001450:	00000097          	auipc	ra,0x0
    80001454:	e5e080e7          	jalr	-418(ra) # 800012ae <uvmunmap>
    80001458:	b7c5                	j	80001438 <uvmdealloc+0x26>

000000008000145a <uvmalloc>:
  if(newsz < oldsz)
    8000145a:	0ab66163          	bltu	a2,a1,800014fc <uvmalloc+0xa2>
{
    8000145e:	7139                	addi	sp,sp,-64
    80001460:	fc06                	sd	ra,56(sp)
    80001462:	f822                	sd	s0,48(sp)
    80001464:	f426                	sd	s1,40(sp)
    80001466:	f04a                	sd	s2,32(sp)
    80001468:	ec4e                	sd	s3,24(sp)
    8000146a:	e852                	sd	s4,16(sp)
    8000146c:	e456                	sd	s5,8(sp)
    8000146e:	0080                	addi	s0,sp,64
    80001470:	8aaa                	mv	s5,a0
    80001472:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001474:	6985                	lui	s3,0x1
    80001476:	19fd                	addi	s3,s3,-1
    80001478:	95ce                	add	a1,a1,s3
    8000147a:	79fd                	lui	s3,0xfffff
    8000147c:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001480:	08c9f063          	bgeu	s3,a2,80001500 <uvmalloc+0xa6>
    80001484:	894e                	mv	s2,s3
    mem = kalloc();
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	686080e7          	jalr	1670(ra) # 80000b0c <kalloc>
    8000148e:	84aa                	mv	s1,a0
    if(mem == 0){
    80001490:	c51d                	beqz	a0,800014be <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001492:	6605                	lui	a2,0x1
    80001494:	4581                	li	a1,0
    80001496:	00000097          	auipc	ra,0x0
    8000149a:	862080e7          	jalr	-1950(ra) # 80000cf8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000149e:	4779                	li	a4,30
    800014a0:	86a6                	mv	a3,s1
    800014a2:	6605                	lui	a2,0x1
    800014a4:	85ca                	mv	a1,s2
    800014a6:	8556                	mv	a0,s5
    800014a8:	00000097          	auipc	ra,0x0
    800014ac:	c6e080e7          	jalr	-914(ra) # 80001116 <mappages>
    800014b0:	e905                	bnez	a0,800014e0 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014b2:	6785                	lui	a5,0x1
    800014b4:	993e                	add	s2,s2,a5
    800014b6:	fd4968e3          	bltu	s2,s4,80001486 <uvmalloc+0x2c>
  return newsz;
    800014ba:	8552                	mv	a0,s4
    800014bc:	a809                	j	800014ce <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800014be:	864e                	mv	a2,s3
    800014c0:	85ca                	mv	a1,s2
    800014c2:	8556                	mv	a0,s5
    800014c4:	00000097          	auipc	ra,0x0
    800014c8:	f4e080e7          	jalr	-178(ra) # 80001412 <uvmdealloc>
      return 0;
    800014cc:	4501                	li	a0,0
}
    800014ce:	70e2                	ld	ra,56(sp)
    800014d0:	7442                	ld	s0,48(sp)
    800014d2:	74a2                	ld	s1,40(sp)
    800014d4:	7902                	ld	s2,32(sp)
    800014d6:	69e2                	ld	s3,24(sp)
    800014d8:	6a42                	ld	s4,16(sp)
    800014da:	6aa2                	ld	s5,8(sp)
    800014dc:	6121                	addi	sp,sp,64
    800014de:	8082                	ret
      kfree(mem);
    800014e0:	8526                	mv	a0,s1
    800014e2:	fffff097          	auipc	ra,0xfffff
    800014e6:	52e080e7          	jalr	1326(ra) # 80000a10 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014ea:	864e                	mv	a2,s3
    800014ec:	85ca                	mv	a1,s2
    800014ee:	8556                	mv	a0,s5
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	f22080e7          	jalr	-222(ra) # 80001412 <uvmdealloc>
      return 0;
    800014f8:	4501                	li	a0,0
    800014fa:	bfd1                	j	800014ce <uvmalloc+0x74>
    return oldsz;
    800014fc:	852e                	mv	a0,a1
}
    800014fe:	8082                	ret
  return newsz;
    80001500:	8532                	mv	a0,a2
    80001502:	b7f1                	j	800014ce <uvmalloc+0x74>

0000000080001504 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001504:	7179                	addi	sp,sp,-48
    80001506:	f406                	sd	ra,40(sp)
    80001508:	f022                	sd	s0,32(sp)
    8000150a:	ec26                	sd	s1,24(sp)
    8000150c:	e84a                	sd	s2,16(sp)
    8000150e:	e44e                	sd	s3,8(sp)
    80001510:	e052                	sd	s4,0(sp)
    80001512:	1800                	addi	s0,sp,48
    80001514:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001516:	84aa                	mv	s1,a0
    80001518:	6905                	lui	s2,0x1
    8000151a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000151c:	4985                	li	s3,1
    8000151e:	a821                	j	80001536 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001520:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001522:	0532                	slli	a0,a0,0xc
    80001524:	00000097          	auipc	ra,0x0
    80001528:	fe0080e7          	jalr	-32(ra) # 80001504 <freewalk>
      pagetable[i] = 0;
    8000152c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001530:	04a1                	addi	s1,s1,8
    80001532:	03248163          	beq	s1,s2,80001554 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001536:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001538:	00f57793          	andi	a5,a0,15
    8000153c:	ff3782e3          	beq	a5,s3,80001520 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001540:	8905                	andi	a0,a0,1
    80001542:	d57d                	beqz	a0,80001530 <freewalk+0x2c>
      panic("freewalk: leaf");
    80001544:	00007517          	auipc	a0,0x7
    80001548:	c4450513          	addi	a0,a0,-956 # 80008188 <digits+0x148>
    8000154c:	fffff097          	auipc	ra,0xfffff
    80001550:	ff4080e7          	jalr	-12(ra) # 80000540 <panic>
    }
  }
  kfree((void*)pagetable);
    80001554:	8552                	mv	a0,s4
    80001556:	fffff097          	auipc	ra,0xfffff
    8000155a:	4ba080e7          	jalr	1210(ra) # 80000a10 <kfree>
}
    8000155e:	70a2                	ld	ra,40(sp)
    80001560:	7402                	ld	s0,32(sp)
    80001562:	64e2                	ld	s1,24(sp)
    80001564:	6942                	ld	s2,16(sp)
    80001566:	69a2                	ld	s3,8(sp)
    80001568:	6a02                	ld	s4,0(sp)
    8000156a:	6145                	addi	sp,sp,48
    8000156c:	8082                	ret

000000008000156e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000156e:	1101                	addi	sp,sp,-32
    80001570:	ec06                	sd	ra,24(sp)
    80001572:	e822                	sd	s0,16(sp)
    80001574:	e426                	sd	s1,8(sp)
    80001576:	1000                	addi	s0,sp,32
    80001578:	84aa                	mv	s1,a0
  if(sz > 0)
    8000157a:	e999                	bnez	a1,80001590 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000157c:	8526                	mv	a0,s1
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	f86080e7          	jalr	-122(ra) # 80001504 <freewalk>
}
    80001586:	60e2                	ld	ra,24(sp)
    80001588:	6442                	ld	s0,16(sp)
    8000158a:	64a2                	ld	s1,8(sp)
    8000158c:	6105                	addi	sp,sp,32
    8000158e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001590:	6605                	lui	a2,0x1
    80001592:	167d                	addi	a2,a2,-1
    80001594:	962e                	add	a2,a2,a1
    80001596:	4685                	li	a3,1
    80001598:	8231                	srli	a2,a2,0xc
    8000159a:	4581                	li	a1,0
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	d12080e7          	jalr	-750(ra) # 800012ae <uvmunmap>
    800015a4:	bfe1                	j	8000157c <uvmfree+0xe>

00000000800015a6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015a6:	c679                	beqz	a2,80001674 <uvmcopy+0xce>
{
    800015a8:	715d                	addi	sp,sp,-80
    800015aa:	e486                	sd	ra,72(sp)
    800015ac:	e0a2                	sd	s0,64(sp)
    800015ae:	fc26                	sd	s1,56(sp)
    800015b0:	f84a                	sd	s2,48(sp)
    800015b2:	f44e                	sd	s3,40(sp)
    800015b4:	f052                	sd	s4,32(sp)
    800015b6:	ec56                	sd	s5,24(sp)
    800015b8:	e85a                	sd	s6,16(sp)
    800015ba:	e45e                	sd	s7,8(sp)
    800015bc:	0880                	addi	s0,sp,80
    800015be:	8b2a                	mv	s6,a0
    800015c0:	8aae                	mv	s5,a1
    800015c2:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015c4:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015c6:	4601                	li	a2,0
    800015c8:	85ce                	mv	a1,s3
    800015ca:	855a                	mv	a0,s6
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	a04080e7          	jalr	-1532(ra) # 80000fd0 <walk>
    800015d4:	c531                	beqz	a0,80001620 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015d6:	6118                	ld	a4,0(a0)
    800015d8:	00177793          	andi	a5,a4,1
    800015dc:	cbb1                	beqz	a5,80001630 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015de:	00a75593          	srli	a1,a4,0xa
    800015e2:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015e6:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015ea:	fffff097          	auipc	ra,0xfffff
    800015ee:	522080e7          	jalr	1314(ra) # 80000b0c <kalloc>
    800015f2:	892a                	mv	s2,a0
    800015f4:	c939                	beqz	a0,8000164a <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015f6:	6605                	lui	a2,0x1
    800015f8:	85de                	mv	a1,s7
    800015fa:	fffff097          	auipc	ra,0xfffff
    800015fe:	75a080e7          	jalr	1882(ra) # 80000d54 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001602:	8726                	mv	a4,s1
    80001604:	86ca                	mv	a3,s2
    80001606:	6605                	lui	a2,0x1
    80001608:	85ce                	mv	a1,s3
    8000160a:	8556                	mv	a0,s5
    8000160c:	00000097          	auipc	ra,0x0
    80001610:	b0a080e7          	jalr	-1270(ra) # 80001116 <mappages>
    80001614:	e515                	bnez	a0,80001640 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001616:	6785                	lui	a5,0x1
    80001618:	99be                	add	s3,s3,a5
    8000161a:	fb49e6e3          	bltu	s3,s4,800015c6 <uvmcopy+0x20>
    8000161e:	a081                	j	8000165e <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001620:	00007517          	auipc	a0,0x7
    80001624:	b7850513          	addi	a0,a0,-1160 # 80008198 <digits+0x158>
    80001628:	fffff097          	auipc	ra,0xfffff
    8000162c:	f18080e7          	jalr	-232(ra) # 80000540 <panic>
      panic("uvmcopy: page not present");
    80001630:	00007517          	auipc	a0,0x7
    80001634:	b8850513          	addi	a0,a0,-1144 # 800081b8 <digits+0x178>
    80001638:	fffff097          	auipc	ra,0xfffff
    8000163c:	f08080e7          	jalr	-248(ra) # 80000540 <panic>
      kfree(mem);
    80001640:	854a                	mv	a0,s2
    80001642:	fffff097          	auipc	ra,0xfffff
    80001646:	3ce080e7          	jalr	974(ra) # 80000a10 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000164a:	4685                	li	a3,1
    8000164c:	00c9d613          	srli	a2,s3,0xc
    80001650:	4581                	li	a1,0
    80001652:	8556                	mv	a0,s5
    80001654:	00000097          	auipc	ra,0x0
    80001658:	c5a080e7          	jalr	-934(ra) # 800012ae <uvmunmap>
  return -1;
    8000165c:	557d                	li	a0,-1
}
    8000165e:	60a6                	ld	ra,72(sp)
    80001660:	6406                	ld	s0,64(sp)
    80001662:	74e2                	ld	s1,56(sp)
    80001664:	7942                	ld	s2,48(sp)
    80001666:	79a2                	ld	s3,40(sp)
    80001668:	7a02                	ld	s4,32(sp)
    8000166a:	6ae2                	ld	s5,24(sp)
    8000166c:	6b42                	ld	s6,16(sp)
    8000166e:	6ba2                	ld	s7,8(sp)
    80001670:	6161                	addi	sp,sp,80
    80001672:	8082                	ret
  return 0;
    80001674:	4501                	li	a0,0
}
    80001676:	8082                	ret

0000000080001678 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001678:	1141                	addi	sp,sp,-16
    8000167a:	e406                	sd	ra,8(sp)
    8000167c:	e022                	sd	s0,0(sp)
    8000167e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001680:	4601                	li	a2,0
    80001682:	00000097          	auipc	ra,0x0
    80001686:	94e080e7          	jalr	-1714(ra) # 80000fd0 <walk>
  if(pte == 0)
    8000168a:	c901                	beqz	a0,8000169a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000168c:	611c                	ld	a5,0(a0)
    8000168e:	9bbd                	andi	a5,a5,-17
    80001690:	e11c                	sd	a5,0(a0)
}
    80001692:	60a2                	ld	ra,8(sp)
    80001694:	6402                	ld	s0,0(sp)
    80001696:	0141                	addi	sp,sp,16
    80001698:	8082                	ret
    panic("uvmclear");
    8000169a:	00007517          	auipc	a0,0x7
    8000169e:	b3e50513          	addi	a0,a0,-1218 # 800081d8 <digits+0x198>
    800016a2:	fffff097          	auipc	ra,0xfffff
    800016a6:	e9e080e7          	jalr	-354(ra) # 80000540 <panic>

00000000800016aa <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016aa:	c6bd                	beqz	a3,80001718 <copyout+0x6e>
{
    800016ac:	715d                	addi	sp,sp,-80
    800016ae:	e486                	sd	ra,72(sp)
    800016b0:	e0a2                	sd	s0,64(sp)
    800016b2:	fc26                	sd	s1,56(sp)
    800016b4:	f84a                	sd	s2,48(sp)
    800016b6:	f44e                	sd	s3,40(sp)
    800016b8:	f052                	sd	s4,32(sp)
    800016ba:	ec56                	sd	s5,24(sp)
    800016bc:	e85a                	sd	s6,16(sp)
    800016be:	e45e                	sd	s7,8(sp)
    800016c0:	e062                	sd	s8,0(sp)
    800016c2:	0880                	addi	s0,sp,80
    800016c4:	8b2a                	mv	s6,a0
    800016c6:	8c2e                	mv	s8,a1
    800016c8:	8a32                	mv	s4,a2
    800016ca:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016cc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016ce:	6a85                	lui	s5,0x1
    800016d0:	a015                	j	800016f4 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016d2:	9562                	add	a0,a0,s8
    800016d4:	0004861b          	sext.w	a2,s1
    800016d8:	85d2                	mv	a1,s4
    800016da:	41250533          	sub	a0,a0,s2
    800016de:	fffff097          	auipc	ra,0xfffff
    800016e2:	676080e7          	jalr	1654(ra) # 80000d54 <memmove>

    len -= n;
    800016e6:	409989b3          	sub	s3,s3,s1
    src += n;
    800016ea:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016ec:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016f0:	02098263          	beqz	s3,80001714 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016f4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016f8:	85ca                	mv	a1,s2
    800016fa:	855a                	mv	a0,s6
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	97a080e7          	jalr	-1670(ra) # 80001076 <walkaddr>
    if(pa0 == 0)
    80001704:	cd01                	beqz	a0,8000171c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001706:	418904b3          	sub	s1,s2,s8
    8000170a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000170c:	fc99f3e3          	bgeu	s3,s1,800016d2 <copyout+0x28>
    80001710:	84ce                	mv	s1,s3
    80001712:	b7c1                	j	800016d2 <copyout+0x28>
  }
  return 0;
    80001714:	4501                	li	a0,0
    80001716:	a021                	j	8000171e <copyout+0x74>
    80001718:	4501                	li	a0,0
}
    8000171a:	8082                	ret
      return -1;
    8000171c:	557d                	li	a0,-1
}
    8000171e:	60a6                	ld	ra,72(sp)
    80001720:	6406                	ld	s0,64(sp)
    80001722:	74e2                	ld	s1,56(sp)
    80001724:	7942                	ld	s2,48(sp)
    80001726:	79a2                	ld	s3,40(sp)
    80001728:	7a02                	ld	s4,32(sp)
    8000172a:	6ae2                	ld	s5,24(sp)
    8000172c:	6b42                	ld	s6,16(sp)
    8000172e:	6ba2                	ld	s7,8(sp)
    80001730:	6c02                	ld	s8,0(sp)
    80001732:	6161                	addi	sp,sp,80
    80001734:	8082                	ret

0000000080001736 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001736:	caa5                	beqz	a3,800017a6 <copyin+0x70>
{
    80001738:	715d                	addi	sp,sp,-80
    8000173a:	e486                	sd	ra,72(sp)
    8000173c:	e0a2                	sd	s0,64(sp)
    8000173e:	fc26                	sd	s1,56(sp)
    80001740:	f84a                	sd	s2,48(sp)
    80001742:	f44e                	sd	s3,40(sp)
    80001744:	f052                	sd	s4,32(sp)
    80001746:	ec56                	sd	s5,24(sp)
    80001748:	e85a                	sd	s6,16(sp)
    8000174a:	e45e                	sd	s7,8(sp)
    8000174c:	e062                	sd	s8,0(sp)
    8000174e:	0880                	addi	s0,sp,80
    80001750:	8b2a                	mv	s6,a0
    80001752:	8a2e                	mv	s4,a1
    80001754:	8c32                	mv	s8,a2
    80001756:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001758:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000175a:	6a85                	lui	s5,0x1
    8000175c:	a01d                	j	80001782 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000175e:	018505b3          	add	a1,a0,s8
    80001762:	0004861b          	sext.w	a2,s1
    80001766:	412585b3          	sub	a1,a1,s2
    8000176a:	8552                	mv	a0,s4
    8000176c:	fffff097          	auipc	ra,0xfffff
    80001770:	5e8080e7          	jalr	1512(ra) # 80000d54 <memmove>

    len -= n;
    80001774:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001778:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000177a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000177e:	02098263          	beqz	s3,800017a2 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001782:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001786:	85ca                	mv	a1,s2
    80001788:	855a                	mv	a0,s6
    8000178a:	00000097          	auipc	ra,0x0
    8000178e:	8ec080e7          	jalr	-1812(ra) # 80001076 <walkaddr>
    if(pa0 == 0)
    80001792:	cd01                	beqz	a0,800017aa <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001794:	418904b3          	sub	s1,s2,s8
    80001798:	94d6                	add	s1,s1,s5
    if(n > len)
    8000179a:	fc99f2e3          	bgeu	s3,s1,8000175e <copyin+0x28>
    8000179e:	84ce                	mv	s1,s3
    800017a0:	bf7d                	j	8000175e <copyin+0x28>
  }
  return 0;
    800017a2:	4501                	li	a0,0
    800017a4:	a021                	j	800017ac <copyin+0x76>
    800017a6:	4501                	li	a0,0
}
    800017a8:	8082                	ret
      return -1;
    800017aa:	557d                	li	a0,-1
}
    800017ac:	60a6                	ld	ra,72(sp)
    800017ae:	6406                	ld	s0,64(sp)
    800017b0:	74e2                	ld	s1,56(sp)
    800017b2:	7942                	ld	s2,48(sp)
    800017b4:	79a2                	ld	s3,40(sp)
    800017b6:	7a02                	ld	s4,32(sp)
    800017b8:	6ae2                	ld	s5,24(sp)
    800017ba:	6b42                	ld	s6,16(sp)
    800017bc:	6ba2                	ld	s7,8(sp)
    800017be:	6c02                	ld	s8,0(sp)
    800017c0:	6161                	addi	sp,sp,80
    800017c2:	8082                	ret

00000000800017c4 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017c4:	c6c5                	beqz	a3,8000186c <copyinstr+0xa8>
{
    800017c6:	715d                	addi	sp,sp,-80
    800017c8:	e486                	sd	ra,72(sp)
    800017ca:	e0a2                	sd	s0,64(sp)
    800017cc:	fc26                	sd	s1,56(sp)
    800017ce:	f84a                	sd	s2,48(sp)
    800017d0:	f44e                	sd	s3,40(sp)
    800017d2:	f052                	sd	s4,32(sp)
    800017d4:	ec56                	sd	s5,24(sp)
    800017d6:	e85a                	sd	s6,16(sp)
    800017d8:	e45e                	sd	s7,8(sp)
    800017da:	0880                	addi	s0,sp,80
    800017dc:	8a2a                	mv	s4,a0
    800017de:	8b2e                	mv	s6,a1
    800017e0:	8bb2                	mv	s7,a2
    800017e2:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017e4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017e6:	6985                	lui	s3,0x1
    800017e8:	a035                	j	80001814 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017ea:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017ee:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017f0:	0017b793          	seqz	a5,a5
    800017f4:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017f8:	60a6                	ld	ra,72(sp)
    800017fa:	6406                	ld	s0,64(sp)
    800017fc:	74e2                	ld	s1,56(sp)
    800017fe:	7942                	ld	s2,48(sp)
    80001800:	79a2                	ld	s3,40(sp)
    80001802:	7a02                	ld	s4,32(sp)
    80001804:	6ae2                	ld	s5,24(sp)
    80001806:	6b42                	ld	s6,16(sp)
    80001808:	6ba2                	ld	s7,8(sp)
    8000180a:	6161                	addi	sp,sp,80
    8000180c:	8082                	ret
    srcva = va0 + PGSIZE;
    8000180e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001812:	c8a9                	beqz	s1,80001864 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80001814:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001818:	85ca                	mv	a1,s2
    8000181a:	8552                	mv	a0,s4
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	85a080e7          	jalr	-1958(ra) # 80001076 <walkaddr>
    if(pa0 == 0)
    80001824:	c131                	beqz	a0,80001868 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001826:	41790833          	sub	a6,s2,s7
    8000182a:	984e                	add	a6,a6,s3
    if(n > max)
    8000182c:	0104f363          	bgeu	s1,a6,80001832 <copyinstr+0x6e>
    80001830:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001832:	955e                	add	a0,a0,s7
    80001834:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001838:	fc080be3          	beqz	a6,8000180e <copyinstr+0x4a>
    8000183c:	985a                	add	a6,a6,s6
    8000183e:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001840:	41650633          	sub	a2,a0,s6
    80001844:	14fd                	addi	s1,s1,-1
    80001846:	9b26                	add	s6,s6,s1
    80001848:	00f60733          	add	a4,a2,a5
    8000184c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8000>
    80001850:	df49                	beqz	a4,800017ea <copyinstr+0x26>
        *dst = *p;
    80001852:	00e78023          	sb	a4,0(a5)
      --max;
    80001856:	40fb04b3          	sub	s1,s6,a5
      dst++;
    8000185a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000185c:	ff0796e3          	bne	a5,a6,80001848 <copyinstr+0x84>
      dst++;
    80001860:	8b42                	mv	s6,a6
    80001862:	b775                	j	8000180e <copyinstr+0x4a>
    80001864:	4781                	li	a5,0
    80001866:	b769                	j	800017f0 <copyinstr+0x2c>
      return -1;
    80001868:	557d                	li	a0,-1
    8000186a:	b779                	j	800017f8 <copyinstr+0x34>
  int got_null = 0;
    8000186c:	4781                	li	a5,0
  if(got_null){
    8000186e:	0017b793          	seqz	a5,a5
    80001872:	40f00533          	neg	a0,a5
}
    80001876:	8082                	ret

0000000080001878 <init_queue>:
#define __DE_MOVE___(P, SRC, DST)       do { dequeue(SRC); enqueue(DST, P); } while(0)
#define __RE_MOVE___(P, SRC, DST)       do { enqueue(DST, remove(SRC, P)); } while(0)

//
// Make it all zeros.
void init_queue(_queue* q, int id) { 
    80001878:	1141                	addi	sp,sp,-16
    8000187a:	e422                	sd	s0,8(sp)
    8000187c:	0800                	addi	s0,sp,16
  q->q_id = id; 
    8000187e:	c10c                	sw	a1,0(a0)
  q->q_head = q->q_tail = 0; 
    80001880:	00053823          	sd	zero,16(a0)
    80001884:	00053423          	sd	zero,8(a0)
  q->q_cnt = 0;
    80001888:	00052223          	sw	zero,4(a0)
};
    8000188c:	6422                	ld	s0,8(sp)
    8000188e:	0141                	addi	sp,sp,16
    80001890:	8082                	ret

0000000080001892 <show_queue_status>:

// Console debug purpose.
void show_queue_status() {
    80001892:	1101                	addi	sp,sp,-32
    80001894:	ec06                	sd	ra,24(sp)
    80001896:	e822                	sd	s0,16(sp)
    80001898:	e426                	sd	s1,8(sp)
    8000189a:	1000                	addi	s0,sp,32
// record_tick() is deprecated. Do not use it.


// Queue controls
// 
int is_empty(_queue* q) { return (q->q_cnt == 0); } 
    8000189c:	00010497          	auipc	s1,0x10
    800018a0:	0b448493          	addi	s1,s1,180 # 80011950 <q2>
    800018a4:	40d0                	lw	a2,4(s1)
  printf("Q2 status check: %d, %d, %p, %p\n", !is_empty(&q2), get_cnt(&q2), get_head(&q2), get_tail(&q2));
    800018a6:	6898                	ld	a4,16(s1)
    800018a8:	6494                	ld	a3,8(s1)
    800018aa:	00c035b3          	snez	a1,a2
    800018ae:	00007517          	auipc	a0,0x7
    800018b2:	93a50513          	addi	a0,a0,-1734 # 800081e8 <digits+0x1a8>
    800018b6:	fffff097          	auipc	ra,0xfffff
    800018ba:	cd4080e7          	jalr	-812(ra) # 8000058a <printf>
int is_empty(_queue* q) { return (q->q_cnt == 0); } 
    800018be:	4cd0                	lw	a2,28(s1)
  printf("Q1 status check: %d, %d, %p, %p\n", !is_empty(&q1), get_cnt(&q1), get_head(&q1), get_tail(&q1));
    800018c0:	7498                	ld	a4,40(s1)
    800018c2:	7094                	ld	a3,32(s1)
    800018c4:	00c035b3          	snez	a1,a2
    800018c8:	00007517          	auipc	a0,0x7
    800018cc:	94850513          	addi	a0,a0,-1720 # 80008210 <digits+0x1d0>
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	cba080e7          	jalr	-838(ra) # 8000058a <printf>
int is_empty(_queue* q) { return (q->q_cnt == 0); } 
    800018d8:	58d0                	lw	a2,52(s1)
  printf("Q0 status check: %d, %d, %p, %p\n\n", !is_empty(&q0), get_cnt(&q0), get_head(&q0), get_tail(&q0));
    800018da:	60b8                	ld	a4,64(s1)
    800018dc:	7c94                	ld	a3,56(s1)
    800018de:	00c035b3          	snez	a1,a2
    800018e2:	00007517          	auipc	a0,0x7
    800018e6:	95650513          	addi	a0,a0,-1706 # 80008238 <digits+0x1f8>
    800018ea:	fffff097          	auipc	ra,0xfffff
    800018ee:	ca0080e7          	jalr	-864(ra) # 8000058a <printf>
}
    800018f2:	60e2                	ld	ra,24(sp)
    800018f4:	6442                	ld	s0,16(sp)
    800018f6:	64a2                	ld	s1,8(sp)
    800018f8:	6105                	addi	sp,sp,32
    800018fa:	8082                	ret

00000000800018fc <is_q2>:
int is_q2(struct proc* p) { return p->p_id == Q2; }
    800018fc:	1141                	addi	sp,sp,-16
    800018fe:	e422                	sd	s0,8(sp)
    80001900:	0800                	addi	s0,sp,16
    80001902:	16852503          	lw	a0,360(a0)
    80001906:	1579                	addi	a0,a0,-2
    80001908:	00153513          	seqz	a0,a0
    8000190c:	6422                	ld	s0,8(sp)
    8000190e:	0141                	addi	sp,sp,16
    80001910:	8082                	ret

0000000080001912 <is_q1>:
int is_q1(struct proc* p) { return p->p_id == Q1; }
    80001912:	1141                	addi	sp,sp,-16
    80001914:	e422                	sd	s0,8(sp)
    80001916:	0800                	addi	s0,sp,16
    80001918:	16852503          	lw	a0,360(a0)
    8000191c:	157d                	addi	a0,a0,-1
    8000191e:	00153513          	seqz	a0,a0
    80001922:	6422                	ld	s0,8(sp)
    80001924:	0141                	addi	sp,sp,16
    80001926:	8082                	ret

0000000080001928 <is_q0>:
int is_q0(struct proc* p) { return p->p_id == Q0; }
    80001928:	1141                	addi	sp,sp,-16
    8000192a:	e422                	sd	s0,8(sp)
    8000192c:	0800                	addi	s0,sp,16
    8000192e:	16852503          	lw	a0,360(a0)
    80001932:	00153513          	seqz	a0,a0
    80001936:	6422                	ld	s0,8(sp)
    80001938:	0141                	addi	sp,sp,16
    8000193a:	8082                	ret

000000008000193c <color>:
int color(struct proc* p, int id) {  p->p_id = id; return id; }
    8000193c:	1141                	addi	sp,sp,-16
    8000193e:	e422                	sd	s0,8(sp)
    80001940:	0800                	addi	s0,sp,16
    80001942:	16b52423          	sw	a1,360(a0)
    80001946:	852e                	mv	a0,a1
    80001948:	6422                	ld	s0,8(sp)
    8000194a:	0141                	addi	sp,sp,16
    8000194c:	8082                	ret

000000008000194e <uncolor>:
int uncolor(struct proc* p) {  p->p_id = UD; return UD; }
    8000194e:	1141                	addi	sp,sp,-16
    80001950:	e422                	sd	s0,8(sp)
    80001952:	0800                	addi	s0,sp,16
    80001954:	57fd                	li	a5,-1
    80001956:	16f52423          	sw	a5,360(a0)
    8000195a:	557d                	li	a0,-1
    8000195c:	6422                	ld	s0,8(sp)
    8000195e:	0141                	addi	sp,sp,16
    80001960:	8082                	ret

0000000080001962 <ground>:
int ground(struct proc* p) { p->p_next = p->p_prev = 0; return 0;}
    80001962:	1141                	addi	sp,sp,-16
    80001964:	e422                	sd	s0,8(sp)
    80001966:	0800                	addi	s0,sp,16
    80001968:	18053023          	sd	zero,384(a0)
    8000196c:	18053423          	sd	zero,392(a0)
    80001970:	4501                	li	a0,0
    80001972:	6422                	ld	s0,8(sp)
    80001974:	0141                	addi	sp,sp,16
    80001976:	8082                	ret

0000000080001978 <record_tick>:
int record_tick(struct proc* p, int qid) { p->p_ticks[qid]++; return p->p_ticks[qid]; }
    80001978:	1141                	addi	sp,sp,-16
    8000197a:	e422                	sd	s0,8(sp)
    8000197c:	0800                	addi	s0,sp,16
    8000197e:	058a                	slli	a1,a1,0x2
    80001980:	95aa                	add	a1,a1,a0
    80001982:	16c5a503          	lw	a0,364(a1)
    80001986:	2505                	addiw	a0,a0,1
    80001988:	16a5a623          	sw	a0,364(a1)
    8000198c:	2501                	sext.w	a0,a0
    8000198e:	6422                	ld	s0,8(sp)
    80001990:	0141                	addi	sp,sp,16
    80001992:	8082                	ret

0000000080001994 <record_tick2>:
int record_tick2(struct proc* p, uint gtick) { 
    80001994:	1141                	addi	sp,sp,-16
    80001996:	e422                	sd	s0,8(sp)
    80001998:	0800                	addi	s0,sp,16
  p->p_ticks[p->p_id] += (gtick - p->p_stp);
    8000199a:	16852703          	lw	a4,360(a0)
    8000199e:	070a                	slli	a4,a4,0x2
    800019a0:	972a                	add	a4,a4,a0
    800019a2:	16c72783          	lw	a5,364(a4)
    800019a6:	17852683          	lw	a3,376(a0)
    800019aa:	9f95                	subw	a5,a5,a3
    800019ac:	9fad                	addw	a5,a5,a1
    800019ae:	16f72623          	sw	a5,364(a4)
  p->p_stp = gtick;
    800019b2:	16b52c23          	sw	a1,376(a0)
}
    800019b6:	0007851b          	sext.w	a0,a5
    800019ba:	6422                	ld	s0,8(sp)
    800019bc:	0141                	addi	sp,sp,16
    800019be:	8082                	ret

00000000800019c0 <is_empty>:
int is_empty(_queue* q) { return (q->q_cnt == 0); } 
    800019c0:	1141                	addi	sp,sp,-16
    800019c2:	e422                	sd	s0,8(sp)
    800019c4:	0800                	addi	s0,sp,16
    800019c6:	4148                	lw	a0,4(a0)
    800019c8:	00153513          	seqz	a0,a0
    800019cc:	6422                	ld	s0,8(sp)
    800019ce:	0141                	addi	sp,sp,16
    800019d0:	8082                	ret

00000000800019d2 <get_head>:

struct proc* get_head(_queue* q) { return q->q_head; }
    800019d2:	1141                	addi	sp,sp,-16
    800019d4:	e422                	sd	s0,8(sp)
    800019d6:	0800                	addi	s0,sp,16
    800019d8:	6508                	ld	a0,8(a0)
    800019da:	6422                	ld	s0,8(sp)
    800019dc:	0141                	addi	sp,sp,16
    800019de:	8082                	ret

00000000800019e0 <get_tail>:
struct proc* get_tail(_queue* q) { return q->q_tail; }
    800019e0:	1141                	addi	sp,sp,-16
    800019e2:	e422                	sd	s0,8(sp)
    800019e4:	0800                	addi	s0,sp,16
    800019e6:	6908                	ld	a0,16(a0)
    800019e8:	6422                	ld	s0,8(sp)
    800019ea:	0141                	addi	sp,sp,16
    800019ec:	8082                	ret

00000000800019ee <get_cnt>:
int get_cnt(_queue* q) { return q->q_cnt; }
    800019ee:	1141                	addi	sp,sp,-16
    800019f0:	e422                	sd	s0,8(sp)
    800019f2:	0800                	addi	s0,sp,16
    800019f4:	4148                	lw	a0,4(a0)
    800019f6:	6422                	ld	s0,8(sp)
    800019f8:	0141                	addi	sp,sp,16
    800019fa:	8082                	ret

00000000800019fc <run_this>:

// 
// This function is responsible in deciding the next process to run.
struct proc* run_this(struct proc* p) {
    800019fc:	1101                	addi	sp,sp,-32
    800019fe:	ec06                	sd	ra,24(sp)
    80001a00:	e822                	sd	s0,16(sp)
    80001a02:	e426                	sd	s1,8(sp)
    80001a04:	e04a                	sd	s2,0(sp)
    80001a06:	1000                	addi	s0,sp,32
  struct proc* rp;
  
  // If the process is fixed to 0, the kernaltrap will be on. 
  // Thus, it should be prevented.
  if (p == 0) return get_head(&q2);
    80001a08:	c521                	beqz	a0,80001a50 <run_this+0x54>
    80001a0a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001a0c:	fffff097          	auipc	ra,0xfffff
    80001a10:	1f0080e7          	jalr	496(ra) # 80000bfc <acquire>

  if (p->p_next == 0) { // case when at the end of loop
    80001a14:	1884b903          	ld	s2,392(s1)
    80001a18:	04090163          	beqz	s2,80001a5a <run_this+0x5e>
    else rp = get_head(&q1);
    // If it is the end of the queue, 
    // the next process to run is always the head of the queue.
    // This holds true only when q2 is not empty.
  } else {
    if (!is_empty(&q2)) { // Case when q2 is empty, which is q1's turn.
    80001a1c:	00010797          	auipc	a5,0x10
    80001a20:	f387a783          	lw	a5,-200(a5) # 80011954 <q2+0x4>
    80001a24:	cb91                	beqz	a5,80001a38 <run_this+0x3c>
      if (is_q1(p)) rp = get_head(&q2);
    80001a26:	1684a703          	lw	a4,360(s1)
    80001a2a:	4785                	li	a5,1
    80001a2c:	00f71663          	bne	a4,a5,80001a38 <run_this+0x3c>
struct proc* get_head(_queue* q) { return q->q_head; }
    80001a30:	00010917          	auipc	s2,0x10
    80001a34:	f2893903          	ld	s2,-216(s2) # 80011958 <q2+0x8>
      else rp = p->p_next;
    } else rp = p->p_next;
  }
  release(&p->lock);
    80001a38:	8526                	mv	a0,s1
    80001a3a:	fffff097          	auipc	ra,0xfffff
    80001a3e:	276080e7          	jalr	630(ra) # 80000cb0 <release>
  return rp;
}
    80001a42:	854a                	mv	a0,s2
    80001a44:	60e2                	ld	ra,24(sp)
    80001a46:	6442                	ld	s0,16(sp)
    80001a48:	64a2                	ld	s1,8(sp)
    80001a4a:	6902                	ld	s2,0(sp)
    80001a4c:	6105                	addi	sp,sp,32
    80001a4e:	8082                	ret
struct proc* get_head(_queue* q) { return q->q_head; }
    80001a50:	00010917          	auipc	s2,0x10
    80001a54:	f0893903          	ld	s2,-248(s2) # 80011958 <q2+0x8>
  if (p == 0) return get_head(&q2);
    80001a58:	b7ed                	j	80001a42 <run_this+0x46>
    if (!is_empty(&q2)) rp = get_head(&q2);
    80001a5a:	00010797          	auipc	a5,0x10
    80001a5e:	efa7a783          	lw	a5,-262(a5) # 80011954 <q2+0x4>
    80001a62:	c791                	beqz	a5,80001a6e <run_this+0x72>
struct proc* get_head(_queue* q) { return q->q_head; }
    80001a64:	00010917          	auipc	s2,0x10
    80001a68:	ef493903          	ld	s2,-268(s2) # 80011958 <q2+0x8>
    80001a6c:	b7f1                	j	80001a38 <run_this+0x3c>
    80001a6e:	00010917          	auipc	s2,0x10
    80001a72:	f0293903          	ld	s2,-254(s2) # 80011970 <q1+0x8>
    80001a76:	b7c9                	j	80001a38 <run_this+0x3c>

0000000080001a78 <enqueue>:

// Simple enqueueing function.
struct proc* enqueue(_queue* q, struct proc* p) {
    80001a78:	1141                	addi	sp,sp,-16
    80001a7a:	e422                	sd	s0,8(sp)
    80001a7c:	0800                	addi	s0,sp,16
    80001a7e:	87aa                	mv	a5,a0
    80001a80:	852e                	mv	a0,a1
  color(p, q->q_id); // color it first
    80001a82:	4398                	lw	a4,0(a5)
int color(struct proc* p, int id) {  p->p_id = id; return id; }
    80001a84:	16e5a423          	sw	a4,360(a1)
  
  if (is_empty(q)) { ground(p); q->q_head = q->q_tail = p; }
    80001a88:	43d8                	lw	a4,4(a5)
    80001a8a:	c305                	beqz	a4,80001aaa <enqueue+0x32>
  else {
    q->q_tail->p_next = p;
    80001a8c:	6b98                	ld	a4,16(a5)
    80001a8e:	18b73423          	sd	a1,392(a4)
    p->p_prev = q->q_tail;
    80001a92:	6b98                	ld	a4,16(a5)
    80001a94:	18e5b023          	sd	a4,384(a1)
    p->p_next = 0;
    80001a98:	1805b423          	sd	zero,392(a1)
    q->q_tail = p;
    80001a9c:	eb8c                	sd	a1,16(a5)
  }

  q->q_cnt++;  
    80001a9e:	43d8                	lw	a4,4(a5)
    80001aa0:	2705                	addiw	a4,a4,1
    80001aa2:	c3d8                	sw	a4,4(a5)
  return p;
}
    80001aa4:	6422                	ld	s0,8(sp)
    80001aa6:	0141                	addi	sp,sp,16
    80001aa8:	8082                	ret
int ground(struct proc* p) { p->p_next = p->p_prev = 0; return 0;}
    80001aaa:	1805b023          	sd	zero,384(a1)
    80001aae:	1805b423          	sd	zero,392(a1)
  if (is_empty(q)) { ground(p); q->q_head = q->q_tail = p; }
    80001ab2:	eb8c                	sd	a1,16(a5)
    80001ab4:	e78c                	sd	a1,8(a5)
    80001ab6:	b7e5                	j	80001a9e <enqueue+0x26>

0000000080001ab8 <dequeue>:

// Simple dequeueing function.
struct proc* dequeue(_queue* q) {
    80001ab8:	1141                	addi	sp,sp,-16
    80001aba:	e422                	sd	s0,8(sp)
    80001abc:	0800                	addi	s0,sp,16
    80001abe:	87aa                	mv	a5,a0
  struct proc* p = q->q_head;
    80001ac0:	6508                	ld	a0,8(a0)
int is_empty(_queue* q) { return (q->q_cnt == 0); } 
    80001ac2:	43d8                	lw	a4,4(a5)
  if (is_empty(q)) return 0;
    80001ac4:	cb1d                	beqz	a4,80001afa <dequeue+0x42>

  // When single element exists
  if (q->q_cnt == 1) q->q_head = q->q_tail = 0;
    80001ac6:	4685                	li	a3,1
    80001ac8:	02d70463          	beq	a4,a3,80001af0 <dequeue+0x38>
  else {
    q->q_head = p->p_next;
    80001acc:	18853703          	ld	a4,392(a0)
    80001ad0:	e798                	sd	a4,8(a5)
    q->q_head->p_prev = 0;
    80001ad2:	18073023          	sd	zero,384(a4)
int uncolor(struct proc* p) {  p->p_id = UD; return UD; }
    80001ad6:	577d                	li	a4,-1
    80001ad8:	16e52423          	sw	a4,360(a0)
int ground(struct proc* p) { p->p_next = p->p_prev = 0; return 0;}
    80001adc:	18053023          	sd	zero,384(a0)
    80001ae0:	18053423          	sd	zero,392(a0)
  }
  uncolor(p); // remove color
  ground(p);

  q->q_cnt--;
    80001ae4:	43d8                	lw	a4,4(a5)
    80001ae6:	377d                	addiw	a4,a4,-1
    80001ae8:	c3d8                	sw	a4,4(a5)
  return p;
}
    80001aea:	6422                	ld	s0,8(sp)
    80001aec:	0141                	addi	sp,sp,16
    80001aee:	8082                	ret
  if (q->q_cnt == 1) q->q_head = q->q_tail = 0;
    80001af0:	0007b823          	sd	zero,16(a5)
    80001af4:	0007b423          	sd	zero,8(a5)
    80001af8:	bff9                	j	80001ad6 <dequeue+0x1e>
  if (is_empty(q)) return 0;
    80001afa:	4501                	li	a0,0
    80001afc:	b7fd                	j	80001aea <dequeue+0x32>

0000000080001afe <remove>:

// This function removes a specific element from queue.
// It is necessary operation, since a process located in the middle of the queue
// might be freed early. It is not desirable to hold a dead process information
// in q1 or q2, so it should be removed.
struct proc* remove(_queue* q, struct proc* tp) { 
    80001afe:	1141                	addi	sp,sp,-16
    80001b00:	e422                	sd	s0,8(sp)
    80001b02:	0800                	addi	s0,sp,16
    80001b04:	87aa                	mv	a5,a0
  struct proc* np = q->q_head;
    80001b06:	6508                	ld	a0,8(a0)
int is_empty(_queue* q) { return (q->q_cnt == 0); } 
    80001b08:	43d8                	lw	a4,4(a5)
  // search
  if (is_empty(q)) { return 0; } // case when empty
    80001b0a:	cf2d                	beqz	a4,80001b84 <remove+0x86>
  while (np != tp && np != 0) np = np->p_next; // search for target
    80001b0c:	00b50963          	beq	a0,a1,80001b1e <remove+0x20>
    80001b10:	c931                	beqz	a0,80001b64 <remove+0x66>
    80001b12:	18853503          	ld	a0,392(a0)
    80001b16:	00a58563          	beq	a1,a0,80001b20 <remove+0x22>
    80001b1a:	fd65                	bnez	a0,80001b12 <remove+0x14>
    80001b1c:	a0a1                	j	80001b64 <remove+0x66>
  struct proc* np = q->q_head;
    80001b1e:	852e                	mv	a0,a1
  if (np == 0) { return 0; } // not found
    80001b20:	c131                	beqz	a0,80001b64 <remove+0x66>

  if (q->q_cnt == 1) { q->q_head = q->q_tail = 0; }
    80001b22:	4685                	li	a3,1
    80001b24:	04d70363          	beq	a4,a3,80001b6a <remove+0x6c>
  else {
    if (np->p_prev != 0) np->p_prev->p_next = np->p_next;  // not in front
    80001b28:	18053703          	ld	a4,384(a0)
    80001b2c:	c709                	beqz	a4,80001b36 <remove+0x38>
    80001b2e:	18853683          	ld	a3,392(a0)
    80001b32:	18d73423          	sd	a3,392(a4)
    if (np->p_next != 0) np->p_next->p_prev = np->p_prev;  // not in rear
    80001b36:	18853703          	ld	a4,392(a0)
    80001b3a:	c709                	beqz	a4,80001b44 <remove+0x46>
    80001b3c:	18053683          	ld	a3,384(a0)
    80001b40:	18d73023          	sd	a3,384(a4)
    if (np == q->q_head) q->q_head = np->p_next; 
    80001b44:	6798                	ld	a4,8(a5)
    80001b46:	02e50763          	beq	a0,a4,80001b74 <remove+0x76>
    if (np == q->q_tail) q->q_tail = np->p_prev; 
    80001b4a:	6b98                	ld	a4,16(a5)
    80001b4c:	02e50863          	beq	a0,a4,80001b7c <remove+0x7e>
int uncolor(struct proc* p) {  p->p_id = UD; return UD; }
    80001b50:	577d                	li	a4,-1
    80001b52:	16e52423          	sw	a4,360(a0)
int ground(struct proc* p) { p->p_next = p->p_prev = 0; return 0;}
    80001b56:	18053023          	sd	zero,384(a0)
    80001b5a:	18053423          	sd	zero,392(a0)

  // Delete the information needed for queueing.
  uncolor(np);
  ground(np);

  q->q_cnt--;
    80001b5e:	43d8                	lw	a4,4(a5)
    80001b60:	377d                	addiw	a4,a4,-1
    80001b62:	c3d8                	sw	a4,4(a5)
  return np;
}
    80001b64:	6422                	ld	s0,8(sp)
    80001b66:	0141                	addi	sp,sp,16
    80001b68:	8082                	ret
  if (q->q_cnt == 1) { q->q_head = q->q_tail = 0; }
    80001b6a:	0007b823          	sd	zero,16(a5)
    80001b6e:	0007b423          	sd	zero,8(a5)
    80001b72:	bff9                	j	80001b50 <remove+0x52>
    if (np == q->q_head) q->q_head = np->p_next; 
    80001b74:	18853703          	ld	a4,392(a0)
    80001b78:	e798                	sd	a4,8(a5)
    80001b7a:	bfc1                	j	80001b4a <remove+0x4c>
    if (np == q->q_tail) q->q_tail = np->p_prev; 
    80001b7c:	18053703          	ld	a4,384(a0)
    80001b80:	eb98                	sd	a4,16(a5)
    80001b82:	b7f9                	j	80001b50 <remove+0x52>
  if (is_empty(q)) { return 0; } // case when empty
    80001b84:	4501                	li	a0,0
    80001b86:	bff9                	j	80001b64 <remove+0x66>

0000000080001b88 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001b88:	1101                	addi	sp,sp,-32
    80001b8a:	ec06                	sd	ra,24(sp)
    80001b8c:	e822                	sd	s0,16(sp)
    80001b8e:	e426                	sd	s1,8(sp)
    80001b90:	1000                	addi	s0,sp,32
    80001b92:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001b94:	fffff097          	auipc	ra,0xfffff
    80001b98:	fee080e7          	jalr	-18(ra) # 80000b82 <holding>
    80001b9c:	c909                	beqz	a0,80001bae <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001b9e:	749c                	ld	a5,40(s1)
    80001ba0:	00978f63          	beq	a5,s1,80001bbe <wakeup1+0x36>
#ifdef SUKJOON
    if (is_q0(p)) // Move to q2
      __RE_MOVE___(p, &q0, &q2);
#endif
  }
}
    80001ba4:	60e2                	ld	ra,24(sp)
    80001ba6:	6442                	ld	s0,16(sp)
    80001ba8:	64a2                	ld	s1,8(sp)
    80001baa:	6105                	addi	sp,sp,32
    80001bac:	8082                	ret
    panic("wakeup1");
    80001bae:	00006517          	auipc	a0,0x6
    80001bb2:	6b250513          	addi	a0,a0,1714 # 80008260 <digits+0x220>
    80001bb6:	fffff097          	auipc	ra,0xfffff
    80001bba:	98a080e7          	jalr	-1654(ra) # 80000540 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001bbe:	4c98                	lw	a4,24(s1)
    80001bc0:	4785                	li	a5,1
    80001bc2:	fef711e3          	bne	a4,a5,80001ba4 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001bc6:	4789                	li	a5,2
    80001bc8:	cc9c                	sw	a5,24(s1)
    if (is_q0(p)) // Move to q2
    80001bca:	1684a783          	lw	a5,360(s1)
    80001bce:	fbf9                	bnez	a5,80001ba4 <wakeup1+0x1c>
      __RE_MOVE___(p, &q0, &q2);
    80001bd0:	85a6                	mv	a1,s1
    80001bd2:	00010517          	auipc	a0,0x10
    80001bd6:	dae50513          	addi	a0,a0,-594 # 80011980 <q0>
    80001bda:	00000097          	auipc	ra,0x0
    80001bde:	f24080e7          	jalr	-220(ra) # 80001afe <remove>
    80001be2:	85aa                	mv	a1,a0
    80001be4:	00010517          	auipc	a0,0x10
    80001be8:	d6c50513          	addi	a0,a0,-660 # 80011950 <q2>
    80001bec:	00000097          	auipc	ra,0x0
    80001bf0:	e8c080e7          	jalr	-372(ra) # 80001a78 <enqueue>
}
    80001bf4:	bf45                	j	80001ba4 <wakeup1+0x1c>

0000000080001bf6 <mlfq_like>:
void mlfq_like() {
    80001bf6:	711d                	addi	sp,sp,-96
    80001bf8:	ec86                	sd	ra,88(sp)
    80001bfa:	e8a2                	sd	s0,80(sp)
    80001bfc:	e4a6                	sd	s1,72(sp)
    80001bfe:	e0ca                	sd	s2,64(sp)
    80001c00:	fc4e                	sd	s3,56(sp)
    80001c02:	f852                	sd	s4,48(sp)
    80001c04:	f456                	sd	s5,40(sp)
    80001c06:	f05a                	sd	s6,32(sp)
    80001c08:	ec5e                	sd	s7,24(sp)
    80001c0a:	e862                	sd	s8,16(sp)
    80001c0c:	e466                	sd	s9,8(sp)
    80001c0e:	1080                	addi	s0,sp,96
struct proc* get_head(_queue* q) { return q->q_head; }
    80001c10:	00010717          	auipc	a4,0x10
    80001c14:	d4070713          	addi	a4,a4,-704 # 80011950 <q2>
    80001c18:	6704                	ld	s1,8(a4)
    80001c1a:	02073903          	ld	s2,32(a4)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c1e:	8792                	mv	a5,tp
  int id = r_tp();
    80001c20:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001c22:	00779c93          	slli	s9,a5,0x7
    80001c26:	9766                	add	a4,a4,s9
    80001c28:	04073423          	sd	zero,72(a4)
          if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001c2c:	00010717          	auipc	a4,0x10
    80001c30:	d7470713          	addi	a4,a4,-652 # 800119a0 <cpus+0x8>
    80001c34:	9cba                	add	s9,s9,a4
        else if (  p == rt && is_q1(p) ) { // case when it is time for q2 to run.
    80001c36:	4a05                	li	s4,1
      for(p = proc; p < &proc[NPROC]; p++) {
    80001c38:	00016997          	auipc	s3,0x16
    80001c3c:	77898993          	addi	s3,s3,1912 # 800183b0 <tickslock>
          else if (p->state == SLEEPING || p->state == ZOMBIE) { __RE_MOVE___(p, &q1, &q0); }
    80001c40:	00010b97          	auipc	s7,0x10
    80001c44:	d28b8b93          	addi	s7,s7,-728 # 80011968 <q1>
          if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001c48:	00010c17          	auipc	s8,0x10
    80001c4c:	d08c0c13          	addi	s8,s8,-760 # 80011950 <q2>
    80001c50:	079e                	slli	a5,a5,0x7
    80001c52:	00fc0b33          	add	s6,s8,a5
    80001c56:	aa0d                	j	80001d88 <mlfq_like+0x192>
          if (pb->state == RUNNABLE) {
    80001c58:	01892703          	lw	a4,24(s2)
    80001c5c:	4789                	li	a5,2
    80001c5e:	02f70063          	beq	a4,a5,80001c7e <mlfq_like+0x88>
          else if (p->state == SLEEPING || p->state == ZOMBIE) { __RE_MOVE___(p, &q1, &q0); }
    80001c62:	4d9c                	lw	a5,24(a1)
    80001c64:	05478263          	beq	a5,s4,80001ca8 <mlfq_like+0xb2>
    80001c68:	4711                	li	a4,4
    80001c6a:	02e78f63          	beq	a5,a4,80001ca8 <mlfq_like+0xb2>
          else if (p->state == UNUSED) { remove(&q1, p); }
    80001c6e:	10079263          	bnez	a5,80001d72 <mlfq_like+0x17c>
    80001c72:	855e                	mv	a0,s7
    80001c74:	00000097          	auipc	ra,0x0
    80001c78:	e8a080e7          	jalr	-374(ra) # 80001afe <remove>
    80001c7c:	a8dd                	j	80001d72 <mlfq_like+0x17c>
            __CONTEXT_SWITCH__(c, pb); // defined in macro.
    80001c7e:	478d                	li	a5,3
    80001c80:	00f92c23          	sw	a5,24(s2)
    80001c84:	052b3423          	sd	s2,72(s6) # 1048 <_entry-0x7fffefb8>
    80001c88:	06090593          	addi	a1,s2,96
    80001c8c:	8566                	mv	a0,s9
    80001c8e:	00001097          	auipc	ra,0x1
    80001c92:	efa080e7          	jalr	-262(ra) # 80002b88 <swtch>
    80001c96:	040b3423          	sd	zero,72(s6)
            pb = pb->p_next;
    80001c9a:	18893903          	ld	s2,392(s2)
            if (pb == 0) pb = get_head(&q1);
    80001c9e:	0c091a63          	bnez	s2,80001d72 <mlfq_like+0x17c>
struct proc* get_head(_queue* q) { return q->q_head; }
    80001ca2:	020c3903          	ld	s2,32(s8)
    80001ca6:	a0f1                	j	80001d72 <mlfq_like+0x17c>
          else if (p->state == SLEEPING || p->state == ZOMBIE) { __RE_MOVE___(p, &q1, &q0); }
    80001ca8:	855e                	mv	a0,s7
    80001caa:	00000097          	auipc	ra,0x0
    80001cae:	e54080e7          	jalr	-428(ra) # 80001afe <remove>
    80001cb2:	85aa                	mv	a1,a0
    80001cb4:	00010517          	auipc	a0,0x10
    80001cb8:	ccc50513          	addi	a0,a0,-820 # 80011980 <q0>
    80001cbc:	00000097          	auipc	ra,0x0
    80001cc0:	dbc080e7          	jalr	-580(ra) # 80001a78 <enqueue>
    80001cc4:	a07d                	j	80001d72 <mlfq_like+0x17c>
        else if (  p == rt && is_q2(p) ) { // case when it is time for q2 to run.
    80001cc6:	02b48463          	beq	s1,a1,80001cee <mlfq_like+0xf8>
      for(p = proc; p < &proc[NPROC]; p++) {
    80001cca:	19858593          	addi	a1,a1,408
    80001cce:	0b358263          	beq	a1,s3,80001d72 <mlfq_like+0x17c>
        if (pb != 0 && p->p_next == 0 && is_q2(p)) {
    80001cd2:	fe090ae3          	beqz	s2,80001cc6 <mlfq_like+0xd0>
    80001cd6:	1885b783          	ld	a5,392(a1)
    80001cda:	f7f5                	bnez	a5,80001cc6 <mlfq_like+0xd0>
    80001cdc:	1685a783          	lw	a5,360(a1)
    80001ce0:	f6e78ce3          	beq	a5,a4,80001c58 <mlfq_like+0x62>
        else if (  p == rt && is_q2(p) ) { // case when it is time for q2 to run.
    80001ce4:	feb493e3          	bne	s1,a1,80001cca <mlfq_like+0xd4>
int is_q2(struct proc* p) { return p->p_id == Q2; }
    80001ce8:	1685a783          	lw	a5,360(a1)
    80001cec:	a029                	j	80001cf6 <mlfq_like+0x100>
    80001cee:	1685a783          	lw	a5,360(a1)
        else if (  p == rt && is_q2(p) ) { // case when it is time for q2 to run.
    80001cf2:	02e78463          	beq	a5,a4,80001d1a <mlfq_like+0x124>
        else if (  p == rt && is_q1(p) ) { // case when it is time for q2 to run.
    80001cf6:	fd479ae3          	bne	a5,s4,80001cca <mlfq_like+0xd4>
          if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001cfa:	4d9c                	lw	a5,24(a1)
    80001cfc:	4709                	li	a4,2
    80001cfe:	0ae78863          	beq	a5,a4,80001dae <mlfq_like+0x1b8>
          else if (p->state == SLEEPING || p->state == ZOMBIE) { __RE_MOVE___(p, &q1, &q0); }
    80001d02:	0d478463          	beq	a5,s4,80001dca <mlfq_like+0x1d4>
    80001d06:	4711                	li	a4,4
    80001d08:	0ce78163          	beq	a5,a4,80001dca <mlfq_like+0x1d4>
          else if (p->state == UNUSED) { remove(&q1, p); }  
    80001d0c:	e3bd                	bnez	a5,80001d72 <mlfq_like+0x17c>
    80001d0e:	855e                	mv	a0,s7
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	dee080e7          	jalr	-530(ra) # 80001afe <remove>
    80001d18:	a8a9                	j	80001d72 <mlfq_like+0x17c>
          if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001d1a:	4d9c                	lw	a5,24(a1)
    80001d1c:	4709                	li	a4,2
    80001d1e:	00e78e63          	beq	a5,a4,80001d3a <mlfq_like+0x144>
          else if (p->state == SLEEPING || p->state == ZOMBIE) { __RE_MOVE___(p, &q2, &q0); }
    80001d22:	03478a63          	beq	a5,s4,80001d56 <mlfq_like+0x160>
    80001d26:	4711                	li	a4,4
    80001d28:	02e78763          	beq	a5,a4,80001d56 <mlfq_like+0x160>
          else if (p->state == UNUSED) { remove(&q2, p); }
    80001d2c:	e3b9                	bnez	a5,80001d72 <mlfq_like+0x17c>
    80001d2e:	8562                	mv	a0,s8
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	dce080e7          	jalr	-562(ra) # 80001afe <remove>
    80001d38:	a82d                	j	80001d72 <mlfq_like+0x17c>
          if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001d3a:	478d                	li	a5,3
    80001d3c:	cd9c                	sw	a5,24(a1)
    80001d3e:	04bb3423          	sd	a1,72(s6)
    80001d42:	06058593          	addi	a1,a1,96
    80001d46:	8566                	mv	a0,s9
    80001d48:	00001097          	auipc	ra,0x1
    80001d4c:	e40080e7          	jalr	-448(ra) # 80002b88 <swtch>
    80001d50:	040b3423          	sd	zero,72(s6)
    80001d54:	a839                	j	80001d72 <mlfq_like+0x17c>
          else if (p->state == SLEEPING || p->state == ZOMBIE) { __RE_MOVE___(p, &q2, &q0); }
    80001d56:	8562                	mv	a0,s8
    80001d58:	00000097          	auipc	ra,0x0
    80001d5c:	da6080e7          	jalr	-602(ra) # 80001afe <remove>
    80001d60:	85aa                	mv	a1,a0
    80001d62:	00010517          	auipc	a0,0x10
    80001d66:	c1e50513          	addi	a0,a0,-994 # 80011980 <q0>
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	d0e080e7          	jalr	-754(ra) # 80001a78 <enqueue>
      release(&rt->lock);
    80001d72:	8556                	mv	a0,s5
    80001d74:	fffff097          	auipc	ra,0xfffff
    80001d78:	f3c080e7          	jalr	-196(ra) # 80000cb0 <release>
    rt = run_this(rt);    
    80001d7c:	8526                	mv	a0,s1
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	c7e080e7          	jalr	-898(ra) # 800019fc <run_this>
    80001d86:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d88:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d8c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d90:	10079073          	csrw	sstatus,a5
    if (rt != 0) {
    80001d94:	d4e5                	beqz	s1,80001d7c <mlfq_like+0x186>
      acquire(&rt->lock);
    80001d96:	8aa6                	mv	s5,s1
    80001d98:	8526                	mv	a0,s1
    80001d9a:	fffff097          	auipc	ra,0xfffff
    80001d9e:	e62080e7          	jalr	-414(ra) # 80000bfc <acquire>
      for(p = proc; p < &proc[NPROC]; p++) {
    80001da2:	00010597          	auipc	a1,0x10
    80001da6:	00e58593          	addi	a1,a1,14 # 80011db0 <proc>
        else if (  p == rt && is_q2(p) ) { // case when it is time for q2 to run.
    80001daa:	4709                	li	a4,2
    80001dac:	b71d                	j	80001cd2 <mlfq_like+0xdc>
          if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001dae:	478d                	li	a5,3
    80001db0:	cd9c                	sw	a5,24(a1)
    80001db2:	04bb3423          	sd	a1,72(s6)
    80001db6:	06058593          	addi	a1,a1,96
    80001dba:	8566                	mv	a0,s9
    80001dbc:	00001097          	auipc	ra,0x1
    80001dc0:	dcc080e7          	jalr	-564(ra) # 80002b88 <swtch>
    80001dc4:	040b3423          	sd	zero,72(s6)
    80001dc8:	b76d                	j	80001d72 <mlfq_like+0x17c>
          else if (p->state == SLEEPING || p->state == ZOMBIE) { __RE_MOVE___(p, &q1, &q0); }
    80001dca:	855e                	mv	a0,s7
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	d32080e7          	jalr	-718(ra) # 80001afe <remove>
    80001dd4:	85aa                	mv	a1,a0
    80001dd6:	00010517          	auipc	a0,0x10
    80001dda:	baa50513          	addi	a0,a0,-1110 # 80011980 <q0>
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	c9a080e7          	jalr	-870(ra) # 80001a78 <enqueue>
    80001de6:	b771                	j	80001d72 <mlfq_like+0x17c>

0000000080001de8 <procinit>:
{
    80001de8:	715d                	addi	sp,sp,-80
    80001dea:	e486                	sd	ra,72(sp)
    80001dec:	e0a2                	sd	s0,64(sp)
    80001dee:	fc26                	sd	s1,56(sp)
    80001df0:	f84a                	sd	s2,48(sp)
    80001df2:	f44e                	sd	s3,40(sp)
    80001df4:	f052                	sd	s4,32(sp)
    80001df6:	ec56                	sd	s5,24(sp)
    80001df8:	e85a                	sd	s6,16(sp)
    80001dfa:	e45e                	sd	s7,8(sp)
    80001dfc:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001dfe:	00006597          	auipc	a1,0x6
    80001e02:	46a58593          	addi	a1,a1,1130 # 80008268 <digits+0x228>
    80001e06:	00010517          	auipc	a0,0x10
    80001e0a:	f9250513          	addi	a0,a0,-110 # 80011d98 <pid_lock>
    80001e0e:	fffff097          	auipc	ra,0xfffff
    80001e12:	d5e080e7          	jalr	-674(ra) # 80000b6c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e16:	00010917          	auipc	s2,0x10
    80001e1a:	f9a90913          	addi	s2,s2,-102 # 80011db0 <proc>
      initlock(&p->lock, "proc");
    80001e1e:	00006b97          	auipc	s7,0x6
    80001e22:	452b8b93          	addi	s7,s7,1106 # 80008270 <digits+0x230>
      uint64 va = KSTACK((int) (p - proc));
    80001e26:	8b4a                	mv	s6,s2
    80001e28:	00006a97          	auipc	s5,0x6
    80001e2c:	1d8a8a93          	addi	s5,s5,472 # 80008000 <etext>
    80001e30:	040009b7          	lui	s3,0x4000
    80001e34:	19fd                	addi	s3,s3,-1
    80001e36:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e38:	00016a17          	auipc	s4,0x16
    80001e3c:	578a0a13          	addi	s4,s4,1400 # 800183b0 <tickslock>
      initlock(&p->lock, "proc");
    80001e40:	85de                	mv	a1,s7
    80001e42:	854a                	mv	a0,s2
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	d28080e7          	jalr	-728(ra) # 80000b6c <initlock>
      char *pa = kalloc();
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	cc0080e7          	jalr	-832(ra) # 80000b0c <kalloc>
    80001e54:	85aa                	mv	a1,a0
      if(pa == 0)
    80001e56:	c549                	beqz	a0,80001ee0 <procinit+0xf8>
      uint64 va = KSTACK((int) (p - proc));
    80001e58:	416904b3          	sub	s1,s2,s6
    80001e5c:	848d                	srai	s1,s1,0x3
    80001e5e:	000ab783          	ld	a5,0(s5)
    80001e62:	02f484b3          	mul	s1,s1,a5
    80001e66:	2485                	addiw	s1,s1,1
    80001e68:	00d4949b          	slliw	s1,s1,0xd
    80001e6c:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001e70:	4699                	li	a3,6
    80001e72:	6605                	lui	a2,0x1
    80001e74:	8526                	mv	a0,s1
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	32e080e7          	jalr	814(ra) # 800011a4 <kvmmap>
      p->kstack = va;
    80001e7e:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e82:	19890913          	addi	s2,s2,408
    80001e86:	fb491de3          	bne	s2,s4,80001e40 <procinit+0x58>
  kvminithart();
    80001e8a:	fffff097          	auipc	ra,0xfffff
    80001e8e:	122080e7          	jalr	290(ra) # 80000fac <kvminithart>
  q->q_id = id; 
    80001e92:	00010797          	auipc	a5,0x10
    80001e96:	abe78793          	addi	a5,a5,-1346 # 80011950 <q2>
    80001e9a:	4709                	li	a4,2
    80001e9c:	c398                	sw	a4,0(a5)
  q->q_head = q->q_tail = 0; 
    80001e9e:	0007b823          	sd	zero,16(a5)
    80001ea2:	0007b423          	sd	zero,8(a5)
  q->q_cnt = 0;
    80001ea6:	0007a223          	sw	zero,4(a5)
  q->q_id = id; 
    80001eaa:	4705                	li	a4,1
    80001eac:	cf98                	sw	a4,24(a5)
  q->q_head = q->q_tail = 0; 
    80001eae:	0207b423          	sd	zero,40(a5)
    80001eb2:	0207b023          	sd	zero,32(a5)
  q->q_cnt = 0;
    80001eb6:	0007ae23          	sw	zero,28(a5)
  q->q_id = id; 
    80001eba:	0207a823          	sw	zero,48(a5)
  q->q_head = q->q_tail = 0; 
    80001ebe:	0407b023          	sd	zero,64(a5)
    80001ec2:	0207bc23          	sd	zero,56(a5)
  q->q_cnt = 0;
    80001ec6:	0207aa23          	sw	zero,52(a5)
}
    80001eca:	60a6                	ld	ra,72(sp)
    80001ecc:	6406                	ld	s0,64(sp)
    80001ece:	74e2                	ld	s1,56(sp)
    80001ed0:	7942                	ld	s2,48(sp)
    80001ed2:	79a2                	ld	s3,40(sp)
    80001ed4:	7a02                	ld	s4,32(sp)
    80001ed6:	6ae2                	ld	s5,24(sp)
    80001ed8:	6b42                	ld	s6,16(sp)
    80001eda:	6ba2                	ld	s7,8(sp)
    80001edc:	6161                	addi	sp,sp,80
    80001ede:	8082                	ret
        panic("kalloc");
    80001ee0:	00006517          	auipc	a0,0x6
    80001ee4:	39850513          	addi	a0,a0,920 # 80008278 <digits+0x238>
    80001ee8:	ffffe097          	auipc	ra,0xffffe
    80001eec:	658080e7          	jalr	1624(ra) # 80000540 <panic>

0000000080001ef0 <cpuid>:
{
    80001ef0:	1141                	addi	sp,sp,-16
    80001ef2:	e422                	sd	s0,8(sp)
    80001ef4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ef6:	8512                	mv	a0,tp
}
    80001ef8:	2501                	sext.w	a0,a0
    80001efa:	6422                	ld	s0,8(sp)
    80001efc:	0141                	addi	sp,sp,16
    80001efe:	8082                	ret

0000000080001f00 <mycpu>:
mycpu(void) {
    80001f00:	1141                	addi	sp,sp,-16
    80001f02:	e422                	sd	s0,8(sp)
    80001f04:	0800                	addi	s0,sp,16
    80001f06:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001f08:	2781                	sext.w	a5,a5
    80001f0a:	079e                	slli	a5,a5,0x7
}
    80001f0c:	00010517          	auipc	a0,0x10
    80001f10:	a8c50513          	addi	a0,a0,-1396 # 80011998 <cpus>
    80001f14:	953e                	add	a0,a0,a5
    80001f16:	6422                	ld	s0,8(sp)
    80001f18:	0141                	addi	sp,sp,16
    80001f1a:	8082                	ret

0000000080001f1c <myproc>:
myproc(void) {
    80001f1c:	1101                	addi	sp,sp,-32
    80001f1e:	ec06                	sd	ra,24(sp)
    80001f20:	e822                	sd	s0,16(sp)
    80001f22:	e426                	sd	s1,8(sp)
    80001f24:	1000                	addi	s0,sp,32
  push_off();
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	c8a080e7          	jalr	-886(ra) # 80000bb0 <push_off>
    80001f2e:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001f30:	2781                	sext.w	a5,a5
    80001f32:	079e                	slli	a5,a5,0x7
    80001f34:	00010717          	auipc	a4,0x10
    80001f38:	a1c70713          	addi	a4,a4,-1508 # 80011950 <q2>
    80001f3c:	97ba                	add	a5,a5,a4
    80001f3e:	67a4                	ld	s1,72(a5)
  pop_off();
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	d10080e7          	jalr	-752(ra) # 80000c50 <pop_off>
}
    80001f48:	8526                	mv	a0,s1
    80001f4a:	60e2                	ld	ra,24(sp)
    80001f4c:	6442                	ld	s0,16(sp)
    80001f4e:	64a2                	ld	s1,8(sp)
    80001f50:	6105                	addi	sp,sp,32
    80001f52:	8082                	ret

0000000080001f54 <forkret>:
{
    80001f54:	1141                	addi	sp,sp,-16
    80001f56:	e406                	sd	ra,8(sp)
    80001f58:	e022                	sd	s0,0(sp)
    80001f5a:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001f5c:	00000097          	auipc	ra,0x0
    80001f60:	fc0080e7          	jalr	-64(ra) # 80001f1c <myproc>
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	d4c080e7          	jalr	-692(ra) # 80000cb0 <release>
  if (first) {
    80001f6c:	00007797          	auipc	a5,0x7
    80001f70:	9747a783          	lw	a5,-1676(a5) # 800088e0 <first.1>
    80001f74:	eb89                	bnez	a5,80001f86 <forkret+0x32>
  usertrapret();
    80001f76:	00001097          	auipc	ra,0x1
    80001f7a:	cbc080e7          	jalr	-836(ra) # 80002c32 <usertrapret>
}
    80001f7e:	60a2                	ld	ra,8(sp)
    80001f80:	6402                	ld	s0,0(sp)
    80001f82:	0141                	addi	sp,sp,16
    80001f84:	8082                	ret
    first = 0;
    80001f86:	00007797          	auipc	a5,0x7
    80001f8a:	9407ad23          	sw	zero,-1702(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80001f8e:	4505                	li	a0,1
    80001f90:	00002097          	auipc	ra,0x2
    80001f94:	abc080e7          	jalr	-1348(ra) # 80003a4c <fsinit>
    80001f98:	bff9                	j	80001f76 <forkret+0x22>

0000000080001f9a <allocpid>:
allocpid() {
    80001f9a:	1101                	addi	sp,sp,-32
    80001f9c:	ec06                	sd	ra,24(sp)
    80001f9e:	e822                	sd	s0,16(sp)
    80001fa0:	e426                	sd	s1,8(sp)
    80001fa2:	e04a                	sd	s2,0(sp)
    80001fa4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001fa6:	00010917          	auipc	s2,0x10
    80001faa:	df290913          	addi	s2,s2,-526 # 80011d98 <pid_lock>
    80001fae:	854a                	mv	a0,s2
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	c4c080e7          	jalr	-948(ra) # 80000bfc <acquire>
  pid = nextpid;
    80001fb8:	00007797          	auipc	a5,0x7
    80001fbc:	92c78793          	addi	a5,a5,-1748 # 800088e4 <nextpid>
    80001fc0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001fc2:	0014871b          	addiw	a4,s1,1
    80001fc6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001fc8:	854a                	mv	a0,s2
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	ce6080e7          	jalr	-794(ra) # 80000cb0 <release>
}
    80001fd2:	8526                	mv	a0,s1
    80001fd4:	60e2                	ld	ra,24(sp)
    80001fd6:	6442                	ld	s0,16(sp)
    80001fd8:	64a2                	ld	s1,8(sp)
    80001fda:	6902                	ld	s2,0(sp)
    80001fdc:	6105                	addi	sp,sp,32
    80001fde:	8082                	ret

0000000080001fe0 <proc_pagetable>:
{
    80001fe0:	1101                	addi	sp,sp,-32
    80001fe2:	ec06                	sd	ra,24(sp)
    80001fe4:	e822                	sd	s0,16(sp)
    80001fe6:	e426                	sd	s1,8(sp)
    80001fe8:	e04a                	sd	s2,0(sp)
    80001fea:	1000                	addi	s0,sp,32
    80001fec:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	384080e7          	jalr	900(ra) # 80001372 <uvmcreate>
    80001ff6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001ff8:	c121                	beqz	a0,80002038 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ffa:	4729                	li	a4,10
    80001ffc:	00005697          	auipc	a3,0x5
    80002000:	00468693          	addi	a3,a3,4 # 80007000 <_trampoline>
    80002004:	6605                	lui	a2,0x1
    80002006:	040005b7          	lui	a1,0x4000
    8000200a:	15fd                	addi	a1,a1,-1
    8000200c:	05b2                	slli	a1,a1,0xc
    8000200e:	fffff097          	auipc	ra,0xfffff
    80002012:	108080e7          	jalr	264(ra) # 80001116 <mappages>
    80002016:	02054863          	bltz	a0,80002046 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000201a:	4719                	li	a4,6
    8000201c:	05893683          	ld	a3,88(s2)
    80002020:	6605                	lui	a2,0x1
    80002022:	020005b7          	lui	a1,0x2000
    80002026:	15fd                	addi	a1,a1,-1
    80002028:	05b6                	slli	a1,a1,0xd
    8000202a:	8526                	mv	a0,s1
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	0ea080e7          	jalr	234(ra) # 80001116 <mappages>
    80002034:	02054163          	bltz	a0,80002056 <proc_pagetable+0x76>
}
    80002038:	8526                	mv	a0,s1
    8000203a:	60e2                	ld	ra,24(sp)
    8000203c:	6442                	ld	s0,16(sp)
    8000203e:	64a2                	ld	s1,8(sp)
    80002040:	6902                	ld	s2,0(sp)
    80002042:	6105                	addi	sp,sp,32
    80002044:	8082                	ret
    uvmfree(pagetable, 0);
    80002046:	4581                	li	a1,0
    80002048:	8526                	mv	a0,s1
    8000204a:	fffff097          	auipc	ra,0xfffff
    8000204e:	524080e7          	jalr	1316(ra) # 8000156e <uvmfree>
    return 0;
    80002052:	4481                	li	s1,0
    80002054:	b7d5                	j	80002038 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002056:	4681                	li	a3,0
    80002058:	4605                	li	a2,1
    8000205a:	040005b7          	lui	a1,0x4000
    8000205e:	15fd                	addi	a1,a1,-1
    80002060:	05b2                	slli	a1,a1,0xc
    80002062:	8526                	mv	a0,s1
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	24a080e7          	jalr	586(ra) # 800012ae <uvmunmap>
    uvmfree(pagetable, 0);
    8000206c:	4581                	li	a1,0
    8000206e:	8526                	mv	a0,s1
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	4fe080e7          	jalr	1278(ra) # 8000156e <uvmfree>
    return 0;
    80002078:	4481                	li	s1,0
    8000207a:	bf7d                	j	80002038 <proc_pagetable+0x58>

000000008000207c <proc_freepagetable>:
{
    8000207c:	1101                	addi	sp,sp,-32
    8000207e:	ec06                	sd	ra,24(sp)
    80002080:	e822                	sd	s0,16(sp)
    80002082:	e426                	sd	s1,8(sp)
    80002084:	e04a                	sd	s2,0(sp)
    80002086:	1000                	addi	s0,sp,32
    80002088:	84aa                	mv	s1,a0
    8000208a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000208c:	4681                	li	a3,0
    8000208e:	4605                	li	a2,1
    80002090:	040005b7          	lui	a1,0x4000
    80002094:	15fd                	addi	a1,a1,-1
    80002096:	05b2                	slli	a1,a1,0xc
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	216080e7          	jalr	534(ra) # 800012ae <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800020a0:	4681                	li	a3,0
    800020a2:	4605                	li	a2,1
    800020a4:	020005b7          	lui	a1,0x2000
    800020a8:	15fd                	addi	a1,a1,-1
    800020aa:	05b6                	slli	a1,a1,0xd
    800020ac:	8526                	mv	a0,s1
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	200080e7          	jalr	512(ra) # 800012ae <uvmunmap>
  uvmfree(pagetable, sz);
    800020b6:	85ca                	mv	a1,s2
    800020b8:	8526                	mv	a0,s1
    800020ba:	fffff097          	auipc	ra,0xfffff
    800020be:	4b4080e7          	jalr	1204(ra) # 8000156e <uvmfree>
}
    800020c2:	60e2                	ld	ra,24(sp)
    800020c4:	6442                	ld	s0,16(sp)
    800020c6:	64a2                	ld	s1,8(sp)
    800020c8:	6902                	ld	s2,0(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret

00000000800020ce <freeproc>:
{
    800020ce:	1101                	addi	sp,sp,-32
    800020d0:	ec06                	sd	ra,24(sp)
    800020d2:	e822                	sd	s0,16(sp)
    800020d4:	e426                	sd	s1,8(sp)
    800020d6:	1000                	addi	s0,sp,32
    800020d8:	84aa                	mv	s1,a0
         RATIO(p->p_ticks[Q2]), RATIO(p->p_ticks[Q1]), RATIO(p->p_ticks[Q0]));
    800020da:	17452583          	lw	a1,372(a0)
    800020de:	17052703          	lw	a4,368(a0)
    800020e2:	16c52783          	lw	a5,364(a0)
    800020e6:	00e5863b          	addw	a2,a1,a4
    800020ea:	9e3d                	addw	a2,a2,a5
    800020ec:	06400693          	li	a3,100
    800020f0:	02f687bb          	mulw	a5,a3,a5
    800020f4:	02e6873b          	mulw	a4,a3,a4
    800020f8:	02b686bb          	mulw	a3,a3,a1
  printf("%s (pid=%d): Q2(%d%%), Q1(%d%%), Q0(%d%%)\n",
    800020fc:	02c7d7bb          	divuw	a5,a5,a2
    80002100:	02c7573b          	divuw	a4,a4,a2
    80002104:	02c6d6bb          	divuw	a3,a3,a2
    80002108:	5d10                	lw	a2,56(a0)
    8000210a:	15850593          	addi	a1,a0,344
    8000210e:	00006517          	auipc	a0,0x6
    80002112:	17250513          	addi	a0,a0,370 # 80008280 <digits+0x240>
    80002116:	ffffe097          	auipc	ra,0xffffe
    8000211a:	474080e7          	jalr	1140(ra) # 8000058a <printf>
  p->p_ticks[Q2] = p->p_ticks[Q1] = p->p_ticks[Q0] = 0;
    8000211e:	1604a623          	sw	zero,364(s1)
    80002122:	1604a823          	sw	zero,368(s1)
    80002126:	1604aa23          	sw	zero,372(s1)
  p->p_stp = 0;
    8000212a:	1604ac23          	sw	zero,376(s1)
  p->p_intr = 0;
    8000212e:	1804a823          	sw	zero,400(s1)
  if (p->state == ZOMBIE) {
    80002132:	4c98                	lw	a4,24(s1)
    80002134:	4791                	li	a5,4
    80002136:	04f70863          	beq	a4,a5,80002186 <freeproc+0xb8>
  if(p->trapframe)
    8000213a:	6ca8                	ld	a0,88(s1)
    8000213c:	c509                	beqz	a0,80002146 <freeproc+0x78>
    kfree((void*)p->trapframe);
    8000213e:	fffff097          	auipc	ra,0xfffff
    80002142:	8d2080e7          	jalr	-1838(ra) # 80000a10 <kfree>
  p->trapframe = 0;
    80002146:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000214a:	68a8                	ld	a0,80(s1)
    8000214c:	c511                	beqz	a0,80002158 <freeproc+0x8a>
    proc_freepagetable(p->pagetable, p->sz);
    8000214e:	64ac                	ld	a1,72(s1)
    80002150:	00000097          	auipc	ra,0x0
    80002154:	f2c080e7          	jalr	-212(ra) # 8000207c <proc_freepagetable>
  p->pagetable = 0;
    80002158:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000215c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80002160:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80002164:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80002168:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000216c:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80002170:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80002174:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80002178:	0004ac23          	sw	zero,24(s1)
}
    8000217c:	60e2                	ld	ra,24(sp)
    8000217e:	6442                	ld	s0,16(sp)
    80002180:	64a2                	ld	s1,8(sp)
    80002182:	6105                	addi	sp,sp,32
    80002184:	8082                	ret
int is_q2(struct proc* p) { return p->p_id == Q2; }
    80002186:	1684a783          	lw	a5,360(s1)
    if (is_q2(p)) remove(&q2, p);
    8000218a:	4709                	li	a4,2
    8000218c:	02e78063          	beq	a5,a4,800021ac <freeproc+0xde>
    else if (is_q1(p)) remove(&q1, p);
    80002190:	4705                	li	a4,1
    80002192:	02e78763          	beq	a5,a4,800021c0 <freeproc+0xf2>
    else if (is_q0(p)) remove(&q0, p);
    80002196:	f3d5                	bnez	a5,8000213a <freeproc+0x6c>
    80002198:	85a6                	mv	a1,s1
    8000219a:	0000f517          	auipc	a0,0xf
    8000219e:	7e650513          	addi	a0,a0,2022 # 80011980 <q0>
    800021a2:	00000097          	auipc	ra,0x0
    800021a6:	95c080e7          	jalr	-1700(ra) # 80001afe <remove>
    800021aa:	bf41                	j	8000213a <freeproc+0x6c>
    if (is_q2(p)) remove(&q2, p);
    800021ac:	85a6                	mv	a1,s1
    800021ae:	0000f517          	auipc	a0,0xf
    800021b2:	7a250513          	addi	a0,a0,1954 # 80011950 <q2>
    800021b6:	00000097          	auipc	ra,0x0
    800021ba:	948080e7          	jalr	-1720(ra) # 80001afe <remove>
    800021be:	bfb5                	j	8000213a <freeproc+0x6c>
    else if (is_q1(p)) remove(&q1, p);
    800021c0:	85a6                	mv	a1,s1
    800021c2:	0000f517          	auipc	a0,0xf
    800021c6:	7a650513          	addi	a0,a0,1958 # 80011968 <q1>
    800021ca:	00000097          	auipc	ra,0x0
    800021ce:	934080e7          	jalr	-1740(ra) # 80001afe <remove>
    800021d2:	b7a5                	j	8000213a <freeproc+0x6c>

00000000800021d4 <allocproc>:
{
    800021d4:	1101                	addi	sp,sp,-32
    800021d6:	ec06                	sd	ra,24(sp)
    800021d8:	e822                	sd	s0,16(sp)
    800021da:	e426                	sd	s1,8(sp)
    800021dc:	e04a                	sd	s2,0(sp)
    800021de:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800021e0:	00010497          	auipc	s1,0x10
    800021e4:	bd048493          	addi	s1,s1,-1072 # 80011db0 <proc>
    800021e8:	00016917          	auipc	s2,0x16
    800021ec:	1c890913          	addi	s2,s2,456 # 800183b0 <tickslock>
    acquire(&p->lock);
    800021f0:	8526                	mv	a0,s1
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	a0a080e7          	jalr	-1526(ra) # 80000bfc <acquire>
    if(p->state == UNUSED) {
    800021fa:	4c9c                	lw	a5,24(s1)
    800021fc:	cf81                	beqz	a5,80002214 <allocproc+0x40>
      release(&p->lock);
    800021fe:	8526                	mv	a0,s1
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	ab0080e7          	jalr	-1360(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002208:	19848493          	addi	s1,s1,408
    8000220c:	ff2492e3          	bne	s1,s2,800021f0 <allocproc+0x1c>
  return 0;
    80002210:	4481                	li	s1,0
    80002212:	a8b5                	j	8000228e <allocproc+0xba>
  p->pid = allocpid();
    80002214:	00000097          	auipc	ra,0x0
    80002218:	d86080e7          	jalr	-634(ra) # 80001f9a <allocpid>
    8000221c:	dc88                	sw	a0,56(s1)
  enqueue(&q2, p);
    8000221e:	85a6                	mv	a1,s1
    80002220:	0000f517          	auipc	a0,0xf
    80002224:	73050513          	addi	a0,a0,1840 # 80011950 <q2>
    80002228:	00000097          	auipc	ra,0x0
    8000222c:	850080e7          	jalr	-1968(ra) # 80001a78 <enqueue>
  p->p_ticks[Q2] = p->p_ticks[Q1] = p->p_ticks[Q0] = 0;
    80002230:	1604a623          	sw	zero,364(s1)
    80002234:	1604a823          	sw	zero,368(s1)
    80002238:	1604aa23          	sw	zero,372(s1)
  p->p_stp = ticks;
    8000223c:	00007797          	auipc	a5,0x7
    80002240:	de47a783          	lw	a5,-540(a5) # 80009020 <ticks>
    80002244:	16f4ac23          	sw	a5,376(s1)
  p->p_intr = 0;
    80002248:	1804a823          	sw	zero,400(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000224c:	fffff097          	auipc	ra,0xfffff
    80002250:	8c0080e7          	jalr	-1856(ra) # 80000b0c <kalloc>
    80002254:	892a                	mv	s2,a0
    80002256:	eca8                	sd	a0,88(s1)
    80002258:	c131                	beqz	a0,8000229c <allocproc+0xc8>
  p->pagetable = proc_pagetable(p);
    8000225a:	8526                	mv	a0,s1
    8000225c:	00000097          	auipc	ra,0x0
    80002260:	d84080e7          	jalr	-636(ra) # 80001fe0 <proc_pagetable>
    80002264:	892a                	mv	s2,a0
    80002266:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80002268:	c129                	beqz	a0,800022aa <allocproc+0xd6>
  memset(&p->context, 0, sizeof(p->context));
    8000226a:	07000613          	li	a2,112
    8000226e:	4581                	li	a1,0
    80002270:	06048513          	addi	a0,s1,96
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	a84080e7          	jalr	-1404(ra) # 80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    8000227c:	00000797          	auipc	a5,0x0
    80002280:	cd878793          	addi	a5,a5,-808 # 80001f54 <forkret>
    80002284:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002286:	60bc                	ld	a5,64(s1)
    80002288:	6705                	lui	a4,0x1
    8000228a:	97ba                	add	a5,a5,a4
    8000228c:	f4bc                	sd	a5,104(s1)
}
    8000228e:	8526                	mv	a0,s1
    80002290:	60e2                	ld	ra,24(sp)
    80002292:	6442                	ld	s0,16(sp)
    80002294:	64a2                	ld	s1,8(sp)
    80002296:	6902                	ld	s2,0(sp)
    80002298:	6105                	addi	sp,sp,32
    8000229a:	8082                	ret
    release(&p->lock);
    8000229c:	8526                	mv	a0,s1
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	a12080e7          	jalr	-1518(ra) # 80000cb0 <release>
    return 0;
    800022a6:	84ca                	mv	s1,s2
    800022a8:	b7dd                	j	8000228e <allocproc+0xba>
    freeproc(p);
    800022aa:	8526                	mv	a0,s1
    800022ac:	00000097          	auipc	ra,0x0
    800022b0:	e22080e7          	jalr	-478(ra) # 800020ce <freeproc>
    release(&p->lock);
    800022b4:	8526                	mv	a0,s1
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	9fa080e7          	jalr	-1542(ra) # 80000cb0 <release>
    return 0;
    800022be:	84ca                	mv	s1,s2
    800022c0:	b7f9                	j	8000228e <allocproc+0xba>

00000000800022c2 <userinit>:
{
    800022c2:	1101                	addi	sp,sp,-32
    800022c4:	ec06                	sd	ra,24(sp)
    800022c6:	e822                	sd	s0,16(sp)
    800022c8:	e426                	sd	s1,8(sp)
    800022ca:	1000                	addi	s0,sp,32
  p = allocproc();
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	f08080e7          	jalr	-248(ra) # 800021d4 <allocproc>
    800022d4:	84aa                	mv	s1,a0
  initproc = p;
    800022d6:	00007797          	auipc	a5,0x7
    800022da:	d4a7b123          	sd	a0,-702(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800022de:	03400613          	li	a2,52
    800022e2:	00006597          	auipc	a1,0x6
    800022e6:	60e58593          	addi	a1,a1,1550 # 800088f0 <initcode>
    800022ea:	6928                	ld	a0,80(a0)
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	0b4080e7          	jalr	180(ra) # 800013a0 <uvminit>
  p->sz = PGSIZE;
    800022f4:	6785                	lui	a5,0x1
    800022f6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800022f8:	6cb8                	ld	a4,88(s1)
    800022fa:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800022fe:	6cb8                	ld	a4,88(s1)
    80002300:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002302:	4641                	li	a2,16
    80002304:	00006597          	auipc	a1,0x6
    80002308:	fac58593          	addi	a1,a1,-84 # 800082b0 <digits+0x270>
    8000230c:	15848513          	addi	a0,s1,344
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	b3a080e7          	jalr	-1222(ra) # 80000e4a <safestrcpy>
  p->cwd = namei("/");
    80002318:	00006517          	auipc	a0,0x6
    8000231c:	fa850513          	addi	a0,a0,-88 # 800082c0 <digits+0x280>
    80002320:	00002097          	auipc	ra,0x2
    80002324:	154080e7          	jalr	340(ra) # 80004474 <namei>
    80002328:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000232c:	4789                	li	a5,2
    8000232e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002330:	8526                	mv	a0,s1
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	97e080e7          	jalr	-1666(ra) # 80000cb0 <release>
}
    8000233a:	60e2                	ld	ra,24(sp)
    8000233c:	6442                	ld	s0,16(sp)
    8000233e:	64a2                	ld	s1,8(sp)
    80002340:	6105                	addi	sp,sp,32
    80002342:	8082                	ret

0000000080002344 <growproc>:
{
    80002344:	1101                	addi	sp,sp,-32
    80002346:	ec06                	sd	ra,24(sp)
    80002348:	e822                	sd	s0,16(sp)
    8000234a:	e426                	sd	s1,8(sp)
    8000234c:	e04a                	sd	s2,0(sp)
    8000234e:	1000                	addi	s0,sp,32
    80002350:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002352:	00000097          	auipc	ra,0x0
    80002356:	bca080e7          	jalr	-1078(ra) # 80001f1c <myproc>
    8000235a:	892a                	mv	s2,a0
  sz = p->sz;
    8000235c:	652c                	ld	a1,72(a0)
    8000235e:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80002362:	00904f63          	bgtz	s1,80002380 <growproc+0x3c>
  } else if(n < 0){
    80002366:	0204cc63          	bltz	s1,8000239e <growproc+0x5a>
  p->sz = sz;
    8000236a:	1602                	slli	a2,a2,0x20
    8000236c:	9201                	srli	a2,a2,0x20
    8000236e:	04c93423          	sd	a2,72(s2)
  return 0;
    80002372:	4501                	li	a0,0
}
    80002374:	60e2                	ld	ra,24(sp)
    80002376:	6442                	ld	s0,16(sp)
    80002378:	64a2                	ld	s1,8(sp)
    8000237a:	6902                	ld	s2,0(sp)
    8000237c:	6105                	addi	sp,sp,32
    8000237e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80002380:	9e25                	addw	a2,a2,s1
    80002382:	1602                	slli	a2,a2,0x20
    80002384:	9201                	srli	a2,a2,0x20
    80002386:	1582                	slli	a1,a1,0x20
    80002388:	9181                	srli	a1,a1,0x20
    8000238a:	6928                	ld	a0,80(a0)
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	0ce080e7          	jalr	206(ra) # 8000145a <uvmalloc>
    80002394:	0005061b          	sext.w	a2,a0
    80002398:	fa69                	bnez	a2,8000236a <growproc+0x26>
      return -1;
    8000239a:	557d                	li	a0,-1
    8000239c:	bfe1                	j	80002374 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000239e:	9e25                	addw	a2,a2,s1
    800023a0:	1602                	slli	a2,a2,0x20
    800023a2:	9201                	srli	a2,a2,0x20
    800023a4:	1582                	slli	a1,a1,0x20
    800023a6:	9181                	srli	a1,a1,0x20
    800023a8:	6928                	ld	a0,80(a0)
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	068080e7          	jalr	104(ra) # 80001412 <uvmdealloc>
    800023b2:	0005061b          	sext.w	a2,a0
    800023b6:	bf55                	j	8000236a <growproc+0x26>

00000000800023b8 <fork>:
{
    800023b8:	7139                	addi	sp,sp,-64
    800023ba:	fc06                	sd	ra,56(sp)
    800023bc:	f822                	sd	s0,48(sp)
    800023be:	f426                	sd	s1,40(sp)
    800023c0:	f04a                	sd	s2,32(sp)
    800023c2:	ec4e                	sd	s3,24(sp)
    800023c4:	e852                	sd	s4,16(sp)
    800023c6:	e456                	sd	s5,8(sp)
    800023c8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800023ca:	00000097          	auipc	ra,0x0
    800023ce:	b52080e7          	jalr	-1198(ra) # 80001f1c <myproc>
    800023d2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800023d4:	00000097          	auipc	ra,0x0
    800023d8:	e00080e7          	jalr	-512(ra) # 800021d4 <allocproc>
    800023dc:	c17d                	beqz	a0,800024c2 <fork+0x10a>
    800023de:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800023e0:	048ab603          	ld	a2,72(s5)
    800023e4:	692c                	ld	a1,80(a0)
    800023e6:	050ab503          	ld	a0,80(s5)
    800023ea:	fffff097          	auipc	ra,0xfffff
    800023ee:	1bc080e7          	jalr	444(ra) # 800015a6 <uvmcopy>
    800023f2:	04054a63          	bltz	a0,80002446 <fork+0x8e>
  np->sz = p->sz;
    800023f6:	048ab783          	ld	a5,72(s5)
    800023fa:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    800023fe:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80002402:	058ab683          	ld	a3,88(s5)
    80002406:	87b6                	mv	a5,a3
    80002408:	058a3703          	ld	a4,88(s4)
    8000240c:	12068693          	addi	a3,a3,288
    80002410:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002414:	6788                	ld	a0,8(a5)
    80002416:	6b8c                	ld	a1,16(a5)
    80002418:	6f90                	ld	a2,24(a5)
    8000241a:	01073023          	sd	a6,0(a4)
    8000241e:	e708                	sd	a0,8(a4)
    80002420:	eb0c                	sd	a1,16(a4)
    80002422:	ef10                	sd	a2,24(a4)
    80002424:	02078793          	addi	a5,a5,32
    80002428:	02070713          	addi	a4,a4,32
    8000242c:	fed792e3          	bne	a5,a3,80002410 <fork+0x58>
  np->trapframe->a0 = 0;
    80002430:	058a3783          	ld	a5,88(s4)
    80002434:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002438:	0d0a8493          	addi	s1,s5,208
    8000243c:	0d0a0913          	addi	s2,s4,208
    80002440:	150a8993          	addi	s3,s5,336
    80002444:	a00d                	j	80002466 <fork+0xae>
    freeproc(np);
    80002446:	8552                	mv	a0,s4
    80002448:	00000097          	auipc	ra,0x0
    8000244c:	c86080e7          	jalr	-890(ra) # 800020ce <freeproc>
    release(&np->lock);
    80002450:	8552                	mv	a0,s4
    80002452:	fffff097          	auipc	ra,0xfffff
    80002456:	85e080e7          	jalr	-1954(ra) # 80000cb0 <release>
    return -1;
    8000245a:	54fd                	li	s1,-1
    8000245c:	a889                	j	800024ae <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    8000245e:	04a1                	addi	s1,s1,8
    80002460:	0921                	addi	s2,s2,8
    80002462:	01348b63          	beq	s1,s3,80002478 <fork+0xc0>
    if(p->ofile[i])
    80002466:	6088                	ld	a0,0(s1)
    80002468:	d97d                	beqz	a0,8000245e <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000246a:	00002097          	auipc	ra,0x2
    8000246e:	69a080e7          	jalr	1690(ra) # 80004b04 <filedup>
    80002472:	00a93023          	sd	a0,0(s2)
    80002476:	b7e5                	j	8000245e <fork+0xa6>
  np->cwd = idup(p->cwd);
    80002478:	150ab503          	ld	a0,336(s5)
    8000247c:	00002097          	auipc	ra,0x2
    80002480:	80a080e7          	jalr	-2038(ra) # 80003c86 <idup>
    80002484:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002488:	4641                	li	a2,16
    8000248a:	158a8593          	addi	a1,s5,344
    8000248e:	158a0513          	addi	a0,s4,344
    80002492:	fffff097          	auipc	ra,0xfffff
    80002496:	9b8080e7          	jalr	-1608(ra) # 80000e4a <safestrcpy>
  pid = np->pid;
    8000249a:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    8000249e:	4789                	li	a5,2
    800024a0:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800024a4:	8552                	mv	a0,s4
    800024a6:	fffff097          	auipc	ra,0xfffff
    800024aa:	80a080e7          	jalr	-2038(ra) # 80000cb0 <release>
}
    800024ae:	8526                	mv	a0,s1
    800024b0:	70e2                	ld	ra,56(sp)
    800024b2:	7442                	ld	s0,48(sp)
    800024b4:	74a2                	ld	s1,40(sp)
    800024b6:	7902                	ld	s2,32(sp)
    800024b8:	69e2                	ld	s3,24(sp)
    800024ba:	6a42                	ld	s4,16(sp)
    800024bc:	6aa2                	ld	s5,8(sp)
    800024be:	6121                	addi	sp,sp,64
    800024c0:	8082                	ret
    return -1;
    800024c2:	54fd                	li	s1,-1
    800024c4:	b7ed                	j	800024ae <fork+0xf6>

00000000800024c6 <reparent>:
{
    800024c6:	7179                	addi	sp,sp,-48
    800024c8:	f406                	sd	ra,40(sp)
    800024ca:	f022                	sd	s0,32(sp)
    800024cc:	ec26                	sd	s1,24(sp)
    800024ce:	e84a                	sd	s2,16(sp)
    800024d0:	e44e                	sd	s3,8(sp)
    800024d2:	e052                	sd	s4,0(sp)
    800024d4:	1800                	addi	s0,sp,48
    800024d6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800024d8:	00010497          	auipc	s1,0x10
    800024dc:	8d848493          	addi	s1,s1,-1832 # 80011db0 <proc>
      pp->parent = initproc;
    800024e0:	00007a17          	auipc	s4,0x7
    800024e4:	b38a0a13          	addi	s4,s4,-1224 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800024e8:	00016997          	auipc	s3,0x16
    800024ec:	ec898993          	addi	s3,s3,-312 # 800183b0 <tickslock>
    800024f0:	a029                	j	800024fa <reparent+0x34>
    800024f2:	19848493          	addi	s1,s1,408
    800024f6:	03348363          	beq	s1,s3,8000251c <reparent+0x56>
    if(pp->parent == p){
    800024fa:	709c                	ld	a5,32(s1)
    800024fc:	ff279be3          	bne	a5,s2,800024f2 <reparent+0x2c>
      acquire(&pp->lock);
    80002500:	8526                	mv	a0,s1
    80002502:	ffffe097          	auipc	ra,0xffffe
    80002506:	6fa080e7          	jalr	1786(ra) # 80000bfc <acquire>
      pp->parent = initproc;
    8000250a:	000a3783          	ld	a5,0(s4)
    8000250e:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80002510:	8526                	mv	a0,s1
    80002512:	ffffe097          	auipc	ra,0xffffe
    80002516:	79e080e7          	jalr	1950(ra) # 80000cb0 <release>
    8000251a:	bfe1                	j	800024f2 <reparent+0x2c>
}
    8000251c:	70a2                	ld	ra,40(sp)
    8000251e:	7402                	ld	s0,32(sp)
    80002520:	64e2                	ld	s1,24(sp)
    80002522:	6942                	ld	s2,16(sp)
    80002524:	69a2                	ld	s3,8(sp)
    80002526:	6a02                	ld	s4,0(sp)
    80002528:	6145                	addi	sp,sp,48
    8000252a:	8082                	ret

000000008000252c <scheduler>:
{
    8000252c:	1141                	addi	sp,sp,-16
    8000252e:	e406                	sd	ra,8(sp)
    80002530:	e022                	sd	s0,0(sp)
    80002532:	0800                	addi	s0,sp,16
  mlfq_like();
    80002534:	fffff097          	auipc	ra,0xfffff
    80002538:	6c2080e7          	jalr	1730(ra) # 80001bf6 <mlfq_like>

000000008000253c <sched>:
{
    8000253c:	7179                	addi	sp,sp,-48
    8000253e:	f406                	sd	ra,40(sp)
    80002540:	f022                	sd	s0,32(sp)
    80002542:	ec26                	sd	s1,24(sp)
    80002544:	e84a                	sd	s2,16(sp)
    80002546:	e44e                	sd	s3,8(sp)
    80002548:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000254a:	00000097          	auipc	ra,0x0
    8000254e:	9d2080e7          	jalr	-1582(ra) # 80001f1c <myproc>
    80002552:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002554:	ffffe097          	auipc	ra,0xffffe
    80002558:	62e080e7          	jalr	1582(ra) # 80000b82 <holding>
    8000255c:	c93d                	beqz	a0,800025d2 <sched+0x96>
    8000255e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002560:	2781                	sext.w	a5,a5
    80002562:	079e                	slli	a5,a5,0x7
    80002564:	0000f717          	auipc	a4,0xf
    80002568:	3ec70713          	addi	a4,a4,1004 # 80011950 <q2>
    8000256c:	97ba                	add	a5,a5,a4
    8000256e:	0c07a703          	lw	a4,192(a5)
    80002572:	4785                	li	a5,1
    80002574:	06f71763          	bne	a4,a5,800025e2 <sched+0xa6>
  if(p->state == RUNNING)
    80002578:	4c98                	lw	a4,24(s1)
    8000257a:	478d                	li	a5,3
    8000257c:	06f70b63          	beq	a4,a5,800025f2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002580:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002584:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002586:	efb5                	bnez	a5,80002602 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002588:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000258a:	0000f917          	auipc	s2,0xf
    8000258e:	3c690913          	addi	s2,s2,966 # 80011950 <q2>
    80002592:	2781                	sext.w	a5,a5
    80002594:	079e                	slli	a5,a5,0x7
    80002596:	97ca                	add	a5,a5,s2
    80002598:	0c47a983          	lw	s3,196(a5)
    8000259c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000259e:	2781                	sext.w	a5,a5
    800025a0:	079e                	slli	a5,a5,0x7
    800025a2:	0000f597          	auipc	a1,0xf
    800025a6:	3fe58593          	addi	a1,a1,1022 # 800119a0 <cpus+0x8>
    800025aa:	95be                	add	a1,a1,a5
    800025ac:	06048513          	addi	a0,s1,96
    800025b0:	00000097          	auipc	ra,0x0
    800025b4:	5d8080e7          	jalr	1496(ra) # 80002b88 <swtch>
    800025b8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800025ba:	2781                	sext.w	a5,a5
    800025bc:	079e                	slli	a5,a5,0x7
    800025be:	97ca                	add	a5,a5,s2
    800025c0:	0d37a223          	sw	s3,196(a5)
}
    800025c4:	70a2                	ld	ra,40(sp)
    800025c6:	7402                	ld	s0,32(sp)
    800025c8:	64e2                	ld	s1,24(sp)
    800025ca:	6942                	ld	s2,16(sp)
    800025cc:	69a2                	ld	s3,8(sp)
    800025ce:	6145                	addi	sp,sp,48
    800025d0:	8082                	ret
    panic("sched p->lock");
    800025d2:	00006517          	auipc	a0,0x6
    800025d6:	cf650513          	addi	a0,a0,-778 # 800082c8 <digits+0x288>
    800025da:	ffffe097          	auipc	ra,0xffffe
    800025de:	f66080e7          	jalr	-154(ra) # 80000540 <panic>
    panic("sched locks");
    800025e2:	00006517          	auipc	a0,0x6
    800025e6:	cf650513          	addi	a0,a0,-778 # 800082d8 <digits+0x298>
    800025ea:	ffffe097          	auipc	ra,0xffffe
    800025ee:	f56080e7          	jalr	-170(ra) # 80000540 <panic>
    panic("sched running");
    800025f2:	00006517          	auipc	a0,0x6
    800025f6:	cf650513          	addi	a0,a0,-778 # 800082e8 <digits+0x2a8>
    800025fa:	ffffe097          	auipc	ra,0xffffe
    800025fe:	f46080e7          	jalr	-186(ra) # 80000540 <panic>
    panic("sched interruptible");
    80002602:	00006517          	auipc	a0,0x6
    80002606:	cf650513          	addi	a0,a0,-778 # 800082f8 <digits+0x2b8>
    8000260a:	ffffe097          	auipc	ra,0xffffe
    8000260e:	f36080e7          	jalr	-202(ra) # 80000540 <panic>

0000000080002612 <exit>:
{
    80002612:	7179                	addi	sp,sp,-48
    80002614:	f406                	sd	ra,40(sp)
    80002616:	f022                	sd	s0,32(sp)
    80002618:	ec26                	sd	s1,24(sp)
    8000261a:	e84a                	sd	s2,16(sp)
    8000261c:	e44e                	sd	s3,8(sp)
    8000261e:	e052                	sd	s4,0(sp)
    80002620:	1800                	addi	s0,sp,48
    80002622:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002624:	00000097          	auipc	ra,0x0
    80002628:	8f8080e7          	jalr	-1800(ra) # 80001f1c <myproc>
    8000262c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000262e:	00007797          	auipc	a5,0x7
    80002632:	9ea7b783          	ld	a5,-1558(a5) # 80009018 <initproc>
    80002636:	0d050493          	addi	s1,a0,208
    8000263a:	15050913          	addi	s2,a0,336
    8000263e:	02a79363          	bne	a5,a0,80002664 <exit+0x52>
    panic("init exiting");
    80002642:	00006517          	auipc	a0,0x6
    80002646:	cce50513          	addi	a0,a0,-818 # 80008310 <digits+0x2d0>
    8000264a:	ffffe097          	auipc	ra,0xffffe
    8000264e:	ef6080e7          	jalr	-266(ra) # 80000540 <panic>
      fileclose(f);
    80002652:	00002097          	auipc	ra,0x2
    80002656:	504080e7          	jalr	1284(ra) # 80004b56 <fileclose>
      p->ofile[fd] = 0;
    8000265a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000265e:	04a1                	addi	s1,s1,8
    80002660:	01248563          	beq	s1,s2,8000266a <exit+0x58>
    if(p->ofile[fd]){
    80002664:	6088                	ld	a0,0(s1)
    80002666:	f575                	bnez	a0,80002652 <exit+0x40>
    80002668:	bfdd                	j	8000265e <exit+0x4c>
  begin_op();
    8000266a:	00002097          	auipc	ra,0x2
    8000266e:	01a080e7          	jalr	26(ra) # 80004684 <begin_op>
  iput(p->cwd);
    80002672:	1509b503          	ld	a0,336(s3)
    80002676:	00002097          	auipc	ra,0x2
    8000267a:	808080e7          	jalr	-2040(ra) # 80003e7e <iput>
  end_op();
    8000267e:	00002097          	auipc	ra,0x2
    80002682:	086080e7          	jalr	134(ra) # 80004704 <end_op>
  p->cwd = 0;
    80002686:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    8000268a:	00007497          	auipc	s1,0x7
    8000268e:	98e48493          	addi	s1,s1,-1650 # 80009018 <initproc>
    80002692:	6088                	ld	a0,0(s1)
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	568080e7          	jalr	1384(ra) # 80000bfc <acquire>
  wakeup1(initproc);
    8000269c:	6088                	ld	a0,0(s1)
    8000269e:	fffff097          	auipc	ra,0xfffff
    800026a2:	4ea080e7          	jalr	1258(ra) # 80001b88 <wakeup1>
  release(&initproc->lock);
    800026a6:	6088                	ld	a0,0(s1)
    800026a8:	ffffe097          	auipc	ra,0xffffe
    800026ac:	608080e7          	jalr	1544(ra) # 80000cb0 <release>
  acquire(&p->lock);
    800026b0:	854e                	mv	a0,s3
    800026b2:	ffffe097          	auipc	ra,0xffffe
    800026b6:	54a080e7          	jalr	1354(ra) # 80000bfc <acquire>
  struct proc *original_parent = p->parent;
    800026ba:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800026be:	854e                	mv	a0,s3
    800026c0:	ffffe097          	auipc	ra,0xffffe
    800026c4:	5f0080e7          	jalr	1520(ra) # 80000cb0 <release>
  acquire(&original_parent->lock);
    800026c8:	8526                	mv	a0,s1
    800026ca:	ffffe097          	auipc	ra,0xffffe
    800026ce:	532080e7          	jalr	1330(ra) # 80000bfc <acquire>
  acquire(&p->lock);
    800026d2:	854e                	mv	a0,s3
    800026d4:	ffffe097          	auipc	ra,0xffffe
    800026d8:	528080e7          	jalr	1320(ra) # 80000bfc <acquire>
  reparent(p);
    800026dc:	854e                	mv	a0,s3
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	de8080e7          	jalr	-536(ra) # 800024c6 <reparent>
  wakeup1(original_parent);
    800026e6:	8526                	mv	a0,s1
    800026e8:	fffff097          	auipc	ra,0xfffff
    800026ec:	4a0080e7          	jalr	1184(ra) # 80001b88 <wakeup1>
  p->xstate = status;
    800026f0:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800026f4:	4791                	li	a5,4
    800026f6:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    800026fa:	8526                	mv	a0,s1
    800026fc:	ffffe097          	auipc	ra,0xffffe
    80002700:	5b4080e7          	jalr	1460(ra) # 80000cb0 <release>
  sched();
    80002704:	00000097          	auipc	ra,0x0
    80002708:	e38080e7          	jalr	-456(ra) # 8000253c <sched>
  panic("zombie exit");
    8000270c:	00006517          	auipc	a0,0x6
    80002710:	c1450513          	addi	a0,a0,-1004 # 80008320 <digits+0x2e0>
    80002714:	ffffe097          	auipc	ra,0xffffe
    80002718:	e2c080e7          	jalr	-468(ra) # 80000540 <panic>

000000008000271c <yield>:
{
    8000271c:	1101                	addi	sp,sp,-32
    8000271e:	ec06                	sd	ra,24(sp)
    80002720:	e822                	sd	s0,16(sp)
    80002722:	e426                	sd	s1,8(sp)
    80002724:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002726:	fffff097          	auipc	ra,0xfffff
    8000272a:	7f6080e7          	jalr	2038(ra) # 80001f1c <myproc>
    8000272e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	4cc080e7          	jalr	1228(ra) # 80000bfc <acquire>
  p->state = RUNNABLE;
    80002738:	4789                	li	a5,2
    8000273a:	cc9c                	sw	a5,24(s1)
  if (is_q2(p) && p->p_intr == 0) __RE_MOVE___(p, &q2, &q1);
    8000273c:	1684a703          	lw	a4,360(s1)
    80002740:	00f71563          	bne	a4,a5,8000274a <yield+0x2e>
    80002744:	1904a783          	lw	a5,400(s1)
    80002748:	c785                	beqz	a5,80002770 <yield+0x54>
  if (p->p_intr == 1) p->p_intr = 0;
    8000274a:	1904a703          	lw	a4,400(s1)
    8000274e:	4785                	li	a5,1
    80002750:	04f70363          	beq	a4,a5,80002796 <yield+0x7a>
  sched();
    80002754:	00000097          	auipc	ra,0x0
    80002758:	de8080e7          	jalr	-536(ra) # 8000253c <sched>
  release(&p->lock);
    8000275c:	8526                	mv	a0,s1
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	552080e7          	jalr	1362(ra) # 80000cb0 <release>
}
    80002766:	60e2                	ld	ra,24(sp)
    80002768:	6442                	ld	s0,16(sp)
    8000276a:	64a2                	ld	s1,8(sp)
    8000276c:	6105                	addi	sp,sp,32
    8000276e:	8082                	ret
  if (is_q2(p) && p->p_intr == 0) __RE_MOVE___(p, &q2, &q1);
    80002770:	85a6                	mv	a1,s1
    80002772:	0000f517          	auipc	a0,0xf
    80002776:	1de50513          	addi	a0,a0,478 # 80011950 <q2>
    8000277a:	fffff097          	auipc	ra,0xfffff
    8000277e:	384080e7          	jalr	900(ra) # 80001afe <remove>
    80002782:	85aa                	mv	a1,a0
    80002784:	0000f517          	auipc	a0,0xf
    80002788:	1e450513          	addi	a0,a0,484 # 80011968 <q1>
    8000278c:	fffff097          	auipc	ra,0xfffff
    80002790:	2ec080e7          	jalr	748(ra) # 80001a78 <enqueue>
    80002794:	bf5d                	j	8000274a <yield+0x2e>
  if (p->p_intr == 1) p->p_intr = 0;
    80002796:	1804a823          	sw	zero,400(s1)
    8000279a:	bf6d                	j	80002754 <yield+0x38>

000000008000279c <sleep>:
{
    8000279c:	7179                	addi	sp,sp,-48
    8000279e:	f406                	sd	ra,40(sp)
    800027a0:	f022                	sd	s0,32(sp)
    800027a2:	ec26                	sd	s1,24(sp)
    800027a4:	e84a                	sd	s2,16(sp)
    800027a6:	e44e                	sd	s3,8(sp)
    800027a8:	1800                	addi	s0,sp,48
    800027aa:	89aa                	mv	s3,a0
    800027ac:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027ae:	fffff097          	auipc	ra,0xfffff
    800027b2:	76e080e7          	jalr	1902(ra) # 80001f1c <myproc>
    800027b6:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800027b8:	05250663          	beq	a0,s2,80002804 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800027bc:	ffffe097          	auipc	ra,0xffffe
    800027c0:	440080e7          	jalr	1088(ra) # 80000bfc <acquire>
    release(lk);
    800027c4:	854a                	mv	a0,s2
    800027c6:	ffffe097          	auipc	ra,0xffffe
    800027ca:	4ea080e7          	jalr	1258(ra) # 80000cb0 <release>
  p->chan = chan;
    800027ce:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800027d2:	4785                	li	a5,1
    800027d4:	cc9c                	sw	a5,24(s1)
  sched();
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	d66080e7          	jalr	-666(ra) # 8000253c <sched>
  p->chan = 0;
    800027de:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800027e2:	8526                	mv	a0,s1
    800027e4:	ffffe097          	auipc	ra,0xffffe
    800027e8:	4cc080e7          	jalr	1228(ra) # 80000cb0 <release>
    acquire(lk);
    800027ec:	854a                	mv	a0,s2
    800027ee:	ffffe097          	auipc	ra,0xffffe
    800027f2:	40e080e7          	jalr	1038(ra) # 80000bfc <acquire>
}
    800027f6:	70a2                	ld	ra,40(sp)
    800027f8:	7402                	ld	s0,32(sp)
    800027fa:	64e2                	ld	s1,24(sp)
    800027fc:	6942                	ld	s2,16(sp)
    800027fe:	69a2                	ld	s3,8(sp)
    80002800:	6145                	addi	sp,sp,48
    80002802:	8082                	ret
  p->chan = chan;
    80002804:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002808:	4785                	li	a5,1
    8000280a:	cd1c                	sw	a5,24(a0)
  sched();
    8000280c:	00000097          	auipc	ra,0x0
    80002810:	d30080e7          	jalr	-720(ra) # 8000253c <sched>
  p->chan = 0;
    80002814:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002818:	bff9                	j	800027f6 <sleep+0x5a>

000000008000281a <wait>:
{
    8000281a:	715d                	addi	sp,sp,-80
    8000281c:	e486                	sd	ra,72(sp)
    8000281e:	e0a2                	sd	s0,64(sp)
    80002820:	fc26                	sd	s1,56(sp)
    80002822:	f84a                	sd	s2,48(sp)
    80002824:	f44e                	sd	s3,40(sp)
    80002826:	f052                	sd	s4,32(sp)
    80002828:	ec56                	sd	s5,24(sp)
    8000282a:	e85a                	sd	s6,16(sp)
    8000282c:	e45e                	sd	s7,8(sp)
    8000282e:	0880                	addi	s0,sp,80
    80002830:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002832:	fffff097          	auipc	ra,0xfffff
    80002836:	6ea080e7          	jalr	1770(ra) # 80001f1c <myproc>
    8000283a:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000283c:	ffffe097          	auipc	ra,0xffffe
    80002840:	3c0080e7          	jalr	960(ra) # 80000bfc <acquire>
    havekids = 0;
    80002844:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002846:	4a11                	li	s4,4
        havekids = 1;
    80002848:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000284a:	00016997          	auipc	s3,0x16
    8000284e:	b6698993          	addi	s3,s3,-1178 # 800183b0 <tickslock>
    havekids = 0;
    80002852:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002854:	0000f497          	auipc	s1,0xf
    80002858:	55c48493          	addi	s1,s1,1372 # 80011db0 <proc>
    8000285c:	a08d                	j	800028be <wait+0xa4>
          pid = np->pid;
    8000285e:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002862:	000b0e63          	beqz	s6,8000287e <wait+0x64>
    80002866:	4691                	li	a3,4
    80002868:	03448613          	addi	a2,s1,52
    8000286c:	85da                	mv	a1,s6
    8000286e:	05093503          	ld	a0,80(s2)
    80002872:	fffff097          	auipc	ra,0xfffff
    80002876:	e38080e7          	jalr	-456(ra) # 800016aa <copyout>
    8000287a:	02054263          	bltz	a0,8000289e <wait+0x84>
          freeproc(np);
    8000287e:	8526                	mv	a0,s1
    80002880:	00000097          	auipc	ra,0x0
    80002884:	84e080e7          	jalr	-1970(ra) # 800020ce <freeproc>
          release(&np->lock);
    80002888:	8526                	mv	a0,s1
    8000288a:	ffffe097          	auipc	ra,0xffffe
    8000288e:	426080e7          	jalr	1062(ra) # 80000cb0 <release>
          release(&p->lock);
    80002892:	854a                	mv	a0,s2
    80002894:	ffffe097          	auipc	ra,0xffffe
    80002898:	41c080e7          	jalr	1052(ra) # 80000cb0 <release>
          return pid;
    8000289c:	a8a9                	j	800028f6 <wait+0xdc>
            release(&np->lock);
    8000289e:	8526                	mv	a0,s1
    800028a0:	ffffe097          	auipc	ra,0xffffe
    800028a4:	410080e7          	jalr	1040(ra) # 80000cb0 <release>
            release(&p->lock);
    800028a8:	854a                	mv	a0,s2
    800028aa:	ffffe097          	auipc	ra,0xffffe
    800028ae:	406080e7          	jalr	1030(ra) # 80000cb0 <release>
            return -1;
    800028b2:	59fd                	li	s3,-1
    800028b4:	a089                	j	800028f6 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    800028b6:	19848493          	addi	s1,s1,408
    800028ba:	03348463          	beq	s1,s3,800028e2 <wait+0xc8>
      if(np->parent == p){
    800028be:	709c                	ld	a5,32(s1)
    800028c0:	ff279be3          	bne	a5,s2,800028b6 <wait+0x9c>
        acquire(&np->lock);
    800028c4:	8526                	mv	a0,s1
    800028c6:	ffffe097          	auipc	ra,0xffffe
    800028ca:	336080e7          	jalr	822(ra) # 80000bfc <acquire>
        if(np->state == ZOMBIE){
    800028ce:	4c9c                	lw	a5,24(s1)
    800028d0:	f94787e3          	beq	a5,s4,8000285e <wait+0x44>
        release(&np->lock);
    800028d4:	8526                	mv	a0,s1
    800028d6:	ffffe097          	auipc	ra,0xffffe
    800028da:	3da080e7          	jalr	986(ra) # 80000cb0 <release>
        havekids = 1;
    800028de:	8756                	mv	a4,s5
    800028e0:	bfd9                	j	800028b6 <wait+0x9c>
    if(!havekids || p->killed){
    800028e2:	c701                	beqz	a4,800028ea <wait+0xd0>
    800028e4:	03092783          	lw	a5,48(s2)
    800028e8:	c39d                	beqz	a5,8000290e <wait+0xf4>
      release(&p->lock);
    800028ea:	854a                	mv	a0,s2
    800028ec:	ffffe097          	auipc	ra,0xffffe
    800028f0:	3c4080e7          	jalr	964(ra) # 80000cb0 <release>
      return -1;
    800028f4:	59fd                	li	s3,-1
}
    800028f6:	854e                	mv	a0,s3
    800028f8:	60a6                	ld	ra,72(sp)
    800028fa:	6406                	ld	s0,64(sp)
    800028fc:	74e2                	ld	s1,56(sp)
    800028fe:	7942                	ld	s2,48(sp)
    80002900:	79a2                	ld	s3,40(sp)
    80002902:	7a02                	ld	s4,32(sp)
    80002904:	6ae2                	ld	s5,24(sp)
    80002906:	6b42                	ld	s6,16(sp)
    80002908:	6ba2                	ld	s7,8(sp)
    8000290a:	6161                	addi	sp,sp,80
    8000290c:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000290e:	85ca                	mv	a1,s2
    80002910:	854a                	mv	a0,s2
    80002912:	00000097          	auipc	ra,0x0
    80002916:	e8a080e7          	jalr	-374(ra) # 8000279c <sleep>
    havekids = 0;
    8000291a:	bf25                	j	80002852 <wait+0x38>

000000008000291c <wakeup>:
{
    8000291c:	715d                	addi	sp,sp,-80
    8000291e:	e486                	sd	ra,72(sp)
    80002920:	e0a2                	sd	s0,64(sp)
    80002922:	fc26                	sd	s1,56(sp)
    80002924:	f84a                	sd	s2,48(sp)
    80002926:	f44e                	sd	s3,40(sp)
    80002928:	f052                	sd	s4,32(sp)
    8000292a:	ec56                	sd	s5,24(sp)
    8000292c:	e85a                	sd	s6,16(sp)
    8000292e:	e45e                	sd	s7,8(sp)
    80002930:	0880                	addi	s0,sp,80
    80002932:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002934:	0000f497          	auipc	s1,0xf
    80002938:	47c48493          	addi	s1,s1,1148 # 80011db0 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000293c:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000293e:	4a89                	li	s5,2
        __RE_MOVE___(p, &q0, &q2);
    80002940:	0000fb97          	auipc	s7,0xf
    80002944:	010b8b93          	addi	s7,s7,16 # 80011950 <q2>
    80002948:	0000fb17          	auipc	s6,0xf
    8000294c:	038b0b13          	addi	s6,s6,56 # 80011980 <q0>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002950:	00016917          	auipc	s2,0x16
    80002954:	a6090913          	addi	s2,s2,-1440 # 800183b0 <tickslock>
    80002958:	a811                	j	8000296c <wakeup+0x50>
    release(&p->lock);
    8000295a:	8526                	mv	a0,s1
    8000295c:	ffffe097          	auipc	ra,0xffffe
    80002960:	354080e7          	jalr	852(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002964:	19848493          	addi	s1,s1,408
    80002968:	03248f63          	beq	s1,s2,800029a6 <wakeup+0x8a>
    acquire(&p->lock);
    8000296c:	8526                	mv	a0,s1
    8000296e:	ffffe097          	auipc	ra,0xffffe
    80002972:	28e080e7          	jalr	654(ra) # 80000bfc <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002976:	4c9c                	lw	a5,24(s1)
    80002978:	ff3791e3          	bne	a5,s3,8000295a <wakeup+0x3e>
    8000297c:	749c                	ld	a5,40(s1)
    8000297e:	fd479ee3          	bne	a5,s4,8000295a <wakeup+0x3e>
      p->state = RUNNABLE;
    80002982:	0154ac23          	sw	s5,24(s1)
      if (is_q0(p)) // Move all to q2
    80002986:	1684a783          	lw	a5,360(s1)
    8000298a:	fbe1                	bnez	a5,8000295a <wakeup+0x3e>
        __RE_MOVE___(p, &q0, &q2);
    8000298c:	85a6                	mv	a1,s1
    8000298e:	855a                	mv	a0,s6
    80002990:	fffff097          	auipc	ra,0xfffff
    80002994:	16e080e7          	jalr	366(ra) # 80001afe <remove>
    80002998:	85aa                	mv	a1,a0
    8000299a:	855e                	mv	a0,s7
    8000299c:	fffff097          	auipc	ra,0xfffff
    800029a0:	0dc080e7          	jalr	220(ra) # 80001a78 <enqueue>
    800029a4:	bf5d                	j	8000295a <wakeup+0x3e>
}
    800029a6:	60a6                	ld	ra,72(sp)
    800029a8:	6406                	ld	s0,64(sp)
    800029aa:	74e2                	ld	s1,56(sp)
    800029ac:	7942                	ld	s2,48(sp)
    800029ae:	79a2                	ld	s3,40(sp)
    800029b0:	7a02                	ld	s4,32(sp)
    800029b2:	6ae2                	ld	s5,24(sp)
    800029b4:	6b42                	ld	s6,16(sp)
    800029b6:	6ba2                	ld	s7,8(sp)
    800029b8:	6161                	addi	sp,sp,80
    800029ba:	8082                	ret

00000000800029bc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800029bc:	7179                	addi	sp,sp,-48
    800029be:	f406                	sd	ra,40(sp)
    800029c0:	f022                	sd	s0,32(sp)
    800029c2:	ec26                	sd	s1,24(sp)
    800029c4:	e84a                	sd	s2,16(sp)
    800029c6:	e44e                	sd	s3,8(sp)
    800029c8:	1800                	addi	s0,sp,48
    800029ca:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800029cc:	0000f497          	auipc	s1,0xf
    800029d0:	3e448493          	addi	s1,s1,996 # 80011db0 <proc>
    800029d4:	00016997          	auipc	s3,0x16
    800029d8:	9dc98993          	addi	s3,s3,-1572 # 800183b0 <tickslock>
    acquire(&p->lock);
    800029dc:	8526                	mv	a0,s1
    800029de:	ffffe097          	auipc	ra,0xffffe
    800029e2:	21e080e7          	jalr	542(ra) # 80000bfc <acquire>
    if(p->pid == pid){
    800029e6:	5c9c                	lw	a5,56(s1)
    800029e8:	01278d63          	beq	a5,s2,80002a02 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800029ec:	8526                	mv	a0,s1
    800029ee:	ffffe097          	auipc	ra,0xffffe
    800029f2:	2c2080e7          	jalr	706(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800029f6:	19848493          	addi	s1,s1,408
    800029fa:	ff3491e3          	bne	s1,s3,800029dc <kill+0x20>
  }
  return -1;
    800029fe:	557d                	li	a0,-1
    80002a00:	a821                	j	80002a18 <kill+0x5c>
      p->killed = 1;
    80002a02:	4785                	li	a5,1
    80002a04:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002a06:	4c98                	lw	a4,24(s1)
    80002a08:	00f70f63          	beq	a4,a5,80002a26 <kill+0x6a>
      release(&p->lock);
    80002a0c:	8526                	mv	a0,s1
    80002a0e:	ffffe097          	auipc	ra,0xffffe
    80002a12:	2a2080e7          	jalr	674(ra) # 80000cb0 <release>
      return 0;
    80002a16:	4501                	li	a0,0
}
    80002a18:	70a2                	ld	ra,40(sp)
    80002a1a:	7402                	ld	s0,32(sp)
    80002a1c:	64e2                	ld	s1,24(sp)
    80002a1e:	6942                	ld	s2,16(sp)
    80002a20:	69a2                	ld	s3,8(sp)
    80002a22:	6145                	addi	sp,sp,48
    80002a24:	8082                	ret
        p->state = RUNNABLE;
    80002a26:	4789                	li	a5,2
    80002a28:	cc9c                	sw	a5,24(s1)
    80002a2a:	b7cd                	j	80002a0c <kill+0x50>

0000000080002a2c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002a2c:	7179                	addi	sp,sp,-48
    80002a2e:	f406                	sd	ra,40(sp)
    80002a30:	f022                	sd	s0,32(sp)
    80002a32:	ec26                	sd	s1,24(sp)
    80002a34:	e84a                	sd	s2,16(sp)
    80002a36:	e44e                	sd	s3,8(sp)
    80002a38:	e052                	sd	s4,0(sp)
    80002a3a:	1800                	addi	s0,sp,48
    80002a3c:	84aa                	mv	s1,a0
    80002a3e:	892e                	mv	s2,a1
    80002a40:	89b2                	mv	s3,a2
    80002a42:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002a44:	fffff097          	auipc	ra,0xfffff
    80002a48:	4d8080e7          	jalr	1240(ra) # 80001f1c <myproc>
  if(user_dst){
    80002a4c:	c08d                	beqz	s1,80002a6e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002a4e:	86d2                	mv	a3,s4
    80002a50:	864e                	mv	a2,s3
    80002a52:	85ca                	mv	a1,s2
    80002a54:	6928                	ld	a0,80(a0)
    80002a56:	fffff097          	auipc	ra,0xfffff
    80002a5a:	c54080e7          	jalr	-940(ra) # 800016aa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002a5e:	70a2                	ld	ra,40(sp)
    80002a60:	7402                	ld	s0,32(sp)
    80002a62:	64e2                	ld	s1,24(sp)
    80002a64:	6942                	ld	s2,16(sp)
    80002a66:	69a2                	ld	s3,8(sp)
    80002a68:	6a02                	ld	s4,0(sp)
    80002a6a:	6145                	addi	sp,sp,48
    80002a6c:	8082                	ret
    memmove((char *)dst, src, len);
    80002a6e:	000a061b          	sext.w	a2,s4
    80002a72:	85ce                	mv	a1,s3
    80002a74:	854a                	mv	a0,s2
    80002a76:	ffffe097          	auipc	ra,0xffffe
    80002a7a:	2de080e7          	jalr	734(ra) # 80000d54 <memmove>
    return 0;
    80002a7e:	8526                	mv	a0,s1
    80002a80:	bff9                	j	80002a5e <either_copyout+0x32>

0000000080002a82 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002a82:	7179                	addi	sp,sp,-48
    80002a84:	f406                	sd	ra,40(sp)
    80002a86:	f022                	sd	s0,32(sp)
    80002a88:	ec26                	sd	s1,24(sp)
    80002a8a:	e84a                	sd	s2,16(sp)
    80002a8c:	e44e                	sd	s3,8(sp)
    80002a8e:	e052                	sd	s4,0(sp)
    80002a90:	1800                	addi	s0,sp,48
    80002a92:	892a                	mv	s2,a0
    80002a94:	84ae                	mv	s1,a1
    80002a96:	89b2                	mv	s3,a2
    80002a98:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002a9a:	fffff097          	auipc	ra,0xfffff
    80002a9e:	482080e7          	jalr	1154(ra) # 80001f1c <myproc>
  if(user_src){
    80002aa2:	c08d                	beqz	s1,80002ac4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002aa4:	86d2                	mv	a3,s4
    80002aa6:	864e                	mv	a2,s3
    80002aa8:	85ca                	mv	a1,s2
    80002aaa:	6928                	ld	a0,80(a0)
    80002aac:	fffff097          	auipc	ra,0xfffff
    80002ab0:	c8a080e7          	jalr	-886(ra) # 80001736 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002ab4:	70a2                	ld	ra,40(sp)
    80002ab6:	7402                	ld	s0,32(sp)
    80002ab8:	64e2                	ld	s1,24(sp)
    80002aba:	6942                	ld	s2,16(sp)
    80002abc:	69a2                	ld	s3,8(sp)
    80002abe:	6a02                	ld	s4,0(sp)
    80002ac0:	6145                	addi	sp,sp,48
    80002ac2:	8082                	ret
    memmove(dst, (char*)src, len);
    80002ac4:	000a061b          	sext.w	a2,s4
    80002ac8:	85ce                	mv	a1,s3
    80002aca:	854a                	mv	a0,s2
    80002acc:	ffffe097          	auipc	ra,0xffffe
    80002ad0:	288080e7          	jalr	648(ra) # 80000d54 <memmove>
    return 0;
    80002ad4:	8526                	mv	a0,s1
    80002ad6:	bff9                	j	80002ab4 <either_copyin+0x32>

0000000080002ad8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002ad8:	715d                	addi	sp,sp,-80
    80002ada:	e486                	sd	ra,72(sp)
    80002adc:	e0a2                	sd	s0,64(sp)
    80002ade:	fc26                	sd	s1,56(sp)
    80002ae0:	f84a                	sd	s2,48(sp)
    80002ae2:	f44e                	sd	s3,40(sp)
    80002ae4:	f052                	sd	s4,32(sp)
    80002ae6:	ec56                	sd	s5,24(sp)
    80002ae8:	e85a                	sd	s6,16(sp)
    80002aea:	e45e                	sd	s7,8(sp)
    80002aec:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002aee:	00005517          	auipc	a0,0x5
    80002af2:	76a50513          	addi	a0,a0,1898 # 80008258 <digits+0x218>
    80002af6:	ffffe097          	auipc	ra,0xffffe
    80002afa:	a94080e7          	jalr	-1388(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002afe:	0000f497          	auipc	s1,0xf
    80002b02:	40a48493          	addi	s1,s1,1034 # 80011f08 <proc+0x158>
    80002b06:	00016917          	auipc	s2,0x16
    80002b0a:	a0290913          	addi	s2,s2,-1534 # 80018508 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002b0e:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002b10:	00006997          	auipc	s3,0x6
    80002b14:	82098993          	addi	s3,s3,-2016 # 80008330 <digits+0x2f0>
    printf("%d %s %s", p->pid, state, p->name);
    80002b18:	00006a97          	auipc	s5,0x6
    80002b1c:	820a8a93          	addi	s5,s5,-2016 # 80008338 <digits+0x2f8>
    printf("\n");
    80002b20:	00005a17          	auipc	s4,0x5
    80002b24:	738a0a13          	addi	s4,s4,1848 # 80008258 <digits+0x218>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002b28:	00006b97          	auipc	s7,0x6
    80002b2c:	848b8b93          	addi	s7,s7,-1976 # 80008370 <states.0>
    80002b30:	a00d                	j	80002b52 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002b32:	ee06a583          	lw	a1,-288(a3)
    80002b36:	8556                	mv	a0,s5
    80002b38:	ffffe097          	auipc	ra,0xffffe
    80002b3c:	a52080e7          	jalr	-1454(ra) # 8000058a <printf>
    printf("\n");
    80002b40:	8552                	mv	a0,s4
    80002b42:	ffffe097          	auipc	ra,0xffffe
    80002b46:	a48080e7          	jalr	-1464(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002b4a:	19848493          	addi	s1,s1,408
    80002b4e:	03248263          	beq	s1,s2,80002b72 <procdump+0x9a>
    if(p->state == UNUSED)
    80002b52:	86a6                	mv	a3,s1
    80002b54:	ec04a783          	lw	a5,-320(s1)
    80002b58:	dbed                	beqz	a5,80002b4a <procdump+0x72>
      state = "???";
    80002b5a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002b5c:	fcfb6be3          	bltu	s6,a5,80002b32 <procdump+0x5a>
    80002b60:	02079713          	slli	a4,a5,0x20
    80002b64:	01d75793          	srli	a5,a4,0x1d
    80002b68:	97de                	add	a5,a5,s7
    80002b6a:	6390                	ld	a2,0(a5)
    80002b6c:	f279                	bnez	a2,80002b32 <procdump+0x5a>
      state = "???";
    80002b6e:	864e                	mv	a2,s3
    80002b70:	b7c9                	j	80002b32 <procdump+0x5a>
  }
}
    80002b72:	60a6                	ld	ra,72(sp)
    80002b74:	6406                	ld	s0,64(sp)
    80002b76:	74e2                	ld	s1,56(sp)
    80002b78:	7942                	ld	s2,48(sp)
    80002b7a:	79a2                	ld	s3,40(sp)
    80002b7c:	7a02                	ld	s4,32(sp)
    80002b7e:	6ae2                	ld	s5,24(sp)
    80002b80:	6b42                	ld	s6,16(sp)
    80002b82:	6ba2                	ld	s7,8(sp)
    80002b84:	6161                	addi	sp,sp,80
    80002b86:	8082                	ret

0000000080002b88 <swtch>:
    80002b88:	00153023          	sd	ra,0(a0)
    80002b8c:	00253423          	sd	sp,8(a0)
    80002b90:	e900                	sd	s0,16(a0)
    80002b92:	ed04                	sd	s1,24(a0)
    80002b94:	03253023          	sd	s2,32(a0)
    80002b98:	03353423          	sd	s3,40(a0)
    80002b9c:	03453823          	sd	s4,48(a0)
    80002ba0:	03553c23          	sd	s5,56(a0)
    80002ba4:	05653023          	sd	s6,64(a0)
    80002ba8:	05753423          	sd	s7,72(a0)
    80002bac:	05853823          	sd	s8,80(a0)
    80002bb0:	05953c23          	sd	s9,88(a0)
    80002bb4:	07a53023          	sd	s10,96(a0)
    80002bb8:	07b53423          	sd	s11,104(a0)
    80002bbc:	0005b083          	ld	ra,0(a1)
    80002bc0:	0085b103          	ld	sp,8(a1)
    80002bc4:	6980                	ld	s0,16(a1)
    80002bc6:	6d84                	ld	s1,24(a1)
    80002bc8:	0205b903          	ld	s2,32(a1)
    80002bcc:	0285b983          	ld	s3,40(a1)
    80002bd0:	0305ba03          	ld	s4,48(a1)
    80002bd4:	0385ba83          	ld	s5,56(a1)
    80002bd8:	0405bb03          	ld	s6,64(a1)
    80002bdc:	0485bb83          	ld	s7,72(a1)
    80002be0:	0505bc03          	ld	s8,80(a1)
    80002be4:	0585bc83          	ld	s9,88(a1)
    80002be8:	0605bd03          	ld	s10,96(a1)
    80002bec:	0685bd83          	ld	s11,104(a1)
    80002bf0:	8082                	ret

0000000080002bf2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002bf2:	1141                	addi	sp,sp,-16
    80002bf4:	e406                	sd	ra,8(sp)
    80002bf6:	e022                	sd	s0,0(sp)
    80002bf8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002bfa:	00005597          	auipc	a1,0x5
    80002bfe:	79e58593          	addi	a1,a1,1950 # 80008398 <states.0+0x28>
    80002c02:	00015517          	auipc	a0,0x15
    80002c06:	7ae50513          	addi	a0,a0,1966 # 800183b0 <tickslock>
    80002c0a:	ffffe097          	auipc	ra,0xffffe
    80002c0e:	f62080e7          	jalr	-158(ra) # 80000b6c <initlock>
}
    80002c12:	60a2                	ld	ra,8(sp)
    80002c14:	6402                	ld	s0,0(sp)
    80002c16:	0141                	addi	sp,sp,16
    80002c18:	8082                	ret

0000000080002c1a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002c1a:	1141                	addi	sp,sp,-16
    80002c1c:	e422                	sd	s0,8(sp)
    80002c1e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c20:	00003797          	auipc	a5,0x3
    80002c24:	59078793          	addi	a5,a5,1424 # 800061b0 <kernelvec>
    80002c28:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002c2c:	6422                	ld	s0,8(sp)
    80002c2e:	0141                	addi	sp,sp,16
    80002c30:	8082                	ret

0000000080002c32 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002c32:	1141                	addi	sp,sp,-16
    80002c34:	e406                	sd	ra,8(sp)
    80002c36:	e022                	sd	s0,0(sp)
    80002c38:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002c3a:	fffff097          	auipc	ra,0xfffff
    80002c3e:	2e2080e7          	jalr	738(ra) # 80001f1c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002c46:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c48:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002c4c:	00004617          	auipc	a2,0x4
    80002c50:	3b460613          	addi	a2,a2,948 # 80007000 <_trampoline>
    80002c54:	00004697          	auipc	a3,0x4
    80002c58:	3ac68693          	addi	a3,a3,940 # 80007000 <_trampoline>
    80002c5c:	8e91                	sub	a3,a3,a2
    80002c5e:	040007b7          	lui	a5,0x4000
    80002c62:	17fd                	addi	a5,a5,-1
    80002c64:	07b2                	slli	a5,a5,0xc
    80002c66:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c68:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002c6c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002c6e:	180026f3          	csrr	a3,satp
    80002c72:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002c74:	6d38                	ld	a4,88(a0)
    80002c76:	6134                	ld	a3,64(a0)
    80002c78:	6585                	lui	a1,0x1
    80002c7a:	96ae                	add	a3,a3,a1
    80002c7c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002c7e:	6d38                	ld	a4,88(a0)
    80002c80:	00000697          	auipc	a3,0x0
    80002c84:	18868693          	addi	a3,a3,392 # 80002e08 <usertrap>
    80002c88:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002c8a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c8c:	8692                	mv	a3,tp
    80002c8e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c90:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002c94:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002c98:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c9c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002ca0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ca2:	6f18                	ld	a4,24(a4)
    80002ca4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002ca8:	692c                	ld	a1,80(a0)
    80002caa:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002cac:	00004717          	auipc	a4,0x4
    80002cb0:	3e470713          	addi	a4,a4,996 # 80007090 <userret>
    80002cb4:	8f11                	sub	a4,a4,a2
    80002cb6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002cb8:	577d                	li	a4,-1
    80002cba:	177e                	slli	a4,a4,0x3f
    80002cbc:	8dd9                	or	a1,a1,a4
    80002cbe:	02000537          	lui	a0,0x2000
    80002cc2:	157d                	addi	a0,a0,-1
    80002cc4:	0536                	slli	a0,a0,0xd
    80002cc6:	9782                	jalr	a5
}
    80002cc8:	60a2                	ld	ra,8(sp)
    80002cca:	6402                	ld	s0,0(sp)
    80002ccc:	0141                	addi	sp,sp,16
    80002cce:	8082                	ret

0000000080002cd0 <clockintr>:
// Both are from proc.c
#endif

void
clockintr()
{
    80002cd0:	7179                	addi	sp,sp,-48
    80002cd2:	f406                	sd	ra,40(sp)
    80002cd4:	f022                	sd	s0,32(sp)
    80002cd6:	ec26                	sd	s1,24(sp)
    80002cd8:	e84a                	sd	s2,16(sp)
    80002cda:	e44e                	sd	s3,8(sp)
    80002cdc:	e052                	sd	s4,0(sp)
    80002cde:	1800                	addi	s0,sp,48
  acquire(&tickslock);
    80002ce0:	00015517          	auipc	a0,0x15
    80002ce4:	6d050513          	addi	a0,a0,1744 # 800183b0 <tickslock>
    80002ce8:	ffffe097          	auipc	ra,0xffffe
    80002cec:	f14080e7          	jalr	-236(ra) # 80000bfc <acquire>
  ticks++;
    80002cf0:	00006717          	auipc	a4,0x6
    80002cf4:	33070713          	addi	a4,a4,816 # 80009020 <ticks>
    80002cf8:	431c                	lw	a5,0(a4)
    80002cfa:	2785                	addiw	a5,a5,1
    80002cfc:	c31c                	sw	a5,0(a4)
#ifdef SUKJOON
  // Rounds all valid processes in order to count the ticks.
  for(struct proc* p = proc; p < &proc[NPROC]; p++)
    80002cfe:	0000f497          	auipc	s1,0xf
    80002d02:	0b248493          	addi	s1,s1,178 # 80011db0 <proc>
    if (p != 0 && p->p_id != -1) record_tick2(p, ticks);
    80002d06:	59fd                	li	s3,-1
    80002d08:	8a3a                	mv	s4,a4
  for(struct proc* p = proc; p < &proc[NPROC]; p++)
    80002d0a:	00015917          	auipc	s2,0x15
    80002d0e:	6a690913          	addi	s2,s2,1702 # 800183b0 <tickslock>
    80002d12:	a029                	j	80002d1c <clockintr+0x4c>
    80002d14:	19848493          	addi	s1,s1,408
    80002d18:	01248f63          	beq	s1,s2,80002d36 <clockintr+0x66>
    if (p != 0 && p->p_id != -1) record_tick2(p, ticks);
    80002d1c:	dce5                	beqz	s1,80002d14 <clockintr+0x44>
    80002d1e:	1684a783          	lw	a5,360(s1)
    80002d22:	ff3789e3          	beq	a5,s3,80002d14 <clockintr+0x44>
    80002d26:	000a2583          	lw	a1,0(s4)
    80002d2a:	8526                	mv	a0,s1
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	c68080e7          	jalr	-920(ra) # 80001994 <record_tick2>
    80002d34:	b7c5                	j	80002d14 <clockintr+0x44>
#endif
  wakeup(&ticks);
    80002d36:	00006517          	auipc	a0,0x6
    80002d3a:	2ea50513          	addi	a0,a0,746 # 80009020 <ticks>
    80002d3e:	00000097          	auipc	ra,0x0
    80002d42:	bde080e7          	jalr	-1058(ra) # 8000291c <wakeup>
  release(&tickslock);
    80002d46:	00015517          	auipc	a0,0x15
    80002d4a:	66a50513          	addi	a0,a0,1642 # 800183b0 <tickslock>
    80002d4e:	ffffe097          	auipc	ra,0xffffe
    80002d52:	f62080e7          	jalr	-158(ra) # 80000cb0 <release>

}
    80002d56:	70a2                	ld	ra,40(sp)
    80002d58:	7402                	ld	s0,32(sp)
    80002d5a:	64e2                	ld	s1,24(sp)
    80002d5c:	6942                	ld	s2,16(sp)
    80002d5e:	69a2                	ld	s3,8(sp)
    80002d60:	6a02                	ld	s4,0(sp)
    80002d62:	6145                	addi	sp,sp,48
    80002d64:	8082                	ret

0000000080002d66 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002d66:	1101                	addi	sp,sp,-32
    80002d68:	ec06                	sd	ra,24(sp)
    80002d6a:	e822                	sd	s0,16(sp)
    80002d6c:	e426                	sd	s1,8(sp)
    80002d6e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d70:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002d74:	00074d63          	bltz	a4,80002d8e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002d78:	57fd                	li	a5,-1
    80002d7a:	17fe                	slli	a5,a5,0x3f
    80002d7c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002d7e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002d80:	06f70363          	beq	a4,a5,80002de6 <devintr+0x80>
  }
}
    80002d84:	60e2                	ld	ra,24(sp)
    80002d86:	6442                	ld	s0,16(sp)
    80002d88:	64a2                	ld	s1,8(sp)
    80002d8a:	6105                	addi	sp,sp,32
    80002d8c:	8082                	ret
     (scause & 0xff) == 9){
    80002d8e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002d92:	46a5                	li	a3,9
    80002d94:	fed792e3          	bne	a5,a3,80002d78 <devintr+0x12>
    int irq = plic_claim();
    80002d98:	00003097          	auipc	ra,0x3
    80002d9c:	520080e7          	jalr	1312(ra) # 800062b8 <plic_claim>
    80002da0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002da2:	47a9                	li	a5,10
    80002da4:	02f50763          	beq	a0,a5,80002dd2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002da8:	4785                	li	a5,1
    80002daa:	02f50963          	beq	a0,a5,80002ddc <devintr+0x76>
    return 1;
    80002dae:	4505                	li	a0,1
    } else if(irq){
    80002db0:	d8f1                	beqz	s1,80002d84 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002db2:	85a6                	mv	a1,s1
    80002db4:	00005517          	auipc	a0,0x5
    80002db8:	5ec50513          	addi	a0,a0,1516 # 800083a0 <states.0+0x30>
    80002dbc:	ffffd097          	auipc	ra,0xffffd
    80002dc0:	7ce080e7          	jalr	1998(ra) # 8000058a <printf>
      plic_complete(irq);
    80002dc4:	8526                	mv	a0,s1
    80002dc6:	00003097          	auipc	ra,0x3
    80002dca:	516080e7          	jalr	1302(ra) # 800062dc <plic_complete>
    return 1;
    80002dce:	4505                	li	a0,1
    80002dd0:	bf55                	j	80002d84 <devintr+0x1e>
      uartintr();
    80002dd2:	ffffe097          	auipc	ra,0xffffe
    80002dd6:	bee080e7          	jalr	-1042(ra) # 800009c0 <uartintr>
    80002dda:	b7ed                	j	80002dc4 <devintr+0x5e>
      virtio_disk_intr();
    80002ddc:	00004097          	auipc	ra,0x4
    80002de0:	97a080e7          	jalr	-1670(ra) # 80006756 <virtio_disk_intr>
    80002de4:	b7c5                	j	80002dc4 <devintr+0x5e>
    if(cpuid() == 0){
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	10a080e7          	jalr	266(ra) # 80001ef0 <cpuid>
    80002dee:	c901                	beqz	a0,80002dfe <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002df0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002df4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002df6:	14479073          	csrw	sip,a5
    return 2;
    80002dfa:	4509                	li	a0,2
    80002dfc:	b761                	j	80002d84 <devintr+0x1e>
      clockintr();
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	ed2080e7          	jalr	-302(ra) # 80002cd0 <clockintr>
    80002e06:	b7ed                	j	80002df0 <devintr+0x8a>

0000000080002e08 <usertrap>:
{
    80002e08:	1101                	addi	sp,sp,-32
    80002e0a:	ec06                	sd	ra,24(sp)
    80002e0c:	e822                	sd	s0,16(sp)
    80002e0e:	e426                	sd	s1,8(sp)
    80002e10:	e04a                	sd	s2,0(sp)
    80002e12:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e14:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002e18:	1007f793          	andi	a5,a5,256
    80002e1c:	e3ad                	bnez	a5,80002e7e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e1e:	00003797          	auipc	a5,0x3
    80002e22:	39278793          	addi	a5,a5,914 # 800061b0 <kernelvec>
    80002e26:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002e2a:	fffff097          	auipc	ra,0xfffff
    80002e2e:	0f2080e7          	jalr	242(ra) # 80001f1c <myproc>
    80002e32:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002e34:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e36:	14102773          	csrr	a4,sepc
    80002e3a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e3c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002e40:	47a1                	li	a5,8
    80002e42:	04f71c63          	bne	a4,a5,80002e9a <usertrap+0x92>
    if(p->killed)
    80002e46:	591c                	lw	a5,48(a0)
    80002e48:	e3b9                	bnez	a5,80002e8e <usertrap+0x86>
    p->trapframe->epc += 4;
    80002e4a:	6cb8                	ld	a4,88(s1)
    80002e4c:	6f1c                	ld	a5,24(a4)
    80002e4e:	0791                	addi	a5,a5,4
    80002e50:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e56:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e5a:	10079073          	csrw	sstatus,a5
    syscall();
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	2e0080e7          	jalr	736(ra) # 8000313e <syscall>
  if(p->killed)
    80002e66:	589c                	lw	a5,48(s1)
    80002e68:	ebc1                	bnez	a5,80002ef8 <usertrap+0xf0>
  usertrapret();
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	dc8080e7          	jalr	-568(ra) # 80002c32 <usertrapret>
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6902                	ld	s2,0(sp)
    80002e7a:	6105                	addi	sp,sp,32
    80002e7c:	8082                	ret
    panic("usertrap: not from user mode");
    80002e7e:	00005517          	auipc	a0,0x5
    80002e82:	54250513          	addi	a0,a0,1346 # 800083c0 <states.0+0x50>
    80002e86:	ffffd097          	auipc	ra,0xffffd
    80002e8a:	6ba080e7          	jalr	1722(ra) # 80000540 <panic>
      exit(-1);
    80002e8e:	557d                	li	a0,-1
    80002e90:	fffff097          	auipc	ra,0xfffff
    80002e94:	782080e7          	jalr	1922(ra) # 80002612 <exit>
    80002e98:	bf4d                	j	80002e4a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002e9a:	00000097          	auipc	ra,0x0
    80002e9e:	ecc080e7          	jalr	-308(ra) # 80002d66 <devintr>
    80002ea2:	892a                	mv	s2,a0
    80002ea4:	c501                	beqz	a0,80002eac <usertrap+0xa4>
  if(p->killed)
    80002ea6:	589c                	lw	a5,48(s1)
    80002ea8:	c3a1                	beqz	a5,80002ee8 <usertrap+0xe0>
    80002eaa:	a815                	j	80002ede <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002eac:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002eb0:	5c90                	lw	a2,56(s1)
    80002eb2:	00005517          	auipc	a0,0x5
    80002eb6:	52e50513          	addi	a0,a0,1326 # 800083e0 <states.0+0x70>
    80002eba:	ffffd097          	auipc	ra,0xffffd
    80002ebe:	6d0080e7          	jalr	1744(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ec2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ec6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002eca:	00005517          	auipc	a0,0x5
    80002ece:	54650513          	addi	a0,a0,1350 # 80008410 <states.0+0xa0>
    80002ed2:	ffffd097          	auipc	ra,0xffffd
    80002ed6:	6b8080e7          	jalr	1720(ra) # 8000058a <printf>
    p->killed = 1;
    80002eda:	4785                	li	a5,1
    80002edc:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002ede:	557d                	li	a0,-1
    80002ee0:	fffff097          	auipc	ra,0xfffff
    80002ee4:	732080e7          	jalr	1842(ra) # 80002612 <exit>
  if(which_dev == 2)
    80002ee8:	4789                	li	a5,2
    80002eea:	f8f910e3          	bne	s2,a5,80002e6a <usertrap+0x62>
    yield();
    80002eee:	00000097          	auipc	ra,0x0
    80002ef2:	82e080e7          	jalr	-2002(ra) # 8000271c <yield>
    80002ef6:	bf95                	j	80002e6a <usertrap+0x62>
  int which_dev = 0;
    80002ef8:	4901                	li	s2,0
    80002efa:	b7d5                	j	80002ede <usertrap+0xd6>

0000000080002efc <kerneltrap>:
{
    80002efc:	7179                	addi	sp,sp,-48
    80002efe:	f406                	sd	ra,40(sp)
    80002f00:	f022                	sd	s0,32(sp)
    80002f02:	ec26                	sd	s1,24(sp)
    80002f04:	e84a                	sd	s2,16(sp)
    80002f06:	e44e                	sd	s3,8(sp)
    80002f08:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f0a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f0e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f12:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002f16:	1004f793          	andi	a5,s1,256
    80002f1a:	cb85                	beqz	a5,80002f4a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f1c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f20:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002f22:	ef85                	bnez	a5,80002f5a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002f24:	00000097          	auipc	ra,0x0
    80002f28:	e42080e7          	jalr	-446(ra) # 80002d66 <devintr>
    80002f2c:	cd1d                	beqz	a0,80002f6a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f2e:	4789                	li	a5,2
    80002f30:	06f50a63          	beq	a0,a5,80002fa4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f34:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f38:	10049073          	csrw	sstatus,s1
}
    80002f3c:	70a2                	ld	ra,40(sp)
    80002f3e:	7402                	ld	s0,32(sp)
    80002f40:	64e2                	ld	s1,24(sp)
    80002f42:	6942                	ld	s2,16(sp)
    80002f44:	69a2                	ld	s3,8(sp)
    80002f46:	6145                	addi	sp,sp,48
    80002f48:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002f4a:	00005517          	auipc	a0,0x5
    80002f4e:	4e650513          	addi	a0,a0,1254 # 80008430 <states.0+0xc0>
    80002f52:	ffffd097          	auipc	ra,0xffffd
    80002f56:	5ee080e7          	jalr	1518(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    80002f5a:	00005517          	auipc	a0,0x5
    80002f5e:	4fe50513          	addi	a0,a0,1278 # 80008458 <states.0+0xe8>
    80002f62:	ffffd097          	auipc	ra,0xffffd
    80002f66:	5de080e7          	jalr	1502(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    80002f6a:	85ce                	mv	a1,s3
    80002f6c:	00005517          	auipc	a0,0x5
    80002f70:	50c50513          	addi	a0,a0,1292 # 80008478 <states.0+0x108>
    80002f74:	ffffd097          	auipc	ra,0xffffd
    80002f78:	616080e7          	jalr	1558(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f7c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f80:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f84:	00005517          	auipc	a0,0x5
    80002f88:	50450513          	addi	a0,a0,1284 # 80008488 <states.0+0x118>
    80002f8c:	ffffd097          	auipc	ra,0xffffd
    80002f90:	5fe080e7          	jalr	1534(ra) # 8000058a <printf>
    panic("kerneltrap");
    80002f94:	00005517          	auipc	a0,0x5
    80002f98:	50c50513          	addi	a0,a0,1292 # 800084a0 <states.0+0x130>
    80002f9c:	ffffd097          	auipc	ra,0xffffd
    80002fa0:	5a4080e7          	jalr	1444(ra) # 80000540 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002fa4:	fffff097          	auipc	ra,0xfffff
    80002fa8:	f78080e7          	jalr	-136(ra) # 80001f1c <myproc>
    80002fac:	d541                	beqz	a0,80002f34 <kerneltrap+0x38>
    80002fae:	fffff097          	auipc	ra,0xfffff
    80002fb2:	f6e080e7          	jalr	-146(ra) # 80001f1c <myproc>
    80002fb6:	4d18                	lw	a4,24(a0)
    80002fb8:	478d                	li	a5,3
    80002fba:	f6f71de3          	bne	a4,a5,80002f34 <kerneltrap+0x38>
    yield();
    80002fbe:	fffff097          	auipc	ra,0xfffff
    80002fc2:	75e080e7          	jalr	1886(ra) # 8000271c <yield>
    80002fc6:	b7bd                	j	80002f34 <kerneltrap+0x38>

0000000080002fc8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002fc8:	1101                	addi	sp,sp,-32
    80002fca:	ec06                	sd	ra,24(sp)
    80002fcc:	e822                	sd	s0,16(sp)
    80002fce:	e426                	sd	s1,8(sp)
    80002fd0:	1000                	addi	s0,sp,32
    80002fd2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002fd4:	fffff097          	auipc	ra,0xfffff
    80002fd8:	f48080e7          	jalr	-184(ra) # 80001f1c <myproc>
  switch (n) {
    80002fdc:	4795                	li	a5,5
    80002fde:	0497e163          	bltu	a5,s1,80003020 <argraw+0x58>
    80002fe2:	048a                	slli	s1,s1,0x2
    80002fe4:	00005717          	auipc	a4,0x5
    80002fe8:	4f470713          	addi	a4,a4,1268 # 800084d8 <states.0+0x168>
    80002fec:	94ba                	add	s1,s1,a4
    80002fee:	409c                	lw	a5,0(s1)
    80002ff0:	97ba                	add	a5,a5,a4
    80002ff2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ff4:	6d3c                	ld	a5,88(a0)
    80002ff6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002ff8:	60e2                	ld	ra,24(sp)
    80002ffa:	6442                	ld	s0,16(sp)
    80002ffc:	64a2                	ld	s1,8(sp)
    80002ffe:	6105                	addi	sp,sp,32
    80003000:	8082                	ret
    return p->trapframe->a1;
    80003002:	6d3c                	ld	a5,88(a0)
    80003004:	7fa8                	ld	a0,120(a5)
    80003006:	bfcd                	j	80002ff8 <argraw+0x30>
    return p->trapframe->a2;
    80003008:	6d3c                	ld	a5,88(a0)
    8000300a:	63c8                	ld	a0,128(a5)
    8000300c:	b7f5                	j	80002ff8 <argraw+0x30>
    return p->trapframe->a3;
    8000300e:	6d3c                	ld	a5,88(a0)
    80003010:	67c8                	ld	a0,136(a5)
    80003012:	b7dd                	j	80002ff8 <argraw+0x30>
    return p->trapframe->a4;
    80003014:	6d3c                	ld	a5,88(a0)
    80003016:	6bc8                	ld	a0,144(a5)
    80003018:	b7c5                	j	80002ff8 <argraw+0x30>
    return p->trapframe->a5;
    8000301a:	6d3c                	ld	a5,88(a0)
    8000301c:	6fc8                	ld	a0,152(a5)
    8000301e:	bfe9                	j	80002ff8 <argraw+0x30>
  panic("argraw");
    80003020:	00005517          	auipc	a0,0x5
    80003024:	49050513          	addi	a0,a0,1168 # 800084b0 <states.0+0x140>
    80003028:	ffffd097          	auipc	ra,0xffffd
    8000302c:	518080e7          	jalr	1304(ra) # 80000540 <panic>

0000000080003030 <fetchaddr>:
{
    80003030:	1101                	addi	sp,sp,-32
    80003032:	ec06                	sd	ra,24(sp)
    80003034:	e822                	sd	s0,16(sp)
    80003036:	e426                	sd	s1,8(sp)
    80003038:	e04a                	sd	s2,0(sp)
    8000303a:	1000                	addi	s0,sp,32
    8000303c:	84aa                	mv	s1,a0
    8000303e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	edc080e7          	jalr	-292(ra) # 80001f1c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80003048:	653c                	ld	a5,72(a0)
    8000304a:	02f4f863          	bgeu	s1,a5,8000307a <fetchaddr+0x4a>
    8000304e:	00848713          	addi	a4,s1,8
    80003052:	02e7e663          	bltu	a5,a4,8000307e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003056:	46a1                	li	a3,8
    80003058:	8626                	mv	a2,s1
    8000305a:	85ca                	mv	a1,s2
    8000305c:	6928                	ld	a0,80(a0)
    8000305e:	ffffe097          	auipc	ra,0xffffe
    80003062:	6d8080e7          	jalr	1752(ra) # 80001736 <copyin>
    80003066:	00a03533          	snez	a0,a0
    8000306a:	40a00533          	neg	a0,a0
}
    8000306e:	60e2                	ld	ra,24(sp)
    80003070:	6442                	ld	s0,16(sp)
    80003072:	64a2                	ld	s1,8(sp)
    80003074:	6902                	ld	s2,0(sp)
    80003076:	6105                	addi	sp,sp,32
    80003078:	8082                	ret
    return -1;
    8000307a:	557d                	li	a0,-1
    8000307c:	bfcd                	j	8000306e <fetchaddr+0x3e>
    8000307e:	557d                	li	a0,-1
    80003080:	b7fd                	j	8000306e <fetchaddr+0x3e>

0000000080003082 <fetchstr>:
{
    80003082:	7179                	addi	sp,sp,-48
    80003084:	f406                	sd	ra,40(sp)
    80003086:	f022                	sd	s0,32(sp)
    80003088:	ec26                	sd	s1,24(sp)
    8000308a:	e84a                	sd	s2,16(sp)
    8000308c:	e44e                	sd	s3,8(sp)
    8000308e:	1800                	addi	s0,sp,48
    80003090:	892a                	mv	s2,a0
    80003092:	84ae                	mv	s1,a1
    80003094:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003096:	fffff097          	auipc	ra,0xfffff
    8000309a:	e86080e7          	jalr	-378(ra) # 80001f1c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000309e:	86ce                	mv	a3,s3
    800030a0:	864a                	mv	a2,s2
    800030a2:	85a6                	mv	a1,s1
    800030a4:	6928                	ld	a0,80(a0)
    800030a6:	ffffe097          	auipc	ra,0xffffe
    800030aa:	71e080e7          	jalr	1822(ra) # 800017c4 <copyinstr>
  if(err < 0)
    800030ae:	00054763          	bltz	a0,800030bc <fetchstr+0x3a>
  return strlen(buf);
    800030b2:	8526                	mv	a0,s1
    800030b4:	ffffe097          	auipc	ra,0xffffe
    800030b8:	dc8080e7          	jalr	-568(ra) # 80000e7c <strlen>
}
    800030bc:	70a2                	ld	ra,40(sp)
    800030be:	7402                	ld	s0,32(sp)
    800030c0:	64e2                	ld	s1,24(sp)
    800030c2:	6942                	ld	s2,16(sp)
    800030c4:	69a2                	ld	s3,8(sp)
    800030c6:	6145                	addi	sp,sp,48
    800030c8:	8082                	ret

00000000800030ca <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800030ca:	1101                	addi	sp,sp,-32
    800030cc:	ec06                	sd	ra,24(sp)
    800030ce:	e822                	sd	s0,16(sp)
    800030d0:	e426                	sd	s1,8(sp)
    800030d2:	1000                	addi	s0,sp,32
    800030d4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030d6:	00000097          	auipc	ra,0x0
    800030da:	ef2080e7          	jalr	-270(ra) # 80002fc8 <argraw>
    800030de:	c088                	sw	a0,0(s1)
  return 0;
}
    800030e0:	4501                	li	a0,0
    800030e2:	60e2                	ld	ra,24(sp)
    800030e4:	6442                	ld	s0,16(sp)
    800030e6:	64a2                	ld	s1,8(sp)
    800030e8:	6105                	addi	sp,sp,32
    800030ea:	8082                	ret

00000000800030ec <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800030ec:	1101                	addi	sp,sp,-32
    800030ee:	ec06                	sd	ra,24(sp)
    800030f0:	e822                	sd	s0,16(sp)
    800030f2:	e426                	sd	s1,8(sp)
    800030f4:	1000                	addi	s0,sp,32
    800030f6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030f8:	00000097          	auipc	ra,0x0
    800030fc:	ed0080e7          	jalr	-304(ra) # 80002fc8 <argraw>
    80003100:	e088                	sd	a0,0(s1)
  return 0;
}
    80003102:	4501                	li	a0,0
    80003104:	60e2                	ld	ra,24(sp)
    80003106:	6442                	ld	s0,16(sp)
    80003108:	64a2                	ld	s1,8(sp)
    8000310a:	6105                	addi	sp,sp,32
    8000310c:	8082                	ret

000000008000310e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000310e:	1101                	addi	sp,sp,-32
    80003110:	ec06                	sd	ra,24(sp)
    80003112:	e822                	sd	s0,16(sp)
    80003114:	e426                	sd	s1,8(sp)
    80003116:	e04a                	sd	s2,0(sp)
    80003118:	1000                	addi	s0,sp,32
    8000311a:	84ae                	mv	s1,a1
    8000311c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000311e:	00000097          	auipc	ra,0x0
    80003122:	eaa080e7          	jalr	-342(ra) # 80002fc8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003126:	864a                	mv	a2,s2
    80003128:	85a6                	mv	a1,s1
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	f58080e7          	jalr	-168(ra) # 80003082 <fetchstr>
}
    80003132:	60e2                	ld	ra,24(sp)
    80003134:	6442                	ld	s0,16(sp)
    80003136:	64a2                	ld	s1,8(sp)
    80003138:	6902                	ld	s2,0(sp)
    8000313a:	6105                	addi	sp,sp,32
    8000313c:	8082                	ret

000000008000313e <syscall>:

#endif

void
syscall(void)
{
    8000313e:	1101                	addi	sp,sp,-32
    80003140:	ec06                	sd	ra,24(sp)
    80003142:	e822                	sd	s0,16(sp)
    80003144:	e426                	sd	s1,8(sp)
    80003146:	e04a                	sd	s2,0(sp)
    80003148:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000314a:	fffff097          	auipc	ra,0xfffff
    8000314e:	dd2080e7          	jalr	-558(ra) # 80001f1c <myproc>
    80003152:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003154:	05853903          	ld	s2,88(a0)
    80003158:	0a893783          	ld	a5,168(s2)
    8000315c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003160:	37fd                	addiw	a5,a5,-1
    80003162:	4751                	li	a4,20
    80003164:	00f76f63          	bltu	a4,a5,80003182 <syscall+0x44>
    80003168:	00369713          	slli	a4,a3,0x3
    8000316c:	00005797          	auipc	a5,0x5
    80003170:	38478793          	addi	a5,a5,900 # 800084f0 <syscalls>
    80003174:	97ba                	add	a5,a5,a4
    80003176:	639c                	ld	a5,0(a5)
    80003178:	c789                	beqz	a5,80003182 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000317a:	9782                	jalr	a5
    8000317c:	06a93823          	sd	a0,112(s2)
    80003180:	a839                	j	8000319e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003182:	15848613          	addi	a2,s1,344
    80003186:	5c8c                	lw	a1,56(s1)
    80003188:	00005517          	auipc	a0,0x5
    8000318c:	33050513          	addi	a0,a0,816 # 800084b8 <states.0+0x148>
    80003190:	ffffd097          	auipc	ra,0xffffd
    80003194:	3fa080e7          	jalr	1018(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003198:	6cbc                	ld	a5,88(s1)
    8000319a:	577d                	li	a4,-1
    8000319c:	fbb8                	sd	a4,112(a5)
  }
#ifdef SUKJOON
  acquire(&p->lock);
    8000319e:	8526                	mv	a0,s1
    800031a0:	ffffe097          	auipc	ra,0xffffe
    800031a4:	a5c080e7          	jalr	-1444(ra) # 80000bfc <acquire>
  if (is_q2(p)) { }
    800031a8:	8526                	mv	a0,s1
    800031aa:	ffffe097          	auipc	ra,0xffffe
    800031ae:	752080e7          	jalr	1874(ra) # 800018fc <is_q2>
  if (is_q1(p)) { remove(&q1, p); enqueue(&q2, p); }
    800031b2:	8526                	mv	a0,s1
    800031b4:	ffffe097          	auipc	ra,0xffffe
    800031b8:	75e080e7          	jalr	1886(ra) # 80001912 <is_q1>
    800031bc:	e50d                	bnez	a0,800031e6 <syscall+0xa8>
  if (is_q0(p)) { remove(&q0, p); enqueue(&q2, p); }
    800031be:	8526                	mv	a0,s1
    800031c0:	ffffe097          	auipc	ra,0xffffe
    800031c4:	768080e7          	jalr	1896(ra) # 80001928 <is_q0>
    800031c8:	e131                	bnez	a0,8000320c <syscall+0xce>
  p->p_intr = 1;
    800031ca:	4785                	li	a5,1
    800031cc:	18f4a823          	sw	a5,400(s1)
  release(&p->lock);
    800031d0:	8526                	mv	a0,s1
    800031d2:	ffffe097          	auipc	ra,0xffffe
    800031d6:	ade080e7          	jalr	-1314(ra) # 80000cb0 <release>
#endif
}
    800031da:	60e2                	ld	ra,24(sp)
    800031dc:	6442                	ld	s0,16(sp)
    800031de:	64a2                	ld	s1,8(sp)
    800031e0:	6902                	ld	s2,0(sp)
    800031e2:	6105                	addi	sp,sp,32
    800031e4:	8082                	ret
  if (is_q1(p)) { remove(&q1, p); enqueue(&q2, p); }
    800031e6:	85a6                	mv	a1,s1
    800031e8:	0000e517          	auipc	a0,0xe
    800031ec:	78050513          	addi	a0,a0,1920 # 80011968 <q1>
    800031f0:	fffff097          	auipc	ra,0xfffff
    800031f4:	90e080e7          	jalr	-1778(ra) # 80001afe <remove>
    800031f8:	85a6                	mv	a1,s1
    800031fa:	0000e517          	auipc	a0,0xe
    800031fe:	75650513          	addi	a0,a0,1878 # 80011950 <q2>
    80003202:	fffff097          	auipc	ra,0xfffff
    80003206:	876080e7          	jalr	-1930(ra) # 80001a78 <enqueue>
    8000320a:	bf55                	j	800031be <syscall+0x80>
  if (is_q0(p)) { remove(&q0, p); enqueue(&q2, p); }
    8000320c:	85a6                	mv	a1,s1
    8000320e:	0000e517          	auipc	a0,0xe
    80003212:	77250513          	addi	a0,a0,1906 # 80011980 <q0>
    80003216:	fffff097          	auipc	ra,0xfffff
    8000321a:	8e8080e7          	jalr	-1816(ra) # 80001afe <remove>
    8000321e:	85a6                	mv	a1,s1
    80003220:	0000e517          	auipc	a0,0xe
    80003224:	73050513          	addi	a0,a0,1840 # 80011950 <q2>
    80003228:	fffff097          	auipc	ra,0xfffff
    8000322c:	850080e7          	jalr	-1968(ra) # 80001a78 <enqueue>
    80003230:	bf69                	j	800031ca <syscall+0x8c>

0000000080003232 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003232:	1101                	addi	sp,sp,-32
    80003234:	ec06                	sd	ra,24(sp)
    80003236:	e822                	sd	s0,16(sp)
    80003238:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000323a:	fec40593          	addi	a1,s0,-20
    8000323e:	4501                	li	a0,0
    80003240:	00000097          	auipc	ra,0x0
    80003244:	e8a080e7          	jalr	-374(ra) # 800030ca <argint>
    return -1;
    80003248:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000324a:	00054963          	bltz	a0,8000325c <sys_exit+0x2a>
  exit(n);
    8000324e:	fec42503          	lw	a0,-20(s0)
    80003252:	fffff097          	auipc	ra,0xfffff
    80003256:	3c0080e7          	jalr	960(ra) # 80002612 <exit>
  return 0;  // not reached
    8000325a:	4781                	li	a5,0
}
    8000325c:	853e                	mv	a0,a5
    8000325e:	60e2                	ld	ra,24(sp)
    80003260:	6442                	ld	s0,16(sp)
    80003262:	6105                	addi	sp,sp,32
    80003264:	8082                	ret

0000000080003266 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003266:	1141                	addi	sp,sp,-16
    80003268:	e406                	sd	ra,8(sp)
    8000326a:	e022                	sd	s0,0(sp)
    8000326c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000326e:	fffff097          	auipc	ra,0xfffff
    80003272:	cae080e7          	jalr	-850(ra) # 80001f1c <myproc>
}
    80003276:	5d08                	lw	a0,56(a0)
    80003278:	60a2                	ld	ra,8(sp)
    8000327a:	6402                	ld	s0,0(sp)
    8000327c:	0141                	addi	sp,sp,16
    8000327e:	8082                	ret

0000000080003280 <sys_fork>:

uint64
sys_fork(void)
{
    80003280:	1141                	addi	sp,sp,-16
    80003282:	e406                	sd	ra,8(sp)
    80003284:	e022                	sd	s0,0(sp)
    80003286:	0800                	addi	s0,sp,16
  return fork();
    80003288:	fffff097          	auipc	ra,0xfffff
    8000328c:	130080e7          	jalr	304(ra) # 800023b8 <fork>
}
    80003290:	60a2                	ld	ra,8(sp)
    80003292:	6402                	ld	s0,0(sp)
    80003294:	0141                	addi	sp,sp,16
    80003296:	8082                	ret

0000000080003298 <sys_wait>:

uint64
sys_wait(void)
{
    80003298:	1101                	addi	sp,sp,-32
    8000329a:	ec06                	sd	ra,24(sp)
    8000329c:	e822                	sd	s0,16(sp)
    8000329e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800032a0:	fe840593          	addi	a1,s0,-24
    800032a4:	4501                	li	a0,0
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	e46080e7          	jalr	-442(ra) # 800030ec <argaddr>
    800032ae:	87aa                	mv	a5,a0
    return -1;
    800032b0:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800032b2:	0007c863          	bltz	a5,800032c2 <sys_wait+0x2a>
  return wait(p);
    800032b6:	fe843503          	ld	a0,-24(s0)
    800032ba:	fffff097          	auipc	ra,0xfffff
    800032be:	560080e7          	jalr	1376(ra) # 8000281a <wait>
}
    800032c2:	60e2                	ld	ra,24(sp)
    800032c4:	6442                	ld	s0,16(sp)
    800032c6:	6105                	addi	sp,sp,32
    800032c8:	8082                	ret

00000000800032ca <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800032ca:	7179                	addi	sp,sp,-48
    800032cc:	f406                	sd	ra,40(sp)
    800032ce:	f022                	sd	s0,32(sp)
    800032d0:	ec26                	sd	s1,24(sp)
    800032d2:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800032d4:	fdc40593          	addi	a1,s0,-36
    800032d8:	4501                	li	a0,0
    800032da:	00000097          	auipc	ra,0x0
    800032de:	df0080e7          	jalr	-528(ra) # 800030ca <argint>
    return -1;
    800032e2:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    800032e4:	00054f63          	bltz	a0,80003302 <sys_sbrk+0x38>
  addr = myproc()->sz;
    800032e8:	fffff097          	auipc	ra,0xfffff
    800032ec:	c34080e7          	jalr	-972(ra) # 80001f1c <myproc>
    800032f0:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800032f2:	fdc42503          	lw	a0,-36(s0)
    800032f6:	fffff097          	auipc	ra,0xfffff
    800032fa:	04e080e7          	jalr	78(ra) # 80002344 <growproc>
    800032fe:	00054863          	bltz	a0,8000330e <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80003302:	8526                	mv	a0,s1
    80003304:	70a2                	ld	ra,40(sp)
    80003306:	7402                	ld	s0,32(sp)
    80003308:	64e2                	ld	s1,24(sp)
    8000330a:	6145                	addi	sp,sp,48
    8000330c:	8082                	ret
    return -1;
    8000330e:	54fd                	li	s1,-1
    80003310:	bfcd                	j	80003302 <sys_sbrk+0x38>

0000000080003312 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003312:	7139                	addi	sp,sp,-64
    80003314:	fc06                	sd	ra,56(sp)
    80003316:	f822                	sd	s0,48(sp)
    80003318:	f426                	sd	s1,40(sp)
    8000331a:	f04a                	sd	s2,32(sp)
    8000331c:	ec4e                	sd	s3,24(sp)
    8000331e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003320:	fcc40593          	addi	a1,s0,-52
    80003324:	4501                	li	a0,0
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	da4080e7          	jalr	-604(ra) # 800030ca <argint>
    return -1;
    8000332e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003330:	06054563          	bltz	a0,8000339a <sys_sleep+0x88>
  acquire(&tickslock);
    80003334:	00015517          	auipc	a0,0x15
    80003338:	07c50513          	addi	a0,a0,124 # 800183b0 <tickslock>
    8000333c:	ffffe097          	auipc	ra,0xffffe
    80003340:	8c0080e7          	jalr	-1856(ra) # 80000bfc <acquire>
  ticks0 = ticks;
    80003344:	00006917          	auipc	s2,0x6
    80003348:	cdc92903          	lw	s2,-804(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    8000334c:	fcc42783          	lw	a5,-52(s0)
    80003350:	cf85                	beqz	a5,80003388 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003352:	00015997          	auipc	s3,0x15
    80003356:	05e98993          	addi	s3,s3,94 # 800183b0 <tickslock>
    8000335a:	00006497          	auipc	s1,0x6
    8000335e:	cc648493          	addi	s1,s1,-826 # 80009020 <ticks>
    if(myproc()->killed){
    80003362:	fffff097          	auipc	ra,0xfffff
    80003366:	bba080e7          	jalr	-1094(ra) # 80001f1c <myproc>
    8000336a:	591c                	lw	a5,48(a0)
    8000336c:	ef9d                	bnez	a5,800033aa <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000336e:	85ce                	mv	a1,s3
    80003370:	8526                	mv	a0,s1
    80003372:	fffff097          	auipc	ra,0xfffff
    80003376:	42a080e7          	jalr	1066(ra) # 8000279c <sleep>
  while(ticks - ticks0 < n){
    8000337a:	409c                	lw	a5,0(s1)
    8000337c:	412787bb          	subw	a5,a5,s2
    80003380:	fcc42703          	lw	a4,-52(s0)
    80003384:	fce7efe3          	bltu	a5,a4,80003362 <sys_sleep+0x50>
  }
  release(&tickslock);
    80003388:	00015517          	auipc	a0,0x15
    8000338c:	02850513          	addi	a0,a0,40 # 800183b0 <tickslock>
    80003390:	ffffe097          	auipc	ra,0xffffe
    80003394:	920080e7          	jalr	-1760(ra) # 80000cb0 <release>
  return 0;
    80003398:	4781                	li	a5,0
}
    8000339a:	853e                	mv	a0,a5
    8000339c:	70e2                	ld	ra,56(sp)
    8000339e:	7442                	ld	s0,48(sp)
    800033a0:	74a2                	ld	s1,40(sp)
    800033a2:	7902                	ld	s2,32(sp)
    800033a4:	69e2                	ld	s3,24(sp)
    800033a6:	6121                	addi	sp,sp,64
    800033a8:	8082                	ret
      release(&tickslock);
    800033aa:	00015517          	auipc	a0,0x15
    800033ae:	00650513          	addi	a0,a0,6 # 800183b0 <tickslock>
    800033b2:	ffffe097          	auipc	ra,0xffffe
    800033b6:	8fe080e7          	jalr	-1794(ra) # 80000cb0 <release>
      return -1;
    800033ba:	57fd                	li	a5,-1
    800033bc:	bff9                	j	8000339a <sys_sleep+0x88>

00000000800033be <sys_kill>:

uint64
sys_kill(void)
{
    800033be:	1101                	addi	sp,sp,-32
    800033c0:	ec06                	sd	ra,24(sp)
    800033c2:	e822                	sd	s0,16(sp)
    800033c4:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800033c6:	fec40593          	addi	a1,s0,-20
    800033ca:	4501                	li	a0,0
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	cfe080e7          	jalr	-770(ra) # 800030ca <argint>
    800033d4:	87aa                	mv	a5,a0
    return -1;
    800033d6:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800033d8:	0007c863          	bltz	a5,800033e8 <sys_kill+0x2a>
  return kill(pid);
    800033dc:	fec42503          	lw	a0,-20(s0)
    800033e0:	fffff097          	auipc	ra,0xfffff
    800033e4:	5dc080e7          	jalr	1500(ra) # 800029bc <kill>
}
    800033e8:	60e2                	ld	ra,24(sp)
    800033ea:	6442                	ld	s0,16(sp)
    800033ec:	6105                	addi	sp,sp,32
    800033ee:	8082                	ret

00000000800033f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800033f0:	1101                	addi	sp,sp,-32
    800033f2:	ec06                	sd	ra,24(sp)
    800033f4:	e822                	sd	s0,16(sp)
    800033f6:	e426                	sd	s1,8(sp)
    800033f8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800033fa:	00015517          	auipc	a0,0x15
    800033fe:	fb650513          	addi	a0,a0,-74 # 800183b0 <tickslock>
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	7fa080e7          	jalr	2042(ra) # 80000bfc <acquire>
  xticks = ticks;
    8000340a:	00006497          	auipc	s1,0x6
    8000340e:	c164a483          	lw	s1,-1002(s1) # 80009020 <ticks>
  release(&tickslock);
    80003412:	00015517          	auipc	a0,0x15
    80003416:	f9e50513          	addi	a0,a0,-98 # 800183b0 <tickslock>
    8000341a:	ffffe097          	auipc	ra,0xffffe
    8000341e:	896080e7          	jalr	-1898(ra) # 80000cb0 <release>
  return xticks;
}
    80003422:	02049513          	slli	a0,s1,0x20
    80003426:	9101                	srli	a0,a0,0x20
    80003428:	60e2                	ld	ra,24(sp)
    8000342a:	6442                	ld	s0,16(sp)
    8000342c:	64a2                	ld	s1,8(sp)
    8000342e:	6105                	addi	sp,sp,32
    80003430:	8082                	ret

0000000080003432 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003432:	7179                	addi	sp,sp,-48
    80003434:	f406                	sd	ra,40(sp)
    80003436:	f022                	sd	s0,32(sp)
    80003438:	ec26                	sd	s1,24(sp)
    8000343a:	e84a                	sd	s2,16(sp)
    8000343c:	e44e                	sd	s3,8(sp)
    8000343e:	e052                	sd	s4,0(sp)
    80003440:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003442:	00005597          	auipc	a1,0x5
    80003446:	15e58593          	addi	a1,a1,350 # 800085a0 <syscalls+0xb0>
    8000344a:	00015517          	auipc	a0,0x15
    8000344e:	f7e50513          	addi	a0,a0,-130 # 800183c8 <bcache>
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	71a080e7          	jalr	1818(ra) # 80000b6c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000345a:	0001d797          	auipc	a5,0x1d
    8000345e:	f6e78793          	addi	a5,a5,-146 # 800203c8 <bcache+0x8000>
    80003462:	0001d717          	auipc	a4,0x1d
    80003466:	1ce70713          	addi	a4,a4,462 # 80020630 <bcache+0x8268>
    8000346a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000346e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003472:	00015497          	auipc	s1,0x15
    80003476:	f6e48493          	addi	s1,s1,-146 # 800183e0 <bcache+0x18>
    b->next = bcache.head.next;
    8000347a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000347c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000347e:	00005a17          	auipc	s4,0x5
    80003482:	12aa0a13          	addi	s4,s4,298 # 800085a8 <syscalls+0xb8>
    b->next = bcache.head.next;
    80003486:	2b893783          	ld	a5,696(s2)
    8000348a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000348c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003490:	85d2                	mv	a1,s4
    80003492:	01048513          	addi	a0,s1,16
    80003496:	00001097          	auipc	ra,0x1
    8000349a:	4b2080e7          	jalr	1202(ra) # 80004948 <initsleeplock>
    bcache.head.next->prev = b;
    8000349e:	2b893783          	ld	a5,696(s2)
    800034a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800034a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800034a8:	45848493          	addi	s1,s1,1112
    800034ac:	fd349de3          	bne	s1,s3,80003486 <binit+0x54>
  }
}
    800034b0:	70a2                	ld	ra,40(sp)
    800034b2:	7402                	ld	s0,32(sp)
    800034b4:	64e2                	ld	s1,24(sp)
    800034b6:	6942                	ld	s2,16(sp)
    800034b8:	69a2                	ld	s3,8(sp)
    800034ba:	6a02                	ld	s4,0(sp)
    800034bc:	6145                	addi	sp,sp,48
    800034be:	8082                	ret

00000000800034c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800034c0:	7179                	addi	sp,sp,-48
    800034c2:	f406                	sd	ra,40(sp)
    800034c4:	f022                	sd	s0,32(sp)
    800034c6:	ec26                	sd	s1,24(sp)
    800034c8:	e84a                	sd	s2,16(sp)
    800034ca:	e44e                	sd	s3,8(sp)
    800034cc:	1800                	addi	s0,sp,48
    800034ce:	892a                	mv	s2,a0
    800034d0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800034d2:	00015517          	auipc	a0,0x15
    800034d6:	ef650513          	addi	a0,a0,-266 # 800183c8 <bcache>
    800034da:	ffffd097          	auipc	ra,0xffffd
    800034de:	722080e7          	jalr	1826(ra) # 80000bfc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800034e2:	0001d497          	auipc	s1,0x1d
    800034e6:	19e4b483          	ld	s1,414(s1) # 80020680 <bcache+0x82b8>
    800034ea:	0001d797          	auipc	a5,0x1d
    800034ee:	14678793          	addi	a5,a5,326 # 80020630 <bcache+0x8268>
    800034f2:	02f48f63          	beq	s1,a5,80003530 <bread+0x70>
    800034f6:	873e                	mv	a4,a5
    800034f8:	a021                	j	80003500 <bread+0x40>
    800034fa:	68a4                	ld	s1,80(s1)
    800034fc:	02e48a63          	beq	s1,a4,80003530 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003500:	449c                	lw	a5,8(s1)
    80003502:	ff279ce3          	bne	a5,s2,800034fa <bread+0x3a>
    80003506:	44dc                	lw	a5,12(s1)
    80003508:	ff3799e3          	bne	a5,s3,800034fa <bread+0x3a>
      b->refcnt++;
    8000350c:	40bc                	lw	a5,64(s1)
    8000350e:	2785                	addiw	a5,a5,1
    80003510:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003512:	00015517          	auipc	a0,0x15
    80003516:	eb650513          	addi	a0,a0,-330 # 800183c8 <bcache>
    8000351a:	ffffd097          	auipc	ra,0xffffd
    8000351e:	796080e7          	jalr	1942(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    80003522:	01048513          	addi	a0,s1,16
    80003526:	00001097          	auipc	ra,0x1
    8000352a:	45c080e7          	jalr	1116(ra) # 80004982 <acquiresleep>
      return b;
    8000352e:	a8b9                	j	8000358c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003530:	0001d497          	auipc	s1,0x1d
    80003534:	1484b483          	ld	s1,328(s1) # 80020678 <bcache+0x82b0>
    80003538:	0001d797          	auipc	a5,0x1d
    8000353c:	0f878793          	addi	a5,a5,248 # 80020630 <bcache+0x8268>
    80003540:	00f48863          	beq	s1,a5,80003550 <bread+0x90>
    80003544:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003546:	40bc                	lw	a5,64(s1)
    80003548:	cf81                	beqz	a5,80003560 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000354a:	64a4                	ld	s1,72(s1)
    8000354c:	fee49de3          	bne	s1,a4,80003546 <bread+0x86>
  panic("bget: no buffers");
    80003550:	00005517          	auipc	a0,0x5
    80003554:	06050513          	addi	a0,a0,96 # 800085b0 <syscalls+0xc0>
    80003558:	ffffd097          	auipc	ra,0xffffd
    8000355c:	fe8080e7          	jalr	-24(ra) # 80000540 <panic>
      b->dev = dev;
    80003560:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003564:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003568:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000356c:	4785                	li	a5,1
    8000356e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003570:	00015517          	auipc	a0,0x15
    80003574:	e5850513          	addi	a0,a0,-424 # 800183c8 <bcache>
    80003578:	ffffd097          	auipc	ra,0xffffd
    8000357c:	738080e7          	jalr	1848(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    80003580:	01048513          	addi	a0,s1,16
    80003584:	00001097          	auipc	ra,0x1
    80003588:	3fe080e7          	jalr	1022(ra) # 80004982 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000358c:	409c                	lw	a5,0(s1)
    8000358e:	cb89                	beqz	a5,800035a0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003590:	8526                	mv	a0,s1
    80003592:	70a2                	ld	ra,40(sp)
    80003594:	7402                	ld	s0,32(sp)
    80003596:	64e2                	ld	s1,24(sp)
    80003598:	6942                	ld	s2,16(sp)
    8000359a:	69a2                	ld	s3,8(sp)
    8000359c:	6145                	addi	sp,sp,48
    8000359e:	8082                	ret
    virtio_disk_rw(b, 0);
    800035a0:	4581                	li	a1,0
    800035a2:	8526                	mv	a0,s1
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	f28080e7          	jalr	-216(ra) # 800064cc <virtio_disk_rw>
    b->valid = 1;
    800035ac:	4785                	li	a5,1
    800035ae:	c09c                	sw	a5,0(s1)
  return b;
    800035b0:	b7c5                	j	80003590 <bread+0xd0>

00000000800035b2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800035b2:	1101                	addi	sp,sp,-32
    800035b4:	ec06                	sd	ra,24(sp)
    800035b6:	e822                	sd	s0,16(sp)
    800035b8:	e426                	sd	s1,8(sp)
    800035ba:	1000                	addi	s0,sp,32
    800035bc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035be:	0541                	addi	a0,a0,16
    800035c0:	00001097          	auipc	ra,0x1
    800035c4:	45c080e7          	jalr	1116(ra) # 80004a1c <holdingsleep>
    800035c8:	cd01                	beqz	a0,800035e0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800035ca:	4585                	li	a1,1
    800035cc:	8526                	mv	a0,s1
    800035ce:	00003097          	auipc	ra,0x3
    800035d2:	efe080e7          	jalr	-258(ra) # 800064cc <virtio_disk_rw>
}
    800035d6:	60e2                	ld	ra,24(sp)
    800035d8:	6442                	ld	s0,16(sp)
    800035da:	64a2                	ld	s1,8(sp)
    800035dc:	6105                	addi	sp,sp,32
    800035de:	8082                	ret
    panic("bwrite");
    800035e0:	00005517          	auipc	a0,0x5
    800035e4:	fe850513          	addi	a0,a0,-24 # 800085c8 <syscalls+0xd8>
    800035e8:	ffffd097          	auipc	ra,0xffffd
    800035ec:	f58080e7          	jalr	-168(ra) # 80000540 <panic>

00000000800035f0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800035f0:	1101                	addi	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	e426                	sd	s1,8(sp)
    800035f8:	e04a                	sd	s2,0(sp)
    800035fa:	1000                	addi	s0,sp,32
    800035fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035fe:	01050913          	addi	s2,a0,16
    80003602:	854a                	mv	a0,s2
    80003604:	00001097          	auipc	ra,0x1
    80003608:	418080e7          	jalr	1048(ra) # 80004a1c <holdingsleep>
    8000360c:	c92d                	beqz	a0,8000367e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000360e:	854a                	mv	a0,s2
    80003610:	00001097          	auipc	ra,0x1
    80003614:	3c8080e7          	jalr	968(ra) # 800049d8 <releasesleep>

  acquire(&bcache.lock);
    80003618:	00015517          	auipc	a0,0x15
    8000361c:	db050513          	addi	a0,a0,-592 # 800183c8 <bcache>
    80003620:	ffffd097          	auipc	ra,0xffffd
    80003624:	5dc080e7          	jalr	1500(ra) # 80000bfc <acquire>
  b->refcnt--;
    80003628:	40bc                	lw	a5,64(s1)
    8000362a:	37fd                	addiw	a5,a5,-1
    8000362c:	0007871b          	sext.w	a4,a5
    80003630:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003632:	eb05                	bnez	a4,80003662 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003634:	68bc                	ld	a5,80(s1)
    80003636:	64b8                	ld	a4,72(s1)
    80003638:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000363a:	64bc                	ld	a5,72(s1)
    8000363c:	68b8                	ld	a4,80(s1)
    8000363e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003640:	0001d797          	auipc	a5,0x1d
    80003644:	d8878793          	addi	a5,a5,-632 # 800203c8 <bcache+0x8000>
    80003648:	2b87b703          	ld	a4,696(a5)
    8000364c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000364e:	0001d717          	auipc	a4,0x1d
    80003652:	fe270713          	addi	a4,a4,-30 # 80020630 <bcache+0x8268>
    80003656:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003658:	2b87b703          	ld	a4,696(a5)
    8000365c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000365e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003662:	00015517          	auipc	a0,0x15
    80003666:	d6650513          	addi	a0,a0,-666 # 800183c8 <bcache>
    8000366a:	ffffd097          	auipc	ra,0xffffd
    8000366e:	646080e7          	jalr	1606(ra) # 80000cb0 <release>
}
    80003672:	60e2                	ld	ra,24(sp)
    80003674:	6442                	ld	s0,16(sp)
    80003676:	64a2                	ld	s1,8(sp)
    80003678:	6902                	ld	s2,0(sp)
    8000367a:	6105                	addi	sp,sp,32
    8000367c:	8082                	ret
    panic("brelse");
    8000367e:	00005517          	auipc	a0,0x5
    80003682:	f5250513          	addi	a0,a0,-174 # 800085d0 <syscalls+0xe0>
    80003686:	ffffd097          	auipc	ra,0xffffd
    8000368a:	eba080e7          	jalr	-326(ra) # 80000540 <panic>

000000008000368e <bpin>:

void
bpin(struct buf *b) {
    8000368e:	1101                	addi	sp,sp,-32
    80003690:	ec06                	sd	ra,24(sp)
    80003692:	e822                	sd	s0,16(sp)
    80003694:	e426                	sd	s1,8(sp)
    80003696:	1000                	addi	s0,sp,32
    80003698:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000369a:	00015517          	auipc	a0,0x15
    8000369e:	d2e50513          	addi	a0,a0,-722 # 800183c8 <bcache>
    800036a2:	ffffd097          	auipc	ra,0xffffd
    800036a6:	55a080e7          	jalr	1370(ra) # 80000bfc <acquire>
  b->refcnt++;
    800036aa:	40bc                	lw	a5,64(s1)
    800036ac:	2785                	addiw	a5,a5,1
    800036ae:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036b0:	00015517          	auipc	a0,0x15
    800036b4:	d1850513          	addi	a0,a0,-744 # 800183c8 <bcache>
    800036b8:	ffffd097          	auipc	ra,0xffffd
    800036bc:	5f8080e7          	jalr	1528(ra) # 80000cb0 <release>
}
    800036c0:	60e2                	ld	ra,24(sp)
    800036c2:	6442                	ld	s0,16(sp)
    800036c4:	64a2                	ld	s1,8(sp)
    800036c6:	6105                	addi	sp,sp,32
    800036c8:	8082                	ret

00000000800036ca <bunpin>:

void
bunpin(struct buf *b) {
    800036ca:	1101                	addi	sp,sp,-32
    800036cc:	ec06                	sd	ra,24(sp)
    800036ce:	e822                	sd	s0,16(sp)
    800036d0:	e426                	sd	s1,8(sp)
    800036d2:	1000                	addi	s0,sp,32
    800036d4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800036d6:	00015517          	auipc	a0,0x15
    800036da:	cf250513          	addi	a0,a0,-782 # 800183c8 <bcache>
    800036de:	ffffd097          	auipc	ra,0xffffd
    800036e2:	51e080e7          	jalr	1310(ra) # 80000bfc <acquire>
  b->refcnt--;
    800036e6:	40bc                	lw	a5,64(s1)
    800036e8:	37fd                	addiw	a5,a5,-1
    800036ea:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036ec:	00015517          	auipc	a0,0x15
    800036f0:	cdc50513          	addi	a0,a0,-804 # 800183c8 <bcache>
    800036f4:	ffffd097          	auipc	ra,0xffffd
    800036f8:	5bc080e7          	jalr	1468(ra) # 80000cb0 <release>
}
    800036fc:	60e2                	ld	ra,24(sp)
    800036fe:	6442                	ld	s0,16(sp)
    80003700:	64a2                	ld	s1,8(sp)
    80003702:	6105                	addi	sp,sp,32
    80003704:	8082                	ret

0000000080003706 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003706:	1101                	addi	sp,sp,-32
    80003708:	ec06                	sd	ra,24(sp)
    8000370a:	e822                	sd	s0,16(sp)
    8000370c:	e426                	sd	s1,8(sp)
    8000370e:	e04a                	sd	s2,0(sp)
    80003710:	1000                	addi	s0,sp,32
    80003712:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003714:	00d5d59b          	srliw	a1,a1,0xd
    80003718:	0001d797          	auipc	a5,0x1d
    8000371c:	38c7a783          	lw	a5,908(a5) # 80020aa4 <sb+0x1c>
    80003720:	9dbd                	addw	a1,a1,a5
    80003722:	00000097          	auipc	ra,0x0
    80003726:	d9e080e7          	jalr	-610(ra) # 800034c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000372a:	0074f713          	andi	a4,s1,7
    8000372e:	4785                	li	a5,1
    80003730:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003734:	14ce                	slli	s1,s1,0x33
    80003736:	90d9                	srli	s1,s1,0x36
    80003738:	00950733          	add	a4,a0,s1
    8000373c:	05874703          	lbu	a4,88(a4)
    80003740:	00e7f6b3          	and	a3,a5,a4
    80003744:	c69d                	beqz	a3,80003772 <bfree+0x6c>
    80003746:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003748:	94aa                	add	s1,s1,a0
    8000374a:	fff7c793          	not	a5,a5
    8000374e:	8ff9                	and	a5,a5,a4
    80003750:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003754:	00001097          	auipc	ra,0x1
    80003758:	106080e7          	jalr	262(ra) # 8000485a <log_write>
  brelse(bp);
    8000375c:	854a                	mv	a0,s2
    8000375e:	00000097          	auipc	ra,0x0
    80003762:	e92080e7          	jalr	-366(ra) # 800035f0 <brelse>
}
    80003766:	60e2                	ld	ra,24(sp)
    80003768:	6442                	ld	s0,16(sp)
    8000376a:	64a2                	ld	s1,8(sp)
    8000376c:	6902                	ld	s2,0(sp)
    8000376e:	6105                	addi	sp,sp,32
    80003770:	8082                	ret
    panic("freeing free block");
    80003772:	00005517          	auipc	a0,0x5
    80003776:	e6650513          	addi	a0,a0,-410 # 800085d8 <syscalls+0xe8>
    8000377a:	ffffd097          	auipc	ra,0xffffd
    8000377e:	dc6080e7          	jalr	-570(ra) # 80000540 <panic>

0000000080003782 <balloc>:
{
    80003782:	711d                	addi	sp,sp,-96
    80003784:	ec86                	sd	ra,88(sp)
    80003786:	e8a2                	sd	s0,80(sp)
    80003788:	e4a6                	sd	s1,72(sp)
    8000378a:	e0ca                	sd	s2,64(sp)
    8000378c:	fc4e                	sd	s3,56(sp)
    8000378e:	f852                	sd	s4,48(sp)
    80003790:	f456                	sd	s5,40(sp)
    80003792:	f05a                	sd	s6,32(sp)
    80003794:	ec5e                	sd	s7,24(sp)
    80003796:	e862                	sd	s8,16(sp)
    80003798:	e466                	sd	s9,8(sp)
    8000379a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000379c:	0001d797          	auipc	a5,0x1d
    800037a0:	2f07a783          	lw	a5,752(a5) # 80020a8c <sb+0x4>
    800037a4:	cbd1                	beqz	a5,80003838 <balloc+0xb6>
    800037a6:	8baa                	mv	s7,a0
    800037a8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800037aa:	0001db17          	auipc	s6,0x1d
    800037ae:	2deb0b13          	addi	s6,s6,734 # 80020a88 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037b2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800037b4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037b6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800037b8:	6c89                	lui	s9,0x2
    800037ba:	a831                	j	800037d6 <balloc+0x54>
    brelse(bp);
    800037bc:	854a                	mv	a0,s2
    800037be:	00000097          	auipc	ra,0x0
    800037c2:	e32080e7          	jalr	-462(ra) # 800035f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800037c6:	015c87bb          	addw	a5,s9,s5
    800037ca:	00078a9b          	sext.w	s5,a5
    800037ce:	004b2703          	lw	a4,4(s6)
    800037d2:	06eaf363          	bgeu	s5,a4,80003838 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800037d6:	41fad79b          	sraiw	a5,s5,0x1f
    800037da:	0137d79b          	srliw	a5,a5,0x13
    800037de:	015787bb          	addw	a5,a5,s5
    800037e2:	40d7d79b          	sraiw	a5,a5,0xd
    800037e6:	01cb2583          	lw	a1,28(s6)
    800037ea:	9dbd                	addw	a1,a1,a5
    800037ec:	855e                	mv	a0,s7
    800037ee:	00000097          	auipc	ra,0x0
    800037f2:	cd2080e7          	jalr	-814(ra) # 800034c0 <bread>
    800037f6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037f8:	004b2503          	lw	a0,4(s6)
    800037fc:	000a849b          	sext.w	s1,s5
    80003800:	8662                	mv	a2,s8
    80003802:	faa4fde3          	bgeu	s1,a0,800037bc <balloc+0x3a>
      m = 1 << (bi % 8);
    80003806:	41f6579b          	sraiw	a5,a2,0x1f
    8000380a:	01d7d69b          	srliw	a3,a5,0x1d
    8000380e:	00c6873b          	addw	a4,a3,a2
    80003812:	00777793          	andi	a5,a4,7
    80003816:	9f95                	subw	a5,a5,a3
    80003818:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000381c:	4037571b          	sraiw	a4,a4,0x3
    80003820:	00e906b3          	add	a3,s2,a4
    80003824:	0586c683          	lbu	a3,88(a3)
    80003828:	00d7f5b3          	and	a1,a5,a3
    8000382c:	cd91                	beqz	a1,80003848 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000382e:	2605                	addiw	a2,a2,1
    80003830:	2485                	addiw	s1,s1,1
    80003832:	fd4618e3          	bne	a2,s4,80003802 <balloc+0x80>
    80003836:	b759                	j	800037bc <balloc+0x3a>
  panic("balloc: out of blocks");
    80003838:	00005517          	auipc	a0,0x5
    8000383c:	db850513          	addi	a0,a0,-584 # 800085f0 <syscalls+0x100>
    80003840:	ffffd097          	auipc	ra,0xffffd
    80003844:	d00080e7          	jalr	-768(ra) # 80000540 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003848:	974a                	add	a4,a4,s2
    8000384a:	8fd5                	or	a5,a5,a3
    8000384c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003850:	854a                	mv	a0,s2
    80003852:	00001097          	auipc	ra,0x1
    80003856:	008080e7          	jalr	8(ra) # 8000485a <log_write>
        brelse(bp);
    8000385a:	854a                	mv	a0,s2
    8000385c:	00000097          	auipc	ra,0x0
    80003860:	d94080e7          	jalr	-620(ra) # 800035f0 <brelse>
  bp = bread(dev, bno);
    80003864:	85a6                	mv	a1,s1
    80003866:	855e                	mv	a0,s7
    80003868:	00000097          	auipc	ra,0x0
    8000386c:	c58080e7          	jalr	-936(ra) # 800034c0 <bread>
    80003870:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003872:	40000613          	li	a2,1024
    80003876:	4581                	li	a1,0
    80003878:	05850513          	addi	a0,a0,88
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	47c080e7          	jalr	1148(ra) # 80000cf8 <memset>
  log_write(bp);
    80003884:	854a                	mv	a0,s2
    80003886:	00001097          	auipc	ra,0x1
    8000388a:	fd4080e7          	jalr	-44(ra) # 8000485a <log_write>
  brelse(bp);
    8000388e:	854a                	mv	a0,s2
    80003890:	00000097          	auipc	ra,0x0
    80003894:	d60080e7          	jalr	-672(ra) # 800035f0 <brelse>
}
    80003898:	8526                	mv	a0,s1
    8000389a:	60e6                	ld	ra,88(sp)
    8000389c:	6446                	ld	s0,80(sp)
    8000389e:	64a6                	ld	s1,72(sp)
    800038a0:	6906                	ld	s2,64(sp)
    800038a2:	79e2                	ld	s3,56(sp)
    800038a4:	7a42                	ld	s4,48(sp)
    800038a6:	7aa2                	ld	s5,40(sp)
    800038a8:	7b02                	ld	s6,32(sp)
    800038aa:	6be2                	ld	s7,24(sp)
    800038ac:	6c42                	ld	s8,16(sp)
    800038ae:	6ca2                	ld	s9,8(sp)
    800038b0:	6125                	addi	sp,sp,96
    800038b2:	8082                	ret

00000000800038b4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800038b4:	7179                	addi	sp,sp,-48
    800038b6:	f406                	sd	ra,40(sp)
    800038b8:	f022                	sd	s0,32(sp)
    800038ba:	ec26                	sd	s1,24(sp)
    800038bc:	e84a                	sd	s2,16(sp)
    800038be:	e44e                	sd	s3,8(sp)
    800038c0:	e052                	sd	s4,0(sp)
    800038c2:	1800                	addi	s0,sp,48
    800038c4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800038c6:	47ad                	li	a5,11
    800038c8:	04b7fe63          	bgeu	a5,a1,80003924 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800038cc:	ff45849b          	addiw	s1,a1,-12
    800038d0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800038d4:	0ff00793          	li	a5,255
    800038d8:	0ae7e463          	bltu	a5,a4,80003980 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800038dc:	08052583          	lw	a1,128(a0)
    800038e0:	c5b5                	beqz	a1,8000394c <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800038e2:	00092503          	lw	a0,0(s2)
    800038e6:	00000097          	auipc	ra,0x0
    800038ea:	bda080e7          	jalr	-1062(ra) # 800034c0 <bread>
    800038ee:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800038f0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800038f4:	02049713          	slli	a4,s1,0x20
    800038f8:	01e75593          	srli	a1,a4,0x1e
    800038fc:	00b784b3          	add	s1,a5,a1
    80003900:	0004a983          	lw	s3,0(s1)
    80003904:	04098e63          	beqz	s3,80003960 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003908:	8552                	mv	a0,s4
    8000390a:	00000097          	auipc	ra,0x0
    8000390e:	ce6080e7          	jalr	-794(ra) # 800035f0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003912:	854e                	mv	a0,s3
    80003914:	70a2                	ld	ra,40(sp)
    80003916:	7402                	ld	s0,32(sp)
    80003918:	64e2                	ld	s1,24(sp)
    8000391a:	6942                	ld	s2,16(sp)
    8000391c:	69a2                	ld	s3,8(sp)
    8000391e:	6a02                	ld	s4,0(sp)
    80003920:	6145                	addi	sp,sp,48
    80003922:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003924:	02059793          	slli	a5,a1,0x20
    80003928:	01e7d593          	srli	a1,a5,0x1e
    8000392c:	00b504b3          	add	s1,a0,a1
    80003930:	0504a983          	lw	s3,80(s1)
    80003934:	fc099fe3          	bnez	s3,80003912 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003938:	4108                	lw	a0,0(a0)
    8000393a:	00000097          	auipc	ra,0x0
    8000393e:	e48080e7          	jalr	-440(ra) # 80003782 <balloc>
    80003942:	0005099b          	sext.w	s3,a0
    80003946:	0534a823          	sw	s3,80(s1)
    8000394a:	b7e1                	j	80003912 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000394c:	4108                	lw	a0,0(a0)
    8000394e:	00000097          	auipc	ra,0x0
    80003952:	e34080e7          	jalr	-460(ra) # 80003782 <balloc>
    80003956:	0005059b          	sext.w	a1,a0
    8000395a:	08b92023          	sw	a1,128(s2)
    8000395e:	b751                	j	800038e2 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003960:	00092503          	lw	a0,0(s2)
    80003964:	00000097          	auipc	ra,0x0
    80003968:	e1e080e7          	jalr	-482(ra) # 80003782 <balloc>
    8000396c:	0005099b          	sext.w	s3,a0
    80003970:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003974:	8552                	mv	a0,s4
    80003976:	00001097          	auipc	ra,0x1
    8000397a:	ee4080e7          	jalr	-284(ra) # 8000485a <log_write>
    8000397e:	b769                	j	80003908 <bmap+0x54>
  panic("bmap: out of range");
    80003980:	00005517          	auipc	a0,0x5
    80003984:	c8850513          	addi	a0,a0,-888 # 80008608 <syscalls+0x118>
    80003988:	ffffd097          	auipc	ra,0xffffd
    8000398c:	bb8080e7          	jalr	-1096(ra) # 80000540 <panic>

0000000080003990 <iget>:
{
    80003990:	7179                	addi	sp,sp,-48
    80003992:	f406                	sd	ra,40(sp)
    80003994:	f022                	sd	s0,32(sp)
    80003996:	ec26                	sd	s1,24(sp)
    80003998:	e84a                	sd	s2,16(sp)
    8000399a:	e44e                	sd	s3,8(sp)
    8000399c:	e052                	sd	s4,0(sp)
    8000399e:	1800                	addi	s0,sp,48
    800039a0:	89aa                	mv	s3,a0
    800039a2:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800039a4:	0001d517          	auipc	a0,0x1d
    800039a8:	10450513          	addi	a0,a0,260 # 80020aa8 <icache>
    800039ac:	ffffd097          	auipc	ra,0xffffd
    800039b0:	250080e7          	jalr	592(ra) # 80000bfc <acquire>
  empty = 0;
    800039b4:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800039b6:	0001d497          	auipc	s1,0x1d
    800039ba:	10a48493          	addi	s1,s1,266 # 80020ac0 <icache+0x18>
    800039be:	0001f697          	auipc	a3,0x1f
    800039c2:	b9268693          	addi	a3,a3,-1134 # 80022550 <log>
    800039c6:	a039                	j	800039d4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039c8:	02090b63          	beqz	s2,800039fe <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800039cc:	08848493          	addi	s1,s1,136
    800039d0:	02d48a63          	beq	s1,a3,80003a04 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800039d4:	449c                	lw	a5,8(s1)
    800039d6:	fef059e3          	blez	a5,800039c8 <iget+0x38>
    800039da:	4098                	lw	a4,0(s1)
    800039dc:	ff3716e3          	bne	a4,s3,800039c8 <iget+0x38>
    800039e0:	40d8                	lw	a4,4(s1)
    800039e2:	ff4713e3          	bne	a4,s4,800039c8 <iget+0x38>
      ip->ref++;
    800039e6:	2785                	addiw	a5,a5,1
    800039e8:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800039ea:	0001d517          	auipc	a0,0x1d
    800039ee:	0be50513          	addi	a0,a0,190 # 80020aa8 <icache>
    800039f2:	ffffd097          	auipc	ra,0xffffd
    800039f6:	2be080e7          	jalr	702(ra) # 80000cb0 <release>
      return ip;
    800039fa:	8926                	mv	s2,s1
    800039fc:	a03d                	j	80003a2a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039fe:	f7f9                	bnez	a5,800039cc <iget+0x3c>
    80003a00:	8926                	mv	s2,s1
    80003a02:	b7e9                	j	800039cc <iget+0x3c>
  if(empty == 0)
    80003a04:	02090c63          	beqz	s2,80003a3c <iget+0xac>
  ip->dev = dev;
    80003a08:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003a0c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003a10:	4785                	li	a5,1
    80003a12:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003a16:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003a1a:	0001d517          	auipc	a0,0x1d
    80003a1e:	08e50513          	addi	a0,a0,142 # 80020aa8 <icache>
    80003a22:	ffffd097          	auipc	ra,0xffffd
    80003a26:	28e080e7          	jalr	654(ra) # 80000cb0 <release>
}
    80003a2a:	854a                	mv	a0,s2
    80003a2c:	70a2                	ld	ra,40(sp)
    80003a2e:	7402                	ld	s0,32(sp)
    80003a30:	64e2                	ld	s1,24(sp)
    80003a32:	6942                	ld	s2,16(sp)
    80003a34:	69a2                	ld	s3,8(sp)
    80003a36:	6a02                	ld	s4,0(sp)
    80003a38:	6145                	addi	sp,sp,48
    80003a3a:	8082                	ret
    panic("iget: no inodes");
    80003a3c:	00005517          	auipc	a0,0x5
    80003a40:	be450513          	addi	a0,a0,-1052 # 80008620 <syscalls+0x130>
    80003a44:	ffffd097          	auipc	ra,0xffffd
    80003a48:	afc080e7          	jalr	-1284(ra) # 80000540 <panic>

0000000080003a4c <fsinit>:
fsinit(int dev) {
    80003a4c:	7179                	addi	sp,sp,-48
    80003a4e:	f406                	sd	ra,40(sp)
    80003a50:	f022                	sd	s0,32(sp)
    80003a52:	ec26                	sd	s1,24(sp)
    80003a54:	e84a                	sd	s2,16(sp)
    80003a56:	e44e                	sd	s3,8(sp)
    80003a58:	1800                	addi	s0,sp,48
    80003a5a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003a5c:	4585                	li	a1,1
    80003a5e:	00000097          	auipc	ra,0x0
    80003a62:	a62080e7          	jalr	-1438(ra) # 800034c0 <bread>
    80003a66:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a68:	0001d997          	auipc	s3,0x1d
    80003a6c:	02098993          	addi	s3,s3,32 # 80020a88 <sb>
    80003a70:	02000613          	li	a2,32
    80003a74:	05850593          	addi	a1,a0,88
    80003a78:	854e                	mv	a0,s3
    80003a7a:	ffffd097          	auipc	ra,0xffffd
    80003a7e:	2da080e7          	jalr	730(ra) # 80000d54 <memmove>
  brelse(bp);
    80003a82:	8526                	mv	a0,s1
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	b6c080e7          	jalr	-1172(ra) # 800035f0 <brelse>
  if(sb.magic != FSMAGIC)
    80003a8c:	0009a703          	lw	a4,0(s3)
    80003a90:	102037b7          	lui	a5,0x10203
    80003a94:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a98:	02f71263          	bne	a4,a5,80003abc <fsinit+0x70>
  initlog(dev, &sb);
    80003a9c:	0001d597          	auipc	a1,0x1d
    80003aa0:	fec58593          	addi	a1,a1,-20 # 80020a88 <sb>
    80003aa4:	854a                	mv	a0,s2
    80003aa6:	00001097          	auipc	ra,0x1
    80003aaa:	b3a080e7          	jalr	-1222(ra) # 800045e0 <initlog>
}
    80003aae:	70a2                	ld	ra,40(sp)
    80003ab0:	7402                	ld	s0,32(sp)
    80003ab2:	64e2                	ld	s1,24(sp)
    80003ab4:	6942                	ld	s2,16(sp)
    80003ab6:	69a2                	ld	s3,8(sp)
    80003ab8:	6145                	addi	sp,sp,48
    80003aba:	8082                	ret
    panic("invalid file system");
    80003abc:	00005517          	auipc	a0,0x5
    80003ac0:	b7450513          	addi	a0,a0,-1164 # 80008630 <syscalls+0x140>
    80003ac4:	ffffd097          	auipc	ra,0xffffd
    80003ac8:	a7c080e7          	jalr	-1412(ra) # 80000540 <panic>

0000000080003acc <iinit>:
{
    80003acc:	7179                	addi	sp,sp,-48
    80003ace:	f406                	sd	ra,40(sp)
    80003ad0:	f022                	sd	s0,32(sp)
    80003ad2:	ec26                	sd	s1,24(sp)
    80003ad4:	e84a                	sd	s2,16(sp)
    80003ad6:	e44e                	sd	s3,8(sp)
    80003ad8:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003ada:	00005597          	auipc	a1,0x5
    80003ade:	b6e58593          	addi	a1,a1,-1170 # 80008648 <syscalls+0x158>
    80003ae2:	0001d517          	auipc	a0,0x1d
    80003ae6:	fc650513          	addi	a0,a0,-58 # 80020aa8 <icache>
    80003aea:	ffffd097          	auipc	ra,0xffffd
    80003aee:	082080e7          	jalr	130(ra) # 80000b6c <initlock>
  for(i = 0; i < NINODE; i++) {
    80003af2:	0001d497          	auipc	s1,0x1d
    80003af6:	fde48493          	addi	s1,s1,-34 # 80020ad0 <icache+0x28>
    80003afa:	0001f997          	auipc	s3,0x1f
    80003afe:	a6698993          	addi	s3,s3,-1434 # 80022560 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003b02:	00005917          	auipc	s2,0x5
    80003b06:	b4e90913          	addi	s2,s2,-1202 # 80008650 <syscalls+0x160>
    80003b0a:	85ca                	mv	a1,s2
    80003b0c:	8526                	mv	a0,s1
    80003b0e:	00001097          	auipc	ra,0x1
    80003b12:	e3a080e7          	jalr	-454(ra) # 80004948 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b16:	08848493          	addi	s1,s1,136
    80003b1a:	ff3498e3          	bne	s1,s3,80003b0a <iinit+0x3e>
}
    80003b1e:	70a2                	ld	ra,40(sp)
    80003b20:	7402                	ld	s0,32(sp)
    80003b22:	64e2                	ld	s1,24(sp)
    80003b24:	6942                	ld	s2,16(sp)
    80003b26:	69a2                	ld	s3,8(sp)
    80003b28:	6145                	addi	sp,sp,48
    80003b2a:	8082                	ret

0000000080003b2c <ialloc>:
{
    80003b2c:	715d                	addi	sp,sp,-80
    80003b2e:	e486                	sd	ra,72(sp)
    80003b30:	e0a2                	sd	s0,64(sp)
    80003b32:	fc26                	sd	s1,56(sp)
    80003b34:	f84a                	sd	s2,48(sp)
    80003b36:	f44e                	sd	s3,40(sp)
    80003b38:	f052                	sd	s4,32(sp)
    80003b3a:	ec56                	sd	s5,24(sp)
    80003b3c:	e85a                	sd	s6,16(sp)
    80003b3e:	e45e                	sd	s7,8(sp)
    80003b40:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b42:	0001d717          	auipc	a4,0x1d
    80003b46:	f5272703          	lw	a4,-174(a4) # 80020a94 <sb+0xc>
    80003b4a:	4785                	li	a5,1
    80003b4c:	04e7fa63          	bgeu	a5,a4,80003ba0 <ialloc+0x74>
    80003b50:	8aaa                	mv	s5,a0
    80003b52:	8bae                	mv	s7,a1
    80003b54:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003b56:	0001da17          	auipc	s4,0x1d
    80003b5a:	f32a0a13          	addi	s4,s4,-206 # 80020a88 <sb>
    80003b5e:	00048b1b          	sext.w	s6,s1
    80003b62:	0044d793          	srli	a5,s1,0x4
    80003b66:	018a2583          	lw	a1,24(s4)
    80003b6a:	9dbd                	addw	a1,a1,a5
    80003b6c:	8556                	mv	a0,s5
    80003b6e:	00000097          	auipc	ra,0x0
    80003b72:	952080e7          	jalr	-1710(ra) # 800034c0 <bread>
    80003b76:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b78:	05850993          	addi	s3,a0,88
    80003b7c:	00f4f793          	andi	a5,s1,15
    80003b80:	079a                	slli	a5,a5,0x6
    80003b82:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b84:	00099783          	lh	a5,0(s3)
    80003b88:	c785                	beqz	a5,80003bb0 <ialloc+0x84>
    brelse(bp);
    80003b8a:	00000097          	auipc	ra,0x0
    80003b8e:	a66080e7          	jalr	-1434(ra) # 800035f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b92:	0485                	addi	s1,s1,1
    80003b94:	00ca2703          	lw	a4,12(s4)
    80003b98:	0004879b          	sext.w	a5,s1
    80003b9c:	fce7e1e3          	bltu	a5,a4,80003b5e <ialloc+0x32>
  panic("ialloc: no inodes");
    80003ba0:	00005517          	auipc	a0,0x5
    80003ba4:	ab850513          	addi	a0,a0,-1352 # 80008658 <syscalls+0x168>
    80003ba8:	ffffd097          	auipc	ra,0xffffd
    80003bac:	998080e7          	jalr	-1640(ra) # 80000540 <panic>
      memset(dip, 0, sizeof(*dip));
    80003bb0:	04000613          	li	a2,64
    80003bb4:	4581                	li	a1,0
    80003bb6:	854e                	mv	a0,s3
    80003bb8:	ffffd097          	auipc	ra,0xffffd
    80003bbc:	140080e7          	jalr	320(ra) # 80000cf8 <memset>
      dip->type = type;
    80003bc0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003bc4:	854a                	mv	a0,s2
    80003bc6:	00001097          	auipc	ra,0x1
    80003bca:	c94080e7          	jalr	-876(ra) # 8000485a <log_write>
      brelse(bp);
    80003bce:	854a                	mv	a0,s2
    80003bd0:	00000097          	auipc	ra,0x0
    80003bd4:	a20080e7          	jalr	-1504(ra) # 800035f0 <brelse>
      return iget(dev, inum);
    80003bd8:	85da                	mv	a1,s6
    80003bda:	8556                	mv	a0,s5
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	db4080e7          	jalr	-588(ra) # 80003990 <iget>
}
    80003be4:	60a6                	ld	ra,72(sp)
    80003be6:	6406                	ld	s0,64(sp)
    80003be8:	74e2                	ld	s1,56(sp)
    80003bea:	7942                	ld	s2,48(sp)
    80003bec:	79a2                	ld	s3,40(sp)
    80003bee:	7a02                	ld	s4,32(sp)
    80003bf0:	6ae2                	ld	s5,24(sp)
    80003bf2:	6b42                	ld	s6,16(sp)
    80003bf4:	6ba2                	ld	s7,8(sp)
    80003bf6:	6161                	addi	sp,sp,80
    80003bf8:	8082                	ret

0000000080003bfa <iupdate>:
{
    80003bfa:	1101                	addi	sp,sp,-32
    80003bfc:	ec06                	sd	ra,24(sp)
    80003bfe:	e822                	sd	s0,16(sp)
    80003c00:	e426                	sd	s1,8(sp)
    80003c02:	e04a                	sd	s2,0(sp)
    80003c04:	1000                	addi	s0,sp,32
    80003c06:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c08:	415c                	lw	a5,4(a0)
    80003c0a:	0047d79b          	srliw	a5,a5,0x4
    80003c0e:	0001d597          	auipc	a1,0x1d
    80003c12:	e925a583          	lw	a1,-366(a1) # 80020aa0 <sb+0x18>
    80003c16:	9dbd                	addw	a1,a1,a5
    80003c18:	4108                	lw	a0,0(a0)
    80003c1a:	00000097          	auipc	ra,0x0
    80003c1e:	8a6080e7          	jalr	-1882(ra) # 800034c0 <bread>
    80003c22:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c24:	05850793          	addi	a5,a0,88
    80003c28:	40c8                	lw	a0,4(s1)
    80003c2a:	893d                	andi	a0,a0,15
    80003c2c:	051a                	slli	a0,a0,0x6
    80003c2e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003c30:	04449703          	lh	a4,68(s1)
    80003c34:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003c38:	04649703          	lh	a4,70(s1)
    80003c3c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003c40:	04849703          	lh	a4,72(s1)
    80003c44:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003c48:	04a49703          	lh	a4,74(s1)
    80003c4c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003c50:	44f8                	lw	a4,76(s1)
    80003c52:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c54:	03400613          	li	a2,52
    80003c58:	05048593          	addi	a1,s1,80
    80003c5c:	0531                	addi	a0,a0,12
    80003c5e:	ffffd097          	auipc	ra,0xffffd
    80003c62:	0f6080e7          	jalr	246(ra) # 80000d54 <memmove>
  log_write(bp);
    80003c66:	854a                	mv	a0,s2
    80003c68:	00001097          	auipc	ra,0x1
    80003c6c:	bf2080e7          	jalr	-1038(ra) # 8000485a <log_write>
  brelse(bp);
    80003c70:	854a                	mv	a0,s2
    80003c72:	00000097          	auipc	ra,0x0
    80003c76:	97e080e7          	jalr	-1666(ra) # 800035f0 <brelse>
}
    80003c7a:	60e2                	ld	ra,24(sp)
    80003c7c:	6442                	ld	s0,16(sp)
    80003c7e:	64a2                	ld	s1,8(sp)
    80003c80:	6902                	ld	s2,0(sp)
    80003c82:	6105                	addi	sp,sp,32
    80003c84:	8082                	ret

0000000080003c86 <idup>:
{
    80003c86:	1101                	addi	sp,sp,-32
    80003c88:	ec06                	sd	ra,24(sp)
    80003c8a:	e822                	sd	s0,16(sp)
    80003c8c:	e426                	sd	s1,8(sp)
    80003c8e:	1000                	addi	s0,sp,32
    80003c90:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003c92:	0001d517          	auipc	a0,0x1d
    80003c96:	e1650513          	addi	a0,a0,-490 # 80020aa8 <icache>
    80003c9a:	ffffd097          	auipc	ra,0xffffd
    80003c9e:	f62080e7          	jalr	-158(ra) # 80000bfc <acquire>
  ip->ref++;
    80003ca2:	449c                	lw	a5,8(s1)
    80003ca4:	2785                	addiw	a5,a5,1
    80003ca6:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003ca8:	0001d517          	auipc	a0,0x1d
    80003cac:	e0050513          	addi	a0,a0,-512 # 80020aa8 <icache>
    80003cb0:	ffffd097          	auipc	ra,0xffffd
    80003cb4:	000080e7          	jalr	ra # 80000cb0 <release>
}
    80003cb8:	8526                	mv	a0,s1
    80003cba:	60e2                	ld	ra,24(sp)
    80003cbc:	6442                	ld	s0,16(sp)
    80003cbe:	64a2                	ld	s1,8(sp)
    80003cc0:	6105                	addi	sp,sp,32
    80003cc2:	8082                	ret

0000000080003cc4 <ilock>:
{
    80003cc4:	1101                	addi	sp,sp,-32
    80003cc6:	ec06                	sd	ra,24(sp)
    80003cc8:	e822                	sd	s0,16(sp)
    80003cca:	e426                	sd	s1,8(sp)
    80003ccc:	e04a                	sd	s2,0(sp)
    80003cce:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003cd0:	c115                	beqz	a0,80003cf4 <ilock+0x30>
    80003cd2:	84aa                	mv	s1,a0
    80003cd4:	451c                	lw	a5,8(a0)
    80003cd6:	00f05f63          	blez	a5,80003cf4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003cda:	0541                	addi	a0,a0,16
    80003cdc:	00001097          	auipc	ra,0x1
    80003ce0:	ca6080e7          	jalr	-858(ra) # 80004982 <acquiresleep>
  if(ip->valid == 0){
    80003ce4:	40bc                	lw	a5,64(s1)
    80003ce6:	cf99                	beqz	a5,80003d04 <ilock+0x40>
}
    80003ce8:	60e2                	ld	ra,24(sp)
    80003cea:	6442                	ld	s0,16(sp)
    80003cec:	64a2                	ld	s1,8(sp)
    80003cee:	6902                	ld	s2,0(sp)
    80003cf0:	6105                	addi	sp,sp,32
    80003cf2:	8082                	ret
    panic("ilock");
    80003cf4:	00005517          	auipc	a0,0x5
    80003cf8:	97c50513          	addi	a0,a0,-1668 # 80008670 <syscalls+0x180>
    80003cfc:	ffffd097          	auipc	ra,0xffffd
    80003d00:	844080e7          	jalr	-1980(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d04:	40dc                	lw	a5,4(s1)
    80003d06:	0047d79b          	srliw	a5,a5,0x4
    80003d0a:	0001d597          	auipc	a1,0x1d
    80003d0e:	d965a583          	lw	a1,-618(a1) # 80020aa0 <sb+0x18>
    80003d12:	9dbd                	addw	a1,a1,a5
    80003d14:	4088                	lw	a0,0(s1)
    80003d16:	fffff097          	auipc	ra,0xfffff
    80003d1a:	7aa080e7          	jalr	1962(ra) # 800034c0 <bread>
    80003d1e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d20:	05850593          	addi	a1,a0,88
    80003d24:	40dc                	lw	a5,4(s1)
    80003d26:	8bbd                	andi	a5,a5,15
    80003d28:	079a                	slli	a5,a5,0x6
    80003d2a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003d2c:	00059783          	lh	a5,0(a1)
    80003d30:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003d34:	00259783          	lh	a5,2(a1)
    80003d38:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003d3c:	00459783          	lh	a5,4(a1)
    80003d40:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d44:	00659783          	lh	a5,6(a1)
    80003d48:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d4c:	459c                	lw	a5,8(a1)
    80003d4e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d50:	03400613          	li	a2,52
    80003d54:	05b1                	addi	a1,a1,12
    80003d56:	05048513          	addi	a0,s1,80
    80003d5a:	ffffd097          	auipc	ra,0xffffd
    80003d5e:	ffa080e7          	jalr	-6(ra) # 80000d54 <memmove>
    brelse(bp);
    80003d62:	854a                	mv	a0,s2
    80003d64:	00000097          	auipc	ra,0x0
    80003d68:	88c080e7          	jalr	-1908(ra) # 800035f0 <brelse>
    ip->valid = 1;
    80003d6c:	4785                	li	a5,1
    80003d6e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d70:	04449783          	lh	a5,68(s1)
    80003d74:	fbb5                	bnez	a5,80003ce8 <ilock+0x24>
      panic("ilock: no type");
    80003d76:	00005517          	auipc	a0,0x5
    80003d7a:	90250513          	addi	a0,a0,-1790 # 80008678 <syscalls+0x188>
    80003d7e:	ffffc097          	auipc	ra,0xffffc
    80003d82:	7c2080e7          	jalr	1986(ra) # 80000540 <panic>

0000000080003d86 <iunlock>:
{
    80003d86:	1101                	addi	sp,sp,-32
    80003d88:	ec06                	sd	ra,24(sp)
    80003d8a:	e822                	sd	s0,16(sp)
    80003d8c:	e426                	sd	s1,8(sp)
    80003d8e:	e04a                	sd	s2,0(sp)
    80003d90:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d92:	c905                	beqz	a0,80003dc2 <iunlock+0x3c>
    80003d94:	84aa                	mv	s1,a0
    80003d96:	01050913          	addi	s2,a0,16
    80003d9a:	854a                	mv	a0,s2
    80003d9c:	00001097          	auipc	ra,0x1
    80003da0:	c80080e7          	jalr	-896(ra) # 80004a1c <holdingsleep>
    80003da4:	cd19                	beqz	a0,80003dc2 <iunlock+0x3c>
    80003da6:	449c                	lw	a5,8(s1)
    80003da8:	00f05d63          	blez	a5,80003dc2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003dac:	854a                	mv	a0,s2
    80003dae:	00001097          	auipc	ra,0x1
    80003db2:	c2a080e7          	jalr	-982(ra) # 800049d8 <releasesleep>
}
    80003db6:	60e2                	ld	ra,24(sp)
    80003db8:	6442                	ld	s0,16(sp)
    80003dba:	64a2                	ld	s1,8(sp)
    80003dbc:	6902                	ld	s2,0(sp)
    80003dbe:	6105                	addi	sp,sp,32
    80003dc0:	8082                	ret
    panic("iunlock");
    80003dc2:	00005517          	auipc	a0,0x5
    80003dc6:	8c650513          	addi	a0,a0,-1850 # 80008688 <syscalls+0x198>
    80003dca:	ffffc097          	auipc	ra,0xffffc
    80003dce:	776080e7          	jalr	1910(ra) # 80000540 <panic>

0000000080003dd2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003dd2:	7179                	addi	sp,sp,-48
    80003dd4:	f406                	sd	ra,40(sp)
    80003dd6:	f022                	sd	s0,32(sp)
    80003dd8:	ec26                	sd	s1,24(sp)
    80003dda:	e84a                	sd	s2,16(sp)
    80003ddc:	e44e                	sd	s3,8(sp)
    80003dde:	e052                	sd	s4,0(sp)
    80003de0:	1800                	addi	s0,sp,48
    80003de2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003de4:	05050493          	addi	s1,a0,80
    80003de8:	08050913          	addi	s2,a0,128
    80003dec:	a021                	j	80003df4 <itrunc+0x22>
    80003dee:	0491                	addi	s1,s1,4
    80003df0:	01248d63          	beq	s1,s2,80003e0a <itrunc+0x38>
    if(ip->addrs[i]){
    80003df4:	408c                	lw	a1,0(s1)
    80003df6:	dde5                	beqz	a1,80003dee <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003df8:	0009a503          	lw	a0,0(s3)
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	90a080e7          	jalr	-1782(ra) # 80003706 <bfree>
      ip->addrs[i] = 0;
    80003e04:	0004a023          	sw	zero,0(s1)
    80003e08:	b7dd                	j	80003dee <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e0a:	0809a583          	lw	a1,128(s3)
    80003e0e:	e185                	bnez	a1,80003e2e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e10:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e14:	854e                	mv	a0,s3
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	de4080e7          	jalr	-540(ra) # 80003bfa <iupdate>
}
    80003e1e:	70a2                	ld	ra,40(sp)
    80003e20:	7402                	ld	s0,32(sp)
    80003e22:	64e2                	ld	s1,24(sp)
    80003e24:	6942                	ld	s2,16(sp)
    80003e26:	69a2                	ld	s3,8(sp)
    80003e28:	6a02                	ld	s4,0(sp)
    80003e2a:	6145                	addi	sp,sp,48
    80003e2c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003e2e:	0009a503          	lw	a0,0(s3)
    80003e32:	fffff097          	auipc	ra,0xfffff
    80003e36:	68e080e7          	jalr	1678(ra) # 800034c0 <bread>
    80003e3a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e3c:	05850493          	addi	s1,a0,88
    80003e40:	45850913          	addi	s2,a0,1112
    80003e44:	a021                	j	80003e4c <itrunc+0x7a>
    80003e46:	0491                	addi	s1,s1,4
    80003e48:	01248b63          	beq	s1,s2,80003e5e <itrunc+0x8c>
      if(a[j])
    80003e4c:	408c                	lw	a1,0(s1)
    80003e4e:	dde5                	beqz	a1,80003e46 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003e50:	0009a503          	lw	a0,0(s3)
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	8b2080e7          	jalr	-1870(ra) # 80003706 <bfree>
    80003e5c:	b7ed                	j	80003e46 <itrunc+0x74>
    brelse(bp);
    80003e5e:	8552                	mv	a0,s4
    80003e60:	fffff097          	auipc	ra,0xfffff
    80003e64:	790080e7          	jalr	1936(ra) # 800035f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e68:	0809a583          	lw	a1,128(s3)
    80003e6c:	0009a503          	lw	a0,0(s3)
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	896080e7          	jalr	-1898(ra) # 80003706 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e78:	0809a023          	sw	zero,128(s3)
    80003e7c:	bf51                	j	80003e10 <itrunc+0x3e>

0000000080003e7e <iput>:
{
    80003e7e:	1101                	addi	sp,sp,-32
    80003e80:	ec06                	sd	ra,24(sp)
    80003e82:	e822                	sd	s0,16(sp)
    80003e84:	e426                	sd	s1,8(sp)
    80003e86:	e04a                	sd	s2,0(sp)
    80003e88:	1000                	addi	s0,sp,32
    80003e8a:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003e8c:	0001d517          	auipc	a0,0x1d
    80003e90:	c1c50513          	addi	a0,a0,-996 # 80020aa8 <icache>
    80003e94:	ffffd097          	auipc	ra,0xffffd
    80003e98:	d68080e7          	jalr	-664(ra) # 80000bfc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e9c:	4498                	lw	a4,8(s1)
    80003e9e:	4785                	li	a5,1
    80003ea0:	02f70363          	beq	a4,a5,80003ec6 <iput+0x48>
  ip->ref--;
    80003ea4:	449c                	lw	a5,8(s1)
    80003ea6:	37fd                	addiw	a5,a5,-1
    80003ea8:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003eaa:	0001d517          	auipc	a0,0x1d
    80003eae:	bfe50513          	addi	a0,a0,-1026 # 80020aa8 <icache>
    80003eb2:	ffffd097          	auipc	ra,0xffffd
    80003eb6:	dfe080e7          	jalr	-514(ra) # 80000cb0 <release>
}
    80003eba:	60e2                	ld	ra,24(sp)
    80003ebc:	6442                	ld	s0,16(sp)
    80003ebe:	64a2                	ld	s1,8(sp)
    80003ec0:	6902                	ld	s2,0(sp)
    80003ec2:	6105                	addi	sp,sp,32
    80003ec4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ec6:	40bc                	lw	a5,64(s1)
    80003ec8:	dff1                	beqz	a5,80003ea4 <iput+0x26>
    80003eca:	04a49783          	lh	a5,74(s1)
    80003ece:	fbf9                	bnez	a5,80003ea4 <iput+0x26>
    acquiresleep(&ip->lock);
    80003ed0:	01048913          	addi	s2,s1,16
    80003ed4:	854a                	mv	a0,s2
    80003ed6:	00001097          	auipc	ra,0x1
    80003eda:	aac080e7          	jalr	-1364(ra) # 80004982 <acquiresleep>
    release(&icache.lock);
    80003ede:	0001d517          	auipc	a0,0x1d
    80003ee2:	bca50513          	addi	a0,a0,-1078 # 80020aa8 <icache>
    80003ee6:	ffffd097          	auipc	ra,0xffffd
    80003eea:	dca080e7          	jalr	-566(ra) # 80000cb0 <release>
    itrunc(ip);
    80003eee:	8526                	mv	a0,s1
    80003ef0:	00000097          	auipc	ra,0x0
    80003ef4:	ee2080e7          	jalr	-286(ra) # 80003dd2 <itrunc>
    ip->type = 0;
    80003ef8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003efc:	8526                	mv	a0,s1
    80003efe:	00000097          	auipc	ra,0x0
    80003f02:	cfc080e7          	jalr	-772(ra) # 80003bfa <iupdate>
    ip->valid = 0;
    80003f06:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f0a:	854a                	mv	a0,s2
    80003f0c:	00001097          	auipc	ra,0x1
    80003f10:	acc080e7          	jalr	-1332(ra) # 800049d8 <releasesleep>
    acquire(&icache.lock);
    80003f14:	0001d517          	auipc	a0,0x1d
    80003f18:	b9450513          	addi	a0,a0,-1132 # 80020aa8 <icache>
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	ce0080e7          	jalr	-800(ra) # 80000bfc <acquire>
    80003f24:	b741                	j	80003ea4 <iput+0x26>

0000000080003f26 <iunlockput>:
{
    80003f26:	1101                	addi	sp,sp,-32
    80003f28:	ec06                	sd	ra,24(sp)
    80003f2a:	e822                	sd	s0,16(sp)
    80003f2c:	e426                	sd	s1,8(sp)
    80003f2e:	1000                	addi	s0,sp,32
    80003f30:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f32:	00000097          	auipc	ra,0x0
    80003f36:	e54080e7          	jalr	-428(ra) # 80003d86 <iunlock>
  iput(ip);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	00000097          	auipc	ra,0x0
    80003f40:	f42080e7          	jalr	-190(ra) # 80003e7e <iput>
}
    80003f44:	60e2                	ld	ra,24(sp)
    80003f46:	6442                	ld	s0,16(sp)
    80003f48:	64a2                	ld	s1,8(sp)
    80003f4a:	6105                	addi	sp,sp,32
    80003f4c:	8082                	ret

0000000080003f4e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f4e:	1141                	addi	sp,sp,-16
    80003f50:	e422                	sd	s0,8(sp)
    80003f52:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f54:	411c                	lw	a5,0(a0)
    80003f56:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f58:	415c                	lw	a5,4(a0)
    80003f5a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f5c:	04451783          	lh	a5,68(a0)
    80003f60:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f64:	04a51783          	lh	a5,74(a0)
    80003f68:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f6c:	04c56783          	lwu	a5,76(a0)
    80003f70:	e99c                	sd	a5,16(a1)
}
    80003f72:	6422                	ld	s0,8(sp)
    80003f74:	0141                	addi	sp,sp,16
    80003f76:	8082                	ret

0000000080003f78 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f78:	457c                	lw	a5,76(a0)
    80003f7a:	0ed7e863          	bltu	a5,a3,8000406a <readi+0xf2>
{
    80003f7e:	7159                	addi	sp,sp,-112
    80003f80:	f486                	sd	ra,104(sp)
    80003f82:	f0a2                	sd	s0,96(sp)
    80003f84:	eca6                	sd	s1,88(sp)
    80003f86:	e8ca                	sd	s2,80(sp)
    80003f88:	e4ce                	sd	s3,72(sp)
    80003f8a:	e0d2                	sd	s4,64(sp)
    80003f8c:	fc56                	sd	s5,56(sp)
    80003f8e:	f85a                	sd	s6,48(sp)
    80003f90:	f45e                	sd	s7,40(sp)
    80003f92:	f062                	sd	s8,32(sp)
    80003f94:	ec66                	sd	s9,24(sp)
    80003f96:	e86a                	sd	s10,16(sp)
    80003f98:	e46e                	sd	s11,8(sp)
    80003f9a:	1880                	addi	s0,sp,112
    80003f9c:	8baa                	mv	s7,a0
    80003f9e:	8c2e                	mv	s8,a1
    80003fa0:	8ab2                	mv	s5,a2
    80003fa2:	84b6                	mv	s1,a3
    80003fa4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003fa6:	9f35                	addw	a4,a4,a3
    return 0;
    80003fa8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003faa:	08d76f63          	bltu	a4,a3,80004048 <readi+0xd0>
  if(off + n > ip->size)
    80003fae:	00e7f463          	bgeu	a5,a4,80003fb6 <readi+0x3e>
    n = ip->size - off;
    80003fb2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fb6:	0a0b0863          	beqz	s6,80004066 <readi+0xee>
    80003fba:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fbc:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003fc0:	5cfd                	li	s9,-1
    80003fc2:	a82d                	j	80003ffc <readi+0x84>
    80003fc4:	020a1d93          	slli	s11,s4,0x20
    80003fc8:	020ddd93          	srli	s11,s11,0x20
    80003fcc:	05890793          	addi	a5,s2,88
    80003fd0:	86ee                	mv	a3,s11
    80003fd2:	963e                	add	a2,a2,a5
    80003fd4:	85d6                	mv	a1,s5
    80003fd6:	8562                	mv	a0,s8
    80003fd8:	fffff097          	auipc	ra,0xfffff
    80003fdc:	a54080e7          	jalr	-1452(ra) # 80002a2c <either_copyout>
    80003fe0:	05950d63          	beq	a0,s9,8000403a <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003fe4:	854a                	mv	a0,s2
    80003fe6:	fffff097          	auipc	ra,0xfffff
    80003fea:	60a080e7          	jalr	1546(ra) # 800035f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fee:	013a09bb          	addw	s3,s4,s3
    80003ff2:	009a04bb          	addw	s1,s4,s1
    80003ff6:	9aee                	add	s5,s5,s11
    80003ff8:	0569f663          	bgeu	s3,s6,80004044 <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003ffc:	000ba903          	lw	s2,0(s7)
    80004000:	00a4d59b          	srliw	a1,s1,0xa
    80004004:	855e                	mv	a0,s7
    80004006:	00000097          	auipc	ra,0x0
    8000400a:	8ae080e7          	jalr	-1874(ra) # 800038b4 <bmap>
    8000400e:	0005059b          	sext.w	a1,a0
    80004012:	854a                	mv	a0,s2
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	4ac080e7          	jalr	1196(ra) # 800034c0 <bread>
    8000401c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000401e:	3ff4f613          	andi	a2,s1,1023
    80004022:	40cd07bb          	subw	a5,s10,a2
    80004026:	413b073b          	subw	a4,s6,s3
    8000402a:	8a3e                	mv	s4,a5
    8000402c:	2781                	sext.w	a5,a5
    8000402e:	0007069b          	sext.w	a3,a4
    80004032:	f8f6f9e3          	bgeu	a3,a5,80003fc4 <readi+0x4c>
    80004036:	8a3a                	mv	s4,a4
    80004038:	b771                	j	80003fc4 <readi+0x4c>
      brelse(bp);
    8000403a:	854a                	mv	a0,s2
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	5b4080e7          	jalr	1460(ra) # 800035f0 <brelse>
  }
  return tot;
    80004044:	0009851b          	sext.w	a0,s3
}
    80004048:	70a6                	ld	ra,104(sp)
    8000404a:	7406                	ld	s0,96(sp)
    8000404c:	64e6                	ld	s1,88(sp)
    8000404e:	6946                	ld	s2,80(sp)
    80004050:	69a6                	ld	s3,72(sp)
    80004052:	6a06                	ld	s4,64(sp)
    80004054:	7ae2                	ld	s5,56(sp)
    80004056:	7b42                	ld	s6,48(sp)
    80004058:	7ba2                	ld	s7,40(sp)
    8000405a:	7c02                	ld	s8,32(sp)
    8000405c:	6ce2                	ld	s9,24(sp)
    8000405e:	6d42                	ld	s10,16(sp)
    80004060:	6da2                	ld	s11,8(sp)
    80004062:	6165                	addi	sp,sp,112
    80004064:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004066:	89da                	mv	s3,s6
    80004068:	bff1                	j	80004044 <readi+0xcc>
    return 0;
    8000406a:	4501                	li	a0,0
}
    8000406c:	8082                	ret

000000008000406e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000406e:	457c                	lw	a5,76(a0)
    80004070:	10d7e663          	bltu	a5,a3,8000417c <writei+0x10e>
{
    80004074:	7159                	addi	sp,sp,-112
    80004076:	f486                	sd	ra,104(sp)
    80004078:	f0a2                	sd	s0,96(sp)
    8000407a:	eca6                	sd	s1,88(sp)
    8000407c:	e8ca                	sd	s2,80(sp)
    8000407e:	e4ce                	sd	s3,72(sp)
    80004080:	e0d2                	sd	s4,64(sp)
    80004082:	fc56                	sd	s5,56(sp)
    80004084:	f85a                	sd	s6,48(sp)
    80004086:	f45e                	sd	s7,40(sp)
    80004088:	f062                	sd	s8,32(sp)
    8000408a:	ec66                	sd	s9,24(sp)
    8000408c:	e86a                	sd	s10,16(sp)
    8000408e:	e46e                	sd	s11,8(sp)
    80004090:	1880                	addi	s0,sp,112
    80004092:	8baa                	mv	s7,a0
    80004094:	8c2e                	mv	s8,a1
    80004096:	8ab2                	mv	s5,a2
    80004098:	8936                	mv	s2,a3
    8000409a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000409c:	00e687bb          	addw	a5,a3,a4
    800040a0:	0ed7e063          	bltu	a5,a3,80004180 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800040a4:	00043737          	lui	a4,0x43
    800040a8:	0cf76e63          	bltu	a4,a5,80004184 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040ac:	0a0b0763          	beqz	s6,8000415a <writei+0xec>
    800040b0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800040b2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800040b6:	5cfd                	li	s9,-1
    800040b8:	a091                	j	800040fc <writei+0x8e>
    800040ba:	02099d93          	slli	s11,s3,0x20
    800040be:	020ddd93          	srli	s11,s11,0x20
    800040c2:	05848793          	addi	a5,s1,88
    800040c6:	86ee                	mv	a3,s11
    800040c8:	8656                	mv	a2,s5
    800040ca:	85e2                	mv	a1,s8
    800040cc:	953e                	add	a0,a0,a5
    800040ce:	fffff097          	auipc	ra,0xfffff
    800040d2:	9b4080e7          	jalr	-1612(ra) # 80002a82 <either_copyin>
    800040d6:	07950263          	beq	a0,s9,8000413a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800040da:	8526                	mv	a0,s1
    800040dc:	00000097          	auipc	ra,0x0
    800040e0:	77e080e7          	jalr	1918(ra) # 8000485a <log_write>
    brelse(bp);
    800040e4:	8526                	mv	a0,s1
    800040e6:	fffff097          	auipc	ra,0xfffff
    800040ea:	50a080e7          	jalr	1290(ra) # 800035f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040ee:	01498a3b          	addw	s4,s3,s4
    800040f2:	0129893b          	addw	s2,s3,s2
    800040f6:	9aee                	add	s5,s5,s11
    800040f8:	056a7663          	bgeu	s4,s6,80004144 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800040fc:	000ba483          	lw	s1,0(s7)
    80004100:	00a9559b          	srliw	a1,s2,0xa
    80004104:	855e                	mv	a0,s7
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	7ae080e7          	jalr	1966(ra) # 800038b4 <bmap>
    8000410e:	0005059b          	sext.w	a1,a0
    80004112:	8526                	mv	a0,s1
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	3ac080e7          	jalr	940(ra) # 800034c0 <bread>
    8000411c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000411e:	3ff97513          	andi	a0,s2,1023
    80004122:	40ad07bb          	subw	a5,s10,a0
    80004126:	414b073b          	subw	a4,s6,s4
    8000412a:	89be                	mv	s3,a5
    8000412c:	2781                	sext.w	a5,a5
    8000412e:	0007069b          	sext.w	a3,a4
    80004132:	f8f6f4e3          	bgeu	a3,a5,800040ba <writei+0x4c>
    80004136:	89ba                	mv	s3,a4
    80004138:	b749                	j	800040ba <writei+0x4c>
      brelse(bp);
    8000413a:	8526                	mv	a0,s1
    8000413c:	fffff097          	auipc	ra,0xfffff
    80004140:	4b4080e7          	jalr	1204(ra) # 800035f0 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80004144:	04cba783          	lw	a5,76(s7)
    80004148:	0127f463          	bgeu	a5,s2,80004150 <writei+0xe2>
      ip->size = off;
    8000414c:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80004150:	855e                	mv	a0,s7
    80004152:	00000097          	auipc	ra,0x0
    80004156:	aa8080e7          	jalr	-1368(ra) # 80003bfa <iupdate>
  }

  return n;
    8000415a:	000b051b          	sext.w	a0,s6
}
    8000415e:	70a6                	ld	ra,104(sp)
    80004160:	7406                	ld	s0,96(sp)
    80004162:	64e6                	ld	s1,88(sp)
    80004164:	6946                	ld	s2,80(sp)
    80004166:	69a6                	ld	s3,72(sp)
    80004168:	6a06                	ld	s4,64(sp)
    8000416a:	7ae2                	ld	s5,56(sp)
    8000416c:	7b42                	ld	s6,48(sp)
    8000416e:	7ba2                	ld	s7,40(sp)
    80004170:	7c02                	ld	s8,32(sp)
    80004172:	6ce2                	ld	s9,24(sp)
    80004174:	6d42                	ld	s10,16(sp)
    80004176:	6da2                	ld	s11,8(sp)
    80004178:	6165                	addi	sp,sp,112
    8000417a:	8082                	ret
    return -1;
    8000417c:	557d                	li	a0,-1
}
    8000417e:	8082                	ret
    return -1;
    80004180:	557d                	li	a0,-1
    80004182:	bff1                	j	8000415e <writei+0xf0>
    return -1;
    80004184:	557d                	li	a0,-1
    80004186:	bfe1                	j	8000415e <writei+0xf0>

0000000080004188 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004188:	1141                	addi	sp,sp,-16
    8000418a:	e406                	sd	ra,8(sp)
    8000418c:	e022                	sd	s0,0(sp)
    8000418e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004190:	4639                	li	a2,14
    80004192:	ffffd097          	auipc	ra,0xffffd
    80004196:	c3e080e7          	jalr	-962(ra) # 80000dd0 <strncmp>
}
    8000419a:	60a2                	ld	ra,8(sp)
    8000419c:	6402                	ld	s0,0(sp)
    8000419e:	0141                	addi	sp,sp,16
    800041a0:	8082                	ret

00000000800041a2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800041a2:	7139                	addi	sp,sp,-64
    800041a4:	fc06                	sd	ra,56(sp)
    800041a6:	f822                	sd	s0,48(sp)
    800041a8:	f426                	sd	s1,40(sp)
    800041aa:	f04a                	sd	s2,32(sp)
    800041ac:	ec4e                	sd	s3,24(sp)
    800041ae:	e852                	sd	s4,16(sp)
    800041b0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800041b2:	04451703          	lh	a4,68(a0)
    800041b6:	4785                	li	a5,1
    800041b8:	00f71a63          	bne	a4,a5,800041cc <dirlookup+0x2a>
    800041bc:	892a                	mv	s2,a0
    800041be:	89ae                	mv	s3,a1
    800041c0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800041c2:	457c                	lw	a5,76(a0)
    800041c4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800041c6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041c8:	e79d                	bnez	a5,800041f6 <dirlookup+0x54>
    800041ca:	a8a5                	j	80004242 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800041cc:	00004517          	auipc	a0,0x4
    800041d0:	4c450513          	addi	a0,a0,1220 # 80008690 <syscalls+0x1a0>
    800041d4:	ffffc097          	auipc	ra,0xffffc
    800041d8:	36c080e7          	jalr	876(ra) # 80000540 <panic>
      panic("dirlookup read");
    800041dc:	00004517          	auipc	a0,0x4
    800041e0:	4cc50513          	addi	a0,a0,1228 # 800086a8 <syscalls+0x1b8>
    800041e4:	ffffc097          	auipc	ra,0xffffc
    800041e8:	35c080e7          	jalr	860(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041ec:	24c1                	addiw	s1,s1,16
    800041ee:	04c92783          	lw	a5,76(s2)
    800041f2:	04f4f763          	bgeu	s1,a5,80004240 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041f6:	4741                	li	a4,16
    800041f8:	86a6                	mv	a3,s1
    800041fa:	fc040613          	addi	a2,s0,-64
    800041fe:	4581                	li	a1,0
    80004200:	854a                	mv	a0,s2
    80004202:	00000097          	auipc	ra,0x0
    80004206:	d76080e7          	jalr	-650(ra) # 80003f78 <readi>
    8000420a:	47c1                	li	a5,16
    8000420c:	fcf518e3          	bne	a0,a5,800041dc <dirlookup+0x3a>
    if(de.inum == 0)
    80004210:	fc045783          	lhu	a5,-64(s0)
    80004214:	dfe1                	beqz	a5,800041ec <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004216:	fc240593          	addi	a1,s0,-62
    8000421a:	854e                	mv	a0,s3
    8000421c:	00000097          	auipc	ra,0x0
    80004220:	f6c080e7          	jalr	-148(ra) # 80004188 <namecmp>
    80004224:	f561                	bnez	a0,800041ec <dirlookup+0x4a>
      if(poff)
    80004226:	000a0463          	beqz	s4,8000422e <dirlookup+0x8c>
        *poff = off;
    8000422a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000422e:	fc045583          	lhu	a1,-64(s0)
    80004232:	00092503          	lw	a0,0(s2)
    80004236:	fffff097          	auipc	ra,0xfffff
    8000423a:	75a080e7          	jalr	1882(ra) # 80003990 <iget>
    8000423e:	a011                	j	80004242 <dirlookup+0xa0>
  return 0;
    80004240:	4501                	li	a0,0
}
    80004242:	70e2                	ld	ra,56(sp)
    80004244:	7442                	ld	s0,48(sp)
    80004246:	74a2                	ld	s1,40(sp)
    80004248:	7902                	ld	s2,32(sp)
    8000424a:	69e2                	ld	s3,24(sp)
    8000424c:	6a42                	ld	s4,16(sp)
    8000424e:	6121                	addi	sp,sp,64
    80004250:	8082                	ret

0000000080004252 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004252:	711d                	addi	sp,sp,-96
    80004254:	ec86                	sd	ra,88(sp)
    80004256:	e8a2                	sd	s0,80(sp)
    80004258:	e4a6                	sd	s1,72(sp)
    8000425a:	e0ca                	sd	s2,64(sp)
    8000425c:	fc4e                	sd	s3,56(sp)
    8000425e:	f852                	sd	s4,48(sp)
    80004260:	f456                	sd	s5,40(sp)
    80004262:	f05a                	sd	s6,32(sp)
    80004264:	ec5e                	sd	s7,24(sp)
    80004266:	e862                	sd	s8,16(sp)
    80004268:	e466                	sd	s9,8(sp)
    8000426a:	1080                	addi	s0,sp,96
    8000426c:	84aa                	mv	s1,a0
    8000426e:	8aae                	mv	s5,a1
    80004270:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004272:	00054703          	lbu	a4,0(a0)
    80004276:	02f00793          	li	a5,47
    8000427a:	02f70363          	beq	a4,a5,800042a0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000427e:	ffffe097          	auipc	ra,0xffffe
    80004282:	c9e080e7          	jalr	-866(ra) # 80001f1c <myproc>
    80004286:	15053503          	ld	a0,336(a0)
    8000428a:	00000097          	auipc	ra,0x0
    8000428e:	9fc080e7          	jalr	-1540(ra) # 80003c86 <idup>
    80004292:	89aa                	mv	s3,a0
  while(*path == '/')
    80004294:	02f00913          	li	s2,47
  len = path - s;
    80004298:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000429a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000429c:	4b85                	li	s7,1
    8000429e:	a865                	j	80004356 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800042a0:	4585                	li	a1,1
    800042a2:	4505                	li	a0,1
    800042a4:	fffff097          	auipc	ra,0xfffff
    800042a8:	6ec080e7          	jalr	1772(ra) # 80003990 <iget>
    800042ac:	89aa                	mv	s3,a0
    800042ae:	b7dd                	j	80004294 <namex+0x42>
      iunlockput(ip);
    800042b0:	854e                	mv	a0,s3
    800042b2:	00000097          	auipc	ra,0x0
    800042b6:	c74080e7          	jalr	-908(ra) # 80003f26 <iunlockput>
      return 0;
    800042ba:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800042bc:	854e                	mv	a0,s3
    800042be:	60e6                	ld	ra,88(sp)
    800042c0:	6446                	ld	s0,80(sp)
    800042c2:	64a6                	ld	s1,72(sp)
    800042c4:	6906                	ld	s2,64(sp)
    800042c6:	79e2                	ld	s3,56(sp)
    800042c8:	7a42                	ld	s4,48(sp)
    800042ca:	7aa2                	ld	s5,40(sp)
    800042cc:	7b02                	ld	s6,32(sp)
    800042ce:	6be2                	ld	s7,24(sp)
    800042d0:	6c42                	ld	s8,16(sp)
    800042d2:	6ca2                	ld	s9,8(sp)
    800042d4:	6125                	addi	sp,sp,96
    800042d6:	8082                	ret
      iunlock(ip);
    800042d8:	854e                	mv	a0,s3
    800042da:	00000097          	auipc	ra,0x0
    800042de:	aac080e7          	jalr	-1364(ra) # 80003d86 <iunlock>
      return ip;
    800042e2:	bfe9                	j	800042bc <namex+0x6a>
      iunlockput(ip);
    800042e4:	854e                	mv	a0,s3
    800042e6:	00000097          	auipc	ra,0x0
    800042ea:	c40080e7          	jalr	-960(ra) # 80003f26 <iunlockput>
      return 0;
    800042ee:	89e6                	mv	s3,s9
    800042f0:	b7f1                	j	800042bc <namex+0x6a>
  len = path - s;
    800042f2:	40b48633          	sub	a2,s1,a1
    800042f6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800042fa:	099c5463          	bge	s8,s9,80004382 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800042fe:	4639                	li	a2,14
    80004300:	8552                	mv	a0,s4
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	a52080e7          	jalr	-1454(ra) # 80000d54 <memmove>
  while(*path == '/')
    8000430a:	0004c783          	lbu	a5,0(s1)
    8000430e:	01279763          	bne	a5,s2,8000431c <namex+0xca>
    path++;
    80004312:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004314:	0004c783          	lbu	a5,0(s1)
    80004318:	ff278de3          	beq	a5,s2,80004312 <namex+0xc0>
    ilock(ip);
    8000431c:	854e                	mv	a0,s3
    8000431e:	00000097          	auipc	ra,0x0
    80004322:	9a6080e7          	jalr	-1626(ra) # 80003cc4 <ilock>
    if(ip->type != T_DIR){
    80004326:	04499783          	lh	a5,68(s3)
    8000432a:	f97793e3          	bne	a5,s7,800042b0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000432e:	000a8563          	beqz	s5,80004338 <namex+0xe6>
    80004332:	0004c783          	lbu	a5,0(s1)
    80004336:	d3cd                	beqz	a5,800042d8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004338:	865a                	mv	a2,s6
    8000433a:	85d2                	mv	a1,s4
    8000433c:	854e                	mv	a0,s3
    8000433e:	00000097          	auipc	ra,0x0
    80004342:	e64080e7          	jalr	-412(ra) # 800041a2 <dirlookup>
    80004346:	8caa                	mv	s9,a0
    80004348:	dd51                	beqz	a0,800042e4 <namex+0x92>
    iunlockput(ip);
    8000434a:	854e                	mv	a0,s3
    8000434c:	00000097          	auipc	ra,0x0
    80004350:	bda080e7          	jalr	-1062(ra) # 80003f26 <iunlockput>
    ip = next;
    80004354:	89e6                	mv	s3,s9
  while(*path == '/')
    80004356:	0004c783          	lbu	a5,0(s1)
    8000435a:	05279763          	bne	a5,s2,800043a8 <namex+0x156>
    path++;
    8000435e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004360:	0004c783          	lbu	a5,0(s1)
    80004364:	ff278de3          	beq	a5,s2,8000435e <namex+0x10c>
  if(*path == 0)
    80004368:	c79d                	beqz	a5,80004396 <namex+0x144>
    path++;
    8000436a:	85a6                	mv	a1,s1
  len = path - s;
    8000436c:	8cda                	mv	s9,s6
    8000436e:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004370:	01278963          	beq	a5,s2,80004382 <namex+0x130>
    80004374:	dfbd                	beqz	a5,800042f2 <namex+0xa0>
    path++;
    80004376:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004378:	0004c783          	lbu	a5,0(s1)
    8000437c:	ff279ce3          	bne	a5,s2,80004374 <namex+0x122>
    80004380:	bf8d                	j	800042f2 <namex+0xa0>
    memmove(name, s, len);
    80004382:	2601                	sext.w	a2,a2
    80004384:	8552                	mv	a0,s4
    80004386:	ffffd097          	auipc	ra,0xffffd
    8000438a:	9ce080e7          	jalr	-1586(ra) # 80000d54 <memmove>
    name[len] = 0;
    8000438e:	9cd2                	add	s9,s9,s4
    80004390:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004394:	bf9d                	j	8000430a <namex+0xb8>
  if(nameiparent){
    80004396:	f20a83e3          	beqz	s5,800042bc <namex+0x6a>
    iput(ip);
    8000439a:	854e                	mv	a0,s3
    8000439c:	00000097          	auipc	ra,0x0
    800043a0:	ae2080e7          	jalr	-1310(ra) # 80003e7e <iput>
    return 0;
    800043a4:	4981                	li	s3,0
    800043a6:	bf19                	j	800042bc <namex+0x6a>
  if(*path == 0)
    800043a8:	d7fd                	beqz	a5,80004396 <namex+0x144>
  while(*path != '/' && *path != 0)
    800043aa:	0004c783          	lbu	a5,0(s1)
    800043ae:	85a6                	mv	a1,s1
    800043b0:	b7d1                	j	80004374 <namex+0x122>

00000000800043b2 <dirlink>:
{
    800043b2:	7139                	addi	sp,sp,-64
    800043b4:	fc06                	sd	ra,56(sp)
    800043b6:	f822                	sd	s0,48(sp)
    800043b8:	f426                	sd	s1,40(sp)
    800043ba:	f04a                	sd	s2,32(sp)
    800043bc:	ec4e                	sd	s3,24(sp)
    800043be:	e852                	sd	s4,16(sp)
    800043c0:	0080                	addi	s0,sp,64
    800043c2:	892a                	mv	s2,a0
    800043c4:	8a2e                	mv	s4,a1
    800043c6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800043c8:	4601                	li	a2,0
    800043ca:	00000097          	auipc	ra,0x0
    800043ce:	dd8080e7          	jalr	-552(ra) # 800041a2 <dirlookup>
    800043d2:	e93d                	bnez	a0,80004448 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043d4:	04c92483          	lw	s1,76(s2)
    800043d8:	c49d                	beqz	s1,80004406 <dirlink+0x54>
    800043da:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043dc:	4741                	li	a4,16
    800043de:	86a6                	mv	a3,s1
    800043e0:	fc040613          	addi	a2,s0,-64
    800043e4:	4581                	li	a1,0
    800043e6:	854a                	mv	a0,s2
    800043e8:	00000097          	auipc	ra,0x0
    800043ec:	b90080e7          	jalr	-1136(ra) # 80003f78 <readi>
    800043f0:	47c1                	li	a5,16
    800043f2:	06f51163          	bne	a0,a5,80004454 <dirlink+0xa2>
    if(de.inum == 0)
    800043f6:	fc045783          	lhu	a5,-64(s0)
    800043fa:	c791                	beqz	a5,80004406 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043fc:	24c1                	addiw	s1,s1,16
    800043fe:	04c92783          	lw	a5,76(s2)
    80004402:	fcf4ede3          	bltu	s1,a5,800043dc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004406:	4639                	li	a2,14
    80004408:	85d2                	mv	a1,s4
    8000440a:	fc240513          	addi	a0,s0,-62
    8000440e:	ffffd097          	auipc	ra,0xffffd
    80004412:	9fe080e7          	jalr	-1538(ra) # 80000e0c <strncpy>
  de.inum = inum;
    80004416:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000441a:	4741                	li	a4,16
    8000441c:	86a6                	mv	a3,s1
    8000441e:	fc040613          	addi	a2,s0,-64
    80004422:	4581                	li	a1,0
    80004424:	854a                	mv	a0,s2
    80004426:	00000097          	auipc	ra,0x0
    8000442a:	c48080e7          	jalr	-952(ra) # 8000406e <writei>
    8000442e:	872a                	mv	a4,a0
    80004430:	47c1                	li	a5,16
  return 0;
    80004432:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004434:	02f71863          	bne	a4,a5,80004464 <dirlink+0xb2>
}
    80004438:	70e2                	ld	ra,56(sp)
    8000443a:	7442                	ld	s0,48(sp)
    8000443c:	74a2                	ld	s1,40(sp)
    8000443e:	7902                	ld	s2,32(sp)
    80004440:	69e2                	ld	s3,24(sp)
    80004442:	6a42                	ld	s4,16(sp)
    80004444:	6121                	addi	sp,sp,64
    80004446:	8082                	ret
    iput(ip);
    80004448:	00000097          	auipc	ra,0x0
    8000444c:	a36080e7          	jalr	-1482(ra) # 80003e7e <iput>
    return -1;
    80004450:	557d                	li	a0,-1
    80004452:	b7dd                	j	80004438 <dirlink+0x86>
      panic("dirlink read");
    80004454:	00004517          	auipc	a0,0x4
    80004458:	26450513          	addi	a0,a0,612 # 800086b8 <syscalls+0x1c8>
    8000445c:	ffffc097          	auipc	ra,0xffffc
    80004460:	0e4080e7          	jalr	228(ra) # 80000540 <panic>
    panic("dirlink");
    80004464:	00004517          	auipc	a0,0x4
    80004468:	37450513          	addi	a0,a0,884 # 800087d8 <syscalls+0x2e8>
    8000446c:	ffffc097          	auipc	ra,0xffffc
    80004470:	0d4080e7          	jalr	212(ra) # 80000540 <panic>

0000000080004474 <namei>:

struct inode*
namei(char *path)
{
    80004474:	1101                	addi	sp,sp,-32
    80004476:	ec06                	sd	ra,24(sp)
    80004478:	e822                	sd	s0,16(sp)
    8000447a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000447c:	fe040613          	addi	a2,s0,-32
    80004480:	4581                	li	a1,0
    80004482:	00000097          	auipc	ra,0x0
    80004486:	dd0080e7          	jalr	-560(ra) # 80004252 <namex>
}
    8000448a:	60e2                	ld	ra,24(sp)
    8000448c:	6442                	ld	s0,16(sp)
    8000448e:	6105                	addi	sp,sp,32
    80004490:	8082                	ret

0000000080004492 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004492:	1141                	addi	sp,sp,-16
    80004494:	e406                	sd	ra,8(sp)
    80004496:	e022                	sd	s0,0(sp)
    80004498:	0800                	addi	s0,sp,16
    8000449a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000449c:	4585                	li	a1,1
    8000449e:	00000097          	auipc	ra,0x0
    800044a2:	db4080e7          	jalr	-588(ra) # 80004252 <namex>
}
    800044a6:	60a2                	ld	ra,8(sp)
    800044a8:	6402                	ld	s0,0(sp)
    800044aa:	0141                	addi	sp,sp,16
    800044ac:	8082                	ret

00000000800044ae <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800044ae:	1101                	addi	sp,sp,-32
    800044b0:	ec06                	sd	ra,24(sp)
    800044b2:	e822                	sd	s0,16(sp)
    800044b4:	e426                	sd	s1,8(sp)
    800044b6:	e04a                	sd	s2,0(sp)
    800044b8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800044ba:	0001e917          	auipc	s2,0x1e
    800044be:	09690913          	addi	s2,s2,150 # 80022550 <log>
    800044c2:	01892583          	lw	a1,24(s2)
    800044c6:	02892503          	lw	a0,40(s2)
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	ff6080e7          	jalr	-10(ra) # 800034c0 <bread>
    800044d2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800044d4:	02c92683          	lw	a3,44(s2)
    800044d8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800044da:	02d05863          	blez	a3,8000450a <write_head+0x5c>
    800044de:	0001e797          	auipc	a5,0x1e
    800044e2:	0a278793          	addi	a5,a5,162 # 80022580 <log+0x30>
    800044e6:	05c50713          	addi	a4,a0,92
    800044ea:	36fd                	addiw	a3,a3,-1
    800044ec:	02069613          	slli	a2,a3,0x20
    800044f0:	01e65693          	srli	a3,a2,0x1e
    800044f4:	0001e617          	auipc	a2,0x1e
    800044f8:	09060613          	addi	a2,a2,144 # 80022584 <log+0x34>
    800044fc:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800044fe:	4390                	lw	a2,0(a5)
    80004500:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004502:	0791                	addi	a5,a5,4
    80004504:	0711                	addi	a4,a4,4
    80004506:	fed79ce3          	bne	a5,a3,800044fe <write_head+0x50>
  }
  bwrite(buf);
    8000450a:	8526                	mv	a0,s1
    8000450c:	fffff097          	auipc	ra,0xfffff
    80004510:	0a6080e7          	jalr	166(ra) # 800035b2 <bwrite>
  brelse(buf);
    80004514:	8526                	mv	a0,s1
    80004516:	fffff097          	auipc	ra,0xfffff
    8000451a:	0da080e7          	jalr	218(ra) # 800035f0 <brelse>
}
    8000451e:	60e2                	ld	ra,24(sp)
    80004520:	6442                	ld	s0,16(sp)
    80004522:	64a2                	ld	s1,8(sp)
    80004524:	6902                	ld	s2,0(sp)
    80004526:	6105                	addi	sp,sp,32
    80004528:	8082                	ret

000000008000452a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000452a:	0001e797          	auipc	a5,0x1e
    8000452e:	0527a783          	lw	a5,82(a5) # 8002257c <log+0x2c>
    80004532:	0af05663          	blez	a5,800045de <install_trans+0xb4>
{
    80004536:	7139                	addi	sp,sp,-64
    80004538:	fc06                	sd	ra,56(sp)
    8000453a:	f822                	sd	s0,48(sp)
    8000453c:	f426                	sd	s1,40(sp)
    8000453e:	f04a                	sd	s2,32(sp)
    80004540:	ec4e                	sd	s3,24(sp)
    80004542:	e852                	sd	s4,16(sp)
    80004544:	e456                	sd	s5,8(sp)
    80004546:	0080                	addi	s0,sp,64
    80004548:	0001ea97          	auipc	s5,0x1e
    8000454c:	038a8a93          	addi	s5,s5,56 # 80022580 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004550:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004552:	0001e997          	auipc	s3,0x1e
    80004556:	ffe98993          	addi	s3,s3,-2 # 80022550 <log>
    8000455a:	0189a583          	lw	a1,24(s3)
    8000455e:	014585bb          	addw	a1,a1,s4
    80004562:	2585                	addiw	a1,a1,1
    80004564:	0289a503          	lw	a0,40(s3)
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	f58080e7          	jalr	-168(ra) # 800034c0 <bread>
    80004570:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004572:	000aa583          	lw	a1,0(s5)
    80004576:	0289a503          	lw	a0,40(s3)
    8000457a:	fffff097          	auipc	ra,0xfffff
    8000457e:	f46080e7          	jalr	-186(ra) # 800034c0 <bread>
    80004582:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004584:	40000613          	li	a2,1024
    80004588:	05890593          	addi	a1,s2,88
    8000458c:	05850513          	addi	a0,a0,88
    80004590:	ffffc097          	auipc	ra,0xffffc
    80004594:	7c4080e7          	jalr	1988(ra) # 80000d54 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004598:	8526                	mv	a0,s1
    8000459a:	fffff097          	auipc	ra,0xfffff
    8000459e:	018080e7          	jalr	24(ra) # 800035b2 <bwrite>
    bunpin(dbuf);
    800045a2:	8526                	mv	a0,s1
    800045a4:	fffff097          	auipc	ra,0xfffff
    800045a8:	126080e7          	jalr	294(ra) # 800036ca <bunpin>
    brelse(lbuf);
    800045ac:	854a                	mv	a0,s2
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	042080e7          	jalr	66(ra) # 800035f0 <brelse>
    brelse(dbuf);
    800045b6:	8526                	mv	a0,s1
    800045b8:	fffff097          	auipc	ra,0xfffff
    800045bc:	038080e7          	jalr	56(ra) # 800035f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045c0:	2a05                	addiw	s4,s4,1
    800045c2:	0a91                	addi	s5,s5,4
    800045c4:	02c9a783          	lw	a5,44(s3)
    800045c8:	f8fa49e3          	blt	s4,a5,8000455a <install_trans+0x30>
}
    800045cc:	70e2                	ld	ra,56(sp)
    800045ce:	7442                	ld	s0,48(sp)
    800045d0:	74a2                	ld	s1,40(sp)
    800045d2:	7902                	ld	s2,32(sp)
    800045d4:	69e2                	ld	s3,24(sp)
    800045d6:	6a42                	ld	s4,16(sp)
    800045d8:	6aa2                	ld	s5,8(sp)
    800045da:	6121                	addi	sp,sp,64
    800045dc:	8082                	ret
    800045de:	8082                	ret

00000000800045e0 <initlog>:
{
    800045e0:	7179                	addi	sp,sp,-48
    800045e2:	f406                	sd	ra,40(sp)
    800045e4:	f022                	sd	s0,32(sp)
    800045e6:	ec26                	sd	s1,24(sp)
    800045e8:	e84a                	sd	s2,16(sp)
    800045ea:	e44e                	sd	s3,8(sp)
    800045ec:	1800                	addi	s0,sp,48
    800045ee:	892a                	mv	s2,a0
    800045f0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800045f2:	0001e497          	auipc	s1,0x1e
    800045f6:	f5e48493          	addi	s1,s1,-162 # 80022550 <log>
    800045fa:	00004597          	auipc	a1,0x4
    800045fe:	0ce58593          	addi	a1,a1,206 # 800086c8 <syscalls+0x1d8>
    80004602:	8526                	mv	a0,s1
    80004604:	ffffc097          	auipc	ra,0xffffc
    80004608:	568080e7          	jalr	1384(ra) # 80000b6c <initlock>
  log.start = sb->logstart;
    8000460c:	0149a583          	lw	a1,20(s3)
    80004610:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004612:	0109a783          	lw	a5,16(s3)
    80004616:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004618:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000461c:	854a                	mv	a0,s2
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	ea2080e7          	jalr	-350(ra) # 800034c0 <bread>
  log.lh.n = lh->n;
    80004626:	4d34                	lw	a3,88(a0)
    80004628:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000462a:	02d05663          	blez	a3,80004656 <initlog+0x76>
    8000462e:	05c50793          	addi	a5,a0,92
    80004632:	0001e717          	auipc	a4,0x1e
    80004636:	f4e70713          	addi	a4,a4,-178 # 80022580 <log+0x30>
    8000463a:	36fd                	addiw	a3,a3,-1
    8000463c:	02069613          	slli	a2,a3,0x20
    80004640:	01e65693          	srli	a3,a2,0x1e
    80004644:	06050613          	addi	a2,a0,96
    80004648:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000464a:	4390                	lw	a2,0(a5)
    8000464c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000464e:	0791                	addi	a5,a5,4
    80004650:	0711                	addi	a4,a4,4
    80004652:	fed79ce3          	bne	a5,a3,8000464a <initlog+0x6a>
  brelse(buf);
    80004656:	fffff097          	auipc	ra,0xfffff
    8000465a:	f9a080e7          	jalr	-102(ra) # 800035f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    8000465e:	00000097          	auipc	ra,0x0
    80004662:	ecc080e7          	jalr	-308(ra) # 8000452a <install_trans>
  log.lh.n = 0;
    80004666:	0001e797          	auipc	a5,0x1e
    8000466a:	f007ab23          	sw	zero,-234(a5) # 8002257c <log+0x2c>
  write_head(); // clear the log
    8000466e:	00000097          	auipc	ra,0x0
    80004672:	e40080e7          	jalr	-448(ra) # 800044ae <write_head>
}
    80004676:	70a2                	ld	ra,40(sp)
    80004678:	7402                	ld	s0,32(sp)
    8000467a:	64e2                	ld	s1,24(sp)
    8000467c:	6942                	ld	s2,16(sp)
    8000467e:	69a2                	ld	s3,8(sp)
    80004680:	6145                	addi	sp,sp,48
    80004682:	8082                	ret

0000000080004684 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004684:	1101                	addi	sp,sp,-32
    80004686:	ec06                	sd	ra,24(sp)
    80004688:	e822                	sd	s0,16(sp)
    8000468a:	e426                	sd	s1,8(sp)
    8000468c:	e04a                	sd	s2,0(sp)
    8000468e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004690:	0001e517          	auipc	a0,0x1e
    80004694:	ec050513          	addi	a0,a0,-320 # 80022550 <log>
    80004698:	ffffc097          	auipc	ra,0xffffc
    8000469c:	564080e7          	jalr	1380(ra) # 80000bfc <acquire>
  while(1){
    if(log.committing){
    800046a0:	0001e497          	auipc	s1,0x1e
    800046a4:	eb048493          	addi	s1,s1,-336 # 80022550 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046a8:	4979                	li	s2,30
    800046aa:	a039                	j	800046b8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800046ac:	85a6                	mv	a1,s1
    800046ae:	8526                	mv	a0,s1
    800046b0:	ffffe097          	auipc	ra,0xffffe
    800046b4:	0ec080e7          	jalr	236(ra) # 8000279c <sleep>
    if(log.committing){
    800046b8:	50dc                	lw	a5,36(s1)
    800046ba:	fbed                	bnez	a5,800046ac <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046bc:	509c                	lw	a5,32(s1)
    800046be:	0017871b          	addiw	a4,a5,1
    800046c2:	0007069b          	sext.w	a3,a4
    800046c6:	0027179b          	slliw	a5,a4,0x2
    800046ca:	9fb9                	addw	a5,a5,a4
    800046cc:	0017979b          	slliw	a5,a5,0x1
    800046d0:	54d8                	lw	a4,44(s1)
    800046d2:	9fb9                	addw	a5,a5,a4
    800046d4:	00f95963          	bge	s2,a5,800046e6 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800046d8:	85a6                	mv	a1,s1
    800046da:	8526                	mv	a0,s1
    800046dc:	ffffe097          	auipc	ra,0xffffe
    800046e0:	0c0080e7          	jalr	192(ra) # 8000279c <sleep>
    800046e4:	bfd1                	j	800046b8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800046e6:	0001e517          	auipc	a0,0x1e
    800046ea:	e6a50513          	addi	a0,a0,-406 # 80022550 <log>
    800046ee:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800046f0:	ffffc097          	auipc	ra,0xffffc
    800046f4:	5c0080e7          	jalr	1472(ra) # 80000cb0 <release>
      break;
    }
  }
}
    800046f8:	60e2                	ld	ra,24(sp)
    800046fa:	6442                	ld	s0,16(sp)
    800046fc:	64a2                	ld	s1,8(sp)
    800046fe:	6902                	ld	s2,0(sp)
    80004700:	6105                	addi	sp,sp,32
    80004702:	8082                	ret

0000000080004704 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004704:	7139                	addi	sp,sp,-64
    80004706:	fc06                	sd	ra,56(sp)
    80004708:	f822                	sd	s0,48(sp)
    8000470a:	f426                	sd	s1,40(sp)
    8000470c:	f04a                	sd	s2,32(sp)
    8000470e:	ec4e                	sd	s3,24(sp)
    80004710:	e852                	sd	s4,16(sp)
    80004712:	e456                	sd	s5,8(sp)
    80004714:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004716:	0001e497          	auipc	s1,0x1e
    8000471a:	e3a48493          	addi	s1,s1,-454 # 80022550 <log>
    8000471e:	8526                	mv	a0,s1
    80004720:	ffffc097          	auipc	ra,0xffffc
    80004724:	4dc080e7          	jalr	1244(ra) # 80000bfc <acquire>
  log.outstanding -= 1;
    80004728:	509c                	lw	a5,32(s1)
    8000472a:	37fd                	addiw	a5,a5,-1
    8000472c:	0007891b          	sext.w	s2,a5
    80004730:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004732:	50dc                	lw	a5,36(s1)
    80004734:	e7b9                	bnez	a5,80004782 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004736:	04091e63          	bnez	s2,80004792 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000473a:	0001e497          	auipc	s1,0x1e
    8000473e:	e1648493          	addi	s1,s1,-490 # 80022550 <log>
    80004742:	4785                	li	a5,1
    80004744:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004746:	8526                	mv	a0,s1
    80004748:	ffffc097          	auipc	ra,0xffffc
    8000474c:	568080e7          	jalr	1384(ra) # 80000cb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004750:	54dc                	lw	a5,44(s1)
    80004752:	06f04763          	bgtz	a5,800047c0 <end_op+0xbc>
    acquire(&log.lock);
    80004756:	0001e497          	auipc	s1,0x1e
    8000475a:	dfa48493          	addi	s1,s1,-518 # 80022550 <log>
    8000475e:	8526                	mv	a0,s1
    80004760:	ffffc097          	auipc	ra,0xffffc
    80004764:	49c080e7          	jalr	1180(ra) # 80000bfc <acquire>
    log.committing = 0;
    80004768:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000476c:	8526                	mv	a0,s1
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	1ae080e7          	jalr	430(ra) # 8000291c <wakeup>
    release(&log.lock);
    80004776:	8526                	mv	a0,s1
    80004778:	ffffc097          	auipc	ra,0xffffc
    8000477c:	538080e7          	jalr	1336(ra) # 80000cb0 <release>
}
    80004780:	a03d                	j	800047ae <end_op+0xaa>
    panic("log.committing");
    80004782:	00004517          	auipc	a0,0x4
    80004786:	f4e50513          	addi	a0,a0,-178 # 800086d0 <syscalls+0x1e0>
    8000478a:	ffffc097          	auipc	ra,0xffffc
    8000478e:	db6080e7          	jalr	-586(ra) # 80000540 <panic>
    wakeup(&log);
    80004792:	0001e497          	auipc	s1,0x1e
    80004796:	dbe48493          	addi	s1,s1,-578 # 80022550 <log>
    8000479a:	8526                	mv	a0,s1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	180080e7          	jalr	384(ra) # 8000291c <wakeup>
  release(&log.lock);
    800047a4:	8526                	mv	a0,s1
    800047a6:	ffffc097          	auipc	ra,0xffffc
    800047aa:	50a080e7          	jalr	1290(ra) # 80000cb0 <release>
}
    800047ae:	70e2                	ld	ra,56(sp)
    800047b0:	7442                	ld	s0,48(sp)
    800047b2:	74a2                	ld	s1,40(sp)
    800047b4:	7902                	ld	s2,32(sp)
    800047b6:	69e2                	ld	s3,24(sp)
    800047b8:	6a42                	ld	s4,16(sp)
    800047ba:	6aa2                	ld	s5,8(sp)
    800047bc:	6121                	addi	sp,sp,64
    800047be:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800047c0:	0001ea97          	auipc	s5,0x1e
    800047c4:	dc0a8a93          	addi	s5,s5,-576 # 80022580 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800047c8:	0001ea17          	auipc	s4,0x1e
    800047cc:	d88a0a13          	addi	s4,s4,-632 # 80022550 <log>
    800047d0:	018a2583          	lw	a1,24(s4)
    800047d4:	012585bb          	addw	a1,a1,s2
    800047d8:	2585                	addiw	a1,a1,1
    800047da:	028a2503          	lw	a0,40(s4)
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	ce2080e7          	jalr	-798(ra) # 800034c0 <bread>
    800047e6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800047e8:	000aa583          	lw	a1,0(s5)
    800047ec:	028a2503          	lw	a0,40(s4)
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	cd0080e7          	jalr	-816(ra) # 800034c0 <bread>
    800047f8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800047fa:	40000613          	li	a2,1024
    800047fe:	05850593          	addi	a1,a0,88
    80004802:	05848513          	addi	a0,s1,88
    80004806:	ffffc097          	auipc	ra,0xffffc
    8000480a:	54e080e7          	jalr	1358(ra) # 80000d54 <memmove>
    bwrite(to);  // write the log
    8000480e:	8526                	mv	a0,s1
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	da2080e7          	jalr	-606(ra) # 800035b2 <bwrite>
    brelse(from);
    80004818:	854e                	mv	a0,s3
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	dd6080e7          	jalr	-554(ra) # 800035f0 <brelse>
    brelse(to);
    80004822:	8526                	mv	a0,s1
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	dcc080e7          	jalr	-564(ra) # 800035f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000482c:	2905                	addiw	s2,s2,1
    8000482e:	0a91                	addi	s5,s5,4
    80004830:	02ca2783          	lw	a5,44(s4)
    80004834:	f8f94ee3          	blt	s2,a5,800047d0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004838:	00000097          	auipc	ra,0x0
    8000483c:	c76080e7          	jalr	-906(ra) # 800044ae <write_head>
    install_trans(); // Now install writes to home locations
    80004840:	00000097          	auipc	ra,0x0
    80004844:	cea080e7          	jalr	-790(ra) # 8000452a <install_trans>
    log.lh.n = 0;
    80004848:	0001e797          	auipc	a5,0x1e
    8000484c:	d207aa23          	sw	zero,-716(a5) # 8002257c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004850:	00000097          	auipc	ra,0x0
    80004854:	c5e080e7          	jalr	-930(ra) # 800044ae <write_head>
    80004858:	bdfd                	j	80004756 <end_op+0x52>

000000008000485a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000485a:	1101                	addi	sp,sp,-32
    8000485c:	ec06                	sd	ra,24(sp)
    8000485e:	e822                	sd	s0,16(sp)
    80004860:	e426                	sd	s1,8(sp)
    80004862:	e04a                	sd	s2,0(sp)
    80004864:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004866:	0001e717          	auipc	a4,0x1e
    8000486a:	d1672703          	lw	a4,-746(a4) # 8002257c <log+0x2c>
    8000486e:	47f5                	li	a5,29
    80004870:	08e7c063          	blt	a5,a4,800048f0 <log_write+0x96>
    80004874:	84aa                	mv	s1,a0
    80004876:	0001e797          	auipc	a5,0x1e
    8000487a:	cf67a783          	lw	a5,-778(a5) # 8002256c <log+0x1c>
    8000487e:	37fd                	addiw	a5,a5,-1
    80004880:	06f75863          	bge	a4,a5,800048f0 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004884:	0001e797          	auipc	a5,0x1e
    80004888:	cec7a783          	lw	a5,-788(a5) # 80022570 <log+0x20>
    8000488c:	06f05a63          	blez	a5,80004900 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004890:	0001e917          	auipc	s2,0x1e
    80004894:	cc090913          	addi	s2,s2,-832 # 80022550 <log>
    80004898:	854a                	mv	a0,s2
    8000489a:	ffffc097          	auipc	ra,0xffffc
    8000489e:	362080e7          	jalr	866(ra) # 80000bfc <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800048a2:	02c92603          	lw	a2,44(s2)
    800048a6:	06c05563          	blez	a2,80004910 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800048aa:	44cc                	lw	a1,12(s1)
    800048ac:	0001e717          	auipc	a4,0x1e
    800048b0:	cd470713          	addi	a4,a4,-812 # 80022580 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800048b4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800048b6:	4314                	lw	a3,0(a4)
    800048b8:	04b68d63          	beq	a3,a1,80004912 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800048bc:	2785                	addiw	a5,a5,1
    800048be:	0711                	addi	a4,a4,4
    800048c0:	fec79be3          	bne	a5,a2,800048b6 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800048c4:	0621                	addi	a2,a2,8
    800048c6:	060a                	slli	a2,a2,0x2
    800048c8:	0001e797          	auipc	a5,0x1e
    800048cc:	c8878793          	addi	a5,a5,-888 # 80022550 <log>
    800048d0:	963e                	add	a2,a2,a5
    800048d2:	44dc                	lw	a5,12(s1)
    800048d4:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800048d6:	8526                	mv	a0,s1
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	db6080e7          	jalr	-586(ra) # 8000368e <bpin>
    log.lh.n++;
    800048e0:	0001e717          	auipc	a4,0x1e
    800048e4:	c7070713          	addi	a4,a4,-912 # 80022550 <log>
    800048e8:	575c                	lw	a5,44(a4)
    800048ea:	2785                	addiw	a5,a5,1
    800048ec:	d75c                	sw	a5,44(a4)
    800048ee:	a83d                	j	8000492c <log_write+0xd2>
    panic("too big a transaction");
    800048f0:	00004517          	auipc	a0,0x4
    800048f4:	df050513          	addi	a0,a0,-528 # 800086e0 <syscalls+0x1f0>
    800048f8:	ffffc097          	auipc	ra,0xffffc
    800048fc:	c48080e7          	jalr	-952(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    80004900:	00004517          	auipc	a0,0x4
    80004904:	df850513          	addi	a0,a0,-520 # 800086f8 <syscalls+0x208>
    80004908:	ffffc097          	auipc	ra,0xffffc
    8000490c:	c38080e7          	jalr	-968(ra) # 80000540 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004910:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004912:	00878713          	addi	a4,a5,8
    80004916:	00271693          	slli	a3,a4,0x2
    8000491a:	0001e717          	auipc	a4,0x1e
    8000491e:	c3670713          	addi	a4,a4,-970 # 80022550 <log>
    80004922:	9736                	add	a4,a4,a3
    80004924:	44d4                	lw	a3,12(s1)
    80004926:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004928:	faf607e3          	beq	a2,a5,800048d6 <log_write+0x7c>
  }
  release(&log.lock);
    8000492c:	0001e517          	auipc	a0,0x1e
    80004930:	c2450513          	addi	a0,a0,-988 # 80022550 <log>
    80004934:	ffffc097          	auipc	ra,0xffffc
    80004938:	37c080e7          	jalr	892(ra) # 80000cb0 <release>
}
    8000493c:	60e2                	ld	ra,24(sp)
    8000493e:	6442                	ld	s0,16(sp)
    80004940:	64a2                	ld	s1,8(sp)
    80004942:	6902                	ld	s2,0(sp)
    80004944:	6105                	addi	sp,sp,32
    80004946:	8082                	ret

0000000080004948 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004948:	1101                	addi	sp,sp,-32
    8000494a:	ec06                	sd	ra,24(sp)
    8000494c:	e822                	sd	s0,16(sp)
    8000494e:	e426                	sd	s1,8(sp)
    80004950:	e04a                	sd	s2,0(sp)
    80004952:	1000                	addi	s0,sp,32
    80004954:	84aa                	mv	s1,a0
    80004956:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004958:	00004597          	auipc	a1,0x4
    8000495c:	dc058593          	addi	a1,a1,-576 # 80008718 <syscalls+0x228>
    80004960:	0521                	addi	a0,a0,8
    80004962:	ffffc097          	auipc	ra,0xffffc
    80004966:	20a080e7          	jalr	522(ra) # 80000b6c <initlock>
  lk->name = name;
    8000496a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000496e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004972:	0204a423          	sw	zero,40(s1)
}
    80004976:	60e2                	ld	ra,24(sp)
    80004978:	6442                	ld	s0,16(sp)
    8000497a:	64a2                	ld	s1,8(sp)
    8000497c:	6902                	ld	s2,0(sp)
    8000497e:	6105                	addi	sp,sp,32
    80004980:	8082                	ret

0000000080004982 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004982:	1101                	addi	sp,sp,-32
    80004984:	ec06                	sd	ra,24(sp)
    80004986:	e822                	sd	s0,16(sp)
    80004988:	e426                	sd	s1,8(sp)
    8000498a:	e04a                	sd	s2,0(sp)
    8000498c:	1000                	addi	s0,sp,32
    8000498e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004990:	00850913          	addi	s2,a0,8
    80004994:	854a                	mv	a0,s2
    80004996:	ffffc097          	auipc	ra,0xffffc
    8000499a:	266080e7          	jalr	614(ra) # 80000bfc <acquire>
  while (lk->locked) {
    8000499e:	409c                	lw	a5,0(s1)
    800049a0:	cb89                	beqz	a5,800049b2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800049a2:	85ca                	mv	a1,s2
    800049a4:	8526                	mv	a0,s1
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	df6080e7          	jalr	-522(ra) # 8000279c <sleep>
  while (lk->locked) {
    800049ae:	409c                	lw	a5,0(s1)
    800049b0:	fbed                	bnez	a5,800049a2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800049b2:	4785                	li	a5,1
    800049b4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800049b6:	ffffd097          	auipc	ra,0xffffd
    800049ba:	566080e7          	jalr	1382(ra) # 80001f1c <myproc>
    800049be:	5d1c                	lw	a5,56(a0)
    800049c0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800049c2:	854a                	mv	a0,s2
    800049c4:	ffffc097          	auipc	ra,0xffffc
    800049c8:	2ec080e7          	jalr	748(ra) # 80000cb0 <release>
}
    800049cc:	60e2                	ld	ra,24(sp)
    800049ce:	6442                	ld	s0,16(sp)
    800049d0:	64a2                	ld	s1,8(sp)
    800049d2:	6902                	ld	s2,0(sp)
    800049d4:	6105                	addi	sp,sp,32
    800049d6:	8082                	ret

00000000800049d8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800049d8:	1101                	addi	sp,sp,-32
    800049da:	ec06                	sd	ra,24(sp)
    800049dc:	e822                	sd	s0,16(sp)
    800049de:	e426                	sd	s1,8(sp)
    800049e0:	e04a                	sd	s2,0(sp)
    800049e2:	1000                	addi	s0,sp,32
    800049e4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049e6:	00850913          	addi	s2,a0,8
    800049ea:	854a                	mv	a0,s2
    800049ec:	ffffc097          	auipc	ra,0xffffc
    800049f0:	210080e7          	jalr	528(ra) # 80000bfc <acquire>
  lk->locked = 0;
    800049f4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049f8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800049fc:	8526                	mv	a0,s1
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	f1e080e7          	jalr	-226(ra) # 8000291c <wakeup>
  release(&lk->lk);
    80004a06:	854a                	mv	a0,s2
    80004a08:	ffffc097          	auipc	ra,0xffffc
    80004a0c:	2a8080e7          	jalr	680(ra) # 80000cb0 <release>
}
    80004a10:	60e2                	ld	ra,24(sp)
    80004a12:	6442                	ld	s0,16(sp)
    80004a14:	64a2                	ld	s1,8(sp)
    80004a16:	6902                	ld	s2,0(sp)
    80004a18:	6105                	addi	sp,sp,32
    80004a1a:	8082                	ret

0000000080004a1c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a1c:	7179                	addi	sp,sp,-48
    80004a1e:	f406                	sd	ra,40(sp)
    80004a20:	f022                	sd	s0,32(sp)
    80004a22:	ec26                	sd	s1,24(sp)
    80004a24:	e84a                	sd	s2,16(sp)
    80004a26:	e44e                	sd	s3,8(sp)
    80004a28:	1800                	addi	s0,sp,48
    80004a2a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a2c:	00850913          	addi	s2,a0,8
    80004a30:	854a                	mv	a0,s2
    80004a32:	ffffc097          	auipc	ra,0xffffc
    80004a36:	1ca080e7          	jalr	458(ra) # 80000bfc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a3a:	409c                	lw	a5,0(s1)
    80004a3c:	ef99                	bnez	a5,80004a5a <holdingsleep+0x3e>
    80004a3e:	4481                	li	s1,0
  release(&lk->lk);
    80004a40:	854a                	mv	a0,s2
    80004a42:	ffffc097          	auipc	ra,0xffffc
    80004a46:	26e080e7          	jalr	622(ra) # 80000cb0 <release>
  return r;
}
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	70a2                	ld	ra,40(sp)
    80004a4e:	7402                	ld	s0,32(sp)
    80004a50:	64e2                	ld	s1,24(sp)
    80004a52:	6942                	ld	s2,16(sp)
    80004a54:	69a2                	ld	s3,8(sp)
    80004a56:	6145                	addi	sp,sp,48
    80004a58:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a5a:	0284a983          	lw	s3,40(s1)
    80004a5e:	ffffd097          	auipc	ra,0xffffd
    80004a62:	4be080e7          	jalr	1214(ra) # 80001f1c <myproc>
    80004a66:	5d04                	lw	s1,56(a0)
    80004a68:	413484b3          	sub	s1,s1,s3
    80004a6c:	0014b493          	seqz	s1,s1
    80004a70:	bfc1                	j	80004a40 <holdingsleep+0x24>

0000000080004a72 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004a72:	1141                	addi	sp,sp,-16
    80004a74:	e406                	sd	ra,8(sp)
    80004a76:	e022                	sd	s0,0(sp)
    80004a78:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004a7a:	00004597          	auipc	a1,0x4
    80004a7e:	cae58593          	addi	a1,a1,-850 # 80008728 <syscalls+0x238>
    80004a82:	0001e517          	auipc	a0,0x1e
    80004a86:	c1650513          	addi	a0,a0,-1002 # 80022698 <ftable>
    80004a8a:	ffffc097          	auipc	ra,0xffffc
    80004a8e:	0e2080e7          	jalr	226(ra) # 80000b6c <initlock>
}
    80004a92:	60a2                	ld	ra,8(sp)
    80004a94:	6402                	ld	s0,0(sp)
    80004a96:	0141                	addi	sp,sp,16
    80004a98:	8082                	ret

0000000080004a9a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a9a:	1101                	addi	sp,sp,-32
    80004a9c:	ec06                	sd	ra,24(sp)
    80004a9e:	e822                	sd	s0,16(sp)
    80004aa0:	e426                	sd	s1,8(sp)
    80004aa2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004aa4:	0001e517          	auipc	a0,0x1e
    80004aa8:	bf450513          	addi	a0,a0,-1036 # 80022698 <ftable>
    80004aac:	ffffc097          	auipc	ra,0xffffc
    80004ab0:	150080e7          	jalr	336(ra) # 80000bfc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004ab4:	0001e497          	auipc	s1,0x1e
    80004ab8:	bfc48493          	addi	s1,s1,-1028 # 800226b0 <ftable+0x18>
    80004abc:	0001f717          	auipc	a4,0x1f
    80004ac0:	b9470713          	addi	a4,a4,-1132 # 80023650 <ftable+0xfb8>
    if(f->ref == 0){
    80004ac4:	40dc                	lw	a5,4(s1)
    80004ac6:	cf99                	beqz	a5,80004ae4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004ac8:	02848493          	addi	s1,s1,40
    80004acc:	fee49ce3          	bne	s1,a4,80004ac4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004ad0:	0001e517          	auipc	a0,0x1e
    80004ad4:	bc850513          	addi	a0,a0,-1080 # 80022698 <ftable>
    80004ad8:	ffffc097          	auipc	ra,0xffffc
    80004adc:	1d8080e7          	jalr	472(ra) # 80000cb0 <release>
  return 0;
    80004ae0:	4481                	li	s1,0
    80004ae2:	a819                	j	80004af8 <filealloc+0x5e>
      f->ref = 1;
    80004ae4:	4785                	li	a5,1
    80004ae6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004ae8:	0001e517          	auipc	a0,0x1e
    80004aec:	bb050513          	addi	a0,a0,-1104 # 80022698 <ftable>
    80004af0:	ffffc097          	auipc	ra,0xffffc
    80004af4:	1c0080e7          	jalr	448(ra) # 80000cb0 <release>
}
    80004af8:	8526                	mv	a0,s1
    80004afa:	60e2                	ld	ra,24(sp)
    80004afc:	6442                	ld	s0,16(sp)
    80004afe:	64a2                	ld	s1,8(sp)
    80004b00:	6105                	addi	sp,sp,32
    80004b02:	8082                	ret

0000000080004b04 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b04:	1101                	addi	sp,sp,-32
    80004b06:	ec06                	sd	ra,24(sp)
    80004b08:	e822                	sd	s0,16(sp)
    80004b0a:	e426                	sd	s1,8(sp)
    80004b0c:	1000                	addi	s0,sp,32
    80004b0e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b10:	0001e517          	auipc	a0,0x1e
    80004b14:	b8850513          	addi	a0,a0,-1144 # 80022698 <ftable>
    80004b18:	ffffc097          	auipc	ra,0xffffc
    80004b1c:	0e4080e7          	jalr	228(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    80004b20:	40dc                	lw	a5,4(s1)
    80004b22:	02f05263          	blez	a5,80004b46 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004b26:	2785                	addiw	a5,a5,1
    80004b28:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b2a:	0001e517          	auipc	a0,0x1e
    80004b2e:	b6e50513          	addi	a0,a0,-1170 # 80022698 <ftable>
    80004b32:	ffffc097          	auipc	ra,0xffffc
    80004b36:	17e080e7          	jalr	382(ra) # 80000cb0 <release>
  return f;
}
    80004b3a:	8526                	mv	a0,s1
    80004b3c:	60e2                	ld	ra,24(sp)
    80004b3e:	6442                	ld	s0,16(sp)
    80004b40:	64a2                	ld	s1,8(sp)
    80004b42:	6105                	addi	sp,sp,32
    80004b44:	8082                	ret
    panic("filedup");
    80004b46:	00004517          	auipc	a0,0x4
    80004b4a:	bea50513          	addi	a0,a0,-1046 # 80008730 <syscalls+0x240>
    80004b4e:	ffffc097          	auipc	ra,0xffffc
    80004b52:	9f2080e7          	jalr	-1550(ra) # 80000540 <panic>

0000000080004b56 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b56:	7139                	addi	sp,sp,-64
    80004b58:	fc06                	sd	ra,56(sp)
    80004b5a:	f822                	sd	s0,48(sp)
    80004b5c:	f426                	sd	s1,40(sp)
    80004b5e:	f04a                	sd	s2,32(sp)
    80004b60:	ec4e                	sd	s3,24(sp)
    80004b62:	e852                	sd	s4,16(sp)
    80004b64:	e456                	sd	s5,8(sp)
    80004b66:	0080                	addi	s0,sp,64
    80004b68:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b6a:	0001e517          	auipc	a0,0x1e
    80004b6e:	b2e50513          	addi	a0,a0,-1234 # 80022698 <ftable>
    80004b72:	ffffc097          	auipc	ra,0xffffc
    80004b76:	08a080e7          	jalr	138(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    80004b7a:	40dc                	lw	a5,4(s1)
    80004b7c:	06f05163          	blez	a5,80004bde <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004b80:	37fd                	addiw	a5,a5,-1
    80004b82:	0007871b          	sext.w	a4,a5
    80004b86:	c0dc                	sw	a5,4(s1)
    80004b88:	06e04363          	bgtz	a4,80004bee <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b8c:	0004a903          	lw	s2,0(s1)
    80004b90:	0094ca83          	lbu	s5,9(s1)
    80004b94:	0104ba03          	ld	s4,16(s1)
    80004b98:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004b9c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004ba0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004ba4:	0001e517          	auipc	a0,0x1e
    80004ba8:	af450513          	addi	a0,a0,-1292 # 80022698 <ftable>
    80004bac:	ffffc097          	auipc	ra,0xffffc
    80004bb0:	104080e7          	jalr	260(ra) # 80000cb0 <release>

  if(ff.type == FD_PIPE){
    80004bb4:	4785                	li	a5,1
    80004bb6:	04f90d63          	beq	s2,a5,80004c10 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004bba:	3979                	addiw	s2,s2,-2
    80004bbc:	4785                	li	a5,1
    80004bbe:	0527e063          	bltu	a5,s2,80004bfe <fileclose+0xa8>
    begin_op();
    80004bc2:	00000097          	auipc	ra,0x0
    80004bc6:	ac2080e7          	jalr	-1342(ra) # 80004684 <begin_op>
    iput(ff.ip);
    80004bca:	854e                	mv	a0,s3
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	2b2080e7          	jalr	690(ra) # 80003e7e <iput>
    end_op();
    80004bd4:	00000097          	auipc	ra,0x0
    80004bd8:	b30080e7          	jalr	-1232(ra) # 80004704 <end_op>
    80004bdc:	a00d                	j	80004bfe <fileclose+0xa8>
    panic("fileclose");
    80004bde:	00004517          	auipc	a0,0x4
    80004be2:	b5a50513          	addi	a0,a0,-1190 # 80008738 <syscalls+0x248>
    80004be6:	ffffc097          	auipc	ra,0xffffc
    80004bea:	95a080e7          	jalr	-1702(ra) # 80000540 <panic>
    release(&ftable.lock);
    80004bee:	0001e517          	auipc	a0,0x1e
    80004bf2:	aaa50513          	addi	a0,a0,-1366 # 80022698 <ftable>
    80004bf6:	ffffc097          	auipc	ra,0xffffc
    80004bfa:	0ba080e7          	jalr	186(ra) # 80000cb0 <release>
  }
}
    80004bfe:	70e2                	ld	ra,56(sp)
    80004c00:	7442                	ld	s0,48(sp)
    80004c02:	74a2                	ld	s1,40(sp)
    80004c04:	7902                	ld	s2,32(sp)
    80004c06:	69e2                	ld	s3,24(sp)
    80004c08:	6a42                	ld	s4,16(sp)
    80004c0a:	6aa2                	ld	s5,8(sp)
    80004c0c:	6121                	addi	sp,sp,64
    80004c0e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c10:	85d6                	mv	a1,s5
    80004c12:	8552                	mv	a0,s4
    80004c14:	00000097          	auipc	ra,0x0
    80004c18:	372080e7          	jalr	882(ra) # 80004f86 <pipeclose>
    80004c1c:	b7cd                	j	80004bfe <fileclose+0xa8>

0000000080004c1e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c1e:	715d                	addi	sp,sp,-80
    80004c20:	e486                	sd	ra,72(sp)
    80004c22:	e0a2                	sd	s0,64(sp)
    80004c24:	fc26                	sd	s1,56(sp)
    80004c26:	f84a                	sd	s2,48(sp)
    80004c28:	f44e                	sd	s3,40(sp)
    80004c2a:	0880                	addi	s0,sp,80
    80004c2c:	84aa                	mv	s1,a0
    80004c2e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004c30:	ffffd097          	auipc	ra,0xffffd
    80004c34:	2ec080e7          	jalr	748(ra) # 80001f1c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c38:	409c                	lw	a5,0(s1)
    80004c3a:	37f9                	addiw	a5,a5,-2
    80004c3c:	4705                	li	a4,1
    80004c3e:	04f76763          	bltu	a4,a5,80004c8c <filestat+0x6e>
    80004c42:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c44:	6c88                	ld	a0,24(s1)
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	07e080e7          	jalr	126(ra) # 80003cc4 <ilock>
    stati(f->ip, &st);
    80004c4e:	fb840593          	addi	a1,s0,-72
    80004c52:	6c88                	ld	a0,24(s1)
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	2fa080e7          	jalr	762(ra) # 80003f4e <stati>
    iunlock(f->ip);
    80004c5c:	6c88                	ld	a0,24(s1)
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	128080e7          	jalr	296(ra) # 80003d86 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004c66:	46e1                	li	a3,24
    80004c68:	fb840613          	addi	a2,s0,-72
    80004c6c:	85ce                	mv	a1,s3
    80004c6e:	05093503          	ld	a0,80(s2)
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	a38080e7          	jalr	-1480(ra) # 800016aa <copyout>
    80004c7a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004c7e:	60a6                	ld	ra,72(sp)
    80004c80:	6406                	ld	s0,64(sp)
    80004c82:	74e2                	ld	s1,56(sp)
    80004c84:	7942                	ld	s2,48(sp)
    80004c86:	79a2                	ld	s3,40(sp)
    80004c88:	6161                	addi	sp,sp,80
    80004c8a:	8082                	ret
  return -1;
    80004c8c:	557d                	li	a0,-1
    80004c8e:	bfc5                	j	80004c7e <filestat+0x60>

0000000080004c90 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c90:	7179                	addi	sp,sp,-48
    80004c92:	f406                	sd	ra,40(sp)
    80004c94:	f022                	sd	s0,32(sp)
    80004c96:	ec26                	sd	s1,24(sp)
    80004c98:	e84a                	sd	s2,16(sp)
    80004c9a:	e44e                	sd	s3,8(sp)
    80004c9c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c9e:	00854783          	lbu	a5,8(a0)
    80004ca2:	c3d5                	beqz	a5,80004d46 <fileread+0xb6>
    80004ca4:	84aa                	mv	s1,a0
    80004ca6:	89ae                	mv	s3,a1
    80004ca8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004caa:	411c                	lw	a5,0(a0)
    80004cac:	4705                	li	a4,1
    80004cae:	04e78963          	beq	a5,a4,80004d00 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cb2:	470d                	li	a4,3
    80004cb4:	04e78d63          	beq	a5,a4,80004d0e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004cb8:	4709                	li	a4,2
    80004cba:	06e79e63          	bne	a5,a4,80004d36 <fileread+0xa6>
    ilock(f->ip);
    80004cbe:	6d08                	ld	a0,24(a0)
    80004cc0:	fffff097          	auipc	ra,0xfffff
    80004cc4:	004080e7          	jalr	4(ra) # 80003cc4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004cc8:	874a                	mv	a4,s2
    80004cca:	5094                	lw	a3,32(s1)
    80004ccc:	864e                	mv	a2,s3
    80004cce:	4585                	li	a1,1
    80004cd0:	6c88                	ld	a0,24(s1)
    80004cd2:	fffff097          	auipc	ra,0xfffff
    80004cd6:	2a6080e7          	jalr	678(ra) # 80003f78 <readi>
    80004cda:	892a                	mv	s2,a0
    80004cdc:	00a05563          	blez	a0,80004ce6 <fileread+0x56>
      f->off += r;
    80004ce0:	509c                	lw	a5,32(s1)
    80004ce2:	9fa9                	addw	a5,a5,a0
    80004ce4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ce6:	6c88                	ld	a0,24(s1)
    80004ce8:	fffff097          	auipc	ra,0xfffff
    80004cec:	09e080e7          	jalr	158(ra) # 80003d86 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004cf0:	854a                	mv	a0,s2
    80004cf2:	70a2                	ld	ra,40(sp)
    80004cf4:	7402                	ld	s0,32(sp)
    80004cf6:	64e2                	ld	s1,24(sp)
    80004cf8:	6942                	ld	s2,16(sp)
    80004cfa:	69a2                	ld	s3,8(sp)
    80004cfc:	6145                	addi	sp,sp,48
    80004cfe:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d00:	6908                	ld	a0,16(a0)
    80004d02:	00000097          	auipc	ra,0x0
    80004d06:	3f4080e7          	jalr	1012(ra) # 800050f6 <piperead>
    80004d0a:	892a                	mv	s2,a0
    80004d0c:	b7d5                	j	80004cf0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d0e:	02451783          	lh	a5,36(a0)
    80004d12:	03079693          	slli	a3,a5,0x30
    80004d16:	92c1                	srli	a3,a3,0x30
    80004d18:	4725                	li	a4,9
    80004d1a:	02d76863          	bltu	a4,a3,80004d4a <fileread+0xba>
    80004d1e:	0792                	slli	a5,a5,0x4
    80004d20:	0001e717          	auipc	a4,0x1e
    80004d24:	8d870713          	addi	a4,a4,-1832 # 800225f8 <devsw>
    80004d28:	97ba                	add	a5,a5,a4
    80004d2a:	639c                	ld	a5,0(a5)
    80004d2c:	c38d                	beqz	a5,80004d4e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004d2e:	4505                	li	a0,1
    80004d30:	9782                	jalr	a5
    80004d32:	892a                	mv	s2,a0
    80004d34:	bf75                	j	80004cf0 <fileread+0x60>
    panic("fileread");
    80004d36:	00004517          	auipc	a0,0x4
    80004d3a:	a1250513          	addi	a0,a0,-1518 # 80008748 <syscalls+0x258>
    80004d3e:	ffffc097          	auipc	ra,0xffffc
    80004d42:	802080e7          	jalr	-2046(ra) # 80000540 <panic>
    return -1;
    80004d46:	597d                	li	s2,-1
    80004d48:	b765                	j	80004cf0 <fileread+0x60>
      return -1;
    80004d4a:	597d                	li	s2,-1
    80004d4c:	b755                	j	80004cf0 <fileread+0x60>
    80004d4e:	597d                	li	s2,-1
    80004d50:	b745                	j	80004cf0 <fileread+0x60>

0000000080004d52 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004d52:	00954783          	lbu	a5,9(a0)
    80004d56:	14078563          	beqz	a5,80004ea0 <filewrite+0x14e>
{
    80004d5a:	715d                	addi	sp,sp,-80
    80004d5c:	e486                	sd	ra,72(sp)
    80004d5e:	e0a2                	sd	s0,64(sp)
    80004d60:	fc26                	sd	s1,56(sp)
    80004d62:	f84a                	sd	s2,48(sp)
    80004d64:	f44e                	sd	s3,40(sp)
    80004d66:	f052                	sd	s4,32(sp)
    80004d68:	ec56                	sd	s5,24(sp)
    80004d6a:	e85a                	sd	s6,16(sp)
    80004d6c:	e45e                	sd	s7,8(sp)
    80004d6e:	e062                	sd	s8,0(sp)
    80004d70:	0880                	addi	s0,sp,80
    80004d72:	892a                	mv	s2,a0
    80004d74:	8aae                	mv	s5,a1
    80004d76:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d78:	411c                	lw	a5,0(a0)
    80004d7a:	4705                	li	a4,1
    80004d7c:	02e78263          	beq	a5,a4,80004da0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d80:	470d                	li	a4,3
    80004d82:	02e78563          	beq	a5,a4,80004dac <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d86:	4709                	li	a4,2
    80004d88:	10e79463          	bne	a5,a4,80004e90 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d8c:	0ec05e63          	blez	a2,80004e88 <filewrite+0x136>
    int i = 0;
    80004d90:	4981                	li	s3,0
    80004d92:	6b05                	lui	s6,0x1
    80004d94:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004d98:	6b85                	lui	s7,0x1
    80004d9a:	c00b8b9b          	addiw	s7,s7,-1024
    80004d9e:	a851                	j	80004e32 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004da0:	6908                	ld	a0,16(a0)
    80004da2:	00000097          	auipc	ra,0x0
    80004da6:	254080e7          	jalr	596(ra) # 80004ff6 <pipewrite>
    80004daa:	a85d                	j	80004e60 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004dac:	02451783          	lh	a5,36(a0)
    80004db0:	03079693          	slli	a3,a5,0x30
    80004db4:	92c1                	srli	a3,a3,0x30
    80004db6:	4725                	li	a4,9
    80004db8:	0ed76663          	bltu	a4,a3,80004ea4 <filewrite+0x152>
    80004dbc:	0792                	slli	a5,a5,0x4
    80004dbe:	0001e717          	auipc	a4,0x1e
    80004dc2:	83a70713          	addi	a4,a4,-1990 # 800225f8 <devsw>
    80004dc6:	97ba                	add	a5,a5,a4
    80004dc8:	679c                	ld	a5,8(a5)
    80004dca:	cff9                	beqz	a5,80004ea8 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004dcc:	4505                	li	a0,1
    80004dce:	9782                	jalr	a5
    80004dd0:	a841                	j	80004e60 <filewrite+0x10e>
    80004dd2:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004dd6:	00000097          	auipc	ra,0x0
    80004dda:	8ae080e7          	jalr	-1874(ra) # 80004684 <begin_op>
      ilock(f->ip);
    80004dde:	01893503          	ld	a0,24(s2)
    80004de2:	fffff097          	auipc	ra,0xfffff
    80004de6:	ee2080e7          	jalr	-286(ra) # 80003cc4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004dea:	8762                	mv	a4,s8
    80004dec:	02092683          	lw	a3,32(s2)
    80004df0:	01598633          	add	a2,s3,s5
    80004df4:	4585                	li	a1,1
    80004df6:	01893503          	ld	a0,24(s2)
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	274080e7          	jalr	628(ra) # 8000406e <writei>
    80004e02:	84aa                	mv	s1,a0
    80004e04:	02a05f63          	blez	a0,80004e42 <filewrite+0xf0>
        f->off += r;
    80004e08:	02092783          	lw	a5,32(s2)
    80004e0c:	9fa9                	addw	a5,a5,a0
    80004e0e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e12:	01893503          	ld	a0,24(s2)
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	f70080e7          	jalr	-144(ra) # 80003d86 <iunlock>
      end_op();
    80004e1e:	00000097          	auipc	ra,0x0
    80004e22:	8e6080e7          	jalr	-1818(ra) # 80004704 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004e26:	049c1963          	bne	s8,s1,80004e78 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004e2a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004e2e:	0349d663          	bge	s3,s4,80004e5a <filewrite+0x108>
      int n1 = n - i;
    80004e32:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004e36:	84be                	mv	s1,a5
    80004e38:	2781                	sext.w	a5,a5
    80004e3a:	f8fb5ce3          	bge	s6,a5,80004dd2 <filewrite+0x80>
    80004e3e:	84de                	mv	s1,s7
    80004e40:	bf49                	j	80004dd2 <filewrite+0x80>
      iunlock(f->ip);
    80004e42:	01893503          	ld	a0,24(s2)
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	f40080e7          	jalr	-192(ra) # 80003d86 <iunlock>
      end_op();
    80004e4e:	00000097          	auipc	ra,0x0
    80004e52:	8b6080e7          	jalr	-1866(ra) # 80004704 <end_op>
      if(r < 0)
    80004e56:	fc04d8e3          	bgez	s1,80004e26 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004e5a:	8552                	mv	a0,s4
    80004e5c:	033a1863          	bne	s4,s3,80004e8c <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004e60:	60a6                	ld	ra,72(sp)
    80004e62:	6406                	ld	s0,64(sp)
    80004e64:	74e2                	ld	s1,56(sp)
    80004e66:	7942                	ld	s2,48(sp)
    80004e68:	79a2                	ld	s3,40(sp)
    80004e6a:	7a02                	ld	s4,32(sp)
    80004e6c:	6ae2                	ld	s5,24(sp)
    80004e6e:	6b42                	ld	s6,16(sp)
    80004e70:	6ba2                	ld	s7,8(sp)
    80004e72:	6c02                	ld	s8,0(sp)
    80004e74:	6161                	addi	sp,sp,80
    80004e76:	8082                	ret
        panic("short filewrite");
    80004e78:	00004517          	auipc	a0,0x4
    80004e7c:	8e050513          	addi	a0,a0,-1824 # 80008758 <syscalls+0x268>
    80004e80:	ffffb097          	auipc	ra,0xffffb
    80004e84:	6c0080e7          	jalr	1728(ra) # 80000540 <panic>
    int i = 0;
    80004e88:	4981                	li	s3,0
    80004e8a:	bfc1                	j	80004e5a <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004e8c:	557d                	li	a0,-1
    80004e8e:	bfc9                	j	80004e60 <filewrite+0x10e>
    panic("filewrite");
    80004e90:	00004517          	auipc	a0,0x4
    80004e94:	8d850513          	addi	a0,a0,-1832 # 80008768 <syscalls+0x278>
    80004e98:	ffffb097          	auipc	ra,0xffffb
    80004e9c:	6a8080e7          	jalr	1704(ra) # 80000540 <panic>
    return -1;
    80004ea0:	557d                	li	a0,-1
}
    80004ea2:	8082                	ret
      return -1;
    80004ea4:	557d                	li	a0,-1
    80004ea6:	bf6d                	j	80004e60 <filewrite+0x10e>
    80004ea8:	557d                	li	a0,-1
    80004eaa:	bf5d                	j	80004e60 <filewrite+0x10e>

0000000080004eac <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004eac:	7179                	addi	sp,sp,-48
    80004eae:	f406                	sd	ra,40(sp)
    80004eb0:	f022                	sd	s0,32(sp)
    80004eb2:	ec26                	sd	s1,24(sp)
    80004eb4:	e84a                	sd	s2,16(sp)
    80004eb6:	e44e                	sd	s3,8(sp)
    80004eb8:	e052                	sd	s4,0(sp)
    80004eba:	1800                	addi	s0,sp,48
    80004ebc:	84aa                	mv	s1,a0
    80004ebe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004ec0:	0005b023          	sd	zero,0(a1)
    80004ec4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004ec8:	00000097          	auipc	ra,0x0
    80004ecc:	bd2080e7          	jalr	-1070(ra) # 80004a9a <filealloc>
    80004ed0:	e088                	sd	a0,0(s1)
    80004ed2:	c551                	beqz	a0,80004f5e <pipealloc+0xb2>
    80004ed4:	00000097          	auipc	ra,0x0
    80004ed8:	bc6080e7          	jalr	-1082(ra) # 80004a9a <filealloc>
    80004edc:	00aa3023          	sd	a0,0(s4)
    80004ee0:	c92d                	beqz	a0,80004f52 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004ee2:	ffffc097          	auipc	ra,0xffffc
    80004ee6:	c2a080e7          	jalr	-982(ra) # 80000b0c <kalloc>
    80004eea:	892a                	mv	s2,a0
    80004eec:	c125                	beqz	a0,80004f4c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004eee:	4985                	li	s3,1
    80004ef0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004ef4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004ef8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004efc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f00:	00004597          	auipc	a1,0x4
    80004f04:	87858593          	addi	a1,a1,-1928 # 80008778 <syscalls+0x288>
    80004f08:	ffffc097          	auipc	ra,0xffffc
    80004f0c:	c64080e7          	jalr	-924(ra) # 80000b6c <initlock>
  (*f0)->type = FD_PIPE;
    80004f10:	609c                	ld	a5,0(s1)
    80004f12:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f16:	609c                	ld	a5,0(s1)
    80004f18:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f1c:	609c                	ld	a5,0(s1)
    80004f1e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004f22:	609c                	ld	a5,0(s1)
    80004f24:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f28:	000a3783          	ld	a5,0(s4)
    80004f2c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f30:	000a3783          	ld	a5,0(s4)
    80004f34:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f38:	000a3783          	ld	a5,0(s4)
    80004f3c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004f40:	000a3783          	ld	a5,0(s4)
    80004f44:	0127b823          	sd	s2,16(a5)
  return 0;
    80004f48:	4501                	li	a0,0
    80004f4a:	a025                	j	80004f72 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004f4c:	6088                	ld	a0,0(s1)
    80004f4e:	e501                	bnez	a0,80004f56 <pipealloc+0xaa>
    80004f50:	a039                	j	80004f5e <pipealloc+0xb2>
    80004f52:	6088                	ld	a0,0(s1)
    80004f54:	c51d                	beqz	a0,80004f82 <pipealloc+0xd6>
    fileclose(*f0);
    80004f56:	00000097          	auipc	ra,0x0
    80004f5a:	c00080e7          	jalr	-1024(ra) # 80004b56 <fileclose>
  if(*f1)
    80004f5e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004f62:	557d                	li	a0,-1
  if(*f1)
    80004f64:	c799                	beqz	a5,80004f72 <pipealloc+0xc6>
    fileclose(*f1);
    80004f66:	853e                	mv	a0,a5
    80004f68:	00000097          	auipc	ra,0x0
    80004f6c:	bee080e7          	jalr	-1042(ra) # 80004b56 <fileclose>
  return -1;
    80004f70:	557d                	li	a0,-1
}
    80004f72:	70a2                	ld	ra,40(sp)
    80004f74:	7402                	ld	s0,32(sp)
    80004f76:	64e2                	ld	s1,24(sp)
    80004f78:	6942                	ld	s2,16(sp)
    80004f7a:	69a2                	ld	s3,8(sp)
    80004f7c:	6a02                	ld	s4,0(sp)
    80004f7e:	6145                	addi	sp,sp,48
    80004f80:	8082                	ret
  return -1;
    80004f82:	557d                	li	a0,-1
    80004f84:	b7fd                	j	80004f72 <pipealloc+0xc6>

0000000080004f86 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004f86:	1101                	addi	sp,sp,-32
    80004f88:	ec06                	sd	ra,24(sp)
    80004f8a:	e822                	sd	s0,16(sp)
    80004f8c:	e426                	sd	s1,8(sp)
    80004f8e:	e04a                	sd	s2,0(sp)
    80004f90:	1000                	addi	s0,sp,32
    80004f92:	84aa                	mv	s1,a0
    80004f94:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f96:	ffffc097          	auipc	ra,0xffffc
    80004f9a:	c66080e7          	jalr	-922(ra) # 80000bfc <acquire>
  if(writable){
    80004f9e:	02090d63          	beqz	s2,80004fd8 <pipeclose+0x52>
    pi->writeopen = 0;
    80004fa2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004fa6:	21848513          	addi	a0,s1,536
    80004faa:	ffffe097          	auipc	ra,0xffffe
    80004fae:	972080e7          	jalr	-1678(ra) # 8000291c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004fb2:	2204b783          	ld	a5,544(s1)
    80004fb6:	eb95                	bnez	a5,80004fea <pipeclose+0x64>
    release(&pi->lock);
    80004fb8:	8526                	mv	a0,s1
    80004fba:	ffffc097          	auipc	ra,0xffffc
    80004fbe:	cf6080e7          	jalr	-778(ra) # 80000cb0 <release>
    kfree((char*)pi);
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	ffffc097          	auipc	ra,0xffffc
    80004fc8:	a4c080e7          	jalr	-1460(ra) # 80000a10 <kfree>
  } else
    release(&pi->lock);
}
    80004fcc:	60e2                	ld	ra,24(sp)
    80004fce:	6442                	ld	s0,16(sp)
    80004fd0:	64a2                	ld	s1,8(sp)
    80004fd2:	6902                	ld	s2,0(sp)
    80004fd4:	6105                	addi	sp,sp,32
    80004fd6:	8082                	ret
    pi->readopen = 0;
    80004fd8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004fdc:	21c48513          	addi	a0,s1,540
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	93c080e7          	jalr	-1732(ra) # 8000291c <wakeup>
    80004fe8:	b7e9                	j	80004fb2 <pipeclose+0x2c>
    release(&pi->lock);
    80004fea:	8526                	mv	a0,s1
    80004fec:	ffffc097          	auipc	ra,0xffffc
    80004ff0:	cc4080e7          	jalr	-828(ra) # 80000cb0 <release>
}
    80004ff4:	bfe1                	j	80004fcc <pipeclose+0x46>

0000000080004ff6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004ff6:	711d                	addi	sp,sp,-96
    80004ff8:	ec86                	sd	ra,88(sp)
    80004ffa:	e8a2                	sd	s0,80(sp)
    80004ffc:	e4a6                	sd	s1,72(sp)
    80004ffe:	e0ca                	sd	s2,64(sp)
    80005000:	fc4e                	sd	s3,56(sp)
    80005002:	f852                	sd	s4,48(sp)
    80005004:	f456                	sd	s5,40(sp)
    80005006:	f05a                	sd	s6,32(sp)
    80005008:	ec5e                	sd	s7,24(sp)
    8000500a:	e862                	sd	s8,16(sp)
    8000500c:	1080                	addi	s0,sp,96
    8000500e:	84aa                	mv	s1,a0
    80005010:	8b2e                	mv	s6,a1
    80005012:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	f08080e7          	jalr	-248(ra) # 80001f1c <myproc>
    8000501c:	892a                	mv	s2,a0

  acquire(&pi->lock);
    8000501e:	8526                	mv	a0,s1
    80005020:	ffffc097          	auipc	ra,0xffffc
    80005024:	bdc080e7          	jalr	-1060(ra) # 80000bfc <acquire>
  for(i = 0; i < n; i++){
    80005028:	09505763          	blez	s5,800050b6 <pipewrite+0xc0>
    8000502c:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    8000502e:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005032:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005036:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80005038:	2184a783          	lw	a5,536(s1)
    8000503c:	21c4a703          	lw	a4,540(s1)
    80005040:	2007879b          	addiw	a5,a5,512
    80005044:	02f71b63          	bne	a4,a5,8000507a <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    80005048:	2204a783          	lw	a5,544(s1)
    8000504c:	c3d1                	beqz	a5,800050d0 <pipewrite+0xda>
    8000504e:	03092783          	lw	a5,48(s2)
    80005052:	efbd                	bnez	a5,800050d0 <pipewrite+0xda>
      wakeup(&pi->nread);
    80005054:	8552                	mv	a0,s4
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	8c6080e7          	jalr	-1850(ra) # 8000291c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000505e:	85a6                	mv	a1,s1
    80005060:	854e                	mv	a0,s3
    80005062:	ffffd097          	auipc	ra,0xffffd
    80005066:	73a080e7          	jalr	1850(ra) # 8000279c <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    8000506a:	2184a783          	lw	a5,536(s1)
    8000506e:	21c4a703          	lw	a4,540(s1)
    80005072:	2007879b          	addiw	a5,a5,512
    80005076:	fcf709e3          	beq	a4,a5,80005048 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000507a:	4685                	li	a3,1
    8000507c:	865a                	mv	a2,s6
    8000507e:	faf40593          	addi	a1,s0,-81
    80005082:	05093503          	ld	a0,80(s2)
    80005086:	ffffc097          	auipc	ra,0xffffc
    8000508a:	6b0080e7          	jalr	1712(ra) # 80001736 <copyin>
    8000508e:	03850563          	beq	a0,s8,800050b8 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005092:	21c4a783          	lw	a5,540(s1)
    80005096:	0017871b          	addiw	a4,a5,1
    8000509a:	20e4ae23          	sw	a4,540(s1)
    8000509e:	1ff7f793          	andi	a5,a5,511
    800050a2:	97a6                	add	a5,a5,s1
    800050a4:	faf44703          	lbu	a4,-81(s0)
    800050a8:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    800050ac:	2b85                	addiw	s7,s7,1
    800050ae:	0b05                	addi	s6,s6,1
    800050b0:	f97a94e3          	bne	s5,s7,80005038 <pipewrite+0x42>
    800050b4:	a011                	j	800050b8 <pipewrite+0xc2>
    800050b6:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    800050b8:	21848513          	addi	a0,s1,536
    800050bc:	ffffe097          	auipc	ra,0xffffe
    800050c0:	860080e7          	jalr	-1952(ra) # 8000291c <wakeup>
  release(&pi->lock);
    800050c4:	8526                	mv	a0,s1
    800050c6:	ffffc097          	auipc	ra,0xffffc
    800050ca:	bea080e7          	jalr	-1046(ra) # 80000cb0 <release>
  return i;
    800050ce:	a039                	j	800050dc <pipewrite+0xe6>
        release(&pi->lock);
    800050d0:	8526                	mv	a0,s1
    800050d2:	ffffc097          	auipc	ra,0xffffc
    800050d6:	bde080e7          	jalr	-1058(ra) # 80000cb0 <release>
        return -1;
    800050da:	5bfd                	li	s7,-1
}
    800050dc:	855e                	mv	a0,s7
    800050de:	60e6                	ld	ra,88(sp)
    800050e0:	6446                	ld	s0,80(sp)
    800050e2:	64a6                	ld	s1,72(sp)
    800050e4:	6906                	ld	s2,64(sp)
    800050e6:	79e2                	ld	s3,56(sp)
    800050e8:	7a42                	ld	s4,48(sp)
    800050ea:	7aa2                	ld	s5,40(sp)
    800050ec:	7b02                	ld	s6,32(sp)
    800050ee:	6be2                	ld	s7,24(sp)
    800050f0:	6c42                	ld	s8,16(sp)
    800050f2:	6125                	addi	sp,sp,96
    800050f4:	8082                	ret

00000000800050f6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800050f6:	715d                	addi	sp,sp,-80
    800050f8:	e486                	sd	ra,72(sp)
    800050fa:	e0a2                	sd	s0,64(sp)
    800050fc:	fc26                	sd	s1,56(sp)
    800050fe:	f84a                	sd	s2,48(sp)
    80005100:	f44e                	sd	s3,40(sp)
    80005102:	f052                	sd	s4,32(sp)
    80005104:	ec56                	sd	s5,24(sp)
    80005106:	e85a                	sd	s6,16(sp)
    80005108:	0880                	addi	s0,sp,80
    8000510a:	84aa                	mv	s1,a0
    8000510c:	892e                	mv	s2,a1
    8000510e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005110:	ffffd097          	auipc	ra,0xffffd
    80005114:	e0c080e7          	jalr	-500(ra) # 80001f1c <myproc>
    80005118:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000511a:	8526                	mv	a0,s1
    8000511c:	ffffc097          	auipc	ra,0xffffc
    80005120:	ae0080e7          	jalr	-1312(ra) # 80000bfc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005124:	2184a703          	lw	a4,536(s1)
    80005128:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000512c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005130:	02f71463          	bne	a4,a5,80005158 <piperead+0x62>
    80005134:	2244a783          	lw	a5,548(s1)
    80005138:	c385                	beqz	a5,80005158 <piperead+0x62>
    if(pr->killed){
    8000513a:	030a2783          	lw	a5,48(s4)
    8000513e:	ebc1                	bnez	a5,800051ce <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005140:	85a6                	mv	a1,s1
    80005142:	854e                	mv	a0,s3
    80005144:	ffffd097          	auipc	ra,0xffffd
    80005148:	658080e7          	jalr	1624(ra) # 8000279c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000514c:	2184a703          	lw	a4,536(s1)
    80005150:	21c4a783          	lw	a5,540(s1)
    80005154:	fef700e3          	beq	a4,a5,80005134 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005158:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000515a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000515c:	05505363          	blez	s5,800051a2 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80005160:	2184a783          	lw	a5,536(s1)
    80005164:	21c4a703          	lw	a4,540(s1)
    80005168:	02f70d63          	beq	a4,a5,800051a2 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000516c:	0017871b          	addiw	a4,a5,1
    80005170:	20e4ac23          	sw	a4,536(s1)
    80005174:	1ff7f793          	andi	a5,a5,511
    80005178:	97a6                	add	a5,a5,s1
    8000517a:	0187c783          	lbu	a5,24(a5)
    8000517e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005182:	4685                	li	a3,1
    80005184:	fbf40613          	addi	a2,s0,-65
    80005188:	85ca                	mv	a1,s2
    8000518a:	050a3503          	ld	a0,80(s4)
    8000518e:	ffffc097          	auipc	ra,0xffffc
    80005192:	51c080e7          	jalr	1308(ra) # 800016aa <copyout>
    80005196:	01650663          	beq	a0,s6,800051a2 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000519a:	2985                	addiw	s3,s3,1
    8000519c:	0905                	addi	s2,s2,1
    8000519e:	fd3a91e3          	bne	s5,s3,80005160 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800051a2:	21c48513          	addi	a0,s1,540
    800051a6:	ffffd097          	auipc	ra,0xffffd
    800051aa:	776080e7          	jalr	1910(ra) # 8000291c <wakeup>
  release(&pi->lock);
    800051ae:	8526                	mv	a0,s1
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	b00080e7          	jalr	-1280(ra) # 80000cb0 <release>
  return i;
}
    800051b8:	854e                	mv	a0,s3
    800051ba:	60a6                	ld	ra,72(sp)
    800051bc:	6406                	ld	s0,64(sp)
    800051be:	74e2                	ld	s1,56(sp)
    800051c0:	7942                	ld	s2,48(sp)
    800051c2:	79a2                	ld	s3,40(sp)
    800051c4:	7a02                	ld	s4,32(sp)
    800051c6:	6ae2                	ld	s5,24(sp)
    800051c8:	6b42                	ld	s6,16(sp)
    800051ca:	6161                	addi	sp,sp,80
    800051cc:	8082                	ret
      release(&pi->lock);
    800051ce:	8526                	mv	a0,s1
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	ae0080e7          	jalr	-1312(ra) # 80000cb0 <release>
      return -1;
    800051d8:	59fd                	li	s3,-1
    800051da:	bff9                	j	800051b8 <piperead+0xc2>

00000000800051dc <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800051dc:	de010113          	addi	sp,sp,-544
    800051e0:	20113c23          	sd	ra,536(sp)
    800051e4:	20813823          	sd	s0,528(sp)
    800051e8:	20913423          	sd	s1,520(sp)
    800051ec:	21213023          	sd	s2,512(sp)
    800051f0:	ffce                	sd	s3,504(sp)
    800051f2:	fbd2                	sd	s4,496(sp)
    800051f4:	f7d6                	sd	s5,488(sp)
    800051f6:	f3da                	sd	s6,480(sp)
    800051f8:	efde                	sd	s7,472(sp)
    800051fa:	ebe2                	sd	s8,464(sp)
    800051fc:	e7e6                	sd	s9,456(sp)
    800051fe:	e3ea                	sd	s10,448(sp)
    80005200:	ff6e                	sd	s11,440(sp)
    80005202:	1400                	addi	s0,sp,544
    80005204:	892a                	mv	s2,a0
    80005206:	dea43423          	sd	a0,-536(s0)
    8000520a:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000520e:	ffffd097          	auipc	ra,0xffffd
    80005212:	d0e080e7          	jalr	-754(ra) # 80001f1c <myproc>
    80005216:	84aa                	mv	s1,a0

  begin_op();
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	46c080e7          	jalr	1132(ra) # 80004684 <begin_op>

  if((ip = namei(path)) == 0){
    80005220:	854a                	mv	a0,s2
    80005222:	fffff097          	auipc	ra,0xfffff
    80005226:	252080e7          	jalr	594(ra) # 80004474 <namei>
    8000522a:	c93d                	beqz	a0,800052a0 <exec+0xc4>
    8000522c:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	a96080e7          	jalr	-1386(ra) # 80003cc4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005236:	04000713          	li	a4,64
    8000523a:	4681                	li	a3,0
    8000523c:	e4840613          	addi	a2,s0,-440
    80005240:	4581                	li	a1,0
    80005242:	8556                	mv	a0,s5
    80005244:	fffff097          	auipc	ra,0xfffff
    80005248:	d34080e7          	jalr	-716(ra) # 80003f78 <readi>
    8000524c:	04000793          	li	a5,64
    80005250:	00f51a63          	bne	a0,a5,80005264 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80005254:	e4842703          	lw	a4,-440(s0)
    80005258:	464c47b7          	lui	a5,0x464c4
    8000525c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005260:	04f70663          	beq	a4,a5,800052ac <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005264:	8556                	mv	a0,s5
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	cc0080e7          	jalr	-832(ra) # 80003f26 <iunlockput>
    end_op();
    8000526e:	fffff097          	auipc	ra,0xfffff
    80005272:	496080e7          	jalr	1174(ra) # 80004704 <end_op>
  }
  return -1;
    80005276:	557d                	li	a0,-1
}
    80005278:	21813083          	ld	ra,536(sp)
    8000527c:	21013403          	ld	s0,528(sp)
    80005280:	20813483          	ld	s1,520(sp)
    80005284:	20013903          	ld	s2,512(sp)
    80005288:	79fe                	ld	s3,504(sp)
    8000528a:	7a5e                	ld	s4,496(sp)
    8000528c:	7abe                	ld	s5,488(sp)
    8000528e:	7b1e                	ld	s6,480(sp)
    80005290:	6bfe                	ld	s7,472(sp)
    80005292:	6c5e                	ld	s8,464(sp)
    80005294:	6cbe                	ld	s9,456(sp)
    80005296:	6d1e                	ld	s10,448(sp)
    80005298:	7dfa                	ld	s11,440(sp)
    8000529a:	22010113          	addi	sp,sp,544
    8000529e:	8082                	ret
    end_op();
    800052a0:	fffff097          	auipc	ra,0xfffff
    800052a4:	464080e7          	jalr	1124(ra) # 80004704 <end_op>
    return -1;
    800052a8:	557d                	li	a0,-1
    800052aa:	b7f9                	j	80005278 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800052ac:	8526                	mv	a0,s1
    800052ae:	ffffd097          	auipc	ra,0xffffd
    800052b2:	d32080e7          	jalr	-718(ra) # 80001fe0 <proc_pagetable>
    800052b6:	8b2a                	mv	s6,a0
    800052b8:	d555                	beqz	a0,80005264 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052ba:	e6842783          	lw	a5,-408(s0)
    800052be:	e8045703          	lhu	a4,-384(s0)
    800052c2:	c735                	beqz	a4,8000532e <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    800052c4:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052c6:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800052ca:	6a05                	lui	s4,0x1
    800052cc:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800052d0:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    800052d4:	6d85                	lui	s11,0x1
    800052d6:	7d7d                	lui	s10,0xfffff
    800052d8:	ac1d                	j	8000550e <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800052da:	00003517          	auipc	a0,0x3
    800052de:	4a650513          	addi	a0,a0,1190 # 80008780 <syscalls+0x290>
    800052e2:	ffffb097          	auipc	ra,0xffffb
    800052e6:	25e080e7          	jalr	606(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800052ea:	874a                	mv	a4,s2
    800052ec:	009c86bb          	addw	a3,s9,s1
    800052f0:	4581                	li	a1,0
    800052f2:	8556                	mv	a0,s5
    800052f4:	fffff097          	auipc	ra,0xfffff
    800052f8:	c84080e7          	jalr	-892(ra) # 80003f78 <readi>
    800052fc:	2501                	sext.w	a0,a0
    800052fe:	1aa91863          	bne	s2,a0,800054ae <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80005302:	009d84bb          	addw	s1,s11,s1
    80005306:	013d09bb          	addw	s3,s10,s3
    8000530a:	1f74f263          	bgeu	s1,s7,800054ee <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000530e:	02049593          	slli	a1,s1,0x20
    80005312:	9181                	srli	a1,a1,0x20
    80005314:	95e2                	add	a1,a1,s8
    80005316:	855a                	mv	a0,s6
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	d5e080e7          	jalr	-674(ra) # 80001076 <walkaddr>
    80005320:	862a                	mv	a2,a0
    if(pa == 0)
    80005322:	dd45                	beqz	a0,800052da <exec+0xfe>
      n = PGSIZE;
    80005324:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005326:	fd49f2e3          	bgeu	s3,s4,800052ea <exec+0x10e>
      n = sz - i;
    8000532a:	894e                	mv	s2,s3
    8000532c:	bf7d                	j	800052ea <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    8000532e:	4481                	li	s1,0
  iunlockput(ip);
    80005330:	8556                	mv	a0,s5
    80005332:	fffff097          	auipc	ra,0xfffff
    80005336:	bf4080e7          	jalr	-1036(ra) # 80003f26 <iunlockput>
  end_op();
    8000533a:	fffff097          	auipc	ra,0xfffff
    8000533e:	3ca080e7          	jalr	970(ra) # 80004704 <end_op>
  p = myproc();
    80005342:	ffffd097          	auipc	ra,0xffffd
    80005346:	bda080e7          	jalr	-1062(ra) # 80001f1c <myproc>
    8000534a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000534c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005350:	6785                	lui	a5,0x1
    80005352:	17fd                	addi	a5,a5,-1
    80005354:	94be                	add	s1,s1,a5
    80005356:	77fd                	lui	a5,0xfffff
    80005358:	8fe5                	and	a5,a5,s1
    8000535a:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000535e:	6609                	lui	a2,0x2
    80005360:	963e                	add	a2,a2,a5
    80005362:	85be                	mv	a1,a5
    80005364:	855a                	mv	a0,s6
    80005366:	ffffc097          	auipc	ra,0xffffc
    8000536a:	0f4080e7          	jalr	244(ra) # 8000145a <uvmalloc>
    8000536e:	8c2a                	mv	s8,a0
  ip = 0;
    80005370:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005372:	12050e63          	beqz	a0,800054ae <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005376:	75f9                	lui	a1,0xffffe
    80005378:	95aa                	add	a1,a1,a0
    8000537a:	855a                	mv	a0,s6
    8000537c:	ffffc097          	auipc	ra,0xffffc
    80005380:	2fc080e7          	jalr	764(ra) # 80001678 <uvmclear>
  stackbase = sp - PGSIZE;
    80005384:	7afd                	lui	s5,0xfffff
    80005386:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005388:	df043783          	ld	a5,-528(s0)
    8000538c:	6388                	ld	a0,0(a5)
    8000538e:	c925                	beqz	a0,800053fe <exec+0x222>
    80005390:	e8840993          	addi	s3,s0,-376
    80005394:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80005398:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000539a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000539c:	ffffc097          	auipc	ra,0xffffc
    800053a0:	ae0080e7          	jalr	-1312(ra) # 80000e7c <strlen>
    800053a4:	0015079b          	addiw	a5,a0,1
    800053a8:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800053ac:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800053b0:	13596363          	bltu	s2,s5,800054d6 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800053b4:	df043d83          	ld	s11,-528(s0)
    800053b8:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800053bc:	8552                	mv	a0,s4
    800053be:	ffffc097          	auipc	ra,0xffffc
    800053c2:	abe080e7          	jalr	-1346(ra) # 80000e7c <strlen>
    800053c6:	0015069b          	addiw	a3,a0,1
    800053ca:	8652                	mv	a2,s4
    800053cc:	85ca                	mv	a1,s2
    800053ce:	855a                	mv	a0,s6
    800053d0:	ffffc097          	auipc	ra,0xffffc
    800053d4:	2da080e7          	jalr	730(ra) # 800016aa <copyout>
    800053d8:	10054363          	bltz	a0,800054de <exec+0x302>
    ustack[argc] = sp;
    800053dc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800053e0:	0485                	addi	s1,s1,1
    800053e2:	008d8793          	addi	a5,s11,8
    800053e6:	def43823          	sd	a5,-528(s0)
    800053ea:	008db503          	ld	a0,8(s11)
    800053ee:	c911                	beqz	a0,80005402 <exec+0x226>
    if(argc >= MAXARG)
    800053f0:	09a1                	addi	s3,s3,8
    800053f2:	fb3c95e3          	bne	s9,s3,8000539c <exec+0x1c0>
  sz = sz1;
    800053f6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053fa:	4a81                	li	s5,0
    800053fc:	a84d                	j	800054ae <exec+0x2d2>
  sp = sz;
    800053fe:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005400:	4481                	li	s1,0
  ustack[argc] = 0;
    80005402:	00349793          	slli	a5,s1,0x3
    80005406:	f9040713          	addi	a4,s0,-112
    8000540a:	97ba                	add	a5,a5,a4
    8000540c:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd7ef8>
  sp -= (argc+1) * sizeof(uint64);
    80005410:	00148693          	addi	a3,s1,1
    80005414:	068e                	slli	a3,a3,0x3
    80005416:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000541a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000541e:	01597663          	bgeu	s2,s5,8000542a <exec+0x24e>
  sz = sz1;
    80005422:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005426:	4a81                	li	s5,0
    80005428:	a059                	j	800054ae <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000542a:	e8840613          	addi	a2,s0,-376
    8000542e:	85ca                	mv	a1,s2
    80005430:	855a                	mv	a0,s6
    80005432:	ffffc097          	auipc	ra,0xffffc
    80005436:	278080e7          	jalr	632(ra) # 800016aa <copyout>
    8000543a:	0a054663          	bltz	a0,800054e6 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000543e:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80005442:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005446:	de843783          	ld	a5,-536(s0)
    8000544a:	0007c703          	lbu	a4,0(a5)
    8000544e:	cf11                	beqz	a4,8000546a <exec+0x28e>
    80005450:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005452:	02f00693          	li	a3,47
    80005456:	a039                	j	80005464 <exec+0x288>
      last = s+1;
    80005458:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000545c:	0785                	addi	a5,a5,1
    8000545e:	fff7c703          	lbu	a4,-1(a5)
    80005462:	c701                	beqz	a4,8000546a <exec+0x28e>
    if(*s == '/')
    80005464:	fed71ce3          	bne	a4,a3,8000545c <exec+0x280>
    80005468:	bfc5                	j	80005458 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000546a:	4641                	li	a2,16
    8000546c:	de843583          	ld	a1,-536(s0)
    80005470:	158b8513          	addi	a0,s7,344
    80005474:	ffffc097          	auipc	ra,0xffffc
    80005478:	9d6080e7          	jalr	-1578(ra) # 80000e4a <safestrcpy>
  oldpagetable = p->pagetable;
    8000547c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005480:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005484:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005488:	058bb783          	ld	a5,88(s7)
    8000548c:	e6043703          	ld	a4,-416(s0)
    80005490:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005492:	058bb783          	ld	a5,88(s7)
    80005496:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000549a:	85ea                	mv	a1,s10
    8000549c:	ffffd097          	auipc	ra,0xffffd
    800054a0:	be0080e7          	jalr	-1056(ra) # 8000207c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800054a4:	0004851b          	sext.w	a0,s1
    800054a8:	bbc1                	j	80005278 <exec+0x9c>
    800054aa:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800054ae:	df843583          	ld	a1,-520(s0)
    800054b2:	855a                	mv	a0,s6
    800054b4:	ffffd097          	auipc	ra,0xffffd
    800054b8:	bc8080e7          	jalr	-1080(ra) # 8000207c <proc_freepagetable>
  if(ip){
    800054bc:	da0a94e3          	bnez	s5,80005264 <exec+0x88>
  return -1;
    800054c0:	557d                	li	a0,-1
    800054c2:	bb5d                	j	80005278 <exec+0x9c>
    800054c4:	de943c23          	sd	s1,-520(s0)
    800054c8:	b7dd                	j	800054ae <exec+0x2d2>
    800054ca:	de943c23          	sd	s1,-520(s0)
    800054ce:	b7c5                	j	800054ae <exec+0x2d2>
    800054d0:	de943c23          	sd	s1,-520(s0)
    800054d4:	bfe9                	j	800054ae <exec+0x2d2>
  sz = sz1;
    800054d6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800054da:	4a81                	li	s5,0
    800054dc:	bfc9                	j	800054ae <exec+0x2d2>
  sz = sz1;
    800054de:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800054e2:	4a81                	li	s5,0
    800054e4:	b7e9                	j	800054ae <exec+0x2d2>
  sz = sz1;
    800054e6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800054ea:	4a81                	li	s5,0
    800054ec:	b7c9                	j	800054ae <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800054ee:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054f2:	e0843783          	ld	a5,-504(s0)
    800054f6:	0017869b          	addiw	a3,a5,1
    800054fa:	e0d43423          	sd	a3,-504(s0)
    800054fe:	e0043783          	ld	a5,-512(s0)
    80005502:	0387879b          	addiw	a5,a5,56
    80005506:	e8045703          	lhu	a4,-384(s0)
    8000550a:	e2e6d3e3          	bge	a3,a4,80005330 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000550e:	2781                	sext.w	a5,a5
    80005510:	e0f43023          	sd	a5,-512(s0)
    80005514:	03800713          	li	a4,56
    80005518:	86be                	mv	a3,a5
    8000551a:	e1040613          	addi	a2,s0,-496
    8000551e:	4581                	li	a1,0
    80005520:	8556                	mv	a0,s5
    80005522:	fffff097          	auipc	ra,0xfffff
    80005526:	a56080e7          	jalr	-1450(ra) # 80003f78 <readi>
    8000552a:	03800793          	li	a5,56
    8000552e:	f6f51ee3          	bne	a0,a5,800054aa <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80005532:	e1042783          	lw	a5,-496(s0)
    80005536:	4705                	li	a4,1
    80005538:	fae79de3          	bne	a5,a4,800054f2 <exec+0x316>
    if(ph.memsz < ph.filesz)
    8000553c:	e3843603          	ld	a2,-456(s0)
    80005540:	e3043783          	ld	a5,-464(s0)
    80005544:	f8f660e3          	bltu	a2,a5,800054c4 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005548:	e2043783          	ld	a5,-480(s0)
    8000554c:	963e                	add	a2,a2,a5
    8000554e:	f6f66ee3          	bltu	a2,a5,800054ca <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005552:	85a6                	mv	a1,s1
    80005554:	855a                	mv	a0,s6
    80005556:	ffffc097          	auipc	ra,0xffffc
    8000555a:	f04080e7          	jalr	-252(ra) # 8000145a <uvmalloc>
    8000555e:	dea43c23          	sd	a0,-520(s0)
    80005562:	d53d                	beqz	a0,800054d0 <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    80005564:	e2043c03          	ld	s8,-480(s0)
    80005568:	de043783          	ld	a5,-544(s0)
    8000556c:	00fc77b3          	and	a5,s8,a5
    80005570:	ff9d                	bnez	a5,800054ae <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005572:	e1842c83          	lw	s9,-488(s0)
    80005576:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000557a:	f60b8ae3          	beqz	s7,800054ee <exec+0x312>
    8000557e:	89de                	mv	s3,s7
    80005580:	4481                	li	s1,0
    80005582:	b371                	j	8000530e <exec+0x132>

0000000080005584 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005584:	7179                	addi	sp,sp,-48
    80005586:	f406                	sd	ra,40(sp)
    80005588:	f022                	sd	s0,32(sp)
    8000558a:	ec26                	sd	s1,24(sp)
    8000558c:	e84a                	sd	s2,16(sp)
    8000558e:	1800                	addi	s0,sp,48
    80005590:	892e                	mv	s2,a1
    80005592:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005594:	fdc40593          	addi	a1,s0,-36
    80005598:	ffffe097          	auipc	ra,0xffffe
    8000559c:	b32080e7          	jalr	-1230(ra) # 800030ca <argint>
    800055a0:	04054063          	bltz	a0,800055e0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800055a4:	fdc42703          	lw	a4,-36(s0)
    800055a8:	47bd                	li	a5,15
    800055aa:	02e7ed63          	bltu	a5,a4,800055e4 <argfd+0x60>
    800055ae:	ffffd097          	auipc	ra,0xffffd
    800055b2:	96e080e7          	jalr	-1682(ra) # 80001f1c <myproc>
    800055b6:	fdc42703          	lw	a4,-36(s0)
    800055ba:	01a70793          	addi	a5,a4,26
    800055be:	078e                	slli	a5,a5,0x3
    800055c0:	953e                	add	a0,a0,a5
    800055c2:	611c                	ld	a5,0(a0)
    800055c4:	c395                	beqz	a5,800055e8 <argfd+0x64>
    return -1;
  if(pfd)
    800055c6:	00090463          	beqz	s2,800055ce <argfd+0x4a>
    *pfd = fd;
    800055ca:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800055ce:	4501                	li	a0,0
  if(pf)
    800055d0:	c091                	beqz	s1,800055d4 <argfd+0x50>
    *pf = f;
    800055d2:	e09c                	sd	a5,0(s1)
}
    800055d4:	70a2                	ld	ra,40(sp)
    800055d6:	7402                	ld	s0,32(sp)
    800055d8:	64e2                	ld	s1,24(sp)
    800055da:	6942                	ld	s2,16(sp)
    800055dc:	6145                	addi	sp,sp,48
    800055de:	8082                	ret
    return -1;
    800055e0:	557d                	li	a0,-1
    800055e2:	bfcd                	j	800055d4 <argfd+0x50>
    return -1;
    800055e4:	557d                	li	a0,-1
    800055e6:	b7fd                	j	800055d4 <argfd+0x50>
    800055e8:	557d                	li	a0,-1
    800055ea:	b7ed                	j	800055d4 <argfd+0x50>

00000000800055ec <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800055ec:	1101                	addi	sp,sp,-32
    800055ee:	ec06                	sd	ra,24(sp)
    800055f0:	e822                	sd	s0,16(sp)
    800055f2:	e426                	sd	s1,8(sp)
    800055f4:	1000                	addi	s0,sp,32
    800055f6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800055f8:	ffffd097          	auipc	ra,0xffffd
    800055fc:	924080e7          	jalr	-1756(ra) # 80001f1c <myproc>
    80005600:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005602:	0d050793          	addi	a5,a0,208
    80005606:	4501                	li	a0,0
    80005608:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000560a:	6398                	ld	a4,0(a5)
    8000560c:	cb19                	beqz	a4,80005622 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000560e:	2505                	addiw	a0,a0,1
    80005610:	07a1                	addi	a5,a5,8
    80005612:	fed51ce3          	bne	a0,a3,8000560a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005616:	557d                	li	a0,-1
}
    80005618:	60e2                	ld	ra,24(sp)
    8000561a:	6442                	ld	s0,16(sp)
    8000561c:	64a2                	ld	s1,8(sp)
    8000561e:	6105                	addi	sp,sp,32
    80005620:	8082                	ret
      p->ofile[fd] = f;
    80005622:	01a50793          	addi	a5,a0,26
    80005626:	078e                	slli	a5,a5,0x3
    80005628:	963e                	add	a2,a2,a5
    8000562a:	e204                	sd	s1,0(a2)
      return fd;
    8000562c:	b7f5                	j	80005618 <fdalloc+0x2c>

000000008000562e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000562e:	715d                	addi	sp,sp,-80
    80005630:	e486                	sd	ra,72(sp)
    80005632:	e0a2                	sd	s0,64(sp)
    80005634:	fc26                	sd	s1,56(sp)
    80005636:	f84a                	sd	s2,48(sp)
    80005638:	f44e                	sd	s3,40(sp)
    8000563a:	f052                	sd	s4,32(sp)
    8000563c:	ec56                	sd	s5,24(sp)
    8000563e:	0880                	addi	s0,sp,80
    80005640:	89ae                	mv	s3,a1
    80005642:	8ab2                	mv	s5,a2
    80005644:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005646:	fb040593          	addi	a1,s0,-80
    8000564a:	fffff097          	auipc	ra,0xfffff
    8000564e:	e48080e7          	jalr	-440(ra) # 80004492 <nameiparent>
    80005652:	892a                	mv	s2,a0
    80005654:	12050e63          	beqz	a0,80005790 <create+0x162>
    return 0;

  ilock(dp);
    80005658:	ffffe097          	auipc	ra,0xffffe
    8000565c:	66c080e7          	jalr	1644(ra) # 80003cc4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005660:	4601                	li	a2,0
    80005662:	fb040593          	addi	a1,s0,-80
    80005666:	854a                	mv	a0,s2
    80005668:	fffff097          	auipc	ra,0xfffff
    8000566c:	b3a080e7          	jalr	-1222(ra) # 800041a2 <dirlookup>
    80005670:	84aa                	mv	s1,a0
    80005672:	c921                	beqz	a0,800056c2 <create+0x94>
    iunlockput(dp);
    80005674:	854a                	mv	a0,s2
    80005676:	fffff097          	auipc	ra,0xfffff
    8000567a:	8b0080e7          	jalr	-1872(ra) # 80003f26 <iunlockput>
    ilock(ip);
    8000567e:	8526                	mv	a0,s1
    80005680:	ffffe097          	auipc	ra,0xffffe
    80005684:	644080e7          	jalr	1604(ra) # 80003cc4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005688:	2981                	sext.w	s3,s3
    8000568a:	4789                	li	a5,2
    8000568c:	02f99463          	bne	s3,a5,800056b4 <create+0x86>
    80005690:	0444d783          	lhu	a5,68(s1)
    80005694:	37f9                	addiw	a5,a5,-2
    80005696:	17c2                	slli	a5,a5,0x30
    80005698:	93c1                	srli	a5,a5,0x30
    8000569a:	4705                	li	a4,1
    8000569c:	00f76c63          	bltu	a4,a5,800056b4 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800056a0:	8526                	mv	a0,s1
    800056a2:	60a6                	ld	ra,72(sp)
    800056a4:	6406                	ld	s0,64(sp)
    800056a6:	74e2                	ld	s1,56(sp)
    800056a8:	7942                	ld	s2,48(sp)
    800056aa:	79a2                	ld	s3,40(sp)
    800056ac:	7a02                	ld	s4,32(sp)
    800056ae:	6ae2                	ld	s5,24(sp)
    800056b0:	6161                	addi	sp,sp,80
    800056b2:	8082                	ret
    iunlockput(ip);
    800056b4:	8526                	mv	a0,s1
    800056b6:	fffff097          	auipc	ra,0xfffff
    800056ba:	870080e7          	jalr	-1936(ra) # 80003f26 <iunlockput>
    return 0;
    800056be:	4481                	li	s1,0
    800056c0:	b7c5                	j	800056a0 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800056c2:	85ce                	mv	a1,s3
    800056c4:	00092503          	lw	a0,0(s2)
    800056c8:	ffffe097          	auipc	ra,0xffffe
    800056cc:	464080e7          	jalr	1124(ra) # 80003b2c <ialloc>
    800056d0:	84aa                	mv	s1,a0
    800056d2:	c521                	beqz	a0,8000571a <create+0xec>
  ilock(ip);
    800056d4:	ffffe097          	auipc	ra,0xffffe
    800056d8:	5f0080e7          	jalr	1520(ra) # 80003cc4 <ilock>
  ip->major = major;
    800056dc:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800056e0:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800056e4:	4a05                	li	s4,1
    800056e6:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800056ea:	8526                	mv	a0,s1
    800056ec:	ffffe097          	auipc	ra,0xffffe
    800056f0:	50e080e7          	jalr	1294(ra) # 80003bfa <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800056f4:	2981                	sext.w	s3,s3
    800056f6:	03498a63          	beq	s3,s4,8000572a <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800056fa:	40d0                	lw	a2,4(s1)
    800056fc:	fb040593          	addi	a1,s0,-80
    80005700:	854a                	mv	a0,s2
    80005702:	fffff097          	auipc	ra,0xfffff
    80005706:	cb0080e7          	jalr	-848(ra) # 800043b2 <dirlink>
    8000570a:	06054b63          	bltz	a0,80005780 <create+0x152>
  iunlockput(dp);
    8000570e:	854a                	mv	a0,s2
    80005710:	fffff097          	auipc	ra,0xfffff
    80005714:	816080e7          	jalr	-2026(ra) # 80003f26 <iunlockput>
  return ip;
    80005718:	b761                	j	800056a0 <create+0x72>
    panic("create: ialloc");
    8000571a:	00003517          	auipc	a0,0x3
    8000571e:	08650513          	addi	a0,a0,134 # 800087a0 <syscalls+0x2b0>
    80005722:	ffffb097          	auipc	ra,0xffffb
    80005726:	e1e080e7          	jalr	-482(ra) # 80000540 <panic>
    dp->nlink++;  // for ".."
    8000572a:	04a95783          	lhu	a5,74(s2)
    8000572e:	2785                	addiw	a5,a5,1
    80005730:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005734:	854a                	mv	a0,s2
    80005736:	ffffe097          	auipc	ra,0xffffe
    8000573a:	4c4080e7          	jalr	1220(ra) # 80003bfa <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000573e:	40d0                	lw	a2,4(s1)
    80005740:	00003597          	auipc	a1,0x3
    80005744:	07058593          	addi	a1,a1,112 # 800087b0 <syscalls+0x2c0>
    80005748:	8526                	mv	a0,s1
    8000574a:	fffff097          	auipc	ra,0xfffff
    8000574e:	c68080e7          	jalr	-920(ra) # 800043b2 <dirlink>
    80005752:	00054f63          	bltz	a0,80005770 <create+0x142>
    80005756:	00492603          	lw	a2,4(s2)
    8000575a:	00003597          	auipc	a1,0x3
    8000575e:	05e58593          	addi	a1,a1,94 # 800087b8 <syscalls+0x2c8>
    80005762:	8526                	mv	a0,s1
    80005764:	fffff097          	auipc	ra,0xfffff
    80005768:	c4e080e7          	jalr	-946(ra) # 800043b2 <dirlink>
    8000576c:	f80557e3          	bgez	a0,800056fa <create+0xcc>
      panic("create dots");
    80005770:	00003517          	auipc	a0,0x3
    80005774:	05050513          	addi	a0,a0,80 # 800087c0 <syscalls+0x2d0>
    80005778:	ffffb097          	auipc	ra,0xffffb
    8000577c:	dc8080e7          	jalr	-568(ra) # 80000540 <panic>
    panic("create: dirlink");
    80005780:	00003517          	auipc	a0,0x3
    80005784:	05050513          	addi	a0,a0,80 # 800087d0 <syscalls+0x2e0>
    80005788:	ffffb097          	auipc	ra,0xffffb
    8000578c:	db8080e7          	jalr	-584(ra) # 80000540 <panic>
    return 0;
    80005790:	84aa                	mv	s1,a0
    80005792:	b739                	j	800056a0 <create+0x72>

0000000080005794 <sys_dup>:
{
    80005794:	7179                	addi	sp,sp,-48
    80005796:	f406                	sd	ra,40(sp)
    80005798:	f022                	sd	s0,32(sp)
    8000579a:	ec26                	sd	s1,24(sp)
    8000579c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000579e:	fd840613          	addi	a2,s0,-40
    800057a2:	4581                	li	a1,0
    800057a4:	4501                	li	a0,0
    800057a6:	00000097          	auipc	ra,0x0
    800057aa:	dde080e7          	jalr	-546(ra) # 80005584 <argfd>
    return -1;
    800057ae:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800057b0:	02054363          	bltz	a0,800057d6 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800057b4:	fd843503          	ld	a0,-40(s0)
    800057b8:	00000097          	auipc	ra,0x0
    800057bc:	e34080e7          	jalr	-460(ra) # 800055ec <fdalloc>
    800057c0:	84aa                	mv	s1,a0
    return -1;
    800057c2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800057c4:	00054963          	bltz	a0,800057d6 <sys_dup+0x42>
  filedup(f);
    800057c8:	fd843503          	ld	a0,-40(s0)
    800057cc:	fffff097          	auipc	ra,0xfffff
    800057d0:	338080e7          	jalr	824(ra) # 80004b04 <filedup>
  return fd;
    800057d4:	87a6                	mv	a5,s1
}
    800057d6:	853e                	mv	a0,a5
    800057d8:	70a2                	ld	ra,40(sp)
    800057da:	7402                	ld	s0,32(sp)
    800057dc:	64e2                	ld	s1,24(sp)
    800057de:	6145                	addi	sp,sp,48
    800057e0:	8082                	ret

00000000800057e2 <sys_read>:
{
    800057e2:	7179                	addi	sp,sp,-48
    800057e4:	f406                	sd	ra,40(sp)
    800057e6:	f022                	sd	s0,32(sp)
    800057e8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800057ea:	fe840613          	addi	a2,s0,-24
    800057ee:	4581                	li	a1,0
    800057f0:	4501                	li	a0,0
    800057f2:	00000097          	auipc	ra,0x0
    800057f6:	d92080e7          	jalr	-622(ra) # 80005584 <argfd>
    return -1;
    800057fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800057fc:	04054163          	bltz	a0,8000583e <sys_read+0x5c>
    80005800:	fe440593          	addi	a1,s0,-28
    80005804:	4509                	li	a0,2
    80005806:	ffffe097          	auipc	ra,0xffffe
    8000580a:	8c4080e7          	jalr	-1852(ra) # 800030ca <argint>
    return -1;
    8000580e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005810:	02054763          	bltz	a0,8000583e <sys_read+0x5c>
    80005814:	fd840593          	addi	a1,s0,-40
    80005818:	4505                	li	a0,1
    8000581a:	ffffe097          	auipc	ra,0xffffe
    8000581e:	8d2080e7          	jalr	-1838(ra) # 800030ec <argaddr>
    return -1;
    80005822:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005824:	00054d63          	bltz	a0,8000583e <sys_read+0x5c>
  return fileread(f, p, n);
    80005828:	fe442603          	lw	a2,-28(s0)
    8000582c:	fd843583          	ld	a1,-40(s0)
    80005830:	fe843503          	ld	a0,-24(s0)
    80005834:	fffff097          	auipc	ra,0xfffff
    80005838:	45c080e7          	jalr	1116(ra) # 80004c90 <fileread>
    8000583c:	87aa                	mv	a5,a0
}
    8000583e:	853e                	mv	a0,a5
    80005840:	70a2                	ld	ra,40(sp)
    80005842:	7402                	ld	s0,32(sp)
    80005844:	6145                	addi	sp,sp,48
    80005846:	8082                	ret

0000000080005848 <sys_write>:
{
    80005848:	7179                	addi	sp,sp,-48
    8000584a:	f406                	sd	ra,40(sp)
    8000584c:	f022                	sd	s0,32(sp)
    8000584e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005850:	fe840613          	addi	a2,s0,-24
    80005854:	4581                	li	a1,0
    80005856:	4501                	li	a0,0
    80005858:	00000097          	auipc	ra,0x0
    8000585c:	d2c080e7          	jalr	-724(ra) # 80005584 <argfd>
    return -1;
    80005860:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005862:	04054163          	bltz	a0,800058a4 <sys_write+0x5c>
    80005866:	fe440593          	addi	a1,s0,-28
    8000586a:	4509                	li	a0,2
    8000586c:	ffffe097          	auipc	ra,0xffffe
    80005870:	85e080e7          	jalr	-1954(ra) # 800030ca <argint>
    return -1;
    80005874:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005876:	02054763          	bltz	a0,800058a4 <sys_write+0x5c>
    8000587a:	fd840593          	addi	a1,s0,-40
    8000587e:	4505                	li	a0,1
    80005880:	ffffe097          	auipc	ra,0xffffe
    80005884:	86c080e7          	jalr	-1940(ra) # 800030ec <argaddr>
    return -1;
    80005888:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000588a:	00054d63          	bltz	a0,800058a4 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000588e:	fe442603          	lw	a2,-28(s0)
    80005892:	fd843583          	ld	a1,-40(s0)
    80005896:	fe843503          	ld	a0,-24(s0)
    8000589a:	fffff097          	auipc	ra,0xfffff
    8000589e:	4b8080e7          	jalr	1208(ra) # 80004d52 <filewrite>
    800058a2:	87aa                	mv	a5,a0
}
    800058a4:	853e                	mv	a0,a5
    800058a6:	70a2                	ld	ra,40(sp)
    800058a8:	7402                	ld	s0,32(sp)
    800058aa:	6145                	addi	sp,sp,48
    800058ac:	8082                	ret

00000000800058ae <sys_close>:
{
    800058ae:	1101                	addi	sp,sp,-32
    800058b0:	ec06                	sd	ra,24(sp)
    800058b2:	e822                	sd	s0,16(sp)
    800058b4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800058b6:	fe040613          	addi	a2,s0,-32
    800058ba:	fec40593          	addi	a1,s0,-20
    800058be:	4501                	li	a0,0
    800058c0:	00000097          	auipc	ra,0x0
    800058c4:	cc4080e7          	jalr	-828(ra) # 80005584 <argfd>
    return -1;
    800058c8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800058ca:	02054463          	bltz	a0,800058f2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800058ce:	ffffc097          	auipc	ra,0xffffc
    800058d2:	64e080e7          	jalr	1614(ra) # 80001f1c <myproc>
    800058d6:	fec42783          	lw	a5,-20(s0)
    800058da:	07e9                	addi	a5,a5,26
    800058dc:	078e                	slli	a5,a5,0x3
    800058de:	97aa                	add	a5,a5,a0
    800058e0:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800058e4:	fe043503          	ld	a0,-32(s0)
    800058e8:	fffff097          	auipc	ra,0xfffff
    800058ec:	26e080e7          	jalr	622(ra) # 80004b56 <fileclose>
  return 0;
    800058f0:	4781                	li	a5,0
}
    800058f2:	853e                	mv	a0,a5
    800058f4:	60e2                	ld	ra,24(sp)
    800058f6:	6442                	ld	s0,16(sp)
    800058f8:	6105                	addi	sp,sp,32
    800058fa:	8082                	ret

00000000800058fc <sys_fstat>:
{
    800058fc:	1101                	addi	sp,sp,-32
    800058fe:	ec06                	sd	ra,24(sp)
    80005900:	e822                	sd	s0,16(sp)
    80005902:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005904:	fe840613          	addi	a2,s0,-24
    80005908:	4581                	li	a1,0
    8000590a:	4501                	li	a0,0
    8000590c:	00000097          	auipc	ra,0x0
    80005910:	c78080e7          	jalr	-904(ra) # 80005584 <argfd>
    return -1;
    80005914:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005916:	02054563          	bltz	a0,80005940 <sys_fstat+0x44>
    8000591a:	fe040593          	addi	a1,s0,-32
    8000591e:	4505                	li	a0,1
    80005920:	ffffd097          	auipc	ra,0xffffd
    80005924:	7cc080e7          	jalr	1996(ra) # 800030ec <argaddr>
    return -1;
    80005928:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000592a:	00054b63          	bltz	a0,80005940 <sys_fstat+0x44>
  return filestat(f, st);
    8000592e:	fe043583          	ld	a1,-32(s0)
    80005932:	fe843503          	ld	a0,-24(s0)
    80005936:	fffff097          	auipc	ra,0xfffff
    8000593a:	2e8080e7          	jalr	744(ra) # 80004c1e <filestat>
    8000593e:	87aa                	mv	a5,a0
}
    80005940:	853e                	mv	a0,a5
    80005942:	60e2                	ld	ra,24(sp)
    80005944:	6442                	ld	s0,16(sp)
    80005946:	6105                	addi	sp,sp,32
    80005948:	8082                	ret

000000008000594a <sys_link>:
{
    8000594a:	7169                	addi	sp,sp,-304
    8000594c:	f606                	sd	ra,296(sp)
    8000594e:	f222                	sd	s0,288(sp)
    80005950:	ee26                	sd	s1,280(sp)
    80005952:	ea4a                	sd	s2,272(sp)
    80005954:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005956:	08000613          	li	a2,128
    8000595a:	ed040593          	addi	a1,s0,-304
    8000595e:	4501                	li	a0,0
    80005960:	ffffd097          	auipc	ra,0xffffd
    80005964:	7ae080e7          	jalr	1966(ra) # 8000310e <argstr>
    return -1;
    80005968:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000596a:	10054e63          	bltz	a0,80005a86 <sys_link+0x13c>
    8000596e:	08000613          	li	a2,128
    80005972:	f5040593          	addi	a1,s0,-176
    80005976:	4505                	li	a0,1
    80005978:	ffffd097          	auipc	ra,0xffffd
    8000597c:	796080e7          	jalr	1942(ra) # 8000310e <argstr>
    return -1;
    80005980:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005982:	10054263          	bltz	a0,80005a86 <sys_link+0x13c>
  begin_op();
    80005986:	fffff097          	auipc	ra,0xfffff
    8000598a:	cfe080e7          	jalr	-770(ra) # 80004684 <begin_op>
  if((ip = namei(old)) == 0){
    8000598e:	ed040513          	addi	a0,s0,-304
    80005992:	fffff097          	auipc	ra,0xfffff
    80005996:	ae2080e7          	jalr	-1310(ra) # 80004474 <namei>
    8000599a:	84aa                	mv	s1,a0
    8000599c:	c551                	beqz	a0,80005a28 <sys_link+0xde>
  ilock(ip);
    8000599e:	ffffe097          	auipc	ra,0xffffe
    800059a2:	326080e7          	jalr	806(ra) # 80003cc4 <ilock>
  if(ip->type == T_DIR){
    800059a6:	04449703          	lh	a4,68(s1)
    800059aa:	4785                	li	a5,1
    800059ac:	08f70463          	beq	a4,a5,80005a34 <sys_link+0xea>
  ip->nlink++;
    800059b0:	04a4d783          	lhu	a5,74(s1)
    800059b4:	2785                	addiw	a5,a5,1
    800059b6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800059ba:	8526                	mv	a0,s1
    800059bc:	ffffe097          	auipc	ra,0xffffe
    800059c0:	23e080e7          	jalr	574(ra) # 80003bfa <iupdate>
  iunlock(ip);
    800059c4:	8526                	mv	a0,s1
    800059c6:	ffffe097          	auipc	ra,0xffffe
    800059ca:	3c0080e7          	jalr	960(ra) # 80003d86 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800059ce:	fd040593          	addi	a1,s0,-48
    800059d2:	f5040513          	addi	a0,s0,-176
    800059d6:	fffff097          	auipc	ra,0xfffff
    800059da:	abc080e7          	jalr	-1348(ra) # 80004492 <nameiparent>
    800059de:	892a                	mv	s2,a0
    800059e0:	c935                	beqz	a0,80005a54 <sys_link+0x10a>
  ilock(dp);
    800059e2:	ffffe097          	auipc	ra,0xffffe
    800059e6:	2e2080e7          	jalr	738(ra) # 80003cc4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800059ea:	00092703          	lw	a4,0(s2)
    800059ee:	409c                	lw	a5,0(s1)
    800059f0:	04f71d63          	bne	a4,a5,80005a4a <sys_link+0x100>
    800059f4:	40d0                	lw	a2,4(s1)
    800059f6:	fd040593          	addi	a1,s0,-48
    800059fa:	854a                	mv	a0,s2
    800059fc:	fffff097          	auipc	ra,0xfffff
    80005a00:	9b6080e7          	jalr	-1610(ra) # 800043b2 <dirlink>
    80005a04:	04054363          	bltz	a0,80005a4a <sys_link+0x100>
  iunlockput(dp);
    80005a08:	854a                	mv	a0,s2
    80005a0a:	ffffe097          	auipc	ra,0xffffe
    80005a0e:	51c080e7          	jalr	1308(ra) # 80003f26 <iunlockput>
  iput(ip);
    80005a12:	8526                	mv	a0,s1
    80005a14:	ffffe097          	auipc	ra,0xffffe
    80005a18:	46a080e7          	jalr	1130(ra) # 80003e7e <iput>
  end_op();
    80005a1c:	fffff097          	auipc	ra,0xfffff
    80005a20:	ce8080e7          	jalr	-792(ra) # 80004704 <end_op>
  return 0;
    80005a24:	4781                	li	a5,0
    80005a26:	a085                	j	80005a86 <sys_link+0x13c>
    end_op();
    80005a28:	fffff097          	auipc	ra,0xfffff
    80005a2c:	cdc080e7          	jalr	-804(ra) # 80004704 <end_op>
    return -1;
    80005a30:	57fd                	li	a5,-1
    80005a32:	a891                	j	80005a86 <sys_link+0x13c>
    iunlockput(ip);
    80005a34:	8526                	mv	a0,s1
    80005a36:	ffffe097          	auipc	ra,0xffffe
    80005a3a:	4f0080e7          	jalr	1264(ra) # 80003f26 <iunlockput>
    end_op();
    80005a3e:	fffff097          	auipc	ra,0xfffff
    80005a42:	cc6080e7          	jalr	-826(ra) # 80004704 <end_op>
    return -1;
    80005a46:	57fd                	li	a5,-1
    80005a48:	a83d                	j	80005a86 <sys_link+0x13c>
    iunlockput(dp);
    80005a4a:	854a                	mv	a0,s2
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	4da080e7          	jalr	1242(ra) # 80003f26 <iunlockput>
  ilock(ip);
    80005a54:	8526                	mv	a0,s1
    80005a56:	ffffe097          	auipc	ra,0xffffe
    80005a5a:	26e080e7          	jalr	622(ra) # 80003cc4 <ilock>
  ip->nlink--;
    80005a5e:	04a4d783          	lhu	a5,74(s1)
    80005a62:	37fd                	addiw	a5,a5,-1
    80005a64:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a68:	8526                	mv	a0,s1
    80005a6a:	ffffe097          	auipc	ra,0xffffe
    80005a6e:	190080e7          	jalr	400(ra) # 80003bfa <iupdate>
  iunlockput(ip);
    80005a72:	8526                	mv	a0,s1
    80005a74:	ffffe097          	auipc	ra,0xffffe
    80005a78:	4b2080e7          	jalr	1202(ra) # 80003f26 <iunlockput>
  end_op();
    80005a7c:	fffff097          	auipc	ra,0xfffff
    80005a80:	c88080e7          	jalr	-888(ra) # 80004704 <end_op>
  return -1;
    80005a84:	57fd                	li	a5,-1
}
    80005a86:	853e                	mv	a0,a5
    80005a88:	70b2                	ld	ra,296(sp)
    80005a8a:	7412                	ld	s0,288(sp)
    80005a8c:	64f2                	ld	s1,280(sp)
    80005a8e:	6952                	ld	s2,272(sp)
    80005a90:	6155                	addi	sp,sp,304
    80005a92:	8082                	ret

0000000080005a94 <sys_unlink>:
{
    80005a94:	7151                	addi	sp,sp,-240
    80005a96:	f586                	sd	ra,232(sp)
    80005a98:	f1a2                	sd	s0,224(sp)
    80005a9a:	eda6                	sd	s1,216(sp)
    80005a9c:	e9ca                	sd	s2,208(sp)
    80005a9e:	e5ce                	sd	s3,200(sp)
    80005aa0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005aa2:	08000613          	li	a2,128
    80005aa6:	f3040593          	addi	a1,s0,-208
    80005aaa:	4501                	li	a0,0
    80005aac:	ffffd097          	auipc	ra,0xffffd
    80005ab0:	662080e7          	jalr	1634(ra) # 8000310e <argstr>
    80005ab4:	18054163          	bltz	a0,80005c36 <sys_unlink+0x1a2>
  begin_op();
    80005ab8:	fffff097          	auipc	ra,0xfffff
    80005abc:	bcc080e7          	jalr	-1076(ra) # 80004684 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005ac0:	fb040593          	addi	a1,s0,-80
    80005ac4:	f3040513          	addi	a0,s0,-208
    80005ac8:	fffff097          	auipc	ra,0xfffff
    80005acc:	9ca080e7          	jalr	-1590(ra) # 80004492 <nameiparent>
    80005ad0:	84aa                	mv	s1,a0
    80005ad2:	c979                	beqz	a0,80005ba8 <sys_unlink+0x114>
  ilock(dp);
    80005ad4:	ffffe097          	auipc	ra,0xffffe
    80005ad8:	1f0080e7          	jalr	496(ra) # 80003cc4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005adc:	00003597          	auipc	a1,0x3
    80005ae0:	cd458593          	addi	a1,a1,-812 # 800087b0 <syscalls+0x2c0>
    80005ae4:	fb040513          	addi	a0,s0,-80
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	6a0080e7          	jalr	1696(ra) # 80004188 <namecmp>
    80005af0:	14050a63          	beqz	a0,80005c44 <sys_unlink+0x1b0>
    80005af4:	00003597          	auipc	a1,0x3
    80005af8:	cc458593          	addi	a1,a1,-828 # 800087b8 <syscalls+0x2c8>
    80005afc:	fb040513          	addi	a0,s0,-80
    80005b00:	ffffe097          	auipc	ra,0xffffe
    80005b04:	688080e7          	jalr	1672(ra) # 80004188 <namecmp>
    80005b08:	12050e63          	beqz	a0,80005c44 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005b0c:	f2c40613          	addi	a2,s0,-212
    80005b10:	fb040593          	addi	a1,s0,-80
    80005b14:	8526                	mv	a0,s1
    80005b16:	ffffe097          	auipc	ra,0xffffe
    80005b1a:	68c080e7          	jalr	1676(ra) # 800041a2 <dirlookup>
    80005b1e:	892a                	mv	s2,a0
    80005b20:	12050263          	beqz	a0,80005c44 <sys_unlink+0x1b0>
  ilock(ip);
    80005b24:	ffffe097          	auipc	ra,0xffffe
    80005b28:	1a0080e7          	jalr	416(ra) # 80003cc4 <ilock>
  if(ip->nlink < 1)
    80005b2c:	04a91783          	lh	a5,74(s2)
    80005b30:	08f05263          	blez	a5,80005bb4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005b34:	04491703          	lh	a4,68(s2)
    80005b38:	4785                	li	a5,1
    80005b3a:	08f70563          	beq	a4,a5,80005bc4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005b3e:	4641                	li	a2,16
    80005b40:	4581                	li	a1,0
    80005b42:	fc040513          	addi	a0,s0,-64
    80005b46:	ffffb097          	auipc	ra,0xffffb
    80005b4a:	1b2080e7          	jalr	434(ra) # 80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b4e:	4741                	li	a4,16
    80005b50:	f2c42683          	lw	a3,-212(s0)
    80005b54:	fc040613          	addi	a2,s0,-64
    80005b58:	4581                	li	a1,0
    80005b5a:	8526                	mv	a0,s1
    80005b5c:	ffffe097          	auipc	ra,0xffffe
    80005b60:	512080e7          	jalr	1298(ra) # 8000406e <writei>
    80005b64:	47c1                	li	a5,16
    80005b66:	0af51563          	bne	a0,a5,80005c10 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005b6a:	04491703          	lh	a4,68(s2)
    80005b6e:	4785                	li	a5,1
    80005b70:	0af70863          	beq	a4,a5,80005c20 <sys_unlink+0x18c>
  iunlockput(dp);
    80005b74:	8526                	mv	a0,s1
    80005b76:	ffffe097          	auipc	ra,0xffffe
    80005b7a:	3b0080e7          	jalr	944(ra) # 80003f26 <iunlockput>
  ip->nlink--;
    80005b7e:	04a95783          	lhu	a5,74(s2)
    80005b82:	37fd                	addiw	a5,a5,-1
    80005b84:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b88:	854a                	mv	a0,s2
    80005b8a:	ffffe097          	auipc	ra,0xffffe
    80005b8e:	070080e7          	jalr	112(ra) # 80003bfa <iupdate>
  iunlockput(ip);
    80005b92:	854a                	mv	a0,s2
    80005b94:	ffffe097          	auipc	ra,0xffffe
    80005b98:	392080e7          	jalr	914(ra) # 80003f26 <iunlockput>
  end_op();
    80005b9c:	fffff097          	auipc	ra,0xfffff
    80005ba0:	b68080e7          	jalr	-1176(ra) # 80004704 <end_op>
  return 0;
    80005ba4:	4501                	li	a0,0
    80005ba6:	a84d                	j	80005c58 <sys_unlink+0x1c4>
    end_op();
    80005ba8:	fffff097          	auipc	ra,0xfffff
    80005bac:	b5c080e7          	jalr	-1188(ra) # 80004704 <end_op>
    return -1;
    80005bb0:	557d                	li	a0,-1
    80005bb2:	a05d                	j	80005c58 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005bb4:	00003517          	auipc	a0,0x3
    80005bb8:	c2c50513          	addi	a0,a0,-980 # 800087e0 <syscalls+0x2f0>
    80005bbc:	ffffb097          	auipc	ra,0xffffb
    80005bc0:	984080e7          	jalr	-1660(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bc4:	04c92703          	lw	a4,76(s2)
    80005bc8:	02000793          	li	a5,32
    80005bcc:	f6e7f9e3          	bgeu	a5,a4,80005b3e <sys_unlink+0xaa>
    80005bd0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005bd4:	4741                	li	a4,16
    80005bd6:	86ce                	mv	a3,s3
    80005bd8:	f1840613          	addi	a2,s0,-232
    80005bdc:	4581                	li	a1,0
    80005bde:	854a                	mv	a0,s2
    80005be0:	ffffe097          	auipc	ra,0xffffe
    80005be4:	398080e7          	jalr	920(ra) # 80003f78 <readi>
    80005be8:	47c1                	li	a5,16
    80005bea:	00f51b63          	bne	a0,a5,80005c00 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005bee:	f1845783          	lhu	a5,-232(s0)
    80005bf2:	e7a1                	bnez	a5,80005c3a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bf4:	29c1                	addiw	s3,s3,16
    80005bf6:	04c92783          	lw	a5,76(s2)
    80005bfa:	fcf9ede3          	bltu	s3,a5,80005bd4 <sys_unlink+0x140>
    80005bfe:	b781                	j	80005b3e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005c00:	00003517          	auipc	a0,0x3
    80005c04:	bf850513          	addi	a0,a0,-1032 # 800087f8 <syscalls+0x308>
    80005c08:	ffffb097          	auipc	ra,0xffffb
    80005c0c:	938080e7          	jalr	-1736(ra) # 80000540 <panic>
    panic("unlink: writei");
    80005c10:	00003517          	auipc	a0,0x3
    80005c14:	c0050513          	addi	a0,a0,-1024 # 80008810 <syscalls+0x320>
    80005c18:	ffffb097          	auipc	ra,0xffffb
    80005c1c:	928080e7          	jalr	-1752(ra) # 80000540 <panic>
    dp->nlink--;
    80005c20:	04a4d783          	lhu	a5,74(s1)
    80005c24:	37fd                	addiw	a5,a5,-1
    80005c26:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005c2a:	8526                	mv	a0,s1
    80005c2c:	ffffe097          	auipc	ra,0xffffe
    80005c30:	fce080e7          	jalr	-50(ra) # 80003bfa <iupdate>
    80005c34:	b781                	j	80005b74 <sys_unlink+0xe0>
    return -1;
    80005c36:	557d                	li	a0,-1
    80005c38:	a005                	j	80005c58 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005c3a:	854a                	mv	a0,s2
    80005c3c:	ffffe097          	auipc	ra,0xffffe
    80005c40:	2ea080e7          	jalr	746(ra) # 80003f26 <iunlockput>
  iunlockput(dp);
    80005c44:	8526                	mv	a0,s1
    80005c46:	ffffe097          	auipc	ra,0xffffe
    80005c4a:	2e0080e7          	jalr	736(ra) # 80003f26 <iunlockput>
  end_op();
    80005c4e:	fffff097          	auipc	ra,0xfffff
    80005c52:	ab6080e7          	jalr	-1354(ra) # 80004704 <end_op>
  return -1;
    80005c56:	557d                	li	a0,-1
}
    80005c58:	70ae                	ld	ra,232(sp)
    80005c5a:	740e                	ld	s0,224(sp)
    80005c5c:	64ee                	ld	s1,216(sp)
    80005c5e:	694e                	ld	s2,208(sp)
    80005c60:	69ae                	ld	s3,200(sp)
    80005c62:	616d                	addi	sp,sp,240
    80005c64:	8082                	ret

0000000080005c66 <sys_open>:

uint64
sys_open(void)
{
    80005c66:	7131                	addi	sp,sp,-192
    80005c68:	fd06                	sd	ra,184(sp)
    80005c6a:	f922                	sd	s0,176(sp)
    80005c6c:	f526                	sd	s1,168(sp)
    80005c6e:	f14a                	sd	s2,160(sp)
    80005c70:	ed4e                	sd	s3,152(sp)
    80005c72:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005c74:	08000613          	li	a2,128
    80005c78:	f5040593          	addi	a1,s0,-176
    80005c7c:	4501                	li	a0,0
    80005c7e:	ffffd097          	auipc	ra,0xffffd
    80005c82:	490080e7          	jalr	1168(ra) # 8000310e <argstr>
    return -1;
    80005c86:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005c88:	0c054163          	bltz	a0,80005d4a <sys_open+0xe4>
    80005c8c:	f4c40593          	addi	a1,s0,-180
    80005c90:	4505                	li	a0,1
    80005c92:	ffffd097          	auipc	ra,0xffffd
    80005c96:	438080e7          	jalr	1080(ra) # 800030ca <argint>
    80005c9a:	0a054863          	bltz	a0,80005d4a <sys_open+0xe4>

  begin_op();
    80005c9e:	fffff097          	auipc	ra,0xfffff
    80005ca2:	9e6080e7          	jalr	-1562(ra) # 80004684 <begin_op>

  if(omode & O_CREATE){
    80005ca6:	f4c42783          	lw	a5,-180(s0)
    80005caa:	2007f793          	andi	a5,a5,512
    80005cae:	cbdd                	beqz	a5,80005d64 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005cb0:	4681                	li	a3,0
    80005cb2:	4601                	li	a2,0
    80005cb4:	4589                	li	a1,2
    80005cb6:	f5040513          	addi	a0,s0,-176
    80005cba:	00000097          	auipc	ra,0x0
    80005cbe:	974080e7          	jalr	-1676(ra) # 8000562e <create>
    80005cc2:	892a                	mv	s2,a0
    if(ip == 0){
    80005cc4:	c959                	beqz	a0,80005d5a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005cc6:	04491703          	lh	a4,68(s2)
    80005cca:	478d                	li	a5,3
    80005ccc:	00f71763          	bne	a4,a5,80005cda <sys_open+0x74>
    80005cd0:	04695703          	lhu	a4,70(s2)
    80005cd4:	47a5                	li	a5,9
    80005cd6:	0ce7ec63          	bltu	a5,a4,80005dae <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005cda:	fffff097          	auipc	ra,0xfffff
    80005cde:	dc0080e7          	jalr	-576(ra) # 80004a9a <filealloc>
    80005ce2:	89aa                	mv	s3,a0
    80005ce4:	10050263          	beqz	a0,80005de8 <sys_open+0x182>
    80005ce8:	00000097          	auipc	ra,0x0
    80005cec:	904080e7          	jalr	-1788(ra) # 800055ec <fdalloc>
    80005cf0:	84aa                	mv	s1,a0
    80005cf2:	0e054663          	bltz	a0,80005dde <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005cf6:	04491703          	lh	a4,68(s2)
    80005cfa:	478d                	li	a5,3
    80005cfc:	0cf70463          	beq	a4,a5,80005dc4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005d00:	4789                	li	a5,2
    80005d02:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005d06:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005d0a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005d0e:	f4c42783          	lw	a5,-180(s0)
    80005d12:	0017c713          	xori	a4,a5,1
    80005d16:	8b05                	andi	a4,a4,1
    80005d18:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005d1c:	0037f713          	andi	a4,a5,3
    80005d20:	00e03733          	snez	a4,a4
    80005d24:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005d28:	4007f793          	andi	a5,a5,1024
    80005d2c:	c791                	beqz	a5,80005d38 <sys_open+0xd2>
    80005d2e:	04491703          	lh	a4,68(s2)
    80005d32:	4789                	li	a5,2
    80005d34:	08f70f63          	beq	a4,a5,80005dd2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005d38:	854a                	mv	a0,s2
    80005d3a:	ffffe097          	auipc	ra,0xffffe
    80005d3e:	04c080e7          	jalr	76(ra) # 80003d86 <iunlock>
  end_op();
    80005d42:	fffff097          	auipc	ra,0xfffff
    80005d46:	9c2080e7          	jalr	-1598(ra) # 80004704 <end_op>

  return fd;
}
    80005d4a:	8526                	mv	a0,s1
    80005d4c:	70ea                	ld	ra,184(sp)
    80005d4e:	744a                	ld	s0,176(sp)
    80005d50:	74aa                	ld	s1,168(sp)
    80005d52:	790a                	ld	s2,160(sp)
    80005d54:	69ea                	ld	s3,152(sp)
    80005d56:	6129                	addi	sp,sp,192
    80005d58:	8082                	ret
      end_op();
    80005d5a:	fffff097          	auipc	ra,0xfffff
    80005d5e:	9aa080e7          	jalr	-1622(ra) # 80004704 <end_op>
      return -1;
    80005d62:	b7e5                	j	80005d4a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005d64:	f5040513          	addi	a0,s0,-176
    80005d68:	ffffe097          	auipc	ra,0xffffe
    80005d6c:	70c080e7          	jalr	1804(ra) # 80004474 <namei>
    80005d70:	892a                	mv	s2,a0
    80005d72:	c905                	beqz	a0,80005da2 <sys_open+0x13c>
    ilock(ip);
    80005d74:	ffffe097          	auipc	ra,0xffffe
    80005d78:	f50080e7          	jalr	-176(ra) # 80003cc4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005d7c:	04491703          	lh	a4,68(s2)
    80005d80:	4785                	li	a5,1
    80005d82:	f4f712e3          	bne	a4,a5,80005cc6 <sys_open+0x60>
    80005d86:	f4c42783          	lw	a5,-180(s0)
    80005d8a:	dba1                	beqz	a5,80005cda <sys_open+0x74>
      iunlockput(ip);
    80005d8c:	854a                	mv	a0,s2
    80005d8e:	ffffe097          	auipc	ra,0xffffe
    80005d92:	198080e7          	jalr	408(ra) # 80003f26 <iunlockput>
      end_op();
    80005d96:	fffff097          	auipc	ra,0xfffff
    80005d9a:	96e080e7          	jalr	-1682(ra) # 80004704 <end_op>
      return -1;
    80005d9e:	54fd                	li	s1,-1
    80005da0:	b76d                	j	80005d4a <sys_open+0xe4>
      end_op();
    80005da2:	fffff097          	auipc	ra,0xfffff
    80005da6:	962080e7          	jalr	-1694(ra) # 80004704 <end_op>
      return -1;
    80005daa:	54fd                	li	s1,-1
    80005dac:	bf79                	j	80005d4a <sys_open+0xe4>
    iunlockput(ip);
    80005dae:	854a                	mv	a0,s2
    80005db0:	ffffe097          	auipc	ra,0xffffe
    80005db4:	176080e7          	jalr	374(ra) # 80003f26 <iunlockput>
    end_op();
    80005db8:	fffff097          	auipc	ra,0xfffff
    80005dbc:	94c080e7          	jalr	-1716(ra) # 80004704 <end_op>
    return -1;
    80005dc0:	54fd                	li	s1,-1
    80005dc2:	b761                	j	80005d4a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005dc4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005dc8:	04691783          	lh	a5,70(s2)
    80005dcc:	02f99223          	sh	a5,36(s3)
    80005dd0:	bf2d                	j	80005d0a <sys_open+0xa4>
    itrunc(ip);
    80005dd2:	854a                	mv	a0,s2
    80005dd4:	ffffe097          	auipc	ra,0xffffe
    80005dd8:	ffe080e7          	jalr	-2(ra) # 80003dd2 <itrunc>
    80005ddc:	bfb1                	j	80005d38 <sys_open+0xd2>
      fileclose(f);
    80005dde:	854e                	mv	a0,s3
    80005de0:	fffff097          	auipc	ra,0xfffff
    80005de4:	d76080e7          	jalr	-650(ra) # 80004b56 <fileclose>
    iunlockput(ip);
    80005de8:	854a                	mv	a0,s2
    80005dea:	ffffe097          	auipc	ra,0xffffe
    80005dee:	13c080e7          	jalr	316(ra) # 80003f26 <iunlockput>
    end_op();
    80005df2:	fffff097          	auipc	ra,0xfffff
    80005df6:	912080e7          	jalr	-1774(ra) # 80004704 <end_op>
    return -1;
    80005dfa:	54fd                	li	s1,-1
    80005dfc:	b7b9                	j	80005d4a <sys_open+0xe4>

0000000080005dfe <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005dfe:	7175                	addi	sp,sp,-144
    80005e00:	e506                	sd	ra,136(sp)
    80005e02:	e122                	sd	s0,128(sp)
    80005e04:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005e06:	fffff097          	auipc	ra,0xfffff
    80005e0a:	87e080e7          	jalr	-1922(ra) # 80004684 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005e0e:	08000613          	li	a2,128
    80005e12:	f7040593          	addi	a1,s0,-144
    80005e16:	4501                	li	a0,0
    80005e18:	ffffd097          	auipc	ra,0xffffd
    80005e1c:	2f6080e7          	jalr	758(ra) # 8000310e <argstr>
    80005e20:	02054963          	bltz	a0,80005e52 <sys_mkdir+0x54>
    80005e24:	4681                	li	a3,0
    80005e26:	4601                	li	a2,0
    80005e28:	4585                	li	a1,1
    80005e2a:	f7040513          	addi	a0,s0,-144
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	800080e7          	jalr	-2048(ra) # 8000562e <create>
    80005e36:	cd11                	beqz	a0,80005e52 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e38:	ffffe097          	auipc	ra,0xffffe
    80005e3c:	0ee080e7          	jalr	238(ra) # 80003f26 <iunlockput>
  end_op();
    80005e40:	fffff097          	auipc	ra,0xfffff
    80005e44:	8c4080e7          	jalr	-1852(ra) # 80004704 <end_op>
  return 0;
    80005e48:	4501                	li	a0,0
}
    80005e4a:	60aa                	ld	ra,136(sp)
    80005e4c:	640a                	ld	s0,128(sp)
    80005e4e:	6149                	addi	sp,sp,144
    80005e50:	8082                	ret
    end_op();
    80005e52:	fffff097          	auipc	ra,0xfffff
    80005e56:	8b2080e7          	jalr	-1870(ra) # 80004704 <end_op>
    return -1;
    80005e5a:	557d                	li	a0,-1
    80005e5c:	b7fd                	j	80005e4a <sys_mkdir+0x4c>

0000000080005e5e <sys_mknod>:

uint64
sys_mknod(void)
{
    80005e5e:	7135                	addi	sp,sp,-160
    80005e60:	ed06                	sd	ra,152(sp)
    80005e62:	e922                	sd	s0,144(sp)
    80005e64:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005e66:	fffff097          	auipc	ra,0xfffff
    80005e6a:	81e080e7          	jalr	-2018(ra) # 80004684 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e6e:	08000613          	li	a2,128
    80005e72:	f7040593          	addi	a1,s0,-144
    80005e76:	4501                	li	a0,0
    80005e78:	ffffd097          	auipc	ra,0xffffd
    80005e7c:	296080e7          	jalr	662(ra) # 8000310e <argstr>
    80005e80:	04054a63          	bltz	a0,80005ed4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005e84:	f6c40593          	addi	a1,s0,-148
    80005e88:	4505                	li	a0,1
    80005e8a:	ffffd097          	auipc	ra,0xffffd
    80005e8e:	240080e7          	jalr	576(ra) # 800030ca <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e92:	04054163          	bltz	a0,80005ed4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005e96:	f6840593          	addi	a1,s0,-152
    80005e9a:	4509                	li	a0,2
    80005e9c:	ffffd097          	auipc	ra,0xffffd
    80005ea0:	22e080e7          	jalr	558(ra) # 800030ca <argint>
     argint(1, &major) < 0 ||
    80005ea4:	02054863          	bltz	a0,80005ed4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005ea8:	f6841683          	lh	a3,-152(s0)
    80005eac:	f6c41603          	lh	a2,-148(s0)
    80005eb0:	458d                	li	a1,3
    80005eb2:	f7040513          	addi	a0,s0,-144
    80005eb6:	fffff097          	auipc	ra,0xfffff
    80005eba:	778080e7          	jalr	1912(ra) # 8000562e <create>
     argint(2, &minor) < 0 ||
    80005ebe:	c919                	beqz	a0,80005ed4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005ec0:	ffffe097          	auipc	ra,0xffffe
    80005ec4:	066080e7          	jalr	102(ra) # 80003f26 <iunlockput>
  end_op();
    80005ec8:	fffff097          	auipc	ra,0xfffff
    80005ecc:	83c080e7          	jalr	-1988(ra) # 80004704 <end_op>
  return 0;
    80005ed0:	4501                	li	a0,0
    80005ed2:	a031                	j	80005ede <sys_mknod+0x80>
    end_op();
    80005ed4:	fffff097          	auipc	ra,0xfffff
    80005ed8:	830080e7          	jalr	-2000(ra) # 80004704 <end_op>
    return -1;
    80005edc:	557d                	li	a0,-1
}
    80005ede:	60ea                	ld	ra,152(sp)
    80005ee0:	644a                	ld	s0,144(sp)
    80005ee2:	610d                	addi	sp,sp,160
    80005ee4:	8082                	ret

0000000080005ee6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005ee6:	7135                	addi	sp,sp,-160
    80005ee8:	ed06                	sd	ra,152(sp)
    80005eea:	e922                	sd	s0,144(sp)
    80005eec:	e526                	sd	s1,136(sp)
    80005eee:	e14a                	sd	s2,128(sp)
    80005ef0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ef2:	ffffc097          	auipc	ra,0xffffc
    80005ef6:	02a080e7          	jalr	42(ra) # 80001f1c <myproc>
    80005efa:	892a                	mv	s2,a0
  
  begin_op();
    80005efc:	ffffe097          	auipc	ra,0xffffe
    80005f00:	788080e7          	jalr	1928(ra) # 80004684 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005f04:	08000613          	li	a2,128
    80005f08:	f6040593          	addi	a1,s0,-160
    80005f0c:	4501                	li	a0,0
    80005f0e:	ffffd097          	auipc	ra,0xffffd
    80005f12:	200080e7          	jalr	512(ra) # 8000310e <argstr>
    80005f16:	04054b63          	bltz	a0,80005f6c <sys_chdir+0x86>
    80005f1a:	f6040513          	addi	a0,s0,-160
    80005f1e:	ffffe097          	auipc	ra,0xffffe
    80005f22:	556080e7          	jalr	1366(ra) # 80004474 <namei>
    80005f26:	84aa                	mv	s1,a0
    80005f28:	c131                	beqz	a0,80005f6c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005f2a:	ffffe097          	auipc	ra,0xffffe
    80005f2e:	d9a080e7          	jalr	-614(ra) # 80003cc4 <ilock>
  if(ip->type != T_DIR){
    80005f32:	04449703          	lh	a4,68(s1)
    80005f36:	4785                	li	a5,1
    80005f38:	04f71063          	bne	a4,a5,80005f78 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f3c:	8526                	mv	a0,s1
    80005f3e:	ffffe097          	auipc	ra,0xffffe
    80005f42:	e48080e7          	jalr	-440(ra) # 80003d86 <iunlock>
  iput(p->cwd);
    80005f46:	15093503          	ld	a0,336(s2)
    80005f4a:	ffffe097          	auipc	ra,0xffffe
    80005f4e:	f34080e7          	jalr	-204(ra) # 80003e7e <iput>
  end_op();
    80005f52:	ffffe097          	auipc	ra,0xffffe
    80005f56:	7b2080e7          	jalr	1970(ra) # 80004704 <end_op>
  p->cwd = ip;
    80005f5a:	14993823          	sd	s1,336(s2)
  return 0;
    80005f5e:	4501                	li	a0,0
}
    80005f60:	60ea                	ld	ra,152(sp)
    80005f62:	644a                	ld	s0,144(sp)
    80005f64:	64aa                	ld	s1,136(sp)
    80005f66:	690a                	ld	s2,128(sp)
    80005f68:	610d                	addi	sp,sp,160
    80005f6a:	8082                	ret
    end_op();
    80005f6c:	ffffe097          	auipc	ra,0xffffe
    80005f70:	798080e7          	jalr	1944(ra) # 80004704 <end_op>
    return -1;
    80005f74:	557d                	li	a0,-1
    80005f76:	b7ed                	j	80005f60 <sys_chdir+0x7a>
    iunlockput(ip);
    80005f78:	8526                	mv	a0,s1
    80005f7a:	ffffe097          	auipc	ra,0xffffe
    80005f7e:	fac080e7          	jalr	-84(ra) # 80003f26 <iunlockput>
    end_op();
    80005f82:	ffffe097          	auipc	ra,0xffffe
    80005f86:	782080e7          	jalr	1922(ra) # 80004704 <end_op>
    return -1;
    80005f8a:	557d                	li	a0,-1
    80005f8c:	bfd1                	j	80005f60 <sys_chdir+0x7a>

0000000080005f8e <sys_exec>:

uint64
sys_exec(void)
{
    80005f8e:	7145                	addi	sp,sp,-464
    80005f90:	e786                	sd	ra,456(sp)
    80005f92:	e3a2                	sd	s0,448(sp)
    80005f94:	ff26                	sd	s1,440(sp)
    80005f96:	fb4a                	sd	s2,432(sp)
    80005f98:	f74e                	sd	s3,424(sp)
    80005f9a:	f352                	sd	s4,416(sp)
    80005f9c:	ef56                	sd	s5,408(sp)
    80005f9e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005fa0:	08000613          	li	a2,128
    80005fa4:	f4040593          	addi	a1,s0,-192
    80005fa8:	4501                	li	a0,0
    80005faa:	ffffd097          	auipc	ra,0xffffd
    80005fae:	164080e7          	jalr	356(ra) # 8000310e <argstr>
    return -1;
    80005fb2:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005fb4:	0c054a63          	bltz	a0,80006088 <sys_exec+0xfa>
    80005fb8:	e3840593          	addi	a1,s0,-456
    80005fbc:	4505                	li	a0,1
    80005fbe:	ffffd097          	auipc	ra,0xffffd
    80005fc2:	12e080e7          	jalr	302(ra) # 800030ec <argaddr>
    80005fc6:	0c054163          	bltz	a0,80006088 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005fca:	10000613          	li	a2,256
    80005fce:	4581                	li	a1,0
    80005fd0:	e4040513          	addi	a0,s0,-448
    80005fd4:	ffffb097          	auipc	ra,0xffffb
    80005fd8:	d24080e7          	jalr	-732(ra) # 80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005fdc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005fe0:	89a6                	mv	s3,s1
    80005fe2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005fe4:	02000a13          	li	s4,32
    80005fe8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005fec:	00391793          	slli	a5,s2,0x3
    80005ff0:	e3040593          	addi	a1,s0,-464
    80005ff4:	e3843503          	ld	a0,-456(s0)
    80005ff8:	953e                	add	a0,a0,a5
    80005ffa:	ffffd097          	auipc	ra,0xffffd
    80005ffe:	036080e7          	jalr	54(ra) # 80003030 <fetchaddr>
    80006002:	02054a63          	bltz	a0,80006036 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80006006:	e3043783          	ld	a5,-464(s0)
    8000600a:	c3b9                	beqz	a5,80006050 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000600c:	ffffb097          	auipc	ra,0xffffb
    80006010:	b00080e7          	jalr	-1280(ra) # 80000b0c <kalloc>
    80006014:	85aa                	mv	a1,a0
    80006016:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000601a:	cd11                	beqz	a0,80006036 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000601c:	6605                	lui	a2,0x1
    8000601e:	e3043503          	ld	a0,-464(s0)
    80006022:	ffffd097          	auipc	ra,0xffffd
    80006026:	060080e7          	jalr	96(ra) # 80003082 <fetchstr>
    8000602a:	00054663          	bltz	a0,80006036 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000602e:	0905                	addi	s2,s2,1
    80006030:	09a1                	addi	s3,s3,8
    80006032:	fb491be3          	bne	s2,s4,80005fe8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006036:	10048913          	addi	s2,s1,256
    8000603a:	6088                	ld	a0,0(s1)
    8000603c:	c529                	beqz	a0,80006086 <sys_exec+0xf8>
    kfree(argv[i]);
    8000603e:	ffffb097          	auipc	ra,0xffffb
    80006042:	9d2080e7          	jalr	-1582(ra) # 80000a10 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006046:	04a1                	addi	s1,s1,8
    80006048:	ff2499e3          	bne	s1,s2,8000603a <sys_exec+0xac>
  return -1;
    8000604c:	597d                	li	s2,-1
    8000604e:	a82d                	j	80006088 <sys_exec+0xfa>
      argv[i] = 0;
    80006050:	0a8e                	slli	s5,s5,0x3
    80006052:	fc040793          	addi	a5,s0,-64
    80006056:	9abe                	add	s5,s5,a5
    80006058:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd7e80>
  int ret = exec(path, argv);
    8000605c:	e4040593          	addi	a1,s0,-448
    80006060:	f4040513          	addi	a0,s0,-192
    80006064:	fffff097          	auipc	ra,0xfffff
    80006068:	178080e7          	jalr	376(ra) # 800051dc <exec>
    8000606c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000606e:	10048993          	addi	s3,s1,256
    80006072:	6088                	ld	a0,0(s1)
    80006074:	c911                	beqz	a0,80006088 <sys_exec+0xfa>
    kfree(argv[i]);
    80006076:	ffffb097          	auipc	ra,0xffffb
    8000607a:	99a080e7          	jalr	-1638(ra) # 80000a10 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000607e:	04a1                	addi	s1,s1,8
    80006080:	ff3499e3          	bne	s1,s3,80006072 <sys_exec+0xe4>
    80006084:	a011                	j	80006088 <sys_exec+0xfa>
  return -1;
    80006086:	597d                	li	s2,-1
}
    80006088:	854a                	mv	a0,s2
    8000608a:	60be                	ld	ra,456(sp)
    8000608c:	641e                	ld	s0,448(sp)
    8000608e:	74fa                	ld	s1,440(sp)
    80006090:	795a                	ld	s2,432(sp)
    80006092:	79ba                	ld	s3,424(sp)
    80006094:	7a1a                	ld	s4,416(sp)
    80006096:	6afa                	ld	s5,408(sp)
    80006098:	6179                	addi	sp,sp,464
    8000609a:	8082                	ret

000000008000609c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000609c:	7139                	addi	sp,sp,-64
    8000609e:	fc06                	sd	ra,56(sp)
    800060a0:	f822                	sd	s0,48(sp)
    800060a2:	f426                	sd	s1,40(sp)
    800060a4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800060a6:	ffffc097          	auipc	ra,0xffffc
    800060aa:	e76080e7          	jalr	-394(ra) # 80001f1c <myproc>
    800060ae:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800060b0:	fd840593          	addi	a1,s0,-40
    800060b4:	4501                	li	a0,0
    800060b6:	ffffd097          	auipc	ra,0xffffd
    800060ba:	036080e7          	jalr	54(ra) # 800030ec <argaddr>
    return -1;
    800060be:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800060c0:	0e054063          	bltz	a0,800061a0 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800060c4:	fc840593          	addi	a1,s0,-56
    800060c8:	fd040513          	addi	a0,s0,-48
    800060cc:	fffff097          	auipc	ra,0xfffff
    800060d0:	de0080e7          	jalr	-544(ra) # 80004eac <pipealloc>
    return -1;
    800060d4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800060d6:	0c054563          	bltz	a0,800061a0 <sys_pipe+0x104>
  fd0 = -1;
    800060da:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800060de:	fd043503          	ld	a0,-48(s0)
    800060e2:	fffff097          	auipc	ra,0xfffff
    800060e6:	50a080e7          	jalr	1290(ra) # 800055ec <fdalloc>
    800060ea:	fca42223          	sw	a0,-60(s0)
    800060ee:	08054c63          	bltz	a0,80006186 <sys_pipe+0xea>
    800060f2:	fc843503          	ld	a0,-56(s0)
    800060f6:	fffff097          	auipc	ra,0xfffff
    800060fa:	4f6080e7          	jalr	1270(ra) # 800055ec <fdalloc>
    800060fe:	fca42023          	sw	a0,-64(s0)
    80006102:	06054863          	bltz	a0,80006172 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006106:	4691                	li	a3,4
    80006108:	fc440613          	addi	a2,s0,-60
    8000610c:	fd843583          	ld	a1,-40(s0)
    80006110:	68a8                	ld	a0,80(s1)
    80006112:	ffffb097          	auipc	ra,0xffffb
    80006116:	598080e7          	jalr	1432(ra) # 800016aa <copyout>
    8000611a:	02054063          	bltz	a0,8000613a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000611e:	4691                	li	a3,4
    80006120:	fc040613          	addi	a2,s0,-64
    80006124:	fd843583          	ld	a1,-40(s0)
    80006128:	0591                	addi	a1,a1,4
    8000612a:	68a8                	ld	a0,80(s1)
    8000612c:	ffffb097          	auipc	ra,0xffffb
    80006130:	57e080e7          	jalr	1406(ra) # 800016aa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006134:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006136:	06055563          	bgez	a0,800061a0 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000613a:	fc442783          	lw	a5,-60(s0)
    8000613e:	07e9                	addi	a5,a5,26
    80006140:	078e                	slli	a5,a5,0x3
    80006142:	97a6                	add	a5,a5,s1
    80006144:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006148:	fc042503          	lw	a0,-64(s0)
    8000614c:	0569                	addi	a0,a0,26
    8000614e:	050e                	slli	a0,a0,0x3
    80006150:	9526                	add	a0,a0,s1
    80006152:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006156:	fd043503          	ld	a0,-48(s0)
    8000615a:	fffff097          	auipc	ra,0xfffff
    8000615e:	9fc080e7          	jalr	-1540(ra) # 80004b56 <fileclose>
    fileclose(wf);
    80006162:	fc843503          	ld	a0,-56(s0)
    80006166:	fffff097          	auipc	ra,0xfffff
    8000616a:	9f0080e7          	jalr	-1552(ra) # 80004b56 <fileclose>
    return -1;
    8000616e:	57fd                	li	a5,-1
    80006170:	a805                	j	800061a0 <sys_pipe+0x104>
    if(fd0 >= 0)
    80006172:	fc442783          	lw	a5,-60(s0)
    80006176:	0007c863          	bltz	a5,80006186 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000617a:	01a78513          	addi	a0,a5,26
    8000617e:	050e                	slli	a0,a0,0x3
    80006180:	9526                	add	a0,a0,s1
    80006182:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006186:	fd043503          	ld	a0,-48(s0)
    8000618a:	fffff097          	auipc	ra,0xfffff
    8000618e:	9cc080e7          	jalr	-1588(ra) # 80004b56 <fileclose>
    fileclose(wf);
    80006192:	fc843503          	ld	a0,-56(s0)
    80006196:	fffff097          	auipc	ra,0xfffff
    8000619a:	9c0080e7          	jalr	-1600(ra) # 80004b56 <fileclose>
    return -1;
    8000619e:	57fd                	li	a5,-1
}
    800061a0:	853e                	mv	a0,a5
    800061a2:	70e2                	ld	ra,56(sp)
    800061a4:	7442                	ld	s0,48(sp)
    800061a6:	74a2                	ld	s1,40(sp)
    800061a8:	6121                	addi	sp,sp,64
    800061aa:	8082                	ret
    800061ac:	0000                	unimp
	...

00000000800061b0 <kernelvec>:
    800061b0:	7111                	addi	sp,sp,-256
    800061b2:	e006                	sd	ra,0(sp)
    800061b4:	e40a                	sd	sp,8(sp)
    800061b6:	e80e                	sd	gp,16(sp)
    800061b8:	ec12                	sd	tp,24(sp)
    800061ba:	f016                	sd	t0,32(sp)
    800061bc:	f41a                	sd	t1,40(sp)
    800061be:	f81e                	sd	t2,48(sp)
    800061c0:	fc22                	sd	s0,56(sp)
    800061c2:	e0a6                	sd	s1,64(sp)
    800061c4:	e4aa                	sd	a0,72(sp)
    800061c6:	e8ae                	sd	a1,80(sp)
    800061c8:	ecb2                	sd	a2,88(sp)
    800061ca:	f0b6                	sd	a3,96(sp)
    800061cc:	f4ba                	sd	a4,104(sp)
    800061ce:	f8be                	sd	a5,112(sp)
    800061d0:	fcc2                	sd	a6,120(sp)
    800061d2:	e146                	sd	a7,128(sp)
    800061d4:	e54a                	sd	s2,136(sp)
    800061d6:	e94e                	sd	s3,144(sp)
    800061d8:	ed52                	sd	s4,152(sp)
    800061da:	f156                	sd	s5,160(sp)
    800061dc:	f55a                	sd	s6,168(sp)
    800061de:	f95e                	sd	s7,176(sp)
    800061e0:	fd62                	sd	s8,184(sp)
    800061e2:	e1e6                	sd	s9,192(sp)
    800061e4:	e5ea                	sd	s10,200(sp)
    800061e6:	e9ee                	sd	s11,208(sp)
    800061e8:	edf2                	sd	t3,216(sp)
    800061ea:	f1f6                	sd	t4,224(sp)
    800061ec:	f5fa                	sd	t5,232(sp)
    800061ee:	f9fe                	sd	t6,240(sp)
    800061f0:	d0dfc0ef          	jal	ra,80002efc <kerneltrap>
    800061f4:	6082                	ld	ra,0(sp)
    800061f6:	6122                	ld	sp,8(sp)
    800061f8:	61c2                	ld	gp,16(sp)
    800061fa:	7282                	ld	t0,32(sp)
    800061fc:	7322                	ld	t1,40(sp)
    800061fe:	73c2                	ld	t2,48(sp)
    80006200:	7462                	ld	s0,56(sp)
    80006202:	6486                	ld	s1,64(sp)
    80006204:	6526                	ld	a0,72(sp)
    80006206:	65c6                	ld	a1,80(sp)
    80006208:	6666                	ld	a2,88(sp)
    8000620a:	7686                	ld	a3,96(sp)
    8000620c:	7726                	ld	a4,104(sp)
    8000620e:	77c6                	ld	a5,112(sp)
    80006210:	7866                	ld	a6,120(sp)
    80006212:	688a                	ld	a7,128(sp)
    80006214:	692a                	ld	s2,136(sp)
    80006216:	69ca                	ld	s3,144(sp)
    80006218:	6a6a                	ld	s4,152(sp)
    8000621a:	7a8a                	ld	s5,160(sp)
    8000621c:	7b2a                	ld	s6,168(sp)
    8000621e:	7bca                	ld	s7,176(sp)
    80006220:	7c6a                	ld	s8,184(sp)
    80006222:	6c8e                	ld	s9,192(sp)
    80006224:	6d2e                	ld	s10,200(sp)
    80006226:	6dce                	ld	s11,208(sp)
    80006228:	6e6e                	ld	t3,216(sp)
    8000622a:	7e8e                	ld	t4,224(sp)
    8000622c:	7f2e                	ld	t5,232(sp)
    8000622e:	7fce                	ld	t6,240(sp)
    80006230:	6111                	addi	sp,sp,256
    80006232:	10200073          	sret
    80006236:	00000013          	nop
    8000623a:	00000013          	nop
    8000623e:	0001                	nop

0000000080006240 <timervec>:
    80006240:	34051573          	csrrw	a0,mscratch,a0
    80006244:	e10c                	sd	a1,0(a0)
    80006246:	e510                	sd	a2,8(a0)
    80006248:	e914                	sd	a3,16(a0)
    8000624a:	710c                	ld	a1,32(a0)
    8000624c:	7510                	ld	a2,40(a0)
    8000624e:	6194                	ld	a3,0(a1)
    80006250:	96b2                	add	a3,a3,a2
    80006252:	e194                	sd	a3,0(a1)
    80006254:	4589                	li	a1,2
    80006256:	14459073          	csrw	sip,a1
    8000625a:	6914                	ld	a3,16(a0)
    8000625c:	6510                	ld	a2,8(a0)
    8000625e:	610c                	ld	a1,0(a0)
    80006260:	34051573          	csrrw	a0,mscratch,a0
    80006264:	30200073          	mret
	...

000000008000626a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000626a:	1141                	addi	sp,sp,-16
    8000626c:	e422                	sd	s0,8(sp)
    8000626e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006270:	0c0007b7          	lui	a5,0xc000
    80006274:	4705                	li	a4,1
    80006276:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006278:	c3d8                	sw	a4,4(a5)
}
    8000627a:	6422                	ld	s0,8(sp)
    8000627c:	0141                	addi	sp,sp,16
    8000627e:	8082                	ret

0000000080006280 <plicinithart>:

void
plicinithart(void)
{
    80006280:	1141                	addi	sp,sp,-16
    80006282:	e406                	sd	ra,8(sp)
    80006284:	e022                	sd	s0,0(sp)
    80006286:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006288:	ffffc097          	auipc	ra,0xffffc
    8000628c:	c68080e7          	jalr	-920(ra) # 80001ef0 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006290:	0085171b          	slliw	a4,a0,0x8
    80006294:	0c0027b7          	lui	a5,0xc002
    80006298:	97ba                	add	a5,a5,a4
    8000629a:	40200713          	li	a4,1026
    8000629e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800062a2:	00d5151b          	slliw	a0,a0,0xd
    800062a6:	0c2017b7          	lui	a5,0xc201
    800062aa:	953e                	add	a0,a0,a5
    800062ac:	00052023          	sw	zero,0(a0)
}
    800062b0:	60a2                	ld	ra,8(sp)
    800062b2:	6402                	ld	s0,0(sp)
    800062b4:	0141                	addi	sp,sp,16
    800062b6:	8082                	ret

00000000800062b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800062b8:	1141                	addi	sp,sp,-16
    800062ba:	e406                	sd	ra,8(sp)
    800062bc:	e022                	sd	s0,0(sp)
    800062be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800062c0:	ffffc097          	auipc	ra,0xffffc
    800062c4:	c30080e7          	jalr	-976(ra) # 80001ef0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800062c8:	00d5179b          	slliw	a5,a0,0xd
    800062cc:	0c201537          	lui	a0,0xc201
    800062d0:	953e                	add	a0,a0,a5
  return irq;
}
    800062d2:	4148                	lw	a0,4(a0)
    800062d4:	60a2                	ld	ra,8(sp)
    800062d6:	6402                	ld	s0,0(sp)
    800062d8:	0141                	addi	sp,sp,16
    800062da:	8082                	ret

00000000800062dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800062dc:	1101                	addi	sp,sp,-32
    800062de:	ec06                	sd	ra,24(sp)
    800062e0:	e822                	sd	s0,16(sp)
    800062e2:	e426                	sd	s1,8(sp)
    800062e4:	1000                	addi	s0,sp,32
    800062e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800062e8:	ffffc097          	auipc	ra,0xffffc
    800062ec:	c08080e7          	jalr	-1016(ra) # 80001ef0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800062f0:	00d5151b          	slliw	a0,a0,0xd
    800062f4:	0c2017b7          	lui	a5,0xc201
    800062f8:	97aa                	add	a5,a5,a0
    800062fa:	c3c4                	sw	s1,4(a5)
}
    800062fc:	60e2                	ld	ra,24(sp)
    800062fe:	6442                	ld	s0,16(sp)
    80006300:	64a2                	ld	s1,8(sp)
    80006302:	6105                	addi	sp,sp,32
    80006304:	8082                	ret

0000000080006306 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006306:	1141                	addi	sp,sp,-16
    80006308:	e406                	sd	ra,8(sp)
    8000630a:	e022                	sd	s0,0(sp)
    8000630c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000630e:	479d                	li	a5,7
    80006310:	04a7cc63          	blt	a5,a0,80006368 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80006314:	0001e797          	auipc	a5,0x1e
    80006318:	cec78793          	addi	a5,a5,-788 # 80024000 <disk>
    8000631c:	00a78733          	add	a4,a5,a0
    80006320:	6789                	lui	a5,0x2
    80006322:	97ba                	add	a5,a5,a4
    80006324:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006328:	eba1                	bnez	a5,80006378 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    8000632a:	00451713          	slli	a4,a0,0x4
    8000632e:	00020797          	auipc	a5,0x20
    80006332:	cd27b783          	ld	a5,-814(a5) # 80026000 <disk+0x2000>
    80006336:	97ba                	add	a5,a5,a4
    80006338:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    8000633c:	0001e797          	auipc	a5,0x1e
    80006340:	cc478793          	addi	a5,a5,-828 # 80024000 <disk>
    80006344:	97aa                	add	a5,a5,a0
    80006346:	6509                	lui	a0,0x2
    80006348:	953e                	add	a0,a0,a5
    8000634a:	4785                	li	a5,1
    8000634c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006350:	00020517          	auipc	a0,0x20
    80006354:	cc850513          	addi	a0,a0,-824 # 80026018 <disk+0x2018>
    80006358:	ffffc097          	auipc	ra,0xffffc
    8000635c:	5c4080e7          	jalr	1476(ra) # 8000291c <wakeup>
}
    80006360:	60a2                	ld	ra,8(sp)
    80006362:	6402                	ld	s0,0(sp)
    80006364:	0141                	addi	sp,sp,16
    80006366:	8082                	ret
    panic("virtio_disk_intr 1");
    80006368:	00002517          	auipc	a0,0x2
    8000636c:	4b850513          	addi	a0,a0,1208 # 80008820 <syscalls+0x330>
    80006370:	ffffa097          	auipc	ra,0xffffa
    80006374:	1d0080e7          	jalr	464(ra) # 80000540 <panic>
    panic("virtio_disk_intr 2");
    80006378:	00002517          	auipc	a0,0x2
    8000637c:	4c050513          	addi	a0,a0,1216 # 80008838 <syscalls+0x348>
    80006380:	ffffa097          	auipc	ra,0xffffa
    80006384:	1c0080e7          	jalr	448(ra) # 80000540 <panic>

0000000080006388 <virtio_disk_init>:
{
    80006388:	1101                	addi	sp,sp,-32
    8000638a:	ec06                	sd	ra,24(sp)
    8000638c:	e822                	sd	s0,16(sp)
    8000638e:	e426                	sd	s1,8(sp)
    80006390:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006392:	00002597          	auipc	a1,0x2
    80006396:	4be58593          	addi	a1,a1,1214 # 80008850 <syscalls+0x360>
    8000639a:	00020517          	auipc	a0,0x20
    8000639e:	d0e50513          	addi	a0,a0,-754 # 800260a8 <disk+0x20a8>
    800063a2:	ffffa097          	auipc	ra,0xffffa
    800063a6:	7ca080e7          	jalr	1994(ra) # 80000b6c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800063aa:	100017b7          	lui	a5,0x10001
    800063ae:	4398                	lw	a4,0(a5)
    800063b0:	2701                	sext.w	a4,a4
    800063b2:	747277b7          	lui	a5,0x74727
    800063b6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800063ba:	0ef71163          	bne	a4,a5,8000649c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800063be:	100017b7          	lui	a5,0x10001
    800063c2:	43dc                	lw	a5,4(a5)
    800063c4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800063c6:	4705                	li	a4,1
    800063c8:	0ce79a63          	bne	a5,a4,8000649c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800063cc:	100017b7          	lui	a5,0x10001
    800063d0:	479c                	lw	a5,8(a5)
    800063d2:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800063d4:	4709                	li	a4,2
    800063d6:	0ce79363          	bne	a5,a4,8000649c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800063da:	100017b7          	lui	a5,0x10001
    800063de:	47d8                	lw	a4,12(a5)
    800063e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800063e2:	554d47b7          	lui	a5,0x554d4
    800063e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800063ea:	0af71963          	bne	a4,a5,8000649c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063ee:	100017b7          	lui	a5,0x10001
    800063f2:	4705                	li	a4,1
    800063f4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063f6:	470d                	li	a4,3
    800063f8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800063fa:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800063fc:	c7ffe737          	lui	a4,0xc7ffe
    80006400:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd775f>
    80006404:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006406:	2701                	sext.w	a4,a4
    80006408:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000640a:	472d                	li	a4,11
    8000640c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000640e:	473d                	li	a4,15
    80006410:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006412:	6705                	lui	a4,0x1
    80006414:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006416:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000641a:	5bdc                	lw	a5,52(a5)
    8000641c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000641e:	c7d9                	beqz	a5,800064ac <virtio_disk_init+0x124>
  if(max < NUM)
    80006420:	471d                	li	a4,7
    80006422:	08f77d63          	bgeu	a4,a5,800064bc <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006426:	100014b7          	lui	s1,0x10001
    8000642a:	47a1                	li	a5,8
    8000642c:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000642e:	6609                	lui	a2,0x2
    80006430:	4581                	li	a1,0
    80006432:	0001e517          	auipc	a0,0x1e
    80006436:	bce50513          	addi	a0,a0,-1074 # 80024000 <disk>
    8000643a:	ffffb097          	auipc	ra,0xffffb
    8000643e:	8be080e7          	jalr	-1858(ra) # 80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006442:	0001e717          	auipc	a4,0x1e
    80006446:	bbe70713          	addi	a4,a4,-1090 # 80024000 <disk>
    8000644a:	00c75793          	srli	a5,a4,0xc
    8000644e:	2781                	sext.w	a5,a5
    80006450:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80006452:	00020797          	auipc	a5,0x20
    80006456:	bae78793          	addi	a5,a5,-1106 # 80026000 <disk+0x2000>
    8000645a:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    8000645c:	0001e717          	auipc	a4,0x1e
    80006460:	c2470713          	addi	a4,a4,-988 # 80024080 <disk+0x80>
    80006464:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80006466:	0001f717          	auipc	a4,0x1f
    8000646a:	b9a70713          	addi	a4,a4,-1126 # 80025000 <disk+0x1000>
    8000646e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006470:	4705                	li	a4,1
    80006472:	00e78c23          	sb	a4,24(a5)
    80006476:	00e78ca3          	sb	a4,25(a5)
    8000647a:	00e78d23          	sb	a4,26(a5)
    8000647e:	00e78da3          	sb	a4,27(a5)
    80006482:	00e78e23          	sb	a4,28(a5)
    80006486:	00e78ea3          	sb	a4,29(a5)
    8000648a:	00e78f23          	sb	a4,30(a5)
    8000648e:	00e78fa3          	sb	a4,31(a5)
}
    80006492:	60e2                	ld	ra,24(sp)
    80006494:	6442                	ld	s0,16(sp)
    80006496:	64a2                	ld	s1,8(sp)
    80006498:	6105                	addi	sp,sp,32
    8000649a:	8082                	ret
    panic("could not find virtio disk");
    8000649c:	00002517          	auipc	a0,0x2
    800064a0:	3c450513          	addi	a0,a0,964 # 80008860 <syscalls+0x370>
    800064a4:	ffffa097          	auipc	ra,0xffffa
    800064a8:	09c080e7          	jalr	156(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    800064ac:	00002517          	auipc	a0,0x2
    800064b0:	3d450513          	addi	a0,a0,980 # 80008880 <syscalls+0x390>
    800064b4:	ffffa097          	auipc	ra,0xffffa
    800064b8:	08c080e7          	jalr	140(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    800064bc:	00002517          	auipc	a0,0x2
    800064c0:	3e450513          	addi	a0,a0,996 # 800088a0 <syscalls+0x3b0>
    800064c4:	ffffa097          	auipc	ra,0xffffa
    800064c8:	07c080e7          	jalr	124(ra) # 80000540 <panic>

00000000800064cc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800064cc:	7175                	addi	sp,sp,-144
    800064ce:	e506                	sd	ra,136(sp)
    800064d0:	e122                	sd	s0,128(sp)
    800064d2:	fca6                	sd	s1,120(sp)
    800064d4:	f8ca                	sd	s2,112(sp)
    800064d6:	f4ce                	sd	s3,104(sp)
    800064d8:	f0d2                	sd	s4,96(sp)
    800064da:	ecd6                	sd	s5,88(sp)
    800064dc:	e8da                	sd	s6,80(sp)
    800064de:	e4de                	sd	s7,72(sp)
    800064e0:	e0e2                	sd	s8,64(sp)
    800064e2:	fc66                	sd	s9,56(sp)
    800064e4:	f86a                	sd	s10,48(sp)
    800064e6:	f46e                	sd	s11,40(sp)
    800064e8:	0900                	addi	s0,sp,144
    800064ea:	8aaa                	mv	s5,a0
    800064ec:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800064ee:	00c52c83          	lw	s9,12(a0)
    800064f2:	001c9c9b          	slliw	s9,s9,0x1
    800064f6:	1c82                	slli	s9,s9,0x20
    800064f8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800064fc:	00020517          	auipc	a0,0x20
    80006500:	bac50513          	addi	a0,a0,-1108 # 800260a8 <disk+0x20a8>
    80006504:	ffffa097          	auipc	ra,0xffffa
    80006508:	6f8080e7          	jalr	1784(ra) # 80000bfc <acquire>
  for(int i = 0; i < 3; i++){
    8000650c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000650e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006510:	0001ec17          	auipc	s8,0x1e
    80006514:	af0c0c13          	addi	s8,s8,-1296 # 80024000 <disk>
    80006518:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    8000651a:	4b0d                	li	s6,3
    8000651c:	a0ad                	j	80006586 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    8000651e:	00fc0733          	add	a4,s8,a5
    80006522:	975e                	add	a4,a4,s7
    80006524:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006528:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000652a:	0207c563          	bltz	a5,80006554 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000652e:	2905                	addiw	s2,s2,1
    80006530:	0611                	addi	a2,a2,4
    80006532:	19690d63          	beq	s2,s6,800066cc <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006536:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006538:	00020717          	auipc	a4,0x20
    8000653c:	ae070713          	addi	a4,a4,-1312 # 80026018 <disk+0x2018>
    80006540:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006542:	00074683          	lbu	a3,0(a4)
    80006546:	fee1                	bnez	a3,8000651e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006548:	2785                	addiw	a5,a5,1
    8000654a:	0705                	addi	a4,a4,1
    8000654c:	fe979be3          	bne	a5,s1,80006542 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006550:	57fd                	li	a5,-1
    80006552:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006554:	01205d63          	blez	s2,8000656e <virtio_disk_rw+0xa2>
    80006558:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000655a:	000a2503          	lw	a0,0(s4)
    8000655e:	00000097          	auipc	ra,0x0
    80006562:	da8080e7          	jalr	-600(ra) # 80006306 <free_desc>
      for(int j = 0; j < i; j++)
    80006566:	2d85                	addiw	s11,s11,1
    80006568:	0a11                	addi	s4,s4,4
    8000656a:	ffb918e3          	bne	s2,s11,8000655a <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000656e:	00020597          	auipc	a1,0x20
    80006572:	b3a58593          	addi	a1,a1,-1222 # 800260a8 <disk+0x20a8>
    80006576:	00020517          	auipc	a0,0x20
    8000657a:	aa250513          	addi	a0,a0,-1374 # 80026018 <disk+0x2018>
    8000657e:	ffffc097          	auipc	ra,0xffffc
    80006582:	21e080e7          	jalr	542(ra) # 8000279c <sleep>
  for(int i = 0; i < 3; i++){
    80006586:	f8040a13          	addi	s4,s0,-128
{
    8000658a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000658c:	894e                	mv	s2,s3
    8000658e:	b765                	j	80006536 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006590:	00020717          	auipc	a4,0x20
    80006594:	a7073703          	ld	a4,-1424(a4) # 80026000 <disk+0x2000>
    80006598:	973e                	add	a4,a4,a5
    8000659a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000659e:	0001e517          	auipc	a0,0x1e
    800065a2:	a6250513          	addi	a0,a0,-1438 # 80024000 <disk>
    800065a6:	00020717          	auipc	a4,0x20
    800065aa:	a5a70713          	addi	a4,a4,-1446 # 80026000 <disk+0x2000>
    800065ae:	6314                	ld	a3,0(a4)
    800065b0:	96be                	add	a3,a3,a5
    800065b2:	00c6d603          	lhu	a2,12(a3)
    800065b6:	00166613          	ori	a2,a2,1
    800065ba:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800065be:	f8842683          	lw	a3,-120(s0)
    800065c2:	6310                	ld	a2,0(a4)
    800065c4:	97b2                	add	a5,a5,a2
    800065c6:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    800065ca:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    800065ce:	0612                	slli	a2,a2,0x4
    800065d0:	962a                	add	a2,a2,a0
    800065d2:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800065d6:	00469793          	slli	a5,a3,0x4
    800065da:	630c                	ld	a1,0(a4)
    800065dc:	95be                	add	a1,a1,a5
    800065de:	6689                	lui	a3,0x2
    800065e0:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800065e4:	96ca                	add	a3,a3,s2
    800065e6:	96aa                	add	a3,a3,a0
    800065e8:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    800065ea:	6314                	ld	a3,0(a4)
    800065ec:	96be                	add	a3,a3,a5
    800065ee:	4585                	li	a1,1
    800065f0:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800065f2:	6314                	ld	a3,0(a4)
    800065f4:	96be                	add	a3,a3,a5
    800065f6:	4509                	li	a0,2
    800065f8:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    800065fc:	6314                	ld	a3,0(a4)
    800065fe:	97b6                	add	a5,a5,a3
    80006600:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006604:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006608:	03563423          	sd	s5,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000660c:	6714                	ld	a3,8(a4)
    8000660e:	0026d783          	lhu	a5,2(a3)
    80006612:	8b9d                	andi	a5,a5,7
    80006614:	0789                	addi	a5,a5,2
    80006616:	0786                	slli	a5,a5,0x1
    80006618:	97b6                	add	a5,a5,a3
    8000661a:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000661e:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80006622:	6718                	ld	a4,8(a4)
    80006624:	00275783          	lhu	a5,2(a4)
    80006628:	2785                	addiw	a5,a5,1
    8000662a:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000662e:	100017b7          	lui	a5,0x10001
    80006632:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006636:	004aa783          	lw	a5,4(s5)
    8000663a:	02b79163          	bne	a5,a1,8000665c <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000663e:	00020917          	auipc	s2,0x20
    80006642:	a6a90913          	addi	s2,s2,-1430 # 800260a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006646:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006648:	85ca                	mv	a1,s2
    8000664a:	8556                	mv	a0,s5
    8000664c:	ffffc097          	auipc	ra,0xffffc
    80006650:	150080e7          	jalr	336(ra) # 8000279c <sleep>
  while(b->disk == 1) {
    80006654:	004aa783          	lw	a5,4(s5)
    80006658:	fe9788e3          	beq	a5,s1,80006648 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    8000665c:	f8042483          	lw	s1,-128(s0)
    80006660:	20048793          	addi	a5,s1,512
    80006664:	00479713          	slli	a4,a5,0x4
    80006668:	0001e797          	auipc	a5,0x1e
    8000666c:	99878793          	addi	a5,a5,-1640 # 80024000 <disk>
    80006670:	97ba                	add	a5,a5,a4
    80006672:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006676:	00020917          	auipc	s2,0x20
    8000667a:	98a90913          	addi	s2,s2,-1654 # 80026000 <disk+0x2000>
    8000667e:	a019                	j	80006684 <virtio_disk_rw+0x1b8>
      i = disk.desc[i].next;
    80006680:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006684:	8526                	mv	a0,s1
    80006686:	00000097          	auipc	ra,0x0
    8000668a:	c80080e7          	jalr	-896(ra) # 80006306 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    8000668e:	0492                	slli	s1,s1,0x4
    80006690:	00093783          	ld	a5,0(s2)
    80006694:	94be                	add	s1,s1,a5
    80006696:	00c4d783          	lhu	a5,12(s1)
    8000669a:	8b85                	andi	a5,a5,1
    8000669c:	f3f5                	bnez	a5,80006680 <virtio_disk_rw+0x1b4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000669e:	00020517          	auipc	a0,0x20
    800066a2:	a0a50513          	addi	a0,a0,-1526 # 800260a8 <disk+0x20a8>
    800066a6:	ffffa097          	auipc	ra,0xffffa
    800066aa:	60a080e7          	jalr	1546(ra) # 80000cb0 <release>
}
    800066ae:	60aa                	ld	ra,136(sp)
    800066b0:	640a                	ld	s0,128(sp)
    800066b2:	74e6                	ld	s1,120(sp)
    800066b4:	7946                	ld	s2,112(sp)
    800066b6:	79a6                	ld	s3,104(sp)
    800066b8:	7a06                	ld	s4,96(sp)
    800066ba:	6ae6                	ld	s5,88(sp)
    800066bc:	6b46                	ld	s6,80(sp)
    800066be:	6ba6                	ld	s7,72(sp)
    800066c0:	6c06                	ld	s8,64(sp)
    800066c2:	7ce2                	ld	s9,56(sp)
    800066c4:	7d42                	ld	s10,48(sp)
    800066c6:	7da2                	ld	s11,40(sp)
    800066c8:	6149                	addi	sp,sp,144
    800066ca:	8082                	ret
  if(write)
    800066cc:	01a037b3          	snez	a5,s10
    800066d0:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    800066d4:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    800066d8:	f7943c23          	sd	s9,-136(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800066dc:	f8042483          	lw	s1,-128(s0)
    800066e0:	00449913          	slli	s2,s1,0x4
    800066e4:	00020997          	auipc	s3,0x20
    800066e8:	91c98993          	addi	s3,s3,-1764 # 80026000 <disk+0x2000>
    800066ec:	0009ba03          	ld	s4,0(s3)
    800066f0:	9a4a                	add	s4,s4,s2
    800066f2:	f7040513          	addi	a0,s0,-144
    800066f6:	ffffb097          	auipc	ra,0xffffb
    800066fa:	9c2080e7          	jalr	-1598(ra) # 800010b8 <kvmpa>
    800066fe:	00aa3023          	sd	a0,0(s4)
  disk.desc[idx[0]].len = sizeof(buf0);
    80006702:	0009b783          	ld	a5,0(s3)
    80006706:	97ca                	add	a5,a5,s2
    80006708:	4741                	li	a4,16
    8000670a:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000670c:	0009b783          	ld	a5,0(s3)
    80006710:	97ca                	add	a5,a5,s2
    80006712:	4705                	li	a4,1
    80006714:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006718:	f8442783          	lw	a5,-124(s0)
    8000671c:	0009b703          	ld	a4,0(s3)
    80006720:	974a                	add	a4,a4,s2
    80006722:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006726:	0792                	slli	a5,a5,0x4
    80006728:	0009b703          	ld	a4,0(s3)
    8000672c:	973e                	add	a4,a4,a5
    8000672e:	058a8693          	addi	a3,s5,88
    80006732:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    80006734:	0009b703          	ld	a4,0(s3)
    80006738:	973e                	add	a4,a4,a5
    8000673a:	40000693          	li	a3,1024
    8000673e:	c714                	sw	a3,8(a4)
  if(write)
    80006740:	e40d18e3          	bnez	s10,80006590 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006744:	00020717          	auipc	a4,0x20
    80006748:	8bc73703          	ld	a4,-1860(a4) # 80026000 <disk+0x2000>
    8000674c:	973e                	add	a4,a4,a5
    8000674e:	4689                	li	a3,2
    80006750:	00d71623          	sh	a3,12(a4)
    80006754:	b5a9                	j	8000659e <virtio_disk_rw+0xd2>

0000000080006756 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006756:	1101                	addi	sp,sp,-32
    80006758:	ec06                	sd	ra,24(sp)
    8000675a:	e822                	sd	s0,16(sp)
    8000675c:	e426                	sd	s1,8(sp)
    8000675e:	e04a                	sd	s2,0(sp)
    80006760:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006762:	00020517          	auipc	a0,0x20
    80006766:	94650513          	addi	a0,a0,-1722 # 800260a8 <disk+0x20a8>
    8000676a:	ffffa097          	auipc	ra,0xffffa
    8000676e:	492080e7          	jalr	1170(ra) # 80000bfc <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006772:	00020717          	auipc	a4,0x20
    80006776:	88e70713          	addi	a4,a4,-1906 # 80026000 <disk+0x2000>
    8000677a:	02075783          	lhu	a5,32(a4)
    8000677e:	6b18                	ld	a4,16(a4)
    80006780:	00275683          	lhu	a3,2(a4)
    80006784:	8ebd                	xor	a3,a3,a5
    80006786:	8a9d                	andi	a3,a3,7
    80006788:	cab9                	beqz	a3,800067de <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    8000678a:	0001e917          	auipc	s2,0x1e
    8000678e:	87690913          	addi	s2,s2,-1930 # 80024000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006792:	00020497          	auipc	s1,0x20
    80006796:	86e48493          	addi	s1,s1,-1938 # 80026000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    8000679a:	078e                	slli	a5,a5,0x3
    8000679c:	97ba                	add	a5,a5,a4
    8000679e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    800067a0:	20078713          	addi	a4,a5,512
    800067a4:	0712                	slli	a4,a4,0x4
    800067a6:	974a                	add	a4,a4,s2
    800067a8:	03074703          	lbu	a4,48(a4)
    800067ac:	ef21                	bnez	a4,80006804 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800067ae:	20078793          	addi	a5,a5,512
    800067b2:	0792                	slli	a5,a5,0x4
    800067b4:	97ca                	add	a5,a5,s2
    800067b6:	7798                	ld	a4,40(a5)
    800067b8:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800067bc:	7788                	ld	a0,40(a5)
    800067be:	ffffc097          	auipc	ra,0xffffc
    800067c2:	15e080e7          	jalr	350(ra) # 8000291c <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800067c6:	0204d783          	lhu	a5,32(s1)
    800067ca:	2785                	addiw	a5,a5,1
    800067cc:	8b9d                	andi	a5,a5,7
    800067ce:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800067d2:	6898                	ld	a4,16(s1)
    800067d4:	00275683          	lhu	a3,2(a4)
    800067d8:	8a9d                	andi	a3,a3,7
    800067da:	fcf690e3          	bne	a3,a5,8000679a <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800067de:	10001737          	lui	a4,0x10001
    800067e2:	533c                	lw	a5,96(a4)
    800067e4:	8b8d                	andi	a5,a5,3
    800067e6:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800067e8:	00020517          	auipc	a0,0x20
    800067ec:	8c050513          	addi	a0,a0,-1856 # 800260a8 <disk+0x20a8>
    800067f0:	ffffa097          	auipc	ra,0xffffa
    800067f4:	4c0080e7          	jalr	1216(ra) # 80000cb0 <release>
}
    800067f8:	60e2                	ld	ra,24(sp)
    800067fa:	6442                	ld	s0,16(sp)
    800067fc:	64a2                	ld	s1,8(sp)
    800067fe:	6902                	ld	s2,0(sp)
    80006800:	6105                	addi	sp,sp,32
    80006802:	8082                	ret
      panic("virtio_disk_intr status");
    80006804:	00002517          	auipc	a0,0x2
    80006808:	0bc50513          	addi	a0,a0,188 # 800088c0 <syscalls+0x3d0>
    8000680c:	ffffa097          	auipc	ra,0xffffa
    80006810:	d34080e7          	jalr	-716(ra) # 80000540 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
