
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
    8000005e:	f7678793          	addi	a5,a5,-138 # 80005fd0 <timervec>
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
    80000128:	780080e7          	jalr	1920(ra) # 800028a4 <either_copyin>
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
    800001dc:	3e6080e7          	jalr	998(ra) # 800025be <sleep>
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
    80000218:	63a080e7          	jalr	1594(ra) # 8000284e <either_copyout>
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
    800002f8:	606080e7          	jalr	1542(ra) # 800028fa <procdump>
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
    8000044c:	2f6080e7          	jalr	758(ra) # 8000273e <wakeup>
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
    800008a4:	e9e080e7          	jalr	-354(ra) # 8000273e <wakeup>
    
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
    8000093e:	c84080e7          	jalr	-892(ra) # 800025be <sleep>
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
    80000ef0:	b50080e7          	jalr	-1200(ra) # 80002a3c <trapinithart>
    80000ef4:	00005097          	auipc	ra,0x5
    80000ef8:	11c080e7          	jalr	284(ra) # 80006010 <plicinithart>
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
    80000f58:	ac0080e7          	jalr	-1344(ra) # 80002a14 <trapinit>
    80000f5c:	00002097          	auipc	ra,0x2
    80000f60:	ae0080e7          	jalr	-1312(ra) # 80002a3c <trapinithart>
    80000f64:	00005097          	auipc	ra,0x5
    80000f68:	096080e7          	jalr	150(ra) # 80005ffa <plicinit>
    80000f6c:	00005097          	auipc	ra,0x5
    80000f70:	0a4080e7          	jalr	164(ra) # 80006010 <plicinithart>
    80000f74:	00002097          	auipc	ra,0x2
    80000f78:	24e080e7          	jalr	590(ra) # 800031c2 <binit>
    80000f7c:	00003097          	auipc	ra,0x3
    80000f80:	8e0080e7          	jalr	-1824(ra) # 8000385c <iinit>
    80000f84:	00004097          	auipc	ra,0x4
    80000f88:	87e080e7          	jalr	-1922(ra) # 80004802 <fileinit>
    80000f8c:	00005097          	auipc	ra,0x5
    80000f90:	18c080e7          	jalr	396(ra) # 80006118 <virtio_disk_init>
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
    80001c1e:	d90080e7          	jalr	-624(ra) # 800029aa <swtch>
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
    80001c72:	d3c080e7          	jalr	-708(ra) # 800029aa <swtch>
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
    80001e1c:	ad87a783          	lw	a5,-1320(a5) # 800088f0 <first.1>
    80001e20:	eb89                	bnez	a5,80001e32 <forkret+0x32>
  usertrapret();
    80001e22:	00001097          	auipc	ra,0x1
    80001e26:	c32080e7          	jalr	-974(ra) # 80002a54 <usertrapret>
}
    80001e2a:	60a2                	ld	ra,8(sp)
    80001e2c:	6402                	ld	s0,0(sp)
    80001e2e:	0141                	addi	sp,sp,16
    80001e30:	8082                	ret
    first = 0;
    80001e32:	00007797          	auipc	a5,0x7
    80001e36:	aa07af23          	sw	zero,-1346(a5) # 800088f0 <first.1>
    fsinit(ROOTDEV);
    80001e3a:	4505                	li	a0,1
    80001e3c:	00002097          	auipc	ra,0x2
    80001e40:	9a0080e7          	jalr	-1632(ra) # 800037dc <fsinit>
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
    80001e68:	a9078793          	addi	a5,a5,-1392 # 800088f4 <nextpid>
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
    800020e4:	82058593          	addi	a1,a1,-2016 # 80008900 <initcode>
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
    80002122:	0e6080e7          	jalr	230(ra) # 80004204 <namei>
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
    8000226c:	62c080e7          	jalr	1580(ra) # 80004894 <filedup>
    80002270:	00a93023          	sd	a0,0(s2)
    80002274:	b7e5                	j	8000225c <fork+0xa6>
  np->cwd = idup(p->cwd);
    80002276:	150ab503          	ld	a0,336(s5)
    8000227a:	00001097          	auipc	ra,0x1
    8000227e:	79c080e7          	jalr	1948(ra) # 80003a16 <idup>
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
    800023b2:	5fc080e7          	jalr	1532(ra) # 800029aa <swtch>
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
    80002454:	496080e7          	jalr	1174(ra) # 800048e6 <fileclose>
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
    8000246c:	fac080e7          	jalr	-84(ra) # 80004414 <begin_op>
  iput(p->cwd);
    80002470:	1509b503          	ld	a0,336(s3)
    80002474:	00001097          	auipc	ra,0x1
    80002478:	79a080e7          	jalr	1946(ra) # 80003c0e <iput>
  end_op();
    8000247c:	00002097          	auipc	ra,0x2
    80002480:	018080e7          	jalr	24(ra) # 80004494 <end_op>
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
    if (is_q1(p)) // Move all to q2, when the time slice has been all used up.
    8000253a:	1684a703          	lw	a4,360(s1)
    8000253e:	4785                	li	a5,1
    80002540:	04f70c63          	beq	a4,a5,80002598 <yield+0x7e>
    acquire(&tickslock);
    80002544:	00016517          	auipc	a0,0x16
    80002548:	86c50513          	addi	a0,a0,-1940 # 80017db0 <tickslock>
    8000254c:	ffffe097          	auipc	ra,0xffffe
    80002550:	6b0080e7          	jalr	1712(ra) # 80000bfc <acquire>
    printf("ticks: %d\n", ticks);
    80002554:	00007597          	auipc	a1,0x7
    80002558:	acc5a583          	lw	a1,-1332(a1) # 80009020 <ticks>
    8000255c:	00006517          	auipc	a0,0x6
    80002560:	dd450513          	addi	a0,a0,-556 # 80008330 <digits+0x2f0>
    80002564:	ffffe097          	auipc	ra,0xffffe
    80002568:	026080e7          	jalr	38(ra) # 8000058a <printf>
    release(&tickslock);
    8000256c:	00016517          	auipc	a0,0x16
    80002570:	84450513          	addi	a0,a0,-1980 # 80017db0 <tickslock>
    80002574:	ffffe097          	auipc	ra,0xffffe
    80002578:	73c080e7          	jalr	1852(ra) # 80000cb0 <release>
  sched();
    8000257c:	00000097          	auipc	ra,0x0
    80002580:	dbe080e7          	jalr	-578(ra) # 8000233a <sched>
  release(&p->lock);
    80002584:	8526                	mv	a0,s1
    80002586:	ffffe097          	auipc	ra,0xffffe
    8000258a:	72a080e7          	jalr	1834(ra) # 80000cb0 <release>
}
    8000258e:	60e2                	ld	ra,24(sp)
    80002590:	6442                	ld	s0,16(sp)
    80002592:	64a2                	ld	s1,8(sp)
    80002594:	6105                	addi	sp,sp,32
    80002596:	8082                	ret
      __RE_MOVE___(p, &q1, &q2);
    80002598:	85a6                	mv	a1,s1
    8000259a:	0000f517          	auipc	a0,0xf
    8000259e:	3ce50513          	addi	a0,a0,974 # 80011968 <q1>
    800025a2:	fffff097          	auipc	ra,0xfffff
    800025a6:	498080e7          	jalr	1176(ra) # 80001a3a <remove>
    800025aa:	85aa                	mv	a1,a0
    800025ac:	0000f517          	auipc	a0,0xf
    800025b0:	3a450513          	addi	a0,a0,932 # 80011950 <q2>
    800025b4:	fffff097          	auipc	ra,0xfffff
    800025b8:	400080e7          	jalr	1024(ra) # 800019b4 <enqueue>
    800025bc:	b761                	j	80002544 <yield+0x2a>

00000000800025be <sleep>:
{
    800025be:	7179                	addi	sp,sp,-48
    800025c0:	f406                	sd	ra,40(sp)
    800025c2:	f022                	sd	s0,32(sp)
    800025c4:	ec26                	sd	s1,24(sp)
    800025c6:	e84a                	sd	s2,16(sp)
    800025c8:	e44e                	sd	s3,8(sp)
    800025ca:	1800                	addi	s0,sp,48
    800025cc:	89aa                	mv	s3,a0
    800025ce:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800025d0:	fffff097          	auipc	ra,0xfffff
    800025d4:	7f8080e7          	jalr	2040(ra) # 80001dc8 <myproc>
    800025d8:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800025da:	05250663          	beq	a0,s2,80002626 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800025de:	ffffe097          	auipc	ra,0xffffe
    800025e2:	61e080e7          	jalr	1566(ra) # 80000bfc <acquire>
    release(lk);
    800025e6:	854a                	mv	a0,s2
    800025e8:	ffffe097          	auipc	ra,0xffffe
    800025ec:	6c8080e7          	jalr	1736(ra) # 80000cb0 <release>
  p->chan = chan;
    800025f0:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800025f4:	4785                	li	a5,1
    800025f6:	cc9c                	sw	a5,24(s1)
  sched();
    800025f8:	00000097          	auipc	ra,0x0
    800025fc:	d42080e7          	jalr	-702(ra) # 8000233a <sched>
  p->chan = 0;
    80002600:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002604:	8526                	mv	a0,s1
    80002606:	ffffe097          	auipc	ra,0xffffe
    8000260a:	6aa080e7          	jalr	1706(ra) # 80000cb0 <release>
    acquire(lk);
    8000260e:	854a                	mv	a0,s2
    80002610:	ffffe097          	auipc	ra,0xffffe
    80002614:	5ec080e7          	jalr	1516(ra) # 80000bfc <acquire>
}
    80002618:	70a2                	ld	ra,40(sp)
    8000261a:	7402                	ld	s0,32(sp)
    8000261c:	64e2                	ld	s1,24(sp)
    8000261e:	6942                	ld	s2,16(sp)
    80002620:	69a2                	ld	s3,8(sp)
    80002622:	6145                	addi	sp,sp,48
    80002624:	8082                	ret
  p->chan = chan;
    80002626:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000262a:	4785                	li	a5,1
    8000262c:	cd1c                	sw	a5,24(a0)
  sched();
    8000262e:	00000097          	auipc	ra,0x0
    80002632:	d0c080e7          	jalr	-756(ra) # 8000233a <sched>
  p->chan = 0;
    80002636:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    8000263a:	bff9                	j	80002618 <sleep+0x5a>

000000008000263c <wait>:
{
    8000263c:	715d                	addi	sp,sp,-80
    8000263e:	e486                	sd	ra,72(sp)
    80002640:	e0a2                	sd	s0,64(sp)
    80002642:	fc26                	sd	s1,56(sp)
    80002644:	f84a                	sd	s2,48(sp)
    80002646:	f44e                	sd	s3,40(sp)
    80002648:	f052                	sd	s4,32(sp)
    8000264a:	ec56                	sd	s5,24(sp)
    8000264c:	e85a                	sd	s6,16(sp)
    8000264e:	e45e                	sd	s7,8(sp)
    80002650:	0880                	addi	s0,sp,80
    80002652:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002654:	fffff097          	auipc	ra,0xfffff
    80002658:	774080e7          	jalr	1908(ra) # 80001dc8 <myproc>
    8000265c:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000265e:	ffffe097          	auipc	ra,0xffffe
    80002662:	59e080e7          	jalr	1438(ra) # 80000bfc <acquire>
    havekids = 0;
    80002666:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002668:	4a11                	li	s4,4
        havekids = 1;
    8000266a:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000266c:	00015997          	auipc	s3,0x15
    80002670:	74498993          	addi	s3,s3,1860 # 80017db0 <tickslock>
    havekids = 0;
    80002674:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002676:	0000f497          	auipc	s1,0xf
    8000267a:	73a48493          	addi	s1,s1,1850 # 80011db0 <proc>
    8000267e:	a08d                	j	800026e0 <wait+0xa4>
          pid = np->pid;
    80002680:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002684:	000b0e63          	beqz	s6,800026a0 <wait+0x64>
    80002688:	4691                	li	a3,4
    8000268a:	03448613          	addi	a2,s1,52
    8000268e:	85da                	mv	a1,s6
    80002690:	05093503          	ld	a0,80(s2)
    80002694:	fffff097          	auipc	ra,0xfffff
    80002698:	016080e7          	jalr	22(ra) # 800016aa <copyout>
    8000269c:	02054263          	bltz	a0,800026c0 <wait+0x84>
          freeproc(np);
    800026a0:	8526                	mv	a0,s1
    800026a2:	00000097          	auipc	ra,0x0
    800026a6:	8d8080e7          	jalr	-1832(ra) # 80001f7a <freeproc>
          release(&np->lock);
    800026aa:	8526                	mv	a0,s1
    800026ac:	ffffe097          	auipc	ra,0xffffe
    800026b0:	604080e7          	jalr	1540(ra) # 80000cb0 <release>
          release(&p->lock);
    800026b4:	854a                	mv	a0,s2
    800026b6:	ffffe097          	auipc	ra,0xffffe
    800026ba:	5fa080e7          	jalr	1530(ra) # 80000cb0 <release>
          return pid;
    800026be:	a8a9                	j	80002718 <wait+0xdc>
            release(&np->lock);
    800026c0:	8526                	mv	a0,s1
    800026c2:	ffffe097          	auipc	ra,0xffffe
    800026c6:	5ee080e7          	jalr	1518(ra) # 80000cb0 <release>
            release(&p->lock);
    800026ca:	854a                	mv	a0,s2
    800026cc:	ffffe097          	auipc	ra,0xffffe
    800026d0:	5e4080e7          	jalr	1508(ra) # 80000cb0 <release>
            return -1;
    800026d4:	59fd                	li	s3,-1
    800026d6:	a089                	j	80002718 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    800026d8:	18048493          	addi	s1,s1,384
    800026dc:	03348463          	beq	s1,s3,80002704 <wait+0xc8>
      if(np->parent == p){
    800026e0:	709c                	ld	a5,32(s1)
    800026e2:	ff279be3          	bne	a5,s2,800026d8 <wait+0x9c>
        acquire(&np->lock);
    800026e6:	8526                	mv	a0,s1
    800026e8:	ffffe097          	auipc	ra,0xffffe
    800026ec:	514080e7          	jalr	1300(ra) # 80000bfc <acquire>
        if(np->state == ZOMBIE){
    800026f0:	4c9c                	lw	a5,24(s1)
    800026f2:	f94787e3          	beq	a5,s4,80002680 <wait+0x44>
        release(&np->lock);
    800026f6:	8526                	mv	a0,s1
    800026f8:	ffffe097          	auipc	ra,0xffffe
    800026fc:	5b8080e7          	jalr	1464(ra) # 80000cb0 <release>
        havekids = 1;
    80002700:	8756                	mv	a4,s5
    80002702:	bfd9                	j	800026d8 <wait+0x9c>
    if(!havekids || p->killed){
    80002704:	c701                	beqz	a4,8000270c <wait+0xd0>
    80002706:	03092783          	lw	a5,48(s2)
    8000270a:	c39d                	beqz	a5,80002730 <wait+0xf4>
      release(&p->lock);
    8000270c:	854a                	mv	a0,s2
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	5a2080e7          	jalr	1442(ra) # 80000cb0 <release>
      return -1;
    80002716:	59fd                	li	s3,-1
}
    80002718:	854e                	mv	a0,s3
    8000271a:	60a6                	ld	ra,72(sp)
    8000271c:	6406                	ld	s0,64(sp)
    8000271e:	74e2                	ld	s1,56(sp)
    80002720:	7942                	ld	s2,48(sp)
    80002722:	79a2                	ld	s3,40(sp)
    80002724:	7a02                	ld	s4,32(sp)
    80002726:	6ae2                	ld	s5,24(sp)
    80002728:	6b42                	ld	s6,16(sp)
    8000272a:	6ba2                	ld	s7,8(sp)
    8000272c:	6161                	addi	sp,sp,80
    8000272e:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002730:	85ca                	mv	a1,s2
    80002732:	854a                	mv	a0,s2
    80002734:	00000097          	auipc	ra,0x0
    80002738:	e8a080e7          	jalr	-374(ra) # 800025be <sleep>
    havekids = 0;
    8000273c:	bf25                	j	80002674 <wait+0x38>

000000008000273e <wakeup>:
{
    8000273e:	715d                	addi	sp,sp,-80
    80002740:	e486                	sd	ra,72(sp)
    80002742:	e0a2                	sd	s0,64(sp)
    80002744:	fc26                	sd	s1,56(sp)
    80002746:	f84a                	sd	s2,48(sp)
    80002748:	f44e                	sd	s3,40(sp)
    8000274a:	f052                	sd	s4,32(sp)
    8000274c:	ec56                	sd	s5,24(sp)
    8000274e:	e85a                	sd	s6,16(sp)
    80002750:	e45e                	sd	s7,8(sp)
    80002752:	0880                	addi	s0,sp,80
    80002754:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002756:	0000f497          	auipc	s1,0xf
    8000275a:	65a48493          	addi	s1,s1,1626 # 80011db0 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000275e:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002760:	4a89                	li	s5,2
        __RE_MOVE___(p, &q0, &q2);
    80002762:	0000fb97          	auipc	s7,0xf
    80002766:	1eeb8b93          	addi	s7,s7,494 # 80011950 <q2>
    8000276a:	0000fb17          	auipc	s6,0xf
    8000276e:	216b0b13          	addi	s6,s6,534 # 80011980 <q0>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002772:	00015917          	auipc	s2,0x15
    80002776:	63e90913          	addi	s2,s2,1598 # 80017db0 <tickslock>
    8000277a:	a811                	j	8000278e <wakeup+0x50>
    release(&p->lock);
    8000277c:	8526                	mv	a0,s1
    8000277e:	ffffe097          	auipc	ra,0xffffe
    80002782:	532080e7          	jalr	1330(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002786:	18048493          	addi	s1,s1,384
    8000278a:	03248f63          	beq	s1,s2,800027c8 <wakeup+0x8a>
    acquire(&p->lock);
    8000278e:	8526                	mv	a0,s1
    80002790:	ffffe097          	auipc	ra,0xffffe
    80002794:	46c080e7          	jalr	1132(ra) # 80000bfc <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002798:	4c9c                	lw	a5,24(s1)
    8000279a:	ff3791e3          	bne	a5,s3,8000277c <wakeup+0x3e>
    8000279e:	749c                	ld	a5,40(s1)
    800027a0:	fd479ee3          	bne	a5,s4,8000277c <wakeup+0x3e>
      p->state = RUNNABLE;
    800027a4:	0154ac23          	sw	s5,24(s1)
      if (is_q0(p)) // Move all to q2
    800027a8:	1684a783          	lw	a5,360(s1)
    800027ac:	fbe1                	bnez	a5,8000277c <wakeup+0x3e>
        __RE_MOVE___(p, &q0, &q2);
    800027ae:	85a6                	mv	a1,s1
    800027b0:	855a                	mv	a0,s6
    800027b2:	fffff097          	auipc	ra,0xfffff
    800027b6:	288080e7          	jalr	648(ra) # 80001a3a <remove>
    800027ba:	85aa                	mv	a1,a0
    800027bc:	855e                	mv	a0,s7
    800027be:	fffff097          	auipc	ra,0xfffff
    800027c2:	1f6080e7          	jalr	502(ra) # 800019b4 <enqueue>
    800027c6:	bf5d                	j	8000277c <wakeup+0x3e>
}
    800027c8:	60a6                	ld	ra,72(sp)
    800027ca:	6406                	ld	s0,64(sp)
    800027cc:	74e2                	ld	s1,56(sp)
    800027ce:	7942                	ld	s2,48(sp)
    800027d0:	79a2                	ld	s3,40(sp)
    800027d2:	7a02                	ld	s4,32(sp)
    800027d4:	6ae2                	ld	s5,24(sp)
    800027d6:	6b42                	ld	s6,16(sp)
    800027d8:	6ba2                	ld	s7,8(sp)
    800027da:	6161                	addi	sp,sp,80
    800027dc:	8082                	ret

00000000800027de <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800027de:	7179                	addi	sp,sp,-48
    800027e0:	f406                	sd	ra,40(sp)
    800027e2:	f022                	sd	s0,32(sp)
    800027e4:	ec26                	sd	s1,24(sp)
    800027e6:	e84a                	sd	s2,16(sp)
    800027e8:	e44e                	sd	s3,8(sp)
    800027ea:	1800                	addi	s0,sp,48
    800027ec:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800027ee:	0000f497          	auipc	s1,0xf
    800027f2:	5c248493          	addi	s1,s1,1474 # 80011db0 <proc>
    800027f6:	00015997          	auipc	s3,0x15
    800027fa:	5ba98993          	addi	s3,s3,1466 # 80017db0 <tickslock>
    acquire(&p->lock);
    800027fe:	8526                	mv	a0,s1
    80002800:	ffffe097          	auipc	ra,0xffffe
    80002804:	3fc080e7          	jalr	1020(ra) # 80000bfc <acquire>
    if(p->pid == pid){
    80002808:	5c9c                	lw	a5,56(s1)
    8000280a:	01278d63          	beq	a5,s2,80002824 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000280e:	8526                	mv	a0,s1
    80002810:	ffffe097          	auipc	ra,0xffffe
    80002814:	4a0080e7          	jalr	1184(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002818:	18048493          	addi	s1,s1,384
    8000281c:	ff3491e3          	bne	s1,s3,800027fe <kill+0x20>
  }
  return -1;
    80002820:	557d                	li	a0,-1
    80002822:	a821                	j	8000283a <kill+0x5c>
      p->killed = 1;
    80002824:	4785                	li	a5,1
    80002826:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002828:	4c98                	lw	a4,24(s1)
    8000282a:	00f70f63          	beq	a4,a5,80002848 <kill+0x6a>
      release(&p->lock);
    8000282e:	8526                	mv	a0,s1
    80002830:	ffffe097          	auipc	ra,0xffffe
    80002834:	480080e7          	jalr	1152(ra) # 80000cb0 <release>
      return 0;
    80002838:	4501                	li	a0,0
}
    8000283a:	70a2                	ld	ra,40(sp)
    8000283c:	7402                	ld	s0,32(sp)
    8000283e:	64e2                	ld	s1,24(sp)
    80002840:	6942                	ld	s2,16(sp)
    80002842:	69a2                	ld	s3,8(sp)
    80002844:	6145                	addi	sp,sp,48
    80002846:	8082                	ret
        p->state = RUNNABLE;
    80002848:	4789                	li	a5,2
    8000284a:	cc9c                	sw	a5,24(s1)
    8000284c:	b7cd                	j	8000282e <kill+0x50>

000000008000284e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000284e:	7179                	addi	sp,sp,-48
    80002850:	f406                	sd	ra,40(sp)
    80002852:	f022                	sd	s0,32(sp)
    80002854:	ec26                	sd	s1,24(sp)
    80002856:	e84a                	sd	s2,16(sp)
    80002858:	e44e                	sd	s3,8(sp)
    8000285a:	e052                	sd	s4,0(sp)
    8000285c:	1800                	addi	s0,sp,48
    8000285e:	84aa                	mv	s1,a0
    80002860:	892e                	mv	s2,a1
    80002862:	89b2                	mv	s3,a2
    80002864:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002866:	fffff097          	auipc	ra,0xfffff
    8000286a:	562080e7          	jalr	1378(ra) # 80001dc8 <myproc>
  if(user_dst){
    8000286e:	c08d                	beqz	s1,80002890 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002870:	86d2                	mv	a3,s4
    80002872:	864e                	mv	a2,s3
    80002874:	85ca                	mv	a1,s2
    80002876:	6928                	ld	a0,80(a0)
    80002878:	fffff097          	auipc	ra,0xfffff
    8000287c:	e32080e7          	jalr	-462(ra) # 800016aa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002880:	70a2                	ld	ra,40(sp)
    80002882:	7402                	ld	s0,32(sp)
    80002884:	64e2                	ld	s1,24(sp)
    80002886:	6942                	ld	s2,16(sp)
    80002888:	69a2                	ld	s3,8(sp)
    8000288a:	6a02                	ld	s4,0(sp)
    8000288c:	6145                	addi	sp,sp,48
    8000288e:	8082                	ret
    memmove((char *)dst, src, len);
    80002890:	000a061b          	sext.w	a2,s4
    80002894:	85ce                	mv	a1,s3
    80002896:	854a                	mv	a0,s2
    80002898:	ffffe097          	auipc	ra,0xffffe
    8000289c:	4bc080e7          	jalr	1212(ra) # 80000d54 <memmove>
    return 0;
    800028a0:	8526                	mv	a0,s1
    800028a2:	bff9                	j	80002880 <either_copyout+0x32>

00000000800028a4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800028a4:	7179                	addi	sp,sp,-48
    800028a6:	f406                	sd	ra,40(sp)
    800028a8:	f022                	sd	s0,32(sp)
    800028aa:	ec26                	sd	s1,24(sp)
    800028ac:	e84a                	sd	s2,16(sp)
    800028ae:	e44e                	sd	s3,8(sp)
    800028b0:	e052                	sd	s4,0(sp)
    800028b2:	1800                	addi	s0,sp,48
    800028b4:	892a                	mv	s2,a0
    800028b6:	84ae                	mv	s1,a1
    800028b8:	89b2                	mv	s3,a2
    800028ba:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028bc:	fffff097          	auipc	ra,0xfffff
    800028c0:	50c080e7          	jalr	1292(ra) # 80001dc8 <myproc>
  if(user_src){
    800028c4:	c08d                	beqz	s1,800028e6 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800028c6:	86d2                	mv	a3,s4
    800028c8:	864e                	mv	a2,s3
    800028ca:	85ca                	mv	a1,s2
    800028cc:	6928                	ld	a0,80(a0)
    800028ce:	fffff097          	auipc	ra,0xfffff
    800028d2:	e68080e7          	jalr	-408(ra) # 80001736 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800028d6:	70a2                	ld	ra,40(sp)
    800028d8:	7402                	ld	s0,32(sp)
    800028da:	64e2                	ld	s1,24(sp)
    800028dc:	6942                	ld	s2,16(sp)
    800028de:	69a2                	ld	s3,8(sp)
    800028e0:	6a02                	ld	s4,0(sp)
    800028e2:	6145                	addi	sp,sp,48
    800028e4:	8082                	ret
    memmove(dst, (char*)src, len);
    800028e6:	000a061b          	sext.w	a2,s4
    800028ea:	85ce                	mv	a1,s3
    800028ec:	854a                	mv	a0,s2
    800028ee:	ffffe097          	auipc	ra,0xffffe
    800028f2:	466080e7          	jalr	1126(ra) # 80000d54 <memmove>
    return 0;
    800028f6:	8526                	mv	a0,s1
    800028f8:	bff9                	j	800028d6 <either_copyin+0x32>

00000000800028fa <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800028fa:	715d                	addi	sp,sp,-80
    800028fc:	e486                	sd	ra,72(sp)
    800028fe:	e0a2                	sd	s0,64(sp)
    80002900:	fc26                	sd	s1,56(sp)
    80002902:	f84a                	sd	s2,48(sp)
    80002904:	f44e                	sd	s3,40(sp)
    80002906:	f052                	sd	s4,32(sp)
    80002908:	ec56                	sd	s5,24(sp)
    8000290a:	e85a                	sd	s6,16(sp)
    8000290c:	e45e                	sd	s7,8(sp)
    8000290e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002910:	00006517          	auipc	a0,0x6
    80002914:	94850513          	addi	a0,a0,-1720 # 80008258 <digits+0x218>
    80002918:	ffffe097          	auipc	ra,0xffffe
    8000291c:	c72080e7          	jalr	-910(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002920:	0000f497          	auipc	s1,0xf
    80002924:	5e848493          	addi	s1,s1,1512 # 80011f08 <proc+0x158>
    80002928:	00015917          	auipc	s2,0x15
    8000292c:	5e090913          	addi	s2,s2,1504 # 80017f08 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002930:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002932:	00006997          	auipc	s3,0x6
    80002936:	a0e98993          	addi	s3,s3,-1522 # 80008340 <digits+0x300>
    printf("%d %s %s", p->pid, state, p->name);
    8000293a:	00006a97          	auipc	s5,0x6
    8000293e:	a0ea8a93          	addi	s5,s5,-1522 # 80008348 <digits+0x308>
    printf("\n");
    80002942:	00006a17          	auipc	s4,0x6
    80002946:	916a0a13          	addi	s4,s4,-1770 # 80008258 <digits+0x218>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000294a:	00006b97          	auipc	s7,0x6
    8000294e:	a36b8b93          	addi	s7,s7,-1482 # 80008380 <states.0>
    80002952:	a00d                	j	80002974 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002954:	ee06a583          	lw	a1,-288(a3)
    80002958:	8556                	mv	a0,s5
    8000295a:	ffffe097          	auipc	ra,0xffffe
    8000295e:	c30080e7          	jalr	-976(ra) # 8000058a <printf>
    printf("\n");
    80002962:	8552                	mv	a0,s4
    80002964:	ffffe097          	auipc	ra,0xffffe
    80002968:	c26080e7          	jalr	-986(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000296c:	18048493          	addi	s1,s1,384
    80002970:	03248263          	beq	s1,s2,80002994 <procdump+0x9a>
    if(p->state == UNUSED)
    80002974:	86a6                	mv	a3,s1
    80002976:	ec04a783          	lw	a5,-320(s1)
    8000297a:	dbed                	beqz	a5,8000296c <procdump+0x72>
      state = "???";
    8000297c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000297e:	fcfb6be3          	bltu	s6,a5,80002954 <procdump+0x5a>
    80002982:	02079713          	slli	a4,a5,0x20
    80002986:	01d75793          	srli	a5,a4,0x1d
    8000298a:	97de                	add	a5,a5,s7
    8000298c:	6390                	ld	a2,0(a5)
    8000298e:	f279                	bnez	a2,80002954 <procdump+0x5a>
      state = "???";
    80002990:	864e                	mv	a2,s3
    80002992:	b7c9                	j	80002954 <procdump+0x5a>
  }
}
    80002994:	60a6                	ld	ra,72(sp)
    80002996:	6406                	ld	s0,64(sp)
    80002998:	74e2                	ld	s1,56(sp)
    8000299a:	7942                	ld	s2,48(sp)
    8000299c:	79a2                	ld	s3,40(sp)
    8000299e:	7a02                	ld	s4,32(sp)
    800029a0:	6ae2                	ld	s5,24(sp)
    800029a2:	6b42                	ld	s6,16(sp)
    800029a4:	6ba2                	ld	s7,8(sp)
    800029a6:	6161                	addi	sp,sp,80
    800029a8:	8082                	ret

00000000800029aa <swtch>:
    800029aa:	00153023          	sd	ra,0(a0)
    800029ae:	00253423          	sd	sp,8(a0)
    800029b2:	e900                	sd	s0,16(a0)
    800029b4:	ed04                	sd	s1,24(a0)
    800029b6:	03253023          	sd	s2,32(a0)
    800029ba:	03353423          	sd	s3,40(a0)
    800029be:	03453823          	sd	s4,48(a0)
    800029c2:	03553c23          	sd	s5,56(a0)
    800029c6:	05653023          	sd	s6,64(a0)
    800029ca:	05753423          	sd	s7,72(a0)
    800029ce:	05853823          	sd	s8,80(a0)
    800029d2:	05953c23          	sd	s9,88(a0)
    800029d6:	07a53023          	sd	s10,96(a0)
    800029da:	07b53423          	sd	s11,104(a0)
    800029de:	0005b083          	ld	ra,0(a1)
    800029e2:	0085b103          	ld	sp,8(a1)
    800029e6:	6980                	ld	s0,16(a1)
    800029e8:	6d84                	ld	s1,24(a1)
    800029ea:	0205b903          	ld	s2,32(a1)
    800029ee:	0285b983          	ld	s3,40(a1)
    800029f2:	0305ba03          	ld	s4,48(a1)
    800029f6:	0385ba83          	ld	s5,56(a1)
    800029fa:	0405bb03          	ld	s6,64(a1)
    800029fe:	0485bb83          	ld	s7,72(a1)
    80002a02:	0505bc03          	ld	s8,80(a1)
    80002a06:	0585bc83          	ld	s9,88(a1)
    80002a0a:	0605bd03          	ld	s10,96(a1)
    80002a0e:	0685bd83          	ld	s11,104(a1)
    80002a12:	8082                	ret

0000000080002a14 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002a14:	1141                	addi	sp,sp,-16
    80002a16:	e406                	sd	ra,8(sp)
    80002a18:	e022                	sd	s0,0(sp)
    80002a1a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a1c:	00006597          	auipc	a1,0x6
    80002a20:	98c58593          	addi	a1,a1,-1652 # 800083a8 <states.0+0x28>
    80002a24:	00015517          	auipc	a0,0x15
    80002a28:	38c50513          	addi	a0,a0,908 # 80017db0 <tickslock>
    80002a2c:	ffffe097          	auipc	ra,0xffffe
    80002a30:	140080e7          	jalr	320(ra) # 80000b6c <initlock>
}
    80002a34:	60a2                	ld	ra,8(sp)
    80002a36:	6402                	ld	s0,0(sp)
    80002a38:	0141                	addi	sp,sp,16
    80002a3a:	8082                	ret

0000000080002a3c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002a3c:	1141                	addi	sp,sp,-16
    80002a3e:	e422                	sd	s0,8(sp)
    80002a40:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a42:	00003797          	auipc	a5,0x3
    80002a46:	4fe78793          	addi	a5,a5,1278 # 80005f40 <kernelvec>
    80002a4a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a4e:	6422                	ld	s0,8(sp)
    80002a50:	0141                	addi	sp,sp,16
    80002a52:	8082                	ret

0000000080002a54 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002a54:	1141                	addi	sp,sp,-16
    80002a56:	e406                	sd	ra,8(sp)
    80002a58:	e022                	sd	s0,0(sp)
    80002a5a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002a5c:	fffff097          	auipc	ra,0xfffff
    80002a60:	36c080e7          	jalr	876(ra) # 80001dc8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a64:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a68:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a6a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002a6e:	00004617          	auipc	a2,0x4
    80002a72:	59260613          	addi	a2,a2,1426 # 80007000 <_trampoline>
    80002a76:	00004697          	auipc	a3,0x4
    80002a7a:	58a68693          	addi	a3,a3,1418 # 80007000 <_trampoline>
    80002a7e:	8e91                	sub	a3,a3,a2
    80002a80:	040007b7          	lui	a5,0x4000
    80002a84:	17fd                	addi	a5,a5,-1
    80002a86:	07b2                	slli	a5,a5,0xc
    80002a88:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a8a:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a8e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a90:	180026f3          	csrr	a3,satp
    80002a94:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a96:	6d38                	ld	a4,88(a0)
    80002a98:	6134                	ld	a3,64(a0)
    80002a9a:	6585                	lui	a1,0x1
    80002a9c:	96ae                	add	a3,a3,a1
    80002a9e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002aa0:	6d38                	ld	a4,88(a0)
    80002aa2:	00000697          	auipc	a3,0x0
    80002aa6:	13868693          	addi	a3,a3,312 # 80002bda <usertrap>
    80002aaa:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002aac:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002aae:	8692                	mv	a3,tp
    80002ab0:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ab2:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002ab6:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002aba:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002abe:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002ac2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ac4:	6f18                	ld	a4,24(a4)
    80002ac6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002aca:	692c                	ld	a1,80(a0)
    80002acc:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002ace:	00004717          	auipc	a4,0x4
    80002ad2:	5c270713          	addi	a4,a4,1474 # 80007090 <userret>
    80002ad6:	8f11                	sub	a4,a4,a2
    80002ad8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002ada:	577d                	li	a4,-1
    80002adc:	177e                	slli	a4,a4,0x3f
    80002ade:	8dd9                	or	a1,a1,a4
    80002ae0:	02000537          	lui	a0,0x2000
    80002ae4:	157d                	addi	a0,a0,-1
    80002ae6:	0536                	slli	a0,a0,0xd
    80002ae8:	9782                	jalr	a5
}
    80002aea:	60a2                	ld	ra,8(sp)
    80002aec:	6402                	ld	s0,0(sp)
    80002aee:	0141                	addi	sp,sp,16
    80002af0:	8082                	ret

0000000080002af2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002af2:	1101                	addi	sp,sp,-32
    80002af4:	ec06                	sd	ra,24(sp)
    80002af6:	e822                	sd	s0,16(sp)
    80002af8:	e426                	sd	s1,8(sp)
    80002afa:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002afc:	00015497          	auipc	s1,0x15
    80002b00:	2b448493          	addi	s1,s1,692 # 80017db0 <tickslock>
    80002b04:	8526                	mv	a0,s1
    80002b06:	ffffe097          	auipc	ra,0xffffe
    80002b0a:	0f6080e7          	jalr	246(ra) # 80000bfc <acquire>
  ticks++;
    80002b0e:	00006517          	auipc	a0,0x6
    80002b12:	51250513          	addi	a0,a0,1298 # 80009020 <ticks>
    80002b16:	411c                	lw	a5,0(a0)
    80002b18:	2785                	addiw	a5,a5,1
    80002b1a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002b1c:	00000097          	auipc	ra,0x0
    80002b20:	c22080e7          	jalr	-990(ra) # 8000273e <wakeup>
  release(&tickslock);
    80002b24:	8526                	mv	a0,s1
    80002b26:	ffffe097          	auipc	ra,0xffffe
    80002b2a:	18a080e7          	jalr	394(ra) # 80000cb0 <release>
}
    80002b2e:	60e2                	ld	ra,24(sp)
    80002b30:	6442                	ld	s0,16(sp)
    80002b32:	64a2                	ld	s1,8(sp)
    80002b34:	6105                	addi	sp,sp,32
    80002b36:	8082                	ret

0000000080002b38 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002b38:	1101                	addi	sp,sp,-32
    80002b3a:	ec06                	sd	ra,24(sp)
    80002b3c:	e822                	sd	s0,16(sp)
    80002b3e:	e426                	sd	s1,8(sp)
    80002b40:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b42:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002b46:	00074d63          	bltz	a4,80002b60 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002b4a:	57fd                	li	a5,-1
    80002b4c:	17fe                	slli	a5,a5,0x3f
    80002b4e:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002b50:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002b52:	06f70363          	beq	a4,a5,80002bb8 <devintr+0x80>
  }
}
    80002b56:	60e2                	ld	ra,24(sp)
    80002b58:	6442                	ld	s0,16(sp)
    80002b5a:	64a2                	ld	s1,8(sp)
    80002b5c:	6105                	addi	sp,sp,32
    80002b5e:	8082                	ret
     (scause & 0xff) == 9){
    80002b60:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002b64:	46a5                	li	a3,9
    80002b66:	fed792e3          	bne	a5,a3,80002b4a <devintr+0x12>
    int irq = plic_claim();
    80002b6a:	00003097          	auipc	ra,0x3
    80002b6e:	4de080e7          	jalr	1246(ra) # 80006048 <plic_claim>
    80002b72:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002b74:	47a9                	li	a5,10
    80002b76:	02f50763          	beq	a0,a5,80002ba4 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002b7a:	4785                	li	a5,1
    80002b7c:	02f50963          	beq	a0,a5,80002bae <devintr+0x76>
    return 1;
    80002b80:	4505                	li	a0,1
    } else if(irq){
    80002b82:	d8f1                	beqz	s1,80002b56 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002b84:	85a6                	mv	a1,s1
    80002b86:	00006517          	auipc	a0,0x6
    80002b8a:	82a50513          	addi	a0,a0,-2006 # 800083b0 <states.0+0x30>
    80002b8e:	ffffe097          	auipc	ra,0xffffe
    80002b92:	9fc080e7          	jalr	-1540(ra) # 8000058a <printf>
      plic_complete(irq);
    80002b96:	8526                	mv	a0,s1
    80002b98:	00003097          	auipc	ra,0x3
    80002b9c:	4d4080e7          	jalr	1236(ra) # 8000606c <plic_complete>
    return 1;
    80002ba0:	4505                	li	a0,1
    80002ba2:	bf55                	j	80002b56 <devintr+0x1e>
      uartintr();
    80002ba4:	ffffe097          	auipc	ra,0xffffe
    80002ba8:	e1c080e7          	jalr	-484(ra) # 800009c0 <uartintr>
    80002bac:	b7ed                	j	80002b96 <devintr+0x5e>
      virtio_disk_intr();
    80002bae:	00004097          	auipc	ra,0x4
    80002bb2:	938080e7          	jalr	-1736(ra) # 800064e6 <virtio_disk_intr>
    80002bb6:	b7c5                	j	80002b96 <devintr+0x5e>
    if(cpuid() == 0){
    80002bb8:	fffff097          	auipc	ra,0xfffff
    80002bbc:	1e4080e7          	jalr	484(ra) # 80001d9c <cpuid>
    80002bc0:	c901                	beqz	a0,80002bd0 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002bc2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002bc8:	14479073          	csrw	sip,a5
    return 2;
    80002bcc:	4509                	li	a0,2
    80002bce:	b761                	j	80002b56 <devintr+0x1e>
      clockintr();
    80002bd0:	00000097          	auipc	ra,0x0
    80002bd4:	f22080e7          	jalr	-222(ra) # 80002af2 <clockintr>
    80002bd8:	b7ed                	j	80002bc2 <devintr+0x8a>

0000000080002bda <usertrap>:
{
    80002bda:	1101                	addi	sp,sp,-32
    80002bdc:	ec06                	sd	ra,24(sp)
    80002bde:	e822                	sd	s0,16(sp)
    80002be0:	e426                	sd	s1,8(sp)
    80002be2:	e04a                	sd	s2,0(sp)
    80002be4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002be6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002bea:	1007f793          	andi	a5,a5,256
    80002bee:	e3ad                	bnez	a5,80002c50 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bf0:	00003797          	auipc	a5,0x3
    80002bf4:	35078793          	addi	a5,a5,848 # 80005f40 <kernelvec>
    80002bf8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002bfc:	fffff097          	auipc	ra,0xfffff
    80002c00:	1cc080e7          	jalr	460(ra) # 80001dc8 <myproc>
    80002c04:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c06:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c08:	14102773          	csrr	a4,sepc
    80002c0c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c0e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002c12:	47a1                	li	a5,8
    80002c14:	04f71c63          	bne	a4,a5,80002c6c <usertrap+0x92>
    if(p->killed)
    80002c18:	591c                	lw	a5,48(a0)
    80002c1a:	e3b9                	bnez	a5,80002c60 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002c1c:	6cb8                	ld	a4,88(s1)
    80002c1e:	6f1c                	ld	a5,24(a4)
    80002c20:	0791                	addi	a5,a5,4
    80002c22:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002c28:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c2c:	10079073          	csrw	sstatus,a5
    syscall();
    80002c30:	00000097          	auipc	ra,0x0
    80002c34:	2e0080e7          	jalr	736(ra) # 80002f10 <syscall>
  if(p->killed)
    80002c38:	589c                	lw	a5,48(s1)
    80002c3a:	ebc1                	bnez	a5,80002cca <usertrap+0xf0>
  usertrapret();
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	e18080e7          	jalr	-488(ra) # 80002a54 <usertrapret>
}
    80002c44:	60e2                	ld	ra,24(sp)
    80002c46:	6442                	ld	s0,16(sp)
    80002c48:	64a2                	ld	s1,8(sp)
    80002c4a:	6902                	ld	s2,0(sp)
    80002c4c:	6105                	addi	sp,sp,32
    80002c4e:	8082                	ret
    panic("usertrap: not from user mode");
    80002c50:	00005517          	auipc	a0,0x5
    80002c54:	78050513          	addi	a0,a0,1920 # 800083d0 <states.0+0x50>
    80002c58:	ffffe097          	auipc	ra,0xffffe
    80002c5c:	8e8080e7          	jalr	-1816(ra) # 80000540 <panic>
      exit(-1);
    80002c60:	557d                	li	a0,-1
    80002c62:	fffff097          	auipc	ra,0xfffff
    80002c66:	7ae080e7          	jalr	1966(ra) # 80002410 <exit>
    80002c6a:	bf4d                	j	80002c1c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	ecc080e7          	jalr	-308(ra) # 80002b38 <devintr>
    80002c74:	892a                	mv	s2,a0
    80002c76:	c501                	beqz	a0,80002c7e <usertrap+0xa4>
  if(p->killed)
    80002c78:	589c                	lw	a5,48(s1)
    80002c7a:	c3a1                	beqz	a5,80002cba <usertrap+0xe0>
    80002c7c:	a815                	j	80002cb0 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c7e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002c82:	5c90                	lw	a2,56(s1)
    80002c84:	00005517          	auipc	a0,0x5
    80002c88:	76c50513          	addi	a0,a0,1900 # 800083f0 <states.0+0x70>
    80002c8c:	ffffe097          	auipc	ra,0xffffe
    80002c90:	8fe080e7          	jalr	-1794(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c94:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c98:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c9c:	00005517          	auipc	a0,0x5
    80002ca0:	78450513          	addi	a0,a0,1924 # 80008420 <states.0+0xa0>
    80002ca4:	ffffe097          	auipc	ra,0xffffe
    80002ca8:	8e6080e7          	jalr	-1818(ra) # 8000058a <printf>
    p->killed = 1;
    80002cac:	4785                	li	a5,1
    80002cae:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002cb0:	557d                	li	a0,-1
    80002cb2:	fffff097          	auipc	ra,0xfffff
    80002cb6:	75e080e7          	jalr	1886(ra) # 80002410 <exit>
  if(which_dev == 2)
    80002cba:	4789                	li	a5,2
    80002cbc:	f8f910e3          	bne	s2,a5,80002c3c <usertrap+0x62>
    yield();
    80002cc0:	00000097          	auipc	ra,0x0
    80002cc4:	85a080e7          	jalr	-1958(ra) # 8000251a <yield>
    80002cc8:	bf95                	j	80002c3c <usertrap+0x62>
  int which_dev = 0;
    80002cca:	4901                	li	s2,0
    80002ccc:	b7d5                	j	80002cb0 <usertrap+0xd6>

0000000080002cce <kerneltrap>:
{
    80002cce:	7179                	addi	sp,sp,-48
    80002cd0:	f406                	sd	ra,40(sp)
    80002cd2:	f022                	sd	s0,32(sp)
    80002cd4:	ec26                	sd	s1,24(sp)
    80002cd6:	e84a                	sd	s2,16(sp)
    80002cd8:	e44e                	sd	s3,8(sp)
    80002cda:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cdc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ce0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ce4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ce8:	1004f793          	andi	a5,s1,256
    80002cec:	cb85                	beqz	a5,80002d1c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cee:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002cf2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002cf4:	ef85                	bnez	a5,80002d2c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	e42080e7          	jalr	-446(ra) # 80002b38 <devintr>
    80002cfe:	cd1d                	beqz	a0,80002d3c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d00:	4789                	li	a5,2
    80002d02:	06f50a63          	beq	a0,a5,80002d76 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d06:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d0a:	10049073          	csrw	sstatus,s1
}
    80002d0e:	70a2                	ld	ra,40(sp)
    80002d10:	7402                	ld	s0,32(sp)
    80002d12:	64e2                	ld	s1,24(sp)
    80002d14:	6942                	ld	s2,16(sp)
    80002d16:	69a2                	ld	s3,8(sp)
    80002d18:	6145                	addi	sp,sp,48
    80002d1a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002d1c:	00005517          	auipc	a0,0x5
    80002d20:	72450513          	addi	a0,a0,1828 # 80008440 <states.0+0xc0>
    80002d24:	ffffe097          	auipc	ra,0xffffe
    80002d28:	81c080e7          	jalr	-2020(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    80002d2c:	00005517          	auipc	a0,0x5
    80002d30:	73c50513          	addi	a0,a0,1852 # 80008468 <states.0+0xe8>
    80002d34:	ffffe097          	auipc	ra,0xffffe
    80002d38:	80c080e7          	jalr	-2036(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    80002d3c:	85ce                	mv	a1,s3
    80002d3e:	00005517          	auipc	a0,0x5
    80002d42:	74a50513          	addi	a0,a0,1866 # 80008488 <states.0+0x108>
    80002d46:	ffffe097          	auipc	ra,0xffffe
    80002d4a:	844080e7          	jalr	-1980(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d4e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d52:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d56:	00005517          	auipc	a0,0x5
    80002d5a:	74250513          	addi	a0,a0,1858 # 80008498 <states.0+0x118>
    80002d5e:	ffffe097          	auipc	ra,0xffffe
    80002d62:	82c080e7          	jalr	-2004(ra) # 8000058a <printf>
    panic("kerneltrap");
    80002d66:	00005517          	auipc	a0,0x5
    80002d6a:	74a50513          	addi	a0,a0,1866 # 800084b0 <states.0+0x130>
    80002d6e:	ffffd097          	auipc	ra,0xffffd
    80002d72:	7d2080e7          	jalr	2002(ra) # 80000540 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	052080e7          	jalr	82(ra) # 80001dc8 <myproc>
    80002d7e:	d541                	beqz	a0,80002d06 <kerneltrap+0x38>
    80002d80:	fffff097          	auipc	ra,0xfffff
    80002d84:	048080e7          	jalr	72(ra) # 80001dc8 <myproc>
    80002d88:	4d18                	lw	a4,24(a0)
    80002d8a:	478d                	li	a5,3
    80002d8c:	f6f71de3          	bne	a4,a5,80002d06 <kerneltrap+0x38>
    yield();
    80002d90:	fffff097          	auipc	ra,0xfffff
    80002d94:	78a080e7          	jalr	1930(ra) # 8000251a <yield>
    80002d98:	b7bd                	j	80002d06 <kerneltrap+0x38>

0000000080002d9a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d9a:	1101                	addi	sp,sp,-32
    80002d9c:	ec06                	sd	ra,24(sp)
    80002d9e:	e822                	sd	s0,16(sp)
    80002da0:	e426                	sd	s1,8(sp)
    80002da2:	1000                	addi	s0,sp,32
    80002da4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002da6:	fffff097          	auipc	ra,0xfffff
    80002daa:	022080e7          	jalr	34(ra) # 80001dc8 <myproc>
  switch (n) {
    80002dae:	4795                	li	a5,5
    80002db0:	0497e163          	bltu	a5,s1,80002df2 <argraw+0x58>
    80002db4:	048a                	slli	s1,s1,0x2
    80002db6:	00005717          	auipc	a4,0x5
    80002dba:	73270713          	addi	a4,a4,1842 # 800084e8 <states.0+0x168>
    80002dbe:	94ba                	add	s1,s1,a4
    80002dc0:	409c                	lw	a5,0(s1)
    80002dc2:	97ba                	add	a5,a5,a4
    80002dc4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002dc6:	6d3c                	ld	a5,88(a0)
    80002dc8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002dca:	60e2                	ld	ra,24(sp)
    80002dcc:	6442                	ld	s0,16(sp)
    80002dce:	64a2                	ld	s1,8(sp)
    80002dd0:	6105                	addi	sp,sp,32
    80002dd2:	8082                	ret
    return p->trapframe->a1;
    80002dd4:	6d3c                	ld	a5,88(a0)
    80002dd6:	7fa8                	ld	a0,120(a5)
    80002dd8:	bfcd                	j	80002dca <argraw+0x30>
    return p->trapframe->a2;
    80002dda:	6d3c                	ld	a5,88(a0)
    80002ddc:	63c8                	ld	a0,128(a5)
    80002dde:	b7f5                	j	80002dca <argraw+0x30>
    return p->trapframe->a3;
    80002de0:	6d3c                	ld	a5,88(a0)
    80002de2:	67c8                	ld	a0,136(a5)
    80002de4:	b7dd                	j	80002dca <argraw+0x30>
    return p->trapframe->a4;
    80002de6:	6d3c                	ld	a5,88(a0)
    80002de8:	6bc8                	ld	a0,144(a5)
    80002dea:	b7c5                	j	80002dca <argraw+0x30>
    return p->trapframe->a5;
    80002dec:	6d3c                	ld	a5,88(a0)
    80002dee:	6fc8                	ld	a0,152(a5)
    80002df0:	bfe9                	j	80002dca <argraw+0x30>
  panic("argraw");
    80002df2:	00005517          	auipc	a0,0x5
    80002df6:	6ce50513          	addi	a0,a0,1742 # 800084c0 <states.0+0x140>
    80002dfa:	ffffd097          	auipc	ra,0xffffd
    80002dfe:	746080e7          	jalr	1862(ra) # 80000540 <panic>

0000000080002e02 <fetchaddr>:
{
    80002e02:	1101                	addi	sp,sp,-32
    80002e04:	ec06                	sd	ra,24(sp)
    80002e06:	e822                	sd	s0,16(sp)
    80002e08:	e426                	sd	s1,8(sp)
    80002e0a:	e04a                	sd	s2,0(sp)
    80002e0c:	1000                	addi	s0,sp,32
    80002e0e:	84aa                	mv	s1,a0
    80002e10:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002e12:	fffff097          	auipc	ra,0xfffff
    80002e16:	fb6080e7          	jalr	-74(ra) # 80001dc8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002e1a:	653c                	ld	a5,72(a0)
    80002e1c:	02f4f863          	bgeu	s1,a5,80002e4c <fetchaddr+0x4a>
    80002e20:	00848713          	addi	a4,s1,8
    80002e24:	02e7e663          	bltu	a5,a4,80002e50 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e28:	46a1                	li	a3,8
    80002e2a:	8626                	mv	a2,s1
    80002e2c:	85ca                	mv	a1,s2
    80002e2e:	6928                	ld	a0,80(a0)
    80002e30:	fffff097          	auipc	ra,0xfffff
    80002e34:	906080e7          	jalr	-1786(ra) # 80001736 <copyin>
    80002e38:	00a03533          	snez	a0,a0
    80002e3c:	40a00533          	neg	a0,a0
}
    80002e40:	60e2                	ld	ra,24(sp)
    80002e42:	6442                	ld	s0,16(sp)
    80002e44:	64a2                	ld	s1,8(sp)
    80002e46:	6902                	ld	s2,0(sp)
    80002e48:	6105                	addi	sp,sp,32
    80002e4a:	8082                	ret
    return -1;
    80002e4c:	557d                	li	a0,-1
    80002e4e:	bfcd                	j	80002e40 <fetchaddr+0x3e>
    80002e50:	557d                	li	a0,-1
    80002e52:	b7fd                	j	80002e40 <fetchaddr+0x3e>

0000000080002e54 <fetchstr>:
{
    80002e54:	7179                	addi	sp,sp,-48
    80002e56:	f406                	sd	ra,40(sp)
    80002e58:	f022                	sd	s0,32(sp)
    80002e5a:	ec26                	sd	s1,24(sp)
    80002e5c:	e84a                	sd	s2,16(sp)
    80002e5e:	e44e                	sd	s3,8(sp)
    80002e60:	1800                	addi	s0,sp,48
    80002e62:	892a                	mv	s2,a0
    80002e64:	84ae                	mv	s1,a1
    80002e66:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002e68:	fffff097          	auipc	ra,0xfffff
    80002e6c:	f60080e7          	jalr	-160(ra) # 80001dc8 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002e70:	86ce                	mv	a3,s3
    80002e72:	864a                	mv	a2,s2
    80002e74:	85a6                	mv	a1,s1
    80002e76:	6928                	ld	a0,80(a0)
    80002e78:	fffff097          	auipc	ra,0xfffff
    80002e7c:	94c080e7          	jalr	-1716(ra) # 800017c4 <copyinstr>
  if(err < 0)
    80002e80:	00054763          	bltz	a0,80002e8e <fetchstr+0x3a>
  return strlen(buf);
    80002e84:	8526                	mv	a0,s1
    80002e86:	ffffe097          	auipc	ra,0xffffe
    80002e8a:	ff6080e7          	jalr	-10(ra) # 80000e7c <strlen>
}
    80002e8e:	70a2                	ld	ra,40(sp)
    80002e90:	7402                	ld	s0,32(sp)
    80002e92:	64e2                	ld	s1,24(sp)
    80002e94:	6942                	ld	s2,16(sp)
    80002e96:	69a2                	ld	s3,8(sp)
    80002e98:	6145                	addi	sp,sp,48
    80002e9a:	8082                	ret

0000000080002e9c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002e9c:	1101                	addi	sp,sp,-32
    80002e9e:	ec06                	sd	ra,24(sp)
    80002ea0:	e822                	sd	s0,16(sp)
    80002ea2:	e426                	sd	s1,8(sp)
    80002ea4:	1000                	addi	s0,sp,32
    80002ea6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	ef2080e7          	jalr	-270(ra) # 80002d9a <argraw>
    80002eb0:	c088                	sw	a0,0(s1)
  return 0;
}
    80002eb2:	4501                	li	a0,0
    80002eb4:	60e2                	ld	ra,24(sp)
    80002eb6:	6442                	ld	s0,16(sp)
    80002eb8:	64a2                	ld	s1,8(sp)
    80002eba:	6105                	addi	sp,sp,32
    80002ebc:	8082                	ret

0000000080002ebe <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002ebe:	1101                	addi	sp,sp,-32
    80002ec0:	ec06                	sd	ra,24(sp)
    80002ec2:	e822                	sd	s0,16(sp)
    80002ec4:	e426                	sd	s1,8(sp)
    80002ec6:	1000                	addi	s0,sp,32
    80002ec8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002eca:	00000097          	auipc	ra,0x0
    80002ece:	ed0080e7          	jalr	-304(ra) # 80002d9a <argraw>
    80002ed2:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ed4:	4501                	li	a0,0
    80002ed6:	60e2                	ld	ra,24(sp)
    80002ed8:	6442                	ld	s0,16(sp)
    80002eda:	64a2                	ld	s1,8(sp)
    80002edc:	6105                	addi	sp,sp,32
    80002ede:	8082                	ret

0000000080002ee0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002ee0:	1101                	addi	sp,sp,-32
    80002ee2:	ec06                	sd	ra,24(sp)
    80002ee4:	e822                	sd	s0,16(sp)
    80002ee6:	e426                	sd	s1,8(sp)
    80002ee8:	e04a                	sd	s2,0(sp)
    80002eea:	1000                	addi	s0,sp,32
    80002eec:	84ae                	mv	s1,a1
    80002eee:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002ef0:	00000097          	auipc	ra,0x0
    80002ef4:	eaa080e7          	jalr	-342(ra) # 80002d9a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002ef8:	864a                	mv	a2,s2
    80002efa:	85a6                	mv	a1,s1
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	f58080e7          	jalr	-168(ra) # 80002e54 <fetchstr>
}
    80002f04:	60e2                	ld	ra,24(sp)
    80002f06:	6442                	ld	s0,16(sp)
    80002f08:	64a2                	ld	s1,8(sp)
    80002f0a:	6902                	ld	s2,0(sp)
    80002f0c:	6105                	addi	sp,sp,32
    80002f0e:	8082                	ret

0000000080002f10 <syscall>:

#endif

void
syscall(void)
{
    80002f10:	1101                	addi	sp,sp,-32
    80002f12:	ec06                	sd	ra,24(sp)
    80002f14:	e822                	sd	s0,16(sp)
    80002f16:	e426                	sd	s1,8(sp)
    80002f18:	e04a                	sd	s2,0(sp)
    80002f1a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	eac080e7          	jalr	-340(ra) # 80001dc8 <myproc>
    80002f24:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002f26:	05853903          	ld	s2,88(a0)
    80002f2a:	0a893783          	ld	a5,168(s2)
    80002f2e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002f32:	37fd                	addiw	a5,a5,-1
    80002f34:	4751                	li	a4,20
    80002f36:	00f76f63          	bltu	a4,a5,80002f54 <syscall+0x44>
    80002f3a:	00369713          	slli	a4,a3,0x3
    80002f3e:	00005797          	auipc	a5,0x5
    80002f42:	5c278793          	addi	a5,a5,1474 # 80008500 <syscalls>
    80002f46:	97ba                	add	a5,a5,a4
    80002f48:	639c                	ld	a5,0(a5)
    80002f4a:	c789                	beqz	a5,80002f54 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002f4c:	9782                	jalr	a5
    80002f4e:	06a93823          	sd	a0,112(s2)
    80002f52:	a839                	j	80002f70 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002f54:	15848613          	addi	a2,s1,344
    80002f58:	5c8c                	lw	a1,56(s1)
    80002f5a:	00005517          	auipc	a0,0x5
    80002f5e:	56e50513          	addi	a0,a0,1390 # 800084c8 <states.0+0x148>
    80002f62:	ffffd097          	auipc	ra,0xffffd
    80002f66:	628080e7          	jalr	1576(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002f6a:	6cbc                	ld	a5,88(s1)
    80002f6c:	577d                	li	a4,-1
    80002f6e:	fbb8                	sd	a4,112(a5)
  }
#ifdef SUKJOON
  acquire(&p->lock);
    80002f70:	8526                	mv	a0,s1
    80002f72:	ffffe097          	auipc	ra,0xffffe
    80002f76:	c8a080e7          	jalr	-886(ra) # 80000bfc <acquire>
  if (is_q1(p)) { remove(&q1, p); enqueue(&q2, p); }
    80002f7a:	8526                	mv	a0,s1
    80002f7c:	fffff097          	auipc	ra,0xfffff
    80002f80:	996080e7          	jalr	-1642(ra) # 80001912 <is_q1>
    80002f84:	ed01                	bnez	a0,80002f9c <syscall+0x8c>
  release(&p->lock);
    80002f86:	8526                	mv	a0,s1
    80002f88:	ffffe097          	auipc	ra,0xffffe
    80002f8c:	d28080e7          	jalr	-728(ra) # 80000cb0 <release>
#endif
}
    80002f90:	60e2                	ld	ra,24(sp)
    80002f92:	6442                	ld	s0,16(sp)
    80002f94:	64a2                	ld	s1,8(sp)
    80002f96:	6902                	ld	s2,0(sp)
    80002f98:	6105                	addi	sp,sp,32
    80002f9a:	8082                	ret
  if (is_q1(p)) { remove(&q1, p); enqueue(&q2, p); }
    80002f9c:	85a6                	mv	a1,s1
    80002f9e:	0000f517          	auipc	a0,0xf
    80002fa2:	9ca50513          	addi	a0,a0,-1590 # 80011968 <q1>
    80002fa6:	fffff097          	auipc	ra,0xfffff
    80002faa:	a94080e7          	jalr	-1388(ra) # 80001a3a <remove>
    80002fae:	85a6                	mv	a1,s1
    80002fb0:	0000f517          	auipc	a0,0xf
    80002fb4:	9a050513          	addi	a0,a0,-1632 # 80011950 <q2>
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	9fc080e7          	jalr	-1540(ra) # 800019b4 <enqueue>
    80002fc0:	b7d9                	j	80002f86 <syscall+0x76>

0000000080002fc2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002fc2:	1101                	addi	sp,sp,-32
    80002fc4:	ec06                	sd	ra,24(sp)
    80002fc6:	e822                	sd	s0,16(sp)
    80002fc8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002fca:	fec40593          	addi	a1,s0,-20
    80002fce:	4501                	li	a0,0
    80002fd0:	00000097          	auipc	ra,0x0
    80002fd4:	ecc080e7          	jalr	-308(ra) # 80002e9c <argint>
    return -1;
    80002fd8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002fda:	00054963          	bltz	a0,80002fec <sys_exit+0x2a>
  exit(n);
    80002fde:	fec42503          	lw	a0,-20(s0)
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	42e080e7          	jalr	1070(ra) # 80002410 <exit>
  return 0;  // not reached
    80002fea:	4781                	li	a5,0
}
    80002fec:	853e                	mv	a0,a5
    80002fee:	60e2                	ld	ra,24(sp)
    80002ff0:	6442                	ld	s0,16(sp)
    80002ff2:	6105                	addi	sp,sp,32
    80002ff4:	8082                	ret

0000000080002ff6 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002ff6:	1141                	addi	sp,sp,-16
    80002ff8:	e406                	sd	ra,8(sp)
    80002ffa:	e022                	sd	s0,0(sp)
    80002ffc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002ffe:	fffff097          	auipc	ra,0xfffff
    80003002:	dca080e7          	jalr	-566(ra) # 80001dc8 <myproc>
}
    80003006:	5d08                	lw	a0,56(a0)
    80003008:	60a2                	ld	ra,8(sp)
    8000300a:	6402                	ld	s0,0(sp)
    8000300c:	0141                	addi	sp,sp,16
    8000300e:	8082                	ret

0000000080003010 <sys_fork>:

uint64
sys_fork(void)
{
    80003010:	1141                	addi	sp,sp,-16
    80003012:	e406                	sd	ra,8(sp)
    80003014:	e022                	sd	s0,0(sp)
    80003016:	0800                	addi	s0,sp,16
  return fork();
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	19e080e7          	jalr	414(ra) # 800021b6 <fork>
}
    80003020:	60a2                	ld	ra,8(sp)
    80003022:	6402                	ld	s0,0(sp)
    80003024:	0141                	addi	sp,sp,16
    80003026:	8082                	ret

0000000080003028 <sys_wait>:

uint64
sys_wait(void)
{
    80003028:	1101                	addi	sp,sp,-32
    8000302a:	ec06                	sd	ra,24(sp)
    8000302c:	e822                	sd	s0,16(sp)
    8000302e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80003030:	fe840593          	addi	a1,s0,-24
    80003034:	4501                	li	a0,0
    80003036:	00000097          	auipc	ra,0x0
    8000303a:	e88080e7          	jalr	-376(ra) # 80002ebe <argaddr>
    8000303e:	87aa                	mv	a5,a0
    return -1;
    80003040:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003042:	0007c863          	bltz	a5,80003052 <sys_wait+0x2a>
  return wait(p);
    80003046:	fe843503          	ld	a0,-24(s0)
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	5f2080e7          	jalr	1522(ra) # 8000263c <wait>
}
    80003052:	60e2                	ld	ra,24(sp)
    80003054:	6442                	ld	s0,16(sp)
    80003056:	6105                	addi	sp,sp,32
    80003058:	8082                	ret

000000008000305a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000305a:	7179                	addi	sp,sp,-48
    8000305c:	f406                	sd	ra,40(sp)
    8000305e:	f022                	sd	s0,32(sp)
    80003060:	ec26                	sd	s1,24(sp)
    80003062:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003064:	fdc40593          	addi	a1,s0,-36
    80003068:	4501                	li	a0,0
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	e32080e7          	jalr	-462(ra) # 80002e9c <argint>
    return -1;
    80003072:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80003074:	00054f63          	bltz	a0,80003092 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	d50080e7          	jalr	-688(ra) # 80001dc8 <myproc>
    80003080:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80003082:	fdc42503          	lw	a0,-36(s0)
    80003086:	fffff097          	auipc	ra,0xfffff
    8000308a:	0bc080e7          	jalr	188(ra) # 80002142 <growproc>
    8000308e:	00054863          	bltz	a0,8000309e <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80003092:	8526                	mv	a0,s1
    80003094:	70a2                	ld	ra,40(sp)
    80003096:	7402                	ld	s0,32(sp)
    80003098:	64e2                	ld	s1,24(sp)
    8000309a:	6145                	addi	sp,sp,48
    8000309c:	8082                	ret
    return -1;
    8000309e:	54fd                	li	s1,-1
    800030a0:	bfcd                	j	80003092 <sys_sbrk+0x38>

00000000800030a2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800030a2:	7139                	addi	sp,sp,-64
    800030a4:	fc06                	sd	ra,56(sp)
    800030a6:	f822                	sd	s0,48(sp)
    800030a8:	f426                	sd	s1,40(sp)
    800030aa:	f04a                	sd	s2,32(sp)
    800030ac:	ec4e                	sd	s3,24(sp)
    800030ae:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800030b0:	fcc40593          	addi	a1,s0,-52
    800030b4:	4501                	li	a0,0
    800030b6:	00000097          	auipc	ra,0x0
    800030ba:	de6080e7          	jalr	-538(ra) # 80002e9c <argint>
    return -1;
    800030be:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800030c0:	06054563          	bltz	a0,8000312a <sys_sleep+0x88>
  acquire(&tickslock);
    800030c4:	00015517          	auipc	a0,0x15
    800030c8:	cec50513          	addi	a0,a0,-788 # 80017db0 <tickslock>
    800030cc:	ffffe097          	auipc	ra,0xffffe
    800030d0:	b30080e7          	jalr	-1232(ra) # 80000bfc <acquire>
  ticks0 = ticks;
    800030d4:	00006917          	auipc	s2,0x6
    800030d8:	f4c92903          	lw	s2,-180(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    800030dc:	fcc42783          	lw	a5,-52(s0)
    800030e0:	cf85                	beqz	a5,80003118 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800030e2:	00015997          	auipc	s3,0x15
    800030e6:	cce98993          	addi	s3,s3,-818 # 80017db0 <tickslock>
    800030ea:	00006497          	auipc	s1,0x6
    800030ee:	f3648493          	addi	s1,s1,-202 # 80009020 <ticks>
    if(myproc()->killed){
    800030f2:	fffff097          	auipc	ra,0xfffff
    800030f6:	cd6080e7          	jalr	-810(ra) # 80001dc8 <myproc>
    800030fa:	591c                	lw	a5,48(a0)
    800030fc:	ef9d                	bnez	a5,8000313a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800030fe:	85ce                	mv	a1,s3
    80003100:	8526                	mv	a0,s1
    80003102:	fffff097          	auipc	ra,0xfffff
    80003106:	4bc080e7          	jalr	1212(ra) # 800025be <sleep>
  while(ticks - ticks0 < n){
    8000310a:	409c                	lw	a5,0(s1)
    8000310c:	412787bb          	subw	a5,a5,s2
    80003110:	fcc42703          	lw	a4,-52(s0)
    80003114:	fce7efe3          	bltu	a5,a4,800030f2 <sys_sleep+0x50>
  }
  release(&tickslock);
    80003118:	00015517          	auipc	a0,0x15
    8000311c:	c9850513          	addi	a0,a0,-872 # 80017db0 <tickslock>
    80003120:	ffffe097          	auipc	ra,0xffffe
    80003124:	b90080e7          	jalr	-1136(ra) # 80000cb0 <release>
  return 0;
    80003128:	4781                	li	a5,0
}
    8000312a:	853e                	mv	a0,a5
    8000312c:	70e2                	ld	ra,56(sp)
    8000312e:	7442                	ld	s0,48(sp)
    80003130:	74a2                	ld	s1,40(sp)
    80003132:	7902                	ld	s2,32(sp)
    80003134:	69e2                	ld	s3,24(sp)
    80003136:	6121                	addi	sp,sp,64
    80003138:	8082                	ret
      release(&tickslock);
    8000313a:	00015517          	auipc	a0,0x15
    8000313e:	c7650513          	addi	a0,a0,-906 # 80017db0 <tickslock>
    80003142:	ffffe097          	auipc	ra,0xffffe
    80003146:	b6e080e7          	jalr	-1170(ra) # 80000cb0 <release>
      return -1;
    8000314a:	57fd                	li	a5,-1
    8000314c:	bff9                	j	8000312a <sys_sleep+0x88>

000000008000314e <sys_kill>:

uint64
sys_kill(void)
{
    8000314e:	1101                	addi	sp,sp,-32
    80003150:	ec06                	sd	ra,24(sp)
    80003152:	e822                	sd	s0,16(sp)
    80003154:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003156:	fec40593          	addi	a1,s0,-20
    8000315a:	4501                	li	a0,0
    8000315c:	00000097          	auipc	ra,0x0
    80003160:	d40080e7          	jalr	-704(ra) # 80002e9c <argint>
    80003164:	87aa                	mv	a5,a0
    return -1;
    80003166:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80003168:	0007c863          	bltz	a5,80003178 <sys_kill+0x2a>
  return kill(pid);
    8000316c:	fec42503          	lw	a0,-20(s0)
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	66e080e7          	jalr	1646(ra) # 800027de <kill>
}
    80003178:	60e2                	ld	ra,24(sp)
    8000317a:	6442                	ld	s0,16(sp)
    8000317c:	6105                	addi	sp,sp,32
    8000317e:	8082                	ret

0000000080003180 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003180:	1101                	addi	sp,sp,-32
    80003182:	ec06                	sd	ra,24(sp)
    80003184:	e822                	sd	s0,16(sp)
    80003186:	e426                	sd	s1,8(sp)
    80003188:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000318a:	00015517          	auipc	a0,0x15
    8000318e:	c2650513          	addi	a0,a0,-986 # 80017db0 <tickslock>
    80003192:	ffffe097          	auipc	ra,0xffffe
    80003196:	a6a080e7          	jalr	-1430(ra) # 80000bfc <acquire>
  xticks = ticks;
    8000319a:	00006497          	auipc	s1,0x6
    8000319e:	e864a483          	lw	s1,-378(s1) # 80009020 <ticks>
  release(&tickslock);
    800031a2:	00015517          	auipc	a0,0x15
    800031a6:	c0e50513          	addi	a0,a0,-1010 # 80017db0 <tickslock>
    800031aa:	ffffe097          	auipc	ra,0xffffe
    800031ae:	b06080e7          	jalr	-1274(ra) # 80000cb0 <release>
  return xticks;
}
    800031b2:	02049513          	slli	a0,s1,0x20
    800031b6:	9101                	srli	a0,a0,0x20
    800031b8:	60e2                	ld	ra,24(sp)
    800031ba:	6442                	ld	s0,16(sp)
    800031bc:	64a2                	ld	s1,8(sp)
    800031be:	6105                	addi	sp,sp,32
    800031c0:	8082                	ret

00000000800031c2 <binit>:
    800031c2:	7179                	addi	sp,sp,-48
    800031c4:	f406                	sd	ra,40(sp)
    800031c6:	f022                	sd	s0,32(sp)
    800031c8:	ec26                	sd	s1,24(sp)
    800031ca:	e84a                	sd	s2,16(sp)
    800031cc:	e44e                	sd	s3,8(sp)
    800031ce:	e052                	sd	s4,0(sp)
    800031d0:	1800                	addi	s0,sp,48
    800031d2:	00005597          	auipc	a1,0x5
    800031d6:	3de58593          	addi	a1,a1,990 # 800085b0 <syscalls+0xb0>
    800031da:	00015517          	auipc	a0,0x15
    800031de:	bee50513          	addi	a0,a0,-1042 # 80017dc8 <bcache>
    800031e2:	ffffe097          	auipc	ra,0xffffe
    800031e6:	98a080e7          	jalr	-1654(ra) # 80000b6c <initlock>
    800031ea:	0001d797          	auipc	a5,0x1d
    800031ee:	bde78793          	addi	a5,a5,-1058 # 8001fdc8 <bcache+0x8000>
    800031f2:	0001d717          	auipc	a4,0x1d
    800031f6:	e3e70713          	addi	a4,a4,-450 # 80020030 <bcache+0x8268>
    800031fa:	2ae7b823          	sd	a4,688(a5)
    800031fe:	2ae7bc23          	sd	a4,696(a5)
    80003202:	00015497          	auipc	s1,0x15
    80003206:	bde48493          	addi	s1,s1,-1058 # 80017de0 <bcache+0x18>
    8000320a:	893e                	mv	s2,a5
    8000320c:	89ba                	mv	s3,a4
    8000320e:	00005a17          	auipc	s4,0x5
    80003212:	3aaa0a13          	addi	s4,s4,938 # 800085b8 <syscalls+0xb8>
    80003216:	2b893783          	ld	a5,696(s2)
    8000321a:	e8bc                	sd	a5,80(s1)
    8000321c:	0534b423          	sd	s3,72(s1)
    80003220:	85d2                	mv	a1,s4
    80003222:	01048513          	addi	a0,s1,16
    80003226:	00001097          	auipc	ra,0x1
    8000322a:	4b2080e7          	jalr	1202(ra) # 800046d8 <initsleeplock>
    8000322e:	2b893783          	ld	a5,696(s2)
    80003232:	e7a4                	sd	s1,72(a5)
    80003234:	2a993c23          	sd	s1,696(s2)
    80003238:	45848493          	addi	s1,s1,1112
    8000323c:	fd349de3          	bne	s1,s3,80003216 <binit+0x54>
    80003240:	70a2                	ld	ra,40(sp)
    80003242:	7402                	ld	s0,32(sp)
    80003244:	64e2                	ld	s1,24(sp)
    80003246:	6942                	ld	s2,16(sp)
    80003248:	69a2                	ld	s3,8(sp)
    8000324a:	6a02                	ld	s4,0(sp)
    8000324c:	6145                	addi	sp,sp,48
    8000324e:	8082                	ret

0000000080003250 <bread>:
    80003250:	7179                	addi	sp,sp,-48
    80003252:	f406                	sd	ra,40(sp)
    80003254:	f022                	sd	s0,32(sp)
    80003256:	ec26                	sd	s1,24(sp)
    80003258:	e84a                	sd	s2,16(sp)
    8000325a:	e44e                	sd	s3,8(sp)
    8000325c:	1800                	addi	s0,sp,48
    8000325e:	892a                	mv	s2,a0
    80003260:	89ae                	mv	s3,a1
    80003262:	00015517          	auipc	a0,0x15
    80003266:	b6650513          	addi	a0,a0,-1178 # 80017dc8 <bcache>
    8000326a:	ffffe097          	auipc	ra,0xffffe
    8000326e:	992080e7          	jalr	-1646(ra) # 80000bfc <acquire>
    80003272:	0001d497          	auipc	s1,0x1d
    80003276:	e0e4b483          	ld	s1,-498(s1) # 80020080 <bcache+0x82b8>
    8000327a:	0001d797          	auipc	a5,0x1d
    8000327e:	db678793          	addi	a5,a5,-586 # 80020030 <bcache+0x8268>
    80003282:	02f48f63          	beq	s1,a5,800032c0 <bread+0x70>
    80003286:	873e                	mv	a4,a5
    80003288:	a021                	j	80003290 <bread+0x40>
    8000328a:	68a4                	ld	s1,80(s1)
    8000328c:	02e48a63          	beq	s1,a4,800032c0 <bread+0x70>
    80003290:	449c                	lw	a5,8(s1)
    80003292:	ff279ce3          	bne	a5,s2,8000328a <bread+0x3a>
    80003296:	44dc                	lw	a5,12(s1)
    80003298:	ff3799e3          	bne	a5,s3,8000328a <bread+0x3a>
    8000329c:	40bc                	lw	a5,64(s1)
    8000329e:	2785                	addiw	a5,a5,1
    800032a0:	c0bc                	sw	a5,64(s1)
    800032a2:	00015517          	auipc	a0,0x15
    800032a6:	b2650513          	addi	a0,a0,-1242 # 80017dc8 <bcache>
    800032aa:	ffffe097          	auipc	ra,0xffffe
    800032ae:	a06080e7          	jalr	-1530(ra) # 80000cb0 <release>
    800032b2:	01048513          	addi	a0,s1,16
    800032b6:	00001097          	auipc	ra,0x1
    800032ba:	45c080e7          	jalr	1116(ra) # 80004712 <acquiresleep>
    800032be:	a8b9                	j	8000331c <bread+0xcc>
    800032c0:	0001d497          	auipc	s1,0x1d
    800032c4:	db84b483          	ld	s1,-584(s1) # 80020078 <bcache+0x82b0>
    800032c8:	0001d797          	auipc	a5,0x1d
    800032cc:	d6878793          	addi	a5,a5,-664 # 80020030 <bcache+0x8268>
    800032d0:	00f48863          	beq	s1,a5,800032e0 <bread+0x90>
    800032d4:	873e                	mv	a4,a5
    800032d6:	40bc                	lw	a5,64(s1)
    800032d8:	cf81                	beqz	a5,800032f0 <bread+0xa0>
    800032da:	64a4                	ld	s1,72(s1)
    800032dc:	fee49de3          	bne	s1,a4,800032d6 <bread+0x86>
    800032e0:	00005517          	auipc	a0,0x5
    800032e4:	2e050513          	addi	a0,a0,736 # 800085c0 <syscalls+0xc0>
    800032e8:	ffffd097          	auipc	ra,0xffffd
    800032ec:	258080e7          	jalr	600(ra) # 80000540 <panic>
    800032f0:	0124a423          	sw	s2,8(s1)
    800032f4:	0134a623          	sw	s3,12(s1)
    800032f8:	0004a023          	sw	zero,0(s1)
    800032fc:	4785                	li	a5,1
    800032fe:	c0bc                	sw	a5,64(s1)
    80003300:	00015517          	auipc	a0,0x15
    80003304:	ac850513          	addi	a0,a0,-1336 # 80017dc8 <bcache>
    80003308:	ffffe097          	auipc	ra,0xffffe
    8000330c:	9a8080e7          	jalr	-1624(ra) # 80000cb0 <release>
    80003310:	01048513          	addi	a0,s1,16
    80003314:	00001097          	auipc	ra,0x1
    80003318:	3fe080e7          	jalr	1022(ra) # 80004712 <acquiresleep>
    8000331c:	409c                	lw	a5,0(s1)
    8000331e:	cb89                	beqz	a5,80003330 <bread+0xe0>
    80003320:	8526                	mv	a0,s1
    80003322:	70a2                	ld	ra,40(sp)
    80003324:	7402                	ld	s0,32(sp)
    80003326:	64e2                	ld	s1,24(sp)
    80003328:	6942                	ld	s2,16(sp)
    8000332a:	69a2                	ld	s3,8(sp)
    8000332c:	6145                	addi	sp,sp,48
    8000332e:	8082                	ret
    80003330:	4581                	li	a1,0
    80003332:	8526                	mv	a0,s1
    80003334:	00003097          	auipc	ra,0x3
    80003338:	f28080e7          	jalr	-216(ra) # 8000625c <virtio_disk_rw>
    8000333c:	4785                	li	a5,1
    8000333e:	c09c                	sw	a5,0(s1)
    80003340:	b7c5                	j	80003320 <bread+0xd0>

0000000080003342 <bwrite>:
    80003342:	1101                	addi	sp,sp,-32
    80003344:	ec06                	sd	ra,24(sp)
    80003346:	e822                	sd	s0,16(sp)
    80003348:	e426                	sd	s1,8(sp)
    8000334a:	1000                	addi	s0,sp,32
    8000334c:	84aa                	mv	s1,a0
    8000334e:	0541                	addi	a0,a0,16
    80003350:	00001097          	auipc	ra,0x1
    80003354:	45c080e7          	jalr	1116(ra) # 800047ac <holdingsleep>
    80003358:	cd01                	beqz	a0,80003370 <bwrite+0x2e>
    8000335a:	4585                	li	a1,1
    8000335c:	8526                	mv	a0,s1
    8000335e:	00003097          	auipc	ra,0x3
    80003362:	efe080e7          	jalr	-258(ra) # 8000625c <virtio_disk_rw>
    80003366:	60e2                	ld	ra,24(sp)
    80003368:	6442                	ld	s0,16(sp)
    8000336a:	64a2                	ld	s1,8(sp)
    8000336c:	6105                	addi	sp,sp,32
    8000336e:	8082                	ret
    80003370:	00005517          	auipc	a0,0x5
    80003374:	26850513          	addi	a0,a0,616 # 800085d8 <syscalls+0xd8>
    80003378:	ffffd097          	auipc	ra,0xffffd
    8000337c:	1c8080e7          	jalr	456(ra) # 80000540 <panic>

0000000080003380 <brelse>:
    80003380:	1101                	addi	sp,sp,-32
    80003382:	ec06                	sd	ra,24(sp)
    80003384:	e822                	sd	s0,16(sp)
    80003386:	e426                	sd	s1,8(sp)
    80003388:	e04a                	sd	s2,0(sp)
    8000338a:	1000                	addi	s0,sp,32
    8000338c:	84aa                	mv	s1,a0
    8000338e:	01050913          	addi	s2,a0,16
    80003392:	854a                	mv	a0,s2
    80003394:	00001097          	auipc	ra,0x1
    80003398:	418080e7          	jalr	1048(ra) # 800047ac <holdingsleep>
    8000339c:	c92d                	beqz	a0,8000340e <brelse+0x8e>
    8000339e:	854a                	mv	a0,s2
    800033a0:	00001097          	auipc	ra,0x1
    800033a4:	3c8080e7          	jalr	968(ra) # 80004768 <releasesleep>
    800033a8:	00015517          	auipc	a0,0x15
    800033ac:	a2050513          	addi	a0,a0,-1504 # 80017dc8 <bcache>
    800033b0:	ffffe097          	auipc	ra,0xffffe
    800033b4:	84c080e7          	jalr	-1972(ra) # 80000bfc <acquire>
    800033b8:	40bc                	lw	a5,64(s1)
    800033ba:	37fd                	addiw	a5,a5,-1
    800033bc:	0007871b          	sext.w	a4,a5
    800033c0:	c0bc                	sw	a5,64(s1)
    800033c2:	eb05                	bnez	a4,800033f2 <brelse+0x72>
    800033c4:	68bc                	ld	a5,80(s1)
    800033c6:	64b8                	ld	a4,72(s1)
    800033c8:	e7b8                	sd	a4,72(a5)
    800033ca:	64bc                	ld	a5,72(s1)
    800033cc:	68b8                	ld	a4,80(s1)
    800033ce:	ebb8                	sd	a4,80(a5)
    800033d0:	0001d797          	auipc	a5,0x1d
    800033d4:	9f878793          	addi	a5,a5,-1544 # 8001fdc8 <bcache+0x8000>
    800033d8:	2b87b703          	ld	a4,696(a5)
    800033dc:	e8b8                	sd	a4,80(s1)
    800033de:	0001d717          	auipc	a4,0x1d
    800033e2:	c5270713          	addi	a4,a4,-942 # 80020030 <bcache+0x8268>
    800033e6:	e4b8                	sd	a4,72(s1)
    800033e8:	2b87b703          	ld	a4,696(a5)
    800033ec:	e724                	sd	s1,72(a4)
    800033ee:	2a97bc23          	sd	s1,696(a5)
    800033f2:	00015517          	auipc	a0,0x15
    800033f6:	9d650513          	addi	a0,a0,-1578 # 80017dc8 <bcache>
    800033fa:	ffffe097          	auipc	ra,0xffffe
    800033fe:	8b6080e7          	jalr	-1866(ra) # 80000cb0 <release>
    80003402:	60e2                	ld	ra,24(sp)
    80003404:	6442                	ld	s0,16(sp)
    80003406:	64a2                	ld	s1,8(sp)
    80003408:	6902                	ld	s2,0(sp)
    8000340a:	6105                	addi	sp,sp,32
    8000340c:	8082                	ret
    8000340e:	00005517          	auipc	a0,0x5
    80003412:	1d250513          	addi	a0,a0,466 # 800085e0 <syscalls+0xe0>
    80003416:	ffffd097          	auipc	ra,0xffffd
    8000341a:	12a080e7          	jalr	298(ra) # 80000540 <panic>

000000008000341e <bpin>:
    8000341e:	1101                	addi	sp,sp,-32
    80003420:	ec06                	sd	ra,24(sp)
    80003422:	e822                	sd	s0,16(sp)
    80003424:	e426                	sd	s1,8(sp)
    80003426:	1000                	addi	s0,sp,32
    80003428:	84aa                	mv	s1,a0
    8000342a:	00015517          	auipc	a0,0x15
    8000342e:	99e50513          	addi	a0,a0,-1634 # 80017dc8 <bcache>
    80003432:	ffffd097          	auipc	ra,0xffffd
    80003436:	7ca080e7          	jalr	1994(ra) # 80000bfc <acquire>
    8000343a:	40bc                	lw	a5,64(s1)
    8000343c:	2785                	addiw	a5,a5,1
    8000343e:	c0bc                	sw	a5,64(s1)
    80003440:	00015517          	auipc	a0,0x15
    80003444:	98850513          	addi	a0,a0,-1656 # 80017dc8 <bcache>
    80003448:	ffffe097          	auipc	ra,0xffffe
    8000344c:	868080e7          	jalr	-1944(ra) # 80000cb0 <release>
    80003450:	60e2                	ld	ra,24(sp)
    80003452:	6442                	ld	s0,16(sp)
    80003454:	64a2                	ld	s1,8(sp)
    80003456:	6105                	addi	sp,sp,32
    80003458:	8082                	ret

000000008000345a <bunpin>:
    8000345a:	1101                	addi	sp,sp,-32
    8000345c:	ec06                	sd	ra,24(sp)
    8000345e:	e822                	sd	s0,16(sp)
    80003460:	e426                	sd	s1,8(sp)
    80003462:	1000                	addi	s0,sp,32
    80003464:	84aa                	mv	s1,a0
    80003466:	00015517          	auipc	a0,0x15
    8000346a:	96250513          	addi	a0,a0,-1694 # 80017dc8 <bcache>
    8000346e:	ffffd097          	auipc	ra,0xffffd
    80003472:	78e080e7          	jalr	1934(ra) # 80000bfc <acquire>
    80003476:	40bc                	lw	a5,64(s1)
    80003478:	37fd                	addiw	a5,a5,-1
    8000347a:	c0bc                	sw	a5,64(s1)
    8000347c:	00015517          	auipc	a0,0x15
    80003480:	94c50513          	addi	a0,a0,-1716 # 80017dc8 <bcache>
    80003484:	ffffe097          	auipc	ra,0xffffe
    80003488:	82c080e7          	jalr	-2004(ra) # 80000cb0 <release>
    8000348c:	60e2                	ld	ra,24(sp)
    8000348e:	6442                	ld	s0,16(sp)
    80003490:	64a2                	ld	s1,8(sp)
    80003492:	6105                	addi	sp,sp,32
    80003494:	8082                	ret

0000000080003496 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003496:	1101                	addi	sp,sp,-32
    80003498:	ec06                	sd	ra,24(sp)
    8000349a:	e822                	sd	s0,16(sp)
    8000349c:	e426                	sd	s1,8(sp)
    8000349e:	e04a                	sd	s2,0(sp)
    800034a0:	1000                	addi	s0,sp,32
    800034a2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800034a4:	00d5d59b          	srliw	a1,a1,0xd
    800034a8:	0001d797          	auipc	a5,0x1d
    800034ac:	ffc7a783          	lw	a5,-4(a5) # 800204a4 <sb+0x1c>
    800034b0:	9dbd                	addw	a1,a1,a5
    800034b2:	00000097          	auipc	ra,0x0
    800034b6:	d9e080e7          	jalr	-610(ra) # 80003250 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800034ba:	0074f713          	andi	a4,s1,7
    800034be:	4785                	li	a5,1
    800034c0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800034c4:	14ce                	slli	s1,s1,0x33
    800034c6:	90d9                	srli	s1,s1,0x36
    800034c8:	00950733          	add	a4,a0,s1
    800034cc:	05874703          	lbu	a4,88(a4)
    800034d0:	00e7f6b3          	and	a3,a5,a4
    800034d4:	c69d                	beqz	a3,80003502 <bfree+0x6c>
    800034d6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800034d8:	94aa                	add	s1,s1,a0
    800034da:	fff7c793          	not	a5,a5
    800034de:	8ff9                	and	a5,a5,a4
    800034e0:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800034e4:	00001097          	auipc	ra,0x1
    800034e8:	106080e7          	jalr	262(ra) # 800045ea <log_write>
  brelse(bp);
    800034ec:	854a                	mv	a0,s2
    800034ee:	00000097          	auipc	ra,0x0
    800034f2:	e92080e7          	jalr	-366(ra) # 80003380 <brelse>
}
    800034f6:	60e2                	ld	ra,24(sp)
    800034f8:	6442                	ld	s0,16(sp)
    800034fa:	64a2                	ld	s1,8(sp)
    800034fc:	6902                	ld	s2,0(sp)
    800034fe:	6105                	addi	sp,sp,32
    80003500:	8082                	ret
    panic("freeing free block");
    80003502:	00005517          	auipc	a0,0x5
    80003506:	0e650513          	addi	a0,a0,230 # 800085e8 <syscalls+0xe8>
    8000350a:	ffffd097          	auipc	ra,0xffffd
    8000350e:	036080e7          	jalr	54(ra) # 80000540 <panic>

0000000080003512 <balloc>:
{
    80003512:	711d                	addi	sp,sp,-96
    80003514:	ec86                	sd	ra,88(sp)
    80003516:	e8a2                	sd	s0,80(sp)
    80003518:	e4a6                	sd	s1,72(sp)
    8000351a:	e0ca                	sd	s2,64(sp)
    8000351c:	fc4e                	sd	s3,56(sp)
    8000351e:	f852                	sd	s4,48(sp)
    80003520:	f456                	sd	s5,40(sp)
    80003522:	f05a                	sd	s6,32(sp)
    80003524:	ec5e                	sd	s7,24(sp)
    80003526:	e862                	sd	s8,16(sp)
    80003528:	e466                	sd	s9,8(sp)
    8000352a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000352c:	0001d797          	auipc	a5,0x1d
    80003530:	f607a783          	lw	a5,-160(a5) # 8002048c <sb+0x4>
    80003534:	cbd1                	beqz	a5,800035c8 <balloc+0xb6>
    80003536:	8baa                	mv	s7,a0
    80003538:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000353a:	0001db17          	auipc	s6,0x1d
    8000353e:	f4eb0b13          	addi	s6,s6,-178 # 80020488 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003542:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003544:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003546:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003548:	6c89                	lui	s9,0x2
    8000354a:	a831                	j	80003566 <balloc+0x54>
    brelse(bp);
    8000354c:	854a                	mv	a0,s2
    8000354e:	00000097          	auipc	ra,0x0
    80003552:	e32080e7          	jalr	-462(ra) # 80003380 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003556:	015c87bb          	addw	a5,s9,s5
    8000355a:	00078a9b          	sext.w	s5,a5
    8000355e:	004b2703          	lw	a4,4(s6)
    80003562:	06eaf363          	bgeu	s5,a4,800035c8 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003566:	41fad79b          	sraiw	a5,s5,0x1f
    8000356a:	0137d79b          	srliw	a5,a5,0x13
    8000356e:	015787bb          	addw	a5,a5,s5
    80003572:	40d7d79b          	sraiw	a5,a5,0xd
    80003576:	01cb2583          	lw	a1,28(s6)
    8000357a:	9dbd                	addw	a1,a1,a5
    8000357c:	855e                	mv	a0,s7
    8000357e:	00000097          	auipc	ra,0x0
    80003582:	cd2080e7          	jalr	-814(ra) # 80003250 <bread>
    80003586:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003588:	004b2503          	lw	a0,4(s6)
    8000358c:	000a849b          	sext.w	s1,s5
    80003590:	8662                	mv	a2,s8
    80003592:	faa4fde3          	bgeu	s1,a0,8000354c <balloc+0x3a>
      m = 1 << (bi % 8);
    80003596:	41f6579b          	sraiw	a5,a2,0x1f
    8000359a:	01d7d69b          	srliw	a3,a5,0x1d
    8000359e:	00c6873b          	addw	a4,a3,a2
    800035a2:	00777793          	andi	a5,a4,7
    800035a6:	9f95                	subw	a5,a5,a3
    800035a8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800035ac:	4037571b          	sraiw	a4,a4,0x3
    800035b0:	00e906b3          	add	a3,s2,a4
    800035b4:	0586c683          	lbu	a3,88(a3)
    800035b8:	00d7f5b3          	and	a1,a5,a3
    800035bc:	cd91                	beqz	a1,800035d8 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035be:	2605                	addiw	a2,a2,1
    800035c0:	2485                	addiw	s1,s1,1
    800035c2:	fd4618e3          	bne	a2,s4,80003592 <balloc+0x80>
    800035c6:	b759                	j	8000354c <balloc+0x3a>
  panic("balloc: out of blocks");
    800035c8:	00005517          	auipc	a0,0x5
    800035cc:	03850513          	addi	a0,a0,56 # 80008600 <syscalls+0x100>
    800035d0:	ffffd097          	auipc	ra,0xffffd
    800035d4:	f70080e7          	jalr	-144(ra) # 80000540 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800035d8:	974a                	add	a4,a4,s2
    800035da:	8fd5                	or	a5,a5,a3
    800035dc:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800035e0:	854a                	mv	a0,s2
    800035e2:	00001097          	auipc	ra,0x1
    800035e6:	008080e7          	jalr	8(ra) # 800045ea <log_write>
        brelse(bp);
    800035ea:	854a                	mv	a0,s2
    800035ec:	00000097          	auipc	ra,0x0
    800035f0:	d94080e7          	jalr	-620(ra) # 80003380 <brelse>
  bp = bread(dev, bno);
    800035f4:	85a6                	mv	a1,s1
    800035f6:	855e                	mv	a0,s7
    800035f8:	00000097          	auipc	ra,0x0
    800035fc:	c58080e7          	jalr	-936(ra) # 80003250 <bread>
    80003600:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003602:	40000613          	li	a2,1024
    80003606:	4581                	li	a1,0
    80003608:	05850513          	addi	a0,a0,88
    8000360c:	ffffd097          	auipc	ra,0xffffd
    80003610:	6ec080e7          	jalr	1772(ra) # 80000cf8 <memset>
  log_write(bp);
    80003614:	854a                	mv	a0,s2
    80003616:	00001097          	auipc	ra,0x1
    8000361a:	fd4080e7          	jalr	-44(ra) # 800045ea <log_write>
  brelse(bp);
    8000361e:	854a                	mv	a0,s2
    80003620:	00000097          	auipc	ra,0x0
    80003624:	d60080e7          	jalr	-672(ra) # 80003380 <brelse>
}
    80003628:	8526                	mv	a0,s1
    8000362a:	60e6                	ld	ra,88(sp)
    8000362c:	6446                	ld	s0,80(sp)
    8000362e:	64a6                	ld	s1,72(sp)
    80003630:	6906                	ld	s2,64(sp)
    80003632:	79e2                	ld	s3,56(sp)
    80003634:	7a42                	ld	s4,48(sp)
    80003636:	7aa2                	ld	s5,40(sp)
    80003638:	7b02                	ld	s6,32(sp)
    8000363a:	6be2                	ld	s7,24(sp)
    8000363c:	6c42                	ld	s8,16(sp)
    8000363e:	6ca2                	ld	s9,8(sp)
    80003640:	6125                	addi	sp,sp,96
    80003642:	8082                	ret

0000000080003644 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003644:	7179                	addi	sp,sp,-48
    80003646:	f406                	sd	ra,40(sp)
    80003648:	f022                	sd	s0,32(sp)
    8000364a:	ec26                	sd	s1,24(sp)
    8000364c:	e84a                	sd	s2,16(sp)
    8000364e:	e44e                	sd	s3,8(sp)
    80003650:	e052                	sd	s4,0(sp)
    80003652:	1800                	addi	s0,sp,48
    80003654:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003656:	47ad                	li	a5,11
    80003658:	04b7fe63          	bgeu	a5,a1,800036b4 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000365c:	ff45849b          	addiw	s1,a1,-12
    80003660:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003664:	0ff00793          	li	a5,255
    80003668:	0ae7e463          	bltu	a5,a4,80003710 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000366c:	08052583          	lw	a1,128(a0)
    80003670:	c5b5                	beqz	a1,800036dc <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003672:	00092503          	lw	a0,0(s2)
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	bda080e7          	jalr	-1062(ra) # 80003250 <bread>
    8000367e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003680:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003684:	02049713          	slli	a4,s1,0x20
    80003688:	01e75593          	srli	a1,a4,0x1e
    8000368c:	00b784b3          	add	s1,a5,a1
    80003690:	0004a983          	lw	s3,0(s1)
    80003694:	04098e63          	beqz	s3,800036f0 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003698:	8552                	mv	a0,s4
    8000369a:	00000097          	auipc	ra,0x0
    8000369e:	ce6080e7          	jalr	-794(ra) # 80003380 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800036a2:	854e                	mv	a0,s3
    800036a4:	70a2                	ld	ra,40(sp)
    800036a6:	7402                	ld	s0,32(sp)
    800036a8:	64e2                	ld	s1,24(sp)
    800036aa:	6942                	ld	s2,16(sp)
    800036ac:	69a2                	ld	s3,8(sp)
    800036ae:	6a02                	ld	s4,0(sp)
    800036b0:	6145                	addi	sp,sp,48
    800036b2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800036b4:	02059793          	slli	a5,a1,0x20
    800036b8:	01e7d593          	srli	a1,a5,0x1e
    800036bc:	00b504b3          	add	s1,a0,a1
    800036c0:	0504a983          	lw	s3,80(s1)
    800036c4:	fc099fe3          	bnez	s3,800036a2 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800036c8:	4108                	lw	a0,0(a0)
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	e48080e7          	jalr	-440(ra) # 80003512 <balloc>
    800036d2:	0005099b          	sext.w	s3,a0
    800036d6:	0534a823          	sw	s3,80(s1)
    800036da:	b7e1                	j	800036a2 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800036dc:	4108                	lw	a0,0(a0)
    800036de:	00000097          	auipc	ra,0x0
    800036e2:	e34080e7          	jalr	-460(ra) # 80003512 <balloc>
    800036e6:	0005059b          	sext.w	a1,a0
    800036ea:	08b92023          	sw	a1,128(s2)
    800036ee:	b751                	j	80003672 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800036f0:	00092503          	lw	a0,0(s2)
    800036f4:	00000097          	auipc	ra,0x0
    800036f8:	e1e080e7          	jalr	-482(ra) # 80003512 <balloc>
    800036fc:	0005099b          	sext.w	s3,a0
    80003700:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003704:	8552                	mv	a0,s4
    80003706:	00001097          	auipc	ra,0x1
    8000370a:	ee4080e7          	jalr	-284(ra) # 800045ea <log_write>
    8000370e:	b769                	j	80003698 <bmap+0x54>
  panic("bmap: out of range");
    80003710:	00005517          	auipc	a0,0x5
    80003714:	f0850513          	addi	a0,a0,-248 # 80008618 <syscalls+0x118>
    80003718:	ffffd097          	auipc	ra,0xffffd
    8000371c:	e28080e7          	jalr	-472(ra) # 80000540 <panic>

0000000080003720 <iget>:
{
    80003720:	7179                	addi	sp,sp,-48
    80003722:	f406                	sd	ra,40(sp)
    80003724:	f022                	sd	s0,32(sp)
    80003726:	ec26                	sd	s1,24(sp)
    80003728:	e84a                	sd	s2,16(sp)
    8000372a:	e44e                	sd	s3,8(sp)
    8000372c:	e052                	sd	s4,0(sp)
    8000372e:	1800                	addi	s0,sp,48
    80003730:	89aa                	mv	s3,a0
    80003732:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003734:	0001d517          	auipc	a0,0x1d
    80003738:	d7450513          	addi	a0,a0,-652 # 800204a8 <icache>
    8000373c:	ffffd097          	auipc	ra,0xffffd
    80003740:	4c0080e7          	jalr	1216(ra) # 80000bfc <acquire>
  empty = 0;
    80003744:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003746:	0001d497          	auipc	s1,0x1d
    8000374a:	d7a48493          	addi	s1,s1,-646 # 800204c0 <icache+0x18>
    8000374e:	0001f697          	auipc	a3,0x1f
    80003752:	80268693          	addi	a3,a3,-2046 # 80021f50 <log>
    80003756:	a039                	j	80003764 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003758:	02090b63          	beqz	s2,8000378e <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000375c:	08848493          	addi	s1,s1,136
    80003760:	02d48a63          	beq	s1,a3,80003794 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003764:	449c                	lw	a5,8(s1)
    80003766:	fef059e3          	blez	a5,80003758 <iget+0x38>
    8000376a:	4098                	lw	a4,0(s1)
    8000376c:	ff3716e3          	bne	a4,s3,80003758 <iget+0x38>
    80003770:	40d8                	lw	a4,4(s1)
    80003772:	ff4713e3          	bne	a4,s4,80003758 <iget+0x38>
      ip->ref++;
    80003776:	2785                	addiw	a5,a5,1
    80003778:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000377a:	0001d517          	auipc	a0,0x1d
    8000377e:	d2e50513          	addi	a0,a0,-722 # 800204a8 <icache>
    80003782:	ffffd097          	auipc	ra,0xffffd
    80003786:	52e080e7          	jalr	1326(ra) # 80000cb0 <release>
      return ip;
    8000378a:	8926                	mv	s2,s1
    8000378c:	a03d                	j	800037ba <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000378e:	f7f9                	bnez	a5,8000375c <iget+0x3c>
    80003790:	8926                	mv	s2,s1
    80003792:	b7e9                	j	8000375c <iget+0x3c>
  if(empty == 0)
    80003794:	02090c63          	beqz	s2,800037cc <iget+0xac>
  ip->dev = dev;
    80003798:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000379c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800037a0:	4785                	li	a5,1
    800037a2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800037a6:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800037aa:	0001d517          	auipc	a0,0x1d
    800037ae:	cfe50513          	addi	a0,a0,-770 # 800204a8 <icache>
    800037b2:	ffffd097          	auipc	ra,0xffffd
    800037b6:	4fe080e7          	jalr	1278(ra) # 80000cb0 <release>
}
    800037ba:	854a                	mv	a0,s2
    800037bc:	70a2                	ld	ra,40(sp)
    800037be:	7402                	ld	s0,32(sp)
    800037c0:	64e2                	ld	s1,24(sp)
    800037c2:	6942                	ld	s2,16(sp)
    800037c4:	69a2                	ld	s3,8(sp)
    800037c6:	6a02                	ld	s4,0(sp)
    800037c8:	6145                	addi	sp,sp,48
    800037ca:	8082                	ret
    panic("iget: no inodes");
    800037cc:	00005517          	auipc	a0,0x5
    800037d0:	e6450513          	addi	a0,a0,-412 # 80008630 <syscalls+0x130>
    800037d4:	ffffd097          	auipc	ra,0xffffd
    800037d8:	d6c080e7          	jalr	-660(ra) # 80000540 <panic>

00000000800037dc <fsinit>:
fsinit(int dev) {
    800037dc:	7179                	addi	sp,sp,-48
    800037de:	f406                	sd	ra,40(sp)
    800037e0:	f022                	sd	s0,32(sp)
    800037e2:	ec26                	sd	s1,24(sp)
    800037e4:	e84a                	sd	s2,16(sp)
    800037e6:	e44e                	sd	s3,8(sp)
    800037e8:	1800                	addi	s0,sp,48
    800037ea:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800037ec:	4585                	li	a1,1
    800037ee:	00000097          	auipc	ra,0x0
    800037f2:	a62080e7          	jalr	-1438(ra) # 80003250 <bread>
    800037f6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800037f8:	0001d997          	auipc	s3,0x1d
    800037fc:	c9098993          	addi	s3,s3,-880 # 80020488 <sb>
    80003800:	02000613          	li	a2,32
    80003804:	05850593          	addi	a1,a0,88
    80003808:	854e                	mv	a0,s3
    8000380a:	ffffd097          	auipc	ra,0xffffd
    8000380e:	54a080e7          	jalr	1354(ra) # 80000d54 <memmove>
  brelse(bp);
    80003812:	8526                	mv	a0,s1
    80003814:	00000097          	auipc	ra,0x0
    80003818:	b6c080e7          	jalr	-1172(ra) # 80003380 <brelse>
  if(sb.magic != FSMAGIC)
    8000381c:	0009a703          	lw	a4,0(s3)
    80003820:	102037b7          	lui	a5,0x10203
    80003824:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003828:	02f71263          	bne	a4,a5,8000384c <fsinit+0x70>
  initlog(dev, &sb);
    8000382c:	0001d597          	auipc	a1,0x1d
    80003830:	c5c58593          	addi	a1,a1,-932 # 80020488 <sb>
    80003834:	854a                	mv	a0,s2
    80003836:	00001097          	auipc	ra,0x1
    8000383a:	b3a080e7          	jalr	-1222(ra) # 80004370 <initlog>
}
    8000383e:	70a2                	ld	ra,40(sp)
    80003840:	7402                	ld	s0,32(sp)
    80003842:	64e2                	ld	s1,24(sp)
    80003844:	6942                	ld	s2,16(sp)
    80003846:	69a2                	ld	s3,8(sp)
    80003848:	6145                	addi	sp,sp,48
    8000384a:	8082                	ret
    panic("invalid file system");
    8000384c:	00005517          	auipc	a0,0x5
    80003850:	df450513          	addi	a0,a0,-524 # 80008640 <syscalls+0x140>
    80003854:	ffffd097          	auipc	ra,0xffffd
    80003858:	cec080e7          	jalr	-788(ra) # 80000540 <panic>

000000008000385c <iinit>:
{
    8000385c:	7179                	addi	sp,sp,-48
    8000385e:	f406                	sd	ra,40(sp)
    80003860:	f022                	sd	s0,32(sp)
    80003862:	ec26                	sd	s1,24(sp)
    80003864:	e84a                	sd	s2,16(sp)
    80003866:	e44e                	sd	s3,8(sp)
    80003868:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    8000386a:	00005597          	auipc	a1,0x5
    8000386e:	dee58593          	addi	a1,a1,-530 # 80008658 <syscalls+0x158>
    80003872:	0001d517          	auipc	a0,0x1d
    80003876:	c3650513          	addi	a0,a0,-970 # 800204a8 <icache>
    8000387a:	ffffd097          	auipc	ra,0xffffd
    8000387e:	2f2080e7          	jalr	754(ra) # 80000b6c <initlock>
  for(i = 0; i < NINODE; i++) {
    80003882:	0001d497          	auipc	s1,0x1d
    80003886:	c4e48493          	addi	s1,s1,-946 # 800204d0 <icache+0x28>
    8000388a:	0001e997          	auipc	s3,0x1e
    8000388e:	6d698993          	addi	s3,s3,1750 # 80021f60 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003892:	00005917          	auipc	s2,0x5
    80003896:	dce90913          	addi	s2,s2,-562 # 80008660 <syscalls+0x160>
    8000389a:	85ca                	mv	a1,s2
    8000389c:	8526                	mv	a0,s1
    8000389e:	00001097          	auipc	ra,0x1
    800038a2:	e3a080e7          	jalr	-454(ra) # 800046d8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800038a6:	08848493          	addi	s1,s1,136
    800038aa:	ff3498e3          	bne	s1,s3,8000389a <iinit+0x3e>
}
    800038ae:	70a2                	ld	ra,40(sp)
    800038b0:	7402                	ld	s0,32(sp)
    800038b2:	64e2                	ld	s1,24(sp)
    800038b4:	6942                	ld	s2,16(sp)
    800038b6:	69a2                	ld	s3,8(sp)
    800038b8:	6145                	addi	sp,sp,48
    800038ba:	8082                	ret

00000000800038bc <ialloc>:
{
    800038bc:	715d                	addi	sp,sp,-80
    800038be:	e486                	sd	ra,72(sp)
    800038c0:	e0a2                	sd	s0,64(sp)
    800038c2:	fc26                	sd	s1,56(sp)
    800038c4:	f84a                	sd	s2,48(sp)
    800038c6:	f44e                	sd	s3,40(sp)
    800038c8:	f052                	sd	s4,32(sp)
    800038ca:	ec56                	sd	s5,24(sp)
    800038cc:	e85a                	sd	s6,16(sp)
    800038ce:	e45e                	sd	s7,8(sp)
    800038d0:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800038d2:	0001d717          	auipc	a4,0x1d
    800038d6:	bc272703          	lw	a4,-1086(a4) # 80020494 <sb+0xc>
    800038da:	4785                	li	a5,1
    800038dc:	04e7fa63          	bgeu	a5,a4,80003930 <ialloc+0x74>
    800038e0:	8aaa                	mv	s5,a0
    800038e2:	8bae                	mv	s7,a1
    800038e4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800038e6:	0001da17          	auipc	s4,0x1d
    800038ea:	ba2a0a13          	addi	s4,s4,-1118 # 80020488 <sb>
    800038ee:	00048b1b          	sext.w	s6,s1
    800038f2:	0044d793          	srli	a5,s1,0x4
    800038f6:	018a2583          	lw	a1,24(s4)
    800038fa:	9dbd                	addw	a1,a1,a5
    800038fc:	8556                	mv	a0,s5
    800038fe:	00000097          	auipc	ra,0x0
    80003902:	952080e7          	jalr	-1710(ra) # 80003250 <bread>
    80003906:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003908:	05850993          	addi	s3,a0,88
    8000390c:	00f4f793          	andi	a5,s1,15
    80003910:	079a                	slli	a5,a5,0x6
    80003912:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003914:	00099783          	lh	a5,0(s3)
    80003918:	c785                	beqz	a5,80003940 <ialloc+0x84>
    brelse(bp);
    8000391a:	00000097          	auipc	ra,0x0
    8000391e:	a66080e7          	jalr	-1434(ra) # 80003380 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003922:	0485                	addi	s1,s1,1
    80003924:	00ca2703          	lw	a4,12(s4)
    80003928:	0004879b          	sext.w	a5,s1
    8000392c:	fce7e1e3          	bltu	a5,a4,800038ee <ialloc+0x32>
  panic("ialloc: no inodes");
    80003930:	00005517          	auipc	a0,0x5
    80003934:	d3850513          	addi	a0,a0,-712 # 80008668 <syscalls+0x168>
    80003938:	ffffd097          	auipc	ra,0xffffd
    8000393c:	c08080e7          	jalr	-1016(ra) # 80000540 <panic>
      memset(dip, 0, sizeof(*dip));
    80003940:	04000613          	li	a2,64
    80003944:	4581                	li	a1,0
    80003946:	854e                	mv	a0,s3
    80003948:	ffffd097          	auipc	ra,0xffffd
    8000394c:	3b0080e7          	jalr	944(ra) # 80000cf8 <memset>
      dip->type = type;
    80003950:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003954:	854a                	mv	a0,s2
    80003956:	00001097          	auipc	ra,0x1
    8000395a:	c94080e7          	jalr	-876(ra) # 800045ea <log_write>
      brelse(bp);
    8000395e:	854a                	mv	a0,s2
    80003960:	00000097          	auipc	ra,0x0
    80003964:	a20080e7          	jalr	-1504(ra) # 80003380 <brelse>
      return iget(dev, inum);
    80003968:	85da                	mv	a1,s6
    8000396a:	8556                	mv	a0,s5
    8000396c:	00000097          	auipc	ra,0x0
    80003970:	db4080e7          	jalr	-588(ra) # 80003720 <iget>
}
    80003974:	60a6                	ld	ra,72(sp)
    80003976:	6406                	ld	s0,64(sp)
    80003978:	74e2                	ld	s1,56(sp)
    8000397a:	7942                	ld	s2,48(sp)
    8000397c:	79a2                	ld	s3,40(sp)
    8000397e:	7a02                	ld	s4,32(sp)
    80003980:	6ae2                	ld	s5,24(sp)
    80003982:	6b42                	ld	s6,16(sp)
    80003984:	6ba2                	ld	s7,8(sp)
    80003986:	6161                	addi	sp,sp,80
    80003988:	8082                	ret

000000008000398a <iupdate>:
{
    8000398a:	1101                	addi	sp,sp,-32
    8000398c:	ec06                	sd	ra,24(sp)
    8000398e:	e822                	sd	s0,16(sp)
    80003990:	e426                	sd	s1,8(sp)
    80003992:	e04a                	sd	s2,0(sp)
    80003994:	1000                	addi	s0,sp,32
    80003996:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003998:	415c                	lw	a5,4(a0)
    8000399a:	0047d79b          	srliw	a5,a5,0x4
    8000399e:	0001d597          	auipc	a1,0x1d
    800039a2:	b025a583          	lw	a1,-1278(a1) # 800204a0 <sb+0x18>
    800039a6:	9dbd                	addw	a1,a1,a5
    800039a8:	4108                	lw	a0,0(a0)
    800039aa:	00000097          	auipc	ra,0x0
    800039ae:	8a6080e7          	jalr	-1882(ra) # 80003250 <bread>
    800039b2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800039b4:	05850793          	addi	a5,a0,88
    800039b8:	40c8                	lw	a0,4(s1)
    800039ba:	893d                	andi	a0,a0,15
    800039bc:	051a                	slli	a0,a0,0x6
    800039be:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800039c0:	04449703          	lh	a4,68(s1)
    800039c4:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800039c8:	04649703          	lh	a4,70(s1)
    800039cc:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800039d0:	04849703          	lh	a4,72(s1)
    800039d4:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800039d8:	04a49703          	lh	a4,74(s1)
    800039dc:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800039e0:	44f8                	lw	a4,76(s1)
    800039e2:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800039e4:	03400613          	li	a2,52
    800039e8:	05048593          	addi	a1,s1,80
    800039ec:	0531                	addi	a0,a0,12
    800039ee:	ffffd097          	auipc	ra,0xffffd
    800039f2:	366080e7          	jalr	870(ra) # 80000d54 <memmove>
  log_write(bp);
    800039f6:	854a                	mv	a0,s2
    800039f8:	00001097          	auipc	ra,0x1
    800039fc:	bf2080e7          	jalr	-1038(ra) # 800045ea <log_write>
  brelse(bp);
    80003a00:	854a                	mv	a0,s2
    80003a02:	00000097          	auipc	ra,0x0
    80003a06:	97e080e7          	jalr	-1666(ra) # 80003380 <brelse>
}
    80003a0a:	60e2                	ld	ra,24(sp)
    80003a0c:	6442                	ld	s0,16(sp)
    80003a0e:	64a2                	ld	s1,8(sp)
    80003a10:	6902                	ld	s2,0(sp)
    80003a12:	6105                	addi	sp,sp,32
    80003a14:	8082                	ret

0000000080003a16 <idup>:
{
    80003a16:	1101                	addi	sp,sp,-32
    80003a18:	ec06                	sd	ra,24(sp)
    80003a1a:	e822                	sd	s0,16(sp)
    80003a1c:	e426                	sd	s1,8(sp)
    80003a1e:	1000                	addi	s0,sp,32
    80003a20:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003a22:	0001d517          	auipc	a0,0x1d
    80003a26:	a8650513          	addi	a0,a0,-1402 # 800204a8 <icache>
    80003a2a:	ffffd097          	auipc	ra,0xffffd
    80003a2e:	1d2080e7          	jalr	466(ra) # 80000bfc <acquire>
  ip->ref++;
    80003a32:	449c                	lw	a5,8(s1)
    80003a34:	2785                	addiw	a5,a5,1
    80003a36:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003a38:	0001d517          	auipc	a0,0x1d
    80003a3c:	a7050513          	addi	a0,a0,-1424 # 800204a8 <icache>
    80003a40:	ffffd097          	auipc	ra,0xffffd
    80003a44:	270080e7          	jalr	624(ra) # 80000cb0 <release>
}
    80003a48:	8526                	mv	a0,s1
    80003a4a:	60e2                	ld	ra,24(sp)
    80003a4c:	6442                	ld	s0,16(sp)
    80003a4e:	64a2                	ld	s1,8(sp)
    80003a50:	6105                	addi	sp,sp,32
    80003a52:	8082                	ret

0000000080003a54 <ilock>:
{
    80003a54:	1101                	addi	sp,sp,-32
    80003a56:	ec06                	sd	ra,24(sp)
    80003a58:	e822                	sd	s0,16(sp)
    80003a5a:	e426                	sd	s1,8(sp)
    80003a5c:	e04a                	sd	s2,0(sp)
    80003a5e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003a60:	c115                	beqz	a0,80003a84 <ilock+0x30>
    80003a62:	84aa                	mv	s1,a0
    80003a64:	451c                	lw	a5,8(a0)
    80003a66:	00f05f63          	blez	a5,80003a84 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003a6a:	0541                	addi	a0,a0,16
    80003a6c:	00001097          	auipc	ra,0x1
    80003a70:	ca6080e7          	jalr	-858(ra) # 80004712 <acquiresleep>
  if(ip->valid == 0){
    80003a74:	40bc                	lw	a5,64(s1)
    80003a76:	cf99                	beqz	a5,80003a94 <ilock+0x40>
}
    80003a78:	60e2                	ld	ra,24(sp)
    80003a7a:	6442                	ld	s0,16(sp)
    80003a7c:	64a2                	ld	s1,8(sp)
    80003a7e:	6902                	ld	s2,0(sp)
    80003a80:	6105                	addi	sp,sp,32
    80003a82:	8082                	ret
    panic("ilock");
    80003a84:	00005517          	auipc	a0,0x5
    80003a88:	bfc50513          	addi	a0,a0,-1028 # 80008680 <syscalls+0x180>
    80003a8c:	ffffd097          	auipc	ra,0xffffd
    80003a90:	ab4080e7          	jalr	-1356(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a94:	40dc                	lw	a5,4(s1)
    80003a96:	0047d79b          	srliw	a5,a5,0x4
    80003a9a:	0001d597          	auipc	a1,0x1d
    80003a9e:	a065a583          	lw	a1,-1530(a1) # 800204a0 <sb+0x18>
    80003aa2:	9dbd                	addw	a1,a1,a5
    80003aa4:	4088                	lw	a0,0(s1)
    80003aa6:	fffff097          	auipc	ra,0xfffff
    80003aaa:	7aa080e7          	jalr	1962(ra) # 80003250 <bread>
    80003aae:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ab0:	05850593          	addi	a1,a0,88
    80003ab4:	40dc                	lw	a5,4(s1)
    80003ab6:	8bbd                	andi	a5,a5,15
    80003ab8:	079a                	slli	a5,a5,0x6
    80003aba:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003abc:	00059783          	lh	a5,0(a1)
    80003ac0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003ac4:	00259783          	lh	a5,2(a1)
    80003ac8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003acc:	00459783          	lh	a5,4(a1)
    80003ad0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ad4:	00659783          	lh	a5,6(a1)
    80003ad8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003adc:	459c                	lw	a5,8(a1)
    80003ade:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003ae0:	03400613          	li	a2,52
    80003ae4:	05b1                	addi	a1,a1,12
    80003ae6:	05048513          	addi	a0,s1,80
    80003aea:	ffffd097          	auipc	ra,0xffffd
    80003aee:	26a080e7          	jalr	618(ra) # 80000d54 <memmove>
    brelse(bp);
    80003af2:	854a                	mv	a0,s2
    80003af4:	00000097          	auipc	ra,0x0
    80003af8:	88c080e7          	jalr	-1908(ra) # 80003380 <brelse>
    ip->valid = 1;
    80003afc:	4785                	li	a5,1
    80003afe:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003b00:	04449783          	lh	a5,68(s1)
    80003b04:	fbb5                	bnez	a5,80003a78 <ilock+0x24>
      panic("ilock: no type");
    80003b06:	00005517          	auipc	a0,0x5
    80003b0a:	b8250513          	addi	a0,a0,-1150 # 80008688 <syscalls+0x188>
    80003b0e:	ffffd097          	auipc	ra,0xffffd
    80003b12:	a32080e7          	jalr	-1486(ra) # 80000540 <panic>

0000000080003b16 <iunlock>:
{
    80003b16:	1101                	addi	sp,sp,-32
    80003b18:	ec06                	sd	ra,24(sp)
    80003b1a:	e822                	sd	s0,16(sp)
    80003b1c:	e426                	sd	s1,8(sp)
    80003b1e:	e04a                	sd	s2,0(sp)
    80003b20:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003b22:	c905                	beqz	a0,80003b52 <iunlock+0x3c>
    80003b24:	84aa                	mv	s1,a0
    80003b26:	01050913          	addi	s2,a0,16
    80003b2a:	854a                	mv	a0,s2
    80003b2c:	00001097          	auipc	ra,0x1
    80003b30:	c80080e7          	jalr	-896(ra) # 800047ac <holdingsleep>
    80003b34:	cd19                	beqz	a0,80003b52 <iunlock+0x3c>
    80003b36:	449c                	lw	a5,8(s1)
    80003b38:	00f05d63          	blez	a5,80003b52 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003b3c:	854a                	mv	a0,s2
    80003b3e:	00001097          	auipc	ra,0x1
    80003b42:	c2a080e7          	jalr	-982(ra) # 80004768 <releasesleep>
}
    80003b46:	60e2                	ld	ra,24(sp)
    80003b48:	6442                	ld	s0,16(sp)
    80003b4a:	64a2                	ld	s1,8(sp)
    80003b4c:	6902                	ld	s2,0(sp)
    80003b4e:	6105                	addi	sp,sp,32
    80003b50:	8082                	ret
    panic("iunlock");
    80003b52:	00005517          	auipc	a0,0x5
    80003b56:	b4650513          	addi	a0,a0,-1210 # 80008698 <syscalls+0x198>
    80003b5a:	ffffd097          	auipc	ra,0xffffd
    80003b5e:	9e6080e7          	jalr	-1562(ra) # 80000540 <panic>

0000000080003b62 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003b62:	7179                	addi	sp,sp,-48
    80003b64:	f406                	sd	ra,40(sp)
    80003b66:	f022                	sd	s0,32(sp)
    80003b68:	ec26                	sd	s1,24(sp)
    80003b6a:	e84a                	sd	s2,16(sp)
    80003b6c:	e44e                	sd	s3,8(sp)
    80003b6e:	e052                	sd	s4,0(sp)
    80003b70:	1800                	addi	s0,sp,48
    80003b72:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003b74:	05050493          	addi	s1,a0,80
    80003b78:	08050913          	addi	s2,a0,128
    80003b7c:	a021                	j	80003b84 <itrunc+0x22>
    80003b7e:	0491                	addi	s1,s1,4
    80003b80:	01248d63          	beq	s1,s2,80003b9a <itrunc+0x38>
    if(ip->addrs[i]){
    80003b84:	408c                	lw	a1,0(s1)
    80003b86:	dde5                	beqz	a1,80003b7e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003b88:	0009a503          	lw	a0,0(s3)
    80003b8c:	00000097          	auipc	ra,0x0
    80003b90:	90a080e7          	jalr	-1782(ra) # 80003496 <bfree>
      ip->addrs[i] = 0;
    80003b94:	0004a023          	sw	zero,0(s1)
    80003b98:	b7dd                	j	80003b7e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003b9a:	0809a583          	lw	a1,128(s3)
    80003b9e:	e185                	bnez	a1,80003bbe <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003ba0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003ba4:	854e                	mv	a0,s3
    80003ba6:	00000097          	auipc	ra,0x0
    80003baa:	de4080e7          	jalr	-540(ra) # 8000398a <iupdate>
}
    80003bae:	70a2                	ld	ra,40(sp)
    80003bb0:	7402                	ld	s0,32(sp)
    80003bb2:	64e2                	ld	s1,24(sp)
    80003bb4:	6942                	ld	s2,16(sp)
    80003bb6:	69a2                	ld	s3,8(sp)
    80003bb8:	6a02                	ld	s4,0(sp)
    80003bba:	6145                	addi	sp,sp,48
    80003bbc:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003bbe:	0009a503          	lw	a0,0(s3)
    80003bc2:	fffff097          	auipc	ra,0xfffff
    80003bc6:	68e080e7          	jalr	1678(ra) # 80003250 <bread>
    80003bca:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003bcc:	05850493          	addi	s1,a0,88
    80003bd0:	45850913          	addi	s2,a0,1112
    80003bd4:	a021                	j	80003bdc <itrunc+0x7a>
    80003bd6:	0491                	addi	s1,s1,4
    80003bd8:	01248b63          	beq	s1,s2,80003bee <itrunc+0x8c>
      if(a[j])
    80003bdc:	408c                	lw	a1,0(s1)
    80003bde:	dde5                	beqz	a1,80003bd6 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003be0:	0009a503          	lw	a0,0(s3)
    80003be4:	00000097          	auipc	ra,0x0
    80003be8:	8b2080e7          	jalr	-1870(ra) # 80003496 <bfree>
    80003bec:	b7ed                	j	80003bd6 <itrunc+0x74>
    brelse(bp);
    80003bee:	8552                	mv	a0,s4
    80003bf0:	fffff097          	auipc	ra,0xfffff
    80003bf4:	790080e7          	jalr	1936(ra) # 80003380 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003bf8:	0809a583          	lw	a1,128(s3)
    80003bfc:	0009a503          	lw	a0,0(s3)
    80003c00:	00000097          	auipc	ra,0x0
    80003c04:	896080e7          	jalr	-1898(ra) # 80003496 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003c08:	0809a023          	sw	zero,128(s3)
    80003c0c:	bf51                	j	80003ba0 <itrunc+0x3e>

0000000080003c0e <iput>:
{
    80003c0e:	1101                	addi	sp,sp,-32
    80003c10:	ec06                	sd	ra,24(sp)
    80003c12:	e822                	sd	s0,16(sp)
    80003c14:	e426                	sd	s1,8(sp)
    80003c16:	e04a                	sd	s2,0(sp)
    80003c18:	1000                	addi	s0,sp,32
    80003c1a:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003c1c:	0001d517          	auipc	a0,0x1d
    80003c20:	88c50513          	addi	a0,a0,-1908 # 800204a8 <icache>
    80003c24:	ffffd097          	auipc	ra,0xffffd
    80003c28:	fd8080e7          	jalr	-40(ra) # 80000bfc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c2c:	4498                	lw	a4,8(s1)
    80003c2e:	4785                	li	a5,1
    80003c30:	02f70363          	beq	a4,a5,80003c56 <iput+0x48>
  ip->ref--;
    80003c34:	449c                	lw	a5,8(s1)
    80003c36:	37fd                	addiw	a5,a5,-1
    80003c38:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003c3a:	0001d517          	auipc	a0,0x1d
    80003c3e:	86e50513          	addi	a0,a0,-1938 # 800204a8 <icache>
    80003c42:	ffffd097          	auipc	ra,0xffffd
    80003c46:	06e080e7          	jalr	110(ra) # 80000cb0 <release>
}
    80003c4a:	60e2                	ld	ra,24(sp)
    80003c4c:	6442                	ld	s0,16(sp)
    80003c4e:	64a2                	ld	s1,8(sp)
    80003c50:	6902                	ld	s2,0(sp)
    80003c52:	6105                	addi	sp,sp,32
    80003c54:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c56:	40bc                	lw	a5,64(s1)
    80003c58:	dff1                	beqz	a5,80003c34 <iput+0x26>
    80003c5a:	04a49783          	lh	a5,74(s1)
    80003c5e:	fbf9                	bnez	a5,80003c34 <iput+0x26>
    acquiresleep(&ip->lock);
    80003c60:	01048913          	addi	s2,s1,16
    80003c64:	854a                	mv	a0,s2
    80003c66:	00001097          	auipc	ra,0x1
    80003c6a:	aac080e7          	jalr	-1364(ra) # 80004712 <acquiresleep>
    release(&icache.lock);
    80003c6e:	0001d517          	auipc	a0,0x1d
    80003c72:	83a50513          	addi	a0,a0,-1990 # 800204a8 <icache>
    80003c76:	ffffd097          	auipc	ra,0xffffd
    80003c7a:	03a080e7          	jalr	58(ra) # 80000cb0 <release>
    itrunc(ip);
    80003c7e:	8526                	mv	a0,s1
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	ee2080e7          	jalr	-286(ra) # 80003b62 <itrunc>
    ip->type = 0;
    80003c88:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003c8c:	8526                	mv	a0,s1
    80003c8e:	00000097          	auipc	ra,0x0
    80003c92:	cfc080e7          	jalr	-772(ra) # 8000398a <iupdate>
    ip->valid = 0;
    80003c96:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003c9a:	854a                	mv	a0,s2
    80003c9c:	00001097          	auipc	ra,0x1
    80003ca0:	acc080e7          	jalr	-1332(ra) # 80004768 <releasesleep>
    acquire(&icache.lock);
    80003ca4:	0001d517          	auipc	a0,0x1d
    80003ca8:	80450513          	addi	a0,a0,-2044 # 800204a8 <icache>
    80003cac:	ffffd097          	auipc	ra,0xffffd
    80003cb0:	f50080e7          	jalr	-176(ra) # 80000bfc <acquire>
    80003cb4:	b741                	j	80003c34 <iput+0x26>

0000000080003cb6 <iunlockput>:
{
    80003cb6:	1101                	addi	sp,sp,-32
    80003cb8:	ec06                	sd	ra,24(sp)
    80003cba:	e822                	sd	s0,16(sp)
    80003cbc:	e426                	sd	s1,8(sp)
    80003cbe:	1000                	addi	s0,sp,32
    80003cc0:	84aa                	mv	s1,a0
  iunlock(ip);
    80003cc2:	00000097          	auipc	ra,0x0
    80003cc6:	e54080e7          	jalr	-428(ra) # 80003b16 <iunlock>
  iput(ip);
    80003cca:	8526                	mv	a0,s1
    80003ccc:	00000097          	auipc	ra,0x0
    80003cd0:	f42080e7          	jalr	-190(ra) # 80003c0e <iput>
}
    80003cd4:	60e2                	ld	ra,24(sp)
    80003cd6:	6442                	ld	s0,16(sp)
    80003cd8:	64a2                	ld	s1,8(sp)
    80003cda:	6105                	addi	sp,sp,32
    80003cdc:	8082                	ret

0000000080003cde <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003cde:	1141                	addi	sp,sp,-16
    80003ce0:	e422                	sd	s0,8(sp)
    80003ce2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ce4:	411c                	lw	a5,0(a0)
    80003ce6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003ce8:	415c                	lw	a5,4(a0)
    80003cea:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003cec:	04451783          	lh	a5,68(a0)
    80003cf0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003cf4:	04a51783          	lh	a5,74(a0)
    80003cf8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003cfc:	04c56783          	lwu	a5,76(a0)
    80003d00:	e99c                	sd	a5,16(a1)
}
    80003d02:	6422                	ld	s0,8(sp)
    80003d04:	0141                	addi	sp,sp,16
    80003d06:	8082                	ret

0000000080003d08 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d08:	457c                	lw	a5,76(a0)
    80003d0a:	0ed7e863          	bltu	a5,a3,80003dfa <readi+0xf2>
{
    80003d0e:	7159                	addi	sp,sp,-112
    80003d10:	f486                	sd	ra,104(sp)
    80003d12:	f0a2                	sd	s0,96(sp)
    80003d14:	eca6                	sd	s1,88(sp)
    80003d16:	e8ca                	sd	s2,80(sp)
    80003d18:	e4ce                	sd	s3,72(sp)
    80003d1a:	e0d2                	sd	s4,64(sp)
    80003d1c:	fc56                	sd	s5,56(sp)
    80003d1e:	f85a                	sd	s6,48(sp)
    80003d20:	f45e                	sd	s7,40(sp)
    80003d22:	f062                	sd	s8,32(sp)
    80003d24:	ec66                	sd	s9,24(sp)
    80003d26:	e86a                	sd	s10,16(sp)
    80003d28:	e46e                	sd	s11,8(sp)
    80003d2a:	1880                	addi	s0,sp,112
    80003d2c:	8baa                	mv	s7,a0
    80003d2e:	8c2e                	mv	s8,a1
    80003d30:	8ab2                	mv	s5,a2
    80003d32:	84b6                	mv	s1,a3
    80003d34:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d36:	9f35                	addw	a4,a4,a3
    return 0;
    80003d38:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003d3a:	08d76f63          	bltu	a4,a3,80003dd8 <readi+0xd0>
  if(off + n > ip->size)
    80003d3e:	00e7f463          	bgeu	a5,a4,80003d46 <readi+0x3e>
    n = ip->size - off;
    80003d42:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d46:	0a0b0863          	beqz	s6,80003df6 <readi+0xee>
    80003d4a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d4c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003d50:	5cfd                	li	s9,-1
    80003d52:	a82d                	j	80003d8c <readi+0x84>
    80003d54:	020a1d93          	slli	s11,s4,0x20
    80003d58:	020ddd93          	srli	s11,s11,0x20
    80003d5c:	05890793          	addi	a5,s2,88
    80003d60:	86ee                	mv	a3,s11
    80003d62:	963e                	add	a2,a2,a5
    80003d64:	85d6                	mv	a1,s5
    80003d66:	8562                	mv	a0,s8
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	ae6080e7          	jalr	-1306(ra) # 8000284e <either_copyout>
    80003d70:	05950d63          	beq	a0,s9,80003dca <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003d74:	854a                	mv	a0,s2
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	60a080e7          	jalr	1546(ra) # 80003380 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d7e:	013a09bb          	addw	s3,s4,s3
    80003d82:	009a04bb          	addw	s1,s4,s1
    80003d86:	9aee                	add	s5,s5,s11
    80003d88:	0569f663          	bgeu	s3,s6,80003dd4 <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003d8c:	000ba903          	lw	s2,0(s7)
    80003d90:	00a4d59b          	srliw	a1,s1,0xa
    80003d94:	855e                	mv	a0,s7
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	8ae080e7          	jalr	-1874(ra) # 80003644 <bmap>
    80003d9e:	0005059b          	sext.w	a1,a0
    80003da2:	854a                	mv	a0,s2
    80003da4:	fffff097          	auipc	ra,0xfffff
    80003da8:	4ac080e7          	jalr	1196(ra) # 80003250 <bread>
    80003dac:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003dae:	3ff4f613          	andi	a2,s1,1023
    80003db2:	40cd07bb          	subw	a5,s10,a2
    80003db6:	413b073b          	subw	a4,s6,s3
    80003dba:	8a3e                	mv	s4,a5
    80003dbc:	2781                	sext.w	a5,a5
    80003dbe:	0007069b          	sext.w	a3,a4
    80003dc2:	f8f6f9e3          	bgeu	a3,a5,80003d54 <readi+0x4c>
    80003dc6:	8a3a                	mv	s4,a4
    80003dc8:	b771                	j	80003d54 <readi+0x4c>
      brelse(bp);
    80003dca:	854a                	mv	a0,s2
    80003dcc:	fffff097          	auipc	ra,0xfffff
    80003dd0:	5b4080e7          	jalr	1460(ra) # 80003380 <brelse>
  }
  return tot;
    80003dd4:	0009851b          	sext.w	a0,s3
}
    80003dd8:	70a6                	ld	ra,104(sp)
    80003dda:	7406                	ld	s0,96(sp)
    80003ddc:	64e6                	ld	s1,88(sp)
    80003dde:	6946                	ld	s2,80(sp)
    80003de0:	69a6                	ld	s3,72(sp)
    80003de2:	6a06                	ld	s4,64(sp)
    80003de4:	7ae2                	ld	s5,56(sp)
    80003de6:	7b42                	ld	s6,48(sp)
    80003de8:	7ba2                	ld	s7,40(sp)
    80003dea:	7c02                	ld	s8,32(sp)
    80003dec:	6ce2                	ld	s9,24(sp)
    80003dee:	6d42                	ld	s10,16(sp)
    80003df0:	6da2                	ld	s11,8(sp)
    80003df2:	6165                	addi	sp,sp,112
    80003df4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003df6:	89da                	mv	s3,s6
    80003df8:	bff1                	j	80003dd4 <readi+0xcc>
    return 0;
    80003dfa:	4501                	li	a0,0
}
    80003dfc:	8082                	ret

0000000080003dfe <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003dfe:	457c                	lw	a5,76(a0)
    80003e00:	10d7e663          	bltu	a5,a3,80003f0c <writei+0x10e>
{
    80003e04:	7159                	addi	sp,sp,-112
    80003e06:	f486                	sd	ra,104(sp)
    80003e08:	f0a2                	sd	s0,96(sp)
    80003e0a:	eca6                	sd	s1,88(sp)
    80003e0c:	e8ca                	sd	s2,80(sp)
    80003e0e:	e4ce                	sd	s3,72(sp)
    80003e10:	e0d2                	sd	s4,64(sp)
    80003e12:	fc56                	sd	s5,56(sp)
    80003e14:	f85a                	sd	s6,48(sp)
    80003e16:	f45e                	sd	s7,40(sp)
    80003e18:	f062                	sd	s8,32(sp)
    80003e1a:	ec66                	sd	s9,24(sp)
    80003e1c:	e86a                	sd	s10,16(sp)
    80003e1e:	e46e                	sd	s11,8(sp)
    80003e20:	1880                	addi	s0,sp,112
    80003e22:	8baa                	mv	s7,a0
    80003e24:	8c2e                	mv	s8,a1
    80003e26:	8ab2                	mv	s5,a2
    80003e28:	8936                	mv	s2,a3
    80003e2a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003e2c:	00e687bb          	addw	a5,a3,a4
    80003e30:	0ed7e063          	bltu	a5,a3,80003f10 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003e34:	00043737          	lui	a4,0x43
    80003e38:	0cf76e63          	bltu	a4,a5,80003f14 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e3c:	0a0b0763          	beqz	s6,80003eea <writei+0xec>
    80003e40:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e42:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003e46:	5cfd                	li	s9,-1
    80003e48:	a091                	j	80003e8c <writei+0x8e>
    80003e4a:	02099d93          	slli	s11,s3,0x20
    80003e4e:	020ddd93          	srli	s11,s11,0x20
    80003e52:	05848793          	addi	a5,s1,88
    80003e56:	86ee                	mv	a3,s11
    80003e58:	8656                	mv	a2,s5
    80003e5a:	85e2                	mv	a1,s8
    80003e5c:	953e                	add	a0,a0,a5
    80003e5e:	fffff097          	auipc	ra,0xfffff
    80003e62:	a46080e7          	jalr	-1466(ra) # 800028a4 <either_copyin>
    80003e66:	07950263          	beq	a0,s9,80003eca <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003e6a:	8526                	mv	a0,s1
    80003e6c:	00000097          	auipc	ra,0x0
    80003e70:	77e080e7          	jalr	1918(ra) # 800045ea <log_write>
    brelse(bp);
    80003e74:	8526                	mv	a0,s1
    80003e76:	fffff097          	auipc	ra,0xfffff
    80003e7a:	50a080e7          	jalr	1290(ra) # 80003380 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e7e:	01498a3b          	addw	s4,s3,s4
    80003e82:	0129893b          	addw	s2,s3,s2
    80003e86:	9aee                	add	s5,s5,s11
    80003e88:	056a7663          	bgeu	s4,s6,80003ed4 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003e8c:	000ba483          	lw	s1,0(s7)
    80003e90:	00a9559b          	srliw	a1,s2,0xa
    80003e94:	855e                	mv	a0,s7
    80003e96:	fffff097          	auipc	ra,0xfffff
    80003e9a:	7ae080e7          	jalr	1966(ra) # 80003644 <bmap>
    80003e9e:	0005059b          	sext.w	a1,a0
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	fffff097          	auipc	ra,0xfffff
    80003ea8:	3ac080e7          	jalr	940(ra) # 80003250 <bread>
    80003eac:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003eae:	3ff97513          	andi	a0,s2,1023
    80003eb2:	40ad07bb          	subw	a5,s10,a0
    80003eb6:	414b073b          	subw	a4,s6,s4
    80003eba:	89be                	mv	s3,a5
    80003ebc:	2781                	sext.w	a5,a5
    80003ebe:	0007069b          	sext.w	a3,a4
    80003ec2:	f8f6f4e3          	bgeu	a3,a5,80003e4a <writei+0x4c>
    80003ec6:	89ba                	mv	s3,a4
    80003ec8:	b749                	j	80003e4a <writei+0x4c>
      brelse(bp);
    80003eca:	8526                	mv	a0,s1
    80003ecc:	fffff097          	auipc	ra,0xfffff
    80003ed0:	4b4080e7          	jalr	1204(ra) # 80003380 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003ed4:	04cba783          	lw	a5,76(s7)
    80003ed8:	0127f463          	bgeu	a5,s2,80003ee0 <writei+0xe2>
      ip->size = off;
    80003edc:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003ee0:	855e                	mv	a0,s7
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	aa8080e7          	jalr	-1368(ra) # 8000398a <iupdate>
  }

  return n;
    80003eea:	000b051b          	sext.w	a0,s6
}
    80003eee:	70a6                	ld	ra,104(sp)
    80003ef0:	7406                	ld	s0,96(sp)
    80003ef2:	64e6                	ld	s1,88(sp)
    80003ef4:	6946                	ld	s2,80(sp)
    80003ef6:	69a6                	ld	s3,72(sp)
    80003ef8:	6a06                	ld	s4,64(sp)
    80003efa:	7ae2                	ld	s5,56(sp)
    80003efc:	7b42                	ld	s6,48(sp)
    80003efe:	7ba2                	ld	s7,40(sp)
    80003f00:	7c02                	ld	s8,32(sp)
    80003f02:	6ce2                	ld	s9,24(sp)
    80003f04:	6d42                	ld	s10,16(sp)
    80003f06:	6da2                	ld	s11,8(sp)
    80003f08:	6165                	addi	sp,sp,112
    80003f0a:	8082                	ret
    return -1;
    80003f0c:	557d                	li	a0,-1
}
    80003f0e:	8082                	ret
    return -1;
    80003f10:	557d                	li	a0,-1
    80003f12:	bff1                	j	80003eee <writei+0xf0>
    return -1;
    80003f14:	557d                	li	a0,-1
    80003f16:	bfe1                	j	80003eee <writei+0xf0>

0000000080003f18 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003f18:	1141                	addi	sp,sp,-16
    80003f1a:	e406                	sd	ra,8(sp)
    80003f1c:	e022                	sd	s0,0(sp)
    80003f1e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003f20:	4639                	li	a2,14
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	eae080e7          	jalr	-338(ra) # 80000dd0 <strncmp>
}
    80003f2a:	60a2                	ld	ra,8(sp)
    80003f2c:	6402                	ld	s0,0(sp)
    80003f2e:	0141                	addi	sp,sp,16
    80003f30:	8082                	ret

0000000080003f32 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003f32:	7139                	addi	sp,sp,-64
    80003f34:	fc06                	sd	ra,56(sp)
    80003f36:	f822                	sd	s0,48(sp)
    80003f38:	f426                	sd	s1,40(sp)
    80003f3a:	f04a                	sd	s2,32(sp)
    80003f3c:	ec4e                	sd	s3,24(sp)
    80003f3e:	e852                	sd	s4,16(sp)
    80003f40:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003f42:	04451703          	lh	a4,68(a0)
    80003f46:	4785                	li	a5,1
    80003f48:	00f71a63          	bne	a4,a5,80003f5c <dirlookup+0x2a>
    80003f4c:	892a                	mv	s2,a0
    80003f4e:	89ae                	mv	s3,a1
    80003f50:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f52:	457c                	lw	a5,76(a0)
    80003f54:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003f56:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f58:	e79d                	bnez	a5,80003f86 <dirlookup+0x54>
    80003f5a:	a8a5                	j	80003fd2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003f5c:	00004517          	auipc	a0,0x4
    80003f60:	74450513          	addi	a0,a0,1860 # 800086a0 <syscalls+0x1a0>
    80003f64:	ffffc097          	auipc	ra,0xffffc
    80003f68:	5dc080e7          	jalr	1500(ra) # 80000540 <panic>
      panic("dirlookup read");
    80003f6c:	00004517          	auipc	a0,0x4
    80003f70:	74c50513          	addi	a0,a0,1868 # 800086b8 <syscalls+0x1b8>
    80003f74:	ffffc097          	auipc	ra,0xffffc
    80003f78:	5cc080e7          	jalr	1484(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f7c:	24c1                	addiw	s1,s1,16
    80003f7e:	04c92783          	lw	a5,76(s2)
    80003f82:	04f4f763          	bgeu	s1,a5,80003fd0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f86:	4741                	li	a4,16
    80003f88:	86a6                	mv	a3,s1
    80003f8a:	fc040613          	addi	a2,s0,-64
    80003f8e:	4581                	li	a1,0
    80003f90:	854a                	mv	a0,s2
    80003f92:	00000097          	auipc	ra,0x0
    80003f96:	d76080e7          	jalr	-650(ra) # 80003d08 <readi>
    80003f9a:	47c1                	li	a5,16
    80003f9c:	fcf518e3          	bne	a0,a5,80003f6c <dirlookup+0x3a>
    if(de.inum == 0)
    80003fa0:	fc045783          	lhu	a5,-64(s0)
    80003fa4:	dfe1                	beqz	a5,80003f7c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003fa6:	fc240593          	addi	a1,s0,-62
    80003faa:	854e                	mv	a0,s3
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	f6c080e7          	jalr	-148(ra) # 80003f18 <namecmp>
    80003fb4:	f561                	bnez	a0,80003f7c <dirlookup+0x4a>
      if(poff)
    80003fb6:	000a0463          	beqz	s4,80003fbe <dirlookup+0x8c>
        *poff = off;
    80003fba:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003fbe:	fc045583          	lhu	a1,-64(s0)
    80003fc2:	00092503          	lw	a0,0(s2)
    80003fc6:	fffff097          	auipc	ra,0xfffff
    80003fca:	75a080e7          	jalr	1882(ra) # 80003720 <iget>
    80003fce:	a011                	j	80003fd2 <dirlookup+0xa0>
  return 0;
    80003fd0:	4501                	li	a0,0
}
    80003fd2:	70e2                	ld	ra,56(sp)
    80003fd4:	7442                	ld	s0,48(sp)
    80003fd6:	74a2                	ld	s1,40(sp)
    80003fd8:	7902                	ld	s2,32(sp)
    80003fda:	69e2                	ld	s3,24(sp)
    80003fdc:	6a42                	ld	s4,16(sp)
    80003fde:	6121                	addi	sp,sp,64
    80003fe0:	8082                	ret

0000000080003fe2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003fe2:	711d                	addi	sp,sp,-96
    80003fe4:	ec86                	sd	ra,88(sp)
    80003fe6:	e8a2                	sd	s0,80(sp)
    80003fe8:	e4a6                	sd	s1,72(sp)
    80003fea:	e0ca                	sd	s2,64(sp)
    80003fec:	fc4e                	sd	s3,56(sp)
    80003fee:	f852                	sd	s4,48(sp)
    80003ff0:	f456                	sd	s5,40(sp)
    80003ff2:	f05a                	sd	s6,32(sp)
    80003ff4:	ec5e                	sd	s7,24(sp)
    80003ff6:	e862                	sd	s8,16(sp)
    80003ff8:	e466                	sd	s9,8(sp)
    80003ffa:	1080                	addi	s0,sp,96
    80003ffc:	84aa                	mv	s1,a0
    80003ffe:	8aae                	mv	s5,a1
    80004000:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004002:	00054703          	lbu	a4,0(a0)
    80004006:	02f00793          	li	a5,47
    8000400a:	02f70363          	beq	a4,a5,80004030 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000400e:	ffffe097          	auipc	ra,0xffffe
    80004012:	dba080e7          	jalr	-582(ra) # 80001dc8 <myproc>
    80004016:	15053503          	ld	a0,336(a0)
    8000401a:	00000097          	auipc	ra,0x0
    8000401e:	9fc080e7          	jalr	-1540(ra) # 80003a16 <idup>
    80004022:	89aa                	mv	s3,a0
  while(*path == '/')
    80004024:	02f00913          	li	s2,47
  len = path - s;
    80004028:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000402a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000402c:	4b85                	li	s7,1
    8000402e:	a865                	j	800040e6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004030:	4585                	li	a1,1
    80004032:	4505                	li	a0,1
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	6ec080e7          	jalr	1772(ra) # 80003720 <iget>
    8000403c:	89aa                	mv	s3,a0
    8000403e:	b7dd                	j	80004024 <namex+0x42>
      iunlockput(ip);
    80004040:	854e                	mv	a0,s3
    80004042:	00000097          	auipc	ra,0x0
    80004046:	c74080e7          	jalr	-908(ra) # 80003cb6 <iunlockput>
      return 0;
    8000404a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000404c:	854e                	mv	a0,s3
    8000404e:	60e6                	ld	ra,88(sp)
    80004050:	6446                	ld	s0,80(sp)
    80004052:	64a6                	ld	s1,72(sp)
    80004054:	6906                	ld	s2,64(sp)
    80004056:	79e2                	ld	s3,56(sp)
    80004058:	7a42                	ld	s4,48(sp)
    8000405a:	7aa2                	ld	s5,40(sp)
    8000405c:	7b02                	ld	s6,32(sp)
    8000405e:	6be2                	ld	s7,24(sp)
    80004060:	6c42                	ld	s8,16(sp)
    80004062:	6ca2                	ld	s9,8(sp)
    80004064:	6125                	addi	sp,sp,96
    80004066:	8082                	ret
      iunlock(ip);
    80004068:	854e                	mv	a0,s3
    8000406a:	00000097          	auipc	ra,0x0
    8000406e:	aac080e7          	jalr	-1364(ra) # 80003b16 <iunlock>
      return ip;
    80004072:	bfe9                	j	8000404c <namex+0x6a>
      iunlockput(ip);
    80004074:	854e                	mv	a0,s3
    80004076:	00000097          	auipc	ra,0x0
    8000407a:	c40080e7          	jalr	-960(ra) # 80003cb6 <iunlockput>
      return 0;
    8000407e:	89e6                	mv	s3,s9
    80004080:	b7f1                	j	8000404c <namex+0x6a>
  len = path - s;
    80004082:	40b48633          	sub	a2,s1,a1
    80004086:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000408a:	099c5463          	bge	s8,s9,80004112 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000408e:	4639                	li	a2,14
    80004090:	8552                	mv	a0,s4
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	cc2080e7          	jalr	-830(ra) # 80000d54 <memmove>
  while(*path == '/')
    8000409a:	0004c783          	lbu	a5,0(s1)
    8000409e:	01279763          	bne	a5,s2,800040ac <namex+0xca>
    path++;
    800040a2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800040a4:	0004c783          	lbu	a5,0(s1)
    800040a8:	ff278de3          	beq	a5,s2,800040a2 <namex+0xc0>
    ilock(ip);
    800040ac:	854e                	mv	a0,s3
    800040ae:	00000097          	auipc	ra,0x0
    800040b2:	9a6080e7          	jalr	-1626(ra) # 80003a54 <ilock>
    if(ip->type != T_DIR){
    800040b6:	04499783          	lh	a5,68(s3)
    800040ba:	f97793e3          	bne	a5,s7,80004040 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800040be:	000a8563          	beqz	s5,800040c8 <namex+0xe6>
    800040c2:	0004c783          	lbu	a5,0(s1)
    800040c6:	d3cd                	beqz	a5,80004068 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800040c8:	865a                	mv	a2,s6
    800040ca:	85d2                	mv	a1,s4
    800040cc:	854e                	mv	a0,s3
    800040ce:	00000097          	auipc	ra,0x0
    800040d2:	e64080e7          	jalr	-412(ra) # 80003f32 <dirlookup>
    800040d6:	8caa                	mv	s9,a0
    800040d8:	dd51                	beqz	a0,80004074 <namex+0x92>
    iunlockput(ip);
    800040da:	854e                	mv	a0,s3
    800040dc:	00000097          	auipc	ra,0x0
    800040e0:	bda080e7          	jalr	-1062(ra) # 80003cb6 <iunlockput>
    ip = next;
    800040e4:	89e6                	mv	s3,s9
  while(*path == '/')
    800040e6:	0004c783          	lbu	a5,0(s1)
    800040ea:	05279763          	bne	a5,s2,80004138 <namex+0x156>
    path++;
    800040ee:	0485                	addi	s1,s1,1
  while(*path == '/')
    800040f0:	0004c783          	lbu	a5,0(s1)
    800040f4:	ff278de3          	beq	a5,s2,800040ee <namex+0x10c>
  if(*path == 0)
    800040f8:	c79d                	beqz	a5,80004126 <namex+0x144>
    path++;
    800040fa:	85a6                	mv	a1,s1
  len = path - s;
    800040fc:	8cda                	mv	s9,s6
    800040fe:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004100:	01278963          	beq	a5,s2,80004112 <namex+0x130>
    80004104:	dfbd                	beqz	a5,80004082 <namex+0xa0>
    path++;
    80004106:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004108:	0004c783          	lbu	a5,0(s1)
    8000410c:	ff279ce3          	bne	a5,s2,80004104 <namex+0x122>
    80004110:	bf8d                	j	80004082 <namex+0xa0>
    memmove(name, s, len);
    80004112:	2601                	sext.w	a2,a2
    80004114:	8552                	mv	a0,s4
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	c3e080e7          	jalr	-962(ra) # 80000d54 <memmove>
    name[len] = 0;
    8000411e:	9cd2                	add	s9,s9,s4
    80004120:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004124:	bf9d                	j	8000409a <namex+0xb8>
  if(nameiparent){
    80004126:	f20a83e3          	beqz	s5,8000404c <namex+0x6a>
    iput(ip);
    8000412a:	854e                	mv	a0,s3
    8000412c:	00000097          	auipc	ra,0x0
    80004130:	ae2080e7          	jalr	-1310(ra) # 80003c0e <iput>
    return 0;
    80004134:	4981                	li	s3,0
    80004136:	bf19                	j	8000404c <namex+0x6a>
  if(*path == 0)
    80004138:	d7fd                	beqz	a5,80004126 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000413a:	0004c783          	lbu	a5,0(s1)
    8000413e:	85a6                	mv	a1,s1
    80004140:	b7d1                	j	80004104 <namex+0x122>

0000000080004142 <dirlink>:
{
    80004142:	7139                	addi	sp,sp,-64
    80004144:	fc06                	sd	ra,56(sp)
    80004146:	f822                	sd	s0,48(sp)
    80004148:	f426                	sd	s1,40(sp)
    8000414a:	f04a                	sd	s2,32(sp)
    8000414c:	ec4e                	sd	s3,24(sp)
    8000414e:	e852                	sd	s4,16(sp)
    80004150:	0080                	addi	s0,sp,64
    80004152:	892a                	mv	s2,a0
    80004154:	8a2e                	mv	s4,a1
    80004156:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004158:	4601                	li	a2,0
    8000415a:	00000097          	auipc	ra,0x0
    8000415e:	dd8080e7          	jalr	-552(ra) # 80003f32 <dirlookup>
    80004162:	e93d                	bnez	a0,800041d8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004164:	04c92483          	lw	s1,76(s2)
    80004168:	c49d                	beqz	s1,80004196 <dirlink+0x54>
    8000416a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000416c:	4741                	li	a4,16
    8000416e:	86a6                	mv	a3,s1
    80004170:	fc040613          	addi	a2,s0,-64
    80004174:	4581                	li	a1,0
    80004176:	854a                	mv	a0,s2
    80004178:	00000097          	auipc	ra,0x0
    8000417c:	b90080e7          	jalr	-1136(ra) # 80003d08 <readi>
    80004180:	47c1                	li	a5,16
    80004182:	06f51163          	bne	a0,a5,800041e4 <dirlink+0xa2>
    if(de.inum == 0)
    80004186:	fc045783          	lhu	a5,-64(s0)
    8000418a:	c791                	beqz	a5,80004196 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000418c:	24c1                	addiw	s1,s1,16
    8000418e:	04c92783          	lw	a5,76(s2)
    80004192:	fcf4ede3          	bltu	s1,a5,8000416c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004196:	4639                	li	a2,14
    80004198:	85d2                	mv	a1,s4
    8000419a:	fc240513          	addi	a0,s0,-62
    8000419e:	ffffd097          	auipc	ra,0xffffd
    800041a2:	c6e080e7          	jalr	-914(ra) # 80000e0c <strncpy>
  de.inum = inum;
    800041a6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041aa:	4741                	li	a4,16
    800041ac:	86a6                	mv	a3,s1
    800041ae:	fc040613          	addi	a2,s0,-64
    800041b2:	4581                	li	a1,0
    800041b4:	854a                	mv	a0,s2
    800041b6:	00000097          	auipc	ra,0x0
    800041ba:	c48080e7          	jalr	-952(ra) # 80003dfe <writei>
    800041be:	872a                	mv	a4,a0
    800041c0:	47c1                	li	a5,16
  return 0;
    800041c2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041c4:	02f71863          	bne	a4,a5,800041f4 <dirlink+0xb2>
}
    800041c8:	70e2                	ld	ra,56(sp)
    800041ca:	7442                	ld	s0,48(sp)
    800041cc:	74a2                	ld	s1,40(sp)
    800041ce:	7902                	ld	s2,32(sp)
    800041d0:	69e2                	ld	s3,24(sp)
    800041d2:	6a42                	ld	s4,16(sp)
    800041d4:	6121                	addi	sp,sp,64
    800041d6:	8082                	ret
    iput(ip);
    800041d8:	00000097          	auipc	ra,0x0
    800041dc:	a36080e7          	jalr	-1482(ra) # 80003c0e <iput>
    return -1;
    800041e0:	557d                	li	a0,-1
    800041e2:	b7dd                	j	800041c8 <dirlink+0x86>
      panic("dirlink read");
    800041e4:	00004517          	auipc	a0,0x4
    800041e8:	4e450513          	addi	a0,a0,1252 # 800086c8 <syscalls+0x1c8>
    800041ec:	ffffc097          	auipc	ra,0xffffc
    800041f0:	354080e7          	jalr	852(ra) # 80000540 <panic>
    panic("dirlink");
    800041f4:	00004517          	auipc	a0,0x4
    800041f8:	5f450513          	addi	a0,a0,1524 # 800087e8 <syscalls+0x2e8>
    800041fc:	ffffc097          	auipc	ra,0xffffc
    80004200:	344080e7          	jalr	836(ra) # 80000540 <panic>

0000000080004204 <namei>:

struct inode*
namei(char *path)
{
    80004204:	1101                	addi	sp,sp,-32
    80004206:	ec06                	sd	ra,24(sp)
    80004208:	e822                	sd	s0,16(sp)
    8000420a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000420c:	fe040613          	addi	a2,s0,-32
    80004210:	4581                	li	a1,0
    80004212:	00000097          	auipc	ra,0x0
    80004216:	dd0080e7          	jalr	-560(ra) # 80003fe2 <namex>
}
    8000421a:	60e2                	ld	ra,24(sp)
    8000421c:	6442                	ld	s0,16(sp)
    8000421e:	6105                	addi	sp,sp,32
    80004220:	8082                	ret

0000000080004222 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004222:	1141                	addi	sp,sp,-16
    80004224:	e406                	sd	ra,8(sp)
    80004226:	e022                	sd	s0,0(sp)
    80004228:	0800                	addi	s0,sp,16
    8000422a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000422c:	4585                	li	a1,1
    8000422e:	00000097          	auipc	ra,0x0
    80004232:	db4080e7          	jalr	-588(ra) # 80003fe2 <namex>
}
    80004236:	60a2                	ld	ra,8(sp)
    80004238:	6402                	ld	s0,0(sp)
    8000423a:	0141                	addi	sp,sp,16
    8000423c:	8082                	ret

000000008000423e <write_head>:
    8000423e:	1101                	addi	sp,sp,-32
    80004240:	ec06                	sd	ra,24(sp)
    80004242:	e822                	sd	s0,16(sp)
    80004244:	e426                	sd	s1,8(sp)
    80004246:	e04a                	sd	s2,0(sp)
    80004248:	1000                	addi	s0,sp,32
    8000424a:	0001e917          	auipc	s2,0x1e
    8000424e:	d0690913          	addi	s2,s2,-762 # 80021f50 <log>
    80004252:	01892583          	lw	a1,24(s2)
    80004256:	02892503          	lw	a0,40(s2)
    8000425a:	fffff097          	auipc	ra,0xfffff
    8000425e:	ff6080e7          	jalr	-10(ra) # 80003250 <bread>
    80004262:	84aa                	mv	s1,a0
    80004264:	02c92683          	lw	a3,44(s2)
    80004268:	cd34                	sw	a3,88(a0)
    8000426a:	02d05863          	blez	a3,8000429a <write_head+0x5c>
    8000426e:	0001e797          	auipc	a5,0x1e
    80004272:	d1278793          	addi	a5,a5,-750 # 80021f80 <log+0x30>
    80004276:	05c50713          	addi	a4,a0,92
    8000427a:	36fd                	addiw	a3,a3,-1
    8000427c:	02069613          	slli	a2,a3,0x20
    80004280:	01e65693          	srli	a3,a2,0x1e
    80004284:	0001e617          	auipc	a2,0x1e
    80004288:	d0060613          	addi	a2,a2,-768 # 80021f84 <log+0x34>
    8000428c:	96b2                	add	a3,a3,a2
    8000428e:	4390                	lw	a2,0(a5)
    80004290:	c310                	sw	a2,0(a4)
    80004292:	0791                	addi	a5,a5,4
    80004294:	0711                	addi	a4,a4,4
    80004296:	fed79ce3          	bne	a5,a3,8000428e <write_head+0x50>
    8000429a:	8526                	mv	a0,s1
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	0a6080e7          	jalr	166(ra) # 80003342 <bwrite>
    800042a4:	8526                	mv	a0,s1
    800042a6:	fffff097          	auipc	ra,0xfffff
    800042aa:	0da080e7          	jalr	218(ra) # 80003380 <brelse>
    800042ae:	60e2                	ld	ra,24(sp)
    800042b0:	6442                	ld	s0,16(sp)
    800042b2:	64a2                	ld	s1,8(sp)
    800042b4:	6902                	ld	s2,0(sp)
    800042b6:	6105                	addi	sp,sp,32
    800042b8:	8082                	ret

00000000800042ba <install_trans>:
    800042ba:	0001e797          	auipc	a5,0x1e
    800042be:	cc27a783          	lw	a5,-830(a5) # 80021f7c <log+0x2c>
    800042c2:	0af05663          	blez	a5,8000436e <install_trans+0xb4>
    800042c6:	7139                	addi	sp,sp,-64
    800042c8:	fc06                	sd	ra,56(sp)
    800042ca:	f822                	sd	s0,48(sp)
    800042cc:	f426                	sd	s1,40(sp)
    800042ce:	f04a                	sd	s2,32(sp)
    800042d0:	ec4e                	sd	s3,24(sp)
    800042d2:	e852                	sd	s4,16(sp)
    800042d4:	e456                	sd	s5,8(sp)
    800042d6:	0080                	addi	s0,sp,64
    800042d8:	0001ea97          	auipc	s5,0x1e
    800042dc:	ca8a8a93          	addi	s5,s5,-856 # 80021f80 <log+0x30>
    800042e0:	4a01                	li	s4,0
    800042e2:	0001e997          	auipc	s3,0x1e
    800042e6:	c6e98993          	addi	s3,s3,-914 # 80021f50 <log>
    800042ea:	0189a583          	lw	a1,24(s3)
    800042ee:	014585bb          	addw	a1,a1,s4
    800042f2:	2585                	addiw	a1,a1,1
    800042f4:	0289a503          	lw	a0,40(s3)
    800042f8:	fffff097          	auipc	ra,0xfffff
    800042fc:	f58080e7          	jalr	-168(ra) # 80003250 <bread>
    80004300:	892a                	mv	s2,a0
    80004302:	000aa583          	lw	a1,0(s5)
    80004306:	0289a503          	lw	a0,40(s3)
    8000430a:	fffff097          	auipc	ra,0xfffff
    8000430e:	f46080e7          	jalr	-186(ra) # 80003250 <bread>
    80004312:	84aa                	mv	s1,a0
    80004314:	40000613          	li	a2,1024
    80004318:	05890593          	addi	a1,s2,88
    8000431c:	05850513          	addi	a0,a0,88
    80004320:	ffffd097          	auipc	ra,0xffffd
    80004324:	a34080e7          	jalr	-1484(ra) # 80000d54 <memmove>
    80004328:	8526                	mv	a0,s1
    8000432a:	fffff097          	auipc	ra,0xfffff
    8000432e:	018080e7          	jalr	24(ra) # 80003342 <bwrite>
    80004332:	8526                	mv	a0,s1
    80004334:	fffff097          	auipc	ra,0xfffff
    80004338:	126080e7          	jalr	294(ra) # 8000345a <bunpin>
    8000433c:	854a                	mv	a0,s2
    8000433e:	fffff097          	auipc	ra,0xfffff
    80004342:	042080e7          	jalr	66(ra) # 80003380 <brelse>
    80004346:	8526                	mv	a0,s1
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	038080e7          	jalr	56(ra) # 80003380 <brelse>
    80004350:	2a05                	addiw	s4,s4,1
    80004352:	0a91                	addi	s5,s5,4
    80004354:	02c9a783          	lw	a5,44(s3)
    80004358:	f8fa49e3          	blt	s4,a5,800042ea <install_trans+0x30>
    8000435c:	70e2                	ld	ra,56(sp)
    8000435e:	7442                	ld	s0,48(sp)
    80004360:	74a2                	ld	s1,40(sp)
    80004362:	7902                	ld	s2,32(sp)
    80004364:	69e2                	ld	s3,24(sp)
    80004366:	6a42                	ld	s4,16(sp)
    80004368:	6aa2                	ld	s5,8(sp)
    8000436a:	6121                	addi	sp,sp,64
    8000436c:	8082                	ret
    8000436e:	8082                	ret

0000000080004370 <initlog>:
    80004370:	7179                	addi	sp,sp,-48
    80004372:	f406                	sd	ra,40(sp)
    80004374:	f022                	sd	s0,32(sp)
    80004376:	ec26                	sd	s1,24(sp)
    80004378:	e84a                	sd	s2,16(sp)
    8000437a:	e44e                	sd	s3,8(sp)
    8000437c:	1800                	addi	s0,sp,48
    8000437e:	892a                	mv	s2,a0
    80004380:	89ae                	mv	s3,a1
    80004382:	0001e497          	auipc	s1,0x1e
    80004386:	bce48493          	addi	s1,s1,-1074 # 80021f50 <log>
    8000438a:	00004597          	auipc	a1,0x4
    8000438e:	34e58593          	addi	a1,a1,846 # 800086d8 <syscalls+0x1d8>
    80004392:	8526                	mv	a0,s1
    80004394:	ffffc097          	auipc	ra,0xffffc
    80004398:	7d8080e7          	jalr	2008(ra) # 80000b6c <initlock>
    8000439c:	0149a583          	lw	a1,20(s3)
    800043a0:	cc8c                	sw	a1,24(s1)
    800043a2:	0109a783          	lw	a5,16(s3)
    800043a6:	ccdc                	sw	a5,28(s1)
    800043a8:	0324a423          	sw	s2,40(s1)
    800043ac:	854a                	mv	a0,s2
    800043ae:	fffff097          	auipc	ra,0xfffff
    800043b2:	ea2080e7          	jalr	-350(ra) # 80003250 <bread>
    800043b6:	4d34                	lw	a3,88(a0)
    800043b8:	d4d4                	sw	a3,44(s1)
    800043ba:	02d05663          	blez	a3,800043e6 <initlog+0x76>
    800043be:	05c50793          	addi	a5,a0,92
    800043c2:	0001e717          	auipc	a4,0x1e
    800043c6:	bbe70713          	addi	a4,a4,-1090 # 80021f80 <log+0x30>
    800043ca:	36fd                	addiw	a3,a3,-1
    800043cc:	02069613          	slli	a2,a3,0x20
    800043d0:	01e65693          	srli	a3,a2,0x1e
    800043d4:	06050613          	addi	a2,a0,96
    800043d8:	96b2                	add	a3,a3,a2
    800043da:	4390                	lw	a2,0(a5)
    800043dc:	c310                	sw	a2,0(a4)
    800043de:	0791                	addi	a5,a5,4
    800043e0:	0711                	addi	a4,a4,4
    800043e2:	fed79ce3          	bne	a5,a3,800043da <initlog+0x6a>
    800043e6:	fffff097          	auipc	ra,0xfffff
    800043ea:	f9a080e7          	jalr	-102(ra) # 80003380 <brelse>
    800043ee:	00000097          	auipc	ra,0x0
    800043f2:	ecc080e7          	jalr	-308(ra) # 800042ba <install_trans>
    800043f6:	0001e797          	auipc	a5,0x1e
    800043fa:	b807a323          	sw	zero,-1146(a5) # 80021f7c <log+0x2c>
    800043fe:	00000097          	auipc	ra,0x0
    80004402:	e40080e7          	jalr	-448(ra) # 8000423e <write_head>
    80004406:	70a2                	ld	ra,40(sp)
    80004408:	7402                	ld	s0,32(sp)
    8000440a:	64e2                	ld	s1,24(sp)
    8000440c:	6942                	ld	s2,16(sp)
    8000440e:	69a2                	ld	s3,8(sp)
    80004410:	6145                	addi	sp,sp,48
    80004412:	8082                	ret

0000000080004414 <begin_op>:
    80004414:	1101                	addi	sp,sp,-32
    80004416:	ec06                	sd	ra,24(sp)
    80004418:	e822                	sd	s0,16(sp)
    8000441a:	e426                	sd	s1,8(sp)
    8000441c:	e04a                	sd	s2,0(sp)
    8000441e:	1000                	addi	s0,sp,32
    80004420:	0001e517          	auipc	a0,0x1e
    80004424:	b3050513          	addi	a0,a0,-1232 # 80021f50 <log>
    80004428:	ffffc097          	auipc	ra,0xffffc
    8000442c:	7d4080e7          	jalr	2004(ra) # 80000bfc <acquire>
    80004430:	0001e497          	auipc	s1,0x1e
    80004434:	b2048493          	addi	s1,s1,-1248 # 80021f50 <log>
    80004438:	4979                	li	s2,30
    8000443a:	a039                	j	80004448 <begin_op+0x34>
    8000443c:	85a6                	mv	a1,s1
    8000443e:	8526                	mv	a0,s1
    80004440:	ffffe097          	auipc	ra,0xffffe
    80004444:	17e080e7          	jalr	382(ra) # 800025be <sleep>
    80004448:	50dc                	lw	a5,36(s1)
    8000444a:	fbed                	bnez	a5,8000443c <begin_op+0x28>
    8000444c:	509c                	lw	a5,32(s1)
    8000444e:	0017871b          	addiw	a4,a5,1
    80004452:	0007069b          	sext.w	a3,a4
    80004456:	0027179b          	slliw	a5,a4,0x2
    8000445a:	9fb9                	addw	a5,a5,a4
    8000445c:	0017979b          	slliw	a5,a5,0x1
    80004460:	54d8                	lw	a4,44(s1)
    80004462:	9fb9                	addw	a5,a5,a4
    80004464:	00f95963          	bge	s2,a5,80004476 <begin_op+0x62>
    80004468:	85a6                	mv	a1,s1
    8000446a:	8526                	mv	a0,s1
    8000446c:	ffffe097          	auipc	ra,0xffffe
    80004470:	152080e7          	jalr	338(ra) # 800025be <sleep>
    80004474:	bfd1                	j	80004448 <begin_op+0x34>
    80004476:	0001e517          	auipc	a0,0x1e
    8000447a:	ada50513          	addi	a0,a0,-1318 # 80021f50 <log>
    8000447e:	d114                	sw	a3,32(a0)
    80004480:	ffffd097          	auipc	ra,0xffffd
    80004484:	830080e7          	jalr	-2000(ra) # 80000cb0 <release>
    80004488:	60e2                	ld	ra,24(sp)
    8000448a:	6442                	ld	s0,16(sp)
    8000448c:	64a2                	ld	s1,8(sp)
    8000448e:	6902                	ld	s2,0(sp)
    80004490:	6105                	addi	sp,sp,32
    80004492:	8082                	ret

0000000080004494 <end_op>:
    80004494:	7139                	addi	sp,sp,-64
    80004496:	fc06                	sd	ra,56(sp)
    80004498:	f822                	sd	s0,48(sp)
    8000449a:	f426                	sd	s1,40(sp)
    8000449c:	f04a                	sd	s2,32(sp)
    8000449e:	ec4e                	sd	s3,24(sp)
    800044a0:	e852                	sd	s4,16(sp)
    800044a2:	e456                	sd	s5,8(sp)
    800044a4:	0080                	addi	s0,sp,64
    800044a6:	0001e497          	auipc	s1,0x1e
    800044aa:	aaa48493          	addi	s1,s1,-1366 # 80021f50 <log>
    800044ae:	8526                	mv	a0,s1
    800044b0:	ffffc097          	auipc	ra,0xffffc
    800044b4:	74c080e7          	jalr	1868(ra) # 80000bfc <acquire>
    800044b8:	509c                	lw	a5,32(s1)
    800044ba:	37fd                	addiw	a5,a5,-1
    800044bc:	0007891b          	sext.w	s2,a5
    800044c0:	d09c                	sw	a5,32(s1)
    800044c2:	50dc                	lw	a5,36(s1)
    800044c4:	e7b9                	bnez	a5,80004512 <end_op+0x7e>
    800044c6:	04091e63          	bnez	s2,80004522 <end_op+0x8e>
    800044ca:	0001e497          	auipc	s1,0x1e
    800044ce:	a8648493          	addi	s1,s1,-1402 # 80021f50 <log>
    800044d2:	4785                	li	a5,1
    800044d4:	d0dc                	sw	a5,36(s1)
    800044d6:	8526                	mv	a0,s1
    800044d8:	ffffc097          	auipc	ra,0xffffc
    800044dc:	7d8080e7          	jalr	2008(ra) # 80000cb0 <release>
    800044e0:	54dc                	lw	a5,44(s1)
    800044e2:	06f04763          	bgtz	a5,80004550 <end_op+0xbc>
    800044e6:	0001e497          	auipc	s1,0x1e
    800044ea:	a6a48493          	addi	s1,s1,-1430 # 80021f50 <log>
    800044ee:	8526                	mv	a0,s1
    800044f0:	ffffc097          	auipc	ra,0xffffc
    800044f4:	70c080e7          	jalr	1804(ra) # 80000bfc <acquire>
    800044f8:	0204a223          	sw	zero,36(s1)
    800044fc:	8526                	mv	a0,s1
    800044fe:	ffffe097          	auipc	ra,0xffffe
    80004502:	240080e7          	jalr	576(ra) # 8000273e <wakeup>
    80004506:	8526                	mv	a0,s1
    80004508:	ffffc097          	auipc	ra,0xffffc
    8000450c:	7a8080e7          	jalr	1960(ra) # 80000cb0 <release>
    80004510:	a03d                	j	8000453e <end_op+0xaa>
    80004512:	00004517          	auipc	a0,0x4
    80004516:	1ce50513          	addi	a0,a0,462 # 800086e0 <syscalls+0x1e0>
    8000451a:	ffffc097          	auipc	ra,0xffffc
    8000451e:	026080e7          	jalr	38(ra) # 80000540 <panic>
    80004522:	0001e497          	auipc	s1,0x1e
    80004526:	a2e48493          	addi	s1,s1,-1490 # 80021f50 <log>
    8000452a:	8526                	mv	a0,s1
    8000452c:	ffffe097          	auipc	ra,0xffffe
    80004530:	212080e7          	jalr	530(ra) # 8000273e <wakeup>
    80004534:	8526                	mv	a0,s1
    80004536:	ffffc097          	auipc	ra,0xffffc
    8000453a:	77a080e7          	jalr	1914(ra) # 80000cb0 <release>
    8000453e:	70e2                	ld	ra,56(sp)
    80004540:	7442                	ld	s0,48(sp)
    80004542:	74a2                	ld	s1,40(sp)
    80004544:	7902                	ld	s2,32(sp)
    80004546:	69e2                	ld	s3,24(sp)
    80004548:	6a42                	ld	s4,16(sp)
    8000454a:	6aa2                	ld	s5,8(sp)
    8000454c:	6121                	addi	sp,sp,64
    8000454e:	8082                	ret
    80004550:	0001ea97          	auipc	s5,0x1e
    80004554:	a30a8a93          	addi	s5,s5,-1488 # 80021f80 <log+0x30>
    80004558:	0001ea17          	auipc	s4,0x1e
    8000455c:	9f8a0a13          	addi	s4,s4,-1544 # 80021f50 <log>
    80004560:	018a2583          	lw	a1,24(s4)
    80004564:	012585bb          	addw	a1,a1,s2
    80004568:	2585                	addiw	a1,a1,1
    8000456a:	028a2503          	lw	a0,40(s4)
    8000456e:	fffff097          	auipc	ra,0xfffff
    80004572:	ce2080e7          	jalr	-798(ra) # 80003250 <bread>
    80004576:	84aa                	mv	s1,a0
    80004578:	000aa583          	lw	a1,0(s5)
    8000457c:	028a2503          	lw	a0,40(s4)
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	cd0080e7          	jalr	-816(ra) # 80003250 <bread>
    80004588:	89aa                	mv	s3,a0
    8000458a:	40000613          	li	a2,1024
    8000458e:	05850593          	addi	a1,a0,88
    80004592:	05848513          	addi	a0,s1,88
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	7be080e7          	jalr	1982(ra) # 80000d54 <memmove>
    8000459e:	8526                	mv	a0,s1
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	da2080e7          	jalr	-606(ra) # 80003342 <bwrite>
    800045a8:	854e                	mv	a0,s3
    800045aa:	fffff097          	auipc	ra,0xfffff
    800045ae:	dd6080e7          	jalr	-554(ra) # 80003380 <brelse>
    800045b2:	8526                	mv	a0,s1
    800045b4:	fffff097          	auipc	ra,0xfffff
    800045b8:	dcc080e7          	jalr	-564(ra) # 80003380 <brelse>
    800045bc:	2905                	addiw	s2,s2,1
    800045be:	0a91                	addi	s5,s5,4
    800045c0:	02ca2783          	lw	a5,44(s4)
    800045c4:	f8f94ee3          	blt	s2,a5,80004560 <end_op+0xcc>
    800045c8:	00000097          	auipc	ra,0x0
    800045cc:	c76080e7          	jalr	-906(ra) # 8000423e <write_head>
    800045d0:	00000097          	auipc	ra,0x0
    800045d4:	cea080e7          	jalr	-790(ra) # 800042ba <install_trans>
    800045d8:	0001e797          	auipc	a5,0x1e
    800045dc:	9a07a223          	sw	zero,-1628(a5) # 80021f7c <log+0x2c>
    800045e0:	00000097          	auipc	ra,0x0
    800045e4:	c5e080e7          	jalr	-930(ra) # 8000423e <write_head>
    800045e8:	bdfd                	j	800044e6 <end_op+0x52>

00000000800045ea <log_write>:
    800045ea:	1101                	addi	sp,sp,-32
    800045ec:	ec06                	sd	ra,24(sp)
    800045ee:	e822                	sd	s0,16(sp)
    800045f0:	e426                	sd	s1,8(sp)
    800045f2:	e04a                	sd	s2,0(sp)
    800045f4:	1000                	addi	s0,sp,32
    800045f6:	0001e717          	auipc	a4,0x1e
    800045fa:	98672703          	lw	a4,-1658(a4) # 80021f7c <log+0x2c>
    800045fe:	47f5                	li	a5,29
    80004600:	08e7c063          	blt	a5,a4,80004680 <log_write+0x96>
    80004604:	84aa                	mv	s1,a0
    80004606:	0001e797          	auipc	a5,0x1e
    8000460a:	9667a783          	lw	a5,-1690(a5) # 80021f6c <log+0x1c>
    8000460e:	37fd                	addiw	a5,a5,-1
    80004610:	06f75863          	bge	a4,a5,80004680 <log_write+0x96>
    80004614:	0001e797          	auipc	a5,0x1e
    80004618:	95c7a783          	lw	a5,-1700(a5) # 80021f70 <log+0x20>
    8000461c:	06f05a63          	blez	a5,80004690 <log_write+0xa6>
    80004620:	0001e917          	auipc	s2,0x1e
    80004624:	93090913          	addi	s2,s2,-1744 # 80021f50 <log>
    80004628:	854a                	mv	a0,s2
    8000462a:	ffffc097          	auipc	ra,0xffffc
    8000462e:	5d2080e7          	jalr	1490(ra) # 80000bfc <acquire>
    80004632:	02c92603          	lw	a2,44(s2)
    80004636:	06c05563          	blez	a2,800046a0 <log_write+0xb6>
    8000463a:	44cc                	lw	a1,12(s1)
    8000463c:	0001e717          	auipc	a4,0x1e
    80004640:	94470713          	addi	a4,a4,-1724 # 80021f80 <log+0x30>
    80004644:	4781                	li	a5,0
    80004646:	4314                	lw	a3,0(a4)
    80004648:	04b68d63          	beq	a3,a1,800046a2 <log_write+0xb8>
    8000464c:	2785                	addiw	a5,a5,1
    8000464e:	0711                	addi	a4,a4,4
    80004650:	fec79be3          	bne	a5,a2,80004646 <log_write+0x5c>
    80004654:	0621                	addi	a2,a2,8
    80004656:	060a                	slli	a2,a2,0x2
    80004658:	0001e797          	auipc	a5,0x1e
    8000465c:	8f878793          	addi	a5,a5,-1800 # 80021f50 <log>
    80004660:	963e                	add	a2,a2,a5
    80004662:	44dc                	lw	a5,12(s1)
    80004664:	ca1c                	sw	a5,16(a2)
    80004666:	8526                	mv	a0,s1
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	db6080e7          	jalr	-586(ra) # 8000341e <bpin>
    80004670:	0001e717          	auipc	a4,0x1e
    80004674:	8e070713          	addi	a4,a4,-1824 # 80021f50 <log>
    80004678:	575c                	lw	a5,44(a4)
    8000467a:	2785                	addiw	a5,a5,1
    8000467c:	d75c                	sw	a5,44(a4)
    8000467e:	a83d                	j	800046bc <log_write+0xd2>
    80004680:	00004517          	auipc	a0,0x4
    80004684:	07050513          	addi	a0,a0,112 # 800086f0 <syscalls+0x1f0>
    80004688:	ffffc097          	auipc	ra,0xffffc
    8000468c:	eb8080e7          	jalr	-328(ra) # 80000540 <panic>
    80004690:	00004517          	auipc	a0,0x4
    80004694:	07850513          	addi	a0,a0,120 # 80008708 <syscalls+0x208>
    80004698:	ffffc097          	auipc	ra,0xffffc
    8000469c:	ea8080e7          	jalr	-344(ra) # 80000540 <panic>
    800046a0:	4781                	li	a5,0
    800046a2:	00878713          	addi	a4,a5,8
    800046a6:	00271693          	slli	a3,a4,0x2
    800046aa:	0001e717          	auipc	a4,0x1e
    800046ae:	8a670713          	addi	a4,a4,-1882 # 80021f50 <log>
    800046b2:	9736                	add	a4,a4,a3
    800046b4:	44d4                	lw	a3,12(s1)
    800046b6:	cb14                	sw	a3,16(a4)
    800046b8:	faf607e3          	beq	a2,a5,80004666 <log_write+0x7c>
    800046bc:	0001e517          	auipc	a0,0x1e
    800046c0:	89450513          	addi	a0,a0,-1900 # 80021f50 <log>
    800046c4:	ffffc097          	auipc	ra,0xffffc
    800046c8:	5ec080e7          	jalr	1516(ra) # 80000cb0 <release>
    800046cc:	60e2                	ld	ra,24(sp)
    800046ce:	6442                	ld	s0,16(sp)
    800046d0:	64a2                	ld	s1,8(sp)
    800046d2:	6902                	ld	s2,0(sp)
    800046d4:	6105                	addi	sp,sp,32
    800046d6:	8082                	ret

00000000800046d8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800046d8:	1101                	addi	sp,sp,-32
    800046da:	ec06                	sd	ra,24(sp)
    800046dc:	e822                	sd	s0,16(sp)
    800046de:	e426                	sd	s1,8(sp)
    800046e0:	e04a                	sd	s2,0(sp)
    800046e2:	1000                	addi	s0,sp,32
    800046e4:	84aa                	mv	s1,a0
    800046e6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800046e8:	00004597          	auipc	a1,0x4
    800046ec:	04058593          	addi	a1,a1,64 # 80008728 <syscalls+0x228>
    800046f0:	0521                	addi	a0,a0,8
    800046f2:	ffffc097          	auipc	ra,0xffffc
    800046f6:	47a080e7          	jalr	1146(ra) # 80000b6c <initlock>
  lk->name = name;
    800046fa:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800046fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004702:	0204a423          	sw	zero,40(s1)
}
    80004706:	60e2                	ld	ra,24(sp)
    80004708:	6442                	ld	s0,16(sp)
    8000470a:	64a2                	ld	s1,8(sp)
    8000470c:	6902                	ld	s2,0(sp)
    8000470e:	6105                	addi	sp,sp,32
    80004710:	8082                	ret

0000000080004712 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004712:	1101                	addi	sp,sp,-32
    80004714:	ec06                	sd	ra,24(sp)
    80004716:	e822                	sd	s0,16(sp)
    80004718:	e426                	sd	s1,8(sp)
    8000471a:	e04a                	sd	s2,0(sp)
    8000471c:	1000                	addi	s0,sp,32
    8000471e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004720:	00850913          	addi	s2,a0,8
    80004724:	854a                	mv	a0,s2
    80004726:	ffffc097          	auipc	ra,0xffffc
    8000472a:	4d6080e7          	jalr	1238(ra) # 80000bfc <acquire>
  while (lk->locked) {
    8000472e:	409c                	lw	a5,0(s1)
    80004730:	cb89                	beqz	a5,80004742 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004732:	85ca                	mv	a1,s2
    80004734:	8526                	mv	a0,s1
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	e88080e7          	jalr	-376(ra) # 800025be <sleep>
  while (lk->locked) {
    8000473e:	409c                	lw	a5,0(s1)
    80004740:	fbed                	bnez	a5,80004732 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004742:	4785                	li	a5,1
    80004744:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004746:	ffffd097          	auipc	ra,0xffffd
    8000474a:	682080e7          	jalr	1666(ra) # 80001dc8 <myproc>
    8000474e:	5d1c                	lw	a5,56(a0)
    80004750:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004752:	854a                	mv	a0,s2
    80004754:	ffffc097          	auipc	ra,0xffffc
    80004758:	55c080e7          	jalr	1372(ra) # 80000cb0 <release>
}
    8000475c:	60e2                	ld	ra,24(sp)
    8000475e:	6442                	ld	s0,16(sp)
    80004760:	64a2                	ld	s1,8(sp)
    80004762:	6902                	ld	s2,0(sp)
    80004764:	6105                	addi	sp,sp,32
    80004766:	8082                	ret

0000000080004768 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004768:	1101                	addi	sp,sp,-32
    8000476a:	ec06                	sd	ra,24(sp)
    8000476c:	e822                	sd	s0,16(sp)
    8000476e:	e426                	sd	s1,8(sp)
    80004770:	e04a                	sd	s2,0(sp)
    80004772:	1000                	addi	s0,sp,32
    80004774:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004776:	00850913          	addi	s2,a0,8
    8000477a:	854a                	mv	a0,s2
    8000477c:	ffffc097          	auipc	ra,0xffffc
    80004780:	480080e7          	jalr	1152(ra) # 80000bfc <acquire>
  lk->locked = 0;
    80004784:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004788:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000478c:	8526                	mv	a0,s1
    8000478e:	ffffe097          	auipc	ra,0xffffe
    80004792:	fb0080e7          	jalr	-80(ra) # 8000273e <wakeup>
  release(&lk->lk);
    80004796:	854a                	mv	a0,s2
    80004798:	ffffc097          	auipc	ra,0xffffc
    8000479c:	518080e7          	jalr	1304(ra) # 80000cb0 <release>
}
    800047a0:	60e2                	ld	ra,24(sp)
    800047a2:	6442                	ld	s0,16(sp)
    800047a4:	64a2                	ld	s1,8(sp)
    800047a6:	6902                	ld	s2,0(sp)
    800047a8:	6105                	addi	sp,sp,32
    800047aa:	8082                	ret

00000000800047ac <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800047ac:	7179                	addi	sp,sp,-48
    800047ae:	f406                	sd	ra,40(sp)
    800047b0:	f022                	sd	s0,32(sp)
    800047b2:	ec26                	sd	s1,24(sp)
    800047b4:	e84a                	sd	s2,16(sp)
    800047b6:	e44e                	sd	s3,8(sp)
    800047b8:	1800                	addi	s0,sp,48
    800047ba:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800047bc:	00850913          	addi	s2,a0,8
    800047c0:	854a                	mv	a0,s2
    800047c2:	ffffc097          	auipc	ra,0xffffc
    800047c6:	43a080e7          	jalr	1082(ra) # 80000bfc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800047ca:	409c                	lw	a5,0(s1)
    800047cc:	ef99                	bnez	a5,800047ea <holdingsleep+0x3e>
    800047ce:	4481                	li	s1,0
  release(&lk->lk);
    800047d0:	854a                	mv	a0,s2
    800047d2:	ffffc097          	auipc	ra,0xffffc
    800047d6:	4de080e7          	jalr	1246(ra) # 80000cb0 <release>
  return r;
}
    800047da:	8526                	mv	a0,s1
    800047dc:	70a2                	ld	ra,40(sp)
    800047de:	7402                	ld	s0,32(sp)
    800047e0:	64e2                	ld	s1,24(sp)
    800047e2:	6942                	ld	s2,16(sp)
    800047e4:	69a2                	ld	s3,8(sp)
    800047e6:	6145                	addi	sp,sp,48
    800047e8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800047ea:	0284a983          	lw	s3,40(s1)
    800047ee:	ffffd097          	auipc	ra,0xffffd
    800047f2:	5da080e7          	jalr	1498(ra) # 80001dc8 <myproc>
    800047f6:	5d04                	lw	s1,56(a0)
    800047f8:	413484b3          	sub	s1,s1,s3
    800047fc:	0014b493          	seqz	s1,s1
    80004800:	bfc1                	j	800047d0 <holdingsleep+0x24>

0000000080004802 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004802:	1141                	addi	sp,sp,-16
    80004804:	e406                	sd	ra,8(sp)
    80004806:	e022                	sd	s0,0(sp)
    80004808:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000480a:	00004597          	auipc	a1,0x4
    8000480e:	f2e58593          	addi	a1,a1,-210 # 80008738 <syscalls+0x238>
    80004812:	0001e517          	auipc	a0,0x1e
    80004816:	88650513          	addi	a0,a0,-1914 # 80022098 <ftable>
    8000481a:	ffffc097          	auipc	ra,0xffffc
    8000481e:	352080e7          	jalr	850(ra) # 80000b6c <initlock>
}
    80004822:	60a2                	ld	ra,8(sp)
    80004824:	6402                	ld	s0,0(sp)
    80004826:	0141                	addi	sp,sp,16
    80004828:	8082                	ret

000000008000482a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000482a:	1101                	addi	sp,sp,-32
    8000482c:	ec06                	sd	ra,24(sp)
    8000482e:	e822                	sd	s0,16(sp)
    80004830:	e426                	sd	s1,8(sp)
    80004832:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004834:	0001e517          	auipc	a0,0x1e
    80004838:	86450513          	addi	a0,a0,-1948 # 80022098 <ftable>
    8000483c:	ffffc097          	auipc	ra,0xffffc
    80004840:	3c0080e7          	jalr	960(ra) # 80000bfc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004844:	0001e497          	auipc	s1,0x1e
    80004848:	86c48493          	addi	s1,s1,-1940 # 800220b0 <ftable+0x18>
    8000484c:	0001f717          	auipc	a4,0x1f
    80004850:	80470713          	addi	a4,a4,-2044 # 80023050 <ftable+0xfb8>
    if(f->ref == 0){
    80004854:	40dc                	lw	a5,4(s1)
    80004856:	cf99                	beqz	a5,80004874 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004858:	02848493          	addi	s1,s1,40
    8000485c:	fee49ce3          	bne	s1,a4,80004854 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004860:	0001e517          	auipc	a0,0x1e
    80004864:	83850513          	addi	a0,a0,-1992 # 80022098 <ftable>
    80004868:	ffffc097          	auipc	ra,0xffffc
    8000486c:	448080e7          	jalr	1096(ra) # 80000cb0 <release>
  return 0;
    80004870:	4481                	li	s1,0
    80004872:	a819                	j	80004888 <filealloc+0x5e>
      f->ref = 1;
    80004874:	4785                	li	a5,1
    80004876:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004878:	0001e517          	auipc	a0,0x1e
    8000487c:	82050513          	addi	a0,a0,-2016 # 80022098 <ftable>
    80004880:	ffffc097          	auipc	ra,0xffffc
    80004884:	430080e7          	jalr	1072(ra) # 80000cb0 <release>
}
    80004888:	8526                	mv	a0,s1
    8000488a:	60e2                	ld	ra,24(sp)
    8000488c:	6442                	ld	s0,16(sp)
    8000488e:	64a2                	ld	s1,8(sp)
    80004890:	6105                	addi	sp,sp,32
    80004892:	8082                	ret

0000000080004894 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004894:	1101                	addi	sp,sp,-32
    80004896:	ec06                	sd	ra,24(sp)
    80004898:	e822                	sd	s0,16(sp)
    8000489a:	e426                	sd	s1,8(sp)
    8000489c:	1000                	addi	s0,sp,32
    8000489e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800048a0:	0001d517          	auipc	a0,0x1d
    800048a4:	7f850513          	addi	a0,a0,2040 # 80022098 <ftable>
    800048a8:	ffffc097          	auipc	ra,0xffffc
    800048ac:	354080e7          	jalr	852(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    800048b0:	40dc                	lw	a5,4(s1)
    800048b2:	02f05263          	blez	a5,800048d6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800048b6:	2785                	addiw	a5,a5,1
    800048b8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800048ba:	0001d517          	auipc	a0,0x1d
    800048be:	7de50513          	addi	a0,a0,2014 # 80022098 <ftable>
    800048c2:	ffffc097          	auipc	ra,0xffffc
    800048c6:	3ee080e7          	jalr	1006(ra) # 80000cb0 <release>
  return f;
}
    800048ca:	8526                	mv	a0,s1
    800048cc:	60e2                	ld	ra,24(sp)
    800048ce:	6442                	ld	s0,16(sp)
    800048d0:	64a2                	ld	s1,8(sp)
    800048d2:	6105                	addi	sp,sp,32
    800048d4:	8082                	ret
    panic("filedup");
    800048d6:	00004517          	auipc	a0,0x4
    800048da:	e6a50513          	addi	a0,a0,-406 # 80008740 <syscalls+0x240>
    800048de:	ffffc097          	auipc	ra,0xffffc
    800048e2:	c62080e7          	jalr	-926(ra) # 80000540 <panic>

00000000800048e6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800048e6:	7139                	addi	sp,sp,-64
    800048e8:	fc06                	sd	ra,56(sp)
    800048ea:	f822                	sd	s0,48(sp)
    800048ec:	f426                	sd	s1,40(sp)
    800048ee:	f04a                	sd	s2,32(sp)
    800048f0:	ec4e                	sd	s3,24(sp)
    800048f2:	e852                	sd	s4,16(sp)
    800048f4:	e456                	sd	s5,8(sp)
    800048f6:	0080                	addi	s0,sp,64
    800048f8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800048fa:	0001d517          	auipc	a0,0x1d
    800048fe:	79e50513          	addi	a0,a0,1950 # 80022098 <ftable>
    80004902:	ffffc097          	auipc	ra,0xffffc
    80004906:	2fa080e7          	jalr	762(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    8000490a:	40dc                	lw	a5,4(s1)
    8000490c:	06f05163          	blez	a5,8000496e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004910:	37fd                	addiw	a5,a5,-1
    80004912:	0007871b          	sext.w	a4,a5
    80004916:	c0dc                	sw	a5,4(s1)
    80004918:	06e04363          	bgtz	a4,8000497e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000491c:	0004a903          	lw	s2,0(s1)
    80004920:	0094ca83          	lbu	s5,9(s1)
    80004924:	0104ba03          	ld	s4,16(s1)
    80004928:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000492c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004930:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004934:	0001d517          	auipc	a0,0x1d
    80004938:	76450513          	addi	a0,a0,1892 # 80022098 <ftable>
    8000493c:	ffffc097          	auipc	ra,0xffffc
    80004940:	374080e7          	jalr	884(ra) # 80000cb0 <release>

  if(ff.type == FD_PIPE){
    80004944:	4785                	li	a5,1
    80004946:	04f90d63          	beq	s2,a5,800049a0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000494a:	3979                	addiw	s2,s2,-2
    8000494c:	4785                	li	a5,1
    8000494e:	0527e063          	bltu	a5,s2,8000498e <fileclose+0xa8>
    begin_op();
    80004952:	00000097          	auipc	ra,0x0
    80004956:	ac2080e7          	jalr	-1342(ra) # 80004414 <begin_op>
    iput(ff.ip);
    8000495a:	854e                	mv	a0,s3
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	2b2080e7          	jalr	690(ra) # 80003c0e <iput>
    end_op();
    80004964:	00000097          	auipc	ra,0x0
    80004968:	b30080e7          	jalr	-1232(ra) # 80004494 <end_op>
    8000496c:	a00d                	j	8000498e <fileclose+0xa8>
    panic("fileclose");
    8000496e:	00004517          	auipc	a0,0x4
    80004972:	dda50513          	addi	a0,a0,-550 # 80008748 <syscalls+0x248>
    80004976:	ffffc097          	auipc	ra,0xffffc
    8000497a:	bca080e7          	jalr	-1078(ra) # 80000540 <panic>
    release(&ftable.lock);
    8000497e:	0001d517          	auipc	a0,0x1d
    80004982:	71a50513          	addi	a0,a0,1818 # 80022098 <ftable>
    80004986:	ffffc097          	auipc	ra,0xffffc
    8000498a:	32a080e7          	jalr	810(ra) # 80000cb0 <release>
  }
}
    8000498e:	70e2                	ld	ra,56(sp)
    80004990:	7442                	ld	s0,48(sp)
    80004992:	74a2                	ld	s1,40(sp)
    80004994:	7902                	ld	s2,32(sp)
    80004996:	69e2                	ld	s3,24(sp)
    80004998:	6a42                	ld	s4,16(sp)
    8000499a:	6aa2                	ld	s5,8(sp)
    8000499c:	6121                	addi	sp,sp,64
    8000499e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800049a0:	85d6                	mv	a1,s5
    800049a2:	8552                	mv	a0,s4
    800049a4:	00000097          	auipc	ra,0x0
    800049a8:	372080e7          	jalr	882(ra) # 80004d16 <pipeclose>
    800049ac:	b7cd                	j	8000498e <fileclose+0xa8>

00000000800049ae <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800049ae:	715d                	addi	sp,sp,-80
    800049b0:	e486                	sd	ra,72(sp)
    800049b2:	e0a2                	sd	s0,64(sp)
    800049b4:	fc26                	sd	s1,56(sp)
    800049b6:	f84a                	sd	s2,48(sp)
    800049b8:	f44e                	sd	s3,40(sp)
    800049ba:	0880                	addi	s0,sp,80
    800049bc:	84aa                	mv	s1,a0
    800049be:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800049c0:	ffffd097          	auipc	ra,0xffffd
    800049c4:	408080e7          	jalr	1032(ra) # 80001dc8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800049c8:	409c                	lw	a5,0(s1)
    800049ca:	37f9                	addiw	a5,a5,-2
    800049cc:	4705                	li	a4,1
    800049ce:	04f76763          	bltu	a4,a5,80004a1c <filestat+0x6e>
    800049d2:	892a                	mv	s2,a0
    ilock(f->ip);
    800049d4:	6c88                	ld	a0,24(s1)
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	07e080e7          	jalr	126(ra) # 80003a54 <ilock>
    stati(f->ip, &st);
    800049de:	fb840593          	addi	a1,s0,-72
    800049e2:	6c88                	ld	a0,24(s1)
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	2fa080e7          	jalr	762(ra) # 80003cde <stati>
    iunlock(f->ip);
    800049ec:	6c88                	ld	a0,24(s1)
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	128080e7          	jalr	296(ra) # 80003b16 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800049f6:	46e1                	li	a3,24
    800049f8:	fb840613          	addi	a2,s0,-72
    800049fc:	85ce                	mv	a1,s3
    800049fe:	05093503          	ld	a0,80(s2)
    80004a02:	ffffd097          	auipc	ra,0xffffd
    80004a06:	ca8080e7          	jalr	-856(ra) # 800016aa <copyout>
    80004a0a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004a0e:	60a6                	ld	ra,72(sp)
    80004a10:	6406                	ld	s0,64(sp)
    80004a12:	74e2                	ld	s1,56(sp)
    80004a14:	7942                	ld	s2,48(sp)
    80004a16:	79a2                	ld	s3,40(sp)
    80004a18:	6161                	addi	sp,sp,80
    80004a1a:	8082                	ret
  return -1;
    80004a1c:	557d                	li	a0,-1
    80004a1e:	bfc5                	j	80004a0e <filestat+0x60>

0000000080004a20 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004a20:	7179                	addi	sp,sp,-48
    80004a22:	f406                	sd	ra,40(sp)
    80004a24:	f022                	sd	s0,32(sp)
    80004a26:	ec26                	sd	s1,24(sp)
    80004a28:	e84a                	sd	s2,16(sp)
    80004a2a:	e44e                	sd	s3,8(sp)
    80004a2c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004a2e:	00854783          	lbu	a5,8(a0)
    80004a32:	c3d5                	beqz	a5,80004ad6 <fileread+0xb6>
    80004a34:	84aa                	mv	s1,a0
    80004a36:	89ae                	mv	s3,a1
    80004a38:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a3a:	411c                	lw	a5,0(a0)
    80004a3c:	4705                	li	a4,1
    80004a3e:	04e78963          	beq	a5,a4,80004a90 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a42:	470d                	li	a4,3
    80004a44:	04e78d63          	beq	a5,a4,80004a9e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a48:	4709                	li	a4,2
    80004a4a:	06e79e63          	bne	a5,a4,80004ac6 <fileread+0xa6>
    ilock(f->ip);
    80004a4e:	6d08                	ld	a0,24(a0)
    80004a50:	fffff097          	auipc	ra,0xfffff
    80004a54:	004080e7          	jalr	4(ra) # 80003a54 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004a58:	874a                	mv	a4,s2
    80004a5a:	5094                	lw	a3,32(s1)
    80004a5c:	864e                	mv	a2,s3
    80004a5e:	4585                	li	a1,1
    80004a60:	6c88                	ld	a0,24(s1)
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	2a6080e7          	jalr	678(ra) # 80003d08 <readi>
    80004a6a:	892a                	mv	s2,a0
    80004a6c:	00a05563          	blez	a0,80004a76 <fileread+0x56>
      f->off += r;
    80004a70:	509c                	lw	a5,32(s1)
    80004a72:	9fa9                	addw	a5,a5,a0
    80004a74:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004a76:	6c88                	ld	a0,24(s1)
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	09e080e7          	jalr	158(ra) # 80003b16 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004a80:	854a                	mv	a0,s2
    80004a82:	70a2                	ld	ra,40(sp)
    80004a84:	7402                	ld	s0,32(sp)
    80004a86:	64e2                	ld	s1,24(sp)
    80004a88:	6942                	ld	s2,16(sp)
    80004a8a:	69a2                	ld	s3,8(sp)
    80004a8c:	6145                	addi	sp,sp,48
    80004a8e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004a90:	6908                	ld	a0,16(a0)
    80004a92:	00000097          	auipc	ra,0x0
    80004a96:	3f4080e7          	jalr	1012(ra) # 80004e86 <piperead>
    80004a9a:	892a                	mv	s2,a0
    80004a9c:	b7d5                	j	80004a80 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004a9e:	02451783          	lh	a5,36(a0)
    80004aa2:	03079693          	slli	a3,a5,0x30
    80004aa6:	92c1                	srli	a3,a3,0x30
    80004aa8:	4725                	li	a4,9
    80004aaa:	02d76863          	bltu	a4,a3,80004ada <fileread+0xba>
    80004aae:	0792                	slli	a5,a5,0x4
    80004ab0:	0001d717          	auipc	a4,0x1d
    80004ab4:	54870713          	addi	a4,a4,1352 # 80021ff8 <devsw>
    80004ab8:	97ba                	add	a5,a5,a4
    80004aba:	639c                	ld	a5,0(a5)
    80004abc:	c38d                	beqz	a5,80004ade <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004abe:	4505                	li	a0,1
    80004ac0:	9782                	jalr	a5
    80004ac2:	892a                	mv	s2,a0
    80004ac4:	bf75                	j	80004a80 <fileread+0x60>
    panic("fileread");
    80004ac6:	00004517          	auipc	a0,0x4
    80004aca:	c9250513          	addi	a0,a0,-878 # 80008758 <syscalls+0x258>
    80004ace:	ffffc097          	auipc	ra,0xffffc
    80004ad2:	a72080e7          	jalr	-1422(ra) # 80000540 <panic>
    return -1;
    80004ad6:	597d                	li	s2,-1
    80004ad8:	b765                	j	80004a80 <fileread+0x60>
      return -1;
    80004ada:	597d                	li	s2,-1
    80004adc:	b755                	j	80004a80 <fileread+0x60>
    80004ade:	597d                	li	s2,-1
    80004ae0:	b745                	j	80004a80 <fileread+0x60>

0000000080004ae2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004ae2:	00954783          	lbu	a5,9(a0)
    80004ae6:	14078563          	beqz	a5,80004c30 <filewrite+0x14e>
{
    80004aea:	715d                	addi	sp,sp,-80
    80004aec:	e486                	sd	ra,72(sp)
    80004aee:	e0a2                	sd	s0,64(sp)
    80004af0:	fc26                	sd	s1,56(sp)
    80004af2:	f84a                	sd	s2,48(sp)
    80004af4:	f44e                	sd	s3,40(sp)
    80004af6:	f052                	sd	s4,32(sp)
    80004af8:	ec56                	sd	s5,24(sp)
    80004afa:	e85a                	sd	s6,16(sp)
    80004afc:	e45e                	sd	s7,8(sp)
    80004afe:	e062                	sd	s8,0(sp)
    80004b00:	0880                	addi	s0,sp,80
    80004b02:	892a                	mv	s2,a0
    80004b04:	8aae                	mv	s5,a1
    80004b06:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b08:	411c                	lw	a5,0(a0)
    80004b0a:	4705                	li	a4,1
    80004b0c:	02e78263          	beq	a5,a4,80004b30 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b10:	470d                	li	a4,3
    80004b12:	02e78563          	beq	a5,a4,80004b3c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b16:	4709                	li	a4,2
    80004b18:	10e79463          	bne	a5,a4,80004c20 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004b1c:	0ec05e63          	blez	a2,80004c18 <filewrite+0x136>
    int i = 0;
    80004b20:	4981                	li	s3,0
    80004b22:	6b05                	lui	s6,0x1
    80004b24:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004b28:	6b85                	lui	s7,0x1
    80004b2a:	c00b8b9b          	addiw	s7,s7,-1024
    80004b2e:	a851                	j	80004bc2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004b30:	6908                	ld	a0,16(a0)
    80004b32:	00000097          	auipc	ra,0x0
    80004b36:	254080e7          	jalr	596(ra) # 80004d86 <pipewrite>
    80004b3a:	a85d                	j	80004bf0 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004b3c:	02451783          	lh	a5,36(a0)
    80004b40:	03079693          	slli	a3,a5,0x30
    80004b44:	92c1                	srli	a3,a3,0x30
    80004b46:	4725                	li	a4,9
    80004b48:	0ed76663          	bltu	a4,a3,80004c34 <filewrite+0x152>
    80004b4c:	0792                	slli	a5,a5,0x4
    80004b4e:	0001d717          	auipc	a4,0x1d
    80004b52:	4aa70713          	addi	a4,a4,1194 # 80021ff8 <devsw>
    80004b56:	97ba                	add	a5,a5,a4
    80004b58:	679c                	ld	a5,8(a5)
    80004b5a:	cff9                	beqz	a5,80004c38 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004b5c:	4505                	li	a0,1
    80004b5e:	9782                	jalr	a5
    80004b60:	a841                	j	80004bf0 <filewrite+0x10e>
    80004b62:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004b66:	00000097          	auipc	ra,0x0
    80004b6a:	8ae080e7          	jalr	-1874(ra) # 80004414 <begin_op>
      ilock(f->ip);
    80004b6e:	01893503          	ld	a0,24(s2)
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	ee2080e7          	jalr	-286(ra) # 80003a54 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004b7a:	8762                	mv	a4,s8
    80004b7c:	02092683          	lw	a3,32(s2)
    80004b80:	01598633          	add	a2,s3,s5
    80004b84:	4585                	li	a1,1
    80004b86:	01893503          	ld	a0,24(s2)
    80004b8a:	fffff097          	auipc	ra,0xfffff
    80004b8e:	274080e7          	jalr	628(ra) # 80003dfe <writei>
    80004b92:	84aa                	mv	s1,a0
    80004b94:	02a05f63          	blez	a0,80004bd2 <filewrite+0xf0>
        f->off += r;
    80004b98:	02092783          	lw	a5,32(s2)
    80004b9c:	9fa9                	addw	a5,a5,a0
    80004b9e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004ba2:	01893503          	ld	a0,24(s2)
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	f70080e7          	jalr	-144(ra) # 80003b16 <iunlock>
      end_op();
    80004bae:	00000097          	auipc	ra,0x0
    80004bb2:	8e6080e7          	jalr	-1818(ra) # 80004494 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004bb6:	049c1963          	bne	s8,s1,80004c08 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004bba:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004bbe:	0349d663          	bge	s3,s4,80004bea <filewrite+0x108>
      int n1 = n - i;
    80004bc2:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004bc6:	84be                	mv	s1,a5
    80004bc8:	2781                	sext.w	a5,a5
    80004bca:	f8fb5ce3          	bge	s6,a5,80004b62 <filewrite+0x80>
    80004bce:	84de                	mv	s1,s7
    80004bd0:	bf49                	j	80004b62 <filewrite+0x80>
      iunlock(f->ip);
    80004bd2:	01893503          	ld	a0,24(s2)
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	f40080e7          	jalr	-192(ra) # 80003b16 <iunlock>
      end_op();
    80004bde:	00000097          	auipc	ra,0x0
    80004be2:	8b6080e7          	jalr	-1866(ra) # 80004494 <end_op>
      if(r < 0)
    80004be6:	fc04d8e3          	bgez	s1,80004bb6 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004bea:	8552                	mv	a0,s4
    80004bec:	033a1863          	bne	s4,s3,80004c1c <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004bf0:	60a6                	ld	ra,72(sp)
    80004bf2:	6406                	ld	s0,64(sp)
    80004bf4:	74e2                	ld	s1,56(sp)
    80004bf6:	7942                	ld	s2,48(sp)
    80004bf8:	79a2                	ld	s3,40(sp)
    80004bfa:	7a02                	ld	s4,32(sp)
    80004bfc:	6ae2                	ld	s5,24(sp)
    80004bfe:	6b42                	ld	s6,16(sp)
    80004c00:	6ba2                	ld	s7,8(sp)
    80004c02:	6c02                	ld	s8,0(sp)
    80004c04:	6161                	addi	sp,sp,80
    80004c06:	8082                	ret
        panic("short filewrite");
    80004c08:	00004517          	auipc	a0,0x4
    80004c0c:	b6050513          	addi	a0,a0,-1184 # 80008768 <syscalls+0x268>
    80004c10:	ffffc097          	auipc	ra,0xffffc
    80004c14:	930080e7          	jalr	-1744(ra) # 80000540 <panic>
    int i = 0;
    80004c18:	4981                	li	s3,0
    80004c1a:	bfc1                	j	80004bea <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004c1c:	557d                	li	a0,-1
    80004c1e:	bfc9                	j	80004bf0 <filewrite+0x10e>
    panic("filewrite");
    80004c20:	00004517          	auipc	a0,0x4
    80004c24:	b5850513          	addi	a0,a0,-1192 # 80008778 <syscalls+0x278>
    80004c28:	ffffc097          	auipc	ra,0xffffc
    80004c2c:	918080e7          	jalr	-1768(ra) # 80000540 <panic>
    return -1;
    80004c30:	557d                	li	a0,-1
}
    80004c32:	8082                	ret
      return -1;
    80004c34:	557d                	li	a0,-1
    80004c36:	bf6d                	j	80004bf0 <filewrite+0x10e>
    80004c38:	557d                	li	a0,-1
    80004c3a:	bf5d                	j	80004bf0 <filewrite+0x10e>

0000000080004c3c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004c3c:	7179                	addi	sp,sp,-48
    80004c3e:	f406                	sd	ra,40(sp)
    80004c40:	f022                	sd	s0,32(sp)
    80004c42:	ec26                	sd	s1,24(sp)
    80004c44:	e84a                	sd	s2,16(sp)
    80004c46:	e44e                	sd	s3,8(sp)
    80004c48:	e052                	sd	s4,0(sp)
    80004c4a:	1800                	addi	s0,sp,48
    80004c4c:	84aa                	mv	s1,a0
    80004c4e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004c50:	0005b023          	sd	zero,0(a1)
    80004c54:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004c58:	00000097          	auipc	ra,0x0
    80004c5c:	bd2080e7          	jalr	-1070(ra) # 8000482a <filealloc>
    80004c60:	e088                	sd	a0,0(s1)
    80004c62:	c551                	beqz	a0,80004cee <pipealloc+0xb2>
    80004c64:	00000097          	auipc	ra,0x0
    80004c68:	bc6080e7          	jalr	-1082(ra) # 8000482a <filealloc>
    80004c6c:	00aa3023          	sd	a0,0(s4)
    80004c70:	c92d                	beqz	a0,80004ce2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004c72:	ffffc097          	auipc	ra,0xffffc
    80004c76:	e9a080e7          	jalr	-358(ra) # 80000b0c <kalloc>
    80004c7a:	892a                	mv	s2,a0
    80004c7c:	c125                	beqz	a0,80004cdc <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004c7e:	4985                	li	s3,1
    80004c80:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004c84:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004c88:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004c8c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004c90:	00004597          	auipc	a1,0x4
    80004c94:	af858593          	addi	a1,a1,-1288 # 80008788 <syscalls+0x288>
    80004c98:	ffffc097          	auipc	ra,0xffffc
    80004c9c:	ed4080e7          	jalr	-300(ra) # 80000b6c <initlock>
  (*f0)->type = FD_PIPE;
    80004ca0:	609c                	ld	a5,0(s1)
    80004ca2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ca6:	609c                	ld	a5,0(s1)
    80004ca8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004cac:	609c                	ld	a5,0(s1)
    80004cae:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004cb2:	609c                	ld	a5,0(s1)
    80004cb4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004cb8:	000a3783          	ld	a5,0(s4)
    80004cbc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004cc0:	000a3783          	ld	a5,0(s4)
    80004cc4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004cc8:	000a3783          	ld	a5,0(s4)
    80004ccc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004cd0:	000a3783          	ld	a5,0(s4)
    80004cd4:	0127b823          	sd	s2,16(a5)
  return 0;
    80004cd8:	4501                	li	a0,0
    80004cda:	a025                	j	80004d02 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004cdc:	6088                	ld	a0,0(s1)
    80004cde:	e501                	bnez	a0,80004ce6 <pipealloc+0xaa>
    80004ce0:	a039                	j	80004cee <pipealloc+0xb2>
    80004ce2:	6088                	ld	a0,0(s1)
    80004ce4:	c51d                	beqz	a0,80004d12 <pipealloc+0xd6>
    fileclose(*f0);
    80004ce6:	00000097          	auipc	ra,0x0
    80004cea:	c00080e7          	jalr	-1024(ra) # 800048e6 <fileclose>
  if(*f1)
    80004cee:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004cf2:	557d                	li	a0,-1
  if(*f1)
    80004cf4:	c799                	beqz	a5,80004d02 <pipealloc+0xc6>
    fileclose(*f1);
    80004cf6:	853e                	mv	a0,a5
    80004cf8:	00000097          	auipc	ra,0x0
    80004cfc:	bee080e7          	jalr	-1042(ra) # 800048e6 <fileclose>
  return -1;
    80004d00:	557d                	li	a0,-1
}
    80004d02:	70a2                	ld	ra,40(sp)
    80004d04:	7402                	ld	s0,32(sp)
    80004d06:	64e2                	ld	s1,24(sp)
    80004d08:	6942                	ld	s2,16(sp)
    80004d0a:	69a2                	ld	s3,8(sp)
    80004d0c:	6a02                	ld	s4,0(sp)
    80004d0e:	6145                	addi	sp,sp,48
    80004d10:	8082                	ret
  return -1;
    80004d12:	557d                	li	a0,-1
    80004d14:	b7fd                	j	80004d02 <pipealloc+0xc6>

0000000080004d16 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004d16:	1101                	addi	sp,sp,-32
    80004d18:	ec06                	sd	ra,24(sp)
    80004d1a:	e822                	sd	s0,16(sp)
    80004d1c:	e426                	sd	s1,8(sp)
    80004d1e:	e04a                	sd	s2,0(sp)
    80004d20:	1000                	addi	s0,sp,32
    80004d22:	84aa                	mv	s1,a0
    80004d24:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004d26:	ffffc097          	auipc	ra,0xffffc
    80004d2a:	ed6080e7          	jalr	-298(ra) # 80000bfc <acquire>
  if(writable){
    80004d2e:	02090d63          	beqz	s2,80004d68 <pipeclose+0x52>
    pi->writeopen = 0;
    80004d32:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004d36:	21848513          	addi	a0,s1,536
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	a04080e7          	jalr	-1532(ra) # 8000273e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004d42:	2204b783          	ld	a5,544(s1)
    80004d46:	eb95                	bnez	a5,80004d7a <pipeclose+0x64>
    release(&pi->lock);
    80004d48:	8526                	mv	a0,s1
    80004d4a:	ffffc097          	auipc	ra,0xffffc
    80004d4e:	f66080e7          	jalr	-154(ra) # 80000cb0 <release>
    kfree((char*)pi);
    80004d52:	8526                	mv	a0,s1
    80004d54:	ffffc097          	auipc	ra,0xffffc
    80004d58:	cbc080e7          	jalr	-836(ra) # 80000a10 <kfree>
  } else
    release(&pi->lock);
}
    80004d5c:	60e2                	ld	ra,24(sp)
    80004d5e:	6442                	ld	s0,16(sp)
    80004d60:	64a2                	ld	s1,8(sp)
    80004d62:	6902                	ld	s2,0(sp)
    80004d64:	6105                	addi	sp,sp,32
    80004d66:	8082                	ret
    pi->readopen = 0;
    80004d68:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004d6c:	21c48513          	addi	a0,s1,540
    80004d70:	ffffe097          	auipc	ra,0xffffe
    80004d74:	9ce080e7          	jalr	-1586(ra) # 8000273e <wakeup>
    80004d78:	b7e9                	j	80004d42 <pipeclose+0x2c>
    release(&pi->lock);
    80004d7a:	8526                	mv	a0,s1
    80004d7c:	ffffc097          	auipc	ra,0xffffc
    80004d80:	f34080e7          	jalr	-204(ra) # 80000cb0 <release>
}
    80004d84:	bfe1                	j	80004d5c <pipeclose+0x46>

0000000080004d86 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004d86:	711d                	addi	sp,sp,-96
    80004d88:	ec86                	sd	ra,88(sp)
    80004d8a:	e8a2                	sd	s0,80(sp)
    80004d8c:	e4a6                	sd	s1,72(sp)
    80004d8e:	e0ca                	sd	s2,64(sp)
    80004d90:	fc4e                	sd	s3,56(sp)
    80004d92:	f852                	sd	s4,48(sp)
    80004d94:	f456                	sd	s5,40(sp)
    80004d96:	f05a                	sd	s6,32(sp)
    80004d98:	ec5e                	sd	s7,24(sp)
    80004d9a:	e862                	sd	s8,16(sp)
    80004d9c:	1080                	addi	s0,sp,96
    80004d9e:	84aa                	mv	s1,a0
    80004da0:	8b2e                	mv	s6,a1
    80004da2:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004da4:	ffffd097          	auipc	ra,0xffffd
    80004da8:	024080e7          	jalr	36(ra) # 80001dc8 <myproc>
    80004dac:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004dae:	8526                	mv	a0,s1
    80004db0:	ffffc097          	auipc	ra,0xffffc
    80004db4:	e4c080e7          	jalr	-436(ra) # 80000bfc <acquire>
  for(i = 0; i < n; i++){
    80004db8:	09505763          	blez	s5,80004e46 <pipewrite+0xc0>
    80004dbc:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004dbe:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004dc2:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004dc6:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004dc8:	2184a783          	lw	a5,536(s1)
    80004dcc:	21c4a703          	lw	a4,540(s1)
    80004dd0:	2007879b          	addiw	a5,a5,512
    80004dd4:	02f71b63          	bne	a4,a5,80004e0a <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    80004dd8:	2204a783          	lw	a5,544(s1)
    80004ddc:	c3d1                	beqz	a5,80004e60 <pipewrite+0xda>
    80004dde:	03092783          	lw	a5,48(s2)
    80004de2:	efbd                	bnez	a5,80004e60 <pipewrite+0xda>
      wakeup(&pi->nread);
    80004de4:	8552                	mv	a0,s4
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	958080e7          	jalr	-1704(ra) # 8000273e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004dee:	85a6                	mv	a1,s1
    80004df0:	854e                	mv	a0,s3
    80004df2:	ffffd097          	auipc	ra,0xffffd
    80004df6:	7cc080e7          	jalr	1996(ra) # 800025be <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004dfa:	2184a783          	lw	a5,536(s1)
    80004dfe:	21c4a703          	lw	a4,540(s1)
    80004e02:	2007879b          	addiw	a5,a5,512
    80004e06:	fcf709e3          	beq	a4,a5,80004dd8 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e0a:	4685                	li	a3,1
    80004e0c:	865a                	mv	a2,s6
    80004e0e:	faf40593          	addi	a1,s0,-81
    80004e12:	05093503          	ld	a0,80(s2)
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	920080e7          	jalr	-1760(ra) # 80001736 <copyin>
    80004e1e:	03850563          	beq	a0,s8,80004e48 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004e22:	21c4a783          	lw	a5,540(s1)
    80004e26:	0017871b          	addiw	a4,a5,1
    80004e2a:	20e4ae23          	sw	a4,540(s1)
    80004e2e:	1ff7f793          	andi	a5,a5,511
    80004e32:	97a6                	add	a5,a5,s1
    80004e34:	faf44703          	lbu	a4,-81(s0)
    80004e38:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004e3c:	2b85                	addiw	s7,s7,1
    80004e3e:	0b05                	addi	s6,s6,1
    80004e40:	f97a94e3          	bne	s5,s7,80004dc8 <pipewrite+0x42>
    80004e44:	a011                	j	80004e48 <pipewrite+0xc2>
    80004e46:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    80004e48:	21848513          	addi	a0,s1,536
    80004e4c:	ffffe097          	auipc	ra,0xffffe
    80004e50:	8f2080e7          	jalr	-1806(ra) # 8000273e <wakeup>
  release(&pi->lock);
    80004e54:	8526                	mv	a0,s1
    80004e56:	ffffc097          	auipc	ra,0xffffc
    80004e5a:	e5a080e7          	jalr	-422(ra) # 80000cb0 <release>
  return i;
    80004e5e:	a039                	j	80004e6c <pipewrite+0xe6>
        release(&pi->lock);
    80004e60:	8526                	mv	a0,s1
    80004e62:	ffffc097          	auipc	ra,0xffffc
    80004e66:	e4e080e7          	jalr	-434(ra) # 80000cb0 <release>
        return -1;
    80004e6a:	5bfd                	li	s7,-1
}
    80004e6c:	855e                	mv	a0,s7
    80004e6e:	60e6                	ld	ra,88(sp)
    80004e70:	6446                	ld	s0,80(sp)
    80004e72:	64a6                	ld	s1,72(sp)
    80004e74:	6906                	ld	s2,64(sp)
    80004e76:	79e2                	ld	s3,56(sp)
    80004e78:	7a42                	ld	s4,48(sp)
    80004e7a:	7aa2                	ld	s5,40(sp)
    80004e7c:	7b02                	ld	s6,32(sp)
    80004e7e:	6be2                	ld	s7,24(sp)
    80004e80:	6c42                	ld	s8,16(sp)
    80004e82:	6125                	addi	sp,sp,96
    80004e84:	8082                	ret

0000000080004e86 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004e86:	715d                	addi	sp,sp,-80
    80004e88:	e486                	sd	ra,72(sp)
    80004e8a:	e0a2                	sd	s0,64(sp)
    80004e8c:	fc26                	sd	s1,56(sp)
    80004e8e:	f84a                	sd	s2,48(sp)
    80004e90:	f44e                	sd	s3,40(sp)
    80004e92:	f052                	sd	s4,32(sp)
    80004e94:	ec56                	sd	s5,24(sp)
    80004e96:	e85a                	sd	s6,16(sp)
    80004e98:	0880                	addi	s0,sp,80
    80004e9a:	84aa                	mv	s1,a0
    80004e9c:	892e                	mv	s2,a1
    80004e9e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004ea0:	ffffd097          	auipc	ra,0xffffd
    80004ea4:	f28080e7          	jalr	-216(ra) # 80001dc8 <myproc>
    80004ea8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004eaa:	8526                	mv	a0,s1
    80004eac:	ffffc097          	auipc	ra,0xffffc
    80004eb0:	d50080e7          	jalr	-688(ra) # 80000bfc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004eb4:	2184a703          	lw	a4,536(s1)
    80004eb8:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004ebc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ec0:	02f71463          	bne	a4,a5,80004ee8 <piperead+0x62>
    80004ec4:	2244a783          	lw	a5,548(s1)
    80004ec8:	c385                	beqz	a5,80004ee8 <piperead+0x62>
    if(pr->killed){
    80004eca:	030a2783          	lw	a5,48(s4)
    80004ece:	ebc1                	bnez	a5,80004f5e <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004ed0:	85a6                	mv	a1,s1
    80004ed2:	854e                	mv	a0,s3
    80004ed4:	ffffd097          	auipc	ra,0xffffd
    80004ed8:	6ea080e7          	jalr	1770(ra) # 800025be <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004edc:	2184a703          	lw	a4,536(s1)
    80004ee0:	21c4a783          	lw	a5,540(s1)
    80004ee4:	fef700e3          	beq	a4,a5,80004ec4 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ee8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004eea:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004eec:	05505363          	blez	s5,80004f32 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004ef0:	2184a783          	lw	a5,536(s1)
    80004ef4:	21c4a703          	lw	a4,540(s1)
    80004ef8:	02f70d63          	beq	a4,a5,80004f32 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004efc:	0017871b          	addiw	a4,a5,1
    80004f00:	20e4ac23          	sw	a4,536(s1)
    80004f04:	1ff7f793          	andi	a5,a5,511
    80004f08:	97a6                	add	a5,a5,s1
    80004f0a:	0187c783          	lbu	a5,24(a5)
    80004f0e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f12:	4685                	li	a3,1
    80004f14:	fbf40613          	addi	a2,s0,-65
    80004f18:	85ca                	mv	a1,s2
    80004f1a:	050a3503          	ld	a0,80(s4)
    80004f1e:	ffffc097          	auipc	ra,0xffffc
    80004f22:	78c080e7          	jalr	1932(ra) # 800016aa <copyout>
    80004f26:	01650663          	beq	a0,s6,80004f32 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f2a:	2985                	addiw	s3,s3,1
    80004f2c:	0905                	addi	s2,s2,1
    80004f2e:	fd3a91e3          	bne	s5,s3,80004ef0 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004f32:	21c48513          	addi	a0,s1,540
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	808080e7          	jalr	-2040(ra) # 8000273e <wakeup>
  release(&pi->lock);
    80004f3e:	8526                	mv	a0,s1
    80004f40:	ffffc097          	auipc	ra,0xffffc
    80004f44:	d70080e7          	jalr	-656(ra) # 80000cb0 <release>
  return i;
}
    80004f48:	854e                	mv	a0,s3
    80004f4a:	60a6                	ld	ra,72(sp)
    80004f4c:	6406                	ld	s0,64(sp)
    80004f4e:	74e2                	ld	s1,56(sp)
    80004f50:	7942                	ld	s2,48(sp)
    80004f52:	79a2                	ld	s3,40(sp)
    80004f54:	7a02                	ld	s4,32(sp)
    80004f56:	6ae2                	ld	s5,24(sp)
    80004f58:	6b42                	ld	s6,16(sp)
    80004f5a:	6161                	addi	sp,sp,80
    80004f5c:	8082                	ret
      release(&pi->lock);
    80004f5e:	8526                	mv	a0,s1
    80004f60:	ffffc097          	auipc	ra,0xffffc
    80004f64:	d50080e7          	jalr	-688(ra) # 80000cb0 <release>
      return -1;
    80004f68:	59fd                	li	s3,-1
    80004f6a:	bff9                	j	80004f48 <piperead+0xc2>

0000000080004f6c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004f6c:	de010113          	addi	sp,sp,-544
    80004f70:	20113c23          	sd	ra,536(sp)
    80004f74:	20813823          	sd	s0,528(sp)
    80004f78:	20913423          	sd	s1,520(sp)
    80004f7c:	21213023          	sd	s2,512(sp)
    80004f80:	ffce                	sd	s3,504(sp)
    80004f82:	fbd2                	sd	s4,496(sp)
    80004f84:	f7d6                	sd	s5,488(sp)
    80004f86:	f3da                	sd	s6,480(sp)
    80004f88:	efde                	sd	s7,472(sp)
    80004f8a:	ebe2                	sd	s8,464(sp)
    80004f8c:	e7e6                	sd	s9,456(sp)
    80004f8e:	e3ea                	sd	s10,448(sp)
    80004f90:	ff6e                	sd	s11,440(sp)
    80004f92:	1400                	addi	s0,sp,544
    80004f94:	892a                	mv	s2,a0
    80004f96:	dea43423          	sd	a0,-536(s0)
    80004f9a:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004f9e:	ffffd097          	auipc	ra,0xffffd
    80004fa2:	e2a080e7          	jalr	-470(ra) # 80001dc8 <myproc>
    80004fa6:	84aa                	mv	s1,a0

  begin_op();
    80004fa8:	fffff097          	auipc	ra,0xfffff
    80004fac:	46c080e7          	jalr	1132(ra) # 80004414 <begin_op>

  if((ip = namei(path)) == 0){
    80004fb0:	854a                	mv	a0,s2
    80004fb2:	fffff097          	auipc	ra,0xfffff
    80004fb6:	252080e7          	jalr	594(ra) # 80004204 <namei>
    80004fba:	c93d                	beqz	a0,80005030 <exec+0xc4>
    80004fbc:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004fbe:	fffff097          	auipc	ra,0xfffff
    80004fc2:	a96080e7          	jalr	-1386(ra) # 80003a54 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004fc6:	04000713          	li	a4,64
    80004fca:	4681                	li	a3,0
    80004fcc:	e4840613          	addi	a2,s0,-440
    80004fd0:	4581                	li	a1,0
    80004fd2:	8556                	mv	a0,s5
    80004fd4:	fffff097          	auipc	ra,0xfffff
    80004fd8:	d34080e7          	jalr	-716(ra) # 80003d08 <readi>
    80004fdc:	04000793          	li	a5,64
    80004fe0:	00f51a63          	bne	a0,a5,80004ff4 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004fe4:	e4842703          	lw	a4,-440(s0)
    80004fe8:	464c47b7          	lui	a5,0x464c4
    80004fec:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ff0:	04f70663          	beq	a4,a5,8000503c <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004ff4:	8556                	mv	a0,s5
    80004ff6:	fffff097          	auipc	ra,0xfffff
    80004ffa:	cc0080e7          	jalr	-832(ra) # 80003cb6 <iunlockput>
    end_op();
    80004ffe:	fffff097          	auipc	ra,0xfffff
    80005002:	496080e7          	jalr	1174(ra) # 80004494 <end_op>
  }
  return -1;
    80005006:	557d                	li	a0,-1
}
    80005008:	21813083          	ld	ra,536(sp)
    8000500c:	21013403          	ld	s0,528(sp)
    80005010:	20813483          	ld	s1,520(sp)
    80005014:	20013903          	ld	s2,512(sp)
    80005018:	79fe                	ld	s3,504(sp)
    8000501a:	7a5e                	ld	s4,496(sp)
    8000501c:	7abe                	ld	s5,488(sp)
    8000501e:	7b1e                	ld	s6,480(sp)
    80005020:	6bfe                	ld	s7,472(sp)
    80005022:	6c5e                	ld	s8,464(sp)
    80005024:	6cbe                	ld	s9,456(sp)
    80005026:	6d1e                	ld	s10,448(sp)
    80005028:	7dfa                	ld	s11,440(sp)
    8000502a:	22010113          	addi	sp,sp,544
    8000502e:	8082                	ret
    end_op();
    80005030:	fffff097          	auipc	ra,0xfffff
    80005034:	464080e7          	jalr	1124(ra) # 80004494 <end_op>
    return -1;
    80005038:	557d                	li	a0,-1
    8000503a:	b7f9                	j	80005008 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000503c:	8526                	mv	a0,s1
    8000503e:	ffffd097          	auipc	ra,0xffffd
    80005042:	e4e080e7          	jalr	-434(ra) # 80001e8c <proc_pagetable>
    80005046:	8b2a                	mv	s6,a0
    80005048:	d555                	beqz	a0,80004ff4 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000504a:	e6842783          	lw	a5,-408(s0)
    8000504e:	e8045703          	lhu	a4,-384(s0)
    80005052:	c735                	beqz	a4,800050be <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005054:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005056:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000505a:	6a05                	lui	s4,0x1
    8000505c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005060:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80005064:	6d85                	lui	s11,0x1
    80005066:	7d7d                	lui	s10,0xfffff
    80005068:	ac1d                	j	8000529e <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000506a:	00003517          	auipc	a0,0x3
    8000506e:	72650513          	addi	a0,a0,1830 # 80008790 <syscalls+0x290>
    80005072:	ffffb097          	auipc	ra,0xffffb
    80005076:	4ce080e7          	jalr	1230(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000507a:	874a                	mv	a4,s2
    8000507c:	009c86bb          	addw	a3,s9,s1
    80005080:	4581                	li	a1,0
    80005082:	8556                	mv	a0,s5
    80005084:	fffff097          	auipc	ra,0xfffff
    80005088:	c84080e7          	jalr	-892(ra) # 80003d08 <readi>
    8000508c:	2501                	sext.w	a0,a0
    8000508e:	1aa91863          	bne	s2,a0,8000523e <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80005092:	009d84bb          	addw	s1,s11,s1
    80005096:	013d09bb          	addw	s3,s10,s3
    8000509a:	1f74f263          	bgeu	s1,s7,8000527e <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000509e:	02049593          	slli	a1,s1,0x20
    800050a2:	9181                	srli	a1,a1,0x20
    800050a4:	95e2                	add	a1,a1,s8
    800050a6:	855a                	mv	a0,s6
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	fce080e7          	jalr	-50(ra) # 80001076 <walkaddr>
    800050b0:	862a                	mv	a2,a0
    if(pa == 0)
    800050b2:	dd45                	beqz	a0,8000506a <exec+0xfe>
      n = PGSIZE;
    800050b4:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800050b6:	fd49f2e3          	bgeu	s3,s4,8000507a <exec+0x10e>
      n = sz - i;
    800050ba:	894e                	mv	s2,s3
    800050bc:	bf7d                	j	8000507a <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    800050be:	4481                	li	s1,0
  iunlockput(ip);
    800050c0:	8556                	mv	a0,s5
    800050c2:	fffff097          	auipc	ra,0xfffff
    800050c6:	bf4080e7          	jalr	-1036(ra) # 80003cb6 <iunlockput>
  end_op();
    800050ca:	fffff097          	auipc	ra,0xfffff
    800050ce:	3ca080e7          	jalr	970(ra) # 80004494 <end_op>
  p = myproc();
    800050d2:	ffffd097          	auipc	ra,0xffffd
    800050d6:	cf6080e7          	jalr	-778(ra) # 80001dc8 <myproc>
    800050da:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800050dc:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800050e0:	6785                	lui	a5,0x1
    800050e2:	17fd                	addi	a5,a5,-1
    800050e4:	94be                	add	s1,s1,a5
    800050e6:	77fd                	lui	a5,0xfffff
    800050e8:	8fe5                	and	a5,a5,s1
    800050ea:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800050ee:	6609                	lui	a2,0x2
    800050f0:	963e                	add	a2,a2,a5
    800050f2:	85be                	mv	a1,a5
    800050f4:	855a                	mv	a0,s6
    800050f6:	ffffc097          	auipc	ra,0xffffc
    800050fa:	364080e7          	jalr	868(ra) # 8000145a <uvmalloc>
    800050fe:	8c2a                	mv	s8,a0
  ip = 0;
    80005100:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005102:	12050e63          	beqz	a0,8000523e <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005106:	75f9                	lui	a1,0xffffe
    80005108:	95aa                	add	a1,a1,a0
    8000510a:	855a                	mv	a0,s6
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	56c080e7          	jalr	1388(ra) # 80001678 <uvmclear>
  stackbase = sp - PGSIZE;
    80005114:	7afd                	lui	s5,0xfffff
    80005116:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005118:	df043783          	ld	a5,-528(s0)
    8000511c:	6388                	ld	a0,0(a5)
    8000511e:	c925                	beqz	a0,8000518e <exec+0x222>
    80005120:	e8840993          	addi	s3,s0,-376
    80005124:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80005128:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000512a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000512c:	ffffc097          	auipc	ra,0xffffc
    80005130:	d50080e7          	jalr	-688(ra) # 80000e7c <strlen>
    80005134:	0015079b          	addiw	a5,a0,1
    80005138:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000513c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005140:	13596363          	bltu	s2,s5,80005266 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005144:	df043d83          	ld	s11,-528(s0)
    80005148:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000514c:	8552                	mv	a0,s4
    8000514e:	ffffc097          	auipc	ra,0xffffc
    80005152:	d2e080e7          	jalr	-722(ra) # 80000e7c <strlen>
    80005156:	0015069b          	addiw	a3,a0,1
    8000515a:	8652                	mv	a2,s4
    8000515c:	85ca                	mv	a1,s2
    8000515e:	855a                	mv	a0,s6
    80005160:	ffffc097          	auipc	ra,0xffffc
    80005164:	54a080e7          	jalr	1354(ra) # 800016aa <copyout>
    80005168:	10054363          	bltz	a0,8000526e <exec+0x302>
    ustack[argc] = sp;
    8000516c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005170:	0485                	addi	s1,s1,1
    80005172:	008d8793          	addi	a5,s11,8
    80005176:	def43823          	sd	a5,-528(s0)
    8000517a:	008db503          	ld	a0,8(s11)
    8000517e:	c911                	beqz	a0,80005192 <exec+0x226>
    if(argc >= MAXARG)
    80005180:	09a1                	addi	s3,s3,8
    80005182:	fb3c95e3          	bne	s9,s3,8000512c <exec+0x1c0>
  sz = sz1;
    80005186:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000518a:	4a81                	li	s5,0
    8000518c:	a84d                	j	8000523e <exec+0x2d2>
  sp = sz;
    8000518e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005190:	4481                	li	s1,0
  ustack[argc] = 0;
    80005192:	00349793          	slli	a5,s1,0x3
    80005196:	f9040713          	addi	a4,s0,-112
    8000519a:	97ba                	add	a5,a5,a4
    8000519c:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd7ef8>
  sp -= (argc+1) * sizeof(uint64);
    800051a0:	00148693          	addi	a3,s1,1
    800051a4:	068e                	slli	a3,a3,0x3
    800051a6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800051aa:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800051ae:	01597663          	bgeu	s2,s5,800051ba <exec+0x24e>
  sz = sz1;
    800051b2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051b6:	4a81                	li	s5,0
    800051b8:	a059                	j	8000523e <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800051ba:	e8840613          	addi	a2,s0,-376
    800051be:	85ca                	mv	a1,s2
    800051c0:	855a                	mv	a0,s6
    800051c2:	ffffc097          	auipc	ra,0xffffc
    800051c6:	4e8080e7          	jalr	1256(ra) # 800016aa <copyout>
    800051ca:	0a054663          	bltz	a0,80005276 <exec+0x30a>
  p->trapframe->a1 = sp;
    800051ce:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800051d2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800051d6:	de843783          	ld	a5,-536(s0)
    800051da:	0007c703          	lbu	a4,0(a5)
    800051de:	cf11                	beqz	a4,800051fa <exec+0x28e>
    800051e0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800051e2:	02f00693          	li	a3,47
    800051e6:	a039                	j	800051f4 <exec+0x288>
      last = s+1;
    800051e8:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800051ec:	0785                	addi	a5,a5,1
    800051ee:	fff7c703          	lbu	a4,-1(a5)
    800051f2:	c701                	beqz	a4,800051fa <exec+0x28e>
    if(*s == '/')
    800051f4:	fed71ce3          	bne	a4,a3,800051ec <exec+0x280>
    800051f8:	bfc5                	j	800051e8 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800051fa:	4641                	li	a2,16
    800051fc:	de843583          	ld	a1,-536(s0)
    80005200:	158b8513          	addi	a0,s7,344
    80005204:	ffffc097          	auipc	ra,0xffffc
    80005208:	c46080e7          	jalr	-954(ra) # 80000e4a <safestrcpy>
  oldpagetable = p->pagetable;
    8000520c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005210:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005214:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005218:	058bb783          	ld	a5,88(s7)
    8000521c:	e6043703          	ld	a4,-416(s0)
    80005220:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005222:	058bb783          	ld	a5,88(s7)
    80005226:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000522a:	85ea                	mv	a1,s10
    8000522c:	ffffd097          	auipc	ra,0xffffd
    80005230:	cfc080e7          	jalr	-772(ra) # 80001f28 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005234:	0004851b          	sext.w	a0,s1
    80005238:	bbc1                	j	80005008 <exec+0x9c>
    8000523a:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000523e:	df843583          	ld	a1,-520(s0)
    80005242:	855a                	mv	a0,s6
    80005244:	ffffd097          	auipc	ra,0xffffd
    80005248:	ce4080e7          	jalr	-796(ra) # 80001f28 <proc_freepagetable>
  if(ip){
    8000524c:	da0a94e3          	bnez	s5,80004ff4 <exec+0x88>
  return -1;
    80005250:	557d                	li	a0,-1
    80005252:	bb5d                	j	80005008 <exec+0x9c>
    80005254:	de943c23          	sd	s1,-520(s0)
    80005258:	b7dd                	j	8000523e <exec+0x2d2>
    8000525a:	de943c23          	sd	s1,-520(s0)
    8000525e:	b7c5                	j	8000523e <exec+0x2d2>
    80005260:	de943c23          	sd	s1,-520(s0)
    80005264:	bfe9                	j	8000523e <exec+0x2d2>
  sz = sz1;
    80005266:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000526a:	4a81                	li	s5,0
    8000526c:	bfc9                	j	8000523e <exec+0x2d2>
  sz = sz1;
    8000526e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005272:	4a81                	li	s5,0
    80005274:	b7e9                	j	8000523e <exec+0x2d2>
  sz = sz1;
    80005276:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000527a:	4a81                	li	s5,0
    8000527c:	b7c9                	j	8000523e <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000527e:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005282:	e0843783          	ld	a5,-504(s0)
    80005286:	0017869b          	addiw	a3,a5,1
    8000528a:	e0d43423          	sd	a3,-504(s0)
    8000528e:	e0043783          	ld	a5,-512(s0)
    80005292:	0387879b          	addiw	a5,a5,56
    80005296:	e8045703          	lhu	a4,-384(s0)
    8000529a:	e2e6d3e3          	bge	a3,a4,800050c0 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000529e:	2781                	sext.w	a5,a5
    800052a0:	e0f43023          	sd	a5,-512(s0)
    800052a4:	03800713          	li	a4,56
    800052a8:	86be                	mv	a3,a5
    800052aa:	e1040613          	addi	a2,s0,-496
    800052ae:	4581                	li	a1,0
    800052b0:	8556                	mv	a0,s5
    800052b2:	fffff097          	auipc	ra,0xfffff
    800052b6:	a56080e7          	jalr	-1450(ra) # 80003d08 <readi>
    800052ba:	03800793          	li	a5,56
    800052be:	f6f51ee3          	bne	a0,a5,8000523a <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800052c2:	e1042783          	lw	a5,-496(s0)
    800052c6:	4705                	li	a4,1
    800052c8:	fae79de3          	bne	a5,a4,80005282 <exec+0x316>
    if(ph.memsz < ph.filesz)
    800052cc:	e3843603          	ld	a2,-456(s0)
    800052d0:	e3043783          	ld	a5,-464(s0)
    800052d4:	f8f660e3          	bltu	a2,a5,80005254 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800052d8:	e2043783          	ld	a5,-480(s0)
    800052dc:	963e                	add	a2,a2,a5
    800052de:	f6f66ee3          	bltu	a2,a5,8000525a <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800052e2:	85a6                	mv	a1,s1
    800052e4:	855a                	mv	a0,s6
    800052e6:	ffffc097          	auipc	ra,0xffffc
    800052ea:	174080e7          	jalr	372(ra) # 8000145a <uvmalloc>
    800052ee:	dea43c23          	sd	a0,-520(s0)
    800052f2:	d53d                	beqz	a0,80005260 <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    800052f4:	e2043c03          	ld	s8,-480(s0)
    800052f8:	de043783          	ld	a5,-544(s0)
    800052fc:	00fc77b3          	and	a5,s8,a5
    80005300:	ff9d                	bnez	a5,8000523e <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005302:	e1842c83          	lw	s9,-488(s0)
    80005306:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000530a:	f60b8ae3          	beqz	s7,8000527e <exec+0x312>
    8000530e:	89de                	mv	s3,s7
    80005310:	4481                	li	s1,0
    80005312:	b371                	j	8000509e <exec+0x132>

0000000080005314 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005314:	7179                	addi	sp,sp,-48
    80005316:	f406                	sd	ra,40(sp)
    80005318:	f022                	sd	s0,32(sp)
    8000531a:	ec26                	sd	s1,24(sp)
    8000531c:	e84a                	sd	s2,16(sp)
    8000531e:	1800                	addi	s0,sp,48
    80005320:	892e                	mv	s2,a1
    80005322:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005324:	fdc40593          	addi	a1,s0,-36
    80005328:	ffffe097          	auipc	ra,0xffffe
    8000532c:	b74080e7          	jalr	-1164(ra) # 80002e9c <argint>
    80005330:	04054063          	bltz	a0,80005370 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005334:	fdc42703          	lw	a4,-36(s0)
    80005338:	47bd                	li	a5,15
    8000533a:	02e7ed63          	bltu	a5,a4,80005374 <argfd+0x60>
    8000533e:	ffffd097          	auipc	ra,0xffffd
    80005342:	a8a080e7          	jalr	-1398(ra) # 80001dc8 <myproc>
    80005346:	fdc42703          	lw	a4,-36(s0)
    8000534a:	01a70793          	addi	a5,a4,26
    8000534e:	078e                	slli	a5,a5,0x3
    80005350:	953e                	add	a0,a0,a5
    80005352:	611c                	ld	a5,0(a0)
    80005354:	c395                	beqz	a5,80005378 <argfd+0x64>
    return -1;
  if(pfd)
    80005356:	00090463          	beqz	s2,8000535e <argfd+0x4a>
    *pfd = fd;
    8000535a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000535e:	4501                	li	a0,0
  if(pf)
    80005360:	c091                	beqz	s1,80005364 <argfd+0x50>
    *pf = f;
    80005362:	e09c                	sd	a5,0(s1)
}
    80005364:	70a2                	ld	ra,40(sp)
    80005366:	7402                	ld	s0,32(sp)
    80005368:	64e2                	ld	s1,24(sp)
    8000536a:	6942                	ld	s2,16(sp)
    8000536c:	6145                	addi	sp,sp,48
    8000536e:	8082                	ret
    return -1;
    80005370:	557d                	li	a0,-1
    80005372:	bfcd                	j	80005364 <argfd+0x50>
    return -1;
    80005374:	557d                	li	a0,-1
    80005376:	b7fd                	j	80005364 <argfd+0x50>
    80005378:	557d                	li	a0,-1
    8000537a:	b7ed                	j	80005364 <argfd+0x50>

000000008000537c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000537c:	1101                	addi	sp,sp,-32
    8000537e:	ec06                	sd	ra,24(sp)
    80005380:	e822                	sd	s0,16(sp)
    80005382:	e426                	sd	s1,8(sp)
    80005384:	1000                	addi	s0,sp,32
    80005386:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005388:	ffffd097          	auipc	ra,0xffffd
    8000538c:	a40080e7          	jalr	-1472(ra) # 80001dc8 <myproc>
    80005390:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005392:	0d050793          	addi	a5,a0,208
    80005396:	4501                	li	a0,0
    80005398:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000539a:	6398                	ld	a4,0(a5)
    8000539c:	cb19                	beqz	a4,800053b2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000539e:	2505                	addiw	a0,a0,1
    800053a0:	07a1                	addi	a5,a5,8
    800053a2:	fed51ce3          	bne	a0,a3,8000539a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800053a6:	557d                	li	a0,-1
}
    800053a8:	60e2                	ld	ra,24(sp)
    800053aa:	6442                	ld	s0,16(sp)
    800053ac:	64a2                	ld	s1,8(sp)
    800053ae:	6105                	addi	sp,sp,32
    800053b0:	8082                	ret
      p->ofile[fd] = f;
    800053b2:	01a50793          	addi	a5,a0,26
    800053b6:	078e                	slli	a5,a5,0x3
    800053b8:	963e                	add	a2,a2,a5
    800053ba:	e204                	sd	s1,0(a2)
      return fd;
    800053bc:	b7f5                	j	800053a8 <fdalloc+0x2c>

00000000800053be <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800053be:	715d                	addi	sp,sp,-80
    800053c0:	e486                	sd	ra,72(sp)
    800053c2:	e0a2                	sd	s0,64(sp)
    800053c4:	fc26                	sd	s1,56(sp)
    800053c6:	f84a                	sd	s2,48(sp)
    800053c8:	f44e                	sd	s3,40(sp)
    800053ca:	f052                	sd	s4,32(sp)
    800053cc:	ec56                	sd	s5,24(sp)
    800053ce:	0880                	addi	s0,sp,80
    800053d0:	89ae                	mv	s3,a1
    800053d2:	8ab2                	mv	s5,a2
    800053d4:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800053d6:	fb040593          	addi	a1,s0,-80
    800053da:	fffff097          	auipc	ra,0xfffff
    800053de:	e48080e7          	jalr	-440(ra) # 80004222 <nameiparent>
    800053e2:	892a                	mv	s2,a0
    800053e4:	12050e63          	beqz	a0,80005520 <create+0x162>
    return 0;

  ilock(dp);
    800053e8:	ffffe097          	auipc	ra,0xffffe
    800053ec:	66c080e7          	jalr	1644(ra) # 80003a54 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800053f0:	4601                	li	a2,0
    800053f2:	fb040593          	addi	a1,s0,-80
    800053f6:	854a                	mv	a0,s2
    800053f8:	fffff097          	auipc	ra,0xfffff
    800053fc:	b3a080e7          	jalr	-1222(ra) # 80003f32 <dirlookup>
    80005400:	84aa                	mv	s1,a0
    80005402:	c921                	beqz	a0,80005452 <create+0x94>
    iunlockput(dp);
    80005404:	854a                	mv	a0,s2
    80005406:	fffff097          	auipc	ra,0xfffff
    8000540a:	8b0080e7          	jalr	-1872(ra) # 80003cb6 <iunlockput>
    ilock(ip);
    8000540e:	8526                	mv	a0,s1
    80005410:	ffffe097          	auipc	ra,0xffffe
    80005414:	644080e7          	jalr	1604(ra) # 80003a54 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005418:	2981                	sext.w	s3,s3
    8000541a:	4789                	li	a5,2
    8000541c:	02f99463          	bne	s3,a5,80005444 <create+0x86>
    80005420:	0444d783          	lhu	a5,68(s1)
    80005424:	37f9                	addiw	a5,a5,-2
    80005426:	17c2                	slli	a5,a5,0x30
    80005428:	93c1                	srli	a5,a5,0x30
    8000542a:	4705                	li	a4,1
    8000542c:	00f76c63          	bltu	a4,a5,80005444 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005430:	8526                	mv	a0,s1
    80005432:	60a6                	ld	ra,72(sp)
    80005434:	6406                	ld	s0,64(sp)
    80005436:	74e2                	ld	s1,56(sp)
    80005438:	7942                	ld	s2,48(sp)
    8000543a:	79a2                	ld	s3,40(sp)
    8000543c:	7a02                	ld	s4,32(sp)
    8000543e:	6ae2                	ld	s5,24(sp)
    80005440:	6161                	addi	sp,sp,80
    80005442:	8082                	ret
    iunlockput(ip);
    80005444:	8526                	mv	a0,s1
    80005446:	fffff097          	auipc	ra,0xfffff
    8000544a:	870080e7          	jalr	-1936(ra) # 80003cb6 <iunlockput>
    return 0;
    8000544e:	4481                	li	s1,0
    80005450:	b7c5                	j	80005430 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005452:	85ce                	mv	a1,s3
    80005454:	00092503          	lw	a0,0(s2)
    80005458:	ffffe097          	auipc	ra,0xffffe
    8000545c:	464080e7          	jalr	1124(ra) # 800038bc <ialloc>
    80005460:	84aa                	mv	s1,a0
    80005462:	c521                	beqz	a0,800054aa <create+0xec>
  ilock(ip);
    80005464:	ffffe097          	auipc	ra,0xffffe
    80005468:	5f0080e7          	jalr	1520(ra) # 80003a54 <ilock>
  ip->major = major;
    8000546c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005470:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005474:	4a05                	li	s4,1
    80005476:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000547a:	8526                	mv	a0,s1
    8000547c:	ffffe097          	auipc	ra,0xffffe
    80005480:	50e080e7          	jalr	1294(ra) # 8000398a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005484:	2981                	sext.w	s3,s3
    80005486:	03498a63          	beq	s3,s4,800054ba <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000548a:	40d0                	lw	a2,4(s1)
    8000548c:	fb040593          	addi	a1,s0,-80
    80005490:	854a                	mv	a0,s2
    80005492:	fffff097          	auipc	ra,0xfffff
    80005496:	cb0080e7          	jalr	-848(ra) # 80004142 <dirlink>
    8000549a:	06054b63          	bltz	a0,80005510 <create+0x152>
  iunlockput(dp);
    8000549e:	854a                	mv	a0,s2
    800054a0:	fffff097          	auipc	ra,0xfffff
    800054a4:	816080e7          	jalr	-2026(ra) # 80003cb6 <iunlockput>
  return ip;
    800054a8:	b761                	j	80005430 <create+0x72>
    panic("create: ialloc");
    800054aa:	00003517          	auipc	a0,0x3
    800054ae:	30650513          	addi	a0,a0,774 # 800087b0 <syscalls+0x2b0>
    800054b2:	ffffb097          	auipc	ra,0xffffb
    800054b6:	08e080e7          	jalr	142(ra) # 80000540 <panic>
    dp->nlink++;  // for ".."
    800054ba:	04a95783          	lhu	a5,74(s2)
    800054be:	2785                	addiw	a5,a5,1
    800054c0:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800054c4:	854a                	mv	a0,s2
    800054c6:	ffffe097          	auipc	ra,0xffffe
    800054ca:	4c4080e7          	jalr	1220(ra) # 8000398a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800054ce:	40d0                	lw	a2,4(s1)
    800054d0:	00003597          	auipc	a1,0x3
    800054d4:	2f058593          	addi	a1,a1,752 # 800087c0 <syscalls+0x2c0>
    800054d8:	8526                	mv	a0,s1
    800054da:	fffff097          	auipc	ra,0xfffff
    800054de:	c68080e7          	jalr	-920(ra) # 80004142 <dirlink>
    800054e2:	00054f63          	bltz	a0,80005500 <create+0x142>
    800054e6:	00492603          	lw	a2,4(s2)
    800054ea:	00003597          	auipc	a1,0x3
    800054ee:	2de58593          	addi	a1,a1,734 # 800087c8 <syscalls+0x2c8>
    800054f2:	8526                	mv	a0,s1
    800054f4:	fffff097          	auipc	ra,0xfffff
    800054f8:	c4e080e7          	jalr	-946(ra) # 80004142 <dirlink>
    800054fc:	f80557e3          	bgez	a0,8000548a <create+0xcc>
      panic("create dots");
    80005500:	00003517          	auipc	a0,0x3
    80005504:	2d050513          	addi	a0,a0,720 # 800087d0 <syscalls+0x2d0>
    80005508:	ffffb097          	auipc	ra,0xffffb
    8000550c:	038080e7          	jalr	56(ra) # 80000540 <panic>
    panic("create: dirlink");
    80005510:	00003517          	auipc	a0,0x3
    80005514:	2d050513          	addi	a0,a0,720 # 800087e0 <syscalls+0x2e0>
    80005518:	ffffb097          	auipc	ra,0xffffb
    8000551c:	028080e7          	jalr	40(ra) # 80000540 <panic>
    return 0;
    80005520:	84aa                	mv	s1,a0
    80005522:	b739                	j	80005430 <create+0x72>

0000000080005524 <sys_dup>:
{
    80005524:	7179                	addi	sp,sp,-48
    80005526:	f406                	sd	ra,40(sp)
    80005528:	f022                	sd	s0,32(sp)
    8000552a:	ec26                	sd	s1,24(sp)
    8000552c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000552e:	fd840613          	addi	a2,s0,-40
    80005532:	4581                	li	a1,0
    80005534:	4501                	li	a0,0
    80005536:	00000097          	auipc	ra,0x0
    8000553a:	dde080e7          	jalr	-546(ra) # 80005314 <argfd>
    return -1;
    8000553e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005540:	02054363          	bltz	a0,80005566 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005544:	fd843503          	ld	a0,-40(s0)
    80005548:	00000097          	auipc	ra,0x0
    8000554c:	e34080e7          	jalr	-460(ra) # 8000537c <fdalloc>
    80005550:	84aa                	mv	s1,a0
    return -1;
    80005552:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005554:	00054963          	bltz	a0,80005566 <sys_dup+0x42>
  filedup(f);
    80005558:	fd843503          	ld	a0,-40(s0)
    8000555c:	fffff097          	auipc	ra,0xfffff
    80005560:	338080e7          	jalr	824(ra) # 80004894 <filedup>
  return fd;
    80005564:	87a6                	mv	a5,s1
}
    80005566:	853e                	mv	a0,a5
    80005568:	70a2                	ld	ra,40(sp)
    8000556a:	7402                	ld	s0,32(sp)
    8000556c:	64e2                	ld	s1,24(sp)
    8000556e:	6145                	addi	sp,sp,48
    80005570:	8082                	ret

0000000080005572 <sys_read>:
{
    80005572:	7179                	addi	sp,sp,-48
    80005574:	f406                	sd	ra,40(sp)
    80005576:	f022                	sd	s0,32(sp)
    80005578:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000557a:	fe840613          	addi	a2,s0,-24
    8000557e:	4581                	li	a1,0
    80005580:	4501                	li	a0,0
    80005582:	00000097          	auipc	ra,0x0
    80005586:	d92080e7          	jalr	-622(ra) # 80005314 <argfd>
    return -1;
    8000558a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000558c:	04054163          	bltz	a0,800055ce <sys_read+0x5c>
    80005590:	fe440593          	addi	a1,s0,-28
    80005594:	4509                	li	a0,2
    80005596:	ffffe097          	auipc	ra,0xffffe
    8000559a:	906080e7          	jalr	-1786(ra) # 80002e9c <argint>
    return -1;
    8000559e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055a0:	02054763          	bltz	a0,800055ce <sys_read+0x5c>
    800055a4:	fd840593          	addi	a1,s0,-40
    800055a8:	4505                	li	a0,1
    800055aa:	ffffe097          	auipc	ra,0xffffe
    800055ae:	914080e7          	jalr	-1772(ra) # 80002ebe <argaddr>
    return -1;
    800055b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055b4:	00054d63          	bltz	a0,800055ce <sys_read+0x5c>
  return fileread(f, p, n);
    800055b8:	fe442603          	lw	a2,-28(s0)
    800055bc:	fd843583          	ld	a1,-40(s0)
    800055c0:	fe843503          	ld	a0,-24(s0)
    800055c4:	fffff097          	auipc	ra,0xfffff
    800055c8:	45c080e7          	jalr	1116(ra) # 80004a20 <fileread>
    800055cc:	87aa                	mv	a5,a0
}
    800055ce:	853e                	mv	a0,a5
    800055d0:	70a2                	ld	ra,40(sp)
    800055d2:	7402                	ld	s0,32(sp)
    800055d4:	6145                	addi	sp,sp,48
    800055d6:	8082                	ret

00000000800055d8 <sys_write>:
{
    800055d8:	7179                	addi	sp,sp,-48
    800055da:	f406                	sd	ra,40(sp)
    800055dc:	f022                	sd	s0,32(sp)
    800055de:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055e0:	fe840613          	addi	a2,s0,-24
    800055e4:	4581                	li	a1,0
    800055e6:	4501                	li	a0,0
    800055e8:	00000097          	auipc	ra,0x0
    800055ec:	d2c080e7          	jalr	-724(ra) # 80005314 <argfd>
    return -1;
    800055f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055f2:	04054163          	bltz	a0,80005634 <sys_write+0x5c>
    800055f6:	fe440593          	addi	a1,s0,-28
    800055fa:	4509                	li	a0,2
    800055fc:	ffffe097          	auipc	ra,0xffffe
    80005600:	8a0080e7          	jalr	-1888(ra) # 80002e9c <argint>
    return -1;
    80005604:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005606:	02054763          	bltz	a0,80005634 <sys_write+0x5c>
    8000560a:	fd840593          	addi	a1,s0,-40
    8000560e:	4505                	li	a0,1
    80005610:	ffffe097          	auipc	ra,0xffffe
    80005614:	8ae080e7          	jalr	-1874(ra) # 80002ebe <argaddr>
    return -1;
    80005618:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000561a:	00054d63          	bltz	a0,80005634 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000561e:	fe442603          	lw	a2,-28(s0)
    80005622:	fd843583          	ld	a1,-40(s0)
    80005626:	fe843503          	ld	a0,-24(s0)
    8000562a:	fffff097          	auipc	ra,0xfffff
    8000562e:	4b8080e7          	jalr	1208(ra) # 80004ae2 <filewrite>
    80005632:	87aa                	mv	a5,a0
}
    80005634:	853e                	mv	a0,a5
    80005636:	70a2                	ld	ra,40(sp)
    80005638:	7402                	ld	s0,32(sp)
    8000563a:	6145                	addi	sp,sp,48
    8000563c:	8082                	ret

000000008000563e <sys_close>:
{
    8000563e:	1101                	addi	sp,sp,-32
    80005640:	ec06                	sd	ra,24(sp)
    80005642:	e822                	sd	s0,16(sp)
    80005644:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005646:	fe040613          	addi	a2,s0,-32
    8000564a:	fec40593          	addi	a1,s0,-20
    8000564e:	4501                	li	a0,0
    80005650:	00000097          	auipc	ra,0x0
    80005654:	cc4080e7          	jalr	-828(ra) # 80005314 <argfd>
    return -1;
    80005658:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000565a:	02054463          	bltz	a0,80005682 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000565e:	ffffc097          	auipc	ra,0xffffc
    80005662:	76a080e7          	jalr	1898(ra) # 80001dc8 <myproc>
    80005666:	fec42783          	lw	a5,-20(s0)
    8000566a:	07e9                	addi	a5,a5,26
    8000566c:	078e                	slli	a5,a5,0x3
    8000566e:	97aa                	add	a5,a5,a0
    80005670:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005674:	fe043503          	ld	a0,-32(s0)
    80005678:	fffff097          	auipc	ra,0xfffff
    8000567c:	26e080e7          	jalr	622(ra) # 800048e6 <fileclose>
  return 0;
    80005680:	4781                	li	a5,0
}
    80005682:	853e                	mv	a0,a5
    80005684:	60e2                	ld	ra,24(sp)
    80005686:	6442                	ld	s0,16(sp)
    80005688:	6105                	addi	sp,sp,32
    8000568a:	8082                	ret

000000008000568c <sys_fstat>:
{
    8000568c:	1101                	addi	sp,sp,-32
    8000568e:	ec06                	sd	ra,24(sp)
    80005690:	e822                	sd	s0,16(sp)
    80005692:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005694:	fe840613          	addi	a2,s0,-24
    80005698:	4581                	li	a1,0
    8000569a:	4501                	li	a0,0
    8000569c:	00000097          	auipc	ra,0x0
    800056a0:	c78080e7          	jalr	-904(ra) # 80005314 <argfd>
    return -1;
    800056a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800056a6:	02054563          	bltz	a0,800056d0 <sys_fstat+0x44>
    800056aa:	fe040593          	addi	a1,s0,-32
    800056ae:	4505                	li	a0,1
    800056b0:	ffffe097          	auipc	ra,0xffffe
    800056b4:	80e080e7          	jalr	-2034(ra) # 80002ebe <argaddr>
    return -1;
    800056b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800056ba:	00054b63          	bltz	a0,800056d0 <sys_fstat+0x44>
  return filestat(f, st);
    800056be:	fe043583          	ld	a1,-32(s0)
    800056c2:	fe843503          	ld	a0,-24(s0)
    800056c6:	fffff097          	auipc	ra,0xfffff
    800056ca:	2e8080e7          	jalr	744(ra) # 800049ae <filestat>
    800056ce:	87aa                	mv	a5,a0
}
    800056d0:	853e                	mv	a0,a5
    800056d2:	60e2                	ld	ra,24(sp)
    800056d4:	6442                	ld	s0,16(sp)
    800056d6:	6105                	addi	sp,sp,32
    800056d8:	8082                	ret

00000000800056da <sys_link>:
{
    800056da:	7169                	addi	sp,sp,-304
    800056dc:	f606                	sd	ra,296(sp)
    800056de:	f222                	sd	s0,288(sp)
    800056e0:	ee26                	sd	s1,280(sp)
    800056e2:	ea4a                	sd	s2,272(sp)
    800056e4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056e6:	08000613          	li	a2,128
    800056ea:	ed040593          	addi	a1,s0,-304
    800056ee:	4501                	li	a0,0
    800056f0:	ffffd097          	auipc	ra,0xffffd
    800056f4:	7f0080e7          	jalr	2032(ra) # 80002ee0 <argstr>
    return -1;
    800056f8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056fa:	10054e63          	bltz	a0,80005816 <sys_link+0x13c>
    800056fe:	08000613          	li	a2,128
    80005702:	f5040593          	addi	a1,s0,-176
    80005706:	4505                	li	a0,1
    80005708:	ffffd097          	auipc	ra,0xffffd
    8000570c:	7d8080e7          	jalr	2008(ra) # 80002ee0 <argstr>
    return -1;
    80005710:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005712:	10054263          	bltz	a0,80005816 <sys_link+0x13c>
  begin_op();
    80005716:	fffff097          	auipc	ra,0xfffff
    8000571a:	cfe080e7          	jalr	-770(ra) # 80004414 <begin_op>
  if((ip = namei(old)) == 0){
    8000571e:	ed040513          	addi	a0,s0,-304
    80005722:	fffff097          	auipc	ra,0xfffff
    80005726:	ae2080e7          	jalr	-1310(ra) # 80004204 <namei>
    8000572a:	84aa                	mv	s1,a0
    8000572c:	c551                	beqz	a0,800057b8 <sys_link+0xde>
  ilock(ip);
    8000572e:	ffffe097          	auipc	ra,0xffffe
    80005732:	326080e7          	jalr	806(ra) # 80003a54 <ilock>
  if(ip->type == T_DIR){
    80005736:	04449703          	lh	a4,68(s1)
    8000573a:	4785                	li	a5,1
    8000573c:	08f70463          	beq	a4,a5,800057c4 <sys_link+0xea>
  ip->nlink++;
    80005740:	04a4d783          	lhu	a5,74(s1)
    80005744:	2785                	addiw	a5,a5,1
    80005746:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000574a:	8526                	mv	a0,s1
    8000574c:	ffffe097          	auipc	ra,0xffffe
    80005750:	23e080e7          	jalr	574(ra) # 8000398a <iupdate>
  iunlock(ip);
    80005754:	8526                	mv	a0,s1
    80005756:	ffffe097          	auipc	ra,0xffffe
    8000575a:	3c0080e7          	jalr	960(ra) # 80003b16 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000575e:	fd040593          	addi	a1,s0,-48
    80005762:	f5040513          	addi	a0,s0,-176
    80005766:	fffff097          	auipc	ra,0xfffff
    8000576a:	abc080e7          	jalr	-1348(ra) # 80004222 <nameiparent>
    8000576e:	892a                	mv	s2,a0
    80005770:	c935                	beqz	a0,800057e4 <sys_link+0x10a>
  ilock(dp);
    80005772:	ffffe097          	auipc	ra,0xffffe
    80005776:	2e2080e7          	jalr	738(ra) # 80003a54 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000577a:	00092703          	lw	a4,0(s2)
    8000577e:	409c                	lw	a5,0(s1)
    80005780:	04f71d63          	bne	a4,a5,800057da <sys_link+0x100>
    80005784:	40d0                	lw	a2,4(s1)
    80005786:	fd040593          	addi	a1,s0,-48
    8000578a:	854a                	mv	a0,s2
    8000578c:	fffff097          	auipc	ra,0xfffff
    80005790:	9b6080e7          	jalr	-1610(ra) # 80004142 <dirlink>
    80005794:	04054363          	bltz	a0,800057da <sys_link+0x100>
  iunlockput(dp);
    80005798:	854a                	mv	a0,s2
    8000579a:	ffffe097          	auipc	ra,0xffffe
    8000579e:	51c080e7          	jalr	1308(ra) # 80003cb6 <iunlockput>
  iput(ip);
    800057a2:	8526                	mv	a0,s1
    800057a4:	ffffe097          	auipc	ra,0xffffe
    800057a8:	46a080e7          	jalr	1130(ra) # 80003c0e <iput>
  end_op();
    800057ac:	fffff097          	auipc	ra,0xfffff
    800057b0:	ce8080e7          	jalr	-792(ra) # 80004494 <end_op>
  return 0;
    800057b4:	4781                	li	a5,0
    800057b6:	a085                	j	80005816 <sys_link+0x13c>
    end_op();
    800057b8:	fffff097          	auipc	ra,0xfffff
    800057bc:	cdc080e7          	jalr	-804(ra) # 80004494 <end_op>
    return -1;
    800057c0:	57fd                	li	a5,-1
    800057c2:	a891                	j	80005816 <sys_link+0x13c>
    iunlockput(ip);
    800057c4:	8526                	mv	a0,s1
    800057c6:	ffffe097          	auipc	ra,0xffffe
    800057ca:	4f0080e7          	jalr	1264(ra) # 80003cb6 <iunlockput>
    end_op();
    800057ce:	fffff097          	auipc	ra,0xfffff
    800057d2:	cc6080e7          	jalr	-826(ra) # 80004494 <end_op>
    return -1;
    800057d6:	57fd                	li	a5,-1
    800057d8:	a83d                	j	80005816 <sys_link+0x13c>
    iunlockput(dp);
    800057da:	854a                	mv	a0,s2
    800057dc:	ffffe097          	auipc	ra,0xffffe
    800057e0:	4da080e7          	jalr	1242(ra) # 80003cb6 <iunlockput>
  ilock(ip);
    800057e4:	8526                	mv	a0,s1
    800057e6:	ffffe097          	auipc	ra,0xffffe
    800057ea:	26e080e7          	jalr	622(ra) # 80003a54 <ilock>
  ip->nlink--;
    800057ee:	04a4d783          	lhu	a5,74(s1)
    800057f2:	37fd                	addiw	a5,a5,-1
    800057f4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057f8:	8526                	mv	a0,s1
    800057fa:	ffffe097          	auipc	ra,0xffffe
    800057fe:	190080e7          	jalr	400(ra) # 8000398a <iupdate>
  iunlockput(ip);
    80005802:	8526                	mv	a0,s1
    80005804:	ffffe097          	auipc	ra,0xffffe
    80005808:	4b2080e7          	jalr	1202(ra) # 80003cb6 <iunlockput>
  end_op();
    8000580c:	fffff097          	auipc	ra,0xfffff
    80005810:	c88080e7          	jalr	-888(ra) # 80004494 <end_op>
  return -1;
    80005814:	57fd                	li	a5,-1
}
    80005816:	853e                	mv	a0,a5
    80005818:	70b2                	ld	ra,296(sp)
    8000581a:	7412                	ld	s0,288(sp)
    8000581c:	64f2                	ld	s1,280(sp)
    8000581e:	6952                	ld	s2,272(sp)
    80005820:	6155                	addi	sp,sp,304
    80005822:	8082                	ret

0000000080005824 <sys_unlink>:
{
    80005824:	7151                	addi	sp,sp,-240
    80005826:	f586                	sd	ra,232(sp)
    80005828:	f1a2                	sd	s0,224(sp)
    8000582a:	eda6                	sd	s1,216(sp)
    8000582c:	e9ca                	sd	s2,208(sp)
    8000582e:	e5ce                	sd	s3,200(sp)
    80005830:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005832:	08000613          	li	a2,128
    80005836:	f3040593          	addi	a1,s0,-208
    8000583a:	4501                	li	a0,0
    8000583c:	ffffd097          	auipc	ra,0xffffd
    80005840:	6a4080e7          	jalr	1700(ra) # 80002ee0 <argstr>
    80005844:	18054163          	bltz	a0,800059c6 <sys_unlink+0x1a2>
  begin_op();
    80005848:	fffff097          	auipc	ra,0xfffff
    8000584c:	bcc080e7          	jalr	-1076(ra) # 80004414 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005850:	fb040593          	addi	a1,s0,-80
    80005854:	f3040513          	addi	a0,s0,-208
    80005858:	fffff097          	auipc	ra,0xfffff
    8000585c:	9ca080e7          	jalr	-1590(ra) # 80004222 <nameiparent>
    80005860:	84aa                	mv	s1,a0
    80005862:	c979                	beqz	a0,80005938 <sys_unlink+0x114>
  ilock(dp);
    80005864:	ffffe097          	auipc	ra,0xffffe
    80005868:	1f0080e7          	jalr	496(ra) # 80003a54 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000586c:	00003597          	auipc	a1,0x3
    80005870:	f5458593          	addi	a1,a1,-172 # 800087c0 <syscalls+0x2c0>
    80005874:	fb040513          	addi	a0,s0,-80
    80005878:	ffffe097          	auipc	ra,0xffffe
    8000587c:	6a0080e7          	jalr	1696(ra) # 80003f18 <namecmp>
    80005880:	14050a63          	beqz	a0,800059d4 <sys_unlink+0x1b0>
    80005884:	00003597          	auipc	a1,0x3
    80005888:	f4458593          	addi	a1,a1,-188 # 800087c8 <syscalls+0x2c8>
    8000588c:	fb040513          	addi	a0,s0,-80
    80005890:	ffffe097          	auipc	ra,0xffffe
    80005894:	688080e7          	jalr	1672(ra) # 80003f18 <namecmp>
    80005898:	12050e63          	beqz	a0,800059d4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000589c:	f2c40613          	addi	a2,s0,-212
    800058a0:	fb040593          	addi	a1,s0,-80
    800058a4:	8526                	mv	a0,s1
    800058a6:	ffffe097          	auipc	ra,0xffffe
    800058aa:	68c080e7          	jalr	1676(ra) # 80003f32 <dirlookup>
    800058ae:	892a                	mv	s2,a0
    800058b0:	12050263          	beqz	a0,800059d4 <sys_unlink+0x1b0>
  ilock(ip);
    800058b4:	ffffe097          	auipc	ra,0xffffe
    800058b8:	1a0080e7          	jalr	416(ra) # 80003a54 <ilock>
  if(ip->nlink < 1)
    800058bc:	04a91783          	lh	a5,74(s2)
    800058c0:	08f05263          	blez	a5,80005944 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800058c4:	04491703          	lh	a4,68(s2)
    800058c8:	4785                	li	a5,1
    800058ca:	08f70563          	beq	a4,a5,80005954 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800058ce:	4641                	li	a2,16
    800058d0:	4581                	li	a1,0
    800058d2:	fc040513          	addi	a0,s0,-64
    800058d6:	ffffb097          	auipc	ra,0xffffb
    800058da:	422080e7          	jalr	1058(ra) # 80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058de:	4741                	li	a4,16
    800058e0:	f2c42683          	lw	a3,-212(s0)
    800058e4:	fc040613          	addi	a2,s0,-64
    800058e8:	4581                	li	a1,0
    800058ea:	8526                	mv	a0,s1
    800058ec:	ffffe097          	auipc	ra,0xffffe
    800058f0:	512080e7          	jalr	1298(ra) # 80003dfe <writei>
    800058f4:	47c1                	li	a5,16
    800058f6:	0af51563          	bne	a0,a5,800059a0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800058fa:	04491703          	lh	a4,68(s2)
    800058fe:	4785                	li	a5,1
    80005900:	0af70863          	beq	a4,a5,800059b0 <sys_unlink+0x18c>
  iunlockput(dp);
    80005904:	8526                	mv	a0,s1
    80005906:	ffffe097          	auipc	ra,0xffffe
    8000590a:	3b0080e7          	jalr	944(ra) # 80003cb6 <iunlockput>
  ip->nlink--;
    8000590e:	04a95783          	lhu	a5,74(s2)
    80005912:	37fd                	addiw	a5,a5,-1
    80005914:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005918:	854a                	mv	a0,s2
    8000591a:	ffffe097          	auipc	ra,0xffffe
    8000591e:	070080e7          	jalr	112(ra) # 8000398a <iupdate>
  iunlockput(ip);
    80005922:	854a                	mv	a0,s2
    80005924:	ffffe097          	auipc	ra,0xffffe
    80005928:	392080e7          	jalr	914(ra) # 80003cb6 <iunlockput>
  end_op();
    8000592c:	fffff097          	auipc	ra,0xfffff
    80005930:	b68080e7          	jalr	-1176(ra) # 80004494 <end_op>
  return 0;
    80005934:	4501                	li	a0,0
    80005936:	a84d                	j	800059e8 <sys_unlink+0x1c4>
    end_op();
    80005938:	fffff097          	auipc	ra,0xfffff
    8000593c:	b5c080e7          	jalr	-1188(ra) # 80004494 <end_op>
    return -1;
    80005940:	557d                	li	a0,-1
    80005942:	a05d                	j	800059e8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005944:	00003517          	auipc	a0,0x3
    80005948:	eac50513          	addi	a0,a0,-340 # 800087f0 <syscalls+0x2f0>
    8000594c:	ffffb097          	auipc	ra,0xffffb
    80005950:	bf4080e7          	jalr	-1036(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005954:	04c92703          	lw	a4,76(s2)
    80005958:	02000793          	li	a5,32
    8000595c:	f6e7f9e3          	bgeu	a5,a4,800058ce <sys_unlink+0xaa>
    80005960:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005964:	4741                	li	a4,16
    80005966:	86ce                	mv	a3,s3
    80005968:	f1840613          	addi	a2,s0,-232
    8000596c:	4581                	li	a1,0
    8000596e:	854a                	mv	a0,s2
    80005970:	ffffe097          	auipc	ra,0xffffe
    80005974:	398080e7          	jalr	920(ra) # 80003d08 <readi>
    80005978:	47c1                	li	a5,16
    8000597a:	00f51b63          	bne	a0,a5,80005990 <sys_unlink+0x16c>
    if(de.inum != 0)
    8000597e:	f1845783          	lhu	a5,-232(s0)
    80005982:	e7a1                	bnez	a5,800059ca <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005984:	29c1                	addiw	s3,s3,16
    80005986:	04c92783          	lw	a5,76(s2)
    8000598a:	fcf9ede3          	bltu	s3,a5,80005964 <sys_unlink+0x140>
    8000598e:	b781                	j	800058ce <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005990:	00003517          	auipc	a0,0x3
    80005994:	e7850513          	addi	a0,a0,-392 # 80008808 <syscalls+0x308>
    80005998:	ffffb097          	auipc	ra,0xffffb
    8000599c:	ba8080e7          	jalr	-1112(ra) # 80000540 <panic>
    panic("unlink: writei");
    800059a0:	00003517          	auipc	a0,0x3
    800059a4:	e8050513          	addi	a0,a0,-384 # 80008820 <syscalls+0x320>
    800059a8:	ffffb097          	auipc	ra,0xffffb
    800059ac:	b98080e7          	jalr	-1128(ra) # 80000540 <panic>
    dp->nlink--;
    800059b0:	04a4d783          	lhu	a5,74(s1)
    800059b4:	37fd                	addiw	a5,a5,-1
    800059b6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800059ba:	8526                	mv	a0,s1
    800059bc:	ffffe097          	auipc	ra,0xffffe
    800059c0:	fce080e7          	jalr	-50(ra) # 8000398a <iupdate>
    800059c4:	b781                	j	80005904 <sys_unlink+0xe0>
    return -1;
    800059c6:	557d                	li	a0,-1
    800059c8:	a005                	j	800059e8 <sys_unlink+0x1c4>
    iunlockput(ip);
    800059ca:	854a                	mv	a0,s2
    800059cc:	ffffe097          	auipc	ra,0xffffe
    800059d0:	2ea080e7          	jalr	746(ra) # 80003cb6 <iunlockput>
  iunlockput(dp);
    800059d4:	8526                	mv	a0,s1
    800059d6:	ffffe097          	auipc	ra,0xffffe
    800059da:	2e0080e7          	jalr	736(ra) # 80003cb6 <iunlockput>
  end_op();
    800059de:	fffff097          	auipc	ra,0xfffff
    800059e2:	ab6080e7          	jalr	-1354(ra) # 80004494 <end_op>
  return -1;
    800059e6:	557d                	li	a0,-1
}
    800059e8:	70ae                	ld	ra,232(sp)
    800059ea:	740e                	ld	s0,224(sp)
    800059ec:	64ee                	ld	s1,216(sp)
    800059ee:	694e                	ld	s2,208(sp)
    800059f0:	69ae                	ld	s3,200(sp)
    800059f2:	616d                	addi	sp,sp,240
    800059f4:	8082                	ret

00000000800059f6 <sys_open>:

uint64
sys_open(void)
{
    800059f6:	7131                	addi	sp,sp,-192
    800059f8:	fd06                	sd	ra,184(sp)
    800059fa:	f922                	sd	s0,176(sp)
    800059fc:	f526                	sd	s1,168(sp)
    800059fe:	f14a                	sd	s2,160(sp)
    80005a00:	ed4e                	sd	s3,152(sp)
    80005a02:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a04:	08000613          	li	a2,128
    80005a08:	f5040593          	addi	a1,s0,-176
    80005a0c:	4501                	li	a0,0
    80005a0e:	ffffd097          	auipc	ra,0xffffd
    80005a12:	4d2080e7          	jalr	1234(ra) # 80002ee0 <argstr>
    return -1;
    80005a16:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a18:	0c054163          	bltz	a0,80005ada <sys_open+0xe4>
    80005a1c:	f4c40593          	addi	a1,s0,-180
    80005a20:	4505                	li	a0,1
    80005a22:	ffffd097          	auipc	ra,0xffffd
    80005a26:	47a080e7          	jalr	1146(ra) # 80002e9c <argint>
    80005a2a:	0a054863          	bltz	a0,80005ada <sys_open+0xe4>

  begin_op();
    80005a2e:	fffff097          	auipc	ra,0xfffff
    80005a32:	9e6080e7          	jalr	-1562(ra) # 80004414 <begin_op>

  if(omode & O_CREATE){
    80005a36:	f4c42783          	lw	a5,-180(s0)
    80005a3a:	2007f793          	andi	a5,a5,512
    80005a3e:	cbdd                	beqz	a5,80005af4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005a40:	4681                	li	a3,0
    80005a42:	4601                	li	a2,0
    80005a44:	4589                	li	a1,2
    80005a46:	f5040513          	addi	a0,s0,-176
    80005a4a:	00000097          	auipc	ra,0x0
    80005a4e:	974080e7          	jalr	-1676(ra) # 800053be <create>
    80005a52:	892a                	mv	s2,a0
    if(ip == 0){
    80005a54:	c959                	beqz	a0,80005aea <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005a56:	04491703          	lh	a4,68(s2)
    80005a5a:	478d                	li	a5,3
    80005a5c:	00f71763          	bne	a4,a5,80005a6a <sys_open+0x74>
    80005a60:	04695703          	lhu	a4,70(s2)
    80005a64:	47a5                	li	a5,9
    80005a66:	0ce7ec63          	bltu	a5,a4,80005b3e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005a6a:	fffff097          	auipc	ra,0xfffff
    80005a6e:	dc0080e7          	jalr	-576(ra) # 8000482a <filealloc>
    80005a72:	89aa                	mv	s3,a0
    80005a74:	10050263          	beqz	a0,80005b78 <sys_open+0x182>
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	904080e7          	jalr	-1788(ra) # 8000537c <fdalloc>
    80005a80:	84aa                	mv	s1,a0
    80005a82:	0e054663          	bltz	a0,80005b6e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005a86:	04491703          	lh	a4,68(s2)
    80005a8a:	478d                	li	a5,3
    80005a8c:	0cf70463          	beq	a4,a5,80005b54 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005a90:	4789                	li	a5,2
    80005a92:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005a96:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005a9a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005a9e:	f4c42783          	lw	a5,-180(s0)
    80005aa2:	0017c713          	xori	a4,a5,1
    80005aa6:	8b05                	andi	a4,a4,1
    80005aa8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005aac:	0037f713          	andi	a4,a5,3
    80005ab0:	00e03733          	snez	a4,a4
    80005ab4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005ab8:	4007f793          	andi	a5,a5,1024
    80005abc:	c791                	beqz	a5,80005ac8 <sys_open+0xd2>
    80005abe:	04491703          	lh	a4,68(s2)
    80005ac2:	4789                	li	a5,2
    80005ac4:	08f70f63          	beq	a4,a5,80005b62 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005ac8:	854a                	mv	a0,s2
    80005aca:	ffffe097          	auipc	ra,0xffffe
    80005ace:	04c080e7          	jalr	76(ra) # 80003b16 <iunlock>
  end_op();
    80005ad2:	fffff097          	auipc	ra,0xfffff
    80005ad6:	9c2080e7          	jalr	-1598(ra) # 80004494 <end_op>

  return fd;
}
    80005ada:	8526                	mv	a0,s1
    80005adc:	70ea                	ld	ra,184(sp)
    80005ade:	744a                	ld	s0,176(sp)
    80005ae0:	74aa                	ld	s1,168(sp)
    80005ae2:	790a                	ld	s2,160(sp)
    80005ae4:	69ea                	ld	s3,152(sp)
    80005ae6:	6129                	addi	sp,sp,192
    80005ae8:	8082                	ret
      end_op();
    80005aea:	fffff097          	auipc	ra,0xfffff
    80005aee:	9aa080e7          	jalr	-1622(ra) # 80004494 <end_op>
      return -1;
    80005af2:	b7e5                	j	80005ada <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005af4:	f5040513          	addi	a0,s0,-176
    80005af8:	ffffe097          	auipc	ra,0xffffe
    80005afc:	70c080e7          	jalr	1804(ra) # 80004204 <namei>
    80005b00:	892a                	mv	s2,a0
    80005b02:	c905                	beqz	a0,80005b32 <sys_open+0x13c>
    ilock(ip);
    80005b04:	ffffe097          	auipc	ra,0xffffe
    80005b08:	f50080e7          	jalr	-176(ra) # 80003a54 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005b0c:	04491703          	lh	a4,68(s2)
    80005b10:	4785                	li	a5,1
    80005b12:	f4f712e3          	bne	a4,a5,80005a56 <sys_open+0x60>
    80005b16:	f4c42783          	lw	a5,-180(s0)
    80005b1a:	dba1                	beqz	a5,80005a6a <sys_open+0x74>
      iunlockput(ip);
    80005b1c:	854a                	mv	a0,s2
    80005b1e:	ffffe097          	auipc	ra,0xffffe
    80005b22:	198080e7          	jalr	408(ra) # 80003cb6 <iunlockput>
      end_op();
    80005b26:	fffff097          	auipc	ra,0xfffff
    80005b2a:	96e080e7          	jalr	-1682(ra) # 80004494 <end_op>
      return -1;
    80005b2e:	54fd                	li	s1,-1
    80005b30:	b76d                	j	80005ada <sys_open+0xe4>
      end_op();
    80005b32:	fffff097          	auipc	ra,0xfffff
    80005b36:	962080e7          	jalr	-1694(ra) # 80004494 <end_op>
      return -1;
    80005b3a:	54fd                	li	s1,-1
    80005b3c:	bf79                	j	80005ada <sys_open+0xe4>
    iunlockput(ip);
    80005b3e:	854a                	mv	a0,s2
    80005b40:	ffffe097          	auipc	ra,0xffffe
    80005b44:	176080e7          	jalr	374(ra) # 80003cb6 <iunlockput>
    end_op();
    80005b48:	fffff097          	auipc	ra,0xfffff
    80005b4c:	94c080e7          	jalr	-1716(ra) # 80004494 <end_op>
    return -1;
    80005b50:	54fd                	li	s1,-1
    80005b52:	b761                	j	80005ada <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005b54:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005b58:	04691783          	lh	a5,70(s2)
    80005b5c:	02f99223          	sh	a5,36(s3)
    80005b60:	bf2d                	j	80005a9a <sys_open+0xa4>
    itrunc(ip);
    80005b62:	854a                	mv	a0,s2
    80005b64:	ffffe097          	auipc	ra,0xffffe
    80005b68:	ffe080e7          	jalr	-2(ra) # 80003b62 <itrunc>
    80005b6c:	bfb1                	j	80005ac8 <sys_open+0xd2>
      fileclose(f);
    80005b6e:	854e                	mv	a0,s3
    80005b70:	fffff097          	auipc	ra,0xfffff
    80005b74:	d76080e7          	jalr	-650(ra) # 800048e6 <fileclose>
    iunlockput(ip);
    80005b78:	854a                	mv	a0,s2
    80005b7a:	ffffe097          	auipc	ra,0xffffe
    80005b7e:	13c080e7          	jalr	316(ra) # 80003cb6 <iunlockput>
    end_op();
    80005b82:	fffff097          	auipc	ra,0xfffff
    80005b86:	912080e7          	jalr	-1774(ra) # 80004494 <end_op>
    return -1;
    80005b8a:	54fd                	li	s1,-1
    80005b8c:	b7b9                	j	80005ada <sys_open+0xe4>

0000000080005b8e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005b8e:	7175                	addi	sp,sp,-144
    80005b90:	e506                	sd	ra,136(sp)
    80005b92:	e122                	sd	s0,128(sp)
    80005b94:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005b96:	fffff097          	auipc	ra,0xfffff
    80005b9a:	87e080e7          	jalr	-1922(ra) # 80004414 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005b9e:	08000613          	li	a2,128
    80005ba2:	f7040593          	addi	a1,s0,-144
    80005ba6:	4501                	li	a0,0
    80005ba8:	ffffd097          	auipc	ra,0xffffd
    80005bac:	338080e7          	jalr	824(ra) # 80002ee0 <argstr>
    80005bb0:	02054963          	bltz	a0,80005be2 <sys_mkdir+0x54>
    80005bb4:	4681                	li	a3,0
    80005bb6:	4601                	li	a2,0
    80005bb8:	4585                	li	a1,1
    80005bba:	f7040513          	addi	a0,s0,-144
    80005bbe:	00000097          	auipc	ra,0x0
    80005bc2:	800080e7          	jalr	-2048(ra) # 800053be <create>
    80005bc6:	cd11                	beqz	a0,80005be2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005bc8:	ffffe097          	auipc	ra,0xffffe
    80005bcc:	0ee080e7          	jalr	238(ra) # 80003cb6 <iunlockput>
  end_op();
    80005bd0:	fffff097          	auipc	ra,0xfffff
    80005bd4:	8c4080e7          	jalr	-1852(ra) # 80004494 <end_op>
  return 0;
    80005bd8:	4501                	li	a0,0
}
    80005bda:	60aa                	ld	ra,136(sp)
    80005bdc:	640a                	ld	s0,128(sp)
    80005bde:	6149                	addi	sp,sp,144
    80005be0:	8082                	ret
    end_op();
    80005be2:	fffff097          	auipc	ra,0xfffff
    80005be6:	8b2080e7          	jalr	-1870(ra) # 80004494 <end_op>
    return -1;
    80005bea:	557d                	li	a0,-1
    80005bec:	b7fd                	j	80005bda <sys_mkdir+0x4c>

0000000080005bee <sys_mknod>:

uint64
sys_mknod(void)
{
    80005bee:	7135                	addi	sp,sp,-160
    80005bf0:	ed06                	sd	ra,152(sp)
    80005bf2:	e922                	sd	s0,144(sp)
    80005bf4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005bf6:	fffff097          	auipc	ra,0xfffff
    80005bfa:	81e080e7          	jalr	-2018(ra) # 80004414 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005bfe:	08000613          	li	a2,128
    80005c02:	f7040593          	addi	a1,s0,-144
    80005c06:	4501                	li	a0,0
    80005c08:	ffffd097          	auipc	ra,0xffffd
    80005c0c:	2d8080e7          	jalr	728(ra) # 80002ee0 <argstr>
    80005c10:	04054a63          	bltz	a0,80005c64 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005c14:	f6c40593          	addi	a1,s0,-148
    80005c18:	4505                	li	a0,1
    80005c1a:	ffffd097          	auipc	ra,0xffffd
    80005c1e:	282080e7          	jalr	642(ra) # 80002e9c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c22:	04054163          	bltz	a0,80005c64 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005c26:	f6840593          	addi	a1,s0,-152
    80005c2a:	4509                	li	a0,2
    80005c2c:	ffffd097          	auipc	ra,0xffffd
    80005c30:	270080e7          	jalr	624(ra) # 80002e9c <argint>
     argint(1, &major) < 0 ||
    80005c34:	02054863          	bltz	a0,80005c64 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005c38:	f6841683          	lh	a3,-152(s0)
    80005c3c:	f6c41603          	lh	a2,-148(s0)
    80005c40:	458d                	li	a1,3
    80005c42:	f7040513          	addi	a0,s0,-144
    80005c46:	fffff097          	auipc	ra,0xfffff
    80005c4a:	778080e7          	jalr	1912(ra) # 800053be <create>
     argint(2, &minor) < 0 ||
    80005c4e:	c919                	beqz	a0,80005c64 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c50:	ffffe097          	auipc	ra,0xffffe
    80005c54:	066080e7          	jalr	102(ra) # 80003cb6 <iunlockput>
  end_op();
    80005c58:	fffff097          	auipc	ra,0xfffff
    80005c5c:	83c080e7          	jalr	-1988(ra) # 80004494 <end_op>
  return 0;
    80005c60:	4501                	li	a0,0
    80005c62:	a031                	j	80005c6e <sys_mknod+0x80>
    end_op();
    80005c64:	fffff097          	auipc	ra,0xfffff
    80005c68:	830080e7          	jalr	-2000(ra) # 80004494 <end_op>
    return -1;
    80005c6c:	557d                	li	a0,-1
}
    80005c6e:	60ea                	ld	ra,152(sp)
    80005c70:	644a                	ld	s0,144(sp)
    80005c72:	610d                	addi	sp,sp,160
    80005c74:	8082                	ret

0000000080005c76 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005c76:	7135                	addi	sp,sp,-160
    80005c78:	ed06                	sd	ra,152(sp)
    80005c7a:	e922                	sd	s0,144(sp)
    80005c7c:	e526                	sd	s1,136(sp)
    80005c7e:	e14a                	sd	s2,128(sp)
    80005c80:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005c82:	ffffc097          	auipc	ra,0xffffc
    80005c86:	146080e7          	jalr	326(ra) # 80001dc8 <myproc>
    80005c8a:	892a                	mv	s2,a0
  
  begin_op();
    80005c8c:	ffffe097          	auipc	ra,0xffffe
    80005c90:	788080e7          	jalr	1928(ra) # 80004414 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005c94:	08000613          	li	a2,128
    80005c98:	f6040593          	addi	a1,s0,-160
    80005c9c:	4501                	li	a0,0
    80005c9e:	ffffd097          	auipc	ra,0xffffd
    80005ca2:	242080e7          	jalr	578(ra) # 80002ee0 <argstr>
    80005ca6:	04054b63          	bltz	a0,80005cfc <sys_chdir+0x86>
    80005caa:	f6040513          	addi	a0,s0,-160
    80005cae:	ffffe097          	auipc	ra,0xffffe
    80005cb2:	556080e7          	jalr	1366(ra) # 80004204 <namei>
    80005cb6:	84aa                	mv	s1,a0
    80005cb8:	c131                	beqz	a0,80005cfc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005cba:	ffffe097          	auipc	ra,0xffffe
    80005cbe:	d9a080e7          	jalr	-614(ra) # 80003a54 <ilock>
  if(ip->type != T_DIR){
    80005cc2:	04449703          	lh	a4,68(s1)
    80005cc6:	4785                	li	a5,1
    80005cc8:	04f71063          	bne	a4,a5,80005d08 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005ccc:	8526                	mv	a0,s1
    80005cce:	ffffe097          	auipc	ra,0xffffe
    80005cd2:	e48080e7          	jalr	-440(ra) # 80003b16 <iunlock>
  iput(p->cwd);
    80005cd6:	15093503          	ld	a0,336(s2)
    80005cda:	ffffe097          	auipc	ra,0xffffe
    80005cde:	f34080e7          	jalr	-204(ra) # 80003c0e <iput>
  end_op();
    80005ce2:	ffffe097          	auipc	ra,0xffffe
    80005ce6:	7b2080e7          	jalr	1970(ra) # 80004494 <end_op>
  p->cwd = ip;
    80005cea:	14993823          	sd	s1,336(s2)
  return 0;
    80005cee:	4501                	li	a0,0
}
    80005cf0:	60ea                	ld	ra,152(sp)
    80005cf2:	644a                	ld	s0,144(sp)
    80005cf4:	64aa                	ld	s1,136(sp)
    80005cf6:	690a                	ld	s2,128(sp)
    80005cf8:	610d                	addi	sp,sp,160
    80005cfa:	8082                	ret
    end_op();
    80005cfc:	ffffe097          	auipc	ra,0xffffe
    80005d00:	798080e7          	jalr	1944(ra) # 80004494 <end_op>
    return -1;
    80005d04:	557d                	li	a0,-1
    80005d06:	b7ed                	j	80005cf0 <sys_chdir+0x7a>
    iunlockput(ip);
    80005d08:	8526                	mv	a0,s1
    80005d0a:	ffffe097          	auipc	ra,0xffffe
    80005d0e:	fac080e7          	jalr	-84(ra) # 80003cb6 <iunlockput>
    end_op();
    80005d12:	ffffe097          	auipc	ra,0xffffe
    80005d16:	782080e7          	jalr	1922(ra) # 80004494 <end_op>
    return -1;
    80005d1a:	557d                	li	a0,-1
    80005d1c:	bfd1                	j	80005cf0 <sys_chdir+0x7a>

0000000080005d1e <sys_exec>:

uint64
sys_exec(void)
{
    80005d1e:	7145                	addi	sp,sp,-464
    80005d20:	e786                	sd	ra,456(sp)
    80005d22:	e3a2                	sd	s0,448(sp)
    80005d24:	ff26                	sd	s1,440(sp)
    80005d26:	fb4a                	sd	s2,432(sp)
    80005d28:	f74e                	sd	s3,424(sp)
    80005d2a:	f352                	sd	s4,416(sp)
    80005d2c:	ef56                	sd	s5,408(sp)
    80005d2e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005d30:	08000613          	li	a2,128
    80005d34:	f4040593          	addi	a1,s0,-192
    80005d38:	4501                	li	a0,0
    80005d3a:	ffffd097          	auipc	ra,0xffffd
    80005d3e:	1a6080e7          	jalr	422(ra) # 80002ee0 <argstr>
    return -1;
    80005d42:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005d44:	0c054a63          	bltz	a0,80005e18 <sys_exec+0xfa>
    80005d48:	e3840593          	addi	a1,s0,-456
    80005d4c:	4505                	li	a0,1
    80005d4e:	ffffd097          	auipc	ra,0xffffd
    80005d52:	170080e7          	jalr	368(ra) # 80002ebe <argaddr>
    80005d56:	0c054163          	bltz	a0,80005e18 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005d5a:	10000613          	li	a2,256
    80005d5e:	4581                	li	a1,0
    80005d60:	e4040513          	addi	a0,s0,-448
    80005d64:	ffffb097          	auipc	ra,0xffffb
    80005d68:	f94080e7          	jalr	-108(ra) # 80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005d6c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005d70:	89a6                	mv	s3,s1
    80005d72:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005d74:	02000a13          	li	s4,32
    80005d78:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005d7c:	00391793          	slli	a5,s2,0x3
    80005d80:	e3040593          	addi	a1,s0,-464
    80005d84:	e3843503          	ld	a0,-456(s0)
    80005d88:	953e                	add	a0,a0,a5
    80005d8a:	ffffd097          	auipc	ra,0xffffd
    80005d8e:	078080e7          	jalr	120(ra) # 80002e02 <fetchaddr>
    80005d92:	02054a63          	bltz	a0,80005dc6 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005d96:	e3043783          	ld	a5,-464(s0)
    80005d9a:	c3b9                	beqz	a5,80005de0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005d9c:	ffffb097          	auipc	ra,0xffffb
    80005da0:	d70080e7          	jalr	-656(ra) # 80000b0c <kalloc>
    80005da4:	85aa                	mv	a1,a0
    80005da6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005daa:	cd11                	beqz	a0,80005dc6 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005dac:	6605                	lui	a2,0x1
    80005dae:	e3043503          	ld	a0,-464(s0)
    80005db2:	ffffd097          	auipc	ra,0xffffd
    80005db6:	0a2080e7          	jalr	162(ra) # 80002e54 <fetchstr>
    80005dba:	00054663          	bltz	a0,80005dc6 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005dbe:	0905                	addi	s2,s2,1
    80005dc0:	09a1                	addi	s3,s3,8
    80005dc2:	fb491be3          	bne	s2,s4,80005d78 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dc6:	10048913          	addi	s2,s1,256
    80005dca:	6088                	ld	a0,0(s1)
    80005dcc:	c529                	beqz	a0,80005e16 <sys_exec+0xf8>
    kfree(argv[i]);
    80005dce:	ffffb097          	auipc	ra,0xffffb
    80005dd2:	c42080e7          	jalr	-958(ra) # 80000a10 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dd6:	04a1                	addi	s1,s1,8
    80005dd8:	ff2499e3          	bne	s1,s2,80005dca <sys_exec+0xac>
  return -1;
    80005ddc:	597d                	li	s2,-1
    80005dde:	a82d                	j	80005e18 <sys_exec+0xfa>
      argv[i] = 0;
    80005de0:	0a8e                	slli	s5,s5,0x3
    80005de2:	fc040793          	addi	a5,s0,-64
    80005de6:	9abe                	add	s5,s5,a5
    80005de8:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd7e80>
  int ret = exec(path, argv);
    80005dec:	e4040593          	addi	a1,s0,-448
    80005df0:	f4040513          	addi	a0,s0,-192
    80005df4:	fffff097          	auipc	ra,0xfffff
    80005df8:	178080e7          	jalr	376(ra) # 80004f6c <exec>
    80005dfc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dfe:	10048993          	addi	s3,s1,256
    80005e02:	6088                	ld	a0,0(s1)
    80005e04:	c911                	beqz	a0,80005e18 <sys_exec+0xfa>
    kfree(argv[i]);
    80005e06:	ffffb097          	auipc	ra,0xffffb
    80005e0a:	c0a080e7          	jalr	-1014(ra) # 80000a10 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e0e:	04a1                	addi	s1,s1,8
    80005e10:	ff3499e3          	bne	s1,s3,80005e02 <sys_exec+0xe4>
    80005e14:	a011                	j	80005e18 <sys_exec+0xfa>
  return -1;
    80005e16:	597d                	li	s2,-1
}
    80005e18:	854a                	mv	a0,s2
    80005e1a:	60be                	ld	ra,456(sp)
    80005e1c:	641e                	ld	s0,448(sp)
    80005e1e:	74fa                	ld	s1,440(sp)
    80005e20:	795a                	ld	s2,432(sp)
    80005e22:	79ba                	ld	s3,424(sp)
    80005e24:	7a1a                	ld	s4,416(sp)
    80005e26:	6afa                	ld	s5,408(sp)
    80005e28:	6179                	addi	sp,sp,464
    80005e2a:	8082                	ret

0000000080005e2c <sys_pipe>:

uint64
sys_pipe(void)
{
    80005e2c:	7139                	addi	sp,sp,-64
    80005e2e:	fc06                	sd	ra,56(sp)
    80005e30:	f822                	sd	s0,48(sp)
    80005e32:	f426                	sd	s1,40(sp)
    80005e34:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005e36:	ffffc097          	auipc	ra,0xffffc
    80005e3a:	f92080e7          	jalr	-110(ra) # 80001dc8 <myproc>
    80005e3e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005e40:	fd840593          	addi	a1,s0,-40
    80005e44:	4501                	li	a0,0
    80005e46:	ffffd097          	auipc	ra,0xffffd
    80005e4a:	078080e7          	jalr	120(ra) # 80002ebe <argaddr>
    return -1;
    80005e4e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005e50:	0e054063          	bltz	a0,80005f30 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005e54:	fc840593          	addi	a1,s0,-56
    80005e58:	fd040513          	addi	a0,s0,-48
    80005e5c:	fffff097          	auipc	ra,0xfffff
    80005e60:	de0080e7          	jalr	-544(ra) # 80004c3c <pipealloc>
    return -1;
    80005e64:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005e66:	0c054563          	bltz	a0,80005f30 <sys_pipe+0x104>
  fd0 = -1;
    80005e6a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005e6e:	fd043503          	ld	a0,-48(s0)
    80005e72:	fffff097          	auipc	ra,0xfffff
    80005e76:	50a080e7          	jalr	1290(ra) # 8000537c <fdalloc>
    80005e7a:	fca42223          	sw	a0,-60(s0)
    80005e7e:	08054c63          	bltz	a0,80005f16 <sys_pipe+0xea>
    80005e82:	fc843503          	ld	a0,-56(s0)
    80005e86:	fffff097          	auipc	ra,0xfffff
    80005e8a:	4f6080e7          	jalr	1270(ra) # 8000537c <fdalloc>
    80005e8e:	fca42023          	sw	a0,-64(s0)
    80005e92:	06054863          	bltz	a0,80005f02 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e96:	4691                	li	a3,4
    80005e98:	fc440613          	addi	a2,s0,-60
    80005e9c:	fd843583          	ld	a1,-40(s0)
    80005ea0:	68a8                	ld	a0,80(s1)
    80005ea2:	ffffc097          	auipc	ra,0xffffc
    80005ea6:	808080e7          	jalr	-2040(ra) # 800016aa <copyout>
    80005eaa:	02054063          	bltz	a0,80005eca <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005eae:	4691                	li	a3,4
    80005eb0:	fc040613          	addi	a2,s0,-64
    80005eb4:	fd843583          	ld	a1,-40(s0)
    80005eb8:	0591                	addi	a1,a1,4
    80005eba:	68a8                	ld	a0,80(s1)
    80005ebc:	ffffb097          	auipc	ra,0xffffb
    80005ec0:	7ee080e7          	jalr	2030(ra) # 800016aa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005ec4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ec6:	06055563          	bgez	a0,80005f30 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005eca:	fc442783          	lw	a5,-60(s0)
    80005ece:	07e9                	addi	a5,a5,26
    80005ed0:	078e                	slli	a5,a5,0x3
    80005ed2:	97a6                	add	a5,a5,s1
    80005ed4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005ed8:	fc042503          	lw	a0,-64(s0)
    80005edc:	0569                	addi	a0,a0,26
    80005ede:	050e                	slli	a0,a0,0x3
    80005ee0:	9526                	add	a0,a0,s1
    80005ee2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005ee6:	fd043503          	ld	a0,-48(s0)
    80005eea:	fffff097          	auipc	ra,0xfffff
    80005eee:	9fc080e7          	jalr	-1540(ra) # 800048e6 <fileclose>
    fileclose(wf);
    80005ef2:	fc843503          	ld	a0,-56(s0)
    80005ef6:	fffff097          	auipc	ra,0xfffff
    80005efa:	9f0080e7          	jalr	-1552(ra) # 800048e6 <fileclose>
    return -1;
    80005efe:	57fd                	li	a5,-1
    80005f00:	a805                	j	80005f30 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005f02:	fc442783          	lw	a5,-60(s0)
    80005f06:	0007c863          	bltz	a5,80005f16 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005f0a:	01a78513          	addi	a0,a5,26
    80005f0e:	050e                	slli	a0,a0,0x3
    80005f10:	9526                	add	a0,a0,s1
    80005f12:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005f16:	fd043503          	ld	a0,-48(s0)
    80005f1a:	fffff097          	auipc	ra,0xfffff
    80005f1e:	9cc080e7          	jalr	-1588(ra) # 800048e6 <fileclose>
    fileclose(wf);
    80005f22:	fc843503          	ld	a0,-56(s0)
    80005f26:	fffff097          	auipc	ra,0xfffff
    80005f2a:	9c0080e7          	jalr	-1600(ra) # 800048e6 <fileclose>
    return -1;
    80005f2e:	57fd                	li	a5,-1
}
    80005f30:	853e                	mv	a0,a5
    80005f32:	70e2                	ld	ra,56(sp)
    80005f34:	7442                	ld	s0,48(sp)
    80005f36:	74a2                	ld	s1,40(sp)
    80005f38:	6121                	addi	sp,sp,64
    80005f3a:	8082                	ret
    80005f3c:	0000                	unimp
	...

0000000080005f40 <kernelvec>:
    80005f40:	7111                	addi	sp,sp,-256
    80005f42:	e006                	sd	ra,0(sp)
    80005f44:	e40a                	sd	sp,8(sp)
    80005f46:	e80e                	sd	gp,16(sp)
    80005f48:	ec12                	sd	tp,24(sp)
    80005f4a:	f016                	sd	t0,32(sp)
    80005f4c:	f41a                	sd	t1,40(sp)
    80005f4e:	f81e                	sd	t2,48(sp)
    80005f50:	fc22                	sd	s0,56(sp)
    80005f52:	e0a6                	sd	s1,64(sp)
    80005f54:	e4aa                	sd	a0,72(sp)
    80005f56:	e8ae                	sd	a1,80(sp)
    80005f58:	ecb2                	sd	a2,88(sp)
    80005f5a:	f0b6                	sd	a3,96(sp)
    80005f5c:	f4ba                	sd	a4,104(sp)
    80005f5e:	f8be                	sd	a5,112(sp)
    80005f60:	fcc2                	sd	a6,120(sp)
    80005f62:	e146                	sd	a7,128(sp)
    80005f64:	e54a                	sd	s2,136(sp)
    80005f66:	e94e                	sd	s3,144(sp)
    80005f68:	ed52                	sd	s4,152(sp)
    80005f6a:	f156                	sd	s5,160(sp)
    80005f6c:	f55a                	sd	s6,168(sp)
    80005f6e:	f95e                	sd	s7,176(sp)
    80005f70:	fd62                	sd	s8,184(sp)
    80005f72:	e1e6                	sd	s9,192(sp)
    80005f74:	e5ea                	sd	s10,200(sp)
    80005f76:	e9ee                	sd	s11,208(sp)
    80005f78:	edf2                	sd	t3,216(sp)
    80005f7a:	f1f6                	sd	t4,224(sp)
    80005f7c:	f5fa                	sd	t5,232(sp)
    80005f7e:	f9fe                	sd	t6,240(sp)
    80005f80:	d4ffc0ef          	jal	ra,80002cce <kerneltrap>
    80005f84:	6082                	ld	ra,0(sp)
    80005f86:	6122                	ld	sp,8(sp)
    80005f88:	61c2                	ld	gp,16(sp)
    80005f8a:	7282                	ld	t0,32(sp)
    80005f8c:	7322                	ld	t1,40(sp)
    80005f8e:	73c2                	ld	t2,48(sp)
    80005f90:	7462                	ld	s0,56(sp)
    80005f92:	6486                	ld	s1,64(sp)
    80005f94:	6526                	ld	a0,72(sp)
    80005f96:	65c6                	ld	a1,80(sp)
    80005f98:	6666                	ld	a2,88(sp)
    80005f9a:	7686                	ld	a3,96(sp)
    80005f9c:	7726                	ld	a4,104(sp)
    80005f9e:	77c6                	ld	a5,112(sp)
    80005fa0:	7866                	ld	a6,120(sp)
    80005fa2:	688a                	ld	a7,128(sp)
    80005fa4:	692a                	ld	s2,136(sp)
    80005fa6:	69ca                	ld	s3,144(sp)
    80005fa8:	6a6a                	ld	s4,152(sp)
    80005faa:	7a8a                	ld	s5,160(sp)
    80005fac:	7b2a                	ld	s6,168(sp)
    80005fae:	7bca                	ld	s7,176(sp)
    80005fb0:	7c6a                	ld	s8,184(sp)
    80005fb2:	6c8e                	ld	s9,192(sp)
    80005fb4:	6d2e                	ld	s10,200(sp)
    80005fb6:	6dce                	ld	s11,208(sp)
    80005fb8:	6e6e                	ld	t3,216(sp)
    80005fba:	7e8e                	ld	t4,224(sp)
    80005fbc:	7f2e                	ld	t5,232(sp)
    80005fbe:	7fce                	ld	t6,240(sp)
    80005fc0:	6111                	addi	sp,sp,256
    80005fc2:	10200073          	sret
    80005fc6:	00000013          	nop
    80005fca:	00000013          	nop
    80005fce:	0001                	nop

0000000080005fd0 <timervec>:
    80005fd0:	34051573          	csrrw	a0,mscratch,a0
    80005fd4:	e10c                	sd	a1,0(a0)
    80005fd6:	e510                	sd	a2,8(a0)
    80005fd8:	e914                	sd	a3,16(a0)
    80005fda:	710c                	ld	a1,32(a0)
    80005fdc:	7510                	ld	a2,40(a0)
    80005fde:	6194                	ld	a3,0(a1)
    80005fe0:	96b2                	add	a3,a3,a2
    80005fe2:	e194                	sd	a3,0(a1)
    80005fe4:	4589                	li	a1,2
    80005fe6:	14459073          	csrw	sip,a1
    80005fea:	6914                	ld	a3,16(a0)
    80005fec:	6510                	ld	a2,8(a0)
    80005fee:	610c                	ld	a1,0(a0)
    80005ff0:	34051573          	csrrw	a0,mscratch,a0
    80005ff4:	30200073          	mret
	...

0000000080005ffa <plicinit>:
    80005ffa:	1141                	addi	sp,sp,-16
    80005ffc:	e422                	sd	s0,8(sp)
    80005ffe:	0800                	addi	s0,sp,16
    80006000:	0c0007b7          	lui	a5,0xc000
    80006004:	4705                	li	a4,1
    80006006:	d798                	sw	a4,40(a5)
    80006008:	c3d8                	sw	a4,4(a5)
    8000600a:	6422                	ld	s0,8(sp)
    8000600c:	0141                	addi	sp,sp,16
    8000600e:	8082                	ret

0000000080006010 <plicinithart>:
    80006010:	1141                	addi	sp,sp,-16
    80006012:	e406                	sd	ra,8(sp)
    80006014:	e022                	sd	s0,0(sp)
    80006016:	0800                	addi	s0,sp,16
    80006018:	ffffc097          	auipc	ra,0xffffc
    8000601c:	d84080e7          	jalr	-636(ra) # 80001d9c <cpuid>
    80006020:	0085171b          	slliw	a4,a0,0x8
    80006024:	0c0027b7          	lui	a5,0xc002
    80006028:	97ba                	add	a5,a5,a4
    8000602a:	40200713          	li	a4,1026
    8000602e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80006032:	00d5151b          	slliw	a0,a0,0xd
    80006036:	0c2017b7          	lui	a5,0xc201
    8000603a:	953e                	add	a0,a0,a5
    8000603c:	00052023          	sw	zero,0(a0)
    80006040:	60a2                	ld	ra,8(sp)
    80006042:	6402                	ld	s0,0(sp)
    80006044:	0141                	addi	sp,sp,16
    80006046:	8082                	ret

0000000080006048 <plic_claim>:
    80006048:	1141                	addi	sp,sp,-16
    8000604a:	e406                	sd	ra,8(sp)
    8000604c:	e022                	sd	s0,0(sp)
    8000604e:	0800                	addi	s0,sp,16
    80006050:	ffffc097          	auipc	ra,0xffffc
    80006054:	d4c080e7          	jalr	-692(ra) # 80001d9c <cpuid>
    80006058:	00d5179b          	slliw	a5,a0,0xd
    8000605c:	0c201537          	lui	a0,0xc201
    80006060:	953e                	add	a0,a0,a5
    80006062:	4148                	lw	a0,4(a0)
    80006064:	60a2                	ld	ra,8(sp)
    80006066:	6402                	ld	s0,0(sp)
    80006068:	0141                	addi	sp,sp,16
    8000606a:	8082                	ret

000000008000606c <plic_complete>:
    8000606c:	1101                	addi	sp,sp,-32
    8000606e:	ec06                	sd	ra,24(sp)
    80006070:	e822                	sd	s0,16(sp)
    80006072:	e426                	sd	s1,8(sp)
    80006074:	1000                	addi	s0,sp,32
    80006076:	84aa                	mv	s1,a0
    80006078:	ffffc097          	auipc	ra,0xffffc
    8000607c:	d24080e7          	jalr	-732(ra) # 80001d9c <cpuid>
    80006080:	00d5151b          	slliw	a0,a0,0xd
    80006084:	0c2017b7          	lui	a5,0xc201
    80006088:	97aa                	add	a5,a5,a0
    8000608a:	c3c4                	sw	s1,4(a5)
    8000608c:	60e2                	ld	ra,24(sp)
    8000608e:	6442                	ld	s0,16(sp)
    80006090:	64a2                	ld	s1,8(sp)
    80006092:	6105                	addi	sp,sp,32
    80006094:	8082                	ret

0000000080006096 <free_desc>:
    80006096:	1141                	addi	sp,sp,-16
    80006098:	e406                	sd	ra,8(sp)
    8000609a:	e022                	sd	s0,0(sp)
    8000609c:	0800                	addi	s0,sp,16
    8000609e:	479d                	li	a5,7
    800060a0:	04a7cc63          	blt	a5,a0,800060f8 <free_desc+0x62>
    800060a4:	0001e797          	auipc	a5,0x1e
    800060a8:	f5c78793          	addi	a5,a5,-164 # 80024000 <disk>
    800060ac:	00a78733          	add	a4,a5,a0
    800060b0:	6789                	lui	a5,0x2
    800060b2:	97ba                	add	a5,a5,a4
    800060b4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800060b8:	eba1                	bnez	a5,80006108 <free_desc+0x72>
    800060ba:	00451713          	slli	a4,a0,0x4
    800060be:	00020797          	auipc	a5,0x20
    800060c2:	f427b783          	ld	a5,-190(a5) # 80026000 <disk+0x2000>
    800060c6:	97ba                	add	a5,a5,a4
    800060c8:	0007b023          	sd	zero,0(a5)
    800060cc:	0001e797          	auipc	a5,0x1e
    800060d0:	f3478793          	addi	a5,a5,-204 # 80024000 <disk>
    800060d4:	97aa                	add	a5,a5,a0
    800060d6:	6509                	lui	a0,0x2
    800060d8:	953e                	add	a0,a0,a5
    800060da:	4785                	li	a5,1
    800060dc:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
    800060e0:	00020517          	auipc	a0,0x20
    800060e4:	f3850513          	addi	a0,a0,-200 # 80026018 <disk+0x2018>
    800060e8:	ffffc097          	auipc	ra,0xffffc
    800060ec:	656080e7          	jalr	1622(ra) # 8000273e <wakeup>
    800060f0:	60a2                	ld	ra,8(sp)
    800060f2:	6402                	ld	s0,0(sp)
    800060f4:	0141                	addi	sp,sp,16
    800060f6:	8082                	ret
    800060f8:	00002517          	auipc	a0,0x2
    800060fc:	73850513          	addi	a0,a0,1848 # 80008830 <syscalls+0x330>
    80006100:	ffffa097          	auipc	ra,0xffffa
    80006104:	440080e7          	jalr	1088(ra) # 80000540 <panic>
    80006108:	00002517          	auipc	a0,0x2
    8000610c:	74050513          	addi	a0,a0,1856 # 80008848 <syscalls+0x348>
    80006110:	ffffa097          	auipc	ra,0xffffa
    80006114:	430080e7          	jalr	1072(ra) # 80000540 <panic>

0000000080006118 <virtio_disk_init>:
    80006118:	1101                	addi	sp,sp,-32
    8000611a:	ec06                	sd	ra,24(sp)
    8000611c:	e822                	sd	s0,16(sp)
    8000611e:	e426                	sd	s1,8(sp)
    80006120:	1000                	addi	s0,sp,32
    80006122:	00002597          	auipc	a1,0x2
    80006126:	73e58593          	addi	a1,a1,1854 # 80008860 <syscalls+0x360>
    8000612a:	00020517          	auipc	a0,0x20
    8000612e:	f7e50513          	addi	a0,a0,-130 # 800260a8 <disk+0x20a8>
    80006132:	ffffb097          	auipc	ra,0xffffb
    80006136:	a3a080e7          	jalr	-1478(ra) # 80000b6c <initlock>
    8000613a:	100017b7          	lui	a5,0x10001
    8000613e:	4398                	lw	a4,0(a5)
    80006140:	2701                	sext.w	a4,a4
    80006142:	747277b7          	lui	a5,0x74727
    80006146:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000614a:	0ef71163          	bne	a4,a5,8000622c <virtio_disk_init+0x114>
    8000614e:	100017b7          	lui	a5,0x10001
    80006152:	43dc                	lw	a5,4(a5)
    80006154:	2781                	sext.w	a5,a5
    80006156:	4705                	li	a4,1
    80006158:	0ce79a63          	bne	a5,a4,8000622c <virtio_disk_init+0x114>
    8000615c:	100017b7          	lui	a5,0x10001
    80006160:	479c                	lw	a5,8(a5)
    80006162:	2781                	sext.w	a5,a5
    80006164:	4709                	li	a4,2
    80006166:	0ce79363          	bne	a5,a4,8000622c <virtio_disk_init+0x114>
    8000616a:	100017b7          	lui	a5,0x10001
    8000616e:	47d8                	lw	a4,12(a5)
    80006170:	2701                	sext.w	a4,a4
    80006172:	554d47b7          	lui	a5,0x554d4
    80006176:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000617a:	0af71963          	bne	a4,a5,8000622c <virtio_disk_init+0x114>
    8000617e:	100017b7          	lui	a5,0x10001
    80006182:	4705                	li	a4,1
    80006184:	dbb8                	sw	a4,112(a5)
    80006186:	470d                	li	a4,3
    80006188:	dbb8                	sw	a4,112(a5)
    8000618a:	4b94                	lw	a3,16(a5)
    8000618c:	c7ffe737          	lui	a4,0xc7ffe
    80006190:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd775f>
    80006194:	8f75                	and	a4,a4,a3
    80006196:	2701                	sext.w	a4,a4
    80006198:	d398                	sw	a4,32(a5)
    8000619a:	472d                	li	a4,11
    8000619c:	dbb8                	sw	a4,112(a5)
    8000619e:	473d                	li	a4,15
    800061a0:	dbb8                	sw	a4,112(a5)
    800061a2:	6705                	lui	a4,0x1
    800061a4:	d798                	sw	a4,40(a5)
    800061a6:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    800061aa:	5bdc                	lw	a5,52(a5)
    800061ac:	2781                	sext.w	a5,a5
    800061ae:	c7d9                	beqz	a5,8000623c <virtio_disk_init+0x124>
    800061b0:	471d                	li	a4,7
    800061b2:	08f77d63          	bgeu	a4,a5,8000624c <virtio_disk_init+0x134>
    800061b6:	100014b7          	lui	s1,0x10001
    800061ba:	47a1                	li	a5,8
    800061bc:	dc9c                	sw	a5,56(s1)
    800061be:	6609                	lui	a2,0x2
    800061c0:	4581                	li	a1,0
    800061c2:	0001e517          	auipc	a0,0x1e
    800061c6:	e3e50513          	addi	a0,a0,-450 # 80024000 <disk>
    800061ca:	ffffb097          	auipc	ra,0xffffb
    800061ce:	b2e080e7          	jalr	-1234(ra) # 80000cf8 <memset>
    800061d2:	0001e717          	auipc	a4,0x1e
    800061d6:	e2e70713          	addi	a4,a4,-466 # 80024000 <disk>
    800061da:	00c75793          	srli	a5,a4,0xc
    800061de:	2781                	sext.w	a5,a5
    800061e0:	c0bc                	sw	a5,64(s1)
    800061e2:	00020797          	auipc	a5,0x20
    800061e6:	e1e78793          	addi	a5,a5,-482 # 80026000 <disk+0x2000>
    800061ea:	e398                	sd	a4,0(a5)
    800061ec:	0001e717          	auipc	a4,0x1e
    800061f0:	e9470713          	addi	a4,a4,-364 # 80024080 <disk+0x80>
    800061f4:	e798                	sd	a4,8(a5)
    800061f6:	0001f717          	auipc	a4,0x1f
    800061fa:	e0a70713          	addi	a4,a4,-502 # 80025000 <disk+0x1000>
    800061fe:	eb98                	sd	a4,16(a5)
    80006200:	4705                	li	a4,1
    80006202:	00e78c23          	sb	a4,24(a5)
    80006206:	00e78ca3          	sb	a4,25(a5)
    8000620a:	00e78d23          	sb	a4,26(a5)
    8000620e:	00e78da3          	sb	a4,27(a5)
    80006212:	00e78e23          	sb	a4,28(a5)
    80006216:	00e78ea3          	sb	a4,29(a5)
    8000621a:	00e78f23          	sb	a4,30(a5)
    8000621e:	00e78fa3          	sb	a4,31(a5)
    80006222:	60e2                	ld	ra,24(sp)
    80006224:	6442                	ld	s0,16(sp)
    80006226:	64a2                	ld	s1,8(sp)
    80006228:	6105                	addi	sp,sp,32
    8000622a:	8082                	ret
    8000622c:	00002517          	auipc	a0,0x2
    80006230:	64450513          	addi	a0,a0,1604 # 80008870 <syscalls+0x370>
    80006234:	ffffa097          	auipc	ra,0xffffa
    80006238:	30c080e7          	jalr	780(ra) # 80000540 <panic>
    8000623c:	00002517          	auipc	a0,0x2
    80006240:	65450513          	addi	a0,a0,1620 # 80008890 <syscalls+0x390>
    80006244:	ffffa097          	auipc	ra,0xffffa
    80006248:	2fc080e7          	jalr	764(ra) # 80000540 <panic>
    8000624c:	00002517          	auipc	a0,0x2
    80006250:	66450513          	addi	a0,a0,1636 # 800088b0 <syscalls+0x3b0>
    80006254:	ffffa097          	auipc	ra,0xffffa
    80006258:	2ec080e7          	jalr	748(ra) # 80000540 <panic>

000000008000625c <virtio_disk_rw>:
    8000625c:	7175                	addi	sp,sp,-144
    8000625e:	e506                	sd	ra,136(sp)
    80006260:	e122                	sd	s0,128(sp)
    80006262:	fca6                	sd	s1,120(sp)
    80006264:	f8ca                	sd	s2,112(sp)
    80006266:	f4ce                	sd	s3,104(sp)
    80006268:	f0d2                	sd	s4,96(sp)
    8000626a:	ecd6                	sd	s5,88(sp)
    8000626c:	e8da                	sd	s6,80(sp)
    8000626e:	e4de                	sd	s7,72(sp)
    80006270:	e0e2                	sd	s8,64(sp)
    80006272:	fc66                	sd	s9,56(sp)
    80006274:	f86a                	sd	s10,48(sp)
    80006276:	f46e                	sd	s11,40(sp)
    80006278:	0900                	addi	s0,sp,144
    8000627a:	8aaa                	mv	s5,a0
    8000627c:	8d2e                	mv	s10,a1
    8000627e:	00c52c83          	lw	s9,12(a0)
    80006282:	001c9c9b          	slliw	s9,s9,0x1
    80006286:	1c82                	slli	s9,s9,0x20
    80006288:	020cdc93          	srli	s9,s9,0x20
    8000628c:	00020517          	auipc	a0,0x20
    80006290:	e1c50513          	addi	a0,a0,-484 # 800260a8 <disk+0x20a8>
    80006294:	ffffb097          	auipc	ra,0xffffb
    80006298:	968080e7          	jalr	-1688(ra) # 80000bfc <acquire>
    8000629c:	4981                	li	s3,0
    8000629e:	44a1                	li	s1,8
    800062a0:	0001ec17          	auipc	s8,0x1e
    800062a4:	d60c0c13          	addi	s8,s8,-672 # 80024000 <disk>
    800062a8:	6b89                	lui	s7,0x2
    800062aa:	4b0d                	li	s6,3
    800062ac:	a0ad                	j	80006316 <virtio_disk_rw+0xba>
    800062ae:	00fc0733          	add	a4,s8,a5
    800062b2:	975e                	add	a4,a4,s7
    800062b4:	00070c23          	sb	zero,24(a4)
    800062b8:	c19c                	sw	a5,0(a1)
    800062ba:	0207c563          	bltz	a5,800062e4 <virtio_disk_rw+0x88>
    800062be:	2905                	addiw	s2,s2,1
    800062c0:	0611                	addi	a2,a2,4
    800062c2:	19690d63          	beq	s2,s6,8000645c <virtio_disk_rw+0x200>
    800062c6:	85b2                	mv	a1,a2
    800062c8:	00020717          	auipc	a4,0x20
    800062cc:	d5070713          	addi	a4,a4,-688 # 80026018 <disk+0x2018>
    800062d0:	87ce                	mv	a5,s3
    800062d2:	00074683          	lbu	a3,0(a4)
    800062d6:	fee1                	bnez	a3,800062ae <virtio_disk_rw+0x52>
    800062d8:	2785                	addiw	a5,a5,1
    800062da:	0705                	addi	a4,a4,1
    800062dc:	fe979be3          	bne	a5,s1,800062d2 <virtio_disk_rw+0x76>
    800062e0:	57fd                	li	a5,-1
    800062e2:	c19c                	sw	a5,0(a1)
    800062e4:	01205d63          	blez	s2,800062fe <virtio_disk_rw+0xa2>
    800062e8:	8dce                	mv	s11,s3
    800062ea:	000a2503          	lw	a0,0(s4)
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	da8080e7          	jalr	-600(ra) # 80006096 <free_desc>
    800062f6:	2d85                	addiw	s11,s11,1
    800062f8:	0a11                	addi	s4,s4,4
    800062fa:	ffb918e3          	bne	s2,s11,800062ea <virtio_disk_rw+0x8e>
    800062fe:	00020597          	auipc	a1,0x20
    80006302:	daa58593          	addi	a1,a1,-598 # 800260a8 <disk+0x20a8>
    80006306:	00020517          	auipc	a0,0x20
    8000630a:	d1250513          	addi	a0,a0,-750 # 80026018 <disk+0x2018>
    8000630e:	ffffc097          	auipc	ra,0xffffc
    80006312:	2b0080e7          	jalr	688(ra) # 800025be <sleep>
    80006316:	f8040a13          	addi	s4,s0,-128
    8000631a:	8652                	mv	a2,s4
    8000631c:	894e                	mv	s2,s3
    8000631e:	b765                	j	800062c6 <virtio_disk_rw+0x6a>
    80006320:	00020717          	auipc	a4,0x20
    80006324:	ce073703          	ld	a4,-800(a4) # 80026000 <disk+0x2000>
    80006328:	973e                	add	a4,a4,a5
    8000632a:	00071623          	sh	zero,12(a4)
    8000632e:	0001e517          	auipc	a0,0x1e
    80006332:	cd250513          	addi	a0,a0,-814 # 80024000 <disk>
    80006336:	00020717          	auipc	a4,0x20
    8000633a:	cca70713          	addi	a4,a4,-822 # 80026000 <disk+0x2000>
    8000633e:	6314                	ld	a3,0(a4)
    80006340:	96be                	add	a3,a3,a5
    80006342:	00c6d603          	lhu	a2,12(a3)
    80006346:	00166613          	ori	a2,a2,1
    8000634a:	00c69623          	sh	a2,12(a3)
    8000634e:	f8842683          	lw	a3,-120(s0)
    80006352:	6310                	ld	a2,0(a4)
    80006354:	97b2                	add	a5,a5,a2
    80006356:	00d79723          	sh	a3,14(a5)
    8000635a:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    8000635e:	0612                	slli	a2,a2,0x4
    80006360:	962a                	add	a2,a2,a0
    80006362:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
    80006366:	00469793          	slli	a5,a3,0x4
    8000636a:	630c                	ld	a1,0(a4)
    8000636c:	95be                	add	a1,a1,a5
    8000636e:	6689                	lui	a3,0x2
    80006370:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80006374:	96ca                	add	a3,a3,s2
    80006376:	96aa                	add	a3,a3,a0
    80006378:	e194                	sd	a3,0(a1)
    8000637a:	6314                	ld	a3,0(a4)
    8000637c:	96be                	add	a3,a3,a5
    8000637e:	4585                	li	a1,1
    80006380:	c68c                	sw	a1,8(a3)
    80006382:	6314                	ld	a3,0(a4)
    80006384:	96be                	add	a3,a3,a5
    80006386:	4509                	li	a0,2
    80006388:	00a69623          	sh	a0,12(a3)
    8000638c:	6314                	ld	a3,0(a4)
    8000638e:	97b6                	add	a5,a5,a3
    80006390:	00079723          	sh	zero,14(a5)
    80006394:	00baa223          	sw	a1,4(s5)
    80006398:	03563423          	sd	s5,40(a2)
    8000639c:	6714                	ld	a3,8(a4)
    8000639e:	0026d783          	lhu	a5,2(a3)
    800063a2:	8b9d                	andi	a5,a5,7
    800063a4:	0789                	addi	a5,a5,2
    800063a6:	0786                	slli	a5,a5,0x1
    800063a8:	97b6                	add	a5,a5,a3
    800063aa:	00979023          	sh	s1,0(a5)
    800063ae:	0ff0000f          	fence
    800063b2:	6718                	ld	a4,8(a4)
    800063b4:	00275783          	lhu	a5,2(a4)
    800063b8:	2785                	addiw	a5,a5,1
    800063ba:	00f71123          	sh	a5,2(a4)
    800063be:	100017b7          	lui	a5,0x10001
    800063c2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
    800063c6:	004aa783          	lw	a5,4(s5)
    800063ca:	02b79163          	bne	a5,a1,800063ec <virtio_disk_rw+0x190>
    800063ce:	00020917          	auipc	s2,0x20
    800063d2:	cda90913          	addi	s2,s2,-806 # 800260a8 <disk+0x20a8>
    800063d6:	4485                	li	s1,1
    800063d8:	85ca                	mv	a1,s2
    800063da:	8556                	mv	a0,s5
    800063dc:	ffffc097          	auipc	ra,0xffffc
    800063e0:	1e2080e7          	jalr	482(ra) # 800025be <sleep>
    800063e4:	004aa783          	lw	a5,4(s5)
    800063e8:	fe9788e3          	beq	a5,s1,800063d8 <virtio_disk_rw+0x17c>
    800063ec:	f8042483          	lw	s1,-128(s0)
    800063f0:	20048793          	addi	a5,s1,512
    800063f4:	00479713          	slli	a4,a5,0x4
    800063f8:	0001e797          	auipc	a5,0x1e
    800063fc:	c0878793          	addi	a5,a5,-1016 # 80024000 <disk>
    80006400:	97ba                	add	a5,a5,a4
    80006402:	0207b423          	sd	zero,40(a5)
    80006406:	00020917          	auipc	s2,0x20
    8000640a:	bfa90913          	addi	s2,s2,-1030 # 80026000 <disk+0x2000>
    8000640e:	a019                	j	80006414 <virtio_disk_rw+0x1b8>
    80006410:	00e4d483          	lhu	s1,14(s1)
    80006414:	8526                	mv	a0,s1
    80006416:	00000097          	auipc	ra,0x0
    8000641a:	c80080e7          	jalr	-896(ra) # 80006096 <free_desc>
    8000641e:	0492                	slli	s1,s1,0x4
    80006420:	00093783          	ld	a5,0(s2)
    80006424:	94be                	add	s1,s1,a5
    80006426:	00c4d783          	lhu	a5,12(s1)
    8000642a:	8b85                	andi	a5,a5,1
    8000642c:	f3f5                	bnez	a5,80006410 <virtio_disk_rw+0x1b4>
    8000642e:	00020517          	auipc	a0,0x20
    80006432:	c7a50513          	addi	a0,a0,-902 # 800260a8 <disk+0x20a8>
    80006436:	ffffb097          	auipc	ra,0xffffb
    8000643a:	87a080e7          	jalr	-1926(ra) # 80000cb0 <release>
    8000643e:	60aa                	ld	ra,136(sp)
    80006440:	640a                	ld	s0,128(sp)
    80006442:	74e6                	ld	s1,120(sp)
    80006444:	7946                	ld	s2,112(sp)
    80006446:	79a6                	ld	s3,104(sp)
    80006448:	7a06                	ld	s4,96(sp)
    8000644a:	6ae6                	ld	s5,88(sp)
    8000644c:	6b46                	ld	s6,80(sp)
    8000644e:	6ba6                	ld	s7,72(sp)
    80006450:	6c06                	ld	s8,64(sp)
    80006452:	7ce2                	ld	s9,56(sp)
    80006454:	7d42                	ld	s10,48(sp)
    80006456:	7da2                	ld	s11,40(sp)
    80006458:	6149                	addi	sp,sp,144
    8000645a:	8082                	ret
    8000645c:	01a037b3          	snez	a5,s10
    80006460:	f6f42823          	sw	a5,-144(s0)
    80006464:	f6042a23          	sw	zero,-140(s0)
    80006468:	f7943c23          	sd	s9,-136(s0)
    8000646c:	f8042483          	lw	s1,-128(s0)
    80006470:	00449913          	slli	s2,s1,0x4
    80006474:	00020997          	auipc	s3,0x20
    80006478:	b8c98993          	addi	s3,s3,-1140 # 80026000 <disk+0x2000>
    8000647c:	0009ba03          	ld	s4,0(s3)
    80006480:	9a4a                	add	s4,s4,s2
    80006482:	f7040513          	addi	a0,s0,-144
    80006486:	ffffb097          	auipc	ra,0xffffb
    8000648a:	c32080e7          	jalr	-974(ra) # 800010b8 <kvmpa>
    8000648e:	00aa3023          	sd	a0,0(s4)
    80006492:	0009b783          	ld	a5,0(s3)
    80006496:	97ca                	add	a5,a5,s2
    80006498:	4741                	li	a4,16
    8000649a:	c798                	sw	a4,8(a5)
    8000649c:	0009b783          	ld	a5,0(s3)
    800064a0:	97ca                	add	a5,a5,s2
    800064a2:	4705                	li	a4,1
    800064a4:	00e79623          	sh	a4,12(a5)
    800064a8:	f8442783          	lw	a5,-124(s0)
    800064ac:	0009b703          	ld	a4,0(s3)
    800064b0:	974a                	add	a4,a4,s2
    800064b2:	00f71723          	sh	a5,14(a4)
    800064b6:	0792                	slli	a5,a5,0x4
    800064b8:	0009b703          	ld	a4,0(s3)
    800064bc:	973e                	add	a4,a4,a5
    800064be:	058a8693          	addi	a3,s5,88
    800064c2:	e314                	sd	a3,0(a4)
    800064c4:	0009b703          	ld	a4,0(s3)
    800064c8:	973e                	add	a4,a4,a5
    800064ca:	40000693          	li	a3,1024
    800064ce:	c714                	sw	a3,8(a4)
    800064d0:	e40d18e3          	bnez	s10,80006320 <virtio_disk_rw+0xc4>
    800064d4:	00020717          	auipc	a4,0x20
    800064d8:	b2c73703          	ld	a4,-1236(a4) # 80026000 <disk+0x2000>
    800064dc:	973e                	add	a4,a4,a5
    800064de:	4689                	li	a3,2
    800064e0:	00d71623          	sh	a3,12(a4)
    800064e4:	b5a9                	j	8000632e <virtio_disk_rw+0xd2>

00000000800064e6 <virtio_disk_intr>:
    800064e6:	1101                	addi	sp,sp,-32
    800064e8:	ec06                	sd	ra,24(sp)
    800064ea:	e822                	sd	s0,16(sp)
    800064ec:	e426                	sd	s1,8(sp)
    800064ee:	e04a                	sd	s2,0(sp)
    800064f0:	1000                	addi	s0,sp,32
    800064f2:	00020517          	auipc	a0,0x20
    800064f6:	bb650513          	addi	a0,a0,-1098 # 800260a8 <disk+0x20a8>
    800064fa:	ffffa097          	auipc	ra,0xffffa
    800064fe:	702080e7          	jalr	1794(ra) # 80000bfc <acquire>
    80006502:	00020717          	auipc	a4,0x20
    80006506:	afe70713          	addi	a4,a4,-1282 # 80026000 <disk+0x2000>
    8000650a:	02075783          	lhu	a5,32(a4)
    8000650e:	6b18                	ld	a4,16(a4)
    80006510:	00275683          	lhu	a3,2(a4)
    80006514:	8ebd                	xor	a3,a3,a5
    80006516:	8a9d                	andi	a3,a3,7
    80006518:	cab9                	beqz	a3,8000656e <virtio_disk_intr+0x88>
    8000651a:	0001e917          	auipc	s2,0x1e
    8000651e:	ae690913          	addi	s2,s2,-1306 # 80024000 <disk>
    80006522:	00020497          	auipc	s1,0x20
    80006526:	ade48493          	addi	s1,s1,-1314 # 80026000 <disk+0x2000>
    8000652a:	078e                	slli	a5,a5,0x3
    8000652c:	97ba                	add	a5,a5,a4
    8000652e:	43dc                	lw	a5,4(a5)
    80006530:	20078713          	addi	a4,a5,512
    80006534:	0712                	slli	a4,a4,0x4
    80006536:	974a                	add	a4,a4,s2
    80006538:	03074703          	lbu	a4,48(a4)
    8000653c:	ef21                	bnez	a4,80006594 <virtio_disk_intr+0xae>
    8000653e:	20078793          	addi	a5,a5,512
    80006542:	0792                	slli	a5,a5,0x4
    80006544:	97ca                	add	a5,a5,s2
    80006546:	7798                	ld	a4,40(a5)
    80006548:	00072223          	sw	zero,4(a4)
    8000654c:	7788                	ld	a0,40(a5)
    8000654e:	ffffc097          	auipc	ra,0xffffc
    80006552:	1f0080e7          	jalr	496(ra) # 8000273e <wakeup>
    80006556:	0204d783          	lhu	a5,32(s1)
    8000655a:	2785                	addiw	a5,a5,1
    8000655c:	8b9d                	andi	a5,a5,7
    8000655e:	02f49023          	sh	a5,32(s1)
    80006562:	6898                	ld	a4,16(s1)
    80006564:	00275683          	lhu	a3,2(a4)
    80006568:	8a9d                	andi	a3,a3,7
    8000656a:	fcf690e3          	bne	a3,a5,8000652a <virtio_disk_intr+0x44>
    8000656e:	10001737          	lui	a4,0x10001
    80006572:	533c                	lw	a5,96(a4)
    80006574:	8b8d                	andi	a5,a5,3
    80006576:	d37c                	sw	a5,100(a4)
    80006578:	00020517          	auipc	a0,0x20
    8000657c:	b3050513          	addi	a0,a0,-1232 # 800260a8 <disk+0x20a8>
    80006580:	ffffa097          	auipc	ra,0xffffa
    80006584:	730080e7          	jalr	1840(ra) # 80000cb0 <release>
    80006588:	60e2                	ld	ra,24(sp)
    8000658a:	6442                	ld	s0,16(sp)
    8000658c:	64a2                	ld	s1,8(sp)
    8000658e:	6902                	ld	s2,0(sp)
    80006590:	6105                	addi	sp,sp,32
    80006592:	8082                	ret
    80006594:	00002517          	auipc	a0,0x2
    80006598:	33c50513          	addi	a0,a0,828 # 800088d0 <syscalls+0x3d0>
    8000659c:	ffffa097          	auipc	ra,0xffffa
    800065a0:	fa4080e7          	jalr	-92(ra) # 80000540 <panic>
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
