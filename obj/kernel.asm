
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 0d 11 00       	mov    $0x110d80,%edx
  10000b:	b8 16 fa 10 00       	mov    $0x10fa16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100027:	e8 78 2f 00 00       	call   102fa4 <memset>

    cons_init();                // init the console
  10002c:	e8 5e 15 00 00       	call   10158f <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 a0 37 10 00 	movl   $0x1037a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 bc 37 10 00 	movl   $0x1037bc,(%esp)
  100046:	e8 21 02 00 00       	call   10026c <cprintf>

    print_kerninfo();
  10004b:	e8 c2 08 00 00       	call   100912 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8e 00 00 00       	call   1000e3 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 1f 2c 00 00       	call   102c79 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 6f 16 00 00       	call   1016ce <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 f4 17 00 00       	call   101858 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 07 0d 00 00       	call   100d70 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 9a 17 00 00       	call   101808 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6b 01 00 00       	call   1001de <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 c7 0c 00 00       	call   100d5e <mon_backtrace>
}
  100097:	90                   	nop
  100098:	c9                   	leave  
  100099:	c3                   	ret    

0010009a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	53                   	push   %ebx
  10009e:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a7:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b9:	89 04 24             	mov    %eax,(%esp)
  1000bc:	e8 b4 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c1:	90                   	nop
  1000c2:	83 c4 14             	add    $0x14,%esp
  1000c5:	5b                   	pop    %ebx
  1000c6:	5d                   	pop    %ebp
  1000c7:	c3                   	ret    

001000c8 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c8:	55                   	push   %ebp
  1000c9:	89 e5                	mov    %esp,%ebp
  1000cb:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d8:	89 04 24             	mov    %eax,(%esp)
  1000db:	e8 ba ff ff ff       	call   10009a <grade_backtrace1>
}
  1000e0:	90                   	nop
  1000e1:	c9                   	leave  
  1000e2:	c3                   	ret    

001000e3 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e3:	55                   	push   %ebp
  1000e4:	89 e5                	mov    %esp,%ebp
  1000e6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ee:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f5:	ff 
  1000f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100101:	e8 c2 ff ff ff       	call   1000c8 <grade_backtrace0>
}
  100106:	90                   	nop
  100107:	c9                   	leave  
  100108:	c3                   	ret    

00100109 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100112:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100115:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100118:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	83 e0 03             	and    $0x3,%eax
  100122:	89 c2                	mov    %eax,%edx
  100124:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100129:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100131:	c7 04 24 c1 37 10 00 	movl   $0x1037c1,(%esp)
  100138:	e8 2f 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100141:	89 c2                	mov    %eax,%edx
  100143:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 cf 37 10 00 	movl   $0x1037cf,(%esp)
  100157:	e8 10 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	89 c2                	mov    %eax,%edx
  100162:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100167:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016f:	c7 04 24 dd 37 10 00 	movl   $0x1037dd,(%esp)
  100176:	e8 f1 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017f:	89 c2                	mov    %eax,%edx
  100181:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100186:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018e:	c7 04 24 eb 37 10 00 	movl   $0x1037eb,(%esp)
  100195:	e8 d2 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019e:	89 c2                	mov    %eax,%edx
  1001a0:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 f9 37 10 00 	movl   $0x1037f9,(%esp)
  1001b4:	e8 b3 00 00 00       	call   10026c <cprintf>
    round ++;
  1001b9:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001be:	40                   	inc    %eax
  1001bf:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001c4:	90                   	nop
  1001c5:	c9                   	leave  
  1001c6:	c3                   	ret    

001001c7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c7:	55                   	push   %ebp
  1001c8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    	asm volatile (
  1001ca:	83 ec 08             	sub    $0x8,%esp
  1001cd:	cd 78                	int    $0x78
  1001cf:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d1:	90                   	nop
  1001d2:	5d                   	pop    %ebp
  1001d3:	c3                   	ret    

001001d4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d4:	55                   	push   %ebp
  1001d5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    	asm volatile (
  1001d7:	cd 79                	int    $0x79
  1001d9:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001db:	90                   	nop
  1001dc:	5d                   	pop    %ebp
  1001dd:	c3                   	ret    

001001de <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001de:	55                   	push   %ebp
  1001df:	89 e5                	mov    %esp,%ebp
  1001e1:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e4:	e8 20 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e9:	c7 04 24 08 38 10 00 	movl   $0x103808,(%esp)
  1001f0:	e8 77 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_user();
  1001f5:	e8 cd ff ff ff       	call   1001c7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fa:	e8 0a ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001ff:	c7 04 24 28 38 10 00 	movl   $0x103828,(%esp)
  100206:	e8 61 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_kernel();
  10020b:	e8 c4 ff ff ff       	call   1001d4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100210:	e8 f4 fe ff ff       	call   100109 <lab1_print_cur_status>
}
  100215:	90                   	nop
  100216:	c9                   	leave  
  100217:	c3                   	ret    

00100218 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100218:	55                   	push   %ebp
  100219:	89 e5                	mov    %esp,%ebp
  10021b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10021e:	8b 45 08             	mov    0x8(%ebp),%eax
  100221:	89 04 24             	mov    %eax,(%esp)
  100224:	e8 93 13 00 00       	call   1015bc <cons_putc>
    (*cnt) ++;
  100229:	8b 45 0c             	mov    0xc(%ebp),%eax
  10022c:	8b 00                	mov    (%eax),%eax
  10022e:	8d 50 01             	lea    0x1(%eax),%edx
  100231:	8b 45 0c             	mov    0xc(%ebp),%eax
  100234:	89 10                	mov    %edx,(%eax)
}
  100236:	90                   	nop
  100237:	c9                   	leave  
  100238:	c3                   	ret    

00100239 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100239:	55                   	push   %ebp
  10023a:	89 e5                	mov    %esp,%ebp
  10023c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10023f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100246:	8b 45 0c             	mov    0xc(%ebp),%eax
  100249:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10024d:	8b 45 08             	mov    0x8(%ebp),%eax
  100250:	89 44 24 08          	mov    %eax,0x8(%esp)
  100254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100257:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025b:	c7 04 24 18 02 10 00 	movl   $0x100218,(%esp)
  100262:	e8 90 30 00 00       	call   1032f7 <vprintfmt>
    return cnt;
  100267:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026a:	c9                   	leave  
  10026b:	c3                   	ret    

0010026c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026c:	55                   	push   %ebp
  10026d:	89 e5                	mov    %esp,%ebp
  10026f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100272:	8d 45 0c             	lea    0xc(%ebp),%eax
  100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027f:	8b 45 08             	mov    0x8(%ebp),%eax
  100282:	89 04 24             	mov    %eax,(%esp)
  100285:	e8 af ff ff ff       	call   100239 <vcprintf>
  10028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100298:	8b 45 08             	mov    0x8(%ebp),%eax
  10029b:	89 04 24             	mov    %eax,(%esp)
  10029e:	e8 19 13 00 00       	call   1015bc <cons_putc>
}
  1002a3:	90                   	nop
  1002a4:	c9                   	leave  
  1002a5:	c3                   	ret    

001002a6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a6:	55                   	push   %ebp
  1002a7:	89 e5                	mov    %esp,%ebp
  1002a9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b3:	eb 13                	jmp    1002c8 <cputs+0x22>
        cputch(c, &cnt);
  1002b5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002c0:	89 04 24             	mov    %eax,(%esp)
  1002c3:	e8 50 ff ff ff       	call   100218 <cputch>
    while ((c = *str ++) != '\0') {
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	8d 50 01             	lea    0x1(%eax),%edx
  1002ce:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d1:	0f b6 00             	movzbl (%eax),%eax
  1002d4:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d7:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002db:	75 d8                	jne    1002b5 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002e4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002eb:	e8 28 ff ff ff       	call   100218 <cputch>
    return cnt;
  1002f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002fb:	e8 e6 12 00 00       	call   1015e6 <cons_getc>
  100300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100303:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100307:	74 f2                	je     1002fb <getchar+0x6>
        /* do nothing */;
    return c;
  100309:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10030c:	c9                   	leave  
  10030d:	c3                   	ret    

0010030e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030e:	55                   	push   %ebp
  10030f:	89 e5                	mov    %esp,%ebp
  100311:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100318:	74 13                	je     10032d <readline+0x1f>
        cprintf("%s", prompt);
  10031a:	8b 45 08             	mov    0x8(%ebp),%eax
  10031d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100321:	c7 04 24 47 38 10 00 	movl   $0x103847,(%esp)
  100328:	e8 3f ff ff ff       	call   10026c <cprintf>
    }
    int i = 0, c;
  10032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100334:	e8 bc ff ff ff       	call   1002f5 <getchar>
  100339:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10033c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100340:	79 07                	jns    100349 <readline+0x3b>
            return NULL;
  100342:	b8 00 00 00 00       	mov    $0x0,%eax
  100347:	eb 78                	jmp    1003c1 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034d:	7e 28                	jle    100377 <readline+0x69>
  10034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100356:	7f 1f                	jg     100377 <readline+0x69>
            cputchar(c);
  100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10035b:	89 04 24             	mov    %eax,(%esp)
  10035e:	e8 2f ff ff ff       	call   100292 <cputchar>
            buf[i ++] = c;
  100363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100366:	8d 50 01             	lea    0x1(%eax),%edx
  100369:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10036f:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100375:	eb 45                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100377:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037b:	75 16                	jne    100393 <readline+0x85>
  10037d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100381:	7e 10                	jle    100393 <readline+0x85>
            cputchar(c);
  100383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100386:	89 04 24             	mov    %eax,(%esp)
  100389:	e8 04 ff ff ff       	call   100292 <cputchar>
            i --;
  10038e:	ff 4d f4             	decl   -0xc(%ebp)
  100391:	eb 29                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100393:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100397:	74 06                	je     10039f <readline+0x91>
  100399:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10039d:	75 95                	jne    100334 <readline+0x26>
            cputchar(c);
  10039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a2:	89 04 24             	mov    %eax,(%esp)
  1003a5:	e8 e8 fe ff ff       	call   100292 <cputchar>
            buf[i] = '\0';
  1003aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ad:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1003b2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003b5:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1003ba:	eb 05                	jmp    1003c1 <readline+0xb3>
        c = getchar();
  1003bc:	e9 73 ff ff ff       	jmp    100334 <readline+0x26>
        }
    }
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003c9:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  1003ce:	85 c0                	test   %eax,%eax
  1003d0:	75 5b                	jne    10042d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003d2:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  1003d9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003dc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1003ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f0:	c7 04 24 4a 38 10 00 	movl   $0x10384a,(%esp)
  1003f7:	e8 70 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  1003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100403:	8b 45 10             	mov    0x10(%ebp),%eax
  100406:	89 04 24             	mov    %eax,(%esp)
  100409:	e8 2b fe ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  10040e:	c7 04 24 66 38 10 00 	movl   $0x103866,(%esp)
  100415:	e8 52 fe ff ff       	call   10026c <cprintf>
    
    cprintf("stack trackback:\n");
  10041a:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
  100421:	e8 46 fe ff ff       	call   10026c <cprintf>
    print_stackframe();
  100426:	e8 32 06 00 00       	call   100a5d <print_stackframe>
  10042b:	eb 01                	jmp    10042e <__panic+0x6b>
        goto panic_dead;
  10042d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10042e:	e8 dc 13 00 00       	call   10180f <intr_disable>
    while (1) {
        kmonitor(NULL);
  100433:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10043a:	e8 52 08 00 00       	call   100c91 <kmonitor>
  10043f:	eb f2                	jmp    100433 <__panic+0x70>

00100441 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100441:	55                   	push   %ebp
  100442:	89 e5                	mov    %esp,%ebp
  100444:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100447:	8d 45 14             	lea    0x14(%ebp),%eax
  10044a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10044d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100450:	89 44 24 08          	mov    %eax,0x8(%esp)
  100454:	8b 45 08             	mov    0x8(%ebp),%eax
  100457:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045b:	c7 04 24 7a 38 10 00 	movl   $0x10387a,(%esp)
  100462:	e8 05 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  100467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10046a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046e:	8b 45 10             	mov    0x10(%ebp),%eax
  100471:	89 04 24             	mov    %eax,(%esp)
  100474:	e8 c0 fd ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  100479:	c7 04 24 66 38 10 00 	movl   $0x103866,(%esp)
  100480:	e8 e7 fd ff ff       	call   10026c <cprintf>
    va_end(ap);
}
  100485:	90                   	nop
  100486:	c9                   	leave  
  100487:	c3                   	ret    

00100488 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100488:	55                   	push   %ebp
  100489:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10048b:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100490:	5d                   	pop    %ebp
  100491:	c3                   	ret    

00100492 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100492:	55                   	push   %ebp
  100493:	89 e5                	mov    %esp,%ebp
  100495:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100498:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049b:	8b 00                	mov    (%eax),%eax
  10049d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a3:	8b 00                	mov    (%eax),%eax
  1004a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004af:	e9 ca 00 00 00       	jmp    10057e <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004ba:	01 d0                	add    %edx,%eax
  1004bc:	89 c2                	mov    %eax,%edx
  1004be:	c1 ea 1f             	shr    $0x1f,%edx
  1004c1:	01 d0                	add    %edx,%eax
  1004c3:	d1 f8                	sar    %eax
  1004c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ce:	eb 03                	jmp    1004d3 <stab_binsearch+0x41>
            m --;
  1004d0:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d9:	7c 1f                	jl     1004fa <stab_binsearch+0x68>
  1004db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004de:	89 d0                	mov    %edx,%eax
  1004e0:	01 c0                	add    %eax,%eax
  1004e2:	01 d0                	add    %edx,%eax
  1004e4:	c1 e0 02             	shl    $0x2,%eax
  1004e7:	89 c2                	mov    %eax,%edx
  1004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f2:	0f b6 c0             	movzbl %al,%eax
  1004f5:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004f8:	75 d6                	jne    1004d0 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100500:	7d 09                	jge    10050b <stab_binsearch+0x79>
            l = true_m + 1;
  100502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100505:	40                   	inc    %eax
  100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100509:	eb 73                	jmp    10057e <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10050b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100515:	89 d0                	mov    %edx,%eax
  100517:	01 c0                	add    %eax,%eax
  100519:	01 d0                	add    %edx,%eax
  10051b:	c1 e0 02             	shl    $0x2,%eax
  10051e:	89 c2                	mov    %eax,%edx
  100520:	8b 45 08             	mov    0x8(%ebp),%eax
  100523:	01 d0                	add    %edx,%eax
  100525:	8b 40 08             	mov    0x8(%eax),%eax
  100528:	39 45 18             	cmp    %eax,0x18(%ebp)
  10052b:	76 11                	jbe    10053e <stab_binsearch+0xac>
            *region_left = m;
  10052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100530:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100533:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100538:	40                   	inc    %eax
  100539:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053c:	eb 40                	jmp    10057e <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  10053e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100541:	89 d0                	mov    %edx,%eax
  100543:	01 c0                	add    %eax,%eax
  100545:	01 d0                	add    %edx,%eax
  100547:	c1 e0 02             	shl    $0x2,%eax
  10054a:	89 c2                	mov    %eax,%edx
  10054c:	8b 45 08             	mov    0x8(%ebp),%eax
  10054f:	01 d0                	add    %edx,%eax
  100551:	8b 40 08             	mov    0x8(%eax),%eax
  100554:	39 45 18             	cmp    %eax,0x18(%ebp)
  100557:	73 14                	jae    10056d <stab_binsearch+0xdb>
            *region_right = m - 1;
  100559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055f:	8b 45 10             	mov    0x10(%ebp),%eax
  100562:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100567:	48                   	dec    %eax
  100568:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056b:	eb 11                	jmp    10057e <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100570:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100573:	89 10                	mov    %edx,(%eax)
            l = m;
  100575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100578:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10057b:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  10057e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100581:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100584:	0f 8e 2a ff ff ff    	jle    1004b4 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  10058a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10058e:	75 0f                	jne    10059f <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  100590:	8b 45 0c             	mov    0xc(%ebp),%eax
  100593:	8b 00                	mov    (%eax),%eax
  100595:	8d 50 ff             	lea    -0x1(%eax),%edx
  100598:	8b 45 10             	mov    0x10(%ebp),%eax
  10059b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10059d:	eb 3e                	jmp    1005dd <stab_binsearch+0x14b>
        l = *region_right;
  10059f:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a2:	8b 00                	mov    (%eax),%eax
  1005a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005a7:	eb 03                	jmp    1005ac <stab_binsearch+0x11a>
  1005a9:	ff 4d fc             	decl   -0x4(%ebp)
  1005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005af:	8b 00                	mov    (%eax),%eax
  1005b1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005b4:	7e 1f                	jle    1005d5 <stab_binsearch+0x143>
  1005b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b9:	89 d0                	mov    %edx,%eax
  1005bb:	01 c0                	add    %eax,%eax
  1005bd:	01 d0                	add    %edx,%eax
  1005bf:	c1 e0 02             	shl    $0x2,%eax
  1005c2:	89 c2                	mov    %eax,%edx
  1005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c7:	01 d0                	add    %edx,%eax
  1005c9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005cd:	0f b6 c0             	movzbl %al,%eax
  1005d0:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005d3:	75 d4                	jne    1005a9 <stab_binsearch+0x117>
        *region_left = l;
  1005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005db:	89 10                	mov    %edx,(%eax)
}
  1005dd:	90                   	nop
  1005de:	c9                   	leave  
  1005df:	c3                   	ret    

001005e0 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e0:	55                   	push   %ebp
  1005e1:	89 e5                	mov    %esp,%ebp
  1005e3:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	c7 00 98 38 10 00    	movl   $0x103898,(%eax)
    info->eip_line = 0;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	c7 40 08 98 38 10 00 	movl   $0x103898,0x8(%eax)
    info->eip_fn_namelen = 9;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100610:	8b 55 08             	mov    0x8(%ebp),%edx
  100613:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100616:	8b 45 0c             	mov    0xc(%ebp),%eax
  100619:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100620:	c7 45 f4 cc 40 10 00 	movl   $0x1040cc,-0xc(%ebp)
    stab_end = __STAB_END__;
  100627:	c7 45 f0 d4 bf 10 00 	movl   $0x10bfd4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10062e:	c7 45 ec d5 bf 10 00 	movl   $0x10bfd5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100635:	c7 45 e8 c7 e0 10 00 	movl   $0x10e0c7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10063c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100642:	76 0b                	jbe    10064f <debuginfo_eip+0x6f>
  100644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100647:	48                   	dec    %eax
  100648:	0f b6 00             	movzbl (%eax),%eax
  10064b:	84 c0                	test   %al,%al
  10064d:	74 0a                	je     100659 <debuginfo_eip+0x79>
        return -1;
  10064f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100654:	e9 b7 02 00 00       	jmp    100910 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100659:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100666:	29 c2                	sub    %eax,%edx
  100668:	89 d0                	mov    %edx,%eax
  10066a:	c1 f8 02             	sar    $0x2,%eax
  10066d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100673:	48                   	dec    %eax
  100674:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100677:	8b 45 08             	mov    0x8(%ebp),%eax
  10067a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10067e:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100685:	00 
  100686:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100689:	89 44 24 08          	mov    %eax,0x8(%esp)
  10068d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100690:	89 44 24 04          	mov    %eax,0x4(%esp)
  100694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100697:	89 04 24             	mov    %eax,(%esp)
  10069a:	e8 f3 fd ff ff       	call   100492 <stab_binsearch>
    if (lfile == 0)
  10069f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a2:	85 c0                	test   %eax,%eax
  1006a4:	75 0a                	jne    1006b0 <debuginfo_eip+0xd0>
        return -1;
  1006a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ab:	e9 60 02 00 00       	jmp    100910 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006c3:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006ca:	00 
  1006cb:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006d2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006dc:	89 04 24             	mov    %eax,(%esp)
  1006df:	e8 ae fd ff ff       	call   100492 <stab_binsearch>

    if (lfun <= rfun) {
  1006e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006ea:	39 c2                	cmp    %eax,%edx
  1006ec:	7f 7c                	jg     10076a <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f1:	89 c2                	mov    %eax,%edx
  1006f3:	89 d0                	mov    %edx,%eax
  1006f5:	01 c0                	add    %eax,%eax
  1006f7:	01 d0                	add    %edx,%eax
  1006f9:	c1 e0 02             	shl    $0x2,%eax
  1006fc:	89 c2                	mov    %eax,%edx
  1006fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100701:	01 d0                	add    %edx,%eax
  100703:	8b 00                	mov    (%eax),%eax
  100705:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100708:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10070b:	29 d1                	sub    %edx,%ecx
  10070d:	89 ca                	mov    %ecx,%edx
  10070f:	39 d0                	cmp    %edx,%eax
  100711:	73 22                	jae    100735 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100713:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100716:	89 c2                	mov    %eax,%edx
  100718:	89 d0                	mov    %edx,%eax
  10071a:	01 c0                	add    %eax,%eax
  10071c:	01 d0                	add    %edx,%eax
  10071e:	c1 e0 02             	shl    $0x2,%eax
  100721:	89 c2                	mov    %eax,%edx
  100723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	8b 10                	mov    (%eax),%edx
  10072a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10072d:	01 c2                	add    %eax,%edx
  10072f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100732:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100735:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100738:	89 c2                	mov    %eax,%edx
  10073a:	89 d0                	mov    %edx,%eax
  10073c:	01 c0                	add    %eax,%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	c1 e0 02             	shl    $0x2,%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100748:	01 d0                	add    %edx,%eax
  10074a:	8b 50 08             	mov    0x8(%eax),%edx
  10074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100750:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100753:	8b 45 0c             	mov    0xc(%ebp),%eax
  100756:	8b 40 10             	mov    0x10(%eax),%eax
  100759:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100762:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100765:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100768:	eb 15                	jmp    10077f <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	8b 55 08             	mov    0x8(%ebp),%edx
  100770:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100776:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100779:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10077c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100782:	8b 40 08             	mov    0x8(%eax),%eax
  100785:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10078c:	00 
  10078d:	89 04 24             	mov    %eax,(%esp)
  100790:	e8 8b 26 00 00       	call   102e20 <strfind>
  100795:	89 c2                	mov    %eax,%edx
  100797:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079a:	8b 40 08             	mov    0x8(%eax),%eax
  10079d:	29 c2                	sub    %eax,%edx
  10079f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a2:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1007a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007ac:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007b3:	00 
  1007b4:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007bb:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c5:	89 04 24             	mov    %eax,(%esp)
  1007c8:	e8 c5 fc ff ff       	call   100492 <stab_binsearch>
    if (lline <= rline) {
  1007cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007d3:	39 c2                	cmp    %eax,%edx
  1007d5:	7f 23                	jg     1007fa <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  1007d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007da:	89 c2                	mov    %eax,%edx
  1007dc:	89 d0                	mov    %edx,%eax
  1007de:	01 c0                	add    %eax,%eax
  1007e0:	01 d0                	add    %edx,%eax
  1007e2:	c1 e0 02             	shl    $0x2,%eax
  1007e5:	89 c2                	mov    %eax,%edx
  1007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ea:	01 d0                	add    %edx,%eax
  1007ec:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007f0:	89 c2                	mov    %eax,%edx
  1007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007f8:	eb 11                	jmp    10080b <debuginfo_eip+0x22b>
        return -1;
  1007fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ff:	e9 0c 01 00 00       	jmp    100910 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100807:	48                   	dec    %eax
  100808:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10080b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10080e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100811:	39 c2                	cmp    %eax,%edx
  100813:	7c 56                	jl     10086b <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  100815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	89 d0                	mov    %edx,%eax
  10081c:	01 c0                	add    %eax,%eax
  10081e:	01 d0                	add    %edx,%eax
  100820:	c1 e0 02             	shl    $0x2,%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100828:	01 d0                	add    %edx,%eax
  10082a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082e:	3c 84                	cmp    $0x84,%al
  100830:	74 39                	je     10086b <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084b:	3c 64                	cmp    $0x64,%al
  10084d:	75 b5                	jne    100804 <debuginfo_eip+0x224>
  10084f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100852:	89 c2                	mov    %eax,%edx
  100854:	89 d0                	mov    %edx,%eax
  100856:	01 c0                	add    %eax,%eax
  100858:	01 d0                	add    %edx,%eax
  10085a:	c1 e0 02             	shl    $0x2,%eax
  10085d:	89 c2                	mov    %eax,%edx
  10085f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100862:	01 d0                	add    %edx,%eax
  100864:	8b 40 08             	mov    0x8(%eax),%eax
  100867:	85 c0                	test   %eax,%eax
  100869:	74 99                	je     100804 <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10086b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10086e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100871:	39 c2                	cmp    %eax,%edx
  100873:	7c 46                	jl     1008bb <debuginfo_eip+0x2db>
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 00                	mov    (%eax),%eax
  10088c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10088f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100892:	29 d1                	sub    %edx,%ecx
  100894:	89 ca                	mov    %ecx,%edx
  100896:	39 d0                	cmp    %edx,%eax
  100898:	73 21                	jae    1008bb <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10089a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089d:	89 c2                	mov    %eax,%edx
  10089f:	89 d0                	mov    %edx,%eax
  1008a1:	01 c0                	add    %eax,%eax
  1008a3:	01 d0                	add    %edx,%eax
  1008a5:	c1 e0 02             	shl    $0x2,%eax
  1008a8:	89 c2                	mov    %eax,%edx
  1008aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ad:	01 d0                	add    %edx,%eax
  1008af:	8b 10                	mov    (%eax),%edx
  1008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b4:	01 c2                	add    %eax,%edx
  1008b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008c1:	39 c2                	cmp    %eax,%edx
  1008c3:	7d 46                	jge    10090b <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008c8:	40                   	inc    %eax
  1008c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008cc:	eb 16                	jmp    1008e4 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d1:	8b 40 14             	mov    0x14(%eax),%eax
  1008d4:	8d 50 01             	lea    0x1(%eax),%edx
  1008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008da:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e0:	40                   	inc    %eax
  1008e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008ea:	39 c2                	cmp    %eax,%edx
  1008ec:	7d 1d                	jge    10090b <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f1:	89 c2                	mov    %eax,%edx
  1008f3:	89 d0                	mov    %edx,%eax
  1008f5:	01 c0                	add    %eax,%eax
  1008f7:	01 d0                	add    %edx,%eax
  1008f9:	c1 e0 02             	shl    $0x2,%eax
  1008fc:	89 c2                	mov    %eax,%edx
  1008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100901:	01 d0                	add    %edx,%eax
  100903:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100907:	3c a0                	cmp    $0xa0,%al
  100909:	74 c3                	je     1008ce <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  10090b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100918:	c7 04 24 a2 38 10 00 	movl   $0x1038a2,(%esp)
  10091f:	e8 48 f9 ff ff       	call   10026c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100924:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10092b:	00 
  10092c:	c7 04 24 bb 38 10 00 	movl   $0x1038bb,(%esp)
  100933:	e8 34 f9 ff ff       	call   10026c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100938:	c7 44 24 04 9e 37 10 	movl   $0x10379e,0x4(%esp)
  10093f:	00 
  100940:	c7 04 24 d3 38 10 00 	movl   $0x1038d3,(%esp)
  100947:	e8 20 f9 ff ff       	call   10026c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10094c:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  100953:	00 
  100954:	c7 04 24 eb 38 10 00 	movl   $0x1038eb,(%esp)
  10095b:	e8 0c f9 ff ff       	call   10026c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100960:	c7 44 24 04 80 0d 11 	movl   $0x110d80,0x4(%esp)
  100967:	00 
  100968:	c7 04 24 03 39 10 00 	movl   $0x103903,(%esp)
  10096f:	e8 f8 f8 ff ff       	call   10026c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100974:	b8 80 0d 11 00       	mov    $0x110d80,%eax
  100979:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10097f:	b8 00 00 10 00       	mov    $0x100000,%eax
  100984:	29 c2                	sub    %eax,%edx
  100986:	89 d0                	mov    %edx,%eax
  100988:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10098e:	85 c0                	test   %eax,%eax
  100990:	0f 48 c2             	cmovs  %edx,%eax
  100993:	c1 f8 0a             	sar    $0xa,%eax
  100996:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099a:	c7 04 24 1c 39 10 00 	movl   $0x10391c,(%esp)
  1009a1:	e8 c6 f8 ff ff       	call   10026c <cprintf>
}
  1009a6:	90                   	nop
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009b2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bc:	89 04 24             	mov    %eax,(%esp)
  1009bf:	e8 1c fc ff ff       	call   1005e0 <debuginfo_eip>
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	74 15                	je     1009dd <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cf:	c7 04 24 46 39 10 00 	movl   $0x103946,(%esp)
  1009d6:	e8 91 f8 ff ff       	call   10026c <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009db:	eb 6c                	jmp    100a49 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009e4:	eb 1b                	jmp    100a01 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  1009e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ec:	01 d0                	add    %edx,%eax
  1009ee:	0f b6 00             	movzbl (%eax),%eax
  1009f1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009fa:	01 ca                	add    %ecx,%edx
  1009fc:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fe:	ff 45 f4             	incl   -0xc(%ebp)
  100a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a07:	7c dd                	jl     1009e6 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a09:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a12:	01 d0                	add    %edx,%eax
  100a14:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a1a:	8b 55 08             	mov    0x8(%ebp),%edx
  100a1d:	89 d1                	mov    %edx,%ecx
  100a1f:	29 c1                	sub    %eax,%ecx
  100a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a27:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a2b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a31:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a35:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3d:	c7 04 24 62 39 10 00 	movl   $0x103962,(%esp)
  100a44:	e8 23 f8 ff ff       	call   10026c <cprintf>
}
  100a49:	90                   	nop
  100a4a:	c9                   	leave  
  100a4b:	c3                   	ret    

