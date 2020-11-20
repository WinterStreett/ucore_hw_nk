
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 90 11 40       	mov    $0x40119000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 90 11 00       	mov    %eax,0x119000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 80 11 00       	mov    $0x118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba 88 bf 11 00       	mov    $0x11bf88,%edx
  100041:	b8 36 8a 11 00       	mov    $0x118a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 8a 11 00 	movl   $0x118a36,(%esp)
  10005d:	e8 ca 5a 00 00       	call   105b2c <memset>

    cons_init();                // init the console
  100062:	e8 9c 15 00 00       	call   101603 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 40 63 10 00 	movl   $0x106340,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 5c 63 10 00 	movl   $0x10635c,(%esp)
  10007c:	e8 21 02 00 00       	call   1002a2 <cprintf>

    print_kerninfo();
  100081:	e8 c2 08 00 00       	call   100948 <print_kerninfo>

    grade_backtrace();
  100086:	e8 8e 00 00 00       	call   100119 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 53 34 00 00       	call   1034e3 <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 d3 16 00 00       	call   101768 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 58 18 00 00       	call   1018f2 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 07 0d 00 00       	call   100da6 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 fe 17 00 00       	call   1018a2 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  1000a4:	e8 6b 01 00 00       	call   100214 <lab1_switch_test>

    /* do nothing */
    while (1);
  1000a9:	eb fe                	jmp    1000a9 <kern_init+0x73>

001000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000ab:	55                   	push   %ebp
  1000ac:	89 e5                	mov    %esp,%ebp
  1000ae:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b8:	00 
  1000b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000c0:	00 
  1000c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c8:	e8 c7 0c 00 00       	call   100d94 <mon_backtrace>
}
  1000cd:	90                   	nop
  1000ce:	c9                   	leave  
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000d0:	55                   	push   %ebp
  1000d1:	89 e5                	mov    %esp,%ebp
  1000d3:	53                   	push   %ebx
  1000d4:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d7:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000da:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000dd:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e7:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ef:	89 04 24             	mov    %eax,(%esp)
  1000f2:	e8 b4 ff ff ff       	call   1000ab <grade_backtrace2>
}
  1000f7:	90                   	nop
  1000f8:	83 c4 14             	add    $0x14,%esp
  1000fb:	5b                   	pop    %ebx
  1000fc:	5d                   	pop    %ebp
  1000fd:	c3                   	ret    

001000fe <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000fe:	55                   	push   %ebp
  1000ff:	89 e5                	mov    %esp,%ebp
  100101:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100104:	8b 45 10             	mov    0x10(%ebp),%eax
  100107:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010b:	8b 45 08             	mov    0x8(%ebp),%eax
  10010e:	89 04 24             	mov    %eax,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace1>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <grade_backtrace>:

void
grade_backtrace(void) {
  100119:	55                   	push   %ebp
  10011a:	89 e5                	mov    %esp,%ebp
  10011c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011f:	b8 36 00 10 00       	mov    $0x100036,%eax
  100124:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10012b:	ff 
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100137:	e8 c2 ff ff ff       	call   1000fe <grade_backtrace0>
}
  10013c:	90                   	nop
  10013d:	c9                   	leave  
  10013e:	c3                   	ret    

0010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013f:	55                   	push   %ebp
  100140:	89 e5                	mov    %esp,%ebp
  100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	83 e0 03             	and    $0x3,%eax
  100158:	89 c2                	mov    %eax,%edx
  10015a:	a1 00 b0 11 00       	mov    0x11b000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 61 63 10 00 	movl   $0x106361,(%esp)
  10016e:	e8 2f 01 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 b0 11 00       	mov    0x11b000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 6f 63 10 00 	movl   $0x10636f,(%esp)
  10018d:	e8 10 01 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 b0 11 00       	mov    0x11b000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 7d 63 10 00 	movl   $0x10637d,(%esp)
  1001ac:	e8 f1 00 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 8b 63 10 00 	movl   $0x10638b,(%esp)
  1001cb:	e8 d2 00 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 99 63 10 00 	movl   $0x106399,(%esp)
  1001ea:	e8 b3 00 00 00       	call   1002a2 <cprintf>
    round ++;
  1001ef:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 b0 11 00       	mov    %eax,0x11b000
}
  1001fa:	90                   	nop
  1001fb:	c9                   	leave  
  1001fc:	c3                   	ret    

001001fd <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001fd:	55                   	push   %ebp
  1001fe:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
        asm volatile (
  100200:	83 ec 08             	sub    $0x8,%esp
  100203:	cd 78                	int    $0x78
  100205:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  100207:	90                   	nop
  100208:	5d                   	pop    %ebp
  100209:	c3                   	ret    

0010020a <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10020a:	55                   	push   %ebp
  10020b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
        asm volatile (
  10020d:	cd 79                	int    $0x79
  10020f:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  100211:	90                   	nop
  100212:	5d                   	pop    %ebp
  100213:	c3                   	ret    

00100214 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100214:	55                   	push   %ebp
  100215:	89 e5                	mov    %esp,%ebp
  100217:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10021a:	e8 20 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10021f:	c7 04 24 a8 63 10 00 	movl   $0x1063a8,(%esp)
  100226:	e8 77 00 00 00       	call   1002a2 <cprintf>
    lab1_switch_to_user();
  10022b:	e8 cd ff ff ff       	call   1001fd <lab1_switch_to_user>
    lab1_print_cur_status();
  100230:	e8 0a ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100235:	c7 04 24 c8 63 10 00 	movl   $0x1063c8,(%esp)
  10023c:	e8 61 00 00 00       	call   1002a2 <cprintf>
    lab1_switch_to_kernel();
  100241:	e8 c4 ff ff ff       	call   10020a <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100246:	e8 f4 fe ff ff       	call   10013f <lab1_print_cur_status>
}
  10024b:	90                   	nop
  10024c:	c9                   	leave  
  10024d:	c3                   	ret    

0010024e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10024e:	55                   	push   %ebp
  10024f:	89 e5                	mov    %esp,%ebp
  100251:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100254:	8b 45 08             	mov    0x8(%ebp),%eax
  100257:	89 04 24             	mov    %eax,(%esp)
  10025a:	e8 d1 13 00 00       	call   101630 <cons_putc>
    (*cnt) ++;
  10025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100262:	8b 00                	mov    (%eax),%eax
  100264:	8d 50 01             	lea    0x1(%eax),%edx
  100267:	8b 45 0c             	mov    0xc(%ebp),%eax
  10026a:	89 10                	mov    %edx,(%eax)
}
  10026c:	90                   	nop
  10026d:	c9                   	leave  
  10026e:	c3                   	ret    

0010026f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10026f:	55                   	push   %ebp
  100270:	89 e5                	mov    %esp,%ebp
  100272:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10027c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10027f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100283:	8b 45 08             	mov    0x8(%ebp),%eax
  100286:	89 44 24 08          	mov    %eax,0x8(%esp)
  10028a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10028d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100291:	c7 04 24 4e 02 10 00 	movl   $0x10024e,(%esp)
  100298:	e8 e2 5b 00 00       	call   105e7f <vprintfmt>
    return cnt;
  10029d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002a0:	c9                   	leave  
  1002a1:	c3                   	ret    

001002a2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002a2:	55                   	push   %ebp
  1002a3:	89 e5                	mov    %esp,%ebp
  1002a5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002a8:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b8:	89 04 24             	mov    %eax,(%esp)
  1002bb:	e8 af ff ff ff       	call   10026f <vcprintf>
  1002c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002c6:	c9                   	leave  
  1002c7:	c3                   	ret    

001002c8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	89 04 24             	mov    %eax,(%esp)
  1002d4:	e8 57 13 00 00       	call   101630 <cons_putc>
}
  1002d9:	90                   	nop
  1002da:	c9                   	leave  
  1002db:	c3                   	ret    

001002dc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002dc:	55                   	push   %ebp
  1002dd:	89 e5                	mov    %esp,%ebp
  1002df:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e9:	eb 13                	jmp    1002fe <cputs+0x22>
        cputch(c, &cnt);
  1002eb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ef:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002f2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f6:	89 04 24             	mov    %eax,(%esp)
  1002f9:	e8 50 ff ff ff       	call   10024e <cputch>
    while ((c = *str ++) != '\0') {
  1002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100301:	8d 50 01             	lea    0x1(%eax),%edx
  100304:	89 55 08             	mov    %edx,0x8(%ebp)
  100307:	0f b6 00             	movzbl (%eax),%eax
  10030a:	88 45 f7             	mov    %al,-0x9(%ebp)
  10030d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100311:	75 d8                	jne    1002eb <cputs+0xf>
    }
    cputch('\n', &cnt);
  100313:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100316:	89 44 24 04          	mov    %eax,0x4(%esp)
  10031a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100321:	e8 28 ff ff ff       	call   10024e <cputch>
    return cnt;
  100326:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100329:	c9                   	leave  
  10032a:	c3                   	ret    

0010032b <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10032b:	55                   	push   %ebp
  10032c:	89 e5                	mov    %esp,%ebp
  10032e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100331:	e8 37 13 00 00       	call   10166d <cons_getc>
  100336:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10033d:	74 f2                	je     100331 <getchar+0x6>
        /* do nothing */;
    return c;
  10033f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100342:	c9                   	leave  
  100343:	c3                   	ret    

00100344 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100344:	55                   	push   %ebp
  100345:	89 e5                	mov    %esp,%ebp
  100347:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10034a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10034e:	74 13                	je     100363 <readline+0x1f>
        cprintf("%s", prompt);
  100350:	8b 45 08             	mov    0x8(%ebp),%eax
  100353:	89 44 24 04          	mov    %eax,0x4(%esp)
  100357:	c7 04 24 e7 63 10 00 	movl   $0x1063e7,(%esp)
  10035e:	e8 3f ff ff ff       	call   1002a2 <cprintf>
    }
    int i = 0, c;
  100363:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10036a:	e8 bc ff ff ff       	call   10032b <getchar>
  10036f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100372:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100376:	79 07                	jns    10037f <readline+0x3b>
            return NULL;
  100378:	b8 00 00 00 00       	mov    $0x0,%eax
  10037d:	eb 78                	jmp    1003f7 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10037f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100383:	7e 28                	jle    1003ad <readline+0x69>
  100385:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10038c:	7f 1f                	jg     1003ad <readline+0x69>
            cputchar(c);
  10038e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100391:	89 04 24             	mov    %eax,(%esp)
  100394:	e8 2f ff ff ff       	call   1002c8 <cputchar>
            buf[i ++] = c;
  100399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039c:	8d 50 01             	lea    0x1(%eax),%edx
  10039f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003a5:	88 90 20 b0 11 00    	mov    %dl,0x11b020(%eax)
  1003ab:	eb 45                	jmp    1003f2 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1003ad:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b1:	75 16                	jne    1003c9 <readline+0x85>
  1003b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003b7:	7e 10                	jle    1003c9 <readline+0x85>
            cputchar(c);
  1003b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003bc:	89 04 24             	mov    %eax,(%esp)
  1003bf:	e8 04 ff ff ff       	call   1002c8 <cputchar>
            i --;
  1003c4:	ff 4d f4             	decl   -0xc(%ebp)
  1003c7:	eb 29                	jmp    1003f2 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1003c9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003cd:	74 06                	je     1003d5 <readline+0x91>
  1003cf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003d3:	75 95                	jne    10036a <readline+0x26>
            cputchar(c);
  1003d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003d8:	89 04 24             	mov    %eax,(%esp)
  1003db:	e8 e8 fe ff ff       	call   1002c8 <cputchar>
            buf[i] = '\0';
  1003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003e3:	05 20 b0 11 00       	add    $0x11b020,%eax
  1003e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003eb:	b8 20 b0 11 00       	mov    $0x11b020,%eax
  1003f0:	eb 05                	jmp    1003f7 <readline+0xb3>
        c = getchar();
  1003f2:	e9 73 ff ff ff       	jmp    10036a <readline+0x26>
        }
    }
}
  1003f7:	c9                   	leave  
  1003f8:	c3                   	ret    

001003f9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003f9:	55                   	push   %ebp
  1003fa:	89 e5                	mov    %esp,%ebp
  1003fc:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003ff:	a1 20 b4 11 00       	mov    0x11b420,%eax
  100404:	85 c0                	test   %eax,%eax
  100406:	75 5b                	jne    100463 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100408:	c7 05 20 b4 11 00 01 	movl   $0x1,0x11b420
  10040f:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100412:	8d 45 14             	lea    0x14(%ebp),%eax
  100415:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100418:	8b 45 0c             	mov    0xc(%ebp),%eax
  10041b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10041f:	8b 45 08             	mov    0x8(%ebp),%eax
  100422:	89 44 24 04          	mov    %eax,0x4(%esp)
  100426:	c7 04 24 ea 63 10 00 	movl   $0x1063ea,(%esp)
  10042d:	e8 70 fe ff ff       	call   1002a2 <cprintf>
    vcprintf(fmt, ap);
  100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100435:	89 44 24 04          	mov    %eax,0x4(%esp)
  100439:	8b 45 10             	mov    0x10(%ebp),%eax
  10043c:	89 04 24             	mov    %eax,(%esp)
  10043f:	e8 2b fe ff ff       	call   10026f <vcprintf>
    cprintf("\n");
  100444:	c7 04 24 06 64 10 00 	movl   $0x106406,(%esp)
  10044b:	e8 52 fe ff ff       	call   1002a2 <cprintf>
    
    cprintf("stack trackback:\n");
  100450:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  100457:	e8 46 fe ff ff       	call   1002a2 <cprintf>
    print_stackframe();
  10045c:	e8 32 06 00 00       	call   100a93 <print_stackframe>
  100461:	eb 01                	jmp    100464 <__panic+0x6b>
        goto panic_dead;
  100463:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100464:	e8 40 14 00 00       	call   1018a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100469:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100470:	e8 52 08 00 00       	call   100cc7 <kmonitor>
  100475:	eb f2                	jmp    100469 <__panic+0x70>

00100477 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100477:	55                   	push   %ebp
  100478:	89 e5                	mov    %esp,%ebp
  10047a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10047d:	8d 45 14             	lea    0x14(%ebp),%eax
  100480:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100483:	8b 45 0c             	mov    0xc(%ebp),%eax
  100486:	89 44 24 08          	mov    %eax,0x8(%esp)
  10048a:	8b 45 08             	mov    0x8(%ebp),%eax
  10048d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100491:	c7 04 24 1a 64 10 00 	movl   $0x10641a,(%esp)
  100498:	e8 05 fe ff ff       	call   1002a2 <cprintf>
    vcprintf(fmt, ap);
  10049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a7:	89 04 24             	mov    %eax,(%esp)
  1004aa:	e8 c0 fd ff ff       	call   10026f <vcprintf>
    cprintf("\n");
  1004af:	c7 04 24 06 64 10 00 	movl   $0x106406,(%esp)
  1004b6:	e8 e7 fd ff ff       	call   1002a2 <cprintf>
    va_end(ap);
}
  1004bb:	90                   	nop
  1004bc:	c9                   	leave  
  1004bd:	c3                   	ret    

001004be <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004be:	55                   	push   %ebp
  1004bf:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004c1:	a1 20 b4 11 00       	mov    0x11b420,%eax
}
  1004c6:	5d                   	pop    %ebp
  1004c7:	c3                   	ret    

001004c8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004c8:	55                   	push   %ebp
  1004c9:	89 e5                	mov    %esp,%ebp
  1004cb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d1:	8b 00                	mov    (%eax),%eax
  1004d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004d6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004e5:	e9 ca 00 00 00       	jmp    1005b4 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004f0:	01 d0                	add    %edx,%eax
  1004f2:	89 c2                	mov    %eax,%edx
  1004f4:	c1 ea 1f             	shr    $0x1f,%edx
  1004f7:	01 d0                	add    %edx,%eax
  1004f9:	d1 f8                	sar    %eax
  1004fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100501:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100504:	eb 03                	jmp    100509 <stab_binsearch+0x41>
            m --;
  100506:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10050f:	7c 1f                	jl     100530 <stab_binsearch+0x68>
  100511:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100514:	89 d0                	mov    %edx,%eax
  100516:	01 c0                	add    %eax,%eax
  100518:	01 d0                	add    %edx,%eax
  10051a:	c1 e0 02             	shl    $0x2,%eax
  10051d:	89 c2                	mov    %eax,%edx
  10051f:	8b 45 08             	mov    0x8(%ebp),%eax
  100522:	01 d0                	add    %edx,%eax
  100524:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100528:	0f b6 c0             	movzbl %al,%eax
  10052b:	39 45 14             	cmp    %eax,0x14(%ebp)
  10052e:	75 d6                	jne    100506 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100533:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100536:	7d 09                	jge    100541 <stab_binsearch+0x79>
            l = true_m + 1;
  100538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10053b:	40                   	inc    %eax
  10053c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10053f:	eb 73                	jmp    1005b4 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100541:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100548:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10054b:	89 d0                	mov    %edx,%eax
  10054d:	01 c0                	add    %eax,%eax
  10054f:	01 d0                	add    %edx,%eax
  100551:	c1 e0 02             	shl    $0x2,%eax
  100554:	89 c2                	mov    %eax,%edx
  100556:	8b 45 08             	mov    0x8(%ebp),%eax
  100559:	01 d0                	add    %edx,%eax
  10055b:	8b 40 08             	mov    0x8(%eax),%eax
  10055e:	39 45 18             	cmp    %eax,0x18(%ebp)
  100561:	76 11                	jbe    100574 <stab_binsearch+0xac>
            *region_left = m;
  100563:	8b 45 0c             	mov    0xc(%ebp),%eax
  100566:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100569:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10056b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10056e:	40                   	inc    %eax
  10056f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100572:	eb 40                	jmp    1005b4 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100574:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100577:	89 d0                	mov    %edx,%eax
  100579:	01 c0                	add    %eax,%eax
  10057b:	01 d0                	add    %edx,%eax
  10057d:	c1 e0 02             	shl    $0x2,%eax
  100580:	89 c2                	mov    %eax,%edx
  100582:	8b 45 08             	mov    0x8(%ebp),%eax
  100585:	01 d0                	add    %edx,%eax
  100587:	8b 40 08             	mov    0x8(%eax),%eax
  10058a:	39 45 18             	cmp    %eax,0x18(%ebp)
  10058d:	73 14                	jae    1005a3 <stab_binsearch+0xdb>
            *region_right = m - 1;
  10058f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100592:	8d 50 ff             	lea    -0x1(%eax),%edx
  100595:	8b 45 10             	mov    0x10(%ebp),%eax
  100598:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10059a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059d:	48                   	dec    %eax
  10059e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005a1:	eb 11                	jmp    1005b4 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a9:	89 10                	mov    %edx,(%eax)
            l = m;
  1005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005b1:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005ba:	0f 8e 2a ff ff ff    	jle    1004ea <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005c4:	75 0f                	jne    1005d5 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c9:	8b 00                	mov    (%eax),%eax
  1005cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005d3:	eb 3e                	jmp    100613 <stab_binsearch+0x14b>
        l = *region_right;
  1005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d8:	8b 00                	mov    (%eax),%eax
  1005da:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005dd:	eb 03                	jmp    1005e2 <stab_binsearch+0x11a>
  1005df:	ff 4d fc             	decl   -0x4(%ebp)
  1005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e5:	8b 00                	mov    (%eax),%eax
  1005e7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005ea:	7e 1f                	jle    10060b <stab_binsearch+0x143>
  1005ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005ef:	89 d0                	mov    %edx,%eax
  1005f1:	01 c0                	add    %eax,%eax
  1005f3:	01 d0                	add    %edx,%eax
  1005f5:	c1 e0 02             	shl    $0x2,%eax
  1005f8:	89 c2                	mov    %eax,%edx
  1005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1005fd:	01 d0                	add    %edx,%eax
  1005ff:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100603:	0f b6 c0             	movzbl %al,%eax
  100606:	39 45 14             	cmp    %eax,0x14(%ebp)
  100609:	75 d4                	jne    1005df <stab_binsearch+0x117>
        *region_left = l;
  10060b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100611:	89 10                	mov    %edx,(%eax)
}
  100613:	90                   	nop
  100614:	c9                   	leave  
  100615:	c3                   	ret    

00100616 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100616:	55                   	push   %ebp
  100617:	89 e5                	mov    %esp,%ebp
  100619:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10061c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061f:	c7 00 38 64 10 00    	movl   $0x106438,(%eax)
    info->eip_line = 0;
  100625:	8b 45 0c             	mov    0xc(%ebp),%eax
  100628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100632:	c7 40 08 38 64 10 00 	movl   $0x106438,0x8(%eax)
    info->eip_fn_namelen = 9;
  100639:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100643:	8b 45 0c             	mov    0xc(%ebp),%eax
  100646:	8b 55 08             	mov    0x8(%ebp),%edx
  100649:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10064c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100656:	c7 45 f4 b0 76 10 00 	movl   $0x1076b0,-0xc(%ebp)
    stab_end = __STAB_END__;
  10065d:	c7 45 f0 f8 2a 11 00 	movl   $0x112af8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100664:	c7 45 ec f9 2a 11 00 	movl   $0x112af9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10066b:	c7 45 e8 1a 56 11 00 	movl   $0x11561a,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100675:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100678:	76 0b                	jbe    100685 <debuginfo_eip+0x6f>
  10067a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10067d:	48                   	dec    %eax
  10067e:	0f b6 00             	movzbl (%eax),%eax
  100681:	84 c0                	test   %al,%al
  100683:	74 0a                	je     10068f <debuginfo_eip+0x79>
        return -1;
  100685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10068a:	e9 b7 02 00 00       	jmp    100946 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10068f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100696:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069c:	29 c2                	sub    %eax,%edx
  10069e:	89 d0                	mov    %edx,%eax
  1006a0:	c1 f8 02             	sar    $0x2,%eax
  1006a3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006a9:	48                   	dec    %eax
  1006aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006b4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006bb:	00 
  1006bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006cd:	89 04 24             	mov    %eax,(%esp)
  1006d0:	e8 f3 fd ff ff       	call   1004c8 <stab_binsearch>
    if (lfile == 0)
  1006d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d8:	85 c0                	test   %eax,%eax
  1006da:	75 0a                	jne    1006e6 <debuginfo_eip+0xd0>
        return -1;
  1006dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006e1:	e9 60 02 00 00       	jmp    100946 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006f9:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100700:	00 
  100701:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100704:	89 44 24 08          	mov    %eax,0x8(%esp)
  100708:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10070b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10070f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100712:	89 04 24             	mov    %eax,(%esp)
  100715:	e8 ae fd ff ff       	call   1004c8 <stab_binsearch>

    if (lfun <= rfun) {
  10071a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10071d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100720:	39 c2                	cmp    %eax,%edx
  100722:	7f 7c                	jg     1007a0 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100724:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100727:	89 c2                	mov    %eax,%edx
  100729:	89 d0                	mov    %edx,%eax
  10072b:	01 c0                	add    %eax,%eax
  10072d:	01 d0                	add    %edx,%eax
  10072f:	c1 e0 02             	shl    $0x2,%eax
  100732:	89 c2                	mov    %eax,%edx
  100734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	8b 00                	mov    (%eax),%eax
  10073b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10073e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100741:	29 d1                	sub    %edx,%ecx
  100743:	89 ca                	mov    %ecx,%edx
  100745:	39 d0                	cmp    %edx,%eax
  100747:	73 22                	jae    10076b <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100749:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074c:	89 c2                	mov    %eax,%edx
  10074e:	89 d0                	mov    %edx,%eax
  100750:	01 c0                	add    %eax,%eax
  100752:	01 d0                	add    %edx,%eax
  100754:	c1 e0 02             	shl    $0x2,%eax
  100757:	89 c2                	mov    %eax,%edx
  100759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075c:	01 d0                	add    %edx,%eax
  10075e:	8b 10                	mov    (%eax),%edx
  100760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100763:	01 c2                	add    %eax,%edx
  100765:	8b 45 0c             	mov    0xc(%ebp),%eax
  100768:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10076b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10076e:	89 c2                	mov    %eax,%edx
  100770:	89 d0                	mov    %edx,%eax
  100772:	01 c0                	add    %eax,%eax
  100774:	01 d0                	add    %edx,%eax
  100776:	c1 e0 02             	shl    $0x2,%eax
  100779:	89 c2                	mov    %eax,%edx
  10077b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077e:	01 d0                	add    %edx,%eax
  100780:	8b 50 08             	mov    0x8(%eax),%edx
  100783:	8b 45 0c             	mov    0xc(%ebp),%eax
  100786:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100789:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078c:	8b 40 10             	mov    0x10(%eax),%eax
  10078f:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100792:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100795:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100798:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10079b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10079e:	eb 15                	jmp    1007b5 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1007a6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b8:	8b 40 08             	mov    0x8(%eax),%eax
  1007bb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007c2:	00 
  1007c3:	89 04 24             	mov    %eax,(%esp)
  1007c6:	e8 dd 51 00 00       	call   1059a8 <strfind>
  1007cb:	89 c2                	mov    %eax,%edx
  1007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d0:	8b 40 08             	mov    0x8(%eax),%eax
  1007d3:	29 c2                	sub    %eax,%edx
  1007d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007db:	8b 45 08             	mov    0x8(%ebp),%eax
  1007de:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007e2:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007e9:	00 
  1007ea:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007f1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007fb:	89 04 24             	mov    %eax,(%esp)
  1007fe:	e8 c5 fc ff ff       	call   1004c8 <stab_binsearch>
    if (lline <= rline) {
  100803:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100806:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100809:	39 c2                	cmp    %eax,%edx
  10080b:	7f 23                	jg     100830 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  10080d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100810:	89 c2                	mov    %eax,%edx
  100812:	89 d0                	mov    %edx,%eax
  100814:	01 c0                	add    %eax,%eax
  100816:	01 d0                	add    %edx,%eax
  100818:	c1 e0 02             	shl    $0x2,%eax
  10081b:	89 c2                	mov    %eax,%edx
  10081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100820:	01 d0                	add    %edx,%eax
  100822:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100826:	89 c2                	mov    %eax,%edx
  100828:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082b:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10082e:	eb 11                	jmp    100841 <debuginfo_eip+0x22b>
        return -1;
  100830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100835:	e9 0c 01 00 00       	jmp    100946 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10083a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083d:	48                   	dec    %eax
  10083e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100841:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100847:	39 c2                	cmp    %eax,%edx
  100849:	7c 56                	jl     1008a1 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  10084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084e:	89 c2                	mov    %eax,%edx
  100850:	89 d0                	mov    %edx,%eax
  100852:	01 c0                	add    %eax,%eax
  100854:	01 d0                	add    %edx,%eax
  100856:	c1 e0 02             	shl    $0x2,%eax
  100859:	89 c2                	mov    %eax,%edx
  10085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100864:	3c 84                	cmp    $0x84,%al
  100866:	74 39                	je     1008a1 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100868:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10086b:	89 c2                	mov    %eax,%edx
  10086d:	89 d0                	mov    %edx,%eax
  10086f:	01 c0                	add    %eax,%eax
  100871:	01 d0                	add    %edx,%eax
  100873:	c1 e0 02             	shl    $0x2,%eax
  100876:	89 c2                	mov    %eax,%edx
  100878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10087b:	01 d0                	add    %edx,%eax
  10087d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100881:	3c 64                	cmp    $0x64,%al
  100883:	75 b5                	jne    10083a <debuginfo_eip+0x224>
  100885:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100888:	89 c2                	mov    %eax,%edx
  10088a:	89 d0                	mov    %edx,%eax
  10088c:	01 c0                	add    %eax,%eax
  10088e:	01 d0                	add    %edx,%eax
  100890:	c1 e0 02             	shl    $0x2,%eax
  100893:	89 c2                	mov    %eax,%edx
  100895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100898:	01 d0                	add    %edx,%eax
  10089a:	8b 40 08             	mov    0x8(%eax),%eax
  10089d:	85 c0                	test   %eax,%eax
  10089f:	74 99                	je     10083a <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008a7:	39 c2                	cmp    %eax,%edx
  1008a9:	7c 46                	jl     1008f1 <debuginfo_eip+0x2db>
  1008ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008ae:	89 c2                	mov    %eax,%edx
  1008b0:	89 d0                	mov    %edx,%eax
  1008b2:	01 c0                	add    %eax,%eax
  1008b4:	01 d0                	add    %edx,%eax
  1008b6:	c1 e0 02             	shl    $0x2,%eax
  1008b9:	89 c2                	mov    %eax,%edx
  1008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008be:	01 d0                	add    %edx,%eax
  1008c0:	8b 00                	mov    (%eax),%eax
  1008c2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1008c8:	29 d1                	sub    %edx,%ecx
  1008ca:	89 ca                	mov    %ecx,%edx
  1008cc:	39 d0                	cmp    %edx,%eax
  1008ce:	73 21                	jae    1008f1 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d3:	89 c2                	mov    %eax,%edx
  1008d5:	89 d0                	mov    %edx,%eax
  1008d7:	01 c0                	add    %eax,%eax
  1008d9:	01 d0                	add    %edx,%eax
  1008db:	c1 e0 02             	shl    $0x2,%eax
  1008de:	89 c2                	mov    %eax,%edx
  1008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e3:	01 d0                	add    %edx,%eax
  1008e5:	8b 10                	mov    (%eax),%edx
  1008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008ea:	01 c2                	add    %eax,%edx
  1008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ef:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008f7:	39 c2                	cmp    %eax,%edx
  1008f9:	7d 46                	jge    100941 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008fe:	40                   	inc    %eax
  1008ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100902:	eb 16                	jmp    10091a <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100904:	8b 45 0c             	mov    0xc(%ebp),%eax
  100907:	8b 40 14             	mov    0x14(%eax),%eax
  10090a:	8d 50 01             	lea    0x1(%eax),%edx
  10090d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100910:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100916:	40                   	inc    %eax
  100917:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10091a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100920:	39 c2                	cmp    %eax,%edx
  100922:	7d 1d                	jge    100941 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100924:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100927:	89 c2                	mov    %eax,%edx
  100929:	89 d0                	mov    %edx,%eax
  10092b:	01 c0                	add    %eax,%eax
  10092d:	01 d0                	add    %edx,%eax
  10092f:	c1 e0 02             	shl    $0x2,%eax
  100932:	89 c2                	mov    %eax,%edx
  100934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100937:	01 d0                	add    %edx,%eax
  100939:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10093d:	3c a0                	cmp    $0xa0,%al
  10093f:	74 c3                	je     100904 <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  100941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100946:	c9                   	leave  
  100947:	c3                   	ret    

00100948 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100948:	55                   	push   %ebp
  100949:	89 e5                	mov    %esp,%ebp
  10094b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10094e:	c7 04 24 42 64 10 00 	movl   $0x106442,(%esp)
  100955:	e8 48 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10095a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100961:	00 
  100962:	c7 04 24 5b 64 10 00 	movl   $0x10645b,(%esp)
  100969:	e8 34 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10096e:	c7 44 24 04 26 63 10 	movl   $0x106326,0x4(%esp)
  100975:	00 
  100976:	c7 04 24 73 64 10 00 	movl   $0x106473,(%esp)
  10097d:	e8 20 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100982:	c7 44 24 04 36 8a 11 	movl   $0x118a36,0x4(%esp)
  100989:	00 
  10098a:	c7 04 24 8b 64 10 00 	movl   $0x10648b,(%esp)
  100991:	e8 0c f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100996:	c7 44 24 04 88 bf 11 	movl   $0x11bf88,0x4(%esp)
  10099d:	00 
  10099e:	c7 04 24 a3 64 10 00 	movl   $0x1064a3,(%esp)
  1009a5:	e8 f8 f8 ff ff       	call   1002a2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009aa:	b8 88 bf 11 00       	mov    $0x11bf88,%eax
  1009af:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b5:	b8 36 00 10 00       	mov    $0x100036,%eax
  1009ba:	29 c2                	sub    %eax,%edx
  1009bc:	89 d0                	mov    %edx,%eax
  1009be:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	0f 48 c2             	cmovs  %edx,%eax
  1009c9:	c1 f8 0a             	sar    $0xa,%eax
  1009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d0:	c7 04 24 bc 64 10 00 	movl   $0x1064bc,(%esp)
  1009d7:	e8 c6 f8 ff ff       	call   1002a2 <cprintf>
}
  1009dc:	90                   	nop
  1009dd:	c9                   	leave  
  1009de:	c3                   	ret    

001009df <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009df:	55                   	push   %ebp
  1009e0:	89 e5                	mov    %esp,%ebp
  1009e2:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009e8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1009f2:	89 04 24             	mov    %eax,(%esp)
  1009f5:	e8 1c fc ff ff       	call   100616 <debuginfo_eip>
  1009fa:	85 c0                	test   %eax,%eax
  1009fc:	74 15                	je     100a13 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a05:	c7 04 24 e6 64 10 00 	movl   $0x1064e6,(%esp)
  100a0c:	e8 91 f8 ff ff       	call   1002a2 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a11:	eb 6c                	jmp    100a7f <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a1a:	eb 1b                	jmp    100a37 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100a1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a22:	01 d0                	add    %edx,%eax
  100a24:	0f b6 00             	movzbl (%eax),%eax
  100a27:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a30:	01 ca                	add    %ecx,%edx
  100a32:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a34:	ff 45 f4             	incl   -0xc(%ebp)
  100a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a3a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a3d:	7c dd                	jl     100a1c <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a3f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a48:	01 d0                	add    %edx,%eax
  100a4a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a50:	8b 55 08             	mov    0x8(%ebp),%edx
  100a53:	89 d1                	mov    %edx,%ecx
  100a55:	29 c1                	sub    %eax,%ecx
  100a57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a5d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a61:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a73:	c7 04 24 02 65 10 00 	movl   $0x106502,(%esp)
  100a7a:	e8 23 f8 ff ff       	call   1002a2 <cprintf>
}
  100a7f:	90                   	nop
  100a80:	c9                   	leave  
  100a81:	c3                   	ret    

00100a82 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a82:	55                   	push   %ebp
  100a83:	89 e5                	mov    %esp,%ebp
  100a85:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a88:	8b 45 04             	mov    0x4(%ebp),%eax
  100a8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a91:	c9                   	leave  
  100a92:	c3                   	ret    

00100a93 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a93:	55                   	push   %ebp
  100a94:	89 e5                	mov    %esp,%ebp
  100a96:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a99:	89 e8                	mov    %ebp,%eax
  100a9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp();
  100aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip  = read_eip();
  100aa4:	e8 d9 ff ff ff       	call   100a82 <read_eip>
  100aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
     int j ;
     for(int i = 0;ebp!=0 && i<STACKFRAME_DEPTH;i++)
  100aac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ab3:	e9 90 00 00 00       	jmp    100b48 <print_stackframe+0xb5>
     {
         cprintf("ebp:0x%08x  eip:0x%08x    ", ebp, eip);
  100ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
  100abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac6:	c7 04 24 14 65 10 00 	movl   $0x106514,(%esp)
  100acd:	e8 d0 f7 ff ff       	call   1002a2 <cprintf>
         cprintf("arg:");
  100ad2:	c7 04 24 2f 65 10 00 	movl   $0x10652f,(%esp)
  100ad9:	e8 c4 f7 ff ff       	call   1002a2 <cprintf>
         uint32_t *args = (uint32_t *)ebp + 2;
  100ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae1:	83 c0 08             	add    $0x8,%eax
  100ae4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
         for(j=0; j<=4; j++)
  100ae7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100aee:	eb 24                	jmp    100b14 <print_stackframe+0x81>
             cprintf("0x%08x    ", args[j]);
  100af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100afd:	01 d0                	add    %edx,%eax
  100aff:	8b 00                	mov    (%eax),%eax
  100b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b05:	c7 04 24 34 65 10 00 	movl   $0x106534,(%esp)
  100b0c:	e8 91 f7 ff ff       	call   1002a2 <cprintf>
         for(j=0; j<=4; j++)
  100b11:	ff 45 ec             	incl   -0x14(%ebp)
  100b14:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
  100b18:	7e d6                	jle    100af0 <print_stackframe+0x5d>
         cprintf("\n");
  100b1a:	c7 04 24 3f 65 10 00 	movl   $0x10653f,(%esp)
  100b21:	e8 7c f7 ff ff       	call   1002a2 <cprintf>
         print_debuginfo(eip-1);
  100b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b29:	48                   	dec    %eax
  100b2a:	89 04 24             	mov    %eax,(%esp)
  100b2d:	e8 ad fe ff ff       	call   1009df <print_debuginfo>
         eip = ((uint32_t *)ebp)[1];
  100b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b35:	83 c0 04             	add    $0x4,%eax
  100b38:	8b 00                	mov    (%eax),%eax
  100b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
         ebp = ((uint32_t *)ebp)[0];
  100b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b40:	8b 00                	mov    (%eax),%eax
  100b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for(int i = 0;ebp!=0 && i<STACKFRAME_DEPTH;i++)
  100b45:	ff 45 e8             	incl   -0x18(%ebp)
  100b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b4c:	74 0a                	je     100b58 <print_stackframe+0xc5>
  100b4e:	83 7d e8 13          	cmpl   $0x13,-0x18(%ebp)
  100b52:	0f 8e 60 ff ff ff    	jle    100ab8 <print_stackframe+0x25>
     }
}
  100b58:	90                   	nop
  100b59:	c9                   	leave  
  100b5a:	c3                   	ret    

00100b5b <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b5b:	55                   	push   %ebp
  100b5c:	89 e5                	mov    %esp,%ebp
  100b5e:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b68:	eb 0c                	jmp    100b76 <parse+0x1b>
            *buf ++ = '\0';
  100b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6d:	8d 50 01             	lea    0x1(%eax),%edx
  100b70:	89 55 08             	mov    %edx,0x8(%ebp)
  100b73:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b76:	8b 45 08             	mov    0x8(%ebp),%eax
  100b79:	0f b6 00             	movzbl (%eax),%eax
  100b7c:	84 c0                	test   %al,%al
  100b7e:	74 1d                	je     100b9d <parse+0x42>
  100b80:	8b 45 08             	mov    0x8(%ebp),%eax
  100b83:	0f b6 00             	movzbl (%eax),%eax
  100b86:	0f be c0             	movsbl %al,%eax
  100b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b8d:	c7 04 24 c4 65 10 00 	movl   $0x1065c4,(%esp)
  100b94:	e8 dd 4d 00 00       	call   105976 <strchr>
  100b99:	85 c0                	test   %eax,%eax
  100b9b:	75 cd                	jne    100b6a <parse+0xf>
        }
        if (*buf == '\0') {
  100b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba0:	0f b6 00             	movzbl (%eax),%eax
  100ba3:	84 c0                	test   %al,%al
  100ba5:	74 65                	je     100c0c <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ba7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bab:	75 14                	jne    100bc1 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bad:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bb4:	00 
  100bb5:	c7 04 24 c9 65 10 00 	movl   $0x1065c9,(%esp)
  100bbc:	e8 e1 f6 ff ff       	call   1002a2 <cprintf>
        }
        argv[argc ++] = buf;
  100bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc4:	8d 50 01             	lea    0x1(%eax),%edx
  100bc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bd4:	01 c2                	add    %eax,%edx
  100bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bdb:	eb 03                	jmp    100be0 <parse+0x85>
            buf ++;
  100bdd:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100be0:	8b 45 08             	mov    0x8(%ebp),%eax
  100be3:	0f b6 00             	movzbl (%eax),%eax
  100be6:	84 c0                	test   %al,%al
  100be8:	74 8c                	je     100b76 <parse+0x1b>
  100bea:	8b 45 08             	mov    0x8(%ebp),%eax
  100bed:	0f b6 00             	movzbl (%eax),%eax
  100bf0:	0f be c0             	movsbl %al,%eax
  100bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bf7:	c7 04 24 c4 65 10 00 	movl   $0x1065c4,(%esp)
  100bfe:	e8 73 4d 00 00       	call   105976 <strchr>
  100c03:	85 c0                	test   %eax,%eax
  100c05:	74 d6                	je     100bdd <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c07:	e9 6a ff ff ff       	jmp    100b76 <parse+0x1b>
            break;
  100c0c:	90                   	nop
        }
    }
    return argc;
  100c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c10:	c9                   	leave  
  100c11:	c3                   	ret    

00100c12 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c12:	55                   	push   %ebp
  100c13:	89 e5                	mov    %esp,%ebp
  100c15:	53                   	push   %ebx
  100c16:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c19:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c20:	8b 45 08             	mov    0x8(%ebp),%eax
  100c23:	89 04 24             	mov    %eax,(%esp)
  100c26:	e8 30 ff ff ff       	call   100b5b <parse>
  100c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c32:	75 0a                	jne    100c3e <runcmd+0x2c>
        return 0;
  100c34:	b8 00 00 00 00       	mov    $0x0,%eax
  100c39:	e9 83 00 00 00       	jmp    100cc1 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c45:	eb 5a                	jmp    100ca1 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c47:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4d:	89 d0                	mov    %edx,%eax
  100c4f:	01 c0                	add    %eax,%eax
  100c51:	01 d0                	add    %edx,%eax
  100c53:	c1 e0 02             	shl    $0x2,%eax
  100c56:	05 00 80 11 00       	add    $0x118000,%eax
  100c5b:	8b 00                	mov    (%eax),%eax
  100c5d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c61:	89 04 24             	mov    %eax,(%esp)
  100c64:	e8 70 4c 00 00       	call   1058d9 <strcmp>
  100c69:	85 c0                	test   %eax,%eax
  100c6b:	75 31                	jne    100c9e <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c70:	89 d0                	mov    %edx,%eax
  100c72:	01 c0                	add    %eax,%eax
  100c74:	01 d0                	add    %edx,%eax
  100c76:	c1 e0 02             	shl    $0x2,%eax
  100c79:	05 08 80 11 00       	add    $0x118008,%eax
  100c7e:	8b 10                	mov    (%eax),%edx
  100c80:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c83:	83 c0 04             	add    $0x4,%eax
  100c86:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c89:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c97:	89 1c 24             	mov    %ebx,(%esp)
  100c9a:	ff d2                	call   *%edx
  100c9c:	eb 23                	jmp    100cc1 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9e:	ff 45 f4             	incl   -0xc(%ebp)
  100ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca4:	83 f8 02             	cmp    $0x2,%eax
  100ca7:	76 9e                	jbe    100c47 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ca9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb0:	c7 04 24 e7 65 10 00 	movl   $0x1065e7,(%esp)
  100cb7:	e8 e6 f5 ff ff       	call   1002a2 <cprintf>
    return 0;
  100cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc1:	83 c4 64             	add    $0x64,%esp
  100cc4:	5b                   	pop    %ebx
  100cc5:	5d                   	pop    %ebp
  100cc6:	c3                   	ret    

00100cc7 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cc7:	55                   	push   %ebp
  100cc8:	89 e5                	mov    %esp,%ebp
  100cca:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ccd:	c7 04 24 00 66 10 00 	movl   $0x106600,(%esp)
  100cd4:	e8 c9 f5 ff ff       	call   1002a2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cd9:	c7 04 24 28 66 10 00 	movl   $0x106628,(%esp)
  100ce0:	e8 bd f5 ff ff       	call   1002a2 <cprintf>

    if (tf != NULL) {
  100ce5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ce9:	74 0b                	je     100cf6 <kmonitor+0x2f>
        print_trapframe(tf);
  100ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cee:	89 04 24             	mov    %eax,(%esp)
  100cf1:	e8 b2 0d 00 00       	call   101aa8 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cf6:	c7 04 24 4d 66 10 00 	movl   $0x10664d,(%esp)
  100cfd:	e8 42 f6 ff ff       	call   100344 <readline>
  100d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d09:	74 eb                	je     100cf6 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d15:	89 04 24             	mov    %eax,(%esp)
  100d18:	e8 f5 fe ff ff       	call   100c12 <runcmd>
  100d1d:	85 c0                	test   %eax,%eax
  100d1f:	78 02                	js     100d23 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100d21:	eb d3                	jmp    100cf6 <kmonitor+0x2f>
                break;
  100d23:	90                   	nop
            }
        }
    }
}
  100d24:	90                   	nop
  100d25:	c9                   	leave  
  100d26:	c3                   	ret    

00100d27 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d27:	55                   	push   %ebp
  100d28:	89 e5                	mov    %esp,%ebp
  100d2a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d34:	eb 3d                	jmp    100d73 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d39:	89 d0                	mov    %edx,%eax
  100d3b:	01 c0                	add    %eax,%eax
  100d3d:	01 d0                	add    %edx,%eax
  100d3f:	c1 e0 02             	shl    $0x2,%eax
  100d42:	05 04 80 11 00       	add    $0x118004,%eax
  100d47:	8b 08                	mov    (%eax),%ecx
  100d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d4c:	89 d0                	mov    %edx,%eax
  100d4e:	01 c0                	add    %eax,%eax
  100d50:	01 d0                	add    %edx,%eax
  100d52:	c1 e0 02             	shl    $0x2,%eax
  100d55:	05 00 80 11 00       	add    $0x118000,%eax
  100d5a:	8b 00                	mov    (%eax),%eax
  100d5c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d64:	c7 04 24 51 66 10 00 	movl   $0x106651,(%esp)
  100d6b:	e8 32 f5 ff ff       	call   1002a2 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d70:	ff 45 f4             	incl   -0xc(%ebp)
  100d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d76:	83 f8 02             	cmp    $0x2,%eax
  100d79:	76 bb                	jbe    100d36 <mon_help+0xf>
    }
    return 0;
  100d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d80:	c9                   	leave  
  100d81:	c3                   	ret    

00100d82 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d88:	e8 bb fb ff ff       	call   100948 <print_kerninfo>
    return 0;
  100d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d92:	c9                   	leave  
  100d93:	c3                   	ret    

00100d94 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d94:	55                   	push   %ebp
  100d95:	89 e5                	mov    %esp,%ebp
  100d97:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d9a:	e8 f4 fc ff ff       	call   100a93 <print_stackframe>
    return 0;
  100d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100da4:	c9                   	leave  
  100da5:	c3                   	ret    

00100da6 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100da6:	55                   	push   %ebp
  100da7:	89 e5                	mov    %esp,%ebp
  100da9:	83 ec 28             	sub    $0x28,%esp
  100dac:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100db2:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100db6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dba:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dbe:	ee                   	out    %al,(%dx)
  100dbf:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dc5:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dc9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dcd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dd1:	ee                   	out    %al,(%dx)
  100dd2:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dd8:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100ddc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100de0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100de4:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100de5:	c7 05 0c bf 11 00 00 	movl   $0x0,0x11bf0c
  100dec:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100def:	c7 04 24 5a 66 10 00 	movl   $0x10665a,(%esp)
  100df6:	e8 a7 f4 ff ff       	call   1002a2 <cprintf>
    pic_enable(IRQ_TIMER);
  100dfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e02:	e8 2e 09 00 00       	call   101735 <pic_enable>
}
  100e07:	90                   	nop
  100e08:	c9                   	leave  
  100e09:	c3                   	ret    

00100e0a <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e0a:	55                   	push   %ebp
  100e0b:	89 e5                	mov    %esp,%ebp
  100e0d:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e10:	9c                   	pushf  
  100e11:	58                   	pop    %eax
  100e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e18:	25 00 02 00 00       	and    $0x200,%eax
  100e1d:	85 c0                	test   %eax,%eax
  100e1f:	74 0c                	je     100e2d <__intr_save+0x23>
        intr_disable();
  100e21:	e8 83 0a 00 00       	call   1018a9 <intr_disable>
        return 1;
  100e26:	b8 01 00 00 00       	mov    $0x1,%eax
  100e2b:	eb 05                	jmp    100e32 <__intr_save+0x28>
    }
    return 0;
  100e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e32:	c9                   	leave  
  100e33:	c3                   	ret    

00100e34 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e34:	55                   	push   %ebp
  100e35:	89 e5                	mov    %esp,%ebp
  100e37:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e3e:	74 05                	je     100e45 <__intr_restore+0x11>
        intr_enable();
  100e40:	e8 5d 0a 00 00       	call   1018a2 <intr_enable>
    }
}
  100e45:	90                   	nop
  100e46:	c9                   	leave  
  100e47:	c3                   	ret    

00100e48 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e48:	55                   	push   %ebp
  100e49:	89 e5                	mov    %esp,%ebp
  100e4b:	83 ec 10             	sub    $0x10,%esp
  100e4e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e54:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e58:	89 c2                	mov    %eax,%edx
  100e5a:	ec                   	in     (%dx),%al
  100e5b:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e5e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e64:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e68:	89 c2                	mov    %eax,%edx
  100e6a:	ec                   	in     (%dx),%al
  100e6b:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e6e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e74:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e78:	89 c2                	mov    %eax,%edx
  100e7a:	ec                   	in     (%dx),%al
  100e7b:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e7e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e84:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e88:	89 c2                	mov    %eax,%edx
  100e8a:	ec                   	in     (%dx),%al
  100e8b:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e8e:	90                   	nop
  100e8f:	c9                   	leave  
  100e90:	c3                   	ret    

00100e91 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e91:	55                   	push   %ebp
  100e92:	89 e5                	mov    %esp,%ebp
  100e94:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e97:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea1:	0f b7 00             	movzwl (%eax),%eax
  100ea4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eab:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb3:	0f b7 00             	movzwl (%eax),%eax
  100eb6:	0f b7 c0             	movzwl %ax,%eax
  100eb9:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ebe:	74 12                	je     100ed2 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ec0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ec7:	66 c7 05 46 b4 11 00 	movw   $0x3b4,0x11b446
  100ece:	b4 03 
  100ed0:	eb 13                	jmp    100ee5 <cga_init+0x54>
    } else {
        *cp = was;
  100ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ed9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100edc:	66 c7 05 46 b4 11 00 	movw   $0x3d4,0x11b446
  100ee3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ee5:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100eec:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ef0:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ef4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ef8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100efc:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100efd:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f04:	40                   	inc    %eax
  100f05:	0f b7 c0             	movzwl %ax,%eax
  100f08:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f0c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f10:	89 c2                	mov    %eax,%edx
  100f12:	ec                   	in     (%dx),%al
  100f13:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1a:	0f b6 c0             	movzbl %al,%eax
  100f1d:	c1 e0 08             	shl    $0x8,%eax
  100f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f23:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f2a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f2e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f32:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f36:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f3a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f3b:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f42:	40                   	inc    %eax
  100f43:	0f b7 c0             	movzwl %ax,%eax
  100f46:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f4a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f4e:	89 c2                	mov    %eax,%edx
  100f50:	ec                   	in     (%dx),%al
  100f51:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f54:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f58:	0f b6 c0             	movzbl %al,%eax
  100f5b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f61:	a3 40 b4 11 00       	mov    %eax,0x11b440
    crt_pos = pos;
  100f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f69:	0f b7 c0             	movzwl %ax,%eax
  100f6c:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
}
  100f72:	90                   	nop
  100f73:	c9                   	leave  
  100f74:	c3                   	ret    

00100f75 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f75:	55                   	push   %ebp
  100f76:	89 e5                	mov    %esp,%ebp
  100f78:	83 ec 48             	sub    $0x48,%esp
  100f7b:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f81:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f85:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f89:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f8d:	ee                   	out    %al,(%dx)
  100f8e:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f94:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f98:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f9c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fa0:	ee                   	out    %al,(%dx)
  100fa1:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fa7:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100fab:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100faf:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fb3:	ee                   	out    %al,(%dx)
  100fb4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fba:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100fbe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fc2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fc6:	ee                   	out    %al,(%dx)
  100fc7:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fcd:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100fd1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fd5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd9:	ee                   	out    %al,(%dx)
  100fda:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fe0:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100fe4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fe8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fec:	ee                   	out    %al,(%dx)
  100fed:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100ff3:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100ff7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ffb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fff:	ee                   	out    %al,(%dx)
  101000:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101006:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10100a:	89 c2                	mov    %eax,%edx
  10100c:	ec                   	in     (%dx),%al
  10100d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101010:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101014:	3c ff                	cmp    $0xff,%al
  101016:	0f 95 c0             	setne  %al
  101019:	0f b6 c0             	movzbl %al,%eax
  10101c:	a3 48 b4 11 00       	mov    %eax,0x11b448
  101021:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101027:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10102b:	89 c2                	mov    %eax,%edx
  10102d:	ec                   	in     (%dx),%al
  10102e:	88 45 f1             	mov    %al,-0xf(%ebp)
  101031:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101037:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10103b:	89 c2                	mov    %eax,%edx
  10103d:	ec                   	in     (%dx),%al
  10103e:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101041:	a1 48 b4 11 00       	mov    0x11b448,%eax
  101046:	85 c0                	test   %eax,%eax
  101048:	74 0c                	je     101056 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10104a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101051:	e8 df 06 00 00       	call   101735 <pic_enable>
    }
}
  101056:	90                   	nop
  101057:	c9                   	leave  
  101058:	c3                   	ret    

00101059 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101059:	55                   	push   %ebp
  10105a:	89 e5                	mov    %esp,%ebp
  10105c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10105f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101066:	eb 08                	jmp    101070 <lpt_putc_sub+0x17>
        delay();
  101068:	e8 db fd ff ff       	call   100e48 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10106d:	ff 45 fc             	incl   -0x4(%ebp)
  101070:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101076:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10107a:	89 c2                	mov    %eax,%edx
  10107c:	ec                   	in     (%dx),%al
  10107d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101080:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101084:	84 c0                	test   %al,%al
  101086:	78 09                	js     101091 <lpt_putc_sub+0x38>
  101088:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10108f:	7e d7                	jle    101068 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101091:	8b 45 08             	mov    0x8(%ebp),%eax
  101094:	0f b6 c0             	movzbl %al,%eax
  101097:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10109d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a8:	ee                   	out    %al,(%dx)
  1010a9:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010af:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010b3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010b7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010bb:	ee                   	out    %al,(%dx)
  1010bc:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010c2:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  1010c6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010ca:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010ce:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010cf:	90                   	nop
  1010d0:	c9                   	leave  
  1010d1:	c3                   	ret    

001010d2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010d2:	55                   	push   %ebp
  1010d3:	89 e5                	mov    %esp,%ebp
  1010d5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010d8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010dc:	74 0d                	je     1010eb <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010de:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e1:	89 04 24             	mov    %eax,(%esp)
  1010e4:	e8 70 ff ff ff       	call   101059 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010e9:	eb 24                	jmp    10110f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010f2:	e8 62 ff ff ff       	call   101059 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010f7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010fe:	e8 56 ff ff ff       	call   101059 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101103:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10110a:	e8 4a ff ff ff       	call   101059 <lpt_putc_sub>
}
  10110f:	90                   	nop
  101110:	c9                   	leave  
  101111:	c3                   	ret    

00101112 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101112:	55                   	push   %ebp
  101113:	89 e5                	mov    %esp,%ebp
  101115:	53                   	push   %ebx
  101116:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101119:	8b 45 08             	mov    0x8(%ebp),%eax
  10111c:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101121:	85 c0                	test   %eax,%eax
  101123:	75 07                	jne    10112c <cga_putc+0x1a>
        c |= 0x0700;
  101125:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10112c:	8b 45 08             	mov    0x8(%ebp),%eax
  10112f:	0f b6 c0             	movzbl %al,%eax
  101132:	83 f8 0a             	cmp    $0xa,%eax
  101135:	74 55                	je     10118c <cga_putc+0x7a>
  101137:	83 f8 0d             	cmp    $0xd,%eax
  10113a:	74 63                	je     10119f <cga_putc+0x8d>
  10113c:	83 f8 08             	cmp    $0x8,%eax
  10113f:	0f 85 94 00 00 00    	jne    1011d9 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  101145:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10114c:	85 c0                	test   %eax,%eax
  10114e:	0f 84 af 00 00 00    	je     101203 <cga_putc+0xf1>
            crt_pos --;
  101154:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10115b:	48                   	dec    %eax
  10115c:	0f b7 c0             	movzwl %ax,%eax
  10115f:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101165:	8b 45 08             	mov    0x8(%ebp),%eax
  101168:	98                   	cwtl   
  101169:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10116e:	98                   	cwtl   
  10116f:	83 c8 20             	or     $0x20,%eax
  101172:	98                   	cwtl   
  101173:	8b 15 40 b4 11 00    	mov    0x11b440,%edx
  101179:	0f b7 0d 44 b4 11 00 	movzwl 0x11b444,%ecx
  101180:	01 c9                	add    %ecx,%ecx
  101182:	01 ca                	add    %ecx,%edx
  101184:	0f b7 c0             	movzwl %ax,%eax
  101187:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10118a:	eb 77                	jmp    101203 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  10118c:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101193:	83 c0 50             	add    $0x50,%eax
  101196:	0f b7 c0             	movzwl %ax,%eax
  101199:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10119f:	0f b7 1d 44 b4 11 00 	movzwl 0x11b444,%ebx
  1011a6:	0f b7 0d 44 b4 11 00 	movzwl 0x11b444,%ecx
  1011ad:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011b2:	89 c8                	mov    %ecx,%eax
  1011b4:	f7 e2                	mul    %edx
  1011b6:	c1 ea 06             	shr    $0x6,%edx
  1011b9:	89 d0                	mov    %edx,%eax
  1011bb:	c1 e0 02             	shl    $0x2,%eax
  1011be:	01 d0                	add    %edx,%eax
  1011c0:	c1 e0 04             	shl    $0x4,%eax
  1011c3:	29 c1                	sub    %eax,%ecx
  1011c5:	89 c8                	mov    %ecx,%eax
  1011c7:	0f b7 c0             	movzwl %ax,%eax
  1011ca:	29 c3                	sub    %eax,%ebx
  1011cc:	89 d8                	mov    %ebx,%eax
  1011ce:	0f b7 c0             	movzwl %ax,%eax
  1011d1:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
        break;
  1011d7:	eb 2b                	jmp    101204 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011d9:	8b 0d 40 b4 11 00    	mov    0x11b440,%ecx
  1011df:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1011e6:	8d 50 01             	lea    0x1(%eax),%edx
  1011e9:	0f b7 d2             	movzwl %dx,%edx
  1011ec:	66 89 15 44 b4 11 00 	mov    %dx,0x11b444
  1011f3:	01 c0                	add    %eax,%eax
  1011f5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1011fb:	0f b7 c0             	movzwl %ax,%eax
  1011fe:	66 89 02             	mov    %ax,(%edx)
        break;
  101201:	eb 01                	jmp    101204 <cga_putc+0xf2>
        break;
  101203:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101204:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10120b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101210:	76 5d                	jbe    10126f <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101212:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101217:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10121d:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101222:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101229:	00 
  10122a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10122e:	89 04 24             	mov    %eax,(%esp)
  101231:	e8 36 49 00 00       	call   105b6c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101236:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10123d:	eb 14                	jmp    101253 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  10123f:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101244:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101247:	01 d2                	add    %edx,%edx
  101249:	01 d0                	add    %edx,%eax
  10124b:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101250:	ff 45 f4             	incl   -0xc(%ebp)
  101253:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10125a:	7e e3                	jle    10123f <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  10125c:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101263:	83 e8 50             	sub    $0x50,%eax
  101266:	0f b7 c0             	movzwl %ax,%eax
  101269:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10126f:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  101276:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10127a:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  10127e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101282:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101286:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101287:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10128e:	c1 e8 08             	shr    $0x8,%eax
  101291:	0f b7 c0             	movzwl %ax,%eax
  101294:	0f b6 c0             	movzbl %al,%eax
  101297:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  10129e:	42                   	inc    %edx
  10129f:	0f b7 d2             	movzwl %dx,%edx
  1012a2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012a6:	88 45 e9             	mov    %al,-0x17(%ebp)
  1012a9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ad:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012b1:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012b2:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  1012b9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012bd:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1012c1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012c5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012c9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012ca:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1012d1:	0f b6 c0             	movzbl %al,%eax
  1012d4:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  1012db:	42                   	inc    %edx
  1012dc:	0f b7 d2             	movzwl %dx,%edx
  1012df:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012e3:	88 45 f1             	mov    %al,-0xf(%ebp)
  1012e6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012ea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012ee:	ee                   	out    %al,(%dx)
}
  1012ef:	90                   	nop
  1012f0:	83 c4 34             	add    $0x34,%esp
  1012f3:	5b                   	pop    %ebx
  1012f4:	5d                   	pop    %ebp
  1012f5:	c3                   	ret    

001012f6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012f6:	55                   	push   %ebp
  1012f7:	89 e5                	mov    %esp,%ebp
  1012f9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101303:	eb 08                	jmp    10130d <serial_putc_sub+0x17>
        delay();
  101305:	e8 3e fb ff ff       	call   100e48 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10130a:	ff 45 fc             	incl   -0x4(%ebp)
  10130d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101313:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101317:	89 c2                	mov    %eax,%edx
  101319:	ec                   	in     (%dx),%al
  10131a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10131d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101321:	0f b6 c0             	movzbl %al,%eax
  101324:	83 e0 20             	and    $0x20,%eax
  101327:	85 c0                	test   %eax,%eax
  101329:	75 09                	jne    101334 <serial_putc_sub+0x3e>
  10132b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101332:	7e d1                	jle    101305 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101334:	8b 45 08             	mov    0x8(%ebp),%eax
  101337:	0f b6 c0             	movzbl %al,%eax
  10133a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101340:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101343:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101347:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10134b:	ee                   	out    %al,(%dx)
}
  10134c:	90                   	nop
  10134d:	c9                   	leave  
  10134e:	c3                   	ret    

0010134f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10134f:	55                   	push   %ebp
  101350:	89 e5                	mov    %esp,%ebp
  101352:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101355:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101359:	74 0d                	je     101368 <serial_putc+0x19>
        serial_putc_sub(c);
  10135b:	8b 45 08             	mov    0x8(%ebp),%eax
  10135e:	89 04 24             	mov    %eax,(%esp)
  101361:	e8 90 ff ff ff       	call   1012f6 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101366:	eb 24                	jmp    10138c <serial_putc+0x3d>
        serial_putc_sub('\b');
  101368:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10136f:	e8 82 ff ff ff       	call   1012f6 <serial_putc_sub>
        serial_putc_sub(' ');
  101374:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10137b:	e8 76 ff ff ff       	call   1012f6 <serial_putc_sub>
        serial_putc_sub('\b');
  101380:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101387:	e8 6a ff ff ff       	call   1012f6 <serial_putc_sub>
}
  10138c:	90                   	nop
  10138d:	c9                   	leave  
  10138e:	c3                   	ret    

0010138f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10138f:	55                   	push   %ebp
  101390:	89 e5                	mov    %esp,%ebp
  101392:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101395:	eb 33                	jmp    1013ca <cons_intr+0x3b>
        if (c != 0) {
  101397:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10139b:	74 2d                	je     1013ca <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10139d:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1013a2:	8d 50 01             	lea    0x1(%eax),%edx
  1013a5:	89 15 64 b6 11 00    	mov    %edx,0x11b664
  1013ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013ae:	88 90 60 b4 11 00    	mov    %dl,0x11b460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013b4:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1013b9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013be:	75 0a                	jne    1013ca <cons_intr+0x3b>
                cons.wpos = 0;
  1013c0:	c7 05 64 b6 11 00 00 	movl   $0x0,0x11b664
  1013c7:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1013cd:	ff d0                	call   *%eax
  1013cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013d2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013d6:	75 bf                	jne    101397 <cons_intr+0x8>
            }
        }
    }
}
  1013d8:	90                   	nop
  1013d9:	c9                   	leave  
  1013da:	c3                   	ret    

001013db <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013db:	55                   	push   %ebp
  1013dc:	89 e5                	mov    %esp,%ebp
  1013de:	83 ec 10             	sub    $0x10,%esp
  1013e1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013e7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013eb:	89 c2                	mov    %eax,%edx
  1013ed:	ec                   	in     (%dx),%al
  1013ee:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013f1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013f5:	0f b6 c0             	movzbl %al,%eax
  1013f8:	83 e0 01             	and    $0x1,%eax
  1013fb:	85 c0                	test   %eax,%eax
  1013fd:	75 07                	jne    101406 <serial_proc_data+0x2b>
        return -1;
  1013ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101404:	eb 2a                	jmp    101430 <serial_proc_data+0x55>
  101406:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10140c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101410:	89 c2                	mov    %eax,%edx
  101412:	ec                   	in     (%dx),%al
  101413:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101416:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10141a:	0f b6 c0             	movzbl %al,%eax
  10141d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101420:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101424:	75 07                	jne    10142d <serial_proc_data+0x52>
        c = '\b';
  101426:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10142d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101430:	c9                   	leave  
  101431:	c3                   	ret    

00101432 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101432:	55                   	push   %ebp
  101433:	89 e5                	mov    %esp,%ebp
  101435:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101438:	a1 48 b4 11 00       	mov    0x11b448,%eax
  10143d:	85 c0                	test   %eax,%eax
  10143f:	74 0c                	je     10144d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101441:	c7 04 24 db 13 10 00 	movl   $0x1013db,(%esp)
  101448:	e8 42 ff ff ff       	call   10138f <cons_intr>
    }
}
  10144d:	90                   	nop
  10144e:	c9                   	leave  
  10144f:	c3                   	ret    

00101450 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101450:	55                   	push   %ebp
  101451:	89 e5                	mov    %esp,%ebp
  101453:	83 ec 38             	sub    $0x38,%esp
  101456:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10145c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10145f:	89 c2                	mov    %eax,%edx
  101461:	ec                   	in     (%dx),%al
  101462:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101465:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101469:	0f b6 c0             	movzbl %al,%eax
  10146c:	83 e0 01             	and    $0x1,%eax
  10146f:	85 c0                	test   %eax,%eax
  101471:	75 0a                	jne    10147d <kbd_proc_data+0x2d>
        return -1;
  101473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101478:	e9 55 01 00 00       	jmp    1015d2 <kbd_proc_data+0x182>
  10147d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101486:	89 c2                	mov    %eax,%edx
  101488:	ec                   	in     (%dx),%al
  101489:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10148c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101490:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101493:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101497:	75 17                	jne    1014b0 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101499:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10149e:	83 c8 40             	or     $0x40,%eax
  1014a1:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  1014a6:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ab:	e9 22 01 00 00       	jmp    1015d2 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  1014b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b4:	84 c0                	test   %al,%al
  1014b6:	79 45                	jns    1014fd <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014b8:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014bd:	83 e0 40             	and    $0x40,%eax
  1014c0:	85 c0                	test   %eax,%eax
  1014c2:	75 08                	jne    1014cc <kbd_proc_data+0x7c>
  1014c4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c8:	24 7f                	and    $0x7f,%al
  1014ca:	eb 04                	jmp    1014d0 <kbd_proc_data+0x80>
  1014cc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014d3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d7:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  1014de:	0c 40                	or     $0x40,%al
  1014e0:	0f b6 c0             	movzbl %al,%eax
  1014e3:	f7 d0                	not    %eax
  1014e5:	89 c2                	mov    %eax,%edx
  1014e7:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014ec:	21 d0                	and    %edx,%eax
  1014ee:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  1014f3:	b8 00 00 00 00       	mov    $0x0,%eax
  1014f8:	e9 d5 00 00 00       	jmp    1015d2 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  1014fd:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101502:	83 e0 40             	and    $0x40,%eax
  101505:	85 c0                	test   %eax,%eax
  101507:	74 11                	je     10151a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101509:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10150d:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101512:	83 e0 bf             	and    $0xffffffbf,%eax
  101515:	a3 68 b6 11 00       	mov    %eax,0x11b668
    }

    shift |= shiftcode[data];
  10151a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151e:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  101525:	0f b6 d0             	movzbl %al,%edx
  101528:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10152d:	09 d0                	or     %edx,%eax
  10152f:	a3 68 b6 11 00       	mov    %eax,0x11b668
    shift ^= togglecode[data];
  101534:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101538:	0f b6 80 40 81 11 00 	movzbl 0x118140(%eax),%eax
  10153f:	0f b6 d0             	movzbl %al,%edx
  101542:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101547:	31 d0                	xor    %edx,%eax
  101549:	a3 68 b6 11 00       	mov    %eax,0x11b668

    c = charcode[shift & (CTL | SHIFT)][data];
  10154e:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101553:	83 e0 03             	and    $0x3,%eax
  101556:	8b 14 85 40 85 11 00 	mov    0x118540(,%eax,4),%edx
  10155d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101561:	01 d0                	add    %edx,%eax
  101563:	0f b6 00             	movzbl (%eax),%eax
  101566:	0f b6 c0             	movzbl %al,%eax
  101569:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10156c:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101571:	83 e0 08             	and    $0x8,%eax
  101574:	85 c0                	test   %eax,%eax
  101576:	74 22                	je     10159a <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101578:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10157c:	7e 0c                	jle    10158a <kbd_proc_data+0x13a>
  10157e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101582:	7f 06                	jg     10158a <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  101584:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101588:	eb 10                	jmp    10159a <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  10158a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10158e:	7e 0a                	jle    10159a <kbd_proc_data+0x14a>
  101590:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101594:	7f 04                	jg     10159a <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101596:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10159a:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10159f:	f7 d0                	not    %eax
  1015a1:	83 e0 06             	and    $0x6,%eax
  1015a4:	85 c0                	test   %eax,%eax
  1015a6:	75 27                	jne    1015cf <kbd_proc_data+0x17f>
  1015a8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015af:	75 1e                	jne    1015cf <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  1015b1:	c7 04 24 75 66 10 00 	movl   $0x106675,(%esp)
  1015b8:	e8 e5 ec ff ff       	call   1002a2 <cprintf>
  1015bd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015c3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015ce:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015d2:	c9                   	leave  
  1015d3:	c3                   	ret    

001015d4 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015d4:	55                   	push   %ebp
  1015d5:	89 e5                	mov    %esp,%ebp
  1015d7:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015da:	c7 04 24 50 14 10 00 	movl   $0x101450,(%esp)
  1015e1:	e8 a9 fd ff ff       	call   10138f <cons_intr>
}
  1015e6:	90                   	nop
  1015e7:	c9                   	leave  
  1015e8:	c3                   	ret    

001015e9 <kbd_init>:

static void
kbd_init(void) {
  1015e9:	55                   	push   %ebp
  1015ea:	89 e5                	mov    %esp,%ebp
  1015ec:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015ef:	e8 e0 ff ff ff       	call   1015d4 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015fb:	e8 35 01 00 00       	call   101735 <pic_enable>
}
  101600:	90                   	nop
  101601:	c9                   	leave  
  101602:	c3                   	ret    

00101603 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101603:	55                   	push   %ebp
  101604:	89 e5                	mov    %esp,%ebp
  101606:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101609:	e8 83 f8 ff ff       	call   100e91 <cga_init>
    serial_init();
  10160e:	e8 62 f9 ff ff       	call   100f75 <serial_init>
    kbd_init();
  101613:	e8 d1 ff ff ff       	call   1015e9 <kbd_init>
    if (!serial_exists) {
  101618:	a1 48 b4 11 00       	mov    0x11b448,%eax
  10161d:	85 c0                	test   %eax,%eax
  10161f:	75 0c                	jne    10162d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101621:	c7 04 24 81 66 10 00 	movl   $0x106681,(%esp)
  101628:	e8 75 ec ff ff       	call   1002a2 <cprintf>
    }
}
  10162d:	90                   	nop
  10162e:	c9                   	leave  
  10162f:	c3                   	ret    

00101630 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101630:	55                   	push   %ebp
  101631:	89 e5                	mov    %esp,%ebp
  101633:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101636:	e8 cf f7 ff ff       	call   100e0a <__intr_save>
  10163b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10163e:	8b 45 08             	mov    0x8(%ebp),%eax
  101641:	89 04 24             	mov    %eax,(%esp)
  101644:	e8 89 fa ff ff       	call   1010d2 <lpt_putc>
        cga_putc(c);
  101649:	8b 45 08             	mov    0x8(%ebp),%eax
  10164c:	89 04 24             	mov    %eax,(%esp)
  10164f:	e8 be fa ff ff       	call   101112 <cga_putc>
        serial_putc(c);
  101654:	8b 45 08             	mov    0x8(%ebp),%eax
  101657:	89 04 24             	mov    %eax,(%esp)
  10165a:	e8 f0 fc ff ff       	call   10134f <serial_putc>
    }
    local_intr_restore(intr_flag);
  10165f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101662:	89 04 24             	mov    %eax,(%esp)
  101665:	e8 ca f7 ff ff       	call   100e34 <__intr_restore>
}
  10166a:	90                   	nop
  10166b:	c9                   	leave  
  10166c:	c3                   	ret    

0010166d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10166d:	55                   	push   %ebp
  10166e:	89 e5                	mov    %esp,%ebp
  101670:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101673:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10167a:	e8 8b f7 ff ff       	call   100e0a <__intr_save>
  10167f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101682:	e8 ab fd ff ff       	call   101432 <serial_intr>
        kbd_intr();
  101687:	e8 48 ff ff ff       	call   1015d4 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10168c:	8b 15 60 b6 11 00    	mov    0x11b660,%edx
  101692:	a1 64 b6 11 00       	mov    0x11b664,%eax
  101697:	39 c2                	cmp    %eax,%edx
  101699:	74 31                	je     1016cc <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10169b:	a1 60 b6 11 00       	mov    0x11b660,%eax
  1016a0:	8d 50 01             	lea    0x1(%eax),%edx
  1016a3:	89 15 60 b6 11 00    	mov    %edx,0x11b660
  1016a9:	0f b6 80 60 b4 11 00 	movzbl 0x11b460(%eax),%eax
  1016b0:	0f b6 c0             	movzbl %al,%eax
  1016b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1016b6:	a1 60 b6 11 00       	mov    0x11b660,%eax
  1016bb:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016c0:	75 0a                	jne    1016cc <cons_getc+0x5f>
                cons.rpos = 0;
  1016c2:	c7 05 60 b6 11 00 00 	movl   $0x0,0x11b660
  1016c9:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016cf:	89 04 24             	mov    %eax,(%esp)
  1016d2:	e8 5d f7 ff ff       	call   100e34 <__intr_restore>
    return c;
  1016d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016da:	c9                   	leave  
  1016db:	c3                   	ret    

001016dc <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016dc:	55                   	push   %ebp
  1016dd:	89 e5                	mov    %esp,%ebp
  1016df:	83 ec 14             	sub    $0x14,%esp
  1016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016e5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016ec:	66 a3 50 85 11 00    	mov    %ax,0x118550
    if (did_init) {
  1016f2:	a1 6c b6 11 00       	mov    0x11b66c,%eax
  1016f7:	85 c0                	test   %eax,%eax
  1016f9:	74 37                	je     101732 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016fe:	0f b6 c0             	movzbl %al,%eax
  101701:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101707:	88 45 f9             	mov    %al,-0x7(%ebp)
  10170a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10170e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101712:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101713:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101717:	c1 e8 08             	shr    $0x8,%eax
  10171a:	0f b7 c0             	movzwl %ax,%eax
  10171d:	0f b6 c0             	movzbl %al,%eax
  101720:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101726:	88 45 fd             	mov    %al,-0x3(%ebp)
  101729:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10172d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101731:	ee                   	out    %al,(%dx)
    }
}
  101732:	90                   	nop
  101733:	c9                   	leave  
  101734:	c3                   	ret    

00101735 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101735:	55                   	push   %ebp
  101736:	89 e5                	mov    %esp,%ebp
  101738:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10173b:	8b 45 08             	mov    0x8(%ebp),%eax
  10173e:	ba 01 00 00 00       	mov    $0x1,%edx
  101743:	88 c1                	mov    %al,%cl
  101745:	d3 e2                	shl    %cl,%edx
  101747:	89 d0                	mov    %edx,%eax
  101749:	98                   	cwtl   
  10174a:	f7 d0                	not    %eax
  10174c:	0f bf d0             	movswl %ax,%edx
  10174f:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  101756:	98                   	cwtl   
  101757:	21 d0                	and    %edx,%eax
  101759:	98                   	cwtl   
  10175a:	0f b7 c0             	movzwl %ax,%eax
  10175d:	89 04 24             	mov    %eax,(%esp)
  101760:	e8 77 ff ff ff       	call   1016dc <pic_setmask>
}
  101765:	90                   	nop
  101766:	c9                   	leave  
  101767:	c3                   	ret    

00101768 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101768:	55                   	push   %ebp
  101769:	89 e5                	mov    %esp,%ebp
  10176b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10176e:	c7 05 6c b6 11 00 01 	movl   $0x1,0x11b66c
  101775:	00 00 00 
  101778:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  10177e:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101782:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101786:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10178a:	ee                   	out    %al,(%dx)
  10178b:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101791:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101795:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101799:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10179d:	ee                   	out    %al,(%dx)
  10179e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017a4:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1017a8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017ac:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017b0:	ee                   	out    %al,(%dx)
  1017b1:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017b7:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  1017bb:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017bf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017c3:	ee                   	out    %al,(%dx)
  1017c4:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017ca:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  1017ce:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017d2:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017d6:	ee                   	out    %al,(%dx)
  1017d7:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017dd:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1017e1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017e5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017e9:	ee                   	out    %al,(%dx)
  1017ea:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017f0:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1017f4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017f8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017fc:	ee                   	out    %al,(%dx)
  1017fd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101803:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101807:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10180b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10180f:	ee                   	out    %al,(%dx)
  101810:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101816:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  10181a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10181e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101822:	ee                   	out    %al,(%dx)
  101823:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101829:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  10182d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101831:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101835:	ee                   	out    %al,(%dx)
  101836:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10183c:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101840:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101844:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101848:	ee                   	out    %al,(%dx)
  101849:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10184f:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101853:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101857:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10185b:	ee                   	out    %al,(%dx)
  10185c:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101862:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101866:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10186a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10186e:	ee                   	out    %al,(%dx)
  10186f:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101875:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101879:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10187d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101881:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101882:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  101889:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10188e:	74 0f                	je     10189f <pic_init+0x137>
        pic_setmask(irq_mask);
  101890:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  101897:	89 04 24             	mov    %eax,(%esp)
  10189a:	e8 3d fe ff ff       	call   1016dc <pic_setmask>
    }
}
  10189f:	90                   	nop
  1018a0:	c9                   	leave  
  1018a1:	c3                   	ret    

001018a2 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018a2:	55                   	push   %ebp
  1018a3:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  1018a5:	fb                   	sti    
    sti();
}
  1018a6:	90                   	nop
  1018a7:	5d                   	pop    %ebp
  1018a8:	c3                   	ret    

001018a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1018a9:	55                   	push   %ebp
  1018aa:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  1018ac:	fa                   	cli    
    cli();
}
  1018ad:	90                   	nop
  1018ae:	5d                   	pop    %ebp
  1018af:	c3                   	ret    

001018b0 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1018b0:	55                   	push   %ebp
  1018b1:	89 e5                	mov    %esp,%ebp
  1018b3:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018b6:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018bd:	00 
  1018be:	c7 04 24 a0 66 10 00 	movl   $0x1066a0,(%esp)
  1018c5:	e8 d8 e9 ff ff       	call   1002a2 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018ca:	c7 04 24 aa 66 10 00 	movl   $0x1066aa,(%esp)
  1018d1:	e8 cc e9 ff ff       	call   1002a2 <cprintf>
    panic("EOT: kernel seems ok.");
  1018d6:	c7 44 24 08 b8 66 10 	movl   $0x1066b8,0x8(%esp)
  1018dd:	00 
  1018de:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018e5:	00 
  1018e6:	c7 04 24 ce 66 10 00 	movl   $0x1066ce,(%esp)
  1018ed:	e8 07 eb ff ff       	call   1003f9 <__panic>

001018f2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018f2:	55                   	push   %ebp
  1018f3:	89 e5                	mov    %esp,%ebp
  1018f5:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
          extern uintptr_t __vectors[];
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018ff:	e9 c4 00 00 00       	jmp    1019c8 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  10190e:	0f b7 d0             	movzwl %ax,%edx
  101911:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101914:	66 89 14 c5 80 b6 11 	mov    %dx,0x11b680(,%eax,8)
  10191b:	00 
  10191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191f:	66 c7 04 c5 82 b6 11 	movw   $0x8,0x11b682(,%eax,8)
  101926:	00 08 00 
  101929:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192c:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  101933:	00 
  101934:	80 e2 e0             	and    $0xe0,%dl
  101937:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  10193e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101941:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  101948:	00 
  101949:	80 e2 1f             	and    $0x1f,%dl
  10194c:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  101953:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101956:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  10195d:	00 
  10195e:	80 e2 f0             	and    $0xf0,%dl
  101961:	80 ca 0e             	or     $0xe,%dl
  101964:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  10196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196e:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  101975:	00 
  101976:	80 e2 ef             	and    $0xef,%dl
  101979:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  101980:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101983:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  10198a:	00 
  10198b:	80 e2 9f             	and    $0x9f,%dl
  10198e:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  101995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101998:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  10199f:	00 
  1019a0:	80 ca 80             	or     $0x80,%dl
  1019a3:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ad:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  1019b4:	c1 e8 10             	shr    $0x10,%eax
  1019b7:	0f b7 d0             	movzwl %ax,%edx
  1019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bd:	66 89 14 c5 86 b6 11 	mov    %dx,0x11b686(,%eax,8)
  1019c4:	00 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019c5:	ff 45 fc             	incl   -0x4(%ebp)
  1019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019d0:	0f 86 2e ff ff ff    	jbe    101904 <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  1019d6:	a1 c4 87 11 00       	mov    0x1187c4,%eax
  1019db:	0f b7 c0             	movzwl %ax,%eax
  1019de:	66 a3 48 ba 11 00    	mov    %ax,0x11ba48
  1019e4:	66 c7 05 4a ba 11 00 	movw   $0x8,0x11ba4a
  1019eb:	08 00 
  1019ed:	0f b6 05 4c ba 11 00 	movzbl 0x11ba4c,%eax
  1019f4:	24 e0                	and    $0xe0,%al
  1019f6:	a2 4c ba 11 00       	mov    %al,0x11ba4c
  1019fb:	0f b6 05 4c ba 11 00 	movzbl 0x11ba4c,%eax
  101a02:	24 1f                	and    $0x1f,%al
  101a04:	a2 4c ba 11 00       	mov    %al,0x11ba4c
  101a09:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a10:	0c 0f                	or     $0xf,%al
  101a12:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a17:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a1e:	24 ef                	and    $0xef,%al
  101a20:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a25:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a2c:	0c 60                	or     $0x60,%al
  101a2e:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a33:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a3a:	0c 80                	or     $0x80,%al
  101a3c:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a41:	a1 c4 87 11 00       	mov    0x1187c4,%eax
  101a46:	c1 e8 10             	shr    $0x10,%eax
  101a49:	0f b7 c0             	movzwl %ax,%eax
  101a4c:	66 a3 4e ba 11 00    	mov    %ax,0x11ba4e
  101a52:	c7 45 f8 60 85 11 00 	movl   $0x118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a5c:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
  101a5f:	90                   	nop
  101a60:	c9                   	leave  
  101a61:	c3                   	ret    

00101a62 <trapname>:

static const char *
trapname(int trapno) {
  101a62:	55                   	push   %ebp
  101a63:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a65:	8b 45 08             	mov    0x8(%ebp),%eax
  101a68:	83 f8 13             	cmp    $0x13,%eax
  101a6b:	77 0c                	ja     101a79 <trapname+0x17>
        return excnames[trapno];
  101a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a70:	8b 04 85 20 6a 10 00 	mov    0x106a20(,%eax,4),%eax
  101a77:	eb 18                	jmp    101a91 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a79:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a7d:	7e 0d                	jle    101a8c <trapname+0x2a>
  101a7f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a83:	7f 07                	jg     101a8c <trapname+0x2a>
        return "Hardware Interrupt";
  101a85:	b8 df 66 10 00       	mov    $0x1066df,%eax
  101a8a:	eb 05                	jmp    101a91 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a8c:	b8 f2 66 10 00       	mov    $0x1066f2,%eax
}
  101a91:	5d                   	pop    %ebp
  101a92:	c3                   	ret    

00101a93 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a93:	55                   	push   %ebp
  101a94:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a96:	8b 45 08             	mov    0x8(%ebp),%eax
  101a99:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a9d:	83 f8 08             	cmp    $0x8,%eax
  101aa0:	0f 94 c0             	sete   %al
  101aa3:	0f b6 c0             	movzbl %al,%eax
}
  101aa6:	5d                   	pop    %ebp
  101aa7:	c3                   	ret    

00101aa8 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101aa8:	55                   	push   %ebp
  101aa9:	89 e5                	mov    %esp,%ebp
  101aab:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101aae:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab5:	c7 04 24 33 67 10 00 	movl   $0x106733,(%esp)
  101abc:	e8 e1 e7 ff ff       	call   1002a2 <cprintf>
    print_regs(&tf->tf_regs);
  101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac4:	89 04 24             	mov    %eax,(%esp)
  101ac7:	e8 8f 01 00 00       	call   101c5b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101acc:	8b 45 08             	mov    0x8(%ebp),%eax
  101acf:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad7:	c7 04 24 44 67 10 00 	movl   $0x106744,(%esp)
  101ade:	e8 bf e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aee:	c7 04 24 57 67 10 00 	movl   $0x106757,(%esp)
  101af5:	e8 a8 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101afa:	8b 45 08             	mov    0x8(%ebp),%eax
  101afd:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b05:	c7 04 24 6a 67 10 00 	movl   $0x10676a,(%esp)
  101b0c:	e8 91 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b11:	8b 45 08             	mov    0x8(%ebp),%eax
  101b14:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1c:	c7 04 24 7d 67 10 00 	movl   $0x10677d,(%esp)
  101b23:	e8 7a e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b28:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2b:	8b 40 30             	mov    0x30(%eax),%eax
  101b2e:	89 04 24             	mov    %eax,(%esp)
  101b31:	e8 2c ff ff ff       	call   101a62 <trapname>
  101b36:	89 c2                	mov    %eax,%edx
  101b38:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3b:	8b 40 30             	mov    0x30(%eax),%eax
  101b3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b46:	c7 04 24 90 67 10 00 	movl   $0x106790,(%esp)
  101b4d:	e8 50 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b52:	8b 45 08             	mov    0x8(%ebp),%eax
  101b55:	8b 40 34             	mov    0x34(%eax),%eax
  101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5c:	c7 04 24 a2 67 10 00 	movl   $0x1067a2,(%esp)
  101b63:	e8 3a e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b68:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6b:	8b 40 38             	mov    0x38(%eax),%eax
  101b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b72:	c7 04 24 b1 67 10 00 	movl   $0x1067b1,(%esp)
  101b79:	e8 24 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b89:	c7 04 24 c0 67 10 00 	movl   $0x1067c0,(%esp)
  101b90:	e8 0d e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b95:	8b 45 08             	mov    0x8(%ebp),%eax
  101b98:	8b 40 40             	mov    0x40(%eax),%eax
  101b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9f:	c7 04 24 d3 67 10 00 	movl   $0x1067d3,(%esp)
  101ba6:	e8 f7 e6 ff ff       	call   1002a2 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bb2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bb9:	eb 3d                	jmp    101bf8 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	8b 50 40             	mov    0x40(%eax),%edx
  101bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bc4:	21 d0                	and    %edx,%eax
  101bc6:	85 c0                	test   %eax,%eax
  101bc8:	74 28                	je     101bf2 <print_trapframe+0x14a>
  101bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bcd:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101bd4:	85 c0                	test   %eax,%eax
  101bd6:	74 1a                	je     101bf2 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bdb:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101be2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be6:	c7 04 24 e2 67 10 00 	movl   $0x1067e2,(%esp)
  101bed:	e8 b0 e6 ff ff       	call   1002a2 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bf2:	ff 45 f4             	incl   -0xc(%ebp)
  101bf5:	d1 65 f0             	shll   -0x10(%ebp)
  101bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bfb:	83 f8 17             	cmp    $0x17,%eax
  101bfe:	76 bb                	jbe    101bbb <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c00:	8b 45 08             	mov    0x8(%ebp),%eax
  101c03:	8b 40 40             	mov    0x40(%eax),%eax
  101c06:	c1 e8 0c             	shr    $0xc,%eax
  101c09:	83 e0 03             	and    $0x3,%eax
  101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c10:	c7 04 24 e6 67 10 00 	movl   $0x1067e6,(%esp)
  101c17:	e8 86 e6 ff ff       	call   1002a2 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1f:	89 04 24             	mov    %eax,(%esp)
  101c22:	e8 6c fe ff ff       	call   101a93 <trap_in_kernel>
  101c27:	85 c0                	test   %eax,%eax
  101c29:	75 2d                	jne    101c58 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2e:	8b 40 44             	mov    0x44(%eax),%eax
  101c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c35:	c7 04 24 ef 67 10 00 	movl   $0x1067ef,(%esp)
  101c3c:	e8 61 e6 ff ff       	call   1002a2 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c41:	8b 45 08             	mov    0x8(%ebp),%eax
  101c44:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4c:	c7 04 24 fe 67 10 00 	movl   $0x1067fe,(%esp)
  101c53:	e8 4a e6 ff ff       	call   1002a2 <cprintf>
    }
}
  101c58:	90                   	nop
  101c59:	c9                   	leave  
  101c5a:	c3                   	ret    

00101c5b <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c5b:	55                   	push   %ebp
  101c5c:	89 e5                	mov    %esp,%ebp
  101c5e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c61:	8b 45 08             	mov    0x8(%ebp),%eax
  101c64:	8b 00                	mov    (%eax),%eax
  101c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6a:	c7 04 24 11 68 10 00 	movl   $0x106811,(%esp)
  101c71:	e8 2c e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c76:	8b 45 08             	mov    0x8(%ebp),%eax
  101c79:	8b 40 04             	mov    0x4(%eax),%eax
  101c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c80:	c7 04 24 20 68 10 00 	movl   $0x106820,(%esp)
  101c87:	e8 16 e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8f:	8b 40 08             	mov    0x8(%eax),%eax
  101c92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c96:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  101c9d:	e8 00 e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  101ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cac:	c7 04 24 3e 68 10 00 	movl   $0x10683e,(%esp)
  101cb3:	e8 ea e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbb:	8b 40 10             	mov    0x10(%eax),%eax
  101cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc2:	c7 04 24 4d 68 10 00 	movl   $0x10684d,(%esp)
  101cc9:	e8 d4 e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cce:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd1:	8b 40 14             	mov    0x14(%eax),%eax
  101cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd8:	c7 04 24 5c 68 10 00 	movl   $0x10685c,(%esp)
  101cdf:	e8 be e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce7:	8b 40 18             	mov    0x18(%eax),%eax
  101cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cee:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  101cf5:	e8 a8 e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfd:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d04:	c7 04 24 7a 68 10 00 	movl   $0x10687a,(%esp)
  101d0b:	e8 92 e5 ff ff       	call   1002a2 <cprintf>
}
  101d10:	90                   	nop
  101d11:	c9                   	leave  
  101d12:	c3                   	ret    

00101d13 <trap_dispatch>:
struct trapframe switchk2u, *switchu2k;
/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d13:	55                   	push   %ebp
  101d14:	89 e5                	mov    %esp,%ebp
  101d16:	57                   	push   %edi
  101d17:	56                   	push   %esi
  101d18:	53                   	push   %ebx
  101d19:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1f:	8b 40 30             	mov    0x30(%eax),%eax
  101d22:	83 f8 2f             	cmp    $0x2f,%eax
  101d25:	77 21                	ja     101d48 <trap_dispatch+0x35>
  101d27:	83 f8 2e             	cmp    $0x2e,%eax
  101d2a:	0f 83 f9 03 00 00    	jae    102129 <trap_dispatch+0x416>
  101d30:	83 f8 21             	cmp    $0x21,%eax
  101d33:	0f 84 9c 00 00 00    	je     101dd5 <trap_dispatch+0xc2>
  101d39:	83 f8 24             	cmp    $0x24,%eax
  101d3c:	74 6e                	je     101dac <trap_dispatch+0x99>
  101d3e:	83 f8 20             	cmp    $0x20,%eax
  101d41:	74 1c                	je     101d5f <trap_dispatch+0x4c>
  101d43:	e9 ac 03 00 00       	jmp    1020f4 <trap_dispatch+0x3e1>
  101d48:	83 f8 78             	cmp    $0x78,%eax
  101d4b:	0f 84 42 02 00 00    	je     101f93 <trap_dispatch+0x280>
  101d51:	83 f8 79             	cmp    $0x79,%eax
  101d54:	0f 84 1d 03 00 00    	je     102077 <trap_dispatch+0x364>
  101d5a:	e9 95 03 00 00       	jmp    1020f4 <trap_dispatch+0x3e1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101d5f:	a1 0c bf 11 00       	mov    0x11bf0c,%eax
  101d64:	40                   	inc    %eax
  101d65:	a3 0c bf 11 00       	mov    %eax,0x11bf0c
        if(ticks % 100 == 0)
  101d6a:	8b 0d 0c bf 11 00    	mov    0x11bf0c,%ecx
  101d70:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d75:	89 c8                	mov    %ecx,%eax
  101d77:	f7 e2                	mul    %edx
  101d79:	c1 ea 05             	shr    $0x5,%edx
  101d7c:	89 d0                	mov    %edx,%eax
  101d7e:	c1 e0 02             	shl    $0x2,%eax
  101d81:	01 d0                	add    %edx,%eax
  101d83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d8a:	01 d0                	add    %edx,%eax
  101d8c:	c1 e0 02             	shl    $0x2,%eax
  101d8f:	29 c1                	sub    %eax,%ecx
  101d91:	89 ca                	mov    %ecx,%edx
  101d93:	85 d2                	test   %edx,%edx
  101d95:	0f 85 91 03 00 00    	jne    10212c <trap_dispatch+0x419>
            print_ticks("100 ticks");
  101d9b:	c7 04 24 89 68 10 00 	movl   $0x106889,(%esp)
  101da2:	e8 09 fb ff ff       	call   1018b0 <print_ticks>
        break;
  101da7:	e9 80 03 00 00       	jmp    10212c <trap_dispatch+0x419>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101dac:	e8 bc f8 ff ff       	call   10166d <cons_getc>
  101db1:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101db4:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101db8:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dbc:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc4:	c7 04 24 93 68 10 00 	movl   $0x106893,(%esp)
  101dcb:	e8 d2 e4 ff ff       	call   1002a2 <cprintf>
        break;
  101dd0:	e9 5e 03 00 00       	jmp    102133 <trap_dispatch+0x420>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dd5:	e8 93 f8 ff ff       	call   10166d <cons_getc>
  101dda:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ddd:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101de1:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101de5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101de9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ded:	c7 04 24 a5 68 10 00 	movl   $0x1068a5,(%esp)
  101df4:	e8 a9 e4 ff ff       	call   1002a2 <cprintf>
        switch (c)
  101df9:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dfd:	83 f8 30             	cmp    $0x30,%eax
  101e00:	74 0e                	je     101e10 <trap_dispatch+0xfd>
  101e02:	83 f8 33             	cmp    $0x33,%eax
  101e05:	0f 84 90 00 00 00    	je     101e9b <trap_dispatch+0x188>
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
            print_trapframe(tf);
        }
        break;
        default:
            break;
  101e0b:	e9 7e 01 00 00       	jmp    101f8e <trap_dispatch+0x27b>
            if (tf->tf_cs != KERNEL_CS) {
  101e10:	8b 45 08             	mov    0x8(%ebp),%eax
  101e13:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e17:	83 f8 08             	cmp    $0x8,%eax
  101e1a:	0f 84 67 01 00 00    	je     101f87 <trap_dispatch+0x274>
            tf->tf_cs = KERNEL_CS;
  101e20:	8b 45 08             	mov    0x8(%ebp),%eax
  101e23:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e29:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2c:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e32:	8b 45 08             	mov    0x8(%ebp),%eax
  101e35:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e39:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	8b 40 40             	mov    0x40(%eax),%eax
  101e46:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101e4b:	89 c2                	mov    %eax,%edx
  101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e50:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e53:	8b 45 08             	mov    0x8(%ebp),%eax
  101e56:	8b 40 44             	mov    0x44(%eax),%eax
  101e59:	83 e8 44             	sub    $0x44,%eax
  101e5c:	a3 6c bf 11 00       	mov    %eax,0x11bf6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e61:	a1 6c bf 11 00       	mov    0x11bf6c,%eax
  101e66:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e6d:	00 
  101e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  101e71:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e75:	89 04 24             	mov    %eax,(%esp)
  101e78:	e8 ef 3c 00 00       	call   105b6c <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e7d:	8b 15 6c bf 11 00    	mov    0x11bf6c,%edx
  101e83:	8b 45 08             	mov    0x8(%ebp),%eax
  101e86:	83 e8 04             	sub    $0x4,%eax
  101e89:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
  101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8e:	89 04 24             	mov    %eax,(%esp)
  101e91:	e8 12 fc ff ff       	call   101aa8 <print_trapframe>
            break;
  101e96:	e9 ec 00 00 00       	jmp    101f87 <trap_dispatch+0x274>
            if (tf->tf_cs != USER_CS) {
  101e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ea2:	83 f8 1b             	cmp    $0x1b,%eax
  101ea5:	0f 84 e2 00 00 00    	je     101f8d <trap_dispatch+0x27a>
            switchk2u = *tf;
  101eab:	8b 55 08             	mov    0x8(%ebp),%edx
  101eae:	b8 20 bf 11 00       	mov    $0x11bf20,%eax
  101eb3:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101eb8:	89 c1                	mov    %eax,%ecx
  101eba:	83 e1 01             	and    $0x1,%ecx
  101ebd:	85 c9                	test   %ecx,%ecx
  101ebf:	74 0c                	je     101ecd <trap_dispatch+0x1ba>
  101ec1:	0f b6 0a             	movzbl (%edx),%ecx
  101ec4:	88 08                	mov    %cl,(%eax)
  101ec6:	8d 40 01             	lea    0x1(%eax),%eax
  101ec9:	8d 52 01             	lea    0x1(%edx),%edx
  101ecc:	4b                   	dec    %ebx
  101ecd:	89 c1                	mov    %eax,%ecx
  101ecf:	83 e1 02             	and    $0x2,%ecx
  101ed2:	85 c9                	test   %ecx,%ecx
  101ed4:	74 0f                	je     101ee5 <trap_dispatch+0x1d2>
  101ed6:	0f b7 0a             	movzwl (%edx),%ecx
  101ed9:	66 89 08             	mov    %cx,(%eax)
  101edc:	8d 40 02             	lea    0x2(%eax),%eax
  101edf:	8d 52 02             	lea    0x2(%edx),%edx
  101ee2:	83 eb 02             	sub    $0x2,%ebx
  101ee5:	89 df                	mov    %ebx,%edi
  101ee7:	83 e7 fc             	and    $0xfffffffc,%edi
  101eea:	b9 00 00 00 00       	mov    $0x0,%ecx
  101eef:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101ef2:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101ef5:	83 c1 04             	add    $0x4,%ecx
  101ef8:	39 f9                	cmp    %edi,%ecx
  101efa:	72 f3                	jb     101eef <trap_dispatch+0x1dc>
  101efc:	01 c8                	add    %ecx,%eax
  101efe:	01 ca                	add    %ecx,%edx
  101f00:	b9 00 00 00 00       	mov    $0x0,%ecx
  101f05:	89 de                	mov    %ebx,%esi
  101f07:	83 e6 02             	and    $0x2,%esi
  101f0a:	85 f6                	test   %esi,%esi
  101f0c:	74 0b                	je     101f19 <trap_dispatch+0x206>
  101f0e:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101f12:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101f16:	83 c1 02             	add    $0x2,%ecx
  101f19:	83 e3 01             	and    $0x1,%ebx
  101f1c:	85 db                	test   %ebx,%ebx
  101f1e:	74 07                	je     101f27 <trap_dispatch+0x214>
  101f20:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101f24:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101f27:	66 c7 05 5c bf 11 00 	movw   $0x1b,0x11bf5c
  101f2e:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101f30:	66 c7 05 68 bf 11 00 	movw   $0x23,0x11bf68
  101f37:	23 00 
  101f39:	0f b7 05 68 bf 11 00 	movzwl 0x11bf68,%eax
  101f40:	66 a3 48 bf 11 00    	mov    %ax,0x11bf48
  101f46:	0f b7 05 48 bf 11 00 	movzwl 0x11bf48,%eax
  101f4d:	66 a3 4c bf 11 00    	mov    %ax,0x11bf4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101f53:	8b 45 08             	mov    0x8(%ebp),%eax
  101f56:	83 c0 44             	add    $0x44,%eax
  101f59:	a3 64 bf 11 00       	mov    %eax,0x11bf64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101f5e:	a1 60 bf 11 00       	mov    0x11bf60,%eax
  101f63:	0d 00 30 00 00       	or     $0x3000,%eax
  101f68:	a3 60 bf 11 00       	mov    %eax,0x11bf60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f70:	83 e8 04             	sub    $0x4,%eax
  101f73:	ba 20 bf 11 00       	mov    $0x11bf20,%edx
  101f78:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
  101f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7d:	89 04 24             	mov    %eax,(%esp)
  101f80:	e8 23 fb ff ff       	call   101aa8 <print_trapframe>
        break;
  101f85:	eb 06                	jmp    101f8d <trap_dispatch+0x27a>
            break;
  101f87:	90                   	nop
  101f88:	e9 a6 01 00 00       	jmp    102133 <trap_dispatch+0x420>
        break;
  101f8d:	90                   	nop
        }
        break;  
  101f8e:	e9 a0 01 00 00       	jmp    102133 <trap_dispatch+0x420>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
            if (tf->tf_cs != USER_CS) {
  101f93:	8b 45 08             	mov    0x8(%ebp),%eax
  101f96:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f9a:	83 f8 1b             	cmp    $0x1b,%eax
  101f9d:	0f 84 8c 01 00 00    	je     10212f <trap_dispatch+0x41c>
            switchk2u = *tf;
  101fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  101fa6:	b8 20 bf 11 00       	mov    $0x11bf20,%eax
  101fab:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101fb0:	89 c1                	mov    %eax,%ecx
  101fb2:	83 e1 01             	and    $0x1,%ecx
  101fb5:	85 c9                	test   %ecx,%ecx
  101fb7:	74 0c                	je     101fc5 <trap_dispatch+0x2b2>
  101fb9:	0f b6 0a             	movzbl (%edx),%ecx
  101fbc:	88 08                	mov    %cl,(%eax)
  101fbe:	8d 40 01             	lea    0x1(%eax),%eax
  101fc1:	8d 52 01             	lea    0x1(%edx),%edx
  101fc4:	4b                   	dec    %ebx
  101fc5:	89 c1                	mov    %eax,%ecx
  101fc7:	83 e1 02             	and    $0x2,%ecx
  101fca:	85 c9                	test   %ecx,%ecx
  101fcc:	74 0f                	je     101fdd <trap_dispatch+0x2ca>
  101fce:	0f b7 0a             	movzwl (%edx),%ecx
  101fd1:	66 89 08             	mov    %cx,(%eax)
  101fd4:	8d 40 02             	lea    0x2(%eax),%eax
  101fd7:	8d 52 02             	lea    0x2(%edx),%edx
  101fda:	83 eb 02             	sub    $0x2,%ebx
  101fdd:	89 df                	mov    %ebx,%edi
  101fdf:	83 e7 fc             	and    $0xfffffffc,%edi
  101fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
  101fe7:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101fea:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101fed:	83 c1 04             	add    $0x4,%ecx
  101ff0:	39 f9                	cmp    %edi,%ecx
  101ff2:	72 f3                	jb     101fe7 <trap_dispatch+0x2d4>
  101ff4:	01 c8                	add    %ecx,%eax
  101ff6:	01 ca                	add    %ecx,%edx
  101ff8:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ffd:	89 de                	mov    %ebx,%esi
  101fff:	83 e6 02             	and    $0x2,%esi
  102002:	85 f6                	test   %esi,%esi
  102004:	74 0b                	je     102011 <trap_dispatch+0x2fe>
  102006:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  10200a:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  10200e:	83 c1 02             	add    $0x2,%ecx
  102011:	83 e3 01             	and    $0x1,%ebx
  102014:	85 db                	test   %ebx,%ebx
  102016:	74 07                	je     10201f <trap_dispatch+0x30c>
  102018:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  10201c:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  10201f:	66 c7 05 5c bf 11 00 	movw   $0x1b,0x11bf5c
  102026:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  102028:	66 c7 05 68 bf 11 00 	movw   $0x23,0x11bf68
  10202f:	23 00 
  102031:	0f b7 05 68 bf 11 00 	movzwl 0x11bf68,%eax
  102038:	66 a3 48 bf 11 00    	mov    %ax,0x11bf48
  10203e:	0f b7 05 48 bf 11 00 	movzwl 0x11bf48,%eax
  102045:	66 a3 4c bf 11 00    	mov    %ax,0x11bf4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  10204b:	8b 45 08             	mov    0x8(%ebp),%eax
  10204e:	83 c0 44             	add    $0x44,%eax
  102051:	a3 64 bf 11 00       	mov    %eax,0x11bf64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  102056:	a1 60 bf 11 00       	mov    0x11bf60,%eax
  10205b:	0d 00 30 00 00       	or     $0x3000,%eax
  102060:	a3 60 bf 11 00       	mov    %eax,0x11bf60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  102065:	8b 45 08             	mov    0x8(%ebp),%eax
  102068:	83 e8 04             	sub    $0x4,%eax
  10206b:	ba 20 bf 11 00       	mov    $0x11bf20,%edx
  102070:	89 10                	mov    %edx,(%eax)
        }
        break;
  102072:	e9 b8 00 00 00       	jmp    10212f <trap_dispatch+0x41c>
    case T_SWITCH_TOK:
         if (tf->tf_cs != KERNEL_CS) {
  102077:	8b 45 08             	mov    0x8(%ebp),%eax
  10207a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10207e:	83 f8 08             	cmp    $0x8,%eax
  102081:	0f 84 ab 00 00 00    	je     102132 <trap_dispatch+0x41f>
            tf->tf_cs = KERNEL_CS;
  102087:	8b 45 08             	mov    0x8(%ebp),%eax
  10208a:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  102090:	8b 45 08             	mov    0x8(%ebp),%eax
  102093:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  102099:	8b 45 08             	mov    0x8(%ebp),%eax
  10209c:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  1020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a3:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  1020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1020aa:	8b 40 40             	mov    0x40(%eax),%eax
  1020ad:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  1020b2:	89 c2                	mov    %eax,%edx
  1020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b7:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  1020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1020bd:	8b 40 44             	mov    0x44(%eax),%eax
  1020c0:	83 e8 44             	sub    $0x44,%eax
  1020c3:	a3 6c bf 11 00       	mov    %eax,0x11bf6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  1020c8:	a1 6c bf 11 00       	mov    0x11bf6c,%eax
  1020cd:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1020d4:	00 
  1020d5:	8b 55 08             	mov    0x8(%ebp),%edx
  1020d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1020dc:	89 04 24             	mov    %eax,(%esp)
  1020df:	e8 88 3a 00 00       	call   105b6c <memmove>
            //*((uint32_t *)tf - 1) = (uint32_t)tf;
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  1020e4:	8b 15 6c bf 11 00    	mov    0x11bf6c,%edx
  1020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ed:	83 e8 04             	sub    $0x4,%eax
  1020f0:	89 10                	mov    %edx,(%eax)
        }
        break;
  1020f2:	eb 3e                	jmp    102132 <trap_dispatch+0x41f>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  1020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1020f7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020fb:	83 e0 03             	and    $0x3,%eax
  1020fe:	85 c0                	test   %eax,%eax
  102100:	75 31                	jne    102133 <trap_dispatch+0x420>
            print_trapframe(tf);
  102102:	8b 45 08             	mov    0x8(%ebp),%eax
  102105:	89 04 24             	mov    %eax,(%esp)
  102108:	e8 9b f9 ff ff       	call   101aa8 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  10210d:	c7 44 24 08 b4 68 10 	movl   $0x1068b4,0x8(%esp)
  102114:	00 
  102115:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  10211c:	00 
  10211d:	c7 04 24 ce 66 10 00 	movl   $0x1066ce,(%esp)
  102124:	e8 d0 e2 ff ff       	call   1003f9 <__panic>
        break;
  102129:	90                   	nop
  10212a:	eb 07                	jmp    102133 <trap_dispatch+0x420>
        break;
  10212c:	90                   	nop
  10212d:	eb 04                	jmp    102133 <trap_dispatch+0x420>
        break;
  10212f:	90                   	nop
  102130:	eb 01                	jmp    102133 <trap_dispatch+0x420>
        break;
  102132:	90                   	nop
        }
    }
}
  102133:	90                   	nop
  102134:	83 c4 2c             	add    $0x2c,%esp
  102137:	5b                   	pop    %ebx
  102138:	5e                   	pop    %esi
  102139:	5f                   	pop    %edi
  10213a:	5d                   	pop    %ebp
  10213b:	c3                   	ret    

0010213c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  10213c:	55                   	push   %ebp
  10213d:	89 e5                	mov    %esp,%ebp
  10213f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102142:	8b 45 08             	mov    0x8(%ebp),%eax
  102145:	89 04 24             	mov    %eax,(%esp)
  102148:	e8 c6 fb ff ff       	call   101d13 <trap_dispatch>
}
  10214d:	90                   	nop
  10214e:	c9                   	leave  
  10214f:	c3                   	ret    

00102150 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $0
  102152:	6a 00                	push   $0x0
  jmp __alltraps
  102154:	e9 69 0a 00 00       	jmp    102bc2 <__alltraps>

00102159 <vector1>:
.globl vector1
vector1:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $1
  10215b:	6a 01                	push   $0x1
  jmp __alltraps
  10215d:	e9 60 0a 00 00       	jmp    102bc2 <__alltraps>

00102162 <vector2>:
.globl vector2
vector2:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $2
  102164:	6a 02                	push   $0x2
  jmp __alltraps
  102166:	e9 57 0a 00 00       	jmp    102bc2 <__alltraps>

0010216b <vector3>:
.globl vector3
vector3:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $3
  10216d:	6a 03                	push   $0x3
  jmp __alltraps
  10216f:	e9 4e 0a 00 00       	jmp    102bc2 <__alltraps>

00102174 <vector4>:
.globl vector4
vector4:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $4
  102176:	6a 04                	push   $0x4
  jmp __alltraps
  102178:	e9 45 0a 00 00       	jmp    102bc2 <__alltraps>

0010217d <vector5>:
.globl vector5
vector5:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $5
  10217f:	6a 05                	push   $0x5
  jmp __alltraps
  102181:	e9 3c 0a 00 00       	jmp    102bc2 <__alltraps>

00102186 <vector6>:
.globl vector6
vector6:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $6
  102188:	6a 06                	push   $0x6
  jmp __alltraps
  10218a:	e9 33 0a 00 00       	jmp    102bc2 <__alltraps>

0010218f <vector7>:
.globl vector7
vector7:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $7
  102191:	6a 07                	push   $0x7
  jmp __alltraps
  102193:	e9 2a 0a 00 00       	jmp    102bc2 <__alltraps>

00102198 <vector8>:
.globl vector8
vector8:
  pushl $8
  102198:	6a 08                	push   $0x8
  jmp __alltraps
  10219a:	e9 23 0a 00 00       	jmp    102bc2 <__alltraps>

0010219f <vector9>:
.globl vector9
vector9:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $9
  1021a1:	6a 09                	push   $0x9
  jmp __alltraps
  1021a3:	e9 1a 0a 00 00       	jmp    102bc2 <__alltraps>

001021a8 <vector10>:
.globl vector10
vector10:
  pushl $10
  1021a8:	6a 0a                	push   $0xa
  jmp __alltraps
  1021aa:	e9 13 0a 00 00       	jmp    102bc2 <__alltraps>

001021af <vector11>:
.globl vector11
vector11:
  pushl $11
  1021af:	6a 0b                	push   $0xb
  jmp __alltraps
  1021b1:	e9 0c 0a 00 00       	jmp    102bc2 <__alltraps>

001021b6 <vector12>:
.globl vector12
vector12:
  pushl $12
  1021b6:	6a 0c                	push   $0xc
  jmp __alltraps
  1021b8:	e9 05 0a 00 00       	jmp    102bc2 <__alltraps>

001021bd <vector13>:
.globl vector13
vector13:
  pushl $13
  1021bd:	6a 0d                	push   $0xd
  jmp __alltraps
  1021bf:	e9 fe 09 00 00       	jmp    102bc2 <__alltraps>

001021c4 <vector14>:
.globl vector14
vector14:
  pushl $14
  1021c4:	6a 0e                	push   $0xe
  jmp __alltraps
  1021c6:	e9 f7 09 00 00       	jmp    102bc2 <__alltraps>

001021cb <vector15>:
.globl vector15
vector15:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $15
  1021cd:	6a 0f                	push   $0xf
  jmp __alltraps
  1021cf:	e9 ee 09 00 00       	jmp    102bc2 <__alltraps>

001021d4 <vector16>:
.globl vector16
vector16:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $16
  1021d6:	6a 10                	push   $0x10
  jmp __alltraps
  1021d8:	e9 e5 09 00 00       	jmp    102bc2 <__alltraps>

001021dd <vector17>:
.globl vector17
vector17:
  pushl $17
  1021dd:	6a 11                	push   $0x11
  jmp __alltraps
  1021df:	e9 de 09 00 00       	jmp    102bc2 <__alltraps>

001021e4 <vector18>:
.globl vector18
vector18:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $18
  1021e6:	6a 12                	push   $0x12
  jmp __alltraps
  1021e8:	e9 d5 09 00 00       	jmp    102bc2 <__alltraps>

001021ed <vector19>:
.globl vector19
vector19:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $19
  1021ef:	6a 13                	push   $0x13
  jmp __alltraps
  1021f1:	e9 cc 09 00 00       	jmp    102bc2 <__alltraps>

001021f6 <vector20>:
.globl vector20
vector20:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $20
  1021f8:	6a 14                	push   $0x14
  jmp __alltraps
  1021fa:	e9 c3 09 00 00       	jmp    102bc2 <__alltraps>

001021ff <vector21>:
.globl vector21
vector21:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $21
  102201:	6a 15                	push   $0x15
  jmp __alltraps
  102203:	e9 ba 09 00 00       	jmp    102bc2 <__alltraps>

00102208 <vector22>:
.globl vector22
vector22:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $22
  10220a:	6a 16                	push   $0x16
  jmp __alltraps
  10220c:	e9 b1 09 00 00       	jmp    102bc2 <__alltraps>

00102211 <vector23>:
.globl vector23
vector23:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $23
  102213:	6a 17                	push   $0x17
  jmp __alltraps
  102215:	e9 a8 09 00 00       	jmp    102bc2 <__alltraps>

0010221a <vector24>:
.globl vector24
vector24:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $24
  10221c:	6a 18                	push   $0x18
  jmp __alltraps
  10221e:	e9 9f 09 00 00       	jmp    102bc2 <__alltraps>

00102223 <vector25>:
.globl vector25
vector25:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $25
  102225:	6a 19                	push   $0x19
  jmp __alltraps
  102227:	e9 96 09 00 00       	jmp    102bc2 <__alltraps>

0010222c <vector26>:
.globl vector26
vector26:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $26
  10222e:	6a 1a                	push   $0x1a
  jmp __alltraps
  102230:	e9 8d 09 00 00       	jmp    102bc2 <__alltraps>

00102235 <vector27>:
.globl vector27
vector27:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $27
  102237:	6a 1b                	push   $0x1b
  jmp __alltraps
  102239:	e9 84 09 00 00       	jmp    102bc2 <__alltraps>

0010223e <vector28>:
.globl vector28
vector28:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $28
  102240:	6a 1c                	push   $0x1c
  jmp __alltraps
  102242:	e9 7b 09 00 00       	jmp    102bc2 <__alltraps>

00102247 <vector29>:
.globl vector29
vector29:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $29
  102249:	6a 1d                	push   $0x1d
  jmp __alltraps
  10224b:	e9 72 09 00 00       	jmp    102bc2 <__alltraps>

00102250 <vector30>:
.globl vector30
vector30:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $30
  102252:	6a 1e                	push   $0x1e
  jmp __alltraps
  102254:	e9 69 09 00 00       	jmp    102bc2 <__alltraps>

00102259 <vector31>:
.globl vector31
vector31:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $31
  10225b:	6a 1f                	push   $0x1f
  jmp __alltraps
  10225d:	e9 60 09 00 00       	jmp    102bc2 <__alltraps>

00102262 <vector32>:
.globl vector32
vector32:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $32
  102264:	6a 20                	push   $0x20
  jmp __alltraps
  102266:	e9 57 09 00 00       	jmp    102bc2 <__alltraps>

0010226b <vector33>:
.globl vector33
vector33:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $33
  10226d:	6a 21                	push   $0x21
  jmp __alltraps
  10226f:	e9 4e 09 00 00       	jmp    102bc2 <__alltraps>

00102274 <vector34>:
.globl vector34
vector34:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $34
  102276:	6a 22                	push   $0x22
  jmp __alltraps
  102278:	e9 45 09 00 00       	jmp    102bc2 <__alltraps>

0010227d <vector35>:
.globl vector35
vector35:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $35
  10227f:	6a 23                	push   $0x23
  jmp __alltraps
  102281:	e9 3c 09 00 00       	jmp    102bc2 <__alltraps>

00102286 <vector36>:
.globl vector36
vector36:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $36
  102288:	6a 24                	push   $0x24
  jmp __alltraps
  10228a:	e9 33 09 00 00       	jmp    102bc2 <__alltraps>

0010228f <vector37>:
.globl vector37
vector37:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $37
  102291:	6a 25                	push   $0x25
  jmp __alltraps
  102293:	e9 2a 09 00 00       	jmp    102bc2 <__alltraps>

00102298 <vector38>:
.globl vector38
vector38:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $38
  10229a:	6a 26                	push   $0x26
  jmp __alltraps
  10229c:	e9 21 09 00 00       	jmp    102bc2 <__alltraps>

001022a1 <vector39>:
.globl vector39
vector39:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $39
  1022a3:	6a 27                	push   $0x27
  jmp __alltraps
  1022a5:	e9 18 09 00 00       	jmp    102bc2 <__alltraps>

001022aa <vector40>:
.globl vector40
vector40:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $40
  1022ac:	6a 28                	push   $0x28
  jmp __alltraps
  1022ae:	e9 0f 09 00 00       	jmp    102bc2 <__alltraps>

001022b3 <vector41>:
.globl vector41
vector41:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $41
  1022b5:	6a 29                	push   $0x29
  jmp __alltraps
  1022b7:	e9 06 09 00 00       	jmp    102bc2 <__alltraps>

001022bc <vector42>:
.globl vector42
vector42:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $42
  1022be:	6a 2a                	push   $0x2a
  jmp __alltraps
  1022c0:	e9 fd 08 00 00       	jmp    102bc2 <__alltraps>

001022c5 <vector43>:
.globl vector43
vector43:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $43
  1022c7:	6a 2b                	push   $0x2b
  jmp __alltraps
  1022c9:	e9 f4 08 00 00       	jmp    102bc2 <__alltraps>

001022ce <vector44>:
.globl vector44
vector44:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $44
  1022d0:	6a 2c                	push   $0x2c
  jmp __alltraps
  1022d2:	e9 eb 08 00 00       	jmp    102bc2 <__alltraps>

001022d7 <vector45>:
.globl vector45
vector45:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $45
  1022d9:	6a 2d                	push   $0x2d
  jmp __alltraps
  1022db:	e9 e2 08 00 00       	jmp    102bc2 <__alltraps>

001022e0 <vector46>:
.globl vector46
vector46:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $46
  1022e2:	6a 2e                	push   $0x2e
  jmp __alltraps
  1022e4:	e9 d9 08 00 00       	jmp    102bc2 <__alltraps>

001022e9 <vector47>:
.globl vector47
vector47:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $47
  1022eb:	6a 2f                	push   $0x2f
  jmp __alltraps
  1022ed:	e9 d0 08 00 00       	jmp    102bc2 <__alltraps>

001022f2 <vector48>:
.globl vector48
vector48:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $48
  1022f4:	6a 30                	push   $0x30
  jmp __alltraps
  1022f6:	e9 c7 08 00 00       	jmp    102bc2 <__alltraps>

001022fb <vector49>:
.globl vector49
vector49:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $49
  1022fd:	6a 31                	push   $0x31
  jmp __alltraps
  1022ff:	e9 be 08 00 00       	jmp    102bc2 <__alltraps>

00102304 <vector50>:
.globl vector50
vector50:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $50
  102306:	6a 32                	push   $0x32
  jmp __alltraps
  102308:	e9 b5 08 00 00       	jmp    102bc2 <__alltraps>

0010230d <vector51>:
.globl vector51
vector51:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $51
  10230f:	6a 33                	push   $0x33
  jmp __alltraps
  102311:	e9 ac 08 00 00       	jmp    102bc2 <__alltraps>

00102316 <vector52>:
.globl vector52
vector52:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $52
  102318:	6a 34                	push   $0x34
  jmp __alltraps
  10231a:	e9 a3 08 00 00       	jmp    102bc2 <__alltraps>

0010231f <vector53>:
.globl vector53
vector53:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $53
  102321:	6a 35                	push   $0x35
  jmp __alltraps
  102323:	e9 9a 08 00 00       	jmp    102bc2 <__alltraps>

00102328 <vector54>:
.globl vector54
vector54:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $54
  10232a:	6a 36                	push   $0x36
  jmp __alltraps
  10232c:	e9 91 08 00 00       	jmp    102bc2 <__alltraps>

00102331 <vector55>:
.globl vector55
vector55:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $55
  102333:	6a 37                	push   $0x37
  jmp __alltraps
  102335:	e9 88 08 00 00       	jmp    102bc2 <__alltraps>

0010233a <vector56>:
.globl vector56
vector56:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $56
  10233c:	6a 38                	push   $0x38
  jmp __alltraps
  10233e:	e9 7f 08 00 00       	jmp    102bc2 <__alltraps>

00102343 <vector57>:
.globl vector57
vector57:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $57
  102345:	6a 39                	push   $0x39
  jmp __alltraps
  102347:	e9 76 08 00 00       	jmp    102bc2 <__alltraps>

0010234c <vector58>:
.globl vector58
vector58:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $58
  10234e:	6a 3a                	push   $0x3a
  jmp __alltraps
  102350:	e9 6d 08 00 00       	jmp    102bc2 <__alltraps>

00102355 <vector59>:
.globl vector59
vector59:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $59
  102357:	6a 3b                	push   $0x3b
  jmp __alltraps
  102359:	e9 64 08 00 00       	jmp    102bc2 <__alltraps>

0010235e <vector60>:
.globl vector60
vector60:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $60
  102360:	6a 3c                	push   $0x3c
  jmp __alltraps
  102362:	e9 5b 08 00 00       	jmp    102bc2 <__alltraps>

00102367 <vector61>:
.globl vector61
vector61:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $61
  102369:	6a 3d                	push   $0x3d
  jmp __alltraps
  10236b:	e9 52 08 00 00       	jmp    102bc2 <__alltraps>

00102370 <vector62>:
.globl vector62
vector62:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $62
  102372:	6a 3e                	push   $0x3e
  jmp __alltraps
  102374:	e9 49 08 00 00       	jmp    102bc2 <__alltraps>

00102379 <vector63>:
.globl vector63
vector63:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $63
  10237b:	6a 3f                	push   $0x3f
  jmp __alltraps
  10237d:	e9 40 08 00 00       	jmp    102bc2 <__alltraps>

00102382 <vector64>:
.globl vector64
vector64:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $64
  102384:	6a 40                	push   $0x40
  jmp __alltraps
  102386:	e9 37 08 00 00       	jmp    102bc2 <__alltraps>

0010238b <vector65>:
.globl vector65
vector65:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $65
  10238d:	6a 41                	push   $0x41
  jmp __alltraps
  10238f:	e9 2e 08 00 00       	jmp    102bc2 <__alltraps>

00102394 <vector66>:
.globl vector66
vector66:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $66
  102396:	6a 42                	push   $0x42
  jmp __alltraps
  102398:	e9 25 08 00 00       	jmp    102bc2 <__alltraps>

0010239d <vector67>:
.globl vector67
vector67:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $67
  10239f:	6a 43                	push   $0x43
  jmp __alltraps
  1023a1:	e9 1c 08 00 00       	jmp    102bc2 <__alltraps>

001023a6 <vector68>:
.globl vector68
vector68:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $68
  1023a8:	6a 44                	push   $0x44
  jmp __alltraps
  1023aa:	e9 13 08 00 00       	jmp    102bc2 <__alltraps>

001023af <vector69>:
.globl vector69
vector69:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $69
  1023b1:	6a 45                	push   $0x45
  jmp __alltraps
  1023b3:	e9 0a 08 00 00       	jmp    102bc2 <__alltraps>

001023b8 <vector70>:
.globl vector70
vector70:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $70
  1023ba:	6a 46                	push   $0x46
  jmp __alltraps
  1023bc:	e9 01 08 00 00       	jmp    102bc2 <__alltraps>

001023c1 <vector71>:
.globl vector71
vector71:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $71
  1023c3:	6a 47                	push   $0x47
  jmp __alltraps
  1023c5:	e9 f8 07 00 00       	jmp    102bc2 <__alltraps>

001023ca <vector72>:
.globl vector72
vector72:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $72
  1023cc:	6a 48                	push   $0x48
  jmp __alltraps
  1023ce:	e9 ef 07 00 00       	jmp    102bc2 <__alltraps>

001023d3 <vector73>:
.globl vector73
vector73:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $73
  1023d5:	6a 49                	push   $0x49
  jmp __alltraps
  1023d7:	e9 e6 07 00 00       	jmp    102bc2 <__alltraps>

001023dc <vector74>:
.globl vector74
vector74:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $74
  1023de:	6a 4a                	push   $0x4a
  jmp __alltraps
  1023e0:	e9 dd 07 00 00       	jmp    102bc2 <__alltraps>

001023e5 <vector75>:
.globl vector75
vector75:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $75
  1023e7:	6a 4b                	push   $0x4b
  jmp __alltraps
  1023e9:	e9 d4 07 00 00       	jmp    102bc2 <__alltraps>

001023ee <vector76>:
.globl vector76
vector76:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $76
  1023f0:	6a 4c                	push   $0x4c
  jmp __alltraps
  1023f2:	e9 cb 07 00 00       	jmp    102bc2 <__alltraps>

001023f7 <vector77>:
.globl vector77
vector77:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $77
  1023f9:	6a 4d                	push   $0x4d
  jmp __alltraps
  1023fb:	e9 c2 07 00 00       	jmp    102bc2 <__alltraps>

00102400 <vector78>:
.globl vector78
vector78:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $78
  102402:	6a 4e                	push   $0x4e
  jmp __alltraps
  102404:	e9 b9 07 00 00       	jmp    102bc2 <__alltraps>

00102409 <vector79>:
.globl vector79
vector79:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $79
  10240b:	6a 4f                	push   $0x4f
  jmp __alltraps
  10240d:	e9 b0 07 00 00       	jmp    102bc2 <__alltraps>

00102412 <vector80>:
.globl vector80
vector80:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $80
  102414:	6a 50                	push   $0x50
  jmp __alltraps
  102416:	e9 a7 07 00 00       	jmp    102bc2 <__alltraps>

0010241b <vector81>:
.globl vector81
vector81:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $81
  10241d:	6a 51                	push   $0x51
  jmp __alltraps
  10241f:	e9 9e 07 00 00       	jmp    102bc2 <__alltraps>

00102424 <vector82>:
.globl vector82
vector82:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $82
  102426:	6a 52                	push   $0x52
  jmp __alltraps
  102428:	e9 95 07 00 00       	jmp    102bc2 <__alltraps>

0010242d <vector83>:
.globl vector83
vector83:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $83
  10242f:	6a 53                	push   $0x53
  jmp __alltraps
  102431:	e9 8c 07 00 00       	jmp    102bc2 <__alltraps>

00102436 <vector84>:
.globl vector84
vector84:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $84
  102438:	6a 54                	push   $0x54
  jmp __alltraps
  10243a:	e9 83 07 00 00       	jmp    102bc2 <__alltraps>

0010243f <vector85>:
.globl vector85
vector85:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $85
  102441:	6a 55                	push   $0x55
  jmp __alltraps
  102443:	e9 7a 07 00 00       	jmp    102bc2 <__alltraps>

00102448 <vector86>:
.globl vector86
vector86:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $86
  10244a:	6a 56                	push   $0x56
  jmp __alltraps
  10244c:	e9 71 07 00 00       	jmp    102bc2 <__alltraps>

00102451 <vector87>:
.globl vector87
vector87:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $87
  102453:	6a 57                	push   $0x57
  jmp __alltraps
  102455:	e9 68 07 00 00       	jmp    102bc2 <__alltraps>

0010245a <vector88>:
.globl vector88
vector88:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $88
  10245c:	6a 58                	push   $0x58
  jmp __alltraps
  10245e:	e9 5f 07 00 00       	jmp    102bc2 <__alltraps>

00102463 <vector89>:
.globl vector89
vector89:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $89
  102465:	6a 59                	push   $0x59
  jmp __alltraps
  102467:	e9 56 07 00 00       	jmp    102bc2 <__alltraps>

0010246c <vector90>:
.globl vector90
vector90:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $90
  10246e:	6a 5a                	push   $0x5a
  jmp __alltraps
  102470:	e9 4d 07 00 00       	jmp    102bc2 <__alltraps>

00102475 <vector91>:
.globl vector91
vector91:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $91
  102477:	6a 5b                	push   $0x5b
  jmp __alltraps
  102479:	e9 44 07 00 00       	jmp    102bc2 <__alltraps>

0010247e <vector92>:
.globl vector92
vector92:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $92
  102480:	6a 5c                	push   $0x5c
  jmp __alltraps
  102482:	e9 3b 07 00 00       	jmp    102bc2 <__alltraps>

00102487 <vector93>:
.globl vector93
vector93:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $93
  102489:	6a 5d                	push   $0x5d
  jmp __alltraps
  10248b:	e9 32 07 00 00       	jmp    102bc2 <__alltraps>

00102490 <vector94>:
.globl vector94
vector94:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $94
  102492:	6a 5e                	push   $0x5e
  jmp __alltraps
  102494:	e9 29 07 00 00       	jmp    102bc2 <__alltraps>

00102499 <vector95>:
.globl vector95
vector95:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $95
  10249b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10249d:	e9 20 07 00 00       	jmp    102bc2 <__alltraps>

001024a2 <vector96>:
.globl vector96
vector96:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $96
  1024a4:	6a 60                	push   $0x60
  jmp __alltraps
  1024a6:	e9 17 07 00 00       	jmp    102bc2 <__alltraps>

001024ab <vector97>:
.globl vector97
vector97:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $97
  1024ad:	6a 61                	push   $0x61
  jmp __alltraps
  1024af:	e9 0e 07 00 00       	jmp    102bc2 <__alltraps>

001024b4 <vector98>:
.globl vector98
vector98:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $98
  1024b6:	6a 62                	push   $0x62
  jmp __alltraps
  1024b8:	e9 05 07 00 00       	jmp    102bc2 <__alltraps>

001024bd <vector99>:
.globl vector99
vector99:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $99
  1024bf:	6a 63                	push   $0x63
  jmp __alltraps
  1024c1:	e9 fc 06 00 00       	jmp    102bc2 <__alltraps>

001024c6 <vector100>:
.globl vector100
vector100:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $100
  1024c8:	6a 64                	push   $0x64
  jmp __alltraps
  1024ca:	e9 f3 06 00 00       	jmp    102bc2 <__alltraps>

001024cf <vector101>:
.globl vector101
vector101:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $101
  1024d1:	6a 65                	push   $0x65
  jmp __alltraps
  1024d3:	e9 ea 06 00 00       	jmp    102bc2 <__alltraps>

001024d8 <vector102>:
.globl vector102
vector102:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $102
  1024da:	6a 66                	push   $0x66
  jmp __alltraps
  1024dc:	e9 e1 06 00 00       	jmp    102bc2 <__alltraps>

001024e1 <vector103>:
.globl vector103
vector103:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $103
  1024e3:	6a 67                	push   $0x67
  jmp __alltraps
  1024e5:	e9 d8 06 00 00       	jmp    102bc2 <__alltraps>

001024ea <vector104>:
.globl vector104
vector104:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $104
  1024ec:	6a 68                	push   $0x68
  jmp __alltraps
  1024ee:	e9 cf 06 00 00       	jmp    102bc2 <__alltraps>

001024f3 <vector105>:
.globl vector105
vector105:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $105
  1024f5:	6a 69                	push   $0x69
  jmp __alltraps
  1024f7:	e9 c6 06 00 00       	jmp    102bc2 <__alltraps>

001024fc <vector106>:
.globl vector106
vector106:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $106
  1024fe:	6a 6a                	push   $0x6a
  jmp __alltraps
  102500:	e9 bd 06 00 00       	jmp    102bc2 <__alltraps>

00102505 <vector107>:
.globl vector107
vector107:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $107
  102507:	6a 6b                	push   $0x6b
  jmp __alltraps
  102509:	e9 b4 06 00 00       	jmp    102bc2 <__alltraps>

0010250e <vector108>:
.globl vector108
vector108:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $108
  102510:	6a 6c                	push   $0x6c
  jmp __alltraps
  102512:	e9 ab 06 00 00       	jmp    102bc2 <__alltraps>

00102517 <vector109>:
.globl vector109
vector109:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $109
  102519:	6a 6d                	push   $0x6d
  jmp __alltraps
  10251b:	e9 a2 06 00 00       	jmp    102bc2 <__alltraps>

00102520 <vector110>:
.globl vector110
vector110:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $110
  102522:	6a 6e                	push   $0x6e
  jmp __alltraps
  102524:	e9 99 06 00 00       	jmp    102bc2 <__alltraps>

00102529 <vector111>:
.globl vector111
vector111:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $111
  10252b:	6a 6f                	push   $0x6f
  jmp __alltraps
  10252d:	e9 90 06 00 00       	jmp    102bc2 <__alltraps>

00102532 <vector112>:
.globl vector112
vector112:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $112
  102534:	6a 70                	push   $0x70
  jmp __alltraps
  102536:	e9 87 06 00 00       	jmp    102bc2 <__alltraps>

0010253b <vector113>:
.globl vector113
vector113:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $113
  10253d:	6a 71                	push   $0x71
  jmp __alltraps
  10253f:	e9 7e 06 00 00       	jmp    102bc2 <__alltraps>

00102544 <vector114>:
.globl vector114
vector114:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $114
  102546:	6a 72                	push   $0x72
  jmp __alltraps
  102548:	e9 75 06 00 00       	jmp    102bc2 <__alltraps>

0010254d <vector115>:
.globl vector115
vector115:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $115
  10254f:	6a 73                	push   $0x73
  jmp __alltraps
  102551:	e9 6c 06 00 00       	jmp    102bc2 <__alltraps>

00102556 <vector116>:
.globl vector116
vector116:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $116
  102558:	6a 74                	push   $0x74
  jmp __alltraps
  10255a:	e9 63 06 00 00       	jmp    102bc2 <__alltraps>

0010255f <vector117>:
.globl vector117
vector117:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $117
  102561:	6a 75                	push   $0x75
  jmp __alltraps
  102563:	e9 5a 06 00 00       	jmp    102bc2 <__alltraps>

00102568 <vector118>:
.globl vector118
vector118:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $118
  10256a:	6a 76                	push   $0x76
  jmp __alltraps
  10256c:	e9 51 06 00 00       	jmp    102bc2 <__alltraps>

00102571 <vector119>:
.globl vector119
vector119:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $119
  102573:	6a 77                	push   $0x77
  jmp __alltraps
  102575:	e9 48 06 00 00       	jmp    102bc2 <__alltraps>

0010257a <vector120>:
.globl vector120
vector120:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $120
  10257c:	6a 78                	push   $0x78
  jmp __alltraps
  10257e:	e9 3f 06 00 00       	jmp    102bc2 <__alltraps>

00102583 <vector121>:
.globl vector121
vector121:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $121
  102585:	6a 79                	push   $0x79
  jmp __alltraps
  102587:	e9 36 06 00 00       	jmp    102bc2 <__alltraps>

0010258c <vector122>:
.globl vector122
vector122:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $122
  10258e:	6a 7a                	push   $0x7a
  jmp __alltraps
  102590:	e9 2d 06 00 00       	jmp    102bc2 <__alltraps>

00102595 <vector123>:
.globl vector123
vector123:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $123
  102597:	6a 7b                	push   $0x7b
  jmp __alltraps
  102599:	e9 24 06 00 00       	jmp    102bc2 <__alltraps>

0010259e <vector124>:
.globl vector124
vector124:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $124
  1025a0:	6a 7c                	push   $0x7c
  jmp __alltraps
  1025a2:	e9 1b 06 00 00       	jmp    102bc2 <__alltraps>

001025a7 <vector125>:
.globl vector125
vector125:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $125
  1025a9:	6a 7d                	push   $0x7d
  jmp __alltraps
  1025ab:	e9 12 06 00 00       	jmp    102bc2 <__alltraps>

001025b0 <vector126>:
.globl vector126
vector126:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $126
  1025b2:	6a 7e                	push   $0x7e
  jmp __alltraps
  1025b4:	e9 09 06 00 00       	jmp    102bc2 <__alltraps>

001025b9 <vector127>:
.globl vector127
vector127:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $127
  1025bb:	6a 7f                	push   $0x7f
  jmp __alltraps
  1025bd:	e9 00 06 00 00       	jmp    102bc2 <__alltraps>

001025c2 <vector128>:
.globl vector128
vector128:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $128
  1025c4:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1025c9:	e9 f4 05 00 00       	jmp    102bc2 <__alltraps>

001025ce <vector129>:
.globl vector129
vector129:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $129
  1025d0:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1025d5:	e9 e8 05 00 00       	jmp    102bc2 <__alltraps>

001025da <vector130>:
.globl vector130
vector130:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $130
  1025dc:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1025e1:	e9 dc 05 00 00       	jmp    102bc2 <__alltraps>

001025e6 <vector131>:
.globl vector131
vector131:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $131
  1025e8:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1025ed:	e9 d0 05 00 00       	jmp    102bc2 <__alltraps>

001025f2 <vector132>:
.globl vector132
vector132:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $132
  1025f4:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1025f9:	e9 c4 05 00 00       	jmp    102bc2 <__alltraps>

001025fe <vector133>:
.globl vector133
vector133:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $133
  102600:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102605:	e9 b8 05 00 00       	jmp    102bc2 <__alltraps>

0010260a <vector134>:
.globl vector134
vector134:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $134
  10260c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102611:	e9 ac 05 00 00       	jmp    102bc2 <__alltraps>

00102616 <vector135>:
.globl vector135
vector135:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $135
  102618:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10261d:	e9 a0 05 00 00       	jmp    102bc2 <__alltraps>

00102622 <vector136>:
.globl vector136
vector136:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $136
  102624:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102629:	e9 94 05 00 00       	jmp    102bc2 <__alltraps>

0010262e <vector137>:
.globl vector137
vector137:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $137
  102630:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102635:	e9 88 05 00 00       	jmp    102bc2 <__alltraps>

0010263a <vector138>:
.globl vector138
vector138:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $138
  10263c:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102641:	e9 7c 05 00 00       	jmp    102bc2 <__alltraps>

00102646 <vector139>:
.globl vector139
vector139:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $139
  102648:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10264d:	e9 70 05 00 00       	jmp    102bc2 <__alltraps>

00102652 <vector140>:
.globl vector140
vector140:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $140
  102654:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102659:	e9 64 05 00 00       	jmp    102bc2 <__alltraps>

0010265e <vector141>:
.globl vector141
vector141:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $141
  102660:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102665:	e9 58 05 00 00       	jmp    102bc2 <__alltraps>

0010266a <vector142>:
.globl vector142
vector142:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $142
  10266c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102671:	e9 4c 05 00 00       	jmp    102bc2 <__alltraps>

00102676 <vector143>:
.globl vector143
vector143:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $143
  102678:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10267d:	e9 40 05 00 00       	jmp    102bc2 <__alltraps>

00102682 <vector144>:
.globl vector144
vector144:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $144
  102684:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102689:	e9 34 05 00 00       	jmp    102bc2 <__alltraps>

0010268e <vector145>:
.globl vector145
vector145:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $145
  102690:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102695:	e9 28 05 00 00       	jmp    102bc2 <__alltraps>

0010269a <vector146>:
.globl vector146
vector146:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $146
  10269c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1026a1:	e9 1c 05 00 00       	jmp    102bc2 <__alltraps>

001026a6 <vector147>:
.globl vector147
vector147:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $147
  1026a8:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1026ad:	e9 10 05 00 00       	jmp    102bc2 <__alltraps>

001026b2 <vector148>:
.globl vector148
vector148:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $148
  1026b4:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1026b9:	e9 04 05 00 00       	jmp    102bc2 <__alltraps>

001026be <vector149>:
.globl vector149
vector149:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $149
  1026c0:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1026c5:	e9 f8 04 00 00       	jmp    102bc2 <__alltraps>

001026ca <vector150>:
.globl vector150
vector150:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $150
  1026cc:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1026d1:	e9 ec 04 00 00       	jmp    102bc2 <__alltraps>

001026d6 <vector151>:
.globl vector151
vector151:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $151
  1026d8:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1026dd:	e9 e0 04 00 00       	jmp    102bc2 <__alltraps>

001026e2 <vector152>:
.globl vector152
vector152:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $152
  1026e4:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1026e9:	e9 d4 04 00 00       	jmp    102bc2 <__alltraps>

001026ee <vector153>:
.globl vector153
vector153:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $153
  1026f0:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1026f5:	e9 c8 04 00 00       	jmp    102bc2 <__alltraps>

001026fa <vector154>:
.globl vector154
vector154:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $154
  1026fc:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102701:	e9 bc 04 00 00       	jmp    102bc2 <__alltraps>

00102706 <vector155>:
.globl vector155
vector155:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $155
  102708:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10270d:	e9 b0 04 00 00       	jmp    102bc2 <__alltraps>

00102712 <vector156>:
.globl vector156
vector156:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $156
  102714:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102719:	e9 a4 04 00 00       	jmp    102bc2 <__alltraps>

0010271e <vector157>:
.globl vector157
vector157:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $157
  102720:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102725:	e9 98 04 00 00       	jmp    102bc2 <__alltraps>

0010272a <vector158>:
.globl vector158
vector158:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $158
  10272c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102731:	e9 8c 04 00 00       	jmp    102bc2 <__alltraps>

00102736 <vector159>:
.globl vector159
vector159:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $159
  102738:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10273d:	e9 80 04 00 00       	jmp    102bc2 <__alltraps>

00102742 <vector160>:
.globl vector160
vector160:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $160
  102744:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102749:	e9 74 04 00 00       	jmp    102bc2 <__alltraps>

0010274e <vector161>:
.globl vector161
vector161:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $161
  102750:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102755:	e9 68 04 00 00       	jmp    102bc2 <__alltraps>

0010275a <vector162>:
.globl vector162
vector162:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $162
  10275c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102761:	e9 5c 04 00 00       	jmp    102bc2 <__alltraps>

00102766 <vector163>:
.globl vector163
vector163:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $163
  102768:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10276d:	e9 50 04 00 00       	jmp    102bc2 <__alltraps>

00102772 <vector164>:
.globl vector164
vector164:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $164
  102774:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102779:	e9 44 04 00 00       	jmp    102bc2 <__alltraps>

0010277e <vector165>:
.globl vector165
vector165:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $165
  102780:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102785:	e9 38 04 00 00       	jmp    102bc2 <__alltraps>

0010278a <vector166>:
.globl vector166
vector166:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $166
  10278c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102791:	e9 2c 04 00 00       	jmp    102bc2 <__alltraps>

00102796 <vector167>:
.globl vector167
vector167:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $167
  102798:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10279d:	e9 20 04 00 00       	jmp    102bc2 <__alltraps>

001027a2 <vector168>:
.globl vector168
vector168:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $168
  1027a4:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1027a9:	e9 14 04 00 00       	jmp    102bc2 <__alltraps>

001027ae <vector169>:
.globl vector169
vector169:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $169
  1027b0:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1027b5:	e9 08 04 00 00       	jmp    102bc2 <__alltraps>

001027ba <vector170>:
.globl vector170
vector170:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $170
  1027bc:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1027c1:	e9 fc 03 00 00       	jmp    102bc2 <__alltraps>

001027c6 <vector171>:
.globl vector171
vector171:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $171
  1027c8:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1027cd:	e9 f0 03 00 00       	jmp    102bc2 <__alltraps>

001027d2 <vector172>:
.globl vector172
vector172:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $172
  1027d4:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1027d9:	e9 e4 03 00 00       	jmp    102bc2 <__alltraps>

001027de <vector173>:
.globl vector173
vector173:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $173
  1027e0:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1027e5:	e9 d8 03 00 00       	jmp    102bc2 <__alltraps>

001027ea <vector174>:
.globl vector174
vector174:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $174
  1027ec:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1027f1:	e9 cc 03 00 00       	jmp    102bc2 <__alltraps>

001027f6 <vector175>:
.globl vector175
vector175:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $175
  1027f8:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1027fd:	e9 c0 03 00 00       	jmp    102bc2 <__alltraps>

00102802 <vector176>:
.globl vector176
vector176:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $176
  102804:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102809:	e9 b4 03 00 00       	jmp    102bc2 <__alltraps>

0010280e <vector177>:
.globl vector177
vector177:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $177
  102810:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102815:	e9 a8 03 00 00       	jmp    102bc2 <__alltraps>

0010281a <vector178>:
.globl vector178
vector178:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $178
  10281c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102821:	e9 9c 03 00 00       	jmp    102bc2 <__alltraps>

00102826 <vector179>:
.globl vector179
vector179:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $179
  102828:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10282d:	e9 90 03 00 00       	jmp    102bc2 <__alltraps>

00102832 <vector180>:
.globl vector180
vector180:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $180
  102834:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102839:	e9 84 03 00 00       	jmp    102bc2 <__alltraps>

0010283e <vector181>:
.globl vector181
vector181:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $181
  102840:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102845:	e9 78 03 00 00       	jmp    102bc2 <__alltraps>

0010284a <vector182>:
.globl vector182
vector182:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $182
  10284c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102851:	e9 6c 03 00 00       	jmp    102bc2 <__alltraps>

00102856 <vector183>:
.globl vector183
vector183:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $183
  102858:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10285d:	e9 60 03 00 00       	jmp    102bc2 <__alltraps>

00102862 <vector184>:
.globl vector184
vector184:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $184
  102864:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102869:	e9 54 03 00 00       	jmp    102bc2 <__alltraps>

0010286e <vector185>:
.globl vector185
vector185:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $185
  102870:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102875:	e9 48 03 00 00       	jmp    102bc2 <__alltraps>

0010287a <vector186>:
.globl vector186
vector186:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $186
  10287c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102881:	e9 3c 03 00 00       	jmp    102bc2 <__alltraps>

00102886 <vector187>:
.globl vector187
vector187:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $187
  102888:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10288d:	e9 30 03 00 00       	jmp    102bc2 <__alltraps>

00102892 <vector188>:
.globl vector188
vector188:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $188
  102894:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102899:	e9 24 03 00 00       	jmp    102bc2 <__alltraps>

0010289e <vector189>:
.globl vector189
vector189:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $189
  1028a0:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1028a5:	e9 18 03 00 00       	jmp    102bc2 <__alltraps>

001028aa <vector190>:
.globl vector190
vector190:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $190
  1028ac:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1028b1:	e9 0c 03 00 00       	jmp    102bc2 <__alltraps>

001028b6 <vector191>:
.globl vector191
vector191:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $191
  1028b8:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1028bd:	e9 00 03 00 00       	jmp    102bc2 <__alltraps>

001028c2 <vector192>:
.globl vector192
vector192:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $192
  1028c4:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1028c9:	e9 f4 02 00 00       	jmp    102bc2 <__alltraps>

001028ce <vector193>:
.globl vector193
vector193:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $193
  1028d0:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1028d5:	e9 e8 02 00 00       	jmp    102bc2 <__alltraps>

001028da <vector194>:
.globl vector194
vector194:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $194
  1028dc:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1028e1:	e9 dc 02 00 00       	jmp    102bc2 <__alltraps>

001028e6 <vector195>:
.globl vector195
vector195:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $195
  1028e8:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1028ed:	e9 d0 02 00 00       	jmp    102bc2 <__alltraps>

001028f2 <vector196>:
.globl vector196
vector196:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $196
  1028f4:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1028f9:	e9 c4 02 00 00       	jmp    102bc2 <__alltraps>

001028fe <vector197>:
.globl vector197
vector197:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $197
  102900:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102905:	e9 b8 02 00 00       	jmp    102bc2 <__alltraps>

0010290a <vector198>:
.globl vector198
vector198:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $198
  10290c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102911:	e9 ac 02 00 00       	jmp    102bc2 <__alltraps>

00102916 <vector199>:
.globl vector199
vector199:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $199
  102918:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10291d:	e9 a0 02 00 00       	jmp    102bc2 <__alltraps>

00102922 <vector200>:
.globl vector200
vector200:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $200
  102924:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102929:	e9 94 02 00 00       	jmp    102bc2 <__alltraps>

0010292e <vector201>:
.globl vector201
vector201:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $201
  102930:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102935:	e9 88 02 00 00       	jmp    102bc2 <__alltraps>

0010293a <vector202>:
.globl vector202
vector202:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $202
  10293c:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102941:	e9 7c 02 00 00       	jmp    102bc2 <__alltraps>

00102946 <vector203>:
.globl vector203
vector203:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $203
  102948:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10294d:	e9 70 02 00 00       	jmp    102bc2 <__alltraps>

00102952 <vector204>:
.globl vector204
vector204:
  pushl $0
  102952:	6a 00                	push   $0x0
  pushl $204
  102954:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102959:	e9 64 02 00 00       	jmp    102bc2 <__alltraps>

0010295e <vector205>:
.globl vector205
vector205:
  pushl $0
  10295e:	6a 00                	push   $0x0
  pushl $205
  102960:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102965:	e9 58 02 00 00       	jmp    102bc2 <__alltraps>

0010296a <vector206>:
.globl vector206
vector206:
  pushl $0
  10296a:	6a 00                	push   $0x0
  pushl $206
  10296c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102971:	e9 4c 02 00 00       	jmp    102bc2 <__alltraps>

00102976 <vector207>:
.globl vector207
vector207:
  pushl $0
  102976:	6a 00                	push   $0x0
  pushl $207
  102978:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10297d:	e9 40 02 00 00       	jmp    102bc2 <__alltraps>

00102982 <vector208>:
.globl vector208
vector208:
  pushl $0
  102982:	6a 00                	push   $0x0
  pushl $208
  102984:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102989:	e9 34 02 00 00       	jmp    102bc2 <__alltraps>

0010298e <vector209>:
.globl vector209
vector209:
  pushl $0
  10298e:	6a 00                	push   $0x0
  pushl $209
  102990:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102995:	e9 28 02 00 00       	jmp    102bc2 <__alltraps>

0010299a <vector210>:
.globl vector210
vector210:
  pushl $0
  10299a:	6a 00                	push   $0x0
  pushl $210
  10299c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1029a1:	e9 1c 02 00 00       	jmp    102bc2 <__alltraps>

001029a6 <vector211>:
.globl vector211
vector211:
  pushl $0
  1029a6:	6a 00                	push   $0x0
  pushl $211
  1029a8:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1029ad:	e9 10 02 00 00       	jmp    102bc2 <__alltraps>

001029b2 <vector212>:
.globl vector212
vector212:
  pushl $0
  1029b2:	6a 00                	push   $0x0
  pushl $212
  1029b4:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1029b9:	e9 04 02 00 00       	jmp    102bc2 <__alltraps>

001029be <vector213>:
.globl vector213
vector213:
  pushl $0
  1029be:	6a 00                	push   $0x0
  pushl $213
  1029c0:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1029c5:	e9 f8 01 00 00       	jmp    102bc2 <__alltraps>

001029ca <vector214>:
.globl vector214
vector214:
  pushl $0
  1029ca:	6a 00                	push   $0x0
  pushl $214
  1029cc:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1029d1:	e9 ec 01 00 00       	jmp    102bc2 <__alltraps>

001029d6 <vector215>:
.globl vector215
vector215:
  pushl $0
  1029d6:	6a 00                	push   $0x0
  pushl $215
  1029d8:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1029dd:	e9 e0 01 00 00       	jmp    102bc2 <__alltraps>

001029e2 <vector216>:
.globl vector216
vector216:
  pushl $0
  1029e2:	6a 00                	push   $0x0
  pushl $216
  1029e4:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1029e9:	e9 d4 01 00 00       	jmp    102bc2 <__alltraps>

001029ee <vector217>:
.globl vector217
vector217:
  pushl $0
  1029ee:	6a 00                	push   $0x0
  pushl $217
  1029f0:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1029f5:	e9 c8 01 00 00       	jmp    102bc2 <__alltraps>

001029fa <vector218>:
.globl vector218
vector218:
  pushl $0
  1029fa:	6a 00                	push   $0x0
  pushl $218
  1029fc:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102a01:	e9 bc 01 00 00       	jmp    102bc2 <__alltraps>

00102a06 <vector219>:
.globl vector219
vector219:
  pushl $0
  102a06:	6a 00                	push   $0x0
  pushl $219
  102a08:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102a0d:	e9 b0 01 00 00       	jmp    102bc2 <__alltraps>

00102a12 <vector220>:
.globl vector220
vector220:
  pushl $0
  102a12:	6a 00                	push   $0x0
  pushl $220
  102a14:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102a19:	e9 a4 01 00 00       	jmp    102bc2 <__alltraps>

00102a1e <vector221>:
.globl vector221
vector221:
  pushl $0
  102a1e:	6a 00                	push   $0x0
  pushl $221
  102a20:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102a25:	e9 98 01 00 00       	jmp    102bc2 <__alltraps>

00102a2a <vector222>:
.globl vector222
vector222:
  pushl $0
  102a2a:	6a 00                	push   $0x0
  pushl $222
  102a2c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102a31:	e9 8c 01 00 00       	jmp    102bc2 <__alltraps>

00102a36 <vector223>:
.globl vector223
vector223:
  pushl $0
  102a36:	6a 00                	push   $0x0
  pushl $223
  102a38:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102a3d:	e9 80 01 00 00       	jmp    102bc2 <__alltraps>

00102a42 <vector224>:
.globl vector224
vector224:
  pushl $0
  102a42:	6a 00                	push   $0x0
  pushl $224
  102a44:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102a49:	e9 74 01 00 00       	jmp    102bc2 <__alltraps>

00102a4e <vector225>:
.globl vector225
vector225:
  pushl $0
  102a4e:	6a 00                	push   $0x0
  pushl $225
  102a50:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102a55:	e9 68 01 00 00       	jmp    102bc2 <__alltraps>

00102a5a <vector226>:
.globl vector226
vector226:
  pushl $0
  102a5a:	6a 00                	push   $0x0
  pushl $226
  102a5c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102a61:	e9 5c 01 00 00       	jmp    102bc2 <__alltraps>

00102a66 <vector227>:
.globl vector227
vector227:
  pushl $0
  102a66:	6a 00                	push   $0x0
  pushl $227
  102a68:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102a6d:	e9 50 01 00 00       	jmp    102bc2 <__alltraps>

00102a72 <vector228>:
.globl vector228
vector228:
  pushl $0
  102a72:	6a 00                	push   $0x0
  pushl $228
  102a74:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102a79:	e9 44 01 00 00       	jmp    102bc2 <__alltraps>

00102a7e <vector229>:
.globl vector229
vector229:
  pushl $0
  102a7e:	6a 00                	push   $0x0
  pushl $229
  102a80:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102a85:	e9 38 01 00 00       	jmp    102bc2 <__alltraps>

00102a8a <vector230>:
.globl vector230
vector230:
  pushl $0
  102a8a:	6a 00                	push   $0x0
  pushl $230
  102a8c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102a91:	e9 2c 01 00 00       	jmp    102bc2 <__alltraps>

00102a96 <vector231>:
.globl vector231
vector231:
  pushl $0
  102a96:	6a 00                	push   $0x0
  pushl $231
  102a98:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102a9d:	e9 20 01 00 00       	jmp    102bc2 <__alltraps>

00102aa2 <vector232>:
.globl vector232
vector232:
  pushl $0
  102aa2:	6a 00                	push   $0x0
  pushl $232
  102aa4:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102aa9:	e9 14 01 00 00       	jmp    102bc2 <__alltraps>

00102aae <vector233>:
.globl vector233
vector233:
  pushl $0
  102aae:	6a 00                	push   $0x0
  pushl $233
  102ab0:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102ab5:	e9 08 01 00 00       	jmp    102bc2 <__alltraps>

00102aba <vector234>:
.globl vector234
vector234:
  pushl $0
  102aba:	6a 00                	push   $0x0
  pushl $234
  102abc:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102ac1:	e9 fc 00 00 00       	jmp    102bc2 <__alltraps>

00102ac6 <vector235>:
.globl vector235
vector235:
  pushl $0
  102ac6:	6a 00                	push   $0x0
  pushl $235
  102ac8:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102acd:	e9 f0 00 00 00       	jmp    102bc2 <__alltraps>

00102ad2 <vector236>:
.globl vector236
vector236:
  pushl $0
  102ad2:	6a 00                	push   $0x0
  pushl $236
  102ad4:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102ad9:	e9 e4 00 00 00       	jmp    102bc2 <__alltraps>

00102ade <vector237>:
.globl vector237
vector237:
  pushl $0
  102ade:	6a 00                	push   $0x0
  pushl $237
  102ae0:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102ae5:	e9 d8 00 00 00       	jmp    102bc2 <__alltraps>

00102aea <vector238>:
.globl vector238
vector238:
  pushl $0
  102aea:	6a 00                	push   $0x0
  pushl $238
  102aec:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102af1:	e9 cc 00 00 00       	jmp    102bc2 <__alltraps>

00102af6 <vector239>:
.globl vector239
vector239:
  pushl $0
  102af6:	6a 00                	push   $0x0
  pushl $239
  102af8:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102afd:	e9 c0 00 00 00       	jmp    102bc2 <__alltraps>

00102b02 <vector240>:
.globl vector240
vector240:
  pushl $0
  102b02:	6a 00                	push   $0x0
  pushl $240
  102b04:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102b09:	e9 b4 00 00 00       	jmp    102bc2 <__alltraps>

00102b0e <vector241>:
.globl vector241
vector241:
  pushl $0
  102b0e:	6a 00                	push   $0x0
  pushl $241
  102b10:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102b15:	e9 a8 00 00 00       	jmp    102bc2 <__alltraps>

00102b1a <vector242>:
.globl vector242
vector242:
  pushl $0
  102b1a:	6a 00                	push   $0x0
  pushl $242
  102b1c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102b21:	e9 9c 00 00 00       	jmp    102bc2 <__alltraps>

00102b26 <vector243>:
.globl vector243
vector243:
  pushl $0
  102b26:	6a 00                	push   $0x0
  pushl $243
  102b28:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102b2d:	e9 90 00 00 00       	jmp    102bc2 <__alltraps>

00102b32 <vector244>:
.globl vector244
vector244:
  pushl $0
  102b32:	6a 00                	push   $0x0
  pushl $244
  102b34:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102b39:	e9 84 00 00 00       	jmp    102bc2 <__alltraps>

00102b3e <vector245>:
.globl vector245
vector245:
  pushl $0
  102b3e:	6a 00                	push   $0x0
  pushl $245
  102b40:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102b45:	e9 78 00 00 00       	jmp    102bc2 <__alltraps>

00102b4a <vector246>:
.globl vector246
vector246:
  pushl $0
  102b4a:	6a 00                	push   $0x0
  pushl $246
  102b4c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102b51:	e9 6c 00 00 00       	jmp    102bc2 <__alltraps>

00102b56 <vector247>:
.globl vector247
vector247:
  pushl $0
  102b56:	6a 00                	push   $0x0
  pushl $247
  102b58:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102b5d:	e9 60 00 00 00       	jmp    102bc2 <__alltraps>

00102b62 <vector248>:
.globl vector248
vector248:
  pushl $0
  102b62:	6a 00                	push   $0x0
  pushl $248
  102b64:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102b69:	e9 54 00 00 00       	jmp    102bc2 <__alltraps>

00102b6e <vector249>:
.globl vector249
vector249:
  pushl $0
  102b6e:	6a 00                	push   $0x0
  pushl $249
  102b70:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102b75:	e9 48 00 00 00       	jmp    102bc2 <__alltraps>

00102b7a <vector250>:
.globl vector250
vector250:
  pushl $0
  102b7a:	6a 00                	push   $0x0
  pushl $250
  102b7c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102b81:	e9 3c 00 00 00       	jmp    102bc2 <__alltraps>

00102b86 <vector251>:
.globl vector251
vector251:
  pushl $0
  102b86:	6a 00                	push   $0x0
  pushl $251
  102b88:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102b8d:	e9 30 00 00 00       	jmp    102bc2 <__alltraps>

00102b92 <vector252>:
.globl vector252
vector252:
  pushl $0
  102b92:	6a 00                	push   $0x0
  pushl $252
  102b94:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102b99:	e9 24 00 00 00       	jmp    102bc2 <__alltraps>

00102b9e <vector253>:
.globl vector253
vector253:
  pushl $0
  102b9e:	6a 00                	push   $0x0
  pushl $253
  102ba0:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102ba5:	e9 18 00 00 00       	jmp    102bc2 <__alltraps>

00102baa <vector254>:
.globl vector254
vector254:
  pushl $0
  102baa:	6a 00                	push   $0x0
  pushl $254
  102bac:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102bb1:	e9 0c 00 00 00       	jmp    102bc2 <__alltraps>

00102bb6 <vector255>:
.globl vector255
vector255:
  pushl $0
  102bb6:	6a 00                	push   $0x0
  pushl $255
  102bb8:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102bbd:	e9 00 00 00 00       	jmp    102bc2 <__alltraps>

00102bc2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102bc2:	1e                   	push   %ds
    pushl %es
  102bc3:	06                   	push   %es
    pushl %fs
  102bc4:	0f a0                	push   %fs
    pushl %gs
  102bc6:	0f a8                	push   %gs
    pushal
  102bc8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102bc9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102bce:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102bd0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102bd2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102bd3:	e8 64 f5 ff ff       	call   10213c <trap>

    # pop the pushed stack pointer
    popl %esp
  102bd8:	5c                   	pop    %esp

00102bd9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102bd9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102bda:	0f a9                	pop    %gs
    popl %fs
  102bdc:	0f a1                	pop    %fs
    popl %es
  102bde:	07                   	pop    %es
    popl %ds
  102bdf:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102be0:	83 c4 08             	add    $0x8,%esp
    iret
  102be3:	cf                   	iret   

00102be4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102be4:	55                   	push   %ebp
  102be5:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102be7:	8b 45 08             	mov    0x8(%ebp),%eax
  102bea:	8b 15 78 bf 11 00    	mov    0x11bf78,%edx
  102bf0:	29 d0                	sub    %edx,%eax
  102bf2:	c1 f8 02             	sar    $0x2,%eax
  102bf5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102bfb:	5d                   	pop    %ebp
  102bfc:	c3                   	ret    

00102bfd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102bfd:	55                   	push   %ebp
  102bfe:	89 e5                	mov    %esp,%ebp
  102c00:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102c03:	8b 45 08             	mov    0x8(%ebp),%eax
  102c06:	89 04 24             	mov    %eax,(%esp)
  102c09:	e8 d6 ff ff ff       	call   102be4 <page2ppn>
  102c0e:	c1 e0 0c             	shl    $0xc,%eax
}
  102c11:	c9                   	leave  
  102c12:	c3                   	ret    

00102c13 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102c13:	55                   	push   %ebp
  102c14:	89 e5                	mov    %esp,%ebp
  102c16:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102c19:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1c:	c1 e8 0c             	shr    $0xc,%eax
  102c1f:	89 c2                	mov    %eax,%edx
  102c21:	a1 80 be 11 00       	mov    0x11be80,%eax
  102c26:	39 c2                	cmp    %eax,%edx
  102c28:	72 1c                	jb     102c46 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102c2a:	c7 44 24 08 70 6a 10 	movl   $0x106a70,0x8(%esp)
  102c31:	00 
  102c32:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102c39:	00 
  102c3a:	c7 04 24 8f 6a 10 00 	movl   $0x106a8f,(%esp)
  102c41:	e8 b3 d7 ff ff       	call   1003f9 <__panic>
    }
    return &pages[PPN(pa)];
  102c46:	8b 0d 78 bf 11 00    	mov    0x11bf78,%ecx
  102c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4f:	c1 e8 0c             	shr    $0xc,%eax
  102c52:	89 c2                	mov    %eax,%edx
  102c54:	89 d0                	mov    %edx,%eax
  102c56:	c1 e0 02             	shl    $0x2,%eax
  102c59:	01 d0                	add    %edx,%eax
  102c5b:	c1 e0 02             	shl    $0x2,%eax
  102c5e:	01 c8                	add    %ecx,%eax
}
  102c60:	c9                   	leave  
  102c61:	c3                   	ret    

00102c62 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102c62:	55                   	push   %ebp
  102c63:	89 e5                	mov    %esp,%ebp
  102c65:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102c68:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6b:	89 04 24             	mov    %eax,(%esp)
  102c6e:	e8 8a ff ff ff       	call   102bfd <page2pa>
  102c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c79:	c1 e8 0c             	shr    $0xc,%eax
  102c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c7f:	a1 80 be 11 00       	mov    0x11be80,%eax
  102c84:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102c87:	72 23                	jb     102cac <page2kva+0x4a>
  102c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c90:	c7 44 24 08 a0 6a 10 	movl   $0x106aa0,0x8(%esp)
  102c97:	00 
  102c98:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102c9f:	00 
  102ca0:	c7 04 24 8f 6a 10 00 	movl   $0x106a8f,(%esp)
  102ca7:	e8 4d d7 ff ff       	call   1003f9 <__panic>
  102cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102caf:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102cb4:	c9                   	leave  
  102cb5:	c3                   	ret    

00102cb6 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102cb6:	55                   	push   %ebp
  102cb7:	89 e5                	mov    %esp,%ebp
  102cb9:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  102cbf:	83 e0 01             	and    $0x1,%eax
  102cc2:	85 c0                	test   %eax,%eax
  102cc4:	75 1c                	jne    102ce2 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102cc6:	c7 44 24 08 c4 6a 10 	movl   $0x106ac4,0x8(%esp)
  102ccd:	00 
  102cce:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102cd5:	00 
  102cd6:	c7 04 24 8f 6a 10 00 	movl   $0x106a8f,(%esp)
  102cdd:	e8 17 d7 ff ff       	call   1003f9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102cea:	89 04 24             	mov    %eax,(%esp)
  102ced:	e8 21 ff ff ff       	call   102c13 <pa2page>
}
  102cf2:	c9                   	leave  
  102cf3:	c3                   	ret    

00102cf4 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102cf4:	55                   	push   %ebp
  102cf5:	89 e5                	mov    %esp,%ebp
  102cf7:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102d02:	89 04 24             	mov    %eax,(%esp)
  102d05:	e8 09 ff ff ff       	call   102c13 <pa2page>
}
  102d0a:	c9                   	leave  
  102d0b:	c3                   	ret    

00102d0c <page_ref>:

static inline int
page_ref(struct Page *page) {
  102d0c:	55                   	push   %ebp
  102d0d:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d12:	8b 00                	mov    (%eax),%eax
}
  102d14:	5d                   	pop    %ebp
  102d15:	c3                   	ret    

00102d16 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102d16:	55                   	push   %ebp
  102d17:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102d19:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d1f:	89 10                	mov    %edx,(%eax)
}
  102d21:	90                   	nop
  102d22:	5d                   	pop    %ebp
  102d23:	c3                   	ret    

00102d24 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102d24:	55                   	push   %ebp
  102d25:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102d27:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2a:	8b 00                	mov    (%eax),%eax
  102d2c:	8d 50 01             	lea    0x1(%eax),%edx
  102d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d32:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102d34:	8b 45 08             	mov    0x8(%ebp),%eax
  102d37:	8b 00                	mov    (%eax),%eax
}
  102d39:	5d                   	pop    %ebp
  102d3a:	c3                   	ret    

00102d3b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102d3b:	55                   	push   %ebp
  102d3c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d41:	8b 00                	mov    (%eax),%eax
  102d43:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d46:	8b 45 08             	mov    0x8(%ebp),%eax
  102d49:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4e:	8b 00                	mov    (%eax),%eax
}
  102d50:	5d                   	pop    %ebp
  102d51:	c3                   	ret    

00102d52 <__intr_save>:
__intr_save(void) {
  102d52:	55                   	push   %ebp
  102d53:	89 e5                	mov    %esp,%ebp
  102d55:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102d58:	9c                   	pushf  
  102d59:	58                   	pop    %eax
  102d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102d60:	25 00 02 00 00       	and    $0x200,%eax
  102d65:	85 c0                	test   %eax,%eax
  102d67:	74 0c                	je     102d75 <__intr_save+0x23>
        intr_disable();
  102d69:	e8 3b eb ff ff       	call   1018a9 <intr_disable>
        return 1;
  102d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  102d73:	eb 05                	jmp    102d7a <__intr_save+0x28>
    return 0;
  102d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d7a:	c9                   	leave  
  102d7b:	c3                   	ret    

00102d7c <__intr_restore>:
__intr_restore(bool flag) {
  102d7c:	55                   	push   %ebp
  102d7d:	89 e5                	mov    %esp,%ebp
  102d7f:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102d82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102d86:	74 05                	je     102d8d <__intr_restore+0x11>
        intr_enable();
  102d88:	e8 15 eb ff ff       	call   1018a2 <intr_enable>
}
  102d8d:	90                   	nop
  102d8e:	c9                   	leave  
  102d8f:	c3                   	ret    

00102d90 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102d90:	55                   	push   %ebp
  102d91:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102d93:	8b 45 08             	mov    0x8(%ebp),%eax
  102d96:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102d99:	b8 23 00 00 00       	mov    $0x23,%eax
  102d9e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102da0:	b8 23 00 00 00       	mov    $0x23,%eax
  102da5:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102da7:	b8 10 00 00 00       	mov    $0x10,%eax
  102dac:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102dae:	b8 10 00 00 00       	mov    $0x10,%eax
  102db3:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102db5:	b8 10 00 00 00       	mov    $0x10,%eax
  102dba:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102dbc:	ea c3 2d 10 00 08 00 	ljmp   $0x8,$0x102dc3
}
  102dc3:	90                   	nop
  102dc4:	5d                   	pop    %ebp
  102dc5:	c3                   	ret    

00102dc6 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102dc6:	55                   	push   %ebp
  102dc7:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcc:	a3 a4 be 11 00       	mov    %eax,0x11bea4
}
  102dd1:	90                   	nop
  102dd2:	5d                   	pop    %ebp
  102dd3:	c3                   	ret    

00102dd4 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102dd4:	55                   	push   %ebp
  102dd5:	89 e5                	mov    %esp,%ebp
  102dd7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102dda:	b8 00 80 11 00       	mov    $0x118000,%eax
  102ddf:	89 04 24             	mov    %eax,(%esp)
  102de2:	e8 df ff ff ff       	call   102dc6 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102de7:	66 c7 05 a8 be 11 00 	movw   $0x10,0x11bea8
  102dee:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102df0:	66 c7 05 28 8a 11 00 	movw   $0x68,0x118a28
  102df7:	68 00 
  102df9:	b8 a0 be 11 00       	mov    $0x11bea0,%eax
  102dfe:	0f b7 c0             	movzwl %ax,%eax
  102e01:	66 a3 2a 8a 11 00    	mov    %ax,0x118a2a
  102e07:	b8 a0 be 11 00       	mov    $0x11bea0,%eax
  102e0c:	c1 e8 10             	shr    $0x10,%eax
  102e0f:	a2 2c 8a 11 00       	mov    %al,0x118a2c
  102e14:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  102e1b:	24 f0                	and    $0xf0,%al
  102e1d:	0c 09                	or     $0x9,%al
  102e1f:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  102e24:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  102e2b:	24 ef                	and    $0xef,%al
  102e2d:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  102e32:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  102e39:	24 9f                	and    $0x9f,%al
  102e3b:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  102e40:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  102e47:	0c 80                	or     $0x80,%al
  102e49:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  102e4e:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102e55:	24 f0                	and    $0xf0,%al
  102e57:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102e5c:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102e63:	24 ef                	and    $0xef,%al
  102e65:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102e6a:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102e71:	24 df                	and    $0xdf,%al
  102e73:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102e78:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102e7f:	0c 40                	or     $0x40,%al
  102e81:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102e86:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102e8d:	24 7f                	and    $0x7f,%al
  102e8f:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102e94:	b8 a0 be 11 00       	mov    $0x11bea0,%eax
  102e99:	c1 e8 18             	shr    $0x18,%eax
  102e9c:	a2 2f 8a 11 00       	mov    %al,0x118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102ea1:	c7 04 24 30 8a 11 00 	movl   $0x118a30,(%esp)
  102ea8:	e8 e3 fe ff ff       	call   102d90 <lgdt>
  102ead:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102eb3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102eb7:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102eba:	90                   	nop
  102ebb:	c9                   	leave  
  102ebc:	c3                   	ret    

00102ebd <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102ebd:	55                   	push   %ebp
  102ebe:	89 e5                	mov    %esp,%ebp
  102ec0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102ec3:	c7 05 70 bf 11 00 98 	movl   $0x107498,0x11bf70
  102eca:	74 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102ecd:	a1 70 bf 11 00       	mov    0x11bf70,%eax
  102ed2:	8b 00                	mov    (%eax),%eax
  102ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed8:	c7 04 24 f0 6a 10 00 	movl   $0x106af0,(%esp)
  102edf:	e8 be d3 ff ff       	call   1002a2 <cprintf>
    pmm_manager->init();
  102ee4:	a1 70 bf 11 00       	mov    0x11bf70,%eax
  102ee9:	8b 40 04             	mov    0x4(%eax),%eax
  102eec:	ff d0                	call   *%eax
}
  102eee:	90                   	nop
  102eef:	c9                   	leave  
  102ef0:	c3                   	ret    

00102ef1 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102ef1:	55                   	push   %ebp
  102ef2:	89 e5                	mov    %esp,%ebp
  102ef4:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102ef7:	a1 70 bf 11 00       	mov    0x11bf70,%eax
  102efc:	8b 40 08             	mov    0x8(%eax),%eax
  102eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f02:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f06:	8b 55 08             	mov    0x8(%ebp),%edx
  102f09:	89 14 24             	mov    %edx,(%esp)
  102f0c:	ff d0                	call   *%eax
}
  102f0e:	90                   	nop
  102f0f:	c9                   	leave  
  102f10:	c3                   	ret    

00102f11 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102f11:	55                   	push   %ebp
  102f12:	89 e5                	mov    %esp,%ebp
  102f14:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102f17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102f1e:	e8 2f fe ff ff       	call   102d52 <__intr_save>
  102f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102f26:	a1 70 bf 11 00       	mov    0x11bf70,%eax
  102f2b:	8b 40 0c             	mov    0xc(%eax),%eax
  102f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  102f31:	89 14 24             	mov    %edx,(%esp)
  102f34:	ff d0                	call   *%eax
  102f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f3c:	89 04 24             	mov    %eax,(%esp)
  102f3f:	e8 38 fe ff ff       	call   102d7c <__intr_restore>
    return page;
  102f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f47:	c9                   	leave  
  102f48:	c3                   	ret    

00102f49 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102f49:	55                   	push   %ebp
  102f4a:	89 e5                	mov    %esp,%ebp
  102f4c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102f4f:	e8 fe fd ff ff       	call   102d52 <__intr_save>
  102f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102f57:	a1 70 bf 11 00       	mov    0x11bf70,%eax
  102f5c:	8b 40 10             	mov    0x10(%eax),%eax
  102f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f62:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f66:	8b 55 08             	mov    0x8(%ebp),%edx
  102f69:	89 14 24             	mov    %edx,(%esp)
  102f6c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f71:	89 04 24             	mov    %eax,(%esp)
  102f74:	e8 03 fe ff ff       	call   102d7c <__intr_restore>
}
  102f79:	90                   	nop
  102f7a:	c9                   	leave  
  102f7b:	c3                   	ret    

00102f7c <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102f7c:	55                   	push   %ebp
  102f7d:	89 e5                	mov    %esp,%ebp
  102f7f:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102f82:	e8 cb fd ff ff       	call   102d52 <__intr_save>
  102f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102f8a:	a1 70 bf 11 00       	mov    0x11bf70,%eax
  102f8f:	8b 40 14             	mov    0x14(%eax),%eax
  102f92:	ff d0                	call   *%eax
  102f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f9a:	89 04 24             	mov    %eax,(%esp)
  102f9d:	e8 da fd ff ff       	call   102d7c <__intr_restore>
    return ret;
  102fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102fa5:	c9                   	leave  
  102fa6:	c3                   	ret    

00102fa7 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102fa7:	55                   	push   %ebp
  102fa8:	89 e5                	mov    %esp,%ebp
  102faa:	57                   	push   %edi
  102fab:	56                   	push   %esi
  102fac:	53                   	push   %ebx
  102fad:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102fb3:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102fba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102fc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102fc8:	c7 04 24 07 6b 10 00 	movl   $0x106b07,(%esp)
  102fcf:	e8 ce d2 ff ff       	call   1002a2 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102fd4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fdb:	e9 22 01 00 00       	jmp    103102 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102fe0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fe3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fe6:	89 d0                	mov    %edx,%eax
  102fe8:	c1 e0 02             	shl    $0x2,%eax
  102feb:	01 d0                	add    %edx,%eax
  102fed:	c1 e0 02             	shl    $0x2,%eax
  102ff0:	01 c8                	add    %ecx,%eax
  102ff2:	8b 50 08             	mov    0x8(%eax),%edx
  102ff5:	8b 40 04             	mov    0x4(%eax),%eax
  102ff8:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102ffb:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102ffe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103001:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103004:	89 d0                	mov    %edx,%eax
  103006:	c1 e0 02             	shl    $0x2,%eax
  103009:	01 d0                	add    %edx,%eax
  10300b:	c1 e0 02             	shl    $0x2,%eax
  10300e:	01 c8                	add    %ecx,%eax
  103010:	8b 48 0c             	mov    0xc(%eax),%ecx
  103013:	8b 58 10             	mov    0x10(%eax),%ebx
  103016:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103019:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10301c:	01 c8                	add    %ecx,%eax
  10301e:	11 da                	adc    %ebx,%edx
  103020:	89 45 98             	mov    %eax,-0x68(%ebp)
  103023:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103026:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103029:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10302c:	89 d0                	mov    %edx,%eax
  10302e:	c1 e0 02             	shl    $0x2,%eax
  103031:	01 d0                	add    %edx,%eax
  103033:	c1 e0 02             	shl    $0x2,%eax
  103036:	01 c8                	add    %ecx,%eax
  103038:	83 c0 14             	add    $0x14,%eax
  10303b:	8b 00                	mov    (%eax),%eax
  10303d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  103040:	8b 45 98             	mov    -0x68(%ebp),%eax
  103043:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103046:	83 c0 ff             	add    $0xffffffff,%eax
  103049:	83 d2 ff             	adc    $0xffffffff,%edx
  10304c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  103052:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  103058:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10305b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10305e:	89 d0                	mov    %edx,%eax
  103060:	c1 e0 02             	shl    $0x2,%eax
  103063:	01 d0                	add    %edx,%eax
  103065:	c1 e0 02             	shl    $0x2,%eax
  103068:	01 c8                	add    %ecx,%eax
  10306a:	8b 48 0c             	mov    0xc(%eax),%ecx
  10306d:	8b 58 10             	mov    0x10(%eax),%ebx
  103070:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103073:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  103077:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  10307d:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  103083:	89 44 24 14          	mov    %eax,0x14(%esp)
  103087:	89 54 24 18          	mov    %edx,0x18(%esp)
  10308b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10308e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103091:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103095:	89 54 24 10          	mov    %edx,0x10(%esp)
  103099:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  10309d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1030a1:	c7 04 24 14 6b 10 00 	movl   $0x106b14,(%esp)
  1030a8:	e8 f5 d1 ff ff       	call   1002a2 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1030ad:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030b3:	89 d0                	mov    %edx,%eax
  1030b5:	c1 e0 02             	shl    $0x2,%eax
  1030b8:	01 d0                	add    %edx,%eax
  1030ba:	c1 e0 02             	shl    $0x2,%eax
  1030bd:	01 c8                	add    %ecx,%eax
  1030bf:	83 c0 14             	add    $0x14,%eax
  1030c2:	8b 00                	mov    (%eax),%eax
  1030c4:	83 f8 01             	cmp    $0x1,%eax
  1030c7:	75 36                	jne    1030ff <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
  1030c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1030cf:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  1030d2:	77 2b                	ja     1030ff <page_init+0x158>
  1030d4:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  1030d7:	72 05                	jb     1030de <page_init+0x137>
  1030d9:	3b 45 98             	cmp    -0x68(%ebp),%eax
  1030dc:	73 21                	jae    1030ff <page_init+0x158>
  1030de:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1030e2:	77 1b                	ja     1030ff <page_init+0x158>
  1030e4:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1030e8:	72 09                	jb     1030f3 <page_init+0x14c>
  1030ea:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
  1030f1:	77 0c                	ja     1030ff <page_init+0x158>
                maxpa = end;
  1030f3:	8b 45 98             	mov    -0x68(%ebp),%eax
  1030f6:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1030f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1030fc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  1030ff:	ff 45 dc             	incl   -0x24(%ebp)
  103102:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103105:	8b 00                	mov    (%eax),%eax
  103107:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10310a:	0f 8c d0 fe ff ff    	jl     102fe0 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103110:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103114:	72 1d                	jb     103133 <page_init+0x18c>
  103116:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10311a:	77 09                	ja     103125 <page_init+0x17e>
  10311c:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103123:	76 0e                	jbe    103133 <page_init+0x18c>
        maxpa = KMEMSIZE;
  103125:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10312c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103133:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103136:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103139:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10313d:	c1 ea 0c             	shr    $0xc,%edx
  103140:	89 c1                	mov    %eax,%ecx
  103142:	89 d3                	mov    %edx,%ebx
  103144:	89 c8                	mov    %ecx,%eax
  103146:	a3 80 be 11 00       	mov    %eax,0x11be80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10314b:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  103152:	b8 88 bf 11 00       	mov    $0x11bf88,%eax
  103157:	8d 50 ff             	lea    -0x1(%eax),%edx
  10315a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10315d:	01 d0                	add    %edx,%eax
  10315f:	89 45 bc             	mov    %eax,-0x44(%ebp)
  103162:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103165:	ba 00 00 00 00       	mov    $0x0,%edx
  10316a:	f7 75 c0             	divl   -0x40(%ebp)
  10316d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103170:	29 d0                	sub    %edx,%eax
  103172:	a3 78 bf 11 00       	mov    %eax,0x11bf78

    for (i = 0; i < npage; i ++) {
  103177:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10317e:	eb 2e                	jmp    1031ae <page_init+0x207>
        SetPageReserved(pages + i);
  103180:	8b 0d 78 bf 11 00    	mov    0x11bf78,%ecx
  103186:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103189:	89 d0                	mov    %edx,%eax
  10318b:	c1 e0 02             	shl    $0x2,%eax
  10318e:	01 d0                	add    %edx,%eax
  103190:	c1 e0 02             	shl    $0x2,%eax
  103193:	01 c8                	add    %ecx,%eax
  103195:	83 c0 04             	add    $0x4,%eax
  103198:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  10319f:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1031a2:	8b 45 90             	mov    -0x70(%ebp),%eax
  1031a5:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1031a8:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  1031ab:	ff 45 dc             	incl   -0x24(%ebp)
  1031ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031b1:	a1 80 be 11 00       	mov    0x11be80,%eax
  1031b6:	39 c2                	cmp    %eax,%edx
  1031b8:	72 c6                	jb     103180 <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1031ba:	8b 15 80 be 11 00    	mov    0x11be80,%edx
  1031c0:	89 d0                	mov    %edx,%eax
  1031c2:	c1 e0 02             	shl    $0x2,%eax
  1031c5:	01 d0                	add    %edx,%eax
  1031c7:	c1 e0 02             	shl    $0x2,%eax
  1031ca:	89 c2                	mov    %eax,%edx
  1031cc:	a1 78 bf 11 00       	mov    0x11bf78,%eax
  1031d1:	01 d0                	add    %edx,%eax
  1031d3:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1031d6:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  1031dd:	77 23                	ja     103202 <page_init+0x25b>
  1031df:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1031e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1031e6:	c7 44 24 08 44 6b 10 	movl   $0x106b44,0x8(%esp)
  1031ed:	00 
  1031ee:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  1031f5:	00 
  1031f6:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1031fd:	e8 f7 d1 ff ff       	call   1003f9 <__panic>
  103202:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103205:	05 00 00 00 40       	add    $0x40000000,%eax
  10320a:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10320d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103214:	e9 69 01 00 00       	jmp    103382 <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103219:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10321c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10321f:	89 d0                	mov    %edx,%eax
  103221:	c1 e0 02             	shl    $0x2,%eax
  103224:	01 d0                	add    %edx,%eax
  103226:	c1 e0 02             	shl    $0x2,%eax
  103229:	01 c8                	add    %ecx,%eax
  10322b:	8b 50 08             	mov    0x8(%eax),%edx
  10322e:	8b 40 04             	mov    0x4(%eax),%eax
  103231:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103234:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103237:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10323a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10323d:	89 d0                	mov    %edx,%eax
  10323f:	c1 e0 02             	shl    $0x2,%eax
  103242:	01 d0                	add    %edx,%eax
  103244:	c1 e0 02             	shl    $0x2,%eax
  103247:	01 c8                	add    %ecx,%eax
  103249:	8b 48 0c             	mov    0xc(%eax),%ecx
  10324c:	8b 58 10             	mov    0x10(%eax),%ebx
  10324f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103252:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103255:	01 c8                	add    %ecx,%eax
  103257:	11 da                	adc    %ebx,%edx
  103259:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10325c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10325f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103262:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103265:	89 d0                	mov    %edx,%eax
  103267:	c1 e0 02             	shl    $0x2,%eax
  10326a:	01 d0                	add    %edx,%eax
  10326c:	c1 e0 02             	shl    $0x2,%eax
  10326f:	01 c8                	add    %ecx,%eax
  103271:	83 c0 14             	add    $0x14,%eax
  103274:	8b 00                	mov    (%eax),%eax
  103276:	83 f8 01             	cmp    $0x1,%eax
  103279:	0f 85 00 01 00 00    	jne    10337f <page_init+0x3d8>
            if (begin < freemem) {
  10327f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103282:	ba 00 00 00 00       	mov    $0x0,%edx
  103287:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10328a:	77 17                	ja     1032a3 <page_init+0x2fc>
  10328c:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10328f:	72 05                	jb     103296 <page_init+0x2ef>
  103291:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103294:	73 0d                	jae    1032a3 <page_init+0x2fc>
                begin = freemem;
  103296:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103299:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10329c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1032a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1032a7:	72 1d                	jb     1032c6 <page_init+0x31f>
  1032a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1032ad:	77 09                	ja     1032b8 <page_init+0x311>
  1032af:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1032b6:	76 0e                	jbe    1032c6 <page_init+0x31f>
                end = KMEMSIZE;
  1032b8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1032bf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1032c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1032cc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1032cf:	0f 87 aa 00 00 00    	ja     10337f <page_init+0x3d8>
  1032d5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1032d8:	72 09                	jb     1032e3 <page_init+0x33c>
  1032da:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1032dd:	0f 83 9c 00 00 00    	jae    10337f <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
  1032e3:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  1032ea:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1032ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1032f0:	01 d0                	add    %edx,%eax
  1032f2:	48                   	dec    %eax
  1032f3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1032f6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1032f9:	ba 00 00 00 00       	mov    $0x0,%edx
  1032fe:	f7 75 b0             	divl   -0x50(%ebp)
  103301:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103304:	29 d0                	sub    %edx,%eax
  103306:	ba 00 00 00 00       	mov    $0x0,%edx
  10330b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10330e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103311:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103314:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103317:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10331a:	ba 00 00 00 00       	mov    $0x0,%edx
  10331f:	89 c3                	mov    %eax,%ebx
  103321:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  103327:	89 de                	mov    %ebx,%esi
  103329:	89 d0                	mov    %edx,%eax
  10332b:	83 e0 00             	and    $0x0,%eax
  10332e:	89 c7                	mov    %eax,%edi
  103330:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103333:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  103336:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103339:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10333c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10333f:	77 3e                	ja     10337f <page_init+0x3d8>
  103341:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103344:	72 05                	jb     10334b <page_init+0x3a4>
  103346:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103349:	73 34                	jae    10337f <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10334b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10334e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103351:	2b 45 d0             	sub    -0x30(%ebp),%eax
  103354:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  103357:	89 c1                	mov    %eax,%ecx
  103359:	89 d3                	mov    %edx,%ebx
  10335b:	89 c8                	mov    %ecx,%eax
  10335d:	89 da                	mov    %ebx,%edx
  10335f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103363:	c1 ea 0c             	shr    $0xc,%edx
  103366:	89 c3                	mov    %eax,%ebx
  103368:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10336b:	89 04 24             	mov    %eax,(%esp)
  10336e:	e8 a0 f8 ff ff       	call   102c13 <pa2page>
  103373:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103377:	89 04 24             	mov    %eax,(%esp)
  10337a:	e8 72 fb ff ff       	call   102ef1 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10337f:	ff 45 dc             	incl   -0x24(%ebp)
  103382:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103385:	8b 00                	mov    (%eax),%eax
  103387:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10338a:	0f 8c 89 fe ff ff    	jl     103219 <page_init+0x272>
                }
            }
        }
    }
}
  103390:	90                   	nop
  103391:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103397:	5b                   	pop    %ebx
  103398:	5e                   	pop    %esi
  103399:	5f                   	pop    %edi
  10339a:	5d                   	pop    %ebp
  10339b:	c3                   	ret    

0010339c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10339c:	55                   	push   %ebp
  10339d:	89 e5                	mov    %esp,%ebp
  10339f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1033a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033a5:	33 45 14             	xor    0x14(%ebp),%eax
  1033a8:	25 ff 0f 00 00       	and    $0xfff,%eax
  1033ad:	85 c0                	test   %eax,%eax
  1033af:	74 24                	je     1033d5 <boot_map_segment+0x39>
  1033b1:	c7 44 24 0c 76 6b 10 	movl   $0x106b76,0xc(%esp)
  1033b8:	00 
  1033b9:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  1033c0:	00 
  1033c1:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1033c8:	00 
  1033c9:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1033d0:	e8 24 d0 ff ff       	call   1003f9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1033d5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1033dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033df:	25 ff 0f 00 00       	and    $0xfff,%eax
  1033e4:	89 c2                	mov    %eax,%edx
  1033e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1033e9:	01 c2                	add    %eax,%edx
  1033eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033ee:	01 d0                	add    %edx,%eax
  1033f0:	48                   	dec    %eax
  1033f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033f7:	ba 00 00 00 00       	mov    $0x0,%edx
  1033fc:	f7 75 f0             	divl   -0x10(%ebp)
  1033ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103402:	29 d0                	sub    %edx,%eax
  103404:	c1 e8 0c             	shr    $0xc,%eax
  103407:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10340a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10340d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103410:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103413:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103418:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10341b:	8b 45 14             	mov    0x14(%ebp),%eax
  10341e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103424:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103429:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10342c:	eb 68                	jmp    103496 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10342e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103435:	00 
  103436:	8b 45 0c             	mov    0xc(%ebp),%eax
  103439:	89 44 24 04          	mov    %eax,0x4(%esp)
  10343d:	8b 45 08             	mov    0x8(%ebp),%eax
  103440:	89 04 24             	mov    %eax,(%esp)
  103443:	e8 81 01 00 00       	call   1035c9 <get_pte>
  103448:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10344b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10344f:	75 24                	jne    103475 <boot_map_segment+0xd9>
  103451:	c7 44 24 0c a2 6b 10 	movl   $0x106ba2,0xc(%esp)
  103458:	00 
  103459:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103460:	00 
  103461:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103468:	00 
  103469:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103470:	e8 84 cf ff ff       	call   1003f9 <__panic>
        *ptep = pa | PTE_P | perm;
  103475:	8b 45 14             	mov    0x14(%ebp),%eax
  103478:	0b 45 18             	or     0x18(%ebp),%eax
  10347b:	83 c8 01             	or     $0x1,%eax
  10347e:	89 c2                	mov    %eax,%edx
  103480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103483:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103485:	ff 4d f4             	decl   -0xc(%ebp)
  103488:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10348f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10349a:	75 92                	jne    10342e <boot_map_segment+0x92>
    }
}
  10349c:	90                   	nop
  10349d:	c9                   	leave  
  10349e:	c3                   	ret    

0010349f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10349f:	55                   	push   %ebp
  1034a0:	89 e5                	mov    %esp,%ebp
  1034a2:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1034a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034ac:	e8 60 fa ff ff       	call   102f11 <alloc_pages>
  1034b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1034b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034b8:	75 1c                	jne    1034d6 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1034ba:	c7 44 24 08 af 6b 10 	movl   $0x106baf,0x8(%esp)
  1034c1:	00 
  1034c2:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1034c9:	00 
  1034ca:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1034d1:	e8 23 cf ff ff       	call   1003f9 <__panic>
    }
    return page2kva(p);
  1034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034d9:	89 04 24             	mov    %eax,(%esp)
  1034dc:	e8 81 f7 ff ff       	call   102c62 <page2kva>
}
  1034e1:	c9                   	leave  
  1034e2:	c3                   	ret    

001034e3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1034e3:	55                   	push   %ebp
  1034e4:	89 e5                	mov    %esp,%ebp
  1034e6:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1034e9:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1034ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1034f1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1034f8:	77 23                	ja     10351d <pmm_init+0x3a>
  1034fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103501:	c7 44 24 08 44 6b 10 	movl   $0x106b44,0x8(%esp)
  103508:	00 
  103509:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  103510:	00 
  103511:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103518:	e8 dc ce ff ff       	call   1003f9 <__panic>
  10351d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103520:	05 00 00 00 40       	add    $0x40000000,%eax
  103525:	a3 74 bf 11 00       	mov    %eax,0x11bf74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10352a:	e8 8e f9 ff ff       	call   102ebd <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10352f:	e8 73 fa ff ff       	call   102fa7 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103534:	e8 de 03 00 00       	call   103917 <check_alloc_page>

    check_pgdir();
  103539:	e8 f8 03 00 00       	call   103936 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10353e:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103543:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103546:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10354d:	77 23                	ja     103572 <pmm_init+0x8f>
  10354f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103552:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103556:	c7 44 24 08 44 6b 10 	movl   $0x106b44,0x8(%esp)
  10355d:	00 
  10355e:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  103565:	00 
  103566:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  10356d:	e8 87 ce ff ff       	call   1003f9 <__panic>
  103572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103575:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10357b:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103580:	05 ac 0f 00 00       	add    $0xfac,%eax
  103585:	83 ca 03             	or     $0x3,%edx
  103588:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10358a:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10358f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103596:	00 
  103597:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10359e:	00 
  10359f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1035a6:	38 
  1035a7:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1035ae:	c0 
  1035af:	89 04 24             	mov    %eax,(%esp)
  1035b2:	e8 e5 fd ff ff       	call   10339c <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1035b7:	e8 18 f8 ff ff       	call   102dd4 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1035bc:	e8 11 0a 00 00       	call   103fd2 <check_boot_pgdir>

    print_pgdir();
  1035c1:	e8 8a 0e 00 00       	call   104450 <print_pgdir>

}
  1035c6:	90                   	nop
  1035c7:	c9                   	leave  
  1035c8:	c3                   	ret    

001035c9 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1035c9:	55                   	push   %ebp
  1035ca:	89 e5                	mov    %esp,%ebp
  1035cc:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];//获取二级页表的地址
  1035cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035d2:	c1 e8 16             	shr    $0x16,%eax
  1035d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1035dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1035df:	01 d0                	add    %edx,%eax
  1035e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {//如果该二级页表还没有分配物理空间
  1035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035e7:	8b 00                	mov    (%eax),%eax
  1035e9:	83 e0 01             	and    $0x1,%eax
  1035ec:	85 c0                	test   %eax,%eax
  1035ee:	0f 85 af 00 00 00    	jne    1036a3 <get_pte+0xda>
        struct Page *page;//分配一个
        if (!create || (page = alloc_page()) == NULL) {
  1035f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1035f8:	74 15                	je     10360f <get_pte+0x46>
  1035fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103601:	e8 0b f9 ff ff       	call   102f11 <alloc_pages>
  103606:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10360d:	75 0a                	jne    103619 <get_pte+0x50>
            return NULL;
  10360f:	b8 00 00 00 00       	mov    $0x0,%eax
  103614:	e9 e7 00 00 00       	jmp    103700 <get_pte+0x137>
        }
        //下面都是给新页初始化属性
        set_page_ref(page, 1);
  103619:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103620:	00 
  103621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103624:	89 04 24             	mov    %eax,(%esp)
  103627:	e8 ea f6 ff ff       	call   102d16 <set_page_ref>
        uintptr_t pa = page2pa(page);
  10362c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10362f:	89 04 24             	mov    %eax,(%esp)
  103632:	e8 c6 f5 ff ff       	call   102bfd <page2pa>
  103637:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  10363a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10363d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103643:	c1 e8 0c             	shr    $0xc,%eax
  103646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103649:	a1 80 be 11 00       	mov    0x11be80,%eax
  10364e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103651:	72 23                	jb     103676 <get_pte+0xad>
  103653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103656:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10365a:	c7 44 24 08 a0 6a 10 	movl   $0x106aa0,0x8(%esp)
  103661:	00 
  103662:	c7 44 24 04 73 01 00 	movl   $0x173,0x4(%esp)
  103669:	00 
  10366a:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103671:	e8 83 cd ff ff       	call   1003f9 <__panic>
  103676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103679:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10367e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103685:	00 
  103686:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10368d:	00 
  10368e:	89 04 24             	mov    %eax,(%esp)
  103691:	e8 96 24 00 00       	call   105b2c <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  103696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103699:	83 c8 07             	or     $0x7,%eax
  10369c:	89 c2                	mov    %eax,%edx
  10369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036a1:	89 10                	mov    %edx,(%eax)
        //得到一个被引用数为1，内容为空，权限极低的二级页表页
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];//通过查二级页表返回对应页表项的地址
  1036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036a6:	8b 00                	mov    (%eax),%eax
  1036a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1036ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1036b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036b3:	c1 e8 0c             	shr    $0xc,%eax
  1036b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1036b9:	a1 80 be 11 00       	mov    0x11be80,%eax
  1036be:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1036c1:	72 23                	jb     1036e6 <get_pte+0x11d>
  1036c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036ca:	c7 44 24 08 a0 6a 10 	movl   $0x106aa0,0x8(%esp)
  1036d1:	00 
  1036d2:	c7 44 24 04 77 01 00 	movl   $0x177,0x4(%esp)
  1036d9:	00 
  1036da:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1036e1:	e8 13 cd ff ff       	call   1003f9 <__panic>
  1036e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036e9:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1036ee:	89 c2                	mov    %eax,%edx
  1036f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f3:	c1 e8 0c             	shr    $0xc,%eax
  1036f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  1036fb:	c1 e0 02             	shl    $0x2,%eax
  1036fe:	01 d0                	add    %edx,%eax
}
  103700:	c9                   	leave  
  103701:	c3                   	ret    

00103702 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103702:	55                   	push   %ebp
  103703:	89 e5                	mov    %esp,%ebp
  103705:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103708:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10370f:	00 
  103710:	8b 45 0c             	mov    0xc(%ebp),%eax
  103713:	89 44 24 04          	mov    %eax,0x4(%esp)
  103717:	8b 45 08             	mov    0x8(%ebp),%eax
  10371a:	89 04 24             	mov    %eax,(%esp)
  10371d:	e8 a7 fe ff ff       	call   1035c9 <get_pte>
  103722:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103725:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103729:	74 08                	je     103733 <get_page+0x31>
        *ptep_store = ptep;
  10372b:	8b 45 10             	mov    0x10(%ebp),%eax
  10372e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103731:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103733:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103737:	74 1b                	je     103754 <get_page+0x52>
  103739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10373c:	8b 00                	mov    (%eax),%eax
  10373e:	83 e0 01             	and    $0x1,%eax
  103741:	85 c0                	test   %eax,%eax
  103743:	74 0f                	je     103754 <get_page+0x52>
        return pte2page(*ptep);
  103745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103748:	8b 00                	mov    (%eax),%eax
  10374a:	89 04 24             	mov    %eax,(%esp)
  10374d:	e8 64 f5 ff ff       	call   102cb6 <pte2page>
  103752:	eb 05                	jmp    103759 <get_page+0x57>
    }
    return NULL;
  103754:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103759:	c9                   	leave  
  10375a:	c3                   	ret    

0010375b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10375b:	55                   	push   %ebp
  10375c:	89 e5                	mov    %esp,%ebp
  10375e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
        if (*ptep & PTE_P) {//如果逻辑地址所映射到的page，已经分配了内存
  103761:	8b 45 10             	mov    0x10(%ebp),%eax
  103764:	8b 00                	mov    (%eax),%eax
  103766:	83 e0 01             	and    $0x1,%eax
  103769:	85 c0                	test   %eax,%eax
  10376b:	74 4d                	je     1037ba <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);//通过宏，得到二级页表项所指向的page
  10376d:	8b 45 10             	mov    0x10(%ebp),%eax
  103770:	8b 00                	mov    (%eax),%eax
  103772:	89 04 24             	mov    %eax,(%esp)
  103775:	e8 3c f5 ff ff       	call   102cb6 <pte2page>
  10377a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {//由于这个逻辑地址不再指向page了，所以page少了一次引用次数
  10377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103780:	89 04 24             	mov    %eax,(%esp)
  103783:	e8 b3 f5 ff ff       	call   102d3b <page_ref_dec>
  103788:	85 c0                	test   %eax,%eax
  10378a:	75 13                	jne    10379f <page_remove_pte+0x44>
            free_page(page);//如果page的被引用次数为0，就释放掉该页
  10378c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103793:	00 
  103794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103797:	89 04 24             	mov    %eax,(%esp)
  10379a:	e8 aa f7 ff ff       	call   102f49 <free_pages>
        }
        *ptep = 0;//讲该二级页表项清空
  10379f:	8b 45 10             	mov    0x10(%ebp),%eax
  1037a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);//TLB更新
  1037a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037af:	8b 45 08             	mov    0x8(%ebp),%eax
  1037b2:	89 04 24             	mov    %eax,(%esp)
  1037b5:	e8 01 01 00 00       	call   1038bb <tlb_invalidate>
    }
}
  1037ba:	90                   	nop
  1037bb:	c9                   	leave  
  1037bc:	c3                   	ret    

001037bd <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1037bd:	55                   	push   %ebp
  1037be:	89 e5                	mov    %esp,%ebp
  1037c0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1037c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037ca:	00 
  1037cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1037d5:	89 04 24             	mov    %eax,(%esp)
  1037d8:	e8 ec fd ff ff       	call   1035c9 <get_pte>
  1037dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1037e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1037e4:	74 19                	je     1037ff <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1037e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1037ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1037f7:	89 04 24             	mov    %eax,(%esp)
  1037fa:	e8 5c ff ff ff       	call   10375b <page_remove_pte>
    }
}
  1037ff:	90                   	nop
  103800:	c9                   	leave  
  103801:	c3                   	ret    

00103802 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103802:	55                   	push   %ebp
  103803:	89 e5                	mov    %esp,%ebp
  103805:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103808:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10380f:	00 
  103810:	8b 45 10             	mov    0x10(%ebp),%eax
  103813:	89 44 24 04          	mov    %eax,0x4(%esp)
  103817:	8b 45 08             	mov    0x8(%ebp),%eax
  10381a:	89 04 24             	mov    %eax,(%esp)
  10381d:	e8 a7 fd ff ff       	call   1035c9 <get_pte>
  103822:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103829:	75 0a                	jne    103835 <page_insert+0x33>
        return -E_NO_MEM;
  10382b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103830:	e9 84 00 00 00       	jmp    1038b9 <page_insert+0xb7>
    }
    page_ref_inc(page);
  103835:	8b 45 0c             	mov    0xc(%ebp),%eax
  103838:	89 04 24             	mov    %eax,(%esp)
  10383b:	e8 e4 f4 ff ff       	call   102d24 <page_ref_inc>
    if (*ptep & PTE_P) {
  103840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103843:	8b 00                	mov    (%eax),%eax
  103845:	83 e0 01             	and    $0x1,%eax
  103848:	85 c0                	test   %eax,%eax
  10384a:	74 3e                	je     10388a <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10384f:	8b 00                	mov    (%eax),%eax
  103851:	89 04 24             	mov    %eax,(%esp)
  103854:	e8 5d f4 ff ff       	call   102cb6 <pte2page>
  103859:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10385c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10385f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103862:	75 0d                	jne    103871 <page_insert+0x6f>
            page_ref_dec(page);
  103864:	8b 45 0c             	mov    0xc(%ebp),%eax
  103867:	89 04 24             	mov    %eax,(%esp)
  10386a:	e8 cc f4 ff ff       	call   102d3b <page_ref_dec>
  10386f:	eb 19                	jmp    10388a <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103874:	89 44 24 08          	mov    %eax,0x8(%esp)
  103878:	8b 45 10             	mov    0x10(%ebp),%eax
  10387b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10387f:	8b 45 08             	mov    0x8(%ebp),%eax
  103882:	89 04 24             	mov    %eax,(%esp)
  103885:	e8 d1 fe ff ff       	call   10375b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10388a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10388d:	89 04 24             	mov    %eax,(%esp)
  103890:	e8 68 f3 ff ff       	call   102bfd <page2pa>
  103895:	0b 45 14             	or     0x14(%ebp),%eax
  103898:	83 c8 01             	or     $0x1,%eax
  10389b:	89 c2                	mov    %eax,%edx
  10389d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038a0:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1038a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1038a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1038ac:	89 04 24             	mov    %eax,(%esp)
  1038af:	e8 07 00 00 00       	call   1038bb <tlb_invalidate>
    return 0;
  1038b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1038b9:	c9                   	leave  
  1038ba:	c3                   	ret    

001038bb <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1038bb:	55                   	push   %ebp
  1038bc:	89 e5                	mov    %esp,%ebp
  1038be:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1038c1:	0f 20 d8             	mov    %cr3,%eax
  1038c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1038c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1038ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1038cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1038d0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1038d7:	77 23                	ja     1038fc <tlb_invalidate+0x41>
  1038d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1038e0:	c7 44 24 08 44 6b 10 	movl   $0x106b44,0x8(%esp)
  1038e7:	00 
  1038e8:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  1038ef:	00 
  1038f0:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1038f7:	e8 fd ca ff ff       	call   1003f9 <__panic>
  1038fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038ff:	05 00 00 00 40       	add    $0x40000000,%eax
  103904:	39 d0                	cmp    %edx,%eax
  103906:	75 0c                	jne    103914 <tlb_invalidate+0x59>
        invlpg((void *)la);
  103908:	8b 45 0c             	mov    0xc(%ebp),%eax
  10390b:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10390e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103911:	0f 01 38             	invlpg (%eax)
    }
}
  103914:	90                   	nop
  103915:	c9                   	leave  
  103916:	c3                   	ret    

00103917 <check_alloc_page>:

static void
check_alloc_page(void) {
  103917:	55                   	push   %ebp
  103918:	89 e5                	mov    %esp,%ebp
  10391a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10391d:	a1 70 bf 11 00       	mov    0x11bf70,%eax
  103922:	8b 40 18             	mov    0x18(%eax),%eax
  103925:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103927:	c7 04 24 c8 6b 10 00 	movl   $0x106bc8,(%esp)
  10392e:	e8 6f c9 ff ff       	call   1002a2 <cprintf>
}
  103933:	90                   	nop
  103934:	c9                   	leave  
  103935:	c3                   	ret    

00103936 <check_pgdir>:

static void
check_pgdir(void) {
  103936:	55                   	push   %ebp
  103937:	89 e5                	mov    %esp,%ebp
  103939:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10393c:	a1 80 be 11 00       	mov    0x11be80,%eax
  103941:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103946:	76 24                	jbe    10396c <check_pgdir+0x36>
  103948:	c7 44 24 0c e7 6b 10 	movl   $0x106be7,0xc(%esp)
  10394f:	00 
  103950:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103957:	00 
  103958:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  10395f:	00 
  103960:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103967:	e8 8d ca ff ff       	call   1003f9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10396c:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103971:	85 c0                	test   %eax,%eax
  103973:	74 0e                	je     103983 <check_pgdir+0x4d>
  103975:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10397a:	25 ff 0f 00 00       	and    $0xfff,%eax
  10397f:	85 c0                	test   %eax,%eax
  103981:	74 24                	je     1039a7 <check_pgdir+0x71>
  103983:	c7 44 24 0c 04 6c 10 	movl   $0x106c04,0xc(%esp)
  10398a:	00 
  10398b:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103992:	00 
  103993:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  10399a:	00 
  10399b:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1039a2:	e8 52 ca ff ff       	call   1003f9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1039a7:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1039ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039b3:	00 
  1039b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1039bb:	00 
  1039bc:	89 04 24             	mov    %eax,(%esp)
  1039bf:	e8 3e fd ff ff       	call   103702 <get_page>
  1039c4:	85 c0                	test   %eax,%eax
  1039c6:	74 24                	je     1039ec <check_pgdir+0xb6>
  1039c8:	c7 44 24 0c 3c 6c 10 	movl   $0x106c3c,0xc(%esp)
  1039cf:	00 
  1039d0:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  1039d7:	00 
  1039d8:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  1039df:	00 
  1039e0:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1039e7:	e8 0d ca ff ff       	call   1003f9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1039ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039f3:	e8 19 f5 ff ff       	call   102f11 <alloc_pages>
  1039f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1039fb:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103a00:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103a07:	00 
  103a08:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a0f:	00 
  103a10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103a13:	89 54 24 04          	mov    %edx,0x4(%esp)
  103a17:	89 04 24             	mov    %eax,(%esp)
  103a1a:	e8 e3 fd ff ff       	call   103802 <page_insert>
  103a1f:	85 c0                	test   %eax,%eax
  103a21:	74 24                	je     103a47 <check_pgdir+0x111>
  103a23:	c7 44 24 0c 64 6c 10 	movl   $0x106c64,0xc(%esp)
  103a2a:	00 
  103a2b:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103a32:	00 
  103a33:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  103a3a:	00 
  103a3b:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103a42:	e8 b2 c9 ff ff       	call   1003f9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103a47:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103a4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a53:	00 
  103a54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a5b:	00 
  103a5c:	89 04 24             	mov    %eax,(%esp)
  103a5f:	e8 65 fb ff ff       	call   1035c9 <get_pte>
  103a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a6b:	75 24                	jne    103a91 <check_pgdir+0x15b>
  103a6d:	c7 44 24 0c 90 6c 10 	movl   $0x106c90,0xc(%esp)
  103a74:	00 
  103a75:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103a7c:	00 
  103a7d:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  103a84:	00 
  103a85:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103a8c:	e8 68 c9 ff ff       	call   1003f9 <__panic>
    assert(pte2page(*ptep) == p1);
  103a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a94:	8b 00                	mov    (%eax),%eax
  103a96:	89 04 24             	mov    %eax,(%esp)
  103a99:	e8 18 f2 ff ff       	call   102cb6 <pte2page>
  103a9e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103aa1:	74 24                	je     103ac7 <check_pgdir+0x191>
  103aa3:	c7 44 24 0c bd 6c 10 	movl   $0x106cbd,0xc(%esp)
  103aaa:	00 
  103aab:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103ab2:	00 
  103ab3:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103aba:	00 
  103abb:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103ac2:	e8 32 c9 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p1) == 1);
  103ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aca:	89 04 24             	mov    %eax,(%esp)
  103acd:	e8 3a f2 ff ff       	call   102d0c <page_ref>
  103ad2:	83 f8 01             	cmp    $0x1,%eax
  103ad5:	74 24                	je     103afb <check_pgdir+0x1c5>
  103ad7:	c7 44 24 0c d3 6c 10 	movl   $0x106cd3,0xc(%esp)
  103ade:	00 
  103adf:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103ae6:	00 
  103ae7:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  103aee:	00 
  103aef:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103af6:	e8 fe c8 ff ff       	call   1003f9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103afb:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103b00:	8b 00                	mov    (%eax),%eax
  103b02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b0d:	c1 e8 0c             	shr    $0xc,%eax
  103b10:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103b13:	a1 80 be 11 00       	mov    0x11be80,%eax
  103b18:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103b1b:	72 23                	jb     103b40 <check_pgdir+0x20a>
  103b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b20:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103b24:	c7 44 24 08 a0 6a 10 	movl   $0x106aa0,0x8(%esp)
  103b2b:	00 
  103b2c:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  103b33:	00 
  103b34:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103b3b:	e8 b9 c8 ff ff       	call   1003f9 <__panic>
  103b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b43:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103b48:	83 c0 04             	add    $0x4,%eax
  103b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103b4e:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103b53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b5a:	00 
  103b5b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b62:	00 
  103b63:	89 04 24             	mov    %eax,(%esp)
  103b66:	e8 5e fa ff ff       	call   1035c9 <get_pte>
  103b6b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103b6e:	74 24                	je     103b94 <check_pgdir+0x25e>
  103b70:	c7 44 24 0c e8 6c 10 	movl   $0x106ce8,0xc(%esp)
  103b77:	00 
  103b78:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103b7f:	00 
  103b80:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103b87:	00 
  103b88:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103b8f:	e8 65 c8 ff ff       	call   1003f9 <__panic>

    p2 = alloc_page();
  103b94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103b9b:	e8 71 f3 ff ff       	call   102f11 <alloc_pages>
  103ba0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103ba3:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103ba8:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103baf:	00 
  103bb0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103bb7:	00 
  103bb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
  103bbf:	89 04 24             	mov    %eax,(%esp)
  103bc2:	e8 3b fc ff ff       	call   103802 <page_insert>
  103bc7:	85 c0                	test   %eax,%eax
  103bc9:	74 24                	je     103bef <check_pgdir+0x2b9>
  103bcb:	c7 44 24 0c 10 6d 10 	movl   $0x106d10,0xc(%esp)
  103bd2:	00 
  103bd3:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103bda:	00 
  103bdb:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103be2:	00 
  103be3:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103bea:	e8 0a c8 ff ff       	call   1003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103bef:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103bf4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103bfb:	00 
  103bfc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c03:	00 
  103c04:	89 04 24             	mov    %eax,(%esp)
  103c07:	e8 bd f9 ff ff       	call   1035c9 <get_pte>
  103c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c13:	75 24                	jne    103c39 <check_pgdir+0x303>
  103c15:	c7 44 24 0c 48 6d 10 	movl   $0x106d48,0xc(%esp)
  103c1c:	00 
  103c1d:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103c24:	00 
  103c25:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103c2c:	00 
  103c2d:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103c34:	e8 c0 c7 ff ff       	call   1003f9 <__panic>
    assert(*ptep & PTE_U);
  103c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c3c:	8b 00                	mov    (%eax),%eax
  103c3e:	83 e0 04             	and    $0x4,%eax
  103c41:	85 c0                	test   %eax,%eax
  103c43:	75 24                	jne    103c69 <check_pgdir+0x333>
  103c45:	c7 44 24 0c 78 6d 10 	movl   $0x106d78,0xc(%esp)
  103c4c:	00 
  103c4d:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103c54:	00 
  103c55:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103c5c:	00 
  103c5d:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103c64:	e8 90 c7 ff ff       	call   1003f9 <__panic>
    assert(*ptep & PTE_W);
  103c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c6c:	8b 00                	mov    (%eax),%eax
  103c6e:	83 e0 02             	and    $0x2,%eax
  103c71:	85 c0                	test   %eax,%eax
  103c73:	75 24                	jne    103c99 <check_pgdir+0x363>
  103c75:	c7 44 24 0c 86 6d 10 	movl   $0x106d86,0xc(%esp)
  103c7c:	00 
  103c7d:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103c84:	00 
  103c85:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  103c8c:	00 
  103c8d:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103c94:	e8 60 c7 ff ff       	call   1003f9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103c99:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103c9e:	8b 00                	mov    (%eax),%eax
  103ca0:	83 e0 04             	and    $0x4,%eax
  103ca3:	85 c0                	test   %eax,%eax
  103ca5:	75 24                	jne    103ccb <check_pgdir+0x395>
  103ca7:	c7 44 24 0c 94 6d 10 	movl   $0x106d94,0xc(%esp)
  103cae:	00 
  103caf:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103cb6:	00 
  103cb7:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103cbe:	00 
  103cbf:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103cc6:	e8 2e c7 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 1);
  103ccb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cce:	89 04 24             	mov    %eax,(%esp)
  103cd1:	e8 36 f0 ff ff       	call   102d0c <page_ref>
  103cd6:	83 f8 01             	cmp    $0x1,%eax
  103cd9:	74 24                	je     103cff <check_pgdir+0x3c9>
  103cdb:	c7 44 24 0c aa 6d 10 	movl   $0x106daa,0xc(%esp)
  103ce2:	00 
  103ce3:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103cea:	00 
  103ceb:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  103cf2:	00 
  103cf3:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103cfa:	e8 fa c6 ff ff       	call   1003f9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103cff:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103d04:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103d0b:	00 
  103d0c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103d13:	00 
  103d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103d17:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d1b:	89 04 24             	mov    %eax,(%esp)
  103d1e:	e8 df fa ff ff       	call   103802 <page_insert>
  103d23:	85 c0                	test   %eax,%eax
  103d25:	74 24                	je     103d4b <check_pgdir+0x415>
  103d27:	c7 44 24 0c bc 6d 10 	movl   $0x106dbc,0xc(%esp)
  103d2e:	00 
  103d2f:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103d36:	00 
  103d37:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103d3e:	00 
  103d3f:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103d46:	e8 ae c6 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p1) == 2);
  103d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d4e:	89 04 24             	mov    %eax,(%esp)
  103d51:	e8 b6 ef ff ff       	call   102d0c <page_ref>
  103d56:	83 f8 02             	cmp    $0x2,%eax
  103d59:	74 24                	je     103d7f <check_pgdir+0x449>
  103d5b:	c7 44 24 0c e8 6d 10 	movl   $0x106de8,0xc(%esp)
  103d62:	00 
  103d63:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103d6a:	00 
  103d6b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103d72:	00 
  103d73:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103d7a:	e8 7a c6 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d82:	89 04 24             	mov    %eax,(%esp)
  103d85:	e8 82 ef ff ff       	call   102d0c <page_ref>
  103d8a:	85 c0                	test   %eax,%eax
  103d8c:	74 24                	je     103db2 <check_pgdir+0x47c>
  103d8e:	c7 44 24 0c fa 6d 10 	movl   $0x106dfa,0xc(%esp)
  103d95:	00 
  103d96:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103d9d:	00 
  103d9e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103da5:	00 
  103da6:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103dad:	e8 47 c6 ff ff       	call   1003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103db2:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103db7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103dbe:	00 
  103dbf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103dc6:	00 
  103dc7:	89 04 24             	mov    %eax,(%esp)
  103dca:	e8 fa f7 ff ff       	call   1035c9 <get_pte>
  103dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103dd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103dd6:	75 24                	jne    103dfc <check_pgdir+0x4c6>
  103dd8:	c7 44 24 0c 48 6d 10 	movl   $0x106d48,0xc(%esp)
  103ddf:	00 
  103de0:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103de7:	00 
  103de8:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103def:	00 
  103df0:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103df7:	e8 fd c5 ff ff       	call   1003f9 <__panic>
    assert(pte2page(*ptep) == p1);
  103dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103dff:	8b 00                	mov    (%eax),%eax
  103e01:	89 04 24             	mov    %eax,(%esp)
  103e04:	e8 ad ee ff ff       	call   102cb6 <pte2page>
  103e09:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103e0c:	74 24                	je     103e32 <check_pgdir+0x4fc>
  103e0e:	c7 44 24 0c bd 6c 10 	movl   $0x106cbd,0xc(%esp)
  103e15:	00 
  103e16:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103e1d:	00 
  103e1e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  103e25:	00 
  103e26:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103e2d:	e8 c7 c5 ff ff       	call   1003f9 <__panic>
    assert((*ptep & PTE_U) == 0);
  103e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e35:	8b 00                	mov    (%eax),%eax
  103e37:	83 e0 04             	and    $0x4,%eax
  103e3a:	85 c0                	test   %eax,%eax
  103e3c:	74 24                	je     103e62 <check_pgdir+0x52c>
  103e3e:	c7 44 24 0c 0c 6e 10 	movl   $0x106e0c,0xc(%esp)
  103e45:	00 
  103e46:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103e4d:	00 
  103e4e:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103e55:	00 
  103e56:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103e5d:	e8 97 c5 ff ff       	call   1003f9 <__panic>

    page_remove(boot_pgdir, 0x0);
  103e62:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103e67:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103e6e:	00 
  103e6f:	89 04 24             	mov    %eax,(%esp)
  103e72:	e8 46 f9 ff ff       	call   1037bd <page_remove>
    assert(page_ref(p1) == 1);
  103e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e7a:	89 04 24             	mov    %eax,(%esp)
  103e7d:	e8 8a ee ff ff       	call   102d0c <page_ref>
  103e82:	83 f8 01             	cmp    $0x1,%eax
  103e85:	74 24                	je     103eab <check_pgdir+0x575>
  103e87:	c7 44 24 0c d3 6c 10 	movl   $0x106cd3,0xc(%esp)
  103e8e:	00 
  103e8f:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103e96:	00 
  103e97:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  103e9e:	00 
  103e9f:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103ea6:	e8 4e c5 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103eae:	89 04 24             	mov    %eax,(%esp)
  103eb1:	e8 56 ee ff ff       	call   102d0c <page_ref>
  103eb6:	85 c0                	test   %eax,%eax
  103eb8:	74 24                	je     103ede <check_pgdir+0x5a8>
  103eba:	c7 44 24 0c fa 6d 10 	movl   $0x106dfa,0xc(%esp)
  103ec1:	00 
  103ec2:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103ec9:	00 
  103eca:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103ed1:	00 
  103ed2:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103ed9:	e8 1b c5 ff ff       	call   1003f9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103ede:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103ee3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103eea:	00 
  103eeb:	89 04 24             	mov    %eax,(%esp)
  103eee:	e8 ca f8 ff ff       	call   1037bd <page_remove>
    assert(page_ref(p1) == 0);
  103ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ef6:	89 04 24             	mov    %eax,(%esp)
  103ef9:	e8 0e ee ff ff       	call   102d0c <page_ref>
  103efe:	85 c0                	test   %eax,%eax
  103f00:	74 24                	je     103f26 <check_pgdir+0x5f0>
  103f02:	c7 44 24 0c 21 6e 10 	movl   $0x106e21,0xc(%esp)
  103f09:	00 
  103f0a:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103f11:	00 
  103f12:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  103f19:	00 
  103f1a:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103f21:	e8 d3 c4 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f29:	89 04 24             	mov    %eax,(%esp)
  103f2c:	e8 db ed ff ff       	call   102d0c <page_ref>
  103f31:	85 c0                	test   %eax,%eax
  103f33:	74 24                	je     103f59 <check_pgdir+0x623>
  103f35:	c7 44 24 0c fa 6d 10 	movl   $0x106dfa,0xc(%esp)
  103f3c:	00 
  103f3d:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103f44:	00 
  103f45:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103f4c:	00 
  103f4d:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103f54:	e8 a0 c4 ff ff       	call   1003f9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103f59:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103f5e:	8b 00                	mov    (%eax),%eax
  103f60:	89 04 24             	mov    %eax,(%esp)
  103f63:	e8 8c ed ff ff       	call   102cf4 <pde2page>
  103f68:	89 04 24             	mov    %eax,(%esp)
  103f6b:	e8 9c ed ff ff       	call   102d0c <page_ref>
  103f70:	83 f8 01             	cmp    $0x1,%eax
  103f73:	74 24                	je     103f99 <check_pgdir+0x663>
  103f75:	c7 44 24 0c 34 6e 10 	movl   $0x106e34,0xc(%esp)
  103f7c:	00 
  103f7d:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  103f84:	00 
  103f85:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103f8c:	00 
  103f8d:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  103f94:	e8 60 c4 ff ff       	call   1003f9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103f99:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103f9e:	8b 00                	mov    (%eax),%eax
  103fa0:	89 04 24             	mov    %eax,(%esp)
  103fa3:	e8 4c ed ff ff       	call   102cf4 <pde2page>
  103fa8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103faf:	00 
  103fb0:	89 04 24             	mov    %eax,(%esp)
  103fb3:	e8 91 ef ff ff       	call   102f49 <free_pages>
    boot_pgdir[0] = 0;
  103fb8:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  103fbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103fc3:	c7 04 24 5b 6e 10 00 	movl   $0x106e5b,(%esp)
  103fca:	e8 d3 c2 ff ff       	call   1002a2 <cprintf>
}
  103fcf:	90                   	nop
  103fd0:	c9                   	leave  
  103fd1:	c3                   	ret    

00103fd2 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103fd2:	55                   	push   %ebp
  103fd3:	89 e5                	mov    %esp,%ebp
  103fd5:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103fd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103fdf:	e9 ca 00 00 00       	jmp    1040ae <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fe7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103fed:	c1 e8 0c             	shr    $0xc,%eax
  103ff0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ff3:	a1 80 be 11 00       	mov    0x11be80,%eax
  103ff8:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103ffb:	72 23                	jb     104020 <check_boot_pgdir+0x4e>
  103ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104000:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104004:	c7 44 24 08 a0 6a 10 	movl   $0x106aa0,0x8(%esp)
  10400b:	00 
  10400c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104013:	00 
  104014:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  10401b:	e8 d9 c3 ff ff       	call   1003f9 <__panic>
  104020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104023:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104028:	89 c2                	mov    %eax,%edx
  10402a:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10402f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104036:	00 
  104037:	89 54 24 04          	mov    %edx,0x4(%esp)
  10403b:	89 04 24             	mov    %eax,(%esp)
  10403e:	e8 86 f5 ff ff       	call   1035c9 <get_pte>
  104043:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104046:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10404a:	75 24                	jne    104070 <check_boot_pgdir+0x9e>
  10404c:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  104053:	00 
  104054:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  10405b:	00 
  10405c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104063:	00 
  104064:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  10406b:	e8 89 c3 ff ff       	call   1003f9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104070:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104073:	8b 00                	mov    (%eax),%eax
  104075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10407a:	89 c2                	mov    %eax,%edx
  10407c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10407f:	39 c2                	cmp    %eax,%edx
  104081:	74 24                	je     1040a7 <check_boot_pgdir+0xd5>
  104083:	c7 44 24 0c b5 6e 10 	movl   $0x106eb5,0xc(%esp)
  10408a:	00 
  10408b:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  104092:	00 
  104093:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  10409a:	00 
  10409b:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1040a2:	e8 52 c3 ff ff       	call   1003f9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  1040a7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1040ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1040b1:	a1 80 be 11 00       	mov    0x11be80,%eax
  1040b6:	39 c2                	cmp    %eax,%edx
  1040b8:	0f 82 26 ff ff ff    	jb     103fe4 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1040be:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1040c3:	05 ac 0f 00 00       	add    $0xfac,%eax
  1040c8:	8b 00                	mov    (%eax),%eax
  1040ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1040cf:	89 c2                	mov    %eax,%edx
  1040d1:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1040d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1040d9:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1040e0:	77 23                	ja     104105 <check_boot_pgdir+0x133>
  1040e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040e9:	c7 44 24 08 44 6b 10 	movl   $0x106b44,0x8(%esp)
  1040f0:	00 
  1040f1:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  1040f8:	00 
  1040f9:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  104100:	e8 f4 c2 ff ff       	call   1003f9 <__panic>
  104105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104108:	05 00 00 00 40       	add    $0x40000000,%eax
  10410d:	39 d0                	cmp    %edx,%eax
  10410f:	74 24                	je     104135 <check_boot_pgdir+0x163>
  104111:	c7 44 24 0c cc 6e 10 	movl   $0x106ecc,0xc(%esp)
  104118:	00 
  104119:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  104120:	00 
  104121:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104128:	00 
  104129:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  104130:	e8 c4 c2 ff ff       	call   1003f9 <__panic>

    assert(boot_pgdir[0] == 0);
  104135:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10413a:	8b 00                	mov    (%eax),%eax
  10413c:	85 c0                	test   %eax,%eax
  10413e:	74 24                	je     104164 <check_boot_pgdir+0x192>
  104140:	c7 44 24 0c 00 6f 10 	movl   $0x106f00,0xc(%esp)
  104147:	00 
  104148:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  10414f:	00 
  104150:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104157:	00 
  104158:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  10415f:	e8 95 c2 ff ff       	call   1003f9 <__panic>

    struct Page *p;
    p = alloc_page();
  104164:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10416b:	e8 a1 ed ff ff       	call   102f11 <alloc_pages>
  104170:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104173:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104178:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10417f:	00 
  104180:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104187:	00 
  104188:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10418b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10418f:	89 04 24             	mov    %eax,(%esp)
  104192:	e8 6b f6 ff ff       	call   103802 <page_insert>
  104197:	85 c0                	test   %eax,%eax
  104199:	74 24                	je     1041bf <check_boot_pgdir+0x1ed>
  10419b:	c7 44 24 0c 14 6f 10 	movl   $0x106f14,0xc(%esp)
  1041a2:	00 
  1041a3:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  1041aa:	00 
  1041ab:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  1041b2:	00 
  1041b3:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1041ba:	e8 3a c2 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p) == 1);
  1041bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041c2:	89 04 24             	mov    %eax,(%esp)
  1041c5:	e8 42 eb ff ff       	call   102d0c <page_ref>
  1041ca:	83 f8 01             	cmp    $0x1,%eax
  1041cd:	74 24                	je     1041f3 <check_boot_pgdir+0x221>
  1041cf:	c7 44 24 0c 42 6f 10 	movl   $0x106f42,0xc(%esp)
  1041d6:	00 
  1041d7:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  1041de:	00 
  1041df:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  1041e6:	00 
  1041e7:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1041ee:	e8 06 c2 ff ff       	call   1003f9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1041f3:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1041f8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1041ff:	00 
  104200:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104207:	00 
  104208:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10420b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10420f:	89 04 24             	mov    %eax,(%esp)
  104212:	e8 eb f5 ff ff       	call   103802 <page_insert>
  104217:	85 c0                	test   %eax,%eax
  104219:	74 24                	je     10423f <check_boot_pgdir+0x26d>
  10421b:	c7 44 24 0c 54 6f 10 	movl   $0x106f54,0xc(%esp)
  104222:	00 
  104223:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  10422a:	00 
  10422b:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104232:	00 
  104233:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  10423a:	e8 ba c1 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p) == 2);
  10423f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104242:	89 04 24             	mov    %eax,(%esp)
  104245:	e8 c2 ea ff ff       	call   102d0c <page_ref>
  10424a:	83 f8 02             	cmp    $0x2,%eax
  10424d:	74 24                	je     104273 <check_boot_pgdir+0x2a1>
  10424f:	c7 44 24 0c 8b 6f 10 	movl   $0x106f8b,0xc(%esp)
  104256:	00 
  104257:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  10425e:	00 
  10425f:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  104266:	00 
  104267:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  10426e:	e8 86 c1 ff ff       	call   1003f9 <__panic>

    const char *str = "ucore: Hello world!!";
  104273:	c7 45 e8 9c 6f 10 00 	movl   $0x106f9c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  10427a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10427d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104281:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104288:	e8 d5 15 00 00       	call   105862 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10428d:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104294:	00 
  104295:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10429c:	e8 38 16 00 00       	call   1058d9 <strcmp>
  1042a1:	85 c0                	test   %eax,%eax
  1042a3:	74 24                	je     1042c9 <check_boot_pgdir+0x2f7>
  1042a5:	c7 44 24 0c b4 6f 10 	movl   $0x106fb4,0xc(%esp)
  1042ac:	00 
  1042ad:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  1042b4:	00 
  1042b5:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  1042bc:	00 
  1042bd:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  1042c4:	e8 30 c1 ff ff       	call   1003f9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1042c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042cc:	89 04 24             	mov    %eax,(%esp)
  1042cf:	e8 8e e9 ff ff       	call   102c62 <page2kva>
  1042d4:	05 00 01 00 00       	add    $0x100,%eax
  1042d9:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1042dc:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1042e3:	e8 24 15 00 00       	call   10580c <strlen>
  1042e8:	85 c0                	test   %eax,%eax
  1042ea:	74 24                	je     104310 <check_boot_pgdir+0x33e>
  1042ec:	c7 44 24 0c ec 6f 10 	movl   $0x106fec,0xc(%esp)
  1042f3:	00 
  1042f4:	c7 44 24 08 8d 6b 10 	movl   $0x106b8d,0x8(%esp)
  1042fb:	00 
  1042fc:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104303:	00 
  104304:	c7 04 24 68 6b 10 00 	movl   $0x106b68,(%esp)
  10430b:	e8 e9 c0 ff ff       	call   1003f9 <__panic>

    free_page(p);
  104310:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104317:	00 
  104318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10431b:	89 04 24             	mov    %eax,(%esp)
  10431e:	e8 26 ec ff ff       	call   102f49 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104323:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104328:	8b 00                	mov    (%eax),%eax
  10432a:	89 04 24             	mov    %eax,(%esp)
  10432d:	e8 c2 e9 ff ff       	call   102cf4 <pde2page>
  104332:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104339:	00 
  10433a:	89 04 24             	mov    %eax,(%esp)
  10433d:	e8 07 ec ff ff       	call   102f49 <free_pages>
    boot_pgdir[0] = 0;
  104342:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104347:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10434d:	c7 04 24 10 70 10 00 	movl   $0x107010,(%esp)
  104354:	e8 49 bf ff ff       	call   1002a2 <cprintf>
}
  104359:	90                   	nop
  10435a:	c9                   	leave  
  10435b:	c3                   	ret    

0010435c <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10435c:	55                   	push   %ebp
  10435d:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10435f:	8b 45 08             	mov    0x8(%ebp),%eax
  104362:	83 e0 04             	and    $0x4,%eax
  104365:	85 c0                	test   %eax,%eax
  104367:	74 04                	je     10436d <perm2str+0x11>
  104369:	b0 75                	mov    $0x75,%al
  10436b:	eb 02                	jmp    10436f <perm2str+0x13>
  10436d:	b0 2d                	mov    $0x2d,%al
  10436f:	a2 08 bf 11 00       	mov    %al,0x11bf08
    str[1] = 'r';
  104374:	c6 05 09 bf 11 00 72 	movb   $0x72,0x11bf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10437b:	8b 45 08             	mov    0x8(%ebp),%eax
  10437e:	83 e0 02             	and    $0x2,%eax
  104381:	85 c0                	test   %eax,%eax
  104383:	74 04                	je     104389 <perm2str+0x2d>
  104385:	b0 77                	mov    $0x77,%al
  104387:	eb 02                	jmp    10438b <perm2str+0x2f>
  104389:	b0 2d                	mov    $0x2d,%al
  10438b:	a2 0a bf 11 00       	mov    %al,0x11bf0a
    str[3] = '\0';
  104390:	c6 05 0b bf 11 00 00 	movb   $0x0,0x11bf0b
    return str;
  104397:	b8 08 bf 11 00       	mov    $0x11bf08,%eax
}
  10439c:	5d                   	pop    %ebp
  10439d:	c3                   	ret    

0010439e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10439e:	55                   	push   %ebp
  10439f:	89 e5                	mov    %esp,%ebp
  1043a1:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1043a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1043a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1043aa:	72 0d                	jb     1043b9 <get_pgtable_items+0x1b>
        return 0;
  1043ac:	b8 00 00 00 00       	mov    $0x0,%eax
  1043b1:	e9 98 00 00 00       	jmp    10444e <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1043b6:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1043b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1043bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1043bf:	73 18                	jae    1043d9 <get_pgtable_items+0x3b>
  1043c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1043c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1043cb:	8b 45 14             	mov    0x14(%ebp),%eax
  1043ce:	01 d0                	add    %edx,%eax
  1043d0:	8b 00                	mov    (%eax),%eax
  1043d2:	83 e0 01             	and    $0x1,%eax
  1043d5:	85 c0                	test   %eax,%eax
  1043d7:	74 dd                	je     1043b6 <get_pgtable_items+0x18>
    }
    if (start < right) {
  1043d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1043dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1043df:	73 68                	jae    104449 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  1043e1:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1043e5:	74 08                	je     1043ef <get_pgtable_items+0x51>
            *left_store = start;
  1043e7:	8b 45 18             	mov    0x18(%ebp),%eax
  1043ea:	8b 55 10             	mov    0x10(%ebp),%edx
  1043ed:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1043ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1043f2:	8d 50 01             	lea    0x1(%eax),%edx
  1043f5:	89 55 10             	mov    %edx,0x10(%ebp)
  1043f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1043ff:	8b 45 14             	mov    0x14(%ebp),%eax
  104402:	01 d0                	add    %edx,%eax
  104404:	8b 00                	mov    (%eax),%eax
  104406:	83 e0 07             	and    $0x7,%eax
  104409:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10440c:	eb 03                	jmp    104411 <get_pgtable_items+0x73>
            start ++;
  10440e:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104411:	8b 45 10             	mov    0x10(%ebp),%eax
  104414:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104417:	73 1d                	jae    104436 <get_pgtable_items+0x98>
  104419:	8b 45 10             	mov    0x10(%ebp),%eax
  10441c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104423:	8b 45 14             	mov    0x14(%ebp),%eax
  104426:	01 d0                	add    %edx,%eax
  104428:	8b 00                	mov    (%eax),%eax
  10442a:	83 e0 07             	and    $0x7,%eax
  10442d:	89 c2                	mov    %eax,%edx
  10442f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104432:	39 c2                	cmp    %eax,%edx
  104434:	74 d8                	je     10440e <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  104436:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10443a:	74 08                	je     104444 <get_pgtable_items+0xa6>
            *right_store = start;
  10443c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10443f:	8b 55 10             	mov    0x10(%ebp),%edx
  104442:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104447:	eb 05                	jmp    10444e <get_pgtable_items+0xb0>
    }
    return 0;
  104449:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10444e:	c9                   	leave  
  10444f:	c3                   	ret    

00104450 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104450:	55                   	push   %ebp
  104451:	89 e5                	mov    %esp,%ebp
  104453:	57                   	push   %edi
  104454:	56                   	push   %esi
  104455:	53                   	push   %ebx
  104456:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104459:	c7 04 24 30 70 10 00 	movl   $0x107030,(%esp)
  104460:	e8 3d be ff ff       	call   1002a2 <cprintf>
    size_t left, right = 0, perm;
  104465:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10446c:	e9 fa 00 00 00       	jmp    10456b <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104474:	89 04 24             	mov    %eax,(%esp)
  104477:	e8 e0 fe ff ff       	call   10435c <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10447c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10447f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104482:	29 d1                	sub    %edx,%ecx
  104484:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104486:	89 d6                	mov    %edx,%esi
  104488:	c1 e6 16             	shl    $0x16,%esi
  10448b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10448e:	89 d3                	mov    %edx,%ebx
  104490:	c1 e3 16             	shl    $0x16,%ebx
  104493:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104496:	89 d1                	mov    %edx,%ecx
  104498:	c1 e1 16             	shl    $0x16,%ecx
  10449b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10449e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1044a1:	29 d7                	sub    %edx,%edi
  1044a3:	89 fa                	mov    %edi,%edx
  1044a5:	89 44 24 14          	mov    %eax,0x14(%esp)
  1044a9:	89 74 24 10          	mov    %esi,0x10(%esp)
  1044ad:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1044b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1044b5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1044b9:	c7 04 24 61 70 10 00 	movl   $0x107061,(%esp)
  1044c0:	e8 dd bd ff ff       	call   1002a2 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1044c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044c8:	c1 e0 0a             	shl    $0xa,%eax
  1044cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1044ce:	eb 54                	jmp    104524 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1044d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044d3:	89 04 24             	mov    %eax,(%esp)
  1044d6:	e8 81 fe ff ff       	call   10435c <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1044db:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1044de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1044e1:	29 d1                	sub    %edx,%ecx
  1044e3:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1044e5:	89 d6                	mov    %edx,%esi
  1044e7:	c1 e6 0c             	shl    $0xc,%esi
  1044ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1044ed:	89 d3                	mov    %edx,%ebx
  1044ef:	c1 e3 0c             	shl    $0xc,%ebx
  1044f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1044f5:	89 d1                	mov    %edx,%ecx
  1044f7:	c1 e1 0c             	shl    $0xc,%ecx
  1044fa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1044fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104500:	29 d7                	sub    %edx,%edi
  104502:	89 fa                	mov    %edi,%edx
  104504:	89 44 24 14          	mov    %eax,0x14(%esp)
  104508:	89 74 24 10          	mov    %esi,0x10(%esp)
  10450c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104510:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104514:	89 54 24 04          	mov    %edx,0x4(%esp)
  104518:	c7 04 24 80 70 10 00 	movl   $0x107080,(%esp)
  10451f:	e8 7e bd ff ff       	call   1002a2 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104524:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10452c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10452f:	89 d3                	mov    %edx,%ebx
  104531:	c1 e3 0a             	shl    $0xa,%ebx
  104534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104537:	89 d1                	mov    %edx,%ecx
  104539:	c1 e1 0a             	shl    $0xa,%ecx
  10453c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10453f:	89 54 24 14          	mov    %edx,0x14(%esp)
  104543:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104546:	89 54 24 10          	mov    %edx,0x10(%esp)
  10454a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10454e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104552:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104556:	89 0c 24             	mov    %ecx,(%esp)
  104559:	e8 40 fe ff ff       	call   10439e <get_pgtable_items>
  10455e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104561:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104565:	0f 85 65 ff ff ff    	jne    1044d0 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10456b:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104570:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104573:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104576:	89 54 24 14          	mov    %edx,0x14(%esp)
  10457a:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10457d:	89 54 24 10          	mov    %edx,0x10(%esp)
  104581:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  104585:	89 44 24 08          	mov    %eax,0x8(%esp)
  104589:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104590:	00 
  104591:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104598:	e8 01 fe ff ff       	call   10439e <get_pgtable_items>
  10459d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1045a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1045a4:	0f 85 c7 fe ff ff    	jne    104471 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1045aa:	c7 04 24 a4 70 10 00 	movl   $0x1070a4,(%esp)
  1045b1:	e8 ec bc ff ff       	call   1002a2 <cprintf>
}
  1045b6:	90                   	nop
  1045b7:	83 c4 4c             	add    $0x4c,%esp
  1045ba:	5b                   	pop    %ebx
  1045bb:	5e                   	pop    %esi
  1045bc:	5f                   	pop    %edi
  1045bd:	5d                   	pop    %ebp
  1045be:	c3                   	ret    

001045bf <page2ppn>:
page2ppn(struct Page *page) {
  1045bf:	55                   	push   %ebp
  1045c0:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1045c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1045c5:	8b 15 78 bf 11 00    	mov    0x11bf78,%edx
  1045cb:	29 d0                	sub    %edx,%eax
  1045cd:	c1 f8 02             	sar    $0x2,%eax
  1045d0:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1045d6:	5d                   	pop    %ebp
  1045d7:	c3                   	ret    

001045d8 <page2pa>:
page2pa(struct Page *page) {
  1045d8:	55                   	push   %ebp
  1045d9:	89 e5                	mov    %esp,%ebp
  1045db:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1045de:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e1:	89 04 24             	mov    %eax,(%esp)
  1045e4:	e8 d6 ff ff ff       	call   1045bf <page2ppn>
  1045e9:	c1 e0 0c             	shl    $0xc,%eax
}
  1045ec:	c9                   	leave  
  1045ed:	c3                   	ret    

001045ee <page_ref>:
page_ref(struct Page *page) {
  1045ee:	55                   	push   %ebp
  1045ef:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1045f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1045f4:	8b 00                	mov    (%eax),%eax
}
  1045f6:	5d                   	pop    %ebp
  1045f7:	c3                   	ret    

001045f8 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1045f8:	55                   	push   %ebp
  1045f9:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1045fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1045fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  104601:	89 10                	mov    %edx,(%eax)
}
  104603:	90                   	nop
  104604:	5d                   	pop    %ebp
  104605:	c3                   	ret    

00104606 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104606:	55                   	push   %ebp
  104607:	89 e5                	mov    %esp,%ebp
  104609:	83 ec 10             	sub    $0x10,%esp
  10460c:	c7 45 fc 7c bf 11 00 	movl   $0x11bf7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104613:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104616:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104619:	89 50 04             	mov    %edx,0x4(%eax)
  10461c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10461f:	8b 50 04             	mov    0x4(%eax),%edx
  104622:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104625:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  104627:	c7 05 84 bf 11 00 00 	movl   $0x0,0x11bf84
  10462e:	00 00 00 
}
  104631:	90                   	nop
  104632:	c9                   	leave  
  104633:	c3                   	ret    

00104634 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  104634:	55                   	push   %ebp
  104635:	89 e5                	mov    %esp,%ebp
  104637:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  10463a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10463e:	75 24                	jne    104664 <default_init_memmap+0x30>
  104640:	c7 44 24 0c d8 70 10 	movl   $0x1070d8,0xc(%esp)
  104647:	00 
  104648:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  10464f:	00 
  104650:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  104657:	00 
  104658:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  10465f:	e8 95 bd ff ff       	call   1003f9 <__panic>
    struct Page *p = base;
  104664:	8b 45 08             	mov    0x8(%ebp),%eax
  104667:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10466a:	eb 7d                	jmp    1046e9 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  10466c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10466f:	83 c0 04             	add    $0x4,%eax
  104672:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104679:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10467c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10467f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104682:	0f a3 10             	bt     %edx,(%eax)
  104685:	19 c0                	sbb    %eax,%eax
  104687:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10468a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10468e:	0f 95 c0             	setne  %al
  104691:	0f b6 c0             	movzbl %al,%eax
  104694:	85 c0                	test   %eax,%eax
  104696:	75 24                	jne    1046bc <default_init_memmap+0x88>
  104698:	c7 44 24 0c 09 71 10 	movl   $0x107109,0xc(%esp)
  10469f:	00 
  1046a0:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1046a7:	00 
  1046a8:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  1046af:	00 
  1046b0:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1046b7:	e8 3d bd ff ff       	call   1003f9 <__panic>
        p->flags = p->property = 0;
  1046bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1046c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046c9:	8b 50 08             	mov    0x8(%eax),%edx
  1046cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046cf:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1046d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046d9:	00 
  1046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046dd:	89 04 24             	mov    %eax,(%esp)
  1046e0:	e8 13 ff ff ff       	call   1045f8 <set_page_ref>
    for (; p != base + n; p ++) {
  1046e5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1046e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046ec:	89 d0                	mov    %edx,%eax
  1046ee:	c1 e0 02             	shl    $0x2,%eax
  1046f1:	01 d0                	add    %edx,%eax
  1046f3:	c1 e0 02             	shl    $0x2,%eax
  1046f6:	89 c2                	mov    %eax,%edx
  1046f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1046fb:	01 d0                	add    %edx,%eax
  1046fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104700:	0f 85 66 ff ff ff    	jne    10466c <default_init_memmap+0x38>
    }
    base->property = n;
  104706:	8b 45 08             	mov    0x8(%ebp),%eax
  104709:	8b 55 0c             	mov    0xc(%ebp),%edx
  10470c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10470f:	8b 45 08             	mov    0x8(%ebp),%eax
  104712:	83 c0 04             	add    $0x4,%eax
  104715:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10471c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10471f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104722:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104725:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  104728:	8b 15 84 bf 11 00    	mov    0x11bf84,%edx
  10472e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104731:	01 d0                	add    %edx,%eax
  104733:	a3 84 bf 11 00       	mov    %eax,0x11bf84
    list_add_before(&free_list, &(base->page_link));
  104738:	8b 45 08             	mov    0x8(%ebp),%eax
  10473b:	83 c0 0c             	add    $0xc,%eax
  10473e:	c7 45 e4 7c bf 11 00 	movl   $0x11bf7c,-0x1c(%ebp)
  104745:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10474b:	8b 00                	mov    (%eax),%eax
  10474d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104750:	89 55 dc             	mov    %edx,-0x24(%ebp)
  104753:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104759:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10475c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10475f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104762:	89 10                	mov    %edx,(%eax)
  104764:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104767:	8b 10                	mov    (%eax),%edx
  104769:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10476c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10476f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104772:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104775:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104778:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10477b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10477e:	89 10                	mov    %edx,(%eax)
}
  104780:	90                   	nop
  104781:	c9                   	leave  
  104782:	c3                   	ret    

00104783 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104783:	55                   	push   %ebp
  104784:	89 e5                	mov    %esp,%ebp
  104786:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104789:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10478d:	75 24                	jne    1047b3 <default_alloc_pages+0x30>
  10478f:	c7 44 24 0c d8 70 10 	movl   $0x1070d8,0xc(%esp)
  104796:	00 
  104797:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  10479e:	00 
  10479f:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  1047a6:	00 
  1047a7:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1047ae:	e8 46 bc ff ff       	call   1003f9 <__panic>
    if (n > nr_free) {
  1047b3:	a1 84 bf 11 00       	mov    0x11bf84,%eax
  1047b8:	39 45 08             	cmp    %eax,0x8(%ebp)
  1047bb:	76 0a                	jbe    1047c7 <default_alloc_pages+0x44>
        return NULL;
  1047bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1047c2:	e9 3d 01 00 00       	jmp    104904 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
  1047c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1047ce:	c7 45 f0 7c bf 11 00 	movl   $0x11bf7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1047d5:	eb 1c                	jmp    1047f3 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  1047d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047da:	83 e8 0c             	sub    $0xc,%eax
  1047dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1047e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047e3:	8b 40 08             	mov    0x8(%eax),%eax
  1047e6:	39 45 08             	cmp    %eax,0x8(%ebp)
  1047e9:	77 08                	ja     1047f3 <default_alloc_pages+0x70>
            page = p;
  1047eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  1047f1:	eb 18                	jmp    10480b <default_alloc_pages+0x88>
  1047f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  1047f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047fc:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1047ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104802:	81 7d f0 7c bf 11 00 	cmpl   $0x11bf7c,-0x10(%ebp)
  104809:	75 cc                	jne    1047d7 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  10480b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10480f:	0f 84 ec 00 00 00    	je     104901 <default_alloc_pages+0x17e>
        if (page->property > n) {
  104815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104818:	8b 40 08             	mov    0x8(%eax),%eax
  10481b:	39 45 08             	cmp    %eax,0x8(%ebp)
  10481e:	0f 83 8c 00 00 00    	jae    1048b0 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
  104824:	8b 55 08             	mov    0x8(%ebp),%edx
  104827:	89 d0                	mov    %edx,%eax
  104829:	c1 e0 02             	shl    $0x2,%eax
  10482c:	01 d0                	add    %edx,%eax
  10482e:	c1 e0 02             	shl    $0x2,%eax
  104831:	89 c2                	mov    %eax,%edx
  104833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104836:	01 d0                	add    %edx,%eax
  104838:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  10483b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10483e:	8b 40 08             	mov    0x8(%eax),%eax
  104841:	2b 45 08             	sub    0x8(%ebp),%eax
  104844:	89 c2                	mov    %eax,%edx
  104846:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104849:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  10484c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10484f:	83 c0 04             	add    $0x4,%eax
  104852:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104859:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10485c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10485f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104862:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  104865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104868:	83 c0 0c             	add    $0xc,%eax
  10486b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10486e:	83 c2 0c             	add    $0xc,%edx
  104871:	89 55 e0             	mov    %edx,-0x20(%ebp)
  104874:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  104877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10487a:	8b 40 04             	mov    0x4(%eax),%eax
  10487d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104880:	89 55 d8             	mov    %edx,-0x28(%ebp)
  104883:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104886:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104889:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  10488c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10488f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104892:	89 10                	mov    %edx,(%eax)
  104894:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104897:	8b 10                	mov    (%eax),%edx
  104899:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10489c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10489f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1048a2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1048a5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1048a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1048ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1048ae:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
  1048b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b3:	83 c0 0c             	add    $0xc,%eax
  1048b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  1048b9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1048bc:	8b 40 04             	mov    0x4(%eax),%eax
  1048bf:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1048c2:	8b 12                	mov    (%edx),%edx
  1048c4:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1048c7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1048ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1048cd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1048d0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1048d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1048d6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1048d9:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  1048db:	a1 84 bf 11 00       	mov    0x11bf84,%eax
  1048e0:	2b 45 08             	sub    0x8(%ebp),%eax
  1048e3:	a3 84 bf 11 00       	mov    %eax,0x11bf84
        ClearPageProperty(page);
  1048e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048eb:	83 c0 04             	add    $0x4,%eax
  1048ee:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  1048f5:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1048f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1048fb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1048fe:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  104901:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104904:	c9                   	leave  
  104905:	c3                   	ret    

00104906 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104906:	55                   	push   %ebp
  104907:	89 e5                	mov    %esp,%ebp
  104909:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  10490f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104913:	75 24                	jne    104939 <default_free_pages+0x33>
  104915:	c7 44 24 0c d8 70 10 	movl   $0x1070d8,0xc(%esp)
  10491c:	00 
  10491d:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104924:	00 
  104925:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  10492c:	00 
  10492d:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104934:	e8 c0 ba ff ff       	call   1003f9 <__panic>
    struct Page *p = base;
  104939:	8b 45 08             	mov    0x8(%ebp),%eax
  10493c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10493f:	e9 9d 00 00 00       	jmp    1049e1 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  104944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104947:	83 c0 04             	add    $0x4,%eax
  10494a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104951:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104954:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104957:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10495a:	0f a3 10             	bt     %edx,(%eax)
  10495d:	19 c0                	sbb    %eax,%eax
  10495f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104962:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104966:	0f 95 c0             	setne  %al
  104969:	0f b6 c0             	movzbl %al,%eax
  10496c:	85 c0                	test   %eax,%eax
  10496e:	75 2c                	jne    10499c <default_free_pages+0x96>
  104970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104973:	83 c0 04             	add    $0x4,%eax
  104976:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10497d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104980:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104983:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104986:	0f a3 10             	bt     %edx,(%eax)
  104989:	19 c0                	sbb    %eax,%eax
  10498b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10498e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104992:	0f 95 c0             	setne  %al
  104995:	0f b6 c0             	movzbl %al,%eax
  104998:	85 c0                	test   %eax,%eax
  10499a:	74 24                	je     1049c0 <default_free_pages+0xba>
  10499c:	c7 44 24 0c 1c 71 10 	movl   $0x10711c,0xc(%esp)
  1049a3:	00 
  1049a4:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1049ab:	00 
  1049ac:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  1049b3:	00 
  1049b4:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1049bb:	e8 39 ba ff ff       	call   1003f9 <__panic>
        p->flags = 0;
  1049c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1049ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1049d1:	00 
  1049d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d5:	89 04 24             	mov    %eax,(%esp)
  1049d8:	e8 1b fc ff ff       	call   1045f8 <set_page_ref>
    for (; p != base + n; p ++) {
  1049dd:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1049e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1049e4:	89 d0                	mov    %edx,%eax
  1049e6:	c1 e0 02             	shl    $0x2,%eax
  1049e9:	01 d0                	add    %edx,%eax
  1049eb:	c1 e0 02             	shl    $0x2,%eax
  1049ee:	89 c2                	mov    %eax,%edx
  1049f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1049f3:	01 d0                	add    %edx,%eax
  1049f5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1049f8:	0f 85 46 ff ff ff    	jne    104944 <default_free_pages+0x3e>
    }
    base->property = n;
  1049fe:	8b 45 08             	mov    0x8(%ebp),%eax
  104a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  104a04:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104a07:	8b 45 08             	mov    0x8(%ebp),%eax
  104a0a:	83 c0 04             	add    $0x4,%eax
  104a0d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104a14:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104a17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104a1a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104a1d:	0f ab 10             	bts    %edx,(%eax)
  104a20:	c7 45 d4 7c bf 11 00 	movl   $0x11bf7c,-0x2c(%ebp)
    return listelm->next;
  104a27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104a2a:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104a30:	e9 08 01 00 00       	jmp    104b3d <default_free_pages+0x237>
        p = le2page(le, page_link);
  104a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a38:	83 e8 0c             	sub    $0xc,%eax
  104a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a41:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104a44:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104a47:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  104a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  104a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  104a50:	8b 50 08             	mov    0x8(%eax),%edx
  104a53:	89 d0                	mov    %edx,%eax
  104a55:	c1 e0 02             	shl    $0x2,%eax
  104a58:	01 d0                	add    %edx,%eax
  104a5a:	c1 e0 02             	shl    $0x2,%eax
  104a5d:	89 c2                	mov    %eax,%edx
  104a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  104a62:	01 d0                	add    %edx,%eax
  104a64:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104a67:	75 5a                	jne    104ac3 <default_free_pages+0x1bd>
            base->property += p->property;
  104a69:	8b 45 08             	mov    0x8(%ebp),%eax
  104a6c:	8b 50 08             	mov    0x8(%eax),%edx
  104a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a72:	8b 40 08             	mov    0x8(%eax),%eax
  104a75:	01 c2                	add    %eax,%edx
  104a77:	8b 45 08             	mov    0x8(%ebp),%eax
  104a7a:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  104a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a80:	83 c0 04             	add    $0x4,%eax
  104a83:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104a8a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104a8d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104a90:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104a93:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  104a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a99:	83 c0 0c             	add    $0xc,%eax
  104a9c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104a9f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104aa2:	8b 40 04             	mov    0x4(%eax),%eax
  104aa5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104aa8:	8b 12                	mov    (%edx),%edx
  104aaa:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104aad:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104ab0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104ab3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104ab6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104ab9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104abc:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104abf:	89 10                	mov    %edx,(%eax)
  104ac1:	eb 7a                	jmp    104b3d <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  104ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ac6:	8b 50 08             	mov    0x8(%eax),%edx
  104ac9:	89 d0                	mov    %edx,%eax
  104acb:	c1 e0 02             	shl    $0x2,%eax
  104ace:	01 d0                	add    %edx,%eax
  104ad0:	c1 e0 02             	shl    $0x2,%eax
  104ad3:	89 c2                	mov    %eax,%edx
  104ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ad8:	01 d0                	add    %edx,%eax
  104ada:	39 45 08             	cmp    %eax,0x8(%ebp)
  104add:	75 5e                	jne    104b3d <default_free_pages+0x237>
            p->property += base->property;
  104adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ae2:	8b 50 08             	mov    0x8(%eax),%edx
  104ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  104ae8:	8b 40 08             	mov    0x8(%eax),%eax
  104aeb:	01 c2                	add    %eax,%edx
  104aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104af0:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  104af3:	8b 45 08             	mov    0x8(%ebp),%eax
  104af6:	83 c0 04             	add    $0x4,%eax
  104af9:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104b00:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104b03:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104b06:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104b09:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  104b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b0f:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b15:	83 c0 0c             	add    $0xc,%eax
  104b18:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  104b1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104b1e:	8b 40 04             	mov    0x4(%eax),%eax
  104b21:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104b24:	8b 12                	mov    (%edx),%edx
  104b26:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104b29:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104b2c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104b2f:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104b32:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104b35:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104b38:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104b3b:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
  104b3d:	81 7d f0 7c bf 11 00 	cmpl   $0x11bf7c,-0x10(%ebp)
  104b44:	0f 85 eb fe ff ff    	jne    104a35 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
  104b4a:	8b 15 84 bf 11 00    	mov    0x11bf84,%edx
  104b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  104b53:	01 d0                	add    %edx,%eax
  104b55:	a3 84 bf 11 00       	mov    %eax,0x11bf84
  104b5a:	c7 45 9c 7c bf 11 00 	movl   $0x11bf7c,-0x64(%ebp)
    return listelm->next;
  104b61:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104b64:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  104b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104b6a:	eb 74                	jmp    104be0 <default_free_pages+0x2da>
        p = le2page(le, page_link);
  104b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b6f:	83 e8 0c             	sub    $0xc,%eax
  104b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  104b75:	8b 45 08             	mov    0x8(%ebp),%eax
  104b78:	8b 50 08             	mov    0x8(%eax),%edx
  104b7b:	89 d0                	mov    %edx,%eax
  104b7d:	c1 e0 02             	shl    $0x2,%eax
  104b80:	01 d0                	add    %edx,%eax
  104b82:	c1 e0 02             	shl    $0x2,%eax
  104b85:	89 c2                	mov    %eax,%edx
  104b87:	8b 45 08             	mov    0x8(%ebp),%eax
  104b8a:	01 d0                	add    %edx,%eax
  104b8c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104b8f:	72 40                	jb     104bd1 <default_free_pages+0x2cb>
            assert(base + base->property != p);
  104b91:	8b 45 08             	mov    0x8(%ebp),%eax
  104b94:	8b 50 08             	mov    0x8(%eax),%edx
  104b97:	89 d0                	mov    %edx,%eax
  104b99:	c1 e0 02             	shl    $0x2,%eax
  104b9c:	01 d0                	add    %edx,%eax
  104b9e:	c1 e0 02             	shl    $0x2,%eax
  104ba1:	89 c2                	mov    %eax,%edx
  104ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  104ba6:	01 d0                	add    %edx,%eax
  104ba8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104bab:	75 3e                	jne    104beb <default_free_pages+0x2e5>
  104bad:	c7 44 24 0c 41 71 10 	movl   $0x107141,0xc(%esp)
  104bb4:	00 
  104bb5:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104bbc:	00 
  104bbd:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  104bc4:	00 
  104bc5:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104bcc:	e8 28 b8 ff ff       	call   1003f9 <__panic>
  104bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bd4:	89 45 98             	mov    %eax,-0x68(%ebp)
  104bd7:	8b 45 98             	mov    -0x68(%ebp),%eax
  104bda:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  104bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104be0:	81 7d f0 7c bf 11 00 	cmpl   $0x11bf7c,-0x10(%ebp)
  104be7:	75 83                	jne    104b6c <default_free_pages+0x266>
  104be9:	eb 01                	jmp    104bec <default_free_pages+0x2e6>
            break;
  104beb:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  104bec:	8b 45 08             	mov    0x8(%ebp),%eax
  104bef:	8d 50 0c             	lea    0xc(%eax),%edx
  104bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bf5:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104bf8:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  104bfb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104bfe:	8b 00                	mov    (%eax),%eax
  104c00:	8b 55 90             	mov    -0x70(%ebp),%edx
  104c03:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104c06:	89 45 88             	mov    %eax,-0x78(%ebp)
  104c09:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104c0c:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  104c0f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104c12:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104c15:	89 10                	mov    %edx,(%eax)
  104c17:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104c1a:	8b 10                	mov    (%eax),%edx
  104c1c:	8b 45 88             	mov    -0x78(%ebp),%eax
  104c1f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104c22:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104c25:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104c28:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104c2b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104c2e:	8b 55 88             	mov    -0x78(%ebp),%edx
  104c31:	89 10                	mov    %edx,(%eax)
}
  104c33:	90                   	nop
  104c34:	c9                   	leave  
  104c35:	c3                   	ret    

00104c36 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104c36:	55                   	push   %ebp
  104c37:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104c39:	a1 84 bf 11 00       	mov    0x11bf84,%eax
}
  104c3e:	5d                   	pop    %ebp
  104c3f:	c3                   	ret    

00104c40 <basic_check>:

static void
basic_check(void) {
  104c40:	55                   	push   %ebp
  104c41:	89 e5                	mov    %esp,%ebp
  104c43:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104c46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c56:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104c59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c60:	e8 ac e2 ff ff       	call   102f11 <alloc_pages>
  104c65:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104c6c:	75 24                	jne    104c92 <basic_check+0x52>
  104c6e:	c7 44 24 0c 5c 71 10 	movl   $0x10715c,0xc(%esp)
  104c75:	00 
  104c76:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104c7d:	00 
  104c7e:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  104c85:	00 
  104c86:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104c8d:	e8 67 b7 ff ff       	call   1003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104c92:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c99:	e8 73 e2 ff ff       	call   102f11 <alloc_pages>
  104c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ca1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ca5:	75 24                	jne    104ccb <basic_check+0x8b>
  104ca7:	c7 44 24 0c 78 71 10 	movl   $0x107178,0xc(%esp)
  104cae:	00 
  104caf:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104cb6:	00 
  104cb7:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  104cbe:	00 
  104cbf:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104cc6:	e8 2e b7 ff ff       	call   1003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104ccb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cd2:	e8 3a e2 ff ff       	call   102f11 <alloc_pages>
  104cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104cde:	75 24                	jne    104d04 <basic_check+0xc4>
  104ce0:	c7 44 24 0c 94 71 10 	movl   $0x107194,0xc(%esp)
  104ce7:	00 
  104ce8:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104cef:	00 
  104cf0:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  104cf7:	00 
  104cf8:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104cff:	e8 f5 b6 ff ff       	call   1003f9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d07:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104d0a:	74 10                	je     104d1c <basic_check+0xdc>
  104d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d0f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104d12:	74 08                	je     104d1c <basic_check+0xdc>
  104d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d17:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104d1a:	75 24                	jne    104d40 <basic_check+0x100>
  104d1c:	c7 44 24 0c b0 71 10 	movl   $0x1071b0,0xc(%esp)
  104d23:	00 
  104d24:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104d2b:	00 
  104d2c:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  104d33:	00 
  104d34:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104d3b:	e8 b9 b6 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d43:	89 04 24             	mov    %eax,(%esp)
  104d46:	e8 a3 f8 ff ff       	call   1045ee <page_ref>
  104d4b:	85 c0                	test   %eax,%eax
  104d4d:	75 1e                	jne    104d6d <basic_check+0x12d>
  104d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d52:	89 04 24             	mov    %eax,(%esp)
  104d55:	e8 94 f8 ff ff       	call   1045ee <page_ref>
  104d5a:	85 c0                	test   %eax,%eax
  104d5c:	75 0f                	jne    104d6d <basic_check+0x12d>
  104d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d61:	89 04 24             	mov    %eax,(%esp)
  104d64:	e8 85 f8 ff ff       	call   1045ee <page_ref>
  104d69:	85 c0                	test   %eax,%eax
  104d6b:	74 24                	je     104d91 <basic_check+0x151>
  104d6d:	c7 44 24 0c d4 71 10 	movl   $0x1071d4,0xc(%esp)
  104d74:	00 
  104d75:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104d7c:	00 
  104d7d:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  104d84:	00 
  104d85:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104d8c:	e8 68 b6 ff ff       	call   1003f9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d94:	89 04 24             	mov    %eax,(%esp)
  104d97:	e8 3c f8 ff ff       	call   1045d8 <page2pa>
  104d9c:	8b 15 80 be 11 00    	mov    0x11be80,%edx
  104da2:	c1 e2 0c             	shl    $0xc,%edx
  104da5:	39 d0                	cmp    %edx,%eax
  104da7:	72 24                	jb     104dcd <basic_check+0x18d>
  104da9:	c7 44 24 0c 10 72 10 	movl   $0x107210,0xc(%esp)
  104db0:	00 
  104db1:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104db8:	00 
  104db9:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  104dc0:	00 
  104dc1:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104dc8:	e8 2c b6 ff ff       	call   1003f9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dd0:	89 04 24             	mov    %eax,(%esp)
  104dd3:	e8 00 f8 ff ff       	call   1045d8 <page2pa>
  104dd8:	8b 15 80 be 11 00    	mov    0x11be80,%edx
  104dde:	c1 e2 0c             	shl    $0xc,%edx
  104de1:	39 d0                	cmp    %edx,%eax
  104de3:	72 24                	jb     104e09 <basic_check+0x1c9>
  104de5:	c7 44 24 0c 2d 72 10 	movl   $0x10722d,0xc(%esp)
  104dec:	00 
  104ded:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104df4:	00 
  104df5:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104dfc:	00 
  104dfd:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104e04:	e8 f0 b5 ff ff       	call   1003f9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e0c:	89 04 24             	mov    %eax,(%esp)
  104e0f:	e8 c4 f7 ff ff       	call   1045d8 <page2pa>
  104e14:	8b 15 80 be 11 00    	mov    0x11be80,%edx
  104e1a:	c1 e2 0c             	shl    $0xc,%edx
  104e1d:	39 d0                	cmp    %edx,%eax
  104e1f:	72 24                	jb     104e45 <basic_check+0x205>
  104e21:	c7 44 24 0c 4a 72 10 	movl   $0x10724a,0xc(%esp)
  104e28:	00 
  104e29:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104e30:	00 
  104e31:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  104e38:	00 
  104e39:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104e40:	e8 b4 b5 ff ff       	call   1003f9 <__panic>

    list_entry_t free_list_store = free_list;
  104e45:	a1 7c bf 11 00       	mov    0x11bf7c,%eax
  104e4a:	8b 15 80 bf 11 00    	mov    0x11bf80,%edx
  104e50:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104e53:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104e56:	c7 45 dc 7c bf 11 00 	movl   $0x11bf7c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104e5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104e60:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104e63:	89 50 04             	mov    %edx,0x4(%eax)
  104e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104e69:	8b 50 04             	mov    0x4(%eax),%edx
  104e6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104e6f:	89 10                	mov    %edx,(%eax)
  104e71:	c7 45 e0 7c bf 11 00 	movl   $0x11bf7c,-0x20(%ebp)
    return list->next == list;
  104e78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104e7b:	8b 40 04             	mov    0x4(%eax),%eax
  104e7e:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104e81:	0f 94 c0             	sete   %al
  104e84:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104e87:	85 c0                	test   %eax,%eax
  104e89:	75 24                	jne    104eaf <basic_check+0x26f>
  104e8b:	c7 44 24 0c 67 72 10 	movl   $0x107267,0xc(%esp)
  104e92:	00 
  104e93:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104e9a:	00 
  104e9b:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  104ea2:	00 
  104ea3:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104eaa:	e8 4a b5 ff ff       	call   1003f9 <__panic>

    unsigned int nr_free_store = nr_free;
  104eaf:	a1 84 bf 11 00       	mov    0x11bf84,%eax
  104eb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104eb7:	c7 05 84 bf 11 00 00 	movl   $0x0,0x11bf84
  104ebe:	00 00 00 

    assert(alloc_page() == NULL);
  104ec1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ec8:	e8 44 e0 ff ff       	call   102f11 <alloc_pages>
  104ecd:	85 c0                	test   %eax,%eax
  104ecf:	74 24                	je     104ef5 <basic_check+0x2b5>
  104ed1:	c7 44 24 0c 7e 72 10 	movl   $0x10727e,0xc(%esp)
  104ed8:	00 
  104ed9:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104ee0:	00 
  104ee1:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  104ee8:	00 
  104ee9:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104ef0:	e8 04 b5 ff ff       	call   1003f9 <__panic>

    free_page(p0);
  104ef5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104efc:	00 
  104efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f00:	89 04 24             	mov    %eax,(%esp)
  104f03:	e8 41 e0 ff ff       	call   102f49 <free_pages>
    free_page(p1);
  104f08:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f0f:	00 
  104f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f13:	89 04 24             	mov    %eax,(%esp)
  104f16:	e8 2e e0 ff ff       	call   102f49 <free_pages>
    free_page(p2);
  104f1b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f22:	00 
  104f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f26:	89 04 24             	mov    %eax,(%esp)
  104f29:	e8 1b e0 ff ff       	call   102f49 <free_pages>
    assert(nr_free == 3);
  104f2e:	a1 84 bf 11 00       	mov    0x11bf84,%eax
  104f33:	83 f8 03             	cmp    $0x3,%eax
  104f36:	74 24                	je     104f5c <basic_check+0x31c>
  104f38:	c7 44 24 0c 93 72 10 	movl   $0x107293,0xc(%esp)
  104f3f:	00 
  104f40:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104f47:	00 
  104f48:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  104f4f:	00 
  104f50:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104f57:	e8 9d b4 ff ff       	call   1003f9 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104f5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f63:	e8 a9 df ff ff       	call   102f11 <alloc_pages>
  104f68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104f6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104f6f:	75 24                	jne    104f95 <basic_check+0x355>
  104f71:	c7 44 24 0c 5c 71 10 	movl   $0x10715c,0xc(%esp)
  104f78:	00 
  104f79:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104f80:	00 
  104f81:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104f88:	00 
  104f89:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104f90:	e8 64 b4 ff ff       	call   1003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104f95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f9c:	e8 70 df ff ff       	call   102f11 <alloc_pages>
  104fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104fa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104fa8:	75 24                	jne    104fce <basic_check+0x38e>
  104faa:	c7 44 24 0c 78 71 10 	movl   $0x107178,0xc(%esp)
  104fb1:	00 
  104fb2:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104fb9:	00 
  104fba:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104fc1:	00 
  104fc2:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  104fc9:	e8 2b b4 ff ff       	call   1003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104fce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fd5:	e8 37 df ff ff       	call   102f11 <alloc_pages>
  104fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104fe1:	75 24                	jne    105007 <basic_check+0x3c7>
  104fe3:	c7 44 24 0c 94 71 10 	movl   $0x107194,0xc(%esp)
  104fea:	00 
  104feb:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  104ff2:	00 
  104ff3:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  104ffa:	00 
  104ffb:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105002:	e8 f2 b3 ff ff       	call   1003f9 <__panic>

    assert(alloc_page() == NULL);
  105007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10500e:	e8 fe de ff ff       	call   102f11 <alloc_pages>
  105013:	85 c0                	test   %eax,%eax
  105015:	74 24                	je     10503b <basic_check+0x3fb>
  105017:	c7 44 24 0c 7e 72 10 	movl   $0x10727e,0xc(%esp)
  10501e:	00 
  10501f:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105026:	00 
  105027:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  10502e:	00 
  10502f:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105036:	e8 be b3 ff ff       	call   1003f9 <__panic>

    free_page(p0);
  10503b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105042:	00 
  105043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105046:	89 04 24             	mov    %eax,(%esp)
  105049:	e8 fb de ff ff       	call   102f49 <free_pages>
  10504e:	c7 45 d8 7c bf 11 00 	movl   $0x11bf7c,-0x28(%ebp)
  105055:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105058:	8b 40 04             	mov    0x4(%eax),%eax
  10505b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10505e:	0f 94 c0             	sete   %al
  105061:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  105064:	85 c0                	test   %eax,%eax
  105066:	74 24                	je     10508c <basic_check+0x44c>
  105068:	c7 44 24 0c a0 72 10 	movl   $0x1072a0,0xc(%esp)
  10506f:	00 
  105070:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105077:	00 
  105078:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  10507f:	00 
  105080:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105087:	e8 6d b3 ff ff       	call   1003f9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10508c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105093:	e8 79 de ff ff       	call   102f11 <alloc_pages>
  105098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10509b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10509e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1050a1:	74 24                	je     1050c7 <basic_check+0x487>
  1050a3:	c7 44 24 0c b8 72 10 	movl   $0x1072b8,0xc(%esp)
  1050aa:	00 
  1050ab:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1050b2:	00 
  1050b3:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  1050ba:	00 
  1050bb:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1050c2:	e8 32 b3 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  1050c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050ce:	e8 3e de ff ff       	call   102f11 <alloc_pages>
  1050d3:	85 c0                	test   %eax,%eax
  1050d5:	74 24                	je     1050fb <basic_check+0x4bb>
  1050d7:	c7 44 24 0c 7e 72 10 	movl   $0x10727e,0xc(%esp)
  1050de:	00 
  1050df:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1050e6:	00 
  1050e7:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  1050ee:	00 
  1050ef:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1050f6:	e8 fe b2 ff ff       	call   1003f9 <__panic>

    assert(nr_free == 0);
  1050fb:	a1 84 bf 11 00       	mov    0x11bf84,%eax
  105100:	85 c0                	test   %eax,%eax
  105102:	74 24                	je     105128 <basic_check+0x4e8>
  105104:	c7 44 24 0c d1 72 10 	movl   $0x1072d1,0xc(%esp)
  10510b:	00 
  10510c:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105113:	00 
  105114:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  10511b:	00 
  10511c:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105123:	e8 d1 b2 ff ff       	call   1003f9 <__panic>
    free_list = free_list_store;
  105128:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10512b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10512e:	a3 7c bf 11 00       	mov    %eax,0x11bf7c
  105133:	89 15 80 bf 11 00    	mov    %edx,0x11bf80
    nr_free = nr_free_store;
  105139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10513c:	a3 84 bf 11 00       	mov    %eax,0x11bf84

    free_page(p);
  105141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105148:	00 
  105149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10514c:	89 04 24             	mov    %eax,(%esp)
  10514f:	e8 f5 dd ff ff       	call   102f49 <free_pages>
    free_page(p1);
  105154:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10515b:	00 
  10515c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10515f:	89 04 24             	mov    %eax,(%esp)
  105162:	e8 e2 dd ff ff       	call   102f49 <free_pages>
    free_page(p2);
  105167:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10516e:	00 
  10516f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105172:	89 04 24             	mov    %eax,(%esp)
  105175:	e8 cf dd ff ff       	call   102f49 <free_pages>
}
  10517a:	90                   	nop
  10517b:	c9                   	leave  
  10517c:	c3                   	ret    

0010517d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10517d:	55                   	push   %ebp
  10517e:	89 e5                	mov    %esp,%ebp
  105180:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  105186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10518d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  105194:	c7 45 ec 7c bf 11 00 	movl   $0x11bf7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10519b:	eb 6a                	jmp    105207 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  10519d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051a0:	83 e8 0c             	sub    $0xc,%eax
  1051a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  1051a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1051a9:	83 c0 04             	add    $0x4,%eax
  1051ac:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1051b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1051b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1051b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1051bc:	0f a3 10             	bt     %edx,(%eax)
  1051bf:	19 c0                	sbb    %eax,%eax
  1051c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1051c4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1051c8:	0f 95 c0             	setne  %al
  1051cb:	0f b6 c0             	movzbl %al,%eax
  1051ce:	85 c0                	test   %eax,%eax
  1051d0:	75 24                	jne    1051f6 <default_check+0x79>
  1051d2:	c7 44 24 0c de 72 10 	movl   $0x1072de,0xc(%esp)
  1051d9:	00 
  1051da:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1051e1:	00 
  1051e2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  1051e9:	00 
  1051ea:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1051f1:	e8 03 b2 ff ff       	call   1003f9 <__panic>
        count ++, total += p->property;
  1051f6:	ff 45 f4             	incl   -0xc(%ebp)
  1051f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1051fc:	8b 50 08             	mov    0x8(%eax),%edx
  1051ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105202:	01 d0                	add    %edx,%eax
  105204:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10520a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  10520d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105210:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105213:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105216:	81 7d ec 7c bf 11 00 	cmpl   $0x11bf7c,-0x14(%ebp)
  10521d:	0f 85 7a ff ff ff    	jne    10519d <default_check+0x20>
    }
    assert(total == nr_free_pages());
  105223:	e8 54 dd ff ff       	call   102f7c <nr_free_pages>
  105228:	89 c2                	mov    %eax,%edx
  10522a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10522d:	39 c2                	cmp    %eax,%edx
  10522f:	74 24                	je     105255 <default_check+0xd8>
  105231:	c7 44 24 0c ee 72 10 	movl   $0x1072ee,0xc(%esp)
  105238:	00 
  105239:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105240:	00 
  105241:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  105248:	00 
  105249:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105250:	e8 a4 b1 ff ff       	call   1003f9 <__panic>

    basic_check();
  105255:	e8 e6 f9 ff ff       	call   104c40 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10525a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105261:	e8 ab dc ff ff       	call   102f11 <alloc_pages>
  105266:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  105269:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10526d:	75 24                	jne    105293 <default_check+0x116>
  10526f:	c7 44 24 0c 07 73 10 	movl   $0x107307,0xc(%esp)
  105276:	00 
  105277:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  10527e:	00 
  10527f:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  105286:	00 
  105287:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  10528e:	e8 66 b1 ff ff       	call   1003f9 <__panic>
    assert(!PageProperty(p0));
  105293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105296:	83 c0 04             	add    $0x4,%eax
  105299:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1052a0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1052a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1052a6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1052a9:	0f a3 10             	bt     %edx,(%eax)
  1052ac:	19 c0                	sbb    %eax,%eax
  1052ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1052b1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1052b5:	0f 95 c0             	setne  %al
  1052b8:	0f b6 c0             	movzbl %al,%eax
  1052bb:	85 c0                	test   %eax,%eax
  1052bd:	74 24                	je     1052e3 <default_check+0x166>
  1052bf:	c7 44 24 0c 12 73 10 	movl   $0x107312,0xc(%esp)
  1052c6:	00 
  1052c7:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1052ce:	00 
  1052cf:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  1052d6:	00 
  1052d7:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1052de:	e8 16 b1 ff ff       	call   1003f9 <__panic>

    list_entry_t free_list_store = free_list;
  1052e3:	a1 7c bf 11 00       	mov    0x11bf7c,%eax
  1052e8:	8b 15 80 bf 11 00    	mov    0x11bf80,%edx
  1052ee:	89 45 80             	mov    %eax,-0x80(%ebp)
  1052f1:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1052f4:	c7 45 b0 7c bf 11 00 	movl   $0x11bf7c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1052fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1052fe:	8b 55 b0             	mov    -0x50(%ebp),%edx
  105301:	89 50 04             	mov    %edx,0x4(%eax)
  105304:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105307:	8b 50 04             	mov    0x4(%eax),%edx
  10530a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10530d:	89 10                	mov    %edx,(%eax)
  10530f:	c7 45 b4 7c bf 11 00 	movl   $0x11bf7c,-0x4c(%ebp)
    return list->next == list;
  105316:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105319:	8b 40 04             	mov    0x4(%eax),%eax
  10531c:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  10531f:	0f 94 c0             	sete   %al
  105322:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  105325:	85 c0                	test   %eax,%eax
  105327:	75 24                	jne    10534d <default_check+0x1d0>
  105329:	c7 44 24 0c 67 72 10 	movl   $0x107267,0xc(%esp)
  105330:	00 
  105331:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105338:	00 
  105339:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  105340:	00 
  105341:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105348:	e8 ac b0 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  10534d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105354:	e8 b8 db ff ff       	call   102f11 <alloc_pages>
  105359:	85 c0                	test   %eax,%eax
  10535b:	74 24                	je     105381 <default_check+0x204>
  10535d:	c7 44 24 0c 7e 72 10 	movl   $0x10727e,0xc(%esp)
  105364:	00 
  105365:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  10536c:	00 
  10536d:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  105374:	00 
  105375:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  10537c:	e8 78 b0 ff ff       	call   1003f9 <__panic>

    unsigned int nr_free_store = nr_free;
  105381:	a1 84 bf 11 00       	mov    0x11bf84,%eax
  105386:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  105389:	c7 05 84 bf 11 00 00 	movl   $0x0,0x11bf84
  105390:	00 00 00 

    free_pages(p0 + 2, 3);
  105393:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105396:	83 c0 28             	add    $0x28,%eax
  105399:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1053a0:	00 
  1053a1:	89 04 24             	mov    %eax,(%esp)
  1053a4:	e8 a0 db ff ff       	call   102f49 <free_pages>
    assert(alloc_pages(4) == NULL);
  1053a9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1053b0:	e8 5c db ff ff       	call   102f11 <alloc_pages>
  1053b5:	85 c0                	test   %eax,%eax
  1053b7:	74 24                	je     1053dd <default_check+0x260>
  1053b9:	c7 44 24 0c 24 73 10 	movl   $0x107324,0xc(%esp)
  1053c0:	00 
  1053c1:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1053c8:	00 
  1053c9:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  1053d0:	00 
  1053d1:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1053d8:	e8 1c b0 ff ff       	call   1003f9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1053dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053e0:	83 c0 28             	add    $0x28,%eax
  1053e3:	83 c0 04             	add    $0x4,%eax
  1053e6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1053ed:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1053f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1053f3:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1053f6:	0f a3 10             	bt     %edx,(%eax)
  1053f9:	19 c0                	sbb    %eax,%eax
  1053fb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1053fe:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105402:	0f 95 c0             	setne  %al
  105405:	0f b6 c0             	movzbl %al,%eax
  105408:	85 c0                	test   %eax,%eax
  10540a:	74 0e                	je     10541a <default_check+0x29d>
  10540c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10540f:	83 c0 28             	add    $0x28,%eax
  105412:	8b 40 08             	mov    0x8(%eax),%eax
  105415:	83 f8 03             	cmp    $0x3,%eax
  105418:	74 24                	je     10543e <default_check+0x2c1>
  10541a:	c7 44 24 0c 3c 73 10 	movl   $0x10733c,0xc(%esp)
  105421:	00 
  105422:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105429:	00 
  10542a:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  105431:	00 
  105432:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105439:	e8 bb af ff ff       	call   1003f9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10543e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  105445:	e8 c7 da ff ff       	call   102f11 <alloc_pages>
  10544a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10544d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105451:	75 24                	jne    105477 <default_check+0x2fa>
  105453:	c7 44 24 0c 68 73 10 	movl   $0x107368,0xc(%esp)
  10545a:	00 
  10545b:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105462:	00 
  105463:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  10546a:	00 
  10546b:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105472:	e8 82 af ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  105477:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10547e:	e8 8e da ff ff       	call   102f11 <alloc_pages>
  105483:	85 c0                	test   %eax,%eax
  105485:	74 24                	je     1054ab <default_check+0x32e>
  105487:	c7 44 24 0c 7e 72 10 	movl   $0x10727e,0xc(%esp)
  10548e:	00 
  10548f:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105496:	00 
  105497:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10549e:	00 
  10549f:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1054a6:	e8 4e af ff ff       	call   1003f9 <__panic>
    assert(p0 + 2 == p1);
  1054ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054ae:	83 c0 28             	add    $0x28,%eax
  1054b1:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1054b4:	74 24                	je     1054da <default_check+0x35d>
  1054b6:	c7 44 24 0c 86 73 10 	movl   $0x107386,0xc(%esp)
  1054bd:	00 
  1054be:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1054c5:	00 
  1054c6:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  1054cd:	00 
  1054ce:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1054d5:	e8 1f af ff ff       	call   1003f9 <__panic>

    p2 = p0 + 1;
  1054da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054dd:	83 c0 14             	add    $0x14,%eax
  1054e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1054e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1054ea:	00 
  1054eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054ee:	89 04 24             	mov    %eax,(%esp)
  1054f1:	e8 53 da ff ff       	call   102f49 <free_pages>
    free_pages(p1, 3);
  1054f6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1054fd:	00 
  1054fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105501:	89 04 24             	mov    %eax,(%esp)
  105504:	e8 40 da ff ff       	call   102f49 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  105509:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10550c:	83 c0 04             	add    $0x4,%eax
  10550f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  105516:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105519:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10551c:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10551f:	0f a3 10             	bt     %edx,(%eax)
  105522:	19 c0                	sbb    %eax,%eax
  105524:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  105527:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10552b:	0f 95 c0             	setne  %al
  10552e:	0f b6 c0             	movzbl %al,%eax
  105531:	85 c0                	test   %eax,%eax
  105533:	74 0b                	je     105540 <default_check+0x3c3>
  105535:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105538:	8b 40 08             	mov    0x8(%eax),%eax
  10553b:	83 f8 01             	cmp    $0x1,%eax
  10553e:	74 24                	je     105564 <default_check+0x3e7>
  105540:	c7 44 24 0c 94 73 10 	movl   $0x107394,0xc(%esp)
  105547:	00 
  105548:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  10554f:	00 
  105550:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  105557:	00 
  105558:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  10555f:	e8 95 ae ff ff       	call   1003f9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105564:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105567:	83 c0 04             	add    $0x4,%eax
  10556a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105571:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105574:	8b 45 90             	mov    -0x70(%ebp),%eax
  105577:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10557a:	0f a3 10             	bt     %edx,(%eax)
  10557d:	19 c0                	sbb    %eax,%eax
  10557f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105582:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105586:	0f 95 c0             	setne  %al
  105589:	0f b6 c0             	movzbl %al,%eax
  10558c:	85 c0                	test   %eax,%eax
  10558e:	74 0b                	je     10559b <default_check+0x41e>
  105590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105593:	8b 40 08             	mov    0x8(%eax),%eax
  105596:	83 f8 03             	cmp    $0x3,%eax
  105599:	74 24                	je     1055bf <default_check+0x442>
  10559b:	c7 44 24 0c bc 73 10 	movl   $0x1073bc,0xc(%esp)
  1055a2:	00 
  1055a3:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1055aa:	00 
  1055ab:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  1055b2:	00 
  1055b3:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1055ba:	e8 3a ae ff ff       	call   1003f9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1055bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055c6:	e8 46 d9 ff ff       	call   102f11 <alloc_pages>
  1055cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1055d1:	83 e8 14             	sub    $0x14,%eax
  1055d4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1055d7:	74 24                	je     1055fd <default_check+0x480>
  1055d9:	c7 44 24 0c e2 73 10 	movl   $0x1073e2,0xc(%esp)
  1055e0:	00 
  1055e1:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1055e8:	00 
  1055e9:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  1055f0:	00 
  1055f1:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1055f8:	e8 fc ad ff ff       	call   1003f9 <__panic>
    free_page(p0);
  1055fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105604:	00 
  105605:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105608:	89 04 24             	mov    %eax,(%esp)
  10560b:	e8 39 d9 ff ff       	call   102f49 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  105610:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105617:	e8 f5 d8 ff ff       	call   102f11 <alloc_pages>
  10561c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10561f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105622:	83 c0 14             	add    $0x14,%eax
  105625:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105628:	74 24                	je     10564e <default_check+0x4d1>
  10562a:	c7 44 24 0c 00 74 10 	movl   $0x107400,0xc(%esp)
  105631:	00 
  105632:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105639:	00 
  10563a:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  105641:	00 
  105642:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105649:	e8 ab ad ff ff       	call   1003f9 <__panic>

    free_pages(p0, 2);
  10564e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  105655:	00 
  105656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105659:	89 04 24             	mov    %eax,(%esp)
  10565c:	e8 e8 d8 ff ff       	call   102f49 <free_pages>
    free_page(p2);
  105661:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105668:	00 
  105669:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10566c:	89 04 24             	mov    %eax,(%esp)
  10566f:	e8 d5 d8 ff ff       	call   102f49 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105674:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10567b:	e8 91 d8 ff ff       	call   102f11 <alloc_pages>
  105680:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105683:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105687:	75 24                	jne    1056ad <default_check+0x530>
  105689:	c7 44 24 0c 20 74 10 	movl   $0x107420,0xc(%esp)
  105690:	00 
  105691:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  105698:	00 
  105699:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  1056a0:	00 
  1056a1:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1056a8:	e8 4c ad ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  1056ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1056b4:	e8 58 d8 ff ff       	call   102f11 <alloc_pages>
  1056b9:	85 c0                	test   %eax,%eax
  1056bb:	74 24                	je     1056e1 <default_check+0x564>
  1056bd:	c7 44 24 0c 7e 72 10 	movl   $0x10727e,0xc(%esp)
  1056c4:	00 
  1056c5:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1056cc:	00 
  1056cd:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  1056d4:	00 
  1056d5:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1056dc:	e8 18 ad ff ff       	call   1003f9 <__panic>

    assert(nr_free == 0);
  1056e1:	a1 84 bf 11 00       	mov    0x11bf84,%eax
  1056e6:	85 c0                	test   %eax,%eax
  1056e8:	74 24                	je     10570e <default_check+0x591>
  1056ea:	c7 44 24 0c d1 72 10 	movl   $0x1072d1,0xc(%esp)
  1056f1:	00 
  1056f2:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1056f9:	00 
  1056fa:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  105701:	00 
  105702:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105709:	e8 eb ac ff ff       	call   1003f9 <__panic>
    nr_free = nr_free_store;
  10570e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105711:	a3 84 bf 11 00       	mov    %eax,0x11bf84

    free_list = free_list_store;
  105716:	8b 45 80             	mov    -0x80(%ebp),%eax
  105719:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10571c:	a3 7c bf 11 00       	mov    %eax,0x11bf7c
  105721:	89 15 80 bf 11 00    	mov    %edx,0x11bf80
    free_pages(p0, 5);
  105727:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10572e:	00 
  10572f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105732:	89 04 24             	mov    %eax,(%esp)
  105735:	e8 0f d8 ff ff       	call   102f49 <free_pages>

    le = &free_list;
  10573a:	c7 45 ec 7c bf 11 00 	movl   $0x11bf7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105741:	eb 5a                	jmp    10579d <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
  105743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105746:	8b 40 04             	mov    0x4(%eax),%eax
  105749:	8b 00                	mov    (%eax),%eax
  10574b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10574e:	75 0d                	jne    10575d <default_check+0x5e0>
  105750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105753:	8b 00                	mov    (%eax),%eax
  105755:	8b 40 04             	mov    0x4(%eax),%eax
  105758:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10575b:	74 24                	je     105781 <default_check+0x604>
  10575d:	c7 44 24 0c 40 74 10 	movl   $0x107440,0xc(%esp)
  105764:	00 
  105765:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  10576c:	00 
  10576d:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  105774:	00 
  105775:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  10577c:	e8 78 ac ff ff       	call   1003f9 <__panic>
        struct Page *p = le2page(le, page_link);
  105781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105784:	83 e8 0c             	sub    $0xc,%eax
  105787:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  10578a:	ff 4d f4             	decl   -0xc(%ebp)
  10578d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105790:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105793:	8b 40 08             	mov    0x8(%eax),%eax
  105796:	29 c2                	sub    %eax,%edx
  105798:	89 d0                	mov    %edx,%eax
  10579a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10579d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057a0:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  1057a3:	8b 45 88             	mov    -0x78(%ebp),%eax
  1057a6:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1057a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1057ac:	81 7d ec 7c bf 11 00 	cmpl   $0x11bf7c,-0x14(%ebp)
  1057b3:	75 8e                	jne    105743 <default_check+0x5c6>
    }
    assert(count == 0);
  1057b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1057b9:	74 24                	je     1057df <default_check+0x662>
  1057bb:	c7 44 24 0c 6d 74 10 	movl   $0x10746d,0xc(%esp)
  1057c2:	00 
  1057c3:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1057ca:	00 
  1057cb:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  1057d2:	00 
  1057d3:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  1057da:	e8 1a ac ff ff       	call   1003f9 <__panic>
    assert(total == 0);
  1057df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1057e3:	74 24                	je     105809 <default_check+0x68c>
  1057e5:	c7 44 24 0c 78 74 10 	movl   $0x107478,0xc(%esp)
  1057ec:	00 
  1057ed:	c7 44 24 08 de 70 10 	movl   $0x1070de,0x8(%esp)
  1057f4:	00 
  1057f5:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  1057fc:	00 
  1057fd:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  105804:	e8 f0 ab ff ff       	call   1003f9 <__panic>
}
  105809:	90                   	nop
  10580a:	c9                   	leave  
  10580b:	c3                   	ret    

0010580c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10580c:	55                   	push   %ebp
  10580d:	89 e5                	mov    %esp,%ebp
  10580f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105812:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105819:	eb 03                	jmp    10581e <strlen+0x12>
        cnt ++;
  10581b:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  10581e:	8b 45 08             	mov    0x8(%ebp),%eax
  105821:	8d 50 01             	lea    0x1(%eax),%edx
  105824:	89 55 08             	mov    %edx,0x8(%ebp)
  105827:	0f b6 00             	movzbl (%eax),%eax
  10582a:	84 c0                	test   %al,%al
  10582c:	75 ed                	jne    10581b <strlen+0xf>
    }
    return cnt;
  10582e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105831:	c9                   	leave  
  105832:	c3                   	ret    

00105833 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105833:	55                   	push   %ebp
  105834:	89 e5                	mov    %esp,%ebp
  105836:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105839:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105840:	eb 03                	jmp    105845 <strnlen+0x12>
        cnt ++;
  105842:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105845:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105848:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10584b:	73 10                	jae    10585d <strnlen+0x2a>
  10584d:	8b 45 08             	mov    0x8(%ebp),%eax
  105850:	8d 50 01             	lea    0x1(%eax),%edx
  105853:	89 55 08             	mov    %edx,0x8(%ebp)
  105856:	0f b6 00             	movzbl (%eax),%eax
  105859:	84 c0                	test   %al,%al
  10585b:	75 e5                	jne    105842 <strnlen+0xf>
    }
    return cnt;
  10585d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105860:	c9                   	leave  
  105861:	c3                   	ret    

00105862 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105862:	55                   	push   %ebp
  105863:	89 e5                	mov    %esp,%ebp
  105865:	57                   	push   %edi
  105866:	56                   	push   %esi
  105867:	83 ec 20             	sub    $0x20,%esp
  10586a:	8b 45 08             	mov    0x8(%ebp),%eax
  10586d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105870:	8b 45 0c             	mov    0xc(%ebp),%eax
  105873:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105876:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10587c:	89 d1                	mov    %edx,%ecx
  10587e:	89 c2                	mov    %eax,%edx
  105880:	89 ce                	mov    %ecx,%esi
  105882:	89 d7                	mov    %edx,%edi
  105884:	ac                   	lods   %ds:(%esi),%al
  105885:	aa                   	stos   %al,%es:(%edi)
  105886:	84 c0                	test   %al,%al
  105888:	75 fa                	jne    105884 <strcpy+0x22>
  10588a:	89 fa                	mov    %edi,%edx
  10588c:	89 f1                	mov    %esi,%ecx
  10588e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105891:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105897:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  10589a:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10589b:	83 c4 20             	add    $0x20,%esp
  10589e:	5e                   	pop    %esi
  10589f:	5f                   	pop    %edi
  1058a0:	5d                   	pop    %ebp
  1058a1:	c3                   	ret    

001058a2 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1058a2:	55                   	push   %ebp
  1058a3:	89 e5                	mov    %esp,%ebp
  1058a5:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1058a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1058ae:	eb 1e                	jmp    1058ce <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  1058b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b3:	0f b6 10             	movzbl (%eax),%edx
  1058b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1058b9:	88 10                	mov    %dl,(%eax)
  1058bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1058be:	0f b6 00             	movzbl (%eax),%eax
  1058c1:	84 c0                	test   %al,%al
  1058c3:	74 03                	je     1058c8 <strncpy+0x26>
            src ++;
  1058c5:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1058c8:	ff 45 fc             	incl   -0x4(%ebp)
  1058cb:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1058ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1058d2:	75 dc                	jne    1058b0 <strncpy+0xe>
    }
    return dst;
  1058d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1058d7:	c9                   	leave  
  1058d8:	c3                   	ret    

001058d9 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1058d9:	55                   	push   %ebp
  1058da:	89 e5                	mov    %esp,%ebp
  1058dc:	57                   	push   %edi
  1058dd:	56                   	push   %esi
  1058de:	83 ec 20             	sub    $0x20,%esp
  1058e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1058e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1058ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058f3:	89 d1                	mov    %edx,%ecx
  1058f5:	89 c2                	mov    %eax,%edx
  1058f7:	89 ce                	mov    %ecx,%esi
  1058f9:	89 d7                	mov    %edx,%edi
  1058fb:	ac                   	lods   %ds:(%esi),%al
  1058fc:	ae                   	scas   %es:(%edi),%al
  1058fd:	75 08                	jne    105907 <strcmp+0x2e>
  1058ff:	84 c0                	test   %al,%al
  105901:	75 f8                	jne    1058fb <strcmp+0x22>
  105903:	31 c0                	xor    %eax,%eax
  105905:	eb 04                	jmp    10590b <strcmp+0x32>
  105907:	19 c0                	sbb    %eax,%eax
  105909:	0c 01                	or     $0x1,%al
  10590b:	89 fa                	mov    %edi,%edx
  10590d:	89 f1                	mov    %esi,%ecx
  10590f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105912:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105915:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105918:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  10591b:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10591c:	83 c4 20             	add    $0x20,%esp
  10591f:	5e                   	pop    %esi
  105920:	5f                   	pop    %edi
  105921:	5d                   	pop    %ebp
  105922:	c3                   	ret    

00105923 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105923:	55                   	push   %ebp
  105924:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105926:	eb 09                	jmp    105931 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105928:	ff 4d 10             	decl   0x10(%ebp)
  10592b:	ff 45 08             	incl   0x8(%ebp)
  10592e:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105931:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105935:	74 1a                	je     105951 <strncmp+0x2e>
  105937:	8b 45 08             	mov    0x8(%ebp),%eax
  10593a:	0f b6 00             	movzbl (%eax),%eax
  10593d:	84 c0                	test   %al,%al
  10593f:	74 10                	je     105951 <strncmp+0x2e>
  105941:	8b 45 08             	mov    0x8(%ebp),%eax
  105944:	0f b6 10             	movzbl (%eax),%edx
  105947:	8b 45 0c             	mov    0xc(%ebp),%eax
  10594a:	0f b6 00             	movzbl (%eax),%eax
  10594d:	38 c2                	cmp    %al,%dl
  10594f:	74 d7                	je     105928 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105951:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105955:	74 18                	je     10596f <strncmp+0x4c>
  105957:	8b 45 08             	mov    0x8(%ebp),%eax
  10595a:	0f b6 00             	movzbl (%eax),%eax
  10595d:	0f b6 d0             	movzbl %al,%edx
  105960:	8b 45 0c             	mov    0xc(%ebp),%eax
  105963:	0f b6 00             	movzbl (%eax),%eax
  105966:	0f b6 c0             	movzbl %al,%eax
  105969:	29 c2                	sub    %eax,%edx
  10596b:	89 d0                	mov    %edx,%eax
  10596d:	eb 05                	jmp    105974 <strncmp+0x51>
  10596f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105974:	5d                   	pop    %ebp
  105975:	c3                   	ret    

00105976 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105976:	55                   	push   %ebp
  105977:	89 e5                	mov    %esp,%ebp
  105979:	83 ec 04             	sub    $0x4,%esp
  10597c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10597f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105982:	eb 13                	jmp    105997 <strchr+0x21>
        if (*s == c) {
  105984:	8b 45 08             	mov    0x8(%ebp),%eax
  105987:	0f b6 00             	movzbl (%eax),%eax
  10598a:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10598d:	75 05                	jne    105994 <strchr+0x1e>
            return (char *)s;
  10598f:	8b 45 08             	mov    0x8(%ebp),%eax
  105992:	eb 12                	jmp    1059a6 <strchr+0x30>
        }
        s ++;
  105994:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105997:	8b 45 08             	mov    0x8(%ebp),%eax
  10599a:	0f b6 00             	movzbl (%eax),%eax
  10599d:	84 c0                	test   %al,%al
  10599f:	75 e3                	jne    105984 <strchr+0xe>
    }
    return NULL;
  1059a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1059a6:	c9                   	leave  
  1059a7:	c3                   	ret    

001059a8 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1059a8:	55                   	push   %ebp
  1059a9:	89 e5                	mov    %esp,%ebp
  1059ab:	83 ec 04             	sub    $0x4,%esp
  1059ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1059b4:	eb 0e                	jmp    1059c4 <strfind+0x1c>
        if (*s == c) {
  1059b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b9:	0f b6 00             	movzbl (%eax),%eax
  1059bc:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1059bf:	74 0f                	je     1059d0 <strfind+0x28>
            break;
        }
        s ++;
  1059c1:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1059c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c7:	0f b6 00             	movzbl (%eax),%eax
  1059ca:	84 c0                	test   %al,%al
  1059cc:	75 e8                	jne    1059b6 <strfind+0xe>
  1059ce:	eb 01                	jmp    1059d1 <strfind+0x29>
            break;
  1059d0:	90                   	nop
    }
    return (char *)s;
  1059d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1059d4:	c9                   	leave  
  1059d5:	c3                   	ret    

001059d6 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1059d6:	55                   	push   %ebp
  1059d7:	89 e5                	mov    %esp,%ebp
  1059d9:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1059dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1059e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1059ea:	eb 03                	jmp    1059ef <strtol+0x19>
        s ++;
  1059ec:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1059ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f2:	0f b6 00             	movzbl (%eax),%eax
  1059f5:	3c 20                	cmp    $0x20,%al
  1059f7:	74 f3                	je     1059ec <strtol+0x16>
  1059f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059fc:	0f b6 00             	movzbl (%eax),%eax
  1059ff:	3c 09                	cmp    $0x9,%al
  105a01:	74 e9                	je     1059ec <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105a03:	8b 45 08             	mov    0x8(%ebp),%eax
  105a06:	0f b6 00             	movzbl (%eax),%eax
  105a09:	3c 2b                	cmp    $0x2b,%al
  105a0b:	75 05                	jne    105a12 <strtol+0x3c>
        s ++;
  105a0d:	ff 45 08             	incl   0x8(%ebp)
  105a10:	eb 14                	jmp    105a26 <strtol+0x50>
    }
    else if (*s == '-') {
  105a12:	8b 45 08             	mov    0x8(%ebp),%eax
  105a15:	0f b6 00             	movzbl (%eax),%eax
  105a18:	3c 2d                	cmp    $0x2d,%al
  105a1a:	75 0a                	jne    105a26 <strtol+0x50>
        s ++, neg = 1;
  105a1c:	ff 45 08             	incl   0x8(%ebp)
  105a1f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a2a:	74 06                	je     105a32 <strtol+0x5c>
  105a2c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105a30:	75 22                	jne    105a54 <strtol+0x7e>
  105a32:	8b 45 08             	mov    0x8(%ebp),%eax
  105a35:	0f b6 00             	movzbl (%eax),%eax
  105a38:	3c 30                	cmp    $0x30,%al
  105a3a:	75 18                	jne    105a54 <strtol+0x7e>
  105a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a3f:	40                   	inc    %eax
  105a40:	0f b6 00             	movzbl (%eax),%eax
  105a43:	3c 78                	cmp    $0x78,%al
  105a45:	75 0d                	jne    105a54 <strtol+0x7e>
        s += 2, base = 16;
  105a47:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105a4b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105a52:	eb 29                	jmp    105a7d <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105a54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a58:	75 16                	jne    105a70 <strtol+0x9a>
  105a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a5d:	0f b6 00             	movzbl (%eax),%eax
  105a60:	3c 30                	cmp    $0x30,%al
  105a62:	75 0c                	jne    105a70 <strtol+0x9a>
        s ++, base = 8;
  105a64:	ff 45 08             	incl   0x8(%ebp)
  105a67:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105a6e:	eb 0d                	jmp    105a7d <strtol+0xa7>
    }
    else if (base == 0) {
  105a70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a74:	75 07                	jne    105a7d <strtol+0xa7>
        base = 10;
  105a76:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a80:	0f b6 00             	movzbl (%eax),%eax
  105a83:	3c 2f                	cmp    $0x2f,%al
  105a85:	7e 1b                	jle    105aa2 <strtol+0xcc>
  105a87:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8a:	0f b6 00             	movzbl (%eax),%eax
  105a8d:	3c 39                	cmp    $0x39,%al
  105a8f:	7f 11                	jg     105aa2 <strtol+0xcc>
            dig = *s - '0';
  105a91:	8b 45 08             	mov    0x8(%ebp),%eax
  105a94:	0f b6 00             	movzbl (%eax),%eax
  105a97:	0f be c0             	movsbl %al,%eax
  105a9a:	83 e8 30             	sub    $0x30,%eax
  105a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105aa0:	eb 48                	jmp    105aea <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa5:	0f b6 00             	movzbl (%eax),%eax
  105aa8:	3c 60                	cmp    $0x60,%al
  105aaa:	7e 1b                	jle    105ac7 <strtol+0xf1>
  105aac:	8b 45 08             	mov    0x8(%ebp),%eax
  105aaf:	0f b6 00             	movzbl (%eax),%eax
  105ab2:	3c 7a                	cmp    $0x7a,%al
  105ab4:	7f 11                	jg     105ac7 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab9:	0f b6 00             	movzbl (%eax),%eax
  105abc:	0f be c0             	movsbl %al,%eax
  105abf:	83 e8 57             	sub    $0x57,%eax
  105ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ac5:	eb 23                	jmp    105aea <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  105aca:	0f b6 00             	movzbl (%eax),%eax
  105acd:	3c 40                	cmp    $0x40,%al
  105acf:	7e 3b                	jle    105b0c <strtol+0x136>
  105ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad4:	0f b6 00             	movzbl (%eax),%eax
  105ad7:	3c 5a                	cmp    $0x5a,%al
  105ad9:	7f 31                	jg     105b0c <strtol+0x136>
            dig = *s - 'A' + 10;
  105adb:	8b 45 08             	mov    0x8(%ebp),%eax
  105ade:	0f b6 00             	movzbl (%eax),%eax
  105ae1:	0f be c0             	movsbl %al,%eax
  105ae4:	83 e8 37             	sub    $0x37,%eax
  105ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105aed:	3b 45 10             	cmp    0x10(%ebp),%eax
  105af0:	7d 19                	jge    105b0b <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105af2:	ff 45 08             	incl   0x8(%ebp)
  105af5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105af8:	0f af 45 10          	imul   0x10(%ebp),%eax
  105afc:	89 c2                	mov    %eax,%edx
  105afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b01:	01 d0                	add    %edx,%eax
  105b03:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105b06:	e9 72 ff ff ff       	jmp    105a7d <strtol+0xa7>
            break;
  105b0b:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105b0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105b10:	74 08                	je     105b1a <strtol+0x144>
        *endptr = (char *) s;
  105b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b15:	8b 55 08             	mov    0x8(%ebp),%edx
  105b18:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105b1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105b1e:	74 07                	je     105b27 <strtol+0x151>
  105b20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b23:	f7 d8                	neg    %eax
  105b25:	eb 03                	jmp    105b2a <strtol+0x154>
  105b27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105b2a:	c9                   	leave  
  105b2b:	c3                   	ret    

00105b2c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105b2c:	55                   	push   %ebp
  105b2d:	89 e5                	mov    %esp,%ebp
  105b2f:	57                   	push   %edi
  105b30:	83 ec 24             	sub    $0x24,%esp
  105b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b36:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105b39:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  105b40:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105b43:	88 45 f7             	mov    %al,-0x9(%ebp)
  105b46:	8b 45 10             	mov    0x10(%ebp),%eax
  105b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105b4c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105b4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105b53:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105b56:	89 d7                	mov    %edx,%edi
  105b58:	f3 aa                	rep stos %al,%es:(%edi)
  105b5a:	89 fa                	mov    %edi,%edx
  105b5c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b5f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105b62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b65:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105b66:	83 c4 24             	add    $0x24,%esp
  105b69:	5f                   	pop    %edi
  105b6a:	5d                   	pop    %ebp
  105b6b:	c3                   	ret    

00105b6c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105b6c:	55                   	push   %ebp
  105b6d:	89 e5                	mov    %esp,%ebp
  105b6f:	57                   	push   %edi
  105b70:	56                   	push   %esi
  105b71:	53                   	push   %ebx
  105b72:	83 ec 30             	sub    $0x30,%esp
  105b75:	8b 45 08             	mov    0x8(%ebp),%eax
  105b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b81:	8b 45 10             	mov    0x10(%ebp),%eax
  105b84:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105b8d:	73 42                	jae    105bd1 <memmove+0x65>
  105b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b98:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b9e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105ba1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ba4:	c1 e8 02             	shr    $0x2,%eax
  105ba7:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105ba9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105bac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105baf:	89 d7                	mov    %edx,%edi
  105bb1:	89 c6                	mov    %eax,%esi
  105bb3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105bb5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105bb8:	83 e1 03             	and    $0x3,%ecx
  105bbb:	74 02                	je     105bbf <memmove+0x53>
  105bbd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105bbf:	89 f0                	mov    %esi,%eax
  105bc1:	89 fa                	mov    %edi,%edx
  105bc3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105bc6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105bc9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  105bcf:	eb 36                	jmp    105c07 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105bd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  105bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105bda:	01 c2                	add    %eax,%edx
  105bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105bdf:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105be5:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105be8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105beb:	89 c1                	mov    %eax,%ecx
  105bed:	89 d8                	mov    %ebx,%eax
  105bef:	89 d6                	mov    %edx,%esi
  105bf1:	89 c7                	mov    %eax,%edi
  105bf3:	fd                   	std    
  105bf4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105bf6:	fc                   	cld    
  105bf7:	89 f8                	mov    %edi,%eax
  105bf9:	89 f2                	mov    %esi,%edx
  105bfb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105bfe:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105c01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105c07:	83 c4 30             	add    $0x30,%esp
  105c0a:	5b                   	pop    %ebx
  105c0b:	5e                   	pop    %esi
  105c0c:	5f                   	pop    %edi
  105c0d:	5d                   	pop    %ebp
  105c0e:	c3                   	ret    

00105c0f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105c0f:	55                   	push   %ebp
  105c10:	89 e5                	mov    %esp,%ebp
  105c12:	57                   	push   %edi
  105c13:	56                   	push   %esi
  105c14:	83 ec 20             	sub    $0x20,%esp
  105c17:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c23:	8b 45 10             	mov    0x10(%ebp),%eax
  105c26:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c2c:	c1 e8 02             	shr    $0x2,%eax
  105c2f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c37:	89 d7                	mov    %edx,%edi
  105c39:	89 c6                	mov    %eax,%esi
  105c3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105c3d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105c40:	83 e1 03             	and    $0x3,%ecx
  105c43:	74 02                	je     105c47 <memcpy+0x38>
  105c45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105c47:	89 f0                	mov    %esi,%eax
  105c49:	89 fa                	mov    %edi,%edx
  105c4b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105c4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105c51:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  105c57:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105c58:	83 c4 20             	add    $0x20,%esp
  105c5b:	5e                   	pop    %esi
  105c5c:	5f                   	pop    %edi
  105c5d:	5d                   	pop    %ebp
  105c5e:	c3                   	ret    

00105c5f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105c5f:	55                   	push   %ebp
  105c60:	89 e5                	mov    %esp,%ebp
  105c62:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105c65:	8b 45 08             	mov    0x8(%ebp),%eax
  105c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105c71:	eb 2e                	jmp    105ca1 <memcmp+0x42>
        if (*s1 != *s2) {
  105c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c76:	0f b6 10             	movzbl (%eax),%edx
  105c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c7c:	0f b6 00             	movzbl (%eax),%eax
  105c7f:	38 c2                	cmp    %al,%dl
  105c81:	74 18                	je     105c9b <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c86:	0f b6 00             	movzbl (%eax),%eax
  105c89:	0f b6 d0             	movzbl %al,%edx
  105c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c8f:	0f b6 00             	movzbl (%eax),%eax
  105c92:	0f b6 c0             	movzbl %al,%eax
  105c95:	29 c2                	sub    %eax,%edx
  105c97:	89 d0                	mov    %edx,%eax
  105c99:	eb 18                	jmp    105cb3 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  105c9b:	ff 45 fc             	incl   -0x4(%ebp)
  105c9e:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105ca1:	8b 45 10             	mov    0x10(%ebp),%eax
  105ca4:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ca7:	89 55 10             	mov    %edx,0x10(%ebp)
  105caa:	85 c0                	test   %eax,%eax
  105cac:	75 c5                	jne    105c73 <memcmp+0x14>
    }
    return 0;
  105cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105cb3:	c9                   	leave  
  105cb4:	c3                   	ret    

00105cb5 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105cb5:	55                   	push   %ebp
  105cb6:	89 e5                	mov    %esp,%ebp
  105cb8:	83 ec 58             	sub    $0x58,%esp
  105cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  105cbe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105cc1:	8b 45 14             	mov    0x14(%ebp),%eax
  105cc4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105cc7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105cca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105ccd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105cd0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105cd3:	8b 45 18             	mov    0x18(%ebp),%eax
  105cd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105cdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ce2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105cef:	74 1c                	je     105d0d <printnum+0x58>
  105cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  105cf9:	f7 75 e4             	divl   -0x1c(%ebp)
  105cfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d02:	ba 00 00 00 00       	mov    $0x0,%edx
  105d07:	f7 75 e4             	divl   -0x1c(%ebp)
  105d0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d13:	f7 75 e4             	divl   -0x1c(%ebp)
  105d16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105d19:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105d1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105d22:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105d25:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105d28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105d2b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105d2e:	8b 45 18             	mov    0x18(%ebp),%eax
  105d31:	ba 00 00 00 00       	mov    $0x0,%edx
  105d36:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  105d39:	72 56                	jb     105d91 <printnum+0xdc>
  105d3b:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  105d3e:	77 05                	ja     105d45 <printnum+0x90>
  105d40:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105d43:	72 4c                	jb     105d91 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105d45:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105d48:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d4b:	8b 45 20             	mov    0x20(%ebp),%eax
  105d4e:	89 44 24 18          	mov    %eax,0x18(%esp)
  105d52:	89 54 24 14          	mov    %edx,0x14(%esp)
  105d56:	8b 45 18             	mov    0x18(%ebp),%eax
  105d59:	89 44 24 10          	mov    %eax,0x10(%esp)
  105d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d60:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105d63:	89 44 24 08          	mov    %eax,0x8(%esp)
  105d67:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d72:	8b 45 08             	mov    0x8(%ebp),%eax
  105d75:	89 04 24             	mov    %eax,(%esp)
  105d78:	e8 38 ff ff ff       	call   105cb5 <printnum>
  105d7d:	eb 1b                	jmp    105d9a <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d82:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d86:	8b 45 20             	mov    0x20(%ebp),%eax
  105d89:	89 04 24             	mov    %eax,(%esp)
  105d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8f:	ff d0                	call   *%eax
        while (-- width > 0)
  105d91:	ff 4d 1c             	decl   0x1c(%ebp)
  105d94:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105d98:	7f e5                	jg     105d7f <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105d9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105d9d:	05 34 75 10 00       	add    $0x107534,%eax
  105da2:	0f b6 00             	movzbl (%eax),%eax
  105da5:	0f be c0             	movsbl %al,%eax
  105da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  105dab:	89 54 24 04          	mov    %edx,0x4(%esp)
  105daf:	89 04 24             	mov    %eax,(%esp)
  105db2:	8b 45 08             	mov    0x8(%ebp),%eax
  105db5:	ff d0                	call   *%eax
}
  105db7:	90                   	nop
  105db8:	c9                   	leave  
  105db9:	c3                   	ret    

00105dba <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105dba:	55                   	push   %ebp
  105dbb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105dbd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105dc1:	7e 14                	jle    105dd7 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc6:	8b 00                	mov    (%eax),%eax
  105dc8:	8d 48 08             	lea    0x8(%eax),%ecx
  105dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  105dce:	89 0a                	mov    %ecx,(%edx)
  105dd0:	8b 50 04             	mov    0x4(%eax),%edx
  105dd3:	8b 00                	mov    (%eax),%eax
  105dd5:	eb 30                	jmp    105e07 <getuint+0x4d>
    }
    else if (lflag) {
  105dd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105ddb:	74 16                	je     105df3 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  105de0:	8b 00                	mov    (%eax),%eax
  105de2:	8d 48 04             	lea    0x4(%eax),%ecx
  105de5:	8b 55 08             	mov    0x8(%ebp),%edx
  105de8:	89 0a                	mov    %ecx,(%edx)
  105dea:	8b 00                	mov    (%eax),%eax
  105dec:	ba 00 00 00 00       	mov    $0x0,%edx
  105df1:	eb 14                	jmp    105e07 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105df3:	8b 45 08             	mov    0x8(%ebp),%eax
  105df6:	8b 00                	mov    (%eax),%eax
  105df8:	8d 48 04             	lea    0x4(%eax),%ecx
  105dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  105dfe:	89 0a                	mov    %ecx,(%edx)
  105e00:	8b 00                	mov    (%eax),%eax
  105e02:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105e07:	5d                   	pop    %ebp
  105e08:	c3                   	ret    

00105e09 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105e09:	55                   	push   %ebp
  105e0a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105e0c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105e10:	7e 14                	jle    105e26 <getint+0x1d>
        return va_arg(*ap, long long);
  105e12:	8b 45 08             	mov    0x8(%ebp),%eax
  105e15:	8b 00                	mov    (%eax),%eax
  105e17:	8d 48 08             	lea    0x8(%eax),%ecx
  105e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  105e1d:	89 0a                	mov    %ecx,(%edx)
  105e1f:	8b 50 04             	mov    0x4(%eax),%edx
  105e22:	8b 00                	mov    (%eax),%eax
  105e24:	eb 28                	jmp    105e4e <getint+0x45>
    }
    else if (lflag) {
  105e26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105e2a:	74 12                	je     105e3e <getint+0x35>
        return va_arg(*ap, long);
  105e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e2f:	8b 00                	mov    (%eax),%eax
  105e31:	8d 48 04             	lea    0x4(%eax),%ecx
  105e34:	8b 55 08             	mov    0x8(%ebp),%edx
  105e37:	89 0a                	mov    %ecx,(%edx)
  105e39:	8b 00                	mov    (%eax),%eax
  105e3b:	99                   	cltd   
  105e3c:	eb 10                	jmp    105e4e <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e41:	8b 00                	mov    (%eax),%eax
  105e43:	8d 48 04             	lea    0x4(%eax),%ecx
  105e46:	8b 55 08             	mov    0x8(%ebp),%edx
  105e49:	89 0a                	mov    %ecx,(%edx)
  105e4b:	8b 00                	mov    (%eax),%eax
  105e4d:	99                   	cltd   
    }
}
  105e4e:	5d                   	pop    %ebp
  105e4f:	c3                   	ret    

00105e50 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105e50:	55                   	push   %ebp
  105e51:	89 e5                	mov    %esp,%ebp
  105e53:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105e56:	8d 45 14             	lea    0x14(%ebp),%eax
  105e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105e63:	8b 45 10             	mov    0x10(%ebp),%eax
  105e66:	89 44 24 08          	mov    %eax,0x8(%esp)
  105e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e71:	8b 45 08             	mov    0x8(%ebp),%eax
  105e74:	89 04 24             	mov    %eax,(%esp)
  105e77:	e8 03 00 00 00       	call   105e7f <vprintfmt>
    va_end(ap);
}
  105e7c:	90                   	nop
  105e7d:	c9                   	leave  
  105e7e:	c3                   	ret    

00105e7f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105e7f:	55                   	push   %ebp
  105e80:	89 e5                	mov    %esp,%ebp
  105e82:	56                   	push   %esi
  105e83:	53                   	push   %ebx
  105e84:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105e87:	eb 17                	jmp    105ea0 <vprintfmt+0x21>
            if (ch == '\0') {
  105e89:	85 db                	test   %ebx,%ebx
  105e8b:	0f 84 bf 03 00 00    	je     106250 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  105e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e94:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e98:	89 1c 24             	mov    %ebx,(%esp)
  105e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e9e:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  105ea3:	8d 50 01             	lea    0x1(%eax),%edx
  105ea6:	89 55 10             	mov    %edx,0x10(%ebp)
  105ea9:	0f b6 00             	movzbl (%eax),%eax
  105eac:	0f b6 d8             	movzbl %al,%ebx
  105eaf:	83 fb 25             	cmp    $0x25,%ebx
  105eb2:	75 d5                	jne    105e89 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105eb4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105eb8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105ebf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ec2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105ec5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105ecc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ecf:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  105ed5:	8d 50 01             	lea    0x1(%eax),%edx
  105ed8:	89 55 10             	mov    %edx,0x10(%ebp)
  105edb:	0f b6 00             	movzbl (%eax),%eax
  105ede:	0f b6 d8             	movzbl %al,%ebx
  105ee1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105ee4:	83 f8 55             	cmp    $0x55,%eax
  105ee7:	0f 87 37 03 00 00    	ja     106224 <vprintfmt+0x3a5>
  105eed:	8b 04 85 58 75 10 00 	mov    0x107558(,%eax,4),%eax
  105ef4:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105ef6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105efa:	eb d6                	jmp    105ed2 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105efc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105f00:	eb d0                	jmp    105ed2 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105f02:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105f09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f0c:	89 d0                	mov    %edx,%eax
  105f0e:	c1 e0 02             	shl    $0x2,%eax
  105f11:	01 d0                	add    %edx,%eax
  105f13:	01 c0                	add    %eax,%eax
  105f15:	01 d8                	add    %ebx,%eax
  105f17:	83 e8 30             	sub    $0x30,%eax
  105f1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  105f20:	0f b6 00             	movzbl (%eax),%eax
  105f23:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105f26:	83 fb 2f             	cmp    $0x2f,%ebx
  105f29:	7e 38                	jle    105f63 <vprintfmt+0xe4>
  105f2b:	83 fb 39             	cmp    $0x39,%ebx
  105f2e:	7f 33                	jg     105f63 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105f30:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105f33:	eb d4                	jmp    105f09 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105f35:	8b 45 14             	mov    0x14(%ebp),%eax
  105f38:	8d 50 04             	lea    0x4(%eax),%edx
  105f3b:	89 55 14             	mov    %edx,0x14(%ebp)
  105f3e:	8b 00                	mov    (%eax),%eax
  105f40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105f43:	eb 1f                	jmp    105f64 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  105f45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105f49:	79 87                	jns    105ed2 <vprintfmt+0x53>
                width = 0;
  105f4b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105f52:	e9 7b ff ff ff       	jmp    105ed2 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105f57:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105f5e:	e9 6f ff ff ff       	jmp    105ed2 <vprintfmt+0x53>
            goto process_precision;
  105f63:	90                   	nop

        process_precision:
            if (width < 0)
  105f64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105f68:	0f 89 64 ff ff ff    	jns    105ed2 <vprintfmt+0x53>
                width = precision, precision = -1;
  105f6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f71:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105f74:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105f7b:	e9 52 ff ff ff       	jmp    105ed2 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105f80:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105f83:	e9 4a ff ff ff       	jmp    105ed2 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105f88:	8b 45 14             	mov    0x14(%ebp),%eax
  105f8b:	8d 50 04             	lea    0x4(%eax),%edx
  105f8e:	89 55 14             	mov    %edx,0x14(%ebp)
  105f91:	8b 00                	mov    (%eax),%eax
  105f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  105f96:	89 54 24 04          	mov    %edx,0x4(%esp)
  105f9a:	89 04 24             	mov    %eax,(%esp)
  105f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  105fa0:	ff d0                	call   *%eax
            break;
  105fa2:	e9 a4 02 00 00       	jmp    10624b <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105fa7:	8b 45 14             	mov    0x14(%ebp),%eax
  105faa:	8d 50 04             	lea    0x4(%eax),%edx
  105fad:	89 55 14             	mov    %edx,0x14(%ebp)
  105fb0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105fb2:	85 db                	test   %ebx,%ebx
  105fb4:	79 02                	jns    105fb8 <vprintfmt+0x139>
                err = -err;
  105fb6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105fb8:	83 fb 06             	cmp    $0x6,%ebx
  105fbb:	7f 0b                	jg     105fc8 <vprintfmt+0x149>
  105fbd:	8b 34 9d 18 75 10 00 	mov    0x107518(,%ebx,4),%esi
  105fc4:	85 f6                	test   %esi,%esi
  105fc6:	75 23                	jne    105feb <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  105fc8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105fcc:	c7 44 24 08 45 75 10 	movl   $0x107545,0x8(%esp)
  105fd3:	00 
  105fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  105fde:	89 04 24             	mov    %eax,(%esp)
  105fe1:	e8 6a fe ff ff       	call   105e50 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105fe6:	e9 60 02 00 00       	jmp    10624b <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  105feb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105fef:	c7 44 24 08 4e 75 10 	movl   $0x10754e,0x8(%esp)
  105ff6:	00 
  105ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ffa:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  106001:	89 04 24             	mov    %eax,(%esp)
  106004:	e8 47 fe ff ff       	call   105e50 <printfmt>
            break;
  106009:	e9 3d 02 00 00       	jmp    10624b <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10600e:	8b 45 14             	mov    0x14(%ebp),%eax
  106011:	8d 50 04             	lea    0x4(%eax),%edx
  106014:	89 55 14             	mov    %edx,0x14(%ebp)
  106017:	8b 30                	mov    (%eax),%esi
  106019:	85 f6                	test   %esi,%esi
  10601b:	75 05                	jne    106022 <vprintfmt+0x1a3>
                p = "(null)";
  10601d:	be 51 75 10 00       	mov    $0x107551,%esi
            }
            if (width > 0 && padc != '-') {
  106022:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106026:	7e 76                	jle    10609e <vprintfmt+0x21f>
  106028:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10602c:	74 70                	je     10609e <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10602e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106031:	89 44 24 04          	mov    %eax,0x4(%esp)
  106035:	89 34 24             	mov    %esi,(%esp)
  106038:	e8 f6 f7 ff ff       	call   105833 <strnlen>
  10603d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106040:	29 c2                	sub    %eax,%edx
  106042:	89 d0                	mov    %edx,%eax
  106044:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106047:	eb 16                	jmp    10605f <vprintfmt+0x1e0>
                    putch(padc, putdat);
  106049:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10604d:	8b 55 0c             	mov    0xc(%ebp),%edx
  106050:	89 54 24 04          	mov    %edx,0x4(%esp)
  106054:	89 04 24             	mov    %eax,(%esp)
  106057:	8b 45 08             	mov    0x8(%ebp),%eax
  10605a:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  10605c:	ff 4d e8             	decl   -0x18(%ebp)
  10605f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106063:	7f e4                	jg     106049 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106065:	eb 37                	jmp    10609e <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  106067:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10606b:	74 1f                	je     10608c <vprintfmt+0x20d>
  10606d:	83 fb 1f             	cmp    $0x1f,%ebx
  106070:	7e 05                	jle    106077 <vprintfmt+0x1f8>
  106072:	83 fb 7e             	cmp    $0x7e,%ebx
  106075:	7e 15                	jle    10608c <vprintfmt+0x20d>
                    putch('?', putdat);
  106077:	8b 45 0c             	mov    0xc(%ebp),%eax
  10607a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10607e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  106085:	8b 45 08             	mov    0x8(%ebp),%eax
  106088:	ff d0                	call   *%eax
  10608a:	eb 0f                	jmp    10609b <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  10608c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10608f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106093:	89 1c 24             	mov    %ebx,(%esp)
  106096:	8b 45 08             	mov    0x8(%ebp),%eax
  106099:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10609b:	ff 4d e8             	decl   -0x18(%ebp)
  10609e:	89 f0                	mov    %esi,%eax
  1060a0:	8d 70 01             	lea    0x1(%eax),%esi
  1060a3:	0f b6 00             	movzbl (%eax),%eax
  1060a6:	0f be d8             	movsbl %al,%ebx
  1060a9:	85 db                	test   %ebx,%ebx
  1060ab:	74 27                	je     1060d4 <vprintfmt+0x255>
  1060ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1060b1:	78 b4                	js     106067 <vprintfmt+0x1e8>
  1060b3:	ff 4d e4             	decl   -0x1c(%ebp)
  1060b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1060ba:	79 ab                	jns    106067 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  1060bc:	eb 16                	jmp    1060d4 <vprintfmt+0x255>
                putch(' ', putdat);
  1060be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1060cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1060cf:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1060d1:	ff 4d e8             	decl   -0x18(%ebp)
  1060d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1060d8:	7f e4                	jg     1060be <vprintfmt+0x23f>
            }
            break;
  1060da:	e9 6c 01 00 00       	jmp    10624b <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1060df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1060e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060e6:	8d 45 14             	lea    0x14(%ebp),%eax
  1060e9:	89 04 24             	mov    %eax,(%esp)
  1060ec:	e8 18 fd ff ff       	call   105e09 <getint>
  1060f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1060f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1060fd:	85 d2                	test   %edx,%edx
  1060ff:	79 26                	jns    106127 <vprintfmt+0x2a8>
                putch('-', putdat);
  106101:	8b 45 0c             	mov    0xc(%ebp),%eax
  106104:	89 44 24 04          	mov    %eax,0x4(%esp)
  106108:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10610f:	8b 45 08             	mov    0x8(%ebp),%eax
  106112:	ff d0                	call   *%eax
                num = -(long long)num;
  106114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106117:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10611a:	f7 d8                	neg    %eax
  10611c:	83 d2 00             	adc    $0x0,%edx
  10611f:	f7 da                	neg    %edx
  106121:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106124:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  106127:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10612e:	e9 a8 00 00 00       	jmp    1061db <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  106133:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106136:	89 44 24 04          	mov    %eax,0x4(%esp)
  10613a:	8d 45 14             	lea    0x14(%ebp),%eax
  10613d:	89 04 24             	mov    %eax,(%esp)
  106140:	e8 75 fc ff ff       	call   105dba <getuint>
  106145:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106148:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10614b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106152:	e9 84 00 00 00       	jmp    1061db <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  106157:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10615a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10615e:	8d 45 14             	lea    0x14(%ebp),%eax
  106161:	89 04 24             	mov    %eax,(%esp)
  106164:	e8 51 fc ff ff       	call   105dba <getuint>
  106169:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10616c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10616f:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  106176:	eb 63                	jmp    1061db <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  106178:	8b 45 0c             	mov    0xc(%ebp),%eax
  10617b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10617f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  106186:	8b 45 08             	mov    0x8(%ebp),%eax
  106189:	ff d0                	call   *%eax
            putch('x', putdat);
  10618b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10618e:	89 44 24 04          	mov    %eax,0x4(%esp)
  106192:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106199:	8b 45 08             	mov    0x8(%ebp),%eax
  10619c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10619e:	8b 45 14             	mov    0x14(%ebp),%eax
  1061a1:	8d 50 04             	lea    0x4(%eax),%edx
  1061a4:	89 55 14             	mov    %edx,0x14(%ebp)
  1061a7:	8b 00                	mov    (%eax),%eax
  1061a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1061b3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1061ba:	eb 1f                	jmp    1061db <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1061bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1061bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1061c3:	8d 45 14             	lea    0x14(%ebp),%eax
  1061c6:	89 04 24             	mov    %eax,(%esp)
  1061c9:	e8 ec fb ff ff       	call   105dba <getuint>
  1061ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1061d4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1061db:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1061df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1061e2:	89 54 24 18          	mov    %edx,0x18(%esp)
  1061e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1061e9:	89 54 24 14          	mov    %edx,0x14(%esp)
  1061ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  1061f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1061f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1061fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1061ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  106202:	89 44 24 04          	mov    %eax,0x4(%esp)
  106206:	8b 45 08             	mov    0x8(%ebp),%eax
  106209:	89 04 24             	mov    %eax,(%esp)
  10620c:	e8 a4 fa ff ff       	call   105cb5 <printnum>
            break;
  106211:	eb 38                	jmp    10624b <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  106213:	8b 45 0c             	mov    0xc(%ebp),%eax
  106216:	89 44 24 04          	mov    %eax,0x4(%esp)
  10621a:	89 1c 24             	mov    %ebx,(%esp)
  10621d:	8b 45 08             	mov    0x8(%ebp),%eax
  106220:	ff d0                	call   *%eax
            break;
  106222:	eb 27                	jmp    10624b <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106224:	8b 45 0c             	mov    0xc(%ebp),%eax
  106227:	89 44 24 04          	mov    %eax,0x4(%esp)
  10622b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  106232:	8b 45 08             	mov    0x8(%ebp),%eax
  106235:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  106237:	ff 4d 10             	decl   0x10(%ebp)
  10623a:	eb 03                	jmp    10623f <vprintfmt+0x3c0>
  10623c:	ff 4d 10             	decl   0x10(%ebp)
  10623f:	8b 45 10             	mov    0x10(%ebp),%eax
  106242:	48                   	dec    %eax
  106243:	0f b6 00             	movzbl (%eax),%eax
  106246:	3c 25                	cmp    $0x25,%al
  106248:	75 f2                	jne    10623c <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  10624a:	90                   	nop
    while (1) {
  10624b:	e9 37 fc ff ff       	jmp    105e87 <vprintfmt+0x8>
                return;
  106250:	90                   	nop
        }
    }
}
  106251:	83 c4 40             	add    $0x40,%esp
  106254:	5b                   	pop    %ebx
  106255:	5e                   	pop    %esi
  106256:	5d                   	pop    %ebp
  106257:	c3                   	ret    

00106258 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106258:	55                   	push   %ebp
  106259:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10625b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10625e:	8b 40 08             	mov    0x8(%eax),%eax
  106261:	8d 50 01             	lea    0x1(%eax),%edx
  106264:	8b 45 0c             	mov    0xc(%ebp),%eax
  106267:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10626a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10626d:	8b 10                	mov    (%eax),%edx
  10626f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106272:	8b 40 04             	mov    0x4(%eax),%eax
  106275:	39 c2                	cmp    %eax,%edx
  106277:	73 12                	jae    10628b <sprintputch+0x33>
        *b->buf ++ = ch;
  106279:	8b 45 0c             	mov    0xc(%ebp),%eax
  10627c:	8b 00                	mov    (%eax),%eax
  10627e:	8d 48 01             	lea    0x1(%eax),%ecx
  106281:	8b 55 0c             	mov    0xc(%ebp),%edx
  106284:	89 0a                	mov    %ecx,(%edx)
  106286:	8b 55 08             	mov    0x8(%ebp),%edx
  106289:	88 10                	mov    %dl,(%eax)
    }
}
  10628b:	90                   	nop
  10628c:	5d                   	pop    %ebp
  10628d:	c3                   	ret    

0010628e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10628e:	55                   	push   %ebp
  10628f:	89 e5                	mov    %esp,%ebp
  106291:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106294:	8d 45 14             	lea    0x14(%ebp),%eax
  106297:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10629a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10629d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1062a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1062a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1062a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1062ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1062af:	8b 45 08             	mov    0x8(%ebp),%eax
  1062b2:	89 04 24             	mov    %eax,(%esp)
  1062b5:	e8 08 00 00 00       	call   1062c2 <vsnprintf>
  1062ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1062bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1062c0:	c9                   	leave  
  1062c1:	c3                   	ret    

001062c2 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1062c2:	55                   	push   %ebp
  1062c3:	89 e5                	mov    %esp,%ebp
  1062c5:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1062c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1062cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1062ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1062d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1062d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1062d7:	01 d0                	add    %edx,%eax
  1062d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1062dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1062e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1062e7:	74 0a                	je     1062f3 <vsnprintf+0x31>
  1062e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1062ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1062ef:	39 c2                	cmp    %eax,%edx
  1062f1:	76 07                	jbe    1062fa <vsnprintf+0x38>
        return -E_INVAL;
  1062f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1062f8:	eb 2a                	jmp    106324 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1062fa:	8b 45 14             	mov    0x14(%ebp),%eax
  1062fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106301:	8b 45 10             	mov    0x10(%ebp),%eax
  106304:	89 44 24 08          	mov    %eax,0x8(%esp)
  106308:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10630b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10630f:	c7 04 24 58 62 10 00 	movl   $0x106258,(%esp)
  106316:	e8 64 fb ff ff       	call   105e7f <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10631b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10631e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106321:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106324:	c9                   	leave  
  106325:	c3                   	ret    
