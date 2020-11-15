
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
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
    80000022:	f14027f3          	csrr	a5,mhartid
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	6709                	lui	a4,0x2
    8000003a:	71070713          	addi	a4,a4,1808 # 2710 <_entry-0x7fffd8f0>
    8000003e:	963a                	add	a2,a2,a4
    80000040:	e290                	sd	a2,0(a3)
    80000042:	0057979b          	slliw	a5,a5,0x5
    80000046:	078e                	slli	a5,a5,0x3
    80000048:	00009617          	auipc	a2,0x9
    8000004c:	fe860613          	addi	a2,a2,-24 # 80009030 <mscratch0>
    80000050:	97b2                	add	a5,a5,a2
    80000052:	f394                	sd	a3,32(a5)
    80000054:	f798                	sd	a4,40(a5)
    80000056:	34079073          	csrw	mscratch,a5
    8000005a:	00006797          	auipc	a5,0x6
    8000005e:	f1678793          	addi	a5,a5,-234 # 80005f70 <timervec>
    80000062:	30579073          	csrw	mtvec,a5
    80000066:	300027f3          	csrr	a5,mstatus
    8000006a:	0087e793          	ori	a5,a5,8
    8000006e:	30079073          	csrw	mstatus,a5
    80000072:	304027f3          	csrr	a5,mie
    80000076:	0807e793          	ori	a5,a5,128
    8000007a:	30479073          	csrw	mie,a5
    8000007e:	6422                	ld	s0,8(sp)
    80000080:	0141                	addi	sp,sp,16
    80000082:	8082                	ret

0000000080000084 <start>:
    80000084:	1141                	addi	sp,sp,-16
    80000086:	e406                	sd	ra,8(sp)
    80000088:	e022                	sd	s0,0(sp)
    8000008a:	0800                	addi	s0,sp,16
    8000008c:	300027f3          	csrr	a5,mstatus
    80000090:	7779                	lui	a4,0xffffe
    80000092:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd77ff>
    80000096:	8ff9                	and	a5,a5,a4
    80000098:	6705                	lui	a4,0x1
    8000009a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000009e:	8fd9                	or	a5,a5,a4
    800000a0:	30079073          	csrw	mstatus,a5
    800000a4:	00001797          	auipc	a5,0x1
    800000a8:	e0278793          	addi	a5,a5,-510 # 80000ea6 <main>
    800000ac:	34179073          	csrw	mepc,a5
    800000b0:	4781                	li	a5,0
    800000b2:	18079073          	csrw	satp,a5
    800000b6:	67c1                	lui	a5,0x10
    800000b8:	17fd                	addi	a5,a5,-1
    800000ba:	30279073          	csrw	medeleg,a5
    800000be:	30379073          	csrw	mideleg,a5
    800000c2:	104027f3          	csrr	a5,sie
    800000c6:	2227e793          	ori	a5,a5,546
    800000ca:	10479073          	csrw	sie,a5
    800000ce:	00000097          	auipc	ra,0x0
    800000d2:	f4e080e7          	jalr	-178(ra) # 8000001c <timerinit>
    800000d6:	f14027f3          	csrr	a5,mhartid
    800000da:	2781                	sext.w	a5,a5
    800000dc:	823e                	mv	tp,a5
    800000de:	30200073          	mret
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
    80000128:	718080e7          	jalr	1816(ra) # 8000283c <either_copyin>
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
    800001cc:	c00080e7          	jalr	-1024(ra) # 80001dc8 <myproc>
    800001d0:	591c                	lw	a5,48(a0)
    800001d2:	e7b5                	bnez	a5,8000023e <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d4:	85a6                	mv	a1,s1
    800001d6:	854a                	mv	a0,s2
    800001d8:	00002097          	auipc	ra,0x2
    800001dc:	37e080e7          	jalr	894(ra) # 80002556 <sleep>
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
    80000218:	5d2080e7          	jalr	1490(ra) # 800027e6 <either_copyout>
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
    800002f8:	59e080e7          	jalr	1438(ra) # 80002892 <procdump>
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
    8000044c:	28e080e7          	jalr	654(ra) # 800026d6 <wakeup>
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
    800008a4:	e36080e7          	jalr	-458(ra) # 800026d6 <wakeup>
    
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
    8000093e:	c1c080e7          	jalr	-996(ra) # 80002556 <sleep>
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
    80000a10:	1101                	addi	sp,sp,-32
    80000a12:	ec06                	sd	ra,24(sp)
    80000a14:	e822                	sd	s0,16(sp)
    80000a16:	e426                	sd	s1,8(sp)
    80000a18:	e04a                	sd	s2,0(sp)
    80000a1a:	1000                	addi	s0,sp,32
    80000a1c:	03451793          	slli	a5,a0,0x34
    80000a20:	ebb9                	bnez	a5,80000a76 <kfree+0x66>
    80000a22:	84aa                	mv	s1,a0
    80000a24:	00026797          	auipc	a5,0x26
    80000a28:	5dc78793          	addi	a5,a5,1500 # 80027000 <end>
    80000a2c:	04f56563          	bltu	a0,a5,80000a76 <kfree+0x66>
    80000a30:	47c5                	li	a5,17
    80000a32:	07ee                	slli	a5,a5,0x1b
    80000a34:	04f57163          	bgeu	a0,a5,80000a76 <kfree+0x66>
    80000a38:	6605                	lui	a2,0x1
    80000a3a:	4585                	li	a1,1
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	2bc080e7          	jalr	700(ra) # 80000cf8 <memset>
    80000a44:	00011917          	auipc	s2,0x11
    80000a48:	eec90913          	addi	s2,s2,-276 # 80011930 <kmem>
    80000a4c:	854a                	mv	a0,s2
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	1ae080e7          	jalr	430(ra) # 80000bfc <acquire>
    80000a56:	01893783          	ld	a5,24(s2)
    80000a5a:	e09c                	sd	a5,0(s1)
    80000a5c:	00993c23          	sd	s1,24(s2)
    80000a60:	854a                	mv	a0,s2
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	24e080e7          	jalr	590(ra) # 80000cb0 <release>
    80000a6a:	60e2                	ld	ra,24(sp)
    80000a6c:	6442                	ld	s0,16(sp)
    80000a6e:	64a2                	ld	s1,8(sp)
    80000a70:	6902                	ld	s2,0(sp)
    80000a72:	6105                	addi	sp,sp,32
    80000a74:	8082                	ret
    80000a76:	00007517          	auipc	a0,0x7
    80000a7a:	5ea50513          	addi	a0,a0,1514 # 80008060 <digits+0x20>
    80000a7e:	00000097          	auipc	ra,0x0
    80000a82:	ac2080e7          	jalr	-1342(ra) # 80000540 <panic>

0000000080000a86 <freerange>:
    80000a86:	7179                	addi	sp,sp,-48
    80000a88:	f406                	sd	ra,40(sp)
    80000a8a:	f022                	sd	s0,32(sp)
    80000a8c:	ec26                	sd	s1,24(sp)
    80000a8e:	e84a                	sd	s2,16(sp)
    80000a90:	e44e                	sd	s3,8(sp)
    80000a92:	e052                	sd	s4,0(sp)
    80000a94:	1800                	addi	s0,sp,48
    80000a96:	6785                	lui	a5,0x1
    80000a98:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a9c:	94aa                	add	s1,s1,a0
    80000a9e:	757d                	lui	a0,0xfffff
    80000aa0:	8ce9                	and	s1,s1,a0
    80000aa2:	94be                	add	s1,s1,a5
    80000aa4:	0095ee63          	bltu	a1,s1,80000ac0 <freerange+0x3a>
    80000aa8:	892e                	mv	s2,a1
    80000aaa:	7a7d                	lui	s4,0xfffff
    80000aac:	6985                	lui	s3,0x1
    80000aae:	01448533          	add	a0,s1,s4
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	f5e080e7          	jalr	-162(ra) # 80000a10 <kfree>
    80000aba:	94ce                	add	s1,s1,s3
    80000abc:	fe9979e3          	bgeu	s2,s1,80000aae <freerange+0x28>
    80000ac0:	70a2                	ld	ra,40(sp)
    80000ac2:	7402                	ld	s0,32(sp)
    80000ac4:	64e2                	ld	s1,24(sp)
    80000ac6:	6942                	ld	s2,16(sp)
    80000ac8:	69a2                	ld	s3,8(sp)
    80000aca:	6a02                	ld	s4,0(sp)
    80000acc:	6145                	addi	sp,sp,48
    80000ace:	8082                	ret

0000000080000ad0 <kinit>:
    80000ad0:	1141                	addi	sp,sp,-16
    80000ad2:	e406                	sd	ra,8(sp)
    80000ad4:	e022                	sd	s0,0(sp)
    80000ad6:	0800                	addi	s0,sp,16
    80000ad8:	00007597          	auipc	a1,0x7
    80000adc:	59058593          	addi	a1,a1,1424 # 80008068 <digits+0x28>
    80000ae0:	00011517          	auipc	a0,0x11
    80000ae4:	e5050513          	addi	a0,a0,-432 # 80011930 <kmem>
    80000ae8:	00000097          	auipc	ra,0x0
    80000aec:	084080e7          	jalr	132(ra) # 80000b6c <initlock>
    80000af0:	45c5                	li	a1,17
    80000af2:	05ee                	slli	a1,a1,0x1b
    80000af4:	00026517          	auipc	a0,0x26
    80000af8:	50c50513          	addi	a0,a0,1292 # 80027000 <end>
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	f8a080e7          	jalr	-118(ra) # 80000a86 <freerange>
    80000b04:	60a2                	ld	ra,8(sp)
    80000b06:	6402                	ld	s0,0(sp)
    80000b08:	0141                	addi	sp,sp,16
    80000b0a:	8082                	ret

0000000080000b0c <kalloc>:
    80000b0c:	1101                	addi	sp,sp,-32
    80000b0e:	ec06                	sd	ra,24(sp)
    80000b10:	e822                	sd	s0,16(sp)
    80000b12:	e426                	sd	s1,8(sp)
    80000b14:	1000                	addi	s0,sp,32
    80000b16:	00011497          	auipc	s1,0x11
    80000b1a:	e1a48493          	addi	s1,s1,-486 # 80011930 <kmem>
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	0dc080e7          	jalr	220(ra) # 80000bfc <acquire>
    80000b28:	6c84                	ld	s1,24(s1)
    80000b2a:	c885                	beqz	s1,80000b5a <kalloc+0x4e>
    80000b2c:	609c                	ld	a5,0(s1)
    80000b2e:	00011517          	auipc	a0,0x11
    80000b32:	e0250513          	addi	a0,a0,-510 # 80011930 <kmem>
    80000b36:	ed1c                	sd	a5,24(a0)
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	178080e7          	jalr	376(ra) # 80000cb0 <release>
    80000b40:	6605                	lui	a2,0x1
    80000b42:	4595                	li	a1,5
    80000b44:	8526                	mv	a0,s1
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	1b2080e7          	jalr	434(ra) # 80000cf8 <memset>
    80000b4e:	8526                	mv	a0,s1
    80000b50:	60e2                	ld	ra,24(sp)
    80000b52:	6442                	ld	s0,16(sp)
    80000b54:	64a2                	ld	s1,8(sp)
    80000b56:	6105                	addi	sp,sp,32
    80000b58:	8082                	ret
    80000b5a:	00011517          	auipc	a0,0x11
    80000b5e:	dd650513          	addi	a0,a0,-554 # 80011930 <kmem>
    80000b62:	00000097          	auipc	ra,0x0
    80000b66:	14e080e7          	jalr	334(ra) # 80000cb0 <release>
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
    80000b9a:	216080e7          	jalr	534(ra) # 80001dac <mycpu>
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

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bba:	100024f3          	csrr	s1,sstatus
    80000bbe:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bc8:	00001097          	auipc	ra,0x1
    80000bcc:	1e4080e7          	jalr	484(ra) # 80001dac <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cf89                	beqz	a5,80000bec <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	00001097          	auipc	ra,0x1
    80000bd8:	1d8080e7          	jalr	472(ra) # 80001dac <mycpu>
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
    80000bf0:	1c0080e7          	jalr	448(ra) # 80001dac <mycpu>
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
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
    80000c30:	180080e7          	jalr	384(ra) # 80001dac <mycpu>
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
    80000c5c:	154080e7          	jalr	340(ra) # 80001dac <mycpu>
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
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e422                	sd	s0,8(sp)
    80000cfc:	0800                	addi	s0,sp,16
    80000cfe:	ca19                	beqz	a2,80000d14 <memset+0x1c>
    80000d00:	87aa                	mv	a5,a0
    80000d02:	1602                	slli	a2,a2,0x20
    80000d04:	9201                	srli	a2,a2,0x20
    80000d06:	00a60733          	add	a4,a2,a0
    80000d0a:	00b78023          	sb	a1,0(a5)
    80000d0e:	0785                	addi	a5,a5,1
    80000d10:	fee79de3          	bne	a5,a4,80000d0a <memset+0x12>
    80000d14:	6422                	ld	s0,8(sp)
    80000d16:	0141                	addi	sp,sp,16
    80000d18:	8082                	ret

0000000080000d1a <memcmp>:
    80000d1a:	1141                	addi	sp,sp,-16
    80000d1c:	e422                	sd	s0,8(sp)
    80000d1e:	0800                	addi	s0,sp,16
    80000d20:	ca05                	beqz	a2,80000d50 <memcmp+0x36>
    80000d22:	fff6069b          	addiw	a3,a2,-1
    80000d26:	1682                	slli	a3,a3,0x20
    80000d28:	9281                	srli	a3,a3,0x20
    80000d2a:	0685                	addi	a3,a3,1
    80000d2c:	96aa                	add	a3,a3,a0
    80000d2e:	00054783          	lbu	a5,0(a0)
    80000d32:	0005c703          	lbu	a4,0(a1)
    80000d36:	00e79863          	bne	a5,a4,80000d46 <memcmp+0x2c>
    80000d3a:	0505                	addi	a0,a0,1
    80000d3c:	0585                	addi	a1,a1,1
    80000d3e:	fed518e3          	bne	a0,a3,80000d2e <memcmp+0x14>
    80000d42:	4501                	li	a0,0
    80000d44:	a019                	j	80000d4a <memcmp+0x30>
    80000d46:	40e7853b          	subw	a0,a5,a4
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
    80000d50:	4501                	li	a0,0
    80000d52:	bfe5                	j	80000d4a <memcmp+0x30>

0000000080000d54 <memmove>:
    80000d54:	1141                	addi	sp,sp,-16
    80000d56:	e422                	sd	s0,8(sp)
    80000d58:	0800                	addi	s0,sp,16
    80000d5a:	02a5e563          	bltu	a1,a0,80000d84 <memmove+0x30>
    80000d5e:	fff6069b          	addiw	a3,a2,-1
    80000d62:	ce11                	beqz	a2,80000d7e <memmove+0x2a>
    80000d64:	1682                	slli	a3,a3,0x20
    80000d66:	9281                	srli	a3,a3,0x20
    80000d68:	0685                	addi	a3,a3,1
    80000d6a:	96ae                	add	a3,a3,a1
    80000d6c:	87aa                	mv	a5,a0
    80000d6e:	0585                	addi	a1,a1,1
    80000d70:	0785                	addi	a5,a5,1
    80000d72:	fff5c703          	lbu	a4,-1(a1)
    80000d76:	fee78fa3          	sb	a4,-1(a5)
    80000d7a:	fed59ae3          	bne	a1,a3,80000d6e <memmove+0x1a>
    80000d7e:	6422                	ld	s0,8(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret
    80000d84:	02061713          	slli	a4,a2,0x20
    80000d88:	9301                	srli	a4,a4,0x20
    80000d8a:	00e587b3          	add	a5,a1,a4
    80000d8e:	fcf578e3          	bgeu	a0,a5,80000d5e <memmove+0xa>
    80000d92:	972a                	add	a4,a4,a0
    80000d94:	fff6069b          	addiw	a3,a2,-1
    80000d98:	d27d                	beqz	a2,80000d7e <memmove+0x2a>
    80000d9a:	02069613          	slli	a2,a3,0x20
    80000d9e:	9201                	srli	a2,a2,0x20
    80000da0:	fff64613          	not	a2,a2
    80000da4:	963e                	add	a2,a2,a5
    80000da6:	17fd                	addi	a5,a5,-1
    80000da8:	177d                	addi	a4,a4,-1
    80000daa:	0007c683          	lbu	a3,0(a5)
    80000dae:	00d70023          	sb	a3,0(a4)
    80000db2:	fef61ae3          	bne	a2,a5,80000da6 <memmove+0x52>
    80000db6:	b7e1                	j	80000d7e <memmove+0x2a>

0000000080000db8 <memcpy>:
    80000db8:	1141                	addi	sp,sp,-16
    80000dba:	e406                	sd	ra,8(sp)
    80000dbc:	e022                	sd	s0,0(sp)
    80000dbe:	0800                	addi	s0,sp,16
    80000dc0:	00000097          	auipc	ra,0x0
    80000dc4:	f94080e7          	jalr	-108(ra) # 80000d54 <memmove>
    80000dc8:	60a2                	ld	ra,8(sp)
    80000dca:	6402                	ld	s0,0(sp)
    80000dcc:	0141                	addi	sp,sp,16
    80000dce:	8082                	ret

0000000080000dd0 <strncmp>:
    80000dd0:	1141                	addi	sp,sp,-16
    80000dd2:	e422                	sd	s0,8(sp)
    80000dd4:	0800                	addi	s0,sp,16
    80000dd6:	ce11                	beqz	a2,80000df2 <strncmp+0x22>
    80000dd8:	00054783          	lbu	a5,0(a0)
    80000ddc:	cf89                	beqz	a5,80000df6 <strncmp+0x26>
    80000dde:	0005c703          	lbu	a4,0(a1)
    80000de2:	00f71a63          	bne	a4,a5,80000df6 <strncmp+0x26>
    80000de6:	367d                	addiw	a2,a2,-1
    80000de8:	0505                	addi	a0,a0,1
    80000dea:	0585                	addi	a1,a1,1
    80000dec:	f675                	bnez	a2,80000dd8 <strncmp+0x8>
    80000dee:	4501                	li	a0,0
    80000df0:	a809                	j	80000e02 <strncmp+0x32>
    80000df2:	4501                	li	a0,0
    80000df4:	a039                	j	80000e02 <strncmp+0x32>
    80000df6:	ca09                	beqz	a2,80000e08 <strncmp+0x38>
    80000df8:	00054503          	lbu	a0,0(a0)
    80000dfc:	0005c783          	lbu	a5,0(a1)
    80000e00:	9d1d                	subw	a0,a0,a5
    80000e02:	6422                	ld	s0,8(sp)
    80000e04:	0141                	addi	sp,sp,16
    80000e06:	8082                	ret
    80000e08:	4501                	li	a0,0
    80000e0a:	bfe5                	j	80000e02 <strncmp+0x32>

0000000080000e0c <strncpy>:
    80000e0c:	1141                	addi	sp,sp,-16
    80000e0e:	e422                	sd	s0,8(sp)
    80000e10:	0800                	addi	s0,sp,16
    80000e12:	872a                	mv	a4,a0
    80000e14:	8832                	mv	a6,a2
    80000e16:	367d                	addiw	a2,a2,-1
    80000e18:	01005963          	blez	a6,80000e2a <strncpy+0x1e>
    80000e1c:	0705                	addi	a4,a4,1
    80000e1e:	0005c783          	lbu	a5,0(a1)
    80000e22:	fef70fa3          	sb	a5,-1(a4)
    80000e26:	0585                	addi	a1,a1,1
    80000e28:	f7f5                	bnez	a5,80000e14 <strncpy+0x8>
    80000e2a:	86ba                	mv	a3,a4
    80000e2c:	00c05c63          	blez	a2,80000e44 <strncpy+0x38>
    80000e30:	0685                	addi	a3,a3,1
    80000e32:	fe068fa3          	sb	zero,-1(a3)
    80000e36:	fff6c793          	not	a5,a3
    80000e3a:	9fb9                	addw	a5,a5,a4
    80000e3c:	010787bb          	addw	a5,a5,a6
    80000e40:	fef048e3          	bgtz	a5,80000e30 <strncpy+0x24>
    80000e44:	6422                	ld	s0,8(sp)
    80000e46:	0141                	addi	sp,sp,16
    80000e48:	8082                	ret

0000000080000e4a <safestrcpy>:
    80000e4a:	1141                	addi	sp,sp,-16
    80000e4c:	e422                	sd	s0,8(sp)
    80000e4e:	0800                	addi	s0,sp,16
    80000e50:	02c05363          	blez	a2,80000e76 <safestrcpy+0x2c>
    80000e54:	fff6069b          	addiw	a3,a2,-1
    80000e58:	1682                	slli	a3,a3,0x20
    80000e5a:	9281                	srli	a3,a3,0x20
    80000e5c:	96ae                	add	a3,a3,a1
    80000e5e:	87aa                	mv	a5,a0
    80000e60:	00d58963          	beq	a1,a3,80000e72 <safestrcpy+0x28>
    80000e64:	0585                	addi	a1,a1,1
    80000e66:	0785                	addi	a5,a5,1
    80000e68:	fff5c703          	lbu	a4,-1(a1)
    80000e6c:	fee78fa3          	sb	a4,-1(a5)
    80000e70:	fb65                	bnez	a4,80000e60 <safestrcpy+0x16>
    80000e72:	00078023          	sb	zero,0(a5)
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <strlen>:
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e422                	sd	s0,8(sp)
    80000e80:	0800                	addi	s0,sp,16
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
    80000e9c:	6422                	ld	s0,8(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret
    80000ea2:	4501                	li	a0,0
    80000ea4:	bfe5                	j	80000e9c <strlen+0x20>

0000000080000ea6 <main>:
    80000ea6:	1141                	addi	sp,sp,-16
    80000ea8:	e406                	sd	ra,8(sp)
    80000eaa:	e022                	sd	s0,0(sp)
    80000eac:	0800                	addi	s0,sp,16
    80000eae:	00001097          	auipc	ra,0x1
    80000eb2:	eee080e7          	jalr	-274(ra) # 80001d9c <cpuid>
    80000eb6:	00008717          	auipc	a4,0x8
    80000eba:	15670713          	addi	a4,a4,342 # 8000900c <started>
    80000ebe:	c139                	beqz	a0,80000f04 <main+0x5e>
    80000ec0:	431c                	lw	a5,0(a4)
    80000ec2:	2781                	sext.w	a5,a5
    80000ec4:	dff5                	beqz	a5,80000ec0 <main+0x1a>
    80000ec6:	0ff0000f          	fence
    80000eca:	00001097          	auipc	ra,0x1
    80000ece:	ed2080e7          	jalr	-302(ra) # 80001d9c <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	20450513          	addi	a0,a0,516 # 800080d8 <digits+0x98>
    80000edc:	fffff097          	auipc	ra,0xfffff
    80000ee0:	6ae080e7          	jalr	1710(ra) # 8000058a <printf>
    80000ee4:	00000097          	auipc	ra,0x0
    80000ee8:	0c8080e7          	jalr	200(ra) # 80000fac <kvminithart>
    80000eec:	00002097          	auipc	ra,0x2
    80000ef0:	ae8080e7          	jalr	-1304(ra) # 800029d4 <trapinithart>
    80000ef4:	00005097          	auipc	ra,0x5
    80000ef8:	0bc080e7          	jalr	188(ra) # 80005fb0 <plicinithart>
    80000efc:	00001097          	auipc	ra,0x1
    80000f00:	42e080e7          	jalr	1070(ra) # 8000232a <scheduler>
    80000f04:	fffff097          	auipc	ra,0xfffff
    80000f08:	54e080e7          	jalr	1358(ra) # 80000452 <consoleinit>
    80000f0c:	00000097          	auipc	ra,0x0
    80000f10:	85e080e7          	jalr	-1954(ra) # 8000076a <printfinit>
    80000f14:	00007517          	auipc	a0,0x7
    80000f18:	34450513          	addi	a0,a0,836 # 80008258 <digits+0x218>
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	66e080e7          	jalr	1646(ra) # 8000058a <printf>
    80000f24:	00007517          	auipc	a0,0x7
    80000f28:	17c50513          	addi	a0,a0,380 # 800080a0 <digits+0x60>
    80000f2c:	fffff097          	auipc	ra,0xfffff
    80000f30:	65e080e7          	jalr	1630(ra) # 8000058a <printf>
    80000f34:	00000097          	auipc	ra,0x0
    80000f38:	b9c080e7          	jalr	-1124(ra) # 80000ad0 <kinit>
    80000f3c:	00000097          	auipc	ra,0x0
    80000f40:	2a0080e7          	jalr	672(ra) # 800011dc <kvminit>
    80000f44:	00000097          	auipc	ra,0x0
    80000f48:	068080e7          	jalr	104(ra) # 80000fac <kvminithart>
    80000f4c:	00001097          	auipc	ra,0x1
    80000f50:	d48080e7          	jalr	-696(ra) # 80001c94 <procinit>
    80000f54:	00002097          	auipc	ra,0x2
    80000f58:	a58080e7          	jalr	-1448(ra) # 800029ac <trapinit>
    80000f5c:	00002097          	auipc	ra,0x2
    80000f60:	a78080e7          	jalr	-1416(ra) # 800029d4 <trapinithart>
    80000f64:	00005097          	auipc	ra,0x5
    80000f68:	036080e7          	jalr	54(ra) # 80005f9a <plicinit>
    80000f6c:	00005097          	auipc	ra,0x5
    80000f70:	044080e7          	jalr	68(ra) # 80005fb0 <plicinithart>
    80000f74:	00002097          	auipc	ra,0x2
    80000f78:	1e6080e7          	jalr	486(ra) # 8000315a <binit>
    80000f7c:	00003097          	auipc	ra,0x3
    80000f80:	878080e7          	jalr	-1928(ra) # 800037f4 <iinit>
    80000f84:	00004097          	auipc	ra,0x4
    80000f88:	816080e7          	jalr	-2026(ra) # 8000479a <fileinit>
    80000f8c:	00005097          	auipc	ra,0x5
    80000f90:	12c080e7          	jalr	300(ra) # 800060b8 <virtio_disk_init>
    80000f94:	00001097          	auipc	ra,0x1
    80000f98:	12c080e7          	jalr	300(ra) # 800020c0 <userinit>
    80000f9c:	0ff0000f          	fence
    80000fa0:	4785                	li	a5,1
    80000fa2:	00008717          	auipc	a4,0x8
    80000fa6:	06f72523          	sw	a5,106(a4) # 8000900c <started>
    80000faa:	bf89                	j	80000efc <main+0x56>

0000000080000fac <kvminithart>:
    80000fac:	1141                	addi	sp,sp,-16
    80000fae:	e422                	sd	s0,8(sp)
    80000fb0:	0800                	addi	s0,sp,16
    80000fb2:	00008797          	auipc	a5,0x8
    80000fb6:	05e7b783          	ld	a5,94(a5) # 80009010 <kernel_pagetable>
    80000fba:	83b1                	srli	a5,a5,0xc
    80000fbc:	577d                	li	a4,-1
    80000fbe:	177e                	slli	a4,a4,0x3f
    80000fc0:	8fd9                	or	a5,a5,a4
    80000fc2:	18079073          	csrw	satp,a5
    80000fc6:	12000073          	sfence.vma
    80000fca:	6422                	ld	s0,8(sp)
    80000fcc:	0141                	addi	sp,sp,16
    80000fce:	8082                	ret

0000000080000fd0 <walk>:
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
    80000fea:	57fd                	li	a5,-1
    80000fec:	83e9                	srli	a5,a5,0x1a
    80000fee:	4a79                	li	s4,30
    80000ff0:	4b31                	li	s6,12
    80000ff2:	04b7f263          	bgeu	a5,a1,80001036 <walk+0x66>
    80000ff6:	00007517          	auipc	a0,0x7
    80000ffa:	0fa50513          	addi	a0,a0,250 # 800080f0 <digits+0xb0>
    80000ffe:	fffff097          	auipc	ra,0xfffff
    80001002:	542080e7          	jalr	1346(ra) # 80000540 <panic>
    80001006:	060a8663          	beqz	s5,80001072 <walk+0xa2>
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	b02080e7          	jalr	-1278(ra) # 80000b0c <kalloc>
    80001012:	84aa                	mv	s1,a0
    80001014:	c529                	beqz	a0,8000105e <walk+0x8e>
    80001016:	6605                	lui	a2,0x1
    80001018:	4581                	li	a1,0
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	cde080e7          	jalr	-802(ra) # 80000cf8 <memset>
    80001022:	00c4d793          	srli	a5,s1,0xc
    80001026:	07aa                	slli	a5,a5,0xa
    80001028:	0017e793          	ori	a5,a5,1
    8000102c:	00f93023          	sd	a5,0(s2)
    80001030:	3a5d                	addiw	s4,s4,-9
    80001032:	036a0063          	beq	s4,s6,80001052 <walk+0x82>
    80001036:	0149d933          	srl	s2,s3,s4
    8000103a:	1ff97913          	andi	s2,s2,511
    8000103e:	090e                	slli	s2,s2,0x3
    80001040:	9926                	add	s2,s2,s1
    80001042:	00093483          	ld	s1,0(s2)
    80001046:	0014f793          	andi	a5,s1,1
    8000104a:	dfd5                	beqz	a5,80001006 <walk+0x36>
    8000104c:	80a9                	srli	s1,s1,0xa
    8000104e:	04b2                	slli	s1,s1,0xc
    80001050:	b7c5                	j	80001030 <walk+0x60>
    80001052:	00c9d513          	srli	a0,s3,0xc
    80001056:	1ff57513          	andi	a0,a0,511
    8000105a:	050e                	slli	a0,a0,0x3
    8000105c:	9526                	add	a0,a0,s1
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
    80001072:	4501                	li	a0,0
    80001074:	b7ed                	j	8000105e <walk+0x8e>

0000000080001076 <walkaddr>:
    80001076:	57fd                	li	a5,-1
    80001078:	83e9                	srli	a5,a5,0x1a
    8000107a:	00b7f463          	bgeu	a5,a1,80001082 <walkaddr+0xc>
    8000107e:	4501                	li	a0,0
    80001080:	8082                	ret
    80001082:	1141                	addi	sp,sp,-16
    80001084:	e406                	sd	ra,8(sp)
    80001086:	e022                	sd	s0,0(sp)
    80001088:	0800                	addi	s0,sp,16
    8000108a:	4601                	li	a2,0
    8000108c:	00000097          	auipc	ra,0x0
    80001090:	f44080e7          	jalr	-188(ra) # 80000fd0 <walk>
    80001094:	c105                	beqz	a0,800010b4 <walkaddr+0x3e>
    80001096:	611c                	ld	a5,0(a0)
    80001098:	0117f693          	andi	a3,a5,17
    8000109c:	4745                	li	a4,17
    8000109e:	4501                	li	a0,0
    800010a0:	00e68663          	beq	a3,a4,800010ac <walkaddr+0x36>
    800010a4:	60a2                	ld	ra,8(sp)
    800010a6:	6402                	ld	s0,0(sp)
    800010a8:	0141                	addi	sp,sp,16
    800010aa:	8082                	ret
    800010ac:	00a7d513          	srli	a0,a5,0xa
    800010b0:	0532                	slli	a0,a0,0xc
    800010b2:	bfcd                	j	800010a4 <walkaddr+0x2e>
    800010b4:	4501                	li	a0,0
    800010b6:	b7fd                	j	800010a4 <walkaddr+0x2e>

00000000800010b8 <kvmpa>:
    800010b8:	1101                	addi	sp,sp,-32
    800010ba:	ec06                	sd	ra,24(sp)
    800010bc:	e822                	sd	s0,16(sp)
    800010be:	e426                	sd	s1,8(sp)
    800010c0:	1000                	addi	s0,sp,32
    800010c2:	85aa                	mv	a1,a0
    800010c4:	1552                	slli	a0,a0,0x34
    800010c6:	03455493          	srli	s1,a0,0x34
    800010ca:	4601                	li	a2,0
    800010cc:	00008517          	auipc	a0,0x8
    800010d0:	f4453503          	ld	a0,-188(a0) # 80009010 <kernel_pagetable>
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	efc080e7          	jalr	-260(ra) # 80000fd0 <walk>
    800010dc:	cd09                	beqz	a0,800010f6 <kvmpa+0x3e>
    800010de:	6108                	ld	a0,0(a0)
    800010e0:	00157793          	andi	a5,a0,1
    800010e4:	c38d                	beqz	a5,80001106 <kvmpa+0x4e>
    800010e6:	8129                	srli	a0,a0,0xa
    800010e8:	0532                	slli	a0,a0,0xc
    800010ea:	9526                	add	a0,a0,s1
    800010ec:	60e2                	ld	ra,24(sp)
    800010ee:	6442                	ld	s0,16(sp)
    800010f0:	64a2                	ld	s1,8(sp)
    800010f2:	6105                	addi	sp,sp,32
    800010f4:	8082                	ret
    800010f6:	00007517          	auipc	a0,0x7
    800010fa:	00250513          	addi	a0,a0,2 # 800080f8 <digits+0xb8>
    800010fe:	fffff097          	auipc	ra,0xfffff
    80001102:	442080e7          	jalr	1090(ra) # 80000540 <panic>
    80001106:	00007517          	auipc	a0,0x7
    8000110a:	ff250513          	addi	a0,a0,-14 # 800080f8 <digits+0xb8>
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	432080e7          	jalr	1074(ra) # 80000540 <panic>

0000000080001116 <mappages>:
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
    80001130:	777d                	lui	a4,0xfffff
    80001132:	00e5f7b3          	and	a5,a1,a4
    80001136:	167d                	addi	a2,a2,-1
    80001138:	00b609b3          	add	s3,a2,a1
    8000113c:	00e9f9b3          	and	s3,s3,a4
    80001140:	893e                	mv	s2,a5
    80001142:	40f68a33          	sub	s4,a3,a5
    80001146:	6b85                	lui	s7,0x1
    80001148:	012a04b3          	add	s1,s4,s2
    8000114c:	4605                	li	a2,1
    8000114e:	85ca                	mv	a1,s2
    80001150:	8556                	mv	a0,s5
    80001152:	00000097          	auipc	ra,0x0
    80001156:	e7e080e7          	jalr	-386(ra) # 80000fd0 <walk>
    8000115a:	c51d                	beqz	a0,80001188 <mappages+0x72>
    8000115c:	611c                	ld	a5,0(a0)
    8000115e:	8b85                	andi	a5,a5,1
    80001160:	ef81                	bnez	a5,80001178 <mappages+0x62>
    80001162:	80b1                	srli	s1,s1,0xc
    80001164:	04aa                	slli	s1,s1,0xa
    80001166:	0164e4b3          	or	s1,s1,s6
    8000116a:	0014e493          	ori	s1,s1,1
    8000116e:	e104                	sd	s1,0(a0)
    80001170:	03390863          	beq	s2,s3,800011a0 <mappages+0x8a>
    80001174:	995e                	add	s2,s2,s7
    80001176:	bfc9                	j	80001148 <mappages+0x32>
    80001178:	00007517          	auipc	a0,0x7
    8000117c:	f8850513          	addi	a0,a0,-120 # 80008100 <digits+0xc0>
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	3c0080e7          	jalr	960(ra) # 80000540 <panic>
    80001188:	557d                	li	a0,-1
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
    800011a0:	4501                	li	a0,0
    800011a2:	b7e5                	j	8000118a <mappages+0x74>

00000000800011a4 <kvmmap>:
    800011a4:	1141                	addi	sp,sp,-16
    800011a6:	e406                	sd	ra,8(sp)
    800011a8:	e022                	sd	s0,0(sp)
    800011aa:	0800                	addi	s0,sp,16
    800011ac:	8736                	mv	a4,a3
    800011ae:	86ae                	mv	a3,a1
    800011b0:	85aa                	mv	a1,a0
    800011b2:	00008517          	auipc	a0,0x8
    800011b6:	e5e53503          	ld	a0,-418(a0) # 80009010 <kernel_pagetable>
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	f5c080e7          	jalr	-164(ra) # 80001116 <mappages>
    800011c2:	e509                	bnez	a0,800011cc <kvmmap+0x28>
    800011c4:	60a2                	ld	ra,8(sp)
    800011c6:	6402                	ld	s0,0(sp)
    800011c8:	0141                	addi	sp,sp,16
    800011ca:	8082                	ret
    800011cc:	00007517          	auipc	a0,0x7
    800011d0:	f3c50513          	addi	a0,a0,-196 # 80008108 <digits+0xc8>
    800011d4:	fffff097          	auipc	ra,0xfffff
    800011d8:	36c080e7          	jalr	876(ra) # 80000540 <panic>

00000000800011dc <kvminit>:
    800011dc:	1101                	addi	sp,sp,-32
    800011de:	ec06                	sd	ra,24(sp)
    800011e0:	e822                	sd	s0,16(sp)
    800011e2:	e426                	sd	s1,8(sp)
    800011e4:	1000                	addi	s0,sp,32
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	926080e7          	jalr	-1754(ra) # 80000b0c <kalloc>
    800011ee:	00008797          	auipc	a5,0x8
    800011f2:	e2a7b123          	sd	a0,-478(a5) # 80009010 <kernel_pagetable>
    800011f6:	6605                	lui	a2,0x1
    800011f8:	4581                	li	a1,0
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	afe080e7          	jalr	-1282(ra) # 80000cf8 <memset>
    80001202:	4699                	li	a3,6
    80001204:	6605                	lui	a2,0x1
    80001206:	100005b7          	lui	a1,0x10000
    8000120a:	10000537          	lui	a0,0x10000
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	f96080e7          	jalr	-106(ra) # 800011a4 <kvmmap>
    80001216:	4699                	li	a3,6
    80001218:	6605                	lui	a2,0x1
    8000121a:	100015b7          	lui	a1,0x10001
    8000121e:	10001537          	lui	a0,0x10001
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f82080e7          	jalr	-126(ra) # 800011a4 <kvmmap>
    8000122a:	4699                	li	a3,6
    8000122c:	6641                	lui	a2,0x10
    8000122e:	020005b7          	lui	a1,0x2000
    80001232:	02000537          	lui	a0,0x2000
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	f6e080e7          	jalr	-146(ra) # 800011a4 <kvmmap>
    8000123e:	4699                	li	a3,6
    80001240:	00400637          	lui	a2,0x400
    80001244:	0c0005b7          	lui	a1,0xc000
    80001248:	0c000537          	lui	a0,0xc000
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f58080e7          	jalr	-168(ra) # 800011a4 <kvmmap>
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
    80001274:	4699                	li	a3,6
    80001276:	4645                	li	a2,17
    80001278:	066e                	slli	a2,a2,0x1b
    8000127a:	8e05                	sub	a2,a2,s1
    8000127c:	85a6                	mv	a1,s1
    8000127e:	8526                	mv	a0,s1
    80001280:	00000097          	auipc	ra,0x0
    80001284:	f24080e7          	jalr	-220(ra) # 800011a4 <kvmmap>
    80001288:	46a9                	li	a3,10
    8000128a:	6605                	lui	a2,0x1
    8000128c:	00006597          	auipc	a1,0x6
    80001290:	d7458593          	addi	a1,a1,-652 # 80007000 <_trampoline>
    80001294:	04000537          	lui	a0,0x4000
    80001298:	157d                	addi	a0,a0,-1
    8000129a:	0532                	slli	a0,a0,0xc
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	f08080e7          	jalr	-248(ra) # 800011a4 <kvmmap>
    800012a4:	60e2                	ld	ra,24(sp)
    800012a6:	6442                	ld	s0,16(sp)
    800012a8:	64a2                	ld	s1,8(sp)
    800012aa:	6105                	addi	sp,sp,32
    800012ac:	8082                	ret

00000000800012ae <uvmunmap>:
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
    800012c4:	03459793          	slli	a5,a1,0x34
    800012c8:	e795                	bnez	a5,800012f4 <uvmunmap+0x46>
    800012ca:	8a2a                	mv	s4,a0
    800012cc:	892e                	mv	s2,a1
    800012ce:	8ab6                	mv	s5,a3
    800012d0:	0632                	slli	a2,a2,0xc
    800012d2:	00b609b3          	add	s3,a2,a1
    800012d6:	4b85                	li	s7,1
    800012d8:	6b05                	lui	s6,0x1
    800012da:	0735e263          	bltu	a1,s3,8000133e <uvmunmap+0x90>
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
    800012f4:	00007517          	auipc	a0,0x7
    800012f8:	e1c50513          	addi	a0,a0,-484 # 80008110 <digits+0xd0>
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	244080e7          	jalr	580(ra) # 80000540 <panic>
    80001304:	00007517          	auipc	a0,0x7
    80001308:	e2450513          	addi	a0,a0,-476 # 80008128 <digits+0xe8>
    8000130c:	fffff097          	auipc	ra,0xfffff
    80001310:	234080e7          	jalr	564(ra) # 80000540 <panic>
    80001314:	00007517          	auipc	a0,0x7
    80001318:	e2450513          	addi	a0,a0,-476 # 80008138 <digits+0xf8>
    8000131c:	fffff097          	auipc	ra,0xfffff
    80001320:	224080e7          	jalr	548(ra) # 80000540 <panic>
    80001324:	00007517          	auipc	a0,0x7
    80001328:	e2c50513          	addi	a0,a0,-468 # 80008150 <digits+0x110>
    8000132c:	fffff097          	auipc	ra,0xfffff
    80001330:	214080e7          	jalr	532(ra) # 80000540 <panic>
    80001334:	0004b023          	sd	zero,0(s1)
    80001338:	995a                	add	s2,s2,s6
    8000133a:	fb3972e3          	bgeu	s2,s3,800012de <uvmunmap+0x30>
    8000133e:	4601                	li	a2,0
    80001340:	85ca                	mv	a1,s2
    80001342:	8552                	mv	a0,s4
    80001344:	00000097          	auipc	ra,0x0
    80001348:	c8c080e7          	jalr	-884(ra) # 80000fd0 <walk>
    8000134c:	84aa                	mv	s1,a0
    8000134e:	d95d                	beqz	a0,80001304 <uvmunmap+0x56>
    80001350:	6108                	ld	a0,0(a0)
    80001352:	00157793          	andi	a5,a0,1
    80001356:	dfdd                	beqz	a5,80001314 <uvmunmap+0x66>
    80001358:	3ff57793          	andi	a5,a0,1023
    8000135c:	fd7784e3          	beq	a5,s7,80001324 <uvmunmap+0x76>
    80001360:	fc0a8ae3          	beqz	s5,80001334 <uvmunmap+0x86>
    80001364:	8129                	srli	a0,a0,0xa
    80001366:	0532                	slli	a0,a0,0xc
    80001368:	fffff097          	auipc	ra,0xfffff
    8000136c:	6a8080e7          	jalr	1704(ra) # 80000a10 <kfree>
    80001370:	b7d1                	j	80001334 <uvmunmap+0x86>

0000000080001372 <uvmcreate>:
    80001372:	1101                	addi	sp,sp,-32
    80001374:	ec06                	sd	ra,24(sp)
    80001376:	e822                	sd	s0,16(sp)
    80001378:	e426                	sd	s1,8(sp)
    8000137a:	1000                	addi	s0,sp,32
    8000137c:	fffff097          	auipc	ra,0xfffff
    80001380:	790080e7          	jalr	1936(ra) # 80000b0c <kalloc>
    80001384:	84aa                	mv	s1,a0
    80001386:	c519                	beqz	a0,80001394 <uvmcreate+0x22>
    80001388:	6605                	lui	a2,0x1
    8000138a:	4581                	li	a1,0
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	96c080e7          	jalr	-1684(ra) # 80000cf8 <memset>
    80001394:	8526                	mv	a0,s1
    80001396:	60e2                	ld	ra,24(sp)
    80001398:	6442                	ld	s0,16(sp)
    8000139a:	64a2                	ld	s1,8(sp)
    8000139c:	6105                	addi	sp,sp,32
    8000139e:	8082                	ret

00000000800013a0 <uvminit>:
    800013a0:	7179                	addi	sp,sp,-48
    800013a2:	f406                	sd	ra,40(sp)
    800013a4:	f022                	sd	s0,32(sp)
    800013a6:	ec26                	sd	s1,24(sp)
    800013a8:	e84a                	sd	s2,16(sp)
    800013aa:	e44e                	sd	s3,8(sp)
    800013ac:	e052                	sd	s4,0(sp)
    800013ae:	1800                	addi	s0,sp,48
    800013b0:	6785                	lui	a5,0x1
    800013b2:	04f67863          	bgeu	a2,a5,80001402 <uvminit+0x62>
    800013b6:	8a2a                	mv	s4,a0
    800013b8:	89ae                	mv	s3,a1
    800013ba:	84b2                	mv	s1,a2
    800013bc:	fffff097          	auipc	ra,0xfffff
    800013c0:	750080e7          	jalr	1872(ra) # 80000b0c <kalloc>
    800013c4:	892a                	mv	s2,a0
    800013c6:	6605                	lui	a2,0x1
    800013c8:	4581                	li	a1,0
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	92e080e7          	jalr	-1746(ra) # 80000cf8 <memset>
    800013d2:	4779                	li	a4,30
    800013d4:	86ca                	mv	a3,s2
    800013d6:	6605                	lui	a2,0x1
    800013d8:	4581                	li	a1,0
    800013da:	8552                	mv	a0,s4
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	d3a080e7          	jalr	-710(ra) # 80001116 <mappages>
    800013e4:	8626                	mv	a2,s1
    800013e6:	85ce                	mv	a1,s3
    800013e8:	854a                	mv	a0,s2
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	96a080e7          	jalr	-1686(ra) # 80000d54 <memmove>
    800013f2:	70a2                	ld	ra,40(sp)
    800013f4:	7402                	ld	s0,32(sp)
    800013f6:	64e2                	ld	s1,24(sp)
    800013f8:	6942                	ld	s2,16(sp)
    800013fa:	69a2                	ld	s3,8(sp)
    800013fc:	6a02                	ld	s4,0(sp)
    800013fe:	6145                	addi	sp,sp,48
    80001400:	8082                	ret
    80001402:	00007517          	auipc	a0,0x7
    80001406:	d6650513          	addi	a0,a0,-666 # 80008168 <digits+0x128>
    8000140a:	fffff097          	auipc	ra,0xfffff
    8000140e:	136080e7          	jalr	310(ra) # 80000540 <panic>

0000000080001412 <uvmdealloc>:
    80001412:	1101                	addi	sp,sp,-32
    80001414:	ec06                	sd	ra,24(sp)
    80001416:	e822                	sd	s0,16(sp)
    80001418:	e426                	sd	s1,8(sp)
    8000141a:	1000                	addi	s0,sp,32
    8000141c:	84ae                	mv	s1,a1
    8000141e:	00b67d63          	bgeu	a2,a1,80001438 <uvmdealloc+0x26>
    80001422:	84b2                	mv	s1,a2
    80001424:	6785                	lui	a5,0x1
    80001426:	17fd                	addi	a5,a5,-1
    80001428:	00f60733          	add	a4,a2,a5
    8000142c:	767d                	lui	a2,0xfffff
    8000142e:	8f71                	and	a4,a4,a2
    80001430:	97ae                	add	a5,a5,a1
    80001432:	8ff1                	and	a5,a5,a2
    80001434:	00f76863          	bltu	a4,a5,80001444 <uvmdealloc+0x32>
    80001438:	8526                	mv	a0,s1
    8000143a:	60e2                	ld	ra,24(sp)
    8000143c:	6442                	ld	s0,16(sp)
    8000143e:	64a2                	ld	s1,8(sp)
    80001440:	6105                	addi	sp,sp,32
    80001442:	8082                	ret
    80001444:	8f99                	sub	a5,a5,a4
    80001446:	83b1                	srli	a5,a5,0xc
    80001448:	4685                	li	a3,1
    8000144a:	0007861b          	sext.w	a2,a5
    8000144e:	85ba                	mv	a1,a4
    80001450:	00000097          	auipc	ra,0x0
    80001454:	e5e080e7          	jalr	-418(ra) # 800012ae <uvmunmap>
    80001458:	b7c5                	j	80001438 <uvmdealloc+0x26>

000000008000145a <uvmalloc>:
    8000145a:	0ab66163          	bltu	a2,a1,800014fc <uvmalloc+0xa2>
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
    80001474:	6985                	lui	s3,0x1
    80001476:	19fd                	addi	s3,s3,-1
    80001478:	95ce                	add	a1,a1,s3
    8000147a:	79fd                	lui	s3,0xfffff
    8000147c:	0135f9b3          	and	s3,a1,s3
    80001480:	08c9f063          	bgeu	s3,a2,80001500 <uvmalloc+0xa6>
    80001484:	894e                	mv	s2,s3
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	686080e7          	jalr	1670(ra) # 80000b0c <kalloc>
    8000148e:	84aa                	mv	s1,a0
    80001490:	c51d                	beqz	a0,800014be <uvmalloc+0x64>
    80001492:	6605                	lui	a2,0x1
    80001494:	4581                	li	a1,0
    80001496:	00000097          	auipc	ra,0x0
    8000149a:	862080e7          	jalr	-1950(ra) # 80000cf8 <memset>
    8000149e:	4779                	li	a4,30
    800014a0:	86a6                	mv	a3,s1
    800014a2:	6605                	lui	a2,0x1
    800014a4:	85ca                	mv	a1,s2
    800014a6:	8556                	mv	a0,s5
    800014a8:	00000097          	auipc	ra,0x0
    800014ac:	c6e080e7          	jalr	-914(ra) # 80001116 <mappages>
    800014b0:	e905                	bnez	a0,800014e0 <uvmalloc+0x86>
    800014b2:	6785                	lui	a5,0x1
    800014b4:	993e                	add	s2,s2,a5
    800014b6:	fd4968e3          	bltu	s2,s4,80001486 <uvmalloc+0x2c>
    800014ba:	8552                	mv	a0,s4
    800014bc:	a809                	j	800014ce <uvmalloc+0x74>
    800014be:	864e                	mv	a2,s3
    800014c0:	85ca                	mv	a1,s2
    800014c2:	8556                	mv	a0,s5
    800014c4:	00000097          	auipc	ra,0x0
    800014c8:	f4e080e7          	jalr	-178(ra) # 80001412 <uvmdealloc>
    800014cc:	4501                	li	a0,0
    800014ce:	70e2                	ld	ra,56(sp)
    800014d0:	7442                	ld	s0,48(sp)
    800014d2:	74a2                	ld	s1,40(sp)
    800014d4:	7902                	ld	s2,32(sp)
    800014d6:	69e2                	ld	s3,24(sp)
    800014d8:	6a42                	ld	s4,16(sp)
    800014da:	6aa2                	ld	s5,8(sp)
    800014dc:	6121                	addi	sp,sp,64
    800014de:	8082                	ret
    800014e0:	8526                	mv	a0,s1
    800014e2:	fffff097          	auipc	ra,0xfffff
    800014e6:	52e080e7          	jalr	1326(ra) # 80000a10 <kfree>
    800014ea:	864e                	mv	a2,s3
    800014ec:	85ca                	mv	a1,s2
    800014ee:	8556                	mv	a0,s5
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	f22080e7          	jalr	-222(ra) # 80001412 <uvmdealloc>
    800014f8:	4501                	li	a0,0
    800014fa:	bfd1                	j	800014ce <uvmalloc+0x74>
    800014fc:	852e                	mv	a0,a1
    800014fe:	8082                	ret
    80001500:	8532                	mv	a0,a2
    80001502:	b7f1                	j	800014ce <uvmalloc+0x74>

0000000080001504 <freewalk>:
    80001504:	7179                	addi	sp,sp,-48
    80001506:	f406                	sd	ra,40(sp)
    80001508:	f022                	sd	s0,32(sp)
    8000150a:	ec26                	sd	s1,24(sp)
    8000150c:	e84a                	sd	s2,16(sp)
    8000150e:	e44e                	sd	s3,8(sp)
    80001510:	e052                	sd	s4,0(sp)
    80001512:	1800                	addi	s0,sp,48
    80001514:	8a2a                	mv	s4,a0
    80001516:	84aa                	mv	s1,a0
    80001518:	6905                	lui	s2,0x1
    8000151a:	992a                	add	s2,s2,a0
    8000151c:	4985                	li	s3,1
    8000151e:	a821                	j	80001536 <freewalk+0x32>
    80001520:	8129                	srli	a0,a0,0xa
    80001522:	0532                	slli	a0,a0,0xc
    80001524:	00000097          	auipc	ra,0x0
    80001528:	fe0080e7          	jalr	-32(ra) # 80001504 <freewalk>
    8000152c:	0004b023          	sd	zero,0(s1)
    80001530:	04a1                	addi	s1,s1,8
    80001532:	03248163          	beq	s1,s2,80001554 <freewalk+0x50>
    80001536:	6088                	ld	a0,0(s1)
    80001538:	00f57793          	andi	a5,a0,15
    8000153c:	ff3782e3          	beq	a5,s3,80001520 <freewalk+0x1c>
    80001540:	8905                	andi	a0,a0,1
    80001542:	d57d                	beqz	a0,80001530 <freewalk+0x2c>
    80001544:	00007517          	auipc	a0,0x7
    80001548:	c4450513          	addi	a0,a0,-956 # 80008188 <digits+0x148>
    8000154c:	fffff097          	auipc	ra,0xfffff
    80001550:	ff4080e7          	jalr	-12(ra) # 80000540 <panic>
    80001554:	8552                	mv	a0,s4
    80001556:	fffff097          	auipc	ra,0xfffff
    8000155a:	4ba080e7          	jalr	1210(ra) # 80000a10 <kfree>
    8000155e:	70a2                	ld	ra,40(sp)
    80001560:	7402                	ld	s0,32(sp)
    80001562:	64e2                	ld	s1,24(sp)
    80001564:	6942                	ld	s2,16(sp)
    80001566:	69a2                	ld	s3,8(sp)
    80001568:	6a02                	ld	s4,0(sp)
    8000156a:	6145                	addi	sp,sp,48
    8000156c:	8082                	ret

000000008000156e <uvmfree>:
    8000156e:	1101                	addi	sp,sp,-32
    80001570:	ec06                	sd	ra,24(sp)
    80001572:	e822                	sd	s0,16(sp)
    80001574:	e426                	sd	s1,8(sp)
    80001576:	1000                	addi	s0,sp,32
    80001578:	84aa                	mv	s1,a0
    8000157a:	e999                	bnez	a1,80001590 <uvmfree+0x22>
    8000157c:	8526                	mv	a0,s1
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	f86080e7          	jalr	-122(ra) # 80001504 <freewalk>
    80001586:	60e2                	ld	ra,24(sp)
    80001588:	6442                	ld	s0,16(sp)
    8000158a:	64a2                	ld	s1,8(sp)
    8000158c:	6105                	addi	sp,sp,32
    8000158e:	8082                	ret
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
    800015a6:	c679                	beqz	a2,80001674 <uvmcopy+0xce>
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
    800015c4:	4981                	li	s3,0
    800015c6:	4601                	li	a2,0
    800015c8:	85ce                	mv	a1,s3
    800015ca:	855a                	mv	a0,s6
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	a04080e7          	jalr	-1532(ra) # 80000fd0 <walk>
    800015d4:	c531                	beqz	a0,80001620 <uvmcopy+0x7a>
    800015d6:	6118                	ld	a4,0(a0)
    800015d8:	00177793          	andi	a5,a4,1
    800015dc:	cbb1                	beqz	a5,80001630 <uvmcopy+0x8a>
    800015de:	00a75593          	srli	a1,a4,0xa
    800015e2:	00c59b93          	slli	s7,a1,0xc
    800015e6:	3ff77493          	andi	s1,a4,1023
    800015ea:	fffff097          	auipc	ra,0xfffff
    800015ee:	522080e7          	jalr	1314(ra) # 80000b0c <kalloc>
    800015f2:	892a                	mv	s2,a0
    800015f4:	c939                	beqz	a0,8000164a <uvmcopy+0xa4>
    800015f6:	6605                	lui	a2,0x1
    800015f8:	85de                	mv	a1,s7
    800015fa:	fffff097          	auipc	ra,0xfffff
    800015fe:	75a080e7          	jalr	1882(ra) # 80000d54 <memmove>
    80001602:	8726                	mv	a4,s1
    80001604:	86ca                	mv	a3,s2
    80001606:	6605                	lui	a2,0x1
    80001608:	85ce                	mv	a1,s3
    8000160a:	8556                	mv	a0,s5
    8000160c:	00000097          	auipc	ra,0x0
    80001610:	b0a080e7          	jalr	-1270(ra) # 80001116 <mappages>
    80001614:	e515                	bnez	a0,80001640 <uvmcopy+0x9a>
    80001616:	6785                	lui	a5,0x1
    80001618:	99be                	add	s3,s3,a5
    8000161a:	fb49e6e3          	bltu	s3,s4,800015c6 <uvmcopy+0x20>
    8000161e:	a081                	j	8000165e <uvmcopy+0xb8>
    80001620:	00007517          	auipc	a0,0x7
    80001624:	b7850513          	addi	a0,a0,-1160 # 80008198 <digits+0x158>
    80001628:	fffff097          	auipc	ra,0xfffff
    8000162c:	f18080e7          	jalr	-232(ra) # 80000540 <panic>
    80001630:	00007517          	auipc	a0,0x7
    80001634:	b8850513          	addi	a0,a0,-1144 # 800081b8 <digits+0x178>
    80001638:	fffff097          	auipc	ra,0xfffff
    8000163c:	f08080e7          	jalr	-248(ra) # 80000540 <panic>
    80001640:	854a                	mv	a0,s2
    80001642:	fffff097          	auipc	ra,0xfffff
    80001646:	3ce080e7          	jalr	974(ra) # 80000a10 <kfree>
    8000164a:	4685                	li	a3,1
    8000164c:	00c9d613          	srli	a2,s3,0xc
    80001650:	4581                	li	a1,0
    80001652:	8556                	mv	a0,s5
    80001654:	00000097          	auipc	ra,0x0
    80001658:	c5a080e7          	jalr	-934(ra) # 800012ae <uvmunmap>
    8000165c:	557d                	li	a0,-1
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
    80001674:	4501                	li	a0,0
    80001676:	8082                	ret

0000000080001678 <uvmclear>:
    80001678:	1141                	addi	sp,sp,-16
    8000167a:	e406                	sd	ra,8(sp)
    8000167c:	e022                	sd	s0,0(sp)
    8000167e:	0800                	addi	s0,sp,16
    80001680:	4601                	li	a2,0
    80001682:	00000097          	auipc	ra,0x0
    80001686:	94e080e7          	jalr	-1714(ra) # 80000fd0 <walk>
    8000168a:	c901                	beqz	a0,8000169a <uvmclear+0x22>
    8000168c:	611c                	ld	a5,0(a0)
    8000168e:	9bbd                	andi	a5,a5,-17
    80001690:	e11c                	sd	a5,0(a0)
    80001692:	60a2                	ld	ra,8(sp)
    80001694:	6402                	ld	s0,0(sp)
    80001696:	0141                	addi	sp,sp,16
    80001698:	8082                	ret
    8000169a:	00007517          	auipc	a0,0x7
    8000169e:	b3e50513          	addi	a0,a0,-1218 # 800081d8 <digits+0x198>
    800016a2:	fffff097          	auipc	ra,0xfffff
    800016a6:	e9e080e7          	jalr	-354(ra) # 80000540 <panic>

00000000800016aa <copyout>:
    800016aa:	c6bd                	beqz	a3,80001718 <copyout+0x6e>
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
    800016cc:	7bfd                	lui	s7,0xfffff
    800016ce:	6a85                	lui	s5,0x1
    800016d0:	a015                	j	800016f4 <copyout+0x4a>
    800016d2:	9562                	add	a0,a0,s8
    800016d4:	0004861b          	sext.w	a2,s1
    800016d8:	85d2                	mv	a1,s4
    800016da:	41250533          	sub	a0,a0,s2
    800016de:	fffff097          	auipc	ra,0xfffff
    800016e2:	676080e7          	jalr	1654(ra) # 80000d54 <memmove>
    800016e6:	409989b3          	sub	s3,s3,s1
    800016ea:	9a26                	add	s4,s4,s1
    800016ec:	01590c33          	add	s8,s2,s5
    800016f0:	02098263          	beqz	s3,80001714 <copyout+0x6a>
    800016f4:	017c7933          	and	s2,s8,s7
    800016f8:	85ca                	mv	a1,s2
    800016fa:	855a                	mv	a0,s6
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	97a080e7          	jalr	-1670(ra) # 80001076 <walkaddr>
    80001704:	cd01                	beqz	a0,8000171c <copyout+0x72>
    80001706:	418904b3          	sub	s1,s2,s8
    8000170a:	94d6                	add	s1,s1,s5
    8000170c:	fc99f3e3          	bgeu	s3,s1,800016d2 <copyout+0x28>
    80001710:	84ce                	mv	s1,s3
    80001712:	b7c1                	j	800016d2 <copyout+0x28>
    80001714:	4501                	li	a0,0
    80001716:	a021                	j	8000171e <copyout+0x74>
    80001718:	4501                	li	a0,0
    8000171a:	8082                	ret
    8000171c:	557d                	li	a0,-1
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
    80001736:	caa5                	beqz	a3,800017a6 <copyin+0x70>
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
    80001758:	7bfd                	lui	s7,0xfffff
    8000175a:	6a85                	lui	s5,0x1
    8000175c:	a01d                	j	80001782 <copyin+0x4c>
    8000175e:	018505b3          	add	a1,a0,s8
    80001762:	0004861b          	sext.w	a2,s1
    80001766:	412585b3          	sub	a1,a1,s2
    8000176a:	8552                	mv	a0,s4
    8000176c:	fffff097          	auipc	ra,0xfffff
    80001770:	5e8080e7          	jalr	1512(ra) # 80000d54 <memmove>
    80001774:	409989b3          	sub	s3,s3,s1
    80001778:	9a26                	add	s4,s4,s1
    8000177a:	01590c33          	add	s8,s2,s5
    8000177e:	02098263          	beqz	s3,800017a2 <copyin+0x6c>
    80001782:	017c7933          	and	s2,s8,s7
    80001786:	85ca                	mv	a1,s2
    80001788:	855a                	mv	a0,s6
    8000178a:	00000097          	auipc	ra,0x0
    8000178e:	8ec080e7          	jalr	-1812(ra) # 80001076 <walkaddr>
    80001792:	cd01                	beqz	a0,800017aa <copyin+0x74>
    80001794:	418904b3          	sub	s1,s2,s8
    80001798:	94d6                	add	s1,s1,s5
    8000179a:	fc99f2e3          	bgeu	s3,s1,8000175e <copyin+0x28>
    8000179e:	84ce                	mv	s1,s3
    800017a0:	bf7d                	j	8000175e <copyin+0x28>
    800017a2:	4501                	li	a0,0
    800017a4:	a021                	j	800017ac <copyin+0x76>
    800017a6:	4501                	li	a0,0
    800017a8:	8082                	ret
    800017aa:	557d                	li	a0,-1
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
    800017c4:	c6c5                	beqz	a3,8000186c <copyinstr+0xa8>
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
    800017e4:	7afd                	lui	s5,0xfffff
    800017e6:	6985                	lui	s3,0x1
    800017e8:	a035                	j	80001814 <copyinstr+0x50>
    800017ea:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017ee:	4785                	li	a5,1
    800017f0:	0017b793          	seqz	a5,a5
    800017f4:	40f00533          	neg	a0,a5
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
    8000180e:	01390bb3          	add	s7,s2,s3
    80001812:	c8a9                	beqz	s1,80001864 <copyinstr+0xa0>
    80001814:	015bf933          	and	s2,s7,s5
    80001818:	85ca                	mv	a1,s2
    8000181a:	8552                	mv	a0,s4
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	85a080e7          	jalr	-1958(ra) # 80001076 <walkaddr>
    80001824:	c131                	beqz	a0,80001868 <copyinstr+0xa4>
    80001826:	41790833          	sub	a6,s2,s7
    8000182a:	984e                	add	a6,a6,s3
    8000182c:	0104f363          	bgeu	s1,a6,80001832 <copyinstr+0x6e>
    80001830:	8826                	mv	a6,s1
    80001832:	955e                	add	a0,a0,s7
    80001834:	41250533          	sub	a0,a0,s2
    80001838:	fc080be3          	beqz	a6,8000180e <copyinstr+0x4a>
    8000183c:	985a                	add	a6,a6,s6
    8000183e:	87da                	mv	a5,s6
    80001840:	41650633          	sub	a2,a0,s6
    80001844:	14fd                	addi	s1,s1,-1
    80001846:	9b26                	add	s6,s6,s1
    80001848:	00f60733          	add	a4,a2,a5
    8000184c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8000>
    80001850:	df49                	beqz	a4,800017ea <copyinstr+0x26>
    80001852:	00e78023          	sb	a4,0(a5)
    80001856:	40fb04b3          	sub	s1,s6,a5
    8000185a:	0785                	addi	a5,a5,1
    8000185c:	ff0796e3          	bne	a5,a6,80001848 <copyinstr+0x84>
    80001860:	8b42                	mv	s6,a6
    80001862:	b775                	j	8000180e <copyinstr+0x4a>
    80001864:	4781                	li	a5,0
    80001866:	b769                	j	800017f0 <copyinstr+0x2c>
    80001868:	557d                	li	a0,-1
    8000186a:	b779                	j	800017f8 <copyinstr+0x34>
    8000186c:	4781                	li	a5,0
    8000186e:	0017b793          	seqz	a5,a5
    80001872:	40f00533          	neg	a0,a5
    80001876:	8082                	ret

0000000080001878 <init_queue>:
#define __DE_MOVE___(P, SRC, DST)   do { dequeue(SRC); enqueue(DST, P); } while(0)
#define __RE_MOVE___(P, SRC, DST)   do { enqueue(DST, remove(SRC, P)); } while(0)


// Make it all zeros.
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

// Console debug purpose.
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
  color(p, q->q_id); // color it first
    800019be:	4398                	lw	a4,0(a5)
int color(struct proc* p, int id) {  p->p_id = id; return id; }
    800019c0:	16e5a423          	sw	a4,360(a1)
  
  if (is_empty(q)) { ground(p); q->q_head = q->q_tail = p; }
    800019c4:	43d8                	lw	a4,4(a5)
    800019c6:	c305                	beqz	a4,800019e6 <enqueue+0x32>
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
  
  return p;
}
    800019e0:	6422                	ld	s0,8(sp)
    800019e2:	0141                	addi	sp,sp,16
    800019e4:	8082                	ret
int ground(struct proc* p) { p->p_next = p->p_prev = 0; return 0;}
    800019e6:	1605b823          	sd	zero,368(a1)
    800019ea:	1605bc23          	sd	zero,376(a1)
  if (is_empty(q)) { ground(p); q->q_head = q->q_tail = p; }
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
  if (q->q_cnt == 1) q->q_head = q->q_tail = 0;
    80001a02:	4685                	li	a3,1
    80001a04:	02d70463          	beq	a4,a3,80001a2c <dequeue+0x38>
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

  return p;
}
    80001a26:	6422                	ld	s0,8(sp)
    80001a28:	0141                	addi	sp,sp,16
    80001a2a:	8082                	ret
  if (q->q_cnt == 1) q->q_head = q->q_tail = 0;
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

  if (q->q_cnt == 1) { q->q_head = q->q_tail = 0; }
    80001a5e:	4685                	li	a3,1
    80001a60:	04d70363          	beq	a4,a3,80001aa6 <remove+0x6c>
  else {
    if (np->p_prev != 0) np->p_prev->p_next = np->p_next;  // not in front
    80001a64:	17053703          	ld	a4,368(a0)
    80001a68:	c709                	beqz	a4,80001a72 <remove+0x38>
    80001a6a:	17853683          	ld	a3,376(a0)
    80001a6e:	16d73c23          	sd	a3,376(a4)
    if (np->p_next != 0) np->p_next->p_prev = np->p_prev;  // not in rear
    80001a72:	17853703          	ld	a4,376(a0)
    80001a76:	c709                	beqz	a4,80001a80 <remove+0x46>
    80001a78:	17053683          	ld	a3,368(a0)
    80001a7c:	16d73823          	sd	a3,368(a4)
    if (np == q->q_head) q->q_head = np->p_next; 
    80001a80:	6798                	ld	a4,8(a5)
    80001a82:	02e50763          	beq	a0,a4,80001ab0 <remove+0x76>
    if (np == q->q_tail) q->q_tail = np->p_prev; 
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

  return np;
}
    80001aa0:	6422                	ld	s0,8(sp)
    80001aa2:	0141                	addi	sp,sp,16
    80001aa4:	8082                	ret
  if (q->q_cnt == 1) { q->q_head = q->q_tail = 0; }
    80001aa6:	0007b823          	sd	zero,16(a5)
    80001aaa:	0007b423          	sd	zero,8(a5)
    80001aae:	bff9                	j	80001a8c <remove+0x52>
    if (np == q->q_head) q->q_head = np->p_next; 
    80001ab0:	17853703          	ld	a4,376(a0)
    80001ab4:	e798                	sd	a4,8(a5)
    80001ab6:	bfc1                	j	80001a86 <remove+0x4c>
    if (np == q->q_tail) q->q_tail = np->p_prev; 
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
    if (is_q0(p)) // Move to q2
      __RE_MOVE___(p, &q0, &q2);
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
    if (is_q0(p)) // Move to q2
    80001b06:	1684a783          	lw	a5,360(s1)
    80001b0a:	fbf9                	bnez	a5,80001ae0 <wakeup1+0x1c>
      __RE_MOVE___(p, &q0, &q2);
    80001b0c:	85a6                	mv	a1,s1
    80001b0e:	00010517          	auipc	a0,0x10
    80001b12:	e7250513          	addi	a0,a0,-398 # 80011980 <q0>
    80001b16:	00000097          	auipc	ra,0x0
    80001b1a:	f24080e7          	jalr	-220(ra) # 80001a3a <remove>
    80001b1e:	85aa                	mv	a1,a0
    80001b20:	00010517          	auipc	a0,0x10
    80001b24:	e3050513          	addi	a0,a0,-464 # 80011950 <q2>
    80001b28:	00000097          	auipc	ra,0x0
    80001b2c:	e8c080e7          	jalr	-372(ra) # 800019b4 <enqueue>
}
    80001b30:	bf45                	j	80001ae0 <wakeup1+0x1c>

0000000080001b32 <mlfq_like>:
void mlfq_like() {
    80001b32:	711d                	addi	sp,sp,-96
    80001b34:	ec86                	sd	ra,88(sp)
    80001b36:	e8a2                	sd	s0,80(sp)
    80001b38:	e4a6                	sd	s1,72(sp)
    80001b3a:	e0ca                	sd	s2,64(sp)
    80001b3c:	fc4e                	sd	s3,56(sp)
    80001b3e:	f852                	sd	s4,48(sp)
    80001b40:	f456                	sd	s5,40(sp)
    80001b42:	f05a                	sd	s6,32(sp)
    80001b44:	ec5e                	sd	s7,24(sp)
    80001b46:	e862                	sd	s8,16(sp)
    80001b48:	e466                	sd	s9,8(sp)
    80001b4a:	e06a                	sd	s10,0(sp)
    80001b4c:	1080                	addi	s0,sp,96
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b4e:	8792                	mv	a5,tp
  int id = r_tp();
    80001b50:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001b52:	00779c93          	slli	s9,a5,0x7
    80001b56:	00010717          	auipc	a4,0x10
    80001b5a:	dfa70713          	addi	a4,a4,-518 # 80011950 <q2>
    80001b5e:	9766                	add	a4,a4,s9
    80001b60:	04073423          	sd	zero,72(a4)
        if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001b64:	00010717          	auipc	a4,0x10
    80001b68:	e3c70713          	addi	a4,a4,-452 # 800119a0 <cpus+0x8>
    80001b6c:	9cba                	add	s9,s9,a4
struct proc* get_head(_queue* q) { return q->q_head; }
    80001b6e:	00010997          	auipc	s3,0x10
    80001b72:	de298993          	addi	s3,s3,-542 # 80011950 <q2>
        else if (p->state == UNUSED || p->state == ZOMBIE) { dequeue(&q1); }
    80001b76:	00010c17          	auipc	s8,0x10
    80001b7a:	df2c0c13          	addi	s8,s8,-526 # 80011968 <q1>
        else if (p->state == SLEEPING) { __DE_MOVE___(p, &q1, &q0); }
    80001b7e:	00010d17          	auipc	s10,0x10
    80001b82:	e02d0d13          	addi	s10,s10,-510 # 80011980 <q0>
        if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001b86:	079e                	slli	a5,a5,0x7
    80001b88:	00f98bb3          	add	s7,s3,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b90:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b94:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001b98:	00010917          	auipc	s2,0x10
    80001b9c:	27890913          	addi	s2,s2,632 # 80011e10 <proc+0x60>
    80001ba0:	00010497          	auipc	s1,0x10
    80001ba4:	21048493          	addi	s1,s1,528 # 80011db0 <proc>
        if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001ba8:	4a89                	li	s5,2
        else if (p->state == SLEEPING) { __DE_MOVE___(p, &q1, &q0); }
    80001baa:	4b05                	li	s6,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001bac:	00016a17          	auipc	s4,0x16
    80001bb0:	204a0a13          	addi	s4,s4,516 # 80017db0 <tickslock>
    80001bb4:	a01d                	j	80001bda <mlfq_like+0xa8>
        if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); __DE_MOVE___(p, &q2, &q1); }
    80001bb6:	4c9c                	lw	a5,24(s1)
    80001bb8:	05578b63          	beq	a5,s5,80001c0e <mlfq_like+0xdc>
        else if (p->state == SLEEPING) { __DE_MOVE___(p, &q2, &q0); }
    80001bbc:	09678163          	beq	a5,s6,80001c3e <mlfq_like+0x10c>
        else if (p->state == UNUSED || p->state == ZOMBIE) { dequeue(&q2); } 
    80001bc0:	9bed                	andi	a5,a5,-5
    80001bc2:	cbd1                	beqz	a5,80001c56 <mlfq_like+0x124>
      release(&p->lock);
    80001bc4:	8526                	mv	a0,s1
    80001bc6:	fffff097          	auipc	ra,0xfffff
    80001bca:	0ea080e7          	jalr	234(ra) # 80000cb0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001bce:	18048493          	addi	s1,s1,384
    80001bd2:	18090913          	addi	s2,s2,384
    80001bd6:	fb448be3          	beq	s1,s4,80001b8c <mlfq_like+0x5a>
      acquire(&p->lock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	fffff097          	auipc	ra,0xfffff
    80001be0:	020080e7          	jalr	32(ra) # 80000bfc <acquire>
      if (  p == get_head(&q2)   ) {
    80001be4:	0089b783          	ld	a5,8(s3)
    80001be8:	fcf487e3          	beq	s1,a5,80001bb6 <mlfq_like+0x84>
      else if (  p == get_head(&q1)   ) {
    80001bec:	0209b783          	ld	a5,32(s3)
    80001bf0:	fcf49ae3          	bne	s1,a5,80001bc4 <mlfq_like+0x92>
        if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001bf4:	4c9c                	lw	a5,24(s1)
    80001bf6:	07578663          	beq	a5,s5,80001c62 <mlfq_like+0x130>
        else if (p->state == SLEEPING) { __DE_MOVE___(p, &q1, &q0); }
    80001bfa:	09678163          	beq	a5,s6,80001c7c <mlfq_like+0x14a>
        else if (p->state == UNUSED || p->state == ZOMBIE) { dequeue(&q1); }
    80001bfe:	9bed                	andi	a5,a5,-5
    80001c00:	f3f1                	bnez	a5,80001bc4 <mlfq_like+0x92>
    80001c02:	8562                	mv	a0,s8
    80001c04:	00000097          	auipc	ra,0x0
    80001c08:	df0080e7          	jalr	-528(ra) # 800019f4 <dequeue>
    80001c0c:	bf65                	j	80001bc4 <mlfq_like+0x92>
        if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); __DE_MOVE___(p, &q2, &q1); }
    80001c0e:	478d                	li	a5,3
    80001c10:	cc9c                	sw	a5,24(s1)
    80001c12:	049bb423          	sd	s1,72(s7) # fffffffffffff048 <end+0xffffffff7ffd8048>
    80001c16:	85ca                	mv	a1,s2
    80001c18:	8566                	mv	a0,s9
    80001c1a:	00001097          	auipc	ra,0x1
    80001c1e:	d28080e7          	jalr	-728(ra) # 80002942 <swtch>
    80001c22:	040bb423          	sd	zero,72(s7)
    80001c26:	854e                	mv	a0,s3
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	dcc080e7          	jalr	-564(ra) # 800019f4 <dequeue>
    80001c30:	85a6                	mv	a1,s1
    80001c32:	8562                	mv	a0,s8
    80001c34:	00000097          	auipc	ra,0x0
    80001c38:	d80080e7          	jalr	-640(ra) # 800019b4 <enqueue>
    80001c3c:	b761                	j	80001bc4 <mlfq_like+0x92>
        else if (p->state == SLEEPING) { __DE_MOVE___(p, &q2, &q0); }
    80001c3e:	854e                	mv	a0,s3
    80001c40:	00000097          	auipc	ra,0x0
    80001c44:	db4080e7          	jalr	-588(ra) # 800019f4 <dequeue>
    80001c48:	85a6                	mv	a1,s1
    80001c4a:	856a                	mv	a0,s10
    80001c4c:	00000097          	auipc	ra,0x0
    80001c50:	d68080e7          	jalr	-664(ra) # 800019b4 <enqueue>
    80001c54:	bf85                	j	80001bc4 <mlfq_like+0x92>
        else if (p->state == UNUSED || p->state == ZOMBIE) { dequeue(&q2); } 
    80001c56:	854e                	mv	a0,s3
    80001c58:	00000097          	auipc	ra,0x0
    80001c5c:	d9c080e7          	jalr	-612(ra) # 800019f4 <dequeue>
    80001c60:	b795                	j	80001bc4 <mlfq_like+0x92>
        if(p->state == RUNNABLE) { __CONTEXT_SWITCH__(c, p); }
    80001c62:	478d                	li	a5,3
    80001c64:	cc9c                	sw	a5,24(s1)
    80001c66:	049bb423          	sd	s1,72(s7)
    80001c6a:	85ca                	mv	a1,s2
    80001c6c:	8566                	mv	a0,s9
    80001c6e:	00001097          	auipc	ra,0x1
    80001c72:	cd4080e7          	jalr	-812(ra) # 80002942 <swtch>
    80001c76:	040bb423          	sd	zero,72(s7)
    80001c7a:	b7a9                	j	80001bc4 <mlfq_like+0x92>
        else if (p->state == SLEEPING) { __DE_MOVE___(p, &q1, &q0); }
    80001c7c:	8562                	mv	a0,s8
    80001c7e:	00000097          	auipc	ra,0x0
    80001c82:	d76080e7          	jalr	-650(ra) # 800019f4 <dequeue>
    80001c86:	85a6                	mv	a1,s1
    80001c88:	856a                	mv	a0,s10
    80001c8a:	00000097          	auipc	ra,0x0
    80001c8e:	d2a080e7          	jalr	-726(ra) # 800019b4 <enqueue>
    80001c92:	bf0d                	j	80001bc4 <mlfq_like+0x92>

0000000080001c94 <procinit>:
{
    80001c94:	715d                	addi	sp,sp,-80
    80001c96:	e486                	sd	ra,72(sp)
    80001c98:	e0a2                	sd	s0,64(sp)
    80001c9a:	fc26                	sd	s1,56(sp)
    80001c9c:	f84a                	sd	s2,48(sp)
    80001c9e:	f44e                	sd	s3,40(sp)
    80001ca0:	f052                	sd	s4,32(sp)
    80001ca2:	ec56                	sd	s5,24(sp)
    80001ca4:	e85a                	sd	s6,16(sp)
    80001ca6:	e45e                	sd	s7,8(sp)
    80001ca8:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001caa:	00006597          	auipc	a1,0x6
    80001cae:	5be58593          	addi	a1,a1,1470 # 80008268 <digits+0x228>
    80001cb2:	00010517          	auipc	a0,0x10
    80001cb6:	0e650513          	addi	a0,a0,230 # 80011d98 <pid_lock>
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	eb2080e7          	jalr	-334(ra) # 80000b6c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cc2:	00010917          	auipc	s2,0x10
    80001cc6:	0ee90913          	addi	s2,s2,238 # 80011db0 <proc>
      initlock(&p->lock, "proc");
    80001cca:	00006b97          	auipc	s7,0x6
    80001cce:	5a6b8b93          	addi	s7,s7,1446 # 80008270 <digits+0x230>
      uint64 va = KSTACK((int) (p - proc));
    80001cd2:	8b4a                	mv	s6,s2
    80001cd4:	00006a97          	auipc	s5,0x6
    80001cd8:	32ca8a93          	addi	s5,s5,812 # 80008000 <etext>
    80001cdc:	040009b7          	lui	s3,0x4000
    80001ce0:	19fd                	addi	s3,s3,-1
    80001ce2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ce4:	00016a17          	auipc	s4,0x16
    80001ce8:	0cca0a13          	addi	s4,s4,204 # 80017db0 <tickslock>
      initlock(&p->lock, "proc");
    80001cec:	85de                	mv	a1,s7
    80001cee:	854a                	mv	a0,s2
    80001cf0:	fffff097          	auipc	ra,0xfffff
    80001cf4:	e7c080e7          	jalr	-388(ra) # 80000b6c <initlock>
      char *pa = kalloc();
    80001cf8:	fffff097          	auipc	ra,0xfffff
    80001cfc:	e14080e7          	jalr	-492(ra) # 80000b0c <kalloc>
    80001d00:	85aa                	mv	a1,a0
      if(pa == 0)
    80001d02:	c549                	beqz	a0,80001d8c <procinit+0xf8>
      uint64 va = KSTACK((int) (p - proc));
    80001d04:	416904b3          	sub	s1,s2,s6
    80001d08:	849d                	srai	s1,s1,0x7
    80001d0a:	000ab783          	ld	a5,0(s5)
    80001d0e:	02f484b3          	mul	s1,s1,a5
    80001d12:	2485                	addiw	s1,s1,1
    80001d14:	00d4949b          	slliw	s1,s1,0xd
    80001d18:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d1c:	4699                	li	a3,6
    80001d1e:	6605                	lui	a2,0x1
    80001d20:	8526                	mv	a0,s1
    80001d22:	fffff097          	auipc	ra,0xfffff
    80001d26:	482080e7          	jalr	1154(ra) # 800011a4 <kvmmap>
      p->kstack = va;
    80001d2a:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d2e:	18090913          	addi	s2,s2,384
    80001d32:	fb491de3          	bne	s2,s4,80001cec <procinit+0x58>
  kvminithart();
    80001d36:	fffff097          	auipc	ra,0xfffff
    80001d3a:	276080e7          	jalr	630(ra) # 80000fac <kvminithart>
void init_queue(_queue* q, int id) { q->q_id = id; q->q_head = 0; q->q_tail = 0; q->q_cnt = 0; };
    80001d3e:	00010797          	auipc	a5,0x10
    80001d42:	c1278793          	addi	a5,a5,-1006 # 80011950 <q2>
    80001d46:	4709                	li	a4,2
    80001d48:	c398                	sw	a4,0(a5)
    80001d4a:	0007b423          	sd	zero,8(a5)
    80001d4e:	0007b823          	sd	zero,16(a5)
    80001d52:	0007a223          	sw	zero,4(a5)
    80001d56:	4705                	li	a4,1
    80001d58:	cf98                	sw	a4,24(a5)
    80001d5a:	0207b023          	sd	zero,32(a5)
    80001d5e:	0207b423          	sd	zero,40(a5)
    80001d62:	0007ae23          	sw	zero,28(a5)
    80001d66:	0207a823          	sw	zero,48(a5)
    80001d6a:	0207bc23          	sd	zero,56(a5)
    80001d6e:	0407b023          	sd	zero,64(a5)
    80001d72:	0207aa23          	sw	zero,52(a5)
}
    80001d76:	60a6                	ld	ra,72(sp)
    80001d78:	6406                	ld	s0,64(sp)
    80001d7a:	74e2                	ld	s1,56(sp)
    80001d7c:	7942                	ld	s2,48(sp)
    80001d7e:	79a2                	ld	s3,40(sp)
    80001d80:	7a02                	ld	s4,32(sp)
    80001d82:	6ae2                	ld	s5,24(sp)
    80001d84:	6b42                	ld	s6,16(sp)
    80001d86:	6ba2                	ld	s7,8(sp)
    80001d88:	6161                	addi	sp,sp,80
    80001d8a:	8082                	ret
        panic("kalloc");
    80001d8c:	00006517          	auipc	a0,0x6
    80001d90:	4ec50513          	addi	a0,a0,1260 # 80008278 <digits+0x238>
    80001d94:	ffffe097          	auipc	ra,0xffffe
    80001d98:	7ac080e7          	jalr	1964(ra) # 80000540 <panic>

0000000080001d9c <cpuid>:
{
    80001d9c:	1141                	addi	sp,sp,-16
    80001d9e:	e422                	sd	s0,8(sp)
    80001da0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001da2:	8512                	mv	a0,tp
}
    80001da4:	2501                	sext.w	a0,a0
    80001da6:	6422                	ld	s0,8(sp)
    80001da8:	0141                	addi	sp,sp,16
    80001daa:	8082                	ret

0000000080001dac <mycpu>:
mycpu(void) {
    80001dac:	1141                	addi	sp,sp,-16
    80001dae:	e422                	sd	s0,8(sp)
    80001db0:	0800                	addi	s0,sp,16
    80001db2:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001db4:	2781                	sext.w	a5,a5
    80001db6:	079e                	slli	a5,a5,0x7
}
    80001db8:	00010517          	auipc	a0,0x10
    80001dbc:	be050513          	addi	a0,a0,-1056 # 80011998 <cpus>
    80001dc0:	953e                	add	a0,a0,a5
    80001dc2:	6422                	ld	s0,8(sp)
    80001dc4:	0141                	addi	sp,sp,16
    80001dc6:	8082                	ret

0000000080001dc8 <myproc>:
myproc(void) {
    80001dc8:	1101                	addi	sp,sp,-32
    80001dca:	ec06                	sd	ra,24(sp)
    80001dcc:	e822                	sd	s0,16(sp)
    80001dce:	e426                	sd	s1,8(sp)
    80001dd0:	1000                	addi	s0,sp,32
  push_off();
    80001dd2:	fffff097          	auipc	ra,0xfffff
    80001dd6:	dde080e7          	jalr	-546(ra) # 80000bb0 <push_off>
    80001dda:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001ddc:	2781                	sext.w	a5,a5
    80001dde:	079e                	slli	a5,a5,0x7
    80001de0:	00010717          	auipc	a4,0x10
    80001de4:	b7070713          	addi	a4,a4,-1168 # 80011950 <q2>
    80001de8:	97ba                	add	a5,a5,a4
    80001dea:	67a4                	ld	s1,72(a5)
  pop_off();
    80001dec:	fffff097          	auipc	ra,0xfffff
    80001df0:	e64080e7          	jalr	-412(ra) # 80000c50 <pop_off>
}
    80001df4:	8526                	mv	a0,s1
    80001df6:	60e2                	ld	ra,24(sp)
    80001df8:	6442                	ld	s0,16(sp)
    80001dfa:	64a2                	ld	s1,8(sp)
    80001dfc:	6105                	addi	sp,sp,32
    80001dfe:	8082                	ret

0000000080001e00 <forkret>:
{
    80001e00:	1141                	addi	sp,sp,-16
    80001e02:	e406                	sd	ra,8(sp)
    80001e04:	e022                	sd	s0,0(sp)
    80001e06:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001e08:	00000097          	auipc	ra,0x0
    80001e0c:	fc0080e7          	jalr	-64(ra) # 80001dc8 <myproc>
    80001e10:	fffff097          	auipc	ra,0xfffff
    80001e14:	ea0080e7          	jalr	-352(ra) # 80000cb0 <release>
  if (first) {
    80001e18:	00007797          	auipc	a5,0x7
    80001e1c:	ac87a783          	lw	a5,-1336(a5) # 800088e0 <first.1>
    80001e20:	eb89                	bnez	a5,80001e32 <forkret+0x32>
  usertrapret();
    80001e22:	00001097          	auipc	ra,0x1
    80001e26:	bca080e7          	jalr	-1078(ra) # 800029ec <usertrapret>
}
    80001e2a:	60a2                	ld	ra,8(sp)
    80001e2c:	6402                	ld	s0,0(sp)
    80001e2e:	0141                	addi	sp,sp,16
    80001e30:	8082                	ret
    first = 0;
    80001e32:	00007797          	auipc	a5,0x7
    80001e36:	aa07a723          	sw	zero,-1362(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80001e3a:	4505                	li	a0,1
    80001e3c:	00002097          	auipc	ra,0x2
    80001e40:	938080e7          	jalr	-1736(ra) # 80003774 <fsinit>
    80001e44:	bff9                	j	80001e22 <forkret+0x22>

0000000080001e46 <allocpid>:
allocpid() {
    80001e46:	1101                	addi	sp,sp,-32
    80001e48:	ec06                	sd	ra,24(sp)
    80001e4a:	e822                	sd	s0,16(sp)
    80001e4c:	e426                	sd	s1,8(sp)
    80001e4e:	e04a                	sd	s2,0(sp)
    80001e50:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001e52:	00010917          	auipc	s2,0x10
    80001e56:	f4690913          	addi	s2,s2,-186 # 80011d98 <pid_lock>
    80001e5a:	854a                	mv	a0,s2
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	da0080e7          	jalr	-608(ra) # 80000bfc <acquire>
  pid = nextpid;
    80001e64:	00007797          	auipc	a5,0x7
    80001e68:	a8078793          	addi	a5,a5,-1408 # 800088e4 <nextpid>
    80001e6c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001e6e:	0014871b          	addiw	a4,s1,1
    80001e72:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001e74:	854a                	mv	a0,s2
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	e3a080e7          	jalr	-454(ra) # 80000cb0 <release>
}
    80001e7e:	8526                	mv	a0,s1
    80001e80:	60e2                	ld	ra,24(sp)
    80001e82:	6442                	ld	s0,16(sp)
    80001e84:	64a2                	ld	s1,8(sp)
    80001e86:	6902                	ld	s2,0(sp)
    80001e88:	6105                	addi	sp,sp,32
    80001e8a:	8082                	ret

0000000080001e8c <proc_pagetable>:
{
    80001e8c:	1101                	addi	sp,sp,-32
    80001e8e:	ec06                	sd	ra,24(sp)
    80001e90:	e822                	sd	s0,16(sp)
    80001e92:	e426                	sd	s1,8(sp)
    80001e94:	e04a                	sd	s2,0(sp)
    80001e96:	1000                	addi	s0,sp,32
    80001e98:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	4d8080e7          	jalr	1240(ra) # 80001372 <uvmcreate>
    80001ea2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001ea4:	c121                	beqz	a0,80001ee4 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ea6:	4729                	li	a4,10
    80001ea8:	00005697          	auipc	a3,0x5
    80001eac:	15868693          	addi	a3,a3,344 # 80007000 <_trampoline>
    80001eb0:	6605                	lui	a2,0x1
    80001eb2:	040005b7          	lui	a1,0x4000
    80001eb6:	15fd                	addi	a1,a1,-1
    80001eb8:	05b2                	slli	a1,a1,0xc
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	25c080e7          	jalr	604(ra) # 80001116 <mappages>
    80001ec2:	02054863          	bltz	a0,80001ef2 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ec6:	4719                	li	a4,6
    80001ec8:	05893683          	ld	a3,88(s2)
    80001ecc:	6605                	lui	a2,0x1
    80001ece:	020005b7          	lui	a1,0x2000
    80001ed2:	15fd                	addi	a1,a1,-1
    80001ed4:	05b6                	slli	a1,a1,0xd
    80001ed6:	8526                	mv	a0,s1
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	23e080e7          	jalr	574(ra) # 80001116 <mappages>
    80001ee0:	02054163          	bltz	a0,80001f02 <proc_pagetable+0x76>
}
    80001ee4:	8526                	mv	a0,s1
    80001ee6:	60e2                	ld	ra,24(sp)
    80001ee8:	6442                	ld	s0,16(sp)
    80001eea:	64a2                	ld	s1,8(sp)
    80001eec:	6902                	ld	s2,0(sp)
    80001eee:	6105                	addi	sp,sp,32
    80001ef0:	8082                	ret
    uvmfree(pagetable, 0);
    80001ef2:	4581                	li	a1,0
    80001ef4:	8526                	mv	a0,s1
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	678080e7          	jalr	1656(ra) # 8000156e <uvmfree>
    return 0;
    80001efe:	4481                	li	s1,0
    80001f00:	b7d5                	j	80001ee4 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f02:	4681                	li	a3,0
    80001f04:	4605                	li	a2,1
    80001f06:	040005b7          	lui	a1,0x4000
    80001f0a:	15fd                	addi	a1,a1,-1
    80001f0c:	05b2                	slli	a1,a1,0xc
    80001f0e:	8526                	mv	a0,s1
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	39e080e7          	jalr	926(ra) # 800012ae <uvmunmap>
    uvmfree(pagetable, 0);
    80001f18:	4581                	li	a1,0
    80001f1a:	8526                	mv	a0,s1
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	652080e7          	jalr	1618(ra) # 8000156e <uvmfree>
    return 0;
    80001f24:	4481                	li	s1,0
    80001f26:	bf7d                	j	80001ee4 <proc_pagetable+0x58>

0000000080001f28 <proc_freepagetable>:
{
    80001f28:	1101                	addi	sp,sp,-32
    80001f2a:	ec06                	sd	ra,24(sp)
    80001f2c:	e822                	sd	s0,16(sp)
    80001f2e:	e426                	sd	s1,8(sp)
    80001f30:	e04a                	sd	s2,0(sp)
    80001f32:	1000                	addi	s0,sp,32
    80001f34:	84aa                	mv	s1,a0
    80001f36:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f38:	4681                	li	a3,0
    80001f3a:	4605                	li	a2,1
    80001f3c:	040005b7          	lui	a1,0x4000
    80001f40:	15fd                	addi	a1,a1,-1
    80001f42:	05b2                	slli	a1,a1,0xc
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	36a080e7          	jalr	874(ra) # 800012ae <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001f4c:	4681                	li	a3,0
    80001f4e:	4605                	li	a2,1
    80001f50:	020005b7          	lui	a1,0x2000
    80001f54:	15fd                	addi	a1,a1,-1
    80001f56:	05b6                	slli	a1,a1,0xd
    80001f58:	8526                	mv	a0,s1
    80001f5a:	fffff097          	auipc	ra,0xfffff
    80001f5e:	354080e7          	jalr	852(ra) # 800012ae <uvmunmap>
  uvmfree(pagetable, sz);
    80001f62:	85ca                	mv	a1,s2
    80001f64:	8526                	mv	a0,s1
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	608080e7          	jalr	1544(ra) # 8000156e <uvmfree>
}
    80001f6e:	60e2                	ld	ra,24(sp)
    80001f70:	6442                	ld	s0,16(sp)
    80001f72:	64a2                	ld	s1,8(sp)
    80001f74:	6902                	ld	s2,0(sp)
    80001f76:	6105                	addi	sp,sp,32
    80001f78:	8082                	ret

0000000080001f7a <freeproc>:
{
    80001f7a:	1101                	addi	sp,sp,-32
    80001f7c:	ec06                	sd	ra,24(sp)
    80001f7e:	e822                	sd	s0,16(sp)
    80001f80:	e426                	sd	s1,8(sp)
    80001f82:	1000                	addi	s0,sp,32
    80001f84:	84aa                	mv	s1,a0
  printf("%s (pid=%d): Q2(%d%%), Q1(%d%%), Q0(%d%%)\n",
    80001f86:	4781                	li	a5,0
    80001f88:	4701                	li	a4,0
    80001f8a:	4681                	li	a3,0
    80001f8c:	5d10                	lw	a2,56(a0)
    80001f8e:	15850593          	addi	a1,a0,344
    80001f92:	00006517          	auipc	a0,0x6
    80001f96:	2ee50513          	addi	a0,a0,750 # 80008280 <digits+0x240>
    80001f9a:	ffffe097          	auipc	ra,0xffffe
    80001f9e:	5f0080e7          	jalr	1520(ra) # 8000058a <printf>
  if(p->trapframe)
    80001fa2:	6ca8                	ld	a0,88(s1)
    80001fa4:	c509                	beqz	a0,80001fae <freeproc+0x34>
    kfree((void*)p->trapframe);
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	a6a080e7          	jalr	-1430(ra) # 80000a10 <kfree>
  p->trapframe = 0;
    80001fae:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001fb2:	68a8                	ld	a0,80(s1)
    80001fb4:	c511                	beqz	a0,80001fc0 <freeproc+0x46>
    proc_freepagetable(p->pagetable, p->sz);
    80001fb6:	64ac                	ld	a1,72(s1)
    80001fb8:	00000097          	auipc	ra,0x0
    80001fbc:	f70080e7          	jalr	-144(ra) # 80001f28 <proc_freepagetable>
  p->pagetable = 0;
    80001fc0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001fc4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001fc8:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001fcc:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001fd0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001fd4:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001fd8:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001fdc:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001fe0:	0004ac23          	sw	zero,24(s1)
}
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	64a2                	ld	s1,8(sp)
    80001fea:	6105                	addi	sp,sp,32
    80001fec:	8082                	ret

0000000080001fee <allocproc>:
{
    80001fee:	1101                	addi	sp,sp,-32
    80001ff0:	ec06                	sd	ra,24(sp)
    80001ff2:	e822                	sd	s0,16(sp)
    80001ff4:	e426                	sd	s1,8(sp)
    80001ff6:	e04a                	sd	s2,0(sp)
    80001ff8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ffa:	00010497          	auipc	s1,0x10
    80001ffe:	db648493          	addi	s1,s1,-586 # 80011db0 <proc>
    80002002:	00016917          	auipc	s2,0x16
    80002006:	dae90913          	addi	s2,s2,-594 # 80017db0 <tickslock>
    acquire(&p->lock);
    8000200a:	8526                	mv	a0,s1
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	bf0080e7          	jalr	-1040(ra) # 80000bfc <acquire>
    if(p->state == UNUSED) {
    80002014:	4c9c                	lw	a5,24(s1)
    80002016:	cf81                	beqz	a5,8000202e <allocproc+0x40>
      release(&p->lock);
    80002018:	8526                	mv	a0,s1
    8000201a:	fffff097          	auipc	ra,0xfffff
    8000201e:	c96080e7          	jalr	-874(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002022:	18048493          	addi	s1,s1,384
    80002026:	ff2492e3          	bne	s1,s2,8000200a <allocproc+0x1c>
  return 0;
    8000202a:	4481                	li	s1,0
    8000202c:	a085                	j	8000208c <allocproc+0x9e>
  p->pid = allocpid();
    8000202e:	00000097          	auipc	ra,0x0
    80002032:	e18080e7          	jalr	-488(ra) # 80001e46 <allocpid>
    80002036:	dc88                	sw	a0,56(s1)
  enqueue(&q2, p);
    80002038:	85a6                	mv	a1,s1
    8000203a:	00010517          	auipc	a0,0x10
    8000203e:	91650513          	addi	a0,a0,-1770 # 80011950 <q2>
    80002042:	00000097          	auipc	ra,0x0
    80002046:	972080e7          	jalr	-1678(ra) # 800019b4 <enqueue>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000204a:	fffff097          	auipc	ra,0xfffff
    8000204e:	ac2080e7          	jalr	-1342(ra) # 80000b0c <kalloc>
    80002052:	892a                	mv	s2,a0
    80002054:	eca8                	sd	a0,88(s1)
    80002056:	c131                	beqz	a0,8000209a <allocproc+0xac>
  p->pagetable = proc_pagetable(p);
    80002058:	8526                	mv	a0,s1
    8000205a:	00000097          	auipc	ra,0x0
    8000205e:	e32080e7          	jalr	-462(ra) # 80001e8c <proc_pagetable>
    80002062:	892a                	mv	s2,a0
    80002064:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80002066:	c129                	beqz	a0,800020a8 <allocproc+0xba>
  memset(&p->context, 0, sizeof(p->context));
    80002068:	07000613          	li	a2,112
    8000206c:	4581                	li	a1,0
    8000206e:	06048513          	addi	a0,s1,96
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	c86080e7          	jalr	-890(ra) # 80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    8000207a:	00000797          	auipc	a5,0x0
    8000207e:	d8678793          	addi	a5,a5,-634 # 80001e00 <forkret>
    80002082:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002084:	60bc                	ld	a5,64(s1)
    80002086:	6705                	lui	a4,0x1
    80002088:	97ba                	add	a5,a5,a4
    8000208a:	f4bc                	sd	a5,104(s1)
}
    8000208c:	8526                	mv	a0,s1
    8000208e:	60e2                	ld	ra,24(sp)
    80002090:	6442                	ld	s0,16(sp)
    80002092:	64a2                	ld	s1,8(sp)
    80002094:	6902                	ld	s2,0(sp)
    80002096:	6105                	addi	sp,sp,32
    80002098:	8082                	ret
    release(&p->lock);
    8000209a:	8526                	mv	a0,s1
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	c14080e7          	jalr	-1004(ra) # 80000cb0 <release>
    return 0;
    800020a4:	84ca                	mv	s1,s2
    800020a6:	b7dd                	j	8000208c <allocproc+0x9e>
    freeproc(p);
    800020a8:	8526                	mv	a0,s1
    800020aa:	00000097          	auipc	ra,0x0
    800020ae:	ed0080e7          	jalr	-304(ra) # 80001f7a <freeproc>
    release(&p->lock);
    800020b2:	8526                	mv	a0,s1
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	bfc080e7          	jalr	-1028(ra) # 80000cb0 <release>
    return 0;
    800020bc:	84ca                	mv	s1,s2
    800020be:	b7f9                	j	8000208c <allocproc+0x9e>

00000000800020c0 <userinit>:
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	e426                	sd	s1,8(sp)
    800020c8:	1000                	addi	s0,sp,32
  p = allocproc();
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	f24080e7          	jalr	-220(ra) # 80001fee <allocproc>
    800020d2:	84aa                	mv	s1,a0
  initproc = p;
    800020d4:	00007797          	auipc	a5,0x7
    800020d8:	f4a7b223          	sd	a0,-188(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800020dc:	03400613          	li	a2,52
    800020e0:	00007597          	auipc	a1,0x7
    800020e4:	81058593          	addi	a1,a1,-2032 # 800088f0 <initcode>
    800020e8:	6928                	ld	a0,80(a0)
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	2b6080e7          	jalr	694(ra) # 800013a0 <uvminit>
  p->sz = PGSIZE;
    800020f2:	6785                	lui	a5,0x1
    800020f4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800020f6:	6cb8                	ld	a4,88(s1)
    800020f8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800020fc:	6cb8                	ld	a4,88(s1)
    800020fe:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002100:	4641                	li	a2,16
    80002102:	00006597          	auipc	a1,0x6
    80002106:	1ae58593          	addi	a1,a1,430 # 800082b0 <digits+0x270>
    8000210a:	15848513          	addi	a0,s1,344
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	d3c080e7          	jalr	-708(ra) # 80000e4a <safestrcpy>
  p->cwd = namei("/");
    80002116:	00006517          	auipc	a0,0x6
    8000211a:	1aa50513          	addi	a0,a0,426 # 800082c0 <digits+0x280>
    8000211e:	00002097          	auipc	ra,0x2
    80002122:	07e080e7          	jalr	126(ra) # 8000419c <namei>
    80002126:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000212a:	4789                	li	a5,2
    8000212c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000212e:	8526                	mv	a0,s1
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	b80080e7          	jalr	-1152(ra) # 80000cb0 <release>
}
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6105                	addi	sp,sp,32
    80002140:	8082                	ret

0000000080002142 <growproc>:
{
    80002142:	1101                	addi	sp,sp,-32
    80002144:	ec06                	sd	ra,24(sp)
    80002146:	e822                	sd	s0,16(sp)
    80002148:	e426                	sd	s1,8(sp)
    8000214a:	e04a                	sd	s2,0(sp)
    8000214c:	1000                	addi	s0,sp,32
    8000214e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002150:	00000097          	auipc	ra,0x0
    80002154:	c78080e7          	jalr	-904(ra) # 80001dc8 <myproc>
    80002158:	892a                	mv	s2,a0
  sz = p->sz;
    8000215a:	652c                	ld	a1,72(a0)
    8000215c:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80002160:	00904f63          	bgtz	s1,8000217e <growproc+0x3c>
  } else if(n < 0){
    80002164:	0204cc63          	bltz	s1,8000219c <growproc+0x5a>
  p->sz = sz;
    80002168:	1602                	slli	a2,a2,0x20
    8000216a:	9201                	srli	a2,a2,0x20
    8000216c:	04c93423          	sd	a2,72(s2)
  return 0;
    80002170:	4501                	li	a0,0
}
    80002172:	60e2                	ld	ra,24(sp)
    80002174:	6442                	ld	s0,16(sp)
    80002176:	64a2                	ld	s1,8(sp)
    80002178:	6902                	ld	s2,0(sp)
    8000217a:	6105                	addi	sp,sp,32
    8000217c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000217e:	9e25                	addw	a2,a2,s1
    80002180:	1602                	slli	a2,a2,0x20
    80002182:	9201                	srli	a2,a2,0x20
    80002184:	1582                	slli	a1,a1,0x20
    80002186:	9181                	srli	a1,a1,0x20
    80002188:	6928                	ld	a0,80(a0)
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	2d0080e7          	jalr	720(ra) # 8000145a <uvmalloc>
    80002192:	0005061b          	sext.w	a2,a0
    80002196:	fa69                	bnez	a2,80002168 <growproc+0x26>
      return -1;
    80002198:	557d                	li	a0,-1
    8000219a:	bfe1                	j	80002172 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000219c:	9e25                	addw	a2,a2,s1
    8000219e:	1602                	slli	a2,a2,0x20
    800021a0:	9201                	srli	a2,a2,0x20
    800021a2:	1582                	slli	a1,a1,0x20
    800021a4:	9181                	srli	a1,a1,0x20
    800021a6:	6928                	ld	a0,80(a0)
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	26a080e7          	jalr	618(ra) # 80001412 <uvmdealloc>
    800021b0:	0005061b          	sext.w	a2,a0
    800021b4:	bf55                	j	80002168 <growproc+0x26>

00000000800021b6 <fork>:
{
    800021b6:	7139                	addi	sp,sp,-64
    800021b8:	fc06                	sd	ra,56(sp)
    800021ba:	f822                	sd	s0,48(sp)
    800021bc:	f426                	sd	s1,40(sp)
    800021be:	f04a                	sd	s2,32(sp)
    800021c0:	ec4e                	sd	s3,24(sp)
    800021c2:	e852                	sd	s4,16(sp)
    800021c4:	e456                	sd	s5,8(sp)
    800021c6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	c00080e7          	jalr	-1024(ra) # 80001dc8 <myproc>
    800021d0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800021d2:	00000097          	auipc	ra,0x0
    800021d6:	e1c080e7          	jalr	-484(ra) # 80001fee <allocproc>
    800021da:	c17d                	beqz	a0,800022c0 <fork+0x10a>
    800021dc:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800021de:	048ab603          	ld	a2,72(s5)
    800021e2:	692c                	ld	a1,80(a0)
    800021e4:	050ab503          	ld	a0,80(s5)
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	3be080e7          	jalr	958(ra) # 800015a6 <uvmcopy>
    800021f0:	04054a63          	bltz	a0,80002244 <fork+0x8e>
  np->sz = p->sz;
    800021f4:	048ab783          	ld	a5,72(s5)
    800021f8:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    800021fc:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80002200:	058ab683          	ld	a3,88(s5)
    80002204:	87b6                	mv	a5,a3
    80002206:	058a3703          	ld	a4,88(s4)
    8000220a:	12068693          	addi	a3,a3,288
    8000220e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002212:	6788                	ld	a0,8(a5)
    80002214:	6b8c                	ld	a1,16(a5)
    80002216:	6f90                	ld	a2,24(a5)
    80002218:	01073023          	sd	a6,0(a4)
    8000221c:	e708                	sd	a0,8(a4)
    8000221e:	eb0c                	sd	a1,16(a4)
    80002220:	ef10                	sd	a2,24(a4)
    80002222:	02078793          	addi	a5,a5,32
    80002226:	02070713          	addi	a4,a4,32
    8000222a:	fed792e3          	bne	a5,a3,8000220e <fork+0x58>
  np->trapframe->a0 = 0;
    8000222e:	058a3783          	ld	a5,88(s4)
    80002232:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002236:	0d0a8493          	addi	s1,s5,208
    8000223a:	0d0a0913          	addi	s2,s4,208
    8000223e:	150a8993          	addi	s3,s5,336
    80002242:	a00d                	j	80002264 <fork+0xae>
    freeproc(np);
    80002244:	8552                	mv	a0,s4
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	d34080e7          	jalr	-716(ra) # 80001f7a <freeproc>
    release(&np->lock);
    8000224e:	8552                	mv	a0,s4
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	a60080e7          	jalr	-1440(ra) # 80000cb0 <release>
    return -1;
    80002258:	54fd                	li	s1,-1
    8000225a:	a889                	j	800022ac <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    8000225c:	04a1                	addi	s1,s1,8
    8000225e:	0921                	addi	s2,s2,8
    80002260:	01348b63          	beq	s1,s3,80002276 <fork+0xc0>
    if(p->ofile[i])
    80002264:	6088                	ld	a0,0(s1)
    80002266:	d97d                	beqz	a0,8000225c <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80002268:	00002097          	auipc	ra,0x2
    8000226c:	5c4080e7          	jalr	1476(ra) # 8000482c <filedup>
    80002270:	00a93023          	sd	a0,0(s2)
    80002274:	b7e5                	j	8000225c <fork+0xa6>
  np->cwd = idup(p->cwd);
    80002276:	150ab503          	ld	a0,336(s5)
    8000227a:	00001097          	auipc	ra,0x1
    8000227e:	734080e7          	jalr	1844(ra) # 800039ae <idup>
    80002282:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002286:	4641                	li	a2,16
    80002288:	158a8593          	addi	a1,s5,344
    8000228c:	158a0513          	addi	a0,s4,344
    80002290:	fffff097          	auipc	ra,0xfffff
    80002294:	bba080e7          	jalr	-1094(ra) # 80000e4a <safestrcpy>
  pid = np->pid;
    80002298:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    8000229c:	4789                	li	a5,2
    8000229e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800022a2:	8552                	mv	a0,s4
    800022a4:	fffff097          	auipc	ra,0xfffff
    800022a8:	a0c080e7          	jalr	-1524(ra) # 80000cb0 <release>
}
    800022ac:	8526                	mv	a0,s1
    800022ae:	70e2                	ld	ra,56(sp)
    800022b0:	7442                	ld	s0,48(sp)
    800022b2:	74a2                	ld	s1,40(sp)
    800022b4:	7902                	ld	s2,32(sp)
    800022b6:	69e2                	ld	s3,24(sp)
    800022b8:	6a42                	ld	s4,16(sp)
    800022ba:	6aa2                	ld	s5,8(sp)
    800022bc:	6121                	addi	sp,sp,64
    800022be:	8082                	ret
    return -1;
    800022c0:	54fd                	li	s1,-1
    800022c2:	b7ed                	j	800022ac <fork+0xf6>

00000000800022c4 <reparent>:
{
    800022c4:	7179                	addi	sp,sp,-48
    800022c6:	f406                	sd	ra,40(sp)
    800022c8:	f022                	sd	s0,32(sp)
    800022ca:	ec26                	sd	s1,24(sp)
    800022cc:	e84a                	sd	s2,16(sp)
    800022ce:	e44e                	sd	s3,8(sp)
    800022d0:	e052                	sd	s4,0(sp)
    800022d2:	1800                	addi	s0,sp,48
    800022d4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022d6:	00010497          	auipc	s1,0x10
    800022da:	ada48493          	addi	s1,s1,-1318 # 80011db0 <proc>
      pp->parent = initproc;
    800022de:	00007a17          	auipc	s4,0x7
    800022e2:	d3aa0a13          	addi	s4,s4,-710 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e6:	00016997          	auipc	s3,0x16
    800022ea:	aca98993          	addi	s3,s3,-1334 # 80017db0 <tickslock>
    800022ee:	a029                	j	800022f8 <reparent+0x34>
    800022f0:	18048493          	addi	s1,s1,384
    800022f4:	03348363          	beq	s1,s3,8000231a <reparent+0x56>
    if(pp->parent == p){
    800022f8:	709c                	ld	a5,32(s1)
    800022fa:	ff279be3          	bne	a5,s2,800022f0 <reparent+0x2c>
      acquire(&pp->lock);
    800022fe:	8526                	mv	a0,s1
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	8fc080e7          	jalr	-1796(ra) # 80000bfc <acquire>
      pp->parent = initproc;
    80002308:	000a3783          	ld	a5,0(s4)
    8000230c:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    8000230e:	8526                	mv	a0,s1
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	9a0080e7          	jalr	-1632(ra) # 80000cb0 <release>
    80002318:	bfe1                	j	800022f0 <reparent+0x2c>
}
    8000231a:	70a2                	ld	ra,40(sp)
    8000231c:	7402                	ld	s0,32(sp)
    8000231e:	64e2                	ld	s1,24(sp)
    80002320:	6942                	ld	s2,16(sp)
    80002322:	69a2                	ld	s3,8(sp)
    80002324:	6a02                	ld	s4,0(sp)
    80002326:	6145                	addi	sp,sp,48
    80002328:	8082                	ret

000000008000232a <scheduler>:
{
    8000232a:	1141                	addi	sp,sp,-16
    8000232c:	e406                	sd	ra,8(sp)
    8000232e:	e022                	sd	s0,0(sp)
    80002330:	0800                	addi	s0,sp,16
  mlfq_like();
    80002332:	00000097          	auipc	ra,0x0
    80002336:	800080e7          	jalr	-2048(ra) # 80001b32 <mlfq_like>

000000008000233a <sched>:
{
    8000233a:	7179                	addi	sp,sp,-48
    8000233c:	f406                	sd	ra,40(sp)
    8000233e:	f022                	sd	s0,32(sp)
    80002340:	ec26                	sd	s1,24(sp)
    80002342:	e84a                	sd	s2,16(sp)
    80002344:	e44e                	sd	s3,8(sp)
    80002346:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002348:	00000097          	auipc	ra,0x0
    8000234c:	a80080e7          	jalr	-1408(ra) # 80001dc8 <myproc>
    80002350:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	830080e7          	jalr	-2000(ra) # 80000b82 <holding>
    8000235a:	c93d                	beqz	a0,800023d0 <sched+0x96>
    8000235c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000235e:	2781                	sext.w	a5,a5
    80002360:	079e                	slli	a5,a5,0x7
    80002362:	0000f717          	auipc	a4,0xf
    80002366:	5ee70713          	addi	a4,a4,1518 # 80011950 <q2>
    8000236a:	97ba                	add	a5,a5,a4
    8000236c:	0c07a703          	lw	a4,192(a5)
    80002370:	4785                	li	a5,1
    80002372:	06f71763          	bne	a4,a5,800023e0 <sched+0xa6>
  if(p->state == RUNNING)
    80002376:	4c98                	lw	a4,24(s1)
    80002378:	478d                	li	a5,3
    8000237a:	06f70b63          	beq	a4,a5,800023f0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000237e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002382:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002384:	efb5                	bnez	a5,80002400 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002386:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002388:	0000f917          	auipc	s2,0xf
    8000238c:	5c890913          	addi	s2,s2,1480 # 80011950 <q2>
    80002390:	2781                	sext.w	a5,a5
    80002392:	079e                	slli	a5,a5,0x7
    80002394:	97ca                	add	a5,a5,s2
    80002396:	0c47a983          	lw	s3,196(a5)
    8000239a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000239c:	2781                	sext.w	a5,a5
    8000239e:	079e                	slli	a5,a5,0x7
    800023a0:	0000f597          	auipc	a1,0xf
    800023a4:	60058593          	addi	a1,a1,1536 # 800119a0 <cpus+0x8>
    800023a8:	95be                	add	a1,a1,a5
    800023aa:	06048513          	addi	a0,s1,96
    800023ae:	00000097          	auipc	ra,0x0
    800023b2:	594080e7          	jalr	1428(ra) # 80002942 <swtch>
    800023b6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800023b8:	2781                	sext.w	a5,a5
    800023ba:	079e                	slli	a5,a5,0x7
    800023bc:	97ca                	add	a5,a5,s2
    800023be:	0d37a223          	sw	s3,196(a5)
}
    800023c2:	70a2                	ld	ra,40(sp)
    800023c4:	7402                	ld	s0,32(sp)
    800023c6:	64e2                	ld	s1,24(sp)
    800023c8:	6942                	ld	s2,16(sp)
    800023ca:	69a2                	ld	s3,8(sp)
    800023cc:	6145                	addi	sp,sp,48
    800023ce:	8082                	ret
    panic("sched p->lock");
    800023d0:	00006517          	auipc	a0,0x6
    800023d4:	ef850513          	addi	a0,a0,-264 # 800082c8 <digits+0x288>
    800023d8:	ffffe097          	auipc	ra,0xffffe
    800023dc:	168080e7          	jalr	360(ra) # 80000540 <panic>
    panic("sched locks");
    800023e0:	00006517          	auipc	a0,0x6
    800023e4:	ef850513          	addi	a0,a0,-264 # 800082d8 <digits+0x298>
    800023e8:	ffffe097          	auipc	ra,0xffffe
    800023ec:	158080e7          	jalr	344(ra) # 80000540 <panic>
    panic("sched running");
    800023f0:	00006517          	auipc	a0,0x6
    800023f4:	ef850513          	addi	a0,a0,-264 # 800082e8 <digits+0x2a8>
    800023f8:	ffffe097          	auipc	ra,0xffffe
    800023fc:	148080e7          	jalr	328(ra) # 80000540 <panic>
    panic("sched interruptible");
    80002400:	00006517          	auipc	a0,0x6
    80002404:	ef850513          	addi	a0,a0,-264 # 800082f8 <digits+0x2b8>
    80002408:	ffffe097          	auipc	ra,0xffffe
    8000240c:	138080e7          	jalr	312(ra) # 80000540 <panic>

0000000080002410 <exit>:
{
    80002410:	7179                	addi	sp,sp,-48
    80002412:	f406                	sd	ra,40(sp)
    80002414:	f022                	sd	s0,32(sp)
    80002416:	ec26                	sd	s1,24(sp)
    80002418:	e84a                	sd	s2,16(sp)
    8000241a:	e44e                	sd	s3,8(sp)
    8000241c:	e052                	sd	s4,0(sp)
    8000241e:	1800                	addi	s0,sp,48
    80002420:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002422:	00000097          	auipc	ra,0x0
    80002426:	9a6080e7          	jalr	-1626(ra) # 80001dc8 <myproc>
    8000242a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000242c:	00007797          	auipc	a5,0x7
    80002430:	bec7b783          	ld	a5,-1044(a5) # 80009018 <initproc>
    80002434:	0d050493          	addi	s1,a0,208
    80002438:	15050913          	addi	s2,a0,336
    8000243c:	02a79363          	bne	a5,a0,80002462 <exit+0x52>
    panic("init exiting");
    80002440:	00006517          	auipc	a0,0x6
    80002444:	ed050513          	addi	a0,a0,-304 # 80008310 <digits+0x2d0>
    80002448:	ffffe097          	auipc	ra,0xffffe
    8000244c:	0f8080e7          	jalr	248(ra) # 80000540 <panic>
      fileclose(f);
    80002450:	00002097          	auipc	ra,0x2
    80002454:	42e080e7          	jalr	1070(ra) # 8000487e <fileclose>
      p->ofile[fd] = 0;
    80002458:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000245c:	04a1                	addi	s1,s1,8
    8000245e:	01248563          	beq	s1,s2,80002468 <exit+0x58>
    if(p->ofile[fd]){
    80002462:	6088                	ld	a0,0(s1)
    80002464:	f575                	bnez	a0,80002450 <exit+0x40>
    80002466:	bfdd                	j	8000245c <exit+0x4c>
  begin_op();
    80002468:	00002097          	auipc	ra,0x2
    8000246c:	f44080e7          	jalr	-188(ra) # 800043ac <begin_op>
  iput(p->cwd);
    80002470:	1509b503          	ld	a0,336(s3)
    80002474:	00001097          	auipc	ra,0x1
    80002478:	732080e7          	jalr	1842(ra) # 80003ba6 <iput>
  end_op();
    8000247c:	00002097          	auipc	ra,0x2
    80002480:	fb0080e7          	jalr	-80(ra) # 8000442c <end_op>
  p->cwd = 0;
    80002484:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80002488:	00007497          	auipc	s1,0x7
    8000248c:	b9048493          	addi	s1,s1,-1136 # 80009018 <initproc>
    80002490:	6088                	ld	a0,0(s1)
    80002492:	ffffe097          	auipc	ra,0xffffe
    80002496:	76a080e7          	jalr	1898(ra) # 80000bfc <acquire>
  wakeup1(initproc);
    8000249a:	6088                	ld	a0,0(s1)
    8000249c:	fffff097          	auipc	ra,0xfffff
    800024a0:	628080e7          	jalr	1576(ra) # 80001ac4 <wakeup1>
  release(&initproc->lock);
    800024a4:	6088                	ld	a0,0(s1)
    800024a6:	fffff097          	auipc	ra,0xfffff
    800024aa:	80a080e7          	jalr	-2038(ra) # 80000cb0 <release>
  acquire(&p->lock);
    800024ae:	854e                	mv	a0,s3
    800024b0:	ffffe097          	auipc	ra,0xffffe
    800024b4:	74c080e7          	jalr	1868(ra) # 80000bfc <acquire>
  struct proc *original_parent = p->parent;
    800024b8:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800024bc:	854e                	mv	a0,s3
    800024be:	ffffe097          	auipc	ra,0xffffe
    800024c2:	7f2080e7          	jalr	2034(ra) # 80000cb0 <release>
  acquire(&original_parent->lock);
    800024c6:	8526                	mv	a0,s1
    800024c8:	ffffe097          	auipc	ra,0xffffe
    800024cc:	734080e7          	jalr	1844(ra) # 80000bfc <acquire>
  acquire(&p->lock);
    800024d0:	854e                	mv	a0,s3
    800024d2:	ffffe097          	auipc	ra,0xffffe
    800024d6:	72a080e7          	jalr	1834(ra) # 80000bfc <acquire>
  reparent(p);
    800024da:	854e                	mv	a0,s3
    800024dc:	00000097          	auipc	ra,0x0
    800024e0:	de8080e7          	jalr	-536(ra) # 800022c4 <reparent>
  wakeup1(original_parent);
    800024e4:	8526                	mv	a0,s1
    800024e6:	fffff097          	auipc	ra,0xfffff
    800024ea:	5de080e7          	jalr	1502(ra) # 80001ac4 <wakeup1>
  p->xstate = status;
    800024ee:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800024f2:	4791                	li	a5,4
    800024f4:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    800024f8:	8526                	mv	a0,s1
    800024fa:	ffffe097          	auipc	ra,0xffffe
    800024fe:	7b6080e7          	jalr	1974(ra) # 80000cb0 <release>
  sched();
    80002502:	00000097          	auipc	ra,0x0
    80002506:	e38080e7          	jalr	-456(ra) # 8000233a <sched>
  panic("zombie exit");
    8000250a:	00006517          	auipc	a0,0x6
    8000250e:	e1650513          	addi	a0,a0,-490 # 80008320 <digits+0x2e0>
    80002512:	ffffe097          	auipc	ra,0xffffe
    80002516:	02e080e7          	jalr	46(ra) # 80000540 <panic>

000000008000251a <yield>:
{
    8000251a:	1101                	addi	sp,sp,-32
    8000251c:	ec06                	sd	ra,24(sp)
    8000251e:	e822                	sd	s0,16(sp)
    80002520:	e426                	sd	s1,8(sp)
    80002522:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002524:	00000097          	auipc	ra,0x0
    80002528:	8a4080e7          	jalr	-1884(ra) # 80001dc8 <myproc>
    8000252c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000252e:	ffffe097          	auipc	ra,0xffffe
    80002532:	6ce080e7          	jalr	1742(ra) # 80000bfc <acquire>
  p->state = RUNNABLE;
    80002536:	4789                	li	a5,2
    80002538:	cc9c                	sw	a5,24(s1)
  sched();
    8000253a:	00000097          	auipc	ra,0x0
    8000253e:	e00080e7          	jalr	-512(ra) # 8000233a <sched>
  release(&p->lock);
    80002542:	8526                	mv	a0,s1
    80002544:	ffffe097          	auipc	ra,0xffffe
    80002548:	76c080e7          	jalr	1900(ra) # 80000cb0 <release>
}
    8000254c:	60e2                	ld	ra,24(sp)
    8000254e:	6442                	ld	s0,16(sp)
    80002550:	64a2                	ld	s1,8(sp)
    80002552:	6105                	addi	sp,sp,32
    80002554:	8082                	ret

0000000080002556 <sleep>:
{
    80002556:	7179                	addi	sp,sp,-48
    80002558:	f406                	sd	ra,40(sp)
    8000255a:	f022                	sd	s0,32(sp)
    8000255c:	ec26                	sd	s1,24(sp)
    8000255e:	e84a                	sd	s2,16(sp)
    80002560:	e44e                	sd	s3,8(sp)
    80002562:	1800                	addi	s0,sp,48
    80002564:	89aa                	mv	s3,a0
    80002566:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002568:	00000097          	auipc	ra,0x0
    8000256c:	860080e7          	jalr	-1952(ra) # 80001dc8 <myproc>
    80002570:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002572:	05250663          	beq	a0,s2,800025be <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002576:	ffffe097          	auipc	ra,0xffffe
    8000257a:	686080e7          	jalr	1670(ra) # 80000bfc <acquire>
    release(lk);
    8000257e:	854a                	mv	a0,s2
    80002580:	ffffe097          	auipc	ra,0xffffe
    80002584:	730080e7          	jalr	1840(ra) # 80000cb0 <release>
  p->chan = chan;
    80002588:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000258c:	4785                	li	a5,1
    8000258e:	cc9c                	sw	a5,24(s1)
  sched();
    80002590:	00000097          	auipc	ra,0x0
    80002594:	daa080e7          	jalr	-598(ra) # 8000233a <sched>
  p->chan = 0;
    80002598:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    8000259c:	8526                	mv	a0,s1
    8000259e:	ffffe097          	auipc	ra,0xffffe
    800025a2:	712080e7          	jalr	1810(ra) # 80000cb0 <release>
    acquire(lk);
    800025a6:	854a                	mv	a0,s2
    800025a8:	ffffe097          	auipc	ra,0xffffe
    800025ac:	654080e7          	jalr	1620(ra) # 80000bfc <acquire>
}
    800025b0:	70a2                	ld	ra,40(sp)
    800025b2:	7402                	ld	s0,32(sp)
    800025b4:	64e2                	ld	s1,24(sp)
    800025b6:	6942                	ld	s2,16(sp)
    800025b8:	69a2                	ld	s3,8(sp)
    800025ba:	6145                	addi	sp,sp,48
    800025bc:	8082                	ret
  p->chan = chan;
    800025be:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800025c2:	4785                	li	a5,1
    800025c4:	cd1c                	sw	a5,24(a0)
  sched();
    800025c6:	00000097          	auipc	ra,0x0
    800025ca:	d74080e7          	jalr	-652(ra) # 8000233a <sched>
  p->chan = 0;
    800025ce:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800025d2:	bff9                	j	800025b0 <sleep+0x5a>

00000000800025d4 <wait>:
{
    800025d4:	715d                	addi	sp,sp,-80
    800025d6:	e486                	sd	ra,72(sp)
    800025d8:	e0a2                	sd	s0,64(sp)
    800025da:	fc26                	sd	s1,56(sp)
    800025dc:	f84a                	sd	s2,48(sp)
    800025de:	f44e                	sd	s3,40(sp)
    800025e0:	f052                	sd	s4,32(sp)
    800025e2:	ec56                	sd	s5,24(sp)
    800025e4:	e85a                	sd	s6,16(sp)
    800025e6:	e45e                	sd	s7,8(sp)
    800025e8:	0880                	addi	s0,sp,80
    800025ea:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800025ec:	fffff097          	auipc	ra,0xfffff
    800025f0:	7dc080e7          	jalr	2012(ra) # 80001dc8 <myproc>
    800025f4:	892a                	mv	s2,a0
  acquire(&p->lock);
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	606080e7          	jalr	1542(ra) # 80000bfc <acquire>
    havekids = 0;
    800025fe:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002600:	4a11                	li	s4,4
        havekids = 1;
    80002602:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002604:	00015997          	auipc	s3,0x15
    80002608:	7ac98993          	addi	s3,s3,1964 # 80017db0 <tickslock>
    havekids = 0;
    8000260c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000260e:	0000f497          	auipc	s1,0xf
    80002612:	7a248493          	addi	s1,s1,1954 # 80011db0 <proc>
    80002616:	a08d                	j	80002678 <wait+0xa4>
          pid = np->pid;
    80002618:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000261c:	000b0e63          	beqz	s6,80002638 <wait+0x64>
    80002620:	4691                	li	a3,4
    80002622:	03448613          	addi	a2,s1,52
    80002626:	85da                	mv	a1,s6
    80002628:	05093503          	ld	a0,80(s2)
    8000262c:	fffff097          	auipc	ra,0xfffff
    80002630:	07e080e7          	jalr	126(ra) # 800016aa <copyout>
    80002634:	02054263          	bltz	a0,80002658 <wait+0x84>
          freeproc(np);
    80002638:	8526                	mv	a0,s1
    8000263a:	00000097          	auipc	ra,0x0
    8000263e:	940080e7          	jalr	-1728(ra) # 80001f7a <freeproc>
          release(&np->lock);
    80002642:	8526                	mv	a0,s1
    80002644:	ffffe097          	auipc	ra,0xffffe
    80002648:	66c080e7          	jalr	1644(ra) # 80000cb0 <release>
          release(&p->lock);
    8000264c:	854a                	mv	a0,s2
    8000264e:	ffffe097          	auipc	ra,0xffffe
    80002652:	662080e7          	jalr	1634(ra) # 80000cb0 <release>
          return pid;
    80002656:	a8a9                	j	800026b0 <wait+0xdc>
            release(&np->lock);
    80002658:	8526                	mv	a0,s1
    8000265a:	ffffe097          	auipc	ra,0xffffe
    8000265e:	656080e7          	jalr	1622(ra) # 80000cb0 <release>
            release(&p->lock);
    80002662:	854a                	mv	a0,s2
    80002664:	ffffe097          	auipc	ra,0xffffe
    80002668:	64c080e7          	jalr	1612(ra) # 80000cb0 <release>
            return -1;
    8000266c:	59fd                	li	s3,-1
    8000266e:	a089                	j	800026b0 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    80002670:	18048493          	addi	s1,s1,384
    80002674:	03348463          	beq	s1,s3,8000269c <wait+0xc8>
      if(np->parent == p){
    80002678:	709c                	ld	a5,32(s1)
    8000267a:	ff279be3          	bne	a5,s2,80002670 <wait+0x9c>
        acquire(&np->lock);
    8000267e:	8526                	mv	a0,s1
    80002680:	ffffe097          	auipc	ra,0xffffe
    80002684:	57c080e7          	jalr	1404(ra) # 80000bfc <acquire>
        if(np->state == ZOMBIE){
    80002688:	4c9c                	lw	a5,24(s1)
    8000268a:	f94787e3          	beq	a5,s4,80002618 <wait+0x44>
        release(&np->lock);
    8000268e:	8526                	mv	a0,s1
    80002690:	ffffe097          	auipc	ra,0xffffe
    80002694:	620080e7          	jalr	1568(ra) # 80000cb0 <release>
        havekids = 1;
    80002698:	8756                	mv	a4,s5
    8000269a:	bfd9                	j	80002670 <wait+0x9c>
    if(!havekids || p->killed){
    8000269c:	c701                	beqz	a4,800026a4 <wait+0xd0>
    8000269e:	03092783          	lw	a5,48(s2)
    800026a2:	c39d                	beqz	a5,800026c8 <wait+0xf4>
      release(&p->lock);
    800026a4:	854a                	mv	a0,s2
    800026a6:	ffffe097          	auipc	ra,0xffffe
    800026aa:	60a080e7          	jalr	1546(ra) # 80000cb0 <release>
      return -1;
    800026ae:	59fd                	li	s3,-1
}
    800026b0:	854e                	mv	a0,s3
    800026b2:	60a6                	ld	ra,72(sp)
    800026b4:	6406                	ld	s0,64(sp)
    800026b6:	74e2                	ld	s1,56(sp)
    800026b8:	7942                	ld	s2,48(sp)
    800026ba:	79a2                	ld	s3,40(sp)
    800026bc:	7a02                	ld	s4,32(sp)
    800026be:	6ae2                	ld	s5,24(sp)
    800026c0:	6b42                	ld	s6,16(sp)
    800026c2:	6ba2                	ld	s7,8(sp)
    800026c4:	6161                	addi	sp,sp,80
    800026c6:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800026c8:	85ca                	mv	a1,s2
    800026ca:	854a                	mv	a0,s2
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	e8a080e7          	jalr	-374(ra) # 80002556 <sleep>
    havekids = 0;
    800026d4:	bf25                	j	8000260c <wait+0x38>

00000000800026d6 <wakeup>:
{
    800026d6:	715d                	addi	sp,sp,-80
    800026d8:	e486                	sd	ra,72(sp)
    800026da:	e0a2                	sd	s0,64(sp)
    800026dc:	fc26                	sd	s1,56(sp)
    800026de:	f84a                	sd	s2,48(sp)
    800026e0:	f44e                	sd	s3,40(sp)
    800026e2:	f052                	sd	s4,32(sp)
    800026e4:	ec56                	sd	s5,24(sp)
    800026e6:	e85a                	sd	s6,16(sp)
    800026e8:	e45e                	sd	s7,8(sp)
    800026ea:	0880                	addi	s0,sp,80
    800026ec:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800026ee:	0000f497          	auipc	s1,0xf
    800026f2:	6c248493          	addi	s1,s1,1730 # 80011db0 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800026f6:	4985                	li	s3,1
      p->state = RUNNABLE;
    800026f8:	4a89                	li	s5,2
        __RE_MOVE___(p, &q0, &q2);
    800026fa:	0000fb97          	auipc	s7,0xf
    800026fe:	256b8b93          	addi	s7,s7,598 # 80011950 <q2>
    80002702:	0000fb17          	auipc	s6,0xf
    80002706:	27eb0b13          	addi	s6,s6,638 # 80011980 <q0>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000270a:	00015917          	auipc	s2,0x15
    8000270e:	6a690913          	addi	s2,s2,1702 # 80017db0 <tickslock>
    80002712:	a811                	j	80002726 <wakeup+0x50>
    release(&p->lock);
    80002714:	8526                	mv	a0,s1
    80002716:	ffffe097          	auipc	ra,0xffffe
    8000271a:	59a080e7          	jalr	1434(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000271e:	18048493          	addi	s1,s1,384
    80002722:	03248f63          	beq	s1,s2,80002760 <wakeup+0x8a>
    acquire(&p->lock);
    80002726:	8526                	mv	a0,s1
    80002728:	ffffe097          	auipc	ra,0xffffe
    8000272c:	4d4080e7          	jalr	1236(ra) # 80000bfc <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002730:	4c9c                	lw	a5,24(s1)
    80002732:	ff3791e3          	bne	a5,s3,80002714 <wakeup+0x3e>
    80002736:	749c                	ld	a5,40(s1)
    80002738:	fd479ee3          	bne	a5,s4,80002714 <wakeup+0x3e>
      p->state = RUNNABLE;
    8000273c:	0154ac23          	sw	s5,24(s1)
      if (is_q0(p)) // Move all to q2
    80002740:	1684a783          	lw	a5,360(s1)
    80002744:	fbe1                	bnez	a5,80002714 <wakeup+0x3e>
        __RE_MOVE___(p, &q0, &q2);
    80002746:	85a6                	mv	a1,s1
    80002748:	855a                	mv	a0,s6
    8000274a:	fffff097          	auipc	ra,0xfffff
    8000274e:	2f0080e7          	jalr	752(ra) # 80001a3a <remove>
    80002752:	85aa                	mv	a1,a0
    80002754:	855e                	mv	a0,s7
    80002756:	fffff097          	auipc	ra,0xfffff
    8000275a:	25e080e7          	jalr	606(ra) # 800019b4 <enqueue>
    8000275e:	bf5d                	j	80002714 <wakeup+0x3e>
}
    80002760:	60a6                	ld	ra,72(sp)
    80002762:	6406                	ld	s0,64(sp)
    80002764:	74e2                	ld	s1,56(sp)
    80002766:	7942                	ld	s2,48(sp)
    80002768:	79a2                	ld	s3,40(sp)
    8000276a:	7a02                	ld	s4,32(sp)
    8000276c:	6ae2                	ld	s5,24(sp)
    8000276e:	6b42                	ld	s6,16(sp)
    80002770:	6ba2                	ld	s7,8(sp)
    80002772:	6161                	addi	sp,sp,80
    80002774:	8082                	ret

0000000080002776 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002776:	7179                	addi	sp,sp,-48
    80002778:	f406                	sd	ra,40(sp)
    8000277a:	f022                	sd	s0,32(sp)
    8000277c:	ec26                	sd	s1,24(sp)
    8000277e:	e84a                	sd	s2,16(sp)
    80002780:	e44e                	sd	s3,8(sp)
    80002782:	1800                	addi	s0,sp,48
    80002784:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002786:	0000f497          	auipc	s1,0xf
    8000278a:	62a48493          	addi	s1,s1,1578 # 80011db0 <proc>
    8000278e:	00015997          	auipc	s3,0x15
    80002792:	62298993          	addi	s3,s3,1570 # 80017db0 <tickslock>
    acquire(&p->lock);
    80002796:	8526                	mv	a0,s1
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	464080e7          	jalr	1124(ra) # 80000bfc <acquire>
    if(p->pid == pid){
    800027a0:	5c9c                	lw	a5,56(s1)
    800027a2:	01278d63          	beq	a5,s2,800027bc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800027a6:	8526                	mv	a0,s1
    800027a8:	ffffe097          	auipc	ra,0xffffe
    800027ac:	508080e7          	jalr	1288(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800027b0:	18048493          	addi	s1,s1,384
    800027b4:	ff3491e3          	bne	s1,s3,80002796 <kill+0x20>
  }
  return -1;
    800027b8:	557d                	li	a0,-1
    800027ba:	a821                	j	800027d2 <kill+0x5c>
      p->killed = 1;
    800027bc:	4785                	li	a5,1
    800027be:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800027c0:	4c98                	lw	a4,24(s1)
    800027c2:	00f70f63          	beq	a4,a5,800027e0 <kill+0x6a>
      release(&p->lock);
    800027c6:	8526                	mv	a0,s1
    800027c8:	ffffe097          	auipc	ra,0xffffe
    800027cc:	4e8080e7          	jalr	1256(ra) # 80000cb0 <release>
      return 0;
    800027d0:	4501                	li	a0,0
}
    800027d2:	70a2                	ld	ra,40(sp)
    800027d4:	7402                	ld	s0,32(sp)
    800027d6:	64e2                	ld	s1,24(sp)
    800027d8:	6942                	ld	s2,16(sp)
    800027da:	69a2                	ld	s3,8(sp)
    800027dc:	6145                	addi	sp,sp,48
    800027de:	8082                	ret
        p->state = RUNNABLE;
    800027e0:	4789                	li	a5,2
    800027e2:	cc9c                	sw	a5,24(s1)
    800027e4:	b7cd                	j	800027c6 <kill+0x50>

00000000800027e6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800027e6:	7179                	addi	sp,sp,-48
    800027e8:	f406                	sd	ra,40(sp)
    800027ea:	f022                	sd	s0,32(sp)
    800027ec:	ec26                	sd	s1,24(sp)
    800027ee:	e84a                	sd	s2,16(sp)
    800027f0:	e44e                	sd	s3,8(sp)
    800027f2:	e052                	sd	s4,0(sp)
    800027f4:	1800                	addi	s0,sp,48
    800027f6:	84aa                	mv	s1,a0
    800027f8:	892e                	mv	s2,a1
    800027fa:	89b2                	mv	s3,a2
    800027fc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800027fe:	fffff097          	auipc	ra,0xfffff
    80002802:	5ca080e7          	jalr	1482(ra) # 80001dc8 <myproc>
  if(user_dst){
    80002806:	c08d                	beqz	s1,80002828 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002808:	86d2                	mv	a3,s4
    8000280a:	864e                	mv	a2,s3
    8000280c:	85ca                	mv	a1,s2
    8000280e:	6928                	ld	a0,80(a0)
    80002810:	fffff097          	auipc	ra,0xfffff
    80002814:	e9a080e7          	jalr	-358(ra) # 800016aa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002818:	70a2                	ld	ra,40(sp)
    8000281a:	7402                	ld	s0,32(sp)
    8000281c:	64e2                	ld	s1,24(sp)
    8000281e:	6942                	ld	s2,16(sp)
    80002820:	69a2                	ld	s3,8(sp)
    80002822:	6a02                	ld	s4,0(sp)
    80002824:	6145                	addi	sp,sp,48
    80002826:	8082                	ret
    memmove((char *)dst, src, len);
    80002828:	000a061b          	sext.w	a2,s4
    8000282c:	85ce                	mv	a1,s3
    8000282e:	854a                	mv	a0,s2
    80002830:	ffffe097          	auipc	ra,0xffffe
    80002834:	524080e7          	jalr	1316(ra) # 80000d54 <memmove>
    return 0;
    80002838:	8526                	mv	a0,s1
    8000283a:	bff9                	j	80002818 <either_copyout+0x32>

000000008000283c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000283c:	7179                	addi	sp,sp,-48
    8000283e:	f406                	sd	ra,40(sp)
    80002840:	f022                	sd	s0,32(sp)
    80002842:	ec26                	sd	s1,24(sp)
    80002844:	e84a                	sd	s2,16(sp)
    80002846:	e44e                	sd	s3,8(sp)
    80002848:	e052                	sd	s4,0(sp)
    8000284a:	1800                	addi	s0,sp,48
    8000284c:	892a                	mv	s2,a0
    8000284e:	84ae                	mv	s1,a1
    80002850:	89b2                	mv	s3,a2
    80002852:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002854:	fffff097          	auipc	ra,0xfffff
    80002858:	574080e7          	jalr	1396(ra) # 80001dc8 <myproc>
  if(user_src){
    8000285c:	c08d                	beqz	s1,8000287e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000285e:	86d2                	mv	a3,s4
    80002860:	864e                	mv	a2,s3
    80002862:	85ca                	mv	a1,s2
    80002864:	6928                	ld	a0,80(a0)
    80002866:	fffff097          	auipc	ra,0xfffff
    8000286a:	ed0080e7          	jalr	-304(ra) # 80001736 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000286e:	70a2                	ld	ra,40(sp)
    80002870:	7402                	ld	s0,32(sp)
    80002872:	64e2                	ld	s1,24(sp)
    80002874:	6942                	ld	s2,16(sp)
    80002876:	69a2                	ld	s3,8(sp)
    80002878:	6a02                	ld	s4,0(sp)
    8000287a:	6145                	addi	sp,sp,48
    8000287c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000287e:	000a061b          	sext.w	a2,s4
    80002882:	85ce                	mv	a1,s3
    80002884:	854a                	mv	a0,s2
    80002886:	ffffe097          	auipc	ra,0xffffe
    8000288a:	4ce080e7          	jalr	1230(ra) # 80000d54 <memmove>
    return 0;
    8000288e:	8526                	mv	a0,s1
    80002890:	bff9                	j	8000286e <either_copyin+0x32>

0000000080002892 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002892:	715d                	addi	sp,sp,-80
    80002894:	e486                	sd	ra,72(sp)
    80002896:	e0a2                	sd	s0,64(sp)
    80002898:	fc26                	sd	s1,56(sp)
    8000289a:	f84a                	sd	s2,48(sp)
    8000289c:	f44e                	sd	s3,40(sp)
    8000289e:	f052                	sd	s4,32(sp)
    800028a0:	ec56                	sd	s5,24(sp)
    800028a2:	e85a                	sd	s6,16(sp)
    800028a4:	e45e                	sd	s7,8(sp)
    800028a6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800028a8:	00006517          	auipc	a0,0x6
    800028ac:	9b050513          	addi	a0,a0,-1616 # 80008258 <digits+0x218>
    800028b0:	ffffe097          	auipc	ra,0xffffe
    800028b4:	cda080e7          	jalr	-806(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800028b8:	0000f497          	auipc	s1,0xf
    800028bc:	65048493          	addi	s1,s1,1616 # 80011f08 <proc+0x158>
    800028c0:	00015917          	auipc	s2,0x15
    800028c4:	64890913          	addi	s2,s2,1608 # 80017f08 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028c8:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800028ca:	00006997          	auipc	s3,0x6
    800028ce:	a6698993          	addi	s3,s3,-1434 # 80008330 <digits+0x2f0>
    printf("%d %s %s", p->pid, state, p->name);
    800028d2:	00006a97          	auipc	s5,0x6
    800028d6:	a66a8a93          	addi	s5,s5,-1434 # 80008338 <digits+0x2f8>
    printf("\n");
    800028da:	00006a17          	auipc	s4,0x6
    800028de:	97ea0a13          	addi	s4,s4,-1666 # 80008258 <digits+0x218>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028e2:	00006b97          	auipc	s7,0x6
    800028e6:	a8eb8b93          	addi	s7,s7,-1394 # 80008370 <states.0>
    800028ea:	a00d                	j	8000290c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800028ec:	ee06a583          	lw	a1,-288(a3)
    800028f0:	8556                	mv	a0,s5
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	c98080e7          	jalr	-872(ra) # 8000058a <printf>
    printf("\n");
    800028fa:	8552                	mv	a0,s4
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	c8e080e7          	jalr	-882(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002904:	18048493          	addi	s1,s1,384
    80002908:	03248263          	beq	s1,s2,8000292c <procdump+0x9a>
    if(p->state == UNUSED)
    8000290c:	86a6                	mv	a3,s1
    8000290e:	ec04a783          	lw	a5,-320(s1)
    80002912:	dbed                	beqz	a5,80002904 <procdump+0x72>
      state = "???";
    80002914:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002916:	fcfb6be3          	bltu	s6,a5,800028ec <procdump+0x5a>
    8000291a:	02079713          	slli	a4,a5,0x20
    8000291e:	01d75793          	srli	a5,a4,0x1d
    80002922:	97de                	add	a5,a5,s7
    80002924:	6390                	ld	a2,0(a5)
    80002926:	f279                	bnez	a2,800028ec <procdump+0x5a>
      state = "???";
    80002928:	864e                	mv	a2,s3
    8000292a:	b7c9                	j	800028ec <procdump+0x5a>
  }
}
    8000292c:	60a6                	ld	ra,72(sp)
    8000292e:	6406                	ld	s0,64(sp)
    80002930:	74e2                	ld	s1,56(sp)
    80002932:	7942                	ld	s2,48(sp)
    80002934:	79a2                	ld	s3,40(sp)
    80002936:	7a02                	ld	s4,32(sp)
    80002938:	6ae2                	ld	s5,24(sp)
    8000293a:	6b42                	ld	s6,16(sp)
    8000293c:	6ba2                	ld	s7,8(sp)
    8000293e:	6161                	addi	sp,sp,80
    80002940:	8082                	ret

0000000080002942 <swtch>:
    80002942:	00153023          	sd	ra,0(a0)
    80002946:	00253423          	sd	sp,8(a0)
    8000294a:	e900                	sd	s0,16(a0)
    8000294c:	ed04                	sd	s1,24(a0)
    8000294e:	03253023          	sd	s2,32(a0)
    80002952:	03353423          	sd	s3,40(a0)
    80002956:	03453823          	sd	s4,48(a0)
    8000295a:	03553c23          	sd	s5,56(a0)
    8000295e:	05653023          	sd	s6,64(a0)
    80002962:	05753423          	sd	s7,72(a0)
    80002966:	05853823          	sd	s8,80(a0)
    8000296a:	05953c23          	sd	s9,88(a0)
    8000296e:	07a53023          	sd	s10,96(a0)
    80002972:	07b53423          	sd	s11,104(a0)
    80002976:	0005b083          	ld	ra,0(a1)
    8000297a:	0085b103          	ld	sp,8(a1)
    8000297e:	6980                	ld	s0,16(a1)
    80002980:	6d84                	ld	s1,24(a1)
    80002982:	0205b903          	ld	s2,32(a1)
    80002986:	0285b983          	ld	s3,40(a1)
    8000298a:	0305ba03          	ld	s4,48(a1)
    8000298e:	0385ba83          	ld	s5,56(a1)
    80002992:	0405bb03          	ld	s6,64(a1)
    80002996:	0485bb83          	ld	s7,72(a1)
    8000299a:	0505bc03          	ld	s8,80(a1)
    8000299e:	0585bc83          	ld	s9,88(a1)
    800029a2:	0605bd03          	ld	s10,96(a1)
    800029a6:	0685bd83          	ld	s11,104(a1)
    800029aa:	8082                	ret

00000000800029ac <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800029ac:	1141                	addi	sp,sp,-16
    800029ae:	e406                	sd	ra,8(sp)
    800029b0:	e022                	sd	s0,0(sp)
    800029b2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800029b4:	00006597          	auipc	a1,0x6
    800029b8:	9e458593          	addi	a1,a1,-1564 # 80008398 <states.0+0x28>
    800029bc:	00015517          	auipc	a0,0x15
    800029c0:	3f450513          	addi	a0,a0,1012 # 80017db0 <tickslock>
    800029c4:	ffffe097          	auipc	ra,0xffffe
    800029c8:	1a8080e7          	jalr	424(ra) # 80000b6c <initlock>
}
    800029cc:	60a2                	ld	ra,8(sp)
    800029ce:	6402                	ld	s0,0(sp)
    800029d0:	0141                	addi	sp,sp,16
    800029d2:	8082                	ret

00000000800029d4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800029d4:	1141                	addi	sp,sp,-16
    800029d6:	e422                	sd	s0,8(sp)
    800029d8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029da:	00003797          	auipc	a5,0x3
    800029de:	50678793          	addi	a5,a5,1286 # 80005ee0 <kernelvec>
    800029e2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800029e6:	6422                	ld	s0,8(sp)
    800029e8:	0141                	addi	sp,sp,16
    800029ea:	8082                	ret

00000000800029ec <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800029ec:	1141                	addi	sp,sp,-16
    800029ee:	e406                	sd	ra,8(sp)
    800029f0:	e022                	sd	s0,0(sp)
    800029f2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800029f4:	fffff097          	auipc	ra,0xfffff
    800029f8:	3d4080e7          	jalr	980(ra) # 80001dc8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a02:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002a06:	00004617          	auipc	a2,0x4
    80002a0a:	5fa60613          	addi	a2,a2,1530 # 80007000 <_trampoline>
    80002a0e:	00004697          	auipc	a3,0x4
    80002a12:	5f268693          	addi	a3,a3,1522 # 80007000 <_trampoline>
    80002a16:	8e91                	sub	a3,a3,a2
    80002a18:	040007b7          	lui	a5,0x4000
    80002a1c:	17fd                	addi	a5,a5,-1
    80002a1e:	07b2                	slli	a5,a5,0xc
    80002a20:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a22:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a26:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a28:	180026f3          	csrr	a3,satp
    80002a2c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a2e:	6d38                	ld	a4,88(a0)
    80002a30:	6134                	ld	a3,64(a0)
    80002a32:	6585                	lui	a1,0x1
    80002a34:	96ae                	add	a3,a3,a1
    80002a36:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002a38:	6d38                	ld	a4,88(a0)
    80002a3a:	00000697          	auipc	a3,0x0
    80002a3e:	13868693          	addi	a3,a3,312 # 80002b72 <usertrap>
    80002a42:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002a44:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002a46:	8692                	mv	a3,tp
    80002a48:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a4a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002a4e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002a52:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a56:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002a5a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a5c:	6f18                	ld	a4,24(a4)
    80002a5e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002a62:	692c                	ld	a1,80(a0)
    80002a64:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002a66:	00004717          	auipc	a4,0x4
    80002a6a:	62a70713          	addi	a4,a4,1578 # 80007090 <userret>
    80002a6e:	8f11                	sub	a4,a4,a2
    80002a70:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002a72:	577d                	li	a4,-1
    80002a74:	177e                	slli	a4,a4,0x3f
    80002a76:	8dd9                	or	a1,a1,a4
    80002a78:	02000537          	lui	a0,0x2000
    80002a7c:	157d                	addi	a0,a0,-1
    80002a7e:	0536                	slli	a0,a0,0xd
    80002a80:	9782                	jalr	a5
}
    80002a82:	60a2                	ld	ra,8(sp)
    80002a84:	6402                	ld	s0,0(sp)
    80002a86:	0141                	addi	sp,sp,16
    80002a88:	8082                	ret

0000000080002a8a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002a8a:	1101                	addi	sp,sp,-32
    80002a8c:	ec06                	sd	ra,24(sp)
    80002a8e:	e822                	sd	s0,16(sp)
    80002a90:	e426                	sd	s1,8(sp)
    80002a92:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002a94:	00015497          	auipc	s1,0x15
    80002a98:	31c48493          	addi	s1,s1,796 # 80017db0 <tickslock>
    80002a9c:	8526                	mv	a0,s1
    80002a9e:	ffffe097          	auipc	ra,0xffffe
    80002aa2:	15e080e7          	jalr	350(ra) # 80000bfc <acquire>
  ticks++;
    80002aa6:	00006517          	auipc	a0,0x6
    80002aaa:	57a50513          	addi	a0,a0,1402 # 80009020 <ticks>
    80002aae:	411c                	lw	a5,0(a0)
    80002ab0:	2785                	addiw	a5,a5,1
    80002ab2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	c22080e7          	jalr	-990(ra) # 800026d6 <wakeup>
  release(&tickslock);
    80002abc:	8526                	mv	a0,s1
    80002abe:	ffffe097          	auipc	ra,0xffffe
    80002ac2:	1f2080e7          	jalr	498(ra) # 80000cb0 <release>
}
    80002ac6:	60e2                	ld	ra,24(sp)
    80002ac8:	6442                	ld	s0,16(sp)
    80002aca:	64a2                	ld	s1,8(sp)
    80002acc:	6105                	addi	sp,sp,32
    80002ace:	8082                	ret

0000000080002ad0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002ad0:	1101                	addi	sp,sp,-32
    80002ad2:	ec06                	sd	ra,24(sp)
    80002ad4:	e822                	sd	s0,16(sp)
    80002ad6:	e426                	sd	s1,8(sp)
    80002ad8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ada:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002ade:	00074d63          	bltz	a4,80002af8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002ae2:	57fd                	li	a5,-1
    80002ae4:	17fe                	slli	a5,a5,0x3f
    80002ae6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002ae8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002aea:	06f70363          	beq	a4,a5,80002b50 <devintr+0x80>
  }
}
    80002aee:	60e2                	ld	ra,24(sp)
    80002af0:	6442                	ld	s0,16(sp)
    80002af2:	64a2                	ld	s1,8(sp)
    80002af4:	6105                	addi	sp,sp,32
    80002af6:	8082                	ret
     (scause & 0xff) == 9){
    80002af8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002afc:	46a5                	li	a3,9
    80002afe:	fed792e3          	bne	a5,a3,80002ae2 <devintr+0x12>
    int irq = plic_claim();
    80002b02:	00003097          	auipc	ra,0x3
    80002b06:	4e6080e7          	jalr	1254(ra) # 80005fe8 <plic_claim>
    80002b0a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002b0c:	47a9                	li	a5,10
    80002b0e:	02f50763          	beq	a0,a5,80002b3c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002b12:	4785                	li	a5,1
    80002b14:	02f50963          	beq	a0,a5,80002b46 <devintr+0x76>
    return 1;
    80002b18:	4505                	li	a0,1
    } else if(irq){
    80002b1a:	d8f1                	beqz	s1,80002aee <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002b1c:	85a6                	mv	a1,s1
    80002b1e:	00006517          	auipc	a0,0x6
    80002b22:	88250513          	addi	a0,a0,-1918 # 800083a0 <states.0+0x30>
    80002b26:	ffffe097          	auipc	ra,0xffffe
    80002b2a:	a64080e7          	jalr	-1436(ra) # 8000058a <printf>
      plic_complete(irq);
    80002b2e:	8526                	mv	a0,s1
    80002b30:	00003097          	auipc	ra,0x3
    80002b34:	4dc080e7          	jalr	1244(ra) # 8000600c <plic_complete>
    return 1;
    80002b38:	4505                	li	a0,1
    80002b3a:	bf55                	j	80002aee <devintr+0x1e>
      uartintr();
    80002b3c:	ffffe097          	auipc	ra,0xffffe
    80002b40:	e84080e7          	jalr	-380(ra) # 800009c0 <uartintr>
    80002b44:	b7ed                	j	80002b2e <devintr+0x5e>
      virtio_disk_intr();
    80002b46:	00004097          	auipc	ra,0x4
    80002b4a:	940080e7          	jalr	-1728(ra) # 80006486 <virtio_disk_intr>
    80002b4e:	b7c5                	j	80002b2e <devintr+0x5e>
    if(cpuid() == 0){
    80002b50:	fffff097          	auipc	ra,0xfffff
    80002b54:	24c080e7          	jalr	588(ra) # 80001d9c <cpuid>
    80002b58:	c901                	beqz	a0,80002b68 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002b5a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002b5e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002b60:	14479073          	csrw	sip,a5
    return 2;
    80002b64:	4509                	li	a0,2
    80002b66:	b761                	j	80002aee <devintr+0x1e>
      clockintr();
    80002b68:	00000097          	auipc	ra,0x0
    80002b6c:	f22080e7          	jalr	-222(ra) # 80002a8a <clockintr>
    80002b70:	b7ed                	j	80002b5a <devintr+0x8a>

0000000080002b72 <usertrap>:
{
    80002b72:	1101                	addi	sp,sp,-32
    80002b74:	ec06                	sd	ra,24(sp)
    80002b76:	e822                	sd	s0,16(sp)
    80002b78:	e426                	sd	s1,8(sp)
    80002b7a:	e04a                	sd	s2,0(sp)
    80002b7c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b7e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002b82:	1007f793          	andi	a5,a5,256
    80002b86:	e3ad                	bnez	a5,80002be8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b88:	00003797          	auipc	a5,0x3
    80002b8c:	35878793          	addi	a5,a5,856 # 80005ee0 <kernelvec>
    80002b90:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002b94:	fffff097          	auipc	ra,0xfffff
    80002b98:	234080e7          	jalr	564(ra) # 80001dc8 <myproc>
    80002b9c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002b9e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ba0:	14102773          	csrr	a4,sepc
    80002ba4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ba6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002baa:	47a1                	li	a5,8
    80002bac:	04f71c63          	bne	a4,a5,80002c04 <usertrap+0x92>
    if(p->killed)
    80002bb0:	591c                	lw	a5,48(a0)
    80002bb2:	e3b9                	bnez	a5,80002bf8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002bb4:	6cb8                	ld	a4,88(s1)
    80002bb6:	6f1c                	ld	a5,24(a4)
    80002bb8:	0791                	addi	a5,a5,4
    80002bba:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bbc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002bc0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bc4:	10079073          	csrw	sstatus,a5
    syscall();
    80002bc8:	00000097          	auipc	ra,0x0
    80002bcc:	2e0080e7          	jalr	736(ra) # 80002ea8 <syscall>
  if(p->killed)
    80002bd0:	589c                	lw	a5,48(s1)
    80002bd2:	ebc1                	bnez	a5,80002c62 <usertrap+0xf0>
  usertrapret();
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	e18080e7          	jalr	-488(ra) # 800029ec <usertrapret>
}
    80002bdc:	60e2                	ld	ra,24(sp)
    80002bde:	6442                	ld	s0,16(sp)
    80002be0:	64a2                	ld	s1,8(sp)
    80002be2:	6902                	ld	s2,0(sp)
    80002be4:	6105                	addi	sp,sp,32
    80002be6:	8082                	ret
    panic("usertrap: not from user mode");
    80002be8:	00005517          	auipc	a0,0x5
    80002bec:	7d850513          	addi	a0,a0,2008 # 800083c0 <states.0+0x50>
    80002bf0:	ffffe097          	auipc	ra,0xffffe
    80002bf4:	950080e7          	jalr	-1712(ra) # 80000540 <panic>
      exit(-1);
    80002bf8:	557d                	li	a0,-1
    80002bfa:	00000097          	auipc	ra,0x0
    80002bfe:	816080e7          	jalr	-2026(ra) # 80002410 <exit>
    80002c02:	bf4d                	j	80002bb4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002c04:	00000097          	auipc	ra,0x0
    80002c08:	ecc080e7          	jalr	-308(ra) # 80002ad0 <devintr>
    80002c0c:	892a                	mv	s2,a0
    80002c0e:	c501                	beqz	a0,80002c16 <usertrap+0xa4>
  if(p->killed)
    80002c10:	589c                	lw	a5,48(s1)
    80002c12:	c3a1                	beqz	a5,80002c52 <usertrap+0xe0>
    80002c14:	a815                	j	80002c48 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c16:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002c1a:	5c90                	lw	a2,56(s1)
    80002c1c:	00005517          	auipc	a0,0x5
    80002c20:	7c450513          	addi	a0,a0,1988 # 800083e0 <states.0+0x70>
    80002c24:	ffffe097          	auipc	ra,0xffffe
    80002c28:	966080e7          	jalr	-1690(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c2c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c30:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c34:	00005517          	auipc	a0,0x5
    80002c38:	7dc50513          	addi	a0,a0,2012 # 80008410 <states.0+0xa0>
    80002c3c:	ffffe097          	auipc	ra,0xffffe
    80002c40:	94e080e7          	jalr	-1714(ra) # 8000058a <printf>
    p->killed = 1;
    80002c44:	4785                	li	a5,1
    80002c46:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002c48:	557d                	li	a0,-1
    80002c4a:	fffff097          	auipc	ra,0xfffff
    80002c4e:	7c6080e7          	jalr	1990(ra) # 80002410 <exit>
  if(which_dev == 2)
    80002c52:	4789                	li	a5,2
    80002c54:	f8f910e3          	bne	s2,a5,80002bd4 <usertrap+0x62>
    yield();
    80002c58:	00000097          	auipc	ra,0x0
    80002c5c:	8c2080e7          	jalr	-1854(ra) # 8000251a <yield>
    80002c60:	bf95                	j	80002bd4 <usertrap+0x62>
  int which_dev = 0;
    80002c62:	4901                	li	s2,0
    80002c64:	b7d5                	j	80002c48 <usertrap+0xd6>

0000000080002c66 <kerneltrap>:
{
    80002c66:	7179                	addi	sp,sp,-48
    80002c68:	f406                	sd	ra,40(sp)
    80002c6a:	f022                	sd	s0,32(sp)
    80002c6c:	ec26                	sd	s1,24(sp)
    80002c6e:	e84a                	sd	s2,16(sp)
    80002c70:	e44e                	sd	s3,8(sp)
    80002c72:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c74:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c78:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c7c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002c80:	1004f793          	andi	a5,s1,256
    80002c84:	cb85                	beqz	a5,80002cb4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c86:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002c8a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002c8c:	ef85                	bnez	a5,80002cc4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002c8e:	00000097          	auipc	ra,0x0
    80002c92:	e42080e7          	jalr	-446(ra) # 80002ad0 <devintr>
    80002c96:	cd1d                	beqz	a0,80002cd4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002c98:	4789                	li	a5,2
    80002c9a:	06f50a63          	beq	a0,a5,80002d0e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002c9e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ca2:	10049073          	csrw	sstatus,s1
}
    80002ca6:	70a2                	ld	ra,40(sp)
    80002ca8:	7402                	ld	s0,32(sp)
    80002caa:	64e2                	ld	s1,24(sp)
    80002cac:	6942                	ld	s2,16(sp)
    80002cae:	69a2                	ld	s3,8(sp)
    80002cb0:	6145                	addi	sp,sp,48
    80002cb2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002cb4:	00005517          	auipc	a0,0x5
    80002cb8:	77c50513          	addi	a0,a0,1916 # 80008430 <states.0+0xc0>
    80002cbc:	ffffe097          	auipc	ra,0xffffe
    80002cc0:	884080e7          	jalr	-1916(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    80002cc4:	00005517          	auipc	a0,0x5
    80002cc8:	79450513          	addi	a0,a0,1940 # 80008458 <states.0+0xe8>
    80002ccc:	ffffe097          	auipc	ra,0xffffe
    80002cd0:	874080e7          	jalr	-1932(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    80002cd4:	85ce                	mv	a1,s3
    80002cd6:	00005517          	auipc	a0,0x5
    80002cda:	7a250513          	addi	a0,a0,1954 # 80008478 <states.0+0x108>
    80002cde:	ffffe097          	auipc	ra,0xffffe
    80002ce2:	8ac080e7          	jalr	-1876(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ce6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002cea:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002cee:	00005517          	auipc	a0,0x5
    80002cf2:	79a50513          	addi	a0,a0,1946 # 80008488 <states.0+0x118>
    80002cf6:	ffffe097          	auipc	ra,0xffffe
    80002cfa:	894080e7          	jalr	-1900(ra) # 8000058a <printf>
    panic("kerneltrap");
    80002cfe:	00005517          	auipc	a0,0x5
    80002d02:	7a250513          	addi	a0,a0,1954 # 800084a0 <states.0+0x130>
    80002d06:	ffffe097          	auipc	ra,0xffffe
    80002d0a:	83a080e7          	jalr	-1990(ra) # 80000540 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d0e:	fffff097          	auipc	ra,0xfffff
    80002d12:	0ba080e7          	jalr	186(ra) # 80001dc8 <myproc>
    80002d16:	d541                	beqz	a0,80002c9e <kerneltrap+0x38>
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	0b0080e7          	jalr	176(ra) # 80001dc8 <myproc>
    80002d20:	4d18                	lw	a4,24(a0)
    80002d22:	478d                	li	a5,3
    80002d24:	f6f71de3          	bne	a4,a5,80002c9e <kerneltrap+0x38>
    yield();
    80002d28:	fffff097          	auipc	ra,0xfffff
    80002d2c:	7f2080e7          	jalr	2034(ra) # 8000251a <yield>
    80002d30:	b7bd                	j	80002c9e <kerneltrap+0x38>

0000000080002d32 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d32:	1101                	addi	sp,sp,-32
    80002d34:	ec06                	sd	ra,24(sp)
    80002d36:	e822                	sd	s0,16(sp)
    80002d38:	e426                	sd	s1,8(sp)
    80002d3a:	1000                	addi	s0,sp,32
    80002d3c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002d3e:	fffff097          	auipc	ra,0xfffff
    80002d42:	08a080e7          	jalr	138(ra) # 80001dc8 <myproc>
  switch (n) {
    80002d46:	4795                	li	a5,5
    80002d48:	0497e163          	bltu	a5,s1,80002d8a <argraw+0x58>
    80002d4c:	048a                	slli	s1,s1,0x2
    80002d4e:	00005717          	auipc	a4,0x5
    80002d52:	78a70713          	addi	a4,a4,1930 # 800084d8 <states.0+0x168>
    80002d56:	94ba                	add	s1,s1,a4
    80002d58:	409c                	lw	a5,0(s1)
    80002d5a:	97ba                	add	a5,a5,a4
    80002d5c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002d5e:	6d3c                	ld	a5,88(a0)
    80002d60:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002d62:	60e2                	ld	ra,24(sp)
    80002d64:	6442                	ld	s0,16(sp)
    80002d66:	64a2                	ld	s1,8(sp)
    80002d68:	6105                	addi	sp,sp,32
    80002d6a:	8082                	ret
    return p->trapframe->a1;
    80002d6c:	6d3c                	ld	a5,88(a0)
    80002d6e:	7fa8                	ld	a0,120(a5)
    80002d70:	bfcd                	j	80002d62 <argraw+0x30>
    return p->trapframe->a2;
    80002d72:	6d3c                	ld	a5,88(a0)
    80002d74:	63c8                	ld	a0,128(a5)
    80002d76:	b7f5                	j	80002d62 <argraw+0x30>
    return p->trapframe->a3;
    80002d78:	6d3c                	ld	a5,88(a0)
    80002d7a:	67c8                	ld	a0,136(a5)
    80002d7c:	b7dd                	j	80002d62 <argraw+0x30>
    return p->trapframe->a4;
    80002d7e:	6d3c                	ld	a5,88(a0)
    80002d80:	6bc8                	ld	a0,144(a5)
    80002d82:	b7c5                	j	80002d62 <argraw+0x30>
    return p->trapframe->a5;
    80002d84:	6d3c                	ld	a5,88(a0)
    80002d86:	6fc8                	ld	a0,152(a5)
    80002d88:	bfe9                	j	80002d62 <argraw+0x30>
  panic("argraw");
    80002d8a:	00005517          	auipc	a0,0x5
    80002d8e:	72650513          	addi	a0,a0,1830 # 800084b0 <states.0+0x140>
    80002d92:	ffffd097          	auipc	ra,0xffffd
    80002d96:	7ae080e7          	jalr	1966(ra) # 80000540 <panic>

0000000080002d9a <fetchaddr>:
{
    80002d9a:	1101                	addi	sp,sp,-32
    80002d9c:	ec06                	sd	ra,24(sp)
    80002d9e:	e822                	sd	s0,16(sp)
    80002da0:	e426                	sd	s1,8(sp)
    80002da2:	e04a                	sd	s2,0(sp)
    80002da4:	1000                	addi	s0,sp,32
    80002da6:	84aa                	mv	s1,a0
    80002da8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002daa:	fffff097          	auipc	ra,0xfffff
    80002dae:	01e080e7          	jalr	30(ra) # 80001dc8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002db2:	653c                	ld	a5,72(a0)
    80002db4:	02f4f863          	bgeu	s1,a5,80002de4 <fetchaddr+0x4a>
    80002db8:	00848713          	addi	a4,s1,8
    80002dbc:	02e7e663          	bltu	a5,a4,80002de8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002dc0:	46a1                	li	a3,8
    80002dc2:	8626                	mv	a2,s1
    80002dc4:	85ca                	mv	a1,s2
    80002dc6:	6928                	ld	a0,80(a0)
    80002dc8:	fffff097          	auipc	ra,0xfffff
    80002dcc:	96e080e7          	jalr	-1682(ra) # 80001736 <copyin>
    80002dd0:	00a03533          	snez	a0,a0
    80002dd4:	40a00533          	neg	a0,a0
}
    80002dd8:	60e2                	ld	ra,24(sp)
    80002dda:	6442                	ld	s0,16(sp)
    80002ddc:	64a2                	ld	s1,8(sp)
    80002dde:	6902                	ld	s2,0(sp)
    80002de0:	6105                	addi	sp,sp,32
    80002de2:	8082                	ret
    return -1;
    80002de4:	557d                	li	a0,-1
    80002de6:	bfcd                	j	80002dd8 <fetchaddr+0x3e>
    80002de8:	557d                	li	a0,-1
    80002dea:	b7fd                	j	80002dd8 <fetchaddr+0x3e>

0000000080002dec <fetchstr>:
{
    80002dec:	7179                	addi	sp,sp,-48
    80002dee:	f406                	sd	ra,40(sp)
    80002df0:	f022                	sd	s0,32(sp)
    80002df2:	ec26                	sd	s1,24(sp)
    80002df4:	e84a                	sd	s2,16(sp)
    80002df6:	e44e                	sd	s3,8(sp)
    80002df8:	1800                	addi	s0,sp,48
    80002dfa:	892a                	mv	s2,a0
    80002dfc:	84ae                	mv	s1,a1
    80002dfe:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002e00:	fffff097          	auipc	ra,0xfffff
    80002e04:	fc8080e7          	jalr	-56(ra) # 80001dc8 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002e08:	86ce                	mv	a3,s3
    80002e0a:	864a                	mv	a2,s2
    80002e0c:	85a6                	mv	a1,s1
    80002e0e:	6928                	ld	a0,80(a0)
    80002e10:	fffff097          	auipc	ra,0xfffff
    80002e14:	9b4080e7          	jalr	-1612(ra) # 800017c4 <copyinstr>
  if(err < 0)
    80002e18:	00054763          	bltz	a0,80002e26 <fetchstr+0x3a>
  return strlen(buf);
    80002e1c:	8526                	mv	a0,s1
    80002e1e:	ffffe097          	auipc	ra,0xffffe
    80002e22:	05e080e7          	jalr	94(ra) # 80000e7c <strlen>
}
    80002e26:	70a2                	ld	ra,40(sp)
    80002e28:	7402                	ld	s0,32(sp)
    80002e2a:	64e2                	ld	s1,24(sp)
    80002e2c:	6942                	ld	s2,16(sp)
    80002e2e:	69a2                	ld	s3,8(sp)
    80002e30:	6145                	addi	sp,sp,48
    80002e32:	8082                	ret

0000000080002e34 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002e34:	1101                	addi	sp,sp,-32
    80002e36:	ec06                	sd	ra,24(sp)
    80002e38:	e822                	sd	s0,16(sp)
    80002e3a:	e426                	sd	s1,8(sp)
    80002e3c:	1000                	addi	s0,sp,32
    80002e3e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	ef2080e7          	jalr	-270(ra) # 80002d32 <argraw>
    80002e48:	c088                	sw	a0,0(s1)
  return 0;
}
    80002e4a:	4501                	li	a0,0
    80002e4c:	60e2                	ld	ra,24(sp)
    80002e4e:	6442                	ld	s0,16(sp)
    80002e50:	64a2                	ld	s1,8(sp)
    80002e52:	6105                	addi	sp,sp,32
    80002e54:	8082                	ret

0000000080002e56 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002e56:	1101                	addi	sp,sp,-32
    80002e58:	ec06                	sd	ra,24(sp)
    80002e5a:	e822                	sd	s0,16(sp)
    80002e5c:	e426                	sd	s1,8(sp)
    80002e5e:	1000                	addi	s0,sp,32
    80002e60:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e62:	00000097          	auipc	ra,0x0
    80002e66:	ed0080e7          	jalr	-304(ra) # 80002d32 <argraw>
    80002e6a:	e088                	sd	a0,0(s1)
  return 0;
}
    80002e6c:	4501                	li	a0,0
    80002e6e:	60e2                	ld	ra,24(sp)
    80002e70:	6442                	ld	s0,16(sp)
    80002e72:	64a2                	ld	s1,8(sp)
    80002e74:	6105                	addi	sp,sp,32
    80002e76:	8082                	ret

0000000080002e78 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002e78:	1101                	addi	sp,sp,-32
    80002e7a:	ec06                	sd	ra,24(sp)
    80002e7c:	e822                	sd	s0,16(sp)
    80002e7e:	e426                	sd	s1,8(sp)
    80002e80:	e04a                	sd	s2,0(sp)
    80002e82:	1000                	addi	s0,sp,32
    80002e84:	84ae                	mv	s1,a1
    80002e86:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002e88:	00000097          	auipc	ra,0x0
    80002e8c:	eaa080e7          	jalr	-342(ra) # 80002d32 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002e90:	864a                	mv	a2,s2
    80002e92:	85a6                	mv	a1,s1
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	f58080e7          	jalr	-168(ra) # 80002dec <fetchstr>
}
    80002e9c:	60e2                	ld	ra,24(sp)
    80002e9e:	6442                	ld	s0,16(sp)
    80002ea0:	64a2                	ld	s1,8(sp)
    80002ea2:	6902                	ld	s2,0(sp)
    80002ea4:	6105                	addi	sp,sp,32
    80002ea6:	8082                	ret

0000000080002ea8 <syscall>:

#endif

void
syscall(void)
{
    80002ea8:	1101                	addi	sp,sp,-32
    80002eaa:	ec06                	sd	ra,24(sp)
    80002eac:	e822                	sd	s0,16(sp)
    80002eae:	e426                	sd	s1,8(sp)
    80002eb0:	e04a                	sd	s2,0(sp)
    80002eb2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	f14080e7          	jalr	-236(ra) # 80001dc8 <myproc>
    80002ebc:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ebe:	05853903          	ld	s2,88(a0)
    80002ec2:	0a893783          	ld	a5,168(s2)
    80002ec6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002eca:	37fd                	addiw	a5,a5,-1
    80002ecc:	4751                	li	a4,20
    80002ece:	00f76f63          	bltu	a4,a5,80002eec <syscall+0x44>
    80002ed2:	00369713          	slli	a4,a3,0x3
    80002ed6:	00005797          	auipc	a5,0x5
    80002eda:	61a78793          	addi	a5,a5,1562 # 800084f0 <syscalls>
    80002ede:	97ba                	add	a5,a5,a4
    80002ee0:	639c                	ld	a5,0(a5)
    80002ee2:	c789                	beqz	a5,80002eec <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002ee4:	9782                	jalr	a5
    80002ee6:	06a93823          	sd	a0,112(s2)
    80002eea:	a839                	j	80002f08 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002eec:	15848613          	addi	a2,s1,344
    80002ef0:	5c8c                	lw	a1,56(s1)
    80002ef2:	00005517          	auipc	a0,0x5
    80002ef6:	5c650513          	addi	a0,a0,1478 # 800084b8 <states.0+0x148>
    80002efa:	ffffd097          	auipc	ra,0xffffd
    80002efe:	690080e7          	jalr	1680(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002f02:	6cbc                	ld	a5,88(s1)
    80002f04:	577d                	li	a4,-1
    80002f06:	fbb8                	sd	a4,112(a5)
  }
#ifdef SUKJOON
  acquire(&p->lock);
    80002f08:	8526                	mv	a0,s1
    80002f0a:	ffffe097          	auipc	ra,0xffffe
    80002f0e:	cf2080e7          	jalr	-782(ra) # 80000bfc <acquire>
  if (is_q1(p)) { remove(&q1, p); enqueue(&q2, p); }
    80002f12:	8526                	mv	a0,s1
    80002f14:	fffff097          	auipc	ra,0xfffff
    80002f18:	9fe080e7          	jalr	-1538(ra) # 80001912 <is_q1>
    80002f1c:	ed01                	bnez	a0,80002f34 <syscall+0x8c>
  release(&p->lock);
    80002f1e:	8526                	mv	a0,s1
    80002f20:	ffffe097          	auipc	ra,0xffffe
    80002f24:	d90080e7          	jalr	-624(ra) # 80000cb0 <release>
#endif
}
    80002f28:	60e2                	ld	ra,24(sp)
    80002f2a:	6442                	ld	s0,16(sp)
    80002f2c:	64a2                	ld	s1,8(sp)
    80002f2e:	6902                	ld	s2,0(sp)
    80002f30:	6105                	addi	sp,sp,32
    80002f32:	8082                	ret
  if (is_q1(p)) { remove(&q1, p); enqueue(&q2, p); }
    80002f34:	85a6                	mv	a1,s1
    80002f36:	0000f517          	auipc	a0,0xf
    80002f3a:	a3250513          	addi	a0,a0,-1486 # 80011968 <q1>
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	afc080e7          	jalr	-1284(ra) # 80001a3a <remove>
    80002f46:	85a6                	mv	a1,s1
    80002f48:	0000f517          	auipc	a0,0xf
    80002f4c:	a0850513          	addi	a0,a0,-1528 # 80011950 <q2>
    80002f50:	fffff097          	auipc	ra,0xfffff
    80002f54:	a64080e7          	jalr	-1436(ra) # 800019b4 <enqueue>
    80002f58:	b7d9                	j	80002f1e <syscall+0x76>

0000000080002f5a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002f5a:	1101                	addi	sp,sp,-32
    80002f5c:	ec06                	sd	ra,24(sp)
    80002f5e:	e822                	sd	s0,16(sp)
    80002f60:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002f62:	fec40593          	addi	a1,s0,-20
    80002f66:	4501                	li	a0,0
    80002f68:	00000097          	auipc	ra,0x0
    80002f6c:	ecc080e7          	jalr	-308(ra) # 80002e34 <argint>
    return -1;
    80002f70:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002f72:	00054963          	bltz	a0,80002f84 <sys_exit+0x2a>
  exit(n);
    80002f76:	fec42503          	lw	a0,-20(s0)
    80002f7a:	fffff097          	auipc	ra,0xfffff
    80002f7e:	496080e7          	jalr	1174(ra) # 80002410 <exit>
  return 0;  // not reached
    80002f82:	4781                	li	a5,0
}
    80002f84:	853e                	mv	a0,a5
    80002f86:	60e2                	ld	ra,24(sp)
    80002f88:	6442                	ld	s0,16(sp)
    80002f8a:	6105                	addi	sp,sp,32
    80002f8c:	8082                	ret

0000000080002f8e <sys_getpid>:

uint64
sys_getpid(void)
{
    80002f8e:	1141                	addi	sp,sp,-16
    80002f90:	e406                	sd	ra,8(sp)
    80002f92:	e022                	sd	s0,0(sp)
    80002f94:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002f96:	fffff097          	auipc	ra,0xfffff
    80002f9a:	e32080e7          	jalr	-462(ra) # 80001dc8 <myproc>
}
    80002f9e:	5d08                	lw	a0,56(a0)
    80002fa0:	60a2                	ld	ra,8(sp)
    80002fa2:	6402                	ld	s0,0(sp)
    80002fa4:	0141                	addi	sp,sp,16
    80002fa6:	8082                	ret

0000000080002fa8 <sys_fork>:

uint64
sys_fork(void)
{
    80002fa8:	1141                	addi	sp,sp,-16
    80002faa:	e406                	sd	ra,8(sp)
    80002fac:	e022                	sd	s0,0(sp)
    80002fae:	0800                	addi	s0,sp,16
  return fork();
    80002fb0:	fffff097          	auipc	ra,0xfffff
    80002fb4:	206080e7          	jalr	518(ra) # 800021b6 <fork>
}
    80002fb8:	60a2                	ld	ra,8(sp)
    80002fba:	6402                	ld	s0,0(sp)
    80002fbc:	0141                	addi	sp,sp,16
    80002fbe:	8082                	ret

0000000080002fc0 <sys_wait>:

uint64
sys_wait(void)
{
    80002fc0:	1101                	addi	sp,sp,-32
    80002fc2:	ec06                	sd	ra,24(sp)
    80002fc4:	e822                	sd	s0,16(sp)
    80002fc6:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002fc8:	fe840593          	addi	a1,s0,-24
    80002fcc:	4501                	li	a0,0
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	e88080e7          	jalr	-376(ra) # 80002e56 <argaddr>
    80002fd6:	87aa                	mv	a5,a0
    return -1;
    80002fd8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002fda:	0007c863          	bltz	a5,80002fea <sys_wait+0x2a>
  return wait(p);
    80002fde:	fe843503          	ld	a0,-24(s0)
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	5f2080e7          	jalr	1522(ra) # 800025d4 <wait>
}
    80002fea:	60e2                	ld	ra,24(sp)
    80002fec:	6442                	ld	s0,16(sp)
    80002fee:	6105                	addi	sp,sp,32
    80002ff0:	8082                	ret

0000000080002ff2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002ff2:	7179                	addi	sp,sp,-48
    80002ff4:	f406                	sd	ra,40(sp)
    80002ff6:	f022                	sd	s0,32(sp)
    80002ff8:	ec26                	sd	s1,24(sp)
    80002ffa:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002ffc:	fdc40593          	addi	a1,s0,-36
    80003000:	4501                	li	a0,0
    80003002:	00000097          	auipc	ra,0x0
    80003006:	e32080e7          	jalr	-462(ra) # 80002e34 <argint>
    return -1;
    8000300a:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    8000300c:	00054f63          	bltz	a0,8000302a <sys_sbrk+0x38>
  addr = myproc()->sz;
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	db8080e7          	jalr	-584(ra) # 80001dc8 <myproc>
    80003018:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000301a:	fdc42503          	lw	a0,-36(s0)
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	124080e7          	jalr	292(ra) # 80002142 <growproc>
    80003026:	00054863          	bltz	a0,80003036 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    8000302a:	8526                	mv	a0,s1
    8000302c:	70a2                	ld	ra,40(sp)
    8000302e:	7402                	ld	s0,32(sp)
    80003030:	64e2                	ld	s1,24(sp)
    80003032:	6145                	addi	sp,sp,48
    80003034:	8082                	ret
    return -1;
    80003036:	54fd                	li	s1,-1
    80003038:	bfcd                	j	8000302a <sys_sbrk+0x38>

000000008000303a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000303a:	7139                	addi	sp,sp,-64
    8000303c:	fc06                	sd	ra,56(sp)
    8000303e:	f822                	sd	s0,48(sp)
    80003040:	f426                	sd	s1,40(sp)
    80003042:	f04a                	sd	s2,32(sp)
    80003044:	ec4e                	sd	s3,24(sp)
    80003046:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003048:	fcc40593          	addi	a1,s0,-52
    8000304c:	4501                	li	a0,0
    8000304e:	00000097          	auipc	ra,0x0
    80003052:	de6080e7          	jalr	-538(ra) # 80002e34 <argint>
    return -1;
    80003056:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003058:	06054563          	bltz	a0,800030c2 <sys_sleep+0x88>
  acquire(&tickslock);
    8000305c:	00015517          	auipc	a0,0x15
    80003060:	d5450513          	addi	a0,a0,-684 # 80017db0 <tickslock>
    80003064:	ffffe097          	auipc	ra,0xffffe
    80003068:	b98080e7          	jalr	-1128(ra) # 80000bfc <acquire>
  ticks0 = ticks;
    8000306c:	00006917          	auipc	s2,0x6
    80003070:	fb492903          	lw	s2,-76(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80003074:	fcc42783          	lw	a5,-52(s0)
    80003078:	cf85                	beqz	a5,800030b0 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000307a:	00015997          	auipc	s3,0x15
    8000307e:	d3698993          	addi	s3,s3,-714 # 80017db0 <tickslock>
    80003082:	00006497          	auipc	s1,0x6
    80003086:	f9e48493          	addi	s1,s1,-98 # 80009020 <ticks>
    if(myproc()->killed){
    8000308a:	fffff097          	auipc	ra,0xfffff
    8000308e:	d3e080e7          	jalr	-706(ra) # 80001dc8 <myproc>
    80003092:	591c                	lw	a5,48(a0)
    80003094:	ef9d                	bnez	a5,800030d2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80003096:	85ce                	mv	a1,s3
    80003098:	8526                	mv	a0,s1
    8000309a:	fffff097          	auipc	ra,0xfffff
    8000309e:	4bc080e7          	jalr	1212(ra) # 80002556 <sleep>
  while(ticks - ticks0 < n){
    800030a2:	409c                	lw	a5,0(s1)
    800030a4:	412787bb          	subw	a5,a5,s2
    800030a8:	fcc42703          	lw	a4,-52(s0)
    800030ac:	fce7efe3          	bltu	a5,a4,8000308a <sys_sleep+0x50>
  }
  release(&tickslock);
    800030b0:	00015517          	auipc	a0,0x15
    800030b4:	d0050513          	addi	a0,a0,-768 # 80017db0 <tickslock>
    800030b8:	ffffe097          	auipc	ra,0xffffe
    800030bc:	bf8080e7          	jalr	-1032(ra) # 80000cb0 <release>
  return 0;
    800030c0:	4781                	li	a5,0
}
    800030c2:	853e                	mv	a0,a5
    800030c4:	70e2                	ld	ra,56(sp)
    800030c6:	7442                	ld	s0,48(sp)
    800030c8:	74a2                	ld	s1,40(sp)
    800030ca:	7902                	ld	s2,32(sp)
    800030cc:	69e2                	ld	s3,24(sp)
    800030ce:	6121                	addi	sp,sp,64
    800030d0:	8082                	ret
      release(&tickslock);
    800030d2:	00015517          	auipc	a0,0x15
    800030d6:	cde50513          	addi	a0,a0,-802 # 80017db0 <tickslock>
    800030da:	ffffe097          	auipc	ra,0xffffe
    800030de:	bd6080e7          	jalr	-1066(ra) # 80000cb0 <release>
      return -1;
    800030e2:	57fd                	li	a5,-1
    800030e4:	bff9                	j	800030c2 <sys_sleep+0x88>

00000000800030e6 <sys_kill>:

uint64
sys_kill(void)
{
    800030e6:	1101                	addi	sp,sp,-32
    800030e8:	ec06                	sd	ra,24(sp)
    800030ea:	e822                	sd	s0,16(sp)
    800030ec:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800030ee:	fec40593          	addi	a1,s0,-20
    800030f2:	4501                	li	a0,0
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	d40080e7          	jalr	-704(ra) # 80002e34 <argint>
    800030fc:	87aa                	mv	a5,a0
    return -1;
    800030fe:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80003100:	0007c863          	bltz	a5,80003110 <sys_kill+0x2a>
  return kill(pid);
    80003104:	fec42503          	lw	a0,-20(s0)
    80003108:	fffff097          	auipc	ra,0xfffff
    8000310c:	66e080e7          	jalr	1646(ra) # 80002776 <kill>
}
    80003110:	60e2                	ld	ra,24(sp)
    80003112:	6442                	ld	s0,16(sp)
    80003114:	6105                	addi	sp,sp,32
    80003116:	8082                	ret

0000000080003118 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003118:	1101                	addi	sp,sp,-32
    8000311a:	ec06                	sd	ra,24(sp)
    8000311c:	e822                	sd	s0,16(sp)
    8000311e:	e426                	sd	s1,8(sp)
    80003120:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003122:	00015517          	auipc	a0,0x15
    80003126:	c8e50513          	addi	a0,a0,-882 # 80017db0 <tickslock>
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	ad2080e7          	jalr	-1326(ra) # 80000bfc <acquire>
  xticks = ticks;
    80003132:	00006497          	auipc	s1,0x6
    80003136:	eee4a483          	lw	s1,-274(s1) # 80009020 <ticks>
  release(&tickslock);
    8000313a:	00015517          	auipc	a0,0x15
    8000313e:	c7650513          	addi	a0,a0,-906 # 80017db0 <tickslock>
    80003142:	ffffe097          	auipc	ra,0xffffe
    80003146:	b6e080e7          	jalr	-1170(ra) # 80000cb0 <release>
  return xticks;
}
    8000314a:	02049513          	slli	a0,s1,0x20
    8000314e:	9101                	srli	a0,a0,0x20
    80003150:	60e2                	ld	ra,24(sp)
    80003152:	6442                	ld	s0,16(sp)
    80003154:	64a2                	ld	s1,8(sp)
    80003156:	6105                	addi	sp,sp,32
    80003158:	8082                	ret

000000008000315a <binit>:
    8000315a:	7179                	addi	sp,sp,-48
    8000315c:	f406                	sd	ra,40(sp)
    8000315e:	f022                	sd	s0,32(sp)
    80003160:	ec26                	sd	s1,24(sp)
    80003162:	e84a                	sd	s2,16(sp)
    80003164:	e44e                	sd	s3,8(sp)
    80003166:	e052                	sd	s4,0(sp)
    80003168:	1800                	addi	s0,sp,48
    8000316a:	00005597          	auipc	a1,0x5
    8000316e:	43658593          	addi	a1,a1,1078 # 800085a0 <syscalls+0xb0>
    80003172:	00015517          	auipc	a0,0x15
    80003176:	c5650513          	addi	a0,a0,-938 # 80017dc8 <bcache>
    8000317a:	ffffe097          	auipc	ra,0xffffe
    8000317e:	9f2080e7          	jalr	-1550(ra) # 80000b6c <initlock>
    80003182:	0001d797          	auipc	a5,0x1d
    80003186:	c4678793          	addi	a5,a5,-954 # 8001fdc8 <bcache+0x8000>
    8000318a:	0001d717          	auipc	a4,0x1d
    8000318e:	ea670713          	addi	a4,a4,-346 # 80020030 <bcache+0x8268>
    80003192:	2ae7b823          	sd	a4,688(a5)
    80003196:	2ae7bc23          	sd	a4,696(a5)
    8000319a:	00015497          	auipc	s1,0x15
    8000319e:	c4648493          	addi	s1,s1,-954 # 80017de0 <bcache+0x18>
    800031a2:	893e                	mv	s2,a5
    800031a4:	89ba                	mv	s3,a4
    800031a6:	00005a17          	auipc	s4,0x5
    800031aa:	402a0a13          	addi	s4,s4,1026 # 800085a8 <syscalls+0xb8>
    800031ae:	2b893783          	ld	a5,696(s2)
    800031b2:	e8bc                	sd	a5,80(s1)
    800031b4:	0534b423          	sd	s3,72(s1)
    800031b8:	85d2                	mv	a1,s4
    800031ba:	01048513          	addi	a0,s1,16
    800031be:	00001097          	auipc	ra,0x1
    800031c2:	4b2080e7          	jalr	1202(ra) # 80004670 <initsleeplock>
    800031c6:	2b893783          	ld	a5,696(s2)
    800031ca:	e7a4                	sd	s1,72(a5)
    800031cc:	2a993c23          	sd	s1,696(s2)
    800031d0:	45848493          	addi	s1,s1,1112
    800031d4:	fd349de3          	bne	s1,s3,800031ae <binit+0x54>
    800031d8:	70a2                	ld	ra,40(sp)
    800031da:	7402                	ld	s0,32(sp)
    800031dc:	64e2                	ld	s1,24(sp)
    800031de:	6942                	ld	s2,16(sp)
    800031e0:	69a2                	ld	s3,8(sp)
    800031e2:	6a02                	ld	s4,0(sp)
    800031e4:	6145                	addi	sp,sp,48
    800031e6:	8082                	ret

00000000800031e8 <bread>:
    800031e8:	7179                	addi	sp,sp,-48
    800031ea:	f406                	sd	ra,40(sp)
    800031ec:	f022                	sd	s0,32(sp)
    800031ee:	ec26                	sd	s1,24(sp)
    800031f0:	e84a                	sd	s2,16(sp)
    800031f2:	e44e                	sd	s3,8(sp)
    800031f4:	1800                	addi	s0,sp,48
    800031f6:	892a                	mv	s2,a0
    800031f8:	89ae                	mv	s3,a1
    800031fa:	00015517          	auipc	a0,0x15
    800031fe:	bce50513          	addi	a0,a0,-1074 # 80017dc8 <bcache>
    80003202:	ffffe097          	auipc	ra,0xffffe
    80003206:	9fa080e7          	jalr	-1542(ra) # 80000bfc <acquire>
    8000320a:	0001d497          	auipc	s1,0x1d
    8000320e:	e764b483          	ld	s1,-394(s1) # 80020080 <bcache+0x82b8>
    80003212:	0001d797          	auipc	a5,0x1d
    80003216:	e1e78793          	addi	a5,a5,-482 # 80020030 <bcache+0x8268>
    8000321a:	02f48f63          	beq	s1,a5,80003258 <bread+0x70>
    8000321e:	873e                	mv	a4,a5
    80003220:	a021                	j	80003228 <bread+0x40>
    80003222:	68a4                	ld	s1,80(s1)
    80003224:	02e48a63          	beq	s1,a4,80003258 <bread+0x70>
    80003228:	449c                	lw	a5,8(s1)
    8000322a:	ff279ce3          	bne	a5,s2,80003222 <bread+0x3a>
    8000322e:	44dc                	lw	a5,12(s1)
    80003230:	ff3799e3          	bne	a5,s3,80003222 <bread+0x3a>
    80003234:	40bc                	lw	a5,64(s1)
    80003236:	2785                	addiw	a5,a5,1
    80003238:	c0bc                	sw	a5,64(s1)
    8000323a:	00015517          	auipc	a0,0x15
    8000323e:	b8e50513          	addi	a0,a0,-1138 # 80017dc8 <bcache>
    80003242:	ffffe097          	auipc	ra,0xffffe
    80003246:	a6e080e7          	jalr	-1426(ra) # 80000cb0 <release>
    8000324a:	01048513          	addi	a0,s1,16
    8000324e:	00001097          	auipc	ra,0x1
    80003252:	45c080e7          	jalr	1116(ra) # 800046aa <acquiresleep>
    80003256:	a8b9                	j	800032b4 <bread+0xcc>
    80003258:	0001d497          	auipc	s1,0x1d
    8000325c:	e204b483          	ld	s1,-480(s1) # 80020078 <bcache+0x82b0>
    80003260:	0001d797          	auipc	a5,0x1d
    80003264:	dd078793          	addi	a5,a5,-560 # 80020030 <bcache+0x8268>
    80003268:	00f48863          	beq	s1,a5,80003278 <bread+0x90>
    8000326c:	873e                	mv	a4,a5
    8000326e:	40bc                	lw	a5,64(s1)
    80003270:	cf81                	beqz	a5,80003288 <bread+0xa0>
    80003272:	64a4                	ld	s1,72(s1)
    80003274:	fee49de3          	bne	s1,a4,8000326e <bread+0x86>
    80003278:	00005517          	auipc	a0,0x5
    8000327c:	33850513          	addi	a0,a0,824 # 800085b0 <syscalls+0xc0>
    80003280:	ffffd097          	auipc	ra,0xffffd
    80003284:	2c0080e7          	jalr	704(ra) # 80000540 <panic>
    80003288:	0124a423          	sw	s2,8(s1)
    8000328c:	0134a623          	sw	s3,12(s1)
    80003290:	0004a023          	sw	zero,0(s1)
    80003294:	4785                	li	a5,1
    80003296:	c0bc                	sw	a5,64(s1)
    80003298:	00015517          	auipc	a0,0x15
    8000329c:	b3050513          	addi	a0,a0,-1232 # 80017dc8 <bcache>
    800032a0:	ffffe097          	auipc	ra,0xffffe
    800032a4:	a10080e7          	jalr	-1520(ra) # 80000cb0 <release>
    800032a8:	01048513          	addi	a0,s1,16
    800032ac:	00001097          	auipc	ra,0x1
    800032b0:	3fe080e7          	jalr	1022(ra) # 800046aa <acquiresleep>
    800032b4:	409c                	lw	a5,0(s1)
    800032b6:	cb89                	beqz	a5,800032c8 <bread+0xe0>
    800032b8:	8526                	mv	a0,s1
    800032ba:	70a2                	ld	ra,40(sp)
    800032bc:	7402                	ld	s0,32(sp)
    800032be:	64e2                	ld	s1,24(sp)
    800032c0:	6942                	ld	s2,16(sp)
    800032c2:	69a2                	ld	s3,8(sp)
    800032c4:	6145                	addi	sp,sp,48
    800032c6:	8082                	ret
    800032c8:	4581                	li	a1,0
    800032ca:	8526                	mv	a0,s1
    800032cc:	00003097          	auipc	ra,0x3
    800032d0:	f30080e7          	jalr	-208(ra) # 800061fc <virtio_disk_rw>
    800032d4:	4785                	li	a5,1
    800032d6:	c09c                	sw	a5,0(s1)
    800032d8:	b7c5                	j	800032b8 <bread+0xd0>

00000000800032da <bwrite>:
    800032da:	1101                	addi	sp,sp,-32
    800032dc:	ec06                	sd	ra,24(sp)
    800032de:	e822                	sd	s0,16(sp)
    800032e0:	e426                	sd	s1,8(sp)
    800032e2:	1000                	addi	s0,sp,32
    800032e4:	84aa                	mv	s1,a0
    800032e6:	0541                	addi	a0,a0,16
    800032e8:	00001097          	auipc	ra,0x1
    800032ec:	45c080e7          	jalr	1116(ra) # 80004744 <holdingsleep>
    800032f0:	cd01                	beqz	a0,80003308 <bwrite+0x2e>
    800032f2:	4585                	li	a1,1
    800032f4:	8526                	mv	a0,s1
    800032f6:	00003097          	auipc	ra,0x3
    800032fa:	f06080e7          	jalr	-250(ra) # 800061fc <virtio_disk_rw>
    800032fe:	60e2                	ld	ra,24(sp)
    80003300:	6442                	ld	s0,16(sp)
    80003302:	64a2                	ld	s1,8(sp)
    80003304:	6105                	addi	sp,sp,32
    80003306:	8082                	ret
    80003308:	00005517          	auipc	a0,0x5
    8000330c:	2c050513          	addi	a0,a0,704 # 800085c8 <syscalls+0xd8>
    80003310:	ffffd097          	auipc	ra,0xffffd
    80003314:	230080e7          	jalr	560(ra) # 80000540 <panic>

0000000080003318 <brelse>:
    80003318:	1101                	addi	sp,sp,-32
    8000331a:	ec06                	sd	ra,24(sp)
    8000331c:	e822                	sd	s0,16(sp)
    8000331e:	e426                	sd	s1,8(sp)
    80003320:	e04a                	sd	s2,0(sp)
    80003322:	1000                	addi	s0,sp,32
    80003324:	84aa                	mv	s1,a0
    80003326:	01050913          	addi	s2,a0,16
    8000332a:	854a                	mv	a0,s2
    8000332c:	00001097          	auipc	ra,0x1
    80003330:	418080e7          	jalr	1048(ra) # 80004744 <holdingsleep>
    80003334:	c92d                	beqz	a0,800033a6 <brelse+0x8e>
    80003336:	854a                	mv	a0,s2
    80003338:	00001097          	auipc	ra,0x1
    8000333c:	3c8080e7          	jalr	968(ra) # 80004700 <releasesleep>
    80003340:	00015517          	auipc	a0,0x15
    80003344:	a8850513          	addi	a0,a0,-1400 # 80017dc8 <bcache>
    80003348:	ffffe097          	auipc	ra,0xffffe
    8000334c:	8b4080e7          	jalr	-1868(ra) # 80000bfc <acquire>
    80003350:	40bc                	lw	a5,64(s1)
    80003352:	37fd                	addiw	a5,a5,-1
    80003354:	0007871b          	sext.w	a4,a5
    80003358:	c0bc                	sw	a5,64(s1)
    8000335a:	eb05                	bnez	a4,8000338a <brelse+0x72>
    8000335c:	68bc                	ld	a5,80(s1)
    8000335e:	64b8                	ld	a4,72(s1)
    80003360:	e7b8                	sd	a4,72(a5)
    80003362:	64bc                	ld	a5,72(s1)
    80003364:	68b8                	ld	a4,80(s1)
    80003366:	ebb8                	sd	a4,80(a5)
    80003368:	0001d797          	auipc	a5,0x1d
    8000336c:	a6078793          	addi	a5,a5,-1440 # 8001fdc8 <bcache+0x8000>
    80003370:	2b87b703          	ld	a4,696(a5)
    80003374:	e8b8                	sd	a4,80(s1)
    80003376:	0001d717          	auipc	a4,0x1d
    8000337a:	cba70713          	addi	a4,a4,-838 # 80020030 <bcache+0x8268>
    8000337e:	e4b8                	sd	a4,72(s1)
    80003380:	2b87b703          	ld	a4,696(a5)
    80003384:	e724                	sd	s1,72(a4)
    80003386:	2a97bc23          	sd	s1,696(a5)
    8000338a:	00015517          	auipc	a0,0x15
    8000338e:	a3e50513          	addi	a0,a0,-1474 # 80017dc8 <bcache>
    80003392:	ffffe097          	auipc	ra,0xffffe
    80003396:	91e080e7          	jalr	-1762(ra) # 80000cb0 <release>
    8000339a:	60e2                	ld	ra,24(sp)
    8000339c:	6442                	ld	s0,16(sp)
    8000339e:	64a2                	ld	s1,8(sp)
    800033a0:	6902                	ld	s2,0(sp)
    800033a2:	6105                	addi	sp,sp,32
    800033a4:	8082                	ret
    800033a6:	00005517          	auipc	a0,0x5
    800033aa:	22a50513          	addi	a0,a0,554 # 800085d0 <syscalls+0xe0>
    800033ae:	ffffd097          	auipc	ra,0xffffd
    800033b2:	192080e7          	jalr	402(ra) # 80000540 <panic>

00000000800033b6 <bpin>:
    800033b6:	1101                	addi	sp,sp,-32
    800033b8:	ec06                	sd	ra,24(sp)
    800033ba:	e822                	sd	s0,16(sp)
    800033bc:	e426                	sd	s1,8(sp)
    800033be:	1000                	addi	s0,sp,32
    800033c0:	84aa                	mv	s1,a0
    800033c2:	00015517          	auipc	a0,0x15
    800033c6:	a0650513          	addi	a0,a0,-1530 # 80017dc8 <bcache>
    800033ca:	ffffe097          	auipc	ra,0xffffe
    800033ce:	832080e7          	jalr	-1998(ra) # 80000bfc <acquire>
    800033d2:	40bc                	lw	a5,64(s1)
    800033d4:	2785                	addiw	a5,a5,1
    800033d6:	c0bc                	sw	a5,64(s1)
    800033d8:	00015517          	auipc	a0,0x15
    800033dc:	9f050513          	addi	a0,a0,-1552 # 80017dc8 <bcache>
    800033e0:	ffffe097          	auipc	ra,0xffffe
    800033e4:	8d0080e7          	jalr	-1840(ra) # 80000cb0 <release>
    800033e8:	60e2                	ld	ra,24(sp)
    800033ea:	6442                	ld	s0,16(sp)
    800033ec:	64a2                	ld	s1,8(sp)
    800033ee:	6105                	addi	sp,sp,32
    800033f0:	8082                	ret

00000000800033f2 <bunpin>:
    800033f2:	1101                	addi	sp,sp,-32
    800033f4:	ec06                	sd	ra,24(sp)
    800033f6:	e822                	sd	s0,16(sp)
    800033f8:	e426                	sd	s1,8(sp)
    800033fa:	1000                	addi	s0,sp,32
    800033fc:	84aa                	mv	s1,a0
    800033fe:	00015517          	auipc	a0,0x15
    80003402:	9ca50513          	addi	a0,a0,-1590 # 80017dc8 <bcache>
    80003406:	ffffd097          	auipc	ra,0xffffd
    8000340a:	7f6080e7          	jalr	2038(ra) # 80000bfc <acquire>
    8000340e:	40bc                	lw	a5,64(s1)
    80003410:	37fd                	addiw	a5,a5,-1
    80003412:	c0bc                	sw	a5,64(s1)
    80003414:	00015517          	auipc	a0,0x15
    80003418:	9b450513          	addi	a0,a0,-1612 # 80017dc8 <bcache>
    8000341c:	ffffe097          	auipc	ra,0xffffe
    80003420:	894080e7          	jalr	-1900(ra) # 80000cb0 <release>
    80003424:	60e2                	ld	ra,24(sp)
    80003426:	6442                	ld	s0,16(sp)
    80003428:	64a2                	ld	s1,8(sp)
    8000342a:	6105                	addi	sp,sp,32
    8000342c:	8082                	ret

000000008000342e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000342e:	1101                	addi	sp,sp,-32
    80003430:	ec06                	sd	ra,24(sp)
    80003432:	e822                	sd	s0,16(sp)
    80003434:	e426                	sd	s1,8(sp)
    80003436:	e04a                	sd	s2,0(sp)
    80003438:	1000                	addi	s0,sp,32
    8000343a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000343c:	00d5d59b          	srliw	a1,a1,0xd
    80003440:	0001d797          	auipc	a5,0x1d
    80003444:	0647a783          	lw	a5,100(a5) # 800204a4 <sb+0x1c>
    80003448:	9dbd                	addw	a1,a1,a5
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	d9e080e7          	jalr	-610(ra) # 800031e8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003452:	0074f713          	andi	a4,s1,7
    80003456:	4785                	li	a5,1
    80003458:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000345c:	14ce                	slli	s1,s1,0x33
    8000345e:	90d9                	srli	s1,s1,0x36
    80003460:	00950733          	add	a4,a0,s1
    80003464:	05874703          	lbu	a4,88(a4)
    80003468:	00e7f6b3          	and	a3,a5,a4
    8000346c:	c69d                	beqz	a3,8000349a <bfree+0x6c>
    8000346e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003470:	94aa                	add	s1,s1,a0
    80003472:	fff7c793          	not	a5,a5
    80003476:	8ff9                	and	a5,a5,a4
    80003478:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000347c:	00001097          	auipc	ra,0x1
    80003480:	106080e7          	jalr	262(ra) # 80004582 <log_write>
  brelse(bp);
    80003484:	854a                	mv	a0,s2
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	e92080e7          	jalr	-366(ra) # 80003318 <brelse>
}
    8000348e:	60e2                	ld	ra,24(sp)
    80003490:	6442                	ld	s0,16(sp)
    80003492:	64a2                	ld	s1,8(sp)
    80003494:	6902                	ld	s2,0(sp)
    80003496:	6105                	addi	sp,sp,32
    80003498:	8082                	ret
    panic("freeing free block");
    8000349a:	00005517          	auipc	a0,0x5
    8000349e:	13e50513          	addi	a0,a0,318 # 800085d8 <syscalls+0xe8>
    800034a2:	ffffd097          	auipc	ra,0xffffd
    800034a6:	09e080e7          	jalr	158(ra) # 80000540 <panic>

00000000800034aa <balloc>:
{
    800034aa:	711d                	addi	sp,sp,-96
    800034ac:	ec86                	sd	ra,88(sp)
    800034ae:	e8a2                	sd	s0,80(sp)
    800034b0:	e4a6                	sd	s1,72(sp)
    800034b2:	e0ca                	sd	s2,64(sp)
    800034b4:	fc4e                	sd	s3,56(sp)
    800034b6:	f852                	sd	s4,48(sp)
    800034b8:	f456                	sd	s5,40(sp)
    800034ba:	f05a                	sd	s6,32(sp)
    800034bc:	ec5e                	sd	s7,24(sp)
    800034be:	e862                	sd	s8,16(sp)
    800034c0:	e466                	sd	s9,8(sp)
    800034c2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800034c4:	0001d797          	auipc	a5,0x1d
    800034c8:	fc87a783          	lw	a5,-56(a5) # 8002048c <sb+0x4>
    800034cc:	cbd1                	beqz	a5,80003560 <balloc+0xb6>
    800034ce:	8baa                	mv	s7,a0
    800034d0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800034d2:	0001db17          	auipc	s6,0x1d
    800034d6:	fb6b0b13          	addi	s6,s6,-74 # 80020488 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034da:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800034dc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034de:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800034e0:	6c89                	lui	s9,0x2
    800034e2:	a831                	j	800034fe <balloc+0x54>
    brelse(bp);
    800034e4:	854a                	mv	a0,s2
    800034e6:	00000097          	auipc	ra,0x0
    800034ea:	e32080e7          	jalr	-462(ra) # 80003318 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800034ee:	015c87bb          	addw	a5,s9,s5
    800034f2:	00078a9b          	sext.w	s5,a5
    800034f6:	004b2703          	lw	a4,4(s6)
    800034fa:	06eaf363          	bgeu	s5,a4,80003560 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800034fe:	41fad79b          	sraiw	a5,s5,0x1f
    80003502:	0137d79b          	srliw	a5,a5,0x13
    80003506:	015787bb          	addw	a5,a5,s5
    8000350a:	40d7d79b          	sraiw	a5,a5,0xd
    8000350e:	01cb2583          	lw	a1,28(s6)
    80003512:	9dbd                	addw	a1,a1,a5
    80003514:	855e                	mv	a0,s7
    80003516:	00000097          	auipc	ra,0x0
    8000351a:	cd2080e7          	jalr	-814(ra) # 800031e8 <bread>
    8000351e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003520:	004b2503          	lw	a0,4(s6)
    80003524:	000a849b          	sext.w	s1,s5
    80003528:	8662                	mv	a2,s8
    8000352a:	faa4fde3          	bgeu	s1,a0,800034e4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000352e:	41f6579b          	sraiw	a5,a2,0x1f
    80003532:	01d7d69b          	srliw	a3,a5,0x1d
    80003536:	00c6873b          	addw	a4,a3,a2
    8000353a:	00777793          	andi	a5,a4,7
    8000353e:	9f95                	subw	a5,a5,a3
    80003540:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003544:	4037571b          	sraiw	a4,a4,0x3
    80003548:	00e906b3          	add	a3,s2,a4
    8000354c:	0586c683          	lbu	a3,88(a3)
    80003550:	00d7f5b3          	and	a1,a5,a3
    80003554:	cd91                	beqz	a1,80003570 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003556:	2605                	addiw	a2,a2,1
    80003558:	2485                	addiw	s1,s1,1
    8000355a:	fd4618e3          	bne	a2,s4,8000352a <balloc+0x80>
    8000355e:	b759                	j	800034e4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003560:	00005517          	auipc	a0,0x5
    80003564:	09050513          	addi	a0,a0,144 # 800085f0 <syscalls+0x100>
    80003568:	ffffd097          	auipc	ra,0xffffd
    8000356c:	fd8080e7          	jalr	-40(ra) # 80000540 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003570:	974a                	add	a4,a4,s2
    80003572:	8fd5                	or	a5,a5,a3
    80003574:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003578:	854a                	mv	a0,s2
    8000357a:	00001097          	auipc	ra,0x1
    8000357e:	008080e7          	jalr	8(ra) # 80004582 <log_write>
        brelse(bp);
    80003582:	854a                	mv	a0,s2
    80003584:	00000097          	auipc	ra,0x0
    80003588:	d94080e7          	jalr	-620(ra) # 80003318 <brelse>
  bp = bread(dev, bno);
    8000358c:	85a6                	mv	a1,s1
    8000358e:	855e                	mv	a0,s7
    80003590:	00000097          	auipc	ra,0x0
    80003594:	c58080e7          	jalr	-936(ra) # 800031e8 <bread>
    80003598:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000359a:	40000613          	li	a2,1024
    8000359e:	4581                	li	a1,0
    800035a0:	05850513          	addi	a0,a0,88
    800035a4:	ffffd097          	auipc	ra,0xffffd
    800035a8:	754080e7          	jalr	1876(ra) # 80000cf8 <memset>
  log_write(bp);
    800035ac:	854a                	mv	a0,s2
    800035ae:	00001097          	auipc	ra,0x1
    800035b2:	fd4080e7          	jalr	-44(ra) # 80004582 <log_write>
  brelse(bp);
    800035b6:	854a                	mv	a0,s2
    800035b8:	00000097          	auipc	ra,0x0
    800035bc:	d60080e7          	jalr	-672(ra) # 80003318 <brelse>
}
    800035c0:	8526                	mv	a0,s1
    800035c2:	60e6                	ld	ra,88(sp)
    800035c4:	6446                	ld	s0,80(sp)
    800035c6:	64a6                	ld	s1,72(sp)
    800035c8:	6906                	ld	s2,64(sp)
    800035ca:	79e2                	ld	s3,56(sp)
    800035cc:	7a42                	ld	s4,48(sp)
    800035ce:	7aa2                	ld	s5,40(sp)
    800035d0:	7b02                	ld	s6,32(sp)
    800035d2:	6be2                	ld	s7,24(sp)
    800035d4:	6c42                	ld	s8,16(sp)
    800035d6:	6ca2                	ld	s9,8(sp)
    800035d8:	6125                	addi	sp,sp,96
    800035da:	8082                	ret

00000000800035dc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800035dc:	7179                	addi	sp,sp,-48
    800035de:	f406                	sd	ra,40(sp)
    800035e0:	f022                	sd	s0,32(sp)
    800035e2:	ec26                	sd	s1,24(sp)
    800035e4:	e84a                	sd	s2,16(sp)
    800035e6:	e44e                	sd	s3,8(sp)
    800035e8:	e052                	sd	s4,0(sp)
    800035ea:	1800                	addi	s0,sp,48
    800035ec:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800035ee:	47ad                	li	a5,11
    800035f0:	04b7fe63          	bgeu	a5,a1,8000364c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800035f4:	ff45849b          	addiw	s1,a1,-12
    800035f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800035fc:	0ff00793          	li	a5,255
    80003600:	0ae7e463          	bltu	a5,a4,800036a8 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003604:	08052583          	lw	a1,128(a0)
    80003608:	c5b5                	beqz	a1,80003674 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000360a:	00092503          	lw	a0,0(s2)
    8000360e:	00000097          	auipc	ra,0x0
    80003612:	bda080e7          	jalr	-1062(ra) # 800031e8 <bread>
    80003616:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003618:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000361c:	02049713          	slli	a4,s1,0x20
    80003620:	01e75593          	srli	a1,a4,0x1e
    80003624:	00b784b3          	add	s1,a5,a1
    80003628:	0004a983          	lw	s3,0(s1)
    8000362c:	04098e63          	beqz	s3,80003688 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003630:	8552                	mv	a0,s4
    80003632:	00000097          	auipc	ra,0x0
    80003636:	ce6080e7          	jalr	-794(ra) # 80003318 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000363a:	854e                	mv	a0,s3
    8000363c:	70a2                	ld	ra,40(sp)
    8000363e:	7402                	ld	s0,32(sp)
    80003640:	64e2                	ld	s1,24(sp)
    80003642:	6942                	ld	s2,16(sp)
    80003644:	69a2                	ld	s3,8(sp)
    80003646:	6a02                	ld	s4,0(sp)
    80003648:	6145                	addi	sp,sp,48
    8000364a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000364c:	02059793          	slli	a5,a1,0x20
    80003650:	01e7d593          	srli	a1,a5,0x1e
    80003654:	00b504b3          	add	s1,a0,a1
    80003658:	0504a983          	lw	s3,80(s1)
    8000365c:	fc099fe3          	bnez	s3,8000363a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003660:	4108                	lw	a0,0(a0)
    80003662:	00000097          	auipc	ra,0x0
    80003666:	e48080e7          	jalr	-440(ra) # 800034aa <balloc>
    8000366a:	0005099b          	sext.w	s3,a0
    8000366e:	0534a823          	sw	s3,80(s1)
    80003672:	b7e1                	j	8000363a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003674:	4108                	lw	a0,0(a0)
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	e34080e7          	jalr	-460(ra) # 800034aa <balloc>
    8000367e:	0005059b          	sext.w	a1,a0
    80003682:	08b92023          	sw	a1,128(s2)
    80003686:	b751                	j	8000360a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003688:	00092503          	lw	a0,0(s2)
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	e1e080e7          	jalr	-482(ra) # 800034aa <balloc>
    80003694:	0005099b          	sext.w	s3,a0
    80003698:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000369c:	8552                	mv	a0,s4
    8000369e:	00001097          	auipc	ra,0x1
    800036a2:	ee4080e7          	jalr	-284(ra) # 80004582 <log_write>
    800036a6:	b769                	j	80003630 <bmap+0x54>
  panic("bmap: out of range");
    800036a8:	00005517          	auipc	a0,0x5
    800036ac:	f6050513          	addi	a0,a0,-160 # 80008608 <syscalls+0x118>
    800036b0:	ffffd097          	auipc	ra,0xffffd
    800036b4:	e90080e7          	jalr	-368(ra) # 80000540 <panic>

00000000800036b8 <iget>:
{
    800036b8:	7179                	addi	sp,sp,-48
    800036ba:	f406                	sd	ra,40(sp)
    800036bc:	f022                	sd	s0,32(sp)
    800036be:	ec26                	sd	s1,24(sp)
    800036c0:	e84a                	sd	s2,16(sp)
    800036c2:	e44e                	sd	s3,8(sp)
    800036c4:	e052                	sd	s4,0(sp)
    800036c6:	1800                	addi	s0,sp,48
    800036c8:	89aa                	mv	s3,a0
    800036ca:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800036cc:	0001d517          	auipc	a0,0x1d
    800036d0:	ddc50513          	addi	a0,a0,-548 # 800204a8 <icache>
    800036d4:	ffffd097          	auipc	ra,0xffffd
    800036d8:	528080e7          	jalr	1320(ra) # 80000bfc <acquire>
  empty = 0;
    800036dc:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800036de:	0001d497          	auipc	s1,0x1d
    800036e2:	de248493          	addi	s1,s1,-542 # 800204c0 <icache+0x18>
    800036e6:	0001f697          	auipc	a3,0x1f
    800036ea:	86a68693          	addi	a3,a3,-1942 # 80021f50 <log>
    800036ee:	a039                	j	800036fc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800036f0:	02090b63          	beqz	s2,80003726 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800036f4:	08848493          	addi	s1,s1,136
    800036f8:	02d48a63          	beq	s1,a3,8000372c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800036fc:	449c                	lw	a5,8(s1)
    800036fe:	fef059e3          	blez	a5,800036f0 <iget+0x38>
    80003702:	4098                	lw	a4,0(s1)
    80003704:	ff3716e3          	bne	a4,s3,800036f0 <iget+0x38>
    80003708:	40d8                	lw	a4,4(s1)
    8000370a:	ff4713e3          	bne	a4,s4,800036f0 <iget+0x38>
      ip->ref++;
    8000370e:	2785                	addiw	a5,a5,1
    80003710:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003712:	0001d517          	auipc	a0,0x1d
    80003716:	d9650513          	addi	a0,a0,-618 # 800204a8 <icache>
    8000371a:	ffffd097          	auipc	ra,0xffffd
    8000371e:	596080e7          	jalr	1430(ra) # 80000cb0 <release>
      return ip;
    80003722:	8926                	mv	s2,s1
    80003724:	a03d                	j	80003752 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003726:	f7f9                	bnez	a5,800036f4 <iget+0x3c>
    80003728:	8926                	mv	s2,s1
    8000372a:	b7e9                	j	800036f4 <iget+0x3c>
  if(empty == 0)
    8000372c:	02090c63          	beqz	s2,80003764 <iget+0xac>
  ip->dev = dev;
    80003730:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003734:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003738:	4785                	li	a5,1
    8000373a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000373e:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003742:	0001d517          	auipc	a0,0x1d
    80003746:	d6650513          	addi	a0,a0,-666 # 800204a8 <icache>
    8000374a:	ffffd097          	auipc	ra,0xffffd
    8000374e:	566080e7          	jalr	1382(ra) # 80000cb0 <release>
}
    80003752:	854a                	mv	a0,s2
    80003754:	70a2                	ld	ra,40(sp)
    80003756:	7402                	ld	s0,32(sp)
    80003758:	64e2                	ld	s1,24(sp)
    8000375a:	6942                	ld	s2,16(sp)
    8000375c:	69a2                	ld	s3,8(sp)
    8000375e:	6a02                	ld	s4,0(sp)
    80003760:	6145                	addi	sp,sp,48
    80003762:	8082                	ret
    panic("iget: no inodes");
    80003764:	00005517          	auipc	a0,0x5
    80003768:	ebc50513          	addi	a0,a0,-324 # 80008620 <syscalls+0x130>
    8000376c:	ffffd097          	auipc	ra,0xffffd
    80003770:	dd4080e7          	jalr	-556(ra) # 80000540 <panic>

0000000080003774 <fsinit>:
fsinit(int dev) {
    80003774:	7179                	addi	sp,sp,-48
    80003776:	f406                	sd	ra,40(sp)
    80003778:	f022                	sd	s0,32(sp)
    8000377a:	ec26                	sd	s1,24(sp)
    8000377c:	e84a                	sd	s2,16(sp)
    8000377e:	e44e                	sd	s3,8(sp)
    80003780:	1800                	addi	s0,sp,48
    80003782:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003784:	4585                	li	a1,1
    80003786:	00000097          	auipc	ra,0x0
    8000378a:	a62080e7          	jalr	-1438(ra) # 800031e8 <bread>
    8000378e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003790:	0001d997          	auipc	s3,0x1d
    80003794:	cf898993          	addi	s3,s3,-776 # 80020488 <sb>
    80003798:	02000613          	li	a2,32
    8000379c:	05850593          	addi	a1,a0,88
    800037a0:	854e                	mv	a0,s3
    800037a2:	ffffd097          	auipc	ra,0xffffd
    800037a6:	5b2080e7          	jalr	1458(ra) # 80000d54 <memmove>
  brelse(bp);
    800037aa:	8526                	mv	a0,s1
    800037ac:	00000097          	auipc	ra,0x0
    800037b0:	b6c080e7          	jalr	-1172(ra) # 80003318 <brelse>
  if(sb.magic != FSMAGIC)
    800037b4:	0009a703          	lw	a4,0(s3)
    800037b8:	102037b7          	lui	a5,0x10203
    800037bc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800037c0:	02f71263          	bne	a4,a5,800037e4 <fsinit+0x70>
  initlog(dev, &sb);
    800037c4:	0001d597          	auipc	a1,0x1d
    800037c8:	cc458593          	addi	a1,a1,-828 # 80020488 <sb>
    800037cc:	854a                	mv	a0,s2
    800037ce:	00001097          	auipc	ra,0x1
    800037d2:	b3a080e7          	jalr	-1222(ra) # 80004308 <initlog>
}
    800037d6:	70a2                	ld	ra,40(sp)
    800037d8:	7402                	ld	s0,32(sp)
    800037da:	64e2                	ld	s1,24(sp)
    800037dc:	6942                	ld	s2,16(sp)
    800037de:	69a2                	ld	s3,8(sp)
    800037e0:	6145                	addi	sp,sp,48
    800037e2:	8082                	ret
    panic("invalid file system");
    800037e4:	00005517          	auipc	a0,0x5
    800037e8:	e4c50513          	addi	a0,a0,-436 # 80008630 <syscalls+0x140>
    800037ec:	ffffd097          	auipc	ra,0xffffd
    800037f0:	d54080e7          	jalr	-684(ra) # 80000540 <panic>

00000000800037f4 <iinit>:
{
    800037f4:	7179                	addi	sp,sp,-48
    800037f6:	f406                	sd	ra,40(sp)
    800037f8:	f022                	sd	s0,32(sp)
    800037fa:	ec26                	sd	s1,24(sp)
    800037fc:	e84a                	sd	s2,16(sp)
    800037fe:	e44e                	sd	s3,8(sp)
    80003800:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003802:	00005597          	auipc	a1,0x5
    80003806:	e4658593          	addi	a1,a1,-442 # 80008648 <syscalls+0x158>
    8000380a:	0001d517          	auipc	a0,0x1d
    8000380e:	c9e50513          	addi	a0,a0,-866 # 800204a8 <icache>
    80003812:	ffffd097          	auipc	ra,0xffffd
    80003816:	35a080e7          	jalr	858(ra) # 80000b6c <initlock>
  for(i = 0; i < NINODE; i++) {
    8000381a:	0001d497          	auipc	s1,0x1d
    8000381e:	cb648493          	addi	s1,s1,-842 # 800204d0 <icache+0x28>
    80003822:	0001e997          	auipc	s3,0x1e
    80003826:	73e98993          	addi	s3,s3,1854 # 80021f60 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    8000382a:	00005917          	auipc	s2,0x5
    8000382e:	e2690913          	addi	s2,s2,-474 # 80008650 <syscalls+0x160>
    80003832:	85ca                	mv	a1,s2
    80003834:	8526                	mv	a0,s1
    80003836:	00001097          	auipc	ra,0x1
    8000383a:	e3a080e7          	jalr	-454(ra) # 80004670 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000383e:	08848493          	addi	s1,s1,136
    80003842:	ff3498e3          	bne	s1,s3,80003832 <iinit+0x3e>
}
    80003846:	70a2                	ld	ra,40(sp)
    80003848:	7402                	ld	s0,32(sp)
    8000384a:	64e2                	ld	s1,24(sp)
    8000384c:	6942                	ld	s2,16(sp)
    8000384e:	69a2                	ld	s3,8(sp)
    80003850:	6145                	addi	sp,sp,48
    80003852:	8082                	ret

0000000080003854 <ialloc>:
{
    80003854:	715d                	addi	sp,sp,-80
    80003856:	e486                	sd	ra,72(sp)
    80003858:	e0a2                	sd	s0,64(sp)
    8000385a:	fc26                	sd	s1,56(sp)
    8000385c:	f84a                	sd	s2,48(sp)
    8000385e:	f44e                	sd	s3,40(sp)
    80003860:	f052                	sd	s4,32(sp)
    80003862:	ec56                	sd	s5,24(sp)
    80003864:	e85a                	sd	s6,16(sp)
    80003866:	e45e                	sd	s7,8(sp)
    80003868:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000386a:	0001d717          	auipc	a4,0x1d
    8000386e:	c2a72703          	lw	a4,-982(a4) # 80020494 <sb+0xc>
    80003872:	4785                	li	a5,1
    80003874:	04e7fa63          	bgeu	a5,a4,800038c8 <ialloc+0x74>
    80003878:	8aaa                	mv	s5,a0
    8000387a:	8bae                	mv	s7,a1
    8000387c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000387e:	0001da17          	auipc	s4,0x1d
    80003882:	c0aa0a13          	addi	s4,s4,-1014 # 80020488 <sb>
    80003886:	00048b1b          	sext.w	s6,s1
    8000388a:	0044d793          	srli	a5,s1,0x4
    8000388e:	018a2583          	lw	a1,24(s4)
    80003892:	9dbd                	addw	a1,a1,a5
    80003894:	8556                	mv	a0,s5
    80003896:	00000097          	auipc	ra,0x0
    8000389a:	952080e7          	jalr	-1710(ra) # 800031e8 <bread>
    8000389e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800038a0:	05850993          	addi	s3,a0,88
    800038a4:	00f4f793          	andi	a5,s1,15
    800038a8:	079a                	slli	a5,a5,0x6
    800038aa:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800038ac:	00099783          	lh	a5,0(s3)
    800038b0:	c785                	beqz	a5,800038d8 <ialloc+0x84>
    brelse(bp);
    800038b2:	00000097          	auipc	ra,0x0
    800038b6:	a66080e7          	jalr	-1434(ra) # 80003318 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800038ba:	0485                	addi	s1,s1,1
    800038bc:	00ca2703          	lw	a4,12(s4)
    800038c0:	0004879b          	sext.w	a5,s1
    800038c4:	fce7e1e3          	bltu	a5,a4,80003886 <ialloc+0x32>
  panic("ialloc: no inodes");
    800038c8:	00005517          	auipc	a0,0x5
    800038cc:	d9050513          	addi	a0,a0,-624 # 80008658 <syscalls+0x168>
    800038d0:	ffffd097          	auipc	ra,0xffffd
    800038d4:	c70080e7          	jalr	-912(ra) # 80000540 <panic>
      memset(dip, 0, sizeof(*dip));
    800038d8:	04000613          	li	a2,64
    800038dc:	4581                	li	a1,0
    800038de:	854e                	mv	a0,s3
    800038e0:	ffffd097          	auipc	ra,0xffffd
    800038e4:	418080e7          	jalr	1048(ra) # 80000cf8 <memset>
      dip->type = type;
    800038e8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800038ec:	854a                	mv	a0,s2
    800038ee:	00001097          	auipc	ra,0x1
    800038f2:	c94080e7          	jalr	-876(ra) # 80004582 <log_write>
      brelse(bp);
    800038f6:	854a                	mv	a0,s2
    800038f8:	00000097          	auipc	ra,0x0
    800038fc:	a20080e7          	jalr	-1504(ra) # 80003318 <brelse>
      return iget(dev, inum);
    80003900:	85da                	mv	a1,s6
    80003902:	8556                	mv	a0,s5
    80003904:	00000097          	auipc	ra,0x0
    80003908:	db4080e7          	jalr	-588(ra) # 800036b8 <iget>
}
    8000390c:	60a6                	ld	ra,72(sp)
    8000390e:	6406                	ld	s0,64(sp)
    80003910:	74e2                	ld	s1,56(sp)
    80003912:	7942                	ld	s2,48(sp)
    80003914:	79a2                	ld	s3,40(sp)
    80003916:	7a02                	ld	s4,32(sp)
    80003918:	6ae2                	ld	s5,24(sp)
    8000391a:	6b42                	ld	s6,16(sp)
    8000391c:	6ba2                	ld	s7,8(sp)
    8000391e:	6161                	addi	sp,sp,80
    80003920:	8082                	ret

0000000080003922 <iupdate>:
{
    80003922:	1101                	addi	sp,sp,-32
    80003924:	ec06                	sd	ra,24(sp)
    80003926:	e822                	sd	s0,16(sp)
    80003928:	e426                	sd	s1,8(sp)
    8000392a:	e04a                	sd	s2,0(sp)
    8000392c:	1000                	addi	s0,sp,32
    8000392e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003930:	415c                	lw	a5,4(a0)
    80003932:	0047d79b          	srliw	a5,a5,0x4
    80003936:	0001d597          	auipc	a1,0x1d
    8000393a:	b6a5a583          	lw	a1,-1174(a1) # 800204a0 <sb+0x18>
    8000393e:	9dbd                	addw	a1,a1,a5
    80003940:	4108                	lw	a0,0(a0)
    80003942:	00000097          	auipc	ra,0x0
    80003946:	8a6080e7          	jalr	-1882(ra) # 800031e8 <bread>
    8000394a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000394c:	05850793          	addi	a5,a0,88
    80003950:	40c8                	lw	a0,4(s1)
    80003952:	893d                	andi	a0,a0,15
    80003954:	051a                	slli	a0,a0,0x6
    80003956:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003958:	04449703          	lh	a4,68(s1)
    8000395c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003960:	04649703          	lh	a4,70(s1)
    80003964:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003968:	04849703          	lh	a4,72(s1)
    8000396c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003970:	04a49703          	lh	a4,74(s1)
    80003974:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003978:	44f8                	lw	a4,76(s1)
    8000397a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000397c:	03400613          	li	a2,52
    80003980:	05048593          	addi	a1,s1,80
    80003984:	0531                	addi	a0,a0,12
    80003986:	ffffd097          	auipc	ra,0xffffd
    8000398a:	3ce080e7          	jalr	974(ra) # 80000d54 <memmove>
  log_write(bp);
    8000398e:	854a                	mv	a0,s2
    80003990:	00001097          	auipc	ra,0x1
    80003994:	bf2080e7          	jalr	-1038(ra) # 80004582 <log_write>
  brelse(bp);
    80003998:	854a                	mv	a0,s2
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	97e080e7          	jalr	-1666(ra) # 80003318 <brelse>
}
    800039a2:	60e2                	ld	ra,24(sp)
    800039a4:	6442                	ld	s0,16(sp)
    800039a6:	64a2                	ld	s1,8(sp)
    800039a8:	6902                	ld	s2,0(sp)
    800039aa:	6105                	addi	sp,sp,32
    800039ac:	8082                	ret

00000000800039ae <idup>:
{
    800039ae:	1101                	addi	sp,sp,-32
    800039b0:	ec06                	sd	ra,24(sp)
    800039b2:	e822                	sd	s0,16(sp)
    800039b4:	e426                	sd	s1,8(sp)
    800039b6:	1000                	addi	s0,sp,32
    800039b8:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800039ba:	0001d517          	auipc	a0,0x1d
    800039be:	aee50513          	addi	a0,a0,-1298 # 800204a8 <icache>
    800039c2:	ffffd097          	auipc	ra,0xffffd
    800039c6:	23a080e7          	jalr	570(ra) # 80000bfc <acquire>
  ip->ref++;
    800039ca:	449c                	lw	a5,8(s1)
    800039cc:	2785                	addiw	a5,a5,1
    800039ce:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800039d0:	0001d517          	auipc	a0,0x1d
    800039d4:	ad850513          	addi	a0,a0,-1320 # 800204a8 <icache>
    800039d8:	ffffd097          	auipc	ra,0xffffd
    800039dc:	2d8080e7          	jalr	728(ra) # 80000cb0 <release>
}
    800039e0:	8526                	mv	a0,s1
    800039e2:	60e2                	ld	ra,24(sp)
    800039e4:	6442                	ld	s0,16(sp)
    800039e6:	64a2                	ld	s1,8(sp)
    800039e8:	6105                	addi	sp,sp,32
    800039ea:	8082                	ret

00000000800039ec <ilock>:
{
    800039ec:	1101                	addi	sp,sp,-32
    800039ee:	ec06                	sd	ra,24(sp)
    800039f0:	e822                	sd	s0,16(sp)
    800039f2:	e426                	sd	s1,8(sp)
    800039f4:	e04a                	sd	s2,0(sp)
    800039f6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800039f8:	c115                	beqz	a0,80003a1c <ilock+0x30>
    800039fa:	84aa                	mv	s1,a0
    800039fc:	451c                	lw	a5,8(a0)
    800039fe:	00f05f63          	blez	a5,80003a1c <ilock+0x30>
  acquiresleep(&ip->lock);
    80003a02:	0541                	addi	a0,a0,16
    80003a04:	00001097          	auipc	ra,0x1
    80003a08:	ca6080e7          	jalr	-858(ra) # 800046aa <acquiresleep>
  if(ip->valid == 0){
    80003a0c:	40bc                	lw	a5,64(s1)
    80003a0e:	cf99                	beqz	a5,80003a2c <ilock+0x40>
}
    80003a10:	60e2                	ld	ra,24(sp)
    80003a12:	6442                	ld	s0,16(sp)
    80003a14:	64a2                	ld	s1,8(sp)
    80003a16:	6902                	ld	s2,0(sp)
    80003a18:	6105                	addi	sp,sp,32
    80003a1a:	8082                	ret
    panic("ilock");
    80003a1c:	00005517          	auipc	a0,0x5
    80003a20:	c5450513          	addi	a0,a0,-940 # 80008670 <syscalls+0x180>
    80003a24:	ffffd097          	auipc	ra,0xffffd
    80003a28:	b1c080e7          	jalr	-1252(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a2c:	40dc                	lw	a5,4(s1)
    80003a2e:	0047d79b          	srliw	a5,a5,0x4
    80003a32:	0001d597          	auipc	a1,0x1d
    80003a36:	a6e5a583          	lw	a1,-1426(a1) # 800204a0 <sb+0x18>
    80003a3a:	9dbd                	addw	a1,a1,a5
    80003a3c:	4088                	lw	a0,0(s1)
    80003a3e:	fffff097          	auipc	ra,0xfffff
    80003a42:	7aa080e7          	jalr	1962(ra) # 800031e8 <bread>
    80003a46:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a48:	05850593          	addi	a1,a0,88
    80003a4c:	40dc                	lw	a5,4(s1)
    80003a4e:	8bbd                	andi	a5,a5,15
    80003a50:	079a                	slli	a5,a5,0x6
    80003a52:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003a54:	00059783          	lh	a5,0(a1)
    80003a58:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003a5c:	00259783          	lh	a5,2(a1)
    80003a60:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003a64:	00459783          	lh	a5,4(a1)
    80003a68:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003a6c:	00659783          	lh	a5,6(a1)
    80003a70:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003a74:	459c                	lw	a5,8(a1)
    80003a76:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003a78:	03400613          	li	a2,52
    80003a7c:	05b1                	addi	a1,a1,12
    80003a7e:	05048513          	addi	a0,s1,80
    80003a82:	ffffd097          	auipc	ra,0xffffd
    80003a86:	2d2080e7          	jalr	722(ra) # 80000d54 <memmove>
    brelse(bp);
    80003a8a:	854a                	mv	a0,s2
    80003a8c:	00000097          	auipc	ra,0x0
    80003a90:	88c080e7          	jalr	-1908(ra) # 80003318 <brelse>
    ip->valid = 1;
    80003a94:	4785                	li	a5,1
    80003a96:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003a98:	04449783          	lh	a5,68(s1)
    80003a9c:	fbb5                	bnez	a5,80003a10 <ilock+0x24>
      panic("ilock: no type");
    80003a9e:	00005517          	auipc	a0,0x5
    80003aa2:	bda50513          	addi	a0,a0,-1062 # 80008678 <syscalls+0x188>
    80003aa6:	ffffd097          	auipc	ra,0xffffd
    80003aaa:	a9a080e7          	jalr	-1382(ra) # 80000540 <panic>

0000000080003aae <iunlock>:
{
    80003aae:	1101                	addi	sp,sp,-32
    80003ab0:	ec06                	sd	ra,24(sp)
    80003ab2:	e822                	sd	s0,16(sp)
    80003ab4:	e426                	sd	s1,8(sp)
    80003ab6:	e04a                	sd	s2,0(sp)
    80003ab8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003aba:	c905                	beqz	a0,80003aea <iunlock+0x3c>
    80003abc:	84aa                	mv	s1,a0
    80003abe:	01050913          	addi	s2,a0,16
    80003ac2:	854a                	mv	a0,s2
    80003ac4:	00001097          	auipc	ra,0x1
    80003ac8:	c80080e7          	jalr	-896(ra) # 80004744 <holdingsleep>
    80003acc:	cd19                	beqz	a0,80003aea <iunlock+0x3c>
    80003ace:	449c                	lw	a5,8(s1)
    80003ad0:	00f05d63          	blez	a5,80003aea <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003ad4:	854a                	mv	a0,s2
    80003ad6:	00001097          	auipc	ra,0x1
    80003ada:	c2a080e7          	jalr	-982(ra) # 80004700 <releasesleep>
}
    80003ade:	60e2                	ld	ra,24(sp)
    80003ae0:	6442                	ld	s0,16(sp)
    80003ae2:	64a2                	ld	s1,8(sp)
    80003ae4:	6902                	ld	s2,0(sp)
    80003ae6:	6105                	addi	sp,sp,32
    80003ae8:	8082                	ret
    panic("iunlock");
    80003aea:	00005517          	auipc	a0,0x5
    80003aee:	b9e50513          	addi	a0,a0,-1122 # 80008688 <syscalls+0x198>
    80003af2:	ffffd097          	auipc	ra,0xffffd
    80003af6:	a4e080e7          	jalr	-1458(ra) # 80000540 <panic>

0000000080003afa <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003afa:	7179                	addi	sp,sp,-48
    80003afc:	f406                	sd	ra,40(sp)
    80003afe:	f022                	sd	s0,32(sp)
    80003b00:	ec26                	sd	s1,24(sp)
    80003b02:	e84a                	sd	s2,16(sp)
    80003b04:	e44e                	sd	s3,8(sp)
    80003b06:	e052                	sd	s4,0(sp)
    80003b08:	1800                	addi	s0,sp,48
    80003b0a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003b0c:	05050493          	addi	s1,a0,80
    80003b10:	08050913          	addi	s2,a0,128
    80003b14:	a021                	j	80003b1c <itrunc+0x22>
    80003b16:	0491                	addi	s1,s1,4
    80003b18:	01248d63          	beq	s1,s2,80003b32 <itrunc+0x38>
    if(ip->addrs[i]){
    80003b1c:	408c                	lw	a1,0(s1)
    80003b1e:	dde5                	beqz	a1,80003b16 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003b20:	0009a503          	lw	a0,0(s3)
    80003b24:	00000097          	auipc	ra,0x0
    80003b28:	90a080e7          	jalr	-1782(ra) # 8000342e <bfree>
      ip->addrs[i] = 0;
    80003b2c:	0004a023          	sw	zero,0(s1)
    80003b30:	b7dd                	j	80003b16 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003b32:	0809a583          	lw	a1,128(s3)
    80003b36:	e185                	bnez	a1,80003b56 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003b38:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003b3c:	854e                	mv	a0,s3
    80003b3e:	00000097          	auipc	ra,0x0
    80003b42:	de4080e7          	jalr	-540(ra) # 80003922 <iupdate>
}
    80003b46:	70a2                	ld	ra,40(sp)
    80003b48:	7402                	ld	s0,32(sp)
    80003b4a:	64e2                	ld	s1,24(sp)
    80003b4c:	6942                	ld	s2,16(sp)
    80003b4e:	69a2                	ld	s3,8(sp)
    80003b50:	6a02                	ld	s4,0(sp)
    80003b52:	6145                	addi	sp,sp,48
    80003b54:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003b56:	0009a503          	lw	a0,0(s3)
    80003b5a:	fffff097          	auipc	ra,0xfffff
    80003b5e:	68e080e7          	jalr	1678(ra) # 800031e8 <bread>
    80003b62:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003b64:	05850493          	addi	s1,a0,88
    80003b68:	45850913          	addi	s2,a0,1112
    80003b6c:	a021                	j	80003b74 <itrunc+0x7a>
    80003b6e:	0491                	addi	s1,s1,4
    80003b70:	01248b63          	beq	s1,s2,80003b86 <itrunc+0x8c>
      if(a[j])
    80003b74:	408c                	lw	a1,0(s1)
    80003b76:	dde5                	beqz	a1,80003b6e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003b78:	0009a503          	lw	a0,0(s3)
    80003b7c:	00000097          	auipc	ra,0x0
    80003b80:	8b2080e7          	jalr	-1870(ra) # 8000342e <bfree>
    80003b84:	b7ed                	j	80003b6e <itrunc+0x74>
    brelse(bp);
    80003b86:	8552                	mv	a0,s4
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	790080e7          	jalr	1936(ra) # 80003318 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003b90:	0809a583          	lw	a1,128(s3)
    80003b94:	0009a503          	lw	a0,0(s3)
    80003b98:	00000097          	auipc	ra,0x0
    80003b9c:	896080e7          	jalr	-1898(ra) # 8000342e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003ba0:	0809a023          	sw	zero,128(s3)
    80003ba4:	bf51                	j	80003b38 <itrunc+0x3e>

0000000080003ba6 <iput>:
{
    80003ba6:	1101                	addi	sp,sp,-32
    80003ba8:	ec06                	sd	ra,24(sp)
    80003baa:	e822                	sd	s0,16(sp)
    80003bac:	e426                	sd	s1,8(sp)
    80003bae:	e04a                	sd	s2,0(sp)
    80003bb0:	1000                	addi	s0,sp,32
    80003bb2:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003bb4:	0001d517          	auipc	a0,0x1d
    80003bb8:	8f450513          	addi	a0,a0,-1804 # 800204a8 <icache>
    80003bbc:	ffffd097          	auipc	ra,0xffffd
    80003bc0:	040080e7          	jalr	64(ra) # 80000bfc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003bc4:	4498                	lw	a4,8(s1)
    80003bc6:	4785                	li	a5,1
    80003bc8:	02f70363          	beq	a4,a5,80003bee <iput+0x48>
  ip->ref--;
    80003bcc:	449c                	lw	a5,8(s1)
    80003bce:	37fd                	addiw	a5,a5,-1
    80003bd0:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003bd2:	0001d517          	auipc	a0,0x1d
    80003bd6:	8d650513          	addi	a0,a0,-1834 # 800204a8 <icache>
    80003bda:	ffffd097          	auipc	ra,0xffffd
    80003bde:	0d6080e7          	jalr	214(ra) # 80000cb0 <release>
}
    80003be2:	60e2                	ld	ra,24(sp)
    80003be4:	6442                	ld	s0,16(sp)
    80003be6:	64a2                	ld	s1,8(sp)
    80003be8:	6902                	ld	s2,0(sp)
    80003bea:	6105                	addi	sp,sp,32
    80003bec:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003bee:	40bc                	lw	a5,64(s1)
    80003bf0:	dff1                	beqz	a5,80003bcc <iput+0x26>
    80003bf2:	04a49783          	lh	a5,74(s1)
    80003bf6:	fbf9                	bnez	a5,80003bcc <iput+0x26>
    acquiresleep(&ip->lock);
    80003bf8:	01048913          	addi	s2,s1,16
    80003bfc:	854a                	mv	a0,s2
    80003bfe:	00001097          	auipc	ra,0x1
    80003c02:	aac080e7          	jalr	-1364(ra) # 800046aa <acquiresleep>
    release(&icache.lock);
    80003c06:	0001d517          	auipc	a0,0x1d
    80003c0a:	8a250513          	addi	a0,a0,-1886 # 800204a8 <icache>
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	0a2080e7          	jalr	162(ra) # 80000cb0 <release>
    itrunc(ip);
    80003c16:	8526                	mv	a0,s1
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	ee2080e7          	jalr	-286(ra) # 80003afa <itrunc>
    ip->type = 0;
    80003c20:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003c24:	8526                	mv	a0,s1
    80003c26:	00000097          	auipc	ra,0x0
    80003c2a:	cfc080e7          	jalr	-772(ra) # 80003922 <iupdate>
    ip->valid = 0;
    80003c2e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003c32:	854a                	mv	a0,s2
    80003c34:	00001097          	auipc	ra,0x1
    80003c38:	acc080e7          	jalr	-1332(ra) # 80004700 <releasesleep>
    acquire(&icache.lock);
    80003c3c:	0001d517          	auipc	a0,0x1d
    80003c40:	86c50513          	addi	a0,a0,-1940 # 800204a8 <icache>
    80003c44:	ffffd097          	auipc	ra,0xffffd
    80003c48:	fb8080e7          	jalr	-72(ra) # 80000bfc <acquire>
    80003c4c:	b741                	j	80003bcc <iput+0x26>

0000000080003c4e <iunlockput>:
{
    80003c4e:	1101                	addi	sp,sp,-32
    80003c50:	ec06                	sd	ra,24(sp)
    80003c52:	e822                	sd	s0,16(sp)
    80003c54:	e426                	sd	s1,8(sp)
    80003c56:	1000                	addi	s0,sp,32
    80003c58:	84aa                	mv	s1,a0
  iunlock(ip);
    80003c5a:	00000097          	auipc	ra,0x0
    80003c5e:	e54080e7          	jalr	-428(ra) # 80003aae <iunlock>
  iput(ip);
    80003c62:	8526                	mv	a0,s1
    80003c64:	00000097          	auipc	ra,0x0
    80003c68:	f42080e7          	jalr	-190(ra) # 80003ba6 <iput>
}
    80003c6c:	60e2                	ld	ra,24(sp)
    80003c6e:	6442                	ld	s0,16(sp)
    80003c70:	64a2                	ld	s1,8(sp)
    80003c72:	6105                	addi	sp,sp,32
    80003c74:	8082                	ret

0000000080003c76 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003c76:	1141                	addi	sp,sp,-16
    80003c78:	e422                	sd	s0,8(sp)
    80003c7a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003c7c:	411c                	lw	a5,0(a0)
    80003c7e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003c80:	415c                	lw	a5,4(a0)
    80003c82:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003c84:	04451783          	lh	a5,68(a0)
    80003c88:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003c8c:	04a51783          	lh	a5,74(a0)
    80003c90:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003c94:	04c56783          	lwu	a5,76(a0)
    80003c98:	e99c                	sd	a5,16(a1)
}
    80003c9a:	6422                	ld	s0,8(sp)
    80003c9c:	0141                	addi	sp,sp,16
    80003c9e:	8082                	ret

0000000080003ca0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ca0:	457c                	lw	a5,76(a0)
    80003ca2:	0ed7e863          	bltu	a5,a3,80003d92 <readi+0xf2>
{
    80003ca6:	7159                	addi	sp,sp,-112
    80003ca8:	f486                	sd	ra,104(sp)
    80003caa:	f0a2                	sd	s0,96(sp)
    80003cac:	eca6                	sd	s1,88(sp)
    80003cae:	e8ca                	sd	s2,80(sp)
    80003cb0:	e4ce                	sd	s3,72(sp)
    80003cb2:	e0d2                	sd	s4,64(sp)
    80003cb4:	fc56                	sd	s5,56(sp)
    80003cb6:	f85a                	sd	s6,48(sp)
    80003cb8:	f45e                	sd	s7,40(sp)
    80003cba:	f062                	sd	s8,32(sp)
    80003cbc:	ec66                	sd	s9,24(sp)
    80003cbe:	e86a                	sd	s10,16(sp)
    80003cc0:	e46e                	sd	s11,8(sp)
    80003cc2:	1880                	addi	s0,sp,112
    80003cc4:	8baa                	mv	s7,a0
    80003cc6:	8c2e                	mv	s8,a1
    80003cc8:	8ab2                	mv	s5,a2
    80003cca:	84b6                	mv	s1,a3
    80003ccc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003cce:	9f35                	addw	a4,a4,a3
    return 0;
    80003cd0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003cd2:	08d76f63          	bltu	a4,a3,80003d70 <readi+0xd0>
  if(off + n > ip->size)
    80003cd6:	00e7f463          	bgeu	a5,a4,80003cde <readi+0x3e>
    n = ip->size - off;
    80003cda:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003cde:	0a0b0863          	beqz	s6,80003d8e <readi+0xee>
    80003ce2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ce4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ce8:	5cfd                	li	s9,-1
    80003cea:	a82d                	j	80003d24 <readi+0x84>
    80003cec:	020a1d93          	slli	s11,s4,0x20
    80003cf0:	020ddd93          	srli	s11,s11,0x20
    80003cf4:	05890793          	addi	a5,s2,88
    80003cf8:	86ee                	mv	a3,s11
    80003cfa:	963e                	add	a2,a2,a5
    80003cfc:	85d6                	mv	a1,s5
    80003cfe:	8562                	mv	a0,s8
    80003d00:	fffff097          	auipc	ra,0xfffff
    80003d04:	ae6080e7          	jalr	-1306(ra) # 800027e6 <either_copyout>
    80003d08:	05950d63          	beq	a0,s9,80003d62 <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003d0c:	854a                	mv	a0,s2
    80003d0e:	fffff097          	auipc	ra,0xfffff
    80003d12:	60a080e7          	jalr	1546(ra) # 80003318 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d16:	013a09bb          	addw	s3,s4,s3
    80003d1a:	009a04bb          	addw	s1,s4,s1
    80003d1e:	9aee                	add	s5,s5,s11
    80003d20:	0569f663          	bgeu	s3,s6,80003d6c <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003d24:	000ba903          	lw	s2,0(s7)
    80003d28:	00a4d59b          	srliw	a1,s1,0xa
    80003d2c:	855e                	mv	a0,s7
    80003d2e:	00000097          	auipc	ra,0x0
    80003d32:	8ae080e7          	jalr	-1874(ra) # 800035dc <bmap>
    80003d36:	0005059b          	sext.w	a1,a0
    80003d3a:	854a                	mv	a0,s2
    80003d3c:	fffff097          	auipc	ra,0xfffff
    80003d40:	4ac080e7          	jalr	1196(ra) # 800031e8 <bread>
    80003d44:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d46:	3ff4f613          	andi	a2,s1,1023
    80003d4a:	40cd07bb          	subw	a5,s10,a2
    80003d4e:	413b073b          	subw	a4,s6,s3
    80003d52:	8a3e                	mv	s4,a5
    80003d54:	2781                	sext.w	a5,a5
    80003d56:	0007069b          	sext.w	a3,a4
    80003d5a:	f8f6f9e3          	bgeu	a3,a5,80003cec <readi+0x4c>
    80003d5e:	8a3a                	mv	s4,a4
    80003d60:	b771                	j	80003cec <readi+0x4c>
      brelse(bp);
    80003d62:	854a                	mv	a0,s2
    80003d64:	fffff097          	auipc	ra,0xfffff
    80003d68:	5b4080e7          	jalr	1460(ra) # 80003318 <brelse>
  }
  return tot;
    80003d6c:	0009851b          	sext.w	a0,s3
}
    80003d70:	70a6                	ld	ra,104(sp)
    80003d72:	7406                	ld	s0,96(sp)
    80003d74:	64e6                	ld	s1,88(sp)
    80003d76:	6946                	ld	s2,80(sp)
    80003d78:	69a6                	ld	s3,72(sp)
    80003d7a:	6a06                	ld	s4,64(sp)
    80003d7c:	7ae2                	ld	s5,56(sp)
    80003d7e:	7b42                	ld	s6,48(sp)
    80003d80:	7ba2                	ld	s7,40(sp)
    80003d82:	7c02                	ld	s8,32(sp)
    80003d84:	6ce2                	ld	s9,24(sp)
    80003d86:	6d42                	ld	s10,16(sp)
    80003d88:	6da2                	ld	s11,8(sp)
    80003d8a:	6165                	addi	sp,sp,112
    80003d8c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d8e:	89da                	mv	s3,s6
    80003d90:	bff1                	j	80003d6c <readi+0xcc>
    return 0;
    80003d92:	4501                	li	a0,0
}
    80003d94:	8082                	ret

0000000080003d96 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d96:	457c                	lw	a5,76(a0)
    80003d98:	10d7e663          	bltu	a5,a3,80003ea4 <writei+0x10e>
{
    80003d9c:	7159                	addi	sp,sp,-112
    80003d9e:	f486                	sd	ra,104(sp)
    80003da0:	f0a2                	sd	s0,96(sp)
    80003da2:	eca6                	sd	s1,88(sp)
    80003da4:	e8ca                	sd	s2,80(sp)
    80003da6:	e4ce                	sd	s3,72(sp)
    80003da8:	e0d2                	sd	s4,64(sp)
    80003daa:	fc56                	sd	s5,56(sp)
    80003dac:	f85a                	sd	s6,48(sp)
    80003dae:	f45e                	sd	s7,40(sp)
    80003db0:	f062                	sd	s8,32(sp)
    80003db2:	ec66                	sd	s9,24(sp)
    80003db4:	e86a                	sd	s10,16(sp)
    80003db6:	e46e                	sd	s11,8(sp)
    80003db8:	1880                	addi	s0,sp,112
    80003dba:	8baa                	mv	s7,a0
    80003dbc:	8c2e                	mv	s8,a1
    80003dbe:	8ab2                	mv	s5,a2
    80003dc0:	8936                	mv	s2,a3
    80003dc2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003dc4:	00e687bb          	addw	a5,a3,a4
    80003dc8:	0ed7e063          	bltu	a5,a3,80003ea8 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003dcc:	00043737          	lui	a4,0x43
    80003dd0:	0cf76e63          	bltu	a4,a5,80003eac <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003dd4:	0a0b0763          	beqz	s6,80003e82 <writei+0xec>
    80003dd8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003dda:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003dde:	5cfd                	li	s9,-1
    80003de0:	a091                	j	80003e24 <writei+0x8e>
    80003de2:	02099d93          	slli	s11,s3,0x20
    80003de6:	020ddd93          	srli	s11,s11,0x20
    80003dea:	05848793          	addi	a5,s1,88
    80003dee:	86ee                	mv	a3,s11
    80003df0:	8656                	mv	a2,s5
    80003df2:	85e2                	mv	a1,s8
    80003df4:	953e                	add	a0,a0,a5
    80003df6:	fffff097          	auipc	ra,0xfffff
    80003dfa:	a46080e7          	jalr	-1466(ra) # 8000283c <either_copyin>
    80003dfe:	07950263          	beq	a0,s9,80003e62 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003e02:	8526                	mv	a0,s1
    80003e04:	00000097          	auipc	ra,0x0
    80003e08:	77e080e7          	jalr	1918(ra) # 80004582 <log_write>
    brelse(bp);
    80003e0c:	8526                	mv	a0,s1
    80003e0e:	fffff097          	auipc	ra,0xfffff
    80003e12:	50a080e7          	jalr	1290(ra) # 80003318 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e16:	01498a3b          	addw	s4,s3,s4
    80003e1a:	0129893b          	addw	s2,s3,s2
    80003e1e:	9aee                	add	s5,s5,s11
    80003e20:	056a7663          	bgeu	s4,s6,80003e6c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003e24:	000ba483          	lw	s1,0(s7)
    80003e28:	00a9559b          	srliw	a1,s2,0xa
    80003e2c:	855e                	mv	a0,s7
    80003e2e:	fffff097          	auipc	ra,0xfffff
    80003e32:	7ae080e7          	jalr	1966(ra) # 800035dc <bmap>
    80003e36:	0005059b          	sext.w	a1,a0
    80003e3a:	8526                	mv	a0,s1
    80003e3c:	fffff097          	auipc	ra,0xfffff
    80003e40:	3ac080e7          	jalr	940(ra) # 800031e8 <bread>
    80003e44:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e46:	3ff97513          	andi	a0,s2,1023
    80003e4a:	40ad07bb          	subw	a5,s10,a0
    80003e4e:	414b073b          	subw	a4,s6,s4
    80003e52:	89be                	mv	s3,a5
    80003e54:	2781                	sext.w	a5,a5
    80003e56:	0007069b          	sext.w	a3,a4
    80003e5a:	f8f6f4e3          	bgeu	a3,a5,80003de2 <writei+0x4c>
    80003e5e:	89ba                	mv	s3,a4
    80003e60:	b749                	j	80003de2 <writei+0x4c>
      brelse(bp);
    80003e62:	8526                	mv	a0,s1
    80003e64:	fffff097          	auipc	ra,0xfffff
    80003e68:	4b4080e7          	jalr	1204(ra) # 80003318 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003e6c:	04cba783          	lw	a5,76(s7)
    80003e70:	0127f463          	bgeu	a5,s2,80003e78 <writei+0xe2>
      ip->size = off;
    80003e74:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003e78:	855e                	mv	a0,s7
    80003e7a:	00000097          	auipc	ra,0x0
    80003e7e:	aa8080e7          	jalr	-1368(ra) # 80003922 <iupdate>
  }

  return n;
    80003e82:	000b051b          	sext.w	a0,s6
}
    80003e86:	70a6                	ld	ra,104(sp)
    80003e88:	7406                	ld	s0,96(sp)
    80003e8a:	64e6                	ld	s1,88(sp)
    80003e8c:	6946                	ld	s2,80(sp)
    80003e8e:	69a6                	ld	s3,72(sp)
    80003e90:	6a06                	ld	s4,64(sp)
    80003e92:	7ae2                	ld	s5,56(sp)
    80003e94:	7b42                	ld	s6,48(sp)
    80003e96:	7ba2                	ld	s7,40(sp)
    80003e98:	7c02                	ld	s8,32(sp)
    80003e9a:	6ce2                	ld	s9,24(sp)
    80003e9c:	6d42                	ld	s10,16(sp)
    80003e9e:	6da2                	ld	s11,8(sp)
    80003ea0:	6165                	addi	sp,sp,112
    80003ea2:	8082                	ret
    return -1;
    80003ea4:	557d                	li	a0,-1
}
    80003ea6:	8082                	ret
    return -1;
    80003ea8:	557d                	li	a0,-1
    80003eaa:	bff1                	j	80003e86 <writei+0xf0>
    return -1;
    80003eac:	557d                	li	a0,-1
    80003eae:	bfe1                	j	80003e86 <writei+0xf0>

0000000080003eb0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003eb0:	1141                	addi	sp,sp,-16
    80003eb2:	e406                	sd	ra,8(sp)
    80003eb4:	e022                	sd	s0,0(sp)
    80003eb6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003eb8:	4639                	li	a2,14
    80003eba:	ffffd097          	auipc	ra,0xffffd
    80003ebe:	f16080e7          	jalr	-234(ra) # 80000dd0 <strncmp>
}
    80003ec2:	60a2                	ld	ra,8(sp)
    80003ec4:	6402                	ld	s0,0(sp)
    80003ec6:	0141                	addi	sp,sp,16
    80003ec8:	8082                	ret

0000000080003eca <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003eca:	7139                	addi	sp,sp,-64
    80003ecc:	fc06                	sd	ra,56(sp)
    80003ece:	f822                	sd	s0,48(sp)
    80003ed0:	f426                	sd	s1,40(sp)
    80003ed2:	f04a                	sd	s2,32(sp)
    80003ed4:	ec4e                	sd	s3,24(sp)
    80003ed6:	e852                	sd	s4,16(sp)
    80003ed8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003eda:	04451703          	lh	a4,68(a0)
    80003ede:	4785                	li	a5,1
    80003ee0:	00f71a63          	bne	a4,a5,80003ef4 <dirlookup+0x2a>
    80003ee4:	892a                	mv	s2,a0
    80003ee6:	89ae                	mv	s3,a1
    80003ee8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003eea:	457c                	lw	a5,76(a0)
    80003eec:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003eee:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ef0:	e79d                	bnez	a5,80003f1e <dirlookup+0x54>
    80003ef2:	a8a5                	j	80003f6a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003ef4:	00004517          	auipc	a0,0x4
    80003ef8:	79c50513          	addi	a0,a0,1948 # 80008690 <syscalls+0x1a0>
    80003efc:	ffffc097          	auipc	ra,0xffffc
    80003f00:	644080e7          	jalr	1604(ra) # 80000540 <panic>
      panic("dirlookup read");
    80003f04:	00004517          	auipc	a0,0x4
    80003f08:	7a450513          	addi	a0,a0,1956 # 800086a8 <syscalls+0x1b8>
    80003f0c:	ffffc097          	auipc	ra,0xffffc
    80003f10:	634080e7          	jalr	1588(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f14:	24c1                	addiw	s1,s1,16
    80003f16:	04c92783          	lw	a5,76(s2)
    80003f1a:	04f4f763          	bgeu	s1,a5,80003f68 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f1e:	4741                	li	a4,16
    80003f20:	86a6                	mv	a3,s1
    80003f22:	fc040613          	addi	a2,s0,-64
    80003f26:	4581                	li	a1,0
    80003f28:	854a                	mv	a0,s2
    80003f2a:	00000097          	auipc	ra,0x0
    80003f2e:	d76080e7          	jalr	-650(ra) # 80003ca0 <readi>
    80003f32:	47c1                	li	a5,16
    80003f34:	fcf518e3          	bne	a0,a5,80003f04 <dirlookup+0x3a>
    if(de.inum == 0)
    80003f38:	fc045783          	lhu	a5,-64(s0)
    80003f3c:	dfe1                	beqz	a5,80003f14 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003f3e:	fc240593          	addi	a1,s0,-62
    80003f42:	854e                	mv	a0,s3
    80003f44:	00000097          	auipc	ra,0x0
    80003f48:	f6c080e7          	jalr	-148(ra) # 80003eb0 <namecmp>
    80003f4c:	f561                	bnez	a0,80003f14 <dirlookup+0x4a>
      if(poff)
    80003f4e:	000a0463          	beqz	s4,80003f56 <dirlookup+0x8c>
        *poff = off;
    80003f52:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003f56:	fc045583          	lhu	a1,-64(s0)
    80003f5a:	00092503          	lw	a0,0(s2)
    80003f5e:	fffff097          	auipc	ra,0xfffff
    80003f62:	75a080e7          	jalr	1882(ra) # 800036b8 <iget>
    80003f66:	a011                	j	80003f6a <dirlookup+0xa0>
  return 0;
    80003f68:	4501                	li	a0,0
}
    80003f6a:	70e2                	ld	ra,56(sp)
    80003f6c:	7442                	ld	s0,48(sp)
    80003f6e:	74a2                	ld	s1,40(sp)
    80003f70:	7902                	ld	s2,32(sp)
    80003f72:	69e2                	ld	s3,24(sp)
    80003f74:	6a42                	ld	s4,16(sp)
    80003f76:	6121                	addi	sp,sp,64
    80003f78:	8082                	ret

0000000080003f7a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003f7a:	711d                	addi	sp,sp,-96
    80003f7c:	ec86                	sd	ra,88(sp)
    80003f7e:	e8a2                	sd	s0,80(sp)
    80003f80:	e4a6                	sd	s1,72(sp)
    80003f82:	e0ca                	sd	s2,64(sp)
    80003f84:	fc4e                	sd	s3,56(sp)
    80003f86:	f852                	sd	s4,48(sp)
    80003f88:	f456                	sd	s5,40(sp)
    80003f8a:	f05a                	sd	s6,32(sp)
    80003f8c:	ec5e                	sd	s7,24(sp)
    80003f8e:	e862                	sd	s8,16(sp)
    80003f90:	e466                	sd	s9,8(sp)
    80003f92:	1080                	addi	s0,sp,96
    80003f94:	84aa                	mv	s1,a0
    80003f96:	8aae                	mv	s5,a1
    80003f98:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003f9a:	00054703          	lbu	a4,0(a0)
    80003f9e:	02f00793          	li	a5,47
    80003fa2:	02f70363          	beq	a4,a5,80003fc8 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003fa6:	ffffe097          	auipc	ra,0xffffe
    80003faa:	e22080e7          	jalr	-478(ra) # 80001dc8 <myproc>
    80003fae:	15053503          	ld	a0,336(a0)
    80003fb2:	00000097          	auipc	ra,0x0
    80003fb6:	9fc080e7          	jalr	-1540(ra) # 800039ae <idup>
    80003fba:	89aa                	mv	s3,a0
  while(*path == '/')
    80003fbc:	02f00913          	li	s2,47
  len = path - s;
    80003fc0:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003fc2:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003fc4:	4b85                	li	s7,1
    80003fc6:	a865                	j	8000407e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003fc8:	4585                	li	a1,1
    80003fca:	4505                	li	a0,1
    80003fcc:	fffff097          	auipc	ra,0xfffff
    80003fd0:	6ec080e7          	jalr	1772(ra) # 800036b8 <iget>
    80003fd4:	89aa                	mv	s3,a0
    80003fd6:	b7dd                	j	80003fbc <namex+0x42>
      iunlockput(ip);
    80003fd8:	854e                	mv	a0,s3
    80003fda:	00000097          	auipc	ra,0x0
    80003fde:	c74080e7          	jalr	-908(ra) # 80003c4e <iunlockput>
      return 0;
    80003fe2:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003fe4:	854e                	mv	a0,s3
    80003fe6:	60e6                	ld	ra,88(sp)
    80003fe8:	6446                	ld	s0,80(sp)
    80003fea:	64a6                	ld	s1,72(sp)
    80003fec:	6906                	ld	s2,64(sp)
    80003fee:	79e2                	ld	s3,56(sp)
    80003ff0:	7a42                	ld	s4,48(sp)
    80003ff2:	7aa2                	ld	s5,40(sp)
    80003ff4:	7b02                	ld	s6,32(sp)
    80003ff6:	6be2                	ld	s7,24(sp)
    80003ff8:	6c42                	ld	s8,16(sp)
    80003ffa:	6ca2                	ld	s9,8(sp)
    80003ffc:	6125                	addi	sp,sp,96
    80003ffe:	8082                	ret
      iunlock(ip);
    80004000:	854e                	mv	a0,s3
    80004002:	00000097          	auipc	ra,0x0
    80004006:	aac080e7          	jalr	-1364(ra) # 80003aae <iunlock>
      return ip;
    8000400a:	bfe9                	j	80003fe4 <namex+0x6a>
      iunlockput(ip);
    8000400c:	854e                	mv	a0,s3
    8000400e:	00000097          	auipc	ra,0x0
    80004012:	c40080e7          	jalr	-960(ra) # 80003c4e <iunlockput>
      return 0;
    80004016:	89e6                	mv	s3,s9
    80004018:	b7f1                	j	80003fe4 <namex+0x6a>
  len = path - s;
    8000401a:	40b48633          	sub	a2,s1,a1
    8000401e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004022:	099c5463          	bge	s8,s9,800040aa <namex+0x130>
    memmove(name, s, DIRSIZ);
    80004026:	4639                	li	a2,14
    80004028:	8552                	mv	a0,s4
    8000402a:	ffffd097          	auipc	ra,0xffffd
    8000402e:	d2a080e7          	jalr	-726(ra) # 80000d54 <memmove>
  while(*path == '/')
    80004032:	0004c783          	lbu	a5,0(s1)
    80004036:	01279763          	bne	a5,s2,80004044 <namex+0xca>
    path++;
    8000403a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000403c:	0004c783          	lbu	a5,0(s1)
    80004040:	ff278de3          	beq	a5,s2,8000403a <namex+0xc0>
    ilock(ip);
    80004044:	854e                	mv	a0,s3
    80004046:	00000097          	auipc	ra,0x0
    8000404a:	9a6080e7          	jalr	-1626(ra) # 800039ec <ilock>
    if(ip->type != T_DIR){
    8000404e:	04499783          	lh	a5,68(s3)
    80004052:	f97793e3          	bne	a5,s7,80003fd8 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80004056:	000a8563          	beqz	s5,80004060 <namex+0xe6>
    8000405a:	0004c783          	lbu	a5,0(s1)
    8000405e:	d3cd                	beqz	a5,80004000 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004060:	865a                	mv	a2,s6
    80004062:	85d2                	mv	a1,s4
    80004064:	854e                	mv	a0,s3
    80004066:	00000097          	auipc	ra,0x0
    8000406a:	e64080e7          	jalr	-412(ra) # 80003eca <dirlookup>
    8000406e:	8caa                	mv	s9,a0
    80004070:	dd51                	beqz	a0,8000400c <namex+0x92>
    iunlockput(ip);
    80004072:	854e                	mv	a0,s3
    80004074:	00000097          	auipc	ra,0x0
    80004078:	bda080e7          	jalr	-1062(ra) # 80003c4e <iunlockput>
    ip = next;
    8000407c:	89e6                	mv	s3,s9
  while(*path == '/')
    8000407e:	0004c783          	lbu	a5,0(s1)
    80004082:	05279763          	bne	a5,s2,800040d0 <namex+0x156>
    path++;
    80004086:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004088:	0004c783          	lbu	a5,0(s1)
    8000408c:	ff278de3          	beq	a5,s2,80004086 <namex+0x10c>
  if(*path == 0)
    80004090:	c79d                	beqz	a5,800040be <namex+0x144>
    path++;
    80004092:	85a6                	mv	a1,s1
  len = path - s;
    80004094:	8cda                	mv	s9,s6
    80004096:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004098:	01278963          	beq	a5,s2,800040aa <namex+0x130>
    8000409c:	dfbd                	beqz	a5,8000401a <namex+0xa0>
    path++;
    8000409e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800040a0:	0004c783          	lbu	a5,0(s1)
    800040a4:	ff279ce3          	bne	a5,s2,8000409c <namex+0x122>
    800040a8:	bf8d                	j	8000401a <namex+0xa0>
    memmove(name, s, len);
    800040aa:	2601                	sext.w	a2,a2
    800040ac:	8552                	mv	a0,s4
    800040ae:	ffffd097          	auipc	ra,0xffffd
    800040b2:	ca6080e7          	jalr	-858(ra) # 80000d54 <memmove>
    name[len] = 0;
    800040b6:	9cd2                	add	s9,s9,s4
    800040b8:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800040bc:	bf9d                	j	80004032 <namex+0xb8>
  if(nameiparent){
    800040be:	f20a83e3          	beqz	s5,80003fe4 <namex+0x6a>
    iput(ip);
    800040c2:	854e                	mv	a0,s3
    800040c4:	00000097          	auipc	ra,0x0
    800040c8:	ae2080e7          	jalr	-1310(ra) # 80003ba6 <iput>
    return 0;
    800040cc:	4981                	li	s3,0
    800040ce:	bf19                	j	80003fe4 <namex+0x6a>
  if(*path == 0)
    800040d0:	d7fd                	beqz	a5,800040be <namex+0x144>
  while(*path != '/' && *path != 0)
    800040d2:	0004c783          	lbu	a5,0(s1)
    800040d6:	85a6                	mv	a1,s1
    800040d8:	b7d1                	j	8000409c <namex+0x122>

00000000800040da <dirlink>:
{
    800040da:	7139                	addi	sp,sp,-64
    800040dc:	fc06                	sd	ra,56(sp)
    800040de:	f822                	sd	s0,48(sp)
    800040e0:	f426                	sd	s1,40(sp)
    800040e2:	f04a                	sd	s2,32(sp)
    800040e4:	ec4e                	sd	s3,24(sp)
    800040e6:	e852                	sd	s4,16(sp)
    800040e8:	0080                	addi	s0,sp,64
    800040ea:	892a                	mv	s2,a0
    800040ec:	8a2e                	mv	s4,a1
    800040ee:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800040f0:	4601                	li	a2,0
    800040f2:	00000097          	auipc	ra,0x0
    800040f6:	dd8080e7          	jalr	-552(ra) # 80003eca <dirlookup>
    800040fa:	e93d                	bnez	a0,80004170 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040fc:	04c92483          	lw	s1,76(s2)
    80004100:	c49d                	beqz	s1,8000412e <dirlink+0x54>
    80004102:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004104:	4741                	li	a4,16
    80004106:	86a6                	mv	a3,s1
    80004108:	fc040613          	addi	a2,s0,-64
    8000410c:	4581                	li	a1,0
    8000410e:	854a                	mv	a0,s2
    80004110:	00000097          	auipc	ra,0x0
    80004114:	b90080e7          	jalr	-1136(ra) # 80003ca0 <readi>
    80004118:	47c1                	li	a5,16
    8000411a:	06f51163          	bne	a0,a5,8000417c <dirlink+0xa2>
    if(de.inum == 0)
    8000411e:	fc045783          	lhu	a5,-64(s0)
    80004122:	c791                	beqz	a5,8000412e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004124:	24c1                	addiw	s1,s1,16
    80004126:	04c92783          	lw	a5,76(s2)
    8000412a:	fcf4ede3          	bltu	s1,a5,80004104 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000412e:	4639                	li	a2,14
    80004130:	85d2                	mv	a1,s4
    80004132:	fc240513          	addi	a0,s0,-62
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	cd6080e7          	jalr	-810(ra) # 80000e0c <strncpy>
  de.inum = inum;
    8000413e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004142:	4741                	li	a4,16
    80004144:	86a6                	mv	a3,s1
    80004146:	fc040613          	addi	a2,s0,-64
    8000414a:	4581                	li	a1,0
    8000414c:	854a                	mv	a0,s2
    8000414e:	00000097          	auipc	ra,0x0
    80004152:	c48080e7          	jalr	-952(ra) # 80003d96 <writei>
    80004156:	872a                	mv	a4,a0
    80004158:	47c1                	li	a5,16
  return 0;
    8000415a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000415c:	02f71863          	bne	a4,a5,8000418c <dirlink+0xb2>
}
    80004160:	70e2                	ld	ra,56(sp)
    80004162:	7442                	ld	s0,48(sp)
    80004164:	74a2                	ld	s1,40(sp)
    80004166:	7902                	ld	s2,32(sp)
    80004168:	69e2                	ld	s3,24(sp)
    8000416a:	6a42                	ld	s4,16(sp)
    8000416c:	6121                	addi	sp,sp,64
    8000416e:	8082                	ret
    iput(ip);
    80004170:	00000097          	auipc	ra,0x0
    80004174:	a36080e7          	jalr	-1482(ra) # 80003ba6 <iput>
    return -1;
    80004178:	557d                	li	a0,-1
    8000417a:	b7dd                	j	80004160 <dirlink+0x86>
      panic("dirlink read");
    8000417c:	00004517          	auipc	a0,0x4
    80004180:	53c50513          	addi	a0,a0,1340 # 800086b8 <syscalls+0x1c8>
    80004184:	ffffc097          	auipc	ra,0xffffc
    80004188:	3bc080e7          	jalr	956(ra) # 80000540 <panic>
    panic("dirlink");
    8000418c:	00004517          	auipc	a0,0x4
    80004190:	64c50513          	addi	a0,a0,1612 # 800087d8 <syscalls+0x2e8>
    80004194:	ffffc097          	auipc	ra,0xffffc
    80004198:	3ac080e7          	jalr	940(ra) # 80000540 <panic>

000000008000419c <namei>:

struct inode*
namei(char *path)
{
    8000419c:	1101                	addi	sp,sp,-32
    8000419e:	ec06                	sd	ra,24(sp)
    800041a0:	e822                	sd	s0,16(sp)
    800041a2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800041a4:	fe040613          	addi	a2,s0,-32
    800041a8:	4581                	li	a1,0
    800041aa:	00000097          	auipc	ra,0x0
    800041ae:	dd0080e7          	jalr	-560(ra) # 80003f7a <namex>
}
    800041b2:	60e2                	ld	ra,24(sp)
    800041b4:	6442                	ld	s0,16(sp)
    800041b6:	6105                	addi	sp,sp,32
    800041b8:	8082                	ret

00000000800041ba <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800041ba:	1141                	addi	sp,sp,-16
    800041bc:	e406                	sd	ra,8(sp)
    800041be:	e022                	sd	s0,0(sp)
    800041c0:	0800                	addi	s0,sp,16
    800041c2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800041c4:	4585                	li	a1,1
    800041c6:	00000097          	auipc	ra,0x0
    800041ca:	db4080e7          	jalr	-588(ra) # 80003f7a <namex>
}
    800041ce:	60a2                	ld	ra,8(sp)
    800041d0:	6402                	ld	s0,0(sp)
    800041d2:	0141                	addi	sp,sp,16
    800041d4:	8082                	ret

00000000800041d6 <write_head>:
    800041d6:	1101                	addi	sp,sp,-32
    800041d8:	ec06                	sd	ra,24(sp)
    800041da:	e822                	sd	s0,16(sp)
    800041dc:	e426                	sd	s1,8(sp)
    800041de:	e04a                	sd	s2,0(sp)
    800041e0:	1000                	addi	s0,sp,32
    800041e2:	0001e917          	auipc	s2,0x1e
    800041e6:	d6e90913          	addi	s2,s2,-658 # 80021f50 <log>
    800041ea:	01892583          	lw	a1,24(s2)
    800041ee:	02892503          	lw	a0,40(s2)
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	ff6080e7          	jalr	-10(ra) # 800031e8 <bread>
    800041fa:	84aa                	mv	s1,a0
    800041fc:	02c92683          	lw	a3,44(s2)
    80004200:	cd34                	sw	a3,88(a0)
    80004202:	02d05863          	blez	a3,80004232 <write_head+0x5c>
    80004206:	0001e797          	auipc	a5,0x1e
    8000420a:	d7a78793          	addi	a5,a5,-646 # 80021f80 <log+0x30>
    8000420e:	05c50713          	addi	a4,a0,92
    80004212:	36fd                	addiw	a3,a3,-1
    80004214:	02069613          	slli	a2,a3,0x20
    80004218:	01e65693          	srli	a3,a2,0x1e
    8000421c:	0001e617          	auipc	a2,0x1e
    80004220:	d6860613          	addi	a2,a2,-664 # 80021f84 <log+0x34>
    80004224:	96b2                	add	a3,a3,a2
    80004226:	4390                	lw	a2,0(a5)
    80004228:	c310                	sw	a2,0(a4)
    8000422a:	0791                	addi	a5,a5,4
    8000422c:	0711                	addi	a4,a4,4
    8000422e:	fed79ce3          	bne	a5,a3,80004226 <write_head+0x50>
    80004232:	8526                	mv	a0,s1
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	0a6080e7          	jalr	166(ra) # 800032da <bwrite>
    8000423c:	8526                	mv	a0,s1
    8000423e:	fffff097          	auipc	ra,0xfffff
    80004242:	0da080e7          	jalr	218(ra) # 80003318 <brelse>
    80004246:	60e2                	ld	ra,24(sp)
    80004248:	6442                	ld	s0,16(sp)
    8000424a:	64a2                	ld	s1,8(sp)
    8000424c:	6902                	ld	s2,0(sp)
    8000424e:	6105                	addi	sp,sp,32
    80004250:	8082                	ret

0000000080004252 <install_trans>:
    80004252:	0001e797          	auipc	a5,0x1e
    80004256:	d2a7a783          	lw	a5,-726(a5) # 80021f7c <log+0x2c>
    8000425a:	0af05663          	blez	a5,80004306 <install_trans+0xb4>
    8000425e:	7139                	addi	sp,sp,-64
    80004260:	fc06                	sd	ra,56(sp)
    80004262:	f822                	sd	s0,48(sp)
    80004264:	f426                	sd	s1,40(sp)
    80004266:	f04a                	sd	s2,32(sp)
    80004268:	ec4e                	sd	s3,24(sp)
    8000426a:	e852                	sd	s4,16(sp)
    8000426c:	e456                	sd	s5,8(sp)
    8000426e:	0080                	addi	s0,sp,64
    80004270:	0001ea97          	auipc	s5,0x1e
    80004274:	d10a8a93          	addi	s5,s5,-752 # 80021f80 <log+0x30>
    80004278:	4a01                	li	s4,0
    8000427a:	0001e997          	auipc	s3,0x1e
    8000427e:	cd698993          	addi	s3,s3,-810 # 80021f50 <log>
    80004282:	0189a583          	lw	a1,24(s3)
    80004286:	014585bb          	addw	a1,a1,s4
    8000428a:	2585                	addiw	a1,a1,1
    8000428c:	0289a503          	lw	a0,40(s3)
    80004290:	fffff097          	auipc	ra,0xfffff
    80004294:	f58080e7          	jalr	-168(ra) # 800031e8 <bread>
    80004298:	892a                	mv	s2,a0
    8000429a:	000aa583          	lw	a1,0(s5)
    8000429e:	0289a503          	lw	a0,40(s3)
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	f46080e7          	jalr	-186(ra) # 800031e8 <bread>
    800042aa:	84aa                	mv	s1,a0
    800042ac:	40000613          	li	a2,1024
    800042b0:	05890593          	addi	a1,s2,88
    800042b4:	05850513          	addi	a0,a0,88
    800042b8:	ffffd097          	auipc	ra,0xffffd
    800042bc:	a9c080e7          	jalr	-1380(ra) # 80000d54 <memmove>
    800042c0:	8526                	mv	a0,s1
    800042c2:	fffff097          	auipc	ra,0xfffff
    800042c6:	018080e7          	jalr	24(ra) # 800032da <bwrite>
    800042ca:	8526                	mv	a0,s1
    800042cc:	fffff097          	auipc	ra,0xfffff
    800042d0:	126080e7          	jalr	294(ra) # 800033f2 <bunpin>
    800042d4:	854a                	mv	a0,s2
    800042d6:	fffff097          	auipc	ra,0xfffff
    800042da:	042080e7          	jalr	66(ra) # 80003318 <brelse>
    800042de:	8526                	mv	a0,s1
    800042e0:	fffff097          	auipc	ra,0xfffff
    800042e4:	038080e7          	jalr	56(ra) # 80003318 <brelse>
    800042e8:	2a05                	addiw	s4,s4,1
    800042ea:	0a91                	addi	s5,s5,4
    800042ec:	02c9a783          	lw	a5,44(s3)
    800042f0:	f8fa49e3          	blt	s4,a5,80004282 <install_trans+0x30>
    800042f4:	70e2                	ld	ra,56(sp)
    800042f6:	7442                	ld	s0,48(sp)
    800042f8:	74a2                	ld	s1,40(sp)
    800042fa:	7902                	ld	s2,32(sp)
    800042fc:	69e2                	ld	s3,24(sp)
    800042fe:	6a42                	ld	s4,16(sp)
    80004300:	6aa2                	ld	s5,8(sp)
    80004302:	6121                	addi	sp,sp,64
    80004304:	8082                	ret
    80004306:	8082                	ret

0000000080004308 <initlog>:
    80004308:	7179                	addi	sp,sp,-48
    8000430a:	f406                	sd	ra,40(sp)
    8000430c:	f022                	sd	s0,32(sp)
    8000430e:	ec26                	sd	s1,24(sp)
    80004310:	e84a                	sd	s2,16(sp)
    80004312:	e44e                	sd	s3,8(sp)
    80004314:	1800                	addi	s0,sp,48
    80004316:	892a                	mv	s2,a0
    80004318:	89ae                	mv	s3,a1
    8000431a:	0001e497          	auipc	s1,0x1e
    8000431e:	c3648493          	addi	s1,s1,-970 # 80021f50 <log>
    80004322:	00004597          	auipc	a1,0x4
    80004326:	3a658593          	addi	a1,a1,934 # 800086c8 <syscalls+0x1d8>
    8000432a:	8526                	mv	a0,s1
    8000432c:	ffffd097          	auipc	ra,0xffffd
    80004330:	840080e7          	jalr	-1984(ra) # 80000b6c <initlock>
    80004334:	0149a583          	lw	a1,20(s3)
    80004338:	cc8c                	sw	a1,24(s1)
    8000433a:	0109a783          	lw	a5,16(s3)
    8000433e:	ccdc                	sw	a5,28(s1)
    80004340:	0324a423          	sw	s2,40(s1)
    80004344:	854a                	mv	a0,s2
    80004346:	fffff097          	auipc	ra,0xfffff
    8000434a:	ea2080e7          	jalr	-350(ra) # 800031e8 <bread>
    8000434e:	4d34                	lw	a3,88(a0)
    80004350:	d4d4                	sw	a3,44(s1)
    80004352:	02d05663          	blez	a3,8000437e <initlog+0x76>
    80004356:	05c50793          	addi	a5,a0,92
    8000435a:	0001e717          	auipc	a4,0x1e
    8000435e:	c2670713          	addi	a4,a4,-986 # 80021f80 <log+0x30>
    80004362:	36fd                	addiw	a3,a3,-1
    80004364:	02069613          	slli	a2,a3,0x20
    80004368:	01e65693          	srli	a3,a2,0x1e
    8000436c:	06050613          	addi	a2,a0,96
    80004370:	96b2                	add	a3,a3,a2
    80004372:	4390                	lw	a2,0(a5)
    80004374:	c310                	sw	a2,0(a4)
    80004376:	0791                	addi	a5,a5,4
    80004378:	0711                	addi	a4,a4,4
    8000437a:	fed79ce3          	bne	a5,a3,80004372 <initlog+0x6a>
    8000437e:	fffff097          	auipc	ra,0xfffff
    80004382:	f9a080e7          	jalr	-102(ra) # 80003318 <brelse>
    80004386:	00000097          	auipc	ra,0x0
    8000438a:	ecc080e7          	jalr	-308(ra) # 80004252 <install_trans>
    8000438e:	0001e797          	auipc	a5,0x1e
    80004392:	be07a723          	sw	zero,-1042(a5) # 80021f7c <log+0x2c>
    80004396:	00000097          	auipc	ra,0x0
    8000439a:	e40080e7          	jalr	-448(ra) # 800041d6 <write_head>
    8000439e:	70a2                	ld	ra,40(sp)
    800043a0:	7402                	ld	s0,32(sp)
    800043a2:	64e2                	ld	s1,24(sp)
    800043a4:	6942                	ld	s2,16(sp)
    800043a6:	69a2                	ld	s3,8(sp)
    800043a8:	6145                	addi	sp,sp,48
    800043aa:	8082                	ret

00000000800043ac <begin_op>:
    800043ac:	1101                	addi	sp,sp,-32
    800043ae:	ec06                	sd	ra,24(sp)
    800043b0:	e822                	sd	s0,16(sp)
    800043b2:	e426                	sd	s1,8(sp)
    800043b4:	e04a                	sd	s2,0(sp)
    800043b6:	1000                	addi	s0,sp,32
    800043b8:	0001e517          	auipc	a0,0x1e
    800043bc:	b9850513          	addi	a0,a0,-1128 # 80021f50 <log>
    800043c0:	ffffd097          	auipc	ra,0xffffd
    800043c4:	83c080e7          	jalr	-1988(ra) # 80000bfc <acquire>
    800043c8:	0001e497          	auipc	s1,0x1e
    800043cc:	b8848493          	addi	s1,s1,-1144 # 80021f50 <log>
    800043d0:	4979                	li	s2,30
    800043d2:	a039                	j	800043e0 <begin_op+0x34>
    800043d4:	85a6                	mv	a1,s1
    800043d6:	8526                	mv	a0,s1
    800043d8:	ffffe097          	auipc	ra,0xffffe
    800043dc:	17e080e7          	jalr	382(ra) # 80002556 <sleep>
    800043e0:	50dc                	lw	a5,36(s1)
    800043e2:	fbed                	bnez	a5,800043d4 <begin_op+0x28>
    800043e4:	509c                	lw	a5,32(s1)
    800043e6:	0017871b          	addiw	a4,a5,1
    800043ea:	0007069b          	sext.w	a3,a4
    800043ee:	0027179b          	slliw	a5,a4,0x2
    800043f2:	9fb9                	addw	a5,a5,a4
    800043f4:	0017979b          	slliw	a5,a5,0x1
    800043f8:	54d8                	lw	a4,44(s1)
    800043fa:	9fb9                	addw	a5,a5,a4
    800043fc:	00f95963          	bge	s2,a5,8000440e <begin_op+0x62>
    80004400:	85a6                	mv	a1,s1
    80004402:	8526                	mv	a0,s1
    80004404:	ffffe097          	auipc	ra,0xffffe
    80004408:	152080e7          	jalr	338(ra) # 80002556 <sleep>
    8000440c:	bfd1                	j	800043e0 <begin_op+0x34>
    8000440e:	0001e517          	auipc	a0,0x1e
    80004412:	b4250513          	addi	a0,a0,-1214 # 80021f50 <log>
    80004416:	d114                	sw	a3,32(a0)
    80004418:	ffffd097          	auipc	ra,0xffffd
    8000441c:	898080e7          	jalr	-1896(ra) # 80000cb0 <release>
    80004420:	60e2                	ld	ra,24(sp)
    80004422:	6442                	ld	s0,16(sp)
    80004424:	64a2                	ld	s1,8(sp)
    80004426:	6902                	ld	s2,0(sp)
    80004428:	6105                	addi	sp,sp,32
    8000442a:	8082                	ret

000000008000442c <end_op>:
    8000442c:	7139                	addi	sp,sp,-64
    8000442e:	fc06                	sd	ra,56(sp)
    80004430:	f822                	sd	s0,48(sp)
    80004432:	f426                	sd	s1,40(sp)
    80004434:	f04a                	sd	s2,32(sp)
    80004436:	ec4e                	sd	s3,24(sp)
    80004438:	e852                	sd	s4,16(sp)
    8000443a:	e456                	sd	s5,8(sp)
    8000443c:	0080                	addi	s0,sp,64
    8000443e:	0001e497          	auipc	s1,0x1e
    80004442:	b1248493          	addi	s1,s1,-1262 # 80021f50 <log>
    80004446:	8526                	mv	a0,s1
    80004448:	ffffc097          	auipc	ra,0xffffc
    8000444c:	7b4080e7          	jalr	1972(ra) # 80000bfc <acquire>
    80004450:	509c                	lw	a5,32(s1)
    80004452:	37fd                	addiw	a5,a5,-1
    80004454:	0007891b          	sext.w	s2,a5
    80004458:	d09c                	sw	a5,32(s1)
    8000445a:	50dc                	lw	a5,36(s1)
    8000445c:	e7b9                	bnez	a5,800044aa <end_op+0x7e>
    8000445e:	04091e63          	bnez	s2,800044ba <end_op+0x8e>
    80004462:	0001e497          	auipc	s1,0x1e
    80004466:	aee48493          	addi	s1,s1,-1298 # 80021f50 <log>
    8000446a:	4785                	li	a5,1
    8000446c:	d0dc                	sw	a5,36(s1)
    8000446e:	8526                	mv	a0,s1
    80004470:	ffffd097          	auipc	ra,0xffffd
    80004474:	840080e7          	jalr	-1984(ra) # 80000cb0 <release>
    80004478:	54dc                	lw	a5,44(s1)
    8000447a:	06f04763          	bgtz	a5,800044e8 <end_op+0xbc>
    8000447e:	0001e497          	auipc	s1,0x1e
    80004482:	ad248493          	addi	s1,s1,-1326 # 80021f50 <log>
    80004486:	8526                	mv	a0,s1
    80004488:	ffffc097          	auipc	ra,0xffffc
    8000448c:	774080e7          	jalr	1908(ra) # 80000bfc <acquire>
    80004490:	0204a223          	sw	zero,36(s1)
    80004494:	8526                	mv	a0,s1
    80004496:	ffffe097          	auipc	ra,0xffffe
    8000449a:	240080e7          	jalr	576(ra) # 800026d6 <wakeup>
    8000449e:	8526                	mv	a0,s1
    800044a0:	ffffd097          	auipc	ra,0xffffd
    800044a4:	810080e7          	jalr	-2032(ra) # 80000cb0 <release>
    800044a8:	a03d                	j	800044d6 <end_op+0xaa>
    800044aa:	00004517          	auipc	a0,0x4
    800044ae:	22650513          	addi	a0,a0,550 # 800086d0 <syscalls+0x1e0>
    800044b2:	ffffc097          	auipc	ra,0xffffc
    800044b6:	08e080e7          	jalr	142(ra) # 80000540 <panic>
    800044ba:	0001e497          	auipc	s1,0x1e
    800044be:	a9648493          	addi	s1,s1,-1386 # 80021f50 <log>
    800044c2:	8526                	mv	a0,s1
    800044c4:	ffffe097          	auipc	ra,0xffffe
    800044c8:	212080e7          	jalr	530(ra) # 800026d6 <wakeup>
    800044cc:	8526                	mv	a0,s1
    800044ce:	ffffc097          	auipc	ra,0xffffc
    800044d2:	7e2080e7          	jalr	2018(ra) # 80000cb0 <release>
    800044d6:	70e2                	ld	ra,56(sp)
    800044d8:	7442                	ld	s0,48(sp)
    800044da:	74a2                	ld	s1,40(sp)
    800044dc:	7902                	ld	s2,32(sp)
    800044de:	69e2                	ld	s3,24(sp)
    800044e0:	6a42                	ld	s4,16(sp)
    800044e2:	6aa2                	ld	s5,8(sp)
    800044e4:	6121                	addi	sp,sp,64
    800044e6:	8082                	ret
    800044e8:	0001ea97          	auipc	s5,0x1e
    800044ec:	a98a8a93          	addi	s5,s5,-1384 # 80021f80 <log+0x30>
    800044f0:	0001ea17          	auipc	s4,0x1e
    800044f4:	a60a0a13          	addi	s4,s4,-1440 # 80021f50 <log>
    800044f8:	018a2583          	lw	a1,24(s4)
    800044fc:	012585bb          	addw	a1,a1,s2
    80004500:	2585                	addiw	a1,a1,1
    80004502:	028a2503          	lw	a0,40(s4)
    80004506:	fffff097          	auipc	ra,0xfffff
    8000450a:	ce2080e7          	jalr	-798(ra) # 800031e8 <bread>
    8000450e:	84aa                	mv	s1,a0
    80004510:	000aa583          	lw	a1,0(s5)
    80004514:	028a2503          	lw	a0,40(s4)
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	cd0080e7          	jalr	-816(ra) # 800031e8 <bread>
    80004520:	89aa                	mv	s3,a0
    80004522:	40000613          	li	a2,1024
    80004526:	05850593          	addi	a1,a0,88
    8000452a:	05848513          	addi	a0,s1,88
    8000452e:	ffffd097          	auipc	ra,0xffffd
    80004532:	826080e7          	jalr	-2010(ra) # 80000d54 <memmove>
    80004536:	8526                	mv	a0,s1
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	da2080e7          	jalr	-606(ra) # 800032da <bwrite>
    80004540:	854e                	mv	a0,s3
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	dd6080e7          	jalr	-554(ra) # 80003318 <brelse>
    8000454a:	8526                	mv	a0,s1
    8000454c:	fffff097          	auipc	ra,0xfffff
    80004550:	dcc080e7          	jalr	-564(ra) # 80003318 <brelse>
    80004554:	2905                	addiw	s2,s2,1
    80004556:	0a91                	addi	s5,s5,4
    80004558:	02ca2783          	lw	a5,44(s4)
    8000455c:	f8f94ee3          	blt	s2,a5,800044f8 <end_op+0xcc>
    80004560:	00000097          	auipc	ra,0x0
    80004564:	c76080e7          	jalr	-906(ra) # 800041d6 <write_head>
    80004568:	00000097          	auipc	ra,0x0
    8000456c:	cea080e7          	jalr	-790(ra) # 80004252 <install_trans>
    80004570:	0001e797          	auipc	a5,0x1e
    80004574:	a007a623          	sw	zero,-1524(a5) # 80021f7c <log+0x2c>
    80004578:	00000097          	auipc	ra,0x0
    8000457c:	c5e080e7          	jalr	-930(ra) # 800041d6 <write_head>
    80004580:	bdfd                	j	8000447e <end_op+0x52>

0000000080004582 <log_write>:
    80004582:	1101                	addi	sp,sp,-32
    80004584:	ec06                	sd	ra,24(sp)
    80004586:	e822                	sd	s0,16(sp)
    80004588:	e426                	sd	s1,8(sp)
    8000458a:	e04a                	sd	s2,0(sp)
    8000458c:	1000                	addi	s0,sp,32
    8000458e:	0001e717          	auipc	a4,0x1e
    80004592:	9ee72703          	lw	a4,-1554(a4) # 80021f7c <log+0x2c>
    80004596:	47f5                	li	a5,29
    80004598:	08e7c063          	blt	a5,a4,80004618 <log_write+0x96>
    8000459c:	84aa                	mv	s1,a0
    8000459e:	0001e797          	auipc	a5,0x1e
    800045a2:	9ce7a783          	lw	a5,-1586(a5) # 80021f6c <log+0x1c>
    800045a6:	37fd                	addiw	a5,a5,-1
    800045a8:	06f75863          	bge	a4,a5,80004618 <log_write+0x96>
    800045ac:	0001e797          	auipc	a5,0x1e
    800045b0:	9c47a783          	lw	a5,-1596(a5) # 80021f70 <log+0x20>
    800045b4:	06f05a63          	blez	a5,80004628 <log_write+0xa6>
    800045b8:	0001e917          	auipc	s2,0x1e
    800045bc:	99890913          	addi	s2,s2,-1640 # 80021f50 <log>
    800045c0:	854a                	mv	a0,s2
    800045c2:	ffffc097          	auipc	ra,0xffffc
    800045c6:	63a080e7          	jalr	1594(ra) # 80000bfc <acquire>
    800045ca:	02c92603          	lw	a2,44(s2)
    800045ce:	06c05563          	blez	a2,80004638 <log_write+0xb6>
    800045d2:	44cc                	lw	a1,12(s1)
    800045d4:	0001e717          	auipc	a4,0x1e
    800045d8:	9ac70713          	addi	a4,a4,-1620 # 80021f80 <log+0x30>
    800045dc:	4781                	li	a5,0
    800045de:	4314                	lw	a3,0(a4)
    800045e0:	04b68d63          	beq	a3,a1,8000463a <log_write+0xb8>
    800045e4:	2785                	addiw	a5,a5,1
    800045e6:	0711                	addi	a4,a4,4
    800045e8:	fec79be3          	bne	a5,a2,800045de <log_write+0x5c>
    800045ec:	0621                	addi	a2,a2,8
    800045ee:	060a                	slli	a2,a2,0x2
    800045f0:	0001e797          	auipc	a5,0x1e
    800045f4:	96078793          	addi	a5,a5,-1696 # 80021f50 <log>
    800045f8:	963e                	add	a2,a2,a5
    800045fa:	44dc                	lw	a5,12(s1)
    800045fc:	ca1c                	sw	a5,16(a2)
    800045fe:	8526                	mv	a0,s1
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	db6080e7          	jalr	-586(ra) # 800033b6 <bpin>
    80004608:	0001e717          	auipc	a4,0x1e
    8000460c:	94870713          	addi	a4,a4,-1720 # 80021f50 <log>
    80004610:	575c                	lw	a5,44(a4)
    80004612:	2785                	addiw	a5,a5,1
    80004614:	d75c                	sw	a5,44(a4)
    80004616:	a83d                	j	80004654 <log_write+0xd2>
    80004618:	00004517          	auipc	a0,0x4
    8000461c:	0c850513          	addi	a0,a0,200 # 800086e0 <syscalls+0x1f0>
    80004620:	ffffc097          	auipc	ra,0xffffc
    80004624:	f20080e7          	jalr	-224(ra) # 80000540 <panic>
    80004628:	00004517          	auipc	a0,0x4
    8000462c:	0d050513          	addi	a0,a0,208 # 800086f8 <syscalls+0x208>
    80004630:	ffffc097          	auipc	ra,0xffffc
    80004634:	f10080e7          	jalr	-240(ra) # 80000540 <panic>
    80004638:	4781                	li	a5,0
    8000463a:	00878713          	addi	a4,a5,8
    8000463e:	00271693          	slli	a3,a4,0x2
    80004642:	0001e717          	auipc	a4,0x1e
    80004646:	90e70713          	addi	a4,a4,-1778 # 80021f50 <log>
    8000464a:	9736                	add	a4,a4,a3
    8000464c:	44d4                	lw	a3,12(s1)
    8000464e:	cb14                	sw	a3,16(a4)
    80004650:	faf607e3          	beq	a2,a5,800045fe <log_write+0x7c>
    80004654:	0001e517          	auipc	a0,0x1e
    80004658:	8fc50513          	addi	a0,a0,-1796 # 80021f50 <log>
    8000465c:	ffffc097          	auipc	ra,0xffffc
    80004660:	654080e7          	jalr	1620(ra) # 80000cb0 <release>
    80004664:	60e2                	ld	ra,24(sp)
    80004666:	6442                	ld	s0,16(sp)
    80004668:	64a2                	ld	s1,8(sp)
    8000466a:	6902                	ld	s2,0(sp)
    8000466c:	6105                	addi	sp,sp,32
    8000466e:	8082                	ret

0000000080004670 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004670:	1101                	addi	sp,sp,-32
    80004672:	ec06                	sd	ra,24(sp)
    80004674:	e822                	sd	s0,16(sp)
    80004676:	e426                	sd	s1,8(sp)
    80004678:	e04a                	sd	s2,0(sp)
    8000467a:	1000                	addi	s0,sp,32
    8000467c:	84aa                	mv	s1,a0
    8000467e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004680:	00004597          	auipc	a1,0x4
    80004684:	09858593          	addi	a1,a1,152 # 80008718 <syscalls+0x228>
    80004688:	0521                	addi	a0,a0,8
    8000468a:	ffffc097          	auipc	ra,0xffffc
    8000468e:	4e2080e7          	jalr	1250(ra) # 80000b6c <initlock>
  lk->name = name;
    80004692:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004696:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000469a:	0204a423          	sw	zero,40(s1)
}
    8000469e:	60e2                	ld	ra,24(sp)
    800046a0:	6442                	ld	s0,16(sp)
    800046a2:	64a2                	ld	s1,8(sp)
    800046a4:	6902                	ld	s2,0(sp)
    800046a6:	6105                	addi	sp,sp,32
    800046a8:	8082                	ret

00000000800046aa <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800046aa:	1101                	addi	sp,sp,-32
    800046ac:	ec06                	sd	ra,24(sp)
    800046ae:	e822                	sd	s0,16(sp)
    800046b0:	e426                	sd	s1,8(sp)
    800046b2:	e04a                	sd	s2,0(sp)
    800046b4:	1000                	addi	s0,sp,32
    800046b6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800046b8:	00850913          	addi	s2,a0,8
    800046bc:	854a                	mv	a0,s2
    800046be:	ffffc097          	auipc	ra,0xffffc
    800046c2:	53e080e7          	jalr	1342(ra) # 80000bfc <acquire>
  while (lk->locked) {
    800046c6:	409c                	lw	a5,0(s1)
    800046c8:	cb89                	beqz	a5,800046da <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800046ca:	85ca                	mv	a1,s2
    800046cc:	8526                	mv	a0,s1
    800046ce:	ffffe097          	auipc	ra,0xffffe
    800046d2:	e88080e7          	jalr	-376(ra) # 80002556 <sleep>
  while (lk->locked) {
    800046d6:	409c                	lw	a5,0(s1)
    800046d8:	fbed                	bnez	a5,800046ca <acquiresleep+0x20>
  }
  lk->locked = 1;
    800046da:	4785                	li	a5,1
    800046dc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800046de:	ffffd097          	auipc	ra,0xffffd
    800046e2:	6ea080e7          	jalr	1770(ra) # 80001dc8 <myproc>
    800046e6:	5d1c                	lw	a5,56(a0)
    800046e8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800046ea:	854a                	mv	a0,s2
    800046ec:	ffffc097          	auipc	ra,0xffffc
    800046f0:	5c4080e7          	jalr	1476(ra) # 80000cb0 <release>
}
    800046f4:	60e2                	ld	ra,24(sp)
    800046f6:	6442                	ld	s0,16(sp)
    800046f8:	64a2                	ld	s1,8(sp)
    800046fa:	6902                	ld	s2,0(sp)
    800046fc:	6105                	addi	sp,sp,32
    800046fe:	8082                	ret

0000000080004700 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004700:	1101                	addi	sp,sp,-32
    80004702:	ec06                	sd	ra,24(sp)
    80004704:	e822                	sd	s0,16(sp)
    80004706:	e426                	sd	s1,8(sp)
    80004708:	e04a                	sd	s2,0(sp)
    8000470a:	1000                	addi	s0,sp,32
    8000470c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000470e:	00850913          	addi	s2,a0,8
    80004712:	854a                	mv	a0,s2
    80004714:	ffffc097          	auipc	ra,0xffffc
    80004718:	4e8080e7          	jalr	1256(ra) # 80000bfc <acquire>
  lk->locked = 0;
    8000471c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004720:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004724:	8526                	mv	a0,s1
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	fb0080e7          	jalr	-80(ra) # 800026d6 <wakeup>
  release(&lk->lk);
    8000472e:	854a                	mv	a0,s2
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	580080e7          	jalr	1408(ra) # 80000cb0 <release>
}
    80004738:	60e2                	ld	ra,24(sp)
    8000473a:	6442                	ld	s0,16(sp)
    8000473c:	64a2                	ld	s1,8(sp)
    8000473e:	6902                	ld	s2,0(sp)
    80004740:	6105                	addi	sp,sp,32
    80004742:	8082                	ret

0000000080004744 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004744:	7179                	addi	sp,sp,-48
    80004746:	f406                	sd	ra,40(sp)
    80004748:	f022                	sd	s0,32(sp)
    8000474a:	ec26                	sd	s1,24(sp)
    8000474c:	e84a                	sd	s2,16(sp)
    8000474e:	e44e                	sd	s3,8(sp)
    80004750:	1800                	addi	s0,sp,48
    80004752:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004754:	00850913          	addi	s2,a0,8
    80004758:	854a                	mv	a0,s2
    8000475a:	ffffc097          	auipc	ra,0xffffc
    8000475e:	4a2080e7          	jalr	1186(ra) # 80000bfc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004762:	409c                	lw	a5,0(s1)
    80004764:	ef99                	bnez	a5,80004782 <holdingsleep+0x3e>
    80004766:	4481                	li	s1,0
  release(&lk->lk);
    80004768:	854a                	mv	a0,s2
    8000476a:	ffffc097          	auipc	ra,0xffffc
    8000476e:	546080e7          	jalr	1350(ra) # 80000cb0 <release>
  return r;
}
    80004772:	8526                	mv	a0,s1
    80004774:	70a2                	ld	ra,40(sp)
    80004776:	7402                	ld	s0,32(sp)
    80004778:	64e2                	ld	s1,24(sp)
    8000477a:	6942                	ld	s2,16(sp)
    8000477c:	69a2                	ld	s3,8(sp)
    8000477e:	6145                	addi	sp,sp,48
    80004780:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004782:	0284a983          	lw	s3,40(s1)
    80004786:	ffffd097          	auipc	ra,0xffffd
    8000478a:	642080e7          	jalr	1602(ra) # 80001dc8 <myproc>
    8000478e:	5d04                	lw	s1,56(a0)
    80004790:	413484b3          	sub	s1,s1,s3
    80004794:	0014b493          	seqz	s1,s1
    80004798:	bfc1                	j	80004768 <holdingsleep+0x24>

000000008000479a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000479a:	1141                	addi	sp,sp,-16
    8000479c:	e406                	sd	ra,8(sp)
    8000479e:	e022                	sd	s0,0(sp)
    800047a0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800047a2:	00004597          	auipc	a1,0x4
    800047a6:	f8658593          	addi	a1,a1,-122 # 80008728 <syscalls+0x238>
    800047aa:	0001e517          	auipc	a0,0x1e
    800047ae:	8ee50513          	addi	a0,a0,-1810 # 80022098 <ftable>
    800047b2:	ffffc097          	auipc	ra,0xffffc
    800047b6:	3ba080e7          	jalr	954(ra) # 80000b6c <initlock>
}
    800047ba:	60a2                	ld	ra,8(sp)
    800047bc:	6402                	ld	s0,0(sp)
    800047be:	0141                	addi	sp,sp,16
    800047c0:	8082                	ret

00000000800047c2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800047c2:	1101                	addi	sp,sp,-32
    800047c4:	ec06                	sd	ra,24(sp)
    800047c6:	e822                	sd	s0,16(sp)
    800047c8:	e426                	sd	s1,8(sp)
    800047ca:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800047cc:	0001e517          	auipc	a0,0x1e
    800047d0:	8cc50513          	addi	a0,a0,-1844 # 80022098 <ftable>
    800047d4:	ffffc097          	auipc	ra,0xffffc
    800047d8:	428080e7          	jalr	1064(ra) # 80000bfc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800047dc:	0001e497          	auipc	s1,0x1e
    800047e0:	8d448493          	addi	s1,s1,-1836 # 800220b0 <ftable+0x18>
    800047e4:	0001f717          	auipc	a4,0x1f
    800047e8:	86c70713          	addi	a4,a4,-1940 # 80023050 <ftable+0xfb8>
    if(f->ref == 0){
    800047ec:	40dc                	lw	a5,4(s1)
    800047ee:	cf99                	beqz	a5,8000480c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800047f0:	02848493          	addi	s1,s1,40
    800047f4:	fee49ce3          	bne	s1,a4,800047ec <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800047f8:	0001e517          	auipc	a0,0x1e
    800047fc:	8a050513          	addi	a0,a0,-1888 # 80022098 <ftable>
    80004800:	ffffc097          	auipc	ra,0xffffc
    80004804:	4b0080e7          	jalr	1200(ra) # 80000cb0 <release>
  return 0;
    80004808:	4481                	li	s1,0
    8000480a:	a819                	j	80004820 <filealloc+0x5e>
      f->ref = 1;
    8000480c:	4785                	li	a5,1
    8000480e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004810:	0001e517          	auipc	a0,0x1e
    80004814:	88850513          	addi	a0,a0,-1912 # 80022098 <ftable>
    80004818:	ffffc097          	auipc	ra,0xffffc
    8000481c:	498080e7          	jalr	1176(ra) # 80000cb0 <release>
}
    80004820:	8526                	mv	a0,s1
    80004822:	60e2                	ld	ra,24(sp)
    80004824:	6442                	ld	s0,16(sp)
    80004826:	64a2                	ld	s1,8(sp)
    80004828:	6105                	addi	sp,sp,32
    8000482a:	8082                	ret

000000008000482c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000482c:	1101                	addi	sp,sp,-32
    8000482e:	ec06                	sd	ra,24(sp)
    80004830:	e822                	sd	s0,16(sp)
    80004832:	e426                	sd	s1,8(sp)
    80004834:	1000                	addi	s0,sp,32
    80004836:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004838:	0001e517          	auipc	a0,0x1e
    8000483c:	86050513          	addi	a0,a0,-1952 # 80022098 <ftable>
    80004840:	ffffc097          	auipc	ra,0xffffc
    80004844:	3bc080e7          	jalr	956(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    80004848:	40dc                	lw	a5,4(s1)
    8000484a:	02f05263          	blez	a5,8000486e <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000484e:	2785                	addiw	a5,a5,1
    80004850:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004852:	0001e517          	auipc	a0,0x1e
    80004856:	84650513          	addi	a0,a0,-1978 # 80022098 <ftable>
    8000485a:	ffffc097          	auipc	ra,0xffffc
    8000485e:	456080e7          	jalr	1110(ra) # 80000cb0 <release>
  return f;
}
    80004862:	8526                	mv	a0,s1
    80004864:	60e2                	ld	ra,24(sp)
    80004866:	6442                	ld	s0,16(sp)
    80004868:	64a2                	ld	s1,8(sp)
    8000486a:	6105                	addi	sp,sp,32
    8000486c:	8082                	ret
    panic("filedup");
    8000486e:	00004517          	auipc	a0,0x4
    80004872:	ec250513          	addi	a0,a0,-318 # 80008730 <syscalls+0x240>
    80004876:	ffffc097          	auipc	ra,0xffffc
    8000487a:	cca080e7          	jalr	-822(ra) # 80000540 <panic>

000000008000487e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000487e:	7139                	addi	sp,sp,-64
    80004880:	fc06                	sd	ra,56(sp)
    80004882:	f822                	sd	s0,48(sp)
    80004884:	f426                	sd	s1,40(sp)
    80004886:	f04a                	sd	s2,32(sp)
    80004888:	ec4e                	sd	s3,24(sp)
    8000488a:	e852                	sd	s4,16(sp)
    8000488c:	e456                	sd	s5,8(sp)
    8000488e:	0080                	addi	s0,sp,64
    80004890:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004892:	0001e517          	auipc	a0,0x1e
    80004896:	80650513          	addi	a0,a0,-2042 # 80022098 <ftable>
    8000489a:	ffffc097          	auipc	ra,0xffffc
    8000489e:	362080e7          	jalr	866(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    800048a2:	40dc                	lw	a5,4(s1)
    800048a4:	06f05163          	blez	a5,80004906 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800048a8:	37fd                	addiw	a5,a5,-1
    800048aa:	0007871b          	sext.w	a4,a5
    800048ae:	c0dc                	sw	a5,4(s1)
    800048b0:	06e04363          	bgtz	a4,80004916 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800048b4:	0004a903          	lw	s2,0(s1)
    800048b8:	0094ca83          	lbu	s5,9(s1)
    800048bc:	0104ba03          	ld	s4,16(s1)
    800048c0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800048c4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800048c8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800048cc:	0001d517          	auipc	a0,0x1d
    800048d0:	7cc50513          	addi	a0,a0,1996 # 80022098 <ftable>
    800048d4:	ffffc097          	auipc	ra,0xffffc
    800048d8:	3dc080e7          	jalr	988(ra) # 80000cb0 <release>

  if(ff.type == FD_PIPE){
    800048dc:	4785                	li	a5,1
    800048de:	04f90d63          	beq	s2,a5,80004938 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800048e2:	3979                	addiw	s2,s2,-2
    800048e4:	4785                	li	a5,1
    800048e6:	0527e063          	bltu	a5,s2,80004926 <fileclose+0xa8>
    begin_op();
    800048ea:	00000097          	auipc	ra,0x0
    800048ee:	ac2080e7          	jalr	-1342(ra) # 800043ac <begin_op>
    iput(ff.ip);
    800048f2:	854e                	mv	a0,s3
    800048f4:	fffff097          	auipc	ra,0xfffff
    800048f8:	2b2080e7          	jalr	690(ra) # 80003ba6 <iput>
    end_op();
    800048fc:	00000097          	auipc	ra,0x0
    80004900:	b30080e7          	jalr	-1232(ra) # 8000442c <end_op>
    80004904:	a00d                	j	80004926 <fileclose+0xa8>
    panic("fileclose");
    80004906:	00004517          	auipc	a0,0x4
    8000490a:	e3250513          	addi	a0,a0,-462 # 80008738 <syscalls+0x248>
    8000490e:	ffffc097          	auipc	ra,0xffffc
    80004912:	c32080e7          	jalr	-974(ra) # 80000540 <panic>
    release(&ftable.lock);
    80004916:	0001d517          	auipc	a0,0x1d
    8000491a:	78250513          	addi	a0,a0,1922 # 80022098 <ftable>
    8000491e:	ffffc097          	auipc	ra,0xffffc
    80004922:	392080e7          	jalr	914(ra) # 80000cb0 <release>
  }
}
    80004926:	70e2                	ld	ra,56(sp)
    80004928:	7442                	ld	s0,48(sp)
    8000492a:	74a2                	ld	s1,40(sp)
    8000492c:	7902                	ld	s2,32(sp)
    8000492e:	69e2                	ld	s3,24(sp)
    80004930:	6a42                	ld	s4,16(sp)
    80004932:	6aa2                	ld	s5,8(sp)
    80004934:	6121                	addi	sp,sp,64
    80004936:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004938:	85d6                	mv	a1,s5
    8000493a:	8552                	mv	a0,s4
    8000493c:	00000097          	auipc	ra,0x0
    80004940:	372080e7          	jalr	882(ra) # 80004cae <pipeclose>
    80004944:	b7cd                	j	80004926 <fileclose+0xa8>

0000000080004946 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004946:	715d                	addi	sp,sp,-80
    80004948:	e486                	sd	ra,72(sp)
    8000494a:	e0a2                	sd	s0,64(sp)
    8000494c:	fc26                	sd	s1,56(sp)
    8000494e:	f84a                	sd	s2,48(sp)
    80004950:	f44e                	sd	s3,40(sp)
    80004952:	0880                	addi	s0,sp,80
    80004954:	84aa                	mv	s1,a0
    80004956:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004958:	ffffd097          	auipc	ra,0xffffd
    8000495c:	470080e7          	jalr	1136(ra) # 80001dc8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004960:	409c                	lw	a5,0(s1)
    80004962:	37f9                	addiw	a5,a5,-2
    80004964:	4705                	li	a4,1
    80004966:	04f76763          	bltu	a4,a5,800049b4 <filestat+0x6e>
    8000496a:	892a                	mv	s2,a0
    ilock(f->ip);
    8000496c:	6c88                	ld	a0,24(s1)
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	07e080e7          	jalr	126(ra) # 800039ec <ilock>
    stati(f->ip, &st);
    80004976:	fb840593          	addi	a1,s0,-72
    8000497a:	6c88                	ld	a0,24(s1)
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	2fa080e7          	jalr	762(ra) # 80003c76 <stati>
    iunlock(f->ip);
    80004984:	6c88                	ld	a0,24(s1)
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	128080e7          	jalr	296(ra) # 80003aae <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000498e:	46e1                	li	a3,24
    80004990:	fb840613          	addi	a2,s0,-72
    80004994:	85ce                	mv	a1,s3
    80004996:	05093503          	ld	a0,80(s2)
    8000499a:	ffffd097          	auipc	ra,0xffffd
    8000499e:	d10080e7          	jalr	-752(ra) # 800016aa <copyout>
    800049a2:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800049a6:	60a6                	ld	ra,72(sp)
    800049a8:	6406                	ld	s0,64(sp)
    800049aa:	74e2                	ld	s1,56(sp)
    800049ac:	7942                	ld	s2,48(sp)
    800049ae:	79a2                	ld	s3,40(sp)
    800049b0:	6161                	addi	sp,sp,80
    800049b2:	8082                	ret
  return -1;
    800049b4:	557d                	li	a0,-1
    800049b6:	bfc5                	j	800049a6 <filestat+0x60>

00000000800049b8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800049b8:	7179                	addi	sp,sp,-48
    800049ba:	f406                	sd	ra,40(sp)
    800049bc:	f022                	sd	s0,32(sp)
    800049be:	ec26                	sd	s1,24(sp)
    800049c0:	e84a                	sd	s2,16(sp)
    800049c2:	e44e                	sd	s3,8(sp)
    800049c4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800049c6:	00854783          	lbu	a5,8(a0)
    800049ca:	c3d5                	beqz	a5,80004a6e <fileread+0xb6>
    800049cc:	84aa                	mv	s1,a0
    800049ce:	89ae                	mv	s3,a1
    800049d0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800049d2:	411c                	lw	a5,0(a0)
    800049d4:	4705                	li	a4,1
    800049d6:	04e78963          	beq	a5,a4,80004a28 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800049da:	470d                	li	a4,3
    800049dc:	04e78d63          	beq	a5,a4,80004a36 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800049e0:	4709                	li	a4,2
    800049e2:	06e79e63          	bne	a5,a4,80004a5e <fileread+0xa6>
    ilock(f->ip);
    800049e6:	6d08                	ld	a0,24(a0)
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	004080e7          	jalr	4(ra) # 800039ec <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800049f0:	874a                	mv	a4,s2
    800049f2:	5094                	lw	a3,32(s1)
    800049f4:	864e                	mv	a2,s3
    800049f6:	4585                	li	a1,1
    800049f8:	6c88                	ld	a0,24(s1)
    800049fa:	fffff097          	auipc	ra,0xfffff
    800049fe:	2a6080e7          	jalr	678(ra) # 80003ca0 <readi>
    80004a02:	892a                	mv	s2,a0
    80004a04:	00a05563          	blez	a0,80004a0e <fileread+0x56>
      f->off += r;
    80004a08:	509c                	lw	a5,32(s1)
    80004a0a:	9fa9                	addw	a5,a5,a0
    80004a0c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004a0e:	6c88                	ld	a0,24(s1)
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	09e080e7          	jalr	158(ra) # 80003aae <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004a18:	854a                	mv	a0,s2
    80004a1a:	70a2                	ld	ra,40(sp)
    80004a1c:	7402                	ld	s0,32(sp)
    80004a1e:	64e2                	ld	s1,24(sp)
    80004a20:	6942                	ld	s2,16(sp)
    80004a22:	69a2                	ld	s3,8(sp)
    80004a24:	6145                	addi	sp,sp,48
    80004a26:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004a28:	6908                	ld	a0,16(a0)
    80004a2a:	00000097          	auipc	ra,0x0
    80004a2e:	3f4080e7          	jalr	1012(ra) # 80004e1e <piperead>
    80004a32:	892a                	mv	s2,a0
    80004a34:	b7d5                	j	80004a18 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004a36:	02451783          	lh	a5,36(a0)
    80004a3a:	03079693          	slli	a3,a5,0x30
    80004a3e:	92c1                	srli	a3,a3,0x30
    80004a40:	4725                	li	a4,9
    80004a42:	02d76863          	bltu	a4,a3,80004a72 <fileread+0xba>
    80004a46:	0792                	slli	a5,a5,0x4
    80004a48:	0001d717          	auipc	a4,0x1d
    80004a4c:	5b070713          	addi	a4,a4,1456 # 80021ff8 <devsw>
    80004a50:	97ba                	add	a5,a5,a4
    80004a52:	639c                	ld	a5,0(a5)
    80004a54:	c38d                	beqz	a5,80004a76 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004a56:	4505                	li	a0,1
    80004a58:	9782                	jalr	a5
    80004a5a:	892a                	mv	s2,a0
    80004a5c:	bf75                	j	80004a18 <fileread+0x60>
    panic("fileread");
    80004a5e:	00004517          	auipc	a0,0x4
    80004a62:	cea50513          	addi	a0,a0,-790 # 80008748 <syscalls+0x258>
    80004a66:	ffffc097          	auipc	ra,0xffffc
    80004a6a:	ada080e7          	jalr	-1318(ra) # 80000540 <panic>
    return -1;
    80004a6e:	597d                	li	s2,-1
    80004a70:	b765                	j	80004a18 <fileread+0x60>
      return -1;
    80004a72:	597d                	li	s2,-1
    80004a74:	b755                	j	80004a18 <fileread+0x60>
    80004a76:	597d                	li	s2,-1
    80004a78:	b745                	j	80004a18 <fileread+0x60>

0000000080004a7a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004a7a:	00954783          	lbu	a5,9(a0)
    80004a7e:	14078563          	beqz	a5,80004bc8 <filewrite+0x14e>
{
    80004a82:	715d                	addi	sp,sp,-80
    80004a84:	e486                	sd	ra,72(sp)
    80004a86:	e0a2                	sd	s0,64(sp)
    80004a88:	fc26                	sd	s1,56(sp)
    80004a8a:	f84a                	sd	s2,48(sp)
    80004a8c:	f44e                	sd	s3,40(sp)
    80004a8e:	f052                	sd	s4,32(sp)
    80004a90:	ec56                	sd	s5,24(sp)
    80004a92:	e85a                	sd	s6,16(sp)
    80004a94:	e45e                	sd	s7,8(sp)
    80004a96:	e062                	sd	s8,0(sp)
    80004a98:	0880                	addi	s0,sp,80
    80004a9a:	892a                	mv	s2,a0
    80004a9c:	8aae                	mv	s5,a1
    80004a9e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004aa0:	411c                	lw	a5,0(a0)
    80004aa2:	4705                	li	a4,1
    80004aa4:	02e78263          	beq	a5,a4,80004ac8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004aa8:	470d                	li	a4,3
    80004aaa:	02e78563          	beq	a5,a4,80004ad4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004aae:	4709                	li	a4,2
    80004ab0:	10e79463          	bne	a5,a4,80004bb8 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004ab4:	0ec05e63          	blez	a2,80004bb0 <filewrite+0x136>
    int i = 0;
    80004ab8:	4981                	li	s3,0
    80004aba:	6b05                	lui	s6,0x1
    80004abc:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004ac0:	6b85                	lui	s7,0x1
    80004ac2:	c00b8b9b          	addiw	s7,s7,-1024
    80004ac6:	a851                	j	80004b5a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004ac8:	6908                	ld	a0,16(a0)
    80004aca:	00000097          	auipc	ra,0x0
    80004ace:	254080e7          	jalr	596(ra) # 80004d1e <pipewrite>
    80004ad2:	a85d                	j	80004b88 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004ad4:	02451783          	lh	a5,36(a0)
    80004ad8:	03079693          	slli	a3,a5,0x30
    80004adc:	92c1                	srli	a3,a3,0x30
    80004ade:	4725                	li	a4,9
    80004ae0:	0ed76663          	bltu	a4,a3,80004bcc <filewrite+0x152>
    80004ae4:	0792                	slli	a5,a5,0x4
    80004ae6:	0001d717          	auipc	a4,0x1d
    80004aea:	51270713          	addi	a4,a4,1298 # 80021ff8 <devsw>
    80004aee:	97ba                	add	a5,a5,a4
    80004af0:	679c                	ld	a5,8(a5)
    80004af2:	cff9                	beqz	a5,80004bd0 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004af4:	4505                	li	a0,1
    80004af6:	9782                	jalr	a5
    80004af8:	a841                	j	80004b88 <filewrite+0x10e>
    80004afa:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004afe:	00000097          	auipc	ra,0x0
    80004b02:	8ae080e7          	jalr	-1874(ra) # 800043ac <begin_op>
      ilock(f->ip);
    80004b06:	01893503          	ld	a0,24(s2)
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	ee2080e7          	jalr	-286(ra) # 800039ec <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004b12:	8762                	mv	a4,s8
    80004b14:	02092683          	lw	a3,32(s2)
    80004b18:	01598633          	add	a2,s3,s5
    80004b1c:	4585                	li	a1,1
    80004b1e:	01893503          	ld	a0,24(s2)
    80004b22:	fffff097          	auipc	ra,0xfffff
    80004b26:	274080e7          	jalr	628(ra) # 80003d96 <writei>
    80004b2a:	84aa                	mv	s1,a0
    80004b2c:	02a05f63          	blez	a0,80004b6a <filewrite+0xf0>
        f->off += r;
    80004b30:	02092783          	lw	a5,32(s2)
    80004b34:	9fa9                	addw	a5,a5,a0
    80004b36:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004b3a:	01893503          	ld	a0,24(s2)
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	f70080e7          	jalr	-144(ra) # 80003aae <iunlock>
      end_op();
    80004b46:	00000097          	auipc	ra,0x0
    80004b4a:	8e6080e7          	jalr	-1818(ra) # 8000442c <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004b4e:	049c1963          	bne	s8,s1,80004ba0 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004b52:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004b56:	0349d663          	bge	s3,s4,80004b82 <filewrite+0x108>
      int n1 = n - i;
    80004b5a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004b5e:	84be                	mv	s1,a5
    80004b60:	2781                	sext.w	a5,a5
    80004b62:	f8fb5ce3          	bge	s6,a5,80004afa <filewrite+0x80>
    80004b66:	84de                	mv	s1,s7
    80004b68:	bf49                	j	80004afa <filewrite+0x80>
      iunlock(f->ip);
    80004b6a:	01893503          	ld	a0,24(s2)
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	f40080e7          	jalr	-192(ra) # 80003aae <iunlock>
      end_op();
    80004b76:	00000097          	auipc	ra,0x0
    80004b7a:	8b6080e7          	jalr	-1866(ra) # 8000442c <end_op>
      if(r < 0)
    80004b7e:	fc04d8e3          	bgez	s1,80004b4e <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004b82:	8552                	mv	a0,s4
    80004b84:	033a1863          	bne	s4,s3,80004bb4 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004b88:	60a6                	ld	ra,72(sp)
    80004b8a:	6406                	ld	s0,64(sp)
    80004b8c:	74e2                	ld	s1,56(sp)
    80004b8e:	7942                	ld	s2,48(sp)
    80004b90:	79a2                	ld	s3,40(sp)
    80004b92:	7a02                	ld	s4,32(sp)
    80004b94:	6ae2                	ld	s5,24(sp)
    80004b96:	6b42                	ld	s6,16(sp)
    80004b98:	6ba2                	ld	s7,8(sp)
    80004b9a:	6c02                	ld	s8,0(sp)
    80004b9c:	6161                	addi	sp,sp,80
    80004b9e:	8082                	ret
        panic("short filewrite");
    80004ba0:	00004517          	auipc	a0,0x4
    80004ba4:	bb850513          	addi	a0,a0,-1096 # 80008758 <syscalls+0x268>
    80004ba8:	ffffc097          	auipc	ra,0xffffc
    80004bac:	998080e7          	jalr	-1640(ra) # 80000540 <panic>
    int i = 0;
    80004bb0:	4981                	li	s3,0
    80004bb2:	bfc1                	j	80004b82 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004bb4:	557d                	li	a0,-1
    80004bb6:	bfc9                	j	80004b88 <filewrite+0x10e>
    panic("filewrite");
    80004bb8:	00004517          	auipc	a0,0x4
    80004bbc:	bb050513          	addi	a0,a0,-1104 # 80008768 <syscalls+0x278>
    80004bc0:	ffffc097          	auipc	ra,0xffffc
    80004bc4:	980080e7          	jalr	-1664(ra) # 80000540 <panic>
    return -1;
    80004bc8:	557d                	li	a0,-1
}
    80004bca:	8082                	ret
      return -1;
    80004bcc:	557d                	li	a0,-1
    80004bce:	bf6d                	j	80004b88 <filewrite+0x10e>
    80004bd0:	557d                	li	a0,-1
    80004bd2:	bf5d                	j	80004b88 <filewrite+0x10e>

0000000080004bd4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004bd4:	7179                	addi	sp,sp,-48
    80004bd6:	f406                	sd	ra,40(sp)
    80004bd8:	f022                	sd	s0,32(sp)
    80004bda:	ec26                	sd	s1,24(sp)
    80004bdc:	e84a                	sd	s2,16(sp)
    80004bde:	e44e                	sd	s3,8(sp)
    80004be0:	e052                	sd	s4,0(sp)
    80004be2:	1800                	addi	s0,sp,48
    80004be4:	84aa                	mv	s1,a0
    80004be6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004be8:	0005b023          	sd	zero,0(a1)
    80004bec:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004bf0:	00000097          	auipc	ra,0x0
    80004bf4:	bd2080e7          	jalr	-1070(ra) # 800047c2 <filealloc>
    80004bf8:	e088                	sd	a0,0(s1)
    80004bfa:	c551                	beqz	a0,80004c86 <pipealloc+0xb2>
    80004bfc:	00000097          	auipc	ra,0x0
    80004c00:	bc6080e7          	jalr	-1082(ra) # 800047c2 <filealloc>
    80004c04:	00aa3023          	sd	a0,0(s4)
    80004c08:	c92d                	beqz	a0,80004c7a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004c0a:	ffffc097          	auipc	ra,0xffffc
    80004c0e:	f02080e7          	jalr	-254(ra) # 80000b0c <kalloc>
    80004c12:	892a                	mv	s2,a0
    80004c14:	c125                	beqz	a0,80004c74 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004c16:	4985                	li	s3,1
    80004c18:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004c1c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004c20:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004c24:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004c28:	00004597          	auipc	a1,0x4
    80004c2c:	b5058593          	addi	a1,a1,-1200 # 80008778 <syscalls+0x288>
    80004c30:	ffffc097          	auipc	ra,0xffffc
    80004c34:	f3c080e7          	jalr	-196(ra) # 80000b6c <initlock>
  (*f0)->type = FD_PIPE;
    80004c38:	609c                	ld	a5,0(s1)
    80004c3a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004c3e:	609c                	ld	a5,0(s1)
    80004c40:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004c44:	609c                	ld	a5,0(s1)
    80004c46:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004c4a:	609c                	ld	a5,0(s1)
    80004c4c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004c50:	000a3783          	ld	a5,0(s4)
    80004c54:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004c58:	000a3783          	ld	a5,0(s4)
    80004c5c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004c60:	000a3783          	ld	a5,0(s4)
    80004c64:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004c68:	000a3783          	ld	a5,0(s4)
    80004c6c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004c70:	4501                	li	a0,0
    80004c72:	a025                	j	80004c9a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004c74:	6088                	ld	a0,0(s1)
    80004c76:	e501                	bnez	a0,80004c7e <pipealloc+0xaa>
    80004c78:	a039                	j	80004c86 <pipealloc+0xb2>
    80004c7a:	6088                	ld	a0,0(s1)
    80004c7c:	c51d                	beqz	a0,80004caa <pipealloc+0xd6>
    fileclose(*f0);
    80004c7e:	00000097          	auipc	ra,0x0
    80004c82:	c00080e7          	jalr	-1024(ra) # 8000487e <fileclose>
  if(*f1)
    80004c86:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004c8a:	557d                	li	a0,-1
  if(*f1)
    80004c8c:	c799                	beqz	a5,80004c9a <pipealloc+0xc6>
    fileclose(*f1);
    80004c8e:	853e                	mv	a0,a5
    80004c90:	00000097          	auipc	ra,0x0
    80004c94:	bee080e7          	jalr	-1042(ra) # 8000487e <fileclose>
  return -1;
    80004c98:	557d                	li	a0,-1
}
    80004c9a:	70a2                	ld	ra,40(sp)
    80004c9c:	7402                	ld	s0,32(sp)
    80004c9e:	64e2                	ld	s1,24(sp)
    80004ca0:	6942                	ld	s2,16(sp)
    80004ca2:	69a2                	ld	s3,8(sp)
    80004ca4:	6a02                	ld	s4,0(sp)
    80004ca6:	6145                	addi	sp,sp,48
    80004ca8:	8082                	ret
  return -1;
    80004caa:	557d                	li	a0,-1
    80004cac:	b7fd                	j	80004c9a <pipealloc+0xc6>

0000000080004cae <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004cae:	1101                	addi	sp,sp,-32
    80004cb0:	ec06                	sd	ra,24(sp)
    80004cb2:	e822                	sd	s0,16(sp)
    80004cb4:	e426                	sd	s1,8(sp)
    80004cb6:	e04a                	sd	s2,0(sp)
    80004cb8:	1000                	addi	s0,sp,32
    80004cba:	84aa                	mv	s1,a0
    80004cbc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004cbe:	ffffc097          	auipc	ra,0xffffc
    80004cc2:	f3e080e7          	jalr	-194(ra) # 80000bfc <acquire>
  if(writable){
    80004cc6:	02090d63          	beqz	s2,80004d00 <pipeclose+0x52>
    pi->writeopen = 0;
    80004cca:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004cce:	21848513          	addi	a0,s1,536
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	a04080e7          	jalr	-1532(ra) # 800026d6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004cda:	2204b783          	ld	a5,544(s1)
    80004cde:	eb95                	bnez	a5,80004d12 <pipeclose+0x64>
    release(&pi->lock);
    80004ce0:	8526                	mv	a0,s1
    80004ce2:	ffffc097          	auipc	ra,0xffffc
    80004ce6:	fce080e7          	jalr	-50(ra) # 80000cb0 <release>
    kfree((char*)pi);
    80004cea:	8526                	mv	a0,s1
    80004cec:	ffffc097          	auipc	ra,0xffffc
    80004cf0:	d24080e7          	jalr	-732(ra) # 80000a10 <kfree>
  } else
    release(&pi->lock);
}
    80004cf4:	60e2                	ld	ra,24(sp)
    80004cf6:	6442                	ld	s0,16(sp)
    80004cf8:	64a2                	ld	s1,8(sp)
    80004cfa:	6902                	ld	s2,0(sp)
    80004cfc:	6105                	addi	sp,sp,32
    80004cfe:	8082                	ret
    pi->readopen = 0;
    80004d00:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004d04:	21c48513          	addi	a0,s1,540
    80004d08:	ffffe097          	auipc	ra,0xffffe
    80004d0c:	9ce080e7          	jalr	-1586(ra) # 800026d6 <wakeup>
    80004d10:	b7e9                	j	80004cda <pipeclose+0x2c>
    release(&pi->lock);
    80004d12:	8526                	mv	a0,s1
    80004d14:	ffffc097          	auipc	ra,0xffffc
    80004d18:	f9c080e7          	jalr	-100(ra) # 80000cb0 <release>
}
    80004d1c:	bfe1                	j	80004cf4 <pipeclose+0x46>

0000000080004d1e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004d1e:	711d                	addi	sp,sp,-96
    80004d20:	ec86                	sd	ra,88(sp)
    80004d22:	e8a2                	sd	s0,80(sp)
    80004d24:	e4a6                	sd	s1,72(sp)
    80004d26:	e0ca                	sd	s2,64(sp)
    80004d28:	fc4e                	sd	s3,56(sp)
    80004d2a:	f852                	sd	s4,48(sp)
    80004d2c:	f456                	sd	s5,40(sp)
    80004d2e:	f05a                	sd	s6,32(sp)
    80004d30:	ec5e                	sd	s7,24(sp)
    80004d32:	e862                	sd	s8,16(sp)
    80004d34:	1080                	addi	s0,sp,96
    80004d36:	84aa                	mv	s1,a0
    80004d38:	8b2e                	mv	s6,a1
    80004d3a:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004d3c:	ffffd097          	auipc	ra,0xffffd
    80004d40:	08c080e7          	jalr	140(ra) # 80001dc8 <myproc>
    80004d44:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004d46:	8526                	mv	a0,s1
    80004d48:	ffffc097          	auipc	ra,0xffffc
    80004d4c:	eb4080e7          	jalr	-332(ra) # 80000bfc <acquire>
  for(i = 0; i < n; i++){
    80004d50:	09505763          	blez	s5,80004dde <pipewrite+0xc0>
    80004d54:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004d56:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004d5a:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d5e:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004d60:	2184a783          	lw	a5,536(s1)
    80004d64:	21c4a703          	lw	a4,540(s1)
    80004d68:	2007879b          	addiw	a5,a5,512
    80004d6c:	02f71b63          	bne	a4,a5,80004da2 <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    80004d70:	2204a783          	lw	a5,544(s1)
    80004d74:	c3d1                	beqz	a5,80004df8 <pipewrite+0xda>
    80004d76:	03092783          	lw	a5,48(s2)
    80004d7a:	efbd                	bnez	a5,80004df8 <pipewrite+0xda>
      wakeup(&pi->nread);
    80004d7c:	8552                	mv	a0,s4
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	958080e7          	jalr	-1704(ra) # 800026d6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004d86:	85a6                	mv	a1,s1
    80004d88:	854e                	mv	a0,s3
    80004d8a:	ffffd097          	auipc	ra,0xffffd
    80004d8e:	7cc080e7          	jalr	1996(ra) # 80002556 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004d92:	2184a783          	lw	a5,536(s1)
    80004d96:	21c4a703          	lw	a4,540(s1)
    80004d9a:	2007879b          	addiw	a5,a5,512
    80004d9e:	fcf709e3          	beq	a4,a5,80004d70 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004da2:	4685                	li	a3,1
    80004da4:	865a                	mv	a2,s6
    80004da6:	faf40593          	addi	a1,s0,-81
    80004daa:	05093503          	ld	a0,80(s2)
    80004dae:	ffffd097          	auipc	ra,0xffffd
    80004db2:	988080e7          	jalr	-1656(ra) # 80001736 <copyin>
    80004db6:	03850563          	beq	a0,s8,80004de0 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004dba:	21c4a783          	lw	a5,540(s1)
    80004dbe:	0017871b          	addiw	a4,a5,1
    80004dc2:	20e4ae23          	sw	a4,540(s1)
    80004dc6:	1ff7f793          	andi	a5,a5,511
    80004dca:	97a6                	add	a5,a5,s1
    80004dcc:	faf44703          	lbu	a4,-81(s0)
    80004dd0:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004dd4:	2b85                	addiw	s7,s7,1
    80004dd6:	0b05                	addi	s6,s6,1
    80004dd8:	f97a94e3          	bne	s5,s7,80004d60 <pipewrite+0x42>
    80004ddc:	a011                	j	80004de0 <pipewrite+0xc2>
    80004dde:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    80004de0:	21848513          	addi	a0,s1,536
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	8f2080e7          	jalr	-1806(ra) # 800026d6 <wakeup>
  release(&pi->lock);
    80004dec:	8526                	mv	a0,s1
    80004dee:	ffffc097          	auipc	ra,0xffffc
    80004df2:	ec2080e7          	jalr	-318(ra) # 80000cb0 <release>
  return i;
    80004df6:	a039                	j	80004e04 <pipewrite+0xe6>
        release(&pi->lock);
    80004df8:	8526                	mv	a0,s1
    80004dfa:	ffffc097          	auipc	ra,0xffffc
    80004dfe:	eb6080e7          	jalr	-330(ra) # 80000cb0 <release>
        return -1;
    80004e02:	5bfd                	li	s7,-1
}
    80004e04:	855e                	mv	a0,s7
    80004e06:	60e6                	ld	ra,88(sp)
    80004e08:	6446                	ld	s0,80(sp)
    80004e0a:	64a6                	ld	s1,72(sp)
    80004e0c:	6906                	ld	s2,64(sp)
    80004e0e:	79e2                	ld	s3,56(sp)
    80004e10:	7a42                	ld	s4,48(sp)
    80004e12:	7aa2                	ld	s5,40(sp)
    80004e14:	7b02                	ld	s6,32(sp)
    80004e16:	6be2                	ld	s7,24(sp)
    80004e18:	6c42                	ld	s8,16(sp)
    80004e1a:	6125                	addi	sp,sp,96
    80004e1c:	8082                	ret

0000000080004e1e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004e1e:	715d                	addi	sp,sp,-80
    80004e20:	e486                	sd	ra,72(sp)
    80004e22:	e0a2                	sd	s0,64(sp)
    80004e24:	fc26                	sd	s1,56(sp)
    80004e26:	f84a                	sd	s2,48(sp)
    80004e28:	f44e                	sd	s3,40(sp)
    80004e2a:	f052                	sd	s4,32(sp)
    80004e2c:	ec56                	sd	s5,24(sp)
    80004e2e:	e85a                	sd	s6,16(sp)
    80004e30:	0880                	addi	s0,sp,80
    80004e32:	84aa                	mv	s1,a0
    80004e34:	892e                	mv	s2,a1
    80004e36:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004e38:	ffffd097          	auipc	ra,0xffffd
    80004e3c:	f90080e7          	jalr	-112(ra) # 80001dc8 <myproc>
    80004e40:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004e42:	8526                	mv	a0,s1
    80004e44:	ffffc097          	auipc	ra,0xffffc
    80004e48:	db8080e7          	jalr	-584(ra) # 80000bfc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e4c:	2184a703          	lw	a4,536(s1)
    80004e50:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e54:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e58:	02f71463          	bne	a4,a5,80004e80 <piperead+0x62>
    80004e5c:	2244a783          	lw	a5,548(s1)
    80004e60:	c385                	beqz	a5,80004e80 <piperead+0x62>
    if(pr->killed){
    80004e62:	030a2783          	lw	a5,48(s4)
    80004e66:	ebc1                	bnez	a5,80004ef6 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e68:	85a6                	mv	a1,s1
    80004e6a:	854e                	mv	a0,s3
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	6ea080e7          	jalr	1770(ra) # 80002556 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e74:	2184a703          	lw	a4,536(s1)
    80004e78:	21c4a783          	lw	a5,540(s1)
    80004e7c:	fef700e3          	beq	a4,a5,80004e5c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e80:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e82:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e84:	05505363          	blez	s5,80004eca <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004e88:	2184a783          	lw	a5,536(s1)
    80004e8c:	21c4a703          	lw	a4,540(s1)
    80004e90:	02f70d63          	beq	a4,a5,80004eca <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004e94:	0017871b          	addiw	a4,a5,1
    80004e98:	20e4ac23          	sw	a4,536(s1)
    80004e9c:	1ff7f793          	andi	a5,a5,511
    80004ea0:	97a6                	add	a5,a5,s1
    80004ea2:	0187c783          	lbu	a5,24(a5)
    80004ea6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004eaa:	4685                	li	a3,1
    80004eac:	fbf40613          	addi	a2,s0,-65
    80004eb0:	85ca                	mv	a1,s2
    80004eb2:	050a3503          	ld	a0,80(s4)
    80004eb6:	ffffc097          	auipc	ra,0xffffc
    80004eba:	7f4080e7          	jalr	2036(ra) # 800016aa <copyout>
    80004ebe:	01650663          	beq	a0,s6,80004eca <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ec2:	2985                	addiw	s3,s3,1
    80004ec4:	0905                	addi	s2,s2,1
    80004ec6:	fd3a91e3          	bne	s5,s3,80004e88 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004eca:	21c48513          	addi	a0,s1,540
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	808080e7          	jalr	-2040(ra) # 800026d6 <wakeup>
  release(&pi->lock);
    80004ed6:	8526                	mv	a0,s1
    80004ed8:	ffffc097          	auipc	ra,0xffffc
    80004edc:	dd8080e7          	jalr	-552(ra) # 80000cb0 <release>
  return i;
}
    80004ee0:	854e                	mv	a0,s3
    80004ee2:	60a6                	ld	ra,72(sp)
    80004ee4:	6406                	ld	s0,64(sp)
    80004ee6:	74e2                	ld	s1,56(sp)
    80004ee8:	7942                	ld	s2,48(sp)
    80004eea:	79a2                	ld	s3,40(sp)
    80004eec:	7a02                	ld	s4,32(sp)
    80004eee:	6ae2                	ld	s5,24(sp)
    80004ef0:	6b42                	ld	s6,16(sp)
    80004ef2:	6161                	addi	sp,sp,80
    80004ef4:	8082                	ret
      release(&pi->lock);
    80004ef6:	8526                	mv	a0,s1
    80004ef8:	ffffc097          	auipc	ra,0xffffc
    80004efc:	db8080e7          	jalr	-584(ra) # 80000cb0 <release>
      return -1;
    80004f00:	59fd                	li	s3,-1
    80004f02:	bff9                	j	80004ee0 <piperead+0xc2>

0000000080004f04 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004f04:	de010113          	addi	sp,sp,-544
    80004f08:	20113c23          	sd	ra,536(sp)
    80004f0c:	20813823          	sd	s0,528(sp)
    80004f10:	20913423          	sd	s1,520(sp)
    80004f14:	21213023          	sd	s2,512(sp)
    80004f18:	ffce                	sd	s3,504(sp)
    80004f1a:	fbd2                	sd	s4,496(sp)
    80004f1c:	f7d6                	sd	s5,488(sp)
    80004f1e:	f3da                	sd	s6,480(sp)
    80004f20:	efde                	sd	s7,472(sp)
    80004f22:	ebe2                	sd	s8,464(sp)
    80004f24:	e7e6                	sd	s9,456(sp)
    80004f26:	e3ea                	sd	s10,448(sp)
    80004f28:	ff6e                	sd	s11,440(sp)
    80004f2a:	1400                	addi	s0,sp,544
    80004f2c:	892a                	mv	s2,a0
    80004f2e:	dea43423          	sd	a0,-536(s0)
    80004f32:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004f36:	ffffd097          	auipc	ra,0xffffd
    80004f3a:	e92080e7          	jalr	-366(ra) # 80001dc8 <myproc>
    80004f3e:	84aa                	mv	s1,a0

  begin_op();
    80004f40:	fffff097          	auipc	ra,0xfffff
    80004f44:	46c080e7          	jalr	1132(ra) # 800043ac <begin_op>

  if((ip = namei(path)) == 0){
    80004f48:	854a                	mv	a0,s2
    80004f4a:	fffff097          	auipc	ra,0xfffff
    80004f4e:	252080e7          	jalr	594(ra) # 8000419c <namei>
    80004f52:	c93d                	beqz	a0,80004fc8 <exec+0xc4>
    80004f54:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004f56:	fffff097          	auipc	ra,0xfffff
    80004f5a:	a96080e7          	jalr	-1386(ra) # 800039ec <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004f5e:	04000713          	li	a4,64
    80004f62:	4681                	li	a3,0
    80004f64:	e4840613          	addi	a2,s0,-440
    80004f68:	4581                	li	a1,0
    80004f6a:	8556                	mv	a0,s5
    80004f6c:	fffff097          	auipc	ra,0xfffff
    80004f70:	d34080e7          	jalr	-716(ra) # 80003ca0 <readi>
    80004f74:	04000793          	li	a5,64
    80004f78:	00f51a63          	bne	a0,a5,80004f8c <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004f7c:	e4842703          	lw	a4,-440(s0)
    80004f80:	464c47b7          	lui	a5,0x464c4
    80004f84:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004f88:	04f70663          	beq	a4,a5,80004fd4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004f8c:	8556                	mv	a0,s5
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	cc0080e7          	jalr	-832(ra) # 80003c4e <iunlockput>
    end_op();
    80004f96:	fffff097          	auipc	ra,0xfffff
    80004f9a:	496080e7          	jalr	1174(ra) # 8000442c <end_op>
  }
  return -1;
    80004f9e:	557d                	li	a0,-1
}
    80004fa0:	21813083          	ld	ra,536(sp)
    80004fa4:	21013403          	ld	s0,528(sp)
    80004fa8:	20813483          	ld	s1,520(sp)
    80004fac:	20013903          	ld	s2,512(sp)
    80004fb0:	79fe                	ld	s3,504(sp)
    80004fb2:	7a5e                	ld	s4,496(sp)
    80004fb4:	7abe                	ld	s5,488(sp)
    80004fb6:	7b1e                	ld	s6,480(sp)
    80004fb8:	6bfe                	ld	s7,472(sp)
    80004fba:	6c5e                	ld	s8,464(sp)
    80004fbc:	6cbe                	ld	s9,456(sp)
    80004fbe:	6d1e                	ld	s10,448(sp)
    80004fc0:	7dfa                	ld	s11,440(sp)
    80004fc2:	22010113          	addi	sp,sp,544
    80004fc6:	8082                	ret
    end_op();
    80004fc8:	fffff097          	auipc	ra,0xfffff
    80004fcc:	464080e7          	jalr	1124(ra) # 8000442c <end_op>
    return -1;
    80004fd0:	557d                	li	a0,-1
    80004fd2:	b7f9                	j	80004fa0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004fd4:	8526                	mv	a0,s1
    80004fd6:	ffffd097          	auipc	ra,0xffffd
    80004fda:	eb6080e7          	jalr	-330(ra) # 80001e8c <proc_pagetable>
    80004fde:	8b2a                	mv	s6,a0
    80004fe0:	d555                	beqz	a0,80004f8c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004fe2:	e6842783          	lw	a5,-408(s0)
    80004fe6:	e8045703          	lhu	a4,-384(s0)
    80004fea:	c735                	beqz	a4,80005056 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004fec:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004fee:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004ff2:	6a05                	lui	s4,0x1
    80004ff4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004ff8:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004ffc:	6d85                	lui	s11,0x1
    80004ffe:	7d7d                	lui	s10,0xfffff
    80005000:	ac1d                	j	80005236 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005002:	00003517          	auipc	a0,0x3
    80005006:	77e50513          	addi	a0,a0,1918 # 80008780 <syscalls+0x290>
    8000500a:	ffffb097          	auipc	ra,0xffffb
    8000500e:	536080e7          	jalr	1334(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005012:	874a                	mv	a4,s2
    80005014:	009c86bb          	addw	a3,s9,s1
    80005018:	4581                	li	a1,0
    8000501a:	8556                	mv	a0,s5
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	c84080e7          	jalr	-892(ra) # 80003ca0 <readi>
    80005024:	2501                	sext.w	a0,a0
    80005026:	1aa91863          	bne	s2,a0,800051d6 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    8000502a:	009d84bb          	addw	s1,s11,s1
    8000502e:	013d09bb          	addw	s3,s10,s3
    80005032:	1f74f263          	bgeu	s1,s7,80005216 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80005036:	02049593          	slli	a1,s1,0x20
    8000503a:	9181                	srli	a1,a1,0x20
    8000503c:	95e2                	add	a1,a1,s8
    8000503e:	855a                	mv	a0,s6
    80005040:	ffffc097          	auipc	ra,0xffffc
    80005044:	036080e7          	jalr	54(ra) # 80001076 <walkaddr>
    80005048:	862a                	mv	a2,a0
    if(pa == 0)
    8000504a:	dd45                	beqz	a0,80005002 <exec+0xfe>
      n = PGSIZE;
    8000504c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000504e:	fd49f2e3          	bgeu	s3,s4,80005012 <exec+0x10e>
      n = sz - i;
    80005052:	894e                	mv	s2,s3
    80005054:	bf7d                	j	80005012 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005056:	4481                	li	s1,0
  iunlockput(ip);
    80005058:	8556                	mv	a0,s5
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	bf4080e7          	jalr	-1036(ra) # 80003c4e <iunlockput>
  end_op();
    80005062:	fffff097          	auipc	ra,0xfffff
    80005066:	3ca080e7          	jalr	970(ra) # 8000442c <end_op>
  p = myproc();
    8000506a:	ffffd097          	auipc	ra,0xffffd
    8000506e:	d5e080e7          	jalr	-674(ra) # 80001dc8 <myproc>
    80005072:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005074:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005078:	6785                	lui	a5,0x1
    8000507a:	17fd                	addi	a5,a5,-1
    8000507c:	94be                	add	s1,s1,a5
    8000507e:	77fd                	lui	a5,0xfffff
    80005080:	8fe5                	and	a5,a5,s1
    80005082:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005086:	6609                	lui	a2,0x2
    80005088:	963e                	add	a2,a2,a5
    8000508a:	85be                	mv	a1,a5
    8000508c:	855a                	mv	a0,s6
    8000508e:	ffffc097          	auipc	ra,0xffffc
    80005092:	3cc080e7          	jalr	972(ra) # 8000145a <uvmalloc>
    80005096:	8c2a                	mv	s8,a0
  ip = 0;
    80005098:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000509a:	12050e63          	beqz	a0,800051d6 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000509e:	75f9                	lui	a1,0xffffe
    800050a0:	95aa                	add	a1,a1,a0
    800050a2:	855a                	mv	a0,s6
    800050a4:	ffffc097          	auipc	ra,0xffffc
    800050a8:	5d4080e7          	jalr	1492(ra) # 80001678 <uvmclear>
  stackbase = sp - PGSIZE;
    800050ac:	7afd                	lui	s5,0xfffff
    800050ae:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800050b0:	df043783          	ld	a5,-528(s0)
    800050b4:	6388                	ld	a0,0(a5)
    800050b6:	c925                	beqz	a0,80005126 <exec+0x222>
    800050b8:	e8840993          	addi	s3,s0,-376
    800050bc:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    800050c0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800050c2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800050c4:	ffffc097          	auipc	ra,0xffffc
    800050c8:	db8080e7          	jalr	-584(ra) # 80000e7c <strlen>
    800050cc:	0015079b          	addiw	a5,a0,1
    800050d0:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800050d4:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800050d8:	13596363          	bltu	s2,s5,800051fe <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800050dc:	df043d83          	ld	s11,-528(s0)
    800050e0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800050e4:	8552                	mv	a0,s4
    800050e6:	ffffc097          	auipc	ra,0xffffc
    800050ea:	d96080e7          	jalr	-618(ra) # 80000e7c <strlen>
    800050ee:	0015069b          	addiw	a3,a0,1
    800050f2:	8652                	mv	a2,s4
    800050f4:	85ca                	mv	a1,s2
    800050f6:	855a                	mv	a0,s6
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	5b2080e7          	jalr	1458(ra) # 800016aa <copyout>
    80005100:	10054363          	bltz	a0,80005206 <exec+0x302>
    ustack[argc] = sp;
    80005104:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005108:	0485                	addi	s1,s1,1
    8000510a:	008d8793          	addi	a5,s11,8
    8000510e:	def43823          	sd	a5,-528(s0)
    80005112:	008db503          	ld	a0,8(s11)
    80005116:	c911                	beqz	a0,8000512a <exec+0x226>
    if(argc >= MAXARG)
    80005118:	09a1                	addi	s3,s3,8
    8000511a:	fb3c95e3          	bne	s9,s3,800050c4 <exec+0x1c0>
  sz = sz1;
    8000511e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005122:	4a81                	li	s5,0
    80005124:	a84d                	j	800051d6 <exec+0x2d2>
  sp = sz;
    80005126:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005128:	4481                	li	s1,0
  ustack[argc] = 0;
    8000512a:	00349793          	slli	a5,s1,0x3
    8000512e:	f9040713          	addi	a4,s0,-112
    80005132:	97ba                	add	a5,a5,a4
    80005134:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd7ef8>
  sp -= (argc+1) * sizeof(uint64);
    80005138:	00148693          	addi	a3,s1,1
    8000513c:	068e                	slli	a3,a3,0x3
    8000513e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005142:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005146:	01597663          	bgeu	s2,s5,80005152 <exec+0x24e>
  sz = sz1;
    8000514a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000514e:	4a81                	li	s5,0
    80005150:	a059                	j	800051d6 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005152:	e8840613          	addi	a2,s0,-376
    80005156:	85ca                	mv	a1,s2
    80005158:	855a                	mv	a0,s6
    8000515a:	ffffc097          	auipc	ra,0xffffc
    8000515e:	550080e7          	jalr	1360(ra) # 800016aa <copyout>
    80005162:	0a054663          	bltz	a0,8000520e <exec+0x30a>
  p->trapframe->a1 = sp;
    80005166:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    8000516a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000516e:	de843783          	ld	a5,-536(s0)
    80005172:	0007c703          	lbu	a4,0(a5)
    80005176:	cf11                	beqz	a4,80005192 <exec+0x28e>
    80005178:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000517a:	02f00693          	li	a3,47
    8000517e:	a039                	j	8000518c <exec+0x288>
      last = s+1;
    80005180:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005184:	0785                	addi	a5,a5,1
    80005186:	fff7c703          	lbu	a4,-1(a5)
    8000518a:	c701                	beqz	a4,80005192 <exec+0x28e>
    if(*s == '/')
    8000518c:	fed71ce3          	bne	a4,a3,80005184 <exec+0x280>
    80005190:	bfc5                	j	80005180 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005192:	4641                	li	a2,16
    80005194:	de843583          	ld	a1,-536(s0)
    80005198:	158b8513          	addi	a0,s7,344
    8000519c:	ffffc097          	auipc	ra,0xffffc
    800051a0:	cae080e7          	jalr	-850(ra) # 80000e4a <safestrcpy>
  oldpagetable = p->pagetable;
    800051a4:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800051a8:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800051ac:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800051b0:	058bb783          	ld	a5,88(s7)
    800051b4:	e6043703          	ld	a4,-416(s0)
    800051b8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800051ba:	058bb783          	ld	a5,88(s7)
    800051be:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800051c2:	85ea                	mv	a1,s10
    800051c4:	ffffd097          	auipc	ra,0xffffd
    800051c8:	d64080e7          	jalr	-668(ra) # 80001f28 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800051cc:	0004851b          	sext.w	a0,s1
    800051d0:	bbc1                	j	80004fa0 <exec+0x9c>
    800051d2:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800051d6:	df843583          	ld	a1,-520(s0)
    800051da:	855a                	mv	a0,s6
    800051dc:	ffffd097          	auipc	ra,0xffffd
    800051e0:	d4c080e7          	jalr	-692(ra) # 80001f28 <proc_freepagetable>
  if(ip){
    800051e4:	da0a94e3          	bnez	s5,80004f8c <exec+0x88>
  return -1;
    800051e8:	557d                	li	a0,-1
    800051ea:	bb5d                	j	80004fa0 <exec+0x9c>
    800051ec:	de943c23          	sd	s1,-520(s0)
    800051f0:	b7dd                	j	800051d6 <exec+0x2d2>
    800051f2:	de943c23          	sd	s1,-520(s0)
    800051f6:	b7c5                	j	800051d6 <exec+0x2d2>
    800051f8:	de943c23          	sd	s1,-520(s0)
    800051fc:	bfe9                	j	800051d6 <exec+0x2d2>
  sz = sz1;
    800051fe:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005202:	4a81                	li	s5,0
    80005204:	bfc9                	j	800051d6 <exec+0x2d2>
  sz = sz1;
    80005206:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000520a:	4a81                	li	s5,0
    8000520c:	b7e9                	j	800051d6 <exec+0x2d2>
  sz = sz1;
    8000520e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005212:	4a81                	li	s5,0
    80005214:	b7c9                	j	800051d6 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005216:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000521a:	e0843783          	ld	a5,-504(s0)
    8000521e:	0017869b          	addiw	a3,a5,1
    80005222:	e0d43423          	sd	a3,-504(s0)
    80005226:	e0043783          	ld	a5,-512(s0)
    8000522a:	0387879b          	addiw	a5,a5,56
    8000522e:	e8045703          	lhu	a4,-384(s0)
    80005232:	e2e6d3e3          	bge	a3,a4,80005058 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005236:	2781                	sext.w	a5,a5
    80005238:	e0f43023          	sd	a5,-512(s0)
    8000523c:	03800713          	li	a4,56
    80005240:	86be                	mv	a3,a5
    80005242:	e1040613          	addi	a2,s0,-496
    80005246:	4581                	li	a1,0
    80005248:	8556                	mv	a0,s5
    8000524a:	fffff097          	auipc	ra,0xfffff
    8000524e:	a56080e7          	jalr	-1450(ra) # 80003ca0 <readi>
    80005252:	03800793          	li	a5,56
    80005256:	f6f51ee3          	bne	a0,a5,800051d2 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000525a:	e1042783          	lw	a5,-496(s0)
    8000525e:	4705                	li	a4,1
    80005260:	fae79de3          	bne	a5,a4,8000521a <exec+0x316>
    if(ph.memsz < ph.filesz)
    80005264:	e3843603          	ld	a2,-456(s0)
    80005268:	e3043783          	ld	a5,-464(s0)
    8000526c:	f8f660e3          	bltu	a2,a5,800051ec <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005270:	e2043783          	ld	a5,-480(s0)
    80005274:	963e                	add	a2,a2,a5
    80005276:	f6f66ee3          	bltu	a2,a5,800051f2 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000527a:	85a6                	mv	a1,s1
    8000527c:	855a                	mv	a0,s6
    8000527e:	ffffc097          	auipc	ra,0xffffc
    80005282:	1dc080e7          	jalr	476(ra) # 8000145a <uvmalloc>
    80005286:	dea43c23          	sd	a0,-520(s0)
    8000528a:	d53d                	beqz	a0,800051f8 <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    8000528c:	e2043c03          	ld	s8,-480(s0)
    80005290:	de043783          	ld	a5,-544(s0)
    80005294:	00fc77b3          	and	a5,s8,a5
    80005298:	ff9d                	bnez	a5,800051d6 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000529a:	e1842c83          	lw	s9,-488(s0)
    8000529e:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800052a2:	f60b8ae3          	beqz	s7,80005216 <exec+0x312>
    800052a6:	89de                	mv	s3,s7
    800052a8:	4481                	li	s1,0
    800052aa:	b371                	j	80005036 <exec+0x132>

00000000800052ac <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800052ac:	7179                	addi	sp,sp,-48
    800052ae:	f406                	sd	ra,40(sp)
    800052b0:	f022                	sd	s0,32(sp)
    800052b2:	ec26                	sd	s1,24(sp)
    800052b4:	e84a                	sd	s2,16(sp)
    800052b6:	1800                	addi	s0,sp,48
    800052b8:	892e                	mv	s2,a1
    800052ba:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800052bc:	fdc40593          	addi	a1,s0,-36
    800052c0:	ffffe097          	auipc	ra,0xffffe
    800052c4:	b74080e7          	jalr	-1164(ra) # 80002e34 <argint>
    800052c8:	04054063          	bltz	a0,80005308 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800052cc:	fdc42703          	lw	a4,-36(s0)
    800052d0:	47bd                	li	a5,15
    800052d2:	02e7ed63          	bltu	a5,a4,8000530c <argfd+0x60>
    800052d6:	ffffd097          	auipc	ra,0xffffd
    800052da:	af2080e7          	jalr	-1294(ra) # 80001dc8 <myproc>
    800052de:	fdc42703          	lw	a4,-36(s0)
    800052e2:	01a70793          	addi	a5,a4,26
    800052e6:	078e                	slli	a5,a5,0x3
    800052e8:	953e                	add	a0,a0,a5
    800052ea:	611c                	ld	a5,0(a0)
    800052ec:	c395                	beqz	a5,80005310 <argfd+0x64>
    return -1;
  if(pfd)
    800052ee:	00090463          	beqz	s2,800052f6 <argfd+0x4a>
    *pfd = fd;
    800052f2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800052f6:	4501                	li	a0,0
  if(pf)
    800052f8:	c091                	beqz	s1,800052fc <argfd+0x50>
    *pf = f;
    800052fa:	e09c                	sd	a5,0(s1)
}
    800052fc:	70a2                	ld	ra,40(sp)
    800052fe:	7402                	ld	s0,32(sp)
    80005300:	64e2                	ld	s1,24(sp)
    80005302:	6942                	ld	s2,16(sp)
    80005304:	6145                	addi	sp,sp,48
    80005306:	8082                	ret
    return -1;
    80005308:	557d                	li	a0,-1
    8000530a:	bfcd                	j	800052fc <argfd+0x50>
    return -1;
    8000530c:	557d                	li	a0,-1
    8000530e:	b7fd                	j	800052fc <argfd+0x50>
    80005310:	557d                	li	a0,-1
    80005312:	b7ed                	j	800052fc <argfd+0x50>

0000000080005314 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005314:	1101                	addi	sp,sp,-32
    80005316:	ec06                	sd	ra,24(sp)
    80005318:	e822                	sd	s0,16(sp)
    8000531a:	e426                	sd	s1,8(sp)
    8000531c:	1000                	addi	s0,sp,32
    8000531e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005320:	ffffd097          	auipc	ra,0xffffd
    80005324:	aa8080e7          	jalr	-1368(ra) # 80001dc8 <myproc>
    80005328:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000532a:	0d050793          	addi	a5,a0,208
    8000532e:	4501                	li	a0,0
    80005330:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005332:	6398                	ld	a4,0(a5)
    80005334:	cb19                	beqz	a4,8000534a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005336:	2505                	addiw	a0,a0,1
    80005338:	07a1                	addi	a5,a5,8
    8000533a:	fed51ce3          	bne	a0,a3,80005332 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000533e:	557d                	li	a0,-1
}
    80005340:	60e2                	ld	ra,24(sp)
    80005342:	6442                	ld	s0,16(sp)
    80005344:	64a2                	ld	s1,8(sp)
    80005346:	6105                	addi	sp,sp,32
    80005348:	8082                	ret
      p->ofile[fd] = f;
    8000534a:	01a50793          	addi	a5,a0,26
    8000534e:	078e                	slli	a5,a5,0x3
    80005350:	963e                	add	a2,a2,a5
    80005352:	e204                	sd	s1,0(a2)
      return fd;
    80005354:	b7f5                	j	80005340 <fdalloc+0x2c>

0000000080005356 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005356:	715d                	addi	sp,sp,-80
    80005358:	e486                	sd	ra,72(sp)
    8000535a:	e0a2                	sd	s0,64(sp)
    8000535c:	fc26                	sd	s1,56(sp)
    8000535e:	f84a                	sd	s2,48(sp)
    80005360:	f44e                	sd	s3,40(sp)
    80005362:	f052                	sd	s4,32(sp)
    80005364:	ec56                	sd	s5,24(sp)
    80005366:	0880                	addi	s0,sp,80
    80005368:	89ae                	mv	s3,a1
    8000536a:	8ab2                	mv	s5,a2
    8000536c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000536e:	fb040593          	addi	a1,s0,-80
    80005372:	fffff097          	auipc	ra,0xfffff
    80005376:	e48080e7          	jalr	-440(ra) # 800041ba <nameiparent>
    8000537a:	892a                	mv	s2,a0
    8000537c:	12050e63          	beqz	a0,800054b8 <create+0x162>
    return 0;

  ilock(dp);
    80005380:	ffffe097          	auipc	ra,0xffffe
    80005384:	66c080e7          	jalr	1644(ra) # 800039ec <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005388:	4601                	li	a2,0
    8000538a:	fb040593          	addi	a1,s0,-80
    8000538e:	854a                	mv	a0,s2
    80005390:	fffff097          	auipc	ra,0xfffff
    80005394:	b3a080e7          	jalr	-1222(ra) # 80003eca <dirlookup>
    80005398:	84aa                	mv	s1,a0
    8000539a:	c921                	beqz	a0,800053ea <create+0x94>
    iunlockput(dp);
    8000539c:	854a                	mv	a0,s2
    8000539e:	fffff097          	auipc	ra,0xfffff
    800053a2:	8b0080e7          	jalr	-1872(ra) # 80003c4e <iunlockput>
    ilock(ip);
    800053a6:	8526                	mv	a0,s1
    800053a8:	ffffe097          	auipc	ra,0xffffe
    800053ac:	644080e7          	jalr	1604(ra) # 800039ec <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800053b0:	2981                	sext.w	s3,s3
    800053b2:	4789                	li	a5,2
    800053b4:	02f99463          	bne	s3,a5,800053dc <create+0x86>
    800053b8:	0444d783          	lhu	a5,68(s1)
    800053bc:	37f9                	addiw	a5,a5,-2
    800053be:	17c2                	slli	a5,a5,0x30
    800053c0:	93c1                	srli	a5,a5,0x30
    800053c2:	4705                	li	a4,1
    800053c4:	00f76c63          	bltu	a4,a5,800053dc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800053c8:	8526                	mv	a0,s1
    800053ca:	60a6                	ld	ra,72(sp)
    800053cc:	6406                	ld	s0,64(sp)
    800053ce:	74e2                	ld	s1,56(sp)
    800053d0:	7942                	ld	s2,48(sp)
    800053d2:	79a2                	ld	s3,40(sp)
    800053d4:	7a02                	ld	s4,32(sp)
    800053d6:	6ae2                	ld	s5,24(sp)
    800053d8:	6161                	addi	sp,sp,80
    800053da:	8082                	ret
    iunlockput(ip);
    800053dc:	8526                	mv	a0,s1
    800053de:	fffff097          	auipc	ra,0xfffff
    800053e2:	870080e7          	jalr	-1936(ra) # 80003c4e <iunlockput>
    return 0;
    800053e6:	4481                	li	s1,0
    800053e8:	b7c5                	j	800053c8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800053ea:	85ce                	mv	a1,s3
    800053ec:	00092503          	lw	a0,0(s2)
    800053f0:	ffffe097          	auipc	ra,0xffffe
    800053f4:	464080e7          	jalr	1124(ra) # 80003854 <ialloc>
    800053f8:	84aa                	mv	s1,a0
    800053fa:	c521                	beqz	a0,80005442 <create+0xec>
  ilock(ip);
    800053fc:	ffffe097          	auipc	ra,0xffffe
    80005400:	5f0080e7          	jalr	1520(ra) # 800039ec <ilock>
  ip->major = major;
    80005404:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005408:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000540c:	4a05                	li	s4,1
    8000540e:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005412:	8526                	mv	a0,s1
    80005414:	ffffe097          	auipc	ra,0xffffe
    80005418:	50e080e7          	jalr	1294(ra) # 80003922 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000541c:	2981                	sext.w	s3,s3
    8000541e:	03498a63          	beq	s3,s4,80005452 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005422:	40d0                	lw	a2,4(s1)
    80005424:	fb040593          	addi	a1,s0,-80
    80005428:	854a                	mv	a0,s2
    8000542a:	fffff097          	auipc	ra,0xfffff
    8000542e:	cb0080e7          	jalr	-848(ra) # 800040da <dirlink>
    80005432:	06054b63          	bltz	a0,800054a8 <create+0x152>
  iunlockput(dp);
    80005436:	854a                	mv	a0,s2
    80005438:	fffff097          	auipc	ra,0xfffff
    8000543c:	816080e7          	jalr	-2026(ra) # 80003c4e <iunlockput>
  return ip;
    80005440:	b761                	j	800053c8 <create+0x72>
    panic("create: ialloc");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	35e50513          	addi	a0,a0,862 # 800087a0 <syscalls+0x2b0>
    8000544a:	ffffb097          	auipc	ra,0xffffb
    8000544e:	0f6080e7          	jalr	246(ra) # 80000540 <panic>
    dp->nlink++;  // for ".."
    80005452:	04a95783          	lhu	a5,74(s2)
    80005456:	2785                	addiw	a5,a5,1
    80005458:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000545c:	854a                	mv	a0,s2
    8000545e:	ffffe097          	auipc	ra,0xffffe
    80005462:	4c4080e7          	jalr	1220(ra) # 80003922 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005466:	40d0                	lw	a2,4(s1)
    80005468:	00003597          	auipc	a1,0x3
    8000546c:	34858593          	addi	a1,a1,840 # 800087b0 <syscalls+0x2c0>
    80005470:	8526                	mv	a0,s1
    80005472:	fffff097          	auipc	ra,0xfffff
    80005476:	c68080e7          	jalr	-920(ra) # 800040da <dirlink>
    8000547a:	00054f63          	bltz	a0,80005498 <create+0x142>
    8000547e:	00492603          	lw	a2,4(s2)
    80005482:	00003597          	auipc	a1,0x3
    80005486:	33658593          	addi	a1,a1,822 # 800087b8 <syscalls+0x2c8>
    8000548a:	8526                	mv	a0,s1
    8000548c:	fffff097          	auipc	ra,0xfffff
    80005490:	c4e080e7          	jalr	-946(ra) # 800040da <dirlink>
    80005494:	f80557e3          	bgez	a0,80005422 <create+0xcc>
      panic("create dots");
    80005498:	00003517          	auipc	a0,0x3
    8000549c:	32850513          	addi	a0,a0,808 # 800087c0 <syscalls+0x2d0>
    800054a0:	ffffb097          	auipc	ra,0xffffb
    800054a4:	0a0080e7          	jalr	160(ra) # 80000540 <panic>
    panic("create: dirlink");
    800054a8:	00003517          	auipc	a0,0x3
    800054ac:	32850513          	addi	a0,a0,808 # 800087d0 <syscalls+0x2e0>
    800054b0:	ffffb097          	auipc	ra,0xffffb
    800054b4:	090080e7          	jalr	144(ra) # 80000540 <panic>
    return 0;
    800054b8:	84aa                	mv	s1,a0
    800054ba:	b739                	j	800053c8 <create+0x72>

00000000800054bc <sys_dup>:
{
    800054bc:	7179                	addi	sp,sp,-48
    800054be:	f406                	sd	ra,40(sp)
    800054c0:	f022                	sd	s0,32(sp)
    800054c2:	ec26                	sd	s1,24(sp)
    800054c4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800054c6:	fd840613          	addi	a2,s0,-40
    800054ca:	4581                	li	a1,0
    800054cc:	4501                	li	a0,0
    800054ce:	00000097          	auipc	ra,0x0
    800054d2:	dde080e7          	jalr	-546(ra) # 800052ac <argfd>
    return -1;
    800054d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800054d8:	02054363          	bltz	a0,800054fe <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800054dc:	fd843503          	ld	a0,-40(s0)
    800054e0:	00000097          	auipc	ra,0x0
    800054e4:	e34080e7          	jalr	-460(ra) # 80005314 <fdalloc>
    800054e8:	84aa                	mv	s1,a0
    return -1;
    800054ea:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800054ec:	00054963          	bltz	a0,800054fe <sys_dup+0x42>
  filedup(f);
    800054f0:	fd843503          	ld	a0,-40(s0)
    800054f4:	fffff097          	auipc	ra,0xfffff
    800054f8:	338080e7          	jalr	824(ra) # 8000482c <filedup>
  return fd;
    800054fc:	87a6                	mv	a5,s1
}
    800054fe:	853e                	mv	a0,a5
    80005500:	70a2                	ld	ra,40(sp)
    80005502:	7402                	ld	s0,32(sp)
    80005504:	64e2                	ld	s1,24(sp)
    80005506:	6145                	addi	sp,sp,48
    80005508:	8082                	ret

000000008000550a <sys_read>:
{
    8000550a:	7179                	addi	sp,sp,-48
    8000550c:	f406                	sd	ra,40(sp)
    8000550e:	f022                	sd	s0,32(sp)
    80005510:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005512:	fe840613          	addi	a2,s0,-24
    80005516:	4581                	li	a1,0
    80005518:	4501                	li	a0,0
    8000551a:	00000097          	auipc	ra,0x0
    8000551e:	d92080e7          	jalr	-622(ra) # 800052ac <argfd>
    return -1;
    80005522:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005524:	04054163          	bltz	a0,80005566 <sys_read+0x5c>
    80005528:	fe440593          	addi	a1,s0,-28
    8000552c:	4509                	li	a0,2
    8000552e:	ffffe097          	auipc	ra,0xffffe
    80005532:	906080e7          	jalr	-1786(ra) # 80002e34 <argint>
    return -1;
    80005536:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005538:	02054763          	bltz	a0,80005566 <sys_read+0x5c>
    8000553c:	fd840593          	addi	a1,s0,-40
    80005540:	4505                	li	a0,1
    80005542:	ffffe097          	auipc	ra,0xffffe
    80005546:	914080e7          	jalr	-1772(ra) # 80002e56 <argaddr>
    return -1;
    8000554a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000554c:	00054d63          	bltz	a0,80005566 <sys_read+0x5c>
  return fileread(f, p, n);
    80005550:	fe442603          	lw	a2,-28(s0)
    80005554:	fd843583          	ld	a1,-40(s0)
    80005558:	fe843503          	ld	a0,-24(s0)
    8000555c:	fffff097          	auipc	ra,0xfffff
    80005560:	45c080e7          	jalr	1116(ra) # 800049b8 <fileread>
    80005564:	87aa                	mv	a5,a0
}
    80005566:	853e                	mv	a0,a5
    80005568:	70a2                	ld	ra,40(sp)
    8000556a:	7402                	ld	s0,32(sp)
    8000556c:	6145                	addi	sp,sp,48
    8000556e:	8082                	ret

0000000080005570 <sys_write>:
{
    80005570:	7179                	addi	sp,sp,-48
    80005572:	f406                	sd	ra,40(sp)
    80005574:	f022                	sd	s0,32(sp)
    80005576:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005578:	fe840613          	addi	a2,s0,-24
    8000557c:	4581                	li	a1,0
    8000557e:	4501                	li	a0,0
    80005580:	00000097          	auipc	ra,0x0
    80005584:	d2c080e7          	jalr	-724(ra) # 800052ac <argfd>
    return -1;
    80005588:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000558a:	04054163          	bltz	a0,800055cc <sys_write+0x5c>
    8000558e:	fe440593          	addi	a1,s0,-28
    80005592:	4509                	li	a0,2
    80005594:	ffffe097          	auipc	ra,0xffffe
    80005598:	8a0080e7          	jalr	-1888(ra) # 80002e34 <argint>
    return -1;
    8000559c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000559e:	02054763          	bltz	a0,800055cc <sys_write+0x5c>
    800055a2:	fd840593          	addi	a1,s0,-40
    800055a6:	4505                	li	a0,1
    800055a8:	ffffe097          	auipc	ra,0xffffe
    800055ac:	8ae080e7          	jalr	-1874(ra) # 80002e56 <argaddr>
    return -1;
    800055b0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055b2:	00054d63          	bltz	a0,800055cc <sys_write+0x5c>
  return filewrite(f, p, n);
    800055b6:	fe442603          	lw	a2,-28(s0)
    800055ba:	fd843583          	ld	a1,-40(s0)
    800055be:	fe843503          	ld	a0,-24(s0)
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	4b8080e7          	jalr	1208(ra) # 80004a7a <filewrite>
    800055ca:	87aa                	mv	a5,a0
}
    800055cc:	853e                	mv	a0,a5
    800055ce:	70a2                	ld	ra,40(sp)
    800055d0:	7402                	ld	s0,32(sp)
    800055d2:	6145                	addi	sp,sp,48
    800055d4:	8082                	ret

00000000800055d6 <sys_close>:
{
    800055d6:	1101                	addi	sp,sp,-32
    800055d8:	ec06                	sd	ra,24(sp)
    800055da:	e822                	sd	s0,16(sp)
    800055dc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800055de:	fe040613          	addi	a2,s0,-32
    800055e2:	fec40593          	addi	a1,s0,-20
    800055e6:	4501                	li	a0,0
    800055e8:	00000097          	auipc	ra,0x0
    800055ec:	cc4080e7          	jalr	-828(ra) # 800052ac <argfd>
    return -1;
    800055f0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800055f2:	02054463          	bltz	a0,8000561a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800055f6:	ffffc097          	auipc	ra,0xffffc
    800055fa:	7d2080e7          	jalr	2002(ra) # 80001dc8 <myproc>
    800055fe:	fec42783          	lw	a5,-20(s0)
    80005602:	07e9                	addi	a5,a5,26
    80005604:	078e                	slli	a5,a5,0x3
    80005606:	97aa                	add	a5,a5,a0
    80005608:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000560c:	fe043503          	ld	a0,-32(s0)
    80005610:	fffff097          	auipc	ra,0xfffff
    80005614:	26e080e7          	jalr	622(ra) # 8000487e <fileclose>
  return 0;
    80005618:	4781                	li	a5,0
}
    8000561a:	853e                	mv	a0,a5
    8000561c:	60e2                	ld	ra,24(sp)
    8000561e:	6442                	ld	s0,16(sp)
    80005620:	6105                	addi	sp,sp,32
    80005622:	8082                	ret

0000000080005624 <sys_fstat>:
{
    80005624:	1101                	addi	sp,sp,-32
    80005626:	ec06                	sd	ra,24(sp)
    80005628:	e822                	sd	s0,16(sp)
    8000562a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000562c:	fe840613          	addi	a2,s0,-24
    80005630:	4581                	li	a1,0
    80005632:	4501                	li	a0,0
    80005634:	00000097          	auipc	ra,0x0
    80005638:	c78080e7          	jalr	-904(ra) # 800052ac <argfd>
    return -1;
    8000563c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000563e:	02054563          	bltz	a0,80005668 <sys_fstat+0x44>
    80005642:	fe040593          	addi	a1,s0,-32
    80005646:	4505                	li	a0,1
    80005648:	ffffe097          	auipc	ra,0xffffe
    8000564c:	80e080e7          	jalr	-2034(ra) # 80002e56 <argaddr>
    return -1;
    80005650:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005652:	00054b63          	bltz	a0,80005668 <sys_fstat+0x44>
  return filestat(f, st);
    80005656:	fe043583          	ld	a1,-32(s0)
    8000565a:	fe843503          	ld	a0,-24(s0)
    8000565e:	fffff097          	auipc	ra,0xfffff
    80005662:	2e8080e7          	jalr	744(ra) # 80004946 <filestat>
    80005666:	87aa                	mv	a5,a0
}
    80005668:	853e                	mv	a0,a5
    8000566a:	60e2                	ld	ra,24(sp)
    8000566c:	6442                	ld	s0,16(sp)
    8000566e:	6105                	addi	sp,sp,32
    80005670:	8082                	ret

0000000080005672 <sys_link>:
{
    80005672:	7169                	addi	sp,sp,-304
    80005674:	f606                	sd	ra,296(sp)
    80005676:	f222                	sd	s0,288(sp)
    80005678:	ee26                	sd	s1,280(sp)
    8000567a:	ea4a                	sd	s2,272(sp)
    8000567c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000567e:	08000613          	li	a2,128
    80005682:	ed040593          	addi	a1,s0,-304
    80005686:	4501                	li	a0,0
    80005688:	ffffd097          	auipc	ra,0xffffd
    8000568c:	7f0080e7          	jalr	2032(ra) # 80002e78 <argstr>
    return -1;
    80005690:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005692:	10054e63          	bltz	a0,800057ae <sys_link+0x13c>
    80005696:	08000613          	li	a2,128
    8000569a:	f5040593          	addi	a1,s0,-176
    8000569e:	4505                	li	a0,1
    800056a0:	ffffd097          	auipc	ra,0xffffd
    800056a4:	7d8080e7          	jalr	2008(ra) # 80002e78 <argstr>
    return -1;
    800056a8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056aa:	10054263          	bltz	a0,800057ae <sys_link+0x13c>
  begin_op();
    800056ae:	fffff097          	auipc	ra,0xfffff
    800056b2:	cfe080e7          	jalr	-770(ra) # 800043ac <begin_op>
  if((ip = namei(old)) == 0){
    800056b6:	ed040513          	addi	a0,s0,-304
    800056ba:	fffff097          	auipc	ra,0xfffff
    800056be:	ae2080e7          	jalr	-1310(ra) # 8000419c <namei>
    800056c2:	84aa                	mv	s1,a0
    800056c4:	c551                	beqz	a0,80005750 <sys_link+0xde>
  ilock(ip);
    800056c6:	ffffe097          	auipc	ra,0xffffe
    800056ca:	326080e7          	jalr	806(ra) # 800039ec <ilock>
  if(ip->type == T_DIR){
    800056ce:	04449703          	lh	a4,68(s1)
    800056d2:	4785                	li	a5,1
    800056d4:	08f70463          	beq	a4,a5,8000575c <sys_link+0xea>
  ip->nlink++;
    800056d8:	04a4d783          	lhu	a5,74(s1)
    800056dc:	2785                	addiw	a5,a5,1
    800056de:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800056e2:	8526                	mv	a0,s1
    800056e4:	ffffe097          	auipc	ra,0xffffe
    800056e8:	23e080e7          	jalr	574(ra) # 80003922 <iupdate>
  iunlock(ip);
    800056ec:	8526                	mv	a0,s1
    800056ee:	ffffe097          	auipc	ra,0xffffe
    800056f2:	3c0080e7          	jalr	960(ra) # 80003aae <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800056f6:	fd040593          	addi	a1,s0,-48
    800056fa:	f5040513          	addi	a0,s0,-176
    800056fe:	fffff097          	auipc	ra,0xfffff
    80005702:	abc080e7          	jalr	-1348(ra) # 800041ba <nameiparent>
    80005706:	892a                	mv	s2,a0
    80005708:	c935                	beqz	a0,8000577c <sys_link+0x10a>
  ilock(dp);
    8000570a:	ffffe097          	auipc	ra,0xffffe
    8000570e:	2e2080e7          	jalr	738(ra) # 800039ec <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005712:	00092703          	lw	a4,0(s2)
    80005716:	409c                	lw	a5,0(s1)
    80005718:	04f71d63          	bne	a4,a5,80005772 <sys_link+0x100>
    8000571c:	40d0                	lw	a2,4(s1)
    8000571e:	fd040593          	addi	a1,s0,-48
    80005722:	854a                	mv	a0,s2
    80005724:	fffff097          	auipc	ra,0xfffff
    80005728:	9b6080e7          	jalr	-1610(ra) # 800040da <dirlink>
    8000572c:	04054363          	bltz	a0,80005772 <sys_link+0x100>
  iunlockput(dp);
    80005730:	854a                	mv	a0,s2
    80005732:	ffffe097          	auipc	ra,0xffffe
    80005736:	51c080e7          	jalr	1308(ra) # 80003c4e <iunlockput>
  iput(ip);
    8000573a:	8526                	mv	a0,s1
    8000573c:	ffffe097          	auipc	ra,0xffffe
    80005740:	46a080e7          	jalr	1130(ra) # 80003ba6 <iput>
  end_op();
    80005744:	fffff097          	auipc	ra,0xfffff
    80005748:	ce8080e7          	jalr	-792(ra) # 8000442c <end_op>
  return 0;
    8000574c:	4781                	li	a5,0
    8000574e:	a085                	j	800057ae <sys_link+0x13c>
    end_op();
    80005750:	fffff097          	auipc	ra,0xfffff
    80005754:	cdc080e7          	jalr	-804(ra) # 8000442c <end_op>
    return -1;
    80005758:	57fd                	li	a5,-1
    8000575a:	a891                	j	800057ae <sys_link+0x13c>
    iunlockput(ip);
    8000575c:	8526                	mv	a0,s1
    8000575e:	ffffe097          	auipc	ra,0xffffe
    80005762:	4f0080e7          	jalr	1264(ra) # 80003c4e <iunlockput>
    end_op();
    80005766:	fffff097          	auipc	ra,0xfffff
    8000576a:	cc6080e7          	jalr	-826(ra) # 8000442c <end_op>
    return -1;
    8000576e:	57fd                	li	a5,-1
    80005770:	a83d                	j	800057ae <sys_link+0x13c>
    iunlockput(dp);
    80005772:	854a                	mv	a0,s2
    80005774:	ffffe097          	auipc	ra,0xffffe
    80005778:	4da080e7          	jalr	1242(ra) # 80003c4e <iunlockput>
  ilock(ip);
    8000577c:	8526                	mv	a0,s1
    8000577e:	ffffe097          	auipc	ra,0xffffe
    80005782:	26e080e7          	jalr	622(ra) # 800039ec <ilock>
  ip->nlink--;
    80005786:	04a4d783          	lhu	a5,74(s1)
    8000578a:	37fd                	addiw	a5,a5,-1
    8000578c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005790:	8526                	mv	a0,s1
    80005792:	ffffe097          	auipc	ra,0xffffe
    80005796:	190080e7          	jalr	400(ra) # 80003922 <iupdate>
  iunlockput(ip);
    8000579a:	8526                	mv	a0,s1
    8000579c:	ffffe097          	auipc	ra,0xffffe
    800057a0:	4b2080e7          	jalr	1202(ra) # 80003c4e <iunlockput>
  end_op();
    800057a4:	fffff097          	auipc	ra,0xfffff
    800057a8:	c88080e7          	jalr	-888(ra) # 8000442c <end_op>
  return -1;
    800057ac:	57fd                	li	a5,-1
}
    800057ae:	853e                	mv	a0,a5
    800057b0:	70b2                	ld	ra,296(sp)
    800057b2:	7412                	ld	s0,288(sp)
    800057b4:	64f2                	ld	s1,280(sp)
    800057b6:	6952                	ld	s2,272(sp)
    800057b8:	6155                	addi	sp,sp,304
    800057ba:	8082                	ret

00000000800057bc <sys_unlink>:
{
    800057bc:	7151                	addi	sp,sp,-240
    800057be:	f586                	sd	ra,232(sp)
    800057c0:	f1a2                	sd	s0,224(sp)
    800057c2:	eda6                	sd	s1,216(sp)
    800057c4:	e9ca                	sd	s2,208(sp)
    800057c6:	e5ce                	sd	s3,200(sp)
    800057c8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800057ca:	08000613          	li	a2,128
    800057ce:	f3040593          	addi	a1,s0,-208
    800057d2:	4501                	li	a0,0
    800057d4:	ffffd097          	auipc	ra,0xffffd
    800057d8:	6a4080e7          	jalr	1700(ra) # 80002e78 <argstr>
    800057dc:	18054163          	bltz	a0,8000595e <sys_unlink+0x1a2>
  begin_op();
    800057e0:	fffff097          	auipc	ra,0xfffff
    800057e4:	bcc080e7          	jalr	-1076(ra) # 800043ac <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800057e8:	fb040593          	addi	a1,s0,-80
    800057ec:	f3040513          	addi	a0,s0,-208
    800057f0:	fffff097          	auipc	ra,0xfffff
    800057f4:	9ca080e7          	jalr	-1590(ra) # 800041ba <nameiparent>
    800057f8:	84aa                	mv	s1,a0
    800057fa:	c979                	beqz	a0,800058d0 <sys_unlink+0x114>
  ilock(dp);
    800057fc:	ffffe097          	auipc	ra,0xffffe
    80005800:	1f0080e7          	jalr	496(ra) # 800039ec <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005804:	00003597          	auipc	a1,0x3
    80005808:	fac58593          	addi	a1,a1,-84 # 800087b0 <syscalls+0x2c0>
    8000580c:	fb040513          	addi	a0,s0,-80
    80005810:	ffffe097          	auipc	ra,0xffffe
    80005814:	6a0080e7          	jalr	1696(ra) # 80003eb0 <namecmp>
    80005818:	14050a63          	beqz	a0,8000596c <sys_unlink+0x1b0>
    8000581c:	00003597          	auipc	a1,0x3
    80005820:	f9c58593          	addi	a1,a1,-100 # 800087b8 <syscalls+0x2c8>
    80005824:	fb040513          	addi	a0,s0,-80
    80005828:	ffffe097          	auipc	ra,0xffffe
    8000582c:	688080e7          	jalr	1672(ra) # 80003eb0 <namecmp>
    80005830:	12050e63          	beqz	a0,8000596c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005834:	f2c40613          	addi	a2,s0,-212
    80005838:	fb040593          	addi	a1,s0,-80
    8000583c:	8526                	mv	a0,s1
    8000583e:	ffffe097          	auipc	ra,0xffffe
    80005842:	68c080e7          	jalr	1676(ra) # 80003eca <dirlookup>
    80005846:	892a                	mv	s2,a0
    80005848:	12050263          	beqz	a0,8000596c <sys_unlink+0x1b0>
  ilock(ip);
    8000584c:	ffffe097          	auipc	ra,0xffffe
    80005850:	1a0080e7          	jalr	416(ra) # 800039ec <ilock>
  if(ip->nlink < 1)
    80005854:	04a91783          	lh	a5,74(s2)
    80005858:	08f05263          	blez	a5,800058dc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000585c:	04491703          	lh	a4,68(s2)
    80005860:	4785                	li	a5,1
    80005862:	08f70563          	beq	a4,a5,800058ec <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005866:	4641                	li	a2,16
    80005868:	4581                	li	a1,0
    8000586a:	fc040513          	addi	a0,s0,-64
    8000586e:	ffffb097          	auipc	ra,0xffffb
    80005872:	48a080e7          	jalr	1162(ra) # 80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005876:	4741                	li	a4,16
    80005878:	f2c42683          	lw	a3,-212(s0)
    8000587c:	fc040613          	addi	a2,s0,-64
    80005880:	4581                	li	a1,0
    80005882:	8526                	mv	a0,s1
    80005884:	ffffe097          	auipc	ra,0xffffe
    80005888:	512080e7          	jalr	1298(ra) # 80003d96 <writei>
    8000588c:	47c1                	li	a5,16
    8000588e:	0af51563          	bne	a0,a5,80005938 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005892:	04491703          	lh	a4,68(s2)
    80005896:	4785                	li	a5,1
    80005898:	0af70863          	beq	a4,a5,80005948 <sys_unlink+0x18c>
  iunlockput(dp);
    8000589c:	8526                	mv	a0,s1
    8000589e:	ffffe097          	auipc	ra,0xffffe
    800058a2:	3b0080e7          	jalr	944(ra) # 80003c4e <iunlockput>
  ip->nlink--;
    800058a6:	04a95783          	lhu	a5,74(s2)
    800058aa:	37fd                	addiw	a5,a5,-1
    800058ac:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800058b0:	854a                	mv	a0,s2
    800058b2:	ffffe097          	auipc	ra,0xffffe
    800058b6:	070080e7          	jalr	112(ra) # 80003922 <iupdate>
  iunlockput(ip);
    800058ba:	854a                	mv	a0,s2
    800058bc:	ffffe097          	auipc	ra,0xffffe
    800058c0:	392080e7          	jalr	914(ra) # 80003c4e <iunlockput>
  end_op();
    800058c4:	fffff097          	auipc	ra,0xfffff
    800058c8:	b68080e7          	jalr	-1176(ra) # 8000442c <end_op>
  return 0;
    800058cc:	4501                	li	a0,0
    800058ce:	a84d                	j	80005980 <sys_unlink+0x1c4>
    end_op();
    800058d0:	fffff097          	auipc	ra,0xfffff
    800058d4:	b5c080e7          	jalr	-1188(ra) # 8000442c <end_op>
    return -1;
    800058d8:	557d                	li	a0,-1
    800058da:	a05d                	j	80005980 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800058dc:	00003517          	auipc	a0,0x3
    800058e0:	f0450513          	addi	a0,a0,-252 # 800087e0 <syscalls+0x2f0>
    800058e4:	ffffb097          	auipc	ra,0xffffb
    800058e8:	c5c080e7          	jalr	-932(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058ec:	04c92703          	lw	a4,76(s2)
    800058f0:	02000793          	li	a5,32
    800058f4:	f6e7f9e3          	bgeu	a5,a4,80005866 <sys_unlink+0xaa>
    800058f8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058fc:	4741                	li	a4,16
    800058fe:	86ce                	mv	a3,s3
    80005900:	f1840613          	addi	a2,s0,-232
    80005904:	4581                	li	a1,0
    80005906:	854a                	mv	a0,s2
    80005908:	ffffe097          	auipc	ra,0xffffe
    8000590c:	398080e7          	jalr	920(ra) # 80003ca0 <readi>
    80005910:	47c1                	li	a5,16
    80005912:	00f51b63          	bne	a0,a5,80005928 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005916:	f1845783          	lhu	a5,-232(s0)
    8000591a:	e7a1                	bnez	a5,80005962 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000591c:	29c1                	addiw	s3,s3,16
    8000591e:	04c92783          	lw	a5,76(s2)
    80005922:	fcf9ede3          	bltu	s3,a5,800058fc <sys_unlink+0x140>
    80005926:	b781                	j	80005866 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005928:	00003517          	auipc	a0,0x3
    8000592c:	ed050513          	addi	a0,a0,-304 # 800087f8 <syscalls+0x308>
    80005930:	ffffb097          	auipc	ra,0xffffb
    80005934:	c10080e7          	jalr	-1008(ra) # 80000540 <panic>
    panic("unlink: writei");
    80005938:	00003517          	auipc	a0,0x3
    8000593c:	ed850513          	addi	a0,a0,-296 # 80008810 <syscalls+0x320>
    80005940:	ffffb097          	auipc	ra,0xffffb
    80005944:	c00080e7          	jalr	-1024(ra) # 80000540 <panic>
    dp->nlink--;
    80005948:	04a4d783          	lhu	a5,74(s1)
    8000594c:	37fd                	addiw	a5,a5,-1
    8000594e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005952:	8526                	mv	a0,s1
    80005954:	ffffe097          	auipc	ra,0xffffe
    80005958:	fce080e7          	jalr	-50(ra) # 80003922 <iupdate>
    8000595c:	b781                	j	8000589c <sys_unlink+0xe0>
    return -1;
    8000595e:	557d                	li	a0,-1
    80005960:	a005                	j	80005980 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005962:	854a                	mv	a0,s2
    80005964:	ffffe097          	auipc	ra,0xffffe
    80005968:	2ea080e7          	jalr	746(ra) # 80003c4e <iunlockput>
  iunlockput(dp);
    8000596c:	8526                	mv	a0,s1
    8000596e:	ffffe097          	auipc	ra,0xffffe
    80005972:	2e0080e7          	jalr	736(ra) # 80003c4e <iunlockput>
  end_op();
    80005976:	fffff097          	auipc	ra,0xfffff
    8000597a:	ab6080e7          	jalr	-1354(ra) # 8000442c <end_op>
  return -1;
    8000597e:	557d                	li	a0,-1
}
    80005980:	70ae                	ld	ra,232(sp)
    80005982:	740e                	ld	s0,224(sp)
    80005984:	64ee                	ld	s1,216(sp)
    80005986:	694e                	ld	s2,208(sp)
    80005988:	69ae                	ld	s3,200(sp)
    8000598a:	616d                	addi	sp,sp,240
    8000598c:	8082                	ret

000000008000598e <sys_open>:

uint64
sys_open(void)
{
    8000598e:	7131                	addi	sp,sp,-192
    80005990:	fd06                	sd	ra,184(sp)
    80005992:	f922                	sd	s0,176(sp)
    80005994:	f526                	sd	s1,168(sp)
    80005996:	f14a                	sd	s2,160(sp)
    80005998:	ed4e                	sd	s3,152(sp)
    8000599a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000599c:	08000613          	li	a2,128
    800059a0:	f5040593          	addi	a1,s0,-176
    800059a4:	4501                	li	a0,0
    800059a6:	ffffd097          	auipc	ra,0xffffd
    800059aa:	4d2080e7          	jalr	1234(ra) # 80002e78 <argstr>
    return -1;
    800059ae:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800059b0:	0c054163          	bltz	a0,80005a72 <sys_open+0xe4>
    800059b4:	f4c40593          	addi	a1,s0,-180
    800059b8:	4505                	li	a0,1
    800059ba:	ffffd097          	auipc	ra,0xffffd
    800059be:	47a080e7          	jalr	1146(ra) # 80002e34 <argint>
    800059c2:	0a054863          	bltz	a0,80005a72 <sys_open+0xe4>

  begin_op();
    800059c6:	fffff097          	auipc	ra,0xfffff
    800059ca:	9e6080e7          	jalr	-1562(ra) # 800043ac <begin_op>

  if(omode & O_CREATE){
    800059ce:	f4c42783          	lw	a5,-180(s0)
    800059d2:	2007f793          	andi	a5,a5,512
    800059d6:	cbdd                	beqz	a5,80005a8c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800059d8:	4681                	li	a3,0
    800059da:	4601                	li	a2,0
    800059dc:	4589                	li	a1,2
    800059de:	f5040513          	addi	a0,s0,-176
    800059e2:	00000097          	auipc	ra,0x0
    800059e6:	974080e7          	jalr	-1676(ra) # 80005356 <create>
    800059ea:	892a                	mv	s2,a0
    if(ip == 0){
    800059ec:	c959                	beqz	a0,80005a82 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800059ee:	04491703          	lh	a4,68(s2)
    800059f2:	478d                	li	a5,3
    800059f4:	00f71763          	bne	a4,a5,80005a02 <sys_open+0x74>
    800059f8:	04695703          	lhu	a4,70(s2)
    800059fc:	47a5                	li	a5,9
    800059fe:	0ce7ec63          	bltu	a5,a4,80005ad6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005a02:	fffff097          	auipc	ra,0xfffff
    80005a06:	dc0080e7          	jalr	-576(ra) # 800047c2 <filealloc>
    80005a0a:	89aa                	mv	s3,a0
    80005a0c:	10050263          	beqz	a0,80005b10 <sys_open+0x182>
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	904080e7          	jalr	-1788(ra) # 80005314 <fdalloc>
    80005a18:	84aa                	mv	s1,a0
    80005a1a:	0e054663          	bltz	a0,80005b06 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005a1e:	04491703          	lh	a4,68(s2)
    80005a22:	478d                	li	a5,3
    80005a24:	0cf70463          	beq	a4,a5,80005aec <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005a28:	4789                	li	a5,2
    80005a2a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005a2e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005a32:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005a36:	f4c42783          	lw	a5,-180(s0)
    80005a3a:	0017c713          	xori	a4,a5,1
    80005a3e:	8b05                	andi	a4,a4,1
    80005a40:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005a44:	0037f713          	andi	a4,a5,3
    80005a48:	00e03733          	snez	a4,a4
    80005a4c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005a50:	4007f793          	andi	a5,a5,1024
    80005a54:	c791                	beqz	a5,80005a60 <sys_open+0xd2>
    80005a56:	04491703          	lh	a4,68(s2)
    80005a5a:	4789                	li	a5,2
    80005a5c:	08f70f63          	beq	a4,a5,80005afa <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005a60:	854a                	mv	a0,s2
    80005a62:	ffffe097          	auipc	ra,0xffffe
    80005a66:	04c080e7          	jalr	76(ra) # 80003aae <iunlock>
  end_op();
    80005a6a:	fffff097          	auipc	ra,0xfffff
    80005a6e:	9c2080e7          	jalr	-1598(ra) # 8000442c <end_op>

  return fd;
}
    80005a72:	8526                	mv	a0,s1
    80005a74:	70ea                	ld	ra,184(sp)
    80005a76:	744a                	ld	s0,176(sp)
    80005a78:	74aa                	ld	s1,168(sp)
    80005a7a:	790a                	ld	s2,160(sp)
    80005a7c:	69ea                	ld	s3,152(sp)
    80005a7e:	6129                	addi	sp,sp,192
    80005a80:	8082                	ret
      end_op();
    80005a82:	fffff097          	auipc	ra,0xfffff
    80005a86:	9aa080e7          	jalr	-1622(ra) # 8000442c <end_op>
      return -1;
    80005a8a:	b7e5                	j	80005a72 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005a8c:	f5040513          	addi	a0,s0,-176
    80005a90:	ffffe097          	auipc	ra,0xffffe
    80005a94:	70c080e7          	jalr	1804(ra) # 8000419c <namei>
    80005a98:	892a                	mv	s2,a0
    80005a9a:	c905                	beqz	a0,80005aca <sys_open+0x13c>
    ilock(ip);
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	f50080e7          	jalr	-176(ra) # 800039ec <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005aa4:	04491703          	lh	a4,68(s2)
    80005aa8:	4785                	li	a5,1
    80005aaa:	f4f712e3          	bne	a4,a5,800059ee <sys_open+0x60>
    80005aae:	f4c42783          	lw	a5,-180(s0)
    80005ab2:	dba1                	beqz	a5,80005a02 <sys_open+0x74>
      iunlockput(ip);
    80005ab4:	854a                	mv	a0,s2
    80005ab6:	ffffe097          	auipc	ra,0xffffe
    80005aba:	198080e7          	jalr	408(ra) # 80003c4e <iunlockput>
      end_op();
    80005abe:	fffff097          	auipc	ra,0xfffff
    80005ac2:	96e080e7          	jalr	-1682(ra) # 8000442c <end_op>
      return -1;
    80005ac6:	54fd                	li	s1,-1
    80005ac8:	b76d                	j	80005a72 <sys_open+0xe4>
      end_op();
    80005aca:	fffff097          	auipc	ra,0xfffff
    80005ace:	962080e7          	jalr	-1694(ra) # 8000442c <end_op>
      return -1;
    80005ad2:	54fd                	li	s1,-1
    80005ad4:	bf79                	j	80005a72 <sys_open+0xe4>
    iunlockput(ip);
    80005ad6:	854a                	mv	a0,s2
    80005ad8:	ffffe097          	auipc	ra,0xffffe
    80005adc:	176080e7          	jalr	374(ra) # 80003c4e <iunlockput>
    end_op();
    80005ae0:	fffff097          	auipc	ra,0xfffff
    80005ae4:	94c080e7          	jalr	-1716(ra) # 8000442c <end_op>
    return -1;
    80005ae8:	54fd                	li	s1,-1
    80005aea:	b761                	j	80005a72 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005aec:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005af0:	04691783          	lh	a5,70(s2)
    80005af4:	02f99223          	sh	a5,36(s3)
    80005af8:	bf2d                	j	80005a32 <sys_open+0xa4>
    itrunc(ip);
    80005afa:	854a                	mv	a0,s2
    80005afc:	ffffe097          	auipc	ra,0xffffe
    80005b00:	ffe080e7          	jalr	-2(ra) # 80003afa <itrunc>
    80005b04:	bfb1                	j	80005a60 <sys_open+0xd2>
      fileclose(f);
    80005b06:	854e                	mv	a0,s3
    80005b08:	fffff097          	auipc	ra,0xfffff
    80005b0c:	d76080e7          	jalr	-650(ra) # 8000487e <fileclose>
    iunlockput(ip);
    80005b10:	854a                	mv	a0,s2
    80005b12:	ffffe097          	auipc	ra,0xffffe
    80005b16:	13c080e7          	jalr	316(ra) # 80003c4e <iunlockput>
    end_op();
    80005b1a:	fffff097          	auipc	ra,0xfffff
    80005b1e:	912080e7          	jalr	-1774(ra) # 8000442c <end_op>
    return -1;
    80005b22:	54fd                	li	s1,-1
    80005b24:	b7b9                	j	80005a72 <sys_open+0xe4>

0000000080005b26 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005b26:	7175                	addi	sp,sp,-144
    80005b28:	e506                	sd	ra,136(sp)
    80005b2a:	e122                	sd	s0,128(sp)
    80005b2c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005b2e:	fffff097          	auipc	ra,0xfffff
    80005b32:	87e080e7          	jalr	-1922(ra) # 800043ac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005b36:	08000613          	li	a2,128
    80005b3a:	f7040593          	addi	a1,s0,-144
    80005b3e:	4501                	li	a0,0
    80005b40:	ffffd097          	auipc	ra,0xffffd
    80005b44:	338080e7          	jalr	824(ra) # 80002e78 <argstr>
    80005b48:	02054963          	bltz	a0,80005b7a <sys_mkdir+0x54>
    80005b4c:	4681                	li	a3,0
    80005b4e:	4601                	li	a2,0
    80005b50:	4585                	li	a1,1
    80005b52:	f7040513          	addi	a0,s0,-144
    80005b56:	00000097          	auipc	ra,0x0
    80005b5a:	800080e7          	jalr	-2048(ra) # 80005356 <create>
    80005b5e:	cd11                	beqz	a0,80005b7a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b60:	ffffe097          	auipc	ra,0xffffe
    80005b64:	0ee080e7          	jalr	238(ra) # 80003c4e <iunlockput>
  end_op();
    80005b68:	fffff097          	auipc	ra,0xfffff
    80005b6c:	8c4080e7          	jalr	-1852(ra) # 8000442c <end_op>
  return 0;
    80005b70:	4501                	li	a0,0
}
    80005b72:	60aa                	ld	ra,136(sp)
    80005b74:	640a                	ld	s0,128(sp)
    80005b76:	6149                	addi	sp,sp,144
    80005b78:	8082                	ret
    end_op();
    80005b7a:	fffff097          	auipc	ra,0xfffff
    80005b7e:	8b2080e7          	jalr	-1870(ra) # 8000442c <end_op>
    return -1;
    80005b82:	557d                	li	a0,-1
    80005b84:	b7fd                	j	80005b72 <sys_mkdir+0x4c>

0000000080005b86 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b86:	7135                	addi	sp,sp,-160
    80005b88:	ed06                	sd	ra,152(sp)
    80005b8a:	e922                	sd	s0,144(sp)
    80005b8c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005b8e:	fffff097          	auipc	ra,0xfffff
    80005b92:	81e080e7          	jalr	-2018(ra) # 800043ac <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b96:	08000613          	li	a2,128
    80005b9a:	f7040593          	addi	a1,s0,-144
    80005b9e:	4501                	li	a0,0
    80005ba0:	ffffd097          	auipc	ra,0xffffd
    80005ba4:	2d8080e7          	jalr	728(ra) # 80002e78 <argstr>
    80005ba8:	04054a63          	bltz	a0,80005bfc <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005bac:	f6c40593          	addi	a1,s0,-148
    80005bb0:	4505                	li	a0,1
    80005bb2:	ffffd097          	auipc	ra,0xffffd
    80005bb6:	282080e7          	jalr	642(ra) # 80002e34 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005bba:	04054163          	bltz	a0,80005bfc <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005bbe:	f6840593          	addi	a1,s0,-152
    80005bc2:	4509                	li	a0,2
    80005bc4:	ffffd097          	auipc	ra,0xffffd
    80005bc8:	270080e7          	jalr	624(ra) # 80002e34 <argint>
     argint(1, &major) < 0 ||
    80005bcc:	02054863          	bltz	a0,80005bfc <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005bd0:	f6841683          	lh	a3,-152(s0)
    80005bd4:	f6c41603          	lh	a2,-148(s0)
    80005bd8:	458d                	li	a1,3
    80005bda:	f7040513          	addi	a0,s0,-144
    80005bde:	fffff097          	auipc	ra,0xfffff
    80005be2:	778080e7          	jalr	1912(ra) # 80005356 <create>
     argint(2, &minor) < 0 ||
    80005be6:	c919                	beqz	a0,80005bfc <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005be8:	ffffe097          	auipc	ra,0xffffe
    80005bec:	066080e7          	jalr	102(ra) # 80003c4e <iunlockput>
  end_op();
    80005bf0:	fffff097          	auipc	ra,0xfffff
    80005bf4:	83c080e7          	jalr	-1988(ra) # 8000442c <end_op>
  return 0;
    80005bf8:	4501                	li	a0,0
    80005bfa:	a031                	j	80005c06 <sys_mknod+0x80>
    end_op();
    80005bfc:	fffff097          	auipc	ra,0xfffff
    80005c00:	830080e7          	jalr	-2000(ra) # 8000442c <end_op>
    return -1;
    80005c04:	557d                	li	a0,-1
}
    80005c06:	60ea                	ld	ra,152(sp)
    80005c08:	644a                	ld	s0,144(sp)
    80005c0a:	610d                	addi	sp,sp,160
    80005c0c:	8082                	ret

0000000080005c0e <sys_chdir>:

uint64
sys_chdir(void)
{
    80005c0e:	7135                	addi	sp,sp,-160
    80005c10:	ed06                	sd	ra,152(sp)
    80005c12:	e922                	sd	s0,144(sp)
    80005c14:	e526                	sd	s1,136(sp)
    80005c16:	e14a                	sd	s2,128(sp)
    80005c18:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005c1a:	ffffc097          	auipc	ra,0xffffc
    80005c1e:	1ae080e7          	jalr	430(ra) # 80001dc8 <myproc>
    80005c22:	892a                	mv	s2,a0
  
  begin_op();
    80005c24:	ffffe097          	auipc	ra,0xffffe
    80005c28:	788080e7          	jalr	1928(ra) # 800043ac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005c2c:	08000613          	li	a2,128
    80005c30:	f6040593          	addi	a1,s0,-160
    80005c34:	4501                	li	a0,0
    80005c36:	ffffd097          	auipc	ra,0xffffd
    80005c3a:	242080e7          	jalr	578(ra) # 80002e78 <argstr>
    80005c3e:	04054b63          	bltz	a0,80005c94 <sys_chdir+0x86>
    80005c42:	f6040513          	addi	a0,s0,-160
    80005c46:	ffffe097          	auipc	ra,0xffffe
    80005c4a:	556080e7          	jalr	1366(ra) # 8000419c <namei>
    80005c4e:	84aa                	mv	s1,a0
    80005c50:	c131                	beqz	a0,80005c94 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005c52:	ffffe097          	auipc	ra,0xffffe
    80005c56:	d9a080e7          	jalr	-614(ra) # 800039ec <ilock>
  if(ip->type != T_DIR){
    80005c5a:	04449703          	lh	a4,68(s1)
    80005c5e:	4785                	li	a5,1
    80005c60:	04f71063          	bne	a4,a5,80005ca0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005c64:	8526                	mv	a0,s1
    80005c66:	ffffe097          	auipc	ra,0xffffe
    80005c6a:	e48080e7          	jalr	-440(ra) # 80003aae <iunlock>
  iput(p->cwd);
    80005c6e:	15093503          	ld	a0,336(s2)
    80005c72:	ffffe097          	auipc	ra,0xffffe
    80005c76:	f34080e7          	jalr	-204(ra) # 80003ba6 <iput>
  end_op();
    80005c7a:	ffffe097          	auipc	ra,0xffffe
    80005c7e:	7b2080e7          	jalr	1970(ra) # 8000442c <end_op>
  p->cwd = ip;
    80005c82:	14993823          	sd	s1,336(s2)
  return 0;
    80005c86:	4501                	li	a0,0
}
    80005c88:	60ea                	ld	ra,152(sp)
    80005c8a:	644a                	ld	s0,144(sp)
    80005c8c:	64aa                	ld	s1,136(sp)
    80005c8e:	690a                	ld	s2,128(sp)
    80005c90:	610d                	addi	sp,sp,160
    80005c92:	8082                	ret
    end_op();
    80005c94:	ffffe097          	auipc	ra,0xffffe
    80005c98:	798080e7          	jalr	1944(ra) # 8000442c <end_op>
    return -1;
    80005c9c:	557d                	li	a0,-1
    80005c9e:	b7ed                	j	80005c88 <sys_chdir+0x7a>
    iunlockput(ip);
    80005ca0:	8526                	mv	a0,s1
    80005ca2:	ffffe097          	auipc	ra,0xffffe
    80005ca6:	fac080e7          	jalr	-84(ra) # 80003c4e <iunlockput>
    end_op();
    80005caa:	ffffe097          	auipc	ra,0xffffe
    80005cae:	782080e7          	jalr	1922(ra) # 8000442c <end_op>
    return -1;
    80005cb2:	557d                	li	a0,-1
    80005cb4:	bfd1                	j	80005c88 <sys_chdir+0x7a>

0000000080005cb6 <sys_exec>:

uint64
sys_exec(void)
{
    80005cb6:	7145                	addi	sp,sp,-464
    80005cb8:	e786                	sd	ra,456(sp)
    80005cba:	e3a2                	sd	s0,448(sp)
    80005cbc:	ff26                	sd	s1,440(sp)
    80005cbe:	fb4a                	sd	s2,432(sp)
    80005cc0:	f74e                	sd	s3,424(sp)
    80005cc2:	f352                	sd	s4,416(sp)
    80005cc4:	ef56                	sd	s5,408(sp)
    80005cc6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005cc8:	08000613          	li	a2,128
    80005ccc:	f4040593          	addi	a1,s0,-192
    80005cd0:	4501                	li	a0,0
    80005cd2:	ffffd097          	auipc	ra,0xffffd
    80005cd6:	1a6080e7          	jalr	422(ra) # 80002e78 <argstr>
    return -1;
    80005cda:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005cdc:	0c054a63          	bltz	a0,80005db0 <sys_exec+0xfa>
    80005ce0:	e3840593          	addi	a1,s0,-456
    80005ce4:	4505                	li	a0,1
    80005ce6:	ffffd097          	auipc	ra,0xffffd
    80005cea:	170080e7          	jalr	368(ra) # 80002e56 <argaddr>
    80005cee:	0c054163          	bltz	a0,80005db0 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005cf2:	10000613          	li	a2,256
    80005cf6:	4581                	li	a1,0
    80005cf8:	e4040513          	addi	a0,s0,-448
    80005cfc:	ffffb097          	auipc	ra,0xffffb
    80005d00:	ffc080e7          	jalr	-4(ra) # 80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005d04:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005d08:	89a6                	mv	s3,s1
    80005d0a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005d0c:	02000a13          	li	s4,32
    80005d10:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005d14:	00391793          	slli	a5,s2,0x3
    80005d18:	e3040593          	addi	a1,s0,-464
    80005d1c:	e3843503          	ld	a0,-456(s0)
    80005d20:	953e                	add	a0,a0,a5
    80005d22:	ffffd097          	auipc	ra,0xffffd
    80005d26:	078080e7          	jalr	120(ra) # 80002d9a <fetchaddr>
    80005d2a:	02054a63          	bltz	a0,80005d5e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005d2e:	e3043783          	ld	a5,-464(s0)
    80005d32:	c3b9                	beqz	a5,80005d78 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005d34:	ffffb097          	auipc	ra,0xffffb
    80005d38:	dd8080e7          	jalr	-552(ra) # 80000b0c <kalloc>
    80005d3c:	85aa                	mv	a1,a0
    80005d3e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005d42:	cd11                	beqz	a0,80005d5e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d44:	6605                	lui	a2,0x1
    80005d46:	e3043503          	ld	a0,-464(s0)
    80005d4a:	ffffd097          	auipc	ra,0xffffd
    80005d4e:	0a2080e7          	jalr	162(ra) # 80002dec <fetchstr>
    80005d52:	00054663          	bltz	a0,80005d5e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005d56:	0905                	addi	s2,s2,1
    80005d58:	09a1                	addi	s3,s3,8
    80005d5a:	fb491be3          	bne	s2,s4,80005d10 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d5e:	10048913          	addi	s2,s1,256
    80005d62:	6088                	ld	a0,0(s1)
    80005d64:	c529                	beqz	a0,80005dae <sys_exec+0xf8>
    kfree(argv[i]);
    80005d66:	ffffb097          	auipc	ra,0xffffb
    80005d6a:	caa080e7          	jalr	-854(ra) # 80000a10 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d6e:	04a1                	addi	s1,s1,8
    80005d70:	ff2499e3          	bne	s1,s2,80005d62 <sys_exec+0xac>
  return -1;
    80005d74:	597d                	li	s2,-1
    80005d76:	a82d                	j	80005db0 <sys_exec+0xfa>
      argv[i] = 0;
    80005d78:	0a8e                	slli	s5,s5,0x3
    80005d7a:	fc040793          	addi	a5,s0,-64
    80005d7e:	9abe                	add	s5,s5,a5
    80005d80:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd7e80>
  int ret = exec(path, argv);
    80005d84:	e4040593          	addi	a1,s0,-448
    80005d88:	f4040513          	addi	a0,s0,-192
    80005d8c:	fffff097          	auipc	ra,0xfffff
    80005d90:	178080e7          	jalr	376(ra) # 80004f04 <exec>
    80005d94:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d96:	10048993          	addi	s3,s1,256
    80005d9a:	6088                	ld	a0,0(s1)
    80005d9c:	c911                	beqz	a0,80005db0 <sys_exec+0xfa>
    kfree(argv[i]);
    80005d9e:	ffffb097          	auipc	ra,0xffffb
    80005da2:	c72080e7          	jalr	-910(ra) # 80000a10 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005da6:	04a1                	addi	s1,s1,8
    80005da8:	ff3499e3          	bne	s1,s3,80005d9a <sys_exec+0xe4>
    80005dac:	a011                	j	80005db0 <sys_exec+0xfa>
  return -1;
    80005dae:	597d                	li	s2,-1
}
    80005db0:	854a                	mv	a0,s2
    80005db2:	60be                	ld	ra,456(sp)
    80005db4:	641e                	ld	s0,448(sp)
    80005db6:	74fa                	ld	s1,440(sp)
    80005db8:	795a                	ld	s2,432(sp)
    80005dba:	79ba                	ld	s3,424(sp)
    80005dbc:	7a1a                	ld	s4,416(sp)
    80005dbe:	6afa                	ld	s5,408(sp)
    80005dc0:	6179                	addi	sp,sp,464
    80005dc2:	8082                	ret

0000000080005dc4 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005dc4:	7139                	addi	sp,sp,-64
    80005dc6:	fc06                	sd	ra,56(sp)
    80005dc8:	f822                	sd	s0,48(sp)
    80005dca:	f426                	sd	s1,40(sp)
    80005dcc:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005dce:	ffffc097          	auipc	ra,0xffffc
    80005dd2:	ffa080e7          	jalr	-6(ra) # 80001dc8 <myproc>
    80005dd6:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005dd8:	fd840593          	addi	a1,s0,-40
    80005ddc:	4501                	li	a0,0
    80005dde:	ffffd097          	auipc	ra,0xffffd
    80005de2:	078080e7          	jalr	120(ra) # 80002e56 <argaddr>
    return -1;
    80005de6:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005de8:	0e054063          	bltz	a0,80005ec8 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005dec:	fc840593          	addi	a1,s0,-56
    80005df0:	fd040513          	addi	a0,s0,-48
    80005df4:	fffff097          	auipc	ra,0xfffff
    80005df8:	de0080e7          	jalr	-544(ra) # 80004bd4 <pipealloc>
    return -1;
    80005dfc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005dfe:	0c054563          	bltz	a0,80005ec8 <sys_pipe+0x104>
  fd0 = -1;
    80005e02:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005e06:	fd043503          	ld	a0,-48(s0)
    80005e0a:	fffff097          	auipc	ra,0xfffff
    80005e0e:	50a080e7          	jalr	1290(ra) # 80005314 <fdalloc>
    80005e12:	fca42223          	sw	a0,-60(s0)
    80005e16:	08054c63          	bltz	a0,80005eae <sys_pipe+0xea>
    80005e1a:	fc843503          	ld	a0,-56(s0)
    80005e1e:	fffff097          	auipc	ra,0xfffff
    80005e22:	4f6080e7          	jalr	1270(ra) # 80005314 <fdalloc>
    80005e26:	fca42023          	sw	a0,-64(s0)
    80005e2a:	06054863          	bltz	a0,80005e9a <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e2e:	4691                	li	a3,4
    80005e30:	fc440613          	addi	a2,s0,-60
    80005e34:	fd843583          	ld	a1,-40(s0)
    80005e38:	68a8                	ld	a0,80(s1)
    80005e3a:	ffffc097          	auipc	ra,0xffffc
    80005e3e:	870080e7          	jalr	-1936(ra) # 800016aa <copyout>
    80005e42:	02054063          	bltz	a0,80005e62 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005e46:	4691                	li	a3,4
    80005e48:	fc040613          	addi	a2,s0,-64
    80005e4c:	fd843583          	ld	a1,-40(s0)
    80005e50:	0591                	addi	a1,a1,4
    80005e52:	68a8                	ld	a0,80(s1)
    80005e54:	ffffc097          	auipc	ra,0xffffc
    80005e58:	856080e7          	jalr	-1962(ra) # 800016aa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e5c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e5e:	06055563          	bgez	a0,80005ec8 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005e62:	fc442783          	lw	a5,-60(s0)
    80005e66:	07e9                	addi	a5,a5,26
    80005e68:	078e                	slli	a5,a5,0x3
    80005e6a:	97a6                	add	a5,a5,s1
    80005e6c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005e70:	fc042503          	lw	a0,-64(s0)
    80005e74:	0569                	addi	a0,a0,26
    80005e76:	050e                	slli	a0,a0,0x3
    80005e78:	9526                	add	a0,a0,s1
    80005e7a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005e7e:	fd043503          	ld	a0,-48(s0)
    80005e82:	fffff097          	auipc	ra,0xfffff
    80005e86:	9fc080e7          	jalr	-1540(ra) # 8000487e <fileclose>
    fileclose(wf);
    80005e8a:	fc843503          	ld	a0,-56(s0)
    80005e8e:	fffff097          	auipc	ra,0xfffff
    80005e92:	9f0080e7          	jalr	-1552(ra) # 8000487e <fileclose>
    return -1;
    80005e96:	57fd                	li	a5,-1
    80005e98:	a805                	j	80005ec8 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005e9a:	fc442783          	lw	a5,-60(s0)
    80005e9e:	0007c863          	bltz	a5,80005eae <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005ea2:	01a78513          	addi	a0,a5,26
    80005ea6:	050e                	slli	a0,a0,0x3
    80005ea8:	9526                	add	a0,a0,s1
    80005eaa:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005eae:	fd043503          	ld	a0,-48(s0)
    80005eb2:	fffff097          	auipc	ra,0xfffff
    80005eb6:	9cc080e7          	jalr	-1588(ra) # 8000487e <fileclose>
    fileclose(wf);
    80005eba:	fc843503          	ld	a0,-56(s0)
    80005ebe:	fffff097          	auipc	ra,0xfffff
    80005ec2:	9c0080e7          	jalr	-1600(ra) # 8000487e <fileclose>
    return -1;
    80005ec6:	57fd                	li	a5,-1
}
    80005ec8:	853e                	mv	a0,a5
    80005eca:	70e2                	ld	ra,56(sp)
    80005ecc:	7442                	ld	s0,48(sp)
    80005ece:	74a2                	ld	s1,40(sp)
    80005ed0:	6121                	addi	sp,sp,64
    80005ed2:	8082                	ret
	...

0000000080005ee0 <kernelvec>:
    80005ee0:	7111                	addi	sp,sp,-256
    80005ee2:	e006                	sd	ra,0(sp)
    80005ee4:	e40a                	sd	sp,8(sp)
    80005ee6:	e80e                	sd	gp,16(sp)
    80005ee8:	ec12                	sd	tp,24(sp)
    80005eea:	f016                	sd	t0,32(sp)
    80005eec:	f41a                	sd	t1,40(sp)
    80005eee:	f81e                	sd	t2,48(sp)
    80005ef0:	fc22                	sd	s0,56(sp)
    80005ef2:	e0a6                	sd	s1,64(sp)
    80005ef4:	e4aa                	sd	a0,72(sp)
    80005ef6:	e8ae                	sd	a1,80(sp)
    80005ef8:	ecb2                	sd	a2,88(sp)
    80005efa:	f0b6                	sd	a3,96(sp)
    80005efc:	f4ba                	sd	a4,104(sp)
    80005efe:	f8be                	sd	a5,112(sp)
    80005f00:	fcc2                	sd	a6,120(sp)
    80005f02:	e146                	sd	a7,128(sp)
    80005f04:	e54a                	sd	s2,136(sp)
    80005f06:	e94e                	sd	s3,144(sp)
    80005f08:	ed52                	sd	s4,152(sp)
    80005f0a:	f156                	sd	s5,160(sp)
    80005f0c:	f55a                	sd	s6,168(sp)
    80005f0e:	f95e                	sd	s7,176(sp)
    80005f10:	fd62                	sd	s8,184(sp)
    80005f12:	e1e6                	sd	s9,192(sp)
    80005f14:	e5ea                	sd	s10,200(sp)
    80005f16:	e9ee                	sd	s11,208(sp)
    80005f18:	edf2                	sd	t3,216(sp)
    80005f1a:	f1f6                	sd	t4,224(sp)
    80005f1c:	f5fa                	sd	t5,232(sp)
    80005f1e:	f9fe                	sd	t6,240(sp)
    80005f20:	d47fc0ef          	jal	ra,80002c66 <kerneltrap>
    80005f24:	6082                	ld	ra,0(sp)
    80005f26:	6122                	ld	sp,8(sp)
    80005f28:	61c2                	ld	gp,16(sp)
    80005f2a:	7282                	ld	t0,32(sp)
    80005f2c:	7322                	ld	t1,40(sp)
    80005f2e:	73c2                	ld	t2,48(sp)
    80005f30:	7462                	ld	s0,56(sp)
    80005f32:	6486                	ld	s1,64(sp)
    80005f34:	6526                	ld	a0,72(sp)
    80005f36:	65c6                	ld	a1,80(sp)
    80005f38:	6666                	ld	a2,88(sp)
    80005f3a:	7686                	ld	a3,96(sp)
    80005f3c:	7726                	ld	a4,104(sp)
    80005f3e:	77c6                	ld	a5,112(sp)
    80005f40:	7866                	ld	a6,120(sp)
    80005f42:	688a                	ld	a7,128(sp)
    80005f44:	692a                	ld	s2,136(sp)
    80005f46:	69ca                	ld	s3,144(sp)
    80005f48:	6a6a                	ld	s4,152(sp)
    80005f4a:	7a8a                	ld	s5,160(sp)
    80005f4c:	7b2a                	ld	s6,168(sp)
    80005f4e:	7bca                	ld	s7,176(sp)
    80005f50:	7c6a                	ld	s8,184(sp)
    80005f52:	6c8e                	ld	s9,192(sp)
    80005f54:	6d2e                	ld	s10,200(sp)
    80005f56:	6dce                	ld	s11,208(sp)
    80005f58:	6e6e                	ld	t3,216(sp)
    80005f5a:	7e8e                	ld	t4,224(sp)
    80005f5c:	7f2e                	ld	t5,232(sp)
    80005f5e:	7fce                	ld	t6,240(sp)
    80005f60:	6111                	addi	sp,sp,256
    80005f62:	10200073          	sret
    80005f66:	00000013          	nop
    80005f6a:	00000013          	nop
    80005f6e:	0001                	nop

0000000080005f70 <timervec>:
    80005f70:	34051573          	csrrw	a0,mscratch,a0
    80005f74:	e10c                	sd	a1,0(a0)
    80005f76:	e510                	sd	a2,8(a0)
    80005f78:	e914                	sd	a3,16(a0)
    80005f7a:	710c                	ld	a1,32(a0)
    80005f7c:	7510                	ld	a2,40(a0)
    80005f7e:	6194                	ld	a3,0(a1)
    80005f80:	96b2                	add	a3,a3,a2
    80005f82:	e194                	sd	a3,0(a1)
    80005f84:	4589                	li	a1,2
    80005f86:	14459073          	csrw	sip,a1
    80005f8a:	6914                	ld	a3,16(a0)
    80005f8c:	6510                	ld	a2,8(a0)
    80005f8e:	610c                	ld	a1,0(a0)
    80005f90:	34051573          	csrrw	a0,mscratch,a0
    80005f94:	30200073          	mret
	...

0000000080005f9a <plicinit>:
    80005f9a:	1141                	addi	sp,sp,-16
    80005f9c:	e422                	sd	s0,8(sp)
    80005f9e:	0800                	addi	s0,sp,16
    80005fa0:	0c0007b7          	lui	a5,0xc000
    80005fa4:	4705                	li	a4,1
    80005fa6:	d798                	sw	a4,40(a5)
    80005fa8:	c3d8                	sw	a4,4(a5)
    80005faa:	6422                	ld	s0,8(sp)
    80005fac:	0141                	addi	sp,sp,16
    80005fae:	8082                	ret

0000000080005fb0 <plicinithart>:
    80005fb0:	1141                	addi	sp,sp,-16
    80005fb2:	e406                	sd	ra,8(sp)
    80005fb4:	e022                	sd	s0,0(sp)
    80005fb6:	0800                	addi	s0,sp,16
    80005fb8:	ffffc097          	auipc	ra,0xffffc
    80005fbc:	de4080e7          	jalr	-540(ra) # 80001d9c <cpuid>
    80005fc0:	0085171b          	slliw	a4,a0,0x8
    80005fc4:	0c0027b7          	lui	a5,0xc002
    80005fc8:	97ba                	add	a5,a5,a4
    80005fca:	40200713          	li	a4,1026
    80005fce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80005fd2:	00d5151b          	slliw	a0,a0,0xd
    80005fd6:	0c2017b7          	lui	a5,0xc201
    80005fda:	953e                	add	a0,a0,a5
    80005fdc:	00052023          	sw	zero,0(a0)
    80005fe0:	60a2                	ld	ra,8(sp)
    80005fe2:	6402                	ld	s0,0(sp)
    80005fe4:	0141                	addi	sp,sp,16
    80005fe6:	8082                	ret

0000000080005fe8 <plic_claim>:
    80005fe8:	1141                	addi	sp,sp,-16
    80005fea:	e406                	sd	ra,8(sp)
    80005fec:	e022                	sd	s0,0(sp)
    80005fee:	0800                	addi	s0,sp,16
    80005ff0:	ffffc097          	auipc	ra,0xffffc
    80005ff4:	dac080e7          	jalr	-596(ra) # 80001d9c <cpuid>
    80005ff8:	00d5179b          	slliw	a5,a0,0xd
    80005ffc:	0c201537          	lui	a0,0xc201
    80006000:	953e                	add	a0,a0,a5
    80006002:	4148                	lw	a0,4(a0)
    80006004:	60a2                	ld	ra,8(sp)
    80006006:	6402                	ld	s0,0(sp)
    80006008:	0141                	addi	sp,sp,16
    8000600a:	8082                	ret

000000008000600c <plic_complete>:
    8000600c:	1101                	addi	sp,sp,-32
    8000600e:	ec06                	sd	ra,24(sp)
    80006010:	e822                	sd	s0,16(sp)
    80006012:	e426                	sd	s1,8(sp)
    80006014:	1000                	addi	s0,sp,32
    80006016:	84aa                	mv	s1,a0
    80006018:	ffffc097          	auipc	ra,0xffffc
    8000601c:	d84080e7          	jalr	-636(ra) # 80001d9c <cpuid>
    80006020:	00d5151b          	slliw	a0,a0,0xd
    80006024:	0c2017b7          	lui	a5,0xc201
    80006028:	97aa                	add	a5,a5,a0
    8000602a:	c3c4                	sw	s1,4(a5)
    8000602c:	60e2                	ld	ra,24(sp)
    8000602e:	6442                	ld	s0,16(sp)
    80006030:	64a2                	ld	s1,8(sp)
    80006032:	6105                	addi	sp,sp,32
    80006034:	8082                	ret

0000000080006036 <free_desc>:
    80006036:	1141                	addi	sp,sp,-16
    80006038:	e406                	sd	ra,8(sp)
    8000603a:	e022                	sd	s0,0(sp)
    8000603c:	0800                	addi	s0,sp,16
    8000603e:	479d                	li	a5,7
    80006040:	04a7cc63          	blt	a5,a0,80006098 <free_desc+0x62>
    80006044:	0001e797          	auipc	a5,0x1e
    80006048:	fbc78793          	addi	a5,a5,-68 # 80024000 <disk>
    8000604c:	00a78733          	add	a4,a5,a0
    80006050:	6789                	lui	a5,0x2
    80006052:	97ba                	add	a5,a5,a4
    80006054:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006058:	eba1                	bnez	a5,800060a8 <free_desc+0x72>
    8000605a:	00451713          	slli	a4,a0,0x4
    8000605e:	00020797          	auipc	a5,0x20
    80006062:	fa27b783          	ld	a5,-94(a5) # 80026000 <disk+0x2000>
    80006066:	97ba                	add	a5,a5,a4
    80006068:	0007b023          	sd	zero,0(a5)
    8000606c:	0001e797          	auipc	a5,0x1e
    80006070:	f9478793          	addi	a5,a5,-108 # 80024000 <disk>
    80006074:	97aa                	add	a5,a5,a0
    80006076:	6509                	lui	a0,0x2
    80006078:	953e                	add	a0,a0,a5
    8000607a:	4785                	li	a5,1
    8000607c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
    80006080:	00020517          	auipc	a0,0x20
    80006084:	f9850513          	addi	a0,a0,-104 # 80026018 <disk+0x2018>
    80006088:	ffffc097          	auipc	ra,0xffffc
    8000608c:	64e080e7          	jalr	1614(ra) # 800026d6 <wakeup>
    80006090:	60a2                	ld	ra,8(sp)
    80006092:	6402                	ld	s0,0(sp)
    80006094:	0141                	addi	sp,sp,16
    80006096:	8082                	ret
    80006098:	00002517          	auipc	a0,0x2
    8000609c:	78850513          	addi	a0,a0,1928 # 80008820 <syscalls+0x330>
    800060a0:	ffffa097          	auipc	ra,0xffffa
    800060a4:	4a0080e7          	jalr	1184(ra) # 80000540 <panic>
    800060a8:	00002517          	auipc	a0,0x2
    800060ac:	79050513          	addi	a0,a0,1936 # 80008838 <syscalls+0x348>
    800060b0:	ffffa097          	auipc	ra,0xffffa
    800060b4:	490080e7          	jalr	1168(ra) # 80000540 <panic>

00000000800060b8 <virtio_disk_init>:
    800060b8:	1101                	addi	sp,sp,-32
    800060ba:	ec06                	sd	ra,24(sp)
    800060bc:	e822                	sd	s0,16(sp)
    800060be:	e426                	sd	s1,8(sp)
    800060c0:	1000                	addi	s0,sp,32
    800060c2:	00002597          	auipc	a1,0x2
    800060c6:	78e58593          	addi	a1,a1,1934 # 80008850 <syscalls+0x360>
    800060ca:	00020517          	auipc	a0,0x20
    800060ce:	fde50513          	addi	a0,a0,-34 # 800260a8 <disk+0x20a8>
    800060d2:	ffffb097          	auipc	ra,0xffffb
    800060d6:	a9a080e7          	jalr	-1382(ra) # 80000b6c <initlock>
    800060da:	100017b7          	lui	a5,0x10001
    800060de:	4398                	lw	a4,0(a5)
    800060e0:	2701                	sext.w	a4,a4
    800060e2:	747277b7          	lui	a5,0x74727
    800060e6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800060ea:	0ef71163          	bne	a4,a5,800061cc <virtio_disk_init+0x114>
    800060ee:	100017b7          	lui	a5,0x10001
    800060f2:	43dc                	lw	a5,4(a5)
    800060f4:	2781                	sext.w	a5,a5
    800060f6:	4705                	li	a4,1
    800060f8:	0ce79a63          	bne	a5,a4,800061cc <virtio_disk_init+0x114>
    800060fc:	100017b7          	lui	a5,0x10001
    80006100:	479c                	lw	a5,8(a5)
    80006102:	2781                	sext.w	a5,a5
    80006104:	4709                	li	a4,2
    80006106:	0ce79363          	bne	a5,a4,800061cc <virtio_disk_init+0x114>
    8000610a:	100017b7          	lui	a5,0x10001
    8000610e:	47d8                	lw	a4,12(a5)
    80006110:	2701                	sext.w	a4,a4
    80006112:	554d47b7          	lui	a5,0x554d4
    80006116:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000611a:	0af71963          	bne	a4,a5,800061cc <virtio_disk_init+0x114>
    8000611e:	100017b7          	lui	a5,0x10001
    80006122:	4705                	li	a4,1
    80006124:	dbb8                	sw	a4,112(a5)
    80006126:	470d                	li	a4,3
    80006128:	dbb8                	sw	a4,112(a5)
    8000612a:	4b94                	lw	a3,16(a5)
    8000612c:	c7ffe737          	lui	a4,0xc7ffe
    80006130:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd775f>
    80006134:	8f75                	and	a4,a4,a3
    80006136:	2701                	sext.w	a4,a4
    80006138:	d398                	sw	a4,32(a5)
    8000613a:	472d                	li	a4,11
    8000613c:	dbb8                	sw	a4,112(a5)
    8000613e:	473d                	li	a4,15
    80006140:	dbb8                	sw	a4,112(a5)
    80006142:	6705                	lui	a4,0x1
    80006144:	d798                	sw	a4,40(a5)
    80006146:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    8000614a:	5bdc                	lw	a5,52(a5)
    8000614c:	2781                	sext.w	a5,a5
    8000614e:	c7d9                	beqz	a5,800061dc <virtio_disk_init+0x124>
    80006150:	471d                	li	a4,7
    80006152:	08f77d63          	bgeu	a4,a5,800061ec <virtio_disk_init+0x134>
    80006156:	100014b7          	lui	s1,0x10001
    8000615a:	47a1                	li	a5,8
    8000615c:	dc9c                	sw	a5,56(s1)
    8000615e:	6609                	lui	a2,0x2
    80006160:	4581                	li	a1,0
    80006162:	0001e517          	auipc	a0,0x1e
    80006166:	e9e50513          	addi	a0,a0,-354 # 80024000 <disk>
    8000616a:	ffffb097          	auipc	ra,0xffffb
    8000616e:	b8e080e7          	jalr	-1138(ra) # 80000cf8 <memset>
    80006172:	0001e717          	auipc	a4,0x1e
    80006176:	e8e70713          	addi	a4,a4,-370 # 80024000 <disk>
    8000617a:	00c75793          	srli	a5,a4,0xc
    8000617e:	2781                	sext.w	a5,a5
    80006180:	c0bc                	sw	a5,64(s1)
    80006182:	00020797          	auipc	a5,0x20
    80006186:	e7e78793          	addi	a5,a5,-386 # 80026000 <disk+0x2000>
    8000618a:	e398                	sd	a4,0(a5)
    8000618c:	0001e717          	auipc	a4,0x1e
    80006190:	ef470713          	addi	a4,a4,-268 # 80024080 <disk+0x80>
    80006194:	e798                	sd	a4,8(a5)
    80006196:	0001f717          	auipc	a4,0x1f
    8000619a:	e6a70713          	addi	a4,a4,-406 # 80025000 <disk+0x1000>
    8000619e:	eb98                	sd	a4,16(a5)
    800061a0:	4705                	li	a4,1
    800061a2:	00e78c23          	sb	a4,24(a5)
    800061a6:	00e78ca3          	sb	a4,25(a5)
    800061aa:	00e78d23          	sb	a4,26(a5)
    800061ae:	00e78da3          	sb	a4,27(a5)
    800061b2:	00e78e23          	sb	a4,28(a5)
    800061b6:	00e78ea3          	sb	a4,29(a5)
    800061ba:	00e78f23          	sb	a4,30(a5)
    800061be:	00e78fa3          	sb	a4,31(a5)
    800061c2:	60e2                	ld	ra,24(sp)
    800061c4:	6442                	ld	s0,16(sp)
    800061c6:	64a2                	ld	s1,8(sp)
    800061c8:	6105                	addi	sp,sp,32
    800061ca:	8082                	ret
    800061cc:	00002517          	auipc	a0,0x2
    800061d0:	69450513          	addi	a0,a0,1684 # 80008860 <syscalls+0x370>
    800061d4:	ffffa097          	auipc	ra,0xffffa
    800061d8:	36c080e7          	jalr	876(ra) # 80000540 <panic>
    800061dc:	00002517          	auipc	a0,0x2
    800061e0:	6a450513          	addi	a0,a0,1700 # 80008880 <syscalls+0x390>
    800061e4:	ffffa097          	auipc	ra,0xffffa
    800061e8:	35c080e7          	jalr	860(ra) # 80000540 <panic>
    800061ec:	00002517          	auipc	a0,0x2
    800061f0:	6b450513          	addi	a0,a0,1716 # 800088a0 <syscalls+0x3b0>
    800061f4:	ffffa097          	auipc	ra,0xffffa
    800061f8:	34c080e7          	jalr	844(ra) # 80000540 <panic>

00000000800061fc <virtio_disk_rw>:
    800061fc:	7175                	addi	sp,sp,-144
    800061fe:	e506                	sd	ra,136(sp)
    80006200:	e122                	sd	s0,128(sp)
    80006202:	fca6                	sd	s1,120(sp)
    80006204:	f8ca                	sd	s2,112(sp)
    80006206:	f4ce                	sd	s3,104(sp)
    80006208:	f0d2                	sd	s4,96(sp)
    8000620a:	ecd6                	sd	s5,88(sp)
    8000620c:	e8da                	sd	s6,80(sp)
    8000620e:	e4de                	sd	s7,72(sp)
    80006210:	e0e2                	sd	s8,64(sp)
    80006212:	fc66                	sd	s9,56(sp)
    80006214:	f86a                	sd	s10,48(sp)
    80006216:	f46e                	sd	s11,40(sp)
    80006218:	0900                	addi	s0,sp,144
    8000621a:	8aaa                	mv	s5,a0
    8000621c:	8d2e                	mv	s10,a1
    8000621e:	00c52c83          	lw	s9,12(a0)
    80006222:	001c9c9b          	slliw	s9,s9,0x1
    80006226:	1c82                	slli	s9,s9,0x20
    80006228:	020cdc93          	srli	s9,s9,0x20
    8000622c:	00020517          	auipc	a0,0x20
    80006230:	e7c50513          	addi	a0,a0,-388 # 800260a8 <disk+0x20a8>
    80006234:	ffffb097          	auipc	ra,0xffffb
    80006238:	9c8080e7          	jalr	-1592(ra) # 80000bfc <acquire>
    8000623c:	4981                	li	s3,0
    8000623e:	44a1                	li	s1,8
    80006240:	0001ec17          	auipc	s8,0x1e
    80006244:	dc0c0c13          	addi	s8,s8,-576 # 80024000 <disk>
    80006248:	6b89                	lui	s7,0x2
    8000624a:	4b0d                	li	s6,3
    8000624c:	a0ad                	j	800062b6 <virtio_disk_rw+0xba>
    8000624e:	00fc0733          	add	a4,s8,a5
    80006252:	975e                	add	a4,a4,s7
    80006254:	00070c23          	sb	zero,24(a4)
    80006258:	c19c                	sw	a5,0(a1)
    8000625a:	0207c563          	bltz	a5,80006284 <virtio_disk_rw+0x88>
    8000625e:	2905                	addiw	s2,s2,1
    80006260:	0611                	addi	a2,a2,4
    80006262:	19690d63          	beq	s2,s6,800063fc <virtio_disk_rw+0x200>
    80006266:	85b2                	mv	a1,a2
    80006268:	00020717          	auipc	a4,0x20
    8000626c:	db070713          	addi	a4,a4,-592 # 80026018 <disk+0x2018>
    80006270:	87ce                	mv	a5,s3
    80006272:	00074683          	lbu	a3,0(a4)
    80006276:	fee1                	bnez	a3,8000624e <virtio_disk_rw+0x52>
    80006278:	2785                	addiw	a5,a5,1
    8000627a:	0705                	addi	a4,a4,1
    8000627c:	fe979be3          	bne	a5,s1,80006272 <virtio_disk_rw+0x76>
    80006280:	57fd                	li	a5,-1
    80006282:	c19c                	sw	a5,0(a1)
    80006284:	01205d63          	blez	s2,8000629e <virtio_disk_rw+0xa2>
    80006288:	8dce                	mv	s11,s3
    8000628a:	000a2503          	lw	a0,0(s4)
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	da8080e7          	jalr	-600(ra) # 80006036 <free_desc>
    80006296:	2d85                	addiw	s11,s11,1
    80006298:	0a11                	addi	s4,s4,4
    8000629a:	ffb918e3          	bne	s2,s11,8000628a <virtio_disk_rw+0x8e>
    8000629e:	00020597          	auipc	a1,0x20
    800062a2:	e0a58593          	addi	a1,a1,-502 # 800260a8 <disk+0x20a8>
    800062a6:	00020517          	auipc	a0,0x20
    800062aa:	d7250513          	addi	a0,a0,-654 # 80026018 <disk+0x2018>
    800062ae:	ffffc097          	auipc	ra,0xffffc
    800062b2:	2a8080e7          	jalr	680(ra) # 80002556 <sleep>
    800062b6:	f8040a13          	addi	s4,s0,-128
    800062ba:	8652                	mv	a2,s4
    800062bc:	894e                	mv	s2,s3
    800062be:	b765                	j	80006266 <virtio_disk_rw+0x6a>
    800062c0:	00020717          	auipc	a4,0x20
    800062c4:	d4073703          	ld	a4,-704(a4) # 80026000 <disk+0x2000>
    800062c8:	973e                	add	a4,a4,a5
    800062ca:	00071623          	sh	zero,12(a4)
    800062ce:	0001e517          	auipc	a0,0x1e
    800062d2:	d3250513          	addi	a0,a0,-718 # 80024000 <disk>
    800062d6:	00020717          	auipc	a4,0x20
    800062da:	d2a70713          	addi	a4,a4,-726 # 80026000 <disk+0x2000>
    800062de:	6314                	ld	a3,0(a4)
    800062e0:	96be                	add	a3,a3,a5
    800062e2:	00c6d603          	lhu	a2,12(a3)
    800062e6:	00166613          	ori	a2,a2,1
    800062ea:	00c69623          	sh	a2,12(a3)
    800062ee:	f8842683          	lw	a3,-120(s0)
    800062f2:	6310                	ld	a2,0(a4)
    800062f4:	97b2                	add	a5,a5,a2
    800062f6:	00d79723          	sh	a3,14(a5)
    800062fa:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    800062fe:	0612                	slli	a2,a2,0x4
    80006300:	962a                	add	a2,a2,a0
    80006302:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
    80006306:	00469793          	slli	a5,a3,0x4
    8000630a:	630c                	ld	a1,0(a4)
    8000630c:	95be                	add	a1,a1,a5
    8000630e:	6689                	lui	a3,0x2
    80006310:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80006314:	96ca                	add	a3,a3,s2
    80006316:	96aa                	add	a3,a3,a0
    80006318:	e194                	sd	a3,0(a1)
    8000631a:	6314                	ld	a3,0(a4)
    8000631c:	96be                	add	a3,a3,a5
    8000631e:	4585                	li	a1,1
    80006320:	c68c                	sw	a1,8(a3)
    80006322:	6314                	ld	a3,0(a4)
    80006324:	96be                	add	a3,a3,a5
    80006326:	4509                	li	a0,2
    80006328:	00a69623          	sh	a0,12(a3)
    8000632c:	6314                	ld	a3,0(a4)
    8000632e:	97b6                	add	a5,a5,a3
    80006330:	00079723          	sh	zero,14(a5)
    80006334:	00baa223          	sw	a1,4(s5)
    80006338:	03563423          	sd	s5,40(a2)
    8000633c:	6714                	ld	a3,8(a4)
    8000633e:	0026d783          	lhu	a5,2(a3)
    80006342:	8b9d                	andi	a5,a5,7
    80006344:	0789                	addi	a5,a5,2
    80006346:	0786                	slli	a5,a5,0x1
    80006348:	97b6                	add	a5,a5,a3
    8000634a:	00979023          	sh	s1,0(a5)
    8000634e:	0ff0000f          	fence
    80006352:	6718                	ld	a4,8(a4)
    80006354:	00275783          	lhu	a5,2(a4)
    80006358:	2785                	addiw	a5,a5,1
    8000635a:	00f71123          	sh	a5,2(a4)
    8000635e:	100017b7          	lui	a5,0x10001
    80006362:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
    80006366:	004aa783          	lw	a5,4(s5)
    8000636a:	02b79163          	bne	a5,a1,8000638c <virtio_disk_rw+0x190>
    8000636e:	00020917          	auipc	s2,0x20
    80006372:	d3a90913          	addi	s2,s2,-710 # 800260a8 <disk+0x20a8>
    80006376:	4485                	li	s1,1
    80006378:	85ca                	mv	a1,s2
    8000637a:	8556                	mv	a0,s5
    8000637c:	ffffc097          	auipc	ra,0xffffc
    80006380:	1da080e7          	jalr	474(ra) # 80002556 <sleep>
    80006384:	004aa783          	lw	a5,4(s5)
    80006388:	fe9788e3          	beq	a5,s1,80006378 <virtio_disk_rw+0x17c>
    8000638c:	f8042483          	lw	s1,-128(s0)
    80006390:	20048793          	addi	a5,s1,512
    80006394:	00479713          	slli	a4,a5,0x4
    80006398:	0001e797          	auipc	a5,0x1e
    8000639c:	c6878793          	addi	a5,a5,-920 # 80024000 <disk>
    800063a0:	97ba                	add	a5,a5,a4
    800063a2:	0207b423          	sd	zero,40(a5)
    800063a6:	00020917          	auipc	s2,0x20
    800063aa:	c5a90913          	addi	s2,s2,-934 # 80026000 <disk+0x2000>
    800063ae:	a019                	j	800063b4 <virtio_disk_rw+0x1b8>
    800063b0:	00e4d483          	lhu	s1,14(s1)
    800063b4:	8526                	mv	a0,s1
    800063b6:	00000097          	auipc	ra,0x0
    800063ba:	c80080e7          	jalr	-896(ra) # 80006036 <free_desc>
    800063be:	0492                	slli	s1,s1,0x4
    800063c0:	00093783          	ld	a5,0(s2)
    800063c4:	94be                	add	s1,s1,a5
    800063c6:	00c4d783          	lhu	a5,12(s1)
    800063ca:	8b85                	andi	a5,a5,1
    800063cc:	f3f5                	bnez	a5,800063b0 <virtio_disk_rw+0x1b4>
    800063ce:	00020517          	auipc	a0,0x20
    800063d2:	cda50513          	addi	a0,a0,-806 # 800260a8 <disk+0x20a8>
    800063d6:	ffffb097          	auipc	ra,0xffffb
    800063da:	8da080e7          	jalr	-1830(ra) # 80000cb0 <release>
    800063de:	60aa                	ld	ra,136(sp)
    800063e0:	640a                	ld	s0,128(sp)
    800063e2:	74e6                	ld	s1,120(sp)
    800063e4:	7946                	ld	s2,112(sp)
    800063e6:	79a6                	ld	s3,104(sp)
    800063e8:	7a06                	ld	s4,96(sp)
    800063ea:	6ae6                	ld	s5,88(sp)
    800063ec:	6b46                	ld	s6,80(sp)
    800063ee:	6ba6                	ld	s7,72(sp)
    800063f0:	6c06                	ld	s8,64(sp)
    800063f2:	7ce2                	ld	s9,56(sp)
    800063f4:	7d42                	ld	s10,48(sp)
    800063f6:	7da2                	ld	s11,40(sp)
    800063f8:	6149                	addi	sp,sp,144
    800063fa:	8082                	ret
    800063fc:	01a037b3          	snez	a5,s10
    80006400:	f6f42823          	sw	a5,-144(s0)
    80006404:	f6042a23          	sw	zero,-140(s0)
    80006408:	f7943c23          	sd	s9,-136(s0)
    8000640c:	f8042483          	lw	s1,-128(s0)
    80006410:	00449913          	slli	s2,s1,0x4
    80006414:	00020997          	auipc	s3,0x20
    80006418:	bec98993          	addi	s3,s3,-1044 # 80026000 <disk+0x2000>
    8000641c:	0009ba03          	ld	s4,0(s3)
    80006420:	9a4a                	add	s4,s4,s2
    80006422:	f7040513          	addi	a0,s0,-144
    80006426:	ffffb097          	auipc	ra,0xffffb
    8000642a:	c92080e7          	jalr	-878(ra) # 800010b8 <kvmpa>
    8000642e:	00aa3023          	sd	a0,0(s4)
    80006432:	0009b783          	ld	a5,0(s3)
    80006436:	97ca                	add	a5,a5,s2
    80006438:	4741                	li	a4,16
    8000643a:	c798                	sw	a4,8(a5)
    8000643c:	0009b783          	ld	a5,0(s3)
    80006440:	97ca                	add	a5,a5,s2
    80006442:	4705                	li	a4,1
    80006444:	00e79623          	sh	a4,12(a5)
    80006448:	f8442783          	lw	a5,-124(s0)
    8000644c:	0009b703          	ld	a4,0(s3)
    80006450:	974a                	add	a4,a4,s2
    80006452:	00f71723          	sh	a5,14(a4)
    80006456:	0792                	slli	a5,a5,0x4
    80006458:	0009b703          	ld	a4,0(s3)
    8000645c:	973e                	add	a4,a4,a5
    8000645e:	058a8693          	addi	a3,s5,88
    80006462:	e314                	sd	a3,0(a4)
    80006464:	0009b703          	ld	a4,0(s3)
    80006468:	973e                	add	a4,a4,a5
    8000646a:	40000693          	li	a3,1024
    8000646e:	c714                	sw	a3,8(a4)
    80006470:	e40d18e3          	bnez	s10,800062c0 <virtio_disk_rw+0xc4>
    80006474:	00020717          	auipc	a4,0x20
    80006478:	b8c73703          	ld	a4,-1140(a4) # 80026000 <disk+0x2000>
    8000647c:	973e                	add	a4,a4,a5
    8000647e:	4689                	li	a3,2
    80006480:	00d71623          	sh	a3,12(a4)
    80006484:	b5a9                	j	800062ce <virtio_disk_rw+0xd2>

0000000080006486 <virtio_disk_intr>:
    80006486:	1101                	addi	sp,sp,-32
    80006488:	ec06                	sd	ra,24(sp)
    8000648a:	e822                	sd	s0,16(sp)
    8000648c:	e426                	sd	s1,8(sp)
    8000648e:	e04a                	sd	s2,0(sp)
    80006490:	1000                	addi	s0,sp,32
    80006492:	00020517          	auipc	a0,0x20
    80006496:	c1650513          	addi	a0,a0,-1002 # 800260a8 <disk+0x20a8>
    8000649a:	ffffa097          	auipc	ra,0xffffa
    8000649e:	762080e7          	jalr	1890(ra) # 80000bfc <acquire>
    800064a2:	00020717          	auipc	a4,0x20
    800064a6:	b5e70713          	addi	a4,a4,-1186 # 80026000 <disk+0x2000>
    800064aa:	02075783          	lhu	a5,32(a4)
    800064ae:	6b18                	ld	a4,16(a4)
    800064b0:	00275683          	lhu	a3,2(a4)
    800064b4:	8ebd                	xor	a3,a3,a5
    800064b6:	8a9d                	andi	a3,a3,7
    800064b8:	cab9                	beqz	a3,8000650e <virtio_disk_intr+0x88>
    800064ba:	0001e917          	auipc	s2,0x1e
    800064be:	b4690913          	addi	s2,s2,-1210 # 80024000 <disk>
    800064c2:	00020497          	auipc	s1,0x20
    800064c6:	b3e48493          	addi	s1,s1,-1218 # 80026000 <disk+0x2000>
    800064ca:	078e                	slli	a5,a5,0x3
    800064cc:	97ba                	add	a5,a5,a4
    800064ce:	43dc                	lw	a5,4(a5)
    800064d0:	20078713          	addi	a4,a5,512
    800064d4:	0712                	slli	a4,a4,0x4
    800064d6:	974a                	add	a4,a4,s2
    800064d8:	03074703          	lbu	a4,48(a4)
    800064dc:	ef21                	bnez	a4,80006534 <virtio_disk_intr+0xae>
    800064de:	20078793          	addi	a5,a5,512
    800064e2:	0792                	slli	a5,a5,0x4
    800064e4:	97ca                	add	a5,a5,s2
    800064e6:	7798                	ld	a4,40(a5)
    800064e8:	00072223          	sw	zero,4(a4)
    800064ec:	7788                	ld	a0,40(a5)
    800064ee:	ffffc097          	auipc	ra,0xffffc
    800064f2:	1e8080e7          	jalr	488(ra) # 800026d6 <wakeup>
    800064f6:	0204d783          	lhu	a5,32(s1)
    800064fa:	2785                	addiw	a5,a5,1
    800064fc:	8b9d                	andi	a5,a5,7
    800064fe:	02f49023          	sh	a5,32(s1)
    80006502:	6898                	ld	a4,16(s1)
    80006504:	00275683          	lhu	a3,2(a4)
    80006508:	8a9d                	andi	a3,a3,7
    8000650a:	fcf690e3          	bne	a3,a5,800064ca <virtio_disk_intr+0x44>
    8000650e:	10001737          	lui	a4,0x10001
    80006512:	533c                	lw	a5,96(a4)
    80006514:	8b8d                	andi	a5,a5,3
    80006516:	d37c                	sw	a5,100(a4)
    80006518:	00020517          	auipc	a0,0x20
    8000651c:	b9050513          	addi	a0,a0,-1136 # 800260a8 <disk+0x20a8>
    80006520:	ffffa097          	auipc	ra,0xffffa
    80006524:	790080e7          	jalr	1936(ra) # 80000cb0 <release>
    80006528:	60e2                	ld	ra,24(sp)
    8000652a:	6442                	ld	s0,16(sp)
    8000652c:	64a2                	ld	s1,8(sp)
    8000652e:	6902                	ld	s2,0(sp)
    80006530:	6105                	addi	sp,sp,32
    80006532:	8082                	ret
    80006534:	00002517          	auipc	a0,0x2
    80006538:	38c50513          	addi	a0,a0,908 # 800088c0 <syscalls+0x3d0>
    8000653c:	ffffa097          	auipc	ra,0xffffa
    80006540:	004080e7          	jalr	4(ra) # 80000540 <panic>
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