00100a4c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a4c:	55                   	push   %ebp
  100a4d:	89 e5                	mov    %esp,%ebp
  100a4f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a52:	8b 45 04             	mov    0x4(%ebp),%eax
  100a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a5b:	c9                   	leave  
  100a5c:	c3                   	ret    

00100a5d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a5d:	55                   	push   %ebp
  100a5e:	89 e5                	mov    %esp,%ebp
  100a60:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a63:	89 e8                	mov    %ebp,%eax
  100a65:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp();
  100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip  = read_eip();
  100a6e:	e8 d9 ff ff ff       	call   100a4c <read_eip>
  100a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
     int j ;
     for(int i = 0;ebp!=0 && i<STACKFRAME_DEPTH;i++)
  100a76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a7d:	e9 90 00 00 00       	jmp    100b12 <print_stackframe+0xb5>
     {
         cprintf("ebp:0x%08x  eip:0x%08x    ", ebp, eip);
  100a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a85:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a90:	c7 04 24 74 39 10 00 	movl   $0x103974,(%esp)
  100a97:	e8 d0 f7 ff ff       	call   10026c <cprintf>
         cprintf("arg:");
  100a9c:	c7 04 24 8f 39 10 00 	movl   $0x10398f,(%esp)
  100aa3:	e8 c4 f7 ff ff       	call   10026c <cprintf>
         uint32_t *args = (uint32_t *)ebp + 2;
  100aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aab:	83 c0 08             	add    $0x8,%eax
  100aae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
         for(j=0; j<=4; j++)
  100ab1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100ab8:	eb 24                	jmp    100ade <print_stackframe+0x81>
             cprintf("0x%08x    ", args[j]);
  100aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100abd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100ac7:	01 d0                	add    %edx,%eax
  100ac9:	8b 00                	mov    (%eax),%eax
  100acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100acf:	c7 04 24 94 39 10 00 	movl   $0x103994,(%esp)
  100ad6:	e8 91 f7 ff ff       	call   10026c <cprintf>
         for(j=0; j<=4; j++)
  100adb:	ff 45 ec             	incl   -0x14(%ebp)
  100ade:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
  100ae2:	7e d6                	jle    100aba <print_stackframe+0x5d>
         cprintf("\n");
  100ae4:	c7 04 24 9f 39 10 00 	movl   $0x10399f,(%esp)
  100aeb:	e8 7c f7 ff ff       	call   10026c <cprintf>
         print_debuginfo(eip-1);
  100af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100af3:	48                   	dec    %eax
  100af4:	89 04 24             	mov    %eax,(%esp)
  100af7:	e8 ad fe ff ff       	call   1009a9 <print_debuginfo>
         eip = ((uint32_t *)ebp)[1];
  100afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aff:	83 c0 04             	add    $0x4,%eax
  100b02:	8b 00                	mov    (%eax),%eax
  100b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
         ebp = ((uint32_t *)ebp)[0];
  100b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0a:	8b 00                	mov    (%eax),%eax
  100b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for(int i = 0;ebp!=0 && i<STACKFRAME_DEPTH;i++)
  100b0f:	ff 45 e8             	incl   -0x18(%ebp)
  100b12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b16:	74 0a                	je     100b22 <print_stackframe+0xc5>
  100b18:	83 7d e8 13          	cmpl   $0x13,-0x18(%ebp)
  100b1c:	0f 8e 60 ff ff ff    	jle    100a82 <print_stackframe+0x25>
     }
}
  100b22:	90                   	nop
  100b23:	c9                   	leave  
  100b24:	c3                   	ret    

00100b25 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b25:	55                   	push   %ebp
  100b26:	89 e5                	mov    %esp,%ebp
  100b28:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b32:	eb 0c                	jmp    100b40 <parse+0x1b>
            *buf ++ = '\0';
  100b34:	8b 45 08             	mov    0x8(%ebp),%eax
  100b37:	8d 50 01             	lea    0x1(%eax),%edx
  100b3a:	89 55 08             	mov    %edx,0x8(%ebp)
  100b3d:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b40:	8b 45 08             	mov    0x8(%ebp),%eax
  100b43:	0f b6 00             	movzbl (%eax),%eax
  100b46:	84 c0                	test   %al,%al
  100b48:	74 1d                	je     100b67 <parse+0x42>
  100b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4d:	0f b6 00             	movzbl (%eax),%eax
  100b50:	0f be c0             	movsbl %al,%eax
  100b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b57:	c7 04 24 24 3a 10 00 	movl   $0x103a24,(%esp)
  100b5e:	e8 8b 22 00 00       	call   102dee <strchr>
  100b63:	85 c0                	test   %eax,%eax
  100b65:	75 cd                	jne    100b34 <parse+0xf>
        }
        if (*buf == '\0') {
  100b67:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6a:	0f b6 00             	movzbl (%eax),%eax
  100b6d:	84 c0                	test   %al,%al
  100b6f:	74 65                	je     100bd6 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b71:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b75:	75 14                	jne    100b8b <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b77:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b7e:	00 
  100b7f:	c7 04 24 29 3a 10 00 	movl   $0x103a29,(%esp)
  100b86:	e8 e1 f6 ff ff       	call   10026c <cprintf>
        }
        argv[argc ++] = buf;
  100b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b8e:	8d 50 01             	lea    0x1(%eax),%edx
  100b91:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b9e:	01 c2                	add    %eax,%edx
  100ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba3:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ba5:	eb 03                	jmp    100baa <parse+0x85>
            buf ++;
  100ba7:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100baa:	8b 45 08             	mov    0x8(%ebp),%eax
  100bad:	0f b6 00             	movzbl (%eax),%eax
  100bb0:	84 c0                	test   %al,%al
  100bb2:	74 8c                	je     100b40 <parse+0x1b>
  100bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb7:	0f b6 00             	movzbl (%eax),%eax
  100bba:	0f be c0             	movsbl %al,%eax
  100bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc1:	c7 04 24 24 3a 10 00 	movl   $0x103a24,(%esp)
  100bc8:	e8 21 22 00 00       	call   102dee <strchr>
  100bcd:	85 c0                	test   %eax,%eax
  100bcf:	74 d6                	je     100ba7 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bd1:	e9 6a ff ff ff       	jmp    100b40 <parse+0x1b>
            break;
  100bd6:	90                   	nop
        }
    }
    return argc;
  100bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bda:	c9                   	leave  
  100bdb:	c3                   	ret    

00100bdc <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bdc:	55                   	push   %ebp
  100bdd:	89 e5                	mov    %esp,%ebp
  100bdf:	53                   	push   %ebx
  100be0:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100be3:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100be6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bea:	8b 45 08             	mov    0x8(%ebp),%eax
  100bed:	89 04 24             	mov    %eax,(%esp)
  100bf0:	e8 30 ff ff ff       	call   100b25 <parse>
  100bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bfc:	75 0a                	jne    100c08 <runcmd+0x2c>
        return 0;
  100bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  100c03:	e9 83 00 00 00       	jmp    100c8b <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c0f:	eb 5a                	jmp    100c6b <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c11:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c17:	89 d0                	mov    %edx,%eax
  100c19:	01 c0                	add    %eax,%eax
  100c1b:	01 d0                	add    %edx,%eax
  100c1d:	c1 e0 02             	shl    $0x2,%eax
  100c20:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c25:	8b 00                	mov    (%eax),%eax
  100c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c2b:	89 04 24             	mov    %eax,(%esp)
  100c2e:	e8 1e 21 00 00       	call   102d51 <strcmp>
  100c33:	85 c0                	test   %eax,%eax
  100c35:	75 31                	jne    100c68 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3a:	89 d0                	mov    %edx,%eax
  100c3c:	01 c0                	add    %eax,%eax
  100c3e:	01 d0                	add    %edx,%eax
  100c40:	c1 e0 02             	shl    $0x2,%eax
  100c43:	05 08 f0 10 00       	add    $0x10f008,%eax
  100c48:	8b 10                	mov    (%eax),%edx
  100c4a:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c4d:	83 c0 04             	add    $0x4,%eax
  100c50:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c53:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c59:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c61:	89 1c 24             	mov    %ebx,(%esp)
  100c64:	ff d2                	call   *%edx
  100c66:	eb 23                	jmp    100c8b <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c68:	ff 45 f4             	incl   -0xc(%ebp)
  100c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6e:	83 f8 02             	cmp    $0x2,%eax
  100c71:	76 9e                	jbe    100c11 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c73:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c7a:	c7 04 24 47 3a 10 00 	movl   $0x103a47,(%esp)
  100c81:	e8 e6 f5 ff ff       	call   10026c <cprintf>
    return 0;
  100c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8b:	83 c4 64             	add    $0x64,%esp
  100c8e:	5b                   	pop    %ebx
  100c8f:	5d                   	pop    %ebp
  100c90:	c3                   	ret    

00100c91 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c91:	55                   	push   %ebp
  100c92:	89 e5                	mov    %esp,%ebp
  100c94:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c97:	c7 04 24 60 3a 10 00 	movl   $0x103a60,(%esp)
  100c9e:	e8 c9 f5 ff ff       	call   10026c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100ca3:	c7 04 24 88 3a 10 00 	movl   $0x103a88,(%esp)
  100caa:	e8 bd f5 ff ff       	call   10026c <cprintf>

    if (tf != NULL) {
  100caf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cb3:	74 0b                	je     100cc0 <kmonitor+0x2f>
        print_trapframe(tf);
  100cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cb8:	89 04 24             	mov    %eax,(%esp)
  100cbb:	e8 4e 0d 00 00       	call   101a0e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cc0:	c7 04 24 ad 3a 10 00 	movl   $0x103aad,(%esp)
  100cc7:	e8 42 f6 ff ff       	call   10030e <readline>
  100ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cd3:	74 eb                	je     100cc0 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cdf:	89 04 24             	mov    %eax,(%esp)
  100ce2:	e8 f5 fe ff ff       	call   100bdc <runcmd>
  100ce7:	85 c0                	test   %eax,%eax
  100ce9:	78 02                	js     100ced <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100ceb:	eb d3                	jmp    100cc0 <kmonitor+0x2f>
                break;
  100ced:	90                   	nop
            }
        }
    }
}
  100cee:	90                   	nop
  100cef:	c9                   	leave  
  100cf0:	c3                   	ret    

00100cf1 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cf1:	55                   	push   %ebp
  100cf2:	89 e5                	mov    %esp,%ebp
  100cf4:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cfe:	eb 3d                	jmp    100d3d <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d03:	89 d0                	mov    %edx,%eax
  100d05:	01 c0                	add    %eax,%eax
  100d07:	01 d0                	add    %edx,%eax
  100d09:	c1 e0 02             	shl    $0x2,%eax
  100d0c:	05 04 f0 10 00       	add    $0x10f004,%eax
  100d11:	8b 08                	mov    (%eax),%ecx
  100d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d16:	89 d0                	mov    %edx,%eax
  100d18:	01 c0                	add    %eax,%eax
  100d1a:	01 d0                	add    %edx,%eax
  100d1c:	c1 e0 02             	shl    $0x2,%eax
  100d1f:	05 00 f0 10 00       	add    $0x10f000,%eax
  100d24:	8b 00                	mov    (%eax),%eax
  100d26:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2e:	c7 04 24 b1 3a 10 00 	movl   $0x103ab1,(%esp)
  100d35:	e8 32 f5 ff ff       	call   10026c <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d3a:	ff 45 f4             	incl   -0xc(%ebp)
  100d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d40:	83 f8 02             	cmp    $0x2,%eax
  100d43:	76 bb                	jbe    100d00 <mon_help+0xf>
    }
    return 0;
  100d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d4a:	c9                   	leave  
  100d4b:	c3                   	ret    

00100d4c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d4c:	55                   	push   %ebp
  100d4d:	89 e5                	mov    %esp,%ebp
  100d4f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d52:	e8 bb fb ff ff       	call   100912 <print_kerninfo>
    return 0;
  100d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d5c:	c9                   	leave  
  100d5d:	c3                   	ret    

00100d5e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d5e:	55                   	push   %ebp
  100d5f:	89 e5                	mov    %esp,%ebp
  100d61:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d64:	e8 f4 fc ff ff       	call   100a5d <print_stackframe>
    return 0;
  100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d6e:	c9                   	leave  
  100d6f:	c3                   	ret    

00100d70 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d70:	55                   	push   %ebp
  100d71:	89 e5                	mov    %esp,%ebp
  100d73:	83 ec 28             	sub    $0x28,%esp
  100d76:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d7c:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d84:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d88:	ee                   	out    %al,(%dx)
  100d89:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d93:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d97:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d9b:	ee                   	out    %al,(%dx)
  100d9c:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100da2:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100da6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100daa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dae:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100daf:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100db6:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db9:	c7 04 24 ba 3a 10 00 	movl   $0x103aba,(%esp)
  100dc0:	e8 a7 f4 ff ff       	call   10026c <cprintf>
    pic_enable(IRQ_TIMER);
  100dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dcc:	e8 ca 08 00 00       	call   10169b <pic_enable>
}
  100dd1:	90                   	nop
  100dd2:	c9                   	leave  
  100dd3:	c3                   	ret    

00100dd4 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dd4:	55                   	push   %ebp
  100dd5:	89 e5                	mov    %esp,%ebp
  100dd7:	83 ec 10             	sub    $0x10,%esp
  100dda:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100de0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100de4:	89 c2                	mov    %eax,%edx
  100de6:	ec                   	in     (%dx),%al
  100de7:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dea:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100df0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100df4:	89 c2                	mov    %eax,%edx
  100df6:	ec                   	in     (%dx),%al
  100df7:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dfa:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e00:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e04:	89 c2                	mov    %eax,%edx
  100e06:	ec                   	in     (%dx),%al
  100e07:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e0a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e10:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e14:	89 c2                	mov    %eax,%edx
  100e16:	ec                   	in     (%dx),%al
  100e17:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e1a:	90                   	nop
  100e1b:	c9                   	leave  
  100e1c:	c3                   	ret    

00100e1d <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e1d:	55                   	push   %ebp
  100e1e:	89 e5                	mov    %esp,%ebp
  100e20:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e23:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2d:	0f b7 00             	movzwl (%eax),%eax
  100e30:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e37:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3f:	0f b7 00             	movzwl (%eax),%eax
  100e42:	0f b7 c0             	movzwl %ax,%eax
  100e45:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e4a:	74 12                	je     100e5e <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e4c:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e53:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e5a:	b4 03 
  100e5c:	eb 13                	jmp    100e71 <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e61:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e65:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e68:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e6f:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e71:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e78:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e7c:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e80:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e84:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e88:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e89:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e90:	40                   	inc    %eax
  100e91:	0f b7 c0             	movzwl %ax,%eax
  100e94:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e98:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e9c:	89 c2                	mov    %eax,%edx
  100e9e:	ec                   	in     (%dx),%al
  100e9f:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ea2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ea6:	0f b6 c0             	movzbl %al,%eax
  100ea9:	c1 e0 08             	shl    $0x8,%eax
  100eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eaf:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eb6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100eba:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ebe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ec2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ec6:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ec7:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ece:	40                   	inc    %eax
  100ecf:	0f b7 c0             	movzwl %ax,%eax
  100ed2:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ed6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eda:	89 c2                	mov    %eax,%edx
  100edc:	ec                   	in     (%dx),%al
  100edd:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100ee0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ee4:	0f b6 c0             	movzbl %al,%eax
  100ee7:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eed:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ef5:	0f b7 c0             	movzwl %ax,%eax
  100ef8:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100efe:	90                   	nop
  100eff:	c9                   	leave  
  100f00:	c3                   	ret    

00100f01 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f01:	55                   	push   %ebp
  100f02:	89 e5                	mov    %esp,%ebp
  100f04:	83 ec 48             	sub    $0x48,%esp
  100f07:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f0d:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f11:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f15:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f19:	ee                   	out    %al,(%dx)
  100f1a:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f20:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f24:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f28:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f2c:	ee                   	out    %al,(%dx)
  100f2d:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f33:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f37:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f3b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f3f:	ee                   	out    %al,(%dx)
  100f40:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f46:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f4a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f4e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f52:	ee                   	out    %al,(%dx)
  100f53:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f59:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f5d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f61:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f65:	ee                   	out    %al,(%dx)
  100f66:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f6c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f70:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f74:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f78:	ee                   	out    %al,(%dx)
  100f79:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f7f:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f83:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f87:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f8b:	ee                   	out    %al,(%dx)
  100f8c:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f92:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f96:	89 c2                	mov    %eax,%edx
  100f98:	ec                   	in     (%dx),%al
  100f99:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f9c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fa0:	3c ff                	cmp    $0xff,%al
  100fa2:	0f 95 c0             	setne  %al
  100fa5:	0f b6 c0             	movzbl %al,%eax
  100fa8:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100fad:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fb7:	89 c2                	mov    %eax,%edx
  100fb9:	ec                   	in     (%dx),%al
  100fba:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fbd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fc3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fc7:	89 c2                	mov    %eax,%edx
  100fc9:	ec                   	in     (%dx),%al
  100fca:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fcd:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100fd2:	85 c0                	test   %eax,%eax
  100fd4:	74 0c                	je     100fe2 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fd6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fdd:	e8 b9 06 00 00       	call   10169b <pic_enable>
    }
}
  100fe2:	90                   	nop
  100fe3:	c9                   	leave  
  100fe4:	c3                   	ret    

00100fe5 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fe5:	55                   	push   %ebp
  100fe6:	89 e5                	mov    %esp,%ebp
  100fe8:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100feb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ff2:	eb 08                	jmp    100ffc <lpt_putc_sub+0x17>
        delay();
  100ff4:	e8 db fd ff ff       	call   100dd4 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff9:	ff 45 fc             	incl   -0x4(%ebp)
  100ffc:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101002:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101006:	89 c2                	mov    %eax,%edx
  101008:	ec                   	in     (%dx),%al
  101009:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10100c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101010:	84 c0                	test   %al,%al
  101012:	78 09                	js     10101d <lpt_putc_sub+0x38>
  101014:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10101b:	7e d7                	jle    100ff4 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  10101d:	8b 45 08             	mov    0x8(%ebp),%eax
  101020:	0f b6 c0             	movzbl %al,%eax
  101023:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101029:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10102c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101030:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101034:	ee                   	out    %al,(%dx)
  101035:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10103b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10103f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101043:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101047:	ee                   	out    %al,(%dx)
  101048:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10104e:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101052:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101056:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10105a:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10105b:	90                   	nop
  10105c:	c9                   	leave  
  10105d:	c3                   	ret    

0010105e <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10105e:	55                   	push   %ebp
  10105f:	89 e5                	mov    %esp,%ebp
  101061:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101064:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101068:	74 0d                	je     101077 <lpt_putc+0x19>
        lpt_putc_sub(c);
  10106a:	8b 45 08             	mov    0x8(%ebp),%eax
  10106d:	89 04 24             	mov    %eax,(%esp)
  101070:	e8 70 ff ff ff       	call   100fe5 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101075:	eb 24                	jmp    10109b <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  101077:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107e:	e8 62 ff ff ff       	call   100fe5 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101083:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10108a:	e8 56 ff ff ff       	call   100fe5 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10108f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101096:	e8 4a ff ff ff       	call   100fe5 <lpt_putc_sub>
}
  10109b:	90                   	nop
  10109c:	c9                   	leave  
  10109d:	c3                   	ret    

