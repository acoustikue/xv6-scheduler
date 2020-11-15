
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
    8000005e:	f3678793          	addi	a5,a5,-202 # 80005f90 <timervec>
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
    80000124:	00002097          	auipc	ra,0x2
    80000128:	73e080e7          	jalr	1854(ra) # 80002862 <either_copyin>
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
    800001cc:	c10080e7          	jalr	-1008(ra) # 80001dd8 <myproc>
    800001d0:	591c                	lw	a5,48(a0)
    800001d2:	e7b5                	bnez	a5,8000023e <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d4:	85a6                	mv	a1,s1
    800001d6:	854a                	mv	a0,s2
    800001d8:	00002097          	auipc	ra,0x2
    800001dc:	38e080e7          	jalr	910(ra) # 80002566 <sleep>
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
    80000214:	00002097          	auipc	ra,0x2
    80000218:	5f8080e7          	jalr	1528(ra) # 8000280c <either_copyout>
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
    800002f8:	5c4080e7          	jalr	1476(ra) # 800028b8 <procdump>
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
    8000044c:	29e080e7          	jalr	670(ra) # 800026e6 <wakeup>
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
    8000047e:	b7e78793          	addi	a5,a5,-1154 # 80021ff8 <devsw>
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
    800008a4:	e46080e7          	jalr	-442(ra) # 800026e6 <wakeup>
    
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
    8000093e:	c2c080e7          	jalr	-980(ra) # 80002566 <sleep>
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
    80000b9a:	226080e7          	jalr	550(ra) # 80001dbc <mycpu>
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
    80000bcc:	1f4080e7          	jalr	500(ra) # 80001dbc <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cf89                	beqz	a5,80000bec <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	00001097          	auipc	ra,0x1
    80000bd8:	1e8080e7          	jalr	488(ra) # 80001dbc <mycpu>
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
    80000bf0:	1d0080e7          	jalr	464(ra) # 80001dbc <mycpu>
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
    80000c30:	190080e7          	jalr	400(ra) # 80001dbc <mycpu>
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
    80000c5c:	164080e7          	jalr	356(ra) # 80001dbc <mycpu>
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
    80000eb2:	efe080e7          	jalr	-258(ra) # 80001dac <cpuid>
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
    80000ece:	ee2080e7          	jalr	-286(ra) # 80001dac <cpuid>
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
    80000ef0:	b0e080e7          	jalr	-1266(ra) # 800029fa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ef4:	00005097          	auipc	ra,0x5
    80000ef8:	0dc080e7          	jalr	220(ra) # 80005fd0 <plicinithart>
  }

  scheduler();        
    80000efc:	00001097          	auipc	ra,0x1
    80000f00:	43e080e7          	jalr	1086(ra) # 8000233a <scheduler>
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
    80000f50:	d58080e7          	jalr	-680(ra) # 80001ca4 <procinit>
    trapinit();      // trap vectors
    80000f54:	00002097          	auipc	ra,0x2
    80000f58:	a7e080e7          	jalr	-1410(ra) # 800029d2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f5c:	00002097          	auipc	ra,0x2
    80000f60:	a9e080e7          	jalr	-1378(ra) # 800029fa <trapinithart>
    plicinit();      // set up interrupt controller
    80000f64:	00005097          	auipc	ra,0x5
    80000f68:	056080e7          	jalr	86(ra) # 80005fba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f6c:	00005097          	auipc	ra,0x5
    80000f70:	064080e7          	jalr	100(ra) # 80005fd0 <plicinithart>
    binit();         // buffer cache
    80000f74:	00002097          	auipc	ra,0x2
    80000f78:	20c080e7          	jalr	524(ra) # 80003180 <binit>
    iinit();         // inode cache
    80000f7c:	00003097          	auipc	ra,0x3
    80000f80:	89e080e7          	jalr	-1890(ra) # 8000381a <iinit>
    fileinit();      // file table
    80000f84:	00004097          	auipc	ra,0x4
    80000f88:	83c080e7          	jalr	-1988(ra) # 800047c0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f8c:	00005097          	auipc	ra,0x5
    80000f90:	14c080e7          	jalr	332(ra) # 800060d8 <virtio_disk_init>
    userinit();      // first user process
    80000f94:	00001097          	auipc	ra,0x1
    80000f98:	13c080e7          	jalr	316(ra) # 800020d0 <userinit>
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
#define Q2    2
#define Q1    1
#define Q0    0
#define UD    -1

void init_queue(_queue* q, int id) { q->q_id = id; q->q_head = 0; q->q_tail = 0; q->q_cnt = 0; };
    80001878:	1141                	addi	sp,sp,-16
    8000187a:	e422                	sd	s0,8(sp)
    8000187c:	0800                	addi	s0,sp,16
    8000187e:	c10c                	sw	a1,0(a0)
    80001880:	00053423          	sd	zero,8(a0)
    80001884:	00053823          	sd	zero,16(a0)
    80001888:	00052223          	sw	zero,4(a0)
    8000188c:	6422                	ld	s0,8(sp)
    8000188e:	0141                	addi	sp,sp,16
    80001890:	8082                	ret

0000000080001892 <show_queue_status>:

void show_queue_status() {
    80001892:	1101                	addi	sp,sp,-32
    80001894:	ec06                	sd	ra,24(sp)
    80001896:	e822                	sd	s0,16(sp)
    80001898:	e426                	sd	s1,8(sp)
    8000189a:	1000                	addi	s0,sp,32
int uncolor(struct proc* p) {  p->p_id = UD; return UD; }
int ground(struct proc* p) { p->p_next = p->p_prev = 0; return 0;}


// Queue controls
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
    80001968:	16053823          	sd	zero,368(a0)
    8000196c:	16053c23          	sd	zero,376(a0)
    80001970:	4501                	li	a0,0
    80001972:	6422                	ld	s0,8(sp)
    80001974:	0141                	addi	sp,sp,16
    80001976:	8082                	ret

0000000080001978 <is_empty>:
int is_empty(_queue* q) { return (q->q_cnt == 0); } 
    80001978:	1141                	addi	sp,sp,-16
    8000197a:	e422                	sd	s0,8(sp)
    8000197c:	0800                	addi	s0,sp,16
    8000197e:	4148                	lw	a0,4(a0)
    80001980:	00153513          	seqz	a0,a0
    80001984:	6422                	ld	s0,8(sp)
    80001986:	0141                	addi	sp,sp,16
    80001988:	8082                	ret

000000008000198a <get_head>:

struct proc* get_head(_queue* q) { return q->q_head; }
    8000198a:	1141                	addi	sp,sp,-16
    8000198c:	e422                	sd	s0,8(sp)
    8000198e:	0800                	addi	s0,sp,16
    80001990:	6508                	ld	a0,8(a0)
    80001992:	6422                	ld	s0,8(sp)
    80001994:	0141                	addi	sp,sp,16
    80001996:	8082                	ret

0000000080001998 <get_tail>:
struct proc* get_tail(_queue* q) { return q->q_tail; }
    80001998:	1141                	addi	sp,sp,-16
    8000199a:	e422                	sd	s0,8(sp)
    8000199c:	0800                	addi	s0,sp,16
    8000199e:	6908                	ld	a0,16(a0)
    800019a0:	6422                	ld	s0,8(sp)
    800019a2:	0141                	addi	sp,sp,16
    800019a4:	8082                	ret

00000000800019a6 <get_cnt>:
int get_cnt(_queue* q) { return q->q_cnt; }
    800019a6:	1141                	addi	sp,sp,-16
    800019a8:	e422                	sd	s0,8(sp)
    800019aa:	0800                	addi	s0,sp,16
    800019ac:	4148                	lw	a0,4(a0)
    800019ae:	6422                	ld	s0,8(sp)
    800019b0:	0141                	addi	sp,sp,16
    800019b2:	8082                	ret

00000000800019b4 <enqueue>:

struct proc* enqueue(_queue* q, struct proc* p) {
    800019b4:	1141                	addi	sp,sp,-16
    800019b6:	e422                	sd	s0,8(sp)
    800019b8:	0800                	addi	s0,sp,16
    800019ba:	87aa                	mv	a5,a0
    800019bc:	852e                	mv	a0,a1
  // if (p->p_id == q->q_id) return 0;
  color(p, q->q_id); // color it first
    800019be:	4398                	lw	a4,0(a5)
int color(struct proc* p, int id) {  p->p_id = id; return id; }
    800019c0:	16e5a423          	sw	a4,360(a1)
  
  if (is_empty(q)) {
    800019c4:	43d8                	lw	a4,4(a5)
    800019c6:	c305                	beqz	a4,800019e6 <enqueue+0x32>
    ground(p);
    q->q_head = q->q_tail = p;
  }
  else {

    q->q_tail->p_next = p;
    800019c8:	6b98                	ld	a4,16(a5)
    800019ca:	16b73c23          	sd	a1,376(a4)

    p->p_prev = q->q_tail;
    800019ce:	6b98                	ld	a4,16(a5)
    800019d0:	16e5b823          	sd	a4,368(a1)
    p->p_next = 0;
    800019d4:	1605bc23          	sd	zero,376(a1)

    q->q_tail = p;
    800019d8:	eb8c                	sd	a1,16(a5)
  }

  q->q_cnt++;
    800019da:	43d8                	lw	a4,4(a5)
    800019dc:	2705                	addiw	a4,a4,1
    800019de:	c3d8                	sw	a4,4(a5)

  // printf("enqueue: \n");
  // show_queue_status();
  
  return p;
}
    800019e0:	6422                	ld	s0,8(sp)
    800019e2:	0141                	addi	sp,sp,16
    800019e4:	8082                	ret
int ground(struct proc* p) { p->p_next = p->p_prev = 0; return 0;}
    800019e6:	1605b823          	sd	zero,368(a1)
    800019ea:	1605bc23          	sd	zero,376(a1)
    q->q_head = q->q_tail = p;
    800019ee:	eb8c                	sd	a1,16(a5)
    800019f0:	e78c                	sd	a1,8(a5)
    800019f2:	b7e5                	j	800019da <enqueue+0x26>

00000000800019f4 <dequeue>:


struct proc* dequeue(_queue* q) { // printf("dequeue\n");
    800019f4:	1141                	addi	sp,sp,-16
    800019f6:	e422                	sd	s0,8(sp)
    800019f8:	0800                	addi	s0,sp,16
    800019fa:	87aa                	mv	a5,a0
  struct proc* p = q->q_head;
    800019fc:	6508                	ld	a0,8(a0)
int is_empty(_queue* q) { return (q->q_cnt == 0); } 
    800019fe:	43d8                	lw	a4,4(a5)

  if (is_empty(q)) return 0;
    80001a00:	cb1d                	beqz	a4,80001a36 <dequeue+0x42>

  // When single element exists
  if (q->q_cnt == 1) { 
    80001a02:	4685                	li	a3,1
    80001a04:	02d70463          	beq	a4,a3,80001a2c <dequeue+0x38>
    q->q_head = q->q_tail = 0;
  }
  else {
    q->q_head = p->p_next;
    80001a08:	17853703          	ld	a4,376(a0)
    80001a0c:	e798                	sd	a4,8(a5)
    q->q_head->p_prev = 0;
    80001a0e:	16073823          	sd	zero,368(a4)
int uncolor(struct proc* p) {  p->p_id = UD; return UD; }
    80001a12:	577d                	li	a4,-1
    80001a14:	16e52423          	sw	a4,360(a0)
int ground(struct proc* p) { p->p_next = p->p_prev = 0; return 0;}
    80001a18:	16053823          	sd	zero,368(a0)
    80001a1c:	16053c23          	sd	zero,376(a0)
  }
  uncolor(p); // remove color
  ground(p);

  q->q_cnt--;
    80001a20:	43d8                	lw	a4,4(a5)
    80001a22:	377d                	addiw	a4,a4,-1
    80001a24:	c3d8                	sw	a4,4(a5)

  // printf("dequeue: \n");
  // show_queue_status();

  return p;
}
    80001a26:	6422                	ld	s0,8(sp)
    80001a28:	0141                	addi	sp,sp,16
    80001a2a:	8082                	ret
    q->q_head = q->q_tail = 0;
    80001a2c:	0007b823          	sd	zero,16(a5)
    80001a30:	0007b423          	sd	zero,8(a5)
    80001a34:	bff9                	j	80001a12 <dequeue+0x1e>
  if (is_empty(q)) return 0;
    80001a36:	4501                	li	a0,0
    80001a38:	b7fd                	j	80001a26 <dequeue+0x32>

0000000080001a3a <remove>:


struct proc* remove(_queue* q, struct proc* tp) { 
    80001a3a:	1141                	addi	sp,sp,-16
    80001a3c:	e422                	sd	s0,8(sp)
    80001a3e:	0800                	addi	s0,sp,16
    80001a40:	87aa                	mv	a5,a0
  struct proc* np = q->q_head;
    80001a42:	6508                	ld	a0,8(a0)
int is_empty(_queue* q) { return (q->q_cnt == 0); } 
    80001a44:	43d8                	lw	a4,4(a5)
  // search
  if (is_empty(q)) { return 0; } // case when empty
    80001a46:	cf2d                	beqz	a4,80001ac0 <remove+0x86>
  while (np != tp && np != 0) np = np->p_next; // search for target
    80001a48:	00b50963          	beq	a0,a1,80001a5a <remove+0x20>
    80001a4c:	c931                	beqz	a0,80001aa0 <remove+0x66>
    80001a4e:	17853503          	ld	a0,376(a0)
    80001a52:	00a58563          	beq	a1,a0,80001a5c <remove+0x22>
    80001a56:	fd65                	bnez	a0,80001a4e <remove+0x14>
    80001a58:	a0a1                	j	80001aa0 <remove+0x66>
  struct proc* np = q->q_head;
    80001a5a:	852e                	mv	a0,a1
  
  if (np == 0) { return 0; } // not found
    80001a5c:	c131                	beqz	a0,80001aa0 <remove+0x66>
  // printf("found %p\n", np);
  // found
  if (q->q_cnt == 1) { q->q_head = q->q_tail = 0; }
    80001a5e:	4685                	li	a3,1
    80001a60:	04d70363          	beq	a4,a3,80001aa6 <remove+0x6c>
  else {
    if (np->p_prev != 0) { np->p_prev->p_next = np->p_next; } // not in front
    80001a64:	17053703          	ld	a4,368(a0)
    80001a68:	c709                	beqz	a4,80001a72 <remove+0x38>
    80001a6a:	17853683          	ld	a3,376(a0)
    80001a6e:	16d73c23          	sd	a3,376(a4)
    if (np->p_next != 0) { np->p_next->p_prev = np->p_prev; } // not in rear
    80001a72:	17853703          	ld	a4,376(a0)
    80001a76:	c709                	beqz	a4,80001a80 <remove+0x46>
    80001a78:	17053683          	ld	a3,368(a0)
    80001a7c:	16d73823          	sd	a3,368(a4)
    if (np == q->q_head) { q->q_head = np->p_next; }
    80001a80:	6798                	ld	a4,8(a5)
    80001a82:	02e50763          	beq	a0,a4,80001ab0 <remove+0x76>
    if (np == q->q_tail) { q->q_tail = np->p_prev; }
    80001a86:	6b98                	ld	a4,16(a5)
    80001a88:	02e50863          	beq	a0,a4,80001ab8 <remove+0x7e>
int uncolor(struct proc* p) {  p->p_id = UD; return UD; }
    80001a8c:	577d                	li	a4,-1
    80001a8e:	16e52423          	sw	a4,360(a0)
int ground(struct proc* p) { p->p_next = p->p_prev = 0; return 0;}
    80001a92:	16053823          	sd	zero,368(a0)
    80001a96:	16053c23          	sd	zero,376(a0)
  }

  uncolor(np);
  ground(np);

  q->q_cnt--;
    80001a9a:	43d8                	lw	a4,4(a5)
    80001a9c:	377d                	addiw	a4,a4,-1
    80001a9e:	c3d8                	sw	a4,4(a5)

  // printf("remove: \n");
  // show_queue_status();

  return np;
}
    80001aa0:	6422                	ld	s0,8(sp)
    80001aa2:	0141                	addi	sp,sp,16
    80001aa4:	8082                	ret
  if (q->q_cnt == 1) { q->q_head = q->q_tail = 0; }
    80001aa6:	0007b823          	sd	zero,16(a5)
    80001aaa:	0007b423          	sd	zero,8(a5)
    80001aae:	bff9                	j	80001a8c <remove+0x52>
    if (np == q->q_head) { q->q_head = np->p_next; }
    80001ab0:	17853703          	ld	a4,376(a0)
    80001ab4:	e798                	sd	a4,8(a5)
    80001ab6:	bfc1                	j	80001a86 <remove+0x4c>
    if (np == q->q_tail) { q->q_tail = np->p_prev; }
    80001ab8:	17053703          	ld	a4,368(a0)
    80001abc:	eb98                	sd	a4,16(a5)
    80001abe:	b7f9                	j	80001a8c <remove+0x52>
  if (is_empty(q)) { return 0; } // case when empty
    80001ac0:	4501                	li	a0,0
    80001ac2:	bff9                	j	80001aa0 <remove+0x66>

0000000080001ac4 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001ac4:	1101                	addi	sp,sp,-32
    80001ac6:	ec06                	sd	ra,24(sp)
    80001ac8:	e822                	sd	s0,16(sp)
    80001aca:	e426                	sd	s1,8(sp)
    80001acc:	1000                	addi	s0,sp,32
    80001ace:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	0b2080e7          	jalr	178(ra) # 80000b82 <holding>
    80001ad8:	c909                	beqz	a0,80001aea <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001ada:	749c                	ld	a5,40(s1)
    80001adc:	00978f63          	beq	a5,s1,80001afa <wakeup1+0x36>
#ifdef SUKJOON
    printf("wakeup1\n");
    if (is_q0(p)) { remove(&q0, p); enqueue(&q2, p); }
#endif
  }
}
    80001ae0:	60e2                	ld	ra,24(sp)
    80001ae2:	6442                	ld	s0,16(sp)
    80001ae4:	64a2                	ld	s1,8(sp)
    80001ae6:	6105                	addi	sp,sp,32
    80001ae8:	8082                	ret
    panic("wakeup1");
    80001aea:	00006517          	auipc	a0,0x6
    80001aee:	77650513          	addi	a0,a0,1910 # 80008260 <digits+0x220>
    80001af2:	fffff097          	auipc	ra,0xfffff
    80001af6:	a4e080e7          	jalr	-1458(ra) # 80000540 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001afa:	4c98                	lw	a4,24(s1)
    80001afc:	4785                	li	a5,1
    80001afe:	fef711e3          	bne	a4,a5,80001ae0 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001b02:	4789                	li	a5,2
    80001b04:	cc9c                	sw	a5,24(s1)
    printf("wakeup1\n");
    80001b06:	00006517          	auipc	a0,0x6
    80001b0a:	76250513          	addi	a0,a0,1890 # 80008268 <digits+0x228>
    80001b0e:	fffff097          	auipc	ra,0xfffff
    80001b12:	a7c080e7          	jalr	-1412(ra) # 8000058a <printf>
    if (is_q0(p)) { remove(&q0, p); enqueue(&q2, p); }
    80001b16:	1684a783          	lw	a5,360(s1)
    80001b1a:	f3f9                	bnez	a5,80001ae0 <wakeup1+0x1c>
    80001b1c:	85a6                	mv	a1,s1
    80001b1e:	00010517          	auipc	a0,0x10
    80001b22:	e6250513          	addi	a0,a0,-414 # 80011980 <q0>
    80001b26:	00000097          	auipc	ra,0x0
    80001b2a:	f14080e7          	jalr	-236(ra) # 80001a3a <remove>
    80001b2e:	85a6                	mv	a1,s1
    80001b30:	00010517          	auipc	a0,0x10
    80001b34:	e2050513          	addi	a0,a0,-480 # 80011950 <q2>
    80001b38:	00000097          	auipc	ra,0x0
    80001b3c:	e7c080e7          	jalr	-388(ra) # 800019b4 <enqueue>
}
    80001b40:	b745                	j	80001ae0 <wakeup1+0x1c>

0000000080001b42 <mlfq_like>:
void mlfq_like() {
    80001b42:	711d                	addi	sp,sp,-96
    80001b44:	ec86                	sd	ra,88(sp)
    80001b46:	e8a2                	sd	s0,80(sp)
    80001b48:	e4a6                	sd	s1,72(sp)
    80001b4a:	e0ca                	sd	s2,64(sp)
    80001b4c:	fc4e                	sd	s3,56(sp)
    80001b4e:	f852                	sd	s4,48(sp)
    80001b50:	f456                	sd	s5,40(sp)
    80001b52:	f05a                	sd	s6,32(sp)
    80001b54:	ec5e                	sd	s7,24(sp)
    80001b56:	e862                	sd	s8,16(sp)
    80001b58:	e466                	sd	s9,8(sp)
    80001b5a:	e06a                	sd	s10,0(sp)
    80001b5c:	1080                	addi	s0,sp,96
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b5e:	8792                	mv	a5,tp
  int id = r_tp();
    80001b60:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001b62:	00779c93          	slli	s9,a5,0x7
    80001b66:	00010717          	auipc	a4,0x10
    80001b6a:	dea70713          	addi	a4,a4,-534 # 80011950 <q2>
    80001b6e:	9766                	add	a4,a4,s9
    80001b70:	04073423          	sd	zero,72(a4)
        if(p->state == RUNNABLE) { p->state = RUNNING; c->proc = p;  swtch(&c->context, &p->context); c->proc = 0; }
    80001b74:	00010717          	auipc	a4,0x10
    80001b78:	e2c70713          	addi	a4,a4,-468 # 800119a0 <cpus+0x8>
    80001b7c:	9cba                	add	s9,s9,a4
struct proc* get_head(_queue* q) { return q->q_head; }
    80001b7e:	00010997          	auipc	s3,0x10
    80001b82:	dd298993          	addi	s3,s3,-558 # 80011950 <q2>
        else if (p->state == UNUSED || p->state == ZOMBIE) { dequeue(&q1); }
    80001b86:	00010c17          	auipc	s8,0x10
    80001b8a:	de2c0c13          	addi	s8,s8,-542 # 80011968 <q1>
        else if (p->state == SLEEPING) { dequeue(&q1); enqueue(&q0, p); }
    80001b8e:	00010d17          	auipc	s10,0x10
    80001b92:	df2d0d13          	addi	s10,s10,-526 # 80011980 <q0>
        if(p->state == RUNNABLE) { p->state = RUNNING; c->proc = p;  swtch(&c->context, &p->context); c->proc = 0; }
    80001b96:	079e                	slli	a5,a5,0x7
    80001b98:	00f98bb3          	add	s7,s3,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b9c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ba0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba4:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ba8:	00010917          	auipc	s2,0x10
    80001bac:	26890913          	addi	s2,s2,616 # 80011e10 <proc+0x60>
    80001bb0:	00010497          	auipc	s1,0x10
    80001bb4:	20048493          	addi	s1,s1,512 # 80011db0 <proc>
        if(p->state == RUNNABLE) { p->state = RUNNING; c->proc = p;  swtch(&c->context, &p->context); c->proc = 0; }
    80001bb8:	4a89                	li	s5,2
        else if (p->state == SLEEPING) { dequeue(&q1); enqueue(&q0, p); }
    80001bba:	4b05                	li	s6,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001bbc:	00016a17          	auipc	s4,0x16
    80001bc0:	1f4a0a13          	addi	s4,s4,500 # 80017db0 <tickslock>
    80001bc4:	a01d                	j	80001bea <mlfq_like+0xa8>
        if(p->state == RUNNABLE) { p->state = RUNNING; c->proc = p;  swtch(&c->context, &p->context); c->proc = 0; dequeue(&q2); enqueue(&q1, p); }
    80001bc6:	4c9c                	lw	a5,24(s1)
    80001bc8:	05578b63          	beq	a5,s5,80001c1e <mlfq_like+0xdc>
        else if (p->state == SLEEPING) { dequeue(&q2); enqueue(&q0, p); }
    80001bcc:	09678163          	beq	a5,s6,80001c4e <mlfq_like+0x10c>
        else if (p->state == UNUSED || p->state == ZOMBIE) { dequeue(&q2); } 
    80001bd0:	9bed                	andi	a5,a5,-5
    80001bd2:	cbd1                	beqz	a5,80001c66 <mlfq_like+0x124>
      release(&p->lock);
    80001bd4:	8526                	mv	a0,s1
    80001bd6:	fffff097          	auipc	ra,0xfffff
    80001bda:	0da080e7          	jalr	218(ra) # 80000cb0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001bde:	18048493          	addi	s1,s1,384
    80001be2:	18090913          	addi	s2,s2,384
    80001be6:	fb448be3          	beq	s1,s4,80001b9c <mlfq_like+0x5a>
      acquire(&p->lock);
    80001bea:	8526                	mv	a0,s1
    80001bec:	fffff097          	auipc	ra,0xfffff
    80001bf0:	010080e7          	jalr	16(ra) # 80000bfc <acquire>
      if (  p == get_head(&q2)   ) { //printf("q2 %p\n", p);
    80001bf4:	0089b783          	ld	a5,8(s3)
    80001bf8:	fcf487e3          	beq	s1,a5,80001bc6 <mlfq_like+0x84>
      else if (  p == get_head(&q1)   ) { //  printf("q1 %p\n", p);
    80001bfc:	0209b783          	ld	a5,32(s3)
    80001c00:	fcf49ae3          	bne	s1,a5,80001bd4 <mlfq_like+0x92>
        if(p->state == RUNNABLE) { p->state = RUNNING; c->proc = p;  swtch(&c->context, &p->context); c->proc = 0; }
    80001c04:	4c9c                	lw	a5,24(s1)
    80001c06:	07578663          	beq	a5,s5,80001c72 <mlfq_like+0x130>
        else if (p->state == SLEEPING) { dequeue(&q1); enqueue(&q0, p); }
    80001c0a:	09678163          	beq	a5,s6,80001c8c <mlfq_like+0x14a>
        else if (p->state == UNUSED || p->state == ZOMBIE) { dequeue(&q1); }
    80001c0e:	9bed                	andi	a5,a5,-5
    80001c10:	f3f1                	bnez	a5,80001bd4 <mlfq_like+0x92>
    80001c12:	8562                	mv	a0,s8
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	de0080e7          	jalr	-544(ra) # 800019f4 <dequeue>
    80001c1c:	bf65                	j	80001bd4 <mlfq_like+0x92>
        if(p->state == RUNNABLE) { p->state = RUNNING; c->proc = p;  swtch(&c->context, &p->context); c->proc = 0; dequeue(&q2); enqueue(&q1, p); }
    80001c1e:	478d                	li	a5,3
    80001c20:	cc9c                	sw	a5,24(s1)
    80001c22:	049bb423          	sd	s1,72(s7) # fffffffffffff048 <end+0xffffffff7ffd8048>
    80001c26:	85ca                	mv	a1,s2
    80001c28:	8566                	mv	a0,s9
    80001c2a:	00001097          	auipc	ra,0x1
    80001c2e:	d3e080e7          	jalr	-706(ra) # 80002968 <swtch>
    80001c32:	040bb423          	sd	zero,72(s7)
    80001c36:	854e                	mv	a0,s3
    80001c38:	00000097          	auipc	ra,0x0
    80001c3c:	dbc080e7          	jalr	-580(ra) # 800019f4 <dequeue>
    80001c40:	85a6                	mv	a1,s1
    80001c42:	8562                	mv	a0,s8
    80001c44:	00000097          	auipc	ra,0x0
    80001c48:	d70080e7          	jalr	-656(ra) # 800019b4 <enqueue>
    80001c4c:	b761                	j	80001bd4 <mlfq_like+0x92>
        else if (p->state == SLEEPING) { dequeue(&q2); enqueue(&q0, p); }
    80001c4e:	854e                	mv	a0,s3
    80001c50:	00000097          	auipc	ra,0x0
    80001c54:	da4080e7          	jalr	-604(ra) # 800019f4 <dequeue>
    80001c58:	85a6                	mv	a1,s1
    80001c5a:	856a                	mv	a0,s10
    80001c5c:	00000097          	auipc	ra,0x0
    80001c60:	d58080e7          	jalr	-680(ra) # 800019b4 <enqueue>
    80001c64:	bf85                	j	80001bd4 <mlfq_like+0x92>
        else if (p->state == UNUSED || p->state == ZOMBIE) { dequeue(&q2); } 
    80001c66:	854e                	mv	a0,s3
    80001c68:	00000097          	auipc	ra,0x0
    80001c6c:	d8c080e7          	jalr	-628(ra) # 800019f4 <dequeue>
    80001c70:	b795                	j	80001bd4 <mlfq_like+0x92>
        if(p->state == RUNNABLE) { p->state = RUNNING; c->proc = p;  swtch(&c->context, &p->context); c->proc = 0; }
    80001c72:	478d                	li	a5,3
    80001c74:	cc9c                	sw	a5,24(s1)
    80001c76:	049bb423          	sd	s1,72(s7)
    80001c7a:	85ca                	mv	a1,s2
    80001c7c:	8566                	mv	a0,s9
    80001c7e:	00001097          	auipc	ra,0x1
    80001c82:	cea080e7          	jalr	-790(ra) # 80002968 <swtch>
    80001c86:	040bb423          	sd	zero,72(s7)
    80001c8a:	b7a9                	j	80001bd4 <mlfq_like+0x92>
        else if (p->state == SLEEPING) { dequeue(&q1); enqueue(&q0, p); }
    80001c8c:	8562                	mv	a0,s8
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	d66080e7          	jalr	-666(ra) # 800019f4 <dequeue>
    80001c96:	85a6                	mv	a1,s1
    80001c98:	856a                	mv	a0,s10
    80001c9a:	00000097          	auipc	ra,0x0
    80001c9e:	d1a080e7          	jalr	-742(ra) # 800019b4 <enqueue>
    80001ca2:	bf0d                	j	80001bd4 <mlfq_like+0x92>

0000000080001ca4 <procinit>:
{
    80001ca4:	715d                	addi	sp,sp,-80
    80001ca6:	e486                	sd	ra,72(sp)
    80001ca8:	e0a2                	sd	s0,64(sp)
    80001caa:	fc26                	sd	s1,56(sp)
    80001cac:	f84a                	sd	s2,48(sp)
    80001cae:	f44e                	sd	s3,40(sp)
    80001cb0:	f052                	sd	s4,32(sp)
    80001cb2:	ec56                	sd	s5,24(sp)
    80001cb4:	e85a                	sd	s6,16(sp)
    80001cb6:	e45e                	sd	s7,8(sp)
    80001cb8:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001cba:	00006597          	auipc	a1,0x6
    80001cbe:	5be58593          	addi	a1,a1,1470 # 80008278 <digits+0x238>
    80001cc2:	00010517          	auipc	a0,0x10
    80001cc6:	0d650513          	addi	a0,a0,214 # 80011d98 <pid_lock>
    80001cca:	fffff097          	auipc	ra,0xfffff
    80001cce:	ea2080e7          	jalr	-350(ra) # 80000b6c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cd2:	00010917          	auipc	s2,0x10
    80001cd6:	0de90913          	addi	s2,s2,222 # 80011db0 <proc>
      initlock(&p->lock, "proc");
    80001cda:	00006b97          	auipc	s7,0x6
    80001cde:	5a6b8b93          	addi	s7,s7,1446 # 80008280 <digits+0x240>
      uint64 va = KSTACK((int) (p - proc));
    80001ce2:	8b4a                	mv	s6,s2
    80001ce4:	00006a97          	auipc	s5,0x6
    80001ce8:	31ca8a93          	addi	s5,s5,796 # 80008000 <etext>
    80001cec:	040009b7          	lui	s3,0x4000
    80001cf0:	19fd                	addi	s3,s3,-1
    80001cf2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cf4:	00016a17          	auipc	s4,0x16
    80001cf8:	0bca0a13          	addi	s4,s4,188 # 80017db0 <tickslock>
      initlock(&p->lock, "proc");
    80001cfc:	85de                	mv	a1,s7
    80001cfe:	854a                	mv	a0,s2
    80001d00:	fffff097          	auipc	ra,0xfffff
    80001d04:	e6c080e7          	jalr	-404(ra) # 80000b6c <initlock>
      char *pa = kalloc();
    80001d08:	fffff097          	auipc	ra,0xfffff
    80001d0c:	e04080e7          	jalr	-508(ra) # 80000b0c <kalloc>
    80001d10:	85aa                	mv	a1,a0
      if(pa == 0)
    80001d12:	c549                	beqz	a0,80001d9c <procinit+0xf8>
      uint64 va = KSTACK((int) (p - proc));
    80001d14:	416904b3          	sub	s1,s2,s6
    80001d18:	849d                	srai	s1,s1,0x7
    80001d1a:	000ab783          	ld	a5,0(s5)
    80001d1e:	02f484b3          	mul	s1,s1,a5
    80001d22:	2485                	addiw	s1,s1,1
    80001d24:	00d4949b          	slliw	s1,s1,0xd
    80001d28:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d2c:	4699                	li	a3,6
    80001d2e:	6605                	lui	a2,0x1
    80001d30:	8526                	mv	a0,s1
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	472080e7          	jalr	1138(ra) # 800011a4 <kvmmap>
      p->kstack = va;
    80001d3a:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d3e:	18090913          	addi	s2,s2,384
    80001d42:	fb491de3          	bne	s2,s4,80001cfc <procinit+0x58>
  kvminithart();
    80001d46:	fffff097          	auipc	ra,0xfffff
    80001d4a:	266080e7          	jalr	614(ra) # 80000fac <kvminithart>
void init_queue(_queue* q, int id) { q->q_id = id; q->q_head = 0; q->q_tail = 0; q->q_cnt = 0; };
    80001d4e:	00010797          	auipc	a5,0x10
    80001d52:	c0278793          	addi	a5,a5,-1022 # 80011950 <q2>
    80001d56:	4709                	li	a4,2
    80001d58:	c398                	sw	a4,0(a5)
    80001d5a:	0007b423          	sd	zero,8(a5)
    80001d5e:	0007b823          	sd	zero,16(a5)
    80001d62:	0007a223          	sw	zero,4(a5)
    80001d66:	4705                	li	a4,1
    80001d68:	cf98                	sw	a4,24(a5)
    80001d6a:	0207b023          	sd	zero,32(a5)
    80001d6e:	0207b423          	sd	zero,40(a5)
    80001d72:	0007ae23          	sw	zero,28(a5)
    80001d76:	0207a823          	sw	zero,48(a5)
    80001d7a:	0207bc23          	sd	zero,56(a5)
    80001d7e:	0407b023          	sd	zero,64(a5)
    80001d82:	0207aa23          	sw	zero,52(a5)
}
    80001d86:	60a6                	ld	ra,72(sp)
    80001d88:	6406                	ld	s0,64(sp)
    80001d8a:	74e2                	ld	s1,56(sp)
    80001d8c:	7942                	ld	s2,48(sp)
    80001d8e:	79a2                	ld	s3,40(sp)
    80001d90:	7a02                	ld	s4,32(sp)
    80001d92:	6ae2                	ld	s5,24(sp)
    80001d94:	6b42                	ld	s6,16(sp)
    80001d96:	6ba2                	ld	s7,8(sp)
    80001d98:	6161                	addi	sp,sp,80
    80001d9a:	8082                	ret
        panic("kalloc");
    80001d9c:	00006517          	auipc	a0,0x6
    80001da0:	4ec50513          	addi	a0,a0,1260 # 80008288 <digits+0x248>
    80001da4:	ffffe097          	auipc	ra,0xffffe
    80001da8:	79c080e7          	jalr	1948(ra) # 80000540 <panic>

0000000080001dac <cpuid>:
{
    80001dac:	1141                	addi	sp,sp,-16
    80001dae:	e422                	sd	s0,8(sp)
    80001db0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001db2:	8512                	mv	a0,tp
}
    80001db4:	2501                	sext.w	a0,a0
    80001db6:	6422                	ld	s0,8(sp)
    80001db8:	0141                	addi	sp,sp,16
    80001dba:	8082                	ret

0000000080001dbc <mycpu>:
mycpu(void) {
    80001dbc:	1141                	addi	sp,sp,-16
    80001dbe:	e422                	sd	s0,8(sp)
    80001dc0:	0800                	addi	s0,sp,16
    80001dc2:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001dc4:	2781                	sext.w	a5,a5
    80001dc6:	079e                	slli	a5,a5,0x7
}
    80001dc8:	00010517          	auipc	a0,0x10
    80001dcc:	bd050513          	addi	a0,a0,-1072 # 80011998 <cpus>
    80001dd0:	953e                	add	a0,a0,a5
    80001dd2:	6422                	ld	s0,8(sp)
    80001dd4:	0141                	addi	sp,sp,16
    80001dd6:	8082                	ret

0000000080001dd8 <myproc>:
myproc(void) {
    80001dd8:	1101                	addi	sp,sp,-32
    80001dda:	ec06                	sd	ra,24(sp)
    80001ddc:	e822                	sd	s0,16(sp)
    80001dde:	e426                	sd	s1,8(sp)
    80001de0:	1000                	addi	s0,sp,32
  push_off();
    80001de2:	fffff097          	auipc	ra,0xfffff
    80001de6:	dce080e7          	jalr	-562(ra) # 80000bb0 <push_off>
    80001dea:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001dec:	2781                	sext.w	a5,a5
    80001dee:	079e                	slli	a5,a5,0x7
    80001df0:	00010717          	auipc	a4,0x10
    80001df4:	b6070713          	addi	a4,a4,-1184 # 80011950 <q2>
    80001df8:	97ba                	add	a5,a5,a4
    80001dfa:	67a4                	ld	s1,72(a5)
  pop_off();
    80001dfc:	fffff097          	auipc	ra,0xfffff
    80001e00:	e54080e7          	jalr	-428(ra) # 80000c50 <pop_off>
}
    80001e04:	8526                	mv	a0,s1
    80001e06:	60e2                	ld	ra,24(sp)
    80001e08:	6442                	ld	s0,16(sp)
    80001e0a:	64a2                	ld	s1,8(sp)
    80001e0c:	6105                	addi	sp,sp,32
    80001e0e:	8082                	ret

0000000080001e10 <forkret>:
{
    80001e10:	1141                	addi	sp,sp,-16
    80001e12:	e406                	sd	ra,8(sp)
    80001e14:	e022                	sd	s0,0(sp)
    80001e16:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001e18:	00000097          	auipc	ra,0x0
    80001e1c:	fc0080e7          	jalr	-64(ra) # 80001dd8 <myproc>
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	e90080e7          	jalr	-368(ra) # 80000cb0 <release>
  if (first) {
    80001e28:	00007797          	auipc	a5,0x7
    80001e2c:	ac87a783          	lw	a5,-1336(a5) # 800088f0 <first.1>
    80001e30:	eb89                	bnez	a5,80001e42 <forkret+0x32>
  usertrapret();
    80001e32:	00001097          	auipc	ra,0x1
    80001e36:	be0080e7          	jalr	-1056(ra) # 80002a12 <usertrapret>
}
    80001e3a:	60a2                	ld	ra,8(sp)
    80001e3c:	6402                	ld	s0,0(sp)
    80001e3e:	0141                	addi	sp,sp,16
    80001e40:	8082                	ret
    first = 0;
    80001e42:	00007797          	auipc	a5,0x7
    80001e46:	aa07a723          	sw	zero,-1362(a5) # 800088f0 <first.1>
    fsinit(ROOTDEV);
    80001e4a:	4505                	li	a0,1
    80001e4c:	00002097          	auipc	ra,0x2
    80001e50:	94e080e7          	jalr	-1714(ra) # 8000379a <fsinit>
    80001e54:	bff9                	j	80001e32 <forkret+0x22>

0000000080001e56 <allocpid>:
allocpid() {
    80001e56:	1101                	addi	sp,sp,-32
    80001e58:	ec06                	sd	ra,24(sp)
    80001e5a:	e822                	sd	s0,16(sp)
    80001e5c:	e426                	sd	s1,8(sp)
    80001e5e:	e04a                	sd	s2,0(sp)
    80001e60:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001e62:	00010917          	auipc	s2,0x10
    80001e66:	f3690913          	addi	s2,s2,-202 # 80011d98 <pid_lock>
    80001e6a:	854a                	mv	a0,s2
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	d90080e7          	jalr	-624(ra) # 80000bfc <acquire>
  pid = nextpid;
    80001e74:	00007797          	auipc	a5,0x7
    80001e78:	a8078793          	addi	a5,a5,-1408 # 800088f4 <nextpid>
    80001e7c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001e7e:	0014871b          	addiw	a4,s1,1
    80001e82:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001e84:	854a                	mv	a0,s2
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	e2a080e7          	jalr	-470(ra) # 80000cb0 <release>
}
    80001e8e:	8526                	mv	a0,s1
    80001e90:	60e2                	ld	ra,24(sp)
    80001e92:	6442                	ld	s0,16(sp)
    80001e94:	64a2                	ld	s1,8(sp)
    80001e96:	6902                	ld	s2,0(sp)
    80001e98:	6105                	addi	sp,sp,32
    80001e9a:	8082                	ret

0000000080001e9c <proc_pagetable>:
{
    80001e9c:	1101                	addi	sp,sp,-32
    80001e9e:	ec06                	sd	ra,24(sp)
    80001ea0:	e822                	sd	s0,16(sp)
    80001ea2:	e426                	sd	s1,8(sp)
    80001ea4:	e04a                	sd	s2,0(sp)
    80001ea6:	1000                	addi	s0,sp,32
    80001ea8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001eaa:	fffff097          	auipc	ra,0xfffff
    80001eae:	4c8080e7          	jalr	1224(ra) # 80001372 <uvmcreate>
    80001eb2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001eb4:	c121                	beqz	a0,80001ef4 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001eb6:	4729                	li	a4,10
    80001eb8:	00005697          	auipc	a3,0x5
    80001ebc:	14868693          	addi	a3,a3,328 # 80007000 <_trampoline>
    80001ec0:	6605                	lui	a2,0x1
    80001ec2:	040005b7          	lui	a1,0x4000
    80001ec6:	15fd                	addi	a1,a1,-1
    80001ec8:	05b2                	slli	a1,a1,0xc
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	24c080e7          	jalr	588(ra) # 80001116 <mappages>
    80001ed2:	02054863          	bltz	a0,80001f02 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ed6:	4719                	li	a4,6
    80001ed8:	05893683          	ld	a3,88(s2)
    80001edc:	6605                	lui	a2,0x1
    80001ede:	020005b7          	lui	a1,0x2000
    80001ee2:	15fd                	addi	a1,a1,-1
    80001ee4:	05b6                	slli	a1,a1,0xd
    80001ee6:	8526                	mv	a0,s1
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	22e080e7          	jalr	558(ra) # 80001116 <mappages>
    80001ef0:	02054163          	bltz	a0,80001f12 <proc_pagetable+0x76>
}
    80001ef4:	8526                	mv	a0,s1
    80001ef6:	60e2                	ld	ra,24(sp)
    80001ef8:	6442                	ld	s0,16(sp)
    80001efa:	64a2                	ld	s1,8(sp)
    80001efc:	6902                	ld	s2,0(sp)
    80001efe:	6105                	addi	sp,sp,32
    80001f00:	8082                	ret
    uvmfree(pagetable, 0);
    80001f02:	4581                	li	a1,0
    80001f04:	8526                	mv	a0,s1
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	668080e7          	jalr	1640(ra) # 8000156e <uvmfree>
    return 0;
    80001f0e:	4481                	li	s1,0
    80001f10:	b7d5                	j	80001ef4 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f12:	4681                	li	a3,0
    80001f14:	4605                	li	a2,1
    80001f16:	040005b7          	lui	a1,0x4000
    80001f1a:	15fd                	addi	a1,a1,-1
    80001f1c:	05b2                	slli	a1,a1,0xc
    80001f1e:	8526                	mv	a0,s1
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	38e080e7          	jalr	910(ra) # 800012ae <uvmunmap>
    uvmfree(pagetable, 0);
    80001f28:	4581                	li	a1,0
    80001f2a:	8526                	mv	a0,s1
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	642080e7          	jalr	1602(ra) # 8000156e <uvmfree>
    return 0;
    80001f34:	4481                	li	s1,0
    80001f36:	bf7d                	j	80001ef4 <proc_pagetable+0x58>

0000000080001f38 <proc_freepagetable>:
{
    80001f38:	1101                	addi	sp,sp,-32
    80001f3a:	ec06                	sd	ra,24(sp)
    80001f3c:	e822                	sd	s0,16(sp)
    80001f3e:	e426                	sd	s1,8(sp)
    80001f40:	e04a                	sd	s2,0(sp)
    80001f42:	1000                	addi	s0,sp,32
    80001f44:	84aa                	mv	s1,a0
    80001f46:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f48:	4681                	li	a3,0
    80001f4a:	4605                	li	a2,1
    80001f4c:	040005b7          	lui	a1,0x4000
    80001f50:	15fd                	addi	a1,a1,-1
    80001f52:	05b2                	slli	a1,a1,0xc
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	35a080e7          	jalr	858(ra) # 800012ae <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001f5c:	4681                	li	a3,0
    80001f5e:	4605                	li	a2,1
    80001f60:	020005b7          	lui	a1,0x2000
    80001f64:	15fd                	addi	a1,a1,-1
    80001f66:	05b6                	slli	a1,a1,0xd
    80001f68:	8526                	mv	a0,s1
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	344080e7          	jalr	836(ra) # 800012ae <uvmunmap>
  uvmfree(pagetable, sz);
    80001f72:	85ca                	mv	a1,s2
    80001f74:	8526                	mv	a0,s1
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	5f8080e7          	jalr	1528(ra) # 8000156e <uvmfree>
}
    80001f7e:	60e2                	ld	ra,24(sp)
    80001f80:	6442                	ld	s0,16(sp)
    80001f82:	64a2                	ld	s1,8(sp)
    80001f84:	6902                	ld	s2,0(sp)
    80001f86:	6105                	addi	sp,sp,32
    80001f88:	8082                	ret

0000000080001f8a <freeproc>:
{
    80001f8a:	1101                	addi	sp,sp,-32
    80001f8c:	ec06                	sd	ra,24(sp)
    80001f8e:	e822                	sd	s0,16(sp)
    80001f90:	e426                	sd	s1,8(sp)
    80001f92:	1000                	addi	s0,sp,32
    80001f94:	84aa                	mv	s1,a0
  printf("%s (pid=%d): Q2(%d%%), Q1(%d%%), Q0(%d%%)\n",
    80001f96:	4781                	li	a5,0
    80001f98:	4701                	li	a4,0
    80001f9a:	4681                	li	a3,0
    80001f9c:	5d10                	lw	a2,56(a0)
    80001f9e:	15850593          	addi	a1,a0,344
    80001fa2:	00006517          	auipc	a0,0x6
    80001fa6:	2ee50513          	addi	a0,a0,750 # 80008290 <digits+0x250>
    80001faa:	ffffe097          	auipc	ra,0xffffe
    80001fae:	5e0080e7          	jalr	1504(ra) # 8000058a <printf>
  if(p->trapframe)
    80001fb2:	6ca8                	ld	a0,88(s1)
    80001fb4:	c509                	beqz	a0,80001fbe <freeproc+0x34>
    kfree((void*)p->trapframe);
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	a5a080e7          	jalr	-1446(ra) # 80000a10 <kfree>
  p->trapframe = 0;
    80001fbe:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001fc2:	68a8                	ld	a0,80(s1)
    80001fc4:	c511                	beqz	a0,80001fd0 <freeproc+0x46>
    proc_freepagetable(p->pagetable, p->sz);
    80001fc6:	64ac                	ld	a1,72(s1)
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	f70080e7          	jalr	-144(ra) # 80001f38 <proc_freepagetable>
  p->pagetable = 0;
    80001fd0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001fd4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001fd8:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001fdc:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001fe0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001fe4:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001fe8:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001fec:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001ff0:	0004ac23          	sw	zero,24(s1)
}
    80001ff4:	60e2                	ld	ra,24(sp)
    80001ff6:	6442                	ld	s0,16(sp)
    80001ff8:	64a2                	ld	s1,8(sp)
    80001ffa:	6105                	addi	sp,sp,32
    80001ffc:	8082                	ret

0000000080001ffe <allocproc>:
{
    80001ffe:	1101                	addi	sp,sp,-32
    80002000:	ec06                	sd	ra,24(sp)
    80002002:	e822                	sd	s0,16(sp)
    80002004:	e426                	sd	s1,8(sp)
    80002006:	e04a                	sd	s2,0(sp)
    80002008:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000200a:	00010497          	auipc	s1,0x10
    8000200e:	da648493          	addi	s1,s1,-602 # 80011db0 <proc>
    80002012:	00016917          	auipc	s2,0x16
    80002016:	d9e90913          	addi	s2,s2,-610 # 80017db0 <tickslock>
    acquire(&p->lock);
    8000201a:	8526                	mv	a0,s1
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	be0080e7          	jalr	-1056(ra) # 80000bfc <acquire>
    if(p->state == UNUSED) {
    80002024:	4c9c                	lw	a5,24(s1)
    80002026:	cf81                	beqz	a5,8000203e <allocproc+0x40>
      release(&p->lock);
    80002028:	8526                	mv	a0,s1
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	c86080e7          	jalr	-890(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002032:	18048493          	addi	s1,s1,384
    80002036:	ff2492e3          	bne	s1,s2,8000201a <allocproc+0x1c>
  return 0;
    8000203a:	4481                	li	s1,0
    8000203c:	a085                	j	8000209c <allocproc+0x9e>
  p->pid = allocpid();
    8000203e:	00000097          	auipc	ra,0x0
    80002042:	e18080e7          	jalr	-488(ra) # 80001e56 <allocpid>
    80002046:	dc88                	sw	a0,56(s1)
  enqueue(&q2, p);
    80002048:	85a6                	mv	a1,s1
    8000204a:	00010517          	auipc	a0,0x10
    8000204e:	90650513          	addi	a0,a0,-1786 # 80011950 <q2>
    80002052:	00000097          	auipc	ra,0x0
    80002056:	962080e7          	jalr	-1694(ra) # 800019b4 <enqueue>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	ab2080e7          	jalr	-1358(ra) # 80000b0c <kalloc>
    80002062:	892a                	mv	s2,a0
    80002064:	eca8                	sd	a0,88(s1)
    80002066:	c131                	beqz	a0,800020aa <allocproc+0xac>
  p->pagetable = proc_pagetable(p);
    80002068:	8526                	mv	a0,s1
    8000206a:	00000097          	auipc	ra,0x0
    8000206e:	e32080e7          	jalr	-462(ra) # 80001e9c <proc_pagetable>
    80002072:	892a                	mv	s2,a0
    80002074:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80002076:	c129                	beqz	a0,800020b8 <allocproc+0xba>
  memset(&p->context, 0, sizeof(p->context));
    80002078:	07000613          	li	a2,112
    8000207c:	4581                	li	a1,0
    8000207e:	06048513          	addi	a0,s1,96
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	c76080e7          	jalr	-906(ra) # 80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    8000208a:	00000797          	auipc	a5,0x0
    8000208e:	d8678793          	addi	a5,a5,-634 # 80001e10 <forkret>
    80002092:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002094:	60bc                	ld	a5,64(s1)
    80002096:	6705                	lui	a4,0x1
    80002098:	97ba                	add	a5,a5,a4
    8000209a:	f4bc                	sd	a5,104(s1)
}
    8000209c:	8526                	mv	a0,s1
    8000209e:	60e2                	ld	ra,24(sp)
    800020a0:	6442                	ld	s0,16(sp)
    800020a2:	64a2                	ld	s1,8(sp)
    800020a4:	6902                	ld	s2,0(sp)
    800020a6:	6105                	addi	sp,sp,32
    800020a8:	8082                	ret
    release(&p->lock);
    800020aa:	8526                	mv	a0,s1
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	c04080e7          	jalr	-1020(ra) # 80000cb0 <release>
    return 0;
    800020b4:	84ca                	mv	s1,s2
    800020b6:	b7dd                	j	8000209c <allocproc+0x9e>
    freeproc(p);
    800020b8:	8526                	mv	a0,s1
    800020ba:	00000097          	auipc	ra,0x0
    800020be:	ed0080e7          	jalr	-304(ra) # 80001f8a <freeproc>
    release(&p->lock);
    800020c2:	8526                	mv	a0,s1
    800020c4:	fffff097          	auipc	ra,0xfffff
    800020c8:	bec080e7          	jalr	-1044(ra) # 80000cb0 <release>
    return 0;
    800020cc:	84ca                	mv	s1,s2
    800020ce:	b7f9                	j	8000209c <allocproc+0x9e>

00000000800020d0 <userinit>:
{
    800020d0:	1101                	addi	sp,sp,-32
    800020d2:	ec06                	sd	ra,24(sp)
    800020d4:	e822                	sd	s0,16(sp)
    800020d6:	e426                	sd	s1,8(sp)
    800020d8:	1000                	addi	s0,sp,32
  p = allocproc();
    800020da:	00000097          	auipc	ra,0x0
    800020de:	f24080e7          	jalr	-220(ra) # 80001ffe <allocproc>
    800020e2:	84aa                	mv	s1,a0
  initproc = p;
    800020e4:	00007797          	auipc	a5,0x7
    800020e8:	f2a7ba23          	sd	a0,-204(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800020ec:	03400613          	li	a2,52
    800020f0:	00007597          	auipc	a1,0x7
    800020f4:	81058593          	addi	a1,a1,-2032 # 80008900 <initcode>
    800020f8:	6928                	ld	a0,80(a0)
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	2a6080e7          	jalr	678(ra) # 800013a0 <uvminit>
  p->sz = PGSIZE;
    80002102:	6785                	lui	a5,0x1
    80002104:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80002106:	6cb8                	ld	a4,88(s1)
    80002108:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000210c:	6cb8                	ld	a4,88(s1)
    8000210e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002110:	4641                	li	a2,16
    80002112:	00006597          	auipc	a1,0x6
    80002116:	1ae58593          	addi	a1,a1,430 # 800082c0 <digits+0x280>
    8000211a:	15848513          	addi	a0,s1,344
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	d2c080e7          	jalr	-724(ra) # 80000e4a <safestrcpy>
  p->cwd = namei("/");
    80002126:	00006517          	auipc	a0,0x6
    8000212a:	1aa50513          	addi	a0,a0,426 # 800082d0 <digits+0x290>
    8000212e:	00002097          	auipc	ra,0x2
    80002132:	094080e7          	jalr	148(ra) # 800041c2 <namei>
    80002136:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000213a:	4789                	li	a5,2
    8000213c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000213e:	8526                	mv	a0,s1
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	b70080e7          	jalr	-1168(ra) # 80000cb0 <release>
}
    80002148:	60e2                	ld	ra,24(sp)
    8000214a:	6442                	ld	s0,16(sp)
    8000214c:	64a2                	ld	s1,8(sp)
    8000214e:	6105                	addi	sp,sp,32
    80002150:	8082                	ret

0000000080002152 <growproc>:
{
    80002152:	1101                	addi	sp,sp,-32
    80002154:	ec06                	sd	ra,24(sp)
    80002156:	e822                	sd	s0,16(sp)
    80002158:	e426                	sd	s1,8(sp)
    8000215a:	e04a                	sd	s2,0(sp)
    8000215c:	1000                	addi	s0,sp,32
    8000215e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002160:	00000097          	auipc	ra,0x0
    80002164:	c78080e7          	jalr	-904(ra) # 80001dd8 <myproc>
    80002168:	892a                	mv	s2,a0
  sz = p->sz;
    8000216a:	652c                	ld	a1,72(a0)
    8000216c:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80002170:	00904f63          	bgtz	s1,8000218e <growproc+0x3c>
  } else if(n < 0){
    80002174:	0204cc63          	bltz	s1,800021ac <growproc+0x5a>
  p->sz = sz;
    80002178:	1602                	slli	a2,a2,0x20
    8000217a:	9201                	srli	a2,a2,0x20
    8000217c:	04c93423          	sd	a2,72(s2)
  return 0;
    80002180:	4501                	li	a0,0
}
    80002182:	60e2                	ld	ra,24(sp)
    80002184:	6442                	ld	s0,16(sp)
    80002186:	64a2                	ld	s1,8(sp)
    80002188:	6902                	ld	s2,0(sp)
    8000218a:	6105                	addi	sp,sp,32
    8000218c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000218e:	9e25                	addw	a2,a2,s1
    80002190:	1602                	slli	a2,a2,0x20
    80002192:	9201                	srli	a2,a2,0x20
    80002194:	1582                	slli	a1,a1,0x20
    80002196:	9181                	srli	a1,a1,0x20
    80002198:	6928                	ld	a0,80(a0)
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	2c0080e7          	jalr	704(ra) # 8000145a <uvmalloc>
    800021a2:	0005061b          	sext.w	a2,a0
    800021a6:	fa69                	bnez	a2,80002178 <growproc+0x26>
      return -1;
    800021a8:	557d                	li	a0,-1
    800021aa:	bfe1                	j	80002182 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800021ac:	9e25                	addw	a2,a2,s1
    800021ae:	1602                	slli	a2,a2,0x20
    800021b0:	9201                	srli	a2,a2,0x20
    800021b2:	1582                	slli	a1,a1,0x20
    800021b4:	9181                	srli	a1,a1,0x20
    800021b6:	6928                	ld	a0,80(a0)
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	25a080e7          	jalr	602(ra) # 80001412 <uvmdealloc>
    800021c0:	0005061b          	sext.w	a2,a0
    800021c4:	bf55                	j	80002178 <growproc+0x26>

00000000800021c6 <fork>:
{
    800021c6:	7139                	addi	sp,sp,-64
    800021c8:	fc06                	sd	ra,56(sp)
    800021ca:	f822                	sd	s0,48(sp)
    800021cc:	f426                	sd	s1,40(sp)
    800021ce:	f04a                	sd	s2,32(sp)
    800021d0:	ec4e                	sd	s3,24(sp)
    800021d2:	e852                	sd	s4,16(sp)
    800021d4:	e456                	sd	s5,8(sp)
    800021d6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800021d8:	00000097          	auipc	ra,0x0
    800021dc:	c00080e7          	jalr	-1024(ra) # 80001dd8 <myproc>
    800021e0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800021e2:	00000097          	auipc	ra,0x0
    800021e6:	e1c080e7          	jalr	-484(ra) # 80001ffe <allocproc>
    800021ea:	c17d                	beqz	a0,800022d0 <fork+0x10a>
    800021ec:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800021ee:	048ab603          	ld	a2,72(s5)
    800021f2:	692c                	ld	a1,80(a0)
    800021f4:	050ab503          	ld	a0,80(s5)
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	3ae080e7          	jalr	942(ra) # 800015a6 <uvmcopy>
    80002200:	04054a63          	bltz	a0,80002254 <fork+0x8e>
  np->sz = p->sz;
    80002204:	048ab783          	ld	a5,72(s5)
    80002208:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    8000220c:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80002210:	058ab683          	ld	a3,88(s5)
    80002214:	87b6                	mv	a5,a3
    80002216:	058a3703          	ld	a4,88(s4)
    8000221a:	12068693          	addi	a3,a3,288
    8000221e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002222:	6788                	ld	a0,8(a5)
    80002224:	6b8c                	ld	a1,16(a5)
    80002226:	6f90                	ld	a2,24(a5)
    80002228:	01073023          	sd	a6,0(a4)
    8000222c:	e708                	sd	a0,8(a4)
    8000222e:	eb0c                	sd	a1,16(a4)
    80002230:	ef10                	sd	a2,24(a4)
    80002232:	02078793          	addi	a5,a5,32
    80002236:	02070713          	addi	a4,a4,32
    8000223a:	fed792e3          	bne	a5,a3,8000221e <fork+0x58>
  np->trapframe->a0 = 0;
    8000223e:	058a3783          	ld	a5,88(s4)
    80002242:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002246:	0d0a8493          	addi	s1,s5,208
    8000224a:	0d0a0913          	addi	s2,s4,208
    8000224e:	150a8993          	addi	s3,s5,336
    80002252:	a00d                	j	80002274 <fork+0xae>
    freeproc(np);
    80002254:	8552                	mv	a0,s4
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	d34080e7          	jalr	-716(ra) # 80001f8a <freeproc>
    release(&np->lock);
    8000225e:	8552                	mv	a0,s4
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	a50080e7          	jalr	-1456(ra) # 80000cb0 <release>
    return -1;
    80002268:	54fd                	li	s1,-1
    8000226a:	a889                	j	800022bc <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    8000226c:	04a1                	addi	s1,s1,8
    8000226e:	0921                	addi	s2,s2,8
    80002270:	01348b63          	beq	s1,s3,80002286 <fork+0xc0>
    if(p->ofile[i])
    80002274:	6088                	ld	a0,0(s1)
    80002276:	d97d                	beqz	a0,8000226c <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80002278:	00002097          	auipc	ra,0x2
    8000227c:	5da080e7          	jalr	1498(ra) # 80004852 <filedup>
    80002280:	00a93023          	sd	a0,0(s2)
    80002284:	b7e5                	j	8000226c <fork+0xa6>
  np->cwd = idup(p->cwd);
    80002286:	150ab503          	ld	a0,336(s5)
    8000228a:	00001097          	auipc	ra,0x1
    8000228e:	74a080e7          	jalr	1866(ra) # 800039d4 <idup>
    80002292:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002296:	4641                	li	a2,16
    80002298:	158a8593          	addi	a1,s5,344
    8000229c:	158a0513          	addi	a0,s4,344
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	baa080e7          	jalr	-1110(ra) # 80000e4a <safestrcpy>
  pid = np->pid;
    800022a8:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    800022ac:	4789                	li	a5,2
    800022ae:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800022b2:	8552                	mv	a0,s4
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	9fc080e7          	jalr	-1540(ra) # 80000cb0 <release>
}
    800022bc:	8526                	mv	a0,s1
    800022be:	70e2                	ld	ra,56(sp)
    800022c0:	7442                	ld	s0,48(sp)
    800022c2:	74a2                	ld	s1,40(sp)
    800022c4:	7902                	ld	s2,32(sp)
    800022c6:	69e2                	ld	s3,24(sp)
    800022c8:	6a42                	ld	s4,16(sp)
    800022ca:	6aa2                	ld	s5,8(sp)
    800022cc:	6121                	addi	sp,sp,64
    800022ce:	8082                	ret
    return -1;
    800022d0:	54fd                	li	s1,-1
    800022d2:	b7ed                	j	800022bc <fork+0xf6>

00000000800022d4 <reparent>:
{
    800022d4:	7179                	addi	sp,sp,-48
    800022d6:	f406                	sd	ra,40(sp)
    800022d8:	f022                	sd	s0,32(sp)
    800022da:	ec26                	sd	s1,24(sp)
    800022dc:	e84a                	sd	s2,16(sp)
    800022de:	e44e                	sd	s3,8(sp)
    800022e0:	e052                	sd	s4,0(sp)
    800022e2:	1800                	addi	s0,sp,48
    800022e4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e6:	00010497          	auipc	s1,0x10
    800022ea:	aca48493          	addi	s1,s1,-1334 # 80011db0 <proc>
      pp->parent = initproc;
    800022ee:	00007a17          	auipc	s4,0x7
    800022f2:	d2aa0a13          	addi	s4,s4,-726 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022f6:	00016997          	auipc	s3,0x16
    800022fa:	aba98993          	addi	s3,s3,-1350 # 80017db0 <tickslock>
    800022fe:	a029                	j	80002308 <reparent+0x34>
    80002300:	18048493          	addi	s1,s1,384
    80002304:	03348363          	beq	s1,s3,8000232a <reparent+0x56>
    if(pp->parent == p){
    80002308:	709c                	ld	a5,32(s1)
    8000230a:	ff279be3          	bne	a5,s2,80002300 <reparent+0x2c>
      acquire(&pp->lock);
    8000230e:	8526                	mv	a0,s1
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	8ec080e7          	jalr	-1812(ra) # 80000bfc <acquire>
      pp->parent = initproc;
    80002318:	000a3783          	ld	a5,0(s4)
    8000231c:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    8000231e:	8526                	mv	a0,s1
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	990080e7          	jalr	-1648(ra) # 80000cb0 <release>
    80002328:	bfe1                	j	80002300 <reparent+0x2c>
}
    8000232a:	70a2                	ld	ra,40(sp)
    8000232c:	7402                	ld	s0,32(sp)
    8000232e:	64e2                	ld	s1,24(sp)
    80002330:	6942                	ld	s2,16(sp)
    80002332:	69a2                	ld	s3,8(sp)
    80002334:	6a02                	ld	s4,0(sp)
    80002336:	6145                	addi	sp,sp,48
    80002338:	8082                	ret

000000008000233a <scheduler>:
{
    8000233a:	1141                	addi	sp,sp,-16
    8000233c:	e406                	sd	ra,8(sp)
    8000233e:	e022                	sd	s0,0(sp)
    80002340:	0800                	addi	s0,sp,16
  mlfq_like();
    80002342:	00000097          	auipc	ra,0x0
    80002346:	800080e7          	jalr	-2048(ra) # 80001b42 <mlfq_like>

000000008000234a <sched>:
{
    8000234a:	7179                	addi	sp,sp,-48
    8000234c:	f406                	sd	ra,40(sp)
    8000234e:	f022                	sd	s0,32(sp)
    80002350:	ec26                	sd	s1,24(sp)
    80002352:	e84a                	sd	s2,16(sp)
    80002354:	e44e                	sd	s3,8(sp)
    80002356:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002358:	00000097          	auipc	ra,0x0
    8000235c:	a80080e7          	jalr	-1408(ra) # 80001dd8 <myproc>
    80002360:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	820080e7          	jalr	-2016(ra) # 80000b82 <holding>
    8000236a:	c93d                	beqz	a0,800023e0 <sched+0x96>
    8000236c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000236e:	2781                	sext.w	a5,a5
    80002370:	079e                	slli	a5,a5,0x7
    80002372:	0000f717          	auipc	a4,0xf
    80002376:	5de70713          	addi	a4,a4,1502 # 80011950 <q2>
    8000237a:	97ba                	add	a5,a5,a4
    8000237c:	0c07a703          	lw	a4,192(a5)
    80002380:	4785                	li	a5,1
    80002382:	06f71763          	bne	a4,a5,800023f0 <sched+0xa6>
  if(p->state == RUNNING)
    80002386:	4c98                	lw	a4,24(s1)
    80002388:	478d                	li	a5,3
    8000238a:	06f70b63          	beq	a4,a5,80002400 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000238e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002392:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002394:	efb5                	bnez	a5,80002410 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002396:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002398:	0000f917          	auipc	s2,0xf
    8000239c:	5b890913          	addi	s2,s2,1464 # 80011950 <q2>
    800023a0:	2781                	sext.w	a5,a5
    800023a2:	079e                	slli	a5,a5,0x7
    800023a4:	97ca                	add	a5,a5,s2
    800023a6:	0c47a983          	lw	s3,196(a5)
    800023aa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800023ac:	2781                	sext.w	a5,a5
    800023ae:	079e                	slli	a5,a5,0x7
    800023b0:	0000f597          	auipc	a1,0xf
    800023b4:	5f058593          	addi	a1,a1,1520 # 800119a0 <cpus+0x8>
    800023b8:	95be                	add	a1,a1,a5
    800023ba:	06048513          	addi	a0,s1,96
    800023be:	00000097          	auipc	ra,0x0
    800023c2:	5aa080e7          	jalr	1450(ra) # 80002968 <swtch>
    800023c6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800023c8:	2781                	sext.w	a5,a5
    800023ca:	079e                	slli	a5,a5,0x7
    800023cc:	97ca                	add	a5,a5,s2
    800023ce:	0d37a223          	sw	s3,196(a5)
}
    800023d2:	70a2                	ld	ra,40(sp)
    800023d4:	7402                	ld	s0,32(sp)
    800023d6:	64e2                	ld	s1,24(sp)
    800023d8:	6942                	ld	s2,16(sp)
    800023da:	69a2                	ld	s3,8(sp)
    800023dc:	6145                	addi	sp,sp,48
    800023de:	8082                	ret
    panic("sched p->lock");
    800023e0:	00006517          	auipc	a0,0x6
    800023e4:	ef850513          	addi	a0,a0,-264 # 800082d8 <digits+0x298>
    800023e8:	ffffe097          	auipc	ra,0xffffe
    800023ec:	158080e7          	jalr	344(ra) # 80000540 <panic>
    panic("sched locks");
    800023f0:	00006517          	auipc	a0,0x6
    800023f4:	ef850513          	addi	a0,a0,-264 # 800082e8 <digits+0x2a8>
    800023f8:	ffffe097          	auipc	ra,0xffffe
    800023fc:	148080e7          	jalr	328(ra) # 80000540 <panic>
    panic("sched running");
    80002400:	00006517          	auipc	a0,0x6
    80002404:	ef850513          	addi	a0,a0,-264 # 800082f8 <digits+0x2b8>
    80002408:	ffffe097          	auipc	ra,0xffffe
    8000240c:	138080e7          	jalr	312(ra) # 80000540 <panic>
    panic("sched interruptible");
    80002410:	00006517          	auipc	a0,0x6
    80002414:	ef850513          	addi	a0,a0,-264 # 80008308 <digits+0x2c8>
    80002418:	ffffe097          	auipc	ra,0xffffe
    8000241c:	128080e7          	jalr	296(ra) # 80000540 <panic>

0000000080002420 <exit>:
{
    80002420:	7179                	addi	sp,sp,-48
    80002422:	f406                	sd	ra,40(sp)
    80002424:	f022                	sd	s0,32(sp)
    80002426:	ec26                	sd	s1,24(sp)
    80002428:	e84a                	sd	s2,16(sp)
    8000242a:	e44e                	sd	s3,8(sp)
    8000242c:	e052                	sd	s4,0(sp)
    8000242e:	1800                	addi	s0,sp,48
    80002430:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002432:	00000097          	auipc	ra,0x0
    80002436:	9a6080e7          	jalr	-1626(ra) # 80001dd8 <myproc>
    8000243a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000243c:	00007797          	auipc	a5,0x7
    80002440:	bdc7b783          	ld	a5,-1060(a5) # 80009018 <initproc>
    80002444:	0d050493          	addi	s1,a0,208
    80002448:	15050913          	addi	s2,a0,336
    8000244c:	02a79363          	bne	a5,a0,80002472 <exit+0x52>
    panic("init exiting");
    80002450:	00006517          	auipc	a0,0x6
    80002454:	ed050513          	addi	a0,a0,-304 # 80008320 <digits+0x2e0>
    80002458:	ffffe097          	auipc	ra,0xffffe
    8000245c:	0e8080e7          	jalr	232(ra) # 80000540 <panic>
      fileclose(f);
    80002460:	00002097          	auipc	ra,0x2
    80002464:	444080e7          	jalr	1092(ra) # 800048a4 <fileclose>
      p->ofile[fd] = 0;
    80002468:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000246c:	04a1                	addi	s1,s1,8
    8000246e:	01248563          	beq	s1,s2,80002478 <exit+0x58>
    if(p->ofile[fd]){
    80002472:	6088                	ld	a0,0(s1)
    80002474:	f575                	bnez	a0,80002460 <exit+0x40>
    80002476:	bfdd                	j	8000246c <exit+0x4c>
  begin_op();
    80002478:	00002097          	auipc	ra,0x2
    8000247c:	f5a080e7          	jalr	-166(ra) # 800043d2 <begin_op>
  iput(p->cwd);
    80002480:	1509b503          	ld	a0,336(s3)
    80002484:	00001097          	auipc	ra,0x1
    80002488:	748080e7          	jalr	1864(ra) # 80003bcc <iput>
  end_op();
    8000248c:	00002097          	auipc	ra,0x2
    80002490:	fc6080e7          	jalr	-58(ra) # 80004452 <end_op>
  p->cwd = 0;
    80002494:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80002498:	00007497          	auipc	s1,0x7
    8000249c:	b8048493          	addi	s1,s1,-1152 # 80009018 <initproc>
    800024a0:	6088                	ld	a0,0(s1)
    800024a2:	ffffe097          	auipc	ra,0xffffe
    800024a6:	75a080e7          	jalr	1882(ra) # 80000bfc <acquire>
  wakeup1(initproc);
    800024aa:	6088                	ld	a0,0(s1)
    800024ac:	fffff097          	auipc	ra,0xfffff
    800024b0:	618080e7          	jalr	1560(ra) # 80001ac4 <wakeup1>
  release(&initproc->lock);
    800024b4:	6088                	ld	a0,0(s1)
    800024b6:	ffffe097          	auipc	ra,0xffffe
    800024ba:	7fa080e7          	jalr	2042(ra) # 80000cb0 <release>
  acquire(&p->lock);
    800024be:	854e                	mv	a0,s3
    800024c0:	ffffe097          	auipc	ra,0xffffe
    800024c4:	73c080e7          	jalr	1852(ra) # 80000bfc <acquire>
  struct proc *original_parent = p->parent;
    800024c8:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800024cc:	854e                	mv	a0,s3
    800024ce:	ffffe097          	auipc	ra,0xffffe
    800024d2:	7e2080e7          	jalr	2018(ra) # 80000cb0 <release>
  acquire(&original_parent->lock);
    800024d6:	8526                	mv	a0,s1
    800024d8:	ffffe097          	auipc	ra,0xffffe
    800024dc:	724080e7          	jalr	1828(ra) # 80000bfc <acquire>
  acquire(&p->lock);
    800024e0:	854e                	mv	a0,s3
    800024e2:	ffffe097          	auipc	ra,0xffffe
    800024e6:	71a080e7          	jalr	1818(ra) # 80000bfc <acquire>
  reparent(p);
    800024ea:	854e                	mv	a0,s3
    800024ec:	00000097          	auipc	ra,0x0
    800024f0:	de8080e7          	jalr	-536(ra) # 800022d4 <reparent>
  wakeup1(original_parent);
    800024f4:	8526                	mv	a0,s1
    800024f6:	fffff097          	auipc	ra,0xfffff
    800024fa:	5ce080e7          	jalr	1486(ra) # 80001ac4 <wakeup1>
  p->xstate = status;
    800024fe:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002502:	4791                	li	a5,4
    80002504:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002508:	8526                	mv	a0,s1
    8000250a:	ffffe097          	auipc	ra,0xffffe
    8000250e:	7a6080e7          	jalr	1958(ra) # 80000cb0 <release>
  sched();
    80002512:	00000097          	auipc	ra,0x0
    80002516:	e38080e7          	jalr	-456(ra) # 8000234a <sched>
  panic("zombie exit");
    8000251a:	00006517          	auipc	a0,0x6
    8000251e:	e1650513          	addi	a0,a0,-490 # 80008330 <digits+0x2f0>
    80002522:	ffffe097          	auipc	ra,0xffffe
    80002526:	01e080e7          	jalr	30(ra) # 80000540 <panic>

000000008000252a <yield>:
{
    8000252a:	1101                	addi	sp,sp,-32
    8000252c:	ec06                	sd	ra,24(sp)
    8000252e:	e822                	sd	s0,16(sp)
    80002530:	e426                	sd	s1,8(sp)
    80002532:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002534:	00000097          	auipc	ra,0x0
    80002538:	8a4080e7          	jalr	-1884(ra) # 80001dd8 <myproc>
    8000253c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000253e:	ffffe097          	auipc	ra,0xffffe
    80002542:	6be080e7          	jalr	1726(ra) # 80000bfc <acquire>
  p->state = RUNNABLE;
    80002546:	4789                	li	a5,2
    80002548:	cc9c                	sw	a5,24(s1)
  sched();
    8000254a:	00000097          	auipc	ra,0x0
    8000254e:	e00080e7          	jalr	-512(ra) # 8000234a <sched>
  release(&p->lock);
    80002552:	8526                	mv	a0,s1
    80002554:	ffffe097          	auipc	ra,0xffffe
    80002558:	75c080e7          	jalr	1884(ra) # 80000cb0 <release>
}
    8000255c:	60e2                	ld	ra,24(sp)
    8000255e:	6442                	ld	s0,16(sp)
    80002560:	64a2                	ld	s1,8(sp)
    80002562:	6105                	addi	sp,sp,32
    80002564:	8082                	ret

0000000080002566 <sleep>:
{
    80002566:	7179                	addi	sp,sp,-48
    80002568:	f406                	sd	ra,40(sp)
    8000256a:	f022                	sd	s0,32(sp)
    8000256c:	ec26                	sd	s1,24(sp)
    8000256e:	e84a                	sd	s2,16(sp)
    80002570:	e44e                	sd	s3,8(sp)
    80002572:	1800                	addi	s0,sp,48
    80002574:	89aa                	mv	s3,a0
    80002576:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002578:	00000097          	auipc	ra,0x0
    8000257c:	860080e7          	jalr	-1952(ra) # 80001dd8 <myproc>
    80002580:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002582:	05250663          	beq	a0,s2,800025ce <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002586:	ffffe097          	auipc	ra,0xffffe
    8000258a:	676080e7          	jalr	1654(ra) # 80000bfc <acquire>
    release(lk);
    8000258e:	854a                	mv	a0,s2
    80002590:	ffffe097          	auipc	ra,0xffffe
    80002594:	720080e7          	jalr	1824(ra) # 80000cb0 <release>
  p->chan = chan;
    80002598:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000259c:	4785                	li	a5,1
    8000259e:	cc9c                	sw	a5,24(s1)
  sched();
    800025a0:	00000097          	auipc	ra,0x0
    800025a4:	daa080e7          	jalr	-598(ra) # 8000234a <sched>
  p->chan = 0;
    800025a8:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800025ac:	8526                	mv	a0,s1
    800025ae:	ffffe097          	auipc	ra,0xffffe
    800025b2:	702080e7          	jalr	1794(ra) # 80000cb0 <release>
    acquire(lk);
    800025b6:	854a                	mv	a0,s2
    800025b8:	ffffe097          	auipc	ra,0xffffe
    800025bc:	644080e7          	jalr	1604(ra) # 80000bfc <acquire>
}
    800025c0:	70a2                	ld	ra,40(sp)
    800025c2:	7402                	ld	s0,32(sp)
    800025c4:	64e2                	ld	s1,24(sp)
    800025c6:	6942                	ld	s2,16(sp)
    800025c8:	69a2                	ld	s3,8(sp)
    800025ca:	6145                	addi	sp,sp,48
    800025cc:	8082                	ret
  p->chan = chan;
    800025ce:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800025d2:	4785                	li	a5,1
    800025d4:	cd1c                	sw	a5,24(a0)
  sched();
    800025d6:	00000097          	auipc	ra,0x0
    800025da:	d74080e7          	jalr	-652(ra) # 8000234a <sched>
  p->chan = 0;
    800025de:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800025e2:	bff9                	j	800025c0 <sleep+0x5a>

00000000800025e4 <wait>:
{
    800025e4:	715d                	addi	sp,sp,-80
    800025e6:	e486                	sd	ra,72(sp)
    800025e8:	e0a2                	sd	s0,64(sp)
    800025ea:	fc26                	sd	s1,56(sp)
    800025ec:	f84a                	sd	s2,48(sp)
    800025ee:	f44e                	sd	s3,40(sp)
    800025f0:	f052                	sd	s4,32(sp)
    800025f2:	ec56                	sd	s5,24(sp)
    800025f4:	e85a                	sd	s6,16(sp)
    800025f6:	e45e                	sd	s7,8(sp)
    800025f8:	0880                	addi	s0,sp,80
    800025fa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800025fc:	fffff097          	auipc	ra,0xfffff
    80002600:	7dc080e7          	jalr	2012(ra) # 80001dd8 <myproc>
    80002604:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002606:	ffffe097          	auipc	ra,0xffffe
    8000260a:	5f6080e7          	jalr	1526(ra) # 80000bfc <acquire>
    havekids = 0;
    8000260e:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002610:	4a11                	li	s4,4
        havekids = 1;
    80002612:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002614:	00015997          	auipc	s3,0x15
    80002618:	79c98993          	addi	s3,s3,1948 # 80017db0 <tickslock>
    havekids = 0;
    8000261c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000261e:	0000f497          	auipc	s1,0xf
    80002622:	79248493          	addi	s1,s1,1938 # 80011db0 <proc>
    80002626:	a08d                	j	80002688 <wait+0xa4>
          pid = np->pid;
    80002628:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000262c:	000b0e63          	beqz	s6,80002648 <wait+0x64>
    80002630:	4691                	li	a3,4
    80002632:	03448613          	addi	a2,s1,52
    80002636:	85da                	mv	a1,s6
    80002638:	05093503          	ld	a0,80(s2)
    8000263c:	fffff097          	auipc	ra,0xfffff
    80002640:	06e080e7          	jalr	110(ra) # 800016aa <copyout>
    80002644:	02054263          	bltz	a0,80002668 <wait+0x84>
          freeproc(np);
    80002648:	8526                	mv	a0,s1
    8000264a:	00000097          	auipc	ra,0x0
    8000264e:	940080e7          	jalr	-1728(ra) # 80001f8a <freeproc>
          release(&np->lock);
    80002652:	8526                	mv	a0,s1
    80002654:	ffffe097          	auipc	ra,0xffffe
    80002658:	65c080e7          	jalr	1628(ra) # 80000cb0 <release>
          release(&p->lock);
    8000265c:	854a                	mv	a0,s2
    8000265e:	ffffe097          	auipc	ra,0xffffe
    80002662:	652080e7          	jalr	1618(ra) # 80000cb0 <release>
          return pid;
    80002666:	a8a9                	j	800026c0 <wait+0xdc>
            release(&np->lock);
    80002668:	8526                	mv	a0,s1
    8000266a:	ffffe097          	auipc	ra,0xffffe
    8000266e:	646080e7          	jalr	1606(ra) # 80000cb0 <release>
            release(&p->lock);
    80002672:	854a                	mv	a0,s2
    80002674:	ffffe097          	auipc	ra,0xffffe
    80002678:	63c080e7          	jalr	1596(ra) # 80000cb0 <release>
            return -1;
    8000267c:	59fd                	li	s3,-1
    8000267e:	a089                	j	800026c0 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    80002680:	18048493          	addi	s1,s1,384
    80002684:	03348463          	beq	s1,s3,800026ac <wait+0xc8>
      if(np->parent == p){
    80002688:	709c                	ld	a5,32(s1)
    8000268a:	ff279be3          	bne	a5,s2,80002680 <wait+0x9c>
        acquire(&np->lock);
    8000268e:	8526                	mv	a0,s1
    80002690:	ffffe097          	auipc	ra,0xffffe
    80002694:	56c080e7          	jalr	1388(ra) # 80000bfc <acquire>
        if(np->state == ZOMBIE){
    80002698:	4c9c                	lw	a5,24(s1)
    8000269a:	f94787e3          	beq	a5,s4,80002628 <wait+0x44>
        release(&np->lock);
    8000269e:	8526                	mv	a0,s1
    800026a0:	ffffe097          	auipc	ra,0xffffe
    800026a4:	610080e7          	jalr	1552(ra) # 80000cb0 <release>
        havekids = 1;
    800026a8:	8756                	mv	a4,s5
    800026aa:	bfd9                	j	80002680 <wait+0x9c>
    if(!havekids || p->killed){
    800026ac:	c701                	beqz	a4,800026b4 <wait+0xd0>
    800026ae:	03092783          	lw	a5,48(s2)
    800026b2:	c39d                	beqz	a5,800026d8 <wait+0xf4>
      release(&p->lock);
    800026b4:	854a                	mv	a0,s2
    800026b6:	ffffe097          	auipc	ra,0xffffe
    800026ba:	5fa080e7          	jalr	1530(ra) # 80000cb0 <release>
      return -1;
    800026be:	59fd                	li	s3,-1
}
    800026c0:	854e                	mv	a0,s3
    800026c2:	60a6                	ld	ra,72(sp)
    800026c4:	6406                	ld	s0,64(sp)
    800026c6:	74e2                	ld	s1,56(sp)
    800026c8:	7942                	ld	s2,48(sp)
    800026ca:	79a2                	ld	s3,40(sp)
    800026cc:	7a02                	ld	s4,32(sp)
    800026ce:	6ae2                	ld	s5,24(sp)
    800026d0:	6b42                	ld	s6,16(sp)
    800026d2:	6ba2                	ld	s7,8(sp)
    800026d4:	6161                	addi	sp,sp,80
    800026d6:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800026d8:	85ca                	mv	a1,s2
    800026da:	854a                	mv	a0,s2
    800026dc:	00000097          	auipc	ra,0x0
    800026e0:	e8a080e7          	jalr	-374(ra) # 80002566 <sleep>
    havekids = 0;
    800026e4:	bf25                	j	8000261c <wait+0x38>

00000000800026e6 <wakeup>:
{
    800026e6:	715d                	addi	sp,sp,-80
    800026e8:	e486                	sd	ra,72(sp)
    800026ea:	e0a2                	sd	s0,64(sp)
    800026ec:	fc26                	sd	s1,56(sp)
    800026ee:	f84a                	sd	s2,48(sp)
    800026f0:	f44e                	sd	s3,40(sp)
    800026f2:	f052                	sd	s4,32(sp)
    800026f4:	ec56                	sd	s5,24(sp)
    800026f6:	e85a                	sd	s6,16(sp)
    800026f8:	e45e                	sd	s7,8(sp)
    800026fa:	e062                	sd	s8,0(sp)
    800026fc:	0880                	addi	s0,sp,80
    800026fe:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002700:	0000f497          	auipc	s1,0xf
    80002704:	6b048493          	addi	s1,s1,1712 # 80011db0 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002708:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000270a:	4b09                	li	s6,2
      printf("wakeup\n");
    8000270c:	00006a97          	auipc	s5,0x6
    80002710:	c34a8a93          	addi	s5,s5,-972 # 80008340 <digits+0x300>
      if (is_q0(p)) { remove(&q0, p); enqueue(&q2, p); }
    80002714:	0000fc17          	auipc	s8,0xf
    80002718:	23cc0c13          	addi	s8,s8,572 # 80011950 <q2>
    8000271c:	0000fb97          	auipc	s7,0xf
    80002720:	264b8b93          	addi	s7,s7,612 # 80011980 <q0>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002724:	00015917          	auipc	s2,0x15
    80002728:	68c90913          	addi	s2,s2,1676 # 80017db0 <tickslock>
    8000272c:	a811                	j	80002740 <wakeup+0x5a>
    release(&p->lock);
    8000272e:	8526                	mv	a0,s1
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	580080e7          	jalr	1408(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002738:	18048493          	addi	s1,s1,384
    8000273c:	05248463          	beq	s1,s2,80002784 <wakeup+0x9e>
    acquire(&p->lock);
    80002740:	8526                	mv	a0,s1
    80002742:	ffffe097          	auipc	ra,0xffffe
    80002746:	4ba080e7          	jalr	1210(ra) # 80000bfc <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    8000274a:	4c9c                	lw	a5,24(s1)
    8000274c:	ff3791e3          	bne	a5,s3,8000272e <wakeup+0x48>
    80002750:	749c                	ld	a5,40(s1)
    80002752:	fd479ee3          	bne	a5,s4,8000272e <wakeup+0x48>
      p->state = RUNNABLE;
    80002756:	0164ac23          	sw	s6,24(s1)
      printf("wakeup\n");
    8000275a:	8556                	mv	a0,s5
    8000275c:	ffffe097          	auipc	ra,0xffffe
    80002760:	e2e080e7          	jalr	-466(ra) # 8000058a <printf>
      if (is_q0(p)) { remove(&q0, p); enqueue(&q2, p); }
    80002764:	1684a783          	lw	a5,360(s1)
    80002768:	f3f9                	bnez	a5,8000272e <wakeup+0x48>
    8000276a:	85a6                	mv	a1,s1
    8000276c:	855e                	mv	a0,s7
    8000276e:	fffff097          	auipc	ra,0xfffff
    80002772:	2cc080e7          	jalr	716(ra) # 80001a3a <remove>
    80002776:	85a6                	mv	a1,s1
    80002778:	8562                	mv	a0,s8
    8000277a:	fffff097          	auipc	ra,0xfffff
    8000277e:	23a080e7          	jalr	570(ra) # 800019b4 <enqueue>
    80002782:	b775                	j	8000272e <wakeup+0x48>
}
    80002784:	60a6                	ld	ra,72(sp)
    80002786:	6406                	ld	s0,64(sp)
    80002788:	74e2                	ld	s1,56(sp)
    8000278a:	7942                	ld	s2,48(sp)
    8000278c:	79a2                	ld	s3,40(sp)
    8000278e:	7a02                	ld	s4,32(sp)
    80002790:	6ae2                	ld	s5,24(sp)
    80002792:	6b42                	ld	s6,16(sp)
    80002794:	6ba2                	ld	s7,8(sp)
    80002796:	6c02                	ld	s8,0(sp)
    80002798:	6161                	addi	sp,sp,80
    8000279a:	8082                	ret

000000008000279c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000279c:	7179                	addi	sp,sp,-48
    8000279e:	f406                	sd	ra,40(sp)
    800027a0:	f022                	sd	s0,32(sp)
    800027a2:	ec26                	sd	s1,24(sp)
    800027a4:	e84a                	sd	s2,16(sp)
    800027a6:	e44e                	sd	s3,8(sp)
    800027a8:	1800                	addi	s0,sp,48
    800027aa:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800027ac:	0000f497          	auipc	s1,0xf
    800027b0:	60448493          	addi	s1,s1,1540 # 80011db0 <proc>
    800027b4:	00015997          	auipc	s3,0x15
    800027b8:	5fc98993          	addi	s3,s3,1532 # 80017db0 <tickslock>
    acquire(&p->lock);
    800027bc:	8526                	mv	a0,s1
    800027be:	ffffe097          	auipc	ra,0xffffe
    800027c2:	43e080e7          	jalr	1086(ra) # 80000bfc <acquire>
    if(p->pid == pid){
    800027c6:	5c9c                	lw	a5,56(s1)
    800027c8:	01278d63          	beq	a5,s2,800027e2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800027cc:	8526                	mv	a0,s1
    800027ce:	ffffe097          	auipc	ra,0xffffe
    800027d2:	4e2080e7          	jalr	1250(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800027d6:	18048493          	addi	s1,s1,384
    800027da:	ff3491e3          	bne	s1,s3,800027bc <kill+0x20>
  }
  return -1;
    800027de:	557d                	li	a0,-1
    800027e0:	a821                	j	800027f8 <kill+0x5c>
      p->killed = 1;
    800027e2:	4785                	li	a5,1
    800027e4:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800027e6:	4c98                	lw	a4,24(s1)
    800027e8:	00f70f63          	beq	a4,a5,80002806 <kill+0x6a>
      release(&p->lock);
    800027ec:	8526                	mv	a0,s1
    800027ee:	ffffe097          	auipc	ra,0xffffe
    800027f2:	4c2080e7          	jalr	1218(ra) # 80000cb0 <release>
      return 0;
    800027f6:	4501                	li	a0,0
}
    800027f8:	70a2                	ld	ra,40(sp)
    800027fa:	7402                	ld	s0,32(sp)
    800027fc:	64e2                	ld	s1,24(sp)
    800027fe:	6942                	ld	s2,16(sp)
    80002800:	69a2                	ld	s3,8(sp)
    80002802:	6145                	addi	sp,sp,48
    80002804:	8082                	ret
        p->state = RUNNABLE;
    80002806:	4789                	li	a5,2
    80002808:	cc9c                	sw	a5,24(s1)
    8000280a:	b7cd                	j	800027ec <kill+0x50>

000000008000280c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000280c:	7179                	addi	sp,sp,-48
    8000280e:	f406                	sd	ra,40(sp)
    80002810:	f022                	sd	s0,32(sp)
    80002812:	ec26                	sd	s1,24(sp)
    80002814:	e84a                	sd	s2,16(sp)
    80002816:	e44e                	sd	s3,8(sp)
    80002818:	e052                	sd	s4,0(sp)
    8000281a:	1800                	addi	s0,sp,48
    8000281c:	84aa                	mv	s1,a0
    8000281e:	892e                	mv	s2,a1
    80002820:	89b2                	mv	s3,a2
    80002822:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002824:	fffff097          	auipc	ra,0xfffff
    80002828:	5b4080e7          	jalr	1460(ra) # 80001dd8 <myproc>
  if(user_dst){
    8000282c:	c08d                	beqz	s1,8000284e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000282e:	86d2                	mv	a3,s4
    80002830:	864e                	mv	a2,s3
    80002832:	85ca                	mv	a1,s2
    80002834:	6928                	ld	a0,80(a0)
    80002836:	fffff097          	auipc	ra,0xfffff
    8000283a:	e74080e7          	jalr	-396(ra) # 800016aa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000283e:	70a2                	ld	ra,40(sp)
    80002840:	7402                	ld	s0,32(sp)
    80002842:	64e2                	ld	s1,24(sp)
    80002844:	6942                	ld	s2,16(sp)
    80002846:	69a2                	ld	s3,8(sp)
    80002848:	6a02                	ld	s4,0(sp)
    8000284a:	6145                	addi	sp,sp,48
    8000284c:	8082                	ret
    memmove((char *)dst, src, len);
    8000284e:	000a061b          	sext.w	a2,s4
    80002852:	85ce                	mv	a1,s3
    80002854:	854a                	mv	a0,s2
    80002856:	ffffe097          	auipc	ra,0xffffe
    8000285a:	4fe080e7          	jalr	1278(ra) # 80000d54 <memmove>
    return 0;
    8000285e:	8526                	mv	a0,s1
    80002860:	bff9                	j	8000283e <either_copyout+0x32>

0000000080002862 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002862:	7179                	addi	sp,sp,-48
    80002864:	f406                	sd	ra,40(sp)
    80002866:	f022                	sd	s0,32(sp)
    80002868:	ec26                	sd	s1,24(sp)
    8000286a:	e84a                	sd	s2,16(sp)
    8000286c:	e44e                	sd	s3,8(sp)
    8000286e:	e052                	sd	s4,0(sp)
    80002870:	1800                	addi	s0,sp,48
    80002872:	892a                	mv	s2,a0
    80002874:	84ae                	mv	s1,a1
    80002876:	89b2                	mv	s3,a2
    80002878:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000287a:	fffff097          	auipc	ra,0xfffff
    8000287e:	55e080e7          	jalr	1374(ra) # 80001dd8 <myproc>
  if(user_src){
    80002882:	c08d                	beqz	s1,800028a4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002884:	86d2                	mv	a3,s4
    80002886:	864e                	mv	a2,s3
    80002888:	85ca                	mv	a1,s2
    8000288a:	6928                	ld	a0,80(a0)
    8000288c:	fffff097          	auipc	ra,0xfffff
    80002890:	eaa080e7          	jalr	-342(ra) # 80001736 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002894:	70a2                	ld	ra,40(sp)
    80002896:	7402                	ld	s0,32(sp)
    80002898:	64e2                	ld	s1,24(sp)
    8000289a:	6942                	ld	s2,16(sp)
    8000289c:	69a2                	ld	s3,8(sp)
    8000289e:	6a02                	ld	s4,0(sp)
    800028a0:	6145                	addi	sp,sp,48
    800028a2:	8082                	ret
    memmove(dst, (char*)src, len);
    800028a4:	000a061b          	sext.w	a2,s4
    800028a8:	85ce                	mv	a1,s3
    800028aa:	854a                	mv	a0,s2
    800028ac:	ffffe097          	auipc	ra,0xffffe
    800028b0:	4a8080e7          	jalr	1192(ra) # 80000d54 <memmove>
    return 0;
    800028b4:	8526                	mv	a0,s1
    800028b6:	bff9                	j	80002894 <either_copyin+0x32>

00000000800028b8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800028b8:	715d                	addi	sp,sp,-80
    800028ba:	e486                	sd	ra,72(sp)
    800028bc:	e0a2                	sd	s0,64(sp)
    800028be:	fc26                	sd	s1,56(sp)
    800028c0:	f84a                	sd	s2,48(sp)
    800028c2:	f44e                	sd	s3,40(sp)
    800028c4:	f052                	sd	s4,32(sp)
    800028c6:	ec56                	sd	s5,24(sp)
    800028c8:	e85a                	sd	s6,16(sp)
    800028ca:	e45e                	sd	s7,8(sp)
    800028cc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800028ce:	00006517          	auipc	a0,0x6
    800028d2:	98a50513          	addi	a0,a0,-1654 # 80008258 <digits+0x218>
    800028d6:	ffffe097          	auipc	ra,0xffffe
    800028da:	cb4080e7          	jalr	-844(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800028de:	0000f497          	auipc	s1,0xf
    800028e2:	62a48493          	addi	s1,s1,1578 # 80011f08 <proc+0x158>
    800028e6:	00015917          	auipc	s2,0x15
    800028ea:	62290913          	addi	s2,s2,1570 # 80017f08 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028ee:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800028f0:	00006997          	auipc	s3,0x6
    800028f4:	a5898993          	addi	s3,s3,-1448 # 80008348 <digits+0x308>
    printf("%d %s %s", p->pid, state, p->name);
    800028f8:	00006a97          	auipc	s5,0x6
    800028fc:	a58a8a93          	addi	s5,s5,-1448 # 80008350 <digits+0x310>
    printf("\n");
    80002900:	00006a17          	auipc	s4,0x6
    80002904:	958a0a13          	addi	s4,s4,-1704 # 80008258 <digits+0x218>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002908:	00006b97          	auipc	s7,0x6
    8000290c:	a80b8b93          	addi	s7,s7,-1408 # 80008388 <states.0>
    80002910:	a00d                	j	80002932 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002912:	ee06a583          	lw	a1,-288(a3)
    80002916:	8556                	mv	a0,s5
    80002918:	ffffe097          	auipc	ra,0xffffe
    8000291c:	c72080e7          	jalr	-910(ra) # 8000058a <printf>
    printf("\n");
    80002920:	8552                	mv	a0,s4
    80002922:	ffffe097          	auipc	ra,0xffffe
    80002926:	c68080e7          	jalr	-920(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000292a:	18048493          	addi	s1,s1,384
    8000292e:	03248263          	beq	s1,s2,80002952 <procdump+0x9a>
    if(p->state == UNUSED)
    80002932:	86a6                	mv	a3,s1
    80002934:	ec04a783          	lw	a5,-320(s1)
    80002938:	dbed                	beqz	a5,8000292a <procdump+0x72>
      state = "???";
    8000293a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000293c:	fcfb6be3          	bltu	s6,a5,80002912 <procdump+0x5a>
    80002940:	02079713          	slli	a4,a5,0x20
    80002944:	01d75793          	srli	a5,a4,0x1d
    80002948:	97de                	add	a5,a5,s7
    8000294a:	6390                	ld	a2,0(a5)
    8000294c:	f279                	bnez	a2,80002912 <procdump+0x5a>
      state = "???";
    8000294e:	864e                	mv	a2,s3
    80002950:	b7c9                	j	80002912 <procdump+0x5a>
  }
}
    80002952:	60a6                	ld	ra,72(sp)
    80002954:	6406                	ld	s0,64(sp)
    80002956:	74e2                	ld	s1,56(sp)
    80002958:	7942                	ld	s2,48(sp)
    8000295a:	79a2                	ld	s3,40(sp)
    8000295c:	7a02                	ld	s4,32(sp)
    8000295e:	6ae2                	ld	s5,24(sp)
    80002960:	6b42                	ld	s6,16(sp)
    80002962:	6ba2                	ld	s7,8(sp)
    80002964:	6161                	addi	sp,sp,80
    80002966:	8082                	ret

0000000080002968 <swtch>:
    80002968:	00153023          	sd	ra,0(a0)
    8000296c:	00253423          	sd	sp,8(a0)
    80002970:	e900                	sd	s0,16(a0)
    80002972:	ed04                	sd	s1,24(a0)
    80002974:	03253023          	sd	s2,32(a0)
    80002978:	03353423          	sd	s3,40(a0)
    8000297c:	03453823          	sd	s4,48(a0)
    80002980:	03553c23          	sd	s5,56(a0)
    80002984:	05653023          	sd	s6,64(a0)
    80002988:	05753423          	sd	s7,72(a0)
    8000298c:	05853823          	sd	s8,80(a0)
    80002990:	05953c23          	sd	s9,88(a0)
    80002994:	07a53023          	sd	s10,96(a0)
    80002998:	07b53423          	sd	s11,104(a0)
    8000299c:	0005b083          	ld	ra,0(a1)
    800029a0:	0085b103          	ld	sp,8(a1)
    800029a4:	6980                	ld	s0,16(a1)
    800029a6:	6d84                	ld	s1,24(a1)
    800029a8:	0205b903          	ld	s2,32(a1)
    800029ac:	0285b983          	ld	s3,40(a1)
    800029b0:	0305ba03          	ld	s4,48(a1)
    800029b4:	0385ba83          	ld	s5,56(a1)
    800029b8:	0405bb03          	ld	s6,64(a1)
    800029bc:	0485bb83          	ld	s7,72(a1)
    800029c0:	0505bc03          	ld	s8,80(a1)
    800029c4:	0585bc83          	ld	s9,88(a1)
    800029c8:	0605bd03          	ld	s10,96(a1)
    800029cc:	0685bd83          	ld	s11,104(a1)
    800029d0:	8082                	ret

00000000800029d2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800029d2:	1141                	addi	sp,sp,-16
    800029d4:	e406                	sd	ra,8(sp)
    800029d6:	e022                	sd	s0,0(sp)
    800029d8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800029da:	00006597          	auipc	a1,0x6
    800029de:	9d658593          	addi	a1,a1,-1578 # 800083b0 <states.0+0x28>
    800029e2:	00015517          	auipc	a0,0x15
    800029e6:	3ce50513          	addi	a0,a0,974 # 80017db0 <tickslock>
    800029ea:	ffffe097          	auipc	ra,0xffffe
    800029ee:	182080e7          	jalr	386(ra) # 80000b6c <initlock>
}
    800029f2:	60a2                	ld	ra,8(sp)
    800029f4:	6402                	ld	s0,0(sp)
    800029f6:	0141                	addi	sp,sp,16
    800029f8:	8082                	ret

00000000800029fa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800029fa:	1141                	addi	sp,sp,-16
    800029fc:	e422                	sd	s0,8(sp)
    800029fe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a00:	00003797          	auipc	a5,0x3
    80002a04:	50078793          	addi	a5,a5,1280 # 80005f00 <kernelvec>
    80002a08:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a0c:	6422                	ld	s0,8(sp)
    80002a0e:	0141                	addi	sp,sp,16
    80002a10:	8082                	ret

0000000080002a12 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002a12:	1141                	addi	sp,sp,-16
    80002a14:	e406                	sd	ra,8(sp)
    80002a16:	e022                	sd	s0,0(sp)
    80002a18:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002a1a:	fffff097          	auipc	ra,0xfffff
    80002a1e:	3be080e7          	jalr	958(ra) # 80001dd8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a28:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002a2c:	00004617          	auipc	a2,0x4
    80002a30:	5d460613          	addi	a2,a2,1492 # 80007000 <_trampoline>
    80002a34:	00004697          	auipc	a3,0x4
    80002a38:	5cc68693          	addi	a3,a3,1484 # 80007000 <_trampoline>
    80002a3c:	8e91                	sub	a3,a3,a2
    80002a3e:	040007b7          	lui	a5,0x4000
    80002a42:	17fd                	addi	a5,a5,-1
    80002a44:	07b2                	slli	a5,a5,0xc
    80002a46:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a48:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a4c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a4e:	180026f3          	csrr	a3,satp
    80002a52:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a54:	6d38                	ld	a4,88(a0)
    80002a56:	6134                	ld	a3,64(a0)
    80002a58:	6585                	lui	a1,0x1
    80002a5a:	96ae                	add	a3,a3,a1
    80002a5c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002a5e:	6d38                	ld	a4,88(a0)
    80002a60:	00000697          	auipc	a3,0x0
    80002a64:	13868693          	addi	a3,a3,312 # 80002b98 <usertrap>
    80002a68:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002a6a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002a6c:	8692                	mv	a3,tp
    80002a6e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a70:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002a74:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002a78:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a7c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002a80:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a82:	6f18                	ld	a4,24(a4)
    80002a84:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002a88:	692c                	ld	a1,80(a0)
    80002a8a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002a8c:	00004717          	auipc	a4,0x4
    80002a90:	60470713          	addi	a4,a4,1540 # 80007090 <userret>
    80002a94:	8f11                	sub	a4,a4,a2
    80002a96:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002a98:	577d                	li	a4,-1
    80002a9a:	177e                	slli	a4,a4,0x3f
    80002a9c:	8dd9                	or	a1,a1,a4
    80002a9e:	02000537          	lui	a0,0x2000
    80002aa2:	157d                	addi	a0,a0,-1
    80002aa4:	0536                	slli	a0,a0,0xd
    80002aa6:	9782                	jalr	a5
}
    80002aa8:	60a2                	ld	ra,8(sp)
    80002aaa:	6402                	ld	s0,0(sp)
    80002aac:	0141                	addi	sp,sp,16
    80002aae:	8082                	ret

0000000080002ab0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002ab0:	1101                	addi	sp,sp,-32
    80002ab2:	ec06                	sd	ra,24(sp)
    80002ab4:	e822                	sd	s0,16(sp)
    80002ab6:	e426                	sd	s1,8(sp)
    80002ab8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002aba:	00015497          	auipc	s1,0x15
    80002abe:	2f648493          	addi	s1,s1,758 # 80017db0 <tickslock>
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	ffffe097          	auipc	ra,0xffffe
    80002ac8:	138080e7          	jalr	312(ra) # 80000bfc <acquire>
  ticks++;
    80002acc:	00006517          	auipc	a0,0x6
    80002ad0:	55450513          	addi	a0,a0,1364 # 80009020 <ticks>
    80002ad4:	411c                	lw	a5,0(a0)
    80002ad6:	2785                	addiw	a5,a5,1
    80002ad8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	c0c080e7          	jalr	-1012(ra) # 800026e6 <wakeup>
  release(&tickslock);
    80002ae2:	8526                	mv	a0,s1
    80002ae4:	ffffe097          	auipc	ra,0xffffe
    80002ae8:	1cc080e7          	jalr	460(ra) # 80000cb0 <release>
}
    80002aec:	60e2                	ld	ra,24(sp)
    80002aee:	6442                	ld	s0,16(sp)
    80002af0:	64a2                	ld	s1,8(sp)
    80002af2:	6105                	addi	sp,sp,32
    80002af4:	8082                	ret

0000000080002af6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002af6:	1101                	addi	sp,sp,-32
    80002af8:	ec06                	sd	ra,24(sp)
    80002afa:	e822                	sd	s0,16(sp)
    80002afc:	e426                	sd	s1,8(sp)
    80002afe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b00:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002b04:	00074d63          	bltz	a4,80002b1e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002b08:	57fd                	li	a5,-1
    80002b0a:	17fe                	slli	a5,a5,0x3f
    80002b0c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002b0e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002b10:	06f70363          	beq	a4,a5,80002b76 <devintr+0x80>
  }
}
    80002b14:	60e2                	ld	ra,24(sp)
    80002b16:	6442                	ld	s0,16(sp)
    80002b18:	64a2                	ld	s1,8(sp)
    80002b1a:	6105                	addi	sp,sp,32
    80002b1c:	8082                	ret
     (scause & 0xff) == 9){
    80002b1e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002b22:	46a5                	li	a3,9
    80002b24:	fed792e3          	bne	a5,a3,80002b08 <devintr+0x12>
    int irq = plic_claim();
    80002b28:	00003097          	auipc	ra,0x3
    80002b2c:	4e0080e7          	jalr	1248(ra) # 80006008 <plic_claim>
    80002b30:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002b32:	47a9                	li	a5,10
    80002b34:	02f50763          	beq	a0,a5,80002b62 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002b38:	4785                	li	a5,1
    80002b3a:	02f50963          	beq	a0,a5,80002b6c <devintr+0x76>
    return 1;
    80002b3e:	4505                	li	a0,1
    } else if(irq){
    80002b40:	d8f1                	beqz	s1,80002b14 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002b42:	85a6                	mv	a1,s1
    80002b44:	00006517          	auipc	a0,0x6
    80002b48:	87450513          	addi	a0,a0,-1932 # 800083b8 <states.0+0x30>
    80002b4c:	ffffe097          	auipc	ra,0xffffe
    80002b50:	a3e080e7          	jalr	-1474(ra) # 8000058a <printf>
      plic_complete(irq);
    80002b54:	8526                	mv	a0,s1
    80002b56:	00003097          	auipc	ra,0x3
    80002b5a:	4d6080e7          	jalr	1238(ra) # 8000602c <plic_complete>
    return 1;
    80002b5e:	4505                	li	a0,1
    80002b60:	bf55                	j	80002b14 <devintr+0x1e>
      uartintr();
    80002b62:	ffffe097          	auipc	ra,0xffffe
    80002b66:	e5e080e7          	jalr	-418(ra) # 800009c0 <uartintr>
    80002b6a:	b7ed                	j	80002b54 <devintr+0x5e>
      virtio_disk_intr();
    80002b6c:	00004097          	auipc	ra,0x4
    80002b70:	93a080e7          	jalr	-1734(ra) # 800064a6 <virtio_disk_intr>
    80002b74:	b7c5                	j	80002b54 <devintr+0x5e>
    if(cpuid() == 0){
    80002b76:	fffff097          	auipc	ra,0xfffff
    80002b7a:	236080e7          	jalr	566(ra) # 80001dac <cpuid>
    80002b7e:	c901                	beqz	a0,80002b8e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002b80:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002b84:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002b86:	14479073          	csrw	sip,a5
    return 2;
    80002b8a:	4509                	li	a0,2
    80002b8c:	b761                	j	80002b14 <devintr+0x1e>
      clockintr();
    80002b8e:	00000097          	auipc	ra,0x0
    80002b92:	f22080e7          	jalr	-222(ra) # 80002ab0 <clockintr>
    80002b96:	b7ed                	j	80002b80 <devintr+0x8a>

0000000080002b98 <usertrap>:
{
    80002b98:	1101                	addi	sp,sp,-32
    80002b9a:	ec06                	sd	ra,24(sp)
    80002b9c:	e822                	sd	s0,16(sp)
    80002b9e:	e426                	sd	s1,8(sp)
    80002ba0:	e04a                	sd	s2,0(sp)
    80002ba2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ba4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002ba8:	1007f793          	andi	a5,a5,256
    80002bac:	e3ad                	bnez	a5,80002c0e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bae:	00003797          	auipc	a5,0x3
    80002bb2:	35278793          	addi	a5,a5,850 # 80005f00 <kernelvec>
    80002bb6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002bba:	fffff097          	auipc	ra,0xfffff
    80002bbe:	21e080e7          	jalr	542(ra) # 80001dd8 <myproc>
    80002bc2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002bc4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002bc6:	14102773          	csrr	a4,sepc
    80002bca:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002bcc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002bd0:	47a1                	li	a5,8
    80002bd2:	04f71c63          	bne	a4,a5,80002c2a <usertrap+0x92>
    if(p->killed)
    80002bd6:	591c                	lw	a5,48(a0)
    80002bd8:	e3b9                	bnez	a5,80002c1e <usertrap+0x86>
    p->trapframe->epc += 4;
    80002bda:	6cb8                	ld	a4,88(s1)
    80002bdc:	6f1c                	ld	a5,24(a4)
    80002bde:	0791                	addi	a5,a5,4
    80002be0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002be2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002be6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bea:	10079073          	csrw	sstatus,a5
    syscall();
    80002bee:	00000097          	auipc	ra,0x0
    80002bf2:	2e0080e7          	jalr	736(ra) # 80002ece <syscall>
  if(p->killed)
    80002bf6:	589c                	lw	a5,48(s1)
    80002bf8:	ebc1                	bnez	a5,80002c88 <usertrap+0xf0>
  usertrapret();
    80002bfa:	00000097          	auipc	ra,0x0
    80002bfe:	e18080e7          	jalr	-488(ra) # 80002a12 <usertrapret>
}
    80002c02:	60e2                	ld	ra,24(sp)
    80002c04:	6442                	ld	s0,16(sp)
    80002c06:	64a2                	ld	s1,8(sp)
    80002c08:	6902                	ld	s2,0(sp)
    80002c0a:	6105                	addi	sp,sp,32
    80002c0c:	8082                	ret
    panic("usertrap: not from user mode");
    80002c0e:	00005517          	auipc	a0,0x5
    80002c12:	7ca50513          	addi	a0,a0,1994 # 800083d8 <states.0+0x50>
    80002c16:	ffffe097          	auipc	ra,0xffffe
    80002c1a:	92a080e7          	jalr	-1750(ra) # 80000540 <panic>
      exit(-1);
    80002c1e:	557d                	li	a0,-1
    80002c20:	00000097          	auipc	ra,0x0
    80002c24:	800080e7          	jalr	-2048(ra) # 80002420 <exit>
    80002c28:	bf4d                	j	80002bda <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002c2a:	00000097          	auipc	ra,0x0
    80002c2e:	ecc080e7          	jalr	-308(ra) # 80002af6 <devintr>
    80002c32:	892a                	mv	s2,a0
    80002c34:	c501                	beqz	a0,80002c3c <usertrap+0xa4>
  if(p->killed)
    80002c36:	589c                	lw	a5,48(s1)
    80002c38:	c3a1                	beqz	a5,80002c78 <usertrap+0xe0>
    80002c3a:	a815                	j	80002c6e <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c3c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002c40:	5c90                	lw	a2,56(s1)
    80002c42:	00005517          	auipc	a0,0x5
    80002c46:	7b650513          	addi	a0,a0,1974 # 800083f8 <states.0+0x70>
    80002c4a:	ffffe097          	auipc	ra,0xffffe
    80002c4e:	940080e7          	jalr	-1728(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c52:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c56:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c5a:	00005517          	auipc	a0,0x5
    80002c5e:	7ce50513          	addi	a0,a0,1998 # 80008428 <states.0+0xa0>
    80002c62:	ffffe097          	auipc	ra,0xffffe
    80002c66:	928080e7          	jalr	-1752(ra) # 8000058a <printf>
    p->killed = 1;
    80002c6a:	4785                	li	a5,1
    80002c6c:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002c6e:	557d                	li	a0,-1
    80002c70:	fffff097          	auipc	ra,0xfffff
    80002c74:	7b0080e7          	jalr	1968(ra) # 80002420 <exit>
  if(which_dev == 2)
    80002c78:	4789                	li	a5,2
    80002c7a:	f8f910e3          	bne	s2,a5,80002bfa <usertrap+0x62>
    yield();
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	8ac080e7          	jalr	-1876(ra) # 8000252a <yield>
    80002c86:	bf95                	j	80002bfa <usertrap+0x62>
  int which_dev = 0;
    80002c88:	4901                	li	s2,0
    80002c8a:	b7d5                	j	80002c6e <usertrap+0xd6>

0000000080002c8c <kerneltrap>:
{
    80002c8c:	7179                	addi	sp,sp,-48
    80002c8e:	f406                	sd	ra,40(sp)
    80002c90:	f022                	sd	s0,32(sp)
    80002c92:	ec26                	sd	s1,24(sp)
    80002c94:	e84a                	sd	s2,16(sp)
    80002c96:	e44e                	sd	s3,8(sp)
    80002c98:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c9a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c9e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ca2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ca6:	1004f793          	andi	a5,s1,256
    80002caa:	cb85                	beqz	a5,80002cda <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002cb0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002cb2:	ef85                	bnez	a5,80002cea <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002cb4:	00000097          	auipc	ra,0x0
    80002cb8:	e42080e7          	jalr	-446(ra) # 80002af6 <devintr>
    80002cbc:	cd1d                	beqz	a0,80002cfa <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002cbe:	4789                	li	a5,2
    80002cc0:	06f50a63          	beq	a0,a5,80002d34 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cc4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cc8:	10049073          	csrw	sstatus,s1
}
    80002ccc:	70a2                	ld	ra,40(sp)
    80002cce:	7402                	ld	s0,32(sp)
    80002cd0:	64e2                	ld	s1,24(sp)
    80002cd2:	6942                	ld	s2,16(sp)
    80002cd4:	69a2                	ld	s3,8(sp)
    80002cd6:	6145                	addi	sp,sp,48
    80002cd8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002cda:	00005517          	auipc	a0,0x5
    80002cde:	76e50513          	addi	a0,a0,1902 # 80008448 <states.0+0xc0>
    80002ce2:	ffffe097          	auipc	ra,0xffffe
    80002ce6:	85e080e7          	jalr	-1954(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    80002cea:	00005517          	auipc	a0,0x5
    80002cee:	78650513          	addi	a0,a0,1926 # 80008470 <states.0+0xe8>
    80002cf2:	ffffe097          	auipc	ra,0xffffe
    80002cf6:	84e080e7          	jalr	-1970(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    80002cfa:	85ce                	mv	a1,s3
    80002cfc:	00005517          	auipc	a0,0x5
    80002d00:	79450513          	addi	a0,a0,1940 # 80008490 <states.0+0x108>
    80002d04:	ffffe097          	auipc	ra,0xffffe
    80002d08:	886080e7          	jalr	-1914(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d0c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d10:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d14:	00005517          	auipc	a0,0x5
    80002d18:	78c50513          	addi	a0,a0,1932 # 800084a0 <states.0+0x118>
    80002d1c:	ffffe097          	auipc	ra,0xffffe
    80002d20:	86e080e7          	jalr	-1938(ra) # 8000058a <printf>
    panic("kerneltrap");
    80002d24:	00005517          	auipc	a0,0x5
    80002d28:	79450513          	addi	a0,a0,1940 # 800084b8 <states.0+0x130>
    80002d2c:	ffffe097          	auipc	ra,0xffffe
    80002d30:	814080e7          	jalr	-2028(ra) # 80000540 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d34:	fffff097          	auipc	ra,0xfffff
    80002d38:	0a4080e7          	jalr	164(ra) # 80001dd8 <myproc>
    80002d3c:	d541                	beqz	a0,80002cc4 <kerneltrap+0x38>
    80002d3e:	fffff097          	auipc	ra,0xfffff
    80002d42:	09a080e7          	jalr	154(ra) # 80001dd8 <myproc>
    80002d46:	4d18                	lw	a4,24(a0)
    80002d48:	478d                	li	a5,3
    80002d4a:	f6f71de3          	bne	a4,a5,80002cc4 <kerneltrap+0x38>
    yield();
    80002d4e:	fffff097          	auipc	ra,0xfffff
    80002d52:	7dc080e7          	jalr	2012(ra) # 8000252a <yield>
    80002d56:	b7bd                	j	80002cc4 <kerneltrap+0x38>

0000000080002d58 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d58:	1101                	addi	sp,sp,-32
    80002d5a:	ec06                	sd	ra,24(sp)
    80002d5c:	e822                	sd	s0,16(sp)
    80002d5e:	e426                	sd	s1,8(sp)
    80002d60:	1000                	addi	s0,sp,32
    80002d62:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	074080e7          	jalr	116(ra) # 80001dd8 <myproc>
  switch (n) {
    80002d6c:	4795                	li	a5,5
    80002d6e:	0497e163          	bltu	a5,s1,80002db0 <argraw+0x58>
    80002d72:	048a                	slli	s1,s1,0x2
    80002d74:	00005717          	auipc	a4,0x5
    80002d78:	77c70713          	addi	a4,a4,1916 # 800084f0 <states.0+0x168>
    80002d7c:	94ba                	add	s1,s1,a4
    80002d7e:	409c                	lw	a5,0(s1)
    80002d80:	97ba                	add	a5,a5,a4
    80002d82:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002d84:	6d3c                	ld	a5,88(a0)
    80002d86:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002d88:	60e2                	ld	ra,24(sp)
    80002d8a:	6442                	ld	s0,16(sp)
    80002d8c:	64a2                	ld	s1,8(sp)
    80002d8e:	6105                	addi	sp,sp,32
    80002d90:	8082                	ret
    return p->trapframe->a1;
    80002d92:	6d3c                	ld	a5,88(a0)
    80002d94:	7fa8                	ld	a0,120(a5)
    80002d96:	bfcd                	j	80002d88 <argraw+0x30>
    return p->trapframe->a2;
    80002d98:	6d3c                	ld	a5,88(a0)
    80002d9a:	63c8                	ld	a0,128(a5)
    80002d9c:	b7f5                	j	80002d88 <argraw+0x30>
    return p->trapframe->a3;
    80002d9e:	6d3c                	ld	a5,88(a0)
    80002da0:	67c8                	ld	a0,136(a5)
    80002da2:	b7dd                	j	80002d88 <argraw+0x30>
    return p->trapframe->a4;
    80002da4:	6d3c                	ld	a5,88(a0)
    80002da6:	6bc8                	ld	a0,144(a5)
    80002da8:	b7c5                	j	80002d88 <argraw+0x30>
    return p->trapframe->a5;
    80002daa:	6d3c                	ld	a5,88(a0)
    80002dac:	6fc8                	ld	a0,152(a5)
    80002dae:	bfe9                	j	80002d88 <argraw+0x30>
  panic("argraw");
    80002db0:	00005517          	auipc	a0,0x5
    80002db4:	71850513          	addi	a0,a0,1816 # 800084c8 <states.0+0x140>
    80002db8:	ffffd097          	auipc	ra,0xffffd
    80002dbc:	788080e7          	jalr	1928(ra) # 80000540 <panic>

0000000080002dc0 <fetchaddr>:
{
    80002dc0:	1101                	addi	sp,sp,-32
    80002dc2:	ec06                	sd	ra,24(sp)
    80002dc4:	e822                	sd	s0,16(sp)
    80002dc6:	e426                	sd	s1,8(sp)
    80002dc8:	e04a                	sd	s2,0(sp)
    80002dca:	1000                	addi	s0,sp,32
    80002dcc:	84aa                	mv	s1,a0
    80002dce:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002dd0:	fffff097          	auipc	ra,0xfffff
    80002dd4:	008080e7          	jalr	8(ra) # 80001dd8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002dd8:	653c                	ld	a5,72(a0)
    80002dda:	02f4f863          	bgeu	s1,a5,80002e0a <fetchaddr+0x4a>
    80002dde:	00848713          	addi	a4,s1,8
    80002de2:	02e7e663          	bltu	a5,a4,80002e0e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002de6:	46a1                	li	a3,8
    80002de8:	8626                	mv	a2,s1
    80002dea:	85ca                	mv	a1,s2
    80002dec:	6928                	ld	a0,80(a0)
    80002dee:	fffff097          	auipc	ra,0xfffff
    80002df2:	948080e7          	jalr	-1720(ra) # 80001736 <copyin>
    80002df6:	00a03533          	snez	a0,a0
    80002dfa:	40a00533          	neg	a0,a0
}
    80002dfe:	60e2                	ld	ra,24(sp)
    80002e00:	6442                	ld	s0,16(sp)
    80002e02:	64a2                	ld	s1,8(sp)
    80002e04:	6902                	ld	s2,0(sp)
    80002e06:	6105                	addi	sp,sp,32
    80002e08:	8082                	ret
    return -1;
    80002e0a:	557d                	li	a0,-1
    80002e0c:	bfcd                	j	80002dfe <fetchaddr+0x3e>
    80002e0e:	557d                	li	a0,-1
    80002e10:	b7fd                	j	80002dfe <fetchaddr+0x3e>

0000000080002e12 <fetchstr>:
{
    80002e12:	7179                	addi	sp,sp,-48
    80002e14:	f406                	sd	ra,40(sp)
    80002e16:	f022                	sd	s0,32(sp)
    80002e18:	ec26                	sd	s1,24(sp)
    80002e1a:	e84a                	sd	s2,16(sp)
    80002e1c:	e44e                	sd	s3,8(sp)
    80002e1e:	1800                	addi	s0,sp,48
    80002e20:	892a                	mv	s2,a0
    80002e22:	84ae                	mv	s1,a1
    80002e24:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002e26:	fffff097          	auipc	ra,0xfffff
    80002e2a:	fb2080e7          	jalr	-78(ra) # 80001dd8 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002e2e:	86ce                	mv	a3,s3
    80002e30:	864a                	mv	a2,s2
    80002e32:	85a6                	mv	a1,s1
    80002e34:	6928                	ld	a0,80(a0)
    80002e36:	fffff097          	auipc	ra,0xfffff
    80002e3a:	98e080e7          	jalr	-1650(ra) # 800017c4 <copyinstr>
  if(err < 0)
    80002e3e:	00054763          	bltz	a0,80002e4c <fetchstr+0x3a>
  return strlen(buf);
    80002e42:	8526                	mv	a0,s1
    80002e44:	ffffe097          	auipc	ra,0xffffe
    80002e48:	038080e7          	jalr	56(ra) # 80000e7c <strlen>
}
    80002e4c:	70a2                	ld	ra,40(sp)
    80002e4e:	7402                	ld	s0,32(sp)
    80002e50:	64e2                	ld	s1,24(sp)
    80002e52:	6942                	ld	s2,16(sp)
    80002e54:	69a2                	ld	s3,8(sp)
    80002e56:	6145                	addi	sp,sp,48
    80002e58:	8082                	ret

0000000080002e5a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002e5a:	1101                	addi	sp,sp,-32
    80002e5c:	ec06                	sd	ra,24(sp)
    80002e5e:	e822                	sd	s0,16(sp)
    80002e60:	e426                	sd	s1,8(sp)
    80002e62:	1000                	addi	s0,sp,32
    80002e64:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e66:	00000097          	auipc	ra,0x0
    80002e6a:	ef2080e7          	jalr	-270(ra) # 80002d58 <argraw>
    80002e6e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002e70:	4501                	li	a0,0
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6105                	addi	sp,sp,32
    80002e7a:	8082                	ret

0000000080002e7c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002e7c:	1101                	addi	sp,sp,-32
    80002e7e:	ec06                	sd	ra,24(sp)
    80002e80:	e822                	sd	s0,16(sp)
    80002e82:	e426                	sd	s1,8(sp)
    80002e84:	1000                	addi	s0,sp,32
    80002e86:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e88:	00000097          	auipc	ra,0x0
    80002e8c:	ed0080e7          	jalr	-304(ra) # 80002d58 <argraw>
    80002e90:	e088                	sd	a0,0(s1)
  return 0;
}
    80002e92:	4501                	li	a0,0
    80002e94:	60e2                	ld	ra,24(sp)
    80002e96:	6442                	ld	s0,16(sp)
    80002e98:	64a2                	ld	s1,8(sp)
    80002e9a:	6105                	addi	sp,sp,32
    80002e9c:	8082                	ret

0000000080002e9e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002e9e:	1101                	addi	sp,sp,-32
    80002ea0:	ec06                	sd	ra,24(sp)
    80002ea2:	e822                	sd	s0,16(sp)
    80002ea4:	e426                	sd	s1,8(sp)
    80002ea6:	e04a                	sd	s2,0(sp)
    80002ea8:	1000                	addi	s0,sp,32
    80002eaa:	84ae                	mv	s1,a1
    80002eac:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	eaa080e7          	jalr	-342(ra) # 80002d58 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002eb6:	864a                	mv	a2,s2
    80002eb8:	85a6                	mv	a1,s1
    80002eba:	00000097          	auipc	ra,0x0
    80002ebe:	f58080e7          	jalr	-168(ra) # 80002e12 <fetchstr>
}
    80002ec2:	60e2                	ld	ra,24(sp)
    80002ec4:	6442                	ld	s0,16(sp)
    80002ec6:	64a2                	ld	s1,8(sp)
    80002ec8:	6902                	ld	s2,0(sp)
    80002eca:	6105                	addi	sp,sp,32
    80002ecc:	8082                	ret

0000000080002ece <syscall>:

#endif

void
syscall(void)
{
    80002ece:	1101                	addi	sp,sp,-32
    80002ed0:	ec06                	sd	ra,24(sp)
    80002ed2:	e822                	sd	s0,16(sp)
    80002ed4:	e426                	sd	s1,8(sp)
    80002ed6:	e04a                	sd	s2,0(sp)
    80002ed8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	efe080e7          	jalr	-258(ra) # 80001dd8 <myproc>
    80002ee2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ee4:	05853903          	ld	s2,88(a0)
    80002ee8:	0a893783          	ld	a5,168(s2)
    80002eec:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002ef0:	37fd                	addiw	a5,a5,-1
    80002ef2:	4751                	li	a4,20
    80002ef4:	00f76f63          	bltu	a4,a5,80002f12 <syscall+0x44>
    80002ef8:	00369713          	slli	a4,a3,0x3
    80002efc:	00005797          	auipc	a5,0x5
    80002f00:	60c78793          	addi	a5,a5,1548 # 80008508 <syscalls>
    80002f04:	97ba                	add	a5,a5,a4
    80002f06:	639c                	ld	a5,0(a5)
    80002f08:	c789                	beqz	a5,80002f12 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002f0a:	9782                	jalr	a5
    80002f0c:	06a93823          	sd	a0,112(s2)
    80002f10:	a839                	j	80002f2e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002f12:	15848613          	addi	a2,s1,344
    80002f16:	5c8c                	lw	a1,56(s1)
    80002f18:	00005517          	auipc	a0,0x5
    80002f1c:	5b850513          	addi	a0,a0,1464 # 800084d0 <states.0+0x148>
    80002f20:	ffffd097          	auipc	ra,0xffffd
    80002f24:	66a080e7          	jalr	1642(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002f28:	6cbc                	ld	a5,88(s1)
    80002f2a:	577d                	li	a4,-1
    80002f2c:	fbb8                	sd	a4,112(a5)
  }
#ifdef SUKJOON
  acquire(&p->lock);
    80002f2e:	8526                	mv	a0,s1
    80002f30:	ffffe097          	auipc	ra,0xffffe
    80002f34:	ccc080e7          	jalr	-820(ra) # 80000bfc <acquire>
  if (is_q1(p)) { remove(&q1, p); enqueue(&q2, p); }
    80002f38:	8526                	mv	a0,s1
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	9d8080e7          	jalr	-1576(ra) # 80001912 <is_q1>
    80002f42:	ed01                	bnez	a0,80002f5a <syscall+0x8c>
  release(&p->lock);
    80002f44:	8526                	mv	a0,s1
    80002f46:	ffffe097          	auipc	ra,0xffffe
    80002f4a:	d6a080e7          	jalr	-662(ra) # 80000cb0 <release>
#endif
}
    80002f4e:	60e2                	ld	ra,24(sp)
    80002f50:	6442                	ld	s0,16(sp)
    80002f52:	64a2                	ld	s1,8(sp)
    80002f54:	6902                	ld	s2,0(sp)
    80002f56:	6105                	addi	sp,sp,32
    80002f58:	8082                	ret
  if (is_q1(p)) { remove(&q1, p); enqueue(&q2, p); }
    80002f5a:	85a6                	mv	a1,s1
    80002f5c:	0000f517          	auipc	a0,0xf
    80002f60:	a0c50513          	addi	a0,a0,-1524 # 80011968 <q1>
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	ad6080e7          	jalr	-1322(ra) # 80001a3a <remove>
    80002f6c:	85a6                	mv	a1,s1
    80002f6e:	0000f517          	auipc	a0,0xf
    80002f72:	9e250513          	addi	a0,a0,-1566 # 80011950 <q2>
    80002f76:	fffff097          	auipc	ra,0xfffff
    80002f7a:	a3e080e7          	jalr	-1474(ra) # 800019b4 <enqueue>
    80002f7e:	b7d9                	j	80002f44 <syscall+0x76>

0000000080002f80 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002f80:	1101                	addi	sp,sp,-32
    80002f82:	ec06                	sd	ra,24(sp)
    80002f84:	e822                	sd	s0,16(sp)
    80002f86:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002f88:	fec40593          	addi	a1,s0,-20
    80002f8c:	4501                	li	a0,0
    80002f8e:	00000097          	auipc	ra,0x0
    80002f92:	ecc080e7          	jalr	-308(ra) # 80002e5a <argint>
    return -1;
    80002f96:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002f98:	00054963          	bltz	a0,80002faa <sys_exit+0x2a>
  exit(n);
    80002f9c:	fec42503          	lw	a0,-20(s0)
    80002fa0:	fffff097          	auipc	ra,0xfffff
    80002fa4:	480080e7          	jalr	1152(ra) # 80002420 <exit>
  return 0;  // not reached
    80002fa8:	4781                	li	a5,0
}
    80002faa:	853e                	mv	a0,a5
    80002fac:	60e2                	ld	ra,24(sp)
    80002fae:	6442                	ld	s0,16(sp)
    80002fb0:	6105                	addi	sp,sp,32
    80002fb2:	8082                	ret

0000000080002fb4 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002fb4:	1141                	addi	sp,sp,-16
    80002fb6:	e406                	sd	ra,8(sp)
    80002fb8:	e022                	sd	s0,0(sp)
    80002fba:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002fbc:	fffff097          	auipc	ra,0xfffff
    80002fc0:	e1c080e7          	jalr	-484(ra) # 80001dd8 <myproc>
}
    80002fc4:	5d08                	lw	a0,56(a0)
    80002fc6:	60a2                	ld	ra,8(sp)
    80002fc8:	6402                	ld	s0,0(sp)
    80002fca:	0141                	addi	sp,sp,16
    80002fcc:	8082                	ret

0000000080002fce <sys_fork>:

uint64
sys_fork(void)
{
    80002fce:	1141                	addi	sp,sp,-16
    80002fd0:	e406                	sd	ra,8(sp)
    80002fd2:	e022                	sd	s0,0(sp)
    80002fd4:	0800                	addi	s0,sp,16
  return fork();
    80002fd6:	fffff097          	auipc	ra,0xfffff
    80002fda:	1f0080e7          	jalr	496(ra) # 800021c6 <fork>
}
    80002fde:	60a2                	ld	ra,8(sp)
    80002fe0:	6402                	ld	s0,0(sp)
    80002fe2:	0141                	addi	sp,sp,16
    80002fe4:	8082                	ret

0000000080002fe6 <sys_wait>:

uint64
sys_wait(void)
{
    80002fe6:	1101                	addi	sp,sp,-32
    80002fe8:	ec06                	sd	ra,24(sp)
    80002fea:	e822                	sd	s0,16(sp)
    80002fec:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002fee:	fe840593          	addi	a1,s0,-24
    80002ff2:	4501                	li	a0,0
    80002ff4:	00000097          	auipc	ra,0x0
    80002ff8:	e88080e7          	jalr	-376(ra) # 80002e7c <argaddr>
    80002ffc:	87aa                	mv	a5,a0
    return -1;
    80002ffe:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003000:	0007c863          	bltz	a5,80003010 <sys_wait+0x2a>
  return wait(p);
    80003004:	fe843503          	ld	a0,-24(s0)
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	5dc080e7          	jalr	1500(ra) # 800025e4 <wait>
}
    80003010:	60e2                	ld	ra,24(sp)
    80003012:	6442                	ld	s0,16(sp)
    80003014:	6105                	addi	sp,sp,32
    80003016:	8082                	ret

0000000080003018 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003018:	7179                	addi	sp,sp,-48
    8000301a:	f406                	sd	ra,40(sp)
    8000301c:	f022                	sd	s0,32(sp)
    8000301e:	ec26                	sd	s1,24(sp)
    80003020:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003022:	fdc40593          	addi	a1,s0,-36
    80003026:	4501                	li	a0,0
    80003028:	00000097          	auipc	ra,0x0
    8000302c:	e32080e7          	jalr	-462(ra) # 80002e5a <argint>
    return -1;
    80003030:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80003032:	00054f63          	bltz	a0,80003050 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	da2080e7          	jalr	-606(ra) # 80001dd8 <myproc>
    8000303e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80003040:	fdc42503          	lw	a0,-36(s0)
    80003044:	fffff097          	auipc	ra,0xfffff
    80003048:	10e080e7          	jalr	270(ra) # 80002152 <growproc>
    8000304c:	00054863          	bltz	a0,8000305c <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80003050:	8526                	mv	a0,s1
    80003052:	70a2                	ld	ra,40(sp)
    80003054:	7402                	ld	s0,32(sp)
    80003056:	64e2                	ld	s1,24(sp)
    80003058:	6145                	addi	sp,sp,48
    8000305a:	8082                	ret
    return -1;
    8000305c:	54fd                	li	s1,-1
    8000305e:	bfcd                	j	80003050 <sys_sbrk+0x38>

0000000080003060 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003060:	7139                	addi	sp,sp,-64
    80003062:	fc06                	sd	ra,56(sp)
    80003064:	f822                	sd	s0,48(sp)
    80003066:	f426                	sd	s1,40(sp)
    80003068:	f04a                	sd	s2,32(sp)
    8000306a:	ec4e                	sd	s3,24(sp)
    8000306c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000306e:	fcc40593          	addi	a1,s0,-52
    80003072:	4501                	li	a0,0
    80003074:	00000097          	auipc	ra,0x0
    80003078:	de6080e7          	jalr	-538(ra) # 80002e5a <argint>
    return -1;
    8000307c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000307e:	06054563          	bltz	a0,800030e8 <sys_sleep+0x88>
  acquire(&tickslock);
    80003082:	00015517          	auipc	a0,0x15
    80003086:	d2e50513          	addi	a0,a0,-722 # 80017db0 <tickslock>
    8000308a:	ffffe097          	auipc	ra,0xffffe
    8000308e:	b72080e7          	jalr	-1166(ra) # 80000bfc <acquire>
  ticks0 = ticks;
    80003092:	00006917          	auipc	s2,0x6
    80003096:	f8e92903          	lw	s2,-114(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    8000309a:	fcc42783          	lw	a5,-52(s0)
    8000309e:	cf85                	beqz	a5,800030d6 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800030a0:	00015997          	auipc	s3,0x15
    800030a4:	d1098993          	addi	s3,s3,-752 # 80017db0 <tickslock>
    800030a8:	00006497          	auipc	s1,0x6
    800030ac:	f7848493          	addi	s1,s1,-136 # 80009020 <ticks>
    if(myproc()->killed){
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	d28080e7          	jalr	-728(ra) # 80001dd8 <myproc>
    800030b8:	591c                	lw	a5,48(a0)
    800030ba:	ef9d                	bnez	a5,800030f8 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800030bc:	85ce                	mv	a1,s3
    800030be:	8526                	mv	a0,s1
    800030c0:	fffff097          	auipc	ra,0xfffff
    800030c4:	4a6080e7          	jalr	1190(ra) # 80002566 <sleep>
  while(ticks - ticks0 < n){
    800030c8:	409c                	lw	a5,0(s1)
    800030ca:	412787bb          	subw	a5,a5,s2
    800030ce:	fcc42703          	lw	a4,-52(s0)
    800030d2:	fce7efe3          	bltu	a5,a4,800030b0 <sys_sleep+0x50>
  }
  release(&tickslock);
    800030d6:	00015517          	auipc	a0,0x15
    800030da:	cda50513          	addi	a0,a0,-806 # 80017db0 <tickslock>
    800030de:	ffffe097          	auipc	ra,0xffffe
    800030e2:	bd2080e7          	jalr	-1070(ra) # 80000cb0 <release>
  return 0;
    800030e6:	4781                	li	a5,0
}
    800030e8:	853e                	mv	a0,a5
    800030ea:	70e2                	ld	ra,56(sp)
    800030ec:	7442                	ld	s0,48(sp)
    800030ee:	74a2                	ld	s1,40(sp)
    800030f0:	7902                	ld	s2,32(sp)
    800030f2:	69e2                	ld	s3,24(sp)
    800030f4:	6121                	addi	sp,sp,64
    800030f6:	8082                	ret
      release(&tickslock);
    800030f8:	00015517          	auipc	a0,0x15
    800030fc:	cb850513          	addi	a0,a0,-840 # 80017db0 <tickslock>
    80003100:	ffffe097          	auipc	ra,0xffffe
    80003104:	bb0080e7          	jalr	-1104(ra) # 80000cb0 <release>
      return -1;
    80003108:	57fd                	li	a5,-1
    8000310a:	bff9                	j	800030e8 <sys_sleep+0x88>

000000008000310c <sys_kill>:

uint64
sys_kill(void)
{
    8000310c:	1101                	addi	sp,sp,-32
    8000310e:	ec06                	sd	ra,24(sp)
    80003110:	e822                	sd	s0,16(sp)
    80003112:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003114:	fec40593          	addi	a1,s0,-20
    80003118:	4501                	li	a0,0
    8000311a:	00000097          	auipc	ra,0x0
    8000311e:	d40080e7          	jalr	-704(ra) # 80002e5a <argint>
    80003122:	87aa                	mv	a5,a0
    return -1;
    80003124:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80003126:	0007c863          	bltz	a5,80003136 <sys_kill+0x2a>
  return kill(pid);
    8000312a:	fec42503          	lw	a0,-20(s0)
    8000312e:	fffff097          	auipc	ra,0xfffff
    80003132:	66e080e7          	jalr	1646(ra) # 8000279c <kill>
}
    80003136:	60e2                	ld	ra,24(sp)
    80003138:	6442                	ld	s0,16(sp)
    8000313a:	6105                	addi	sp,sp,32
    8000313c:	8082                	ret

000000008000313e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000313e:	1101                	addi	sp,sp,-32
    80003140:	ec06                	sd	ra,24(sp)
    80003142:	e822                	sd	s0,16(sp)
    80003144:	e426                	sd	s1,8(sp)
    80003146:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003148:	00015517          	auipc	a0,0x15
    8000314c:	c6850513          	addi	a0,a0,-920 # 80017db0 <tickslock>
    80003150:	ffffe097          	auipc	ra,0xffffe
    80003154:	aac080e7          	jalr	-1364(ra) # 80000bfc <acquire>
  xticks = ticks;
    80003158:	00006497          	auipc	s1,0x6
    8000315c:	ec84a483          	lw	s1,-312(s1) # 80009020 <ticks>
  release(&tickslock);
    80003160:	00015517          	auipc	a0,0x15
    80003164:	c5050513          	addi	a0,a0,-944 # 80017db0 <tickslock>
    80003168:	ffffe097          	auipc	ra,0xffffe
    8000316c:	b48080e7          	jalr	-1208(ra) # 80000cb0 <release>
  return xticks;
}
    80003170:	02049513          	slli	a0,s1,0x20
    80003174:	9101                	srli	a0,a0,0x20
    80003176:	60e2                	ld	ra,24(sp)
    80003178:	6442                	ld	s0,16(sp)
    8000317a:	64a2                	ld	s1,8(sp)
    8000317c:	6105                	addi	sp,sp,32
    8000317e:	8082                	ret

0000000080003180 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003180:	7179                	addi	sp,sp,-48
    80003182:	f406                	sd	ra,40(sp)
    80003184:	f022                	sd	s0,32(sp)
    80003186:	ec26                	sd	s1,24(sp)
    80003188:	e84a                	sd	s2,16(sp)
    8000318a:	e44e                	sd	s3,8(sp)
    8000318c:	e052                	sd	s4,0(sp)
    8000318e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003190:	00005597          	auipc	a1,0x5
    80003194:	42858593          	addi	a1,a1,1064 # 800085b8 <syscalls+0xb0>
    80003198:	00015517          	auipc	a0,0x15
    8000319c:	c3050513          	addi	a0,a0,-976 # 80017dc8 <bcache>
    800031a0:	ffffe097          	auipc	ra,0xffffe
    800031a4:	9cc080e7          	jalr	-1588(ra) # 80000b6c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800031a8:	0001d797          	auipc	a5,0x1d
    800031ac:	c2078793          	addi	a5,a5,-992 # 8001fdc8 <bcache+0x8000>
    800031b0:	0001d717          	auipc	a4,0x1d
    800031b4:	e8070713          	addi	a4,a4,-384 # 80020030 <bcache+0x8268>
    800031b8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800031bc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800031c0:	00015497          	auipc	s1,0x15
    800031c4:	c2048493          	addi	s1,s1,-992 # 80017de0 <bcache+0x18>
    b->next = bcache.head.next;
    800031c8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800031ca:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800031cc:	00005a17          	auipc	s4,0x5
    800031d0:	3f4a0a13          	addi	s4,s4,1012 # 800085c0 <syscalls+0xb8>
    b->next = bcache.head.next;
    800031d4:	2b893783          	ld	a5,696(s2)
    800031d8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800031da:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800031de:	85d2                	mv	a1,s4
    800031e0:	01048513          	addi	a0,s1,16
    800031e4:	00001097          	auipc	ra,0x1
    800031e8:	4b2080e7          	jalr	1202(ra) # 80004696 <initsleeplock>
    bcache.head.next->prev = b;
    800031ec:	2b893783          	ld	a5,696(s2)
    800031f0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800031f2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800031f6:	45848493          	addi	s1,s1,1112
    800031fa:	fd349de3          	bne	s1,s3,800031d4 <binit+0x54>
  }
}
    800031fe:	70a2                	ld	ra,40(sp)
    80003200:	7402                	ld	s0,32(sp)
    80003202:	64e2                	ld	s1,24(sp)
    80003204:	6942                	ld	s2,16(sp)
    80003206:	69a2                	ld	s3,8(sp)
    80003208:	6a02                	ld	s4,0(sp)
    8000320a:	6145                	addi	sp,sp,48
    8000320c:	8082                	ret

000000008000320e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000320e:	7179                	addi	sp,sp,-48
    80003210:	f406                	sd	ra,40(sp)
    80003212:	f022                	sd	s0,32(sp)
    80003214:	ec26                	sd	s1,24(sp)
    80003216:	e84a                	sd	s2,16(sp)
    80003218:	e44e                	sd	s3,8(sp)
    8000321a:	1800                	addi	s0,sp,48
    8000321c:	892a                	mv	s2,a0
    8000321e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003220:	00015517          	auipc	a0,0x15
    80003224:	ba850513          	addi	a0,a0,-1112 # 80017dc8 <bcache>
    80003228:	ffffe097          	auipc	ra,0xffffe
    8000322c:	9d4080e7          	jalr	-1580(ra) # 80000bfc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003230:	0001d497          	auipc	s1,0x1d
    80003234:	e504b483          	ld	s1,-432(s1) # 80020080 <bcache+0x82b8>
    80003238:	0001d797          	auipc	a5,0x1d
    8000323c:	df878793          	addi	a5,a5,-520 # 80020030 <bcache+0x8268>
    80003240:	02f48f63          	beq	s1,a5,8000327e <bread+0x70>
    80003244:	873e                	mv	a4,a5
    80003246:	a021                	j	8000324e <bread+0x40>
    80003248:	68a4                	ld	s1,80(s1)
    8000324a:	02e48a63          	beq	s1,a4,8000327e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000324e:	449c                	lw	a5,8(s1)
    80003250:	ff279ce3          	bne	a5,s2,80003248 <bread+0x3a>
    80003254:	44dc                	lw	a5,12(s1)
    80003256:	ff3799e3          	bne	a5,s3,80003248 <bread+0x3a>
      b->refcnt++;
    8000325a:	40bc                	lw	a5,64(s1)
    8000325c:	2785                	addiw	a5,a5,1
    8000325e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003260:	00015517          	auipc	a0,0x15
    80003264:	b6850513          	addi	a0,a0,-1176 # 80017dc8 <bcache>
    80003268:	ffffe097          	auipc	ra,0xffffe
    8000326c:	a48080e7          	jalr	-1464(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    80003270:	01048513          	addi	a0,s1,16
    80003274:	00001097          	auipc	ra,0x1
    80003278:	45c080e7          	jalr	1116(ra) # 800046d0 <acquiresleep>
      return b;
    8000327c:	a8b9                	j	800032da <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000327e:	0001d497          	auipc	s1,0x1d
    80003282:	dfa4b483          	ld	s1,-518(s1) # 80020078 <bcache+0x82b0>
    80003286:	0001d797          	auipc	a5,0x1d
    8000328a:	daa78793          	addi	a5,a5,-598 # 80020030 <bcache+0x8268>
    8000328e:	00f48863          	beq	s1,a5,8000329e <bread+0x90>
    80003292:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003294:	40bc                	lw	a5,64(s1)
    80003296:	cf81                	beqz	a5,800032ae <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003298:	64a4                	ld	s1,72(s1)
    8000329a:	fee49de3          	bne	s1,a4,80003294 <bread+0x86>
  panic("bget: no buffers");
    8000329e:	00005517          	auipc	a0,0x5
    800032a2:	32a50513          	addi	a0,a0,810 # 800085c8 <syscalls+0xc0>
    800032a6:	ffffd097          	auipc	ra,0xffffd
    800032aa:	29a080e7          	jalr	666(ra) # 80000540 <panic>
      b->dev = dev;
    800032ae:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800032b2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800032b6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800032ba:	4785                	li	a5,1
    800032bc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800032be:	00015517          	auipc	a0,0x15
    800032c2:	b0a50513          	addi	a0,a0,-1270 # 80017dc8 <bcache>
    800032c6:	ffffe097          	auipc	ra,0xffffe
    800032ca:	9ea080e7          	jalr	-1558(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    800032ce:	01048513          	addi	a0,s1,16
    800032d2:	00001097          	auipc	ra,0x1
    800032d6:	3fe080e7          	jalr	1022(ra) # 800046d0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800032da:	409c                	lw	a5,0(s1)
    800032dc:	cb89                	beqz	a5,800032ee <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800032de:	8526                	mv	a0,s1
    800032e0:	70a2                	ld	ra,40(sp)
    800032e2:	7402                	ld	s0,32(sp)
    800032e4:	64e2                	ld	s1,24(sp)
    800032e6:	6942                	ld	s2,16(sp)
    800032e8:	69a2                	ld	s3,8(sp)
    800032ea:	6145                	addi	sp,sp,48
    800032ec:	8082                	ret
    virtio_disk_rw(b, 0);
    800032ee:	4581                	li	a1,0
    800032f0:	8526                	mv	a0,s1
    800032f2:	00003097          	auipc	ra,0x3
    800032f6:	f2a080e7          	jalr	-214(ra) # 8000621c <virtio_disk_rw>
    b->valid = 1;
    800032fa:	4785                	li	a5,1
    800032fc:	c09c                	sw	a5,0(s1)
  return b;
    800032fe:	b7c5                	j	800032de <bread+0xd0>

0000000080003300 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003300:	1101                	addi	sp,sp,-32
    80003302:	ec06                	sd	ra,24(sp)
    80003304:	e822                	sd	s0,16(sp)
    80003306:	e426                	sd	s1,8(sp)
    80003308:	1000                	addi	s0,sp,32
    8000330a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000330c:	0541                	addi	a0,a0,16
    8000330e:	00001097          	auipc	ra,0x1
    80003312:	45c080e7          	jalr	1116(ra) # 8000476a <holdingsleep>
    80003316:	cd01                	beqz	a0,8000332e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003318:	4585                	li	a1,1
    8000331a:	8526                	mv	a0,s1
    8000331c:	00003097          	auipc	ra,0x3
    80003320:	f00080e7          	jalr	-256(ra) # 8000621c <virtio_disk_rw>
}
    80003324:	60e2                	ld	ra,24(sp)
    80003326:	6442                	ld	s0,16(sp)
    80003328:	64a2                	ld	s1,8(sp)
    8000332a:	6105                	addi	sp,sp,32
    8000332c:	8082                	ret
    panic("bwrite");
    8000332e:	00005517          	auipc	a0,0x5
    80003332:	2b250513          	addi	a0,a0,690 # 800085e0 <syscalls+0xd8>
    80003336:	ffffd097          	auipc	ra,0xffffd
    8000333a:	20a080e7          	jalr	522(ra) # 80000540 <panic>

000000008000333e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000333e:	1101                	addi	sp,sp,-32
    80003340:	ec06                	sd	ra,24(sp)
    80003342:	e822                	sd	s0,16(sp)
    80003344:	e426                	sd	s1,8(sp)
    80003346:	e04a                	sd	s2,0(sp)
    80003348:	1000                	addi	s0,sp,32
    8000334a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000334c:	01050913          	addi	s2,a0,16
    80003350:	854a                	mv	a0,s2
    80003352:	00001097          	auipc	ra,0x1
    80003356:	418080e7          	jalr	1048(ra) # 8000476a <holdingsleep>
    8000335a:	c92d                	beqz	a0,800033cc <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000335c:	854a                	mv	a0,s2
    8000335e:	00001097          	auipc	ra,0x1
    80003362:	3c8080e7          	jalr	968(ra) # 80004726 <releasesleep>

  acquire(&bcache.lock);
    80003366:	00015517          	auipc	a0,0x15
    8000336a:	a6250513          	addi	a0,a0,-1438 # 80017dc8 <bcache>
    8000336e:	ffffe097          	auipc	ra,0xffffe
    80003372:	88e080e7          	jalr	-1906(ra) # 80000bfc <acquire>
  b->refcnt--;
    80003376:	40bc                	lw	a5,64(s1)
    80003378:	37fd                	addiw	a5,a5,-1
    8000337a:	0007871b          	sext.w	a4,a5
    8000337e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003380:	eb05                	bnez	a4,800033b0 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003382:	68bc                	ld	a5,80(s1)
    80003384:	64b8                	ld	a4,72(s1)
    80003386:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003388:	64bc                	ld	a5,72(s1)
    8000338a:	68b8                	ld	a4,80(s1)
    8000338c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000338e:	0001d797          	auipc	a5,0x1d
    80003392:	a3a78793          	addi	a5,a5,-1478 # 8001fdc8 <bcache+0x8000>
    80003396:	2b87b703          	ld	a4,696(a5)
    8000339a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000339c:	0001d717          	auipc	a4,0x1d
    800033a0:	c9470713          	addi	a4,a4,-876 # 80020030 <bcache+0x8268>
    800033a4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800033a6:	2b87b703          	ld	a4,696(a5)
    800033aa:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800033ac:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800033b0:	00015517          	auipc	a0,0x15
    800033b4:	a1850513          	addi	a0,a0,-1512 # 80017dc8 <bcache>
    800033b8:	ffffe097          	auipc	ra,0xffffe
    800033bc:	8f8080e7          	jalr	-1800(ra) # 80000cb0 <release>
}
    800033c0:	60e2                	ld	ra,24(sp)
    800033c2:	6442                	ld	s0,16(sp)
    800033c4:	64a2                	ld	s1,8(sp)
    800033c6:	6902                	ld	s2,0(sp)
    800033c8:	6105                	addi	sp,sp,32
    800033ca:	8082                	ret
    panic("brelse");
    800033cc:	00005517          	auipc	a0,0x5
    800033d0:	21c50513          	addi	a0,a0,540 # 800085e8 <syscalls+0xe0>
    800033d4:	ffffd097          	auipc	ra,0xffffd
    800033d8:	16c080e7          	jalr	364(ra) # 80000540 <panic>

00000000800033dc <bpin>:

void
bpin(struct buf *b) {
    800033dc:	1101                	addi	sp,sp,-32
    800033de:	ec06                	sd	ra,24(sp)
    800033e0:	e822                	sd	s0,16(sp)
    800033e2:	e426                	sd	s1,8(sp)
    800033e4:	1000                	addi	s0,sp,32
    800033e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800033e8:	00015517          	auipc	a0,0x15
    800033ec:	9e050513          	addi	a0,a0,-1568 # 80017dc8 <bcache>
    800033f0:	ffffe097          	auipc	ra,0xffffe
    800033f4:	80c080e7          	jalr	-2036(ra) # 80000bfc <acquire>
  b->refcnt++;
    800033f8:	40bc                	lw	a5,64(s1)
    800033fa:	2785                	addiw	a5,a5,1
    800033fc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800033fe:	00015517          	auipc	a0,0x15
    80003402:	9ca50513          	addi	a0,a0,-1590 # 80017dc8 <bcache>
    80003406:	ffffe097          	auipc	ra,0xffffe
    8000340a:	8aa080e7          	jalr	-1878(ra) # 80000cb0 <release>
}
    8000340e:	60e2                	ld	ra,24(sp)
    80003410:	6442                	ld	s0,16(sp)
    80003412:	64a2                	ld	s1,8(sp)
    80003414:	6105                	addi	sp,sp,32
    80003416:	8082                	ret

0000000080003418 <bunpin>:

void
bunpin(struct buf *b) {
    80003418:	1101                	addi	sp,sp,-32
    8000341a:	ec06                	sd	ra,24(sp)
    8000341c:	e822                	sd	s0,16(sp)
    8000341e:	e426                	sd	s1,8(sp)
    80003420:	1000                	addi	s0,sp,32
    80003422:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003424:	00015517          	auipc	a0,0x15
    80003428:	9a450513          	addi	a0,a0,-1628 # 80017dc8 <bcache>
    8000342c:	ffffd097          	auipc	ra,0xffffd
    80003430:	7d0080e7          	jalr	2000(ra) # 80000bfc <acquire>
  b->refcnt--;
    80003434:	40bc                	lw	a5,64(s1)
    80003436:	37fd                	addiw	a5,a5,-1
    80003438:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000343a:	00015517          	auipc	a0,0x15
    8000343e:	98e50513          	addi	a0,a0,-1650 # 80017dc8 <bcache>
    80003442:	ffffe097          	auipc	ra,0xffffe
    80003446:	86e080e7          	jalr	-1938(ra) # 80000cb0 <release>
}
    8000344a:	60e2                	ld	ra,24(sp)
    8000344c:	6442                	ld	s0,16(sp)
    8000344e:	64a2                	ld	s1,8(sp)
    80003450:	6105                	addi	sp,sp,32
    80003452:	8082                	ret

0000000080003454 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003454:	1101                	addi	sp,sp,-32
    80003456:	ec06                	sd	ra,24(sp)
    80003458:	e822                	sd	s0,16(sp)
    8000345a:	e426                	sd	s1,8(sp)
    8000345c:	e04a                	sd	s2,0(sp)
    8000345e:	1000                	addi	s0,sp,32
    80003460:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003462:	00d5d59b          	srliw	a1,a1,0xd
    80003466:	0001d797          	auipc	a5,0x1d
    8000346a:	03e7a783          	lw	a5,62(a5) # 800204a4 <sb+0x1c>
    8000346e:	9dbd                	addw	a1,a1,a5
    80003470:	00000097          	auipc	ra,0x0
    80003474:	d9e080e7          	jalr	-610(ra) # 8000320e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003478:	0074f713          	andi	a4,s1,7
    8000347c:	4785                	li	a5,1
    8000347e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003482:	14ce                	slli	s1,s1,0x33
    80003484:	90d9                	srli	s1,s1,0x36
    80003486:	00950733          	add	a4,a0,s1
    8000348a:	05874703          	lbu	a4,88(a4)
    8000348e:	00e7f6b3          	and	a3,a5,a4
    80003492:	c69d                	beqz	a3,800034c0 <bfree+0x6c>
    80003494:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003496:	94aa                	add	s1,s1,a0
    80003498:	fff7c793          	not	a5,a5
    8000349c:	8ff9                	and	a5,a5,a4
    8000349e:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800034a2:	00001097          	auipc	ra,0x1
    800034a6:	106080e7          	jalr	262(ra) # 800045a8 <log_write>
  brelse(bp);
    800034aa:	854a                	mv	a0,s2
    800034ac:	00000097          	auipc	ra,0x0
    800034b0:	e92080e7          	jalr	-366(ra) # 8000333e <brelse>
}
    800034b4:	60e2                	ld	ra,24(sp)
    800034b6:	6442                	ld	s0,16(sp)
    800034b8:	64a2                	ld	s1,8(sp)
    800034ba:	6902                	ld	s2,0(sp)
    800034bc:	6105                	addi	sp,sp,32
    800034be:	8082                	ret
    panic("freeing free block");
    800034c0:	00005517          	auipc	a0,0x5
    800034c4:	13050513          	addi	a0,a0,304 # 800085f0 <syscalls+0xe8>
    800034c8:	ffffd097          	auipc	ra,0xffffd
    800034cc:	078080e7          	jalr	120(ra) # 80000540 <panic>

00000000800034d0 <balloc>:
{
    800034d0:	711d                	addi	sp,sp,-96
    800034d2:	ec86                	sd	ra,88(sp)
    800034d4:	e8a2                	sd	s0,80(sp)
    800034d6:	e4a6                	sd	s1,72(sp)
    800034d8:	e0ca                	sd	s2,64(sp)
    800034da:	fc4e                	sd	s3,56(sp)
    800034dc:	f852                	sd	s4,48(sp)
    800034de:	f456                	sd	s5,40(sp)
    800034e0:	f05a                	sd	s6,32(sp)
    800034e2:	ec5e                	sd	s7,24(sp)
    800034e4:	e862                	sd	s8,16(sp)
    800034e6:	e466                	sd	s9,8(sp)
    800034e8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800034ea:	0001d797          	auipc	a5,0x1d
    800034ee:	fa27a783          	lw	a5,-94(a5) # 8002048c <sb+0x4>
    800034f2:	cbd1                	beqz	a5,80003586 <balloc+0xb6>
    800034f4:	8baa                	mv	s7,a0
    800034f6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800034f8:	0001db17          	auipc	s6,0x1d
    800034fc:	f90b0b13          	addi	s6,s6,-112 # 80020488 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003500:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003502:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003504:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003506:	6c89                	lui	s9,0x2
    80003508:	a831                	j	80003524 <balloc+0x54>
    brelse(bp);
    8000350a:	854a                	mv	a0,s2
    8000350c:	00000097          	auipc	ra,0x0
    80003510:	e32080e7          	jalr	-462(ra) # 8000333e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003514:	015c87bb          	addw	a5,s9,s5
    80003518:	00078a9b          	sext.w	s5,a5
    8000351c:	004b2703          	lw	a4,4(s6)
    80003520:	06eaf363          	bgeu	s5,a4,80003586 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003524:	41fad79b          	sraiw	a5,s5,0x1f
    80003528:	0137d79b          	srliw	a5,a5,0x13
    8000352c:	015787bb          	addw	a5,a5,s5
    80003530:	40d7d79b          	sraiw	a5,a5,0xd
    80003534:	01cb2583          	lw	a1,28(s6)
    80003538:	9dbd                	addw	a1,a1,a5
    8000353a:	855e                	mv	a0,s7
    8000353c:	00000097          	auipc	ra,0x0
    80003540:	cd2080e7          	jalr	-814(ra) # 8000320e <bread>
    80003544:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003546:	004b2503          	lw	a0,4(s6)
    8000354a:	000a849b          	sext.w	s1,s5
    8000354e:	8662                	mv	a2,s8
    80003550:	faa4fde3          	bgeu	s1,a0,8000350a <balloc+0x3a>
      m = 1 << (bi % 8);
    80003554:	41f6579b          	sraiw	a5,a2,0x1f
    80003558:	01d7d69b          	srliw	a3,a5,0x1d
    8000355c:	00c6873b          	addw	a4,a3,a2
    80003560:	00777793          	andi	a5,a4,7
    80003564:	9f95                	subw	a5,a5,a3
    80003566:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000356a:	4037571b          	sraiw	a4,a4,0x3
    8000356e:	00e906b3          	add	a3,s2,a4
    80003572:	0586c683          	lbu	a3,88(a3)
    80003576:	00d7f5b3          	and	a1,a5,a3
    8000357a:	cd91                	beqz	a1,80003596 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000357c:	2605                	addiw	a2,a2,1
    8000357e:	2485                	addiw	s1,s1,1
    80003580:	fd4618e3          	bne	a2,s4,80003550 <balloc+0x80>
    80003584:	b759                	j	8000350a <balloc+0x3a>
  panic("balloc: out of blocks");
    80003586:	00005517          	auipc	a0,0x5
    8000358a:	08250513          	addi	a0,a0,130 # 80008608 <syscalls+0x100>
    8000358e:	ffffd097          	auipc	ra,0xffffd
    80003592:	fb2080e7          	jalr	-78(ra) # 80000540 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003596:	974a                	add	a4,a4,s2
    80003598:	8fd5                	or	a5,a5,a3
    8000359a:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000359e:	854a                	mv	a0,s2
    800035a0:	00001097          	auipc	ra,0x1
    800035a4:	008080e7          	jalr	8(ra) # 800045a8 <log_write>
        brelse(bp);
    800035a8:	854a                	mv	a0,s2
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	d94080e7          	jalr	-620(ra) # 8000333e <brelse>
  bp = bread(dev, bno);
    800035b2:	85a6                	mv	a1,s1
    800035b4:	855e                	mv	a0,s7
    800035b6:	00000097          	auipc	ra,0x0
    800035ba:	c58080e7          	jalr	-936(ra) # 8000320e <bread>
    800035be:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800035c0:	40000613          	li	a2,1024
    800035c4:	4581                	li	a1,0
    800035c6:	05850513          	addi	a0,a0,88
    800035ca:	ffffd097          	auipc	ra,0xffffd
    800035ce:	72e080e7          	jalr	1838(ra) # 80000cf8 <memset>
  log_write(bp);
    800035d2:	854a                	mv	a0,s2
    800035d4:	00001097          	auipc	ra,0x1
    800035d8:	fd4080e7          	jalr	-44(ra) # 800045a8 <log_write>
  brelse(bp);
    800035dc:	854a                	mv	a0,s2
    800035de:	00000097          	auipc	ra,0x0
    800035e2:	d60080e7          	jalr	-672(ra) # 8000333e <brelse>
}
    800035e6:	8526                	mv	a0,s1
    800035e8:	60e6                	ld	ra,88(sp)
    800035ea:	6446                	ld	s0,80(sp)
    800035ec:	64a6                	ld	s1,72(sp)
    800035ee:	6906                	ld	s2,64(sp)
    800035f0:	79e2                	ld	s3,56(sp)
    800035f2:	7a42                	ld	s4,48(sp)
    800035f4:	7aa2                	ld	s5,40(sp)
    800035f6:	7b02                	ld	s6,32(sp)
    800035f8:	6be2                	ld	s7,24(sp)
    800035fa:	6c42                	ld	s8,16(sp)
    800035fc:	6ca2                	ld	s9,8(sp)
    800035fe:	6125                	addi	sp,sp,96
    80003600:	8082                	ret

0000000080003602 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003602:	7179                	addi	sp,sp,-48
    80003604:	f406                	sd	ra,40(sp)
    80003606:	f022                	sd	s0,32(sp)
    80003608:	ec26                	sd	s1,24(sp)
    8000360a:	e84a                	sd	s2,16(sp)
    8000360c:	e44e                	sd	s3,8(sp)
    8000360e:	e052                	sd	s4,0(sp)
    80003610:	1800                	addi	s0,sp,48
    80003612:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003614:	47ad                	li	a5,11
    80003616:	04b7fe63          	bgeu	a5,a1,80003672 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000361a:	ff45849b          	addiw	s1,a1,-12
    8000361e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003622:	0ff00793          	li	a5,255
    80003626:	0ae7e463          	bltu	a5,a4,800036ce <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000362a:	08052583          	lw	a1,128(a0)
    8000362e:	c5b5                	beqz	a1,8000369a <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003630:	00092503          	lw	a0,0(s2)
    80003634:	00000097          	auipc	ra,0x0
    80003638:	bda080e7          	jalr	-1062(ra) # 8000320e <bread>
    8000363c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000363e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003642:	02049713          	slli	a4,s1,0x20
    80003646:	01e75593          	srli	a1,a4,0x1e
    8000364a:	00b784b3          	add	s1,a5,a1
    8000364e:	0004a983          	lw	s3,0(s1)
    80003652:	04098e63          	beqz	s3,800036ae <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003656:	8552                	mv	a0,s4
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	ce6080e7          	jalr	-794(ra) # 8000333e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003660:	854e                	mv	a0,s3
    80003662:	70a2                	ld	ra,40(sp)
    80003664:	7402                	ld	s0,32(sp)
    80003666:	64e2                	ld	s1,24(sp)
    80003668:	6942                	ld	s2,16(sp)
    8000366a:	69a2                	ld	s3,8(sp)
    8000366c:	6a02                	ld	s4,0(sp)
    8000366e:	6145                	addi	sp,sp,48
    80003670:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003672:	02059793          	slli	a5,a1,0x20
    80003676:	01e7d593          	srli	a1,a5,0x1e
    8000367a:	00b504b3          	add	s1,a0,a1
    8000367e:	0504a983          	lw	s3,80(s1)
    80003682:	fc099fe3          	bnez	s3,80003660 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003686:	4108                	lw	a0,0(a0)
    80003688:	00000097          	auipc	ra,0x0
    8000368c:	e48080e7          	jalr	-440(ra) # 800034d0 <balloc>
    80003690:	0005099b          	sext.w	s3,a0
    80003694:	0534a823          	sw	s3,80(s1)
    80003698:	b7e1                	j	80003660 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000369a:	4108                	lw	a0,0(a0)
    8000369c:	00000097          	auipc	ra,0x0
    800036a0:	e34080e7          	jalr	-460(ra) # 800034d0 <balloc>
    800036a4:	0005059b          	sext.w	a1,a0
    800036a8:	08b92023          	sw	a1,128(s2)
    800036ac:	b751                	j	80003630 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800036ae:	00092503          	lw	a0,0(s2)
    800036b2:	00000097          	auipc	ra,0x0
    800036b6:	e1e080e7          	jalr	-482(ra) # 800034d0 <balloc>
    800036ba:	0005099b          	sext.w	s3,a0
    800036be:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800036c2:	8552                	mv	a0,s4
    800036c4:	00001097          	auipc	ra,0x1
    800036c8:	ee4080e7          	jalr	-284(ra) # 800045a8 <log_write>
    800036cc:	b769                	j	80003656 <bmap+0x54>
  panic("bmap: out of range");
    800036ce:	00005517          	auipc	a0,0x5
    800036d2:	f5250513          	addi	a0,a0,-174 # 80008620 <syscalls+0x118>
    800036d6:	ffffd097          	auipc	ra,0xffffd
    800036da:	e6a080e7          	jalr	-406(ra) # 80000540 <panic>

00000000800036de <iget>:
{
    800036de:	7179                	addi	sp,sp,-48
    800036e0:	f406                	sd	ra,40(sp)
    800036e2:	f022                	sd	s0,32(sp)
    800036e4:	ec26                	sd	s1,24(sp)
    800036e6:	e84a                	sd	s2,16(sp)
    800036e8:	e44e                	sd	s3,8(sp)
    800036ea:	e052                	sd	s4,0(sp)
    800036ec:	1800                	addi	s0,sp,48
    800036ee:	89aa                	mv	s3,a0
    800036f0:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800036f2:	0001d517          	auipc	a0,0x1d
    800036f6:	db650513          	addi	a0,a0,-586 # 800204a8 <icache>
    800036fa:	ffffd097          	auipc	ra,0xffffd
    800036fe:	502080e7          	jalr	1282(ra) # 80000bfc <acquire>
  empty = 0;
    80003702:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003704:	0001d497          	auipc	s1,0x1d
    80003708:	dbc48493          	addi	s1,s1,-580 # 800204c0 <icache+0x18>
    8000370c:	0001f697          	auipc	a3,0x1f
    80003710:	84468693          	addi	a3,a3,-1980 # 80021f50 <log>
    80003714:	a039                	j	80003722 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003716:	02090b63          	beqz	s2,8000374c <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000371a:	08848493          	addi	s1,s1,136
    8000371e:	02d48a63          	beq	s1,a3,80003752 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003722:	449c                	lw	a5,8(s1)
    80003724:	fef059e3          	blez	a5,80003716 <iget+0x38>
    80003728:	4098                	lw	a4,0(s1)
    8000372a:	ff3716e3          	bne	a4,s3,80003716 <iget+0x38>
    8000372e:	40d8                	lw	a4,4(s1)
    80003730:	ff4713e3          	bne	a4,s4,80003716 <iget+0x38>
      ip->ref++;
    80003734:	2785                	addiw	a5,a5,1
    80003736:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003738:	0001d517          	auipc	a0,0x1d
    8000373c:	d7050513          	addi	a0,a0,-656 # 800204a8 <icache>
    80003740:	ffffd097          	auipc	ra,0xffffd
    80003744:	570080e7          	jalr	1392(ra) # 80000cb0 <release>
      return ip;
    80003748:	8926                	mv	s2,s1
    8000374a:	a03d                	j	80003778 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000374c:	f7f9                	bnez	a5,8000371a <iget+0x3c>
    8000374e:	8926                	mv	s2,s1
    80003750:	b7e9                	j	8000371a <iget+0x3c>
  if(empty == 0)
    80003752:	02090c63          	beqz	s2,8000378a <iget+0xac>
  ip->dev = dev;
    80003756:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000375a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000375e:	4785                	li	a5,1
    80003760:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003764:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003768:	0001d517          	auipc	a0,0x1d
    8000376c:	d4050513          	addi	a0,a0,-704 # 800204a8 <icache>
    80003770:	ffffd097          	auipc	ra,0xffffd
    80003774:	540080e7          	jalr	1344(ra) # 80000cb0 <release>
}
    80003778:	854a                	mv	a0,s2
    8000377a:	70a2                	ld	ra,40(sp)
    8000377c:	7402                	ld	s0,32(sp)
    8000377e:	64e2                	ld	s1,24(sp)
    80003780:	6942                	ld	s2,16(sp)
    80003782:	69a2                	ld	s3,8(sp)
    80003784:	6a02                	ld	s4,0(sp)
    80003786:	6145                	addi	sp,sp,48
    80003788:	8082                	ret
    panic("iget: no inodes");
    8000378a:	00005517          	auipc	a0,0x5
    8000378e:	eae50513          	addi	a0,a0,-338 # 80008638 <syscalls+0x130>
    80003792:	ffffd097          	auipc	ra,0xffffd
    80003796:	dae080e7          	jalr	-594(ra) # 80000540 <panic>

000000008000379a <fsinit>:
fsinit(int dev) {
    8000379a:	7179                	addi	sp,sp,-48
    8000379c:	f406                	sd	ra,40(sp)
    8000379e:	f022                	sd	s0,32(sp)
    800037a0:	ec26                	sd	s1,24(sp)
    800037a2:	e84a                	sd	s2,16(sp)
    800037a4:	e44e                	sd	s3,8(sp)
    800037a6:	1800                	addi	s0,sp,48
    800037a8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800037aa:	4585                	li	a1,1
    800037ac:	00000097          	auipc	ra,0x0
    800037b0:	a62080e7          	jalr	-1438(ra) # 8000320e <bread>
    800037b4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800037b6:	0001d997          	auipc	s3,0x1d
    800037ba:	cd298993          	addi	s3,s3,-814 # 80020488 <sb>
    800037be:	02000613          	li	a2,32
    800037c2:	05850593          	addi	a1,a0,88
    800037c6:	854e                	mv	a0,s3
    800037c8:	ffffd097          	auipc	ra,0xffffd
    800037cc:	58c080e7          	jalr	1420(ra) # 80000d54 <memmove>
  brelse(bp);
    800037d0:	8526                	mv	a0,s1
    800037d2:	00000097          	auipc	ra,0x0
    800037d6:	b6c080e7          	jalr	-1172(ra) # 8000333e <brelse>
  if(sb.magic != FSMAGIC)
    800037da:	0009a703          	lw	a4,0(s3)
    800037de:	102037b7          	lui	a5,0x10203
    800037e2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800037e6:	02f71263          	bne	a4,a5,8000380a <fsinit+0x70>
  initlog(dev, &sb);
    800037ea:	0001d597          	auipc	a1,0x1d
    800037ee:	c9e58593          	addi	a1,a1,-866 # 80020488 <sb>
    800037f2:	854a                	mv	a0,s2
    800037f4:	00001097          	auipc	ra,0x1
    800037f8:	b3a080e7          	jalr	-1222(ra) # 8000432e <initlog>
}
    800037fc:	70a2                	ld	ra,40(sp)
    800037fe:	7402                	ld	s0,32(sp)
    80003800:	64e2                	ld	s1,24(sp)
    80003802:	6942                	ld	s2,16(sp)
    80003804:	69a2                	ld	s3,8(sp)
    80003806:	6145                	addi	sp,sp,48
    80003808:	8082                	ret
    panic("invalid file system");
    8000380a:	00005517          	auipc	a0,0x5
    8000380e:	e3e50513          	addi	a0,a0,-450 # 80008648 <syscalls+0x140>
    80003812:	ffffd097          	auipc	ra,0xffffd
    80003816:	d2e080e7          	jalr	-722(ra) # 80000540 <panic>

000000008000381a <iinit>:
{
    8000381a:	7179                	addi	sp,sp,-48
    8000381c:	f406                	sd	ra,40(sp)
    8000381e:	f022                	sd	s0,32(sp)
    80003820:	ec26                	sd	s1,24(sp)
    80003822:	e84a                	sd	s2,16(sp)
    80003824:	e44e                	sd	s3,8(sp)
    80003826:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003828:	00005597          	auipc	a1,0x5
    8000382c:	e3858593          	addi	a1,a1,-456 # 80008660 <syscalls+0x158>
    80003830:	0001d517          	auipc	a0,0x1d
    80003834:	c7850513          	addi	a0,a0,-904 # 800204a8 <icache>
    80003838:	ffffd097          	auipc	ra,0xffffd
    8000383c:	334080e7          	jalr	820(ra) # 80000b6c <initlock>
  for(i = 0; i < NINODE; i++) {
    80003840:	0001d497          	auipc	s1,0x1d
    80003844:	c9048493          	addi	s1,s1,-880 # 800204d0 <icache+0x28>
    80003848:	0001e997          	auipc	s3,0x1e
    8000384c:	71898993          	addi	s3,s3,1816 # 80021f60 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003850:	00005917          	auipc	s2,0x5
    80003854:	e1890913          	addi	s2,s2,-488 # 80008668 <syscalls+0x160>
    80003858:	85ca                	mv	a1,s2
    8000385a:	8526                	mv	a0,s1
    8000385c:	00001097          	auipc	ra,0x1
    80003860:	e3a080e7          	jalr	-454(ra) # 80004696 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003864:	08848493          	addi	s1,s1,136
    80003868:	ff3498e3          	bne	s1,s3,80003858 <iinit+0x3e>
}
    8000386c:	70a2                	ld	ra,40(sp)
    8000386e:	7402                	ld	s0,32(sp)
    80003870:	64e2                	ld	s1,24(sp)
    80003872:	6942                	ld	s2,16(sp)
    80003874:	69a2                	ld	s3,8(sp)
    80003876:	6145                	addi	sp,sp,48
    80003878:	8082                	ret

000000008000387a <ialloc>:
{
    8000387a:	715d                	addi	sp,sp,-80
    8000387c:	e486                	sd	ra,72(sp)
    8000387e:	e0a2                	sd	s0,64(sp)
    80003880:	fc26                	sd	s1,56(sp)
    80003882:	f84a                	sd	s2,48(sp)
    80003884:	f44e                	sd	s3,40(sp)
    80003886:	f052                	sd	s4,32(sp)
    80003888:	ec56                	sd	s5,24(sp)
    8000388a:	e85a                	sd	s6,16(sp)
    8000388c:	e45e                	sd	s7,8(sp)
    8000388e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003890:	0001d717          	auipc	a4,0x1d
    80003894:	c0472703          	lw	a4,-1020(a4) # 80020494 <sb+0xc>
    80003898:	4785                	li	a5,1
    8000389a:	04e7fa63          	bgeu	a5,a4,800038ee <ialloc+0x74>
    8000389e:	8aaa                	mv	s5,a0
    800038a0:	8bae                	mv	s7,a1
    800038a2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800038a4:	0001da17          	auipc	s4,0x1d
    800038a8:	be4a0a13          	addi	s4,s4,-1052 # 80020488 <sb>
    800038ac:	00048b1b          	sext.w	s6,s1
    800038b0:	0044d793          	srli	a5,s1,0x4
    800038b4:	018a2583          	lw	a1,24(s4)
    800038b8:	9dbd                	addw	a1,a1,a5
    800038ba:	8556                	mv	a0,s5
    800038bc:	00000097          	auipc	ra,0x0
    800038c0:	952080e7          	jalr	-1710(ra) # 8000320e <bread>
    800038c4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800038c6:	05850993          	addi	s3,a0,88
    800038ca:	00f4f793          	andi	a5,s1,15
    800038ce:	079a                	slli	a5,a5,0x6
    800038d0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800038d2:	00099783          	lh	a5,0(s3)
    800038d6:	c785                	beqz	a5,800038fe <ialloc+0x84>
    brelse(bp);
    800038d8:	00000097          	auipc	ra,0x0
    800038dc:	a66080e7          	jalr	-1434(ra) # 8000333e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800038e0:	0485                	addi	s1,s1,1
    800038e2:	00ca2703          	lw	a4,12(s4)
    800038e6:	0004879b          	sext.w	a5,s1
    800038ea:	fce7e1e3          	bltu	a5,a4,800038ac <ialloc+0x32>
  panic("ialloc: no inodes");
    800038ee:	00005517          	auipc	a0,0x5
    800038f2:	d8250513          	addi	a0,a0,-638 # 80008670 <syscalls+0x168>
    800038f6:	ffffd097          	auipc	ra,0xffffd
    800038fa:	c4a080e7          	jalr	-950(ra) # 80000540 <panic>
      memset(dip, 0, sizeof(*dip));
    800038fe:	04000613          	li	a2,64
    80003902:	4581                	li	a1,0
    80003904:	854e                	mv	a0,s3
    80003906:	ffffd097          	auipc	ra,0xffffd
    8000390a:	3f2080e7          	jalr	1010(ra) # 80000cf8 <memset>
      dip->type = type;
    8000390e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003912:	854a                	mv	a0,s2
    80003914:	00001097          	auipc	ra,0x1
    80003918:	c94080e7          	jalr	-876(ra) # 800045a8 <log_write>
      brelse(bp);
    8000391c:	854a                	mv	a0,s2
    8000391e:	00000097          	auipc	ra,0x0
    80003922:	a20080e7          	jalr	-1504(ra) # 8000333e <brelse>
      return iget(dev, inum);
    80003926:	85da                	mv	a1,s6
    80003928:	8556                	mv	a0,s5
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	db4080e7          	jalr	-588(ra) # 800036de <iget>
}
    80003932:	60a6                	ld	ra,72(sp)
    80003934:	6406                	ld	s0,64(sp)
    80003936:	74e2                	ld	s1,56(sp)
    80003938:	7942                	ld	s2,48(sp)
    8000393a:	79a2                	ld	s3,40(sp)
    8000393c:	7a02                	ld	s4,32(sp)
    8000393e:	6ae2                	ld	s5,24(sp)
    80003940:	6b42                	ld	s6,16(sp)
    80003942:	6ba2                	ld	s7,8(sp)
    80003944:	6161                	addi	sp,sp,80
    80003946:	8082                	ret

0000000080003948 <iupdate>:
{
    80003948:	1101                	addi	sp,sp,-32
    8000394a:	ec06                	sd	ra,24(sp)
    8000394c:	e822                	sd	s0,16(sp)
    8000394e:	e426                	sd	s1,8(sp)
    80003950:	e04a                	sd	s2,0(sp)
    80003952:	1000                	addi	s0,sp,32
    80003954:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003956:	415c                	lw	a5,4(a0)
    80003958:	0047d79b          	srliw	a5,a5,0x4
    8000395c:	0001d597          	auipc	a1,0x1d
    80003960:	b445a583          	lw	a1,-1212(a1) # 800204a0 <sb+0x18>
    80003964:	9dbd                	addw	a1,a1,a5
    80003966:	4108                	lw	a0,0(a0)
    80003968:	00000097          	auipc	ra,0x0
    8000396c:	8a6080e7          	jalr	-1882(ra) # 8000320e <bread>
    80003970:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003972:	05850793          	addi	a5,a0,88
    80003976:	40c8                	lw	a0,4(s1)
    80003978:	893d                	andi	a0,a0,15
    8000397a:	051a                	slli	a0,a0,0x6
    8000397c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000397e:	04449703          	lh	a4,68(s1)
    80003982:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003986:	04649703          	lh	a4,70(s1)
    8000398a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000398e:	04849703          	lh	a4,72(s1)
    80003992:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003996:	04a49703          	lh	a4,74(s1)
    8000399a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000399e:	44f8                	lw	a4,76(s1)
    800039a0:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800039a2:	03400613          	li	a2,52
    800039a6:	05048593          	addi	a1,s1,80
    800039aa:	0531                	addi	a0,a0,12
    800039ac:	ffffd097          	auipc	ra,0xffffd
    800039b0:	3a8080e7          	jalr	936(ra) # 80000d54 <memmove>
  log_write(bp);
    800039b4:	854a                	mv	a0,s2
    800039b6:	00001097          	auipc	ra,0x1
    800039ba:	bf2080e7          	jalr	-1038(ra) # 800045a8 <log_write>
  brelse(bp);
    800039be:	854a                	mv	a0,s2
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	97e080e7          	jalr	-1666(ra) # 8000333e <brelse>
}
    800039c8:	60e2                	ld	ra,24(sp)
    800039ca:	6442                	ld	s0,16(sp)
    800039cc:	64a2                	ld	s1,8(sp)
    800039ce:	6902                	ld	s2,0(sp)
    800039d0:	6105                	addi	sp,sp,32
    800039d2:	8082                	ret

00000000800039d4 <idup>:
{
    800039d4:	1101                	addi	sp,sp,-32
    800039d6:	ec06                	sd	ra,24(sp)
    800039d8:	e822                	sd	s0,16(sp)
    800039da:	e426                	sd	s1,8(sp)
    800039dc:	1000                	addi	s0,sp,32
    800039de:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800039e0:	0001d517          	auipc	a0,0x1d
    800039e4:	ac850513          	addi	a0,a0,-1336 # 800204a8 <icache>
    800039e8:	ffffd097          	auipc	ra,0xffffd
    800039ec:	214080e7          	jalr	532(ra) # 80000bfc <acquire>
  ip->ref++;
    800039f0:	449c                	lw	a5,8(s1)
    800039f2:	2785                	addiw	a5,a5,1
    800039f4:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800039f6:	0001d517          	auipc	a0,0x1d
    800039fa:	ab250513          	addi	a0,a0,-1358 # 800204a8 <icache>
    800039fe:	ffffd097          	auipc	ra,0xffffd
    80003a02:	2b2080e7          	jalr	690(ra) # 80000cb0 <release>
}
    80003a06:	8526                	mv	a0,s1
    80003a08:	60e2                	ld	ra,24(sp)
    80003a0a:	6442                	ld	s0,16(sp)
    80003a0c:	64a2                	ld	s1,8(sp)
    80003a0e:	6105                	addi	sp,sp,32
    80003a10:	8082                	ret

0000000080003a12 <ilock>:
{
    80003a12:	1101                	addi	sp,sp,-32
    80003a14:	ec06                	sd	ra,24(sp)
    80003a16:	e822                	sd	s0,16(sp)
    80003a18:	e426                	sd	s1,8(sp)
    80003a1a:	e04a                	sd	s2,0(sp)
    80003a1c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003a1e:	c115                	beqz	a0,80003a42 <ilock+0x30>
    80003a20:	84aa                	mv	s1,a0
    80003a22:	451c                	lw	a5,8(a0)
    80003a24:	00f05f63          	blez	a5,80003a42 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003a28:	0541                	addi	a0,a0,16
    80003a2a:	00001097          	auipc	ra,0x1
    80003a2e:	ca6080e7          	jalr	-858(ra) # 800046d0 <acquiresleep>
  if(ip->valid == 0){
    80003a32:	40bc                	lw	a5,64(s1)
    80003a34:	cf99                	beqz	a5,80003a52 <ilock+0x40>
}
    80003a36:	60e2                	ld	ra,24(sp)
    80003a38:	6442                	ld	s0,16(sp)
    80003a3a:	64a2                	ld	s1,8(sp)
    80003a3c:	6902                	ld	s2,0(sp)
    80003a3e:	6105                	addi	sp,sp,32
    80003a40:	8082                	ret
    panic("ilock");
    80003a42:	00005517          	auipc	a0,0x5
    80003a46:	c4650513          	addi	a0,a0,-954 # 80008688 <syscalls+0x180>
    80003a4a:	ffffd097          	auipc	ra,0xffffd
    80003a4e:	af6080e7          	jalr	-1290(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a52:	40dc                	lw	a5,4(s1)
    80003a54:	0047d79b          	srliw	a5,a5,0x4
    80003a58:	0001d597          	auipc	a1,0x1d
    80003a5c:	a485a583          	lw	a1,-1464(a1) # 800204a0 <sb+0x18>
    80003a60:	9dbd                	addw	a1,a1,a5
    80003a62:	4088                	lw	a0,0(s1)
    80003a64:	fffff097          	auipc	ra,0xfffff
    80003a68:	7aa080e7          	jalr	1962(ra) # 8000320e <bread>
    80003a6c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a6e:	05850593          	addi	a1,a0,88
    80003a72:	40dc                	lw	a5,4(s1)
    80003a74:	8bbd                	andi	a5,a5,15
    80003a76:	079a                	slli	a5,a5,0x6
    80003a78:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003a7a:	00059783          	lh	a5,0(a1)
    80003a7e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003a82:	00259783          	lh	a5,2(a1)
    80003a86:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003a8a:	00459783          	lh	a5,4(a1)
    80003a8e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003a92:	00659783          	lh	a5,6(a1)
    80003a96:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003a9a:	459c                	lw	a5,8(a1)
    80003a9c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003a9e:	03400613          	li	a2,52
    80003aa2:	05b1                	addi	a1,a1,12
    80003aa4:	05048513          	addi	a0,s1,80
    80003aa8:	ffffd097          	auipc	ra,0xffffd
    80003aac:	2ac080e7          	jalr	684(ra) # 80000d54 <memmove>
    brelse(bp);
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	88c080e7          	jalr	-1908(ra) # 8000333e <brelse>
    ip->valid = 1;
    80003aba:	4785                	li	a5,1
    80003abc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003abe:	04449783          	lh	a5,68(s1)
    80003ac2:	fbb5                	bnez	a5,80003a36 <ilock+0x24>
      panic("ilock: no type");
    80003ac4:	00005517          	auipc	a0,0x5
    80003ac8:	bcc50513          	addi	a0,a0,-1076 # 80008690 <syscalls+0x188>
    80003acc:	ffffd097          	auipc	ra,0xffffd
    80003ad0:	a74080e7          	jalr	-1420(ra) # 80000540 <panic>

0000000080003ad4 <iunlock>:
{
    80003ad4:	1101                	addi	sp,sp,-32
    80003ad6:	ec06                	sd	ra,24(sp)
    80003ad8:	e822                	sd	s0,16(sp)
    80003ada:	e426                	sd	s1,8(sp)
    80003adc:	e04a                	sd	s2,0(sp)
    80003ade:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003ae0:	c905                	beqz	a0,80003b10 <iunlock+0x3c>
    80003ae2:	84aa                	mv	s1,a0
    80003ae4:	01050913          	addi	s2,a0,16
    80003ae8:	854a                	mv	a0,s2
    80003aea:	00001097          	auipc	ra,0x1
    80003aee:	c80080e7          	jalr	-896(ra) # 8000476a <holdingsleep>
    80003af2:	cd19                	beqz	a0,80003b10 <iunlock+0x3c>
    80003af4:	449c                	lw	a5,8(s1)
    80003af6:	00f05d63          	blez	a5,80003b10 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003afa:	854a                	mv	a0,s2
    80003afc:	00001097          	auipc	ra,0x1
    80003b00:	c2a080e7          	jalr	-982(ra) # 80004726 <releasesleep>
}
    80003b04:	60e2                	ld	ra,24(sp)
    80003b06:	6442                	ld	s0,16(sp)
    80003b08:	64a2                	ld	s1,8(sp)
    80003b0a:	6902                	ld	s2,0(sp)
    80003b0c:	6105                	addi	sp,sp,32
    80003b0e:	8082                	ret
    panic("iunlock");
    80003b10:	00005517          	auipc	a0,0x5
    80003b14:	b9050513          	addi	a0,a0,-1136 # 800086a0 <syscalls+0x198>
    80003b18:	ffffd097          	auipc	ra,0xffffd
    80003b1c:	a28080e7          	jalr	-1496(ra) # 80000540 <panic>

0000000080003b20 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003b20:	7179                	addi	sp,sp,-48
    80003b22:	f406                	sd	ra,40(sp)
    80003b24:	f022                	sd	s0,32(sp)
    80003b26:	ec26                	sd	s1,24(sp)
    80003b28:	e84a                	sd	s2,16(sp)
    80003b2a:	e44e                	sd	s3,8(sp)
    80003b2c:	e052                	sd	s4,0(sp)
    80003b2e:	1800                	addi	s0,sp,48
    80003b30:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003b32:	05050493          	addi	s1,a0,80
    80003b36:	08050913          	addi	s2,a0,128
    80003b3a:	a021                	j	80003b42 <itrunc+0x22>
    80003b3c:	0491                	addi	s1,s1,4
    80003b3e:	01248d63          	beq	s1,s2,80003b58 <itrunc+0x38>
    if(ip->addrs[i]){
    80003b42:	408c                	lw	a1,0(s1)
    80003b44:	dde5                	beqz	a1,80003b3c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003b46:	0009a503          	lw	a0,0(s3)
    80003b4a:	00000097          	auipc	ra,0x0
    80003b4e:	90a080e7          	jalr	-1782(ra) # 80003454 <bfree>
      ip->addrs[i] = 0;
    80003b52:	0004a023          	sw	zero,0(s1)
    80003b56:	b7dd                	j	80003b3c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003b58:	0809a583          	lw	a1,128(s3)
    80003b5c:	e185                	bnez	a1,80003b7c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003b5e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003b62:	854e                	mv	a0,s3
    80003b64:	00000097          	auipc	ra,0x0
    80003b68:	de4080e7          	jalr	-540(ra) # 80003948 <iupdate>
}
    80003b6c:	70a2                	ld	ra,40(sp)
    80003b6e:	7402                	ld	s0,32(sp)
    80003b70:	64e2                	ld	s1,24(sp)
    80003b72:	6942                	ld	s2,16(sp)
    80003b74:	69a2                	ld	s3,8(sp)
    80003b76:	6a02                	ld	s4,0(sp)
    80003b78:	6145                	addi	sp,sp,48
    80003b7a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003b7c:	0009a503          	lw	a0,0(s3)
    80003b80:	fffff097          	auipc	ra,0xfffff
    80003b84:	68e080e7          	jalr	1678(ra) # 8000320e <bread>
    80003b88:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003b8a:	05850493          	addi	s1,a0,88
    80003b8e:	45850913          	addi	s2,a0,1112
    80003b92:	a021                	j	80003b9a <itrunc+0x7a>
    80003b94:	0491                	addi	s1,s1,4
    80003b96:	01248b63          	beq	s1,s2,80003bac <itrunc+0x8c>
      if(a[j])
    80003b9a:	408c                	lw	a1,0(s1)
    80003b9c:	dde5                	beqz	a1,80003b94 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003b9e:	0009a503          	lw	a0,0(s3)
    80003ba2:	00000097          	auipc	ra,0x0
    80003ba6:	8b2080e7          	jalr	-1870(ra) # 80003454 <bfree>
    80003baa:	b7ed                	j	80003b94 <itrunc+0x74>
    brelse(bp);
    80003bac:	8552                	mv	a0,s4
    80003bae:	fffff097          	auipc	ra,0xfffff
    80003bb2:	790080e7          	jalr	1936(ra) # 8000333e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003bb6:	0809a583          	lw	a1,128(s3)
    80003bba:	0009a503          	lw	a0,0(s3)
    80003bbe:	00000097          	auipc	ra,0x0
    80003bc2:	896080e7          	jalr	-1898(ra) # 80003454 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003bc6:	0809a023          	sw	zero,128(s3)
    80003bca:	bf51                	j	80003b5e <itrunc+0x3e>

0000000080003bcc <iput>:
{
    80003bcc:	1101                	addi	sp,sp,-32
    80003bce:	ec06                	sd	ra,24(sp)
    80003bd0:	e822                	sd	s0,16(sp)
    80003bd2:	e426                	sd	s1,8(sp)
    80003bd4:	e04a                	sd	s2,0(sp)
    80003bd6:	1000                	addi	s0,sp,32
    80003bd8:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003bda:	0001d517          	auipc	a0,0x1d
    80003bde:	8ce50513          	addi	a0,a0,-1842 # 800204a8 <icache>
    80003be2:	ffffd097          	auipc	ra,0xffffd
    80003be6:	01a080e7          	jalr	26(ra) # 80000bfc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003bea:	4498                	lw	a4,8(s1)
    80003bec:	4785                	li	a5,1
    80003bee:	02f70363          	beq	a4,a5,80003c14 <iput+0x48>
  ip->ref--;
    80003bf2:	449c                	lw	a5,8(s1)
    80003bf4:	37fd                	addiw	a5,a5,-1
    80003bf6:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003bf8:	0001d517          	auipc	a0,0x1d
    80003bfc:	8b050513          	addi	a0,a0,-1872 # 800204a8 <icache>
    80003c00:	ffffd097          	auipc	ra,0xffffd
    80003c04:	0b0080e7          	jalr	176(ra) # 80000cb0 <release>
}
    80003c08:	60e2                	ld	ra,24(sp)
    80003c0a:	6442                	ld	s0,16(sp)
    80003c0c:	64a2                	ld	s1,8(sp)
    80003c0e:	6902                	ld	s2,0(sp)
    80003c10:	6105                	addi	sp,sp,32
    80003c12:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c14:	40bc                	lw	a5,64(s1)
    80003c16:	dff1                	beqz	a5,80003bf2 <iput+0x26>
    80003c18:	04a49783          	lh	a5,74(s1)
    80003c1c:	fbf9                	bnez	a5,80003bf2 <iput+0x26>
    acquiresleep(&ip->lock);
    80003c1e:	01048913          	addi	s2,s1,16
    80003c22:	854a                	mv	a0,s2
    80003c24:	00001097          	auipc	ra,0x1
    80003c28:	aac080e7          	jalr	-1364(ra) # 800046d0 <acquiresleep>
    release(&icache.lock);
    80003c2c:	0001d517          	auipc	a0,0x1d
    80003c30:	87c50513          	addi	a0,a0,-1924 # 800204a8 <icache>
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	07c080e7          	jalr	124(ra) # 80000cb0 <release>
    itrunc(ip);
    80003c3c:	8526                	mv	a0,s1
    80003c3e:	00000097          	auipc	ra,0x0
    80003c42:	ee2080e7          	jalr	-286(ra) # 80003b20 <itrunc>
    ip->type = 0;
    80003c46:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003c4a:	8526                	mv	a0,s1
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	cfc080e7          	jalr	-772(ra) # 80003948 <iupdate>
    ip->valid = 0;
    80003c54:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003c58:	854a                	mv	a0,s2
    80003c5a:	00001097          	auipc	ra,0x1
    80003c5e:	acc080e7          	jalr	-1332(ra) # 80004726 <releasesleep>
    acquire(&icache.lock);
    80003c62:	0001d517          	auipc	a0,0x1d
    80003c66:	84650513          	addi	a0,a0,-1978 # 800204a8 <icache>
    80003c6a:	ffffd097          	auipc	ra,0xffffd
    80003c6e:	f92080e7          	jalr	-110(ra) # 80000bfc <acquire>
    80003c72:	b741                	j	80003bf2 <iput+0x26>

0000000080003c74 <iunlockput>:
{
    80003c74:	1101                	addi	sp,sp,-32
    80003c76:	ec06                	sd	ra,24(sp)
    80003c78:	e822                	sd	s0,16(sp)
    80003c7a:	e426                	sd	s1,8(sp)
    80003c7c:	1000                	addi	s0,sp,32
    80003c7e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	e54080e7          	jalr	-428(ra) # 80003ad4 <iunlock>
  iput(ip);
    80003c88:	8526                	mv	a0,s1
    80003c8a:	00000097          	auipc	ra,0x0
    80003c8e:	f42080e7          	jalr	-190(ra) # 80003bcc <iput>
}
    80003c92:	60e2                	ld	ra,24(sp)
    80003c94:	6442                	ld	s0,16(sp)
    80003c96:	64a2                	ld	s1,8(sp)
    80003c98:	6105                	addi	sp,sp,32
    80003c9a:	8082                	ret

0000000080003c9c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003c9c:	1141                	addi	sp,sp,-16
    80003c9e:	e422                	sd	s0,8(sp)
    80003ca0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ca2:	411c                	lw	a5,0(a0)
    80003ca4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003ca6:	415c                	lw	a5,4(a0)
    80003ca8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003caa:	04451783          	lh	a5,68(a0)
    80003cae:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003cb2:	04a51783          	lh	a5,74(a0)
    80003cb6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003cba:	04c56783          	lwu	a5,76(a0)
    80003cbe:	e99c                	sd	a5,16(a1)
}
    80003cc0:	6422                	ld	s0,8(sp)
    80003cc2:	0141                	addi	sp,sp,16
    80003cc4:	8082                	ret

0000000080003cc6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003cc6:	457c                	lw	a5,76(a0)
    80003cc8:	0ed7e863          	bltu	a5,a3,80003db8 <readi+0xf2>
{
    80003ccc:	7159                	addi	sp,sp,-112
    80003cce:	f486                	sd	ra,104(sp)
    80003cd0:	f0a2                	sd	s0,96(sp)
    80003cd2:	eca6                	sd	s1,88(sp)
    80003cd4:	e8ca                	sd	s2,80(sp)
    80003cd6:	e4ce                	sd	s3,72(sp)
    80003cd8:	e0d2                	sd	s4,64(sp)
    80003cda:	fc56                	sd	s5,56(sp)
    80003cdc:	f85a                	sd	s6,48(sp)
    80003cde:	f45e                	sd	s7,40(sp)
    80003ce0:	f062                	sd	s8,32(sp)
    80003ce2:	ec66                	sd	s9,24(sp)
    80003ce4:	e86a                	sd	s10,16(sp)
    80003ce6:	e46e                	sd	s11,8(sp)
    80003ce8:	1880                	addi	s0,sp,112
    80003cea:	8baa                	mv	s7,a0
    80003cec:	8c2e                	mv	s8,a1
    80003cee:	8ab2                	mv	s5,a2
    80003cf0:	84b6                	mv	s1,a3
    80003cf2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003cf4:	9f35                	addw	a4,a4,a3
    return 0;
    80003cf6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003cf8:	08d76f63          	bltu	a4,a3,80003d96 <readi+0xd0>
  if(off + n > ip->size)
    80003cfc:	00e7f463          	bgeu	a5,a4,80003d04 <readi+0x3e>
    n = ip->size - off;
    80003d00:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d04:	0a0b0863          	beqz	s6,80003db4 <readi+0xee>
    80003d08:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d0a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003d0e:	5cfd                	li	s9,-1
    80003d10:	a82d                	j	80003d4a <readi+0x84>
    80003d12:	020a1d93          	slli	s11,s4,0x20
    80003d16:	020ddd93          	srli	s11,s11,0x20
    80003d1a:	05890793          	addi	a5,s2,88
    80003d1e:	86ee                	mv	a3,s11
    80003d20:	963e                	add	a2,a2,a5
    80003d22:	85d6                	mv	a1,s5
    80003d24:	8562                	mv	a0,s8
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	ae6080e7          	jalr	-1306(ra) # 8000280c <either_copyout>
    80003d2e:	05950d63          	beq	a0,s9,80003d88 <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003d32:	854a                	mv	a0,s2
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	60a080e7          	jalr	1546(ra) # 8000333e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d3c:	013a09bb          	addw	s3,s4,s3
    80003d40:	009a04bb          	addw	s1,s4,s1
    80003d44:	9aee                	add	s5,s5,s11
    80003d46:	0569f663          	bgeu	s3,s6,80003d92 <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003d4a:	000ba903          	lw	s2,0(s7)
    80003d4e:	00a4d59b          	srliw	a1,s1,0xa
    80003d52:	855e                	mv	a0,s7
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	8ae080e7          	jalr	-1874(ra) # 80003602 <bmap>
    80003d5c:	0005059b          	sext.w	a1,a0
    80003d60:	854a                	mv	a0,s2
    80003d62:	fffff097          	auipc	ra,0xfffff
    80003d66:	4ac080e7          	jalr	1196(ra) # 8000320e <bread>
    80003d6a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d6c:	3ff4f613          	andi	a2,s1,1023
    80003d70:	40cd07bb          	subw	a5,s10,a2
    80003d74:	413b073b          	subw	a4,s6,s3
    80003d78:	8a3e                	mv	s4,a5
    80003d7a:	2781                	sext.w	a5,a5
    80003d7c:	0007069b          	sext.w	a3,a4
    80003d80:	f8f6f9e3          	bgeu	a3,a5,80003d12 <readi+0x4c>
    80003d84:	8a3a                	mv	s4,a4
    80003d86:	b771                	j	80003d12 <readi+0x4c>
      brelse(bp);
    80003d88:	854a                	mv	a0,s2
    80003d8a:	fffff097          	auipc	ra,0xfffff
    80003d8e:	5b4080e7          	jalr	1460(ra) # 8000333e <brelse>
  }
  return tot;
    80003d92:	0009851b          	sext.w	a0,s3
}
    80003d96:	70a6                	ld	ra,104(sp)
    80003d98:	7406                	ld	s0,96(sp)
    80003d9a:	64e6                	ld	s1,88(sp)
    80003d9c:	6946                	ld	s2,80(sp)
    80003d9e:	69a6                	ld	s3,72(sp)
    80003da0:	6a06                	ld	s4,64(sp)
    80003da2:	7ae2                	ld	s5,56(sp)
    80003da4:	7b42                	ld	s6,48(sp)
    80003da6:	7ba2                	ld	s7,40(sp)
    80003da8:	7c02                	ld	s8,32(sp)
    80003daa:	6ce2                	ld	s9,24(sp)
    80003dac:	6d42                	ld	s10,16(sp)
    80003dae:	6da2                	ld	s11,8(sp)
    80003db0:	6165                	addi	sp,sp,112
    80003db2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003db4:	89da                	mv	s3,s6
    80003db6:	bff1                	j	80003d92 <readi+0xcc>
    return 0;
    80003db8:	4501                	li	a0,0
}
    80003dba:	8082                	ret

0000000080003dbc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003dbc:	457c                	lw	a5,76(a0)
    80003dbe:	10d7e663          	bltu	a5,a3,80003eca <writei+0x10e>
{
    80003dc2:	7159                	addi	sp,sp,-112
    80003dc4:	f486                	sd	ra,104(sp)
    80003dc6:	f0a2                	sd	s0,96(sp)
    80003dc8:	eca6                	sd	s1,88(sp)
    80003dca:	e8ca                	sd	s2,80(sp)
    80003dcc:	e4ce                	sd	s3,72(sp)
    80003dce:	e0d2                	sd	s4,64(sp)
    80003dd0:	fc56                	sd	s5,56(sp)
    80003dd2:	f85a                	sd	s6,48(sp)
    80003dd4:	f45e                	sd	s7,40(sp)
    80003dd6:	f062                	sd	s8,32(sp)
    80003dd8:	ec66                	sd	s9,24(sp)
    80003dda:	e86a                	sd	s10,16(sp)
    80003ddc:	e46e                	sd	s11,8(sp)
    80003dde:	1880                	addi	s0,sp,112
    80003de0:	8baa                	mv	s7,a0
    80003de2:	8c2e                	mv	s8,a1
    80003de4:	8ab2                	mv	s5,a2
    80003de6:	8936                	mv	s2,a3
    80003de8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003dea:	00e687bb          	addw	a5,a3,a4
    80003dee:	0ed7e063          	bltu	a5,a3,80003ece <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003df2:	00043737          	lui	a4,0x43
    80003df6:	0cf76e63          	bltu	a4,a5,80003ed2 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003dfa:	0a0b0763          	beqz	s6,80003ea8 <writei+0xec>
    80003dfe:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e00:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003e04:	5cfd                	li	s9,-1
    80003e06:	a091                	j	80003e4a <writei+0x8e>
    80003e08:	02099d93          	slli	s11,s3,0x20
    80003e0c:	020ddd93          	srli	s11,s11,0x20
    80003e10:	05848793          	addi	a5,s1,88
    80003e14:	86ee                	mv	a3,s11
    80003e16:	8656                	mv	a2,s5
    80003e18:	85e2                	mv	a1,s8
    80003e1a:	953e                	add	a0,a0,a5
    80003e1c:	fffff097          	auipc	ra,0xfffff
    80003e20:	a46080e7          	jalr	-1466(ra) # 80002862 <either_copyin>
    80003e24:	07950263          	beq	a0,s9,80003e88 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003e28:	8526                	mv	a0,s1
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	77e080e7          	jalr	1918(ra) # 800045a8 <log_write>
    brelse(bp);
    80003e32:	8526                	mv	a0,s1
    80003e34:	fffff097          	auipc	ra,0xfffff
    80003e38:	50a080e7          	jalr	1290(ra) # 8000333e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e3c:	01498a3b          	addw	s4,s3,s4
    80003e40:	0129893b          	addw	s2,s3,s2
    80003e44:	9aee                	add	s5,s5,s11
    80003e46:	056a7663          	bgeu	s4,s6,80003e92 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003e4a:	000ba483          	lw	s1,0(s7)
    80003e4e:	00a9559b          	srliw	a1,s2,0xa
    80003e52:	855e                	mv	a0,s7
    80003e54:	fffff097          	auipc	ra,0xfffff
    80003e58:	7ae080e7          	jalr	1966(ra) # 80003602 <bmap>
    80003e5c:	0005059b          	sext.w	a1,a0
    80003e60:	8526                	mv	a0,s1
    80003e62:	fffff097          	auipc	ra,0xfffff
    80003e66:	3ac080e7          	jalr	940(ra) # 8000320e <bread>
    80003e6a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e6c:	3ff97513          	andi	a0,s2,1023
    80003e70:	40ad07bb          	subw	a5,s10,a0
    80003e74:	414b073b          	subw	a4,s6,s4
    80003e78:	89be                	mv	s3,a5
    80003e7a:	2781                	sext.w	a5,a5
    80003e7c:	0007069b          	sext.w	a3,a4
    80003e80:	f8f6f4e3          	bgeu	a3,a5,80003e08 <writei+0x4c>
    80003e84:	89ba                	mv	s3,a4
    80003e86:	b749                	j	80003e08 <writei+0x4c>
      brelse(bp);
    80003e88:	8526                	mv	a0,s1
    80003e8a:	fffff097          	auipc	ra,0xfffff
    80003e8e:	4b4080e7          	jalr	1204(ra) # 8000333e <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003e92:	04cba783          	lw	a5,76(s7)
    80003e96:	0127f463          	bgeu	a5,s2,80003e9e <writei+0xe2>
      ip->size = off;
    80003e9a:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003e9e:	855e                	mv	a0,s7
    80003ea0:	00000097          	auipc	ra,0x0
    80003ea4:	aa8080e7          	jalr	-1368(ra) # 80003948 <iupdate>
  }

  return n;
    80003ea8:	000b051b          	sext.w	a0,s6
}
    80003eac:	70a6                	ld	ra,104(sp)
    80003eae:	7406                	ld	s0,96(sp)
    80003eb0:	64e6                	ld	s1,88(sp)
    80003eb2:	6946                	ld	s2,80(sp)
    80003eb4:	69a6                	ld	s3,72(sp)
    80003eb6:	6a06                	ld	s4,64(sp)
    80003eb8:	7ae2                	ld	s5,56(sp)
    80003eba:	7b42                	ld	s6,48(sp)
    80003ebc:	7ba2                	ld	s7,40(sp)
    80003ebe:	7c02                	ld	s8,32(sp)
    80003ec0:	6ce2                	ld	s9,24(sp)
    80003ec2:	6d42                	ld	s10,16(sp)
    80003ec4:	6da2                	ld	s11,8(sp)
    80003ec6:	6165                	addi	sp,sp,112
    80003ec8:	8082                	ret
    return -1;
    80003eca:	557d                	li	a0,-1
}
    80003ecc:	8082                	ret
    return -1;
    80003ece:	557d                	li	a0,-1
    80003ed0:	bff1                	j	80003eac <writei+0xf0>
    return -1;
    80003ed2:	557d                	li	a0,-1
    80003ed4:	bfe1                	j	80003eac <writei+0xf0>

0000000080003ed6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ed6:	1141                	addi	sp,sp,-16
    80003ed8:	e406                	sd	ra,8(sp)
    80003eda:	e022                	sd	s0,0(sp)
    80003edc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ede:	4639                	li	a2,14
    80003ee0:	ffffd097          	auipc	ra,0xffffd
    80003ee4:	ef0080e7          	jalr	-272(ra) # 80000dd0 <strncmp>
}
    80003ee8:	60a2                	ld	ra,8(sp)
    80003eea:	6402                	ld	s0,0(sp)
    80003eec:	0141                	addi	sp,sp,16
    80003eee:	8082                	ret

0000000080003ef0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ef0:	7139                	addi	sp,sp,-64
    80003ef2:	fc06                	sd	ra,56(sp)
    80003ef4:	f822                	sd	s0,48(sp)
    80003ef6:	f426                	sd	s1,40(sp)
    80003ef8:	f04a                	sd	s2,32(sp)
    80003efa:	ec4e                	sd	s3,24(sp)
    80003efc:	e852                	sd	s4,16(sp)
    80003efe:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003f00:	04451703          	lh	a4,68(a0)
    80003f04:	4785                	li	a5,1
    80003f06:	00f71a63          	bne	a4,a5,80003f1a <dirlookup+0x2a>
    80003f0a:	892a                	mv	s2,a0
    80003f0c:	89ae                	mv	s3,a1
    80003f0e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f10:	457c                	lw	a5,76(a0)
    80003f12:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003f14:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f16:	e79d                	bnez	a5,80003f44 <dirlookup+0x54>
    80003f18:	a8a5                	j	80003f90 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003f1a:	00004517          	auipc	a0,0x4
    80003f1e:	78e50513          	addi	a0,a0,1934 # 800086a8 <syscalls+0x1a0>
    80003f22:	ffffc097          	auipc	ra,0xffffc
    80003f26:	61e080e7          	jalr	1566(ra) # 80000540 <panic>
      panic("dirlookup read");
    80003f2a:	00004517          	auipc	a0,0x4
    80003f2e:	79650513          	addi	a0,a0,1942 # 800086c0 <syscalls+0x1b8>
    80003f32:	ffffc097          	auipc	ra,0xffffc
    80003f36:	60e080e7          	jalr	1550(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f3a:	24c1                	addiw	s1,s1,16
    80003f3c:	04c92783          	lw	a5,76(s2)
    80003f40:	04f4f763          	bgeu	s1,a5,80003f8e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f44:	4741                	li	a4,16
    80003f46:	86a6                	mv	a3,s1
    80003f48:	fc040613          	addi	a2,s0,-64
    80003f4c:	4581                	li	a1,0
    80003f4e:	854a                	mv	a0,s2
    80003f50:	00000097          	auipc	ra,0x0
    80003f54:	d76080e7          	jalr	-650(ra) # 80003cc6 <readi>
    80003f58:	47c1                	li	a5,16
    80003f5a:	fcf518e3          	bne	a0,a5,80003f2a <dirlookup+0x3a>
    if(de.inum == 0)
    80003f5e:	fc045783          	lhu	a5,-64(s0)
    80003f62:	dfe1                	beqz	a5,80003f3a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003f64:	fc240593          	addi	a1,s0,-62
    80003f68:	854e                	mv	a0,s3
    80003f6a:	00000097          	auipc	ra,0x0
    80003f6e:	f6c080e7          	jalr	-148(ra) # 80003ed6 <namecmp>
    80003f72:	f561                	bnez	a0,80003f3a <dirlookup+0x4a>
      if(poff)
    80003f74:	000a0463          	beqz	s4,80003f7c <dirlookup+0x8c>
        *poff = off;
    80003f78:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003f7c:	fc045583          	lhu	a1,-64(s0)
    80003f80:	00092503          	lw	a0,0(s2)
    80003f84:	fffff097          	auipc	ra,0xfffff
    80003f88:	75a080e7          	jalr	1882(ra) # 800036de <iget>
    80003f8c:	a011                	j	80003f90 <dirlookup+0xa0>
  return 0;
    80003f8e:	4501                	li	a0,0
}
    80003f90:	70e2                	ld	ra,56(sp)
    80003f92:	7442                	ld	s0,48(sp)
    80003f94:	74a2                	ld	s1,40(sp)
    80003f96:	7902                	ld	s2,32(sp)
    80003f98:	69e2                	ld	s3,24(sp)
    80003f9a:	6a42                	ld	s4,16(sp)
    80003f9c:	6121                	addi	sp,sp,64
    80003f9e:	8082                	ret

0000000080003fa0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003fa0:	711d                	addi	sp,sp,-96
    80003fa2:	ec86                	sd	ra,88(sp)
    80003fa4:	e8a2                	sd	s0,80(sp)
    80003fa6:	e4a6                	sd	s1,72(sp)
    80003fa8:	e0ca                	sd	s2,64(sp)
    80003faa:	fc4e                	sd	s3,56(sp)
    80003fac:	f852                	sd	s4,48(sp)
    80003fae:	f456                	sd	s5,40(sp)
    80003fb0:	f05a                	sd	s6,32(sp)
    80003fb2:	ec5e                	sd	s7,24(sp)
    80003fb4:	e862                	sd	s8,16(sp)
    80003fb6:	e466                	sd	s9,8(sp)
    80003fb8:	1080                	addi	s0,sp,96
    80003fba:	84aa                	mv	s1,a0
    80003fbc:	8aae                	mv	s5,a1
    80003fbe:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003fc0:	00054703          	lbu	a4,0(a0)
    80003fc4:	02f00793          	li	a5,47
    80003fc8:	02f70363          	beq	a4,a5,80003fee <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003fcc:	ffffe097          	auipc	ra,0xffffe
    80003fd0:	e0c080e7          	jalr	-500(ra) # 80001dd8 <myproc>
    80003fd4:	15053503          	ld	a0,336(a0)
    80003fd8:	00000097          	auipc	ra,0x0
    80003fdc:	9fc080e7          	jalr	-1540(ra) # 800039d4 <idup>
    80003fe0:	89aa                	mv	s3,a0
  while(*path == '/')
    80003fe2:	02f00913          	li	s2,47
  len = path - s;
    80003fe6:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003fe8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003fea:	4b85                	li	s7,1
    80003fec:	a865                	j	800040a4 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003fee:	4585                	li	a1,1
    80003ff0:	4505                	li	a0,1
    80003ff2:	fffff097          	auipc	ra,0xfffff
    80003ff6:	6ec080e7          	jalr	1772(ra) # 800036de <iget>
    80003ffa:	89aa                	mv	s3,a0
    80003ffc:	b7dd                	j	80003fe2 <namex+0x42>
      iunlockput(ip);
    80003ffe:	854e                	mv	a0,s3
    80004000:	00000097          	auipc	ra,0x0
    80004004:	c74080e7          	jalr	-908(ra) # 80003c74 <iunlockput>
      return 0;
    80004008:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000400a:	854e                	mv	a0,s3
    8000400c:	60e6                	ld	ra,88(sp)
    8000400e:	6446                	ld	s0,80(sp)
    80004010:	64a6                	ld	s1,72(sp)
    80004012:	6906                	ld	s2,64(sp)
    80004014:	79e2                	ld	s3,56(sp)
    80004016:	7a42                	ld	s4,48(sp)
    80004018:	7aa2                	ld	s5,40(sp)
    8000401a:	7b02                	ld	s6,32(sp)
    8000401c:	6be2                	ld	s7,24(sp)
    8000401e:	6c42                	ld	s8,16(sp)
    80004020:	6ca2                	ld	s9,8(sp)
    80004022:	6125                	addi	sp,sp,96
    80004024:	8082                	ret
      iunlock(ip);
    80004026:	854e                	mv	a0,s3
    80004028:	00000097          	auipc	ra,0x0
    8000402c:	aac080e7          	jalr	-1364(ra) # 80003ad4 <iunlock>
      return ip;
    80004030:	bfe9                	j	8000400a <namex+0x6a>
      iunlockput(ip);
    80004032:	854e                	mv	a0,s3
    80004034:	00000097          	auipc	ra,0x0
    80004038:	c40080e7          	jalr	-960(ra) # 80003c74 <iunlockput>
      return 0;
    8000403c:	89e6                	mv	s3,s9
    8000403e:	b7f1                	j	8000400a <namex+0x6a>
  len = path - s;
    80004040:	40b48633          	sub	a2,s1,a1
    80004044:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004048:	099c5463          	bge	s8,s9,800040d0 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000404c:	4639                	li	a2,14
    8000404e:	8552                	mv	a0,s4
    80004050:	ffffd097          	auipc	ra,0xffffd
    80004054:	d04080e7          	jalr	-764(ra) # 80000d54 <memmove>
  while(*path == '/')
    80004058:	0004c783          	lbu	a5,0(s1)
    8000405c:	01279763          	bne	a5,s2,8000406a <namex+0xca>
    path++;
    80004060:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004062:	0004c783          	lbu	a5,0(s1)
    80004066:	ff278de3          	beq	a5,s2,80004060 <namex+0xc0>
    ilock(ip);
    8000406a:	854e                	mv	a0,s3
    8000406c:	00000097          	auipc	ra,0x0
    80004070:	9a6080e7          	jalr	-1626(ra) # 80003a12 <ilock>
    if(ip->type != T_DIR){
    80004074:	04499783          	lh	a5,68(s3)
    80004078:	f97793e3          	bne	a5,s7,80003ffe <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000407c:	000a8563          	beqz	s5,80004086 <namex+0xe6>
    80004080:	0004c783          	lbu	a5,0(s1)
    80004084:	d3cd                	beqz	a5,80004026 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004086:	865a                	mv	a2,s6
    80004088:	85d2                	mv	a1,s4
    8000408a:	854e                	mv	a0,s3
    8000408c:	00000097          	auipc	ra,0x0
    80004090:	e64080e7          	jalr	-412(ra) # 80003ef0 <dirlookup>
    80004094:	8caa                	mv	s9,a0
    80004096:	dd51                	beqz	a0,80004032 <namex+0x92>
    iunlockput(ip);
    80004098:	854e                	mv	a0,s3
    8000409a:	00000097          	auipc	ra,0x0
    8000409e:	bda080e7          	jalr	-1062(ra) # 80003c74 <iunlockput>
    ip = next;
    800040a2:	89e6                	mv	s3,s9
  while(*path == '/')
    800040a4:	0004c783          	lbu	a5,0(s1)
    800040a8:	05279763          	bne	a5,s2,800040f6 <namex+0x156>
    path++;
    800040ac:	0485                	addi	s1,s1,1
  while(*path == '/')
    800040ae:	0004c783          	lbu	a5,0(s1)
    800040b2:	ff278de3          	beq	a5,s2,800040ac <namex+0x10c>
  if(*path == 0)
    800040b6:	c79d                	beqz	a5,800040e4 <namex+0x144>
    path++;
    800040b8:	85a6                	mv	a1,s1
  len = path - s;
    800040ba:	8cda                	mv	s9,s6
    800040bc:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800040be:	01278963          	beq	a5,s2,800040d0 <namex+0x130>
    800040c2:	dfbd                	beqz	a5,80004040 <namex+0xa0>
    path++;
    800040c4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800040c6:	0004c783          	lbu	a5,0(s1)
    800040ca:	ff279ce3          	bne	a5,s2,800040c2 <namex+0x122>
    800040ce:	bf8d                	j	80004040 <namex+0xa0>
    memmove(name, s, len);
    800040d0:	2601                	sext.w	a2,a2
    800040d2:	8552                	mv	a0,s4
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	c80080e7          	jalr	-896(ra) # 80000d54 <memmove>
    name[len] = 0;
    800040dc:	9cd2                	add	s9,s9,s4
    800040de:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800040e2:	bf9d                	j	80004058 <namex+0xb8>
  if(nameiparent){
    800040e4:	f20a83e3          	beqz	s5,8000400a <namex+0x6a>
    iput(ip);
    800040e8:	854e                	mv	a0,s3
    800040ea:	00000097          	auipc	ra,0x0
    800040ee:	ae2080e7          	jalr	-1310(ra) # 80003bcc <iput>
    return 0;
    800040f2:	4981                	li	s3,0
    800040f4:	bf19                	j	8000400a <namex+0x6a>
  if(*path == 0)
    800040f6:	d7fd                	beqz	a5,800040e4 <namex+0x144>
  while(*path != '/' && *path != 0)
    800040f8:	0004c783          	lbu	a5,0(s1)
    800040fc:	85a6                	mv	a1,s1
    800040fe:	b7d1                	j	800040c2 <namex+0x122>

0000000080004100 <dirlink>:
{
    80004100:	7139                	addi	sp,sp,-64
    80004102:	fc06                	sd	ra,56(sp)
    80004104:	f822                	sd	s0,48(sp)
    80004106:	f426                	sd	s1,40(sp)
    80004108:	f04a                	sd	s2,32(sp)
    8000410a:	ec4e                	sd	s3,24(sp)
    8000410c:	e852                	sd	s4,16(sp)
    8000410e:	0080                	addi	s0,sp,64
    80004110:	892a                	mv	s2,a0
    80004112:	8a2e                	mv	s4,a1
    80004114:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004116:	4601                	li	a2,0
    80004118:	00000097          	auipc	ra,0x0
    8000411c:	dd8080e7          	jalr	-552(ra) # 80003ef0 <dirlookup>
    80004120:	e93d                	bnez	a0,80004196 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004122:	04c92483          	lw	s1,76(s2)
    80004126:	c49d                	beqz	s1,80004154 <dirlink+0x54>
    80004128:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000412a:	4741                	li	a4,16
    8000412c:	86a6                	mv	a3,s1
    8000412e:	fc040613          	addi	a2,s0,-64
    80004132:	4581                	li	a1,0
    80004134:	854a                	mv	a0,s2
    80004136:	00000097          	auipc	ra,0x0
    8000413a:	b90080e7          	jalr	-1136(ra) # 80003cc6 <readi>
    8000413e:	47c1                	li	a5,16
    80004140:	06f51163          	bne	a0,a5,800041a2 <dirlink+0xa2>
    if(de.inum == 0)
    80004144:	fc045783          	lhu	a5,-64(s0)
    80004148:	c791                	beqz	a5,80004154 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000414a:	24c1                	addiw	s1,s1,16
    8000414c:	04c92783          	lw	a5,76(s2)
    80004150:	fcf4ede3          	bltu	s1,a5,8000412a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004154:	4639                	li	a2,14
    80004156:	85d2                	mv	a1,s4
    80004158:	fc240513          	addi	a0,s0,-62
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	cb0080e7          	jalr	-848(ra) # 80000e0c <strncpy>
  de.inum = inum;
    80004164:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004168:	4741                	li	a4,16
    8000416a:	86a6                	mv	a3,s1
    8000416c:	fc040613          	addi	a2,s0,-64
    80004170:	4581                	li	a1,0
    80004172:	854a                	mv	a0,s2
    80004174:	00000097          	auipc	ra,0x0
    80004178:	c48080e7          	jalr	-952(ra) # 80003dbc <writei>
    8000417c:	872a                	mv	a4,a0
    8000417e:	47c1                	li	a5,16
  return 0;
    80004180:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004182:	02f71863          	bne	a4,a5,800041b2 <dirlink+0xb2>
}
    80004186:	70e2                	ld	ra,56(sp)
    80004188:	7442                	ld	s0,48(sp)
    8000418a:	74a2                	ld	s1,40(sp)
    8000418c:	7902                	ld	s2,32(sp)
    8000418e:	69e2                	ld	s3,24(sp)
    80004190:	6a42                	ld	s4,16(sp)
    80004192:	6121                	addi	sp,sp,64
    80004194:	8082                	ret
    iput(ip);
    80004196:	00000097          	auipc	ra,0x0
    8000419a:	a36080e7          	jalr	-1482(ra) # 80003bcc <iput>
    return -1;
    8000419e:	557d                	li	a0,-1
    800041a0:	b7dd                	j	80004186 <dirlink+0x86>
      panic("dirlink read");
    800041a2:	00004517          	auipc	a0,0x4
    800041a6:	52e50513          	addi	a0,a0,1326 # 800086d0 <syscalls+0x1c8>
    800041aa:	ffffc097          	auipc	ra,0xffffc
    800041ae:	396080e7          	jalr	918(ra) # 80000540 <panic>
    panic("dirlink");
    800041b2:	00004517          	auipc	a0,0x4
    800041b6:	63e50513          	addi	a0,a0,1598 # 800087f0 <syscalls+0x2e8>
    800041ba:	ffffc097          	auipc	ra,0xffffc
    800041be:	386080e7          	jalr	902(ra) # 80000540 <panic>

00000000800041c2 <namei>:

struct inode*
namei(char *path)
{
    800041c2:	1101                	addi	sp,sp,-32
    800041c4:	ec06                	sd	ra,24(sp)
    800041c6:	e822                	sd	s0,16(sp)
    800041c8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800041ca:	fe040613          	addi	a2,s0,-32
    800041ce:	4581                	li	a1,0
    800041d0:	00000097          	auipc	ra,0x0
    800041d4:	dd0080e7          	jalr	-560(ra) # 80003fa0 <namex>
}
    800041d8:	60e2                	ld	ra,24(sp)
    800041da:	6442                	ld	s0,16(sp)
    800041dc:	6105                	addi	sp,sp,32
    800041de:	8082                	ret

00000000800041e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800041e0:	1141                	addi	sp,sp,-16
    800041e2:	e406                	sd	ra,8(sp)
    800041e4:	e022                	sd	s0,0(sp)
    800041e6:	0800                	addi	s0,sp,16
    800041e8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800041ea:	4585                	li	a1,1
    800041ec:	00000097          	auipc	ra,0x0
    800041f0:	db4080e7          	jalr	-588(ra) # 80003fa0 <namex>
}
    800041f4:	60a2                	ld	ra,8(sp)
    800041f6:	6402                	ld	s0,0(sp)
    800041f8:	0141                	addi	sp,sp,16
    800041fa:	8082                	ret

00000000800041fc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800041fc:	1101                	addi	sp,sp,-32
    800041fe:	ec06                	sd	ra,24(sp)
    80004200:	e822                	sd	s0,16(sp)
    80004202:	e426                	sd	s1,8(sp)
    80004204:	e04a                	sd	s2,0(sp)
    80004206:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004208:	0001e917          	auipc	s2,0x1e
    8000420c:	d4890913          	addi	s2,s2,-696 # 80021f50 <log>
    80004210:	01892583          	lw	a1,24(s2)
    80004214:	02892503          	lw	a0,40(s2)
    80004218:	fffff097          	auipc	ra,0xfffff
    8000421c:	ff6080e7          	jalr	-10(ra) # 8000320e <bread>
    80004220:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004222:	02c92683          	lw	a3,44(s2)
    80004226:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004228:	02d05863          	blez	a3,80004258 <write_head+0x5c>
    8000422c:	0001e797          	auipc	a5,0x1e
    80004230:	d5478793          	addi	a5,a5,-684 # 80021f80 <log+0x30>
    80004234:	05c50713          	addi	a4,a0,92
    80004238:	36fd                	addiw	a3,a3,-1
    8000423a:	02069613          	slli	a2,a3,0x20
    8000423e:	01e65693          	srli	a3,a2,0x1e
    80004242:	0001e617          	auipc	a2,0x1e
    80004246:	d4260613          	addi	a2,a2,-702 # 80021f84 <log+0x34>
    8000424a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000424c:	4390                	lw	a2,0(a5)
    8000424e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004250:	0791                	addi	a5,a5,4
    80004252:	0711                	addi	a4,a4,4
    80004254:	fed79ce3          	bne	a5,a3,8000424c <write_head+0x50>
  }
  bwrite(buf);
    80004258:	8526                	mv	a0,s1
    8000425a:	fffff097          	auipc	ra,0xfffff
    8000425e:	0a6080e7          	jalr	166(ra) # 80003300 <bwrite>
  brelse(buf);
    80004262:	8526                	mv	a0,s1
    80004264:	fffff097          	auipc	ra,0xfffff
    80004268:	0da080e7          	jalr	218(ra) # 8000333e <brelse>
}
    8000426c:	60e2                	ld	ra,24(sp)
    8000426e:	6442                	ld	s0,16(sp)
    80004270:	64a2                	ld	s1,8(sp)
    80004272:	6902                	ld	s2,0(sp)
    80004274:	6105                	addi	sp,sp,32
    80004276:	8082                	ret

0000000080004278 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004278:	0001e797          	auipc	a5,0x1e
    8000427c:	d047a783          	lw	a5,-764(a5) # 80021f7c <log+0x2c>
    80004280:	0af05663          	blez	a5,8000432c <install_trans+0xb4>
{
    80004284:	7139                	addi	sp,sp,-64
    80004286:	fc06                	sd	ra,56(sp)
    80004288:	f822                	sd	s0,48(sp)
    8000428a:	f426                	sd	s1,40(sp)
    8000428c:	f04a                	sd	s2,32(sp)
    8000428e:	ec4e                	sd	s3,24(sp)
    80004290:	e852                	sd	s4,16(sp)
    80004292:	e456                	sd	s5,8(sp)
    80004294:	0080                	addi	s0,sp,64
    80004296:	0001ea97          	auipc	s5,0x1e
    8000429a:	ceaa8a93          	addi	s5,s5,-790 # 80021f80 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000429e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800042a0:	0001e997          	auipc	s3,0x1e
    800042a4:	cb098993          	addi	s3,s3,-848 # 80021f50 <log>
    800042a8:	0189a583          	lw	a1,24(s3)
    800042ac:	014585bb          	addw	a1,a1,s4
    800042b0:	2585                	addiw	a1,a1,1
    800042b2:	0289a503          	lw	a0,40(s3)
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	f58080e7          	jalr	-168(ra) # 8000320e <bread>
    800042be:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800042c0:	000aa583          	lw	a1,0(s5)
    800042c4:	0289a503          	lw	a0,40(s3)
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	f46080e7          	jalr	-186(ra) # 8000320e <bread>
    800042d0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800042d2:	40000613          	li	a2,1024
    800042d6:	05890593          	addi	a1,s2,88
    800042da:	05850513          	addi	a0,a0,88
    800042de:	ffffd097          	auipc	ra,0xffffd
    800042e2:	a76080e7          	jalr	-1418(ra) # 80000d54 <memmove>
    bwrite(dbuf);  // write dst to disk
    800042e6:	8526                	mv	a0,s1
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	018080e7          	jalr	24(ra) # 80003300 <bwrite>
    bunpin(dbuf);
    800042f0:	8526                	mv	a0,s1
    800042f2:	fffff097          	auipc	ra,0xfffff
    800042f6:	126080e7          	jalr	294(ra) # 80003418 <bunpin>
    brelse(lbuf);
    800042fa:	854a                	mv	a0,s2
    800042fc:	fffff097          	auipc	ra,0xfffff
    80004300:	042080e7          	jalr	66(ra) # 8000333e <brelse>
    brelse(dbuf);
    80004304:	8526                	mv	a0,s1
    80004306:	fffff097          	auipc	ra,0xfffff
    8000430a:	038080e7          	jalr	56(ra) # 8000333e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000430e:	2a05                	addiw	s4,s4,1
    80004310:	0a91                	addi	s5,s5,4
    80004312:	02c9a783          	lw	a5,44(s3)
    80004316:	f8fa49e3          	blt	s4,a5,800042a8 <install_trans+0x30>
}
    8000431a:	70e2                	ld	ra,56(sp)
    8000431c:	7442                	ld	s0,48(sp)
    8000431e:	74a2                	ld	s1,40(sp)
    80004320:	7902                	ld	s2,32(sp)
    80004322:	69e2                	ld	s3,24(sp)
    80004324:	6a42                	ld	s4,16(sp)
    80004326:	6aa2                	ld	s5,8(sp)
    80004328:	6121                	addi	sp,sp,64
    8000432a:	8082                	ret
    8000432c:	8082                	ret

000000008000432e <initlog>:
{
    8000432e:	7179                	addi	sp,sp,-48
    80004330:	f406                	sd	ra,40(sp)
    80004332:	f022                	sd	s0,32(sp)
    80004334:	ec26                	sd	s1,24(sp)
    80004336:	e84a                	sd	s2,16(sp)
    80004338:	e44e                	sd	s3,8(sp)
    8000433a:	1800                	addi	s0,sp,48
    8000433c:	892a                	mv	s2,a0
    8000433e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004340:	0001e497          	auipc	s1,0x1e
    80004344:	c1048493          	addi	s1,s1,-1008 # 80021f50 <log>
    80004348:	00004597          	auipc	a1,0x4
    8000434c:	39858593          	addi	a1,a1,920 # 800086e0 <syscalls+0x1d8>
    80004350:	8526                	mv	a0,s1
    80004352:	ffffd097          	auipc	ra,0xffffd
    80004356:	81a080e7          	jalr	-2022(ra) # 80000b6c <initlock>
  log.start = sb->logstart;
    8000435a:	0149a583          	lw	a1,20(s3)
    8000435e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004360:	0109a783          	lw	a5,16(s3)
    80004364:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004366:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000436a:	854a                	mv	a0,s2
    8000436c:	fffff097          	auipc	ra,0xfffff
    80004370:	ea2080e7          	jalr	-350(ra) # 8000320e <bread>
  log.lh.n = lh->n;
    80004374:	4d34                	lw	a3,88(a0)
    80004376:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004378:	02d05663          	blez	a3,800043a4 <initlog+0x76>
    8000437c:	05c50793          	addi	a5,a0,92
    80004380:	0001e717          	auipc	a4,0x1e
    80004384:	c0070713          	addi	a4,a4,-1024 # 80021f80 <log+0x30>
    80004388:	36fd                	addiw	a3,a3,-1
    8000438a:	02069613          	slli	a2,a3,0x20
    8000438e:	01e65693          	srli	a3,a2,0x1e
    80004392:	06050613          	addi	a2,a0,96
    80004396:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004398:	4390                	lw	a2,0(a5)
    8000439a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000439c:	0791                	addi	a5,a5,4
    8000439e:	0711                	addi	a4,a4,4
    800043a0:	fed79ce3          	bne	a5,a3,80004398 <initlog+0x6a>
  brelse(buf);
    800043a4:	fffff097          	auipc	ra,0xfffff
    800043a8:	f9a080e7          	jalr	-102(ra) # 8000333e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800043ac:	00000097          	auipc	ra,0x0
    800043b0:	ecc080e7          	jalr	-308(ra) # 80004278 <install_trans>
  log.lh.n = 0;
    800043b4:	0001e797          	auipc	a5,0x1e
    800043b8:	bc07a423          	sw	zero,-1080(a5) # 80021f7c <log+0x2c>
  write_head(); // clear the log
    800043bc:	00000097          	auipc	ra,0x0
    800043c0:	e40080e7          	jalr	-448(ra) # 800041fc <write_head>
}
    800043c4:	70a2                	ld	ra,40(sp)
    800043c6:	7402                	ld	s0,32(sp)
    800043c8:	64e2                	ld	s1,24(sp)
    800043ca:	6942                	ld	s2,16(sp)
    800043cc:	69a2                	ld	s3,8(sp)
    800043ce:	6145                	addi	sp,sp,48
    800043d0:	8082                	ret

00000000800043d2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800043d2:	1101                	addi	sp,sp,-32
    800043d4:	ec06                	sd	ra,24(sp)
    800043d6:	e822                	sd	s0,16(sp)
    800043d8:	e426                	sd	s1,8(sp)
    800043da:	e04a                	sd	s2,0(sp)
    800043dc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800043de:	0001e517          	auipc	a0,0x1e
    800043e2:	b7250513          	addi	a0,a0,-1166 # 80021f50 <log>
    800043e6:	ffffd097          	auipc	ra,0xffffd
    800043ea:	816080e7          	jalr	-2026(ra) # 80000bfc <acquire>
  while(1){
    if(log.committing){
    800043ee:	0001e497          	auipc	s1,0x1e
    800043f2:	b6248493          	addi	s1,s1,-1182 # 80021f50 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800043f6:	4979                	li	s2,30
    800043f8:	a039                	j	80004406 <begin_op+0x34>
      sleep(&log, &log.lock);
    800043fa:	85a6                	mv	a1,s1
    800043fc:	8526                	mv	a0,s1
    800043fe:	ffffe097          	auipc	ra,0xffffe
    80004402:	168080e7          	jalr	360(ra) # 80002566 <sleep>
    if(log.committing){
    80004406:	50dc                	lw	a5,36(s1)
    80004408:	fbed                	bnez	a5,800043fa <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000440a:	509c                	lw	a5,32(s1)
    8000440c:	0017871b          	addiw	a4,a5,1
    80004410:	0007069b          	sext.w	a3,a4
    80004414:	0027179b          	slliw	a5,a4,0x2
    80004418:	9fb9                	addw	a5,a5,a4
    8000441a:	0017979b          	slliw	a5,a5,0x1
    8000441e:	54d8                	lw	a4,44(s1)
    80004420:	9fb9                	addw	a5,a5,a4
    80004422:	00f95963          	bge	s2,a5,80004434 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004426:	85a6                	mv	a1,s1
    80004428:	8526                	mv	a0,s1
    8000442a:	ffffe097          	auipc	ra,0xffffe
    8000442e:	13c080e7          	jalr	316(ra) # 80002566 <sleep>
    80004432:	bfd1                	j	80004406 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004434:	0001e517          	auipc	a0,0x1e
    80004438:	b1c50513          	addi	a0,a0,-1252 # 80021f50 <log>
    8000443c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000443e:	ffffd097          	auipc	ra,0xffffd
    80004442:	872080e7          	jalr	-1934(ra) # 80000cb0 <release>
      break;
    }
  }
}
    80004446:	60e2                	ld	ra,24(sp)
    80004448:	6442                	ld	s0,16(sp)
    8000444a:	64a2                	ld	s1,8(sp)
    8000444c:	6902                	ld	s2,0(sp)
    8000444e:	6105                	addi	sp,sp,32
    80004450:	8082                	ret

0000000080004452 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004452:	7139                	addi	sp,sp,-64
    80004454:	fc06                	sd	ra,56(sp)
    80004456:	f822                	sd	s0,48(sp)
    80004458:	f426                	sd	s1,40(sp)
    8000445a:	f04a                	sd	s2,32(sp)
    8000445c:	ec4e                	sd	s3,24(sp)
    8000445e:	e852                	sd	s4,16(sp)
    80004460:	e456                	sd	s5,8(sp)
    80004462:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004464:	0001e497          	auipc	s1,0x1e
    80004468:	aec48493          	addi	s1,s1,-1300 # 80021f50 <log>
    8000446c:	8526                	mv	a0,s1
    8000446e:	ffffc097          	auipc	ra,0xffffc
    80004472:	78e080e7          	jalr	1934(ra) # 80000bfc <acquire>
  log.outstanding -= 1;
    80004476:	509c                	lw	a5,32(s1)
    80004478:	37fd                	addiw	a5,a5,-1
    8000447a:	0007891b          	sext.w	s2,a5
    8000447e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004480:	50dc                	lw	a5,36(s1)
    80004482:	e7b9                	bnez	a5,800044d0 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004484:	04091e63          	bnez	s2,800044e0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004488:	0001e497          	auipc	s1,0x1e
    8000448c:	ac848493          	addi	s1,s1,-1336 # 80021f50 <log>
    80004490:	4785                	li	a5,1
    80004492:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004494:	8526                	mv	a0,s1
    80004496:	ffffd097          	auipc	ra,0xffffd
    8000449a:	81a080e7          	jalr	-2022(ra) # 80000cb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000449e:	54dc                	lw	a5,44(s1)
    800044a0:	06f04763          	bgtz	a5,8000450e <end_op+0xbc>
    acquire(&log.lock);
    800044a4:	0001e497          	auipc	s1,0x1e
    800044a8:	aac48493          	addi	s1,s1,-1364 # 80021f50 <log>
    800044ac:	8526                	mv	a0,s1
    800044ae:	ffffc097          	auipc	ra,0xffffc
    800044b2:	74e080e7          	jalr	1870(ra) # 80000bfc <acquire>
    log.committing = 0;
    800044b6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800044ba:	8526                	mv	a0,s1
    800044bc:	ffffe097          	auipc	ra,0xffffe
    800044c0:	22a080e7          	jalr	554(ra) # 800026e6 <wakeup>
    release(&log.lock);
    800044c4:	8526                	mv	a0,s1
    800044c6:	ffffc097          	auipc	ra,0xffffc
    800044ca:	7ea080e7          	jalr	2026(ra) # 80000cb0 <release>
}
    800044ce:	a03d                	j	800044fc <end_op+0xaa>
    panic("log.committing");
    800044d0:	00004517          	auipc	a0,0x4
    800044d4:	21850513          	addi	a0,a0,536 # 800086e8 <syscalls+0x1e0>
    800044d8:	ffffc097          	auipc	ra,0xffffc
    800044dc:	068080e7          	jalr	104(ra) # 80000540 <panic>
    wakeup(&log);
    800044e0:	0001e497          	auipc	s1,0x1e
    800044e4:	a7048493          	addi	s1,s1,-1424 # 80021f50 <log>
    800044e8:	8526                	mv	a0,s1
    800044ea:	ffffe097          	auipc	ra,0xffffe
    800044ee:	1fc080e7          	jalr	508(ra) # 800026e6 <wakeup>
  release(&log.lock);
    800044f2:	8526                	mv	a0,s1
    800044f4:	ffffc097          	auipc	ra,0xffffc
    800044f8:	7bc080e7          	jalr	1980(ra) # 80000cb0 <release>
}
    800044fc:	70e2                	ld	ra,56(sp)
    800044fe:	7442                	ld	s0,48(sp)
    80004500:	74a2                	ld	s1,40(sp)
    80004502:	7902                	ld	s2,32(sp)
    80004504:	69e2                	ld	s3,24(sp)
    80004506:	6a42                	ld	s4,16(sp)
    80004508:	6aa2                	ld	s5,8(sp)
    8000450a:	6121                	addi	sp,sp,64
    8000450c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000450e:	0001ea97          	auipc	s5,0x1e
    80004512:	a72a8a93          	addi	s5,s5,-1422 # 80021f80 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004516:	0001ea17          	auipc	s4,0x1e
    8000451a:	a3aa0a13          	addi	s4,s4,-1478 # 80021f50 <log>
    8000451e:	018a2583          	lw	a1,24(s4)
    80004522:	012585bb          	addw	a1,a1,s2
    80004526:	2585                	addiw	a1,a1,1
    80004528:	028a2503          	lw	a0,40(s4)
    8000452c:	fffff097          	auipc	ra,0xfffff
    80004530:	ce2080e7          	jalr	-798(ra) # 8000320e <bread>
    80004534:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004536:	000aa583          	lw	a1,0(s5)
    8000453a:	028a2503          	lw	a0,40(s4)
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	cd0080e7          	jalr	-816(ra) # 8000320e <bread>
    80004546:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004548:	40000613          	li	a2,1024
    8000454c:	05850593          	addi	a1,a0,88
    80004550:	05848513          	addi	a0,s1,88
    80004554:	ffffd097          	auipc	ra,0xffffd
    80004558:	800080e7          	jalr	-2048(ra) # 80000d54 <memmove>
    bwrite(to);  // write the log
    8000455c:	8526                	mv	a0,s1
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	da2080e7          	jalr	-606(ra) # 80003300 <bwrite>
    brelse(from);
    80004566:	854e                	mv	a0,s3
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	dd6080e7          	jalr	-554(ra) # 8000333e <brelse>
    brelse(to);
    80004570:	8526                	mv	a0,s1
    80004572:	fffff097          	auipc	ra,0xfffff
    80004576:	dcc080e7          	jalr	-564(ra) # 8000333e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000457a:	2905                	addiw	s2,s2,1
    8000457c:	0a91                	addi	s5,s5,4
    8000457e:	02ca2783          	lw	a5,44(s4)
    80004582:	f8f94ee3          	blt	s2,a5,8000451e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004586:	00000097          	auipc	ra,0x0
    8000458a:	c76080e7          	jalr	-906(ra) # 800041fc <write_head>
    install_trans(); // Now install writes to home locations
    8000458e:	00000097          	auipc	ra,0x0
    80004592:	cea080e7          	jalr	-790(ra) # 80004278 <install_trans>
    log.lh.n = 0;
    80004596:	0001e797          	auipc	a5,0x1e
    8000459a:	9e07a323          	sw	zero,-1562(a5) # 80021f7c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000459e:	00000097          	auipc	ra,0x0
    800045a2:	c5e080e7          	jalr	-930(ra) # 800041fc <write_head>
    800045a6:	bdfd                	j	800044a4 <end_op+0x52>

00000000800045a8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800045a8:	1101                	addi	sp,sp,-32
    800045aa:	ec06                	sd	ra,24(sp)
    800045ac:	e822                	sd	s0,16(sp)
    800045ae:	e426                	sd	s1,8(sp)
    800045b0:	e04a                	sd	s2,0(sp)
    800045b2:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800045b4:	0001e717          	auipc	a4,0x1e
    800045b8:	9c872703          	lw	a4,-1592(a4) # 80021f7c <log+0x2c>
    800045bc:	47f5                	li	a5,29
    800045be:	08e7c063          	blt	a5,a4,8000463e <log_write+0x96>
    800045c2:	84aa                	mv	s1,a0
    800045c4:	0001e797          	auipc	a5,0x1e
    800045c8:	9a87a783          	lw	a5,-1624(a5) # 80021f6c <log+0x1c>
    800045cc:	37fd                	addiw	a5,a5,-1
    800045ce:	06f75863          	bge	a4,a5,8000463e <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800045d2:	0001e797          	auipc	a5,0x1e
    800045d6:	99e7a783          	lw	a5,-1634(a5) # 80021f70 <log+0x20>
    800045da:	06f05a63          	blez	a5,8000464e <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800045de:	0001e917          	auipc	s2,0x1e
    800045e2:	97290913          	addi	s2,s2,-1678 # 80021f50 <log>
    800045e6:	854a                	mv	a0,s2
    800045e8:	ffffc097          	auipc	ra,0xffffc
    800045ec:	614080e7          	jalr	1556(ra) # 80000bfc <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800045f0:	02c92603          	lw	a2,44(s2)
    800045f4:	06c05563          	blez	a2,8000465e <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800045f8:	44cc                	lw	a1,12(s1)
    800045fa:	0001e717          	auipc	a4,0x1e
    800045fe:	98670713          	addi	a4,a4,-1658 # 80021f80 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004602:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004604:	4314                	lw	a3,0(a4)
    80004606:	04b68d63          	beq	a3,a1,80004660 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    8000460a:	2785                	addiw	a5,a5,1
    8000460c:	0711                	addi	a4,a4,4
    8000460e:	fec79be3          	bne	a5,a2,80004604 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004612:	0621                	addi	a2,a2,8
    80004614:	060a                	slli	a2,a2,0x2
    80004616:	0001e797          	auipc	a5,0x1e
    8000461a:	93a78793          	addi	a5,a5,-1734 # 80021f50 <log>
    8000461e:	963e                	add	a2,a2,a5
    80004620:	44dc                	lw	a5,12(s1)
    80004622:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004624:	8526                	mv	a0,s1
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	db6080e7          	jalr	-586(ra) # 800033dc <bpin>
    log.lh.n++;
    8000462e:	0001e717          	auipc	a4,0x1e
    80004632:	92270713          	addi	a4,a4,-1758 # 80021f50 <log>
    80004636:	575c                	lw	a5,44(a4)
    80004638:	2785                	addiw	a5,a5,1
    8000463a:	d75c                	sw	a5,44(a4)
    8000463c:	a83d                	j	8000467a <log_write+0xd2>
    panic("too big a transaction");
    8000463e:	00004517          	auipc	a0,0x4
    80004642:	0ba50513          	addi	a0,a0,186 # 800086f8 <syscalls+0x1f0>
    80004646:	ffffc097          	auipc	ra,0xffffc
    8000464a:	efa080e7          	jalr	-262(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    8000464e:	00004517          	auipc	a0,0x4
    80004652:	0c250513          	addi	a0,a0,194 # 80008710 <syscalls+0x208>
    80004656:	ffffc097          	auipc	ra,0xffffc
    8000465a:	eea080e7          	jalr	-278(ra) # 80000540 <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000465e:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004660:	00878713          	addi	a4,a5,8
    80004664:	00271693          	slli	a3,a4,0x2
    80004668:	0001e717          	auipc	a4,0x1e
    8000466c:	8e870713          	addi	a4,a4,-1816 # 80021f50 <log>
    80004670:	9736                	add	a4,a4,a3
    80004672:	44d4                	lw	a3,12(s1)
    80004674:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004676:	faf607e3          	beq	a2,a5,80004624 <log_write+0x7c>
  }
  release(&log.lock);
    8000467a:	0001e517          	auipc	a0,0x1e
    8000467e:	8d650513          	addi	a0,a0,-1834 # 80021f50 <log>
    80004682:	ffffc097          	auipc	ra,0xffffc
    80004686:	62e080e7          	jalr	1582(ra) # 80000cb0 <release>
}
    8000468a:	60e2                	ld	ra,24(sp)
    8000468c:	6442                	ld	s0,16(sp)
    8000468e:	64a2                	ld	s1,8(sp)
    80004690:	6902                	ld	s2,0(sp)
    80004692:	6105                	addi	sp,sp,32
    80004694:	8082                	ret

0000000080004696 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004696:	1101                	addi	sp,sp,-32
    80004698:	ec06                	sd	ra,24(sp)
    8000469a:	e822                	sd	s0,16(sp)
    8000469c:	e426                	sd	s1,8(sp)
    8000469e:	e04a                	sd	s2,0(sp)
    800046a0:	1000                	addi	s0,sp,32
    800046a2:	84aa                	mv	s1,a0
    800046a4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800046a6:	00004597          	auipc	a1,0x4
    800046aa:	08a58593          	addi	a1,a1,138 # 80008730 <syscalls+0x228>
    800046ae:	0521                	addi	a0,a0,8
    800046b0:	ffffc097          	auipc	ra,0xffffc
    800046b4:	4bc080e7          	jalr	1212(ra) # 80000b6c <initlock>
  lk->name = name;
    800046b8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800046bc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800046c0:	0204a423          	sw	zero,40(s1)
}
    800046c4:	60e2                	ld	ra,24(sp)
    800046c6:	6442                	ld	s0,16(sp)
    800046c8:	64a2                	ld	s1,8(sp)
    800046ca:	6902                	ld	s2,0(sp)
    800046cc:	6105                	addi	sp,sp,32
    800046ce:	8082                	ret

00000000800046d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800046d0:	1101                	addi	sp,sp,-32
    800046d2:	ec06                	sd	ra,24(sp)
    800046d4:	e822                	sd	s0,16(sp)
    800046d6:	e426                	sd	s1,8(sp)
    800046d8:	e04a                	sd	s2,0(sp)
    800046da:	1000                	addi	s0,sp,32
    800046dc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800046de:	00850913          	addi	s2,a0,8
    800046e2:	854a                	mv	a0,s2
    800046e4:	ffffc097          	auipc	ra,0xffffc
    800046e8:	518080e7          	jalr	1304(ra) # 80000bfc <acquire>
  while (lk->locked) {
    800046ec:	409c                	lw	a5,0(s1)
    800046ee:	cb89                	beqz	a5,80004700 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800046f0:	85ca                	mv	a1,s2
    800046f2:	8526                	mv	a0,s1
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	e72080e7          	jalr	-398(ra) # 80002566 <sleep>
  while (lk->locked) {
    800046fc:	409c                	lw	a5,0(s1)
    800046fe:	fbed                	bnez	a5,800046f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004700:	4785                	li	a5,1
    80004702:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004704:	ffffd097          	auipc	ra,0xffffd
    80004708:	6d4080e7          	jalr	1748(ra) # 80001dd8 <myproc>
    8000470c:	5d1c                	lw	a5,56(a0)
    8000470e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004710:	854a                	mv	a0,s2
    80004712:	ffffc097          	auipc	ra,0xffffc
    80004716:	59e080e7          	jalr	1438(ra) # 80000cb0 <release>
}
    8000471a:	60e2                	ld	ra,24(sp)
    8000471c:	6442                	ld	s0,16(sp)
    8000471e:	64a2                	ld	s1,8(sp)
    80004720:	6902                	ld	s2,0(sp)
    80004722:	6105                	addi	sp,sp,32
    80004724:	8082                	ret

0000000080004726 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004726:	1101                	addi	sp,sp,-32
    80004728:	ec06                	sd	ra,24(sp)
    8000472a:	e822                	sd	s0,16(sp)
    8000472c:	e426                	sd	s1,8(sp)
    8000472e:	e04a                	sd	s2,0(sp)
    80004730:	1000                	addi	s0,sp,32
    80004732:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004734:	00850913          	addi	s2,a0,8
    80004738:	854a                	mv	a0,s2
    8000473a:	ffffc097          	auipc	ra,0xffffc
    8000473e:	4c2080e7          	jalr	1218(ra) # 80000bfc <acquire>
  lk->locked = 0;
    80004742:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004746:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000474a:	8526                	mv	a0,s1
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	f9a080e7          	jalr	-102(ra) # 800026e6 <wakeup>
  release(&lk->lk);
    80004754:	854a                	mv	a0,s2
    80004756:	ffffc097          	auipc	ra,0xffffc
    8000475a:	55a080e7          	jalr	1370(ra) # 80000cb0 <release>
}
    8000475e:	60e2                	ld	ra,24(sp)
    80004760:	6442                	ld	s0,16(sp)
    80004762:	64a2                	ld	s1,8(sp)
    80004764:	6902                	ld	s2,0(sp)
    80004766:	6105                	addi	sp,sp,32
    80004768:	8082                	ret

000000008000476a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000476a:	7179                	addi	sp,sp,-48
    8000476c:	f406                	sd	ra,40(sp)
    8000476e:	f022                	sd	s0,32(sp)
    80004770:	ec26                	sd	s1,24(sp)
    80004772:	e84a                	sd	s2,16(sp)
    80004774:	e44e                	sd	s3,8(sp)
    80004776:	1800                	addi	s0,sp,48
    80004778:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000477a:	00850913          	addi	s2,a0,8
    8000477e:	854a                	mv	a0,s2
    80004780:	ffffc097          	auipc	ra,0xffffc
    80004784:	47c080e7          	jalr	1148(ra) # 80000bfc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004788:	409c                	lw	a5,0(s1)
    8000478a:	ef99                	bnez	a5,800047a8 <holdingsleep+0x3e>
    8000478c:	4481                	li	s1,0
  release(&lk->lk);
    8000478e:	854a                	mv	a0,s2
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	520080e7          	jalr	1312(ra) # 80000cb0 <release>
  return r;
}
    80004798:	8526                	mv	a0,s1
    8000479a:	70a2                	ld	ra,40(sp)
    8000479c:	7402                	ld	s0,32(sp)
    8000479e:	64e2                	ld	s1,24(sp)
    800047a0:	6942                	ld	s2,16(sp)
    800047a2:	69a2                	ld	s3,8(sp)
    800047a4:	6145                	addi	sp,sp,48
    800047a6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800047a8:	0284a983          	lw	s3,40(s1)
    800047ac:	ffffd097          	auipc	ra,0xffffd
    800047b0:	62c080e7          	jalr	1580(ra) # 80001dd8 <myproc>
    800047b4:	5d04                	lw	s1,56(a0)
    800047b6:	413484b3          	sub	s1,s1,s3
    800047ba:	0014b493          	seqz	s1,s1
    800047be:	bfc1                	j	8000478e <holdingsleep+0x24>

00000000800047c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800047c0:	1141                	addi	sp,sp,-16
    800047c2:	e406                	sd	ra,8(sp)
    800047c4:	e022                	sd	s0,0(sp)
    800047c6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800047c8:	00004597          	auipc	a1,0x4
    800047cc:	f7858593          	addi	a1,a1,-136 # 80008740 <syscalls+0x238>
    800047d0:	0001e517          	auipc	a0,0x1e
    800047d4:	8c850513          	addi	a0,a0,-1848 # 80022098 <ftable>
    800047d8:	ffffc097          	auipc	ra,0xffffc
    800047dc:	394080e7          	jalr	916(ra) # 80000b6c <initlock>
}
    800047e0:	60a2                	ld	ra,8(sp)
    800047e2:	6402                	ld	s0,0(sp)
    800047e4:	0141                	addi	sp,sp,16
    800047e6:	8082                	ret

00000000800047e8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800047e8:	1101                	addi	sp,sp,-32
    800047ea:	ec06                	sd	ra,24(sp)
    800047ec:	e822                	sd	s0,16(sp)
    800047ee:	e426                	sd	s1,8(sp)
    800047f0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800047f2:	0001e517          	auipc	a0,0x1e
    800047f6:	8a650513          	addi	a0,a0,-1882 # 80022098 <ftable>
    800047fa:	ffffc097          	auipc	ra,0xffffc
    800047fe:	402080e7          	jalr	1026(ra) # 80000bfc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004802:	0001e497          	auipc	s1,0x1e
    80004806:	8ae48493          	addi	s1,s1,-1874 # 800220b0 <ftable+0x18>
    8000480a:	0001f717          	auipc	a4,0x1f
    8000480e:	84670713          	addi	a4,a4,-1978 # 80023050 <ftable+0xfb8>
    if(f->ref == 0){
    80004812:	40dc                	lw	a5,4(s1)
    80004814:	cf99                	beqz	a5,80004832 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004816:	02848493          	addi	s1,s1,40
    8000481a:	fee49ce3          	bne	s1,a4,80004812 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000481e:	0001e517          	auipc	a0,0x1e
    80004822:	87a50513          	addi	a0,a0,-1926 # 80022098 <ftable>
    80004826:	ffffc097          	auipc	ra,0xffffc
    8000482a:	48a080e7          	jalr	1162(ra) # 80000cb0 <release>
  return 0;
    8000482e:	4481                	li	s1,0
    80004830:	a819                	j	80004846 <filealloc+0x5e>
      f->ref = 1;
    80004832:	4785                	li	a5,1
    80004834:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004836:	0001e517          	auipc	a0,0x1e
    8000483a:	86250513          	addi	a0,a0,-1950 # 80022098 <ftable>
    8000483e:	ffffc097          	auipc	ra,0xffffc
    80004842:	472080e7          	jalr	1138(ra) # 80000cb0 <release>
}
    80004846:	8526                	mv	a0,s1
    80004848:	60e2                	ld	ra,24(sp)
    8000484a:	6442                	ld	s0,16(sp)
    8000484c:	64a2                	ld	s1,8(sp)
    8000484e:	6105                	addi	sp,sp,32
    80004850:	8082                	ret

0000000080004852 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004852:	1101                	addi	sp,sp,-32
    80004854:	ec06                	sd	ra,24(sp)
    80004856:	e822                	sd	s0,16(sp)
    80004858:	e426                	sd	s1,8(sp)
    8000485a:	1000                	addi	s0,sp,32
    8000485c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000485e:	0001e517          	auipc	a0,0x1e
    80004862:	83a50513          	addi	a0,a0,-1990 # 80022098 <ftable>
    80004866:	ffffc097          	auipc	ra,0xffffc
    8000486a:	396080e7          	jalr	918(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    8000486e:	40dc                	lw	a5,4(s1)
    80004870:	02f05263          	blez	a5,80004894 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004874:	2785                	addiw	a5,a5,1
    80004876:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004878:	0001e517          	auipc	a0,0x1e
    8000487c:	82050513          	addi	a0,a0,-2016 # 80022098 <ftable>
    80004880:	ffffc097          	auipc	ra,0xffffc
    80004884:	430080e7          	jalr	1072(ra) # 80000cb0 <release>
  return f;
}
    80004888:	8526                	mv	a0,s1
    8000488a:	60e2                	ld	ra,24(sp)
    8000488c:	6442                	ld	s0,16(sp)
    8000488e:	64a2                	ld	s1,8(sp)
    80004890:	6105                	addi	sp,sp,32
    80004892:	8082                	ret
    panic("filedup");
    80004894:	00004517          	auipc	a0,0x4
    80004898:	eb450513          	addi	a0,a0,-332 # 80008748 <syscalls+0x240>
    8000489c:	ffffc097          	auipc	ra,0xffffc
    800048a0:	ca4080e7          	jalr	-860(ra) # 80000540 <panic>

00000000800048a4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800048a4:	7139                	addi	sp,sp,-64
    800048a6:	fc06                	sd	ra,56(sp)
    800048a8:	f822                	sd	s0,48(sp)
    800048aa:	f426                	sd	s1,40(sp)
    800048ac:	f04a                	sd	s2,32(sp)
    800048ae:	ec4e                	sd	s3,24(sp)
    800048b0:	e852                	sd	s4,16(sp)
    800048b2:	e456                	sd	s5,8(sp)
    800048b4:	0080                	addi	s0,sp,64
    800048b6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800048b8:	0001d517          	auipc	a0,0x1d
    800048bc:	7e050513          	addi	a0,a0,2016 # 80022098 <ftable>
    800048c0:	ffffc097          	auipc	ra,0xffffc
    800048c4:	33c080e7          	jalr	828(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    800048c8:	40dc                	lw	a5,4(s1)
    800048ca:	06f05163          	blez	a5,8000492c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800048ce:	37fd                	addiw	a5,a5,-1
    800048d0:	0007871b          	sext.w	a4,a5
    800048d4:	c0dc                	sw	a5,4(s1)
    800048d6:	06e04363          	bgtz	a4,8000493c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800048da:	0004a903          	lw	s2,0(s1)
    800048de:	0094ca83          	lbu	s5,9(s1)
    800048e2:	0104ba03          	ld	s4,16(s1)
    800048e6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800048ea:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800048ee:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800048f2:	0001d517          	auipc	a0,0x1d
    800048f6:	7a650513          	addi	a0,a0,1958 # 80022098 <ftable>
    800048fa:	ffffc097          	auipc	ra,0xffffc
    800048fe:	3b6080e7          	jalr	950(ra) # 80000cb0 <release>

  if(ff.type == FD_PIPE){
    80004902:	4785                	li	a5,1
    80004904:	04f90d63          	beq	s2,a5,8000495e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004908:	3979                	addiw	s2,s2,-2
    8000490a:	4785                	li	a5,1
    8000490c:	0527e063          	bltu	a5,s2,8000494c <fileclose+0xa8>
    begin_op();
    80004910:	00000097          	auipc	ra,0x0
    80004914:	ac2080e7          	jalr	-1342(ra) # 800043d2 <begin_op>
    iput(ff.ip);
    80004918:	854e                	mv	a0,s3
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	2b2080e7          	jalr	690(ra) # 80003bcc <iput>
    end_op();
    80004922:	00000097          	auipc	ra,0x0
    80004926:	b30080e7          	jalr	-1232(ra) # 80004452 <end_op>
    8000492a:	a00d                	j	8000494c <fileclose+0xa8>
    panic("fileclose");
    8000492c:	00004517          	auipc	a0,0x4
    80004930:	e2450513          	addi	a0,a0,-476 # 80008750 <syscalls+0x248>
    80004934:	ffffc097          	auipc	ra,0xffffc
    80004938:	c0c080e7          	jalr	-1012(ra) # 80000540 <panic>
    release(&ftable.lock);
    8000493c:	0001d517          	auipc	a0,0x1d
    80004940:	75c50513          	addi	a0,a0,1884 # 80022098 <ftable>
    80004944:	ffffc097          	auipc	ra,0xffffc
    80004948:	36c080e7          	jalr	876(ra) # 80000cb0 <release>
  }
}
    8000494c:	70e2                	ld	ra,56(sp)
    8000494e:	7442                	ld	s0,48(sp)
    80004950:	74a2                	ld	s1,40(sp)
    80004952:	7902                	ld	s2,32(sp)
    80004954:	69e2                	ld	s3,24(sp)
    80004956:	6a42                	ld	s4,16(sp)
    80004958:	6aa2                	ld	s5,8(sp)
    8000495a:	6121                	addi	sp,sp,64
    8000495c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000495e:	85d6                	mv	a1,s5
    80004960:	8552                	mv	a0,s4
    80004962:	00000097          	auipc	ra,0x0
    80004966:	372080e7          	jalr	882(ra) # 80004cd4 <pipeclose>
    8000496a:	b7cd                	j	8000494c <fileclose+0xa8>

000000008000496c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000496c:	715d                	addi	sp,sp,-80
    8000496e:	e486                	sd	ra,72(sp)
    80004970:	e0a2                	sd	s0,64(sp)
    80004972:	fc26                	sd	s1,56(sp)
    80004974:	f84a                	sd	s2,48(sp)
    80004976:	f44e                	sd	s3,40(sp)
    80004978:	0880                	addi	s0,sp,80
    8000497a:	84aa                	mv	s1,a0
    8000497c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000497e:	ffffd097          	auipc	ra,0xffffd
    80004982:	45a080e7          	jalr	1114(ra) # 80001dd8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004986:	409c                	lw	a5,0(s1)
    80004988:	37f9                	addiw	a5,a5,-2
    8000498a:	4705                	li	a4,1
    8000498c:	04f76763          	bltu	a4,a5,800049da <filestat+0x6e>
    80004990:	892a                	mv	s2,a0
    ilock(f->ip);
    80004992:	6c88                	ld	a0,24(s1)
    80004994:	fffff097          	auipc	ra,0xfffff
    80004998:	07e080e7          	jalr	126(ra) # 80003a12 <ilock>
    stati(f->ip, &st);
    8000499c:	fb840593          	addi	a1,s0,-72
    800049a0:	6c88                	ld	a0,24(s1)
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	2fa080e7          	jalr	762(ra) # 80003c9c <stati>
    iunlock(f->ip);
    800049aa:	6c88                	ld	a0,24(s1)
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	128080e7          	jalr	296(ra) # 80003ad4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800049b4:	46e1                	li	a3,24
    800049b6:	fb840613          	addi	a2,s0,-72
    800049ba:	85ce                	mv	a1,s3
    800049bc:	05093503          	ld	a0,80(s2)
    800049c0:	ffffd097          	auipc	ra,0xffffd
    800049c4:	cea080e7          	jalr	-790(ra) # 800016aa <copyout>
    800049c8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800049cc:	60a6                	ld	ra,72(sp)
    800049ce:	6406                	ld	s0,64(sp)
    800049d0:	74e2                	ld	s1,56(sp)
    800049d2:	7942                	ld	s2,48(sp)
    800049d4:	79a2                	ld	s3,40(sp)
    800049d6:	6161                	addi	sp,sp,80
    800049d8:	8082                	ret
  return -1;
    800049da:	557d                	li	a0,-1
    800049dc:	bfc5                	j	800049cc <filestat+0x60>

00000000800049de <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800049de:	7179                	addi	sp,sp,-48
    800049e0:	f406                	sd	ra,40(sp)
    800049e2:	f022                	sd	s0,32(sp)
    800049e4:	ec26                	sd	s1,24(sp)
    800049e6:	e84a                	sd	s2,16(sp)
    800049e8:	e44e                	sd	s3,8(sp)
    800049ea:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800049ec:	00854783          	lbu	a5,8(a0)
    800049f0:	c3d5                	beqz	a5,80004a94 <fileread+0xb6>
    800049f2:	84aa                	mv	s1,a0
    800049f4:	89ae                	mv	s3,a1
    800049f6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800049f8:	411c                	lw	a5,0(a0)
    800049fa:	4705                	li	a4,1
    800049fc:	04e78963          	beq	a5,a4,80004a4e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a00:	470d                	li	a4,3
    80004a02:	04e78d63          	beq	a5,a4,80004a5c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a06:	4709                	li	a4,2
    80004a08:	06e79e63          	bne	a5,a4,80004a84 <fileread+0xa6>
    ilock(f->ip);
    80004a0c:	6d08                	ld	a0,24(a0)
    80004a0e:	fffff097          	auipc	ra,0xfffff
    80004a12:	004080e7          	jalr	4(ra) # 80003a12 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004a16:	874a                	mv	a4,s2
    80004a18:	5094                	lw	a3,32(s1)
    80004a1a:	864e                	mv	a2,s3
    80004a1c:	4585                	li	a1,1
    80004a1e:	6c88                	ld	a0,24(s1)
    80004a20:	fffff097          	auipc	ra,0xfffff
    80004a24:	2a6080e7          	jalr	678(ra) # 80003cc6 <readi>
    80004a28:	892a                	mv	s2,a0
    80004a2a:	00a05563          	blez	a0,80004a34 <fileread+0x56>
      f->off += r;
    80004a2e:	509c                	lw	a5,32(s1)
    80004a30:	9fa9                	addw	a5,a5,a0
    80004a32:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004a34:	6c88                	ld	a0,24(s1)
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	09e080e7          	jalr	158(ra) # 80003ad4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004a3e:	854a                	mv	a0,s2
    80004a40:	70a2                	ld	ra,40(sp)
    80004a42:	7402                	ld	s0,32(sp)
    80004a44:	64e2                	ld	s1,24(sp)
    80004a46:	6942                	ld	s2,16(sp)
    80004a48:	69a2                	ld	s3,8(sp)
    80004a4a:	6145                	addi	sp,sp,48
    80004a4c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004a4e:	6908                	ld	a0,16(a0)
    80004a50:	00000097          	auipc	ra,0x0
    80004a54:	3f4080e7          	jalr	1012(ra) # 80004e44 <piperead>
    80004a58:	892a                	mv	s2,a0
    80004a5a:	b7d5                	j	80004a3e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004a5c:	02451783          	lh	a5,36(a0)
    80004a60:	03079693          	slli	a3,a5,0x30
    80004a64:	92c1                	srli	a3,a3,0x30
    80004a66:	4725                	li	a4,9
    80004a68:	02d76863          	bltu	a4,a3,80004a98 <fileread+0xba>
    80004a6c:	0792                	slli	a5,a5,0x4
    80004a6e:	0001d717          	auipc	a4,0x1d
    80004a72:	58a70713          	addi	a4,a4,1418 # 80021ff8 <devsw>
    80004a76:	97ba                	add	a5,a5,a4
    80004a78:	639c                	ld	a5,0(a5)
    80004a7a:	c38d                	beqz	a5,80004a9c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004a7c:	4505                	li	a0,1
    80004a7e:	9782                	jalr	a5
    80004a80:	892a                	mv	s2,a0
    80004a82:	bf75                	j	80004a3e <fileread+0x60>
    panic("fileread");
    80004a84:	00004517          	auipc	a0,0x4
    80004a88:	cdc50513          	addi	a0,a0,-804 # 80008760 <syscalls+0x258>
    80004a8c:	ffffc097          	auipc	ra,0xffffc
    80004a90:	ab4080e7          	jalr	-1356(ra) # 80000540 <panic>
    return -1;
    80004a94:	597d                	li	s2,-1
    80004a96:	b765                	j	80004a3e <fileread+0x60>
      return -1;
    80004a98:	597d                	li	s2,-1
    80004a9a:	b755                	j	80004a3e <fileread+0x60>
    80004a9c:	597d                	li	s2,-1
    80004a9e:	b745                	j	80004a3e <fileread+0x60>

0000000080004aa0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004aa0:	00954783          	lbu	a5,9(a0)
    80004aa4:	14078563          	beqz	a5,80004bee <filewrite+0x14e>
{
    80004aa8:	715d                	addi	sp,sp,-80
    80004aaa:	e486                	sd	ra,72(sp)
    80004aac:	e0a2                	sd	s0,64(sp)
    80004aae:	fc26                	sd	s1,56(sp)
    80004ab0:	f84a                	sd	s2,48(sp)
    80004ab2:	f44e                	sd	s3,40(sp)
    80004ab4:	f052                	sd	s4,32(sp)
    80004ab6:	ec56                	sd	s5,24(sp)
    80004ab8:	e85a                	sd	s6,16(sp)
    80004aba:	e45e                	sd	s7,8(sp)
    80004abc:	e062                	sd	s8,0(sp)
    80004abe:	0880                	addi	s0,sp,80
    80004ac0:	892a                	mv	s2,a0
    80004ac2:	8aae                	mv	s5,a1
    80004ac4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ac6:	411c                	lw	a5,0(a0)
    80004ac8:	4705                	li	a4,1
    80004aca:	02e78263          	beq	a5,a4,80004aee <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004ace:	470d                	li	a4,3
    80004ad0:	02e78563          	beq	a5,a4,80004afa <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004ad4:	4709                	li	a4,2
    80004ad6:	10e79463          	bne	a5,a4,80004bde <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004ada:	0ec05e63          	blez	a2,80004bd6 <filewrite+0x136>
    int i = 0;
    80004ade:	4981                	li	s3,0
    80004ae0:	6b05                	lui	s6,0x1
    80004ae2:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004ae6:	6b85                	lui	s7,0x1
    80004ae8:	c00b8b9b          	addiw	s7,s7,-1024
    80004aec:	a851                	j	80004b80 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004aee:	6908                	ld	a0,16(a0)
    80004af0:	00000097          	auipc	ra,0x0
    80004af4:	254080e7          	jalr	596(ra) # 80004d44 <pipewrite>
    80004af8:	a85d                	j	80004bae <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004afa:	02451783          	lh	a5,36(a0)
    80004afe:	03079693          	slli	a3,a5,0x30
    80004b02:	92c1                	srli	a3,a3,0x30
    80004b04:	4725                	li	a4,9
    80004b06:	0ed76663          	bltu	a4,a3,80004bf2 <filewrite+0x152>
    80004b0a:	0792                	slli	a5,a5,0x4
    80004b0c:	0001d717          	auipc	a4,0x1d
    80004b10:	4ec70713          	addi	a4,a4,1260 # 80021ff8 <devsw>
    80004b14:	97ba                	add	a5,a5,a4
    80004b16:	679c                	ld	a5,8(a5)
    80004b18:	cff9                	beqz	a5,80004bf6 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004b1a:	4505                	li	a0,1
    80004b1c:	9782                	jalr	a5
    80004b1e:	a841                	j	80004bae <filewrite+0x10e>
    80004b20:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004b24:	00000097          	auipc	ra,0x0
    80004b28:	8ae080e7          	jalr	-1874(ra) # 800043d2 <begin_op>
      ilock(f->ip);
    80004b2c:	01893503          	ld	a0,24(s2)
    80004b30:	fffff097          	auipc	ra,0xfffff
    80004b34:	ee2080e7          	jalr	-286(ra) # 80003a12 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004b38:	8762                	mv	a4,s8
    80004b3a:	02092683          	lw	a3,32(s2)
    80004b3e:	01598633          	add	a2,s3,s5
    80004b42:	4585                	li	a1,1
    80004b44:	01893503          	ld	a0,24(s2)
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	274080e7          	jalr	628(ra) # 80003dbc <writei>
    80004b50:	84aa                	mv	s1,a0
    80004b52:	02a05f63          	blez	a0,80004b90 <filewrite+0xf0>
        f->off += r;
    80004b56:	02092783          	lw	a5,32(s2)
    80004b5a:	9fa9                	addw	a5,a5,a0
    80004b5c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004b60:	01893503          	ld	a0,24(s2)
    80004b64:	fffff097          	auipc	ra,0xfffff
    80004b68:	f70080e7          	jalr	-144(ra) # 80003ad4 <iunlock>
      end_op();
    80004b6c:	00000097          	auipc	ra,0x0
    80004b70:	8e6080e7          	jalr	-1818(ra) # 80004452 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004b74:	049c1963          	bne	s8,s1,80004bc6 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004b78:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004b7c:	0349d663          	bge	s3,s4,80004ba8 <filewrite+0x108>
      int n1 = n - i;
    80004b80:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004b84:	84be                	mv	s1,a5
    80004b86:	2781                	sext.w	a5,a5
    80004b88:	f8fb5ce3          	bge	s6,a5,80004b20 <filewrite+0x80>
    80004b8c:	84de                	mv	s1,s7
    80004b8e:	bf49                	j	80004b20 <filewrite+0x80>
      iunlock(f->ip);
    80004b90:	01893503          	ld	a0,24(s2)
    80004b94:	fffff097          	auipc	ra,0xfffff
    80004b98:	f40080e7          	jalr	-192(ra) # 80003ad4 <iunlock>
      end_op();
    80004b9c:	00000097          	auipc	ra,0x0
    80004ba0:	8b6080e7          	jalr	-1866(ra) # 80004452 <end_op>
      if(r < 0)
    80004ba4:	fc04d8e3          	bgez	s1,80004b74 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004ba8:	8552                	mv	a0,s4
    80004baa:	033a1863          	bne	s4,s3,80004bda <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004bae:	60a6                	ld	ra,72(sp)
    80004bb0:	6406                	ld	s0,64(sp)
    80004bb2:	74e2                	ld	s1,56(sp)
    80004bb4:	7942                	ld	s2,48(sp)
    80004bb6:	79a2                	ld	s3,40(sp)
    80004bb8:	7a02                	ld	s4,32(sp)
    80004bba:	6ae2                	ld	s5,24(sp)
    80004bbc:	6b42                	ld	s6,16(sp)
    80004bbe:	6ba2                	ld	s7,8(sp)
    80004bc0:	6c02                	ld	s8,0(sp)
    80004bc2:	6161                	addi	sp,sp,80
    80004bc4:	8082                	ret
        panic("short filewrite");
    80004bc6:	00004517          	auipc	a0,0x4
    80004bca:	baa50513          	addi	a0,a0,-1110 # 80008770 <syscalls+0x268>
    80004bce:	ffffc097          	auipc	ra,0xffffc
    80004bd2:	972080e7          	jalr	-1678(ra) # 80000540 <panic>
    int i = 0;
    80004bd6:	4981                	li	s3,0
    80004bd8:	bfc1                	j	80004ba8 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004bda:	557d                	li	a0,-1
    80004bdc:	bfc9                	j	80004bae <filewrite+0x10e>
    panic("filewrite");
    80004bde:	00004517          	auipc	a0,0x4
    80004be2:	ba250513          	addi	a0,a0,-1118 # 80008780 <syscalls+0x278>
    80004be6:	ffffc097          	auipc	ra,0xffffc
    80004bea:	95a080e7          	jalr	-1702(ra) # 80000540 <panic>
    return -1;
    80004bee:	557d                	li	a0,-1
}
    80004bf0:	8082                	ret
      return -1;
    80004bf2:	557d                	li	a0,-1
    80004bf4:	bf6d                	j	80004bae <filewrite+0x10e>
    80004bf6:	557d                	li	a0,-1
    80004bf8:	bf5d                	j	80004bae <filewrite+0x10e>

0000000080004bfa <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004bfa:	7179                	addi	sp,sp,-48
    80004bfc:	f406                	sd	ra,40(sp)
    80004bfe:	f022                	sd	s0,32(sp)
    80004c00:	ec26                	sd	s1,24(sp)
    80004c02:	e84a                	sd	s2,16(sp)
    80004c04:	e44e                	sd	s3,8(sp)
    80004c06:	e052                	sd	s4,0(sp)
    80004c08:	1800                	addi	s0,sp,48
    80004c0a:	84aa                	mv	s1,a0
    80004c0c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004c0e:	0005b023          	sd	zero,0(a1)
    80004c12:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004c16:	00000097          	auipc	ra,0x0
    80004c1a:	bd2080e7          	jalr	-1070(ra) # 800047e8 <filealloc>
    80004c1e:	e088                	sd	a0,0(s1)
    80004c20:	c551                	beqz	a0,80004cac <pipealloc+0xb2>
    80004c22:	00000097          	auipc	ra,0x0
    80004c26:	bc6080e7          	jalr	-1082(ra) # 800047e8 <filealloc>
    80004c2a:	00aa3023          	sd	a0,0(s4)
    80004c2e:	c92d                	beqz	a0,80004ca0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004c30:	ffffc097          	auipc	ra,0xffffc
    80004c34:	edc080e7          	jalr	-292(ra) # 80000b0c <kalloc>
    80004c38:	892a                	mv	s2,a0
    80004c3a:	c125                	beqz	a0,80004c9a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004c3c:	4985                	li	s3,1
    80004c3e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004c42:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004c46:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004c4a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004c4e:	00004597          	auipc	a1,0x4
    80004c52:	b4258593          	addi	a1,a1,-1214 # 80008790 <syscalls+0x288>
    80004c56:	ffffc097          	auipc	ra,0xffffc
    80004c5a:	f16080e7          	jalr	-234(ra) # 80000b6c <initlock>
  (*f0)->type = FD_PIPE;
    80004c5e:	609c                	ld	a5,0(s1)
    80004c60:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004c64:	609c                	ld	a5,0(s1)
    80004c66:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004c6a:	609c                	ld	a5,0(s1)
    80004c6c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004c70:	609c                	ld	a5,0(s1)
    80004c72:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004c76:	000a3783          	ld	a5,0(s4)
    80004c7a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004c7e:	000a3783          	ld	a5,0(s4)
    80004c82:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004c86:	000a3783          	ld	a5,0(s4)
    80004c8a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004c8e:	000a3783          	ld	a5,0(s4)
    80004c92:	0127b823          	sd	s2,16(a5)
  return 0;
    80004c96:	4501                	li	a0,0
    80004c98:	a025                	j	80004cc0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004c9a:	6088                	ld	a0,0(s1)
    80004c9c:	e501                	bnez	a0,80004ca4 <pipealloc+0xaa>
    80004c9e:	a039                	j	80004cac <pipealloc+0xb2>
    80004ca0:	6088                	ld	a0,0(s1)
    80004ca2:	c51d                	beqz	a0,80004cd0 <pipealloc+0xd6>
    fileclose(*f0);
    80004ca4:	00000097          	auipc	ra,0x0
    80004ca8:	c00080e7          	jalr	-1024(ra) # 800048a4 <fileclose>
  if(*f1)
    80004cac:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004cb0:	557d                	li	a0,-1
  if(*f1)
    80004cb2:	c799                	beqz	a5,80004cc0 <pipealloc+0xc6>
    fileclose(*f1);
    80004cb4:	853e                	mv	a0,a5
    80004cb6:	00000097          	auipc	ra,0x0
    80004cba:	bee080e7          	jalr	-1042(ra) # 800048a4 <fileclose>
  return -1;
    80004cbe:	557d                	li	a0,-1
}
    80004cc0:	70a2                	ld	ra,40(sp)
    80004cc2:	7402                	ld	s0,32(sp)
    80004cc4:	64e2                	ld	s1,24(sp)
    80004cc6:	6942                	ld	s2,16(sp)
    80004cc8:	69a2                	ld	s3,8(sp)
    80004cca:	6a02                	ld	s4,0(sp)
    80004ccc:	6145                	addi	sp,sp,48
    80004cce:	8082                	ret
  return -1;
    80004cd0:	557d                	li	a0,-1
    80004cd2:	b7fd                	j	80004cc0 <pipealloc+0xc6>

0000000080004cd4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004cd4:	1101                	addi	sp,sp,-32
    80004cd6:	ec06                	sd	ra,24(sp)
    80004cd8:	e822                	sd	s0,16(sp)
    80004cda:	e426                	sd	s1,8(sp)
    80004cdc:	e04a                	sd	s2,0(sp)
    80004cde:	1000                	addi	s0,sp,32
    80004ce0:	84aa                	mv	s1,a0
    80004ce2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004ce4:	ffffc097          	auipc	ra,0xffffc
    80004ce8:	f18080e7          	jalr	-232(ra) # 80000bfc <acquire>
  if(writable){
    80004cec:	02090d63          	beqz	s2,80004d26 <pipeclose+0x52>
    pi->writeopen = 0;
    80004cf0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004cf4:	21848513          	addi	a0,s1,536
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	9ee080e7          	jalr	-1554(ra) # 800026e6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004d00:	2204b783          	ld	a5,544(s1)
    80004d04:	eb95                	bnez	a5,80004d38 <pipeclose+0x64>
    release(&pi->lock);
    80004d06:	8526                	mv	a0,s1
    80004d08:	ffffc097          	auipc	ra,0xffffc
    80004d0c:	fa8080e7          	jalr	-88(ra) # 80000cb0 <release>
    kfree((char*)pi);
    80004d10:	8526                	mv	a0,s1
    80004d12:	ffffc097          	auipc	ra,0xffffc
    80004d16:	cfe080e7          	jalr	-770(ra) # 80000a10 <kfree>
  } else
    release(&pi->lock);
}
    80004d1a:	60e2                	ld	ra,24(sp)
    80004d1c:	6442                	ld	s0,16(sp)
    80004d1e:	64a2                	ld	s1,8(sp)
    80004d20:	6902                	ld	s2,0(sp)
    80004d22:	6105                	addi	sp,sp,32
    80004d24:	8082                	ret
    pi->readopen = 0;
    80004d26:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004d2a:	21c48513          	addi	a0,s1,540
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	9b8080e7          	jalr	-1608(ra) # 800026e6 <wakeup>
    80004d36:	b7e9                	j	80004d00 <pipeclose+0x2c>
    release(&pi->lock);
    80004d38:	8526                	mv	a0,s1
    80004d3a:	ffffc097          	auipc	ra,0xffffc
    80004d3e:	f76080e7          	jalr	-138(ra) # 80000cb0 <release>
}
    80004d42:	bfe1                	j	80004d1a <pipeclose+0x46>

0000000080004d44 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004d44:	711d                	addi	sp,sp,-96
    80004d46:	ec86                	sd	ra,88(sp)
    80004d48:	e8a2                	sd	s0,80(sp)
    80004d4a:	e4a6                	sd	s1,72(sp)
    80004d4c:	e0ca                	sd	s2,64(sp)
    80004d4e:	fc4e                	sd	s3,56(sp)
    80004d50:	f852                	sd	s4,48(sp)
    80004d52:	f456                	sd	s5,40(sp)
    80004d54:	f05a                	sd	s6,32(sp)
    80004d56:	ec5e                	sd	s7,24(sp)
    80004d58:	e862                	sd	s8,16(sp)
    80004d5a:	1080                	addi	s0,sp,96
    80004d5c:	84aa                	mv	s1,a0
    80004d5e:	8b2e                	mv	s6,a1
    80004d60:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004d62:	ffffd097          	auipc	ra,0xffffd
    80004d66:	076080e7          	jalr	118(ra) # 80001dd8 <myproc>
    80004d6a:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004d6c:	8526                	mv	a0,s1
    80004d6e:	ffffc097          	auipc	ra,0xffffc
    80004d72:	e8e080e7          	jalr	-370(ra) # 80000bfc <acquire>
  for(i = 0; i < n; i++){
    80004d76:	09505763          	blez	s5,80004e04 <pipewrite+0xc0>
    80004d7a:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004d7c:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004d80:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d84:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004d86:	2184a783          	lw	a5,536(s1)
    80004d8a:	21c4a703          	lw	a4,540(s1)
    80004d8e:	2007879b          	addiw	a5,a5,512
    80004d92:	02f71b63          	bne	a4,a5,80004dc8 <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    80004d96:	2204a783          	lw	a5,544(s1)
    80004d9a:	c3d1                	beqz	a5,80004e1e <pipewrite+0xda>
    80004d9c:	03092783          	lw	a5,48(s2)
    80004da0:	efbd                	bnez	a5,80004e1e <pipewrite+0xda>
      wakeup(&pi->nread);
    80004da2:	8552                	mv	a0,s4
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	942080e7          	jalr	-1726(ra) # 800026e6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004dac:	85a6                	mv	a1,s1
    80004dae:	854e                	mv	a0,s3
    80004db0:	ffffd097          	auipc	ra,0xffffd
    80004db4:	7b6080e7          	jalr	1974(ra) # 80002566 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004db8:	2184a783          	lw	a5,536(s1)
    80004dbc:	21c4a703          	lw	a4,540(s1)
    80004dc0:	2007879b          	addiw	a5,a5,512
    80004dc4:	fcf709e3          	beq	a4,a5,80004d96 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004dc8:	4685                	li	a3,1
    80004dca:	865a                	mv	a2,s6
    80004dcc:	faf40593          	addi	a1,s0,-81
    80004dd0:	05093503          	ld	a0,80(s2)
    80004dd4:	ffffd097          	auipc	ra,0xffffd
    80004dd8:	962080e7          	jalr	-1694(ra) # 80001736 <copyin>
    80004ddc:	03850563          	beq	a0,s8,80004e06 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004de0:	21c4a783          	lw	a5,540(s1)
    80004de4:	0017871b          	addiw	a4,a5,1
    80004de8:	20e4ae23          	sw	a4,540(s1)
    80004dec:	1ff7f793          	andi	a5,a5,511
    80004df0:	97a6                	add	a5,a5,s1
    80004df2:	faf44703          	lbu	a4,-81(s0)
    80004df6:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004dfa:	2b85                	addiw	s7,s7,1
    80004dfc:	0b05                	addi	s6,s6,1
    80004dfe:	f97a94e3          	bne	s5,s7,80004d86 <pipewrite+0x42>
    80004e02:	a011                	j	80004e06 <pipewrite+0xc2>
    80004e04:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    80004e06:	21848513          	addi	a0,s1,536
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	8dc080e7          	jalr	-1828(ra) # 800026e6 <wakeup>
  release(&pi->lock);
    80004e12:	8526                	mv	a0,s1
    80004e14:	ffffc097          	auipc	ra,0xffffc
    80004e18:	e9c080e7          	jalr	-356(ra) # 80000cb0 <release>
  return i;
    80004e1c:	a039                	j	80004e2a <pipewrite+0xe6>
        release(&pi->lock);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	ffffc097          	auipc	ra,0xffffc
    80004e24:	e90080e7          	jalr	-368(ra) # 80000cb0 <release>
        return -1;
    80004e28:	5bfd                	li	s7,-1
}
    80004e2a:	855e                	mv	a0,s7
    80004e2c:	60e6                	ld	ra,88(sp)
    80004e2e:	6446                	ld	s0,80(sp)
    80004e30:	64a6                	ld	s1,72(sp)
    80004e32:	6906                	ld	s2,64(sp)
    80004e34:	79e2                	ld	s3,56(sp)
    80004e36:	7a42                	ld	s4,48(sp)
    80004e38:	7aa2                	ld	s5,40(sp)
    80004e3a:	7b02                	ld	s6,32(sp)
    80004e3c:	6be2                	ld	s7,24(sp)
    80004e3e:	6c42                	ld	s8,16(sp)
    80004e40:	6125                	addi	sp,sp,96
    80004e42:	8082                	ret

0000000080004e44 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004e44:	715d                	addi	sp,sp,-80
    80004e46:	e486                	sd	ra,72(sp)
    80004e48:	e0a2                	sd	s0,64(sp)
    80004e4a:	fc26                	sd	s1,56(sp)
    80004e4c:	f84a                	sd	s2,48(sp)
    80004e4e:	f44e                	sd	s3,40(sp)
    80004e50:	f052                	sd	s4,32(sp)
    80004e52:	ec56                	sd	s5,24(sp)
    80004e54:	e85a                	sd	s6,16(sp)
    80004e56:	0880                	addi	s0,sp,80
    80004e58:	84aa                	mv	s1,a0
    80004e5a:	892e                	mv	s2,a1
    80004e5c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004e5e:	ffffd097          	auipc	ra,0xffffd
    80004e62:	f7a080e7          	jalr	-134(ra) # 80001dd8 <myproc>
    80004e66:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004e68:	8526                	mv	a0,s1
    80004e6a:	ffffc097          	auipc	ra,0xffffc
    80004e6e:	d92080e7          	jalr	-622(ra) # 80000bfc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e72:	2184a703          	lw	a4,536(s1)
    80004e76:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e7a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e7e:	02f71463          	bne	a4,a5,80004ea6 <piperead+0x62>
    80004e82:	2244a783          	lw	a5,548(s1)
    80004e86:	c385                	beqz	a5,80004ea6 <piperead+0x62>
    if(pr->killed){
    80004e88:	030a2783          	lw	a5,48(s4)
    80004e8c:	ebc1                	bnez	a5,80004f1c <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e8e:	85a6                	mv	a1,s1
    80004e90:	854e                	mv	a0,s3
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	6d4080e7          	jalr	1748(ra) # 80002566 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e9a:	2184a703          	lw	a4,536(s1)
    80004e9e:	21c4a783          	lw	a5,540(s1)
    80004ea2:	fef700e3          	beq	a4,a5,80004e82 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ea6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ea8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004eaa:	05505363          	blez	s5,80004ef0 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004eae:	2184a783          	lw	a5,536(s1)
    80004eb2:	21c4a703          	lw	a4,540(s1)
    80004eb6:	02f70d63          	beq	a4,a5,80004ef0 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004eba:	0017871b          	addiw	a4,a5,1
    80004ebe:	20e4ac23          	sw	a4,536(s1)
    80004ec2:	1ff7f793          	andi	a5,a5,511
    80004ec6:	97a6                	add	a5,a5,s1
    80004ec8:	0187c783          	lbu	a5,24(a5)
    80004ecc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ed0:	4685                	li	a3,1
    80004ed2:	fbf40613          	addi	a2,s0,-65
    80004ed6:	85ca                	mv	a1,s2
    80004ed8:	050a3503          	ld	a0,80(s4)
    80004edc:	ffffc097          	auipc	ra,0xffffc
    80004ee0:	7ce080e7          	jalr	1998(ra) # 800016aa <copyout>
    80004ee4:	01650663          	beq	a0,s6,80004ef0 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ee8:	2985                	addiw	s3,s3,1
    80004eea:	0905                	addi	s2,s2,1
    80004eec:	fd3a91e3          	bne	s5,s3,80004eae <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ef0:	21c48513          	addi	a0,s1,540
    80004ef4:	ffffd097          	auipc	ra,0xffffd
    80004ef8:	7f2080e7          	jalr	2034(ra) # 800026e6 <wakeup>
  release(&pi->lock);
    80004efc:	8526                	mv	a0,s1
    80004efe:	ffffc097          	auipc	ra,0xffffc
    80004f02:	db2080e7          	jalr	-590(ra) # 80000cb0 <release>
  return i;
}
    80004f06:	854e                	mv	a0,s3
    80004f08:	60a6                	ld	ra,72(sp)
    80004f0a:	6406                	ld	s0,64(sp)
    80004f0c:	74e2                	ld	s1,56(sp)
    80004f0e:	7942                	ld	s2,48(sp)
    80004f10:	79a2                	ld	s3,40(sp)
    80004f12:	7a02                	ld	s4,32(sp)
    80004f14:	6ae2                	ld	s5,24(sp)
    80004f16:	6b42                	ld	s6,16(sp)
    80004f18:	6161                	addi	sp,sp,80
    80004f1a:	8082                	ret
      release(&pi->lock);
    80004f1c:	8526                	mv	a0,s1
    80004f1e:	ffffc097          	auipc	ra,0xffffc
    80004f22:	d92080e7          	jalr	-622(ra) # 80000cb0 <release>
      return -1;
    80004f26:	59fd                	li	s3,-1
    80004f28:	bff9                	j	80004f06 <piperead+0xc2>

0000000080004f2a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004f2a:	de010113          	addi	sp,sp,-544
    80004f2e:	20113c23          	sd	ra,536(sp)
    80004f32:	20813823          	sd	s0,528(sp)
    80004f36:	20913423          	sd	s1,520(sp)
    80004f3a:	21213023          	sd	s2,512(sp)
    80004f3e:	ffce                	sd	s3,504(sp)
    80004f40:	fbd2                	sd	s4,496(sp)
    80004f42:	f7d6                	sd	s5,488(sp)
    80004f44:	f3da                	sd	s6,480(sp)
    80004f46:	efde                	sd	s7,472(sp)
    80004f48:	ebe2                	sd	s8,464(sp)
    80004f4a:	e7e6                	sd	s9,456(sp)
    80004f4c:	e3ea                	sd	s10,448(sp)
    80004f4e:	ff6e                	sd	s11,440(sp)
    80004f50:	1400                	addi	s0,sp,544
    80004f52:	892a                	mv	s2,a0
    80004f54:	dea43423          	sd	a0,-536(s0)
    80004f58:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004f5c:	ffffd097          	auipc	ra,0xffffd
    80004f60:	e7c080e7          	jalr	-388(ra) # 80001dd8 <myproc>
    80004f64:	84aa                	mv	s1,a0

  begin_op();
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	46c080e7          	jalr	1132(ra) # 800043d2 <begin_op>

  if((ip = namei(path)) == 0){
    80004f6e:	854a                	mv	a0,s2
    80004f70:	fffff097          	auipc	ra,0xfffff
    80004f74:	252080e7          	jalr	594(ra) # 800041c2 <namei>
    80004f78:	c93d                	beqz	a0,80004fee <exec+0xc4>
    80004f7a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004f7c:	fffff097          	auipc	ra,0xfffff
    80004f80:	a96080e7          	jalr	-1386(ra) # 80003a12 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004f84:	04000713          	li	a4,64
    80004f88:	4681                	li	a3,0
    80004f8a:	e4840613          	addi	a2,s0,-440
    80004f8e:	4581                	li	a1,0
    80004f90:	8556                	mv	a0,s5
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	d34080e7          	jalr	-716(ra) # 80003cc6 <readi>
    80004f9a:	04000793          	li	a5,64
    80004f9e:	00f51a63          	bne	a0,a5,80004fb2 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004fa2:	e4842703          	lw	a4,-440(s0)
    80004fa6:	464c47b7          	lui	a5,0x464c4
    80004faa:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004fae:	04f70663          	beq	a4,a5,80004ffa <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004fb2:	8556                	mv	a0,s5
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	cc0080e7          	jalr	-832(ra) # 80003c74 <iunlockput>
    end_op();
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	496080e7          	jalr	1174(ra) # 80004452 <end_op>
  }
  return -1;
    80004fc4:	557d                	li	a0,-1
}
    80004fc6:	21813083          	ld	ra,536(sp)
    80004fca:	21013403          	ld	s0,528(sp)
    80004fce:	20813483          	ld	s1,520(sp)
    80004fd2:	20013903          	ld	s2,512(sp)
    80004fd6:	79fe                	ld	s3,504(sp)
    80004fd8:	7a5e                	ld	s4,496(sp)
    80004fda:	7abe                	ld	s5,488(sp)
    80004fdc:	7b1e                	ld	s6,480(sp)
    80004fde:	6bfe                	ld	s7,472(sp)
    80004fe0:	6c5e                	ld	s8,464(sp)
    80004fe2:	6cbe                	ld	s9,456(sp)
    80004fe4:	6d1e                	ld	s10,448(sp)
    80004fe6:	7dfa                	ld	s11,440(sp)
    80004fe8:	22010113          	addi	sp,sp,544
    80004fec:	8082                	ret
    end_op();
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	464080e7          	jalr	1124(ra) # 80004452 <end_op>
    return -1;
    80004ff6:	557d                	li	a0,-1
    80004ff8:	b7f9                	j	80004fc6 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004ffa:	8526                	mv	a0,s1
    80004ffc:	ffffd097          	auipc	ra,0xffffd
    80005000:	ea0080e7          	jalr	-352(ra) # 80001e9c <proc_pagetable>
    80005004:	8b2a                	mv	s6,a0
    80005006:	d555                	beqz	a0,80004fb2 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005008:	e6842783          	lw	a5,-408(s0)
    8000500c:	e8045703          	lhu	a4,-384(s0)
    80005010:	c735                	beqz	a4,8000507c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005012:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005014:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005018:	6a05                	lui	s4,0x1
    8000501a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000501e:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80005022:	6d85                	lui	s11,0x1
    80005024:	7d7d                	lui	s10,0xfffff
    80005026:	ac1d                	j	8000525c <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005028:	00003517          	auipc	a0,0x3
    8000502c:	77050513          	addi	a0,a0,1904 # 80008798 <syscalls+0x290>
    80005030:	ffffb097          	auipc	ra,0xffffb
    80005034:	510080e7          	jalr	1296(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005038:	874a                	mv	a4,s2
    8000503a:	009c86bb          	addw	a3,s9,s1
    8000503e:	4581                	li	a1,0
    80005040:	8556                	mv	a0,s5
    80005042:	fffff097          	auipc	ra,0xfffff
    80005046:	c84080e7          	jalr	-892(ra) # 80003cc6 <readi>
    8000504a:	2501                	sext.w	a0,a0
    8000504c:	1aa91863          	bne	s2,a0,800051fc <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80005050:	009d84bb          	addw	s1,s11,s1
    80005054:	013d09bb          	addw	s3,s10,s3
    80005058:	1f74f263          	bgeu	s1,s7,8000523c <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000505c:	02049593          	slli	a1,s1,0x20
    80005060:	9181                	srli	a1,a1,0x20
    80005062:	95e2                	add	a1,a1,s8
    80005064:	855a                	mv	a0,s6
    80005066:	ffffc097          	auipc	ra,0xffffc
    8000506a:	010080e7          	jalr	16(ra) # 80001076 <walkaddr>
    8000506e:	862a                	mv	a2,a0
    if(pa == 0)
    80005070:	dd45                	beqz	a0,80005028 <exec+0xfe>
      n = PGSIZE;
    80005072:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005074:	fd49f2e3          	bgeu	s3,s4,80005038 <exec+0x10e>
      n = sz - i;
    80005078:	894e                	mv	s2,s3
    8000507a:	bf7d                	j	80005038 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    8000507c:	4481                	li	s1,0
  iunlockput(ip);
    8000507e:	8556                	mv	a0,s5
    80005080:	fffff097          	auipc	ra,0xfffff
    80005084:	bf4080e7          	jalr	-1036(ra) # 80003c74 <iunlockput>
  end_op();
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	3ca080e7          	jalr	970(ra) # 80004452 <end_op>
  p = myproc();
    80005090:	ffffd097          	auipc	ra,0xffffd
    80005094:	d48080e7          	jalr	-696(ra) # 80001dd8 <myproc>
    80005098:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000509a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000509e:	6785                	lui	a5,0x1
    800050a0:	17fd                	addi	a5,a5,-1
    800050a2:	94be                	add	s1,s1,a5
    800050a4:	77fd                	lui	a5,0xfffff
    800050a6:	8fe5                	and	a5,a5,s1
    800050a8:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800050ac:	6609                	lui	a2,0x2
    800050ae:	963e                	add	a2,a2,a5
    800050b0:	85be                	mv	a1,a5
    800050b2:	855a                	mv	a0,s6
    800050b4:	ffffc097          	auipc	ra,0xffffc
    800050b8:	3a6080e7          	jalr	934(ra) # 8000145a <uvmalloc>
    800050bc:	8c2a                	mv	s8,a0
  ip = 0;
    800050be:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800050c0:	12050e63          	beqz	a0,800051fc <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800050c4:	75f9                	lui	a1,0xffffe
    800050c6:	95aa                	add	a1,a1,a0
    800050c8:	855a                	mv	a0,s6
    800050ca:	ffffc097          	auipc	ra,0xffffc
    800050ce:	5ae080e7          	jalr	1454(ra) # 80001678 <uvmclear>
  stackbase = sp - PGSIZE;
    800050d2:	7afd                	lui	s5,0xfffff
    800050d4:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800050d6:	df043783          	ld	a5,-528(s0)
    800050da:	6388                	ld	a0,0(a5)
    800050dc:	c925                	beqz	a0,8000514c <exec+0x222>
    800050de:	e8840993          	addi	s3,s0,-376
    800050e2:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    800050e6:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800050e8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800050ea:	ffffc097          	auipc	ra,0xffffc
    800050ee:	d92080e7          	jalr	-622(ra) # 80000e7c <strlen>
    800050f2:	0015079b          	addiw	a5,a0,1
    800050f6:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800050fa:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800050fe:	13596363          	bltu	s2,s5,80005224 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005102:	df043d83          	ld	s11,-528(s0)
    80005106:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000510a:	8552                	mv	a0,s4
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	d70080e7          	jalr	-656(ra) # 80000e7c <strlen>
    80005114:	0015069b          	addiw	a3,a0,1
    80005118:	8652                	mv	a2,s4
    8000511a:	85ca                	mv	a1,s2
    8000511c:	855a                	mv	a0,s6
    8000511e:	ffffc097          	auipc	ra,0xffffc
    80005122:	58c080e7          	jalr	1420(ra) # 800016aa <copyout>
    80005126:	10054363          	bltz	a0,8000522c <exec+0x302>
    ustack[argc] = sp;
    8000512a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000512e:	0485                	addi	s1,s1,1
    80005130:	008d8793          	addi	a5,s11,8
    80005134:	def43823          	sd	a5,-528(s0)
    80005138:	008db503          	ld	a0,8(s11)
    8000513c:	c911                	beqz	a0,80005150 <exec+0x226>
    if(argc >= MAXARG)
    8000513e:	09a1                	addi	s3,s3,8
    80005140:	fb3c95e3          	bne	s9,s3,800050ea <exec+0x1c0>
  sz = sz1;
    80005144:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005148:	4a81                	li	s5,0
    8000514a:	a84d                	j	800051fc <exec+0x2d2>
  sp = sz;
    8000514c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000514e:	4481                	li	s1,0
  ustack[argc] = 0;
    80005150:	00349793          	slli	a5,s1,0x3
    80005154:	f9040713          	addi	a4,s0,-112
    80005158:	97ba                	add	a5,a5,a4
    8000515a:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd7ef8>
  sp -= (argc+1) * sizeof(uint64);
    8000515e:	00148693          	addi	a3,s1,1
    80005162:	068e                	slli	a3,a3,0x3
    80005164:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005168:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000516c:	01597663          	bgeu	s2,s5,80005178 <exec+0x24e>
  sz = sz1;
    80005170:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005174:	4a81                	li	s5,0
    80005176:	a059                	j	800051fc <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005178:	e8840613          	addi	a2,s0,-376
    8000517c:	85ca                	mv	a1,s2
    8000517e:	855a                	mv	a0,s6
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	52a080e7          	jalr	1322(ra) # 800016aa <copyout>
    80005188:	0a054663          	bltz	a0,80005234 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000518c:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80005190:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005194:	de843783          	ld	a5,-536(s0)
    80005198:	0007c703          	lbu	a4,0(a5)
    8000519c:	cf11                	beqz	a4,800051b8 <exec+0x28e>
    8000519e:	0785                	addi	a5,a5,1
    if(*s == '/')
    800051a0:	02f00693          	li	a3,47
    800051a4:	a039                	j	800051b2 <exec+0x288>
      last = s+1;
    800051a6:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800051aa:	0785                	addi	a5,a5,1
    800051ac:	fff7c703          	lbu	a4,-1(a5)
    800051b0:	c701                	beqz	a4,800051b8 <exec+0x28e>
    if(*s == '/')
    800051b2:	fed71ce3          	bne	a4,a3,800051aa <exec+0x280>
    800051b6:	bfc5                	j	800051a6 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800051b8:	4641                	li	a2,16
    800051ba:	de843583          	ld	a1,-536(s0)
    800051be:	158b8513          	addi	a0,s7,344
    800051c2:	ffffc097          	auipc	ra,0xffffc
    800051c6:	c88080e7          	jalr	-888(ra) # 80000e4a <safestrcpy>
  oldpagetable = p->pagetable;
    800051ca:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800051ce:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800051d2:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800051d6:	058bb783          	ld	a5,88(s7)
    800051da:	e6043703          	ld	a4,-416(s0)
    800051de:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800051e0:	058bb783          	ld	a5,88(s7)
    800051e4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800051e8:	85ea                	mv	a1,s10
    800051ea:	ffffd097          	auipc	ra,0xffffd
    800051ee:	d4e080e7          	jalr	-690(ra) # 80001f38 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800051f2:	0004851b          	sext.w	a0,s1
    800051f6:	bbc1                	j	80004fc6 <exec+0x9c>
    800051f8:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800051fc:	df843583          	ld	a1,-520(s0)
    80005200:	855a                	mv	a0,s6
    80005202:	ffffd097          	auipc	ra,0xffffd
    80005206:	d36080e7          	jalr	-714(ra) # 80001f38 <proc_freepagetable>
  if(ip){
    8000520a:	da0a94e3          	bnez	s5,80004fb2 <exec+0x88>
  return -1;
    8000520e:	557d                	li	a0,-1
    80005210:	bb5d                	j	80004fc6 <exec+0x9c>
    80005212:	de943c23          	sd	s1,-520(s0)
    80005216:	b7dd                	j	800051fc <exec+0x2d2>
    80005218:	de943c23          	sd	s1,-520(s0)
    8000521c:	b7c5                	j	800051fc <exec+0x2d2>
    8000521e:	de943c23          	sd	s1,-520(s0)
    80005222:	bfe9                	j	800051fc <exec+0x2d2>
  sz = sz1;
    80005224:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005228:	4a81                	li	s5,0
    8000522a:	bfc9                	j	800051fc <exec+0x2d2>
  sz = sz1;
    8000522c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005230:	4a81                	li	s5,0
    80005232:	b7e9                	j	800051fc <exec+0x2d2>
  sz = sz1;
    80005234:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005238:	4a81                	li	s5,0
    8000523a:	b7c9                	j	800051fc <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000523c:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005240:	e0843783          	ld	a5,-504(s0)
    80005244:	0017869b          	addiw	a3,a5,1
    80005248:	e0d43423          	sd	a3,-504(s0)
    8000524c:	e0043783          	ld	a5,-512(s0)
    80005250:	0387879b          	addiw	a5,a5,56
    80005254:	e8045703          	lhu	a4,-384(s0)
    80005258:	e2e6d3e3          	bge	a3,a4,8000507e <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000525c:	2781                	sext.w	a5,a5
    8000525e:	e0f43023          	sd	a5,-512(s0)
    80005262:	03800713          	li	a4,56
    80005266:	86be                	mv	a3,a5
    80005268:	e1040613          	addi	a2,s0,-496
    8000526c:	4581                	li	a1,0
    8000526e:	8556                	mv	a0,s5
    80005270:	fffff097          	auipc	ra,0xfffff
    80005274:	a56080e7          	jalr	-1450(ra) # 80003cc6 <readi>
    80005278:	03800793          	li	a5,56
    8000527c:	f6f51ee3          	bne	a0,a5,800051f8 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80005280:	e1042783          	lw	a5,-496(s0)
    80005284:	4705                	li	a4,1
    80005286:	fae79de3          	bne	a5,a4,80005240 <exec+0x316>
    if(ph.memsz < ph.filesz)
    8000528a:	e3843603          	ld	a2,-456(s0)
    8000528e:	e3043783          	ld	a5,-464(s0)
    80005292:	f8f660e3          	bltu	a2,a5,80005212 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005296:	e2043783          	ld	a5,-480(s0)
    8000529a:	963e                	add	a2,a2,a5
    8000529c:	f6f66ee3          	bltu	a2,a5,80005218 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800052a0:	85a6                	mv	a1,s1
    800052a2:	855a                	mv	a0,s6
    800052a4:	ffffc097          	auipc	ra,0xffffc
    800052a8:	1b6080e7          	jalr	438(ra) # 8000145a <uvmalloc>
    800052ac:	dea43c23          	sd	a0,-520(s0)
    800052b0:	d53d                	beqz	a0,8000521e <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    800052b2:	e2043c03          	ld	s8,-480(s0)
    800052b6:	de043783          	ld	a5,-544(s0)
    800052ba:	00fc77b3          	and	a5,s8,a5
    800052be:	ff9d                	bnez	a5,800051fc <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800052c0:	e1842c83          	lw	s9,-488(s0)
    800052c4:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800052c8:	f60b8ae3          	beqz	s7,8000523c <exec+0x312>
    800052cc:	89de                	mv	s3,s7
    800052ce:	4481                	li	s1,0
    800052d0:	b371                	j	8000505c <exec+0x132>

00000000800052d2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800052d2:	7179                	addi	sp,sp,-48
    800052d4:	f406                	sd	ra,40(sp)
    800052d6:	f022                	sd	s0,32(sp)
    800052d8:	ec26                	sd	s1,24(sp)
    800052da:	e84a                	sd	s2,16(sp)
    800052dc:	1800                	addi	s0,sp,48
    800052de:	892e                	mv	s2,a1
    800052e0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800052e2:	fdc40593          	addi	a1,s0,-36
    800052e6:	ffffe097          	auipc	ra,0xffffe
    800052ea:	b74080e7          	jalr	-1164(ra) # 80002e5a <argint>
    800052ee:	04054063          	bltz	a0,8000532e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800052f2:	fdc42703          	lw	a4,-36(s0)
    800052f6:	47bd                	li	a5,15
    800052f8:	02e7ed63          	bltu	a5,a4,80005332 <argfd+0x60>
    800052fc:	ffffd097          	auipc	ra,0xffffd
    80005300:	adc080e7          	jalr	-1316(ra) # 80001dd8 <myproc>
    80005304:	fdc42703          	lw	a4,-36(s0)
    80005308:	01a70793          	addi	a5,a4,26
    8000530c:	078e                	slli	a5,a5,0x3
    8000530e:	953e                	add	a0,a0,a5
    80005310:	611c                	ld	a5,0(a0)
    80005312:	c395                	beqz	a5,80005336 <argfd+0x64>
    return -1;
  if(pfd)
    80005314:	00090463          	beqz	s2,8000531c <argfd+0x4a>
    *pfd = fd;
    80005318:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000531c:	4501                	li	a0,0
  if(pf)
    8000531e:	c091                	beqz	s1,80005322 <argfd+0x50>
    *pf = f;
    80005320:	e09c                	sd	a5,0(s1)
}
    80005322:	70a2                	ld	ra,40(sp)
    80005324:	7402                	ld	s0,32(sp)
    80005326:	64e2                	ld	s1,24(sp)
    80005328:	6942                	ld	s2,16(sp)
    8000532a:	6145                	addi	sp,sp,48
    8000532c:	8082                	ret
    return -1;
    8000532e:	557d                	li	a0,-1
    80005330:	bfcd                	j	80005322 <argfd+0x50>
    return -1;
    80005332:	557d                	li	a0,-1
    80005334:	b7fd                	j	80005322 <argfd+0x50>
    80005336:	557d                	li	a0,-1
    80005338:	b7ed                	j	80005322 <argfd+0x50>

000000008000533a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000533a:	1101                	addi	sp,sp,-32
    8000533c:	ec06                	sd	ra,24(sp)
    8000533e:	e822                	sd	s0,16(sp)
    80005340:	e426                	sd	s1,8(sp)
    80005342:	1000                	addi	s0,sp,32
    80005344:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005346:	ffffd097          	auipc	ra,0xffffd
    8000534a:	a92080e7          	jalr	-1390(ra) # 80001dd8 <myproc>
    8000534e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005350:	0d050793          	addi	a5,a0,208
    80005354:	4501                	li	a0,0
    80005356:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005358:	6398                	ld	a4,0(a5)
    8000535a:	cb19                	beqz	a4,80005370 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000535c:	2505                	addiw	a0,a0,1
    8000535e:	07a1                	addi	a5,a5,8
    80005360:	fed51ce3          	bne	a0,a3,80005358 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005364:	557d                	li	a0,-1
}
    80005366:	60e2                	ld	ra,24(sp)
    80005368:	6442                	ld	s0,16(sp)
    8000536a:	64a2                	ld	s1,8(sp)
    8000536c:	6105                	addi	sp,sp,32
    8000536e:	8082                	ret
      p->ofile[fd] = f;
    80005370:	01a50793          	addi	a5,a0,26
    80005374:	078e                	slli	a5,a5,0x3
    80005376:	963e                	add	a2,a2,a5
    80005378:	e204                	sd	s1,0(a2)
      return fd;
    8000537a:	b7f5                	j	80005366 <fdalloc+0x2c>

000000008000537c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000537c:	715d                	addi	sp,sp,-80
    8000537e:	e486                	sd	ra,72(sp)
    80005380:	e0a2                	sd	s0,64(sp)
    80005382:	fc26                	sd	s1,56(sp)
    80005384:	f84a                	sd	s2,48(sp)
    80005386:	f44e                	sd	s3,40(sp)
    80005388:	f052                	sd	s4,32(sp)
    8000538a:	ec56                	sd	s5,24(sp)
    8000538c:	0880                	addi	s0,sp,80
    8000538e:	89ae                	mv	s3,a1
    80005390:	8ab2                	mv	s5,a2
    80005392:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005394:	fb040593          	addi	a1,s0,-80
    80005398:	fffff097          	auipc	ra,0xfffff
    8000539c:	e48080e7          	jalr	-440(ra) # 800041e0 <nameiparent>
    800053a0:	892a                	mv	s2,a0
    800053a2:	12050e63          	beqz	a0,800054de <create+0x162>
    return 0;

  ilock(dp);
    800053a6:	ffffe097          	auipc	ra,0xffffe
    800053aa:	66c080e7          	jalr	1644(ra) # 80003a12 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800053ae:	4601                	li	a2,0
    800053b0:	fb040593          	addi	a1,s0,-80
    800053b4:	854a                	mv	a0,s2
    800053b6:	fffff097          	auipc	ra,0xfffff
    800053ba:	b3a080e7          	jalr	-1222(ra) # 80003ef0 <dirlookup>
    800053be:	84aa                	mv	s1,a0
    800053c0:	c921                	beqz	a0,80005410 <create+0x94>
    iunlockput(dp);
    800053c2:	854a                	mv	a0,s2
    800053c4:	fffff097          	auipc	ra,0xfffff
    800053c8:	8b0080e7          	jalr	-1872(ra) # 80003c74 <iunlockput>
    ilock(ip);
    800053cc:	8526                	mv	a0,s1
    800053ce:	ffffe097          	auipc	ra,0xffffe
    800053d2:	644080e7          	jalr	1604(ra) # 80003a12 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800053d6:	2981                	sext.w	s3,s3
    800053d8:	4789                	li	a5,2
    800053da:	02f99463          	bne	s3,a5,80005402 <create+0x86>
    800053de:	0444d783          	lhu	a5,68(s1)
    800053e2:	37f9                	addiw	a5,a5,-2
    800053e4:	17c2                	slli	a5,a5,0x30
    800053e6:	93c1                	srli	a5,a5,0x30
    800053e8:	4705                	li	a4,1
    800053ea:	00f76c63          	bltu	a4,a5,80005402 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800053ee:	8526                	mv	a0,s1
    800053f0:	60a6                	ld	ra,72(sp)
    800053f2:	6406                	ld	s0,64(sp)
    800053f4:	74e2                	ld	s1,56(sp)
    800053f6:	7942                	ld	s2,48(sp)
    800053f8:	79a2                	ld	s3,40(sp)
    800053fa:	7a02                	ld	s4,32(sp)
    800053fc:	6ae2                	ld	s5,24(sp)
    800053fe:	6161                	addi	sp,sp,80
    80005400:	8082                	ret
    iunlockput(ip);
    80005402:	8526                	mv	a0,s1
    80005404:	fffff097          	auipc	ra,0xfffff
    80005408:	870080e7          	jalr	-1936(ra) # 80003c74 <iunlockput>
    return 0;
    8000540c:	4481                	li	s1,0
    8000540e:	b7c5                	j	800053ee <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005410:	85ce                	mv	a1,s3
    80005412:	00092503          	lw	a0,0(s2)
    80005416:	ffffe097          	auipc	ra,0xffffe
    8000541a:	464080e7          	jalr	1124(ra) # 8000387a <ialloc>
    8000541e:	84aa                	mv	s1,a0
    80005420:	c521                	beqz	a0,80005468 <create+0xec>
  ilock(ip);
    80005422:	ffffe097          	auipc	ra,0xffffe
    80005426:	5f0080e7          	jalr	1520(ra) # 80003a12 <ilock>
  ip->major = major;
    8000542a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000542e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005432:	4a05                	li	s4,1
    80005434:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005438:	8526                	mv	a0,s1
    8000543a:	ffffe097          	auipc	ra,0xffffe
    8000543e:	50e080e7          	jalr	1294(ra) # 80003948 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005442:	2981                	sext.w	s3,s3
    80005444:	03498a63          	beq	s3,s4,80005478 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005448:	40d0                	lw	a2,4(s1)
    8000544a:	fb040593          	addi	a1,s0,-80
    8000544e:	854a                	mv	a0,s2
    80005450:	fffff097          	auipc	ra,0xfffff
    80005454:	cb0080e7          	jalr	-848(ra) # 80004100 <dirlink>
    80005458:	06054b63          	bltz	a0,800054ce <create+0x152>
  iunlockput(dp);
    8000545c:	854a                	mv	a0,s2
    8000545e:	fffff097          	auipc	ra,0xfffff
    80005462:	816080e7          	jalr	-2026(ra) # 80003c74 <iunlockput>
  return ip;
    80005466:	b761                	j	800053ee <create+0x72>
    panic("create: ialloc");
    80005468:	00003517          	auipc	a0,0x3
    8000546c:	35050513          	addi	a0,a0,848 # 800087b8 <syscalls+0x2b0>
    80005470:	ffffb097          	auipc	ra,0xffffb
    80005474:	0d0080e7          	jalr	208(ra) # 80000540 <panic>
    dp->nlink++;  // for ".."
    80005478:	04a95783          	lhu	a5,74(s2)
    8000547c:	2785                	addiw	a5,a5,1
    8000547e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005482:	854a                	mv	a0,s2
    80005484:	ffffe097          	auipc	ra,0xffffe
    80005488:	4c4080e7          	jalr	1220(ra) # 80003948 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000548c:	40d0                	lw	a2,4(s1)
    8000548e:	00003597          	auipc	a1,0x3
    80005492:	33a58593          	addi	a1,a1,826 # 800087c8 <syscalls+0x2c0>
    80005496:	8526                	mv	a0,s1
    80005498:	fffff097          	auipc	ra,0xfffff
    8000549c:	c68080e7          	jalr	-920(ra) # 80004100 <dirlink>
    800054a0:	00054f63          	bltz	a0,800054be <create+0x142>
    800054a4:	00492603          	lw	a2,4(s2)
    800054a8:	00003597          	auipc	a1,0x3
    800054ac:	32858593          	addi	a1,a1,808 # 800087d0 <syscalls+0x2c8>
    800054b0:	8526                	mv	a0,s1
    800054b2:	fffff097          	auipc	ra,0xfffff
    800054b6:	c4e080e7          	jalr	-946(ra) # 80004100 <dirlink>
    800054ba:	f80557e3          	bgez	a0,80005448 <create+0xcc>
      panic("create dots");
    800054be:	00003517          	auipc	a0,0x3
    800054c2:	31a50513          	addi	a0,a0,794 # 800087d8 <syscalls+0x2d0>
    800054c6:	ffffb097          	auipc	ra,0xffffb
    800054ca:	07a080e7          	jalr	122(ra) # 80000540 <panic>
    panic("create: dirlink");
    800054ce:	00003517          	auipc	a0,0x3
    800054d2:	31a50513          	addi	a0,a0,794 # 800087e8 <syscalls+0x2e0>
    800054d6:	ffffb097          	auipc	ra,0xffffb
    800054da:	06a080e7          	jalr	106(ra) # 80000540 <panic>
    return 0;
    800054de:	84aa                	mv	s1,a0
    800054e0:	b739                	j	800053ee <create+0x72>

00000000800054e2 <sys_dup>:
{
    800054e2:	7179                	addi	sp,sp,-48
    800054e4:	f406                	sd	ra,40(sp)
    800054e6:	f022                	sd	s0,32(sp)
    800054e8:	ec26                	sd	s1,24(sp)
    800054ea:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800054ec:	fd840613          	addi	a2,s0,-40
    800054f0:	4581                	li	a1,0
    800054f2:	4501                	li	a0,0
    800054f4:	00000097          	auipc	ra,0x0
    800054f8:	dde080e7          	jalr	-546(ra) # 800052d2 <argfd>
    return -1;
    800054fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800054fe:	02054363          	bltz	a0,80005524 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005502:	fd843503          	ld	a0,-40(s0)
    80005506:	00000097          	auipc	ra,0x0
    8000550a:	e34080e7          	jalr	-460(ra) # 8000533a <fdalloc>
    8000550e:	84aa                	mv	s1,a0
    return -1;
    80005510:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005512:	00054963          	bltz	a0,80005524 <sys_dup+0x42>
  filedup(f);
    80005516:	fd843503          	ld	a0,-40(s0)
    8000551a:	fffff097          	auipc	ra,0xfffff
    8000551e:	338080e7          	jalr	824(ra) # 80004852 <filedup>
  return fd;
    80005522:	87a6                	mv	a5,s1
}
    80005524:	853e                	mv	a0,a5
    80005526:	70a2                	ld	ra,40(sp)
    80005528:	7402                	ld	s0,32(sp)
    8000552a:	64e2                	ld	s1,24(sp)
    8000552c:	6145                	addi	sp,sp,48
    8000552e:	8082                	ret

0000000080005530 <sys_read>:
{
    80005530:	7179                	addi	sp,sp,-48
    80005532:	f406                	sd	ra,40(sp)
    80005534:	f022                	sd	s0,32(sp)
    80005536:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005538:	fe840613          	addi	a2,s0,-24
    8000553c:	4581                	li	a1,0
    8000553e:	4501                	li	a0,0
    80005540:	00000097          	auipc	ra,0x0
    80005544:	d92080e7          	jalr	-622(ra) # 800052d2 <argfd>
    return -1;
    80005548:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000554a:	04054163          	bltz	a0,8000558c <sys_read+0x5c>
    8000554e:	fe440593          	addi	a1,s0,-28
    80005552:	4509                	li	a0,2
    80005554:	ffffe097          	auipc	ra,0xffffe
    80005558:	906080e7          	jalr	-1786(ra) # 80002e5a <argint>
    return -1;
    8000555c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000555e:	02054763          	bltz	a0,8000558c <sys_read+0x5c>
    80005562:	fd840593          	addi	a1,s0,-40
    80005566:	4505                	li	a0,1
    80005568:	ffffe097          	auipc	ra,0xffffe
    8000556c:	914080e7          	jalr	-1772(ra) # 80002e7c <argaddr>
    return -1;
    80005570:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005572:	00054d63          	bltz	a0,8000558c <sys_read+0x5c>
  return fileread(f, p, n);
    80005576:	fe442603          	lw	a2,-28(s0)
    8000557a:	fd843583          	ld	a1,-40(s0)
    8000557e:	fe843503          	ld	a0,-24(s0)
    80005582:	fffff097          	auipc	ra,0xfffff
    80005586:	45c080e7          	jalr	1116(ra) # 800049de <fileread>
    8000558a:	87aa                	mv	a5,a0
}
    8000558c:	853e                	mv	a0,a5
    8000558e:	70a2                	ld	ra,40(sp)
    80005590:	7402                	ld	s0,32(sp)
    80005592:	6145                	addi	sp,sp,48
    80005594:	8082                	ret

0000000080005596 <sys_write>:
{
    80005596:	7179                	addi	sp,sp,-48
    80005598:	f406                	sd	ra,40(sp)
    8000559a:	f022                	sd	s0,32(sp)
    8000559c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000559e:	fe840613          	addi	a2,s0,-24
    800055a2:	4581                	li	a1,0
    800055a4:	4501                	li	a0,0
    800055a6:	00000097          	auipc	ra,0x0
    800055aa:	d2c080e7          	jalr	-724(ra) # 800052d2 <argfd>
    return -1;
    800055ae:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055b0:	04054163          	bltz	a0,800055f2 <sys_write+0x5c>
    800055b4:	fe440593          	addi	a1,s0,-28
    800055b8:	4509                	li	a0,2
    800055ba:	ffffe097          	auipc	ra,0xffffe
    800055be:	8a0080e7          	jalr	-1888(ra) # 80002e5a <argint>
    return -1;
    800055c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055c4:	02054763          	bltz	a0,800055f2 <sys_write+0x5c>
    800055c8:	fd840593          	addi	a1,s0,-40
    800055cc:	4505                	li	a0,1
    800055ce:	ffffe097          	auipc	ra,0xffffe
    800055d2:	8ae080e7          	jalr	-1874(ra) # 80002e7c <argaddr>
    return -1;
    800055d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055d8:	00054d63          	bltz	a0,800055f2 <sys_write+0x5c>
  return filewrite(f, p, n);
    800055dc:	fe442603          	lw	a2,-28(s0)
    800055e0:	fd843583          	ld	a1,-40(s0)
    800055e4:	fe843503          	ld	a0,-24(s0)
    800055e8:	fffff097          	auipc	ra,0xfffff
    800055ec:	4b8080e7          	jalr	1208(ra) # 80004aa0 <filewrite>
    800055f0:	87aa                	mv	a5,a0
}
    800055f2:	853e                	mv	a0,a5
    800055f4:	70a2                	ld	ra,40(sp)
    800055f6:	7402                	ld	s0,32(sp)
    800055f8:	6145                	addi	sp,sp,48
    800055fa:	8082                	ret

00000000800055fc <sys_close>:
{
    800055fc:	1101                	addi	sp,sp,-32
    800055fe:	ec06                	sd	ra,24(sp)
    80005600:	e822                	sd	s0,16(sp)
    80005602:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005604:	fe040613          	addi	a2,s0,-32
    80005608:	fec40593          	addi	a1,s0,-20
    8000560c:	4501                	li	a0,0
    8000560e:	00000097          	auipc	ra,0x0
    80005612:	cc4080e7          	jalr	-828(ra) # 800052d2 <argfd>
    return -1;
    80005616:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005618:	02054463          	bltz	a0,80005640 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000561c:	ffffc097          	auipc	ra,0xffffc
    80005620:	7bc080e7          	jalr	1980(ra) # 80001dd8 <myproc>
    80005624:	fec42783          	lw	a5,-20(s0)
    80005628:	07e9                	addi	a5,a5,26
    8000562a:	078e                	slli	a5,a5,0x3
    8000562c:	97aa                	add	a5,a5,a0
    8000562e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005632:	fe043503          	ld	a0,-32(s0)
    80005636:	fffff097          	auipc	ra,0xfffff
    8000563a:	26e080e7          	jalr	622(ra) # 800048a4 <fileclose>
  return 0;
    8000563e:	4781                	li	a5,0
}
    80005640:	853e                	mv	a0,a5
    80005642:	60e2                	ld	ra,24(sp)
    80005644:	6442                	ld	s0,16(sp)
    80005646:	6105                	addi	sp,sp,32
    80005648:	8082                	ret

000000008000564a <sys_fstat>:
{
    8000564a:	1101                	addi	sp,sp,-32
    8000564c:	ec06                	sd	ra,24(sp)
    8000564e:	e822                	sd	s0,16(sp)
    80005650:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005652:	fe840613          	addi	a2,s0,-24
    80005656:	4581                	li	a1,0
    80005658:	4501                	li	a0,0
    8000565a:	00000097          	auipc	ra,0x0
    8000565e:	c78080e7          	jalr	-904(ra) # 800052d2 <argfd>
    return -1;
    80005662:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005664:	02054563          	bltz	a0,8000568e <sys_fstat+0x44>
    80005668:	fe040593          	addi	a1,s0,-32
    8000566c:	4505                	li	a0,1
    8000566e:	ffffe097          	auipc	ra,0xffffe
    80005672:	80e080e7          	jalr	-2034(ra) # 80002e7c <argaddr>
    return -1;
    80005676:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005678:	00054b63          	bltz	a0,8000568e <sys_fstat+0x44>
  return filestat(f, st);
    8000567c:	fe043583          	ld	a1,-32(s0)
    80005680:	fe843503          	ld	a0,-24(s0)
    80005684:	fffff097          	auipc	ra,0xfffff
    80005688:	2e8080e7          	jalr	744(ra) # 8000496c <filestat>
    8000568c:	87aa                	mv	a5,a0
}
    8000568e:	853e                	mv	a0,a5
    80005690:	60e2                	ld	ra,24(sp)
    80005692:	6442                	ld	s0,16(sp)
    80005694:	6105                	addi	sp,sp,32
    80005696:	8082                	ret

0000000080005698 <sys_link>:
{
    80005698:	7169                	addi	sp,sp,-304
    8000569a:	f606                	sd	ra,296(sp)
    8000569c:	f222                	sd	s0,288(sp)
    8000569e:	ee26                	sd	s1,280(sp)
    800056a0:	ea4a                	sd	s2,272(sp)
    800056a2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056a4:	08000613          	li	a2,128
    800056a8:	ed040593          	addi	a1,s0,-304
    800056ac:	4501                	li	a0,0
    800056ae:	ffffd097          	auipc	ra,0xffffd
    800056b2:	7f0080e7          	jalr	2032(ra) # 80002e9e <argstr>
    return -1;
    800056b6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056b8:	10054e63          	bltz	a0,800057d4 <sys_link+0x13c>
    800056bc:	08000613          	li	a2,128
    800056c0:	f5040593          	addi	a1,s0,-176
    800056c4:	4505                	li	a0,1
    800056c6:	ffffd097          	auipc	ra,0xffffd
    800056ca:	7d8080e7          	jalr	2008(ra) # 80002e9e <argstr>
    return -1;
    800056ce:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056d0:	10054263          	bltz	a0,800057d4 <sys_link+0x13c>
  begin_op();
    800056d4:	fffff097          	auipc	ra,0xfffff
    800056d8:	cfe080e7          	jalr	-770(ra) # 800043d2 <begin_op>
  if((ip = namei(old)) == 0){
    800056dc:	ed040513          	addi	a0,s0,-304
    800056e0:	fffff097          	auipc	ra,0xfffff
    800056e4:	ae2080e7          	jalr	-1310(ra) # 800041c2 <namei>
    800056e8:	84aa                	mv	s1,a0
    800056ea:	c551                	beqz	a0,80005776 <sys_link+0xde>
  ilock(ip);
    800056ec:	ffffe097          	auipc	ra,0xffffe
    800056f0:	326080e7          	jalr	806(ra) # 80003a12 <ilock>
  if(ip->type == T_DIR){
    800056f4:	04449703          	lh	a4,68(s1)
    800056f8:	4785                	li	a5,1
    800056fa:	08f70463          	beq	a4,a5,80005782 <sys_link+0xea>
  ip->nlink++;
    800056fe:	04a4d783          	lhu	a5,74(s1)
    80005702:	2785                	addiw	a5,a5,1
    80005704:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005708:	8526                	mv	a0,s1
    8000570a:	ffffe097          	auipc	ra,0xffffe
    8000570e:	23e080e7          	jalr	574(ra) # 80003948 <iupdate>
  iunlock(ip);
    80005712:	8526                	mv	a0,s1
    80005714:	ffffe097          	auipc	ra,0xffffe
    80005718:	3c0080e7          	jalr	960(ra) # 80003ad4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000571c:	fd040593          	addi	a1,s0,-48
    80005720:	f5040513          	addi	a0,s0,-176
    80005724:	fffff097          	auipc	ra,0xfffff
    80005728:	abc080e7          	jalr	-1348(ra) # 800041e0 <nameiparent>
    8000572c:	892a                	mv	s2,a0
    8000572e:	c935                	beqz	a0,800057a2 <sys_link+0x10a>
  ilock(dp);
    80005730:	ffffe097          	auipc	ra,0xffffe
    80005734:	2e2080e7          	jalr	738(ra) # 80003a12 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005738:	00092703          	lw	a4,0(s2)
    8000573c:	409c                	lw	a5,0(s1)
    8000573e:	04f71d63          	bne	a4,a5,80005798 <sys_link+0x100>
    80005742:	40d0                	lw	a2,4(s1)
    80005744:	fd040593          	addi	a1,s0,-48
    80005748:	854a                	mv	a0,s2
    8000574a:	fffff097          	auipc	ra,0xfffff
    8000574e:	9b6080e7          	jalr	-1610(ra) # 80004100 <dirlink>
    80005752:	04054363          	bltz	a0,80005798 <sys_link+0x100>
  iunlockput(dp);
    80005756:	854a                	mv	a0,s2
    80005758:	ffffe097          	auipc	ra,0xffffe
    8000575c:	51c080e7          	jalr	1308(ra) # 80003c74 <iunlockput>
  iput(ip);
    80005760:	8526                	mv	a0,s1
    80005762:	ffffe097          	auipc	ra,0xffffe
    80005766:	46a080e7          	jalr	1130(ra) # 80003bcc <iput>
  end_op();
    8000576a:	fffff097          	auipc	ra,0xfffff
    8000576e:	ce8080e7          	jalr	-792(ra) # 80004452 <end_op>
  return 0;
    80005772:	4781                	li	a5,0
    80005774:	a085                	j	800057d4 <sys_link+0x13c>
    end_op();
    80005776:	fffff097          	auipc	ra,0xfffff
    8000577a:	cdc080e7          	jalr	-804(ra) # 80004452 <end_op>
    return -1;
    8000577e:	57fd                	li	a5,-1
    80005780:	a891                	j	800057d4 <sys_link+0x13c>
    iunlockput(ip);
    80005782:	8526                	mv	a0,s1
    80005784:	ffffe097          	auipc	ra,0xffffe
    80005788:	4f0080e7          	jalr	1264(ra) # 80003c74 <iunlockput>
    end_op();
    8000578c:	fffff097          	auipc	ra,0xfffff
    80005790:	cc6080e7          	jalr	-826(ra) # 80004452 <end_op>
    return -1;
    80005794:	57fd                	li	a5,-1
    80005796:	a83d                	j	800057d4 <sys_link+0x13c>
    iunlockput(dp);
    80005798:	854a                	mv	a0,s2
    8000579a:	ffffe097          	auipc	ra,0xffffe
    8000579e:	4da080e7          	jalr	1242(ra) # 80003c74 <iunlockput>
  ilock(ip);
    800057a2:	8526                	mv	a0,s1
    800057a4:	ffffe097          	auipc	ra,0xffffe
    800057a8:	26e080e7          	jalr	622(ra) # 80003a12 <ilock>
  ip->nlink--;
    800057ac:	04a4d783          	lhu	a5,74(s1)
    800057b0:	37fd                	addiw	a5,a5,-1
    800057b2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057b6:	8526                	mv	a0,s1
    800057b8:	ffffe097          	auipc	ra,0xffffe
    800057bc:	190080e7          	jalr	400(ra) # 80003948 <iupdate>
  iunlockput(ip);
    800057c0:	8526                	mv	a0,s1
    800057c2:	ffffe097          	auipc	ra,0xffffe
    800057c6:	4b2080e7          	jalr	1202(ra) # 80003c74 <iunlockput>
  end_op();
    800057ca:	fffff097          	auipc	ra,0xfffff
    800057ce:	c88080e7          	jalr	-888(ra) # 80004452 <end_op>
  return -1;
    800057d2:	57fd                	li	a5,-1
}
    800057d4:	853e                	mv	a0,a5
    800057d6:	70b2                	ld	ra,296(sp)
    800057d8:	7412                	ld	s0,288(sp)
    800057da:	64f2                	ld	s1,280(sp)
    800057dc:	6952                	ld	s2,272(sp)
    800057de:	6155                	addi	sp,sp,304
    800057e0:	8082                	ret

00000000800057e2 <sys_unlink>:
{
    800057e2:	7151                	addi	sp,sp,-240
    800057e4:	f586                	sd	ra,232(sp)
    800057e6:	f1a2                	sd	s0,224(sp)
    800057e8:	eda6                	sd	s1,216(sp)
    800057ea:	e9ca                	sd	s2,208(sp)
    800057ec:	e5ce                	sd	s3,200(sp)
    800057ee:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800057f0:	08000613          	li	a2,128
    800057f4:	f3040593          	addi	a1,s0,-208
    800057f8:	4501                	li	a0,0
    800057fa:	ffffd097          	auipc	ra,0xffffd
    800057fe:	6a4080e7          	jalr	1700(ra) # 80002e9e <argstr>
    80005802:	18054163          	bltz	a0,80005984 <sys_unlink+0x1a2>
  begin_op();
    80005806:	fffff097          	auipc	ra,0xfffff
    8000580a:	bcc080e7          	jalr	-1076(ra) # 800043d2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000580e:	fb040593          	addi	a1,s0,-80
    80005812:	f3040513          	addi	a0,s0,-208
    80005816:	fffff097          	auipc	ra,0xfffff
    8000581a:	9ca080e7          	jalr	-1590(ra) # 800041e0 <nameiparent>
    8000581e:	84aa                	mv	s1,a0
    80005820:	c979                	beqz	a0,800058f6 <sys_unlink+0x114>
  ilock(dp);
    80005822:	ffffe097          	auipc	ra,0xffffe
    80005826:	1f0080e7          	jalr	496(ra) # 80003a12 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000582a:	00003597          	auipc	a1,0x3
    8000582e:	f9e58593          	addi	a1,a1,-98 # 800087c8 <syscalls+0x2c0>
    80005832:	fb040513          	addi	a0,s0,-80
    80005836:	ffffe097          	auipc	ra,0xffffe
    8000583a:	6a0080e7          	jalr	1696(ra) # 80003ed6 <namecmp>
    8000583e:	14050a63          	beqz	a0,80005992 <sys_unlink+0x1b0>
    80005842:	00003597          	auipc	a1,0x3
    80005846:	f8e58593          	addi	a1,a1,-114 # 800087d0 <syscalls+0x2c8>
    8000584a:	fb040513          	addi	a0,s0,-80
    8000584e:	ffffe097          	auipc	ra,0xffffe
    80005852:	688080e7          	jalr	1672(ra) # 80003ed6 <namecmp>
    80005856:	12050e63          	beqz	a0,80005992 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000585a:	f2c40613          	addi	a2,s0,-212
    8000585e:	fb040593          	addi	a1,s0,-80
    80005862:	8526                	mv	a0,s1
    80005864:	ffffe097          	auipc	ra,0xffffe
    80005868:	68c080e7          	jalr	1676(ra) # 80003ef0 <dirlookup>
    8000586c:	892a                	mv	s2,a0
    8000586e:	12050263          	beqz	a0,80005992 <sys_unlink+0x1b0>
  ilock(ip);
    80005872:	ffffe097          	auipc	ra,0xffffe
    80005876:	1a0080e7          	jalr	416(ra) # 80003a12 <ilock>
  if(ip->nlink < 1)
    8000587a:	04a91783          	lh	a5,74(s2)
    8000587e:	08f05263          	blez	a5,80005902 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005882:	04491703          	lh	a4,68(s2)
    80005886:	4785                	li	a5,1
    80005888:	08f70563          	beq	a4,a5,80005912 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000588c:	4641                	li	a2,16
    8000588e:	4581                	li	a1,0
    80005890:	fc040513          	addi	a0,s0,-64
    80005894:	ffffb097          	auipc	ra,0xffffb
    80005898:	464080e7          	jalr	1124(ra) # 80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000589c:	4741                	li	a4,16
    8000589e:	f2c42683          	lw	a3,-212(s0)
    800058a2:	fc040613          	addi	a2,s0,-64
    800058a6:	4581                	li	a1,0
    800058a8:	8526                	mv	a0,s1
    800058aa:	ffffe097          	auipc	ra,0xffffe
    800058ae:	512080e7          	jalr	1298(ra) # 80003dbc <writei>
    800058b2:	47c1                	li	a5,16
    800058b4:	0af51563          	bne	a0,a5,8000595e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800058b8:	04491703          	lh	a4,68(s2)
    800058bc:	4785                	li	a5,1
    800058be:	0af70863          	beq	a4,a5,8000596e <sys_unlink+0x18c>
  iunlockput(dp);
    800058c2:	8526                	mv	a0,s1
    800058c4:	ffffe097          	auipc	ra,0xffffe
    800058c8:	3b0080e7          	jalr	944(ra) # 80003c74 <iunlockput>
  ip->nlink--;
    800058cc:	04a95783          	lhu	a5,74(s2)
    800058d0:	37fd                	addiw	a5,a5,-1
    800058d2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800058d6:	854a                	mv	a0,s2
    800058d8:	ffffe097          	auipc	ra,0xffffe
    800058dc:	070080e7          	jalr	112(ra) # 80003948 <iupdate>
  iunlockput(ip);
    800058e0:	854a                	mv	a0,s2
    800058e2:	ffffe097          	auipc	ra,0xffffe
    800058e6:	392080e7          	jalr	914(ra) # 80003c74 <iunlockput>
  end_op();
    800058ea:	fffff097          	auipc	ra,0xfffff
    800058ee:	b68080e7          	jalr	-1176(ra) # 80004452 <end_op>
  return 0;
    800058f2:	4501                	li	a0,0
    800058f4:	a84d                	j	800059a6 <sys_unlink+0x1c4>
    end_op();
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	b5c080e7          	jalr	-1188(ra) # 80004452 <end_op>
    return -1;
    800058fe:	557d                	li	a0,-1
    80005900:	a05d                	j	800059a6 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005902:	00003517          	auipc	a0,0x3
    80005906:	ef650513          	addi	a0,a0,-266 # 800087f8 <syscalls+0x2f0>
    8000590a:	ffffb097          	auipc	ra,0xffffb
    8000590e:	c36080e7          	jalr	-970(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005912:	04c92703          	lw	a4,76(s2)
    80005916:	02000793          	li	a5,32
    8000591a:	f6e7f9e3          	bgeu	a5,a4,8000588c <sys_unlink+0xaa>
    8000591e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005922:	4741                	li	a4,16
    80005924:	86ce                	mv	a3,s3
    80005926:	f1840613          	addi	a2,s0,-232
    8000592a:	4581                	li	a1,0
    8000592c:	854a                	mv	a0,s2
    8000592e:	ffffe097          	auipc	ra,0xffffe
    80005932:	398080e7          	jalr	920(ra) # 80003cc6 <readi>
    80005936:	47c1                	li	a5,16
    80005938:	00f51b63          	bne	a0,a5,8000594e <sys_unlink+0x16c>
    if(de.inum != 0)
    8000593c:	f1845783          	lhu	a5,-232(s0)
    80005940:	e7a1                	bnez	a5,80005988 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005942:	29c1                	addiw	s3,s3,16
    80005944:	04c92783          	lw	a5,76(s2)
    80005948:	fcf9ede3          	bltu	s3,a5,80005922 <sys_unlink+0x140>
    8000594c:	b781                	j	8000588c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000594e:	00003517          	auipc	a0,0x3
    80005952:	ec250513          	addi	a0,a0,-318 # 80008810 <syscalls+0x308>
    80005956:	ffffb097          	auipc	ra,0xffffb
    8000595a:	bea080e7          	jalr	-1046(ra) # 80000540 <panic>
    panic("unlink: writei");
    8000595e:	00003517          	auipc	a0,0x3
    80005962:	eca50513          	addi	a0,a0,-310 # 80008828 <syscalls+0x320>
    80005966:	ffffb097          	auipc	ra,0xffffb
    8000596a:	bda080e7          	jalr	-1062(ra) # 80000540 <panic>
    dp->nlink--;
    8000596e:	04a4d783          	lhu	a5,74(s1)
    80005972:	37fd                	addiw	a5,a5,-1
    80005974:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005978:	8526                	mv	a0,s1
    8000597a:	ffffe097          	auipc	ra,0xffffe
    8000597e:	fce080e7          	jalr	-50(ra) # 80003948 <iupdate>
    80005982:	b781                	j	800058c2 <sys_unlink+0xe0>
    return -1;
    80005984:	557d                	li	a0,-1
    80005986:	a005                	j	800059a6 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005988:	854a                	mv	a0,s2
    8000598a:	ffffe097          	auipc	ra,0xffffe
    8000598e:	2ea080e7          	jalr	746(ra) # 80003c74 <iunlockput>
  iunlockput(dp);
    80005992:	8526                	mv	a0,s1
    80005994:	ffffe097          	auipc	ra,0xffffe
    80005998:	2e0080e7          	jalr	736(ra) # 80003c74 <iunlockput>
  end_op();
    8000599c:	fffff097          	auipc	ra,0xfffff
    800059a0:	ab6080e7          	jalr	-1354(ra) # 80004452 <end_op>
  return -1;
    800059a4:	557d                	li	a0,-1
}
    800059a6:	70ae                	ld	ra,232(sp)
    800059a8:	740e                	ld	s0,224(sp)
    800059aa:	64ee                	ld	s1,216(sp)
    800059ac:	694e                	ld	s2,208(sp)
    800059ae:	69ae                	ld	s3,200(sp)
    800059b0:	616d                	addi	sp,sp,240
    800059b2:	8082                	ret

00000000800059b4 <sys_open>:

uint64
sys_open(void)
{
    800059b4:	7131                	addi	sp,sp,-192
    800059b6:	fd06                	sd	ra,184(sp)
    800059b8:	f922                	sd	s0,176(sp)
    800059ba:	f526                	sd	s1,168(sp)
    800059bc:	f14a                	sd	s2,160(sp)
    800059be:	ed4e                	sd	s3,152(sp)
    800059c0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800059c2:	08000613          	li	a2,128
    800059c6:	f5040593          	addi	a1,s0,-176
    800059ca:	4501                	li	a0,0
    800059cc:	ffffd097          	auipc	ra,0xffffd
    800059d0:	4d2080e7          	jalr	1234(ra) # 80002e9e <argstr>
    return -1;
    800059d4:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800059d6:	0c054163          	bltz	a0,80005a98 <sys_open+0xe4>
    800059da:	f4c40593          	addi	a1,s0,-180
    800059de:	4505                	li	a0,1
    800059e0:	ffffd097          	auipc	ra,0xffffd
    800059e4:	47a080e7          	jalr	1146(ra) # 80002e5a <argint>
    800059e8:	0a054863          	bltz	a0,80005a98 <sys_open+0xe4>

  begin_op();
    800059ec:	fffff097          	auipc	ra,0xfffff
    800059f0:	9e6080e7          	jalr	-1562(ra) # 800043d2 <begin_op>

  if(omode & O_CREATE){
    800059f4:	f4c42783          	lw	a5,-180(s0)
    800059f8:	2007f793          	andi	a5,a5,512
    800059fc:	cbdd                	beqz	a5,80005ab2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800059fe:	4681                	li	a3,0
    80005a00:	4601                	li	a2,0
    80005a02:	4589                	li	a1,2
    80005a04:	f5040513          	addi	a0,s0,-176
    80005a08:	00000097          	auipc	ra,0x0
    80005a0c:	974080e7          	jalr	-1676(ra) # 8000537c <create>
    80005a10:	892a                	mv	s2,a0
    if(ip == 0){
    80005a12:	c959                	beqz	a0,80005aa8 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005a14:	04491703          	lh	a4,68(s2)
    80005a18:	478d                	li	a5,3
    80005a1a:	00f71763          	bne	a4,a5,80005a28 <sys_open+0x74>
    80005a1e:	04695703          	lhu	a4,70(s2)
    80005a22:	47a5                	li	a5,9
    80005a24:	0ce7ec63          	bltu	a5,a4,80005afc <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005a28:	fffff097          	auipc	ra,0xfffff
    80005a2c:	dc0080e7          	jalr	-576(ra) # 800047e8 <filealloc>
    80005a30:	89aa                	mv	s3,a0
    80005a32:	10050263          	beqz	a0,80005b36 <sys_open+0x182>
    80005a36:	00000097          	auipc	ra,0x0
    80005a3a:	904080e7          	jalr	-1788(ra) # 8000533a <fdalloc>
    80005a3e:	84aa                	mv	s1,a0
    80005a40:	0e054663          	bltz	a0,80005b2c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005a44:	04491703          	lh	a4,68(s2)
    80005a48:	478d                	li	a5,3
    80005a4a:	0cf70463          	beq	a4,a5,80005b12 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005a4e:	4789                	li	a5,2
    80005a50:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005a54:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005a58:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005a5c:	f4c42783          	lw	a5,-180(s0)
    80005a60:	0017c713          	xori	a4,a5,1
    80005a64:	8b05                	andi	a4,a4,1
    80005a66:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005a6a:	0037f713          	andi	a4,a5,3
    80005a6e:	00e03733          	snez	a4,a4
    80005a72:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005a76:	4007f793          	andi	a5,a5,1024
    80005a7a:	c791                	beqz	a5,80005a86 <sys_open+0xd2>
    80005a7c:	04491703          	lh	a4,68(s2)
    80005a80:	4789                	li	a5,2
    80005a82:	08f70f63          	beq	a4,a5,80005b20 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005a86:	854a                	mv	a0,s2
    80005a88:	ffffe097          	auipc	ra,0xffffe
    80005a8c:	04c080e7          	jalr	76(ra) # 80003ad4 <iunlock>
  end_op();
    80005a90:	fffff097          	auipc	ra,0xfffff
    80005a94:	9c2080e7          	jalr	-1598(ra) # 80004452 <end_op>

  return fd;
}
    80005a98:	8526                	mv	a0,s1
    80005a9a:	70ea                	ld	ra,184(sp)
    80005a9c:	744a                	ld	s0,176(sp)
    80005a9e:	74aa                	ld	s1,168(sp)
    80005aa0:	790a                	ld	s2,160(sp)
    80005aa2:	69ea                	ld	s3,152(sp)
    80005aa4:	6129                	addi	sp,sp,192
    80005aa6:	8082                	ret
      end_op();
    80005aa8:	fffff097          	auipc	ra,0xfffff
    80005aac:	9aa080e7          	jalr	-1622(ra) # 80004452 <end_op>
      return -1;
    80005ab0:	b7e5                	j	80005a98 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005ab2:	f5040513          	addi	a0,s0,-176
    80005ab6:	ffffe097          	auipc	ra,0xffffe
    80005aba:	70c080e7          	jalr	1804(ra) # 800041c2 <namei>
    80005abe:	892a                	mv	s2,a0
    80005ac0:	c905                	beqz	a0,80005af0 <sys_open+0x13c>
    ilock(ip);
    80005ac2:	ffffe097          	auipc	ra,0xffffe
    80005ac6:	f50080e7          	jalr	-176(ra) # 80003a12 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005aca:	04491703          	lh	a4,68(s2)
    80005ace:	4785                	li	a5,1
    80005ad0:	f4f712e3          	bne	a4,a5,80005a14 <sys_open+0x60>
    80005ad4:	f4c42783          	lw	a5,-180(s0)
    80005ad8:	dba1                	beqz	a5,80005a28 <sys_open+0x74>
      iunlockput(ip);
    80005ada:	854a                	mv	a0,s2
    80005adc:	ffffe097          	auipc	ra,0xffffe
    80005ae0:	198080e7          	jalr	408(ra) # 80003c74 <iunlockput>
      end_op();
    80005ae4:	fffff097          	auipc	ra,0xfffff
    80005ae8:	96e080e7          	jalr	-1682(ra) # 80004452 <end_op>
      return -1;
    80005aec:	54fd                	li	s1,-1
    80005aee:	b76d                	j	80005a98 <sys_open+0xe4>
      end_op();
    80005af0:	fffff097          	auipc	ra,0xfffff
    80005af4:	962080e7          	jalr	-1694(ra) # 80004452 <end_op>
      return -1;
    80005af8:	54fd                	li	s1,-1
    80005afa:	bf79                	j	80005a98 <sys_open+0xe4>
    iunlockput(ip);
    80005afc:	854a                	mv	a0,s2
    80005afe:	ffffe097          	auipc	ra,0xffffe
    80005b02:	176080e7          	jalr	374(ra) # 80003c74 <iunlockput>
    end_op();
    80005b06:	fffff097          	auipc	ra,0xfffff
    80005b0a:	94c080e7          	jalr	-1716(ra) # 80004452 <end_op>
    return -1;
    80005b0e:	54fd                	li	s1,-1
    80005b10:	b761                	j	80005a98 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005b12:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005b16:	04691783          	lh	a5,70(s2)
    80005b1a:	02f99223          	sh	a5,36(s3)
    80005b1e:	bf2d                	j	80005a58 <sys_open+0xa4>
    itrunc(ip);
    80005b20:	854a                	mv	a0,s2
    80005b22:	ffffe097          	auipc	ra,0xffffe
    80005b26:	ffe080e7          	jalr	-2(ra) # 80003b20 <itrunc>
    80005b2a:	bfb1                	j	80005a86 <sys_open+0xd2>
      fileclose(f);
    80005b2c:	854e                	mv	a0,s3
    80005b2e:	fffff097          	auipc	ra,0xfffff
    80005b32:	d76080e7          	jalr	-650(ra) # 800048a4 <fileclose>
    iunlockput(ip);
    80005b36:	854a                	mv	a0,s2
    80005b38:	ffffe097          	auipc	ra,0xffffe
    80005b3c:	13c080e7          	jalr	316(ra) # 80003c74 <iunlockput>
    end_op();
    80005b40:	fffff097          	auipc	ra,0xfffff
    80005b44:	912080e7          	jalr	-1774(ra) # 80004452 <end_op>
    return -1;
    80005b48:	54fd                	li	s1,-1
    80005b4a:	b7b9                	j	80005a98 <sys_open+0xe4>

0000000080005b4c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005b4c:	7175                	addi	sp,sp,-144
    80005b4e:	e506                	sd	ra,136(sp)
    80005b50:	e122                	sd	s0,128(sp)
    80005b52:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005b54:	fffff097          	auipc	ra,0xfffff
    80005b58:	87e080e7          	jalr	-1922(ra) # 800043d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005b5c:	08000613          	li	a2,128
    80005b60:	f7040593          	addi	a1,s0,-144
    80005b64:	4501                	li	a0,0
    80005b66:	ffffd097          	auipc	ra,0xffffd
    80005b6a:	338080e7          	jalr	824(ra) # 80002e9e <argstr>
    80005b6e:	02054963          	bltz	a0,80005ba0 <sys_mkdir+0x54>
    80005b72:	4681                	li	a3,0
    80005b74:	4601                	li	a2,0
    80005b76:	4585                	li	a1,1
    80005b78:	f7040513          	addi	a0,s0,-144
    80005b7c:	00000097          	auipc	ra,0x0
    80005b80:	800080e7          	jalr	-2048(ra) # 8000537c <create>
    80005b84:	cd11                	beqz	a0,80005ba0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b86:	ffffe097          	auipc	ra,0xffffe
    80005b8a:	0ee080e7          	jalr	238(ra) # 80003c74 <iunlockput>
  end_op();
    80005b8e:	fffff097          	auipc	ra,0xfffff
    80005b92:	8c4080e7          	jalr	-1852(ra) # 80004452 <end_op>
  return 0;
    80005b96:	4501                	li	a0,0
}
    80005b98:	60aa                	ld	ra,136(sp)
    80005b9a:	640a                	ld	s0,128(sp)
    80005b9c:	6149                	addi	sp,sp,144
    80005b9e:	8082                	ret
    end_op();
    80005ba0:	fffff097          	auipc	ra,0xfffff
    80005ba4:	8b2080e7          	jalr	-1870(ra) # 80004452 <end_op>
    return -1;
    80005ba8:	557d                	li	a0,-1
    80005baa:	b7fd                	j	80005b98 <sys_mkdir+0x4c>

0000000080005bac <sys_mknod>:

uint64
sys_mknod(void)
{
    80005bac:	7135                	addi	sp,sp,-160
    80005bae:	ed06                	sd	ra,152(sp)
    80005bb0:	e922                	sd	s0,144(sp)
    80005bb2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005bb4:	fffff097          	auipc	ra,0xfffff
    80005bb8:	81e080e7          	jalr	-2018(ra) # 800043d2 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005bbc:	08000613          	li	a2,128
    80005bc0:	f7040593          	addi	a1,s0,-144
    80005bc4:	4501                	li	a0,0
    80005bc6:	ffffd097          	auipc	ra,0xffffd
    80005bca:	2d8080e7          	jalr	728(ra) # 80002e9e <argstr>
    80005bce:	04054a63          	bltz	a0,80005c22 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005bd2:	f6c40593          	addi	a1,s0,-148
    80005bd6:	4505                	li	a0,1
    80005bd8:	ffffd097          	auipc	ra,0xffffd
    80005bdc:	282080e7          	jalr	642(ra) # 80002e5a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005be0:	04054163          	bltz	a0,80005c22 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005be4:	f6840593          	addi	a1,s0,-152
    80005be8:	4509                	li	a0,2
    80005bea:	ffffd097          	auipc	ra,0xffffd
    80005bee:	270080e7          	jalr	624(ra) # 80002e5a <argint>
     argint(1, &major) < 0 ||
    80005bf2:	02054863          	bltz	a0,80005c22 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005bf6:	f6841683          	lh	a3,-152(s0)
    80005bfa:	f6c41603          	lh	a2,-148(s0)
    80005bfe:	458d                	li	a1,3
    80005c00:	f7040513          	addi	a0,s0,-144
    80005c04:	fffff097          	auipc	ra,0xfffff
    80005c08:	778080e7          	jalr	1912(ra) # 8000537c <create>
     argint(2, &minor) < 0 ||
    80005c0c:	c919                	beqz	a0,80005c22 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c0e:	ffffe097          	auipc	ra,0xffffe
    80005c12:	066080e7          	jalr	102(ra) # 80003c74 <iunlockput>
  end_op();
    80005c16:	fffff097          	auipc	ra,0xfffff
    80005c1a:	83c080e7          	jalr	-1988(ra) # 80004452 <end_op>
  return 0;
    80005c1e:	4501                	li	a0,0
    80005c20:	a031                	j	80005c2c <sys_mknod+0x80>
    end_op();
    80005c22:	fffff097          	auipc	ra,0xfffff
    80005c26:	830080e7          	jalr	-2000(ra) # 80004452 <end_op>
    return -1;
    80005c2a:	557d                	li	a0,-1
}
    80005c2c:	60ea                	ld	ra,152(sp)
    80005c2e:	644a                	ld	s0,144(sp)
    80005c30:	610d                	addi	sp,sp,160
    80005c32:	8082                	ret

0000000080005c34 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005c34:	7135                	addi	sp,sp,-160
    80005c36:	ed06                	sd	ra,152(sp)
    80005c38:	e922                	sd	s0,144(sp)
    80005c3a:	e526                	sd	s1,136(sp)
    80005c3c:	e14a                	sd	s2,128(sp)
    80005c3e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005c40:	ffffc097          	auipc	ra,0xffffc
    80005c44:	198080e7          	jalr	408(ra) # 80001dd8 <myproc>
    80005c48:	892a                	mv	s2,a0
  
  begin_op();
    80005c4a:	ffffe097          	auipc	ra,0xffffe
    80005c4e:	788080e7          	jalr	1928(ra) # 800043d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005c52:	08000613          	li	a2,128
    80005c56:	f6040593          	addi	a1,s0,-160
    80005c5a:	4501                	li	a0,0
    80005c5c:	ffffd097          	auipc	ra,0xffffd
    80005c60:	242080e7          	jalr	578(ra) # 80002e9e <argstr>
    80005c64:	04054b63          	bltz	a0,80005cba <sys_chdir+0x86>
    80005c68:	f6040513          	addi	a0,s0,-160
    80005c6c:	ffffe097          	auipc	ra,0xffffe
    80005c70:	556080e7          	jalr	1366(ra) # 800041c2 <namei>
    80005c74:	84aa                	mv	s1,a0
    80005c76:	c131                	beqz	a0,80005cba <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005c78:	ffffe097          	auipc	ra,0xffffe
    80005c7c:	d9a080e7          	jalr	-614(ra) # 80003a12 <ilock>
  if(ip->type != T_DIR){
    80005c80:	04449703          	lh	a4,68(s1)
    80005c84:	4785                	li	a5,1
    80005c86:	04f71063          	bne	a4,a5,80005cc6 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005c8a:	8526                	mv	a0,s1
    80005c8c:	ffffe097          	auipc	ra,0xffffe
    80005c90:	e48080e7          	jalr	-440(ra) # 80003ad4 <iunlock>
  iput(p->cwd);
    80005c94:	15093503          	ld	a0,336(s2)
    80005c98:	ffffe097          	auipc	ra,0xffffe
    80005c9c:	f34080e7          	jalr	-204(ra) # 80003bcc <iput>
  end_op();
    80005ca0:	ffffe097          	auipc	ra,0xffffe
    80005ca4:	7b2080e7          	jalr	1970(ra) # 80004452 <end_op>
  p->cwd = ip;
    80005ca8:	14993823          	sd	s1,336(s2)
  return 0;
    80005cac:	4501                	li	a0,0
}
    80005cae:	60ea                	ld	ra,152(sp)
    80005cb0:	644a                	ld	s0,144(sp)
    80005cb2:	64aa                	ld	s1,136(sp)
    80005cb4:	690a                	ld	s2,128(sp)
    80005cb6:	610d                	addi	sp,sp,160
    80005cb8:	8082                	ret
    end_op();
    80005cba:	ffffe097          	auipc	ra,0xffffe
    80005cbe:	798080e7          	jalr	1944(ra) # 80004452 <end_op>
    return -1;
    80005cc2:	557d                	li	a0,-1
    80005cc4:	b7ed                	j	80005cae <sys_chdir+0x7a>
    iunlockput(ip);
    80005cc6:	8526                	mv	a0,s1
    80005cc8:	ffffe097          	auipc	ra,0xffffe
    80005ccc:	fac080e7          	jalr	-84(ra) # 80003c74 <iunlockput>
    end_op();
    80005cd0:	ffffe097          	auipc	ra,0xffffe
    80005cd4:	782080e7          	jalr	1922(ra) # 80004452 <end_op>
    return -1;
    80005cd8:	557d                	li	a0,-1
    80005cda:	bfd1                	j	80005cae <sys_chdir+0x7a>

0000000080005cdc <sys_exec>:

uint64
sys_exec(void)
{
    80005cdc:	7145                	addi	sp,sp,-464
    80005cde:	e786                	sd	ra,456(sp)
    80005ce0:	e3a2                	sd	s0,448(sp)
    80005ce2:	ff26                	sd	s1,440(sp)
    80005ce4:	fb4a                	sd	s2,432(sp)
    80005ce6:	f74e                	sd	s3,424(sp)
    80005ce8:	f352                	sd	s4,416(sp)
    80005cea:	ef56                	sd	s5,408(sp)
    80005cec:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005cee:	08000613          	li	a2,128
    80005cf2:	f4040593          	addi	a1,s0,-192
    80005cf6:	4501                	li	a0,0
    80005cf8:	ffffd097          	auipc	ra,0xffffd
    80005cfc:	1a6080e7          	jalr	422(ra) # 80002e9e <argstr>
    return -1;
    80005d00:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005d02:	0c054a63          	bltz	a0,80005dd6 <sys_exec+0xfa>
    80005d06:	e3840593          	addi	a1,s0,-456
    80005d0a:	4505                	li	a0,1
    80005d0c:	ffffd097          	auipc	ra,0xffffd
    80005d10:	170080e7          	jalr	368(ra) # 80002e7c <argaddr>
    80005d14:	0c054163          	bltz	a0,80005dd6 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005d18:	10000613          	li	a2,256
    80005d1c:	4581                	li	a1,0
    80005d1e:	e4040513          	addi	a0,s0,-448
    80005d22:	ffffb097          	auipc	ra,0xffffb
    80005d26:	fd6080e7          	jalr	-42(ra) # 80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005d2a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005d2e:	89a6                	mv	s3,s1
    80005d30:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005d32:	02000a13          	li	s4,32
    80005d36:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005d3a:	00391793          	slli	a5,s2,0x3
    80005d3e:	e3040593          	addi	a1,s0,-464
    80005d42:	e3843503          	ld	a0,-456(s0)
    80005d46:	953e                	add	a0,a0,a5
    80005d48:	ffffd097          	auipc	ra,0xffffd
    80005d4c:	078080e7          	jalr	120(ra) # 80002dc0 <fetchaddr>
    80005d50:	02054a63          	bltz	a0,80005d84 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005d54:	e3043783          	ld	a5,-464(s0)
    80005d58:	c3b9                	beqz	a5,80005d9e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005d5a:	ffffb097          	auipc	ra,0xffffb
    80005d5e:	db2080e7          	jalr	-590(ra) # 80000b0c <kalloc>
    80005d62:	85aa                	mv	a1,a0
    80005d64:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005d68:	cd11                	beqz	a0,80005d84 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d6a:	6605                	lui	a2,0x1
    80005d6c:	e3043503          	ld	a0,-464(s0)
    80005d70:	ffffd097          	auipc	ra,0xffffd
    80005d74:	0a2080e7          	jalr	162(ra) # 80002e12 <fetchstr>
    80005d78:	00054663          	bltz	a0,80005d84 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005d7c:	0905                	addi	s2,s2,1
    80005d7e:	09a1                	addi	s3,s3,8
    80005d80:	fb491be3          	bne	s2,s4,80005d36 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d84:	10048913          	addi	s2,s1,256
    80005d88:	6088                	ld	a0,0(s1)
    80005d8a:	c529                	beqz	a0,80005dd4 <sys_exec+0xf8>
    kfree(argv[i]);
    80005d8c:	ffffb097          	auipc	ra,0xffffb
    80005d90:	c84080e7          	jalr	-892(ra) # 80000a10 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d94:	04a1                	addi	s1,s1,8
    80005d96:	ff2499e3          	bne	s1,s2,80005d88 <sys_exec+0xac>
  return -1;
    80005d9a:	597d                	li	s2,-1
    80005d9c:	a82d                	j	80005dd6 <sys_exec+0xfa>
      argv[i] = 0;
    80005d9e:	0a8e                	slli	s5,s5,0x3
    80005da0:	fc040793          	addi	a5,s0,-64
    80005da4:	9abe                	add	s5,s5,a5
    80005da6:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd7e80>
  int ret = exec(path, argv);
    80005daa:	e4040593          	addi	a1,s0,-448
    80005dae:	f4040513          	addi	a0,s0,-192
    80005db2:	fffff097          	auipc	ra,0xfffff
    80005db6:	178080e7          	jalr	376(ra) # 80004f2a <exec>
    80005dba:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dbc:	10048993          	addi	s3,s1,256
    80005dc0:	6088                	ld	a0,0(s1)
    80005dc2:	c911                	beqz	a0,80005dd6 <sys_exec+0xfa>
    kfree(argv[i]);
    80005dc4:	ffffb097          	auipc	ra,0xffffb
    80005dc8:	c4c080e7          	jalr	-948(ra) # 80000a10 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dcc:	04a1                	addi	s1,s1,8
    80005dce:	ff3499e3          	bne	s1,s3,80005dc0 <sys_exec+0xe4>
    80005dd2:	a011                	j	80005dd6 <sys_exec+0xfa>
  return -1;
    80005dd4:	597d                	li	s2,-1
}
    80005dd6:	854a                	mv	a0,s2
    80005dd8:	60be                	ld	ra,456(sp)
    80005dda:	641e                	ld	s0,448(sp)
    80005ddc:	74fa                	ld	s1,440(sp)
    80005dde:	795a                	ld	s2,432(sp)
    80005de0:	79ba                	ld	s3,424(sp)
    80005de2:	7a1a                	ld	s4,416(sp)
    80005de4:	6afa                	ld	s5,408(sp)
    80005de6:	6179                	addi	sp,sp,464
    80005de8:	8082                	ret

0000000080005dea <sys_pipe>:

uint64
sys_pipe(void)
{
    80005dea:	7139                	addi	sp,sp,-64
    80005dec:	fc06                	sd	ra,56(sp)
    80005dee:	f822                	sd	s0,48(sp)
    80005df0:	f426                	sd	s1,40(sp)
    80005df2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005df4:	ffffc097          	auipc	ra,0xffffc
    80005df8:	fe4080e7          	jalr	-28(ra) # 80001dd8 <myproc>
    80005dfc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005dfe:	fd840593          	addi	a1,s0,-40
    80005e02:	4501                	li	a0,0
    80005e04:	ffffd097          	auipc	ra,0xffffd
    80005e08:	078080e7          	jalr	120(ra) # 80002e7c <argaddr>
    return -1;
    80005e0c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005e0e:	0e054063          	bltz	a0,80005eee <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005e12:	fc840593          	addi	a1,s0,-56
    80005e16:	fd040513          	addi	a0,s0,-48
    80005e1a:	fffff097          	auipc	ra,0xfffff
    80005e1e:	de0080e7          	jalr	-544(ra) # 80004bfa <pipealloc>
    return -1;
    80005e22:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005e24:	0c054563          	bltz	a0,80005eee <sys_pipe+0x104>
  fd0 = -1;
    80005e28:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005e2c:	fd043503          	ld	a0,-48(s0)
    80005e30:	fffff097          	auipc	ra,0xfffff
    80005e34:	50a080e7          	jalr	1290(ra) # 8000533a <fdalloc>
    80005e38:	fca42223          	sw	a0,-60(s0)
    80005e3c:	08054c63          	bltz	a0,80005ed4 <sys_pipe+0xea>
    80005e40:	fc843503          	ld	a0,-56(s0)
    80005e44:	fffff097          	auipc	ra,0xfffff
    80005e48:	4f6080e7          	jalr	1270(ra) # 8000533a <fdalloc>
    80005e4c:	fca42023          	sw	a0,-64(s0)
    80005e50:	06054863          	bltz	a0,80005ec0 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e54:	4691                	li	a3,4
    80005e56:	fc440613          	addi	a2,s0,-60
    80005e5a:	fd843583          	ld	a1,-40(s0)
    80005e5e:	68a8                	ld	a0,80(s1)
    80005e60:	ffffc097          	auipc	ra,0xffffc
    80005e64:	84a080e7          	jalr	-1974(ra) # 800016aa <copyout>
    80005e68:	02054063          	bltz	a0,80005e88 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005e6c:	4691                	li	a3,4
    80005e6e:	fc040613          	addi	a2,s0,-64
    80005e72:	fd843583          	ld	a1,-40(s0)
    80005e76:	0591                	addi	a1,a1,4
    80005e78:	68a8                	ld	a0,80(s1)
    80005e7a:	ffffc097          	auipc	ra,0xffffc
    80005e7e:	830080e7          	jalr	-2000(ra) # 800016aa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e82:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e84:	06055563          	bgez	a0,80005eee <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005e88:	fc442783          	lw	a5,-60(s0)
    80005e8c:	07e9                	addi	a5,a5,26
    80005e8e:	078e                	slli	a5,a5,0x3
    80005e90:	97a6                	add	a5,a5,s1
    80005e92:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005e96:	fc042503          	lw	a0,-64(s0)
    80005e9a:	0569                	addi	a0,a0,26
    80005e9c:	050e                	slli	a0,a0,0x3
    80005e9e:	9526                	add	a0,a0,s1
    80005ea0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005ea4:	fd043503          	ld	a0,-48(s0)
    80005ea8:	fffff097          	auipc	ra,0xfffff
    80005eac:	9fc080e7          	jalr	-1540(ra) # 800048a4 <fileclose>
    fileclose(wf);
    80005eb0:	fc843503          	ld	a0,-56(s0)
    80005eb4:	fffff097          	auipc	ra,0xfffff
    80005eb8:	9f0080e7          	jalr	-1552(ra) # 800048a4 <fileclose>
    return -1;
    80005ebc:	57fd                	li	a5,-1
    80005ebe:	a805                	j	80005eee <sys_pipe+0x104>
    if(fd0 >= 0)
    80005ec0:	fc442783          	lw	a5,-60(s0)
    80005ec4:	0007c863          	bltz	a5,80005ed4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005ec8:	01a78513          	addi	a0,a5,26
    80005ecc:	050e                	slli	a0,a0,0x3
    80005ece:	9526                	add	a0,a0,s1
    80005ed0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005ed4:	fd043503          	ld	a0,-48(s0)
    80005ed8:	fffff097          	auipc	ra,0xfffff
    80005edc:	9cc080e7          	jalr	-1588(ra) # 800048a4 <fileclose>
    fileclose(wf);
    80005ee0:	fc843503          	ld	a0,-56(s0)
    80005ee4:	fffff097          	auipc	ra,0xfffff
    80005ee8:	9c0080e7          	jalr	-1600(ra) # 800048a4 <fileclose>
    return -1;
    80005eec:	57fd                	li	a5,-1
}
    80005eee:	853e                	mv	a0,a5
    80005ef0:	70e2                	ld	ra,56(sp)
    80005ef2:	7442                	ld	s0,48(sp)
    80005ef4:	74a2                	ld	s1,40(sp)
    80005ef6:	6121                	addi	sp,sp,64
    80005ef8:	8082                	ret
    80005efa:	0000                	unimp
    80005efc:	0000                	unimp
	...

0000000080005f00 <kernelvec>:
    80005f00:	7111                	addi	sp,sp,-256
    80005f02:	e006                	sd	ra,0(sp)
    80005f04:	e40a                	sd	sp,8(sp)
    80005f06:	e80e                	sd	gp,16(sp)
    80005f08:	ec12                	sd	tp,24(sp)
    80005f0a:	f016                	sd	t0,32(sp)
    80005f0c:	f41a                	sd	t1,40(sp)
    80005f0e:	f81e                	sd	t2,48(sp)
    80005f10:	fc22                	sd	s0,56(sp)
    80005f12:	e0a6                	sd	s1,64(sp)
    80005f14:	e4aa                	sd	a0,72(sp)
    80005f16:	e8ae                	sd	a1,80(sp)
    80005f18:	ecb2                	sd	a2,88(sp)
    80005f1a:	f0b6                	sd	a3,96(sp)
    80005f1c:	f4ba                	sd	a4,104(sp)
    80005f1e:	f8be                	sd	a5,112(sp)
    80005f20:	fcc2                	sd	a6,120(sp)
    80005f22:	e146                	sd	a7,128(sp)
    80005f24:	e54a                	sd	s2,136(sp)
    80005f26:	e94e                	sd	s3,144(sp)
    80005f28:	ed52                	sd	s4,152(sp)
    80005f2a:	f156                	sd	s5,160(sp)
    80005f2c:	f55a                	sd	s6,168(sp)
    80005f2e:	f95e                	sd	s7,176(sp)
    80005f30:	fd62                	sd	s8,184(sp)
    80005f32:	e1e6                	sd	s9,192(sp)
    80005f34:	e5ea                	sd	s10,200(sp)
    80005f36:	e9ee                	sd	s11,208(sp)
    80005f38:	edf2                	sd	t3,216(sp)
    80005f3a:	f1f6                	sd	t4,224(sp)
    80005f3c:	f5fa                	sd	t5,232(sp)
    80005f3e:	f9fe                	sd	t6,240(sp)
    80005f40:	d4dfc0ef          	jal	ra,80002c8c <kerneltrap>
    80005f44:	6082                	ld	ra,0(sp)
    80005f46:	6122                	ld	sp,8(sp)
    80005f48:	61c2                	ld	gp,16(sp)
    80005f4a:	7282                	ld	t0,32(sp)
    80005f4c:	7322                	ld	t1,40(sp)
    80005f4e:	73c2                	ld	t2,48(sp)
    80005f50:	7462                	ld	s0,56(sp)
    80005f52:	6486                	ld	s1,64(sp)
    80005f54:	6526                	ld	a0,72(sp)
    80005f56:	65c6                	ld	a1,80(sp)
    80005f58:	6666                	ld	a2,88(sp)
    80005f5a:	7686                	ld	a3,96(sp)
    80005f5c:	7726                	ld	a4,104(sp)
    80005f5e:	77c6                	ld	a5,112(sp)
    80005f60:	7866                	ld	a6,120(sp)
    80005f62:	688a                	ld	a7,128(sp)
    80005f64:	692a                	ld	s2,136(sp)
    80005f66:	69ca                	ld	s3,144(sp)
    80005f68:	6a6a                	ld	s4,152(sp)
    80005f6a:	7a8a                	ld	s5,160(sp)
    80005f6c:	7b2a                	ld	s6,168(sp)
    80005f6e:	7bca                	ld	s7,176(sp)
    80005f70:	7c6a                	ld	s8,184(sp)
    80005f72:	6c8e                	ld	s9,192(sp)
    80005f74:	6d2e                	ld	s10,200(sp)
    80005f76:	6dce                	ld	s11,208(sp)
    80005f78:	6e6e                	ld	t3,216(sp)
    80005f7a:	7e8e                	ld	t4,224(sp)
    80005f7c:	7f2e                	ld	t5,232(sp)
    80005f7e:	7fce                	ld	t6,240(sp)
    80005f80:	6111                	addi	sp,sp,256
    80005f82:	10200073          	sret
    80005f86:	00000013          	nop
    80005f8a:	00000013          	nop
    80005f8e:	0001                	nop

0000000080005f90 <timervec>:
    80005f90:	34051573          	csrrw	a0,mscratch,a0
    80005f94:	e10c                	sd	a1,0(a0)
    80005f96:	e510                	sd	a2,8(a0)
    80005f98:	e914                	sd	a3,16(a0)
    80005f9a:	710c                	ld	a1,32(a0)
    80005f9c:	7510                	ld	a2,40(a0)
    80005f9e:	6194                	ld	a3,0(a1)
    80005fa0:	96b2                	add	a3,a3,a2
    80005fa2:	e194                	sd	a3,0(a1)
    80005fa4:	4589                	li	a1,2
    80005fa6:	14459073          	csrw	sip,a1
    80005faa:	6914                	ld	a3,16(a0)
    80005fac:	6510                	ld	a2,8(a0)
    80005fae:	610c                	ld	a1,0(a0)
    80005fb0:	34051573          	csrrw	a0,mscratch,a0
    80005fb4:	30200073          	mret
	...

0000000080005fba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005fba:	1141                	addi	sp,sp,-16
    80005fbc:	e422                	sd	s0,8(sp)
    80005fbe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005fc0:	0c0007b7          	lui	a5,0xc000
    80005fc4:	4705                	li	a4,1
    80005fc6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005fc8:	c3d8                	sw	a4,4(a5)
}
    80005fca:	6422                	ld	s0,8(sp)
    80005fcc:	0141                	addi	sp,sp,16
    80005fce:	8082                	ret

0000000080005fd0 <plicinithart>:

void
plicinithart(void)
{
    80005fd0:	1141                	addi	sp,sp,-16
    80005fd2:	e406                	sd	ra,8(sp)
    80005fd4:	e022                	sd	s0,0(sp)
    80005fd6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005fd8:	ffffc097          	auipc	ra,0xffffc
    80005fdc:	dd4080e7          	jalr	-556(ra) # 80001dac <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005fe0:	0085171b          	slliw	a4,a0,0x8
    80005fe4:	0c0027b7          	lui	a5,0xc002
    80005fe8:	97ba                	add	a5,a5,a4
    80005fea:	40200713          	li	a4,1026
    80005fee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005ff2:	00d5151b          	slliw	a0,a0,0xd
    80005ff6:	0c2017b7          	lui	a5,0xc201
    80005ffa:	953e                	add	a0,a0,a5
    80005ffc:	00052023          	sw	zero,0(a0)
}
    80006000:	60a2                	ld	ra,8(sp)
    80006002:	6402                	ld	s0,0(sp)
    80006004:	0141                	addi	sp,sp,16
    80006006:	8082                	ret

0000000080006008 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006008:	1141                	addi	sp,sp,-16
    8000600a:	e406                	sd	ra,8(sp)
    8000600c:	e022                	sd	s0,0(sp)
    8000600e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006010:	ffffc097          	auipc	ra,0xffffc
    80006014:	d9c080e7          	jalr	-612(ra) # 80001dac <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006018:	00d5179b          	slliw	a5,a0,0xd
    8000601c:	0c201537          	lui	a0,0xc201
    80006020:	953e                	add	a0,a0,a5
  return irq;
}
    80006022:	4148                	lw	a0,4(a0)
    80006024:	60a2                	ld	ra,8(sp)
    80006026:	6402                	ld	s0,0(sp)
    80006028:	0141                	addi	sp,sp,16
    8000602a:	8082                	ret

000000008000602c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000602c:	1101                	addi	sp,sp,-32
    8000602e:	ec06                	sd	ra,24(sp)
    80006030:	e822                	sd	s0,16(sp)
    80006032:	e426                	sd	s1,8(sp)
    80006034:	1000                	addi	s0,sp,32
    80006036:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006038:	ffffc097          	auipc	ra,0xffffc
    8000603c:	d74080e7          	jalr	-652(ra) # 80001dac <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006040:	00d5151b          	slliw	a0,a0,0xd
    80006044:	0c2017b7          	lui	a5,0xc201
    80006048:	97aa                	add	a5,a5,a0
    8000604a:	c3c4                	sw	s1,4(a5)
}
    8000604c:	60e2                	ld	ra,24(sp)
    8000604e:	6442                	ld	s0,16(sp)
    80006050:	64a2                	ld	s1,8(sp)
    80006052:	6105                	addi	sp,sp,32
    80006054:	8082                	ret

0000000080006056 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006056:	1141                	addi	sp,sp,-16
    80006058:	e406                	sd	ra,8(sp)
    8000605a:	e022                	sd	s0,0(sp)
    8000605c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000605e:	479d                	li	a5,7
    80006060:	04a7cc63          	blt	a5,a0,800060b8 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80006064:	0001e797          	auipc	a5,0x1e
    80006068:	f9c78793          	addi	a5,a5,-100 # 80024000 <disk>
    8000606c:	00a78733          	add	a4,a5,a0
    80006070:	6789                	lui	a5,0x2
    80006072:	97ba                	add	a5,a5,a4
    80006074:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006078:	eba1                	bnez	a5,800060c8 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    8000607a:	00451713          	slli	a4,a0,0x4
    8000607e:	00020797          	auipc	a5,0x20
    80006082:	f827b783          	ld	a5,-126(a5) # 80026000 <disk+0x2000>
    80006086:	97ba                	add	a5,a5,a4
    80006088:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    8000608c:	0001e797          	auipc	a5,0x1e
    80006090:	f7478793          	addi	a5,a5,-140 # 80024000 <disk>
    80006094:	97aa                	add	a5,a5,a0
    80006096:	6509                	lui	a0,0x2
    80006098:	953e                	add	a0,a0,a5
    8000609a:	4785                	li	a5,1
    8000609c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800060a0:	00020517          	auipc	a0,0x20
    800060a4:	f7850513          	addi	a0,a0,-136 # 80026018 <disk+0x2018>
    800060a8:	ffffc097          	auipc	ra,0xffffc
    800060ac:	63e080e7          	jalr	1598(ra) # 800026e6 <wakeup>
}
    800060b0:	60a2                	ld	ra,8(sp)
    800060b2:	6402                	ld	s0,0(sp)
    800060b4:	0141                	addi	sp,sp,16
    800060b6:	8082                	ret
    panic("virtio_disk_intr 1");
    800060b8:	00002517          	auipc	a0,0x2
    800060bc:	78050513          	addi	a0,a0,1920 # 80008838 <syscalls+0x330>
    800060c0:	ffffa097          	auipc	ra,0xffffa
    800060c4:	480080e7          	jalr	1152(ra) # 80000540 <panic>
    panic("virtio_disk_intr 2");
    800060c8:	00002517          	auipc	a0,0x2
    800060cc:	78850513          	addi	a0,a0,1928 # 80008850 <syscalls+0x348>
    800060d0:	ffffa097          	auipc	ra,0xffffa
    800060d4:	470080e7          	jalr	1136(ra) # 80000540 <panic>

00000000800060d8 <virtio_disk_init>:
{
    800060d8:	1101                	addi	sp,sp,-32
    800060da:	ec06                	sd	ra,24(sp)
    800060dc:	e822                	sd	s0,16(sp)
    800060de:	e426                	sd	s1,8(sp)
    800060e0:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800060e2:	00002597          	auipc	a1,0x2
    800060e6:	78658593          	addi	a1,a1,1926 # 80008868 <syscalls+0x360>
    800060ea:	00020517          	auipc	a0,0x20
    800060ee:	fbe50513          	addi	a0,a0,-66 # 800260a8 <disk+0x20a8>
    800060f2:	ffffb097          	auipc	ra,0xffffb
    800060f6:	a7a080e7          	jalr	-1414(ra) # 80000b6c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800060fa:	100017b7          	lui	a5,0x10001
    800060fe:	4398                	lw	a4,0(a5)
    80006100:	2701                	sext.w	a4,a4
    80006102:	747277b7          	lui	a5,0x74727
    80006106:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000610a:	0ef71163          	bne	a4,a5,800061ec <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000610e:	100017b7          	lui	a5,0x10001
    80006112:	43dc                	lw	a5,4(a5)
    80006114:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006116:	4705                	li	a4,1
    80006118:	0ce79a63          	bne	a5,a4,800061ec <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000611c:	100017b7          	lui	a5,0x10001
    80006120:	479c                	lw	a5,8(a5)
    80006122:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006124:	4709                	li	a4,2
    80006126:	0ce79363          	bne	a5,a4,800061ec <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000612a:	100017b7          	lui	a5,0x10001
    8000612e:	47d8                	lw	a4,12(a5)
    80006130:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006132:	554d47b7          	lui	a5,0x554d4
    80006136:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000613a:	0af71963          	bne	a4,a5,800061ec <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000613e:	100017b7          	lui	a5,0x10001
    80006142:	4705                	li	a4,1
    80006144:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006146:	470d                	li	a4,3
    80006148:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000614a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000614c:	c7ffe737          	lui	a4,0xc7ffe
    80006150:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd775f>
    80006154:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006156:	2701                	sext.w	a4,a4
    80006158:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000615a:	472d                	li	a4,11
    8000615c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000615e:	473d                	li	a4,15
    80006160:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006162:	6705                	lui	a4,0x1
    80006164:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006166:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000616a:	5bdc                	lw	a5,52(a5)
    8000616c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000616e:	c7d9                	beqz	a5,800061fc <virtio_disk_init+0x124>
  if(max < NUM)
    80006170:	471d                	li	a4,7
    80006172:	08f77d63          	bgeu	a4,a5,8000620c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006176:	100014b7          	lui	s1,0x10001
    8000617a:	47a1                	li	a5,8
    8000617c:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000617e:	6609                	lui	a2,0x2
    80006180:	4581                	li	a1,0
    80006182:	0001e517          	auipc	a0,0x1e
    80006186:	e7e50513          	addi	a0,a0,-386 # 80024000 <disk>
    8000618a:	ffffb097          	auipc	ra,0xffffb
    8000618e:	b6e080e7          	jalr	-1170(ra) # 80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006192:	0001e717          	auipc	a4,0x1e
    80006196:	e6e70713          	addi	a4,a4,-402 # 80024000 <disk>
    8000619a:	00c75793          	srli	a5,a4,0xc
    8000619e:	2781                	sext.w	a5,a5
    800061a0:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    800061a2:	00020797          	auipc	a5,0x20
    800061a6:	e5e78793          	addi	a5,a5,-418 # 80026000 <disk+0x2000>
    800061aa:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    800061ac:	0001e717          	auipc	a4,0x1e
    800061b0:	ed470713          	addi	a4,a4,-300 # 80024080 <disk+0x80>
    800061b4:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    800061b6:	0001f717          	auipc	a4,0x1f
    800061ba:	e4a70713          	addi	a4,a4,-438 # 80025000 <disk+0x1000>
    800061be:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800061c0:	4705                	li	a4,1
    800061c2:	00e78c23          	sb	a4,24(a5)
    800061c6:	00e78ca3          	sb	a4,25(a5)
    800061ca:	00e78d23          	sb	a4,26(a5)
    800061ce:	00e78da3          	sb	a4,27(a5)
    800061d2:	00e78e23          	sb	a4,28(a5)
    800061d6:	00e78ea3          	sb	a4,29(a5)
    800061da:	00e78f23          	sb	a4,30(a5)
    800061de:	00e78fa3          	sb	a4,31(a5)
}
    800061e2:	60e2                	ld	ra,24(sp)
    800061e4:	6442                	ld	s0,16(sp)
    800061e6:	64a2                	ld	s1,8(sp)
    800061e8:	6105                	addi	sp,sp,32
    800061ea:	8082                	ret
    panic("could not find virtio disk");
    800061ec:	00002517          	auipc	a0,0x2
    800061f0:	68c50513          	addi	a0,a0,1676 # 80008878 <syscalls+0x370>
    800061f4:	ffffa097          	auipc	ra,0xffffa
    800061f8:	34c080e7          	jalr	844(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    800061fc:	00002517          	auipc	a0,0x2
    80006200:	69c50513          	addi	a0,a0,1692 # 80008898 <syscalls+0x390>
    80006204:	ffffa097          	auipc	ra,0xffffa
    80006208:	33c080e7          	jalr	828(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    8000620c:	00002517          	auipc	a0,0x2
    80006210:	6ac50513          	addi	a0,a0,1708 # 800088b8 <syscalls+0x3b0>
    80006214:	ffffa097          	auipc	ra,0xffffa
    80006218:	32c080e7          	jalr	812(ra) # 80000540 <panic>

000000008000621c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000621c:	7175                	addi	sp,sp,-144
    8000621e:	e506                	sd	ra,136(sp)
    80006220:	e122                	sd	s0,128(sp)
    80006222:	fca6                	sd	s1,120(sp)
    80006224:	f8ca                	sd	s2,112(sp)
    80006226:	f4ce                	sd	s3,104(sp)
    80006228:	f0d2                	sd	s4,96(sp)
    8000622a:	ecd6                	sd	s5,88(sp)
    8000622c:	e8da                	sd	s6,80(sp)
    8000622e:	e4de                	sd	s7,72(sp)
    80006230:	e0e2                	sd	s8,64(sp)
    80006232:	fc66                	sd	s9,56(sp)
    80006234:	f86a                	sd	s10,48(sp)
    80006236:	f46e                	sd	s11,40(sp)
    80006238:	0900                	addi	s0,sp,144
    8000623a:	8aaa                	mv	s5,a0
    8000623c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000623e:	00c52c83          	lw	s9,12(a0)
    80006242:	001c9c9b          	slliw	s9,s9,0x1
    80006246:	1c82                	slli	s9,s9,0x20
    80006248:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000624c:	00020517          	auipc	a0,0x20
    80006250:	e5c50513          	addi	a0,a0,-420 # 800260a8 <disk+0x20a8>
    80006254:	ffffb097          	auipc	ra,0xffffb
    80006258:	9a8080e7          	jalr	-1624(ra) # 80000bfc <acquire>
  for(int i = 0; i < 3; i++){
    8000625c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000625e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006260:	0001ec17          	auipc	s8,0x1e
    80006264:	da0c0c13          	addi	s8,s8,-608 # 80024000 <disk>
    80006268:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    8000626a:	4b0d                	li	s6,3
    8000626c:	a0ad                	j	800062d6 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    8000626e:	00fc0733          	add	a4,s8,a5
    80006272:	975e                	add	a4,a4,s7
    80006274:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006278:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000627a:	0207c563          	bltz	a5,800062a4 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000627e:	2905                	addiw	s2,s2,1
    80006280:	0611                	addi	a2,a2,4
    80006282:	19690d63          	beq	s2,s6,8000641c <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006286:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006288:	00020717          	auipc	a4,0x20
    8000628c:	d9070713          	addi	a4,a4,-624 # 80026018 <disk+0x2018>
    80006290:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006292:	00074683          	lbu	a3,0(a4)
    80006296:	fee1                	bnez	a3,8000626e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006298:	2785                	addiw	a5,a5,1
    8000629a:	0705                	addi	a4,a4,1
    8000629c:	fe979be3          	bne	a5,s1,80006292 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800062a0:	57fd                	li	a5,-1
    800062a2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800062a4:	01205d63          	blez	s2,800062be <virtio_disk_rw+0xa2>
    800062a8:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800062aa:	000a2503          	lw	a0,0(s4)
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	da8080e7          	jalr	-600(ra) # 80006056 <free_desc>
      for(int j = 0; j < i; j++)
    800062b6:	2d85                	addiw	s11,s11,1
    800062b8:	0a11                	addi	s4,s4,4
    800062ba:	ffb918e3          	bne	s2,s11,800062aa <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800062be:	00020597          	auipc	a1,0x20
    800062c2:	dea58593          	addi	a1,a1,-534 # 800260a8 <disk+0x20a8>
    800062c6:	00020517          	auipc	a0,0x20
    800062ca:	d5250513          	addi	a0,a0,-686 # 80026018 <disk+0x2018>
    800062ce:	ffffc097          	auipc	ra,0xffffc
    800062d2:	298080e7          	jalr	664(ra) # 80002566 <sleep>
  for(int i = 0; i < 3; i++){
    800062d6:	f8040a13          	addi	s4,s0,-128
{
    800062da:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800062dc:	894e                	mv	s2,s3
    800062de:	b765                	j	80006286 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800062e0:	00020717          	auipc	a4,0x20
    800062e4:	d2073703          	ld	a4,-736(a4) # 80026000 <disk+0x2000>
    800062e8:	973e                	add	a4,a4,a5
    800062ea:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800062ee:	0001e517          	auipc	a0,0x1e
    800062f2:	d1250513          	addi	a0,a0,-750 # 80024000 <disk>
    800062f6:	00020717          	auipc	a4,0x20
    800062fa:	d0a70713          	addi	a4,a4,-758 # 80026000 <disk+0x2000>
    800062fe:	6314                	ld	a3,0(a4)
    80006300:	96be                	add	a3,a3,a5
    80006302:	00c6d603          	lhu	a2,12(a3)
    80006306:	00166613          	ori	a2,a2,1
    8000630a:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000630e:	f8842683          	lw	a3,-120(s0)
    80006312:	6310                	ld	a2,0(a4)
    80006314:	97b2                	add	a5,a5,a2
    80006316:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    8000631a:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    8000631e:	0612                	slli	a2,a2,0x4
    80006320:	962a                	add	a2,a2,a0
    80006322:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006326:	00469793          	slli	a5,a3,0x4
    8000632a:	630c                	ld	a1,0(a4)
    8000632c:	95be                	add	a1,a1,a5
    8000632e:	6689                	lui	a3,0x2
    80006330:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80006334:	96ca                	add	a3,a3,s2
    80006336:	96aa                	add	a3,a3,a0
    80006338:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    8000633a:	6314                	ld	a3,0(a4)
    8000633c:	96be                	add	a3,a3,a5
    8000633e:	4585                	li	a1,1
    80006340:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006342:	6314                	ld	a3,0(a4)
    80006344:	96be                	add	a3,a3,a5
    80006346:	4509                	li	a0,2
    80006348:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    8000634c:	6314                	ld	a3,0(a4)
    8000634e:	97b6                	add	a5,a5,a3
    80006350:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006354:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006358:	03563423          	sd	s5,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000635c:	6714                	ld	a3,8(a4)
    8000635e:	0026d783          	lhu	a5,2(a3)
    80006362:	8b9d                	andi	a5,a5,7
    80006364:	0789                	addi	a5,a5,2
    80006366:	0786                	slli	a5,a5,0x1
    80006368:	97b6                	add	a5,a5,a3
    8000636a:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000636e:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80006372:	6718                	ld	a4,8(a4)
    80006374:	00275783          	lhu	a5,2(a4)
    80006378:	2785                	addiw	a5,a5,1
    8000637a:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000637e:	100017b7          	lui	a5,0x10001
    80006382:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006386:	004aa783          	lw	a5,4(s5)
    8000638a:	02b79163          	bne	a5,a1,800063ac <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000638e:	00020917          	auipc	s2,0x20
    80006392:	d1a90913          	addi	s2,s2,-742 # 800260a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006396:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006398:	85ca                	mv	a1,s2
    8000639a:	8556                	mv	a0,s5
    8000639c:	ffffc097          	auipc	ra,0xffffc
    800063a0:	1ca080e7          	jalr	458(ra) # 80002566 <sleep>
  while(b->disk == 1) {
    800063a4:	004aa783          	lw	a5,4(s5)
    800063a8:	fe9788e3          	beq	a5,s1,80006398 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800063ac:	f8042483          	lw	s1,-128(s0)
    800063b0:	20048793          	addi	a5,s1,512
    800063b4:	00479713          	slli	a4,a5,0x4
    800063b8:	0001e797          	auipc	a5,0x1e
    800063bc:	c4878793          	addi	a5,a5,-952 # 80024000 <disk>
    800063c0:	97ba                	add	a5,a5,a4
    800063c2:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800063c6:	00020917          	auipc	s2,0x20
    800063ca:	c3a90913          	addi	s2,s2,-966 # 80026000 <disk+0x2000>
    800063ce:	a019                	j	800063d4 <virtio_disk_rw+0x1b8>
      i = disk.desc[i].next;
    800063d0:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    800063d4:	8526                	mv	a0,s1
    800063d6:	00000097          	auipc	ra,0x0
    800063da:	c80080e7          	jalr	-896(ra) # 80006056 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800063de:	0492                	slli	s1,s1,0x4
    800063e0:	00093783          	ld	a5,0(s2)
    800063e4:	94be                	add	s1,s1,a5
    800063e6:	00c4d783          	lhu	a5,12(s1)
    800063ea:	8b85                	andi	a5,a5,1
    800063ec:	f3f5                	bnez	a5,800063d0 <virtio_disk_rw+0x1b4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800063ee:	00020517          	auipc	a0,0x20
    800063f2:	cba50513          	addi	a0,a0,-838 # 800260a8 <disk+0x20a8>
    800063f6:	ffffb097          	auipc	ra,0xffffb
    800063fa:	8ba080e7          	jalr	-1862(ra) # 80000cb0 <release>
}
    800063fe:	60aa                	ld	ra,136(sp)
    80006400:	640a                	ld	s0,128(sp)
    80006402:	74e6                	ld	s1,120(sp)
    80006404:	7946                	ld	s2,112(sp)
    80006406:	79a6                	ld	s3,104(sp)
    80006408:	7a06                	ld	s4,96(sp)
    8000640a:	6ae6                	ld	s5,88(sp)
    8000640c:	6b46                	ld	s6,80(sp)
    8000640e:	6ba6                	ld	s7,72(sp)
    80006410:	6c06                	ld	s8,64(sp)
    80006412:	7ce2                	ld	s9,56(sp)
    80006414:	7d42                	ld	s10,48(sp)
    80006416:	7da2                	ld	s11,40(sp)
    80006418:	6149                	addi	sp,sp,144
    8000641a:	8082                	ret
  if(write)
    8000641c:	01a037b3          	snez	a5,s10
    80006420:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    80006424:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    80006428:	f7943c23          	sd	s9,-136(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    8000642c:	f8042483          	lw	s1,-128(s0)
    80006430:	00449913          	slli	s2,s1,0x4
    80006434:	00020997          	auipc	s3,0x20
    80006438:	bcc98993          	addi	s3,s3,-1076 # 80026000 <disk+0x2000>
    8000643c:	0009ba03          	ld	s4,0(s3)
    80006440:	9a4a                	add	s4,s4,s2
    80006442:	f7040513          	addi	a0,s0,-144
    80006446:	ffffb097          	auipc	ra,0xffffb
    8000644a:	c72080e7          	jalr	-910(ra) # 800010b8 <kvmpa>
    8000644e:	00aa3023          	sd	a0,0(s4)
  disk.desc[idx[0]].len = sizeof(buf0);
    80006452:	0009b783          	ld	a5,0(s3)
    80006456:	97ca                	add	a5,a5,s2
    80006458:	4741                	li	a4,16
    8000645a:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000645c:	0009b783          	ld	a5,0(s3)
    80006460:	97ca                	add	a5,a5,s2
    80006462:	4705                	li	a4,1
    80006464:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006468:	f8442783          	lw	a5,-124(s0)
    8000646c:	0009b703          	ld	a4,0(s3)
    80006470:	974a                	add	a4,a4,s2
    80006472:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006476:	0792                	slli	a5,a5,0x4
    80006478:	0009b703          	ld	a4,0(s3)
    8000647c:	973e                	add	a4,a4,a5
    8000647e:	058a8693          	addi	a3,s5,88
    80006482:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    80006484:	0009b703          	ld	a4,0(s3)
    80006488:	973e                	add	a4,a4,a5
    8000648a:	40000693          	li	a3,1024
    8000648e:	c714                	sw	a3,8(a4)
  if(write)
    80006490:	e40d18e3          	bnez	s10,800062e0 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006494:	00020717          	auipc	a4,0x20
    80006498:	b6c73703          	ld	a4,-1172(a4) # 80026000 <disk+0x2000>
    8000649c:	973e                	add	a4,a4,a5
    8000649e:	4689                	li	a3,2
    800064a0:	00d71623          	sh	a3,12(a4)
    800064a4:	b5a9                	j	800062ee <virtio_disk_rw+0xd2>

00000000800064a6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800064a6:	1101                	addi	sp,sp,-32
    800064a8:	ec06                	sd	ra,24(sp)
    800064aa:	e822                	sd	s0,16(sp)
    800064ac:	e426                	sd	s1,8(sp)
    800064ae:	e04a                	sd	s2,0(sp)
    800064b0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800064b2:	00020517          	auipc	a0,0x20
    800064b6:	bf650513          	addi	a0,a0,-1034 # 800260a8 <disk+0x20a8>
    800064ba:	ffffa097          	auipc	ra,0xffffa
    800064be:	742080e7          	jalr	1858(ra) # 80000bfc <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800064c2:	00020717          	auipc	a4,0x20
    800064c6:	b3e70713          	addi	a4,a4,-1218 # 80026000 <disk+0x2000>
    800064ca:	02075783          	lhu	a5,32(a4)
    800064ce:	6b18                	ld	a4,16(a4)
    800064d0:	00275683          	lhu	a3,2(a4)
    800064d4:	8ebd                	xor	a3,a3,a5
    800064d6:	8a9d                	andi	a3,a3,7
    800064d8:	cab9                	beqz	a3,8000652e <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    800064da:	0001e917          	auipc	s2,0x1e
    800064de:	b2690913          	addi	s2,s2,-1242 # 80024000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    800064e2:	00020497          	auipc	s1,0x20
    800064e6:	b1e48493          	addi	s1,s1,-1250 # 80026000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    800064ea:	078e                	slli	a5,a5,0x3
    800064ec:	97ba                	add	a5,a5,a4
    800064ee:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    800064f0:	20078713          	addi	a4,a5,512
    800064f4:	0712                	slli	a4,a4,0x4
    800064f6:	974a                	add	a4,a4,s2
    800064f8:	03074703          	lbu	a4,48(a4)
    800064fc:	ef21                	bnez	a4,80006554 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800064fe:	20078793          	addi	a5,a5,512
    80006502:	0792                	slli	a5,a5,0x4
    80006504:	97ca                	add	a5,a5,s2
    80006506:	7798                	ld	a4,40(a5)
    80006508:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    8000650c:	7788                	ld	a0,40(a5)
    8000650e:	ffffc097          	auipc	ra,0xffffc
    80006512:	1d8080e7          	jalr	472(ra) # 800026e6 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006516:	0204d783          	lhu	a5,32(s1)
    8000651a:	2785                	addiw	a5,a5,1
    8000651c:	8b9d                	andi	a5,a5,7
    8000651e:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006522:	6898                	ld	a4,16(s1)
    80006524:	00275683          	lhu	a3,2(a4)
    80006528:	8a9d                	andi	a3,a3,7
    8000652a:	fcf690e3          	bne	a3,a5,800064ea <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000652e:	10001737          	lui	a4,0x10001
    80006532:	533c                	lw	a5,96(a4)
    80006534:	8b8d                	andi	a5,a5,3
    80006536:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    80006538:	00020517          	auipc	a0,0x20
    8000653c:	b7050513          	addi	a0,a0,-1168 # 800260a8 <disk+0x20a8>
    80006540:	ffffa097          	auipc	ra,0xffffa
    80006544:	770080e7          	jalr	1904(ra) # 80000cb0 <release>
}
    80006548:	60e2                	ld	ra,24(sp)
    8000654a:	6442                	ld	s0,16(sp)
    8000654c:	64a2                	ld	s1,8(sp)
    8000654e:	6902                	ld	s2,0(sp)
    80006550:	6105                	addi	sp,sp,32
    80006552:	8082                	ret
      panic("virtio_disk_intr status");
    80006554:	00002517          	auipc	a0,0x2
    80006558:	38450513          	addi	a0,a0,900 # 800088d8 <syscalls+0x3d0>
    8000655c:	ffffa097          	auipc	ra,0xffffa
    80006560:	fe4080e7          	jalr	-28(ra) # 80000540 <panic>
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