0010109e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10109e:	55                   	push   %ebp
  10109f:	89 e5                	mov    %esp,%ebp
  1010a1:	53                   	push   %ebx
  1010a2:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a8:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010ad:	85 c0                	test   %eax,%eax
  1010af:	75 07                	jne    1010b8 <cga_putc+0x1a>
        c |= 0x0700;
  1010b1:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bb:	0f b6 c0             	movzbl %al,%eax
  1010be:	83 f8 0a             	cmp    $0xa,%eax
  1010c1:	74 55                	je     101118 <cga_putc+0x7a>
  1010c3:	83 f8 0d             	cmp    $0xd,%eax
  1010c6:	74 63                	je     10112b <cga_putc+0x8d>
  1010c8:	83 f8 08             	cmp    $0x8,%eax
  1010cb:	0f 85 94 00 00 00    	jne    101165 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  1010d1:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010d8:	85 c0                	test   %eax,%eax
  1010da:	0f 84 af 00 00 00    	je     10118f <cga_putc+0xf1>
            crt_pos --;
  1010e0:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010e7:	48                   	dec    %eax
  1010e8:	0f b7 c0             	movzwl %ax,%eax
  1010eb:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f4:	98                   	cwtl   
  1010f5:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010fa:	98                   	cwtl   
  1010fb:	83 c8 20             	or     $0x20,%eax
  1010fe:	98                   	cwtl   
  1010ff:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  101105:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  10110c:	01 c9                	add    %ecx,%ecx
  10110e:	01 ca                	add    %ecx,%edx
  101110:	0f b7 c0             	movzwl %ax,%eax
  101113:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101116:	eb 77                	jmp    10118f <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  101118:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10111f:	83 c0 50             	add    $0x50,%eax
  101122:	0f b7 c0             	movzwl %ax,%eax
  101125:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10112b:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  101132:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101139:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10113e:	89 c8                	mov    %ecx,%eax
  101140:	f7 e2                	mul    %edx
  101142:	c1 ea 06             	shr    $0x6,%edx
  101145:	89 d0                	mov    %edx,%eax
  101147:	c1 e0 02             	shl    $0x2,%eax
  10114a:	01 d0                	add    %edx,%eax
  10114c:	c1 e0 04             	shl    $0x4,%eax
  10114f:	29 c1                	sub    %eax,%ecx
  101151:	89 c8                	mov    %ecx,%eax
  101153:	0f b7 c0             	movzwl %ax,%eax
  101156:	29 c3                	sub    %eax,%ebx
  101158:	89 d8                	mov    %ebx,%eax
  10115a:	0f b7 c0             	movzwl %ax,%eax
  10115d:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  101163:	eb 2b                	jmp    101190 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101165:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  10116b:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101172:	8d 50 01             	lea    0x1(%eax),%edx
  101175:	0f b7 d2             	movzwl %dx,%edx
  101178:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  10117f:	01 c0                	add    %eax,%eax
  101181:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101184:	8b 45 08             	mov    0x8(%ebp),%eax
  101187:	0f b7 c0             	movzwl %ax,%eax
  10118a:	66 89 02             	mov    %ax,(%edx)
        break;
  10118d:	eb 01                	jmp    101190 <cga_putc+0xf2>
        break;
  10118f:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101190:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101197:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10119c:	76 5d                	jbe    1011fb <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10119e:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011a3:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011a9:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011ae:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011b5:	00 
  1011b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011ba:	89 04 24             	mov    %eax,(%esp)
  1011bd:	e8 22 1e 00 00       	call   102fe4 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c2:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011c9:	eb 14                	jmp    1011df <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  1011cb:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011d3:	01 d2                	add    %edx,%edx
  1011d5:	01 d0                	add    %edx,%eax
  1011d7:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011dc:	ff 45 f4             	incl   -0xc(%ebp)
  1011df:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011e6:	7e e3                	jle    1011cb <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  1011e8:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011ef:	83 e8 50             	sub    $0x50,%eax
  1011f2:	0f b7 c0             	movzwl %ax,%eax
  1011f5:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011fb:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101202:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101206:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  10120a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10120e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101212:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101213:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10121a:	c1 e8 08             	shr    $0x8,%eax
  10121d:	0f b7 c0             	movzwl %ax,%eax
  101220:	0f b6 c0             	movzbl %al,%eax
  101223:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  10122a:	42                   	inc    %edx
  10122b:	0f b7 d2             	movzwl %dx,%edx
  10122e:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101232:	88 45 e9             	mov    %al,-0x17(%ebp)
  101235:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101239:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10123d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10123e:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101245:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101249:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  10124d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101251:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101255:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101256:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10125d:	0f b6 c0             	movzbl %al,%eax
  101260:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101267:	42                   	inc    %edx
  101268:	0f b7 d2             	movzwl %dx,%edx
  10126b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10126f:	88 45 f1             	mov    %al,-0xf(%ebp)
  101272:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101276:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10127a:	ee                   	out    %al,(%dx)
}
  10127b:	90                   	nop
  10127c:	83 c4 34             	add    $0x34,%esp
  10127f:	5b                   	pop    %ebx
  101280:	5d                   	pop    %ebp
  101281:	c3                   	ret    

00101282 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101282:	55                   	push   %ebp
  101283:	89 e5                	mov    %esp,%ebp
  101285:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101288:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10128f:	eb 08                	jmp    101299 <serial_putc_sub+0x17>
        delay();
  101291:	e8 3e fb ff ff       	call   100dd4 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101296:	ff 45 fc             	incl   -0x4(%ebp)
  101299:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10129f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012a3:	89 c2                	mov    %eax,%edx
  1012a5:	ec                   	in     (%dx),%al
  1012a6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012a9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012ad:	0f b6 c0             	movzbl %al,%eax
  1012b0:	83 e0 20             	and    $0x20,%eax
  1012b3:	85 c0                	test   %eax,%eax
  1012b5:	75 09                	jne    1012c0 <serial_putc_sub+0x3e>
  1012b7:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012be:	7e d1                	jle    101291 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1012c3:	0f b6 c0             	movzbl %al,%eax
  1012c6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012cc:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012cf:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012d3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012d7:	ee                   	out    %al,(%dx)
}
  1012d8:	90                   	nop
  1012d9:	c9                   	leave  
  1012da:	c3                   	ret    

001012db <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012db:	55                   	push   %ebp
  1012dc:	89 e5                	mov    %esp,%ebp
  1012de:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012e1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012e5:	74 0d                	je     1012f4 <serial_putc+0x19>
        serial_putc_sub(c);
  1012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ea:	89 04 24             	mov    %eax,(%esp)
  1012ed:	e8 90 ff ff ff       	call   101282 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012f2:	eb 24                	jmp    101318 <serial_putc+0x3d>
        serial_putc_sub('\b');
  1012f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012fb:	e8 82 ff ff ff       	call   101282 <serial_putc_sub>
        serial_putc_sub(' ');
  101300:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101307:	e8 76 ff ff ff       	call   101282 <serial_putc_sub>
        serial_putc_sub('\b');
  10130c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101313:	e8 6a ff ff ff       	call   101282 <serial_putc_sub>
}
  101318:	90                   	nop
  101319:	c9                   	leave  
  10131a:	c3                   	ret    

0010131b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10131b:	55                   	push   %ebp
  10131c:	89 e5                	mov    %esp,%ebp
  10131e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101321:	eb 33                	jmp    101356 <cons_intr+0x3b>
        if (c != 0) {
  101323:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101327:	74 2d                	je     101356 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101329:	a1 84 00 11 00       	mov    0x110084,%eax
  10132e:	8d 50 01             	lea    0x1(%eax),%edx
  101331:	89 15 84 00 11 00    	mov    %edx,0x110084
  101337:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10133a:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101340:	a1 84 00 11 00       	mov    0x110084,%eax
  101345:	3d 00 02 00 00       	cmp    $0x200,%eax
  10134a:	75 0a                	jne    101356 <cons_intr+0x3b>
                cons.wpos = 0;
  10134c:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  101353:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101356:	8b 45 08             	mov    0x8(%ebp),%eax
  101359:	ff d0                	call   *%eax
  10135b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10135e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101362:	75 bf                	jne    101323 <cons_intr+0x8>
            }
        }
    }
}
  101364:	90                   	nop
  101365:	c9                   	leave  
  101366:	c3                   	ret    

00101367 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101367:	55                   	push   %ebp
  101368:	89 e5                	mov    %esp,%ebp
  10136a:	83 ec 10             	sub    $0x10,%esp
  10136d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101373:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101377:	89 c2                	mov    %eax,%edx
  101379:	ec                   	in     (%dx),%al
  10137a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10137d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101381:	0f b6 c0             	movzbl %al,%eax
  101384:	83 e0 01             	and    $0x1,%eax
  101387:	85 c0                	test   %eax,%eax
  101389:	75 07                	jne    101392 <serial_proc_data+0x2b>
        return -1;
  10138b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101390:	eb 2a                	jmp    1013bc <serial_proc_data+0x55>
  101392:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101398:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10139c:	89 c2                	mov    %eax,%edx
  10139e:	ec                   	in     (%dx),%al
  10139f:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013a2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013a6:	0f b6 c0             	movzbl %al,%eax
  1013a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ac:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013b0:	75 07                	jne    1013b9 <serial_proc_data+0x52>
        c = '\b';
  1013b2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013bc:	c9                   	leave  
  1013bd:	c3                   	ret    

001013be <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013be:	55                   	push   %ebp
  1013bf:	89 e5                	mov    %esp,%ebp
  1013c1:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013c4:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1013c9:	85 c0                	test   %eax,%eax
  1013cb:	74 0c                	je     1013d9 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013cd:	c7 04 24 67 13 10 00 	movl   $0x101367,(%esp)
  1013d4:	e8 42 ff ff ff       	call   10131b <cons_intr>
    }
}
  1013d9:	90                   	nop
  1013da:	c9                   	leave  
  1013db:	c3                   	ret    

001013dc <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013dc:	55                   	push   %ebp
  1013dd:	89 e5                	mov    %esp,%ebp
  1013df:	83 ec 38             	sub    $0x38,%esp
  1013e2:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013eb:	89 c2                	mov    %eax,%edx
  1013ed:	ec                   	in     (%dx),%al
  1013ee:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013f1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013f5:	0f b6 c0             	movzbl %al,%eax
  1013f8:	83 e0 01             	and    $0x1,%eax
  1013fb:	85 c0                	test   %eax,%eax
  1013fd:	75 0a                	jne    101409 <kbd_proc_data+0x2d>
        return -1;
  1013ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101404:	e9 55 01 00 00       	jmp    10155e <kbd_proc_data+0x182>
  101409:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10140f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101412:	89 c2                	mov    %eax,%edx
  101414:	ec                   	in     (%dx),%al
  101415:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101418:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10141c:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10141f:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101423:	75 17                	jne    10143c <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101425:	a1 88 00 11 00       	mov    0x110088,%eax
  10142a:	83 c8 40             	or     $0x40,%eax
  10142d:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101432:	b8 00 00 00 00       	mov    $0x0,%eax
  101437:	e9 22 01 00 00       	jmp    10155e <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  10143c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101440:	84 c0                	test   %al,%al
  101442:	79 45                	jns    101489 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101444:	a1 88 00 11 00       	mov    0x110088,%eax
  101449:	83 e0 40             	and    $0x40,%eax
  10144c:	85 c0                	test   %eax,%eax
  10144e:	75 08                	jne    101458 <kbd_proc_data+0x7c>
  101450:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101454:	24 7f                	and    $0x7f,%al
  101456:	eb 04                	jmp    10145c <kbd_proc_data+0x80>
  101458:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10145c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10145f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101463:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10146a:	0c 40                	or     $0x40,%al
  10146c:	0f b6 c0             	movzbl %al,%eax
  10146f:	f7 d0                	not    %eax
  101471:	89 c2                	mov    %eax,%edx
  101473:	a1 88 00 11 00       	mov    0x110088,%eax
  101478:	21 d0                	and    %edx,%eax
  10147a:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  10147f:	b8 00 00 00 00       	mov    $0x0,%eax
  101484:	e9 d5 00 00 00       	jmp    10155e <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  101489:	a1 88 00 11 00       	mov    0x110088,%eax
  10148e:	83 e0 40             	and    $0x40,%eax
  101491:	85 c0                	test   %eax,%eax
  101493:	74 11                	je     1014a6 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101495:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101499:	a1 88 00 11 00       	mov    0x110088,%eax
  10149e:	83 e0 bf             	and    $0xffffffbf,%eax
  1014a1:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  1014a6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014aa:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014b1:	0f b6 d0             	movzbl %al,%edx
  1014b4:	a1 88 00 11 00       	mov    0x110088,%eax
  1014b9:	09 d0                	or     %edx,%eax
  1014bb:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  1014c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c4:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  1014cb:	0f b6 d0             	movzbl %al,%edx
  1014ce:	a1 88 00 11 00       	mov    0x110088,%eax
  1014d3:	31 d0                	xor    %edx,%eax
  1014d5:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014da:	a1 88 00 11 00       	mov    0x110088,%eax
  1014df:	83 e0 03             	and    $0x3,%eax
  1014e2:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  1014e9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ed:	01 d0                	add    %edx,%eax
  1014ef:	0f b6 00             	movzbl (%eax),%eax
  1014f2:	0f b6 c0             	movzbl %al,%eax
  1014f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014f8:	a1 88 00 11 00       	mov    0x110088,%eax
  1014fd:	83 e0 08             	and    $0x8,%eax
  101500:	85 c0                	test   %eax,%eax
  101502:	74 22                	je     101526 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101504:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101508:	7e 0c                	jle    101516 <kbd_proc_data+0x13a>
  10150a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10150e:	7f 06                	jg     101516 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  101510:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101514:	eb 10                	jmp    101526 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101516:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10151a:	7e 0a                	jle    101526 <kbd_proc_data+0x14a>
  10151c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101520:	7f 04                	jg     101526 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101522:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101526:	a1 88 00 11 00       	mov    0x110088,%eax
  10152b:	f7 d0                	not    %eax
  10152d:	83 e0 06             	and    $0x6,%eax
  101530:	85 c0                	test   %eax,%eax
  101532:	75 27                	jne    10155b <kbd_proc_data+0x17f>
  101534:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10153b:	75 1e                	jne    10155b <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  10153d:	c7 04 24 d5 3a 10 00 	movl   $0x103ad5,(%esp)
  101544:	e8 23 ed ff ff       	call   10026c <cprintf>
  101549:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10154f:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101553:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101557:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10155a:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10155e:	c9                   	leave  
  10155f:	c3                   	ret    

00101560 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101560:	55                   	push   %ebp
  101561:	89 e5                	mov    %esp,%ebp
  101563:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101566:	c7 04 24 dc 13 10 00 	movl   $0x1013dc,(%esp)
  10156d:	e8 a9 fd ff ff       	call   10131b <cons_intr>
}
  101572:	90                   	nop
  101573:	c9                   	leave  
  101574:	c3                   	ret    

00101575 <kbd_init>:

static void
kbd_init(void) {
  101575:	55                   	push   %ebp
  101576:	89 e5                	mov    %esp,%ebp
  101578:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10157b:	e8 e0 ff ff ff       	call   101560 <kbd_intr>
    pic_enable(IRQ_KBD);
  101580:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101587:	e8 0f 01 00 00       	call   10169b <pic_enable>
}
  10158c:	90                   	nop
  10158d:	c9                   	leave  
  10158e:	c3                   	ret    

0010158f <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10158f:	55                   	push   %ebp
  101590:	89 e5                	mov    %esp,%ebp
  101592:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101595:	e8 83 f8 ff ff       	call   100e1d <cga_init>
    serial_init();
  10159a:	e8 62 f9 ff ff       	call   100f01 <serial_init>
    kbd_init();
  10159f:	e8 d1 ff ff ff       	call   101575 <kbd_init>
    if (!serial_exists) {
  1015a4:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1015a9:	85 c0                	test   %eax,%eax
  1015ab:	75 0c                	jne    1015b9 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ad:	c7 04 24 e1 3a 10 00 	movl   $0x103ae1,(%esp)
  1015b4:	e8 b3 ec ff ff       	call   10026c <cprintf>
    }
}
  1015b9:	90                   	nop
  1015ba:	c9                   	leave  
  1015bb:	c3                   	ret    

001015bc <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015bc:	55                   	push   %ebp
  1015bd:	89 e5                	mov    %esp,%ebp
  1015bf:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c5:	89 04 24             	mov    %eax,(%esp)
  1015c8:	e8 91 fa ff ff       	call   10105e <lpt_putc>
    cga_putc(c);
  1015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d0:	89 04 24             	mov    %eax,(%esp)
  1015d3:	e8 c6 fa ff ff       	call   10109e <cga_putc>
    serial_putc(c);
  1015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1015db:	89 04 24             	mov    %eax,(%esp)
  1015de:	e8 f8 fc ff ff       	call   1012db <serial_putc>
}
  1015e3:	90                   	nop
  1015e4:	c9                   	leave  
  1015e5:	c3                   	ret    

001015e6 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015e6:	55                   	push   %ebp
  1015e7:	89 e5                	mov    %esp,%ebp
  1015e9:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015ec:	e8 cd fd ff ff       	call   1013be <serial_intr>
    kbd_intr();
  1015f1:	e8 6a ff ff ff       	call   101560 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015f6:	8b 15 80 00 11 00    	mov    0x110080,%edx
  1015fc:	a1 84 00 11 00       	mov    0x110084,%eax
  101601:	39 c2                	cmp    %eax,%edx
  101603:	74 36                	je     10163b <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  101605:	a1 80 00 11 00       	mov    0x110080,%eax
  10160a:	8d 50 01             	lea    0x1(%eax),%edx
  10160d:	89 15 80 00 11 00    	mov    %edx,0x110080
  101613:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  10161a:	0f b6 c0             	movzbl %al,%eax
  10161d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101620:	a1 80 00 11 00       	mov    0x110080,%eax
  101625:	3d 00 02 00 00       	cmp    $0x200,%eax
  10162a:	75 0a                	jne    101636 <cons_getc+0x50>
            cons.rpos = 0;
  10162c:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  101633:	00 00 00 
        }
        return c;
  101636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101639:	eb 05                	jmp    101640 <cons_getc+0x5a>
    }
    return 0;
  10163b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101640:	c9                   	leave  
  101641:	c3                   	ret    

00101642 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101642:	55                   	push   %ebp
  101643:	89 e5                	mov    %esp,%ebp
  101645:	83 ec 14             	sub    $0x14,%esp
  101648:	8b 45 08             	mov    0x8(%ebp),%eax
  10164b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10164f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101652:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  101658:	a1 8c 00 11 00       	mov    0x11008c,%eax
  10165d:	85 c0                	test   %eax,%eax
  10165f:	74 37                	je     101698 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101664:	0f b6 c0             	movzbl %al,%eax
  101667:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  10166d:	88 45 f9             	mov    %al,-0x7(%ebp)
  101670:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101674:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101678:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101679:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10167d:	c1 e8 08             	shr    $0x8,%eax
  101680:	0f b7 c0             	movzwl %ax,%eax
  101683:	0f b6 c0             	movzbl %al,%eax
  101686:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  10168c:	88 45 fd             	mov    %al,-0x3(%ebp)
  10168f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101693:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101697:	ee                   	out    %al,(%dx)
    }
}
  101698:	90                   	nop
  101699:	c9                   	leave  
  10169a:	c3                   	ret    

0010169b <pic_enable>:

void
pic_enable(unsigned int irq) {
  10169b:	55                   	push   %ebp
  10169c:	89 e5                	mov    %esp,%ebp
  10169e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a4:	ba 01 00 00 00       	mov    $0x1,%edx
  1016a9:	88 c1                	mov    %al,%cl
  1016ab:	d3 e2                	shl    %cl,%edx
  1016ad:	89 d0                	mov    %edx,%eax
  1016af:	98                   	cwtl   
  1016b0:	f7 d0                	not    %eax
  1016b2:	0f bf d0             	movswl %ax,%edx
  1016b5:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1016bc:	98                   	cwtl   
  1016bd:	21 d0                	and    %edx,%eax
  1016bf:	98                   	cwtl   
  1016c0:	0f b7 c0             	movzwl %ax,%eax
  1016c3:	89 04 24             	mov    %eax,(%esp)
  1016c6:	e8 77 ff ff ff       	call   101642 <pic_setmask>
}
  1016cb:	90                   	nop
  1016cc:	c9                   	leave  
  1016cd:	c3                   	ret    

001016ce <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016ce:	55                   	push   %ebp
  1016cf:	89 e5                	mov    %esp,%ebp
  1016d1:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016d4:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  1016db:	00 00 00 
  1016de:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016e4:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016e8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016ec:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016f0:	ee                   	out    %al,(%dx)
  1016f1:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016f7:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016fb:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016ff:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101703:	ee                   	out    %al,(%dx)
  101704:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10170a:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  10170e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101712:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101716:	ee                   	out    %al,(%dx)
  101717:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10171d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101721:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101725:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101729:	ee                   	out    %al,(%dx)
  10172a:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101730:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101734:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101738:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10173c:	ee                   	out    %al,(%dx)
  10173d:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101743:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101747:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10174b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10174f:	ee                   	out    %al,(%dx)
  101750:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101756:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  10175a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10175e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
  101763:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101769:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  10176d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101771:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101775:	ee                   	out    %al,(%dx)
  101776:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10177c:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101780:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101784:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101788:	ee                   	out    %al,(%dx)
  101789:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10178f:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101793:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101797:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10179b:	ee                   	out    %al,(%dx)
  10179c:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1017a2:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  1017a6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017aa:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017ae:	ee                   	out    %al,(%dx)
  1017af:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017b5:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  1017b9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017bd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017c1:	ee                   	out    %al,(%dx)
  1017c2:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017c8:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  1017cc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017d0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017d4:	ee                   	out    %al,(%dx)
  1017d5:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017db:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017e7:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017e8:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1017ef:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1017f4:	74 0f                	je     101805 <pic_init+0x137>
        pic_setmask(irq_mask);
  1017f6:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1017fd:	89 04 24             	mov    %eax,(%esp)
  101800:	e8 3d fe ff ff       	call   101642 <pic_setmask>
    }
}
  101805:	90                   	nop
  101806:	c9                   	leave  
  101807:	c3                   	ret    

00101808 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101808:	55                   	push   %ebp
  101809:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10180b:	fb                   	sti    
    sti();
}
  10180c:	90                   	nop
  10180d:	5d                   	pop    %ebp
  10180e:	c3                   	ret    

0010180f <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10180f:	55                   	push   %ebp
  101810:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101812:	fa                   	cli    
    cli();
}
  101813:	90                   	nop
  101814:	5d                   	pop    %ebp
  101815:	c3                   	ret    

00101816 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101816:	55                   	push   %ebp
  101817:	89 e5                	mov    %esp,%ebp
  101819:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10181c:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101823:	00 
  101824:	c7 04 24 00 3b 10 00 	movl   $0x103b00,(%esp)
  10182b:	e8 3c ea ff ff       	call   10026c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101830:	c7 04 24 0a 3b 10 00 	movl   $0x103b0a,(%esp)
  101837:	e8 30 ea ff ff       	call   10026c <cprintf>
    panic("EOT: kernel seems ok.");
  10183c:	c7 44 24 08 18 3b 10 	movl   $0x103b18,0x8(%esp)
  101843:	00 
  101844:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10184b:	00 
  10184c:	c7 04 24 2e 3b 10 00 	movl   $0x103b2e,(%esp)
  101853:	e8 6b eb ff ff       	call   1003c3 <__panic>

00101858 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101858:	55                   	push   %ebp
  101859:	89 e5                	mov    %esp,%ebp
  10185b:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10185e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101865:	e9 c4 00 00 00       	jmp    10192e <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10186a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186d:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  101874:	0f b7 d0             	movzwl %ax,%edx
  101877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187a:	66 89 14 c5 a0 00 11 	mov    %dx,0x1100a0(,%eax,8)
  101881:	00 
  101882:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101885:	66 c7 04 c5 a2 00 11 	movw   $0x8,0x1100a2(,%eax,8)
  10188c:	00 08 00 
  10188f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101892:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  101899:	00 
  10189a:	80 e2 e0             	and    $0xe0,%dl
  10189d:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  1018a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a7:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  1018ae:	00 
  1018af:	80 e2 1f             	and    $0x1f,%dl
  1018b2:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  1018b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bc:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1018c3:	00 
  1018c4:	80 e2 f0             	and    $0xf0,%dl
  1018c7:	80 ca 0e             	or     $0xe,%dl
  1018ca:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1018d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d4:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1018db:	00 
  1018dc:	80 e2 ef             	and    $0xef,%dl
  1018df:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1018f0:	00 
  1018f1:	80 e2 9f             	and    $0x9f,%dl
  1018f4:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fe:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  101905:	00 
  101906:	80 ca 80             	or     $0x80,%dl
  101909:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101913:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10191a:	c1 e8 10             	shr    $0x10,%eax
  10191d:	0f b7 d0             	movzwl %ax,%edx
  101920:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101923:	66 89 14 c5 a6 00 11 	mov    %dx,0x1100a6(,%eax,8)
  10192a:	00 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10192b:	ff 45 fc             	incl   -0x4(%ebp)
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	3d ff 00 00 00       	cmp    $0xff,%eax
  101936:	0f 86 2e ff ff ff    	jbe    10186a <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  10193c:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101941:	0f b7 c0             	movzwl %ax,%eax
  101944:	66 a3 68 04 11 00    	mov    %ax,0x110468
  10194a:	66 c7 05 6a 04 11 00 	movw   $0x8,0x11046a
  101951:	08 00 
  101953:	0f b6 05 6c 04 11 00 	movzbl 0x11046c,%eax
  10195a:	24 e0                	and    $0xe0,%al
  10195c:	a2 6c 04 11 00       	mov    %al,0x11046c
  101961:	0f b6 05 6c 04 11 00 	movzbl 0x11046c,%eax
  101968:	24 1f                	and    $0x1f,%al
  10196a:	a2 6c 04 11 00       	mov    %al,0x11046c
  10196f:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101976:	0c 0f                	or     $0xf,%al
  101978:	a2 6d 04 11 00       	mov    %al,0x11046d
  10197d:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101984:	24 ef                	and    $0xef,%al
  101986:	a2 6d 04 11 00       	mov    %al,0x11046d
  10198b:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101992:	0c 60                	or     $0x60,%al
  101994:	a2 6d 04 11 00       	mov    %al,0x11046d
  101999:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  1019a0:	0c 80                	or     $0x80,%al
  1019a2:	a2 6d 04 11 00       	mov    %al,0x11046d
  1019a7:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  1019ac:	c1 e8 10             	shr    $0x10,%eax
  1019af:	0f b7 c0             	movzwl %ax,%eax
  1019b2:	66 a3 6e 04 11 00    	mov    %ax,0x11046e
  1019b8:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019c2:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
  1019c5:	90                   	nop
  1019c6:	c9                   	leave  
  1019c7:	c3                   	ret    

001019c8 <trapname>:

static const char *
trapname(int trapno) {
  1019c8:	55                   	push   %ebp
  1019c9:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ce:	83 f8 13             	cmp    $0x13,%eax
  1019d1:	77 0c                	ja     1019df <trapname+0x17>
        return excnames[trapno];
  1019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d6:	8b 04 85 80 3e 10 00 	mov    0x103e80(,%eax,4),%eax
  1019dd:	eb 18                	jmp    1019f7 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019df:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019e3:	7e 0d                	jle    1019f2 <trapname+0x2a>
  1019e5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019e9:	7f 07                	jg     1019f2 <trapname+0x2a>
        return "Hardware Interrupt";
  1019eb:	b8 3f 3b 10 00       	mov    $0x103b3f,%eax
  1019f0:	eb 05                	jmp    1019f7 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019f2:	b8 52 3b 10 00       	mov    $0x103b52,%eax
}
  1019f7:	5d                   	pop    %ebp
  1019f8:	c3                   	ret    

001019f9 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019f9:	55                   	push   %ebp
  1019fa:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ff:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a03:	83 f8 08             	cmp    $0x8,%eax
  101a06:	0f 94 c0             	sete   %al
  101a09:	0f b6 c0             	movzbl %al,%eax
}
  101a0c:	5d                   	pop    %ebp
  101a0d:	c3                   	ret    

00101a0e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a0e:	55                   	push   %ebp
  101a0f:	89 e5                	mov    %esp,%ebp
  101a11:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a14:	8b 45 08             	mov    0x8(%ebp),%eax
  101a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1b:	c7 04 24 93 3b 10 00 	movl   $0x103b93,(%esp)
  101a22:	e8 45 e8 ff ff       	call   10026c <cprintf>
    print_regs(&tf->tf_regs);
  101a27:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2a:	89 04 24             	mov    %eax,(%esp)
  101a2d:	e8 8f 01 00 00       	call   101bc1 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a32:	8b 45 08             	mov    0x8(%ebp),%eax
  101a35:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3d:	c7 04 24 a4 3b 10 00 	movl   $0x103ba4,(%esp)
  101a44:	e8 23 e8 ff ff       	call   10026c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a49:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a54:	c7 04 24 b7 3b 10 00 	movl   $0x103bb7,(%esp)
  101a5b:	e8 0c e8 ff ff       	call   10026c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a60:	8b 45 08             	mov    0x8(%ebp),%eax
  101a63:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6b:	c7 04 24 ca 3b 10 00 	movl   $0x103bca,(%esp)
  101a72:	e8 f5 e7 ff ff       	call   10026c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a77:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a82:	c7 04 24 dd 3b 10 00 	movl   $0x103bdd,(%esp)
  101a89:	e8 de e7 ff ff       	call   10026c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a91:	8b 40 30             	mov    0x30(%eax),%eax
  101a94:	89 04 24             	mov    %eax,(%esp)
  101a97:	e8 2c ff ff ff       	call   1019c8 <trapname>
  101a9c:	89 c2                	mov    %eax,%edx
  101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa1:	8b 40 30             	mov    0x30(%eax),%eax
  101aa4:	89 54 24 08          	mov    %edx,0x8(%esp)
  101aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aac:	c7 04 24 f0 3b 10 00 	movl   $0x103bf0,(%esp)
  101ab3:	e8 b4 e7 ff ff       	call   10026c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  101abb:	8b 40 34             	mov    0x34(%eax),%eax
  101abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac2:	c7 04 24 02 3c 10 00 	movl   $0x103c02,(%esp)
  101ac9:	e8 9e e7 ff ff       	call   10026c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ace:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad1:	8b 40 38             	mov    0x38(%eax),%eax
  101ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad8:	c7 04 24 11 3c 10 00 	movl   $0x103c11,(%esp)
  101adf:	e8 88 e7 ff ff       	call   10026c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aef:	c7 04 24 20 3c 10 00 	movl   $0x103c20,(%esp)
  101af6:	e8 71 e7 ff ff       	call   10026c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101afb:	8b 45 08             	mov    0x8(%ebp),%eax
  101afe:	8b 40 40             	mov    0x40(%eax),%eax
  101b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b05:	c7 04 24 33 3c 10 00 	movl   $0x103c33,(%esp)
  101b0c:	e8 5b e7 ff ff       	call   10026c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b18:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b1f:	eb 3d                	jmp    101b5e <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b21:	8b 45 08             	mov    0x8(%ebp),%eax
  101b24:	8b 50 40             	mov    0x40(%eax),%edx
  101b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b2a:	21 d0                	and    %edx,%eax
  101b2c:	85 c0                	test   %eax,%eax
  101b2e:	74 28                	je     101b58 <print_trapframe+0x14a>
  101b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b33:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b3a:	85 c0                	test   %eax,%eax
  101b3c:	74 1a                	je     101b58 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b41:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4c:	c7 04 24 42 3c 10 00 	movl   $0x103c42,(%esp)
  101b53:	e8 14 e7 ff ff       	call   10026c <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b58:	ff 45 f4             	incl   -0xc(%ebp)
  101b5b:	d1 65 f0             	shll   -0x10(%ebp)
  101b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b61:	83 f8 17             	cmp    $0x17,%eax
  101b64:	76 bb                	jbe    101b21 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b66:	8b 45 08             	mov    0x8(%ebp),%eax
  101b69:	8b 40 40             	mov    0x40(%eax),%eax
  101b6c:	c1 e8 0c             	shr    $0xc,%eax
  101b6f:	83 e0 03             	and    $0x3,%eax
  101b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b76:	c7 04 24 46 3c 10 00 	movl   $0x103c46,(%esp)
  101b7d:	e8 ea e6 ff ff       	call   10026c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b82:	8b 45 08             	mov    0x8(%ebp),%eax
  101b85:	89 04 24             	mov    %eax,(%esp)
  101b88:	e8 6c fe ff ff       	call   1019f9 <trap_in_kernel>
  101b8d:	85 c0                	test   %eax,%eax
  101b8f:	75 2d                	jne    101bbe <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b91:	8b 45 08             	mov    0x8(%ebp),%eax
  101b94:	8b 40 44             	mov    0x44(%eax),%eax
  101b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9b:	c7 04 24 4f 3c 10 00 	movl   $0x103c4f,(%esp)
  101ba2:	e8 c5 e6 ff ff       	call   10026c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  101baa:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb2:	c7 04 24 5e 3c 10 00 	movl   $0x103c5e,(%esp)
  101bb9:	e8 ae e6 ff ff       	call   10026c <cprintf>
    }
}
  101bbe:	90                   	nop
  101bbf:	c9                   	leave  
  101bc0:	c3                   	ret    

00101bc1 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bc1:	55                   	push   %ebp
  101bc2:	89 e5                	mov    %esp,%ebp
  101bc4:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bca:	8b 00                	mov    (%eax),%eax
  101bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd0:	c7 04 24 71 3c 10 00 	movl   $0x103c71,(%esp)
  101bd7:	e8 90 e6 ff ff       	call   10026c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdf:	8b 40 04             	mov    0x4(%eax),%eax
  101be2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be6:	c7 04 24 80 3c 10 00 	movl   $0x103c80,(%esp)
  101bed:	e8 7a e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf5:	8b 40 08             	mov    0x8(%eax),%eax
  101bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfc:	c7 04 24 8f 3c 10 00 	movl   $0x103c8f,(%esp)
  101c03:	e8 64 e6 ff ff       	call   10026c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c08:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0b:	8b 40 0c             	mov    0xc(%eax),%eax
  101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c12:	c7 04 24 9e 3c 10 00 	movl   $0x103c9e,(%esp)
  101c19:	e8 4e e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c21:	8b 40 10             	mov    0x10(%eax),%eax
  101c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c28:	c7 04 24 ad 3c 10 00 	movl   $0x103cad,(%esp)
  101c2f:	e8 38 e6 ff ff       	call   10026c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c34:	8b 45 08             	mov    0x8(%ebp),%eax
  101c37:	8b 40 14             	mov    0x14(%eax),%eax
  101c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3e:	c7 04 24 bc 3c 10 00 	movl   $0x103cbc,(%esp)
  101c45:	e8 22 e6 ff ff       	call   10026c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4d:	8b 40 18             	mov    0x18(%eax),%eax
  101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c54:	c7 04 24 cb 3c 10 00 	movl   $0x103ccb,(%esp)
  101c5b:	e8 0c e6 ff ff       	call   10026c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c60:	8b 45 08             	mov    0x8(%ebp),%eax
  101c63:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6a:	c7 04 24 da 3c 10 00 	movl   $0x103cda,(%esp)
  101c71:	e8 f6 e5 ff ff       	call   10026c <cprintf>
}
  101c76:	90                   	nop
  101c77:	c9                   	leave  
  101c78:	c3                   	ret    

00101c79 <trap_dispatch>:
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c79:	55                   	push   %ebp
  101c7a:	89 e5                	mov    %esp,%ebp
  101c7c:	57                   	push   %edi
  101c7d:	56                   	push   %esi
  101c7e:	53                   	push   %ebx
  101c7f:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c82:	8b 45 08             	mov    0x8(%ebp),%eax
  101c85:	8b 40 30             	mov    0x30(%eax),%eax
  101c88:	83 f8 2f             	cmp    $0x2f,%eax
  101c8b:	77 21                	ja     101cae <trap_dispatch+0x35>
  101c8d:	83 f8 2e             	cmp    $0x2e,%eax
  101c90:	0f 83 f9 03 00 00    	jae    10208f <trap_dispatch+0x416>
  101c96:	83 f8 21             	cmp    $0x21,%eax
  101c99:	0f 84 9c 00 00 00    	je     101d3b <trap_dispatch+0xc2>
  101c9f:	83 f8 24             	cmp    $0x24,%eax
  101ca2:	74 6e                	je     101d12 <trap_dispatch+0x99>
  101ca4:	83 f8 20             	cmp    $0x20,%eax
  101ca7:	74 1c                	je     101cc5 <trap_dispatch+0x4c>
  101ca9:	e9 ac 03 00 00       	jmp    10205a <trap_dispatch+0x3e1>
  101cae:	83 f8 78             	cmp    $0x78,%eax
  101cb1:	0f 84 42 02 00 00    	je     101ef9 <trap_dispatch+0x280>
  101cb7:	83 f8 79             	cmp    $0x79,%eax
  101cba:	0f 84 1d 03 00 00    	je     101fdd <trap_dispatch+0x364>
  101cc0:	e9 95 03 00 00       	jmp    10205a <trap_dispatch+0x3e1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101cc5:	a1 08 09 11 00       	mov    0x110908,%eax
  101cca:	40                   	inc    %eax
  101ccb:	a3 08 09 11 00       	mov    %eax,0x110908
        if(ticks % 100 == 0)
  101cd0:	8b 0d 08 09 11 00    	mov    0x110908,%ecx
  101cd6:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cdb:	89 c8                	mov    %ecx,%eax
  101cdd:	f7 e2                	mul    %edx
  101cdf:	c1 ea 05             	shr    $0x5,%edx
  101ce2:	89 d0                	mov    %edx,%eax
  101ce4:	c1 e0 02             	shl    $0x2,%eax
  101ce7:	01 d0                	add    %edx,%eax
  101ce9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101cf0:	01 d0                	add    %edx,%eax
  101cf2:	c1 e0 02             	shl    $0x2,%eax
  101cf5:	29 c1                	sub    %eax,%ecx
  101cf7:	89 ca                	mov    %ecx,%edx
  101cf9:	85 d2                	test   %edx,%edx
  101cfb:	0f 85 91 03 00 00    	jne    102092 <trap_dispatch+0x419>
            print_ticks("100 ticks");
  101d01:	c7 04 24 e9 3c 10 00 	movl   $0x103ce9,(%esp)
  101d08:	e8 09 fb ff ff       	call   101816 <print_ticks>
        break;
  101d0d:	e9 80 03 00 00       	jmp    102092 <trap_dispatch+0x419>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d12:	e8 cf f8 ff ff       	call   1015e6 <cons_getc>
  101d17:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d1a:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d1e:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d22:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d26:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2a:	c7 04 24 f3 3c 10 00 	movl   $0x103cf3,(%esp)
  101d31:	e8 36 e5 ff ff       	call   10026c <cprintf>
        break;
  101d36:	e9 5e 03 00 00       	jmp    102099 <trap_dispatch+0x420>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d3b:	e8 a6 f8 ff ff       	call   1015e6 <cons_getc>
  101d40:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d43:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d47:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d53:	c7 04 24 05 3d 10 00 	movl   $0x103d05,(%esp)
  101d5a:	e8 0d e5 ff ff       	call   10026c <cprintf>
        switch (c)
  101d5f:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d63:	83 f8 30             	cmp    $0x30,%eax
  101d66:	74 0e                	je     101d76 <trap_dispatch+0xfd>
  101d68:	83 f8 33             	cmp    $0x33,%eax
  101d6b:	0f 84 90 00 00 00    	je     101e01 <trap_dispatch+0x188>
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
            print_trapframe(tf);
        }
        break;
        default:
            break;
  101d71:	e9 7e 01 00 00       	jmp    101ef4 <trap_dispatch+0x27b>
            if (tf->tf_cs != KERNEL_CS) {
  101d76:	8b 45 08             	mov    0x8(%ebp),%eax
  101d79:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d7d:	83 f8 08             	cmp    $0x8,%eax
  101d80:	0f 84 67 01 00 00    	je     101eed <trap_dispatch+0x274>
            tf->tf_cs = KERNEL_CS;
  101d86:	8b 45 08             	mov    0x8(%ebp),%eax
  101d89:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d92:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101d98:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101da2:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101da6:	8b 45 08             	mov    0x8(%ebp),%eax
  101da9:	8b 40 40             	mov    0x40(%eax),%eax
  101dac:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101db1:	89 c2                	mov    %eax,%edx
  101db3:	8b 45 08             	mov    0x8(%ebp),%eax
  101db6:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101db9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbc:	8b 40 44             	mov    0x44(%eax),%eax
  101dbf:	83 e8 44             	sub    $0x44,%eax
  101dc2:	a3 6c 09 11 00       	mov    %eax,0x11096c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101dc7:	a1 6c 09 11 00       	mov    0x11096c,%eax
  101dcc:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101dd3:	00 
  101dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  101dd7:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ddb:	89 04 24             	mov    %eax,(%esp)
  101dde:	e8 01 12 00 00       	call   102fe4 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101de3:	8b 15 6c 09 11 00    	mov    0x11096c,%edx
  101de9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dec:	83 e8 04             	sub    $0x4,%eax
  101def:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
  101df1:	8b 45 08             	mov    0x8(%ebp),%eax
  101df4:	89 04 24             	mov    %eax,(%esp)
  101df7:	e8 12 fc ff ff       	call   101a0e <print_trapframe>
            break;
  101dfc:	e9 ec 00 00 00       	jmp    101eed <trap_dispatch+0x274>
            if (tf->tf_cs != USER_CS) {
  101e01:	8b 45 08             	mov    0x8(%ebp),%eax
  101e04:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e08:	83 f8 1b             	cmp    $0x1b,%eax
  101e0b:	0f 84 e2 00 00 00    	je     101ef3 <trap_dispatch+0x27a>
            switchk2u = *tf;
  101e11:	8b 55 08             	mov    0x8(%ebp),%edx
  101e14:	b8 20 09 11 00       	mov    $0x110920,%eax
  101e19:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101e1e:	89 c1                	mov    %eax,%ecx
  101e20:	83 e1 01             	and    $0x1,%ecx
  101e23:	85 c9                	test   %ecx,%ecx
  101e25:	74 0c                	je     101e33 <trap_dispatch+0x1ba>
  101e27:	0f b6 0a             	movzbl (%edx),%ecx
  101e2a:	88 08                	mov    %cl,(%eax)
  101e2c:	8d 40 01             	lea    0x1(%eax),%eax
  101e2f:	8d 52 01             	lea    0x1(%edx),%edx
  101e32:	4b                   	dec    %ebx
  101e33:	89 c1                	mov    %eax,%ecx
  101e35:	83 e1 02             	and    $0x2,%ecx
  101e38:	85 c9                	test   %ecx,%ecx
  101e3a:	74 0f                	je     101e4b <trap_dispatch+0x1d2>
  101e3c:	0f b7 0a             	movzwl (%edx),%ecx
  101e3f:	66 89 08             	mov    %cx,(%eax)
  101e42:	8d 40 02             	lea    0x2(%eax),%eax
  101e45:	8d 52 02             	lea    0x2(%edx),%edx
  101e48:	83 eb 02             	sub    $0x2,%ebx
  101e4b:	89 df                	mov    %ebx,%edi
  101e4d:	83 e7 fc             	and    $0xfffffffc,%edi
  101e50:	b9 00 00 00 00       	mov    $0x0,%ecx
  101e55:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101e58:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101e5b:	83 c1 04             	add    $0x4,%ecx
  101e5e:	39 f9                	cmp    %edi,%ecx
  101e60:	72 f3                	jb     101e55 <trap_dispatch+0x1dc>
  101e62:	01 c8                	add    %ecx,%eax
  101e64:	01 ca                	add    %ecx,%edx
  101e66:	b9 00 00 00 00       	mov    $0x0,%ecx
  101e6b:	89 de                	mov    %ebx,%esi
  101e6d:	83 e6 02             	and    $0x2,%esi
  101e70:	85 f6                	test   %esi,%esi
  101e72:	74 0b                	je     101e7f <trap_dispatch+0x206>
  101e74:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101e78:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101e7c:	83 c1 02             	add    $0x2,%ecx
  101e7f:	83 e3 01             	and    $0x1,%ebx
  101e82:	85 db                	test   %ebx,%ebx
  101e84:	74 07                	je     101e8d <trap_dispatch+0x214>
  101e86:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101e8a:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101e8d:	66 c7 05 5c 09 11 00 	movw   $0x1b,0x11095c
  101e94:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101e96:	66 c7 05 68 09 11 00 	movw   $0x23,0x110968
  101e9d:	23 00 
  101e9f:	0f b7 05 68 09 11 00 	movzwl 0x110968,%eax
  101ea6:	66 a3 48 09 11 00    	mov    %ax,0x110948
  101eac:	0f b7 05 48 09 11 00 	movzwl 0x110948,%eax
  101eb3:	66 a3 4c 09 11 00    	mov    %ax,0x11094c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebc:	83 c0 44             	add    $0x44,%eax
  101ebf:	a3 64 09 11 00       	mov    %eax,0x110964
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101ec4:	a1 60 09 11 00       	mov    0x110960,%eax
  101ec9:	0d 00 30 00 00       	or     $0x3000,%eax
  101ece:	a3 60 09 11 00       	mov    %eax,0x110960
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed6:	83 e8 04             	sub    $0x4,%eax
  101ed9:	ba 20 09 11 00       	mov    $0x110920,%edx
  101ede:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
  101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee3:	89 04 24             	mov    %eax,(%esp)
  101ee6:	e8 23 fb ff ff       	call   101a0e <print_trapframe>
        break;
  101eeb:	eb 06                	jmp    101ef3 <trap_dispatch+0x27a>
            break;
  101eed:	90                   	nop
  101eee:	e9 a6 01 00 00       	jmp    102099 <trap_dispatch+0x420>
        break;
  101ef3:	90                   	nop
        }
        break;  
  101ef4:	e9 a0 01 00 00       	jmp    102099 <trap_dispatch+0x420>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  101efc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f00:	83 f8 1b             	cmp    $0x1b,%eax
  101f03:	0f 84 8c 01 00 00    	je     102095 <trap_dispatch+0x41c>
            switchk2u = *tf;
  101f09:	8b 55 08             	mov    0x8(%ebp),%edx
  101f0c:	b8 20 09 11 00       	mov    $0x110920,%eax
  101f11:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101f16:	89 c1                	mov    %eax,%ecx
  101f18:	83 e1 01             	and    $0x1,%ecx
  101f1b:	85 c9                	test   %ecx,%ecx
  101f1d:	74 0c                	je     101f2b <trap_dispatch+0x2b2>
  101f1f:	0f b6 0a             	movzbl (%edx),%ecx
  101f22:	88 08                	mov    %cl,(%eax)
  101f24:	8d 40 01             	lea    0x1(%eax),%eax
  101f27:	8d 52 01             	lea    0x1(%edx),%edx
  101f2a:	4b                   	dec    %ebx
  101f2b:	89 c1                	mov    %eax,%ecx
  101f2d:	83 e1 02             	and    $0x2,%ecx
  101f30:	85 c9                	test   %ecx,%ecx
  101f32:	74 0f                	je     101f43 <trap_dispatch+0x2ca>
  101f34:	0f b7 0a             	movzwl (%edx),%ecx
  101f37:	66 89 08             	mov    %cx,(%eax)
  101f3a:	8d 40 02             	lea    0x2(%eax),%eax
  101f3d:	8d 52 02             	lea    0x2(%edx),%edx
  101f40:	83 eb 02             	sub    $0x2,%ebx
  101f43:	89 df                	mov    %ebx,%edi
  101f45:	83 e7 fc             	and    $0xfffffffc,%edi
  101f48:	b9 00 00 00 00       	mov    $0x0,%ecx
  101f4d:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101f50:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101f53:	83 c1 04             	add    $0x4,%ecx
  101f56:	39 f9                	cmp    %edi,%ecx
  101f58:	72 f3                	jb     101f4d <trap_dispatch+0x2d4>
  101f5a:	01 c8                	add    %ecx,%eax
  101f5c:	01 ca                	add    %ecx,%edx
  101f5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  101f63:	89 de                	mov    %ebx,%esi
  101f65:	83 e6 02             	and    $0x2,%esi
  101f68:	85 f6                	test   %esi,%esi
  101f6a:	74 0b                	je     101f77 <trap_dispatch+0x2fe>
  101f6c:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101f70:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101f74:	83 c1 02             	add    $0x2,%ecx
  101f77:	83 e3 01             	and    $0x1,%ebx
  101f7a:	85 db                	test   %ebx,%ebx
  101f7c:	74 07                	je     101f85 <trap_dispatch+0x30c>
  101f7e:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101f82:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101f85:	66 c7 05 5c 09 11 00 	movw   $0x1b,0x11095c
  101f8c:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101f8e:	66 c7 05 68 09 11 00 	movw   $0x23,0x110968
  101f95:	23 00 
  101f97:	0f b7 05 68 09 11 00 	movzwl 0x110968,%eax
  101f9e:	66 a3 48 09 11 00    	mov    %ax,0x110948
  101fa4:	0f b7 05 48 09 11 00 	movzwl 0x110948,%eax
  101fab:	66 a3 4c 09 11 00    	mov    %ax,0x11094c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb4:	83 c0 44             	add    $0x44,%eax
  101fb7:	a3 64 09 11 00       	mov    %eax,0x110964
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101fbc:	a1 60 09 11 00       	mov    0x110960,%eax
  101fc1:	0d 00 30 00 00       	or     $0x3000,%eax
  101fc6:	a3 60 09 11 00       	mov    %eax,0x110960
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101fce:	83 e8 04             	sub    $0x4,%eax
  101fd1:	ba 20 09 11 00       	mov    $0x110920,%edx
  101fd6:	89 10                	mov    %edx,(%eax)
        }
        break;
  101fd8:	e9 b8 00 00 00       	jmp    102095 <trap_dispatch+0x41c>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fe4:	83 f8 08             	cmp    $0x8,%eax
  101fe7:	0f 84 ab 00 00 00    	je     102098 <trap_dispatch+0x41f>
            tf->tf_cs = KERNEL_CS;
  101fed:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff0:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff9:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101fff:	8b 45 08             	mov    0x8(%ebp),%eax
  102002:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102006:	8b 45 08             	mov    0x8(%ebp),%eax
  102009:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  10200d:	8b 45 08             	mov    0x8(%ebp),%eax
  102010:	8b 40 40             	mov    0x40(%eax),%eax
  102013:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  102018:	89 c2                	mov    %eax,%edx
  10201a:	8b 45 08             	mov    0x8(%ebp),%eax
  10201d:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  102020:	8b 45 08             	mov    0x8(%ebp),%eax
  102023:	8b 40 44             	mov    0x44(%eax),%eax
  102026:	83 e8 44             	sub    $0x44,%eax
  102029:	a3 6c 09 11 00       	mov    %eax,0x11096c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  10202e:	a1 6c 09 11 00       	mov    0x11096c,%eax
  102033:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  10203a:	00 
  10203b:	8b 55 08             	mov    0x8(%ebp),%edx
  10203e:	89 54 24 04          	mov    %edx,0x4(%esp)
  102042:	89 04 24             	mov    %eax,(%esp)
  102045:	e8 9a 0f 00 00       	call   102fe4 <memmove>
            //*((uint32_t *)tf - 1) = (uint32_t)tf;
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  10204a:	8b 15 6c 09 11 00    	mov    0x11096c,%edx
  102050:	8b 45 08             	mov    0x8(%ebp),%eax
  102053:	83 e8 04             	sub    $0x4,%eax
  102056:	89 10                	mov    %edx,(%eax)
        }
        break;
  102058:	eb 3e                	jmp    102098 <trap_dispatch+0x41f>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  10205a:	8b 45 08             	mov    0x8(%ebp),%eax
  10205d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102061:	83 e0 03             	and    $0x3,%eax
  102064:	85 c0                	test   %eax,%eax
  102066:	75 31                	jne    102099 <trap_dispatch+0x420>
            print_trapframe(tf);
  102068:	8b 45 08             	mov    0x8(%ebp),%eax
  10206b:	89 04 24             	mov    %eax,(%esp)
  10206e:	e8 9b f9 ff ff       	call   101a0e <print_trapframe>
            panic("unexpected trap in kernel.\n");
  102073:	c7 44 24 08 14 3d 10 	movl   $0x103d14,0x8(%esp)
  10207a:	00 
  10207b:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  102082:	00 
  102083:	c7 04 24 2e 3b 10 00 	movl   $0x103b2e,(%esp)
  10208a:	e8 34 e3 ff ff       	call   1003c3 <__panic>
        break;
  10208f:	90                   	nop
  102090:	eb 07                	jmp    102099 <trap_dispatch+0x420>
        break;
  102092:	90                   	nop
  102093:	eb 04                	jmp    102099 <trap_dispatch+0x420>
        break;
  102095:	90                   	nop
  102096:	eb 01                	jmp    102099 <trap_dispatch+0x420>
        break;
  102098:	90                   	nop
        }
    }
}
  102099:	90                   	nop
  10209a:	83 c4 2c             	add    $0x2c,%esp
  10209d:	5b                   	pop    %ebx
  10209e:	5e                   	pop    %esi
  10209f:	5f                   	pop    %edi
  1020a0:	5d                   	pop    %ebp
  1020a1:	c3                   	ret    

001020a2 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  1020a2:	55                   	push   %ebp
  1020a3:	89 e5                	mov    %esp,%ebp
  1020a5:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  1020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ab:	89 04 24             	mov    %eax,(%esp)
  1020ae:	e8 c6 fb ff ff       	call   101c79 <trap_dispatch>
}
  1020b3:	90                   	nop
  1020b4:	c9                   	leave  
  1020b5:	c3                   	ret    

001020b6 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $0
  1020b8:	6a 00                	push   $0x0
  jmp __alltraps
  1020ba:	e9 69 0a 00 00       	jmp    102b28 <__alltraps>

001020bf <vector1>:
.globl vector1
vector1:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $1
  1020c1:	6a 01                	push   $0x1
  jmp __alltraps
  1020c3:	e9 60 0a 00 00       	jmp    102b28 <__alltraps>

001020c8 <vector2>:
.globl vector2
vector2:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $2
  1020ca:	6a 02                	push   $0x2
  jmp __alltraps
  1020cc:	e9 57 0a 00 00       	jmp    102b28 <__alltraps>

001020d1 <vector3>:
.globl vector3
vector3:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $3
  1020d3:	6a 03                	push   $0x3
  jmp __alltraps
  1020d5:	e9 4e 0a 00 00       	jmp    102b28 <__alltraps>

001020da <vector4>:
.globl vector4
vector4:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $4
  1020dc:	6a 04                	push   $0x4
  jmp __alltraps
  1020de:	e9 45 0a 00 00       	jmp    102b28 <__alltraps>

001020e3 <vector5>:
.globl vector5
vector5:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $5
  1020e5:	6a 05                	push   $0x5
  jmp __alltraps
  1020e7:	e9 3c 0a 00 00       	jmp    102b28 <__alltraps>

001020ec <vector6>:
.globl vector6
vector6:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $6
  1020ee:	6a 06                	push   $0x6
  jmp __alltraps
  1020f0:	e9 33 0a 00 00       	jmp    102b28 <__alltraps>

001020f5 <vector7>:
.globl vector7
vector7:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $7
  1020f7:	6a 07                	push   $0x7
  jmp __alltraps
  1020f9:	e9 2a 0a 00 00       	jmp    102b28 <__alltraps>

001020fe <vector8>:
.globl vector8
vector8:
  pushl $8
  1020fe:	6a 08                	push   $0x8
  jmp __alltraps
  102100:	e9 23 0a 00 00       	jmp    102b28 <__alltraps>

00102105 <vector9>:
.globl vector9
vector9:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $9
  102107:	6a 09                	push   $0x9
  jmp __alltraps
  102109:	e9 1a 0a 00 00       	jmp    102b28 <__alltraps>

0010210e <vector10>:
.globl vector10
vector10:
  pushl $10
  10210e:	6a 0a                	push   $0xa
  jmp __alltraps
  102110:	e9 13 0a 00 00       	jmp    102b28 <__alltraps>

00102115 <vector11>:
.globl vector11
vector11:
  pushl $11
  102115:	6a 0b                	push   $0xb
  jmp __alltraps
  102117:	e9 0c 0a 00 00       	jmp    102b28 <__alltraps>

0010211c <vector12>:
.globl vector12
vector12:
  pushl $12
  10211c:	6a 0c                	push   $0xc
  jmp __alltraps
  10211e:	e9 05 0a 00 00       	jmp    102b28 <__alltraps>

00102123 <vector13>:
.globl vector13
vector13:
  pushl $13
  102123:	6a 0d                	push   $0xd
  jmp __alltraps
  102125:	e9 fe 09 00 00       	jmp    102b28 <__alltraps>

0010212a <vector14>:
.globl vector14
vector14:
  pushl $14
  10212a:	6a 0e                	push   $0xe
  jmp __alltraps
  10212c:	e9 f7 09 00 00       	jmp    102b28 <__alltraps>

00102131 <vector15>:
.globl vector15
vector15:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $15
  102133:	6a 0f                	push   $0xf
  jmp __alltraps
  102135:	e9 ee 09 00 00       	jmp    102b28 <__alltraps>

0010213a <vector16>:
.globl vector16
vector16:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $16
  10213c:	6a 10                	push   $0x10
  jmp __alltraps
  10213e:	e9 e5 09 00 00       	jmp    102b28 <__alltraps>

00102143 <vector17>:
.globl vector17
vector17:
  pushl $17
  102143:	6a 11                	push   $0x11
  jmp __alltraps
  102145:	e9 de 09 00 00       	jmp    102b28 <__alltraps>

0010214a <vector18>:
.globl vector18
vector18:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $18
  10214c:	6a 12                	push   $0x12
  jmp __alltraps
  10214e:	e9 d5 09 00 00       	jmp    102b28 <__alltraps>

00102153 <vector19>:
.globl vector19
vector19:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $19
  102155:	6a 13                	push   $0x13
  jmp __alltraps
  102157:	e9 cc 09 00 00       	jmp    102b28 <__alltraps>

0010215c <vector20>:
.globl vector20
vector20:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $20
  10215e:	6a 14                	push   $0x14
  jmp __alltraps
  102160:	e9 c3 09 00 00       	jmp    102b28 <__alltraps>

00102165 <vector21>:
.globl vector21
vector21:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $21
  102167:	6a 15                	push   $0x15
  jmp __alltraps
  102169:	e9 ba 09 00 00       	jmp    102b28 <__alltraps>

0010216e <vector22>:
.globl vector22
vector22:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $22
  102170:	6a 16                	push   $0x16
  jmp __alltraps
  102172:	e9 b1 09 00 00       	jmp    102b28 <__alltraps>

00102177 <vector23>:
.globl vector23
vector23:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $23
  102179:	6a 17                	push   $0x17
  jmp __alltraps
  10217b:	e9 a8 09 00 00       	jmp    102b28 <__alltraps>

00102180 <vector24>:
.globl vector24
vector24:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $24
  102182:	6a 18                	push   $0x18
  jmp __alltraps
  102184:	e9 9f 09 00 00       	jmp    102b28 <__alltraps>

00102189 <vector25>:
.globl vector25
vector25:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $25
  10218b:	6a 19                	push   $0x19
  jmp __alltraps
  10218d:	e9 96 09 00 00       	jmp    102b28 <__alltraps>

00102192 <vector26>:
.globl vector26
vector26:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $26
  102194:	6a 1a                	push   $0x1a
  jmp __alltraps
  102196:	e9 8d 09 00 00       	jmp    102b28 <__alltraps>

0010219b <vector27>:
.globl vector27
vector27:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $27
  10219d:	6a 1b                	push   $0x1b
  jmp __alltraps
  10219f:	e9 84 09 00 00       	jmp    102b28 <__alltraps>

001021a4 <vector28>:
.globl vector28
vector28:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $28
  1021a6:	6a 1c                	push   $0x1c
  jmp __alltraps
  1021a8:	e9 7b 09 00 00       	jmp    102b28 <__alltraps>

001021ad <vector29>:
.globl vector29
vector29:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $29
  1021af:	6a 1d                	push   $0x1d
  jmp __alltraps
  1021b1:	e9 72 09 00 00       	jmp    102b28 <__alltraps>

001021b6 <vector30>:
.globl vector30
vector30:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $30
  1021b8:	6a 1e                	push   $0x1e
  jmp __alltraps
  1021ba:	e9 69 09 00 00       	jmp    102b28 <__alltraps>

001021bf <vector31>:
.globl vector31
vector31:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $31
  1021c1:	6a 1f                	push   $0x1f
  jmp __alltraps
  1021c3:	e9 60 09 00 00       	jmp    102b28 <__alltraps>

001021c8 <vector32>:
.globl vector32
vector32:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $32
  1021ca:	6a 20                	push   $0x20
  jmp __alltraps
  1021cc:	e9 57 09 00 00       	jmp    102b28 <__alltraps>

001021d1 <vector33>:
.globl vector33
vector33:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $33
  1021d3:	6a 21                	push   $0x21
  jmp __alltraps
  1021d5:	e9 4e 09 00 00       	jmp    102b28 <__alltraps>

001021da <vector34>:
.globl vector34
vector34:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $34
  1021dc:	6a 22                	push   $0x22
  jmp __alltraps
  1021de:	e9 45 09 00 00       	jmp    102b28 <__alltraps>

001021e3 <vector35>:
.globl vector35
vector35:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $35
  1021e5:	6a 23                	push   $0x23
  jmp __alltraps
  1021e7:	e9 3c 09 00 00       	jmp    102b28 <__alltraps>

001021ec <vector36>:
.globl vector36
vector36:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $36
  1021ee:	6a 24                	push   $0x24
  jmp __alltraps
  1021f0:	e9 33 09 00 00       	jmp    102b28 <__alltraps>

001021f5 <vector37>:
.globl vector37
vector37:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $37
  1021f7:	6a 25                	push   $0x25
  jmp __alltraps
  1021f9:	e9 2a 09 00 00       	jmp    102b28 <__alltraps>

001021fe <vector38>:
.globl vector38
vector38:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $38
  102200:	6a 26                	push   $0x26
  jmp __alltraps
  102202:	e9 21 09 00 00       	jmp    102b28 <__alltraps>

00102207 <vector39>:
.globl vector39
vector39:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $39
  102209:	6a 27                	push   $0x27
  jmp __alltraps
  10220b:	e9 18 09 00 00       	jmp    102b28 <__alltraps>

00102210 <vector40>:
.globl vector40
vector40:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $40
  102212:	6a 28                	push   $0x28
  jmp __alltraps
  102214:	e9 0f 09 00 00       	jmp    102b28 <__alltraps>

00102219 <vector41>:
.globl vector41
vector41:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $41
  10221b:	6a 29                	push   $0x29
  jmp __alltraps
  10221d:	e9 06 09 00 00       	jmp    102b28 <__alltraps>

00102222 <vector42>:
.globl vector42
vector42:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $42
  102224:	6a 2a                	push   $0x2a
  jmp __alltraps
  102226:	e9 fd 08 00 00       	jmp    102b28 <__alltraps>

0010222b <vector43>:
.globl vector43
vector43:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $43
  10222d:	6a 2b                	push   $0x2b
  jmp __alltraps
  10222f:	e9 f4 08 00 00       	jmp    102b28 <__alltraps>

00102234 <vector44>:
.globl vector44
vector44:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $44
  102236:	6a 2c                	push   $0x2c
  jmp __alltraps
  102238:	e9 eb 08 00 00       	jmp    102b28 <__alltraps>

0010223d <vector45>:
.globl vector45
vector45:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $45
  10223f:	6a 2d                	push   $0x2d
  jmp __alltraps
  102241:	e9 e2 08 00 00       	jmp    102b28 <__alltraps>

00102246 <vector46>:
.globl vector46
vector46:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $46
  102248:	6a 2e                	push   $0x2e
  jmp __alltraps
  10224a:	e9 d9 08 00 00       	jmp    102b28 <__alltraps>

0010224f <vector47>:
.globl vector47
vector47:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $47
  102251:	6a 2f                	push   $0x2f
  jmp __alltraps
  102253:	e9 d0 08 00 00       	jmp    102b28 <__alltraps>

00102258 <vector48>:
.globl vector48
vector48:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $48
  10225a:	6a 30                	push   $0x30
  jmp __alltraps
  10225c:	e9 c7 08 00 00       	jmp    102b28 <__alltraps>

00102261 <vector49>:
.globl vector49
vector49:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $49
  102263:	6a 31                	push   $0x31
  jmp __alltraps
  102265:	e9 be 08 00 00       	jmp    102b28 <__alltraps>

0010226a <vector50>:
.globl vector50
vector50:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $50
  10226c:	6a 32                	push   $0x32
  jmp __alltraps
  10226e:	e9 b5 08 00 00       	jmp    102b28 <__alltraps>

00102273 <vector51>:
.globl vector51
vector51:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $51
  102275:	6a 33                	push   $0x33
  jmp __alltraps
  102277:	e9 ac 08 00 00       	jmp    102b28 <__alltraps>

0010227c <vector52>:
.globl vector52
vector52:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $52
  10227e:	6a 34                	push   $0x34
  jmp __alltraps
  102280:	e9 a3 08 00 00       	jmp    102b28 <__alltraps>

00102285 <vector53>:
.globl vector53
vector53:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $53
  102287:	6a 35                	push   $0x35
  jmp __alltraps
  102289:	e9 9a 08 00 00       	jmp    102b28 <__alltraps>

0010228e <vector54>:
.globl vector54
vector54:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $54
  102290:	6a 36                	push   $0x36
  jmp __alltraps
  102292:	e9 91 08 00 00       	jmp    102b28 <__alltraps>

00102297 <vector55>:
.globl vector55
vector55:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $55
  102299:	6a 37                	push   $0x37
  jmp __alltraps
  10229b:	e9 88 08 00 00       	jmp    102b28 <__alltraps>

001022a0 <vector56>:
.globl vector56
vector56:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $56
  1022a2:	6a 38                	push   $0x38
  jmp __alltraps
  1022a4:	e9 7f 08 00 00       	jmp    102b28 <__alltraps>

001022a9 <vector57>:
.globl vector57
vector57:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $57
  1022ab:	6a 39                	push   $0x39
  jmp __alltraps
  1022ad:	e9 76 08 00 00       	jmp    102b28 <__alltraps>

001022b2 <vector58>:
.globl vector58
vector58:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $58
  1022b4:	6a 3a                	push   $0x3a
  jmp __alltraps
  1022b6:	e9 6d 08 00 00       	jmp    102b28 <__alltraps>

001022bb <vector59>:
.globl vector59
vector59:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $59
  1022bd:	6a 3b                	push   $0x3b
  jmp __alltraps
  1022bf:	e9 64 08 00 00       	jmp    102b28 <__alltraps>

001022c4 <vector60>:
.globl vector60
vector60:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $60
  1022c6:	6a 3c                	push   $0x3c
  jmp __alltraps
  1022c8:	e9 5b 08 00 00       	jmp    102b28 <__alltraps>

001022cd <vector61>:
.globl vector61
vector61:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $61
  1022cf:	6a 3d                	push   $0x3d
  jmp __alltraps
  1022d1:	e9 52 08 00 00       	jmp    102b28 <__alltraps>

001022d6 <vector62>:
.globl vector62
vector62:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $62
  1022d8:	6a 3e                	push   $0x3e
  jmp __alltraps
  1022da:	e9 49 08 00 00       	jmp    102b28 <__alltraps>

001022df <vector63>:
.globl vector63
vector63:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $63
  1022e1:	6a 3f                	push   $0x3f
  jmp __alltraps
  1022e3:	e9 40 08 00 00       	jmp    102b28 <__alltraps>

001022e8 <vector64>:
.globl vector64
vector64:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $64
  1022ea:	6a 40                	push   $0x40
  jmp __alltraps
  1022ec:	e9 37 08 00 00       	jmp    102b28 <__alltraps>

001022f1 <vector65>:
.globl vector65
vector65:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $65
  1022f3:	6a 41                	push   $0x41
  jmp __alltraps
  1022f5:	e9 2e 08 00 00       	jmp    102b28 <__alltraps>

001022fa <vector66>:
.globl vector66
vector66:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $66
  1022fc:	6a 42                	push   $0x42
  jmp __alltraps
  1022fe:	e9 25 08 00 00       	jmp    102b28 <__alltraps>

00102303 <vector67>:
.globl vector67
vector67:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $67
  102305:	6a 43                	push   $0x43
  jmp __alltraps
  102307:	e9 1c 08 00 00       	jmp    102b28 <__alltraps>

0010230c <vector68>:
.globl vector68
vector68:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $68
  10230e:	6a 44                	push   $0x44
  jmp __alltraps
  102310:	e9 13 08 00 00       	jmp    102b28 <__alltraps>

00102315 <vector69>:
.globl vector69
vector69:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $69
  102317:	6a 45                	push   $0x45
  jmp __alltraps
  102319:	e9 0a 08 00 00       	jmp    102b28 <__alltraps>

0010231e <vector70>:
.globl vector70
vector70:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $70
  102320:	6a 46                	push   $0x46
  jmp __alltraps
  102322:	e9 01 08 00 00       	jmp    102b28 <__alltraps>

00102327 <vector71>:
.globl vector71
vector71:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $71
  102329:	6a 47                	push   $0x47
  jmp __alltraps
  10232b:	e9 f8 07 00 00       	jmp    102b28 <__alltraps>

00102330 <vector72>:
.globl vector72
vector72:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $72
  102332:	6a 48                	push   $0x48
  jmp __alltraps
  102334:	e9 ef 07 00 00       	jmp    102b28 <__alltraps>

00102339 <vector73>:
.globl vector73
vector73:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $73
  10233b:	6a 49                	push   $0x49
  jmp __alltraps
  10233d:	e9 e6 07 00 00       	jmp    102b28 <__alltraps>

00102342 <vector74>:
.globl vector74
vector74:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $74
  102344:	6a 4a                	push   $0x4a
  jmp __alltraps
  102346:	e9 dd 07 00 00       	jmp    102b28 <__alltraps>

0010234b <vector75>:
.globl vector75
vector75:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $75
  10234d:	6a 4b                	push   $0x4b
  jmp __alltraps
  10234f:	e9 d4 07 00 00       	jmp    102b28 <__alltraps>

00102354 <vector76>:
.globl vector76
vector76:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $76
  102356:	6a 4c                	push   $0x4c
  jmp __alltraps
  102358:	e9 cb 07 00 00       	jmp    102b28 <__alltraps>

0010235d <vector77>:
.globl vector77
vector77:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $77
  10235f:	6a 4d                	push   $0x4d
  jmp __alltraps
  102361:	e9 c2 07 00 00       	jmp    102b28 <__alltraps>

00102366 <vector78>:
.globl vector78
vector78:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $78
  102368:	6a 4e                	push   $0x4e
  jmp __alltraps
  10236a:	e9 b9 07 00 00       	jmp    102b28 <__alltraps>

0010236f <vector79>:
.globl vector79
vector79:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $79
  102371:	6a 4f                	push   $0x4f
  jmp __alltraps
  102373:	e9 b0 07 00 00       	jmp    102b28 <__alltraps>

00102378 <vector80>:
.globl vector80
vector80:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $80
  10237a:	6a 50                	push   $0x50
  jmp __alltraps
  10237c:	e9 a7 07 00 00       	jmp    102b28 <__alltraps>

00102381 <vector81>:
.globl vector81
vector81:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $81
  102383:	6a 51                	push   $0x51
  jmp __alltraps
  102385:	e9 9e 07 00 00       	jmp    102b28 <__alltraps>

0010238a <vector82>:
.globl vector82
vector82:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $82
  10238c:	6a 52                	push   $0x52
  jmp __alltraps
  10238e:	e9 95 07 00 00       	jmp    102b28 <__alltraps>

00102393 <vector83>:
.globl vector83
vector83:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $83
  102395:	6a 53                	push   $0x53
  jmp __alltraps
  102397:	e9 8c 07 00 00       	jmp    102b28 <__alltraps>

0010239c <vector84>:
.globl vector84
vector84:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $84
  10239e:	6a 54                	push   $0x54
  jmp __alltraps
  1023a0:	e9 83 07 00 00       	jmp    102b28 <__alltraps>

001023a5 <vector85>:
.globl vector85
vector85:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $85
  1023a7:	6a 55                	push   $0x55
  jmp __alltraps
  1023a9:	e9 7a 07 00 00       	jmp    102b28 <__alltraps>

001023ae <vector86>:
.globl vector86
vector86:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $86
  1023b0:	6a 56                	push   $0x56
  jmp __alltraps
  1023b2:	e9 71 07 00 00       	jmp    102b28 <__alltraps>

001023b7 <vector87>:
.globl vector87
vector87:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $87
  1023b9:	6a 57                	push   $0x57
  jmp __alltraps
  1023bb:	e9 68 07 00 00       	jmp    102b28 <__alltraps>

001023c0 <vector88>:
.globl vector88
vector88:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $88
  1023c2:	6a 58                	push   $0x58
  jmp __alltraps
  1023c4:	e9 5f 07 00 00       	jmp    102b28 <__alltraps>

001023c9 <vector89>:
.globl vector89
vector89:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $89
  1023cb:	6a 59                	push   $0x59
  jmp __alltraps
  1023cd:	e9 56 07 00 00       	jmp    102b28 <__alltraps>

001023d2 <vector90>:
.globl vector90
vector90:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $90
  1023d4:	6a 5a                	push   $0x5a
  jmp __alltraps
  1023d6:	e9 4d 07 00 00       	jmp    102b28 <__alltraps>

001023db <vector91>:
.globl vector91
vector91:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $91
  1023dd:	6a 5b                	push   $0x5b
  jmp __alltraps
  1023df:	e9 44 07 00 00       	jmp    102b28 <__alltraps>

001023e4 <vector92>:
.globl vector92
vector92:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $92
  1023e6:	6a 5c                	push   $0x5c
  jmp __alltraps
  1023e8:	e9 3b 07 00 00       	jmp    102b28 <__alltraps>

001023ed <vector93>:
.globl vector93
vector93:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $93
  1023ef:	6a 5d                	push   $0x5d
  jmp __alltraps
  1023f1:	e9 32 07 00 00       	jmp    102b28 <__alltraps>

001023f6 <vector94>:
.globl vector94
vector94:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $94
  1023f8:	6a 5e                	push   $0x5e
  jmp __alltraps
  1023fa:	e9 29 07 00 00       	jmp    102b28 <__alltraps>

001023ff <vector95>:
.globl vector95
vector95:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $95
  102401:	6a 5f                	push   $0x5f
  jmp __alltraps
  102403:	e9 20 07 00 00       	jmp    102b28 <__alltraps>

00102408 <vector96>:
.globl vector96
vector96:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $96
  10240a:	6a 60                	push   $0x60
  jmp __alltraps
  10240c:	e9 17 07 00 00       	jmp    102b28 <__alltraps>

00102411 <vector97>:
.globl vector97
vector97:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $97
  102413:	6a 61                	push   $0x61
  jmp __alltraps
  102415:	e9 0e 07 00 00       	jmp    102b28 <__alltraps>

0010241a <vector98>:
.globl vector98
vector98:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $98
  10241c:	6a 62                	push   $0x62
  jmp __alltraps
  10241e:	e9 05 07 00 00       	jmp    102b28 <__alltraps>

00102423 <vector99>:
.globl vector99
vector99:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $99
  102425:	6a 63                	push   $0x63
  jmp __alltraps
  102427:	e9 fc 06 00 00       	jmp    102b28 <__alltraps>

0010242c <vector100>:
.globl vector100
vector100:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $100
  10242e:	6a 64                	push   $0x64
  jmp __alltraps
  102430:	e9 f3 06 00 00       	jmp    102b28 <__alltraps>

00102435 <vector101>:
.globl vector101
vector101:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $101
  102437:	6a 65                	push   $0x65
  jmp __alltraps
  102439:	e9 ea 06 00 00       	jmp    102b28 <__alltraps>

0010243e <vector102>:
.globl vector102
vector102:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $102
  102440:	6a 66                	push   $0x66
  jmp __alltraps
  102442:	e9 e1 06 00 00       	jmp    102b28 <__alltraps>

00102447 <vector103>:
.globl vector103
vector103:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $103
  102449:	6a 67                	push   $0x67
  jmp __alltraps
  10244b:	e9 d8 06 00 00       	jmp    102b28 <__alltraps>

00102450 <vector104>:
.globl vector104
vector104:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $104
  102452:	6a 68                	push   $0x68
  jmp __alltraps
  102454:	e9 cf 06 00 00       	jmp    102b28 <__alltraps>

00102459 <vector105>:
.globl vector105
vector105:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $105
  10245b:	6a 69                	push   $0x69
  jmp __alltraps
  10245d:	e9 c6 06 00 00       	jmp    102b28 <__alltraps>

00102462 <vector106>:
.globl vector106
vector106:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $106
  102464:	6a 6a                	push   $0x6a
  jmp __alltraps
  102466:	e9 bd 06 00 00       	jmp    102b28 <__alltraps>

0010246b <vector107>:
.globl vector107
vector107:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $107
  10246d:	6a 6b                	push   $0x6b
  jmp __alltraps
  10246f:	e9 b4 06 00 00       	jmp    102b28 <__alltraps>

00102474 <vector108>:
.globl vector108
vector108:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $108
  102476:	6a 6c                	push   $0x6c
  jmp __alltraps
  102478:	e9 ab 06 00 00       	jmp    102b28 <__alltraps>

0010247d <vector109>:
.globl vector109
vector109:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $109
  10247f:	6a 6d                	push   $0x6d
  jmp __alltraps
  102481:	e9 a2 06 00 00       	jmp    102b28 <__alltraps>

00102486 <vector110>:
.globl vector110
vector110:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $110
  102488:	6a 6e                	push   $0x6e
  jmp __alltraps
  10248a:	e9 99 06 00 00       	jmp    102b28 <__alltraps>

0010248f <vector111>:
.globl vector111
vector111:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $111
  102491:	6a 6f                	push   $0x6f
  jmp __alltraps
  102493:	e9 90 06 00 00       	jmp    102b28 <__alltraps>

00102498 <vector112>:
.globl vector112
vector112:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $112
  10249a:	6a 70                	push   $0x70
  jmp __alltraps
  10249c:	e9 87 06 00 00       	jmp    102b28 <__alltraps>

001024a1 <vector113>:
.globl vector113
vector113:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $113
  1024a3:	6a 71                	push   $0x71
  jmp __alltraps
  1024a5:	e9 7e 06 00 00       	jmp    102b28 <__alltraps>

001024aa <vector114>:
.globl vector114
vector114:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $114
  1024ac:	6a 72                	push   $0x72
  jmp __alltraps
  1024ae:	e9 75 06 00 00       	jmp    102b28 <__alltraps>

001024b3 <vector115>:
.globl vector115
vector115:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $115
  1024b5:	6a 73                	push   $0x73
  jmp __alltraps
  1024b7:	e9 6c 06 00 00       	jmp    102b28 <__alltraps>

001024bc <vector116>:
.globl vector116
vector116:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $116
  1024be:	6a 74                	push   $0x74
  jmp __alltraps
  1024c0:	e9 63 06 00 00       	jmp    102b28 <__alltraps>

001024c5 <vector117>:
.globl vector117
vector117:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $117
  1024c7:	6a 75                	push   $0x75
  jmp __alltraps
  1024c9:	e9 5a 06 00 00       	jmp    102b28 <__alltraps>

001024ce <vector118>:
.globl vector118
vector118:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $118
  1024d0:	6a 76                	push   $0x76
  jmp __alltraps
  1024d2:	e9 51 06 00 00       	jmp    102b28 <__alltraps>

001024d7 <vector119>:
.globl vector119
vector119:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $119
  1024d9:	6a 77                	push   $0x77
  jmp __alltraps
  1024db:	e9 48 06 00 00       	jmp    102b28 <__alltraps>

001024e0 <vector120>:
.globl vector120
vector120:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $120
  1024e2:	6a 78                	push   $0x78
  jmp __alltraps
  1024e4:	e9 3f 06 00 00       	jmp    102b28 <__alltraps>

001024e9 <vector121>:
.globl vector121
vector121:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $121
  1024eb:	6a 79                	push   $0x79
  jmp __alltraps
  1024ed:	e9 36 06 00 00       	jmp    102b28 <__alltraps>

001024f2 <vector122>:
.globl vector122
vector122:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $122
  1024f4:	6a 7a                	push   $0x7a
  jmp __alltraps
  1024f6:	e9 2d 06 00 00       	jmp    102b28 <__alltraps>

001024fb <vector123>:
.globl vector123
vector123:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $123
  1024fd:	6a 7b                	push   $0x7b
  jmp __alltraps
  1024ff:	e9 24 06 00 00       	jmp    102b28 <__alltraps>

00102504 <vector124>:
.globl vector124
vector124:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $124
  102506:	6a 7c                	push   $0x7c
  jmp __alltraps
  102508:	e9 1b 06 00 00       	jmp    102b28 <__alltraps>

0010250d <vector125>:
.globl vector125
vector125:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $125
  10250f:	6a 7d                	push   $0x7d
  jmp __alltraps
  102511:	e9 12 06 00 00       	jmp    102b28 <__alltraps>

00102516 <vector126>:
.globl vector126
vector126:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $126
  102518:	6a 7e                	push   $0x7e
  jmp __alltraps
  10251a:	e9 09 06 00 00       	jmp    102b28 <__alltraps>

0010251f <vector127>:
.globl vector127
vector127:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $127
  102521:	6a 7f                	push   $0x7f
  jmp __alltraps
  102523:	e9 00 06 00 00       	jmp    102b28 <__alltraps>

00102528 <vector128>:
.globl vector128
vector128:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $128
  10252a:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10252f:	e9 f4 05 00 00       	jmp    102b28 <__alltraps>

00102534 <vector129>:
.globl vector129
vector129:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $129
  102536:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10253b:	e9 e8 05 00 00       	jmp    102b28 <__alltraps>

00102540 <vector130>:
.globl vector130
vector130:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $130
  102542:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102547:	e9 dc 05 00 00       	jmp    102b28 <__alltraps>

0010254c <vector131>:
.globl vector131
vector131:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $131
  10254e:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102553:	e9 d0 05 00 00       	jmp    102b28 <__alltraps>

00102558 <vector132>:
.globl vector132
vector132:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $132
  10255a:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10255f:	e9 c4 05 00 00       	jmp    102b28 <__alltraps>

00102564 <vector133>:
.globl vector133
vector133:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $133
  102566:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10256b:	e9 b8 05 00 00       	jmp    102b28 <__alltraps>

00102570 <vector134>:
.globl vector134
vector134:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $134
  102572:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102577:	e9 ac 05 00 00       	jmp    102b28 <__alltraps>

0010257c <vector135>:
.globl vector135
vector135:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $135
  10257e:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102583:	e9 a0 05 00 00       	jmp    102b28 <__alltraps>

00102588 <vector136>:
.globl vector136
vector136:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $136
  10258a:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10258f:	e9 94 05 00 00       	jmp    102b28 <__alltraps>

00102594 <vector137>:
.globl vector137
vector137:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $137
  102596:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10259b:	e9 88 05 00 00       	jmp    102b28 <__alltraps>

001025a0 <vector138>:
.globl vector138
vector138:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $138
  1025a2:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1025a7:	e9 7c 05 00 00       	jmp    102b28 <__alltraps>

001025ac <vector139>:
.globl vector139
vector139:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $139
  1025ae:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1025b3:	e9 70 05 00 00       	jmp    102b28 <__alltraps>

001025b8 <vector140>:
.globl vector140
vector140:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $140
  1025ba:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1025bf:	e9 64 05 00 00       	jmp    102b28 <__alltraps>

001025c4 <vector141>:
.globl vector141
vector141:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $141
  1025c6:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1025cb:	e9 58 05 00 00       	jmp    102b28 <__alltraps>

001025d0 <vector142>:
.globl vector142
vector142:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $142
  1025d2:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1025d7:	e9 4c 05 00 00       	jmp    102b28 <__alltraps>

001025dc <vector143>:
.globl vector143
vector143:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $143
  1025de:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1025e3:	e9 40 05 00 00       	jmp    102b28 <__alltraps>

001025e8 <vector144>:
.globl vector144
vector144:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $144
  1025ea:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1025ef:	e9 34 05 00 00       	jmp    102b28 <__alltraps>

001025f4 <vector145>:
.globl vector145
vector145:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $145
  1025f6:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1025fb:	e9 28 05 00 00       	jmp    102b28 <__alltraps>

00102600 <vector146>:
.globl vector146
vector146:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $146
  102602:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102607:	e9 1c 05 00 00       	jmp    102b28 <__alltraps>

0010260c <vector147>:
.globl vector147
vector147:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $147
  10260e:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102613:	e9 10 05 00 00       	jmp    102b28 <__alltraps>

00102618 <vector148>:
.globl vector148
vector148:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $148
  10261a:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10261f:	e9 04 05 00 00       	jmp    102b28 <__alltraps>

00102624 <vector149>:
.globl vector149
vector149:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $149
  102626:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10262b:	e9 f8 04 00 00       	jmp    102b28 <__alltraps>

00102630 <vector150>:
.globl vector150
vector150:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $150
  102632:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102637:	e9 ec 04 00 00       	jmp    102b28 <__alltraps>

0010263c <vector151>:
.globl vector151
vector151:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $151
  10263e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102643:	e9 e0 04 00 00       	jmp    102b28 <__alltraps>

00102648 <vector152>:
.globl vector152
vector152:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $152
  10264a:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10264f:	e9 d4 04 00 00       	jmp    102b28 <__alltraps>

00102654 <vector153>:
.globl vector153
vector153:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $153
  102656:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10265b:	e9 c8 04 00 00       	jmp    102b28 <__alltraps>

00102660 <vector154>:
.globl vector154
vector154:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $154
  102662:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102667:	e9 bc 04 00 00       	jmp    102b28 <__alltraps>

0010266c <vector155>:
.globl vector155
vector155:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $155
  10266e:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102673:	e9 b0 04 00 00       	jmp    102b28 <__alltraps>

00102678 <vector156>:
.globl vector156
vector156:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $156
  10267a:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10267f:	e9 a4 04 00 00       	jmp    102b28 <__alltraps>

00102684 <vector157>:
.globl vector157
vector157:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $157
  102686:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10268b:	e9 98 04 00 00       	jmp    102b28 <__alltraps>

00102690 <vector158>:
.globl vector158
vector158:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $158
  102692:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102697:	e9 8c 04 00 00       	jmp    102b28 <__alltraps>

0010269c <vector159>:
.globl vector159
vector159:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $159
  10269e:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1026a3:	e9 80 04 00 00       	jmp    102b28 <__alltraps>

001026a8 <vector160>:
.globl vector160
vector160:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $160
  1026aa:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1026af:	e9 74 04 00 00       	jmp    102b28 <__alltraps>

001026b4 <vector161>:
.globl vector161
vector161:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $161
  1026b6:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1026bb:	e9 68 04 00 00       	jmp    102b28 <__alltraps>

001026c0 <vector162>:
.globl vector162
vector162:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $162
  1026c2:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1026c7:	e9 5c 04 00 00       	jmp    102b28 <__alltraps>

001026cc <vector163>:
.globl vector163
vector163:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $163
  1026ce:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1026d3:	e9 50 04 00 00       	jmp    102b28 <__alltraps>

001026d8 <vector164>:
.globl vector164
vector164:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $164
  1026da:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1026df:	e9 44 04 00 00       	jmp    102b28 <__alltraps>

001026e4 <vector165>:
.globl vector165
vector165:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $165
  1026e6:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1026eb:	e9 38 04 00 00       	jmp    102b28 <__alltraps>

001026f0 <vector166>:
.globl vector166
vector166:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $166
  1026f2:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1026f7:	e9 2c 04 00 00       	jmp    102b28 <__alltraps>

001026fc <vector167>:
.globl vector167
vector167:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $167
  1026fe:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102703:	e9 20 04 00 00       	jmp    102b28 <__alltraps>

00102708 <vector168>:
.globl vector168
vector168:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $168
  10270a:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10270f:	e9 14 04 00 00       	jmp    102b28 <__alltraps>

00102714 <vector169>:
.globl vector169
vector169:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $169
  102716:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10271b:	e9 08 04 00 00       	jmp    102b28 <__alltraps>

00102720 <vector170>:
.globl vector170
vector170:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $170
  102722:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102727:	e9 fc 03 00 00       	jmp    102b28 <__alltraps>

0010272c <vector171>:
.globl vector171
vector171:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $171
  10272e:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102733:	e9 f0 03 00 00       	jmp    102b28 <__alltraps>

00102738 <vector172>:
.globl vector172
vector172:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $172
  10273a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10273f:	e9 e4 03 00 00       	jmp    102b28 <__alltraps>

00102744 <vector173>:
.globl vector173
vector173:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $173
  102746:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10274b:	e9 d8 03 00 00       	jmp    102b28 <__alltraps>

00102750 <vector174>:
.globl vector174
vector174:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $174
  102752:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102757:	e9 cc 03 00 00       	jmp    102b28 <__alltraps>

0010275c <vector175>:
.globl vector175
vector175:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $175
  10275e:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102763:	e9 c0 03 00 00       	jmp    102b28 <__alltraps>

00102768 <vector176>:
.globl vector176
vector176:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $176
  10276a:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10276f:	e9 b4 03 00 00       	jmp    102b28 <__alltraps>

00102774 <vector177>:
.globl vector177
vector177:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $177
  102776:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10277b:	e9 a8 03 00 00       	jmp    102b28 <__alltraps>

00102780 <vector178>:
.globl vector178
vector178:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $178
  102782:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102787:	e9 9c 03 00 00       	jmp    102b28 <__alltraps>

0010278c <vector179>:
.globl vector179
vector179:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $179
  10278e:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102793:	e9 90 03 00 00       	jmp    102b28 <__alltraps>

00102798 <vector180>:
.globl vector180
vector180:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $180
  10279a:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10279f:	e9 84 03 00 00       	jmp    102b28 <__alltraps>

001027a4 <vector181>:
.globl vector181
vector181:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $181
  1027a6:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1027ab:	e9 78 03 00 00       	jmp    102b28 <__alltraps>

001027b0 <vector182>:
.globl vector182
vector182:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $182
  1027b2:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1027b7:	e9 6c 03 00 00       	jmp    102b28 <__alltraps>

001027bc <vector183>:
.globl vector183
vector183:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $183
  1027be:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1027c3:	e9 60 03 00 00       	jmp    102b28 <__alltraps>

001027c8 <vector184>:
.globl vector184
vector184:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $184
  1027ca:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1027cf:	e9 54 03 00 00       	jmp    102b28 <__alltraps>

001027d4 <vector185>:
.globl vector185
vector185:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $185
  1027d6:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1027db:	e9 48 03 00 00       	jmp    102b28 <__alltraps>

001027e0 <vector186>:
.globl vector186
vector186:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $186
  1027e2:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1027e7:	e9 3c 03 00 00       	jmp    102b28 <__alltraps>

001027ec <vector187>:
.globl vector187
vector187:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $187
  1027ee:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1027f3:	e9 30 03 00 00       	jmp    102b28 <__alltraps>

001027f8 <vector188>:
.globl vector188
vector188:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $188
  1027fa:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1027ff:	e9 24 03 00 00       	jmp    102b28 <__alltraps>

00102804 <vector189>:
.globl vector189
vector189:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $189
  102806:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10280b:	e9 18 03 00 00       	jmp    102b28 <__alltraps>

00102810 <vector190>:
.globl vector190
vector190:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $190
  102812:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102817:	e9 0c 03 00 00       	jmp    102b28 <__alltraps>

0010281c <vector191>:
.globl vector191
vector191:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $191
  10281e:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102823:	e9 00 03 00 00       	jmp    102b28 <__alltraps>

00102828 <vector192>:
.globl vector192
vector192:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $192
  10282a:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10282f:	e9 f4 02 00 00       	jmp    102b28 <__alltraps>

00102834 <vector193>:
.globl vector193
vector193:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $193
  102836:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10283b:	e9 e8 02 00 00       	jmp    102b28 <__alltraps>

00102840 <vector194>:
.globl vector194
vector194:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $194
  102842:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102847:	e9 dc 02 00 00       	jmp    102b28 <__alltraps>

0010284c <vector195>:
.globl vector195
vector195:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $195
  10284e:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102853:	e9 d0 02 00 00       	jmp    102b28 <__alltraps>

00102858 <vector196>:
.globl vector196
vector196:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $196
  10285a:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10285f:	e9 c4 02 00 00       	jmp    102b28 <__alltraps>

00102864 <vector197>:
.globl vector197
vector197:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $197
  102866:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10286b:	e9 b8 02 00 00       	jmp    102b28 <__alltraps>

00102870 <vector198>:
.globl vector198
vector198:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $198
  102872:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102877:	e9 ac 02 00 00       	jmp    102b28 <__alltraps>

0010287c <vector199>:
.globl vector199
vector199:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $199
  10287e:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102883:	e9 a0 02 00 00       	jmp    102b28 <__alltraps>

00102888 <vector200>:
.globl vector200
vector200:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $200
  10288a:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10288f:	e9 94 02 00 00       	jmp    102b28 <__alltraps>

00102894 <vector201>:
.globl vector201
vector201:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $201
  102896:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10289b:	e9 88 02 00 00       	jmp    102b28 <__alltraps>

001028a0 <vector202>:
.globl vector202
vector202:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $202
  1028a2:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1028a7:	e9 7c 02 00 00       	jmp    102b28 <__alltraps>

001028ac <vector203>:
.globl vector203
vector203:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $203
  1028ae:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1028b3:	e9 70 02 00 00       	jmp    102b28 <__alltraps>

001028b8 <vector204>:
.globl vector204
vector204:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $204
  1028ba:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1028bf:	e9 64 02 00 00       	jmp    102b28 <__alltraps>

001028c4 <vector205>:
.globl vector205
vector205:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $205
  1028c6:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1028cb:	e9 58 02 00 00       	jmp    102b28 <__alltraps>

001028d0 <vector206>:
.globl vector206
vector206:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $206
  1028d2:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1028d7:	e9 4c 02 00 00       	jmp    102b28 <__alltraps>

001028dc <vector207>:
.globl vector207
vector207:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $207
  1028de:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1028e3:	e9 40 02 00 00       	jmp    102b28 <__alltraps>

001028e8 <vector208>:
.globl vector208
vector208:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $208
  1028ea:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1028ef:	e9 34 02 00 00       	jmp    102b28 <__alltraps>

001028f4 <vector209>:
.globl vector209
vector209:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $209
  1028f6:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1028fb:	e9 28 02 00 00       	jmp    102b28 <__alltraps>

00102900 <vector210>:
.globl vector210
vector210:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $210
  102902:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102907:	e9 1c 02 00 00       	jmp    102b28 <__alltraps>

0010290c <vector211>:
.globl vector211
vector211:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $211
  10290e:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102913:	e9 10 02 00 00       	jmp    102b28 <__alltraps>

00102918 <vector212>:
.globl vector212
vector212:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $212
  10291a:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10291f:	e9 04 02 00 00       	jmp    102b28 <__alltraps>

00102924 <vector213>:
.globl vector213
vector213:
  pushl $0
  102924:	6a 00                	push   $0x0
  pushl $213
  102926:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10292b:	e9 f8 01 00 00       	jmp    102b28 <__alltraps>

00102930 <vector214>:
.globl vector214
vector214:
  pushl $0
  102930:	6a 00                	push   $0x0
  pushl $214
  102932:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102937:	e9 ec 01 00 00       	jmp    102b28 <__alltraps>

0010293c <vector215>:
.globl vector215
vector215:
  pushl $0
  10293c:	6a 00                	push   $0x0
  pushl $215
  10293e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102943:	e9 e0 01 00 00       	jmp    102b28 <__alltraps>

00102948 <vector216>:
.globl vector216
vector216:
  pushl $0
  102948:	6a 00                	push   $0x0
  pushl $216
  10294a:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10294f:	e9 d4 01 00 00       	jmp    102b28 <__alltraps>

00102954 <vector217>:
.globl vector217
vector217:
  pushl $0
  102954:	6a 00                	push   $0x0
  pushl $217
  102956:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10295b:	e9 c8 01 00 00       	jmp    102b28 <__alltraps>

00102960 <vector218>:
.globl vector218
vector218:
  pushl $0
  102960:	6a 00                	push   $0x0
  pushl $218
  102962:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102967:	e9 bc 01 00 00       	jmp    102b28 <__alltraps>

0010296c <vector219>:
.globl vector219
vector219:
  pushl $0
  10296c:	6a 00                	push   $0x0
  pushl $219
  10296e:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102973:	e9 b0 01 00 00       	jmp    102b28 <__alltraps>

00102978 <vector220>:
.globl vector220
vector220:
  pushl $0
  102978:	6a 00                	push   $0x0
  pushl $220
  10297a:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10297f:	e9 a4 01 00 00       	jmp    102b28 <__alltraps>

00102984 <vector221>:
.globl vector221
vector221:
  pushl $0
  102984:	6a 00                	push   $0x0
  pushl $221
  102986:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10298b:	e9 98 01 00 00       	jmp    102b28 <__alltraps>

00102990 <vector222>:
.globl vector222
vector222:
  pushl $0
  102990:	6a 00                	push   $0x0
  pushl $222
  102992:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102997:	e9 8c 01 00 00       	jmp    102b28 <__alltraps>

0010299c <vector223>:
.globl vector223
vector223:
  pushl $0
  10299c:	6a 00                	push   $0x0
  pushl $223
  10299e:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1029a3:	e9 80 01 00 00       	jmp    102b28 <__alltraps>

001029a8 <vector224>:
.globl vector224
vector224:
  pushl $0
  1029a8:	6a 00                	push   $0x0
  pushl $224
  1029aa:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1029af:	e9 74 01 00 00       	jmp    102b28 <__alltraps>

001029b4 <vector225>:
.globl vector225
vector225:
  pushl $0
  1029b4:	6a 00                	push   $0x0
  pushl $225
  1029b6:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1029bb:	e9 68 01 00 00       	jmp    102b28 <__alltraps>

001029c0 <vector226>:
.globl vector226
vector226:
  pushl $0
  1029c0:	6a 00                	push   $0x0
  pushl $226
  1029c2:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1029c7:	e9 5c 01 00 00       	jmp    102b28 <__alltraps>

001029cc <vector227>:
.globl vector227
vector227:
  pushl $0
  1029cc:	6a 00                	push   $0x0
  pushl $227
  1029ce:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1029d3:	e9 50 01 00 00       	jmp    102b28 <__alltraps>

001029d8 <vector228>:
.globl vector228
vector228:
  pushl $0
  1029d8:	6a 00                	push   $0x0
  pushl $228
  1029da:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1029df:	e9 44 01 00 00       	jmp    102b28 <__alltraps>

001029e4 <vector229>:
.globl vector229
vector229:
  pushl $0
  1029e4:	6a 00                	push   $0x0
  pushl $229
  1029e6:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1029eb:	e9 38 01 00 00       	jmp    102b28 <__alltraps>

001029f0 <vector230>:
.globl vector230
vector230:
  pushl $0
  1029f0:	6a 00                	push   $0x0
  pushl $230
  1029f2:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1029f7:	e9 2c 01 00 00       	jmp    102b28 <__alltraps>

001029fc <vector231>:
.globl vector231
vector231:
  pushl $0
  1029fc:	6a 00                	push   $0x0
  pushl $231
  1029fe:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102a03:	e9 20 01 00 00       	jmp    102b28 <__alltraps>

00102a08 <vector232>:
.globl vector232
vector232:
  pushl $0
  102a08:	6a 00                	push   $0x0
  pushl $232
  102a0a:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102a0f:	e9 14 01 00 00       	jmp    102b28 <__alltraps>

00102a14 <vector233>:
.globl vector233
vector233:
  pushl $0
  102a14:	6a 00                	push   $0x0
  pushl $233
  102a16:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102a1b:	e9 08 01 00 00       	jmp    102b28 <__alltraps>

00102a20 <vector234>:
.globl vector234
vector234:
  pushl $0
  102a20:	6a 00                	push   $0x0
  pushl $234
  102a22:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102a27:	e9 fc 00 00 00       	jmp    102b28 <__alltraps>

00102a2c <vector235>:
.globl vector235
vector235:
  pushl $0
  102a2c:	6a 00                	push   $0x0
  pushl $235
  102a2e:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102a33:	e9 f0 00 00 00       	jmp    102b28 <__alltraps>

00102a38 <vector236>:
.globl vector236
vector236:
  pushl $0
  102a38:	6a 00                	push   $0x0
  pushl $236
  102a3a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102a3f:	e9 e4 00 00 00       	jmp    102b28 <__alltraps>

00102a44 <vector237>:
.globl vector237
vector237:
  pushl $0
  102a44:	6a 00                	push   $0x0
  pushl $237
  102a46:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102a4b:	e9 d8 00 00 00       	jmp    102b28 <__alltraps>

00102a50 <vector238>:
.globl vector238
vector238:
  pushl $0
  102a50:	6a 00                	push   $0x0
  pushl $238
  102a52:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102a57:	e9 cc 00 00 00       	jmp    102b28 <__alltraps>

00102a5c <vector239>:
.globl vector239
vector239:
  pushl $0
  102a5c:	6a 00                	push   $0x0
  pushl $239
  102a5e:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102a63:	e9 c0 00 00 00       	jmp    102b28 <__alltraps>

00102a68 <vector240>:
.globl vector240
vector240:
  pushl $0
  102a68:	6a 00                	push   $0x0
  pushl $240
  102a6a:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102a6f:	e9 b4 00 00 00       	jmp    102b28 <__alltraps>

00102a74 <vector241>:
.globl vector241
vector241:
  pushl $0
  102a74:	6a 00                	push   $0x0
  pushl $241
  102a76:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102a7b:	e9 a8 00 00 00       	jmp    102b28 <__alltraps>

00102a80 <vector242>:
.globl vector242
vector242:
  pushl $0
  102a80:	6a 00                	push   $0x0
  pushl $242
  102a82:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a87:	e9 9c 00 00 00       	jmp    102b28 <__alltraps>

00102a8c <vector243>:
.globl vector243
vector243:
  pushl $0
  102a8c:	6a 00                	push   $0x0
  pushl $243
  102a8e:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a93:	e9 90 00 00 00       	jmp    102b28 <__alltraps>

00102a98 <vector244>:
.globl vector244
vector244:
  pushl $0
  102a98:	6a 00                	push   $0x0
  pushl $244
  102a9a:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a9f:	e9 84 00 00 00       	jmp    102b28 <__alltraps>

00102aa4 <vector245>:
.globl vector245
vector245:
  pushl $0
  102aa4:	6a 00                	push   $0x0
  pushl $245
  102aa6:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102aab:	e9 78 00 00 00       	jmp    102b28 <__alltraps>

00102ab0 <vector246>:
.globl vector246
vector246:
  pushl $0
  102ab0:	6a 00                	push   $0x0
  pushl $246
  102ab2:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102ab7:	e9 6c 00 00 00       	jmp    102b28 <__alltraps>

00102abc <vector247>:
.globl vector247
vector247:
  pushl $0
  102abc:	6a 00                	push   $0x0
  pushl $247
  102abe:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102ac3:	e9 60 00 00 00       	jmp    102b28 <__alltraps>

00102ac8 <vector248>:
.globl vector248
vector248:
  pushl $0
  102ac8:	6a 00                	push   $0x0
  pushl $248
  102aca:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102acf:	e9 54 00 00 00       	jmp    102b28 <__alltraps>

00102ad4 <vector249>:
.globl vector249
vector249:
  pushl $0
  102ad4:	6a 00                	push   $0x0
  pushl $249
  102ad6:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102adb:	e9 48 00 00 00       	jmp    102b28 <__alltraps>

00102ae0 <vector250>:
.globl vector250
vector250:
  pushl $0
  102ae0:	6a 00                	push   $0x0
  pushl $250
  102ae2:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102ae7:	e9 3c 00 00 00       	jmp    102b28 <__alltraps>

00102aec <vector251>:
.globl vector251
vector251:
  pushl $0
  102aec:	6a 00                	push   $0x0
  pushl $251
  102aee:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102af3:	e9 30 00 00 00       	jmp    102b28 <__alltraps>

00102af8 <vector252>:
.globl vector252
vector252:
  pushl $0
  102af8:	6a 00                	push   $0x0
  pushl $252
  102afa:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102aff:	e9 24 00 00 00       	jmp    102b28 <__alltraps>

00102b04 <vector253>:
.globl vector253
vector253:
  pushl $0
  102b04:	6a 00                	push   $0x0
  pushl $253
  102b06:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102b0b:	e9 18 00 00 00       	jmp    102b28 <__alltraps>

00102b10 <vector254>:
.globl vector254
vector254:
  pushl $0
  102b10:	6a 00                	push   $0x0
  pushl $254
  102b12:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102b17:	e9 0c 00 00 00       	jmp    102b28 <__alltraps>

00102b1c <vector255>:
.globl vector255
vector255:
  pushl $0
  102b1c:	6a 00                	push   $0x0
  pushl $255
  102b1e:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102b23:	e9 00 00 00 00       	jmp    102b28 <__alltraps>

00102b28 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102b28:	1e                   	push   %ds
    pushl %es
  102b29:	06                   	push   %es
    pushl %fs
  102b2a:	0f a0                	push   %fs
    pushl %gs
  102b2c:	0f a8                	push   %gs
    pushal
  102b2e:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102b2f:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102b34:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102b36:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102b38:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102b39:	e8 64 f5 ff ff       	call   1020a2 <trap>

    # pop the pushed stack pointer
    popl %esp
  102b3e:	5c                   	pop    %esp

00102b3f <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102b3f:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102b40:	0f a9                	pop    %gs
    popl %fs
  102b42:	0f a1                	pop    %fs
    popl %es
  102b44:	07                   	pop    %es
    popl %ds
  102b45:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102b46:	83 c4 08             	add    $0x8,%esp
    iret
  102b49:	cf                   	iret   

00102b4a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b4a:	55                   	push   %ebp
  102b4b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b50:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b53:	b8 23 00 00 00       	mov    $0x23,%eax
  102b58:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b5a:	b8 23 00 00 00       	mov    $0x23,%eax
  102b5f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b61:	b8 10 00 00 00       	mov    $0x10,%eax
  102b66:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b68:	b8 10 00 00 00       	mov    $0x10,%eax
  102b6d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b6f:	b8 10 00 00 00       	mov    $0x10,%eax
  102b74:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b76:	ea 7d 2b 10 00 08 00 	ljmp   $0x8,$0x102b7d
}
  102b7d:	90                   	nop
  102b7e:	5d                   	pop    %ebp
  102b7f:	c3                   	ret    

00102b80 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b80:	55                   	push   %ebp
  102b81:	89 e5                	mov    %esp,%ebp
  102b83:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102b86:	b8 80 09 11 00       	mov    $0x110980,%eax
  102b8b:	05 00 04 00 00       	add    $0x400,%eax
  102b90:	a3 a4 08 11 00       	mov    %eax,0x1108a4
    ts.ts_ss0 = KERNEL_DS;
  102b95:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  102b9c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102b9e:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102ba5:	68 00 
  102ba7:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102bac:	0f b7 c0             	movzwl %ax,%eax
  102baf:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  102bb5:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102bba:	c1 e8 10             	shr    $0x10,%eax
  102bbd:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  102bc2:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102bc9:	24 f0                	and    $0xf0,%al
  102bcb:	0c 09                	or     $0x9,%al
  102bcd:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102bd2:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102bd9:	0c 10                	or     $0x10,%al
  102bdb:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102be0:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102be7:	24 9f                	and    $0x9f,%al
  102be9:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102bee:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102bf5:	0c 80                	or     $0x80,%al
  102bf7:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102bfc:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102c03:	24 f0                	and    $0xf0,%al
  102c05:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c0a:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102c11:	24 ef                	and    $0xef,%al
  102c13:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c18:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102c1f:	24 df                	and    $0xdf,%al
  102c21:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c26:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102c2d:	0c 40                	or     $0x40,%al
  102c2f:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c34:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102c3b:	24 7f                	and    $0x7f,%al
  102c3d:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c42:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102c47:	c1 e8 18             	shr    $0x18,%eax
  102c4a:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102c4f:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102c56:	24 ef                	and    $0xef,%al
  102c58:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102c5d:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102c64:	e8 e1 fe ff ff       	call   102b4a <lgdt>
  102c69:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102c6f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c73:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102c76:	90                   	nop
  102c77:	c9                   	leave  
  102c78:	c3                   	ret    

00102c79 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102c79:	55                   	push   %ebp
  102c7a:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102c7c:	e8 ff fe ff ff       	call   102b80 <gdt_init>
}
  102c81:	90                   	nop
  102c82:	5d                   	pop    %ebp
  102c83:	c3                   	ret    

00102c84 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102c84:	55                   	push   %ebp
  102c85:	89 e5                	mov    %esp,%ebp
  102c87:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c91:	eb 03                	jmp    102c96 <strlen+0x12>
        cnt ++;
  102c93:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102c96:	8b 45 08             	mov    0x8(%ebp),%eax
  102c99:	8d 50 01             	lea    0x1(%eax),%edx
  102c9c:	89 55 08             	mov    %edx,0x8(%ebp)
  102c9f:	0f b6 00             	movzbl (%eax),%eax
  102ca2:	84 c0                	test   %al,%al
  102ca4:	75 ed                	jne    102c93 <strlen+0xf>
    }
    return cnt;
  102ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ca9:	c9                   	leave  
  102caa:	c3                   	ret    

00102cab <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102cab:	55                   	push   %ebp
  102cac:	89 e5                	mov    %esp,%ebp
  102cae:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102cb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102cb8:	eb 03                	jmp    102cbd <strnlen+0x12>
        cnt ++;
  102cba:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cc0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102cc3:	73 10                	jae    102cd5 <strnlen+0x2a>
  102cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc8:	8d 50 01             	lea    0x1(%eax),%edx
  102ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  102cce:	0f b6 00             	movzbl (%eax),%eax
  102cd1:	84 c0                	test   %al,%al
  102cd3:	75 e5                	jne    102cba <strnlen+0xf>
    }
    return cnt;
  102cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102cd8:	c9                   	leave  
  102cd9:	c3                   	ret    

00102cda <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102cda:	55                   	push   %ebp
  102cdb:	89 e5                	mov    %esp,%ebp
  102cdd:	57                   	push   %edi
  102cde:	56                   	push   %esi
  102cdf:	83 ec 20             	sub    $0x20,%esp
  102ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102cee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf4:	89 d1                	mov    %edx,%ecx
  102cf6:	89 c2                	mov    %eax,%edx
  102cf8:	89 ce                	mov    %ecx,%esi
  102cfa:	89 d7                	mov    %edx,%edi
  102cfc:	ac                   	lods   %ds:(%esi),%al
  102cfd:	aa                   	stos   %al,%es:(%edi)
  102cfe:	84 c0                	test   %al,%al
  102d00:	75 fa                	jne    102cfc <strcpy+0x22>
  102d02:	89 fa                	mov    %edi,%edx
  102d04:	89 f1                	mov    %esi,%ecx
  102d06:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102d09:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102d0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102d12:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102d13:	83 c4 20             	add    $0x20,%esp
  102d16:	5e                   	pop    %esi
  102d17:	5f                   	pop    %edi
  102d18:	5d                   	pop    %ebp
  102d19:	c3                   	ret    

00102d1a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102d1a:	55                   	push   %ebp
  102d1b:	89 e5                	mov    %esp,%ebp
  102d1d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102d20:	8b 45 08             	mov    0x8(%ebp),%eax
  102d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102d26:	eb 1e                	jmp    102d46 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  102d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d2b:	0f b6 10             	movzbl (%eax),%edx
  102d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d31:	88 10                	mov    %dl,(%eax)
  102d33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d36:	0f b6 00             	movzbl (%eax),%eax
  102d39:	84 c0                	test   %al,%al
  102d3b:	74 03                	je     102d40 <strncpy+0x26>
            src ++;
  102d3d:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102d40:	ff 45 fc             	incl   -0x4(%ebp)
  102d43:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102d46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d4a:	75 dc                	jne    102d28 <strncpy+0xe>
    }
    return dst;
  102d4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102d4f:	c9                   	leave  
  102d50:	c3                   	ret    

00102d51 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102d51:	55                   	push   %ebp
  102d52:	89 e5                	mov    %esp,%ebp
  102d54:	57                   	push   %edi
  102d55:	56                   	push   %esi
  102d56:	83 ec 20             	sub    $0x20,%esp
  102d59:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d6b:	89 d1                	mov    %edx,%ecx
  102d6d:	89 c2                	mov    %eax,%edx
  102d6f:	89 ce                	mov    %ecx,%esi
  102d71:	89 d7                	mov    %edx,%edi
  102d73:	ac                   	lods   %ds:(%esi),%al
  102d74:	ae                   	scas   %es:(%edi),%al
  102d75:	75 08                	jne    102d7f <strcmp+0x2e>
  102d77:	84 c0                	test   %al,%al
  102d79:	75 f8                	jne    102d73 <strcmp+0x22>
  102d7b:	31 c0                	xor    %eax,%eax
  102d7d:	eb 04                	jmp    102d83 <strcmp+0x32>
  102d7f:	19 c0                	sbb    %eax,%eax
  102d81:	0c 01                	or     $0x1,%al
  102d83:	89 fa                	mov    %edi,%edx
  102d85:	89 f1                	mov    %esi,%ecx
  102d87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d8a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d8d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102d93:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d94:	83 c4 20             	add    $0x20,%esp
  102d97:	5e                   	pop    %esi
  102d98:	5f                   	pop    %edi
  102d99:	5d                   	pop    %ebp
  102d9a:	c3                   	ret    

00102d9b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d9b:	55                   	push   %ebp
  102d9c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d9e:	eb 09                	jmp    102da9 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  102da0:	ff 4d 10             	decl   0x10(%ebp)
  102da3:	ff 45 08             	incl   0x8(%ebp)
  102da6:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102dad:	74 1a                	je     102dc9 <strncmp+0x2e>
  102daf:	8b 45 08             	mov    0x8(%ebp),%eax
  102db2:	0f b6 00             	movzbl (%eax),%eax
  102db5:	84 c0                	test   %al,%al
  102db7:	74 10                	je     102dc9 <strncmp+0x2e>
  102db9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbc:	0f b6 10             	movzbl (%eax),%edx
  102dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc2:	0f b6 00             	movzbl (%eax),%eax
  102dc5:	38 c2                	cmp    %al,%dl
  102dc7:	74 d7                	je     102da0 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102dc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102dcd:	74 18                	je     102de7 <strncmp+0x4c>
  102dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd2:	0f b6 00             	movzbl (%eax),%eax
  102dd5:	0f b6 d0             	movzbl %al,%edx
  102dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ddb:	0f b6 00             	movzbl (%eax),%eax
  102dde:	0f b6 c0             	movzbl %al,%eax
  102de1:	29 c2                	sub    %eax,%edx
  102de3:	89 d0                	mov    %edx,%eax
  102de5:	eb 05                	jmp    102dec <strncmp+0x51>
  102de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102dec:	5d                   	pop    %ebp
  102ded:	c3                   	ret    

00102dee <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102dee:	55                   	push   %ebp
  102def:	89 e5                	mov    %esp,%ebp
  102df1:	83 ec 04             	sub    $0x4,%esp
  102df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102df7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102dfa:	eb 13                	jmp    102e0f <strchr+0x21>
        if (*s == c) {
  102dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dff:	0f b6 00             	movzbl (%eax),%eax
  102e02:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e05:	75 05                	jne    102e0c <strchr+0x1e>
            return (char *)s;
  102e07:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0a:	eb 12                	jmp    102e1e <strchr+0x30>
        }
        s ++;
  102e0c:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e12:	0f b6 00             	movzbl (%eax),%eax
  102e15:	84 c0                	test   %al,%al
  102e17:	75 e3                	jne    102dfc <strchr+0xe>
    }
    return NULL;
  102e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e1e:	c9                   	leave  
  102e1f:	c3                   	ret    

00102e20 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102e20:	55                   	push   %ebp
  102e21:	89 e5                	mov    %esp,%ebp
  102e23:	83 ec 04             	sub    $0x4,%esp
  102e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e29:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102e2c:	eb 0e                	jmp    102e3c <strfind+0x1c>
        if (*s == c) {
  102e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e31:	0f b6 00             	movzbl (%eax),%eax
  102e34:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e37:	74 0f                	je     102e48 <strfind+0x28>
            break;
        }
        s ++;
  102e39:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3f:	0f b6 00             	movzbl (%eax),%eax
  102e42:	84 c0                	test   %al,%al
  102e44:	75 e8                	jne    102e2e <strfind+0xe>
  102e46:	eb 01                	jmp    102e49 <strfind+0x29>
            break;
  102e48:	90                   	nop
    }
    return (char *)s;
  102e49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102e4c:	c9                   	leave  
  102e4d:	c3                   	ret    

00102e4e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102e4e:	55                   	push   %ebp
  102e4f:	89 e5                	mov    %esp,%ebp
  102e51:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102e54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102e5b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102e62:	eb 03                	jmp    102e67 <strtol+0x19>
        s ++;
  102e64:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102e67:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6a:	0f b6 00             	movzbl (%eax),%eax
  102e6d:	3c 20                	cmp    $0x20,%al
  102e6f:	74 f3                	je     102e64 <strtol+0x16>
  102e71:	8b 45 08             	mov    0x8(%ebp),%eax
  102e74:	0f b6 00             	movzbl (%eax),%eax
  102e77:	3c 09                	cmp    $0x9,%al
  102e79:	74 e9                	je     102e64 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7e:	0f b6 00             	movzbl (%eax),%eax
  102e81:	3c 2b                	cmp    $0x2b,%al
  102e83:	75 05                	jne    102e8a <strtol+0x3c>
        s ++;
  102e85:	ff 45 08             	incl   0x8(%ebp)
  102e88:	eb 14                	jmp    102e9e <strtol+0x50>
    }
    else if (*s == '-') {
  102e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e8d:	0f b6 00             	movzbl (%eax),%eax
  102e90:	3c 2d                	cmp    $0x2d,%al
  102e92:	75 0a                	jne    102e9e <strtol+0x50>
        s ++, neg = 1;
  102e94:	ff 45 08             	incl   0x8(%ebp)
  102e97:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ea2:	74 06                	je     102eaa <strtol+0x5c>
  102ea4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102ea8:	75 22                	jne    102ecc <strtol+0x7e>
  102eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  102ead:	0f b6 00             	movzbl (%eax),%eax
  102eb0:	3c 30                	cmp    $0x30,%al
  102eb2:	75 18                	jne    102ecc <strtol+0x7e>
  102eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb7:	40                   	inc    %eax
  102eb8:	0f b6 00             	movzbl (%eax),%eax
  102ebb:	3c 78                	cmp    $0x78,%al
  102ebd:	75 0d                	jne    102ecc <strtol+0x7e>
        s += 2, base = 16;
  102ebf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102ec3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102eca:	eb 29                	jmp    102ef5 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  102ecc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ed0:	75 16                	jne    102ee8 <strtol+0x9a>
  102ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed5:	0f b6 00             	movzbl (%eax),%eax
  102ed8:	3c 30                	cmp    $0x30,%al
  102eda:	75 0c                	jne    102ee8 <strtol+0x9a>
        s ++, base = 8;
  102edc:	ff 45 08             	incl   0x8(%ebp)
  102edf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102ee6:	eb 0d                	jmp    102ef5 <strtol+0xa7>
    }
    else if (base == 0) {
  102ee8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102eec:	75 07                	jne    102ef5 <strtol+0xa7>
        base = 10;
  102eee:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef8:	0f b6 00             	movzbl (%eax),%eax
  102efb:	3c 2f                	cmp    $0x2f,%al
  102efd:	7e 1b                	jle    102f1a <strtol+0xcc>
  102eff:	8b 45 08             	mov    0x8(%ebp),%eax
  102f02:	0f b6 00             	movzbl (%eax),%eax
  102f05:	3c 39                	cmp    $0x39,%al
  102f07:	7f 11                	jg     102f1a <strtol+0xcc>
            dig = *s - '0';
  102f09:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0c:	0f b6 00             	movzbl (%eax),%eax
  102f0f:	0f be c0             	movsbl %al,%eax
  102f12:	83 e8 30             	sub    $0x30,%eax
  102f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f18:	eb 48                	jmp    102f62 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1d:	0f b6 00             	movzbl (%eax),%eax
  102f20:	3c 60                	cmp    $0x60,%al
  102f22:	7e 1b                	jle    102f3f <strtol+0xf1>
  102f24:	8b 45 08             	mov    0x8(%ebp),%eax
  102f27:	0f b6 00             	movzbl (%eax),%eax
  102f2a:	3c 7a                	cmp    $0x7a,%al
  102f2c:	7f 11                	jg     102f3f <strtol+0xf1>
            dig = *s - 'a' + 10;
  102f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f31:	0f b6 00             	movzbl (%eax),%eax
  102f34:	0f be c0             	movsbl %al,%eax
  102f37:	83 e8 57             	sub    $0x57,%eax
  102f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f3d:	eb 23                	jmp    102f62 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f42:	0f b6 00             	movzbl (%eax),%eax
  102f45:	3c 40                	cmp    $0x40,%al
  102f47:	7e 3b                	jle    102f84 <strtol+0x136>
  102f49:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4c:	0f b6 00             	movzbl (%eax),%eax
  102f4f:	3c 5a                	cmp    $0x5a,%al
  102f51:	7f 31                	jg     102f84 <strtol+0x136>
            dig = *s - 'A' + 10;
  102f53:	8b 45 08             	mov    0x8(%ebp),%eax
  102f56:	0f b6 00             	movzbl (%eax),%eax
  102f59:	0f be c0             	movsbl %al,%eax
  102f5c:	83 e8 37             	sub    $0x37,%eax
  102f5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f65:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f68:	7d 19                	jge    102f83 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  102f6a:	ff 45 08             	incl   0x8(%ebp)
  102f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f70:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f74:	89 c2                	mov    %eax,%edx
  102f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f79:	01 d0                	add    %edx,%eax
  102f7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f7e:	e9 72 ff ff ff       	jmp    102ef5 <strtol+0xa7>
            break;
  102f83:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f88:	74 08                	je     102f92 <strtol+0x144>
        *endptr = (char *) s;
  102f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  102f90:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f96:	74 07                	je     102f9f <strtol+0x151>
  102f98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f9b:	f7 d8                	neg    %eax
  102f9d:	eb 03                	jmp    102fa2 <strtol+0x154>
  102f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102fa2:	c9                   	leave  
  102fa3:	c3                   	ret    

00102fa4 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102fa4:	55                   	push   %ebp
  102fa5:	89 e5                	mov    %esp,%ebp
  102fa7:	57                   	push   %edi
  102fa8:	83 ec 24             	sub    $0x24,%esp
  102fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fae:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102fb1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  102fb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102fbb:	88 45 f7             	mov    %al,-0x9(%ebp)
  102fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  102fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102fc4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102fc7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102fcb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102fce:	89 d7                	mov    %edx,%edi
  102fd0:	f3 aa                	rep stos %al,%es:(%edi)
  102fd2:	89 fa                	mov    %edi,%edx
  102fd4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102fd7:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fdd:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102fde:	83 c4 24             	add    $0x24,%esp
  102fe1:	5f                   	pop    %edi
  102fe2:	5d                   	pop    %ebp
  102fe3:	c3                   	ret    

00102fe4 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102fe4:	55                   	push   %ebp
  102fe5:	89 e5                	mov    %esp,%ebp
  102fe7:	57                   	push   %edi
  102fe8:	56                   	push   %esi
  102fe9:	53                   	push   %ebx
  102fea:	83 ec 30             	sub    $0x30,%esp
  102fed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  102ffc:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103002:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103005:	73 42                	jae    103049 <memmove+0x65>
  103007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10300a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10300d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103010:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103013:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103016:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103019:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10301c:	c1 e8 02             	shr    $0x2,%eax
  10301f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103021:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103024:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103027:	89 d7                	mov    %edx,%edi
  103029:	89 c6                	mov    %eax,%esi
  10302b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10302d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103030:	83 e1 03             	and    $0x3,%ecx
  103033:	74 02                	je     103037 <memmove+0x53>
  103035:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103037:	89 f0                	mov    %esi,%eax
  103039:	89 fa                	mov    %edi,%edx
  10303b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10303e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103041:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  103047:	eb 36                	jmp    10307f <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10304c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10304f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103052:	01 c2                	add    %eax,%edx
  103054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103057:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10305a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10305d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103063:	89 c1                	mov    %eax,%ecx
  103065:	89 d8                	mov    %ebx,%eax
  103067:	89 d6                	mov    %edx,%esi
  103069:	89 c7                	mov    %eax,%edi
  10306b:	fd                   	std    
  10306c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10306e:	fc                   	cld    
  10306f:	89 f8                	mov    %edi,%eax
  103071:	89 f2                	mov    %esi,%edx
  103073:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103076:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103079:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10307c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10307f:	83 c4 30             	add    $0x30,%esp
  103082:	5b                   	pop    %ebx
  103083:	5e                   	pop    %esi
  103084:	5f                   	pop    %edi
  103085:	5d                   	pop    %ebp
  103086:	c3                   	ret    

00103087 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103087:	55                   	push   %ebp
  103088:	89 e5                	mov    %esp,%ebp
  10308a:	57                   	push   %edi
  10308b:	56                   	push   %esi
  10308c:	83 ec 20             	sub    $0x20,%esp
  10308f:	8b 45 08             	mov    0x8(%ebp),%eax
  103092:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103095:	8b 45 0c             	mov    0xc(%ebp),%eax
  103098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10309b:	8b 45 10             	mov    0x10(%ebp),%eax
  10309e:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1030a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030a4:	c1 e8 02             	shr    $0x2,%eax
  1030a7:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1030a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030af:	89 d7                	mov    %edx,%edi
  1030b1:	89 c6                	mov    %eax,%esi
  1030b3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1030b5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1030b8:	83 e1 03             	and    $0x3,%ecx
  1030bb:	74 02                	je     1030bf <memcpy+0x38>
  1030bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1030bf:	89 f0                	mov    %esi,%eax
  1030c1:	89 fa                	mov    %edi,%edx
  1030c3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1030c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1030cf:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1030d0:	83 c4 20             	add    $0x20,%esp
  1030d3:	5e                   	pop    %esi
  1030d4:	5f                   	pop    %edi
  1030d5:	5d                   	pop    %ebp
  1030d6:	c3                   	ret    

001030d7 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1030d7:	55                   	push   %ebp
  1030d8:	89 e5                	mov    %esp,%ebp
  1030da:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1030e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1030e9:	eb 2e                	jmp    103119 <memcmp+0x42>
        if (*s1 != *s2) {
  1030eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030ee:	0f b6 10             	movzbl (%eax),%edx
  1030f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030f4:	0f b6 00             	movzbl (%eax),%eax
  1030f7:	38 c2                	cmp    %al,%dl
  1030f9:	74 18                	je     103113 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030fe:	0f b6 00             	movzbl (%eax),%eax
  103101:	0f b6 d0             	movzbl %al,%edx
  103104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103107:	0f b6 00             	movzbl (%eax),%eax
  10310a:	0f b6 c0             	movzbl %al,%eax
  10310d:	29 c2                	sub    %eax,%edx
  10310f:	89 d0                	mov    %edx,%eax
  103111:	eb 18                	jmp    10312b <memcmp+0x54>
        }
        s1 ++, s2 ++;
  103113:	ff 45 fc             	incl   -0x4(%ebp)
  103116:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103119:	8b 45 10             	mov    0x10(%ebp),%eax
  10311c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10311f:	89 55 10             	mov    %edx,0x10(%ebp)
  103122:	85 c0                	test   %eax,%eax
  103124:	75 c5                	jne    1030eb <memcmp+0x14>
    }
    return 0;
  103126:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10312b:	c9                   	leave  
  10312c:	c3                   	ret    

0010312d <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10312d:	55                   	push   %ebp
  10312e:	89 e5                	mov    %esp,%ebp
  103130:	83 ec 58             	sub    $0x58,%esp
  103133:	8b 45 10             	mov    0x10(%ebp),%eax
  103136:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103139:	8b 45 14             	mov    0x14(%ebp),%eax
  10313c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10313f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103142:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103145:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103148:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10314b:	8b 45 18             	mov    0x18(%ebp),%eax
  10314e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103154:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103157:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10315a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103160:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103163:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103167:	74 1c                	je     103185 <printnum+0x58>
  103169:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10316c:	ba 00 00 00 00       	mov    $0x0,%edx
  103171:	f7 75 e4             	divl   -0x1c(%ebp)
  103174:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10317a:	ba 00 00 00 00       	mov    $0x0,%edx
  10317f:	f7 75 e4             	divl   -0x1c(%ebp)
  103182:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10318b:	f7 75 e4             	divl   -0x1c(%ebp)
  10318e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103191:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103194:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103197:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10319a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10319d:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1031a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031a3:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1031a6:	8b 45 18             	mov    0x18(%ebp),%eax
  1031a9:	ba 00 00 00 00       	mov    $0x0,%edx
  1031ae:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1031b1:	72 56                	jb     103209 <printnum+0xdc>
  1031b3:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1031b6:	77 05                	ja     1031bd <printnum+0x90>
  1031b8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1031bb:	72 4c                	jb     103209 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1031bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1031c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1031c3:	8b 45 20             	mov    0x20(%ebp),%eax
  1031c6:	89 44 24 18          	mov    %eax,0x18(%esp)
  1031ca:	89 54 24 14          	mov    %edx,0x14(%esp)
  1031ce:	8b 45 18             	mov    0x18(%ebp),%eax
  1031d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1031d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1031db:	89 44 24 08          	mov    %eax,0x8(%esp)
  1031df:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1031e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ed:	89 04 24             	mov    %eax,(%esp)
  1031f0:	e8 38 ff ff ff       	call   10312d <printnum>
  1031f5:	eb 1b                	jmp    103212 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1031f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031fe:	8b 45 20             	mov    0x20(%ebp),%eax
  103201:	89 04 24             	mov    %eax,(%esp)
  103204:	8b 45 08             	mov    0x8(%ebp),%eax
  103207:	ff d0                	call   *%eax
        while (-- width > 0)
  103209:	ff 4d 1c             	decl   0x1c(%ebp)
  10320c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103210:	7f e5                	jg     1031f7 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103212:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103215:	05 50 3f 10 00       	add    $0x103f50,%eax
  10321a:	0f b6 00             	movzbl (%eax),%eax
  10321d:	0f be c0             	movsbl %al,%eax
  103220:	8b 55 0c             	mov    0xc(%ebp),%edx
  103223:	89 54 24 04          	mov    %edx,0x4(%esp)
  103227:	89 04 24             	mov    %eax,(%esp)
  10322a:	8b 45 08             	mov    0x8(%ebp),%eax
  10322d:	ff d0                	call   *%eax
}
  10322f:	90                   	nop
  103230:	c9                   	leave  
  103231:	c3                   	ret    

00103232 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103232:	55                   	push   %ebp
  103233:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103235:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103239:	7e 14                	jle    10324f <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10323b:	8b 45 08             	mov    0x8(%ebp),%eax
  10323e:	8b 00                	mov    (%eax),%eax
  103240:	8d 48 08             	lea    0x8(%eax),%ecx
  103243:	8b 55 08             	mov    0x8(%ebp),%edx
  103246:	89 0a                	mov    %ecx,(%edx)
  103248:	8b 50 04             	mov    0x4(%eax),%edx
  10324b:	8b 00                	mov    (%eax),%eax
  10324d:	eb 30                	jmp    10327f <getuint+0x4d>
    }
    else if (lflag) {
  10324f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103253:	74 16                	je     10326b <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103255:	8b 45 08             	mov    0x8(%ebp),%eax
  103258:	8b 00                	mov    (%eax),%eax
  10325a:	8d 48 04             	lea    0x4(%eax),%ecx
  10325d:	8b 55 08             	mov    0x8(%ebp),%edx
  103260:	89 0a                	mov    %ecx,(%edx)
  103262:	8b 00                	mov    (%eax),%eax
  103264:	ba 00 00 00 00       	mov    $0x0,%edx
  103269:	eb 14                	jmp    10327f <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10326b:	8b 45 08             	mov    0x8(%ebp),%eax
  10326e:	8b 00                	mov    (%eax),%eax
  103270:	8d 48 04             	lea    0x4(%eax),%ecx
  103273:	8b 55 08             	mov    0x8(%ebp),%edx
  103276:	89 0a                	mov    %ecx,(%edx)
  103278:	8b 00                	mov    (%eax),%eax
  10327a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10327f:	5d                   	pop    %ebp
  103280:	c3                   	ret    

00103281 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103281:	55                   	push   %ebp
  103282:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103284:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103288:	7e 14                	jle    10329e <getint+0x1d>
        return va_arg(*ap, long long);
  10328a:	8b 45 08             	mov    0x8(%ebp),%eax
  10328d:	8b 00                	mov    (%eax),%eax
  10328f:	8d 48 08             	lea    0x8(%eax),%ecx
  103292:	8b 55 08             	mov    0x8(%ebp),%edx
  103295:	89 0a                	mov    %ecx,(%edx)
  103297:	8b 50 04             	mov    0x4(%eax),%edx
  10329a:	8b 00                	mov    (%eax),%eax
  10329c:	eb 28                	jmp    1032c6 <getint+0x45>
    }
    else if (lflag) {
  10329e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032a2:	74 12                	je     1032b6 <getint+0x35>
        return va_arg(*ap, long);
  1032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a7:	8b 00                	mov    (%eax),%eax
  1032a9:	8d 48 04             	lea    0x4(%eax),%ecx
  1032ac:	8b 55 08             	mov    0x8(%ebp),%edx
  1032af:	89 0a                	mov    %ecx,(%edx)
  1032b1:	8b 00                	mov    (%eax),%eax
  1032b3:	99                   	cltd   
  1032b4:	eb 10                	jmp    1032c6 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b9:	8b 00                	mov    (%eax),%eax
  1032bb:	8d 48 04             	lea    0x4(%eax),%ecx
  1032be:	8b 55 08             	mov    0x8(%ebp),%edx
  1032c1:	89 0a                	mov    %ecx,(%edx)
  1032c3:	8b 00                	mov    (%eax),%eax
  1032c5:	99                   	cltd   
    }
}
  1032c6:	5d                   	pop    %ebp
  1032c7:	c3                   	ret    

001032c8 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1032c8:	55                   	push   %ebp
  1032c9:	89 e5                	mov    %esp,%ebp
  1032cb:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1032ce:	8d 45 14             	lea    0x14(%ebp),%eax
  1032d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032db:	8b 45 10             	mov    0x10(%ebp),%eax
  1032de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ec:	89 04 24             	mov    %eax,(%esp)
  1032ef:	e8 03 00 00 00       	call   1032f7 <vprintfmt>
    va_end(ap);
}
  1032f4:	90                   	nop
  1032f5:	c9                   	leave  
  1032f6:	c3                   	ret    

001032f7 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1032f7:	55                   	push   %ebp
  1032f8:	89 e5                	mov    %esp,%ebp
  1032fa:	56                   	push   %esi
  1032fb:	53                   	push   %ebx
  1032fc:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032ff:	eb 17                	jmp    103318 <vprintfmt+0x21>
            if (ch == '\0') {
  103301:	85 db                	test   %ebx,%ebx
  103303:	0f 84 bf 03 00 00    	je     1036c8 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  103309:	8b 45 0c             	mov    0xc(%ebp),%eax
  10330c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103310:	89 1c 24             	mov    %ebx,(%esp)
  103313:	8b 45 08             	mov    0x8(%ebp),%eax
  103316:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103318:	8b 45 10             	mov    0x10(%ebp),%eax
  10331b:	8d 50 01             	lea    0x1(%eax),%edx
  10331e:	89 55 10             	mov    %edx,0x10(%ebp)
  103321:	0f b6 00             	movzbl (%eax),%eax
  103324:	0f b6 d8             	movzbl %al,%ebx
  103327:	83 fb 25             	cmp    $0x25,%ebx
  10332a:	75 d5                	jne    103301 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10332c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103330:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103337:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10333a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10333d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103344:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103347:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10334a:	8b 45 10             	mov    0x10(%ebp),%eax
  10334d:	8d 50 01             	lea    0x1(%eax),%edx
  103350:	89 55 10             	mov    %edx,0x10(%ebp)
  103353:	0f b6 00             	movzbl (%eax),%eax
  103356:	0f b6 d8             	movzbl %al,%ebx
  103359:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10335c:	83 f8 55             	cmp    $0x55,%eax
  10335f:	0f 87 37 03 00 00    	ja     10369c <vprintfmt+0x3a5>
  103365:	8b 04 85 74 3f 10 00 	mov    0x103f74(,%eax,4),%eax
  10336c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10336e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103372:	eb d6                	jmp    10334a <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103374:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103378:	eb d0                	jmp    10334a <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10337a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103381:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103384:	89 d0                	mov    %edx,%eax
  103386:	c1 e0 02             	shl    $0x2,%eax
  103389:	01 d0                	add    %edx,%eax
  10338b:	01 c0                	add    %eax,%eax
  10338d:	01 d8                	add    %ebx,%eax
  10338f:	83 e8 30             	sub    $0x30,%eax
  103392:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103395:	8b 45 10             	mov    0x10(%ebp),%eax
  103398:	0f b6 00             	movzbl (%eax),%eax
  10339b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10339e:	83 fb 2f             	cmp    $0x2f,%ebx
  1033a1:	7e 38                	jle    1033db <vprintfmt+0xe4>
  1033a3:	83 fb 39             	cmp    $0x39,%ebx
  1033a6:	7f 33                	jg     1033db <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  1033a8:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1033ab:	eb d4                	jmp    103381 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1033ad:	8b 45 14             	mov    0x14(%ebp),%eax
  1033b0:	8d 50 04             	lea    0x4(%eax),%edx
  1033b3:	89 55 14             	mov    %edx,0x14(%ebp)
  1033b6:	8b 00                	mov    (%eax),%eax
  1033b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1033bb:	eb 1f                	jmp    1033dc <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  1033bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033c1:	79 87                	jns    10334a <vprintfmt+0x53>
                width = 0;
  1033c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1033ca:	e9 7b ff ff ff       	jmp    10334a <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1033cf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1033d6:	e9 6f ff ff ff       	jmp    10334a <vprintfmt+0x53>
            goto process_precision;
  1033db:	90                   	nop

        process_precision:
            if (width < 0)
  1033dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033e0:	0f 89 64 ff ff ff    	jns    10334a <vprintfmt+0x53>
                width = precision, precision = -1;
  1033e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1033f3:	e9 52 ff ff ff       	jmp    10334a <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1033f8:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1033fb:	e9 4a ff ff ff       	jmp    10334a <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103400:	8b 45 14             	mov    0x14(%ebp),%eax
  103403:	8d 50 04             	lea    0x4(%eax),%edx
  103406:	89 55 14             	mov    %edx,0x14(%ebp)
  103409:	8b 00                	mov    (%eax),%eax
  10340b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10340e:	89 54 24 04          	mov    %edx,0x4(%esp)
  103412:	89 04 24             	mov    %eax,(%esp)
  103415:	8b 45 08             	mov    0x8(%ebp),%eax
  103418:	ff d0                	call   *%eax
            break;
  10341a:	e9 a4 02 00 00       	jmp    1036c3 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10341f:	8b 45 14             	mov    0x14(%ebp),%eax
  103422:	8d 50 04             	lea    0x4(%eax),%edx
  103425:	89 55 14             	mov    %edx,0x14(%ebp)
  103428:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10342a:	85 db                	test   %ebx,%ebx
  10342c:	79 02                	jns    103430 <vprintfmt+0x139>
                err = -err;
  10342e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103430:	83 fb 06             	cmp    $0x6,%ebx
  103433:	7f 0b                	jg     103440 <vprintfmt+0x149>
  103435:	8b 34 9d 34 3f 10 00 	mov    0x103f34(,%ebx,4),%esi
  10343c:	85 f6                	test   %esi,%esi
  10343e:	75 23                	jne    103463 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  103440:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103444:	c7 44 24 08 61 3f 10 	movl   $0x103f61,0x8(%esp)
  10344b:	00 
  10344c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10344f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103453:	8b 45 08             	mov    0x8(%ebp),%eax
  103456:	89 04 24             	mov    %eax,(%esp)
  103459:	e8 6a fe ff ff       	call   1032c8 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10345e:	e9 60 02 00 00       	jmp    1036c3 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  103463:	89 74 24 0c          	mov    %esi,0xc(%esp)
  103467:	c7 44 24 08 6a 3f 10 	movl   $0x103f6a,0x8(%esp)
  10346e:	00 
  10346f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103472:	89 44 24 04          	mov    %eax,0x4(%esp)
  103476:	8b 45 08             	mov    0x8(%ebp),%eax
  103479:	89 04 24             	mov    %eax,(%esp)
  10347c:	e8 47 fe ff ff       	call   1032c8 <printfmt>
            break;
  103481:	e9 3d 02 00 00       	jmp    1036c3 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103486:	8b 45 14             	mov    0x14(%ebp),%eax
  103489:	8d 50 04             	lea    0x4(%eax),%edx
  10348c:	89 55 14             	mov    %edx,0x14(%ebp)
  10348f:	8b 30                	mov    (%eax),%esi
  103491:	85 f6                	test   %esi,%esi
  103493:	75 05                	jne    10349a <vprintfmt+0x1a3>
                p = "(null)";
  103495:	be 6d 3f 10 00       	mov    $0x103f6d,%esi
            }
            if (width > 0 && padc != '-') {
  10349a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10349e:	7e 76                	jle    103516 <vprintfmt+0x21f>
  1034a0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1034a4:	74 70                	je     103516 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1034a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034ad:	89 34 24             	mov    %esi,(%esp)
  1034b0:	e8 f6 f7 ff ff       	call   102cab <strnlen>
  1034b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1034b8:	29 c2                	sub    %eax,%edx
  1034ba:	89 d0                	mov    %edx,%eax
  1034bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1034bf:	eb 16                	jmp    1034d7 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  1034c1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1034c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1034c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1034cc:	89 04 24             	mov    %eax,(%esp)
  1034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1034d2:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1034d4:	ff 4d e8             	decl   -0x18(%ebp)
  1034d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034db:	7f e4                	jg     1034c1 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034dd:	eb 37                	jmp    103516 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  1034df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1034e3:	74 1f                	je     103504 <vprintfmt+0x20d>
  1034e5:	83 fb 1f             	cmp    $0x1f,%ebx
  1034e8:	7e 05                	jle    1034ef <vprintfmt+0x1f8>
  1034ea:	83 fb 7e             	cmp    $0x7e,%ebx
  1034ed:	7e 15                	jle    103504 <vprintfmt+0x20d>
                    putch('?', putdat);
  1034ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034f6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103500:	ff d0                	call   *%eax
  103502:	eb 0f                	jmp    103513 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  103504:	8b 45 0c             	mov    0xc(%ebp),%eax
  103507:	89 44 24 04          	mov    %eax,0x4(%esp)
  10350b:	89 1c 24             	mov    %ebx,(%esp)
  10350e:	8b 45 08             	mov    0x8(%ebp),%eax
  103511:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103513:	ff 4d e8             	decl   -0x18(%ebp)
  103516:	89 f0                	mov    %esi,%eax
  103518:	8d 70 01             	lea    0x1(%eax),%esi
  10351b:	0f b6 00             	movzbl (%eax),%eax
  10351e:	0f be d8             	movsbl %al,%ebx
  103521:	85 db                	test   %ebx,%ebx
  103523:	74 27                	je     10354c <vprintfmt+0x255>
  103525:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103529:	78 b4                	js     1034df <vprintfmt+0x1e8>
  10352b:	ff 4d e4             	decl   -0x1c(%ebp)
  10352e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103532:	79 ab                	jns    1034df <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  103534:	eb 16                	jmp    10354c <vprintfmt+0x255>
                putch(' ', putdat);
  103536:	8b 45 0c             	mov    0xc(%ebp),%eax
  103539:	89 44 24 04          	mov    %eax,0x4(%esp)
  10353d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103544:	8b 45 08             	mov    0x8(%ebp),%eax
  103547:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103549:	ff 4d e8             	decl   -0x18(%ebp)
  10354c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103550:	7f e4                	jg     103536 <vprintfmt+0x23f>
            }
            break;
  103552:	e9 6c 01 00 00       	jmp    1036c3 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10355a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10355e:	8d 45 14             	lea    0x14(%ebp),%eax
  103561:	89 04 24             	mov    %eax,(%esp)
  103564:	e8 18 fd ff ff       	call   103281 <getint>
  103569:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10356c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10356f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103575:	85 d2                	test   %edx,%edx
  103577:	79 26                	jns    10359f <vprintfmt+0x2a8>
                putch('-', putdat);
  103579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10357c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103580:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  103587:	8b 45 08             	mov    0x8(%ebp),%eax
  10358a:	ff d0                	call   *%eax
                num = -(long long)num;
  10358c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10358f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103592:	f7 d8                	neg    %eax
  103594:	83 d2 00             	adc    $0x0,%edx
  103597:	f7 da                	neg    %edx
  103599:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10359c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10359f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1035a6:	e9 a8 00 00 00       	jmp    103653 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1035ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035b2:	8d 45 14             	lea    0x14(%ebp),%eax
  1035b5:	89 04 24             	mov    %eax,(%esp)
  1035b8:	e8 75 fc ff ff       	call   103232 <getuint>
  1035bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1035c3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1035ca:	e9 84 00 00 00       	jmp    103653 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1035cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035d6:	8d 45 14             	lea    0x14(%ebp),%eax
  1035d9:	89 04 24             	mov    %eax,(%esp)
  1035dc:	e8 51 fc ff ff       	call   103232 <getuint>
  1035e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1035e7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1035ee:	eb 63                	jmp    103653 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  1035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035f7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103601:	ff d0                	call   *%eax
            putch('x', putdat);
  103603:	8b 45 0c             	mov    0xc(%ebp),%eax
  103606:	89 44 24 04          	mov    %eax,0x4(%esp)
  10360a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103611:	8b 45 08             	mov    0x8(%ebp),%eax
  103614:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103616:	8b 45 14             	mov    0x14(%ebp),%eax
  103619:	8d 50 04             	lea    0x4(%eax),%edx
  10361c:	89 55 14             	mov    %edx,0x14(%ebp)
  10361f:	8b 00                	mov    (%eax),%eax
  103621:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103624:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10362b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103632:	eb 1f                	jmp    103653 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103634:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103637:	89 44 24 04          	mov    %eax,0x4(%esp)
  10363b:	8d 45 14             	lea    0x14(%ebp),%eax
  10363e:	89 04 24             	mov    %eax,(%esp)
  103641:	e8 ec fb ff ff       	call   103232 <getuint>
  103646:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103649:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10364c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103653:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10365a:	89 54 24 18          	mov    %edx,0x18(%esp)
  10365e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103661:	89 54 24 14          	mov    %edx,0x14(%esp)
  103665:	89 44 24 10          	mov    %eax,0x10(%esp)
  103669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10366c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10366f:	89 44 24 08          	mov    %eax,0x8(%esp)
  103673:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103677:	8b 45 0c             	mov    0xc(%ebp),%eax
  10367a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10367e:	8b 45 08             	mov    0x8(%ebp),%eax
  103681:	89 04 24             	mov    %eax,(%esp)
  103684:	e8 a4 fa ff ff       	call   10312d <printnum>
            break;
  103689:	eb 38                	jmp    1036c3 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10368b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10368e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103692:	89 1c 24             	mov    %ebx,(%esp)
  103695:	8b 45 08             	mov    0x8(%ebp),%eax
  103698:	ff d0                	call   *%eax
            break;
  10369a:	eb 27                	jmp    1036c3 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10369c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10369f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036a3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1036ad:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1036af:	ff 4d 10             	decl   0x10(%ebp)
  1036b2:	eb 03                	jmp    1036b7 <vprintfmt+0x3c0>
  1036b4:	ff 4d 10             	decl   0x10(%ebp)
  1036b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1036ba:	48                   	dec    %eax
  1036bb:	0f b6 00             	movzbl (%eax),%eax
  1036be:	3c 25                	cmp    $0x25,%al
  1036c0:	75 f2                	jne    1036b4 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1036c2:	90                   	nop
    while (1) {
  1036c3:	e9 37 fc ff ff       	jmp    1032ff <vprintfmt+0x8>
                return;
  1036c8:	90                   	nop
        }
    }
}
  1036c9:	83 c4 40             	add    $0x40,%esp
  1036cc:	5b                   	pop    %ebx
  1036cd:	5e                   	pop    %esi
  1036ce:	5d                   	pop    %ebp
  1036cf:	c3                   	ret    

001036d0 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1036d0:	55                   	push   %ebp
  1036d1:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1036d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036d6:	8b 40 08             	mov    0x8(%eax),%eax
  1036d9:	8d 50 01             	lea    0x1(%eax),%edx
  1036dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036df:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1036e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036e5:	8b 10                	mov    (%eax),%edx
  1036e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ea:	8b 40 04             	mov    0x4(%eax),%eax
  1036ed:	39 c2                	cmp    %eax,%edx
  1036ef:	73 12                	jae    103703 <sprintputch+0x33>
        *b->buf ++ = ch;
  1036f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f4:	8b 00                	mov    (%eax),%eax
  1036f6:	8d 48 01             	lea    0x1(%eax),%ecx
  1036f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1036fc:	89 0a                	mov    %ecx,(%edx)
  1036fe:	8b 55 08             	mov    0x8(%ebp),%edx
  103701:	88 10                	mov    %dl,(%eax)
    }
}
  103703:	90                   	nop
  103704:	5d                   	pop    %ebp
  103705:	c3                   	ret    

00103706 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103706:	55                   	push   %ebp
  103707:	89 e5                	mov    %esp,%ebp
  103709:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10370c:	8d 45 14             	lea    0x14(%ebp),%eax
  10370f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103715:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103719:	8b 45 10             	mov    0x10(%ebp),%eax
  10371c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103720:	8b 45 0c             	mov    0xc(%ebp),%eax
  103723:	89 44 24 04          	mov    %eax,0x4(%esp)
  103727:	8b 45 08             	mov    0x8(%ebp),%eax
  10372a:	89 04 24             	mov    %eax,(%esp)
  10372d:	e8 08 00 00 00       	call   10373a <vsnprintf>
  103732:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103735:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103738:	c9                   	leave  
  103739:	c3                   	ret    

0010373a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10373a:	55                   	push   %ebp
  10373b:	89 e5                	mov    %esp,%ebp
  10373d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103740:	8b 45 08             	mov    0x8(%ebp),%eax
  103743:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103746:	8b 45 0c             	mov    0xc(%ebp),%eax
  103749:	8d 50 ff             	lea    -0x1(%eax),%edx
  10374c:	8b 45 08             	mov    0x8(%ebp),%eax
  10374f:	01 d0                	add    %edx,%eax
  103751:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103754:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10375b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10375f:	74 0a                	je     10376b <vsnprintf+0x31>
  103761:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103767:	39 c2                	cmp    %eax,%edx
  103769:	76 07                	jbe    103772 <vsnprintf+0x38>
        return -E_INVAL;
  10376b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103770:	eb 2a                	jmp    10379c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103772:	8b 45 14             	mov    0x14(%ebp),%eax
  103775:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103779:	8b 45 10             	mov    0x10(%ebp),%eax
  10377c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103780:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103783:	89 44 24 04          	mov    %eax,0x4(%esp)
  103787:	c7 04 24 d0 36 10 00 	movl   $0x1036d0,(%esp)
  10378e:	e8 64 fb ff ff       	call   1032f7 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103796:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103799:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10379c:	c9                   	leave  
  10379d:	c3                   	ret    
