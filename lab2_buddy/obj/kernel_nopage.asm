
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
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
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
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
  10003c:	ba 94 af 25 00       	mov    $0x25af94,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 dc 52 00 00       	call   10533e <memset>

    cons_init();                // init the console
  100062:	e8 9c 15 00 00       	call   101603 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 40 5b 10 00 	movl   $0x105b40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 5c 5b 10 00 	movl   $0x105b5c,(%esp)
  10007c:	e8 21 02 00 00       	call   1002a2 <cprintf>

    print_kerninfo();
  100081:	e8 c2 08 00 00       	call   100948 <print_kerninfo>

    grade_backtrace();
  100086:	e8 8e 00 00 00       	call   100119 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 2e 34 00 00       	call   1034be <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 d3 16 00 00       	call   101768 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 33 18 00 00       	call   1018cd <idt_init>

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
  10015a:	a1 00 a0 11 00       	mov    0x11a000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 61 5b 10 00 	movl   $0x105b61,(%esp)
  10016e:	e8 2f 01 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 a0 11 00       	mov    0x11a000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 6f 5b 10 00 	movl   $0x105b6f,(%esp)
  10018d:	e8 10 01 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 a0 11 00       	mov    0x11a000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 7d 5b 10 00 	movl   $0x105b7d,(%esp)
  1001ac:	e8 f1 00 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 8b 5b 10 00 	movl   $0x105b8b,(%esp)
  1001cb:	e8 d2 00 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 99 5b 10 00 	movl   $0x105b99,(%esp)
  1001ea:	e8 b3 00 00 00       	call   1002a2 <cprintf>
    round ++;
  1001ef:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 a0 11 00       	mov    %eax,0x11a000
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
  10021f:	c7 04 24 a8 5b 10 00 	movl   $0x105ba8,(%esp)
  100226:	e8 77 00 00 00       	call   1002a2 <cprintf>
    lab1_switch_to_user();
  10022b:	e8 cd ff ff ff       	call   1001fd <lab1_switch_to_user>
    lab1_print_cur_status();
  100230:	e8 0a ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100235:	c7 04 24 c8 5b 10 00 	movl   $0x105bc8,(%esp)
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
  100298:	e8 f4 53 00 00       	call   105691 <vprintfmt>
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
  100357:	c7 04 24 e7 5b 10 00 	movl   $0x105be7,(%esp)
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
  1003a5:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
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
  1003e3:	05 20 a0 11 00       	add    $0x11a020,%eax
  1003e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003eb:	b8 20 a0 11 00       	mov    $0x11a020,%eax
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
  1003ff:	a1 20 a4 11 00       	mov    0x11a420,%eax
  100404:	85 c0                	test   %eax,%eax
  100406:	75 5b                	jne    100463 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100408:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
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
  100426:	c7 04 24 ea 5b 10 00 	movl   $0x105bea,(%esp)
  10042d:	e8 70 fe ff ff       	call   1002a2 <cprintf>
    vcprintf(fmt, ap);
  100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100435:	89 44 24 04          	mov    %eax,0x4(%esp)
  100439:	8b 45 10             	mov    0x10(%ebp),%eax
  10043c:	89 04 24             	mov    %eax,(%esp)
  10043f:	e8 2b fe ff ff       	call   10026f <vcprintf>
    cprintf("\n");
  100444:	c7 04 24 06 5c 10 00 	movl   $0x105c06,(%esp)
  10044b:	e8 52 fe ff ff       	call   1002a2 <cprintf>
    
    cprintf("stack trackback:\n");
  100450:	c7 04 24 08 5c 10 00 	movl   $0x105c08,(%esp)
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
  100491:	c7 04 24 1a 5c 10 00 	movl   $0x105c1a,(%esp)
  100498:	e8 05 fe ff ff       	call   1002a2 <cprintf>
    vcprintf(fmt, ap);
  10049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a7:	89 04 24             	mov    %eax,(%esp)
  1004aa:	e8 c0 fd ff ff       	call   10026f <vcprintf>
    cprintf("\n");
  1004af:	c7 04 24 06 5c 10 00 	movl   $0x105c06,(%esp)
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
  1004c1:	a1 20 a4 11 00       	mov    0x11a420,%eax
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
  10061f:	c7 00 38 5c 10 00    	movl   $0x105c38,(%eax)
    info->eip_line = 0;
  100625:	8b 45 0c             	mov    0xc(%ebp),%eax
  100628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100632:	c7 40 08 38 5c 10 00 	movl   $0x105c38,0x8(%eax)
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
  100656:	c7 45 f4 7c 6c 10 00 	movl   $0x106c7c,-0xc(%ebp)
    stab_end = __STAB_END__;
  10065d:	c7 45 f0 b0 19 11 00 	movl   $0x1119b0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100664:	c7 45 ec b1 19 11 00 	movl   $0x1119b1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10066b:	c7 45 e8 20 46 11 00 	movl   $0x114620,-0x18(%ebp)

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
  1007c6:	e8 ef 49 00 00       	call   1051ba <strfind>
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
  10094e:	c7 04 24 42 5c 10 00 	movl   $0x105c42,(%esp)
  100955:	e8 48 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10095a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100961:	00 
  100962:	c7 04 24 5b 5c 10 00 	movl   $0x105c5b,(%esp)
  100969:	e8 34 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10096e:	c7 44 24 04 38 5b 10 	movl   $0x105b38,0x4(%esp)
  100975:	00 
  100976:	c7 04 24 73 5c 10 00 	movl   $0x105c73,(%esp)
  10097d:	e8 20 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100982:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  100989:	00 
  10098a:	c7 04 24 8b 5c 10 00 	movl   $0x105c8b,(%esp)
  100991:	e8 0c f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100996:	c7 44 24 04 94 af 25 	movl   $0x25af94,0x4(%esp)
  10099d:	00 
  10099e:	c7 04 24 a3 5c 10 00 	movl   $0x105ca3,(%esp)
  1009a5:	e8 f8 f8 ff ff       	call   1002a2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009aa:	b8 94 af 25 00       	mov    $0x25af94,%eax
  1009af:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b5:	b8 36 00 10 00       	mov    $0x100036,%eax
  1009ba:	29 c2                	sub    %eax,%edx
  1009bc:	89 d0                	mov    %edx,%eax
  1009be:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	0f 48 c2             	cmovs  %edx,%eax
  1009c9:	c1 f8 0a             	sar    $0xa,%eax
  1009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d0:	c7 04 24 bc 5c 10 00 	movl   $0x105cbc,(%esp)
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
  100a05:	c7 04 24 e6 5c 10 00 	movl   $0x105ce6,(%esp)
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
  100a73:	c7 04 24 02 5d 10 00 	movl   $0x105d02,(%esp)
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
  100ac6:	c7 04 24 14 5d 10 00 	movl   $0x105d14,(%esp)
  100acd:	e8 d0 f7 ff ff       	call   1002a2 <cprintf>
         cprintf("arg:");
  100ad2:	c7 04 24 2f 5d 10 00 	movl   $0x105d2f,(%esp)
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
  100b05:	c7 04 24 34 5d 10 00 	movl   $0x105d34,(%esp)
  100b0c:	e8 91 f7 ff ff       	call   1002a2 <cprintf>
         for(j=0; j<=4; j++)
  100b11:	ff 45 ec             	incl   -0x14(%ebp)
  100b14:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
  100b18:	7e d6                	jle    100af0 <print_stackframe+0x5d>
         cprintf("\n");
  100b1a:	c7 04 24 3f 5d 10 00 	movl   $0x105d3f,(%esp)
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
  100b8d:	c7 04 24 c4 5d 10 00 	movl   $0x105dc4,(%esp)
  100b94:	e8 ef 45 00 00       	call   105188 <strchr>
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
  100bb5:	c7 04 24 c9 5d 10 00 	movl   $0x105dc9,(%esp)
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
  100bf7:	c7 04 24 c4 5d 10 00 	movl   $0x105dc4,(%esp)
  100bfe:	e8 85 45 00 00       	call   105188 <strchr>
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
  100c56:	05 00 70 11 00       	add    $0x117000,%eax
  100c5b:	8b 00                	mov    (%eax),%eax
  100c5d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c61:	89 04 24             	mov    %eax,(%esp)
  100c64:	e8 82 44 00 00       	call   1050eb <strcmp>
  100c69:	85 c0                	test   %eax,%eax
  100c6b:	75 31                	jne    100c9e <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c70:	89 d0                	mov    %edx,%eax
  100c72:	01 c0                	add    %eax,%eax
  100c74:	01 d0                	add    %edx,%eax
  100c76:	c1 e0 02             	shl    $0x2,%eax
  100c79:	05 08 70 11 00       	add    $0x117008,%eax
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
  100cb0:	c7 04 24 e7 5d 10 00 	movl   $0x105de7,(%esp)
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
  100ccd:	c7 04 24 00 5e 10 00 	movl   $0x105e00,(%esp)
  100cd4:	e8 c9 f5 ff ff       	call   1002a2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cd9:	c7 04 24 28 5e 10 00 	movl   $0x105e28,(%esp)
  100ce0:	e8 bd f5 ff ff       	call   1002a2 <cprintf>

    if (tf != NULL) {
  100ce5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ce9:	74 0b                	je     100cf6 <kmonitor+0x2f>
        print_trapframe(tf);
  100ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cee:	89 04 24             	mov    %eax,(%esp)
  100cf1:	e8 8d 0d 00 00       	call   101a83 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cf6:	c7 04 24 4d 5e 10 00 	movl   $0x105e4d,(%esp)
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
  100d42:	05 04 70 11 00       	add    $0x117004,%eax
  100d47:	8b 08                	mov    (%eax),%ecx
  100d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d4c:	89 d0                	mov    %edx,%eax
  100d4e:	01 c0                	add    %eax,%eax
  100d50:	01 d0                	add    %edx,%eax
  100d52:	c1 e0 02             	shl    $0x2,%eax
  100d55:	05 00 70 11 00       	add    $0x117000,%eax
  100d5a:	8b 00                	mov    (%eax),%eax
  100d5c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d64:	c7 04 24 51 5e 10 00 	movl   $0x105e51,(%esp)
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
  100de5:	c7 05 0c af 11 00 00 	movl   $0x0,0x11af0c
  100dec:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100def:	c7 04 24 5a 5e 10 00 	movl   $0x105e5a,(%esp)
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
  100ec7:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100ece:	b4 03 
  100ed0:	eb 13                	jmp    100ee5 <cga_init+0x54>
    } else {
        *cp = was;
  100ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ed9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100edc:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ee3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ee5:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100eec:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ef0:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ef4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ef8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100efc:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100efd:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
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
  100f23:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f2a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f2e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f32:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f36:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f3a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f3b:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
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
  100f61:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f69:	0f b7 c0             	movzwl %ax,%eax
  100f6c:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
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
  10101c:	a3 48 a4 11 00       	mov    %eax,0x11a448
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
  101041:	a1 48 a4 11 00       	mov    0x11a448,%eax
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
  101145:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10114c:	85 c0                	test   %eax,%eax
  10114e:	0f 84 af 00 00 00    	je     101203 <cga_putc+0xf1>
            crt_pos --;
  101154:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10115b:	48                   	dec    %eax
  10115c:	0f b7 c0             	movzwl %ax,%eax
  10115f:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101165:	8b 45 08             	mov    0x8(%ebp),%eax
  101168:	98                   	cwtl   
  101169:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10116e:	98                   	cwtl   
  10116f:	83 c8 20             	or     $0x20,%eax
  101172:	98                   	cwtl   
  101173:	8b 15 40 a4 11 00    	mov    0x11a440,%edx
  101179:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  101180:	01 c9                	add    %ecx,%ecx
  101182:	01 ca                	add    %ecx,%edx
  101184:	0f b7 c0             	movzwl %ax,%eax
  101187:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10118a:	eb 77                	jmp    101203 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  10118c:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101193:	83 c0 50             	add    $0x50,%eax
  101196:	0f b7 c0             	movzwl %ax,%eax
  101199:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10119f:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  1011a6:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
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
  1011d1:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011d7:	eb 2b                	jmp    101204 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011d9:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011df:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011e6:	8d 50 01             	lea    0x1(%eax),%edx
  1011e9:	0f b7 d2             	movzwl %dx,%edx
  1011ec:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
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
  101204:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10120b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101210:	76 5d                	jbe    10126f <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101212:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101217:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10121d:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101222:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101229:	00 
  10122a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10122e:	89 04 24             	mov    %eax,(%esp)
  101231:	e8 48 41 00 00       	call   10537e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101236:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10123d:	eb 14                	jmp    101253 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  10123f:	a1 40 a4 11 00       	mov    0x11a440,%eax
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
  10125c:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101263:	83 e8 50             	sub    $0x50,%eax
  101266:	0f b7 c0             	movzwl %ax,%eax
  101269:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10126f:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101276:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10127a:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  10127e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101282:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101286:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101287:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10128e:	c1 e8 08             	shr    $0x8,%eax
  101291:	0f b7 c0             	movzwl %ax,%eax
  101294:	0f b6 c0             	movzbl %al,%eax
  101297:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  10129e:	42                   	inc    %edx
  10129f:	0f b7 d2             	movzwl %dx,%edx
  1012a2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012a6:	88 45 e9             	mov    %al,-0x17(%ebp)
  1012a9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ad:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012b1:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012b2:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  1012b9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012bd:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1012c1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012c5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012c9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012ca:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1012d1:	0f b6 c0             	movzbl %al,%eax
  1012d4:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
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
  10139d:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1013a2:	8d 50 01             	lea    0x1(%eax),%edx
  1013a5:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  1013ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013ae:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013b4:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1013b9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013be:	75 0a                	jne    1013ca <cons_intr+0x3b>
                cons.wpos = 0;
  1013c0:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
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
  101438:	a1 48 a4 11 00       	mov    0x11a448,%eax
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
  101499:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10149e:	83 c8 40             	or     $0x40,%eax
  1014a1:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014a6:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ab:	e9 22 01 00 00       	jmp    1015d2 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  1014b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b4:	84 c0                	test   %al,%al
  1014b6:	79 45                	jns    1014fd <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014b8:	a1 68 a6 11 00       	mov    0x11a668,%eax
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
  1014d7:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014de:	0c 40                	or     $0x40,%al
  1014e0:	0f b6 c0             	movzbl %al,%eax
  1014e3:	f7 d0                	not    %eax
  1014e5:	89 c2                	mov    %eax,%edx
  1014e7:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014ec:	21 d0                	and    %edx,%eax
  1014ee:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014f3:	b8 00 00 00 00       	mov    $0x0,%eax
  1014f8:	e9 d5 00 00 00       	jmp    1015d2 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  1014fd:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101502:	83 e0 40             	and    $0x40,%eax
  101505:	85 c0                	test   %eax,%eax
  101507:	74 11                	je     10151a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101509:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10150d:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101512:	83 e0 bf             	and    $0xffffffbf,%eax
  101515:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  10151a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151e:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  101525:	0f b6 d0             	movzbl %al,%edx
  101528:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10152d:	09 d0                	or     %edx,%eax
  10152f:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  101534:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101538:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  10153f:	0f b6 d0             	movzbl %al,%edx
  101542:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101547:	31 d0                	xor    %edx,%eax
  101549:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  10154e:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101553:	83 e0 03             	and    $0x3,%eax
  101556:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  10155d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101561:	01 d0                	add    %edx,%eax
  101563:	0f b6 00             	movzbl (%eax),%eax
  101566:	0f b6 c0             	movzbl %al,%eax
  101569:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10156c:	a1 68 a6 11 00       	mov    0x11a668,%eax
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
  10159a:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10159f:	f7 d0                	not    %eax
  1015a1:	83 e0 06             	and    $0x6,%eax
  1015a4:	85 c0                	test   %eax,%eax
  1015a6:	75 27                	jne    1015cf <kbd_proc_data+0x17f>
  1015a8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015af:	75 1e                	jne    1015cf <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  1015b1:	c7 04 24 75 5e 10 00 	movl   $0x105e75,(%esp)
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
  101618:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10161d:	85 c0                	test   %eax,%eax
  10161f:	75 0c                	jne    10162d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101621:	c7 04 24 81 5e 10 00 	movl   $0x105e81,(%esp)
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
  10168c:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  101692:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101697:	39 c2                	cmp    %eax,%edx
  101699:	74 31                	je     1016cc <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10169b:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1016a0:	8d 50 01             	lea    0x1(%eax),%edx
  1016a3:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  1016a9:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  1016b0:	0f b6 c0             	movzbl %al,%eax
  1016b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1016b6:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1016bb:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016c0:	75 0a                	jne    1016cc <cons_getc+0x5f>
                cons.rpos = 0;
  1016c2:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
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
  1016ec:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  1016f2:	a1 6c a6 11 00       	mov    0x11a66c,%eax
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
  10174f:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
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
  10176e:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
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
  101882:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101889:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10188e:	74 0f                	je     10189f <pic_init+0x137>
        pic_setmask(irq_mask);
  101890:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
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
  1018be:	c7 04 24 a0 5e 10 00 	movl   $0x105ea0,(%esp)
  1018c5:	e8 d8 e9 ff ff       	call   1002a2 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018ca:	90                   	nop
  1018cb:	c9                   	leave  
  1018cc:	c3                   	ret    

001018cd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018cd:	55                   	push   %ebp
  1018ce:	89 e5                	mov    %esp,%ebp
  1018d0:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
          extern uintptr_t __vectors[];
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018da:	e9 c4 00 00 00       	jmp    1019a3 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e2:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018e9:	0f b7 d0             	movzwl %ax,%edx
  1018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ef:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  1018f6:	00 
  1018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fa:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  101901:	00 08 00 
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  10190e:	00 
  10190f:	80 e2 e0             	and    $0xe0,%dl
  101912:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191c:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101923:	00 
  101924:	80 e2 1f             	and    $0x1f,%dl
  101927:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101938:	00 
  101939:	80 e2 f0             	and    $0xf0,%dl
  10193c:	80 ca 0e             	or     $0xe,%dl
  10193f:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101949:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101950:	00 
  101951:	80 e2 ef             	and    $0xef,%dl
  101954:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195e:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101965:	00 
  101966:	80 e2 9f             	and    $0x9f,%dl
  101969:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101973:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10197a:	00 
  10197b:	80 ca 80             	or     $0x80,%dl
  10197e:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101985:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101988:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  10198f:	c1 e8 10             	shr    $0x10,%eax
  101992:	0f b7 d0             	movzwl %ax,%edx
  101995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101998:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  10199f:	00 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019a0:	ff 45 fc             	incl   -0x4(%ebp)
  1019a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019ab:	0f 86 2e ff ff ff    	jbe    1018df <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  1019b1:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  1019b6:	0f b7 c0             	movzwl %ax,%eax
  1019b9:	66 a3 48 aa 11 00    	mov    %ax,0x11aa48
  1019bf:	66 c7 05 4a aa 11 00 	movw   $0x8,0x11aa4a
  1019c6:	08 00 
  1019c8:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019cf:	24 e0                	and    $0xe0,%al
  1019d1:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019d6:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019dd:	24 1f                	and    $0x1f,%al
  1019df:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019e4:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019eb:	0c 0f                	or     $0xf,%al
  1019ed:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  1019f2:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019f9:	24 ef                	and    $0xef,%al
  1019fb:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a00:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a07:	0c 60                	or     $0x60,%al
  101a09:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a0e:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a15:	0c 80                	or     $0x80,%al
  101a17:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a1c:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  101a21:	c1 e8 10             	shr    $0x10,%eax
  101a24:	0f b7 c0             	movzwl %ax,%eax
  101a27:	66 a3 4e aa 11 00    	mov    %ax,0x11aa4e
  101a2d:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a37:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
  101a3a:	90                   	nop
  101a3b:	c9                   	leave  
  101a3c:	c3                   	ret    

00101a3d <trapname>:

static const char *
trapname(int trapno) {
  101a3d:	55                   	push   %ebp
  101a3e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a40:	8b 45 08             	mov    0x8(%ebp),%eax
  101a43:	83 f8 13             	cmp    $0x13,%eax
  101a46:	77 0c                	ja     101a54 <trapname+0x17>
        return excnames[trapno];
  101a48:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4b:	8b 04 85 00 62 10 00 	mov    0x106200(,%eax,4),%eax
  101a52:	eb 18                	jmp    101a6c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a54:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a58:	7e 0d                	jle    101a67 <trapname+0x2a>
  101a5a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a5e:	7f 07                	jg     101a67 <trapname+0x2a>
        return "Hardware Interrupt";
  101a60:	b8 aa 5e 10 00       	mov    $0x105eaa,%eax
  101a65:	eb 05                	jmp    101a6c <trapname+0x2f>
    }
    return "(unknown trap)";
  101a67:	b8 bd 5e 10 00       	mov    $0x105ebd,%eax
}
  101a6c:	5d                   	pop    %ebp
  101a6d:	c3                   	ret    

00101a6e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a6e:	55                   	push   %ebp
  101a6f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a71:	8b 45 08             	mov    0x8(%ebp),%eax
  101a74:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a78:	83 f8 08             	cmp    $0x8,%eax
  101a7b:	0f 94 c0             	sete   %al
  101a7e:	0f b6 c0             	movzbl %al,%eax
}
  101a81:	5d                   	pop    %ebp
  101a82:	c3                   	ret    

00101a83 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a83:	55                   	push   %ebp
  101a84:	89 e5                	mov    %esp,%ebp
  101a86:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a89:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a90:	c7 04 24 fe 5e 10 00 	movl   $0x105efe,(%esp)
  101a97:	e8 06 e8 ff ff       	call   1002a2 <cprintf>
    print_regs(&tf->tf_regs);
  101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9f:	89 04 24             	mov    %eax,(%esp)
  101aa2:	e8 8f 01 00 00       	call   101c36 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaa:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab2:	c7 04 24 0f 5f 10 00 	movl   $0x105f0f,(%esp)
  101ab9:	e8 e4 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101abe:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac1:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac9:	c7 04 24 22 5f 10 00 	movl   $0x105f22,(%esp)
  101ad0:	e8 cd e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad8:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae0:	c7 04 24 35 5f 10 00 	movl   $0x105f35,(%esp)
  101ae7:	e8 b6 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101aec:	8b 45 08             	mov    0x8(%ebp),%eax
  101aef:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af7:	c7 04 24 48 5f 10 00 	movl   $0x105f48,(%esp)
  101afe:	e8 9f e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	8b 40 30             	mov    0x30(%eax),%eax
  101b09:	89 04 24             	mov    %eax,(%esp)
  101b0c:	e8 2c ff ff ff       	call   101a3d <trapname>
  101b11:	89 c2                	mov    %eax,%edx
  101b13:	8b 45 08             	mov    0x8(%ebp),%eax
  101b16:	8b 40 30             	mov    0x30(%eax),%eax
  101b19:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b21:	c7 04 24 5b 5f 10 00 	movl   $0x105f5b,(%esp)
  101b28:	e8 75 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b30:	8b 40 34             	mov    0x34(%eax),%eax
  101b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b37:	c7 04 24 6d 5f 10 00 	movl   $0x105f6d,(%esp)
  101b3e:	e8 5f e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b43:	8b 45 08             	mov    0x8(%ebp),%eax
  101b46:	8b 40 38             	mov    0x38(%eax),%eax
  101b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4d:	c7 04 24 7c 5f 10 00 	movl   $0x105f7c,(%esp)
  101b54:	e8 49 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b59:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b64:	c7 04 24 8b 5f 10 00 	movl   $0x105f8b,(%esp)
  101b6b:	e8 32 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b70:	8b 45 08             	mov    0x8(%ebp),%eax
  101b73:	8b 40 40             	mov    0x40(%eax),%eax
  101b76:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7a:	c7 04 24 9e 5f 10 00 	movl   $0x105f9e,(%esp)
  101b81:	e8 1c e7 ff ff       	call   1002a2 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b8d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b94:	eb 3d                	jmp    101bd3 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b96:	8b 45 08             	mov    0x8(%ebp),%eax
  101b99:	8b 50 40             	mov    0x40(%eax),%edx
  101b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b9f:	21 d0                	and    %edx,%eax
  101ba1:	85 c0                	test   %eax,%eax
  101ba3:	74 28                	je     101bcd <print_trapframe+0x14a>
  101ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba8:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101baf:	85 c0                	test   %eax,%eax
  101bb1:	74 1a                	je     101bcd <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb6:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc1:	c7 04 24 ad 5f 10 00 	movl   $0x105fad,(%esp)
  101bc8:	e8 d5 e6 ff ff       	call   1002a2 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bcd:	ff 45 f4             	incl   -0xc(%ebp)
  101bd0:	d1 65 f0             	shll   -0x10(%ebp)
  101bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd6:	83 f8 17             	cmp    $0x17,%eax
  101bd9:	76 bb                	jbe    101b96 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bde:	8b 40 40             	mov    0x40(%eax),%eax
  101be1:	c1 e8 0c             	shr    $0xc,%eax
  101be4:	83 e0 03             	and    $0x3,%eax
  101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101beb:	c7 04 24 b1 5f 10 00 	movl   $0x105fb1,(%esp)
  101bf2:	e8 ab e6 ff ff       	call   1002a2 <cprintf>

    if (!trap_in_kernel(tf)) {
  101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfa:	89 04 24             	mov    %eax,(%esp)
  101bfd:	e8 6c fe ff ff       	call   101a6e <trap_in_kernel>
  101c02:	85 c0                	test   %eax,%eax
  101c04:	75 2d                	jne    101c33 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 44             	mov    0x44(%eax),%eax
  101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c10:	c7 04 24 ba 5f 10 00 	movl   $0x105fba,(%esp)
  101c17:	e8 86 e6 ff ff       	call   1002a2 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1f:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c27:	c7 04 24 c9 5f 10 00 	movl   $0x105fc9,(%esp)
  101c2e:	e8 6f e6 ff ff       	call   1002a2 <cprintf>
    }
}
  101c33:	90                   	nop
  101c34:	c9                   	leave  
  101c35:	c3                   	ret    

00101c36 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c36:	55                   	push   %ebp
  101c37:	89 e5                	mov    %esp,%ebp
  101c39:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3f:	8b 00                	mov    (%eax),%eax
  101c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c45:	c7 04 24 dc 5f 10 00 	movl   $0x105fdc,(%esp)
  101c4c:	e8 51 e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c51:	8b 45 08             	mov    0x8(%ebp),%eax
  101c54:	8b 40 04             	mov    0x4(%eax),%eax
  101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5b:	c7 04 24 eb 5f 10 00 	movl   $0x105feb,(%esp)
  101c62:	e8 3b e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c67:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6a:	8b 40 08             	mov    0x8(%eax),%eax
  101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c71:	c7 04 24 fa 5f 10 00 	movl   $0x105ffa,(%esp)
  101c78:	e8 25 e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c80:	8b 40 0c             	mov    0xc(%eax),%eax
  101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c87:	c7 04 24 09 60 10 00 	movl   $0x106009,(%esp)
  101c8e:	e8 0f e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	8b 40 10             	mov    0x10(%eax),%eax
  101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9d:	c7 04 24 18 60 10 00 	movl   $0x106018,(%esp)
  101ca4:	e8 f9 e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cac:	8b 40 14             	mov    0x14(%eax),%eax
  101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb3:	c7 04 24 27 60 10 00 	movl   $0x106027,(%esp)
  101cba:	e8 e3 e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc2:	8b 40 18             	mov    0x18(%eax),%eax
  101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc9:	c7 04 24 36 60 10 00 	movl   $0x106036,(%esp)
  101cd0:	e8 cd e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd8:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdf:	c7 04 24 45 60 10 00 	movl   $0x106045,(%esp)
  101ce6:	e8 b7 e5 ff ff       	call   1002a2 <cprintf>
}
  101ceb:	90                   	nop
  101cec:	c9                   	leave  
  101ced:	c3                   	ret    

00101cee <trap_dispatch>:
struct trapframe switchk2u, *switchu2k;
/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cee:	55                   	push   %ebp
  101cef:	89 e5                	mov    %esp,%ebp
  101cf1:	57                   	push   %edi
  101cf2:	56                   	push   %esi
  101cf3:	53                   	push   %ebx
  101cf4:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfa:	8b 40 30             	mov    0x30(%eax),%eax
  101cfd:	83 f8 2f             	cmp    $0x2f,%eax
  101d00:	77 21                	ja     101d23 <trap_dispatch+0x35>
  101d02:	83 f8 2e             	cmp    $0x2e,%eax
  101d05:	0f 83 f9 03 00 00    	jae    102104 <trap_dispatch+0x416>
  101d0b:	83 f8 21             	cmp    $0x21,%eax
  101d0e:	0f 84 9c 00 00 00    	je     101db0 <trap_dispatch+0xc2>
  101d14:	83 f8 24             	cmp    $0x24,%eax
  101d17:	74 6e                	je     101d87 <trap_dispatch+0x99>
  101d19:	83 f8 20             	cmp    $0x20,%eax
  101d1c:	74 1c                	je     101d3a <trap_dispatch+0x4c>
  101d1e:	e9 ac 03 00 00       	jmp    1020cf <trap_dispatch+0x3e1>
  101d23:	83 f8 78             	cmp    $0x78,%eax
  101d26:	0f 84 42 02 00 00    	je     101f6e <trap_dispatch+0x280>
  101d2c:	83 f8 79             	cmp    $0x79,%eax
  101d2f:	0f 84 1d 03 00 00    	je     102052 <trap_dispatch+0x364>
  101d35:	e9 95 03 00 00       	jmp    1020cf <trap_dispatch+0x3e1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101d3a:	a1 0c af 11 00       	mov    0x11af0c,%eax
  101d3f:	40                   	inc    %eax
  101d40:	a3 0c af 11 00       	mov    %eax,0x11af0c
        if(ticks % 100 == 0)
  101d45:	8b 0d 0c af 11 00    	mov    0x11af0c,%ecx
  101d4b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d50:	89 c8                	mov    %ecx,%eax
  101d52:	f7 e2                	mul    %edx
  101d54:	c1 ea 05             	shr    $0x5,%edx
  101d57:	89 d0                	mov    %edx,%eax
  101d59:	c1 e0 02             	shl    $0x2,%eax
  101d5c:	01 d0                	add    %edx,%eax
  101d5e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d65:	01 d0                	add    %edx,%eax
  101d67:	c1 e0 02             	shl    $0x2,%eax
  101d6a:	29 c1                	sub    %eax,%ecx
  101d6c:	89 ca                	mov    %ecx,%edx
  101d6e:	85 d2                	test   %edx,%edx
  101d70:	0f 85 91 03 00 00    	jne    102107 <trap_dispatch+0x419>
            print_ticks("100 ticks");
  101d76:	c7 04 24 54 60 10 00 	movl   $0x106054,(%esp)
  101d7d:	e8 2e fb ff ff       	call   1018b0 <print_ticks>
        break;
  101d82:	e9 80 03 00 00       	jmp    102107 <trap_dispatch+0x419>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d87:	e8 e1 f8 ff ff       	call   10166d <cons_getc>
  101d8c:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d8f:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d93:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d97:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d9f:	c7 04 24 5e 60 10 00 	movl   $0x10605e,(%esp)
  101da6:	e8 f7 e4 ff ff       	call   1002a2 <cprintf>
        break;
  101dab:	e9 5e 03 00 00       	jmp    10210e <trap_dispatch+0x420>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101db0:	e8 b8 f8 ff ff       	call   10166d <cons_getc>
  101db5:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101db8:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101dbc:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dc0:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc8:	c7 04 24 70 60 10 00 	movl   $0x106070,(%esp)
  101dcf:	e8 ce e4 ff ff       	call   1002a2 <cprintf>
        switch (c)
  101dd4:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dd8:	83 f8 30             	cmp    $0x30,%eax
  101ddb:	74 0e                	je     101deb <trap_dispatch+0xfd>
  101ddd:	83 f8 33             	cmp    $0x33,%eax
  101de0:	0f 84 90 00 00 00    	je     101e76 <trap_dispatch+0x188>
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
            print_trapframe(tf);
        }
        break;
        default:
            break;
  101de6:	e9 7e 01 00 00       	jmp    101f69 <trap_dispatch+0x27b>
            if (tf->tf_cs != KERNEL_CS) {
  101deb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dee:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101df2:	83 f8 08             	cmp    $0x8,%eax
  101df5:	0f 84 67 01 00 00    	je     101f62 <trap_dispatch+0x274>
            tf->tf_cs = KERNEL_CS;
  101dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfe:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e04:	8b 45 08             	mov    0x8(%ebp),%eax
  101e07:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e10:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e14:	8b 45 08             	mov    0x8(%ebp),%eax
  101e17:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1e:	8b 40 40             	mov    0x40(%eax),%eax
  101e21:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101e26:	89 c2                	mov    %eax,%edx
  101e28:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2b:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e31:	8b 40 44             	mov    0x44(%eax),%eax
  101e34:	83 e8 44             	sub    $0x44,%eax
  101e37:	a3 6c af 11 00       	mov    %eax,0x11af6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e3c:	a1 6c af 11 00       	mov    0x11af6c,%eax
  101e41:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e48:	00 
  101e49:	8b 55 08             	mov    0x8(%ebp),%edx
  101e4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e50:	89 04 24             	mov    %eax,(%esp)
  101e53:	e8 26 35 00 00       	call   10537e <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e58:	8b 15 6c af 11 00    	mov    0x11af6c,%edx
  101e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e61:	83 e8 04             	sub    $0x4,%eax
  101e64:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
  101e66:	8b 45 08             	mov    0x8(%ebp),%eax
  101e69:	89 04 24             	mov    %eax,(%esp)
  101e6c:	e8 12 fc ff ff       	call   101a83 <print_trapframe>
            break;
  101e71:	e9 ec 00 00 00       	jmp    101f62 <trap_dispatch+0x274>
            if (tf->tf_cs != USER_CS) {
  101e76:	8b 45 08             	mov    0x8(%ebp),%eax
  101e79:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e7d:	83 f8 1b             	cmp    $0x1b,%eax
  101e80:	0f 84 e2 00 00 00    	je     101f68 <trap_dispatch+0x27a>
            switchk2u = *tf;
  101e86:	8b 55 08             	mov    0x8(%ebp),%edx
  101e89:	b8 20 af 11 00       	mov    $0x11af20,%eax
  101e8e:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101e93:	89 c1                	mov    %eax,%ecx
  101e95:	83 e1 01             	and    $0x1,%ecx
  101e98:	85 c9                	test   %ecx,%ecx
  101e9a:	74 0c                	je     101ea8 <trap_dispatch+0x1ba>
  101e9c:	0f b6 0a             	movzbl (%edx),%ecx
  101e9f:	88 08                	mov    %cl,(%eax)
  101ea1:	8d 40 01             	lea    0x1(%eax),%eax
  101ea4:	8d 52 01             	lea    0x1(%edx),%edx
  101ea7:	4b                   	dec    %ebx
  101ea8:	89 c1                	mov    %eax,%ecx
  101eaa:	83 e1 02             	and    $0x2,%ecx
  101ead:	85 c9                	test   %ecx,%ecx
  101eaf:	74 0f                	je     101ec0 <trap_dispatch+0x1d2>
  101eb1:	0f b7 0a             	movzwl (%edx),%ecx
  101eb4:	66 89 08             	mov    %cx,(%eax)
  101eb7:	8d 40 02             	lea    0x2(%eax),%eax
  101eba:	8d 52 02             	lea    0x2(%edx),%edx
  101ebd:	83 eb 02             	sub    $0x2,%ebx
  101ec0:	89 df                	mov    %ebx,%edi
  101ec2:	83 e7 fc             	and    $0xfffffffc,%edi
  101ec5:	b9 00 00 00 00       	mov    $0x0,%ecx
  101eca:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101ecd:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101ed0:	83 c1 04             	add    $0x4,%ecx
  101ed3:	39 f9                	cmp    %edi,%ecx
  101ed5:	72 f3                	jb     101eca <trap_dispatch+0x1dc>
  101ed7:	01 c8                	add    %ecx,%eax
  101ed9:	01 ca                	add    %ecx,%edx
  101edb:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ee0:	89 de                	mov    %ebx,%esi
  101ee2:	83 e6 02             	and    $0x2,%esi
  101ee5:	85 f6                	test   %esi,%esi
  101ee7:	74 0b                	je     101ef4 <trap_dispatch+0x206>
  101ee9:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101eed:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101ef1:	83 c1 02             	add    $0x2,%ecx
  101ef4:	83 e3 01             	and    $0x1,%ebx
  101ef7:	85 db                	test   %ebx,%ebx
  101ef9:	74 07                	je     101f02 <trap_dispatch+0x214>
  101efb:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101eff:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101f02:	66 c7 05 5c af 11 00 	movw   $0x1b,0x11af5c
  101f09:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101f0b:	66 c7 05 68 af 11 00 	movw   $0x23,0x11af68
  101f12:	23 00 
  101f14:	0f b7 05 68 af 11 00 	movzwl 0x11af68,%eax
  101f1b:	66 a3 48 af 11 00    	mov    %ax,0x11af48
  101f21:	0f b7 05 48 af 11 00 	movzwl 0x11af48,%eax
  101f28:	66 a3 4c af 11 00    	mov    %ax,0x11af4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f31:	83 c0 44             	add    $0x44,%eax
  101f34:	a3 64 af 11 00       	mov    %eax,0x11af64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101f39:	a1 60 af 11 00       	mov    0x11af60,%eax
  101f3e:	0d 00 30 00 00       	or     $0x3000,%eax
  101f43:	a3 60 af 11 00       	mov    %eax,0x11af60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101f48:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4b:	83 e8 04             	sub    $0x4,%eax
  101f4e:	ba 20 af 11 00       	mov    $0x11af20,%edx
  101f53:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
  101f55:	8b 45 08             	mov    0x8(%ebp),%eax
  101f58:	89 04 24             	mov    %eax,(%esp)
  101f5b:	e8 23 fb ff ff       	call   101a83 <print_trapframe>
        break;
  101f60:	eb 06                	jmp    101f68 <trap_dispatch+0x27a>
            break;
  101f62:	90                   	nop
  101f63:	e9 a6 01 00 00       	jmp    10210e <trap_dispatch+0x420>
        break;
  101f68:	90                   	nop
        }
        break;  
  101f69:	e9 a0 01 00 00       	jmp    10210e <trap_dispatch+0x420>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
            if (tf->tf_cs != USER_CS) {
  101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f75:	83 f8 1b             	cmp    $0x1b,%eax
  101f78:	0f 84 8c 01 00 00    	je     10210a <trap_dispatch+0x41c>
            switchk2u = *tf;
  101f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  101f81:	b8 20 af 11 00       	mov    $0x11af20,%eax
  101f86:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101f8b:	89 c1                	mov    %eax,%ecx
  101f8d:	83 e1 01             	and    $0x1,%ecx
  101f90:	85 c9                	test   %ecx,%ecx
  101f92:	74 0c                	je     101fa0 <trap_dispatch+0x2b2>
  101f94:	0f b6 0a             	movzbl (%edx),%ecx
  101f97:	88 08                	mov    %cl,(%eax)
  101f99:	8d 40 01             	lea    0x1(%eax),%eax
  101f9c:	8d 52 01             	lea    0x1(%edx),%edx
  101f9f:	4b                   	dec    %ebx
  101fa0:	89 c1                	mov    %eax,%ecx
  101fa2:	83 e1 02             	and    $0x2,%ecx
  101fa5:	85 c9                	test   %ecx,%ecx
  101fa7:	74 0f                	je     101fb8 <trap_dispatch+0x2ca>
  101fa9:	0f b7 0a             	movzwl (%edx),%ecx
  101fac:	66 89 08             	mov    %cx,(%eax)
  101faf:	8d 40 02             	lea    0x2(%eax),%eax
  101fb2:	8d 52 02             	lea    0x2(%edx),%edx
  101fb5:	83 eb 02             	sub    $0x2,%ebx
  101fb8:	89 df                	mov    %ebx,%edi
  101fba:	83 e7 fc             	and    $0xfffffffc,%edi
  101fbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  101fc2:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101fc5:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101fc8:	83 c1 04             	add    $0x4,%ecx
  101fcb:	39 f9                	cmp    %edi,%ecx
  101fcd:	72 f3                	jb     101fc2 <trap_dispatch+0x2d4>
  101fcf:	01 c8                	add    %ecx,%eax
  101fd1:	01 ca                	add    %ecx,%edx
  101fd3:	b9 00 00 00 00       	mov    $0x0,%ecx
  101fd8:	89 de                	mov    %ebx,%esi
  101fda:	83 e6 02             	and    $0x2,%esi
  101fdd:	85 f6                	test   %esi,%esi
  101fdf:	74 0b                	je     101fec <trap_dispatch+0x2fe>
  101fe1:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101fe5:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101fe9:	83 c1 02             	add    $0x2,%ecx
  101fec:	83 e3 01             	and    $0x1,%ebx
  101fef:	85 db                	test   %ebx,%ebx
  101ff1:	74 07                	je     101ffa <trap_dispatch+0x30c>
  101ff3:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101ff7:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101ffa:	66 c7 05 5c af 11 00 	movw   $0x1b,0x11af5c
  102001:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  102003:	66 c7 05 68 af 11 00 	movw   $0x23,0x11af68
  10200a:	23 00 
  10200c:	0f b7 05 68 af 11 00 	movzwl 0x11af68,%eax
  102013:	66 a3 48 af 11 00    	mov    %ax,0x11af48
  102019:	0f b7 05 48 af 11 00 	movzwl 0x11af48,%eax
  102020:	66 a3 4c af 11 00    	mov    %ax,0x11af4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  102026:	8b 45 08             	mov    0x8(%ebp),%eax
  102029:	83 c0 44             	add    $0x44,%eax
  10202c:	a3 64 af 11 00       	mov    %eax,0x11af64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  102031:	a1 60 af 11 00       	mov    0x11af60,%eax
  102036:	0d 00 30 00 00       	or     $0x3000,%eax
  10203b:	a3 60 af 11 00       	mov    %eax,0x11af60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  102040:	8b 45 08             	mov    0x8(%ebp),%eax
  102043:	83 e8 04             	sub    $0x4,%eax
  102046:	ba 20 af 11 00       	mov    $0x11af20,%edx
  10204b:	89 10                	mov    %edx,(%eax)
        }
        break;
  10204d:	e9 b8 00 00 00       	jmp    10210a <trap_dispatch+0x41c>
    case T_SWITCH_TOK:
         if (tf->tf_cs != KERNEL_CS) {
  102052:	8b 45 08             	mov    0x8(%ebp),%eax
  102055:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102059:	83 f8 08             	cmp    $0x8,%eax
  10205c:	0f 84 ab 00 00 00    	je     10210d <trap_dispatch+0x41f>
            tf->tf_cs = KERNEL_CS;
  102062:	8b 45 08             	mov    0x8(%ebp),%eax
  102065:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  10206b:	8b 45 08             	mov    0x8(%ebp),%eax
  10206e:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  102074:	8b 45 08             	mov    0x8(%ebp),%eax
  102077:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  10207b:	8b 45 08             	mov    0x8(%ebp),%eax
  10207e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  102082:	8b 45 08             	mov    0x8(%ebp),%eax
  102085:	8b 40 40             	mov    0x40(%eax),%eax
  102088:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  10208d:	89 c2                	mov    %eax,%edx
  10208f:	8b 45 08             	mov    0x8(%ebp),%eax
  102092:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  102095:	8b 45 08             	mov    0x8(%ebp),%eax
  102098:	8b 40 44             	mov    0x44(%eax),%eax
  10209b:	83 e8 44             	sub    $0x44,%eax
  10209e:	a3 6c af 11 00       	mov    %eax,0x11af6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  1020a3:	a1 6c af 11 00       	mov    0x11af6c,%eax
  1020a8:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1020af:	00 
  1020b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1020b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1020b7:	89 04 24             	mov    %eax,(%esp)
  1020ba:	e8 bf 32 00 00       	call   10537e <memmove>
            //*((uint32_t *)tf - 1) = (uint32_t)tf;
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  1020bf:	8b 15 6c af 11 00    	mov    0x11af6c,%edx
  1020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1020c8:	83 e8 04             	sub    $0x4,%eax
  1020cb:	89 10                	mov    %edx,(%eax)
        }
        break;
  1020cd:	eb 3e                	jmp    10210d <trap_dispatch+0x41f>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  1020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1020d2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020d6:	83 e0 03             	and    $0x3,%eax
  1020d9:	85 c0                	test   %eax,%eax
  1020db:	75 31                	jne    10210e <trap_dispatch+0x420>
            print_trapframe(tf);
  1020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1020e0:	89 04 24             	mov    %eax,(%esp)
  1020e3:	e8 9b f9 ff ff       	call   101a83 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  1020e8:	c7 44 24 08 7f 60 10 	movl   $0x10607f,0x8(%esp)
  1020ef:	00 
  1020f0:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1020f7:	00 
  1020f8:	c7 04 24 9b 60 10 00 	movl   $0x10609b,(%esp)
  1020ff:	e8 f5 e2 ff ff       	call   1003f9 <__panic>
        break;
  102104:	90                   	nop
  102105:	eb 07                	jmp    10210e <trap_dispatch+0x420>
        break;
  102107:	90                   	nop
  102108:	eb 04                	jmp    10210e <trap_dispatch+0x420>
        break;
  10210a:	90                   	nop
  10210b:	eb 01                	jmp    10210e <trap_dispatch+0x420>
        break;
  10210d:	90                   	nop
        }
    }
}
  10210e:	90                   	nop
  10210f:	83 c4 2c             	add    $0x2c,%esp
  102112:	5b                   	pop    %ebx
  102113:	5e                   	pop    %esi
  102114:	5f                   	pop    %edi
  102115:	5d                   	pop    %ebp
  102116:	c3                   	ret    

00102117 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102117:	55                   	push   %ebp
  102118:	89 e5                	mov    %esp,%ebp
  10211a:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10211d:	8b 45 08             	mov    0x8(%ebp),%eax
  102120:	89 04 24             	mov    %eax,(%esp)
  102123:	e8 c6 fb ff ff       	call   101cee <trap_dispatch>
}
  102128:	90                   	nop
  102129:	c9                   	leave  
  10212a:	c3                   	ret    

0010212b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $0
  10212d:	6a 00                	push   $0x0
  jmp __alltraps
  10212f:	e9 69 0a 00 00       	jmp    102b9d <__alltraps>

00102134 <vector1>:
.globl vector1
vector1:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $1
  102136:	6a 01                	push   $0x1
  jmp __alltraps
  102138:	e9 60 0a 00 00       	jmp    102b9d <__alltraps>

0010213d <vector2>:
.globl vector2
vector2:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $2
  10213f:	6a 02                	push   $0x2
  jmp __alltraps
  102141:	e9 57 0a 00 00       	jmp    102b9d <__alltraps>

00102146 <vector3>:
.globl vector3
vector3:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $3
  102148:	6a 03                	push   $0x3
  jmp __alltraps
  10214a:	e9 4e 0a 00 00       	jmp    102b9d <__alltraps>

0010214f <vector4>:
.globl vector4
vector4:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $4
  102151:	6a 04                	push   $0x4
  jmp __alltraps
  102153:	e9 45 0a 00 00       	jmp    102b9d <__alltraps>

00102158 <vector5>:
.globl vector5
vector5:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $5
  10215a:	6a 05                	push   $0x5
  jmp __alltraps
  10215c:	e9 3c 0a 00 00       	jmp    102b9d <__alltraps>

00102161 <vector6>:
.globl vector6
vector6:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $6
  102163:	6a 06                	push   $0x6
  jmp __alltraps
  102165:	e9 33 0a 00 00       	jmp    102b9d <__alltraps>

0010216a <vector7>:
.globl vector7
vector7:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $7
  10216c:	6a 07                	push   $0x7
  jmp __alltraps
  10216e:	e9 2a 0a 00 00       	jmp    102b9d <__alltraps>

00102173 <vector8>:
.globl vector8
vector8:
  pushl $8
  102173:	6a 08                	push   $0x8
  jmp __alltraps
  102175:	e9 23 0a 00 00       	jmp    102b9d <__alltraps>

0010217a <vector9>:
.globl vector9
vector9:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $9
  10217c:	6a 09                	push   $0x9
  jmp __alltraps
  10217e:	e9 1a 0a 00 00       	jmp    102b9d <__alltraps>

00102183 <vector10>:
.globl vector10
vector10:
  pushl $10
  102183:	6a 0a                	push   $0xa
  jmp __alltraps
  102185:	e9 13 0a 00 00       	jmp    102b9d <__alltraps>

0010218a <vector11>:
.globl vector11
vector11:
  pushl $11
  10218a:	6a 0b                	push   $0xb
  jmp __alltraps
  10218c:	e9 0c 0a 00 00       	jmp    102b9d <__alltraps>

00102191 <vector12>:
.globl vector12
vector12:
  pushl $12
  102191:	6a 0c                	push   $0xc
  jmp __alltraps
  102193:	e9 05 0a 00 00       	jmp    102b9d <__alltraps>

00102198 <vector13>:
.globl vector13
vector13:
  pushl $13
  102198:	6a 0d                	push   $0xd
  jmp __alltraps
  10219a:	e9 fe 09 00 00       	jmp    102b9d <__alltraps>

0010219f <vector14>:
.globl vector14
vector14:
  pushl $14
  10219f:	6a 0e                	push   $0xe
  jmp __alltraps
  1021a1:	e9 f7 09 00 00       	jmp    102b9d <__alltraps>

001021a6 <vector15>:
.globl vector15
vector15:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $15
  1021a8:	6a 0f                	push   $0xf
  jmp __alltraps
  1021aa:	e9 ee 09 00 00       	jmp    102b9d <__alltraps>

001021af <vector16>:
.globl vector16
vector16:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $16
  1021b1:	6a 10                	push   $0x10
  jmp __alltraps
  1021b3:	e9 e5 09 00 00       	jmp    102b9d <__alltraps>

001021b8 <vector17>:
.globl vector17
vector17:
  pushl $17
  1021b8:	6a 11                	push   $0x11
  jmp __alltraps
  1021ba:	e9 de 09 00 00       	jmp    102b9d <__alltraps>

001021bf <vector18>:
.globl vector18
vector18:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $18
  1021c1:	6a 12                	push   $0x12
  jmp __alltraps
  1021c3:	e9 d5 09 00 00       	jmp    102b9d <__alltraps>

001021c8 <vector19>:
.globl vector19
vector19:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $19
  1021ca:	6a 13                	push   $0x13
  jmp __alltraps
  1021cc:	e9 cc 09 00 00       	jmp    102b9d <__alltraps>

001021d1 <vector20>:
.globl vector20
vector20:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $20
  1021d3:	6a 14                	push   $0x14
  jmp __alltraps
  1021d5:	e9 c3 09 00 00       	jmp    102b9d <__alltraps>

001021da <vector21>:
.globl vector21
vector21:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $21
  1021dc:	6a 15                	push   $0x15
  jmp __alltraps
  1021de:	e9 ba 09 00 00       	jmp    102b9d <__alltraps>

001021e3 <vector22>:
.globl vector22
vector22:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $22
  1021e5:	6a 16                	push   $0x16
  jmp __alltraps
  1021e7:	e9 b1 09 00 00       	jmp    102b9d <__alltraps>

001021ec <vector23>:
.globl vector23
vector23:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $23
  1021ee:	6a 17                	push   $0x17
  jmp __alltraps
  1021f0:	e9 a8 09 00 00       	jmp    102b9d <__alltraps>

001021f5 <vector24>:
.globl vector24
vector24:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $24
  1021f7:	6a 18                	push   $0x18
  jmp __alltraps
  1021f9:	e9 9f 09 00 00       	jmp    102b9d <__alltraps>

001021fe <vector25>:
.globl vector25
vector25:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $25
  102200:	6a 19                	push   $0x19
  jmp __alltraps
  102202:	e9 96 09 00 00       	jmp    102b9d <__alltraps>

00102207 <vector26>:
.globl vector26
vector26:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $26
  102209:	6a 1a                	push   $0x1a
  jmp __alltraps
  10220b:	e9 8d 09 00 00       	jmp    102b9d <__alltraps>

00102210 <vector27>:
.globl vector27
vector27:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $27
  102212:	6a 1b                	push   $0x1b
  jmp __alltraps
  102214:	e9 84 09 00 00       	jmp    102b9d <__alltraps>

00102219 <vector28>:
.globl vector28
vector28:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $28
  10221b:	6a 1c                	push   $0x1c
  jmp __alltraps
  10221d:	e9 7b 09 00 00       	jmp    102b9d <__alltraps>

00102222 <vector29>:
.globl vector29
vector29:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $29
  102224:	6a 1d                	push   $0x1d
  jmp __alltraps
  102226:	e9 72 09 00 00       	jmp    102b9d <__alltraps>

0010222b <vector30>:
.globl vector30
vector30:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $30
  10222d:	6a 1e                	push   $0x1e
  jmp __alltraps
  10222f:	e9 69 09 00 00       	jmp    102b9d <__alltraps>

00102234 <vector31>:
.globl vector31
vector31:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $31
  102236:	6a 1f                	push   $0x1f
  jmp __alltraps
  102238:	e9 60 09 00 00       	jmp    102b9d <__alltraps>

0010223d <vector32>:
.globl vector32
vector32:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $32
  10223f:	6a 20                	push   $0x20
  jmp __alltraps
  102241:	e9 57 09 00 00       	jmp    102b9d <__alltraps>

00102246 <vector33>:
.globl vector33
vector33:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $33
  102248:	6a 21                	push   $0x21
  jmp __alltraps
  10224a:	e9 4e 09 00 00       	jmp    102b9d <__alltraps>

0010224f <vector34>:
.globl vector34
vector34:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $34
  102251:	6a 22                	push   $0x22
  jmp __alltraps
  102253:	e9 45 09 00 00       	jmp    102b9d <__alltraps>

00102258 <vector35>:
.globl vector35
vector35:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $35
  10225a:	6a 23                	push   $0x23
  jmp __alltraps
  10225c:	e9 3c 09 00 00       	jmp    102b9d <__alltraps>

00102261 <vector36>:
.globl vector36
vector36:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $36
  102263:	6a 24                	push   $0x24
  jmp __alltraps
  102265:	e9 33 09 00 00       	jmp    102b9d <__alltraps>

0010226a <vector37>:
.globl vector37
vector37:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $37
  10226c:	6a 25                	push   $0x25
  jmp __alltraps
  10226e:	e9 2a 09 00 00       	jmp    102b9d <__alltraps>

00102273 <vector38>:
.globl vector38
vector38:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $38
  102275:	6a 26                	push   $0x26
  jmp __alltraps
  102277:	e9 21 09 00 00       	jmp    102b9d <__alltraps>

0010227c <vector39>:
.globl vector39
vector39:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $39
  10227e:	6a 27                	push   $0x27
  jmp __alltraps
  102280:	e9 18 09 00 00       	jmp    102b9d <__alltraps>

00102285 <vector40>:
.globl vector40
vector40:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $40
  102287:	6a 28                	push   $0x28
  jmp __alltraps
  102289:	e9 0f 09 00 00       	jmp    102b9d <__alltraps>

0010228e <vector41>:
.globl vector41
vector41:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $41
  102290:	6a 29                	push   $0x29
  jmp __alltraps
  102292:	e9 06 09 00 00       	jmp    102b9d <__alltraps>

00102297 <vector42>:
.globl vector42
vector42:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $42
  102299:	6a 2a                	push   $0x2a
  jmp __alltraps
  10229b:	e9 fd 08 00 00       	jmp    102b9d <__alltraps>

001022a0 <vector43>:
.globl vector43
vector43:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $43
  1022a2:	6a 2b                	push   $0x2b
  jmp __alltraps
  1022a4:	e9 f4 08 00 00       	jmp    102b9d <__alltraps>

001022a9 <vector44>:
.globl vector44
vector44:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $44
  1022ab:	6a 2c                	push   $0x2c
  jmp __alltraps
  1022ad:	e9 eb 08 00 00       	jmp    102b9d <__alltraps>

001022b2 <vector45>:
.globl vector45
vector45:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $45
  1022b4:	6a 2d                	push   $0x2d
  jmp __alltraps
  1022b6:	e9 e2 08 00 00       	jmp    102b9d <__alltraps>

001022bb <vector46>:
.globl vector46
vector46:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $46
  1022bd:	6a 2e                	push   $0x2e
  jmp __alltraps
  1022bf:	e9 d9 08 00 00       	jmp    102b9d <__alltraps>

001022c4 <vector47>:
.globl vector47
vector47:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $47
  1022c6:	6a 2f                	push   $0x2f
  jmp __alltraps
  1022c8:	e9 d0 08 00 00       	jmp    102b9d <__alltraps>

001022cd <vector48>:
.globl vector48
vector48:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $48
  1022cf:	6a 30                	push   $0x30
  jmp __alltraps
  1022d1:	e9 c7 08 00 00       	jmp    102b9d <__alltraps>

001022d6 <vector49>:
.globl vector49
vector49:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $49
  1022d8:	6a 31                	push   $0x31
  jmp __alltraps
  1022da:	e9 be 08 00 00       	jmp    102b9d <__alltraps>

001022df <vector50>:
.globl vector50
vector50:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $50
  1022e1:	6a 32                	push   $0x32
  jmp __alltraps
  1022e3:	e9 b5 08 00 00       	jmp    102b9d <__alltraps>

001022e8 <vector51>:
.globl vector51
vector51:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $51
  1022ea:	6a 33                	push   $0x33
  jmp __alltraps
  1022ec:	e9 ac 08 00 00       	jmp    102b9d <__alltraps>

001022f1 <vector52>:
.globl vector52
vector52:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $52
  1022f3:	6a 34                	push   $0x34
  jmp __alltraps
  1022f5:	e9 a3 08 00 00       	jmp    102b9d <__alltraps>

001022fa <vector53>:
.globl vector53
vector53:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $53
  1022fc:	6a 35                	push   $0x35
  jmp __alltraps
  1022fe:	e9 9a 08 00 00       	jmp    102b9d <__alltraps>

00102303 <vector54>:
.globl vector54
vector54:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $54
  102305:	6a 36                	push   $0x36
  jmp __alltraps
  102307:	e9 91 08 00 00       	jmp    102b9d <__alltraps>

0010230c <vector55>:
.globl vector55
vector55:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $55
  10230e:	6a 37                	push   $0x37
  jmp __alltraps
  102310:	e9 88 08 00 00       	jmp    102b9d <__alltraps>

00102315 <vector56>:
.globl vector56
vector56:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $56
  102317:	6a 38                	push   $0x38
  jmp __alltraps
  102319:	e9 7f 08 00 00       	jmp    102b9d <__alltraps>

0010231e <vector57>:
.globl vector57
vector57:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $57
  102320:	6a 39                	push   $0x39
  jmp __alltraps
  102322:	e9 76 08 00 00       	jmp    102b9d <__alltraps>

00102327 <vector58>:
.globl vector58
vector58:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $58
  102329:	6a 3a                	push   $0x3a
  jmp __alltraps
  10232b:	e9 6d 08 00 00       	jmp    102b9d <__alltraps>

00102330 <vector59>:
.globl vector59
vector59:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $59
  102332:	6a 3b                	push   $0x3b
  jmp __alltraps
  102334:	e9 64 08 00 00       	jmp    102b9d <__alltraps>

00102339 <vector60>:
.globl vector60
vector60:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $60
  10233b:	6a 3c                	push   $0x3c
  jmp __alltraps
  10233d:	e9 5b 08 00 00       	jmp    102b9d <__alltraps>

00102342 <vector61>:
.globl vector61
vector61:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $61
  102344:	6a 3d                	push   $0x3d
  jmp __alltraps
  102346:	e9 52 08 00 00       	jmp    102b9d <__alltraps>

0010234b <vector62>:
.globl vector62
vector62:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $62
  10234d:	6a 3e                	push   $0x3e
  jmp __alltraps
  10234f:	e9 49 08 00 00       	jmp    102b9d <__alltraps>

00102354 <vector63>:
.globl vector63
vector63:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $63
  102356:	6a 3f                	push   $0x3f
  jmp __alltraps
  102358:	e9 40 08 00 00       	jmp    102b9d <__alltraps>

0010235d <vector64>:
.globl vector64
vector64:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $64
  10235f:	6a 40                	push   $0x40
  jmp __alltraps
  102361:	e9 37 08 00 00       	jmp    102b9d <__alltraps>

00102366 <vector65>:
.globl vector65
vector65:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $65
  102368:	6a 41                	push   $0x41
  jmp __alltraps
  10236a:	e9 2e 08 00 00       	jmp    102b9d <__alltraps>

0010236f <vector66>:
.globl vector66
vector66:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $66
  102371:	6a 42                	push   $0x42
  jmp __alltraps
  102373:	e9 25 08 00 00       	jmp    102b9d <__alltraps>

00102378 <vector67>:
.globl vector67
vector67:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $67
  10237a:	6a 43                	push   $0x43
  jmp __alltraps
  10237c:	e9 1c 08 00 00       	jmp    102b9d <__alltraps>

00102381 <vector68>:
.globl vector68
vector68:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $68
  102383:	6a 44                	push   $0x44
  jmp __alltraps
  102385:	e9 13 08 00 00       	jmp    102b9d <__alltraps>

0010238a <vector69>:
.globl vector69
vector69:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $69
  10238c:	6a 45                	push   $0x45
  jmp __alltraps
  10238e:	e9 0a 08 00 00       	jmp    102b9d <__alltraps>

00102393 <vector70>:
.globl vector70
vector70:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $70
  102395:	6a 46                	push   $0x46
  jmp __alltraps
  102397:	e9 01 08 00 00       	jmp    102b9d <__alltraps>

0010239c <vector71>:
.globl vector71
vector71:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $71
  10239e:	6a 47                	push   $0x47
  jmp __alltraps
  1023a0:	e9 f8 07 00 00       	jmp    102b9d <__alltraps>

001023a5 <vector72>:
.globl vector72
vector72:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $72
  1023a7:	6a 48                	push   $0x48
  jmp __alltraps
  1023a9:	e9 ef 07 00 00       	jmp    102b9d <__alltraps>

001023ae <vector73>:
.globl vector73
vector73:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $73
  1023b0:	6a 49                	push   $0x49
  jmp __alltraps
  1023b2:	e9 e6 07 00 00       	jmp    102b9d <__alltraps>

001023b7 <vector74>:
.globl vector74
vector74:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $74
  1023b9:	6a 4a                	push   $0x4a
  jmp __alltraps
  1023bb:	e9 dd 07 00 00       	jmp    102b9d <__alltraps>

001023c0 <vector75>:
.globl vector75
vector75:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $75
  1023c2:	6a 4b                	push   $0x4b
  jmp __alltraps
  1023c4:	e9 d4 07 00 00       	jmp    102b9d <__alltraps>

001023c9 <vector76>:
.globl vector76
vector76:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $76
  1023cb:	6a 4c                	push   $0x4c
  jmp __alltraps
  1023cd:	e9 cb 07 00 00       	jmp    102b9d <__alltraps>

001023d2 <vector77>:
.globl vector77
vector77:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $77
  1023d4:	6a 4d                	push   $0x4d
  jmp __alltraps
  1023d6:	e9 c2 07 00 00       	jmp    102b9d <__alltraps>

001023db <vector78>:
.globl vector78
vector78:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $78
  1023dd:	6a 4e                	push   $0x4e
  jmp __alltraps
  1023df:	e9 b9 07 00 00       	jmp    102b9d <__alltraps>

001023e4 <vector79>:
.globl vector79
vector79:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $79
  1023e6:	6a 4f                	push   $0x4f
  jmp __alltraps
  1023e8:	e9 b0 07 00 00       	jmp    102b9d <__alltraps>

001023ed <vector80>:
.globl vector80
vector80:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $80
  1023ef:	6a 50                	push   $0x50
  jmp __alltraps
  1023f1:	e9 a7 07 00 00       	jmp    102b9d <__alltraps>

001023f6 <vector81>:
.globl vector81
vector81:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $81
  1023f8:	6a 51                	push   $0x51
  jmp __alltraps
  1023fa:	e9 9e 07 00 00       	jmp    102b9d <__alltraps>

001023ff <vector82>:
.globl vector82
vector82:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $82
  102401:	6a 52                	push   $0x52
  jmp __alltraps
  102403:	e9 95 07 00 00       	jmp    102b9d <__alltraps>

00102408 <vector83>:
.globl vector83
vector83:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $83
  10240a:	6a 53                	push   $0x53
  jmp __alltraps
  10240c:	e9 8c 07 00 00       	jmp    102b9d <__alltraps>

00102411 <vector84>:
.globl vector84
vector84:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $84
  102413:	6a 54                	push   $0x54
  jmp __alltraps
  102415:	e9 83 07 00 00       	jmp    102b9d <__alltraps>

0010241a <vector85>:
.globl vector85
vector85:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $85
  10241c:	6a 55                	push   $0x55
  jmp __alltraps
  10241e:	e9 7a 07 00 00       	jmp    102b9d <__alltraps>

00102423 <vector86>:
.globl vector86
vector86:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $86
  102425:	6a 56                	push   $0x56
  jmp __alltraps
  102427:	e9 71 07 00 00       	jmp    102b9d <__alltraps>

0010242c <vector87>:
.globl vector87
vector87:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $87
  10242e:	6a 57                	push   $0x57
  jmp __alltraps
  102430:	e9 68 07 00 00       	jmp    102b9d <__alltraps>

00102435 <vector88>:
.globl vector88
vector88:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $88
  102437:	6a 58                	push   $0x58
  jmp __alltraps
  102439:	e9 5f 07 00 00       	jmp    102b9d <__alltraps>

0010243e <vector89>:
.globl vector89
vector89:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $89
  102440:	6a 59                	push   $0x59
  jmp __alltraps
  102442:	e9 56 07 00 00       	jmp    102b9d <__alltraps>

00102447 <vector90>:
.globl vector90
vector90:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $90
  102449:	6a 5a                	push   $0x5a
  jmp __alltraps
  10244b:	e9 4d 07 00 00       	jmp    102b9d <__alltraps>

00102450 <vector91>:
.globl vector91
vector91:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $91
  102452:	6a 5b                	push   $0x5b
  jmp __alltraps
  102454:	e9 44 07 00 00       	jmp    102b9d <__alltraps>

00102459 <vector92>:
.globl vector92
vector92:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $92
  10245b:	6a 5c                	push   $0x5c
  jmp __alltraps
  10245d:	e9 3b 07 00 00       	jmp    102b9d <__alltraps>

00102462 <vector93>:
.globl vector93
vector93:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $93
  102464:	6a 5d                	push   $0x5d
  jmp __alltraps
  102466:	e9 32 07 00 00       	jmp    102b9d <__alltraps>

0010246b <vector94>:
.globl vector94
vector94:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $94
  10246d:	6a 5e                	push   $0x5e
  jmp __alltraps
  10246f:	e9 29 07 00 00       	jmp    102b9d <__alltraps>

00102474 <vector95>:
.globl vector95
vector95:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $95
  102476:	6a 5f                	push   $0x5f
  jmp __alltraps
  102478:	e9 20 07 00 00       	jmp    102b9d <__alltraps>

0010247d <vector96>:
.globl vector96
vector96:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $96
  10247f:	6a 60                	push   $0x60
  jmp __alltraps
  102481:	e9 17 07 00 00       	jmp    102b9d <__alltraps>

00102486 <vector97>:
.globl vector97
vector97:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $97
  102488:	6a 61                	push   $0x61
  jmp __alltraps
  10248a:	e9 0e 07 00 00       	jmp    102b9d <__alltraps>

0010248f <vector98>:
.globl vector98
vector98:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $98
  102491:	6a 62                	push   $0x62
  jmp __alltraps
  102493:	e9 05 07 00 00       	jmp    102b9d <__alltraps>

00102498 <vector99>:
.globl vector99
vector99:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $99
  10249a:	6a 63                	push   $0x63
  jmp __alltraps
  10249c:	e9 fc 06 00 00       	jmp    102b9d <__alltraps>

001024a1 <vector100>:
.globl vector100
vector100:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $100
  1024a3:	6a 64                	push   $0x64
  jmp __alltraps
  1024a5:	e9 f3 06 00 00       	jmp    102b9d <__alltraps>

001024aa <vector101>:
.globl vector101
vector101:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $101
  1024ac:	6a 65                	push   $0x65
  jmp __alltraps
  1024ae:	e9 ea 06 00 00       	jmp    102b9d <__alltraps>

001024b3 <vector102>:
.globl vector102
vector102:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $102
  1024b5:	6a 66                	push   $0x66
  jmp __alltraps
  1024b7:	e9 e1 06 00 00       	jmp    102b9d <__alltraps>

001024bc <vector103>:
.globl vector103
vector103:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $103
  1024be:	6a 67                	push   $0x67
  jmp __alltraps
  1024c0:	e9 d8 06 00 00       	jmp    102b9d <__alltraps>

001024c5 <vector104>:
.globl vector104
vector104:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $104
  1024c7:	6a 68                	push   $0x68
  jmp __alltraps
  1024c9:	e9 cf 06 00 00       	jmp    102b9d <__alltraps>

001024ce <vector105>:
.globl vector105
vector105:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $105
  1024d0:	6a 69                	push   $0x69
  jmp __alltraps
  1024d2:	e9 c6 06 00 00       	jmp    102b9d <__alltraps>

001024d7 <vector106>:
.globl vector106
vector106:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $106
  1024d9:	6a 6a                	push   $0x6a
  jmp __alltraps
  1024db:	e9 bd 06 00 00       	jmp    102b9d <__alltraps>

001024e0 <vector107>:
.globl vector107
vector107:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $107
  1024e2:	6a 6b                	push   $0x6b
  jmp __alltraps
  1024e4:	e9 b4 06 00 00       	jmp    102b9d <__alltraps>

001024e9 <vector108>:
.globl vector108
vector108:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $108
  1024eb:	6a 6c                	push   $0x6c
  jmp __alltraps
  1024ed:	e9 ab 06 00 00       	jmp    102b9d <__alltraps>

001024f2 <vector109>:
.globl vector109
vector109:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $109
  1024f4:	6a 6d                	push   $0x6d
  jmp __alltraps
  1024f6:	e9 a2 06 00 00       	jmp    102b9d <__alltraps>

001024fb <vector110>:
.globl vector110
vector110:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $110
  1024fd:	6a 6e                	push   $0x6e
  jmp __alltraps
  1024ff:	e9 99 06 00 00       	jmp    102b9d <__alltraps>

00102504 <vector111>:
.globl vector111
vector111:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $111
  102506:	6a 6f                	push   $0x6f
  jmp __alltraps
  102508:	e9 90 06 00 00       	jmp    102b9d <__alltraps>

0010250d <vector112>:
.globl vector112
vector112:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $112
  10250f:	6a 70                	push   $0x70
  jmp __alltraps
  102511:	e9 87 06 00 00       	jmp    102b9d <__alltraps>

00102516 <vector113>:
.globl vector113
vector113:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $113
  102518:	6a 71                	push   $0x71
  jmp __alltraps
  10251a:	e9 7e 06 00 00       	jmp    102b9d <__alltraps>

0010251f <vector114>:
.globl vector114
vector114:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $114
  102521:	6a 72                	push   $0x72
  jmp __alltraps
  102523:	e9 75 06 00 00       	jmp    102b9d <__alltraps>

00102528 <vector115>:
.globl vector115
vector115:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $115
  10252a:	6a 73                	push   $0x73
  jmp __alltraps
  10252c:	e9 6c 06 00 00       	jmp    102b9d <__alltraps>

00102531 <vector116>:
.globl vector116
vector116:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $116
  102533:	6a 74                	push   $0x74
  jmp __alltraps
  102535:	e9 63 06 00 00       	jmp    102b9d <__alltraps>

0010253a <vector117>:
.globl vector117
vector117:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $117
  10253c:	6a 75                	push   $0x75
  jmp __alltraps
  10253e:	e9 5a 06 00 00       	jmp    102b9d <__alltraps>

00102543 <vector118>:
.globl vector118
vector118:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $118
  102545:	6a 76                	push   $0x76
  jmp __alltraps
  102547:	e9 51 06 00 00       	jmp    102b9d <__alltraps>

0010254c <vector119>:
.globl vector119
vector119:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $119
  10254e:	6a 77                	push   $0x77
  jmp __alltraps
  102550:	e9 48 06 00 00       	jmp    102b9d <__alltraps>

00102555 <vector120>:
.globl vector120
vector120:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $120
  102557:	6a 78                	push   $0x78
  jmp __alltraps
  102559:	e9 3f 06 00 00       	jmp    102b9d <__alltraps>

0010255e <vector121>:
.globl vector121
vector121:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $121
  102560:	6a 79                	push   $0x79
  jmp __alltraps
  102562:	e9 36 06 00 00       	jmp    102b9d <__alltraps>

00102567 <vector122>:
.globl vector122
vector122:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $122
  102569:	6a 7a                	push   $0x7a
  jmp __alltraps
  10256b:	e9 2d 06 00 00       	jmp    102b9d <__alltraps>

00102570 <vector123>:
.globl vector123
vector123:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $123
  102572:	6a 7b                	push   $0x7b
  jmp __alltraps
  102574:	e9 24 06 00 00       	jmp    102b9d <__alltraps>

00102579 <vector124>:
.globl vector124
vector124:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $124
  10257b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10257d:	e9 1b 06 00 00       	jmp    102b9d <__alltraps>

00102582 <vector125>:
.globl vector125
vector125:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $125
  102584:	6a 7d                	push   $0x7d
  jmp __alltraps
  102586:	e9 12 06 00 00       	jmp    102b9d <__alltraps>

0010258b <vector126>:
.globl vector126
vector126:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $126
  10258d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10258f:	e9 09 06 00 00       	jmp    102b9d <__alltraps>

00102594 <vector127>:
.globl vector127
vector127:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $127
  102596:	6a 7f                	push   $0x7f
  jmp __alltraps
  102598:	e9 00 06 00 00       	jmp    102b9d <__alltraps>

0010259d <vector128>:
.globl vector128
vector128:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $128
  10259f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1025a4:	e9 f4 05 00 00       	jmp    102b9d <__alltraps>

001025a9 <vector129>:
.globl vector129
vector129:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $129
  1025ab:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1025b0:	e9 e8 05 00 00       	jmp    102b9d <__alltraps>

001025b5 <vector130>:
.globl vector130
vector130:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $130
  1025b7:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1025bc:	e9 dc 05 00 00       	jmp    102b9d <__alltraps>

001025c1 <vector131>:
.globl vector131
vector131:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $131
  1025c3:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1025c8:	e9 d0 05 00 00       	jmp    102b9d <__alltraps>

001025cd <vector132>:
.globl vector132
vector132:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $132
  1025cf:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1025d4:	e9 c4 05 00 00       	jmp    102b9d <__alltraps>

001025d9 <vector133>:
.globl vector133
vector133:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $133
  1025db:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1025e0:	e9 b8 05 00 00       	jmp    102b9d <__alltraps>

001025e5 <vector134>:
.globl vector134
vector134:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $134
  1025e7:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1025ec:	e9 ac 05 00 00       	jmp    102b9d <__alltraps>

001025f1 <vector135>:
.globl vector135
vector135:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $135
  1025f3:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1025f8:	e9 a0 05 00 00       	jmp    102b9d <__alltraps>

001025fd <vector136>:
.globl vector136
vector136:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $136
  1025ff:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102604:	e9 94 05 00 00       	jmp    102b9d <__alltraps>

00102609 <vector137>:
.globl vector137
vector137:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $137
  10260b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102610:	e9 88 05 00 00       	jmp    102b9d <__alltraps>

00102615 <vector138>:
.globl vector138
vector138:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $138
  102617:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10261c:	e9 7c 05 00 00       	jmp    102b9d <__alltraps>

00102621 <vector139>:
.globl vector139
vector139:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $139
  102623:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102628:	e9 70 05 00 00       	jmp    102b9d <__alltraps>

0010262d <vector140>:
.globl vector140
vector140:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $140
  10262f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102634:	e9 64 05 00 00       	jmp    102b9d <__alltraps>

00102639 <vector141>:
.globl vector141
vector141:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $141
  10263b:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102640:	e9 58 05 00 00       	jmp    102b9d <__alltraps>

00102645 <vector142>:
.globl vector142
vector142:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $142
  102647:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10264c:	e9 4c 05 00 00       	jmp    102b9d <__alltraps>

00102651 <vector143>:
.globl vector143
vector143:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $143
  102653:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102658:	e9 40 05 00 00       	jmp    102b9d <__alltraps>

0010265d <vector144>:
.globl vector144
vector144:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $144
  10265f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102664:	e9 34 05 00 00       	jmp    102b9d <__alltraps>

00102669 <vector145>:
.globl vector145
vector145:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $145
  10266b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102670:	e9 28 05 00 00       	jmp    102b9d <__alltraps>

00102675 <vector146>:
.globl vector146
vector146:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $146
  102677:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10267c:	e9 1c 05 00 00       	jmp    102b9d <__alltraps>

00102681 <vector147>:
.globl vector147
vector147:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $147
  102683:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102688:	e9 10 05 00 00       	jmp    102b9d <__alltraps>

0010268d <vector148>:
.globl vector148
vector148:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $148
  10268f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102694:	e9 04 05 00 00       	jmp    102b9d <__alltraps>

00102699 <vector149>:
.globl vector149
vector149:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $149
  10269b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1026a0:	e9 f8 04 00 00       	jmp    102b9d <__alltraps>

001026a5 <vector150>:
.globl vector150
vector150:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $150
  1026a7:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1026ac:	e9 ec 04 00 00       	jmp    102b9d <__alltraps>

001026b1 <vector151>:
.globl vector151
vector151:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $151
  1026b3:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1026b8:	e9 e0 04 00 00       	jmp    102b9d <__alltraps>

001026bd <vector152>:
.globl vector152
vector152:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $152
  1026bf:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1026c4:	e9 d4 04 00 00       	jmp    102b9d <__alltraps>

001026c9 <vector153>:
.globl vector153
vector153:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $153
  1026cb:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1026d0:	e9 c8 04 00 00       	jmp    102b9d <__alltraps>

001026d5 <vector154>:
.globl vector154
vector154:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $154
  1026d7:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1026dc:	e9 bc 04 00 00       	jmp    102b9d <__alltraps>

001026e1 <vector155>:
.globl vector155
vector155:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $155
  1026e3:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1026e8:	e9 b0 04 00 00       	jmp    102b9d <__alltraps>

001026ed <vector156>:
.globl vector156
vector156:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $156
  1026ef:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1026f4:	e9 a4 04 00 00       	jmp    102b9d <__alltraps>

001026f9 <vector157>:
.globl vector157
vector157:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $157
  1026fb:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102700:	e9 98 04 00 00       	jmp    102b9d <__alltraps>

00102705 <vector158>:
.globl vector158
vector158:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $158
  102707:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10270c:	e9 8c 04 00 00       	jmp    102b9d <__alltraps>

00102711 <vector159>:
.globl vector159
vector159:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $159
  102713:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102718:	e9 80 04 00 00       	jmp    102b9d <__alltraps>

0010271d <vector160>:
.globl vector160
vector160:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $160
  10271f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102724:	e9 74 04 00 00       	jmp    102b9d <__alltraps>

00102729 <vector161>:
.globl vector161
vector161:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $161
  10272b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102730:	e9 68 04 00 00       	jmp    102b9d <__alltraps>

00102735 <vector162>:
.globl vector162
vector162:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $162
  102737:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10273c:	e9 5c 04 00 00       	jmp    102b9d <__alltraps>

00102741 <vector163>:
.globl vector163
vector163:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $163
  102743:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102748:	e9 50 04 00 00       	jmp    102b9d <__alltraps>

0010274d <vector164>:
.globl vector164
vector164:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $164
  10274f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102754:	e9 44 04 00 00       	jmp    102b9d <__alltraps>

00102759 <vector165>:
.globl vector165
vector165:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $165
  10275b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102760:	e9 38 04 00 00       	jmp    102b9d <__alltraps>

00102765 <vector166>:
.globl vector166
vector166:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $166
  102767:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10276c:	e9 2c 04 00 00       	jmp    102b9d <__alltraps>

00102771 <vector167>:
.globl vector167
vector167:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $167
  102773:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102778:	e9 20 04 00 00       	jmp    102b9d <__alltraps>

0010277d <vector168>:
.globl vector168
vector168:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $168
  10277f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102784:	e9 14 04 00 00       	jmp    102b9d <__alltraps>

00102789 <vector169>:
.globl vector169
vector169:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $169
  10278b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102790:	e9 08 04 00 00       	jmp    102b9d <__alltraps>

00102795 <vector170>:
.globl vector170
vector170:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $170
  102797:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10279c:	e9 fc 03 00 00       	jmp    102b9d <__alltraps>

001027a1 <vector171>:
.globl vector171
vector171:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $171
  1027a3:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1027a8:	e9 f0 03 00 00       	jmp    102b9d <__alltraps>

001027ad <vector172>:
.globl vector172
vector172:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $172
  1027af:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1027b4:	e9 e4 03 00 00       	jmp    102b9d <__alltraps>

001027b9 <vector173>:
.globl vector173
vector173:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $173
  1027bb:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1027c0:	e9 d8 03 00 00       	jmp    102b9d <__alltraps>

001027c5 <vector174>:
.globl vector174
vector174:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $174
  1027c7:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1027cc:	e9 cc 03 00 00       	jmp    102b9d <__alltraps>

001027d1 <vector175>:
.globl vector175
vector175:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $175
  1027d3:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1027d8:	e9 c0 03 00 00       	jmp    102b9d <__alltraps>

001027dd <vector176>:
.globl vector176
vector176:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $176
  1027df:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1027e4:	e9 b4 03 00 00       	jmp    102b9d <__alltraps>

001027e9 <vector177>:
.globl vector177
vector177:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $177
  1027eb:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1027f0:	e9 a8 03 00 00       	jmp    102b9d <__alltraps>

001027f5 <vector178>:
.globl vector178
vector178:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $178
  1027f7:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1027fc:	e9 9c 03 00 00       	jmp    102b9d <__alltraps>

00102801 <vector179>:
.globl vector179
vector179:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $179
  102803:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102808:	e9 90 03 00 00       	jmp    102b9d <__alltraps>

0010280d <vector180>:
.globl vector180
vector180:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $180
  10280f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102814:	e9 84 03 00 00       	jmp    102b9d <__alltraps>

00102819 <vector181>:
.globl vector181
vector181:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $181
  10281b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102820:	e9 78 03 00 00       	jmp    102b9d <__alltraps>

00102825 <vector182>:
.globl vector182
vector182:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $182
  102827:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10282c:	e9 6c 03 00 00       	jmp    102b9d <__alltraps>

00102831 <vector183>:
.globl vector183
vector183:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $183
  102833:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102838:	e9 60 03 00 00       	jmp    102b9d <__alltraps>

0010283d <vector184>:
.globl vector184
vector184:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $184
  10283f:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102844:	e9 54 03 00 00       	jmp    102b9d <__alltraps>

00102849 <vector185>:
.globl vector185
vector185:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $185
  10284b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102850:	e9 48 03 00 00       	jmp    102b9d <__alltraps>

00102855 <vector186>:
.globl vector186
vector186:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $186
  102857:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10285c:	e9 3c 03 00 00       	jmp    102b9d <__alltraps>

00102861 <vector187>:
.globl vector187
vector187:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $187
  102863:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102868:	e9 30 03 00 00       	jmp    102b9d <__alltraps>

0010286d <vector188>:
.globl vector188
vector188:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $188
  10286f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102874:	e9 24 03 00 00       	jmp    102b9d <__alltraps>

00102879 <vector189>:
.globl vector189
vector189:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $189
  10287b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102880:	e9 18 03 00 00       	jmp    102b9d <__alltraps>

00102885 <vector190>:
.globl vector190
vector190:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $190
  102887:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10288c:	e9 0c 03 00 00       	jmp    102b9d <__alltraps>

00102891 <vector191>:
.globl vector191
vector191:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $191
  102893:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102898:	e9 00 03 00 00       	jmp    102b9d <__alltraps>

0010289d <vector192>:
.globl vector192
vector192:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $192
  10289f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1028a4:	e9 f4 02 00 00       	jmp    102b9d <__alltraps>

001028a9 <vector193>:
.globl vector193
vector193:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $193
  1028ab:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1028b0:	e9 e8 02 00 00       	jmp    102b9d <__alltraps>

001028b5 <vector194>:
.globl vector194
vector194:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $194
  1028b7:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1028bc:	e9 dc 02 00 00       	jmp    102b9d <__alltraps>

001028c1 <vector195>:
.globl vector195
vector195:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $195
  1028c3:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1028c8:	e9 d0 02 00 00       	jmp    102b9d <__alltraps>

001028cd <vector196>:
.globl vector196
vector196:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $196
  1028cf:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1028d4:	e9 c4 02 00 00       	jmp    102b9d <__alltraps>

001028d9 <vector197>:
.globl vector197
vector197:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $197
  1028db:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1028e0:	e9 b8 02 00 00       	jmp    102b9d <__alltraps>

001028e5 <vector198>:
.globl vector198
vector198:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $198
  1028e7:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1028ec:	e9 ac 02 00 00       	jmp    102b9d <__alltraps>

001028f1 <vector199>:
.globl vector199
vector199:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $199
  1028f3:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1028f8:	e9 a0 02 00 00       	jmp    102b9d <__alltraps>

001028fd <vector200>:
.globl vector200
vector200:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $200
  1028ff:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102904:	e9 94 02 00 00       	jmp    102b9d <__alltraps>

00102909 <vector201>:
.globl vector201
vector201:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $201
  10290b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102910:	e9 88 02 00 00       	jmp    102b9d <__alltraps>

00102915 <vector202>:
.globl vector202
vector202:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $202
  102917:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10291c:	e9 7c 02 00 00       	jmp    102b9d <__alltraps>

00102921 <vector203>:
.globl vector203
vector203:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $203
  102923:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102928:	e9 70 02 00 00       	jmp    102b9d <__alltraps>

0010292d <vector204>:
.globl vector204
vector204:
  pushl $0
  10292d:	6a 00                	push   $0x0
  pushl $204
  10292f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102934:	e9 64 02 00 00       	jmp    102b9d <__alltraps>

00102939 <vector205>:
.globl vector205
vector205:
  pushl $0
  102939:	6a 00                	push   $0x0
  pushl $205
  10293b:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102940:	e9 58 02 00 00       	jmp    102b9d <__alltraps>

00102945 <vector206>:
.globl vector206
vector206:
  pushl $0
  102945:	6a 00                	push   $0x0
  pushl $206
  102947:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10294c:	e9 4c 02 00 00       	jmp    102b9d <__alltraps>

00102951 <vector207>:
.globl vector207
vector207:
  pushl $0
  102951:	6a 00                	push   $0x0
  pushl $207
  102953:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102958:	e9 40 02 00 00       	jmp    102b9d <__alltraps>

0010295d <vector208>:
.globl vector208
vector208:
  pushl $0
  10295d:	6a 00                	push   $0x0
  pushl $208
  10295f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102964:	e9 34 02 00 00       	jmp    102b9d <__alltraps>

00102969 <vector209>:
.globl vector209
vector209:
  pushl $0
  102969:	6a 00                	push   $0x0
  pushl $209
  10296b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102970:	e9 28 02 00 00       	jmp    102b9d <__alltraps>

00102975 <vector210>:
.globl vector210
vector210:
  pushl $0
  102975:	6a 00                	push   $0x0
  pushl $210
  102977:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10297c:	e9 1c 02 00 00       	jmp    102b9d <__alltraps>

00102981 <vector211>:
.globl vector211
vector211:
  pushl $0
  102981:	6a 00                	push   $0x0
  pushl $211
  102983:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102988:	e9 10 02 00 00       	jmp    102b9d <__alltraps>

0010298d <vector212>:
.globl vector212
vector212:
  pushl $0
  10298d:	6a 00                	push   $0x0
  pushl $212
  10298f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102994:	e9 04 02 00 00       	jmp    102b9d <__alltraps>

00102999 <vector213>:
.globl vector213
vector213:
  pushl $0
  102999:	6a 00                	push   $0x0
  pushl $213
  10299b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1029a0:	e9 f8 01 00 00       	jmp    102b9d <__alltraps>

001029a5 <vector214>:
.globl vector214
vector214:
  pushl $0
  1029a5:	6a 00                	push   $0x0
  pushl $214
  1029a7:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1029ac:	e9 ec 01 00 00       	jmp    102b9d <__alltraps>

001029b1 <vector215>:
.globl vector215
vector215:
  pushl $0
  1029b1:	6a 00                	push   $0x0
  pushl $215
  1029b3:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1029b8:	e9 e0 01 00 00       	jmp    102b9d <__alltraps>

001029bd <vector216>:
.globl vector216
vector216:
  pushl $0
  1029bd:	6a 00                	push   $0x0
  pushl $216
  1029bf:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1029c4:	e9 d4 01 00 00       	jmp    102b9d <__alltraps>

001029c9 <vector217>:
.globl vector217
vector217:
  pushl $0
  1029c9:	6a 00                	push   $0x0
  pushl $217
  1029cb:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1029d0:	e9 c8 01 00 00       	jmp    102b9d <__alltraps>

001029d5 <vector218>:
.globl vector218
vector218:
  pushl $0
  1029d5:	6a 00                	push   $0x0
  pushl $218
  1029d7:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1029dc:	e9 bc 01 00 00       	jmp    102b9d <__alltraps>

001029e1 <vector219>:
.globl vector219
vector219:
  pushl $0
  1029e1:	6a 00                	push   $0x0
  pushl $219
  1029e3:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1029e8:	e9 b0 01 00 00       	jmp    102b9d <__alltraps>

001029ed <vector220>:
.globl vector220
vector220:
  pushl $0
  1029ed:	6a 00                	push   $0x0
  pushl $220
  1029ef:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1029f4:	e9 a4 01 00 00       	jmp    102b9d <__alltraps>

001029f9 <vector221>:
.globl vector221
vector221:
  pushl $0
  1029f9:	6a 00                	push   $0x0
  pushl $221
  1029fb:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102a00:	e9 98 01 00 00       	jmp    102b9d <__alltraps>

00102a05 <vector222>:
.globl vector222
vector222:
  pushl $0
  102a05:	6a 00                	push   $0x0
  pushl $222
  102a07:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102a0c:	e9 8c 01 00 00       	jmp    102b9d <__alltraps>

00102a11 <vector223>:
.globl vector223
vector223:
  pushl $0
  102a11:	6a 00                	push   $0x0
  pushl $223
  102a13:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102a18:	e9 80 01 00 00       	jmp    102b9d <__alltraps>

00102a1d <vector224>:
.globl vector224
vector224:
  pushl $0
  102a1d:	6a 00                	push   $0x0
  pushl $224
  102a1f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102a24:	e9 74 01 00 00       	jmp    102b9d <__alltraps>

00102a29 <vector225>:
.globl vector225
vector225:
  pushl $0
  102a29:	6a 00                	push   $0x0
  pushl $225
  102a2b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102a30:	e9 68 01 00 00       	jmp    102b9d <__alltraps>

00102a35 <vector226>:
.globl vector226
vector226:
  pushl $0
  102a35:	6a 00                	push   $0x0
  pushl $226
  102a37:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102a3c:	e9 5c 01 00 00       	jmp    102b9d <__alltraps>

00102a41 <vector227>:
.globl vector227
vector227:
  pushl $0
  102a41:	6a 00                	push   $0x0
  pushl $227
  102a43:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102a48:	e9 50 01 00 00       	jmp    102b9d <__alltraps>

00102a4d <vector228>:
.globl vector228
vector228:
  pushl $0
  102a4d:	6a 00                	push   $0x0
  pushl $228
  102a4f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102a54:	e9 44 01 00 00       	jmp    102b9d <__alltraps>

00102a59 <vector229>:
.globl vector229
vector229:
  pushl $0
  102a59:	6a 00                	push   $0x0
  pushl $229
  102a5b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102a60:	e9 38 01 00 00       	jmp    102b9d <__alltraps>

00102a65 <vector230>:
.globl vector230
vector230:
  pushl $0
  102a65:	6a 00                	push   $0x0
  pushl $230
  102a67:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102a6c:	e9 2c 01 00 00       	jmp    102b9d <__alltraps>

00102a71 <vector231>:
.globl vector231
vector231:
  pushl $0
  102a71:	6a 00                	push   $0x0
  pushl $231
  102a73:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102a78:	e9 20 01 00 00       	jmp    102b9d <__alltraps>

00102a7d <vector232>:
.globl vector232
vector232:
  pushl $0
  102a7d:	6a 00                	push   $0x0
  pushl $232
  102a7f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102a84:	e9 14 01 00 00       	jmp    102b9d <__alltraps>

00102a89 <vector233>:
.globl vector233
vector233:
  pushl $0
  102a89:	6a 00                	push   $0x0
  pushl $233
  102a8b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102a90:	e9 08 01 00 00       	jmp    102b9d <__alltraps>

00102a95 <vector234>:
.globl vector234
vector234:
  pushl $0
  102a95:	6a 00                	push   $0x0
  pushl $234
  102a97:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102a9c:	e9 fc 00 00 00       	jmp    102b9d <__alltraps>

00102aa1 <vector235>:
.globl vector235
vector235:
  pushl $0
  102aa1:	6a 00                	push   $0x0
  pushl $235
  102aa3:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102aa8:	e9 f0 00 00 00       	jmp    102b9d <__alltraps>

00102aad <vector236>:
.globl vector236
vector236:
  pushl $0
  102aad:	6a 00                	push   $0x0
  pushl $236
  102aaf:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102ab4:	e9 e4 00 00 00       	jmp    102b9d <__alltraps>

00102ab9 <vector237>:
.globl vector237
vector237:
  pushl $0
  102ab9:	6a 00                	push   $0x0
  pushl $237
  102abb:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102ac0:	e9 d8 00 00 00       	jmp    102b9d <__alltraps>

00102ac5 <vector238>:
.globl vector238
vector238:
  pushl $0
  102ac5:	6a 00                	push   $0x0
  pushl $238
  102ac7:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102acc:	e9 cc 00 00 00       	jmp    102b9d <__alltraps>

00102ad1 <vector239>:
.globl vector239
vector239:
  pushl $0
  102ad1:	6a 00                	push   $0x0
  pushl $239
  102ad3:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102ad8:	e9 c0 00 00 00       	jmp    102b9d <__alltraps>

00102add <vector240>:
.globl vector240
vector240:
  pushl $0
  102add:	6a 00                	push   $0x0
  pushl $240
  102adf:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102ae4:	e9 b4 00 00 00       	jmp    102b9d <__alltraps>

00102ae9 <vector241>:
.globl vector241
vector241:
  pushl $0
  102ae9:	6a 00                	push   $0x0
  pushl $241
  102aeb:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102af0:	e9 a8 00 00 00       	jmp    102b9d <__alltraps>

00102af5 <vector242>:
.globl vector242
vector242:
  pushl $0
  102af5:	6a 00                	push   $0x0
  pushl $242
  102af7:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102afc:	e9 9c 00 00 00       	jmp    102b9d <__alltraps>

00102b01 <vector243>:
.globl vector243
vector243:
  pushl $0
  102b01:	6a 00                	push   $0x0
  pushl $243
  102b03:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102b08:	e9 90 00 00 00       	jmp    102b9d <__alltraps>

00102b0d <vector244>:
.globl vector244
vector244:
  pushl $0
  102b0d:	6a 00                	push   $0x0
  pushl $244
  102b0f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102b14:	e9 84 00 00 00       	jmp    102b9d <__alltraps>

00102b19 <vector245>:
.globl vector245
vector245:
  pushl $0
  102b19:	6a 00                	push   $0x0
  pushl $245
  102b1b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102b20:	e9 78 00 00 00       	jmp    102b9d <__alltraps>

00102b25 <vector246>:
.globl vector246
vector246:
  pushl $0
  102b25:	6a 00                	push   $0x0
  pushl $246
  102b27:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102b2c:	e9 6c 00 00 00       	jmp    102b9d <__alltraps>

00102b31 <vector247>:
.globl vector247
vector247:
  pushl $0
  102b31:	6a 00                	push   $0x0
  pushl $247
  102b33:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102b38:	e9 60 00 00 00       	jmp    102b9d <__alltraps>

00102b3d <vector248>:
.globl vector248
vector248:
  pushl $0
  102b3d:	6a 00                	push   $0x0
  pushl $248
  102b3f:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102b44:	e9 54 00 00 00       	jmp    102b9d <__alltraps>

00102b49 <vector249>:
.globl vector249
vector249:
  pushl $0
  102b49:	6a 00                	push   $0x0
  pushl $249
  102b4b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102b50:	e9 48 00 00 00       	jmp    102b9d <__alltraps>

00102b55 <vector250>:
.globl vector250
vector250:
  pushl $0
  102b55:	6a 00                	push   $0x0
  pushl $250
  102b57:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102b5c:	e9 3c 00 00 00       	jmp    102b9d <__alltraps>

00102b61 <vector251>:
.globl vector251
vector251:
  pushl $0
  102b61:	6a 00                	push   $0x0
  pushl $251
  102b63:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102b68:	e9 30 00 00 00       	jmp    102b9d <__alltraps>

00102b6d <vector252>:
.globl vector252
vector252:
  pushl $0
  102b6d:	6a 00                	push   $0x0
  pushl $252
  102b6f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102b74:	e9 24 00 00 00       	jmp    102b9d <__alltraps>

00102b79 <vector253>:
.globl vector253
vector253:
  pushl $0
  102b79:	6a 00                	push   $0x0
  pushl $253
  102b7b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102b80:	e9 18 00 00 00       	jmp    102b9d <__alltraps>

00102b85 <vector254>:
.globl vector254
vector254:
  pushl $0
  102b85:	6a 00                	push   $0x0
  pushl $254
  102b87:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102b8c:	e9 0c 00 00 00       	jmp    102b9d <__alltraps>

00102b91 <vector255>:
.globl vector255
vector255:
  pushl $0
  102b91:	6a 00                	push   $0x0
  pushl $255
  102b93:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102b98:	e9 00 00 00 00       	jmp    102b9d <__alltraps>

00102b9d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102b9d:	1e                   	push   %ds
    pushl %es
  102b9e:	06                   	push   %es
    pushl %fs
  102b9f:	0f a0                	push   %fs
    pushl %gs
  102ba1:	0f a8                	push   %gs
    pushal
  102ba3:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102ba4:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102ba9:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102bab:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102bad:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102bae:	e8 64 f5 ff ff       	call   102117 <trap>

    # pop the pushed stack pointer
    popl %esp
  102bb3:	5c                   	pop    %esp

00102bb4 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102bb4:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102bb5:	0f a9                	pop    %gs
    popl %fs
  102bb7:	0f a1                	pop    %fs
    popl %es
  102bb9:	07                   	pop    %es
    popl %ds
  102bba:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102bbb:	83 c4 08             	add    $0x8,%esp
    iret
  102bbe:	cf                   	iret   

00102bbf <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102bbf:	55                   	push   %ebp
  102bc0:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc5:	8b 15 78 af 11 00    	mov    0x11af78,%edx
  102bcb:	29 d0                	sub    %edx,%eax
  102bcd:	c1 f8 02             	sar    $0x2,%eax
  102bd0:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102bd6:	5d                   	pop    %ebp
  102bd7:	c3                   	ret    

00102bd8 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102bd8:	55                   	push   %ebp
  102bd9:	89 e5                	mov    %esp,%ebp
  102bdb:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102bde:	8b 45 08             	mov    0x8(%ebp),%eax
  102be1:	89 04 24             	mov    %eax,(%esp)
  102be4:	e8 d6 ff ff ff       	call   102bbf <page2ppn>
  102be9:	c1 e0 0c             	shl    $0xc,%eax
}
  102bec:	c9                   	leave  
  102bed:	c3                   	ret    

00102bee <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102bee:	55                   	push   %ebp
  102bef:	89 e5                	mov    %esp,%ebp
  102bf1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf7:	c1 e8 0c             	shr    $0xc,%eax
  102bfa:	89 c2                	mov    %eax,%edx
  102bfc:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102c01:	39 c2                	cmp    %eax,%edx
  102c03:	72 1c                	jb     102c21 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102c05:	c7 44 24 08 50 62 10 	movl   $0x106250,0x8(%esp)
  102c0c:	00 
  102c0d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  102c14:	00 
  102c15:	c7 04 24 6f 62 10 00 	movl   $0x10626f,(%esp)
  102c1c:	e8 d8 d7 ff ff       	call   1003f9 <__panic>
    }
    return &pages[PPN(pa)];
  102c21:	8b 0d 78 af 11 00    	mov    0x11af78,%ecx
  102c27:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2a:	c1 e8 0c             	shr    $0xc,%eax
  102c2d:	89 c2                	mov    %eax,%edx
  102c2f:	89 d0                	mov    %edx,%eax
  102c31:	c1 e0 02             	shl    $0x2,%eax
  102c34:	01 d0                	add    %edx,%eax
  102c36:	c1 e0 02             	shl    $0x2,%eax
  102c39:	01 c8                	add    %ecx,%eax
}
  102c3b:	c9                   	leave  
  102c3c:	c3                   	ret    

00102c3d <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102c3d:	55                   	push   %ebp
  102c3e:	89 e5                	mov    %esp,%ebp
  102c40:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102c43:	8b 45 08             	mov    0x8(%ebp),%eax
  102c46:	89 04 24             	mov    %eax,(%esp)
  102c49:	e8 8a ff ff ff       	call   102bd8 <page2pa>
  102c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c54:	c1 e8 0c             	shr    $0xc,%eax
  102c57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c5a:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102c5f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102c62:	72 23                	jb     102c87 <page2kva+0x4a>
  102c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c6b:	c7 44 24 08 80 62 10 	movl   $0x106280,0x8(%esp)
  102c72:	00 
  102c73:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  102c7a:	00 
  102c7b:	c7 04 24 6f 62 10 00 	movl   $0x10626f,(%esp)
  102c82:	e8 72 d7 ff ff       	call   1003f9 <__panic>
  102c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c8a:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102c8f:	c9                   	leave  
  102c90:	c3                   	ret    

00102c91 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102c91:	55                   	push   %ebp
  102c92:	89 e5                	mov    %esp,%ebp
  102c94:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102c97:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9a:	83 e0 01             	and    $0x1,%eax
  102c9d:	85 c0                	test   %eax,%eax
  102c9f:	75 1c                	jne    102cbd <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102ca1:	c7 44 24 08 a4 62 10 	movl   $0x1062a4,0x8(%esp)
  102ca8:	00 
  102ca9:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102cb0:	00 
  102cb1:	c7 04 24 6f 62 10 00 	movl   $0x10626f,(%esp)
  102cb8:	e8 3c d7 ff ff       	call   1003f9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102cc5:	89 04 24             	mov    %eax,(%esp)
  102cc8:	e8 21 ff ff ff       	call   102bee <pa2page>
}
  102ccd:	c9                   	leave  
  102cce:	c3                   	ret    

00102ccf <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102ccf:	55                   	push   %ebp
  102cd0:	89 e5                	mov    %esp,%ebp
  102cd2:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102cdd:	89 04 24             	mov    %eax,(%esp)
  102ce0:	e8 09 ff ff ff       	call   102bee <pa2page>
}
  102ce5:	c9                   	leave  
  102ce6:	c3                   	ret    

00102ce7 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102ce7:	55                   	push   %ebp
  102ce8:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102cea:	8b 45 08             	mov    0x8(%ebp),%eax
  102ced:	8b 00                	mov    (%eax),%eax
}
  102cef:	5d                   	pop    %ebp
  102cf0:	c3                   	ret    

00102cf1 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102cf1:	55                   	push   %ebp
  102cf2:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cfa:	89 10                	mov    %edx,(%eax)
}
  102cfc:	90                   	nop
  102cfd:	5d                   	pop    %ebp
  102cfe:	c3                   	ret    

00102cff <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102cff:	55                   	push   %ebp
  102d00:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102d02:	8b 45 08             	mov    0x8(%ebp),%eax
  102d05:	8b 00                	mov    (%eax),%eax
  102d07:	8d 50 01             	lea    0x1(%eax),%edx
  102d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d12:	8b 00                	mov    (%eax),%eax
}
  102d14:	5d                   	pop    %ebp
  102d15:	c3                   	ret    

00102d16 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102d16:	55                   	push   %ebp
  102d17:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102d19:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1c:	8b 00                	mov    (%eax),%eax
  102d1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d21:	8b 45 08             	mov    0x8(%ebp),%eax
  102d24:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102d26:	8b 45 08             	mov    0x8(%ebp),%eax
  102d29:	8b 00                	mov    (%eax),%eax
}
  102d2b:	5d                   	pop    %ebp
  102d2c:	c3                   	ret    

00102d2d <__intr_save>:
__intr_save(void) {
  102d2d:	55                   	push   %ebp
  102d2e:	89 e5                	mov    %esp,%ebp
  102d30:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102d33:	9c                   	pushf  
  102d34:	58                   	pop    %eax
  102d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102d3b:	25 00 02 00 00       	and    $0x200,%eax
  102d40:	85 c0                	test   %eax,%eax
  102d42:	74 0c                	je     102d50 <__intr_save+0x23>
        intr_disable();
  102d44:	e8 60 eb ff ff       	call   1018a9 <intr_disable>
        return 1;
  102d49:	b8 01 00 00 00       	mov    $0x1,%eax
  102d4e:	eb 05                	jmp    102d55 <__intr_save+0x28>
    return 0;
  102d50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d55:	c9                   	leave  
  102d56:	c3                   	ret    

00102d57 <__intr_restore>:
__intr_restore(bool flag) {
  102d57:	55                   	push   %ebp
  102d58:	89 e5                	mov    %esp,%ebp
  102d5a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102d5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102d61:	74 05                	je     102d68 <__intr_restore+0x11>
        intr_enable();
  102d63:	e8 3a eb ff ff       	call   1018a2 <intr_enable>
}
  102d68:	90                   	nop
  102d69:	c9                   	leave  
  102d6a:	c3                   	ret    

00102d6b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102d6b:	55                   	push   %ebp
  102d6c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d71:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102d74:	b8 23 00 00 00       	mov    $0x23,%eax
  102d79:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102d7b:	b8 23 00 00 00       	mov    $0x23,%eax
  102d80:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102d82:	b8 10 00 00 00       	mov    $0x10,%eax
  102d87:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102d89:	b8 10 00 00 00       	mov    $0x10,%eax
  102d8e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102d90:	b8 10 00 00 00       	mov    $0x10,%eax
  102d95:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102d97:	ea 9e 2d 10 00 08 00 	ljmp   $0x8,$0x102d9e
}
  102d9e:	90                   	nop
  102d9f:	5d                   	pop    %ebp
  102da0:	c3                   	ret    

00102da1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102da1:	55                   	push   %ebp
  102da2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102da4:	8b 45 08             	mov    0x8(%ebp),%eax
  102da7:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  102dac:	90                   	nop
  102dad:	5d                   	pop    %ebp
  102dae:	c3                   	ret    

00102daf <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102daf:	55                   	push   %ebp
  102db0:	89 e5                	mov    %esp,%ebp
  102db2:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102db5:	b8 00 70 11 00       	mov    $0x117000,%eax
  102dba:	89 04 24             	mov    %eax,(%esp)
  102dbd:	e8 df ff ff ff       	call   102da1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102dc2:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  102dc9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102dcb:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102dd2:	68 00 
  102dd4:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102dd9:	0f b7 c0             	movzwl %ax,%eax
  102ddc:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102de2:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102de7:	c1 e8 10             	shr    $0x10,%eax
  102dea:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102def:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102df6:	24 f0                	and    $0xf0,%al
  102df8:	0c 09                	or     $0x9,%al
  102dfa:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102dff:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102e06:	24 ef                	and    $0xef,%al
  102e08:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102e0d:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102e14:	24 9f                	and    $0x9f,%al
  102e16:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102e1b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102e22:	0c 80                	or     $0x80,%al
  102e24:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102e29:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102e30:	24 f0                	and    $0xf0,%al
  102e32:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102e37:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102e3e:	24 ef                	and    $0xef,%al
  102e40:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102e45:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102e4c:	24 df                	and    $0xdf,%al
  102e4e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102e53:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102e5a:	0c 40                	or     $0x40,%al
  102e5c:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102e61:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102e68:	24 7f                	and    $0x7f,%al
  102e6a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102e6f:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102e74:	c1 e8 18             	shr    $0x18,%eax
  102e77:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102e7c:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  102e83:	e8 e3 fe ff ff       	call   102d6b <lgdt>
  102e88:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102e8e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102e92:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102e95:	90                   	nop
  102e96:	c9                   	leave  
  102e97:	c3                   	ret    

00102e98 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102e98:	55                   	push   %ebp
  102e99:	89 e5                	mov    %esp,%ebp
  102e9b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102e9e:	c7 05 70 af 11 00 60 	movl   $0x106a60,0x11af70
  102ea5:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102ea8:	a1 70 af 11 00       	mov    0x11af70,%eax
  102ead:	8b 00                	mov    (%eax),%eax
  102eaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eb3:	c7 04 24 d0 62 10 00 	movl   $0x1062d0,(%esp)
  102eba:	e8 e3 d3 ff ff       	call   1002a2 <cprintf>
    pmm_manager->init();
  102ebf:	a1 70 af 11 00       	mov    0x11af70,%eax
  102ec4:	8b 40 04             	mov    0x4(%eax),%eax
  102ec7:	ff d0                	call   *%eax
}
  102ec9:	90                   	nop
  102eca:	c9                   	leave  
  102ecb:	c3                   	ret    

00102ecc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102ecc:	55                   	push   %ebp
  102ecd:	89 e5                	mov    %esp,%ebp
  102ecf:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102ed2:	a1 70 af 11 00       	mov    0x11af70,%eax
  102ed7:	8b 40 08             	mov    0x8(%eax),%eax
  102eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  102edd:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  102ee4:	89 14 24             	mov    %edx,(%esp)
  102ee7:	ff d0                	call   *%eax
}
  102ee9:	90                   	nop
  102eea:	c9                   	leave  
  102eeb:	c3                   	ret    

00102eec <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102eec:	55                   	push   %ebp
  102eed:	89 e5                	mov    %esp,%ebp
  102eef:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102ef2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102ef9:	e8 2f fe ff ff       	call   102d2d <__intr_save>
  102efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102f01:	a1 70 af 11 00       	mov    0x11af70,%eax
  102f06:	8b 40 0c             	mov    0xc(%eax),%eax
  102f09:	8b 55 08             	mov    0x8(%ebp),%edx
  102f0c:	89 14 24             	mov    %edx,(%esp)
  102f0f:	ff d0                	call   *%eax
  102f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f17:	89 04 24             	mov    %eax,(%esp)
  102f1a:	e8 38 fe ff ff       	call   102d57 <__intr_restore>
    return page;
  102f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f22:	c9                   	leave  
  102f23:	c3                   	ret    

00102f24 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102f24:	55                   	push   %ebp
  102f25:	89 e5                	mov    %esp,%ebp
  102f27:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102f2a:	e8 fe fd ff ff       	call   102d2d <__intr_save>
  102f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102f32:	a1 70 af 11 00       	mov    0x11af70,%eax
  102f37:	8b 40 10             	mov    0x10(%eax),%eax
  102f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f41:	8b 55 08             	mov    0x8(%ebp),%edx
  102f44:	89 14 24             	mov    %edx,(%esp)
  102f47:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f4c:	89 04 24             	mov    %eax,(%esp)
  102f4f:	e8 03 fe ff ff       	call   102d57 <__intr_restore>
}
  102f54:	90                   	nop
  102f55:	c9                   	leave  
  102f56:	c3                   	ret    

00102f57 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102f57:	55                   	push   %ebp
  102f58:	89 e5                	mov    %esp,%ebp
  102f5a:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102f5d:	e8 cb fd ff ff       	call   102d2d <__intr_save>
  102f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102f65:	a1 70 af 11 00       	mov    0x11af70,%eax
  102f6a:	8b 40 14             	mov    0x14(%eax),%eax
  102f6d:	ff d0                	call   *%eax
  102f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f75:	89 04 24             	mov    %eax,(%esp)
  102f78:	e8 da fd ff ff       	call   102d57 <__intr_restore>
    return ret;
  102f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102f80:	c9                   	leave  
  102f81:	c3                   	ret    

00102f82 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102f82:	55                   	push   %ebp
  102f83:	89 e5                	mov    %esp,%ebp
  102f85:	57                   	push   %edi
  102f86:	56                   	push   %esi
  102f87:	53                   	push   %ebx
  102f88:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102f8e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102f95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102f9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cprintf("e820map:\n");
  102fa3:	c7 04 24 e7 62 10 00 	movl   $0x1062e7,(%esp)
  102faa:	e8 f3 d2 ff ff       	call   1002a2 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102faf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fb6:	e9 22 01 00 00       	jmp    1030dd <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102fbb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fbe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fc1:	89 d0                	mov    %edx,%eax
  102fc3:	c1 e0 02             	shl    $0x2,%eax
  102fc6:	01 d0                	add    %edx,%eax
  102fc8:	c1 e0 02             	shl    $0x2,%eax
  102fcb:	01 c8                	add    %ecx,%eax
  102fcd:	8b 50 08             	mov    0x8(%eax),%edx
  102fd0:	8b 40 04             	mov    0x4(%eax),%eax
  102fd3:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102fd6:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102fd9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fdf:	89 d0                	mov    %edx,%eax
  102fe1:	c1 e0 02             	shl    $0x2,%eax
  102fe4:	01 d0                	add    %edx,%eax
  102fe6:	c1 e0 02             	shl    $0x2,%eax
  102fe9:	01 c8                	add    %ecx,%eax
  102feb:	8b 48 0c             	mov    0xc(%eax),%ecx
  102fee:	8b 58 10             	mov    0x10(%eax),%ebx
  102ff1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ff4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102ff7:	01 c8                	add    %ecx,%eax
  102ff9:	11 da                	adc    %ebx,%edx
  102ffb:	89 45 98             	mov    %eax,-0x68(%ebp)
  102ffe:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103001:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103004:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103007:	89 d0                	mov    %edx,%eax
  103009:	c1 e0 02             	shl    $0x2,%eax
  10300c:	01 d0                	add    %edx,%eax
  10300e:	c1 e0 02             	shl    $0x2,%eax
  103011:	01 c8                	add    %ecx,%eax
  103013:	83 c0 14             	add    $0x14,%eax
  103016:	8b 00                	mov    (%eax),%eax
  103018:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10301b:	8b 45 98             	mov    -0x68(%ebp),%eax
  10301e:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103021:	83 c0 ff             	add    $0xffffffff,%eax
  103024:	83 d2 ff             	adc    $0xffffffff,%edx
  103027:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  10302d:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  103033:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103036:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103039:	89 d0                	mov    %edx,%eax
  10303b:	c1 e0 02             	shl    $0x2,%eax
  10303e:	01 d0                	add    %edx,%eax
  103040:	c1 e0 02             	shl    $0x2,%eax
  103043:	01 c8                	add    %ecx,%eax
  103045:	8b 48 0c             	mov    0xc(%eax),%ecx
  103048:	8b 58 10             	mov    0x10(%eax),%ebx
  10304b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10304e:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  103052:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  103058:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  10305e:	89 44 24 14          	mov    %eax,0x14(%esp)
  103062:	89 54 24 18          	mov    %edx,0x18(%esp)
  103066:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103069:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10306c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103070:	89 54 24 10          	mov    %edx,0x10(%esp)
  103074:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103078:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  10307c:	c7 04 24 f4 62 10 00 	movl   $0x1062f4,(%esp)
  103083:	e8 1a d2 ff ff       	call   1002a2 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103088:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10308b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10308e:	89 d0                	mov    %edx,%eax
  103090:	c1 e0 02             	shl    $0x2,%eax
  103093:	01 d0                	add    %edx,%eax
  103095:	c1 e0 02             	shl    $0x2,%eax
  103098:	01 c8                	add    %ecx,%eax
  10309a:	83 c0 14             	add    $0x14,%eax
  10309d:	8b 00                	mov    (%eax),%eax
  10309f:	83 f8 01             	cmp    $0x1,%eax
  1030a2:	75 36                	jne    1030da <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
  1030a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1030aa:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  1030ad:	77 2b                	ja     1030da <page_init+0x158>
  1030af:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  1030b2:	72 05                	jb     1030b9 <page_init+0x137>
  1030b4:	3b 45 98             	cmp    -0x68(%ebp),%eax
  1030b7:	73 21                	jae    1030da <page_init+0x158>
  1030b9:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1030bd:	77 1b                	ja     1030da <page_init+0x158>
  1030bf:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1030c3:	72 09                	jb     1030ce <page_init+0x14c>
  1030c5:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
  1030cc:	77 0c                	ja     1030da <page_init+0x158>
                maxpa = end;
  1030ce:	8b 45 98             	mov    -0x68(%ebp),%eax
  1030d1:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1030d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1030d7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  1030da:	ff 45 dc             	incl   -0x24(%ebp)
  1030dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1030e0:	8b 00                	mov    (%eax),%eax
  1030e2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030e5:	0f 8c d0 fe ff ff    	jl     102fbb <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  1030eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1030ef:	72 1d                	jb     10310e <page_init+0x18c>
  1030f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1030f5:	77 09                	ja     103100 <page_init+0x17e>
  1030f7:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  1030fe:	76 0e                	jbe    10310e <page_init+0x18c>
        maxpa = KMEMSIZE;
  103100:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103107:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  10310e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103111:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103114:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103118:	c1 ea 0c             	shr    $0xc,%edx
  10311b:	89 c1                	mov    %eax,%ecx
  10311d:	89 d3                	mov    %edx,%ebx
  10311f:	89 c8                	mov    %ecx,%eax
  103121:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103126:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  10312d:	b8 94 af 25 00       	mov    $0x25af94,%eax
  103132:	8d 50 ff             	lea    -0x1(%eax),%edx
  103135:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103138:	01 d0                	add    %edx,%eax
  10313a:	89 45 bc             	mov    %eax,-0x44(%ebp)
  10313d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103140:	ba 00 00 00 00       	mov    $0x0,%edx
  103145:	f7 75 c0             	divl   -0x40(%ebp)
  103148:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10314b:	29 d0                	sub    %edx,%eax
  10314d:	a3 78 af 11 00       	mov    %eax,0x11af78
    for (i = 0; i < npage; i ++) {
  103152:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103159:	eb 2e                	jmp    103189 <page_init+0x207>
        SetPageReserved(pages + i);
  10315b:	8b 0d 78 af 11 00    	mov    0x11af78,%ecx
  103161:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103164:	89 d0                	mov    %edx,%eax
  103166:	c1 e0 02             	shl    $0x2,%eax
  103169:	01 d0                	add    %edx,%eax
  10316b:	c1 e0 02             	shl    $0x2,%eax
  10316e:	01 c8                	add    %ecx,%eax
  103170:	83 c0 04             	add    $0x4,%eax
  103173:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  10317a:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10317d:	8b 45 90             	mov    -0x70(%ebp),%eax
  103180:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103183:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  103186:	ff 45 dc             	incl   -0x24(%ebp)
  103189:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10318c:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103191:	39 c2                	cmp    %eax,%edx
  103193:	72 c6                	jb     10315b <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103195:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  10319b:	89 d0                	mov    %edx,%eax
  10319d:	c1 e0 02             	shl    $0x2,%eax
  1031a0:	01 d0                	add    %edx,%eax
  1031a2:	c1 e0 02             	shl    $0x2,%eax
  1031a5:	89 c2                	mov    %eax,%edx
  1031a7:	a1 78 af 11 00       	mov    0x11af78,%eax
  1031ac:	01 d0                	add    %edx,%eax
  1031ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1031b1:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  1031b8:	77 23                	ja     1031dd <page_init+0x25b>
  1031ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1031bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1031c1:	c7 44 24 08 24 63 10 	movl   $0x106324,0x8(%esp)
  1031c8:	00 
  1031c9:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  1031d0:	00 
  1031d1:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1031d8:	e8 1c d2 ff ff       	call   1003f9 <__panic>
  1031dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1031e0:	05 00 00 00 40       	add    $0x40000000,%eax
  1031e5:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  1031e8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1031ef:	e9 69 01 00 00       	jmp    10335d <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1031f4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031fa:	89 d0                	mov    %edx,%eax
  1031fc:	c1 e0 02             	shl    $0x2,%eax
  1031ff:	01 d0                	add    %edx,%eax
  103201:	c1 e0 02             	shl    $0x2,%eax
  103204:	01 c8                	add    %ecx,%eax
  103206:	8b 50 08             	mov    0x8(%eax),%edx
  103209:	8b 40 04             	mov    0x4(%eax),%eax
  10320c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10320f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103212:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103215:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103218:	89 d0                	mov    %edx,%eax
  10321a:	c1 e0 02             	shl    $0x2,%eax
  10321d:	01 d0                	add    %edx,%eax
  10321f:	c1 e0 02             	shl    $0x2,%eax
  103222:	01 c8                	add    %ecx,%eax
  103224:	8b 48 0c             	mov    0xc(%eax),%ecx
  103227:	8b 58 10             	mov    0x10(%eax),%ebx
  10322a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10322d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103230:	01 c8                	add    %ecx,%eax
  103232:	11 da                	adc    %ebx,%edx
  103234:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103237:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10323a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10323d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103240:	89 d0                	mov    %edx,%eax
  103242:	c1 e0 02             	shl    $0x2,%eax
  103245:	01 d0                	add    %edx,%eax
  103247:	c1 e0 02             	shl    $0x2,%eax
  10324a:	01 c8                	add    %ecx,%eax
  10324c:	83 c0 14             	add    $0x14,%eax
  10324f:	8b 00                	mov    (%eax),%eax
  103251:	83 f8 01             	cmp    $0x1,%eax
  103254:	0f 85 00 01 00 00    	jne    10335a <page_init+0x3d8>
            if (begin < freemem) {
  10325a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10325d:	ba 00 00 00 00       	mov    $0x0,%edx
  103262:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  103265:	77 17                	ja     10327e <page_init+0x2fc>
  103267:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10326a:	72 05                	jb     103271 <page_init+0x2ef>
  10326c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10326f:	73 0d                	jae    10327e <page_init+0x2fc>
                begin = freemem;
  103271:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103274:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103277:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10327e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103282:	72 1d                	jb     1032a1 <page_init+0x31f>
  103284:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103288:	77 09                	ja     103293 <page_init+0x311>
  10328a:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103291:	76 0e                	jbe    1032a1 <page_init+0x31f>
                end = KMEMSIZE;
  103293:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10329a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1032a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1032a7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1032aa:	0f 87 aa 00 00 00    	ja     10335a <page_init+0x3d8>
  1032b0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1032b3:	72 09                	jb     1032be <page_init+0x33c>
  1032b5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1032b8:	0f 83 9c 00 00 00    	jae    10335a <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
  1032be:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  1032c5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1032c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1032cb:	01 d0                	add    %edx,%eax
  1032cd:	48                   	dec    %eax
  1032ce:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1032d1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1032d4:	ba 00 00 00 00       	mov    $0x0,%edx
  1032d9:	f7 75 b0             	divl   -0x50(%ebp)
  1032dc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1032df:	29 d0                	sub    %edx,%eax
  1032e1:	ba 00 00 00 00       	mov    $0x0,%edx
  1032e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1032e9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1032ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1032ef:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1032f2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1032f5:	ba 00 00 00 00       	mov    $0x0,%edx
  1032fa:	89 c3                	mov    %eax,%ebx
  1032fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  103302:	89 de                	mov    %ebx,%esi
  103304:	89 d0                	mov    %edx,%eax
  103306:	83 e0 00             	and    $0x0,%eax
  103309:	89 c7                	mov    %eax,%edi
  10330b:	89 75 c8             	mov    %esi,-0x38(%ebp)
  10330e:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  103311:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103314:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103317:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10331a:	77 3e                	ja     10335a <page_init+0x3d8>
  10331c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10331f:	72 05                	jb     103326 <page_init+0x3a4>
  103321:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103324:	73 34                	jae    10335a <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  103326:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103329:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10332c:	2b 45 d0             	sub    -0x30(%ebp),%eax
  10332f:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  103332:	89 c1                	mov    %eax,%ecx
  103334:	89 d3                	mov    %edx,%ebx
  103336:	89 c8                	mov    %ecx,%eax
  103338:	89 da                	mov    %ebx,%edx
  10333a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10333e:	c1 ea 0c             	shr    $0xc,%edx
  103341:	89 c3                	mov    %eax,%ebx
  103343:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103346:	89 04 24             	mov    %eax,(%esp)
  103349:	e8 a0 f8 ff ff       	call   102bee <pa2page>
  10334e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103352:	89 04 24             	mov    %eax,(%esp)
  103355:	e8 72 fb ff ff       	call   102ecc <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10335a:	ff 45 dc             	incl   -0x24(%ebp)
  10335d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103360:	8b 00                	mov    (%eax),%eax
  103362:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103365:	0f 8c 89 fe ff ff    	jl     1031f4 <page_init+0x272>
                }
            }
        }
    }
}
  10336b:	90                   	nop
  10336c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103372:	5b                   	pop    %ebx
  103373:	5e                   	pop    %esi
  103374:	5f                   	pop    %edi
  103375:	5d                   	pop    %ebp
  103376:	c3                   	ret    

00103377 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103377:	55                   	push   %ebp
  103378:	89 e5                	mov    %esp,%ebp
  10337a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10337d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103380:	33 45 14             	xor    0x14(%ebp),%eax
  103383:	25 ff 0f 00 00       	and    $0xfff,%eax
  103388:	85 c0                	test   %eax,%eax
  10338a:	74 24                	je     1033b0 <boot_map_segment+0x39>
  10338c:	c7 44 24 0c 56 63 10 	movl   $0x106356,0xc(%esp)
  103393:	00 
  103394:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  10339b:	00 
  10339c:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1033a3:	00 
  1033a4:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1033ab:	e8 49 d0 ff ff       	call   1003f9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1033b0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1033b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ba:	25 ff 0f 00 00       	and    $0xfff,%eax
  1033bf:	89 c2                	mov    %eax,%edx
  1033c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1033c4:	01 c2                	add    %eax,%edx
  1033c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033c9:	01 d0                	add    %edx,%eax
  1033cb:	48                   	dec    %eax
  1033cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033d2:	ba 00 00 00 00       	mov    $0x0,%edx
  1033d7:	f7 75 f0             	divl   -0x10(%ebp)
  1033da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033dd:	29 d0                	sub    %edx,%eax
  1033df:	c1 e8 0c             	shr    $0xc,%eax
  1033e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1033e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1033f3:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1033f6:	8b 45 14             	mov    0x14(%ebp),%eax
  1033f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103404:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103407:	eb 68                	jmp    103471 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103409:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103410:	00 
  103411:	8b 45 0c             	mov    0xc(%ebp),%eax
  103414:	89 44 24 04          	mov    %eax,0x4(%esp)
  103418:	8b 45 08             	mov    0x8(%ebp),%eax
  10341b:	89 04 24             	mov    %eax,(%esp)
  10341e:	e8 81 01 00 00       	call   1035a4 <get_pte>
  103423:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103426:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10342a:	75 24                	jne    103450 <boot_map_segment+0xd9>
  10342c:	c7 44 24 0c 82 63 10 	movl   $0x106382,0xc(%esp)
  103433:	00 
  103434:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  10343b:	00 
  10343c:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103443:	00 
  103444:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  10344b:	e8 a9 cf ff ff       	call   1003f9 <__panic>
        *ptep = pa | PTE_P | perm;
  103450:	8b 45 14             	mov    0x14(%ebp),%eax
  103453:	0b 45 18             	or     0x18(%ebp),%eax
  103456:	83 c8 01             	or     $0x1,%eax
  103459:	89 c2                	mov    %eax,%edx
  10345b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10345e:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103460:	ff 4d f4             	decl   -0xc(%ebp)
  103463:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10346a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103475:	75 92                	jne    103409 <boot_map_segment+0x92>
    }
}
  103477:	90                   	nop
  103478:	c9                   	leave  
  103479:	c3                   	ret    

0010347a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10347a:	55                   	push   %ebp
  10347b:	89 e5                	mov    %esp,%ebp
  10347d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103480:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103487:	e8 60 fa ff ff       	call   102eec <alloc_pages>
  10348c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10348f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103493:	75 1c                	jne    1034b1 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  103495:	c7 44 24 08 8f 63 10 	movl   $0x10638f,0x8(%esp)
  10349c:	00 
  10349d:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1034a4:	00 
  1034a5:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1034ac:	e8 48 cf ff ff       	call   1003f9 <__panic>
    }
    return page2kva(p);
  1034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034b4:	89 04 24             	mov    %eax,(%esp)
  1034b7:	e8 81 f7 ff ff       	call   102c3d <page2kva>
}
  1034bc:	c9                   	leave  
  1034bd:	c3                   	ret    

001034be <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1034be:	55                   	push   %ebp
  1034bf:	89 e5                	mov    %esp,%ebp
  1034c1:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1034c4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1034c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1034cc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1034d3:	77 23                	ja     1034f8 <pmm_init+0x3a>
  1034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034dc:	c7 44 24 08 24 63 10 	movl   $0x106324,0x8(%esp)
  1034e3:	00 
  1034e4:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  1034eb:	00 
  1034ec:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1034f3:	e8 01 cf ff ff       	call   1003f9 <__panic>
  1034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034fb:	05 00 00 00 40       	add    $0x40000000,%eax
  103500:	a3 74 af 11 00       	mov    %eax,0x11af74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103505:	e8 8e f9 ff ff       	call   102e98 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10350a:	e8 73 fa ff ff       	call   102f82 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10350f:	e8 de 03 00 00       	call   1038f2 <check_alloc_page>

    check_pgdir();
  103514:	e8 f8 03 00 00       	call   103911 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103519:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10351e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103521:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103528:	77 23                	ja     10354d <pmm_init+0x8f>
  10352a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10352d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103531:	c7 44 24 08 24 63 10 	movl   $0x106324,0x8(%esp)
  103538:	00 
  103539:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  103540:	00 
  103541:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103548:	e8 ac ce ff ff       	call   1003f9 <__panic>
  10354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103550:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  103556:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10355b:	05 ac 0f 00 00       	add    $0xfac,%eax
  103560:	83 ca 03             	or     $0x3,%edx
  103563:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103565:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10356a:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103571:	00 
  103572:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103579:	00 
  10357a:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103581:	38 
  103582:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  103589:	c0 
  10358a:	89 04 24             	mov    %eax,(%esp)
  10358d:	e8 e5 fd ff ff       	call   103377 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103592:	e8 18 f8 ff ff       	call   102daf <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103597:	e8 11 0a 00 00       	call   103fad <check_boot_pgdir>

    print_pgdir();
  10359c:	e8 8a 0e 00 00       	call   10442b <print_pgdir>

}
  1035a1:	90                   	nop
  1035a2:	c9                   	leave  
  1035a3:	c3                   	ret    

001035a4 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1035a4:	55                   	push   %ebp
  1035a5:	89 e5                	mov    %esp,%ebp
  1035a7:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];//获取二级页表的地址
  1035aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035ad:	c1 e8 16             	shr    $0x16,%eax
  1035b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1035b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ba:	01 d0                	add    %edx,%eax
  1035bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {//如果该二级页表还没有分配物理空间
  1035bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035c2:	8b 00                	mov    (%eax),%eax
  1035c4:	83 e0 01             	and    $0x1,%eax
  1035c7:	85 c0                	test   %eax,%eax
  1035c9:	0f 85 af 00 00 00    	jne    10367e <get_pte+0xda>
        struct Page *page;//分配一个
        if (!create || (page = alloc_page()) == NULL) {
  1035cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1035d3:	74 15                	je     1035ea <get_pte+0x46>
  1035d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035dc:	e8 0b f9 ff ff       	call   102eec <alloc_pages>
  1035e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1035e8:	75 0a                	jne    1035f4 <get_pte+0x50>
            return NULL;
  1035ea:	b8 00 00 00 00       	mov    $0x0,%eax
  1035ef:	e9 e7 00 00 00       	jmp    1036db <get_pte+0x137>
        }
        //下面都是给新页初始化属性
        set_page_ref(page, 1);
  1035f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035fb:	00 
  1035fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035ff:	89 04 24             	mov    %eax,(%esp)
  103602:	e8 ea f6 ff ff       	call   102cf1 <set_page_ref>
        uintptr_t pa = page2pa(page);
  103607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10360a:	89 04 24             	mov    %eax,(%esp)
  10360d:	e8 c6 f5 ff ff       	call   102bd8 <page2pa>
  103612:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  103615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103618:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10361e:	c1 e8 0c             	shr    $0xc,%eax
  103621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103624:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103629:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10362c:	72 23                	jb     103651 <get_pte+0xad>
  10362e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103631:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103635:	c7 44 24 08 80 62 10 	movl   $0x106280,0x8(%esp)
  10363c:	00 
  10363d:	c7 44 24 04 71 01 00 	movl   $0x171,0x4(%esp)
  103644:	00 
  103645:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  10364c:	e8 a8 cd ff ff       	call   1003f9 <__panic>
  103651:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103654:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103659:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103660:	00 
  103661:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103668:	00 
  103669:	89 04 24             	mov    %eax,(%esp)
  10366c:	e8 cd 1c 00 00       	call   10533e <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  103671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103674:	83 c8 07             	or     $0x7,%eax
  103677:	89 c2                	mov    %eax,%edx
  103679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10367c:	89 10                	mov    %edx,(%eax)
        //得到一个被引用数为1，内容为空，权限极低的二级页表页
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];//通过查二级页表返回对应页表项的地址
  10367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103681:	8b 00                	mov    (%eax),%eax
  103683:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103688:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10368b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10368e:	c1 e8 0c             	shr    $0xc,%eax
  103691:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103694:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103699:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10369c:	72 23                	jb     1036c1 <get_pte+0x11d>
  10369e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036a5:	c7 44 24 08 80 62 10 	movl   $0x106280,0x8(%esp)
  1036ac:	00 
  1036ad:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  1036b4:	00 
  1036b5:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1036bc:	e8 38 cd ff ff       	call   1003f9 <__panic>
  1036c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036c4:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1036c9:	89 c2                	mov    %eax,%edx
  1036cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ce:	c1 e8 0c             	shr    $0xc,%eax
  1036d1:	25 ff 03 00 00       	and    $0x3ff,%eax
  1036d6:	c1 e0 02             	shl    $0x2,%eax
  1036d9:	01 d0                	add    %edx,%eax
}
  1036db:	c9                   	leave  
  1036dc:	c3                   	ret    

001036dd <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1036dd:	55                   	push   %ebp
  1036de:	89 e5                	mov    %esp,%ebp
  1036e0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1036e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1036ea:	00 
  1036eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1036f5:	89 04 24             	mov    %eax,(%esp)
  1036f8:	e8 a7 fe ff ff       	call   1035a4 <get_pte>
  1036fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103700:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103704:	74 08                	je     10370e <get_page+0x31>
        *ptep_store = ptep;
  103706:	8b 45 10             	mov    0x10(%ebp),%eax
  103709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10370c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10370e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103712:	74 1b                	je     10372f <get_page+0x52>
  103714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103717:	8b 00                	mov    (%eax),%eax
  103719:	83 e0 01             	and    $0x1,%eax
  10371c:	85 c0                	test   %eax,%eax
  10371e:	74 0f                	je     10372f <get_page+0x52>
        return pte2page(*ptep);
  103720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103723:	8b 00                	mov    (%eax),%eax
  103725:	89 04 24             	mov    %eax,(%esp)
  103728:	e8 64 f5 ff ff       	call   102c91 <pte2page>
  10372d:	eb 05                	jmp    103734 <get_page+0x57>
    }
    return NULL;
  10372f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103734:	c9                   	leave  
  103735:	c3                   	ret    

00103736 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103736:	55                   	push   %ebp
  103737:	89 e5                	mov    %esp,%ebp
  103739:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
        if (*ptep & PTE_P) {//如果逻辑地址所映射到的page，已经分配了内存
  10373c:	8b 45 10             	mov    0x10(%ebp),%eax
  10373f:	8b 00                	mov    (%eax),%eax
  103741:	83 e0 01             	and    $0x1,%eax
  103744:	85 c0                	test   %eax,%eax
  103746:	74 4d                	je     103795 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);//通过宏，得到二级页表项所指向的page
  103748:	8b 45 10             	mov    0x10(%ebp),%eax
  10374b:	8b 00                	mov    (%eax),%eax
  10374d:	89 04 24             	mov    %eax,(%esp)
  103750:	e8 3c f5 ff ff       	call   102c91 <pte2page>
  103755:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {//由于这个逻辑地址不再指向page了，所以page少了一次引用次数
  103758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10375b:	89 04 24             	mov    %eax,(%esp)
  10375e:	e8 b3 f5 ff ff       	call   102d16 <page_ref_dec>
  103763:	85 c0                	test   %eax,%eax
  103765:	75 13                	jne    10377a <page_remove_pte+0x44>
            free_page(page);//如果page的被引用次数为0，就释放掉该页
  103767:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10376e:	00 
  10376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103772:	89 04 24             	mov    %eax,(%esp)
  103775:	e8 aa f7 ff ff       	call   102f24 <free_pages>
        }
        *ptep = 0;//讲该二级页表项清空
  10377a:	8b 45 10             	mov    0x10(%ebp),%eax
  10377d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);//TLB更新
  103783:	8b 45 0c             	mov    0xc(%ebp),%eax
  103786:	89 44 24 04          	mov    %eax,0x4(%esp)
  10378a:	8b 45 08             	mov    0x8(%ebp),%eax
  10378d:	89 04 24             	mov    %eax,(%esp)
  103790:	e8 01 01 00 00       	call   103896 <tlb_invalidate>
    }
}
  103795:	90                   	nop
  103796:	c9                   	leave  
  103797:	c3                   	ret    

00103798 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103798:	55                   	push   %ebp
  103799:	89 e5                	mov    %esp,%ebp
  10379b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10379e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037a5:	00 
  1037a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1037b0:	89 04 24             	mov    %eax,(%esp)
  1037b3:	e8 ec fd ff ff       	call   1035a4 <get_pte>
  1037b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1037bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1037bf:	74 19                	je     1037da <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1037c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1037c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1037d2:	89 04 24             	mov    %eax,(%esp)
  1037d5:	e8 5c ff ff ff       	call   103736 <page_remove_pte>
    }
}
  1037da:	90                   	nop
  1037db:	c9                   	leave  
  1037dc:	c3                   	ret    

001037dd <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1037dd:	55                   	push   %ebp
  1037de:	89 e5                	mov    %esp,%ebp
  1037e0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1037e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1037ea:	00 
  1037eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1037ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1037f5:	89 04 24             	mov    %eax,(%esp)
  1037f8:	e8 a7 fd ff ff       	call   1035a4 <get_pte>
  1037fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103804:	75 0a                	jne    103810 <page_insert+0x33>
        return -E_NO_MEM;
  103806:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10380b:	e9 84 00 00 00       	jmp    103894 <page_insert+0xb7>
    }
    page_ref_inc(page);
  103810:	8b 45 0c             	mov    0xc(%ebp),%eax
  103813:	89 04 24             	mov    %eax,(%esp)
  103816:	e8 e4 f4 ff ff       	call   102cff <page_ref_inc>
    if (*ptep & PTE_P) {
  10381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10381e:	8b 00                	mov    (%eax),%eax
  103820:	83 e0 01             	and    $0x1,%eax
  103823:	85 c0                	test   %eax,%eax
  103825:	74 3e                	je     103865 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  103827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10382a:	8b 00                	mov    (%eax),%eax
  10382c:	89 04 24             	mov    %eax,(%esp)
  10382f:	e8 5d f4 ff ff       	call   102c91 <pte2page>
  103834:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10383a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10383d:	75 0d                	jne    10384c <page_insert+0x6f>
            page_ref_dec(page);
  10383f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103842:	89 04 24             	mov    %eax,(%esp)
  103845:	e8 cc f4 ff ff       	call   102d16 <page_ref_dec>
  10384a:	eb 19                	jmp    103865 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10384f:	89 44 24 08          	mov    %eax,0x8(%esp)
  103853:	8b 45 10             	mov    0x10(%ebp),%eax
  103856:	89 44 24 04          	mov    %eax,0x4(%esp)
  10385a:	8b 45 08             	mov    0x8(%ebp),%eax
  10385d:	89 04 24             	mov    %eax,(%esp)
  103860:	e8 d1 fe ff ff       	call   103736 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103865:	8b 45 0c             	mov    0xc(%ebp),%eax
  103868:	89 04 24             	mov    %eax,(%esp)
  10386b:	e8 68 f3 ff ff       	call   102bd8 <page2pa>
  103870:	0b 45 14             	or     0x14(%ebp),%eax
  103873:	83 c8 01             	or     $0x1,%eax
  103876:	89 c2                	mov    %eax,%edx
  103878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10387b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10387d:	8b 45 10             	mov    0x10(%ebp),%eax
  103880:	89 44 24 04          	mov    %eax,0x4(%esp)
  103884:	8b 45 08             	mov    0x8(%ebp),%eax
  103887:	89 04 24             	mov    %eax,(%esp)
  10388a:	e8 07 00 00 00       	call   103896 <tlb_invalidate>
    return 0;
  10388f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103894:	c9                   	leave  
  103895:	c3                   	ret    

00103896 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103896:	55                   	push   %ebp
  103897:	89 e5                	mov    %esp,%ebp
  103899:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10389c:	0f 20 d8             	mov    %cr3,%eax
  10389f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1038a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1038a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1038a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1038ab:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1038b2:	77 23                	ja     1038d7 <tlb_invalidate+0x41>
  1038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1038bb:	c7 44 24 08 24 63 10 	movl   $0x106324,0x8(%esp)
  1038c2:	00 
  1038c3:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
  1038ca:	00 
  1038cb:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1038d2:	e8 22 cb ff ff       	call   1003f9 <__panic>
  1038d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038da:	05 00 00 00 40       	add    $0x40000000,%eax
  1038df:	39 d0                	cmp    %edx,%eax
  1038e1:	75 0c                	jne    1038ef <tlb_invalidate+0x59>
        invlpg((void *)la);
  1038e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1038e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038ec:	0f 01 38             	invlpg (%eax)
    }
}
  1038ef:	90                   	nop
  1038f0:	c9                   	leave  
  1038f1:	c3                   	ret    

001038f2 <check_alloc_page>:

static void
check_alloc_page(void) {
  1038f2:	55                   	push   %ebp
  1038f3:	89 e5                	mov    %esp,%ebp
  1038f5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1038f8:	a1 70 af 11 00       	mov    0x11af70,%eax
  1038fd:	8b 40 18             	mov    0x18(%eax),%eax
  103900:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103902:	c7 04 24 a8 63 10 00 	movl   $0x1063a8,(%esp)
  103909:	e8 94 c9 ff ff       	call   1002a2 <cprintf>
}
  10390e:	90                   	nop
  10390f:	c9                   	leave  
  103910:	c3                   	ret    

00103911 <check_pgdir>:

static void
check_pgdir(void) {
  103911:	55                   	push   %ebp
  103912:	89 e5                	mov    %esp,%ebp
  103914:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103917:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  10391c:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103921:	76 24                	jbe    103947 <check_pgdir+0x36>
  103923:	c7 44 24 0c c7 63 10 	movl   $0x1063c7,0xc(%esp)
  10392a:	00 
  10392b:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103932:	00 
  103933:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  10393a:	00 
  10393b:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103942:	e8 b2 ca ff ff       	call   1003f9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103947:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10394c:	85 c0                	test   %eax,%eax
  10394e:	74 0e                	je     10395e <check_pgdir+0x4d>
  103950:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103955:	25 ff 0f 00 00       	and    $0xfff,%eax
  10395a:	85 c0                	test   %eax,%eax
  10395c:	74 24                	je     103982 <check_pgdir+0x71>
  10395e:	c7 44 24 0c e4 63 10 	movl   $0x1063e4,0xc(%esp)
  103965:	00 
  103966:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  10396d:	00 
  10396e:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  103975:	00 
  103976:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  10397d:	e8 77 ca ff ff       	call   1003f9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103982:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103987:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10398e:	00 
  10398f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103996:	00 
  103997:	89 04 24             	mov    %eax,(%esp)
  10399a:	e8 3e fd ff ff       	call   1036dd <get_page>
  10399f:	85 c0                	test   %eax,%eax
  1039a1:	74 24                	je     1039c7 <check_pgdir+0xb6>
  1039a3:	c7 44 24 0c 1c 64 10 	movl   $0x10641c,0xc(%esp)
  1039aa:	00 
  1039ab:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  1039b2:	00 
  1039b3:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  1039ba:	00 
  1039bb:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1039c2:	e8 32 ca ff ff       	call   1003f9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1039c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039ce:	e8 19 f5 ff ff       	call   102eec <alloc_pages>
  1039d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1039d6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1039db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1039e2:	00 
  1039e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039ea:	00 
  1039eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1039ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1039f2:	89 04 24             	mov    %eax,(%esp)
  1039f5:	e8 e3 fd ff ff       	call   1037dd <page_insert>
  1039fa:	85 c0                	test   %eax,%eax
  1039fc:	74 24                	je     103a22 <check_pgdir+0x111>
  1039fe:	c7 44 24 0c 44 64 10 	movl   $0x106444,0xc(%esp)
  103a05:	00 
  103a06:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103a0d:	00 
  103a0e:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  103a15:	00 
  103a16:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103a1d:	e8 d7 c9 ff ff       	call   1003f9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103a22:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103a27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a2e:	00 
  103a2f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a36:	00 
  103a37:	89 04 24             	mov    %eax,(%esp)
  103a3a:	e8 65 fb ff ff       	call   1035a4 <get_pte>
  103a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a46:	75 24                	jne    103a6c <check_pgdir+0x15b>
  103a48:	c7 44 24 0c 70 64 10 	movl   $0x106470,0xc(%esp)
  103a4f:	00 
  103a50:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103a57:	00 
  103a58:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  103a5f:	00 
  103a60:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103a67:	e8 8d c9 ff ff       	call   1003f9 <__panic>
    assert(pte2page(*ptep) == p1);
  103a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a6f:	8b 00                	mov    (%eax),%eax
  103a71:	89 04 24             	mov    %eax,(%esp)
  103a74:	e8 18 f2 ff ff       	call   102c91 <pte2page>
  103a79:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103a7c:	74 24                	je     103aa2 <check_pgdir+0x191>
  103a7e:	c7 44 24 0c 9d 64 10 	movl   $0x10649d,0xc(%esp)
  103a85:	00 
  103a86:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103a8d:	00 
  103a8e:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  103a95:	00 
  103a96:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103a9d:	e8 57 c9 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p1) == 1);
  103aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aa5:	89 04 24             	mov    %eax,(%esp)
  103aa8:	e8 3a f2 ff ff       	call   102ce7 <page_ref>
  103aad:	83 f8 01             	cmp    $0x1,%eax
  103ab0:	74 24                	je     103ad6 <check_pgdir+0x1c5>
  103ab2:	c7 44 24 0c b3 64 10 	movl   $0x1064b3,0xc(%esp)
  103ab9:	00 
  103aba:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103ac1:	00 
  103ac2:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  103ac9:	00 
  103aca:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103ad1:	e8 23 c9 ff ff       	call   1003f9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103ad6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103adb:	8b 00                	mov    (%eax),%eax
  103add:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ae2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ae8:	c1 e8 0c             	shr    $0xc,%eax
  103aeb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103aee:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103af3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103af6:	72 23                	jb     103b1b <check_pgdir+0x20a>
  103af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103afb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103aff:	c7 44 24 08 80 62 10 	movl   $0x106280,0x8(%esp)
  103b06:	00 
  103b07:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  103b0e:	00 
  103b0f:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103b16:	e8 de c8 ff ff       	call   1003f9 <__panic>
  103b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b1e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103b23:	83 c0 04             	add    $0x4,%eax
  103b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103b29:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103b2e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b35:	00 
  103b36:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b3d:	00 
  103b3e:	89 04 24             	mov    %eax,(%esp)
  103b41:	e8 5e fa ff ff       	call   1035a4 <get_pte>
  103b46:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103b49:	74 24                	je     103b6f <check_pgdir+0x25e>
  103b4b:	c7 44 24 0c c8 64 10 	movl   $0x1064c8,0xc(%esp)
  103b52:	00 
  103b53:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103b5a:	00 
  103b5b:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  103b62:	00 
  103b63:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103b6a:	e8 8a c8 ff ff       	call   1003f9 <__panic>

    p2 = alloc_page();
  103b6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103b76:	e8 71 f3 ff ff       	call   102eec <alloc_pages>
  103b7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103b7e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103b83:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103b8a:	00 
  103b8b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103b92:	00 
  103b93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103b96:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b9a:	89 04 24             	mov    %eax,(%esp)
  103b9d:	e8 3b fc ff ff       	call   1037dd <page_insert>
  103ba2:	85 c0                	test   %eax,%eax
  103ba4:	74 24                	je     103bca <check_pgdir+0x2b9>
  103ba6:	c7 44 24 0c f0 64 10 	movl   $0x1064f0,0xc(%esp)
  103bad:	00 
  103bae:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103bb5:	00 
  103bb6:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  103bbd:	00 
  103bbe:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103bc5:	e8 2f c8 ff ff       	call   1003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103bca:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103bcf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103bd6:	00 
  103bd7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103bde:	00 
  103bdf:	89 04 24             	mov    %eax,(%esp)
  103be2:	e8 bd f9 ff ff       	call   1035a4 <get_pte>
  103be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103bea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bee:	75 24                	jne    103c14 <check_pgdir+0x303>
  103bf0:	c7 44 24 0c 28 65 10 	movl   $0x106528,0xc(%esp)
  103bf7:	00 
  103bf8:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103bff:	00 
  103c00:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  103c07:	00 
  103c08:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103c0f:	e8 e5 c7 ff ff       	call   1003f9 <__panic>
    assert(*ptep & PTE_U);
  103c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c17:	8b 00                	mov    (%eax),%eax
  103c19:	83 e0 04             	and    $0x4,%eax
  103c1c:	85 c0                	test   %eax,%eax
  103c1e:	75 24                	jne    103c44 <check_pgdir+0x333>
  103c20:	c7 44 24 0c 58 65 10 	movl   $0x106558,0xc(%esp)
  103c27:	00 
  103c28:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103c2f:	00 
  103c30:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103c37:	00 
  103c38:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103c3f:	e8 b5 c7 ff ff       	call   1003f9 <__panic>
    assert(*ptep & PTE_W);
  103c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c47:	8b 00                	mov    (%eax),%eax
  103c49:	83 e0 02             	and    $0x2,%eax
  103c4c:	85 c0                	test   %eax,%eax
  103c4e:	75 24                	jne    103c74 <check_pgdir+0x363>
  103c50:	c7 44 24 0c 66 65 10 	movl   $0x106566,0xc(%esp)
  103c57:	00 
  103c58:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103c5f:	00 
  103c60:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103c67:	00 
  103c68:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103c6f:	e8 85 c7 ff ff       	call   1003f9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103c74:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103c79:	8b 00                	mov    (%eax),%eax
  103c7b:	83 e0 04             	and    $0x4,%eax
  103c7e:	85 c0                	test   %eax,%eax
  103c80:	75 24                	jne    103ca6 <check_pgdir+0x395>
  103c82:	c7 44 24 0c 74 65 10 	movl   $0x106574,0xc(%esp)
  103c89:	00 
  103c8a:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103c91:	00 
  103c92:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103c99:	00 
  103c9a:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103ca1:	e8 53 c7 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 1);
  103ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ca9:	89 04 24             	mov    %eax,(%esp)
  103cac:	e8 36 f0 ff ff       	call   102ce7 <page_ref>
  103cb1:	83 f8 01             	cmp    $0x1,%eax
  103cb4:	74 24                	je     103cda <check_pgdir+0x3c9>
  103cb6:	c7 44 24 0c 8a 65 10 	movl   $0x10658a,0xc(%esp)
  103cbd:	00 
  103cbe:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103cc5:	00 
  103cc6:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  103ccd:	00 
  103cce:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103cd5:	e8 1f c7 ff ff       	call   1003f9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103cda:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103cdf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103ce6:	00 
  103ce7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103cee:	00 
  103cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103cf2:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cf6:	89 04 24             	mov    %eax,(%esp)
  103cf9:	e8 df fa ff ff       	call   1037dd <page_insert>
  103cfe:	85 c0                	test   %eax,%eax
  103d00:	74 24                	je     103d26 <check_pgdir+0x415>
  103d02:	c7 44 24 0c 9c 65 10 	movl   $0x10659c,0xc(%esp)
  103d09:	00 
  103d0a:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103d11:	00 
  103d12:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  103d19:	00 
  103d1a:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103d21:	e8 d3 c6 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p1) == 2);
  103d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d29:	89 04 24             	mov    %eax,(%esp)
  103d2c:	e8 b6 ef ff ff       	call   102ce7 <page_ref>
  103d31:	83 f8 02             	cmp    $0x2,%eax
  103d34:	74 24                	je     103d5a <check_pgdir+0x449>
  103d36:	c7 44 24 0c c8 65 10 	movl   $0x1065c8,0xc(%esp)
  103d3d:	00 
  103d3e:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103d45:	00 
  103d46:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103d4d:	00 
  103d4e:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103d55:	e8 9f c6 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d5d:	89 04 24             	mov    %eax,(%esp)
  103d60:	e8 82 ef ff ff       	call   102ce7 <page_ref>
  103d65:	85 c0                	test   %eax,%eax
  103d67:	74 24                	je     103d8d <check_pgdir+0x47c>
  103d69:	c7 44 24 0c da 65 10 	movl   $0x1065da,0xc(%esp)
  103d70:	00 
  103d71:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103d78:	00 
  103d79:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103d80:	00 
  103d81:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103d88:	e8 6c c6 ff ff       	call   1003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103d8d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103d92:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103d99:	00 
  103d9a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103da1:	00 
  103da2:	89 04 24             	mov    %eax,(%esp)
  103da5:	e8 fa f7 ff ff       	call   1035a4 <get_pte>
  103daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103dad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103db1:	75 24                	jne    103dd7 <check_pgdir+0x4c6>
  103db3:	c7 44 24 0c 28 65 10 	movl   $0x106528,0xc(%esp)
  103dba:	00 
  103dbb:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103dc2:	00 
  103dc3:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103dca:	00 
  103dcb:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103dd2:	e8 22 c6 ff ff       	call   1003f9 <__panic>
    assert(pte2page(*ptep) == p1);
  103dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103dda:	8b 00                	mov    (%eax),%eax
  103ddc:	89 04 24             	mov    %eax,(%esp)
  103ddf:	e8 ad ee ff ff       	call   102c91 <pte2page>
  103de4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103de7:	74 24                	je     103e0d <check_pgdir+0x4fc>
  103de9:	c7 44 24 0c 9d 64 10 	movl   $0x10649d,0xc(%esp)
  103df0:	00 
  103df1:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103df8:	00 
  103df9:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103e00:	00 
  103e01:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103e08:	e8 ec c5 ff ff       	call   1003f9 <__panic>
    assert((*ptep & PTE_U) == 0);
  103e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e10:	8b 00                	mov    (%eax),%eax
  103e12:	83 e0 04             	and    $0x4,%eax
  103e15:	85 c0                	test   %eax,%eax
  103e17:	74 24                	je     103e3d <check_pgdir+0x52c>
  103e19:	c7 44 24 0c ec 65 10 	movl   $0x1065ec,0xc(%esp)
  103e20:	00 
  103e21:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103e28:	00 
  103e29:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103e30:	00 
  103e31:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103e38:	e8 bc c5 ff ff       	call   1003f9 <__panic>

    page_remove(boot_pgdir, 0x0);
  103e3d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103e42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103e49:	00 
  103e4a:	89 04 24             	mov    %eax,(%esp)
  103e4d:	e8 46 f9 ff ff       	call   103798 <page_remove>
    assert(page_ref(p1) == 1);
  103e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e55:	89 04 24             	mov    %eax,(%esp)
  103e58:	e8 8a ee ff ff       	call   102ce7 <page_ref>
  103e5d:	83 f8 01             	cmp    $0x1,%eax
  103e60:	74 24                	je     103e86 <check_pgdir+0x575>
  103e62:	c7 44 24 0c b3 64 10 	movl   $0x1064b3,0xc(%esp)
  103e69:	00 
  103e6a:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103e71:	00 
  103e72:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103e79:	00 
  103e7a:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103e81:	e8 73 c5 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e89:	89 04 24             	mov    %eax,(%esp)
  103e8c:	e8 56 ee ff ff       	call   102ce7 <page_ref>
  103e91:	85 c0                	test   %eax,%eax
  103e93:	74 24                	je     103eb9 <check_pgdir+0x5a8>
  103e95:	c7 44 24 0c da 65 10 	movl   $0x1065da,0xc(%esp)
  103e9c:	00 
  103e9d:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103ea4:	00 
  103ea5:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  103eac:	00 
  103ead:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103eb4:	e8 40 c5 ff ff       	call   1003f9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103eb9:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103ebe:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103ec5:	00 
  103ec6:	89 04 24             	mov    %eax,(%esp)
  103ec9:	e8 ca f8 ff ff       	call   103798 <page_remove>
    assert(page_ref(p1) == 0);
  103ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ed1:	89 04 24             	mov    %eax,(%esp)
  103ed4:	e8 0e ee ff ff       	call   102ce7 <page_ref>
  103ed9:	85 c0                	test   %eax,%eax
  103edb:	74 24                	je     103f01 <check_pgdir+0x5f0>
  103edd:	c7 44 24 0c 01 66 10 	movl   $0x106601,0xc(%esp)
  103ee4:	00 
  103ee5:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103eec:	00 
  103eed:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103ef4:	00 
  103ef5:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103efc:	e8 f8 c4 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f04:	89 04 24             	mov    %eax,(%esp)
  103f07:	e8 db ed ff ff       	call   102ce7 <page_ref>
  103f0c:	85 c0                	test   %eax,%eax
  103f0e:	74 24                	je     103f34 <check_pgdir+0x623>
  103f10:	c7 44 24 0c da 65 10 	movl   $0x1065da,0xc(%esp)
  103f17:	00 
  103f18:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103f1f:	00 
  103f20:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103f27:	00 
  103f28:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103f2f:	e8 c5 c4 ff ff       	call   1003f9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103f34:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103f39:	8b 00                	mov    (%eax),%eax
  103f3b:	89 04 24             	mov    %eax,(%esp)
  103f3e:	e8 8c ed ff ff       	call   102ccf <pde2page>
  103f43:	89 04 24             	mov    %eax,(%esp)
  103f46:	e8 9c ed ff ff       	call   102ce7 <page_ref>
  103f4b:	83 f8 01             	cmp    $0x1,%eax
  103f4e:	74 24                	je     103f74 <check_pgdir+0x663>
  103f50:	c7 44 24 0c 14 66 10 	movl   $0x106614,0xc(%esp)
  103f57:	00 
  103f58:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  103f5f:	00 
  103f60:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103f67:	00 
  103f68:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103f6f:	e8 85 c4 ff ff       	call   1003f9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103f74:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103f79:	8b 00                	mov    (%eax),%eax
  103f7b:	89 04 24             	mov    %eax,(%esp)
  103f7e:	e8 4c ed ff ff       	call   102ccf <pde2page>
  103f83:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f8a:	00 
  103f8b:	89 04 24             	mov    %eax,(%esp)
  103f8e:	e8 91 ef ff ff       	call   102f24 <free_pages>
    boot_pgdir[0] = 0;
  103f93:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103f98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103f9e:	c7 04 24 3b 66 10 00 	movl   $0x10663b,(%esp)
  103fa5:	e8 f8 c2 ff ff       	call   1002a2 <cprintf>
}
  103faa:	90                   	nop
  103fab:	c9                   	leave  
  103fac:	c3                   	ret    

00103fad <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103fad:	55                   	push   %ebp
  103fae:	89 e5                	mov    %esp,%ebp
  103fb0:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103fb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103fba:	e9 ca 00 00 00       	jmp    104089 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103fc8:	c1 e8 0c             	shr    $0xc,%eax
  103fcb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103fce:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103fd3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103fd6:	72 23                	jb     103ffb <check_boot_pgdir+0x4e>
  103fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103fdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103fdf:	c7 44 24 08 80 62 10 	movl   $0x106280,0x8(%esp)
  103fe6:	00 
  103fe7:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103fee:	00 
  103fef:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  103ff6:	e8 fe c3 ff ff       	call   1003f9 <__panic>
  103ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ffe:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104003:	89 c2                	mov    %eax,%edx
  104005:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10400a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104011:	00 
  104012:	89 54 24 04          	mov    %edx,0x4(%esp)
  104016:	89 04 24             	mov    %eax,(%esp)
  104019:	e8 86 f5 ff ff       	call   1035a4 <get_pte>
  10401e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104021:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104025:	75 24                	jne    10404b <check_boot_pgdir+0x9e>
  104027:	c7 44 24 0c 58 66 10 	movl   $0x106658,0xc(%esp)
  10402e:	00 
  10402f:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  104036:	00 
  104037:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  10403e:	00 
  10403f:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  104046:	e8 ae c3 ff ff       	call   1003f9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  10404b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10404e:	8b 00                	mov    (%eax),%eax
  104050:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104055:	89 c2                	mov    %eax,%edx
  104057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10405a:	39 c2                	cmp    %eax,%edx
  10405c:	74 24                	je     104082 <check_boot_pgdir+0xd5>
  10405e:	c7 44 24 0c 95 66 10 	movl   $0x106695,0xc(%esp)
  104065:	00 
  104066:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  10406d:	00 
  10406e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104075:	00 
  104076:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  10407d:	e8 77 c3 ff ff       	call   1003f9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  104082:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10408c:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104091:	39 c2                	cmp    %eax,%edx
  104093:	0f 82 26 ff ff ff    	jb     103fbf <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104099:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10409e:	05 ac 0f 00 00       	add    $0xfac,%eax
  1040a3:	8b 00                	mov    (%eax),%eax
  1040a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1040aa:	89 c2                	mov    %eax,%edx
  1040ac:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1040b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1040b4:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1040bb:	77 23                	ja     1040e0 <check_boot_pgdir+0x133>
  1040bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040c4:	c7 44 24 08 24 63 10 	movl   $0x106324,0x8(%esp)
  1040cb:	00 
  1040cc:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  1040d3:	00 
  1040d4:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1040db:	e8 19 c3 ff ff       	call   1003f9 <__panic>
  1040e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040e3:	05 00 00 00 40       	add    $0x40000000,%eax
  1040e8:	39 d0                	cmp    %edx,%eax
  1040ea:	74 24                	je     104110 <check_boot_pgdir+0x163>
  1040ec:	c7 44 24 0c ac 66 10 	movl   $0x1066ac,0xc(%esp)
  1040f3:	00 
  1040f4:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  1040fb:	00 
  1040fc:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104103:	00 
  104104:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  10410b:	e8 e9 c2 ff ff       	call   1003f9 <__panic>

    assert(boot_pgdir[0] == 0);
  104110:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104115:	8b 00                	mov    (%eax),%eax
  104117:	85 c0                	test   %eax,%eax
  104119:	74 24                	je     10413f <check_boot_pgdir+0x192>
  10411b:	c7 44 24 0c e0 66 10 	movl   $0x1066e0,0xc(%esp)
  104122:	00 
  104123:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  10412a:	00 
  10412b:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104132:	00 
  104133:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  10413a:	e8 ba c2 ff ff       	call   1003f9 <__panic>

    struct Page *p;
    p = alloc_page();
  10413f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104146:	e8 a1 ed ff ff       	call   102eec <alloc_pages>
  10414b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  10414e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104153:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10415a:	00 
  10415b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104162:	00 
  104163:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104166:	89 54 24 04          	mov    %edx,0x4(%esp)
  10416a:	89 04 24             	mov    %eax,(%esp)
  10416d:	e8 6b f6 ff ff       	call   1037dd <page_insert>
  104172:	85 c0                	test   %eax,%eax
  104174:	74 24                	je     10419a <check_boot_pgdir+0x1ed>
  104176:	c7 44 24 0c f4 66 10 	movl   $0x1066f4,0xc(%esp)
  10417d:	00 
  10417e:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  104185:	00 
  104186:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  10418d:	00 
  10418e:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  104195:	e8 5f c2 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p) == 1);
  10419a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10419d:	89 04 24             	mov    %eax,(%esp)
  1041a0:	e8 42 eb ff ff       	call   102ce7 <page_ref>
  1041a5:	83 f8 01             	cmp    $0x1,%eax
  1041a8:	74 24                	je     1041ce <check_boot_pgdir+0x221>
  1041aa:	c7 44 24 0c 22 67 10 	movl   $0x106722,0xc(%esp)
  1041b1:	00 
  1041b2:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  1041b9:	00 
  1041ba:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  1041c1:	00 
  1041c2:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1041c9:	e8 2b c2 ff ff       	call   1003f9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1041ce:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1041d3:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1041da:	00 
  1041db:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1041e2:	00 
  1041e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1041ea:	89 04 24             	mov    %eax,(%esp)
  1041ed:	e8 eb f5 ff ff       	call   1037dd <page_insert>
  1041f2:	85 c0                	test   %eax,%eax
  1041f4:	74 24                	je     10421a <check_boot_pgdir+0x26d>
  1041f6:	c7 44 24 0c 34 67 10 	movl   $0x106734,0xc(%esp)
  1041fd:	00 
  1041fe:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  104205:	00 
  104206:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  10420d:	00 
  10420e:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  104215:	e8 df c1 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p) == 2);
  10421a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10421d:	89 04 24             	mov    %eax,(%esp)
  104220:	e8 c2 ea ff ff       	call   102ce7 <page_ref>
  104225:	83 f8 02             	cmp    $0x2,%eax
  104228:	74 24                	je     10424e <check_boot_pgdir+0x2a1>
  10422a:	c7 44 24 0c 6b 67 10 	movl   $0x10676b,0xc(%esp)
  104231:	00 
  104232:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  104239:	00 
  10423a:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104241:	00 
  104242:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  104249:	e8 ab c1 ff ff       	call   1003f9 <__panic>

    const char *str = "ucore: Hello world!!";
  10424e:	c7 45 e8 7c 67 10 00 	movl   $0x10677c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  104255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104258:	89 44 24 04          	mov    %eax,0x4(%esp)
  10425c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104263:	e8 0c 0e 00 00       	call   105074 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104268:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10426f:	00 
  104270:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104277:	e8 6f 0e 00 00       	call   1050eb <strcmp>
  10427c:	85 c0                	test   %eax,%eax
  10427e:	74 24                	je     1042a4 <check_boot_pgdir+0x2f7>
  104280:	c7 44 24 0c 94 67 10 	movl   $0x106794,0xc(%esp)
  104287:	00 
  104288:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  10428f:	00 
  104290:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  104297:	00 
  104298:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  10429f:	e8 55 c1 ff ff       	call   1003f9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1042a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042a7:	89 04 24             	mov    %eax,(%esp)
  1042aa:	e8 8e e9 ff ff       	call   102c3d <page2kva>
  1042af:	05 00 01 00 00       	add    $0x100,%eax
  1042b4:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1042b7:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1042be:	e8 5b 0d 00 00       	call   10501e <strlen>
  1042c3:	85 c0                	test   %eax,%eax
  1042c5:	74 24                	je     1042eb <check_boot_pgdir+0x33e>
  1042c7:	c7 44 24 0c cc 67 10 	movl   $0x1067cc,0xc(%esp)
  1042ce:	00 
  1042cf:	c7 44 24 08 6d 63 10 	movl   $0x10636d,0x8(%esp)
  1042d6:	00 
  1042d7:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  1042de:	00 
  1042df:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  1042e6:	e8 0e c1 ff ff       	call   1003f9 <__panic>

    free_page(p);
  1042eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1042f2:	00 
  1042f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042f6:	89 04 24             	mov    %eax,(%esp)
  1042f9:	e8 26 ec ff ff       	call   102f24 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1042fe:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104303:	8b 00                	mov    (%eax),%eax
  104305:	89 04 24             	mov    %eax,(%esp)
  104308:	e8 c2 e9 ff ff       	call   102ccf <pde2page>
  10430d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104314:	00 
  104315:	89 04 24             	mov    %eax,(%esp)
  104318:	e8 07 ec ff ff       	call   102f24 <free_pages>
    boot_pgdir[0] = 0;
  10431d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104322:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104328:	c7 04 24 f0 67 10 00 	movl   $0x1067f0,(%esp)
  10432f:	e8 6e bf ff ff       	call   1002a2 <cprintf>
}
  104334:	90                   	nop
  104335:	c9                   	leave  
  104336:	c3                   	ret    

00104337 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104337:	55                   	push   %ebp
  104338:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10433a:	8b 45 08             	mov    0x8(%ebp),%eax
  10433d:	83 e0 04             	and    $0x4,%eax
  104340:	85 c0                	test   %eax,%eax
  104342:	74 04                	je     104348 <perm2str+0x11>
  104344:	b0 75                	mov    $0x75,%al
  104346:	eb 02                	jmp    10434a <perm2str+0x13>
  104348:	b0 2d                	mov    $0x2d,%al
  10434a:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  10434f:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104356:	8b 45 08             	mov    0x8(%ebp),%eax
  104359:	83 e0 02             	and    $0x2,%eax
  10435c:	85 c0                	test   %eax,%eax
  10435e:	74 04                	je     104364 <perm2str+0x2d>
  104360:	b0 77                	mov    $0x77,%al
  104362:	eb 02                	jmp    104366 <perm2str+0x2f>
  104364:	b0 2d                	mov    $0x2d,%al
  104366:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  10436b:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  104372:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  104377:	5d                   	pop    %ebp
  104378:	c3                   	ret    

00104379 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104379:	55                   	push   %ebp
  10437a:	89 e5                	mov    %esp,%ebp
  10437c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10437f:	8b 45 10             	mov    0x10(%ebp),%eax
  104382:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104385:	72 0d                	jb     104394 <get_pgtable_items+0x1b>
        return 0;
  104387:	b8 00 00 00 00       	mov    $0x0,%eax
  10438c:	e9 98 00 00 00       	jmp    104429 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104391:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104394:	8b 45 10             	mov    0x10(%ebp),%eax
  104397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10439a:	73 18                	jae    1043b4 <get_pgtable_items+0x3b>
  10439c:	8b 45 10             	mov    0x10(%ebp),%eax
  10439f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1043a6:	8b 45 14             	mov    0x14(%ebp),%eax
  1043a9:	01 d0                	add    %edx,%eax
  1043ab:	8b 00                	mov    (%eax),%eax
  1043ad:	83 e0 01             	and    $0x1,%eax
  1043b0:	85 c0                	test   %eax,%eax
  1043b2:	74 dd                	je     104391 <get_pgtable_items+0x18>
    }
    if (start < right) {
  1043b4:	8b 45 10             	mov    0x10(%ebp),%eax
  1043b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1043ba:	73 68                	jae    104424 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  1043bc:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1043c0:	74 08                	je     1043ca <get_pgtable_items+0x51>
            *left_store = start;
  1043c2:	8b 45 18             	mov    0x18(%ebp),%eax
  1043c5:	8b 55 10             	mov    0x10(%ebp),%edx
  1043c8:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1043ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1043cd:	8d 50 01             	lea    0x1(%eax),%edx
  1043d0:	89 55 10             	mov    %edx,0x10(%ebp)
  1043d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1043da:	8b 45 14             	mov    0x14(%ebp),%eax
  1043dd:	01 d0                	add    %edx,%eax
  1043df:	8b 00                	mov    (%eax),%eax
  1043e1:	83 e0 07             	and    $0x7,%eax
  1043e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1043e7:	eb 03                	jmp    1043ec <get_pgtable_items+0x73>
            start ++;
  1043e9:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1043ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1043ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1043f2:	73 1d                	jae    104411 <get_pgtable_items+0x98>
  1043f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1043f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1043fe:	8b 45 14             	mov    0x14(%ebp),%eax
  104401:	01 d0                	add    %edx,%eax
  104403:	8b 00                	mov    (%eax),%eax
  104405:	83 e0 07             	and    $0x7,%eax
  104408:	89 c2                	mov    %eax,%edx
  10440a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10440d:	39 c2                	cmp    %eax,%edx
  10440f:	74 d8                	je     1043e9 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  104411:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104415:	74 08                	je     10441f <get_pgtable_items+0xa6>
            *right_store = start;
  104417:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10441a:	8b 55 10             	mov    0x10(%ebp),%edx
  10441d:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10441f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104422:	eb 05                	jmp    104429 <get_pgtable_items+0xb0>
    }
    return 0;
  104424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104429:	c9                   	leave  
  10442a:	c3                   	ret    

0010442b <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10442b:	55                   	push   %ebp
  10442c:	89 e5                	mov    %esp,%ebp
  10442e:	57                   	push   %edi
  10442f:	56                   	push   %esi
  104430:	53                   	push   %ebx
  104431:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104434:	c7 04 24 10 68 10 00 	movl   $0x106810,(%esp)
  10443b:	e8 62 be ff ff       	call   1002a2 <cprintf>
    size_t left, right = 0, perm;
  104440:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104447:	e9 fa 00 00 00       	jmp    104546 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10444c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10444f:	89 04 24             	mov    %eax,(%esp)
  104452:	e8 e0 fe ff ff       	call   104337 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104457:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10445a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10445d:	29 d1                	sub    %edx,%ecx
  10445f:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104461:	89 d6                	mov    %edx,%esi
  104463:	c1 e6 16             	shl    $0x16,%esi
  104466:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104469:	89 d3                	mov    %edx,%ebx
  10446b:	c1 e3 16             	shl    $0x16,%ebx
  10446e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104471:	89 d1                	mov    %edx,%ecx
  104473:	c1 e1 16             	shl    $0x16,%ecx
  104476:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104479:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10447c:	29 d7                	sub    %edx,%edi
  10447e:	89 fa                	mov    %edi,%edx
  104480:	89 44 24 14          	mov    %eax,0x14(%esp)
  104484:	89 74 24 10          	mov    %esi,0x10(%esp)
  104488:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10448c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104490:	89 54 24 04          	mov    %edx,0x4(%esp)
  104494:	c7 04 24 41 68 10 00 	movl   $0x106841,(%esp)
  10449b:	e8 02 be ff ff       	call   1002a2 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1044a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044a3:	c1 e0 0a             	shl    $0xa,%eax
  1044a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1044a9:	eb 54                	jmp    1044ff <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1044ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044ae:	89 04 24             	mov    %eax,(%esp)
  1044b1:	e8 81 fe ff ff       	call   104337 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1044b6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1044b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1044bc:	29 d1                	sub    %edx,%ecx
  1044be:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1044c0:	89 d6                	mov    %edx,%esi
  1044c2:	c1 e6 0c             	shl    $0xc,%esi
  1044c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1044c8:	89 d3                	mov    %edx,%ebx
  1044ca:	c1 e3 0c             	shl    $0xc,%ebx
  1044cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1044d0:	89 d1                	mov    %edx,%ecx
  1044d2:	c1 e1 0c             	shl    $0xc,%ecx
  1044d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1044d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1044db:	29 d7                	sub    %edx,%edi
  1044dd:	89 fa                	mov    %edi,%edx
  1044df:	89 44 24 14          	mov    %eax,0x14(%esp)
  1044e3:	89 74 24 10          	mov    %esi,0x10(%esp)
  1044e7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1044eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1044ef:	89 54 24 04          	mov    %edx,0x4(%esp)
  1044f3:	c7 04 24 60 68 10 00 	movl   $0x106860,(%esp)
  1044fa:	e8 a3 bd ff ff       	call   1002a2 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1044ff:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104504:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104507:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10450a:	89 d3                	mov    %edx,%ebx
  10450c:	c1 e3 0a             	shl    $0xa,%ebx
  10450f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104512:	89 d1                	mov    %edx,%ecx
  104514:	c1 e1 0a             	shl    $0xa,%ecx
  104517:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10451a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10451e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104521:	89 54 24 10          	mov    %edx,0x10(%esp)
  104525:	89 74 24 0c          	mov    %esi,0xc(%esp)
  104529:	89 44 24 08          	mov    %eax,0x8(%esp)
  10452d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104531:	89 0c 24             	mov    %ecx,(%esp)
  104534:	e8 40 fe ff ff       	call   104379 <get_pgtable_items>
  104539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10453c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104540:	0f 85 65 ff ff ff    	jne    1044ab <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104546:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10454b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10454e:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104551:	89 54 24 14          	mov    %edx,0x14(%esp)
  104555:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104558:	89 54 24 10          	mov    %edx,0x10(%esp)
  10455c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  104560:	89 44 24 08          	mov    %eax,0x8(%esp)
  104564:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10456b:	00 
  10456c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104573:	e8 01 fe ff ff       	call   104379 <get_pgtable_items>
  104578:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10457b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10457f:	0f 85 c7 fe ff ff    	jne    10444c <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104585:	c7 04 24 84 68 10 00 	movl   $0x106884,(%esp)
  10458c:	e8 11 bd ff ff       	call   1002a2 <cprintf>
}
  104591:	90                   	nop
  104592:	83 c4 4c             	add    $0x4c,%esp
  104595:	5b                   	pop    %ebx
  104596:	5e                   	pop    %esi
  104597:	5f                   	pop    %edi
  104598:	5d                   	pop    %ebp
  104599:	c3                   	ret    

0010459a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10459a:	55                   	push   %ebp
  10459b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10459d:	8b 45 08             	mov    0x8(%ebp),%eax
  1045a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1045a3:	89 10                	mov    %edx,(%eax)
}
  1045a5:	90                   	nop
  1045a6:	5d                   	pop    %ebp
  1045a7:	c3                   	ret    

001045a8 <fixsize>:

// total 是对size进行修正后的二叉树的size大小
unsigned total;

// 如果size不是2的幂次，进行修正
static unsigned fixsize(unsigned size) {
  1045a8:	55                   	push   %ebp
  1045a9:	89 e5                	mov    %esp,%ebp
	size |= size >> 1;
  1045ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1045ae:	d1 e8                	shr    %eax
  1045b0:	09 45 08             	or     %eax,0x8(%ebp)
	size |= size >> 2;
  1045b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b6:	c1 e8 02             	shr    $0x2,%eax
  1045b9:	09 45 08             	or     %eax,0x8(%ebp)
	size |= size >> 4;
  1045bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1045bf:	c1 e8 04             	shr    $0x4,%eax
  1045c2:	09 45 08             	or     %eax,0x8(%ebp)
	size |= size >> 8;
  1045c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1045c8:	c1 e8 08             	shr    $0x8,%eax
  1045cb:	09 45 08             	or     %eax,0x8(%ebp)
	size |= size >> 16;
  1045ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1045d1:	c1 e8 10             	shr    $0x10,%eax
  1045d4:	09 45 08             	or     %eax,0x8(%ebp)
	return size+1;
  1045d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1045da:	40                   	inc    %eax
}
  1045db:	5d                   	pop    %ebp
  1045dc:	c3                   	ret    

001045dd <Buddy_init>:

static void
Buddy_init(void) {
  1045dd:	55                   	push   %ebp
  1045de:	89 e5                	mov    %esp,%ebp
    //list_init(&free_list);用不到这个树了
    nr_free = 0;
  1045e0:	c7 05 90 af 25 00 00 	movl   $0x0,0x25af90
  1045e7:	00 00 00 
}
  1045ea:	90                   	nop
  1045eb:	5d                   	pop    %ebp
  1045ec:	c3                   	ret    

001045ed <init_tree>:

//递归建树 ，对节点进行初始化
void init_tree(int root, int l, int r, struct Page *p){
  1045ed:	55                   	push   %ebp
  1045ee:	89 e5                	mov    %esp,%ebp
  1045f0:	83 ec 28             	sub    $0x28,%esp
	bu[root].left = l;
  1045f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1045f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1045f9:	89 d0                	mov    %edx,%eax
  1045fb:	c1 e0 02             	shl    $0x2,%eax
  1045fe:	01 d0                	add    %edx,%eax
  104600:	c1 e0 02             	shl    $0x2,%eax
  104603:	05 80 af 11 00       	add    $0x11af80,%eax
  104608:	89 08                	mov    %ecx,(%eax)
	bu[root].right = r;
  10460a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10460d:	8b 55 08             	mov    0x8(%ebp),%edx
  104610:	89 d0                	mov    %edx,%eax
  104612:	c1 e0 02             	shl    $0x2,%eax
  104615:	01 d0                	add    %edx,%eax
  104617:	c1 e0 02             	shl    $0x2,%eax
  10461a:	05 84 af 11 00       	add    $0x11af84,%eax
  10461f:	89 08                	mov    %ecx,(%eax)
	bu[root].longest = r-l+1;
  104621:	8b 45 10             	mov    0x10(%ebp),%eax
  104624:	2b 45 0c             	sub    0xc(%ebp),%eax
  104627:	40                   	inc    %eax
  104628:	89 c1                	mov    %eax,%ecx
  10462a:	8b 55 08             	mov    0x8(%ebp),%edx
  10462d:	89 d0                	mov    %edx,%eax
  10462f:	c1 e0 02             	shl    $0x2,%eax
  104632:	01 d0                	add    %edx,%eax
  104634:	c1 e0 02             	shl    $0x2,%eax
  104637:	05 88 af 11 00       	add    $0x11af88,%eax
  10463c:	89 08                	mov    %ecx,(%eax)
	bu[root].page = p;
  10463e:	8b 55 08             	mov    0x8(%ebp),%edx
  104641:	89 d0                	mov    %edx,%eax
  104643:	c1 e0 02             	shl    $0x2,%eax
  104646:	01 d0                	add    %edx,%eax
  104648:	c1 e0 02             	shl    $0x2,%eax
  10464b:	8d 90 90 af 11 00    	lea    0x11af90(%eax),%edx
  104651:	8b 45 14             	mov    0x14(%ebp),%eax
  104654:	89 02                	mov    %eax,(%edx)
	bu[root].free=0;
  104656:	8b 55 08             	mov    0x8(%ebp),%edx
  104659:	89 d0                	mov    %edx,%eax
  10465b:	c1 e0 02             	shl    $0x2,%eax
  10465e:	01 d0                	add    %edx,%eax
  104660:	c1 e0 02             	shl    $0x2,%eax
  104663:	05 8c af 11 00       	add    $0x11af8c,%eax
  104668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (l==r) return;
  10466e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104671:	3b 45 10             	cmp    0x10(%ebp),%eax
  104674:	74 7a                	je     1046f0 <init_tree+0x103>
	int mid=(l+r)>>1;
  104676:	8b 55 0c             	mov    0xc(%ebp),%edx
  104679:	8b 45 10             	mov    0x10(%ebp),%eax
  10467c:	01 d0                	add    %edx,%eax
  10467e:	d1 f8                	sar    %eax
  104680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	init_tree(LEFT_LEAF(root),l,mid,p);
  104683:	8b 45 08             	mov    0x8(%ebp),%eax
  104686:	01 c0                	add    %eax,%eax
  104688:	8d 50 01             	lea    0x1(%eax),%edx
  10468b:	8b 45 14             	mov    0x14(%ebp),%eax
  10468e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104695:	89 44 24 08          	mov    %eax,0x8(%esp)
  104699:	8b 45 0c             	mov    0xc(%ebp),%eax
  10469c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046a0:	89 14 24             	mov    %edx,(%esp)
  1046a3:	e8 45 ff ff ff       	call   1045ed <init_tree>
	init_tree(RIGHT_LEAF(root),mid+1,r,p+(r-l+1)/2);
  1046a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ab:	2b 45 0c             	sub    0xc(%ebp),%eax
  1046ae:	40                   	inc    %eax
  1046af:	89 c2                	mov    %eax,%edx
  1046b1:	c1 ea 1f             	shr    $0x1f,%edx
  1046b4:	01 d0                	add    %edx,%eax
  1046b6:	d1 f8                	sar    %eax
  1046b8:	89 c2                	mov    %eax,%edx
  1046ba:	89 d0                	mov    %edx,%eax
  1046bc:	c1 e0 02             	shl    $0x2,%eax
  1046bf:	01 d0                	add    %edx,%eax
  1046c1:	c1 e0 02             	shl    $0x2,%eax
  1046c4:	89 c2                	mov    %eax,%edx
  1046c6:	8b 45 14             	mov    0x14(%ebp),%eax
  1046c9:	01 d0                	add    %edx,%eax
  1046cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1046ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  1046d1:	8b 55 08             	mov    0x8(%ebp),%edx
  1046d4:	42                   	inc    %edx
  1046d5:	01 d2                	add    %edx,%edx
  1046d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046db:	8b 45 10             	mov    0x10(%ebp),%eax
  1046de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1046e6:	89 14 24             	mov    %edx,(%esp)
  1046e9:	e8 ff fe ff ff       	call   1045ed <init_tree>
  1046ee:	eb 01                	jmp    1046f1 <init_tree+0x104>
	if (l==r) return;
  1046f0:	90                   	nop
}
  1046f1:	c9                   	leave  
  1046f2:	c3                   	ret    

001046f3 <fixtree>:
// 对树进行修正，因为有一些空间是不能被分配的
void fixtree(int index,int n)
{
  1046f3:	55                   	push   %ebp
  1046f4:	89 e5                	mov    %esp,%ebp
  1046f6:	83 ec 28             	sub    $0x28,%esp
	int l = bu[index].left;
  1046f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1046fc:	89 d0                	mov    %edx,%eax
  1046fe:	c1 e0 02             	shl    $0x2,%eax
  104701:	01 d0                	add    %edx,%eax
  104703:	c1 e0 02             	shl    $0x2,%eax
  104706:	05 80 af 11 00       	add    $0x11af80,%eax
  10470b:	8b 00                	mov    (%eax),%eax
  10470d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int r = bu[index].right;
  104710:	8b 55 08             	mov    0x8(%ebp),%edx
  104713:	89 d0                	mov    %edx,%eax
  104715:	c1 e0 02             	shl    $0x2,%eax
  104718:	01 d0                	add    %edx,%eax
  10471a:	c1 e0 02             	shl    $0x2,%eax
  10471d:	05 84 af 11 00       	add    $0x11af84,%eax
  104722:	8b 00                	mov    (%eax),%eax
  104724:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int mid = (l+r)>>1;
  104727:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10472a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10472d:	01 d0                	add    %edx,%eax
  10472f:	d1 f8                	sar    %eax
  104731:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (r < n)return ;
  104734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104737:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10473a:	0f 8c b5 00 00 00    	jl     1047f5 <fixtree+0x102>
	if (l>=n)
  104740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104743:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104746:	7c 32                	jl     10477a <fixtree+0x87>
	{
		bu[index].longest=0;
  104748:	8b 55 08             	mov    0x8(%ebp),%edx
  10474b:	89 d0                	mov    %edx,%eax
  10474d:	c1 e0 02             	shl    $0x2,%eax
  104750:	01 d0                	add    %edx,%eax
  104752:	c1 e0 02             	shl    $0x2,%eax
  104755:	05 88 af 11 00       	add    $0x11af88,%eax
  10475a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		bu[index].free=1;
  104760:	8b 55 08             	mov    0x8(%ebp),%edx
  104763:	89 d0                	mov    %edx,%eax
  104765:	c1 e0 02             	shl    $0x2,%eax
  104768:	01 d0                	add    %edx,%eax
  10476a:	c1 e0 02             	shl    $0x2,%eax
  10476d:	05 8c af 11 00       	add    $0x11af8c,%eax
  104772:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		return;
  104778:	eb 7c                	jmp    1047f6 <fixtree+0x103>
	}
	fixtree(LEFT_LEAF(index),n);
  10477a:	8b 45 08             	mov    0x8(%ebp),%eax
  10477d:	01 c0                	add    %eax,%eax
  10477f:	8d 50 01             	lea    0x1(%eax),%edx
  104782:	8b 45 0c             	mov    0xc(%ebp),%eax
  104785:	89 44 24 04          	mov    %eax,0x4(%esp)
  104789:	89 14 24             	mov    %edx,(%esp)
  10478c:	e8 62 ff ff ff       	call   1046f3 <fixtree>
	fixtree(RIGHT_LEAF(index),n);
  104791:	8b 45 08             	mov    0x8(%ebp),%eax
  104794:	40                   	inc    %eax
  104795:	8d 14 00             	lea    (%eax,%eax,1),%edx
  104798:	8b 45 0c             	mov    0xc(%ebp),%eax
  10479b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10479f:	89 14 24             	mov    %edx,(%esp)
  1047a2:	e8 4c ff ff ff       	call   1046f3 <fixtree>
	bu[index].longest = MAX(bu[LEFT_LEAF(index)].longest,bu[RIGHT_LEAF(index)].longest);
  1047a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1047aa:	40                   	inc    %eax
  1047ab:	8d 14 00             	lea    (%eax,%eax,1),%edx
  1047ae:	89 d0                	mov    %edx,%eax
  1047b0:	c1 e0 02             	shl    $0x2,%eax
  1047b3:	01 d0                	add    %edx,%eax
  1047b5:	c1 e0 02             	shl    $0x2,%eax
  1047b8:	05 88 af 11 00       	add    $0x11af88,%eax
  1047bd:	8b 10                	mov    (%eax),%edx
  1047bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c2:	01 c0                	add    %eax,%eax
  1047c4:	8d 48 01             	lea    0x1(%eax),%ecx
  1047c7:	89 c8                	mov    %ecx,%eax
  1047c9:	c1 e0 02             	shl    $0x2,%eax
  1047cc:	01 c8                	add    %ecx,%eax
  1047ce:	c1 e0 02             	shl    $0x2,%eax
  1047d1:	05 88 af 11 00       	add    $0x11af88,%eax
  1047d6:	8b 00                	mov    (%eax),%eax
  1047d8:	39 c2                	cmp    %eax,%edx
  1047da:	0f 43 c2             	cmovae %edx,%eax
  1047dd:	89 c1                	mov    %eax,%ecx
  1047df:	8b 55 08             	mov    0x8(%ebp),%edx
  1047e2:	89 d0                	mov    %edx,%eax
  1047e4:	c1 e0 02             	shl    $0x2,%eax
  1047e7:	01 d0                	add    %edx,%eax
  1047e9:	c1 e0 02             	shl    $0x2,%eax
  1047ec:	05 88 af 11 00       	add    $0x11af88,%eax
  1047f1:	89 08                	mov    %ecx,(%eax)
  1047f3:	eb 01                	jmp    1047f6 <fixtree+0x103>
	if (r < n)return ;
  1047f5:	90                   	nop
}
  1047f6:	c9                   	leave  
  1047f7:	c3                   	ret    

001047f8 <Buddy_init_memmap>:

// 传入size ，这个size不一定是2的幂次，进行修正以后建二叉树，再对页进行初始化
static void
Buddy_init_memmap(struct Page *base, size_t n) {
  1047f8:	55                   	push   %ebp
  1047f9:	89 e5                	mov    %esp,%ebp
  1047fb:	83 ec 38             	sub    $0x38,%esp
	cprintf("\n----------------------------init_memap total_free_page:%d\n",n);
  1047fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  104801:	89 44 24 04          	mov    %eax,0x4(%esp)
  104805:	c7 04 24 c0 68 10 00 	movl   $0x1068c0,(%esp)
  10480c:	e8 91 ba ff ff       	call   1002a2 <cprintf>
    assert(n > 0);
  104811:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104815:	75 24                	jne    10483b <Buddy_init_memmap+0x43>
  104817:	c7 44 24 0c fc 68 10 	movl   $0x1068fc,0xc(%esp)
  10481e:	00 
  10481f:	c7 44 24 08 02 69 10 	movl   $0x106902,0x8(%esp)
  104826:	00 
  104827:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  10482e:	00 
  10482f:	c7 04 24 17 69 10 00 	movl   $0x106917,(%esp)
  104836:	e8 be bb ff ff       	call   1003f9 <__panic>
	total = fixsize(n);
  10483b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10483e:	89 04 24             	mov    %eax,(%esp)
  104841:	e8 62 fd ff ff       	call   1045a8 <fixsize>
  104846:	a3 84 af 25 00       	mov    %eax,0x25af84
	treebase = base;
  10484b:	8b 45 08             	mov    0x8(%ebp),%eax
  10484e:	a3 80 af 25 00       	mov    %eax,0x25af80
	cprintf("----------------------------tree size is :%d.\n",total);
  104853:	a1 84 af 25 00       	mov    0x25af84,%eax
  104858:	89 44 24 04          	mov    %eax,0x4(%esp)
  10485c:	c7 04 24 30 69 10 00 	movl   $0x106930,(%esp)
  104863:	e8 3a ba ff ff       	call   1002a2 <cprintf>
	init_tree(0,0,total-1,base);
  104868:	a1 84 af 25 00       	mov    0x25af84,%eax
  10486d:	48                   	dec    %eax
  10486e:	89 c2                	mov    %eax,%edx
  104870:	8b 45 08             	mov    0x8(%ebp),%eax
  104873:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104877:	89 54 24 08          	mov    %edx,0x8(%esp)
  10487b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104882:	00 
  104883:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10488a:	e8 5e fd ff ff       	call   1045ed <init_tree>
	fixtree(0,n);
  10488f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104892:	89 44 24 04          	mov    %eax,0x4(%esp)
  104896:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10489d:	e8 51 fe ff ff       	call   1046f3 <fixtree>
	struct Page *p = base;
  1048a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1048a8:	e9 94 00 00 00       	jmp    104941 <Buddy_init_memmap+0x149>
        assert(PageReserved(p));
  1048ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b0:	83 c0 04             	add    $0x4,%eax
  1048b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1048ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1048bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1048c3:	0f a3 10             	bt     %edx,(%eax)
  1048c6:	19 c0                	sbb    %eax,%eax
  1048c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1048cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1048cf:	0f 95 c0             	setne  %al
  1048d2:	0f b6 c0             	movzbl %al,%eax
  1048d5:	85 c0                	test   %eax,%eax
  1048d7:	75 24                	jne    1048fd <Buddy_init_memmap+0x105>
  1048d9:	c7 44 24 0c 5f 69 10 	movl   $0x10695f,0xc(%esp)
  1048e0:	00 
  1048e1:	c7 44 24 08 02 69 10 	movl   $0x106902,0x8(%esp)
  1048e8:	00 
  1048e9:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  1048f0:	00 
  1048f1:	c7 04 24 17 69 10 00 	movl   $0x106917,(%esp)
  1048f8:	e8 fc ba ff ff       	call   1003f9 <__panic>
        p->flags = 0;
  1048fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104900:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  104907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10490a:	83 c0 04             	add    $0x4,%eax
  10490d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  104914:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10491a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10491d:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  104920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104923:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  10492a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104931:	00 
  104932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104935:	89 04 24             	mov    %eax,(%esp)
  104938:	e8 5d fc ff ff       	call   10459a <set_page_ref>
    for (; p != base + n; p ++) {
  10493d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104941:	8b 55 0c             	mov    0xc(%ebp),%edx
  104944:	89 d0                	mov    %edx,%eax
  104946:	c1 e0 02             	shl    $0x2,%eax
  104949:	01 d0                	add    %edx,%eax
  10494b:	c1 e0 02             	shl    $0x2,%eax
  10494e:	89 c2                	mov    %eax,%edx
  104950:	8b 45 08             	mov    0x8(%ebp),%eax
  104953:	01 d0                	add    %edx,%eax
  104955:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104958:	0f 85 4f ff ff ff    	jne    1048ad <Buddy_init_memmap+0xb5>
    }
	cprintf("----------------------------init end\n\n");
  10495e:	c7 04 24 70 69 10 00 	movl   $0x106970,(%esp)
  104965:	e8 38 b9 ff ff       	call   1002a2 <cprintf>
    nr_free += n;
  10496a:	8b 15 90 af 25 00    	mov    0x25af90,%edx
  104970:	8b 45 0c             	mov    0xc(%ebp),%eax
  104973:	01 d0                	add    %edx,%eax
  104975:	a3 90 af 25 00       	mov    %eax,0x25af90
    //first block
    base->property = n;
  10497a:	8b 45 08             	mov    0x8(%ebp),%eax
  10497d:	8b 55 0c             	mov    0xc(%ebp),%edx
  104980:	89 50 08             	mov    %edx,0x8(%eax)
}
  104983:	90                   	nop
  104984:	c9                   	leave  
  104985:	c3                   	ret    

00104986 <search>:

// 通过递归 找到size大小的空闲区间，返回地址； 被alloc函数调用
struct Page * 
	search(int index,int size){
  104986:	55                   	push   %ebp
  104987:	89 e5                	mov    %esp,%ebp
  104989:	83 ec 28             	sub    $0x28,%esp
	int longest = bu[index].longest;
  10498c:	8b 55 08             	mov    0x8(%ebp),%edx
  10498f:	89 d0                	mov    %edx,%eax
  104991:	c1 e0 02             	shl    $0x2,%eax
  104994:	01 d0                	add    %edx,%eax
  104996:	c1 e0 02             	shl    $0x2,%eax
  104999:	05 88 af 11 00       	add    $0x11af88,%eax
  10499e:	8b 00                	mov    (%eax),%eax
  1049a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
	if(size>longest) return NULL;
  1049a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1049a9:	7e 0a                	jle    1049b5 <search+0x2f>
  1049ab:	b8 00 00 00 00       	mov    $0x0,%eax
  1049b0:	e9 5b 01 00 00       	jmp    104b10 <search+0x18a>
	if(bu[LEFT_LEAF(index)].longest >= size){
  1049b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1049b8:	01 c0                	add    %eax,%eax
  1049ba:	8d 50 01             	lea    0x1(%eax),%edx
  1049bd:	89 d0                	mov    %edx,%eax
  1049bf:	c1 e0 02             	shl    $0x2,%eax
  1049c2:	01 d0                	add    %edx,%eax
  1049c4:	c1 e0 02             	shl    $0x2,%eax
  1049c7:	05 88 af 11 00       	add    $0x11af88,%eax
  1049cc:	8b 10                	mov    (%eax),%edx
  1049ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049d1:	39 c2                	cmp    %eax,%edx
  1049d3:	72 6e                	jb     104a43 <search+0xbd>
		struct Page * tmp = search(LEFT_LEAF(index),size);
  1049d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1049d8:	01 c0                	add    %eax,%eax
  1049da:	8d 50 01             	lea    0x1(%eax),%edx
  1049dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049e4:	89 14 24             	mov    %edx,(%esp)
  1049e7:	e8 9a ff ff ff       	call   104986 <search>
  1049ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bu[index].longest = MAX(bu[LEFT_LEAF(index)].longest,bu[RIGHT_LEAF(index)].longest);
  1049ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1049f2:	40                   	inc    %eax
  1049f3:	8d 14 00             	lea    (%eax,%eax,1),%edx
  1049f6:	89 d0                	mov    %edx,%eax
  1049f8:	c1 e0 02             	shl    $0x2,%eax
  1049fb:	01 d0                	add    %edx,%eax
  1049fd:	c1 e0 02             	shl    $0x2,%eax
  104a00:	05 88 af 11 00       	add    $0x11af88,%eax
  104a05:	8b 10                	mov    (%eax),%edx
  104a07:	8b 45 08             	mov    0x8(%ebp),%eax
  104a0a:	01 c0                	add    %eax,%eax
  104a0c:	8d 48 01             	lea    0x1(%eax),%ecx
  104a0f:	89 c8                	mov    %ecx,%eax
  104a11:	c1 e0 02             	shl    $0x2,%eax
  104a14:	01 c8                	add    %ecx,%eax
  104a16:	c1 e0 02             	shl    $0x2,%eax
  104a19:	05 88 af 11 00       	add    $0x11af88,%eax
  104a1e:	8b 00                	mov    (%eax),%eax
  104a20:	39 c2                	cmp    %eax,%edx
  104a22:	0f 43 c2             	cmovae %edx,%eax
  104a25:	89 c1                	mov    %eax,%ecx
  104a27:	8b 55 08             	mov    0x8(%ebp),%edx
  104a2a:	89 d0                	mov    %edx,%eax
  104a2c:	c1 e0 02             	shl    $0x2,%eax
  104a2f:	01 d0                	add    %edx,%eax
  104a31:	c1 e0 02             	shl    $0x2,%eax
  104a34:	05 88 af 11 00       	add    $0x11af88,%eax
  104a39:	89 08                	mov    %ecx,(%eax)
		return tmp;
  104a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a3e:	e9 cd 00 00 00       	jmp    104b10 <search+0x18a>
	}
	if(bu[RIGHT_LEAF(index)].longest >= size){
  104a43:	8b 45 08             	mov    0x8(%ebp),%eax
  104a46:	40                   	inc    %eax
  104a47:	8d 14 00             	lea    (%eax,%eax,1),%edx
  104a4a:	89 d0                	mov    %edx,%eax
  104a4c:	c1 e0 02             	shl    $0x2,%eax
  104a4f:	01 d0                	add    %edx,%eax
  104a51:	c1 e0 02             	shl    $0x2,%eax
  104a54:	05 88 af 11 00       	add    $0x11af88,%eax
  104a59:	8b 10                	mov    (%eax),%edx
  104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  104a5e:	39 c2                	cmp    %eax,%edx
  104a60:	72 6a                	jb     104acc <search+0x146>
		struct Page * tmp = search(RIGHT_LEAF(index),size);
  104a62:	8b 45 08             	mov    0x8(%ebp),%eax
  104a65:	40                   	inc    %eax
  104a66:	8d 14 00             	lea    (%eax,%eax,1),%edx
  104a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  104a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a70:	89 14 24             	mov    %edx,(%esp)
  104a73:	e8 0e ff ff ff       	call   104986 <search>
  104a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bu[index].longest = MAX(bu[LEFT_LEAF(index)].longest,bu[RIGHT_LEAF(index)].longest);
  104a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  104a7e:	40                   	inc    %eax
  104a7f:	8d 14 00             	lea    (%eax,%eax,1),%edx
  104a82:	89 d0                	mov    %edx,%eax
  104a84:	c1 e0 02             	shl    $0x2,%eax
  104a87:	01 d0                	add    %edx,%eax
  104a89:	c1 e0 02             	shl    $0x2,%eax
  104a8c:	05 88 af 11 00       	add    $0x11af88,%eax
  104a91:	8b 10                	mov    (%eax),%edx
  104a93:	8b 45 08             	mov    0x8(%ebp),%eax
  104a96:	01 c0                	add    %eax,%eax
  104a98:	8d 48 01             	lea    0x1(%eax),%ecx
  104a9b:	89 c8                	mov    %ecx,%eax
  104a9d:	c1 e0 02             	shl    $0x2,%eax
  104aa0:	01 c8                	add    %ecx,%eax
  104aa2:	c1 e0 02             	shl    $0x2,%eax
  104aa5:	05 88 af 11 00       	add    $0x11af88,%eax
  104aaa:	8b 00                	mov    (%eax),%eax
  104aac:	39 c2                	cmp    %eax,%edx
  104aae:	0f 43 c2             	cmovae %edx,%eax
  104ab1:	89 c1                	mov    %eax,%ecx
  104ab3:	8b 55 08             	mov    0x8(%ebp),%edx
  104ab6:	89 d0                	mov    %edx,%eax
  104ab8:	c1 e0 02             	shl    $0x2,%eax
  104abb:	01 d0                	add    %edx,%eax
  104abd:	c1 e0 02             	shl    $0x2,%eax
  104ac0:	05 88 af 11 00       	add    $0x11af88,%eax
  104ac5:	89 08                	mov    %ecx,(%eax)
		return tmp;
  104ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aca:	eb 44                	jmp    104b10 <search+0x18a>
	}
	bu[index].longest = 0;
  104acc:	8b 55 08             	mov    0x8(%ebp),%edx
  104acf:	89 d0                	mov    %edx,%eax
  104ad1:	c1 e0 02             	shl    $0x2,%eax
  104ad4:	01 d0                	add    %edx,%eax
  104ad6:	c1 e0 02             	shl    $0x2,%eax
  104ad9:	05 88 af 11 00       	add    $0x11af88,%eax
  104ade:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	bu[index].free=1;
  104ae4:	8b 55 08             	mov    0x8(%ebp),%edx
  104ae7:	89 d0                	mov    %edx,%eax
  104ae9:	c1 e0 02             	shl    $0x2,%eax
  104aec:	01 d0                	add    %edx,%eax
  104aee:	c1 e0 02             	shl    $0x2,%eax
  104af1:	05 8c af 11 00       	add    $0x11af8c,%eax
  104af6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	return bu[index].page;
  104afc:	8b 55 08             	mov    0x8(%ebp),%edx
  104aff:	89 d0                	mov    %edx,%eax
  104b01:	c1 e0 02             	shl    $0x2,%eax
  104b04:	01 d0                	add    %edx,%eax
  104b06:	c1 e0 02             	shl    $0x2,%eax
  104b09:	05 90 af 11 00       	add    $0x11af90,%eax
  104b0e:	8b 00                	mov    (%eax),%eax
	}
  104b10:	c9                   	leave  
  104b11:	c3                   	ret    

00104b12 <Buddy_alloc_pages>:

// 分配空间
static struct Page *
Buddy_alloc_pages(size_t n) {
  104b12:	55                   	push   %ebp
  104b13:	89 e5                	mov    %esp,%ebp
  104b15:	83 ec 28             	sub    $0x28,%esp
	
    assert(n > 0);
  104b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104b1c:	75 24                	jne    104b42 <Buddy_alloc_pages+0x30>
  104b1e:	c7 44 24 0c fc 68 10 	movl   $0x1068fc,0xc(%esp)
  104b25:	00 
  104b26:	c7 44 24 08 02 69 10 	movl   $0x106902,0x8(%esp)
  104b2d:	00 
  104b2e:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  104b35:	00 
  104b36:	c7 04 24 17 69 10 00 	movl   $0x106917,(%esp)
  104b3d:	e8 b7 b8 ff ff       	call   1003f9 <__panic>
    if (n > nr_free) {
  104b42:	a1 90 af 25 00       	mov    0x25af90,%eax
  104b47:	39 45 08             	cmp    %eax,0x8(%ebp)
  104b4a:	76 0a                	jbe    104b56 <Buddy_alloc_pages+0x44>
        return NULL;
  104b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  104b51:	e9 8b 00 00 00       	jmp    104be1 <Buddy_alloc_pages+0xcf>
    }
	struct Page * start =  search(0,n);
  104b56:	8b 45 08             	mov    0x8(%ebp),%eax
  104b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b64:	e8 1d fe ff ff       	call   104986 <search>
  104b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(start == NULL) return NULL;
  104b6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b70:	75 07                	jne    104b79 <Buddy_alloc_pages+0x67>
  104b72:	b8 00 00 00 00       	mov    $0x0,%eax
  104b77:	eb 68                	jmp    104be1 <Buddy_alloc_pages+0xcf>
	int i;
	for(i = 0; i < n; i++){
  104b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104b80:	eb 2d                	jmp    104baf <Buddy_alloc_pages+0x9d>
		SetPageReserved(start+i);
  104b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b85:	89 d0                	mov    %edx,%eax
  104b87:	c1 e0 02             	shl    $0x2,%eax
  104b8a:	01 d0                	add    %edx,%eax
  104b8c:	c1 e0 02             	shl    $0x2,%eax
  104b8f:	89 c2                	mov    %eax,%edx
  104b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b94:	01 d0                	add    %edx,%eax
  104b96:	83 c0 04             	add    $0x4,%eax
  104b99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104ba0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ba6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104ba9:	0f ab 10             	bts    %edx,(%eax)
	for(i = 0; i < n; i++){
  104bac:	ff 45 f4             	incl   -0xc(%ebp)
  104baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bb2:	39 45 08             	cmp    %eax,0x8(%ebp)
  104bb5:	77 cb                	ja     104b82 <Buddy_alloc_pages+0x70>
	}
	nr_free -= n;
  104bb7:	a1 90 af 25 00       	mov    0x25af90,%eax
  104bbc:	2b 45 08             	sub    0x8(%ebp),%eax
  104bbf:	a3 90 af 25 00       	mov    %eax,0x25af90
	//cprintf("----alloc pages:%d %x\n",n,start);
	//if (n>1)
	cprintf("----alloc pages:%d %x\n",n,start);
  104bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  104bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  104bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bd2:	c7 04 24 97 69 10 00 	movl   $0x106997,(%esp)
  104bd9:	e8 c4 b6 ff ff       	call   1002a2 <cprintf>
	return start;
  104bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
    
}
  104be1:	c9                   	leave  
  104be2:	c3                   	ret    

00104be3 <freetree>:

// 通过递归，查找相应位置，释放空间  free_pages函数调用
void freetree(int index, int pos, int size){
  104be3:	55                   	push   %ebp
  104be4:	89 e5                	mov    %esp,%ebp
  104be6:	83 ec 38             	sub    $0x38,%esp
	int l = bu[index].left;
  104be9:	8b 55 08             	mov    0x8(%ebp),%edx
  104bec:	89 d0                	mov    %edx,%eax
  104bee:	c1 e0 02             	shl    $0x2,%eax
  104bf1:	01 d0                	add    %edx,%eax
  104bf3:	c1 e0 02             	shl    $0x2,%eax
  104bf6:	05 80 af 11 00       	add    $0x11af80,%eax
  104bfb:	8b 00                	mov    (%eax),%eax
  104bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int r = bu[index].right;
  104c00:	8b 55 08             	mov    0x8(%ebp),%edx
  104c03:	89 d0                	mov    %edx,%eax
  104c05:	c1 e0 02             	shl    $0x2,%eax
  104c08:	01 d0                	add    %edx,%eax
  104c0a:	c1 e0 02             	shl    $0x2,%eax
  104c0d:	05 84 af 11 00       	add    $0x11af84,%eax
  104c12:	8b 00                	mov    (%eax),%eax
  104c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int longest = bu[index].longest;
  104c17:	8b 55 08             	mov    0x8(%ebp),%edx
  104c1a:	89 d0                	mov    %edx,%eax
  104c1c:	c1 e0 02             	shl    $0x2,%eax
  104c1f:	01 d0                	add    %edx,%eax
  104c21:	c1 e0 02             	shl    $0x2,%eax
  104c24:	05 88 af 11 00       	add    $0x11af88,%eax
  104c29:	8b 00                	mov    (%eax),%eax
  104c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	bool free =bu[index].free;
  104c2e:	8b 55 08             	mov    0x8(%ebp),%edx
  104c31:	89 d0                	mov    %edx,%eax
  104c33:	c1 e0 02             	shl    $0x2,%eax
  104c36:	01 d0                	add    %edx,%eax
  104c38:	c1 e0 02             	shl    $0x2,%eax
  104c3b:	05 8c af 11 00       	add    $0x11af8c,%eax
  104c40:	8b 00                	mov    (%eax),%eax
  104c42:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (free==1)
  104c45:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  104c49:	75 3a                	jne    104c85 <freetree+0xa2>
	{
		bu[index].longest=r-l+1;
  104c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c4e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  104c51:	40                   	inc    %eax
  104c52:	89 c1                	mov    %eax,%ecx
  104c54:	8b 55 08             	mov    0x8(%ebp),%edx
  104c57:	89 d0                	mov    %edx,%eax
  104c59:	c1 e0 02             	shl    $0x2,%eax
  104c5c:	01 d0                	add    %edx,%eax
  104c5e:	c1 e0 02             	shl    $0x2,%eax
  104c61:	05 88 af 11 00       	add    $0x11af88,%eax
  104c66:	89 08                	mov    %ecx,(%eax)
		bu[index].free=0;
  104c68:	8b 55 08             	mov    0x8(%ebp),%edx
  104c6b:	89 d0                	mov    %edx,%eax
  104c6d:	c1 e0 02             	shl    $0x2,%eax
  104c70:	01 d0                	add    %edx,%eax
  104c72:	c1 e0 02             	shl    $0x2,%eax
  104c75:	05 8c af 11 00       	add    $0x11af8c,%eax
  104c7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return;
  104c80:	e9 db 00 00 00       	jmp    104d60 <freetree+0x17d>
	}
	int mid=(l+r)>>1;
  104c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c8b:	01 d0                	add    %edx,%eax
  104c8d:	d1 f8                	sar    %eax
  104c8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (mid>=pos) freetree(LEFT_LEAF(index),pos,size);
  104c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c95:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104c98:	7c 20                	jl     104cba <freetree+0xd7>
  104c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  104c9d:	01 c0                	add    %eax,%eax
  104c9f:	8d 50 01             	lea    0x1(%eax),%edx
  104ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  104ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
  104ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  104cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cb0:	89 14 24             	mov    %edx,(%esp)
  104cb3:	e8 2b ff ff ff       	call   104be3 <freetree>
  104cb8:	eb 1d                	jmp    104cd7 <freetree+0xf4>
	else
		freetree(RIGHT_LEAF(index),pos,size);
  104cba:	8b 45 08             	mov    0x8(%ebp),%eax
  104cbd:	40                   	inc    %eax
  104cbe:	8d 14 00             	lea    (%eax,%eax,1),%edx
  104cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  104cc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  104cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  104ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ccf:	89 14 24             	mov    %edx,(%esp)
  104cd2:	e8 0c ff ff ff       	call   104be3 <freetree>
	int l1 = bu[LEFT_LEAF(index)].longest;
  104cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  104cda:	01 c0                	add    %eax,%eax
  104cdc:	8d 50 01             	lea    0x1(%eax),%edx
  104cdf:	89 d0                	mov    %edx,%eax
  104ce1:	c1 e0 02             	shl    $0x2,%eax
  104ce4:	01 d0                	add    %edx,%eax
  104ce6:	c1 e0 02             	shl    $0x2,%eax
  104ce9:	05 88 af 11 00       	add    $0x11af88,%eax
  104cee:	8b 00                	mov    (%eax),%eax
  104cf0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int r1 = bu[RIGHT_LEAF(index)].longest;
  104cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  104cf6:	40                   	inc    %eax
  104cf7:	8d 14 00             	lea    (%eax,%eax,1),%edx
  104cfa:	89 d0                	mov    %edx,%eax
  104cfc:	c1 e0 02             	shl    $0x2,%eax
  104cff:	01 d0                	add    %edx,%eax
  104d01:	c1 e0 02             	shl    $0x2,%eax
  104d04:	05 88 af 11 00       	add    $0x11af88,%eax
  104d09:	8b 00                	mov    (%eax),%eax
  104d0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	//cprintf("%d,%d,%d\n",l1,r1,r-l+1);
	if (l1+r1==r-l+1) bu[index].longest =r-l+1;
  104d0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104d11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d14:	01 c2                	add    %eax,%edx
  104d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d19:	2b 45 f4             	sub    -0xc(%ebp),%eax
  104d1c:	40                   	inc    %eax
  104d1d:	39 c2                	cmp    %eax,%edx
  104d1f:	75 1f                	jne    104d40 <freetree+0x15d>
  104d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d24:	2b 45 f4             	sub    -0xc(%ebp),%eax
  104d27:	40                   	inc    %eax
  104d28:	89 c1                	mov    %eax,%ecx
  104d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  104d2d:	89 d0                	mov    %edx,%eax
  104d2f:	c1 e0 02             	shl    $0x2,%eax
  104d32:	01 d0                	add    %edx,%eax
  104d34:	c1 e0 02             	shl    $0x2,%eax
  104d37:	05 88 af 11 00       	add    $0x11af88,%eax
  104d3c:	89 08                	mov    %ecx,(%eax)
  104d3e:	eb 20                	jmp    104d60 <freetree+0x17d>
	else
		bu[index].longest = MAX(l1,r1);
  104d40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d43:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104d46:	0f 4d 45 dc          	cmovge -0x24(%ebp),%eax
  104d4a:	89 c1                	mov    %eax,%ecx
  104d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  104d4f:	89 d0                	mov    %edx,%eax
  104d51:	c1 e0 02             	shl    $0x2,%eax
  104d54:	01 d0                	add    %edx,%eax
  104d56:	c1 e0 02             	shl    $0x2,%eax
  104d59:	05 88 af 11 00       	add    $0x11af88,%eax
  104d5e:	89 08                	mov    %ecx,(%eax)
}
  104d60:	c9                   	leave  
  104d61:	c3                   	ret    

00104d62 <Buddy_free_pages>:

// 释放空间 
static void
Buddy_free_pages(struct Page *base, size_t n) {
  104d62:	55                   	push   %ebp
  104d63:	89 e5                	mov    %esp,%ebp
  104d65:	83 ec 28             	sub    $0x28,%esp
	cprintf("----free pages:%d %x\n",n,base,nr_free);
  104d68:	a1 90 af 25 00       	mov    0x25af90,%eax
  104d6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d71:	8b 45 08             	mov    0x8(%ebp),%eax
  104d74:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  104d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d7f:	c7 04 24 ae 69 10 00 	movl   $0x1069ae,(%esp)
  104d86:	e8 17 b5 ff ff       	call   1002a2 <cprintf>
    assert(n > 0);
  104d8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104d8f:	75 24                	jne    104db5 <Buddy_free_pages+0x53>
  104d91:	c7 44 24 0c fc 68 10 	movl   $0x1068fc,0xc(%esp)
  104d98:	00 
  104d99:	c7 44 24 08 02 69 10 	movl   $0x106902,0x8(%esp)
  104da0:	00 
  104da1:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  104da8:	00 
  104da9:	c7 04 24 17 69 10 00 	movl   $0x106917,(%esp)
  104db0:	e8 44 b6 ff ff       	call   1003f9 <__panic>
    assert(PageReserved(base));
  104db5:	8b 45 08             	mov    0x8(%ebp),%eax
  104db8:	83 c0 04             	add    $0x4,%eax
  104dbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104dc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104dcb:	0f a3 10             	bt     %edx,(%eax)
  104dce:	19 c0                	sbb    %eax,%eax
  104dd0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104dd3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104dd7:	0f 95 c0             	setne  %al
  104dda:	0f b6 c0             	movzbl %al,%eax
  104ddd:	85 c0                	test   %eax,%eax
  104ddf:	75 24                	jne    104e05 <Buddy_free_pages+0xa3>
  104de1:	c7 44 24 0c c4 69 10 	movl   $0x1069c4,0xc(%esp)
  104de8:	00 
  104de9:	c7 44 24 08 02 69 10 	movl   $0x106902,0x8(%esp)
  104df0:	00 
  104df1:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  104df8:	00 
  104df9:	c7 04 24 17 69 10 00 	movl   $0x106917,(%esp)
  104e00:	e8 f4 b5 ff ff       	call   1003f9 <__panic>
	int tmp = base - treebase;
  104e05:	8b 45 08             	mov    0x8(%ebp),%eax
  104e08:	8b 15 80 af 25 00    	mov    0x25af80,%edx
  104e0e:	29 d0                	sub    %edx,%eax
  104e10:	c1 f8 02             	sar    $0x2,%eax
  104e13:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  104e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//cprintf("tmp:%d\n",tmp);
	freetree(0,tmp,n);
  104e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  104e1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e26:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104e31:	e8 ad fd ff ff       	call   104be3 <freetree>
	set_page_ref(base, 0);
  104e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104e3d:	00 
  104e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  104e41:	89 04 24             	mov    %eax,(%esp)
  104e44:	e8 51 f7 ff ff       	call   10459a <set_page_ref>
    nr_free += n;
  104e49:	8b 15 90 af 25 00    	mov    0x25af90,%edx
  104e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104e52:	01 d0                	add    %edx,%eax
  104e54:	a3 90 af 25 00       	mov    %eax,0x25af90
    return ;
  104e59:	90                   	nop
}
  104e5a:	c9                   	leave  
  104e5b:	c3                   	ret    

00104e5c <Buddy_nr_free_pages>:

static size_t
Buddy_nr_free_pages(void) {
  104e5c:	55                   	push   %ebp
  104e5d:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104e5f:	a1 90 af 25 00       	mov    0x25af90,%eax
}
  104e64:	5d                   	pop    %ebp
  104e65:	c3                   	ret    

00104e66 <showpage_tree>:

// 输出树的信息
static void showpage_tree(int index)
{
  104e66:	55                   	push   %ebp
  104e67:	89 e5                	mov    %esp,%ebp
  104e69:	83 ec 28             	sub    $0x28,%esp
	int l = bu[index].left;
  104e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  104e6f:	89 d0                	mov    %edx,%eax
  104e71:	c1 e0 02             	shl    $0x2,%eax
  104e74:	01 d0                	add    %edx,%eax
  104e76:	c1 e0 02             	shl    $0x2,%eax
  104e79:	05 80 af 11 00       	add    $0x11af80,%eax
  104e7e:	8b 00                	mov    (%eax),%eax
  104e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int r = bu[index].right;
  104e83:	8b 55 08             	mov    0x8(%ebp),%edx
  104e86:	89 d0                	mov    %edx,%eax
  104e88:	c1 e0 02             	shl    $0x2,%eax
  104e8b:	01 d0                	add    %edx,%eax
  104e8d:	c1 e0 02             	shl    $0x2,%eax
  104e90:	05 84 af 11 00       	add    $0x11af84,%eax
  104e95:	8b 00                	mov    (%eax),%eax
  104e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int longest = bu[index].longest;
  104e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  104e9d:	89 d0                	mov    %edx,%eax
  104e9f:	c1 e0 02             	shl    $0x2,%eax
  104ea2:	01 d0                	add    %edx,%eax
  104ea4:	c1 e0 02             	shl    $0x2,%eax
  104ea7:	05 88 af 11 00       	add    $0x11af88,%eax
  104eac:	8b 00                	mov    (%eax),%eax
  104eae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	bool free=bu[index].free;
  104eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  104eb4:	89 d0                	mov    %edx,%eax
  104eb6:	c1 e0 02             	shl    $0x2,%eax
  104eb9:	01 d0                	add    %edx,%eax
  104ebb:	c1 e0 02             	shl    $0x2,%eax
  104ebe:	05 8c af 11 00       	add    $0x11af8c,%eax
  104ec3:	8b 00                	mov    (%eax),%eax
  104ec5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (r-l+1==longest)
  104ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ecb:	2b 45 f4             	sub    -0xc(%ebp),%eax
  104ece:	40                   	inc    %eax
  104ecf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104ed2:	75 23                	jne    104ef7 <showpage_tree+0x91>
	{
		cprintf("[%d,%d] is free, longest =%d\n",l,r,longest);
  104ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ed7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ede:	89 44 24 08          	mov    %eax,0x8(%esp)
  104ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ee9:	c7 04 24 d7 69 10 00 	movl   $0x1069d7,(%esp)
  104ef0:	e8 ad b3 ff ff       	call   1002a2 <cprintf>
		return;
  104ef5:	eb 49                	jmp    104f40 <showpage_tree+0xda>
	}
	if (free==1)
  104ef7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  104efb:	75 27                	jne    104f24 <showpage_tree+0xbe>
	{
		cprintf("[%d,%d] is reserved, longest =%d\n",l,r,r-l+1);
  104efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f00:	2b 45 f4             	sub    -0xc(%ebp),%eax
  104f03:	40                   	inc    %eax
  104f04:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f12:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f16:	c7 04 24 f8 69 10 00 	movl   $0x1069f8,(%esp)
  104f1d:	e8 80 b3 ff ff       	call   1002a2 <cprintf>
		return;
  104f22:	eb 1c                	jmp    104f40 <showpage_tree+0xda>
	}
	showpage_tree(LEFT_LEAF(index));
  104f24:	8b 45 08             	mov    0x8(%ebp),%eax
  104f27:	01 c0                	add    %eax,%eax
  104f29:	40                   	inc    %eax
  104f2a:	89 04 24             	mov    %eax,(%esp)
  104f2d:	e8 34 ff ff ff       	call   104e66 <showpage_tree>
	showpage_tree(RIGHT_LEAF(index));
  104f32:	8b 45 08             	mov    0x8(%ebp),%eax
  104f35:	40                   	inc    %eax
  104f36:	01 c0                	add    %eax,%eax
  104f38:	89 04 24             	mov    %eax,(%esp)
  104f3b:	e8 26 ff ff ff       	call   104e66 <showpage_tree>
		
}
  104f40:	c9                   	leave  
  104f41:	c3                   	ret    

00104f42 <showpage>:
static void showpage()
{
  104f42:	55                   	push   %ebp
  104f43:	89 e5                	mov    %esp,%ebp
  104f45:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n------------------\n");
  104f48:	c7 04 24 1a 6a 10 00 	movl   $0x106a1a,(%esp)
  104f4f:	e8 4e b3 ff ff       	call   1002a2 <cprintf>
	showpage_tree(0);
  104f54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f5b:	e8 06 ff ff ff       	call   104e66 <showpage_tree>
	cprintf("------------------\n\n");
  104f60:	c7 04 24 2f 6a 10 00 	movl   $0x106a2f,(%esp)
  104f67:	e8 36 b3 ff ff       	call   1002a2 <cprintf>
	
}
  104f6c:	90                   	nop
  104f6d:	c9                   	leave  
  104f6e:	c3                   	ret    

00104f6f <Buddy_check>:
static void
Buddy_check(void) {
  104f6f:	55                   	push   %ebp
  104f70:	89 e5                	mov    %esp,%ebp
  104f72:	83 ec 28             	sub    $0x28,%esp
	showpage();
  104f75:	e8 c8 ff ff ff       	call   104f42 <showpage>
	struct Page *p0 = alloc_pages(5);
  104f7a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104f81:	e8 66 df ff ff       	call   102eec <alloc_pages>
  104f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct Page *p1 = alloc_pages(120);
  104f89:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  104f90:	e8 57 df ff ff       	call   102eec <alloc_pages>
  104f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct Page *p2 = alloc_pages(100);
  104f98:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  104f9f:	e8 48 df ff ff       	call   102eec <alloc_pages>
  104fa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	showpage();
  104fa7:	e8 96 ff ff ff       	call   104f42 <showpage>
	free_pages(p1,120);
  104fac:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  104fb3:	00 
  104fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fb7:	89 04 24             	mov    %eax,(%esp)
  104fba:	e8 65 df ff ff       	call   102f24 <free_pages>
	free_pages(p2,100);
  104fbf:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  104fc6:	00 
  104fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fca:	89 04 24             	mov    %eax,(%esp)
  104fcd:	e8 52 df ff ff       	call   102f24 <free_pages>
	showpage();
  104fd2:	e8 6b ff ff ff       	call   104f42 <showpage>
	struct Page *p3 = alloc_pages(5000);
  104fd7:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
  104fde:	e8 09 df ff ff       	call   102eec <alloc_pages>
  104fe3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	showpage();
  104fe6:	e8 57 ff ff ff       	call   104f42 <showpage>
	free_pages(p0,5);
  104feb:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  104ff2:	00 
  104ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ff6:	89 04 24             	mov    %eax,(%esp)
  104ff9:	e8 26 df ff ff       	call   102f24 <free_pages>
    showpage();
  104ffe:	e8 3f ff ff ff       	call   104f42 <showpage>
	free_pages(p3,5000);
  105003:	c7 44 24 04 88 13 00 	movl   $0x1388,0x4(%esp)
  10500a:	00 
  10500b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10500e:	89 04 24             	mov    %eax,(%esp)
  105011:	e8 0e df ff ff       	call   102f24 <free_pages>
	showpage();
  105016:	e8 27 ff ff ff       	call   104f42 <showpage>
}
  10501b:	90                   	nop
  10501c:	c9                   	leave  
  10501d:	c3                   	ret    

0010501e <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10501e:	55                   	push   %ebp
  10501f:	89 e5                	mov    %esp,%ebp
  105021:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105024:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10502b:	eb 03                	jmp    105030 <strlen+0x12>
        cnt ++;
  10502d:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105030:	8b 45 08             	mov    0x8(%ebp),%eax
  105033:	8d 50 01             	lea    0x1(%eax),%edx
  105036:	89 55 08             	mov    %edx,0x8(%ebp)
  105039:	0f b6 00             	movzbl (%eax),%eax
  10503c:	84 c0                	test   %al,%al
  10503e:	75 ed                	jne    10502d <strlen+0xf>
    }
    return cnt;
  105040:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105043:	c9                   	leave  
  105044:	c3                   	ret    

00105045 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105045:	55                   	push   %ebp
  105046:	89 e5                	mov    %esp,%ebp
  105048:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10504b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105052:	eb 03                	jmp    105057 <strnlen+0x12>
        cnt ++;
  105054:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10505a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10505d:	73 10                	jae    10506f <strnlen+0x2a>
  10505f:	8b 45 08             	mov    0x8(%ebp),%eax
  105062:	8d 50 01             	lea    0x1(%eax),%edx
  105065:	89 55 08             	mov    %edx,0x8(%ebp)
  105068:	0f b6 00             	movzbl (%eax),%eax
  10506b:	84 c0                	test   %al,%al
  10506d:	75 e5                	jne    105054 <strnlen+0xf>
    }
    return cnt;
  10506f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105072:	c9                   	leave  
  105073:	c3                   	ret    

00105074 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105074:	55                   	push   %ebp
  105075:	89 e5                	mov    %esp,%ebp
  105077:	57                   	push   %edi
  105078:	56                   	push   %esi
  105079:	83 ec 20             	sub    $0x20,%esp
  10507c:	8b 45 08             	mov    0x8(%ebp),%eax
  10507f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105082:	8b 45 0c             	mov    0xc(%ebp),%eax
  105085:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105088:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10508b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10508e:	89 d1                	mov    %edx,%ecx
  105090:	89 c2                	mov    %eax,%edx
  105092:	89 ce                	mov    %ecx,%esi
  105094:	89 d7                	mov    %edx,%edi
  105096:	ac                   	lods   %ds:(%esi),%al
  105097:	aa                   	stos   %al,%es:(%edi)
  105098:	84 c0                	test   %al,%al
  10509a:	75 fa                	jne    105096 <strcpy+0x22>
  10509c:	89 fa                	mov    %edi,%edx
  10509e:	89 f1                	mov    %esi,%ecx
  1050a0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1050a3:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1050a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1050a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1050ac:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1050ad:	83 c4 20             	add    $0x20,%esp
  1050b0:	5e                   	pop    %esi
  1050b1:	5f                   	pop    %edi
  1050b2:	5d                   	pop    %ebp
  1050b3:	c3                   	ret    

001050b4 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1050b4:	55                   	push   %ebp
  1050b5:	89 e5                	mov    %esp,%ebp
  1050b7:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1050ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1050bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1050c0:	eb 1e                	jmp    1050e0 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  1050c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050c5:	0f b6 10             	movzbl (%eax),%edx
  1050c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1050cb:	88 10                	mov    %dl,(%eax)
  1050cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1050d0:	0f b6 00             	movzbl (%eax),%eax
  1050d3:	84 c0                	test   %al,%al
  1050d5:	74 03                	je     1050da <strncpy+0x26>
            src ++;
  1050d7:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1050da:	ff 45 fc             	incl   -0x4(%ebp)
  1050dd:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1050e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1050e4:	75 dc                	jne    1050c2 <strncpy+0xe>
    }
    return dst;
  1050e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1050e9:	c9                   	leave  
  1050ea:	c3                   	ret    

001050eb <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1050eb:	55                   	push   %ebp
  1050ec:	89 e5                	mov    %esp,%ebp
  1050ee:	57                   	push   %edi
  1050ef:	56                   	push   %esi
  1050f0:	83 ec 20             	sub    $0x20,%esp
  1050f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1050f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1050f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1050ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105105:	89 d1                	mov    %edx,%ecx
  105107:	89 c2                	mov    %eax,%edx
  105109:	89 ce                	mov    %ecx,%esi
  10510b:	89 d7                	mov    %edx,%edi
  10510d:	ac                   	lods   %ds:(%esi),%al
  10510e:	ae                   	scas   %es:(%edi),%al
  10510f:	75 08                	jne    105119 <strcmp+0x2e>
  105111:	84 c0                	test   %al,%al
  105113:	75 f8                	jne    10510d <strcmp+0x22>
  105115:	31 c0                	xor    %eax,%eax
  105117:	eb 04                	jmp    10511d <strcmp+0x32>
  105119:	19 c0                	sbb    %eax,%eax
  10511b:	0c 01                	or     $0x1,%al
  10511d:	89 fa                	mov    %edi,%edx
  10511f:	89 f1                	mov    %esi,%ecx
  105121:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105124:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105127:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  10512a:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  10512d:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10512e:	83 c4 20             	add    $0x20,%esp
  105131:	5e                   	pop    %esi
  105132:	5f                   	pop    %edi
  105133:	5d                   	pop    %ebp
  105134:	c3                   	ret    

00105135 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105135:	55                   	push   %ebp
  105136:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105138:	eb 09                	jmp    105143 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  10513a:	ff 4d 10             	decl   0x10(%ebp)
  10513d:	ff 45 08             	incl   0x8(%ebp)
  105140:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105143:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105147:	74 1a                	je     105163 <strncmp+0x2e>
  105149:	8b 45 08             	mov    0x8(%ebp),%eax
  10514c:	0f b6 00             	movzbl (%eax),%eax
  10514f:	84 c0                	test   %al,%al
  105151:	74 10                	je     105163 <strncmp+0x2e>
  105153:	8b 45 08             	mov    0x8(%ebp),%eax
  105156:	0f b6 10             	movzbl (%eax),%edx
  105159:	8b 45 0c             	mov    0xc(%ebp),%eax
  10515c:	0f b6 00             	movzbl (%eax),%eax
  10515f:	38 c2                	cmp    %al,%dl
  105161:	74 d7                	je     10513a <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105163:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105167:	74 18                	je     105181 <strncmp+0x4c>
  105169:	8b 45 08             	mov    0x8(%ebp),%eax
  10516c:	0f b6 00             	movzbl (%eax),%eax
  10516f:	0f b6 d0             	movzbl %al,%edx
  105172:	8b 45 0c             	mov    0xc(%ebp),%eax
  105175:	0f b6 00             	movzbl (%eax),%eax
  105178:	0f b6 c0             	movzbl %al,%eax
  10517b:	29 c2                	sub    %eax,%edx
  10517d:	89 d0                	mov    %edx,%eax
  10517f:	eb 05                	jmp    105186 <strncmp+0x51>
  105181:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105186:	5d                   	pop    %ebp
  105187:	c3                   	ret    

00105188 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105188:	55                   	push   %ebp
  105189:	89 e5                	mov    %esp,%ebp
  10518b:	83 ec 04             	sub    $0x4,%esp
  10518e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105191:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105194:	eb 13                	jmp    1051a9 <strchr+0x21>
        if (*s == c) {
  105196:	8b 45 08             	mov    0x8(%ebp),%eax
  105199:	0f b6 00             	movzbl (%eax),%eax
  10519c:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10519f:	75 05                	jne    1051a6 <strchr+0x1e>
            return (char *)s;
  1051a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1051a4:	eb 12                	jmp    1051b8 <strchr+0x30>
        }
        s ++;
  1051a6:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1051a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1051ac:	0f b6 00             	movzbl (%eax),%eax
  1051af:	84 c0                	test   %al,%al
  1051b1:	75 e3                	jne    105196 <strchr+0xe>
    }
    return NULL;
  1051b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1051b8:	c9                   	leave  
  1051b9:	c3                   	ret    

001051ba <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1051ba:	55                   	push   %ebp
  1051bb:	89 e5                	mov    %esp,%ebp
  1051bd:	83 ec 04             	sub    $0x4,%esp
  1051c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051c3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1051c6:	eb 0e                	jmp    1051d6 <strfind+0x1c>
        if (*s == c) {
  1051c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1051cb:	0f b6 00             	movzbl (%eax),%eax
  1051ce:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1051d1:	74 0f                	je     1051e2 <strfind+0x28>
            break;
        }
        s ++;
  1051d3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1051d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1051d9:	0f b6 00             	movzbl (%eax),%eax
  1051dc:	84 c0                	test   %al,%al
  1051de:	75 e8                	jne    1051c8 <strfind+0xe>
  1051e0:	eb 01                	jmp    1051e3 <strfind+0x29>
            break;
  1051e2:	90                   	nop
    }
    return (char *)s;
  1051e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1051e6:	c9                   	leave  
  1051e7:	c3                   	ret    

001051e8 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1051e8:	55                   	push   %ebp
  1051e9:	89 e5                	mov    %esp,%ebp
  1051eb:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1051ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1051f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1051fc:	eb 03                	jmp    105201 <strtol+0x19>
        s ++;
  1051fe:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105201:	8b 45 08             	mov    0x8(%ebp),%eax
  105204:	0f b6 00             	movzbl (%eax),%eax
  105207:	3c 20                	cmp    $0x20,%al
  105209:	74 f3                	je     1051fe <strtol+0x16>
  10520b:	8b 45 08             	mov    0x8(%ebp),%eax
  10520e:	0f b6 00             	movzbl (%eax),%eax
  105211:	3c 09                	cmp    $0x9,%al
  105213:	74 e9                	je     1051fe <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105215:	8b 45 08             	mov    0x8(%ebp),%eax
  105218:	0f b6 00             	movzbl (%eax),%eax
  10521b:	3c 2b                	cmp    $0x2b,%al
  10521d:	75 05                	jne    105224 <strtol+0x3c>
        s ++;
  10521f:	ff 45 08             	incl   0x8(%ebp)
  105222:	eb 14                	jmp    105238 <strtol+0x50>
    }
    else if (*s == '-') {
  105224:	8b 45 08             	mov    0x8(%ebp),%eax
  105227:	0f b6 00             	movzbl (%eax),%eax
  10522a:	3c 2d                	cmp    $0x2d,%al
  10522c:	75 0a                	jne    105238 <strtol+0x50>
        s ++, neg = 1;
  10522e:	ff 45 08             	incl   0x8(%ebp)
  105231:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105238:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10523c:	74 06                	je     105244 <strtol+0x5c>
  10523e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105242:	75 22                	jne    105266 <strtol+0x7e>
  105244:	8b 45 08             	mov    0x8(%ebp),%eax
  105247:	0f b6 00             	movzbl (%eax),%eax
  10524a:	3c 30                	cmp    $0x30,%al
  10524c:	75 18                	jne    105266 <strtol+0x7e>
  10524e:	8b 45 08             	mov    0x8(%ebp),%eax
  105251:	40                   	inc    %eax
  105252:	0f b6 00             	movzbl (%eax),%eax
  105255:	3c 78                	cmp    $0x78,%al
  105257:	75 0d                	jne    105266 <strtol+0x7e>
        s += 2, base = 16;
  105259:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10525d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105264:	eb 29                	jmp    10528f <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105266:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10526a:	75 16                	jne    105282 <strtol+0x9a>
  10526c:	8b 45 08             	mov    0x8(%ebp),%eax
  10526f:	0f b6 00             	movzbl (%eax),%eax
  105272:	3c 30                	cmp    $0x30,%al
  105274:	75 0c                	jne    105282 <strtol+0x9a>
        s ++, base = 8;
  105276:	ff 45 08             	incl   0x8(%ebp)
  105279:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105280:	eb 0d                	jmp    10528f <strtol+0xa7>
    }
    else if (base == 0) {
  105282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105286:	75 07                	jne    10528f <strtol+0xa7>
        base = 10;
  105288:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10528f:	8b 45 08             	mov    0x8(%ebp),%eax
  105292:	0f b6 00             	movzbl (%eax),%eax
  105295:	3c 2f                	cmp    $0x2f,%al
  105297:	7e 1b                	jle    1052b4 <strtol+0xcc>
  105299:	8b 45 08             	mov    0x8(%ebp),%eax
  10529c:	0f b6 00             	movzbl (%eax),%eax
  10529f:	3c 39                	cmp    $0x39,%al
  1052a1:	7f 11                	jg     1052b4 <strtol+0xcc>
            dig = *s - '0';
  1052a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1052a6:	0f b6 00             	movzbl (%eax),%eax
  1052a9:	0f be c0             	movsbl %al,%eax
  1052ac:	83 e8 30             	sub    $0x30,%eax
  1052af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1052b2:	eb 48                	jmp    1052fc <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1052b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1052b7:	0f b6 00             	movzbl (%eax),%eax
  1052ba:	3c 60                	cmp    $0x60,%al
  1052bc:	7e 1b                	jle    1052d9 <strtol+0xf1>
  1052be:	8b 45 08             	mov    0x8(%ebp),%eax
  1052c1:	0f b6 00             	movzbl (%eax),%eax
  1052c4:	3c 7a                	cmp    $0x7a,%al
  1052c6:	7f 11                	jg     1052d9 <strtol+0xf1>
            dig = *s - 'a' + 10;
  1052c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1052cb:	0f b6 00             	movzbl (%eax),%eax
  1052ce:	0f be c0             	movsbl %al,%eax
  1052d1:	83 e8 57             	sub    $0x57,%eax
  1052d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1052d7:	eb 23                	jmp    1052fc <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1052d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1052dc:	0f b6 00             	movzbl (%eax),%eax
  1052df:	3c 40                	cmp    $0x40,%al
  1052e1:	7e 3b                	jle    10531e <strtol+0x136>
  1052e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1052e6:	0f b6 00             	movzbl (%eax),%eax
  1052e9:	3c 5a                	cmp    $0x5a,%al
  1052eb:	7f 31                	jg     10531e <strtol+0x136>
            dig = *s - 'A' + 10;
  1052ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1052f0:	0f b6 00             	movzbl (%eax),%eax
  1052f3:	0f be c0             	movsbl %al,%eax
  1052f6:	83 e8 37             	sub    $0x37,%eax
  1052f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1052fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052ff:	3b 45 10             	cmp    0x10(%ebp),%eax
  105302:	7d 19                	jge    10531d <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105304:	ff 45 08             	incl   0x8(%ebp)
  105307:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10530a:	0f af 45 10          	imul   0x10(%ebp),%eax
  10530e:	89 c2                	mov    %eax,%edx
  105310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105313:	01 d0                	add    %edx,%eax
  105315:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105318:	e9 72 ff ff ff       	jmp    10528f <strtol+0xa7>
            break;
  10531d:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  10531e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105322:	74 08                	je     10532c <strtol+0x144>
        *endptr = (char *) s;
  105324:	8b 45 0c             	mov    0xc(%ebp),%eax
  105327:	8b 55 08             	mov    0x8(%ebp),%edx
  10532a:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10532c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105330:	74 07                	je     105339 <strtol+0x151>
  105332:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105335:	f7 d8                	neg    %eax
  105337:	eb 03                	jmp    10533c <strtol+0x154>
  105339:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10533c:	c9                   	leave  
  10533d:	c3                   	ret    

0010533e <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10533e:	55                   	push   %ebp
  10533f:	89 e5                	mov    %esp,%ebp
  105341:	57                   	push   %edi
  105342:	83 ec 24             	sub    $0x24,%esp
  105345:	8b 45 0c             	mov    0xc(%ebp),%eax
  105348:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10534b:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10534f:	8b 55 08             	mov    0x8(%ebp),%edx
  105352:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105355:	88 45 f7             	mov    %al,-0x9(%ebp)
  105358:	8b 45 10             	mov    0x10(%ebp),%eax
  10535b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10535e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105361:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105365:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105368:	89 d7                	mov    %edx,%edi
  10536a:	f3 aa                	rep stos %al,%es:(%edi)
  10536c:	89 fa                	mov    %edi,%edx
  10536e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105371:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105374:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105377:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105378:	83 c4 24             	add    $0x24,%esp
  10537b:	5f                   	pop    %edi
  10537c:	5d                   	pop    %ebp
  10537d:	c3                   	ret    

0010537e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10537e:	55                   	push   %ebp
  10537f:	89 e5                	mov    %esp,%ebp
  105381:	57                   	push   %edi
  105382:	56                   	push   %esi
  105383:	53                   	push   %ebx
  105384:	83 ec 30             	sub    $0x30,%esp
  105387:	8b 45 08             	mov    0x8(%ebp),%eax
  10538a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10538d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105390:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105393:	8b 45 10             	mov    0x10(%ebp),%eax
  105396:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10539c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10539f:	73 42                	jae    1053e3 <memmove+0x65>
  1053a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1053ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1053b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053b6:	c1 e8 02             	shr    $0x2,%eax
  1053b9:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1053bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1053be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053c1:	89 d7                	mov    %edx,%edi
  1053c3:	89 c6                	mov    %eax,%esi
  1053c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1053c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1053ca:	83 e1 03             	and    $0x3,%ecx
  1053cd:	74 02                	je     1053d1 <memmove+0x53>
  1053cf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1053d1:	89 f0                	mov    %esi,%eax
  1053d3:	89 fa                	mov    %edi,%edx
  1053d5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1053d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1053db:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1053de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1053e1:	eb 36                	jmp    105419 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1053e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1053e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053ec:	01 c2                	add    %eax,%edx
  1053ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053f1:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1053f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053f7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1053fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053fd:	89 c1                	mov    %eax,%ecx
  1053ff:	89 d8                	mov    %ebx,%eax
  105401:	89 d6                	mov    %edx,%esi
  105403:	89 c7                	mov    %eax,%edi
  105405:	fd                   	std    
  105406:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105408:	fc                   	cld    
  105409:	89 f8                	mov    %edi,%eax
  10540b:	89 f2                	mov    %esi,%edx
  10540d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105410:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105413:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105416:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105419:	83 c4 30             	add    $0x30,%esp
  10541c:	5b                   	pop    %ebx
  10541d:	5e                   	pop    %esi
  10541e:	5f                   	pop    %edi
  10541f:	5d                   	pop    %ebp
  105420:	c3                   	ret    

00105421 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105421:	55                   	push   %ebp
  105422:	89 e5                	mov    %esp,%ebp
  105424:	57                   	push   %edi
  105425:	56                   	push   %esi
  105426:	83 ec 20             	sub    $0x20,%esp
  105429:	8b 45 08             	mov    0x8(%ebp),%eax
  10542c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10542f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105432:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105435:	8b 45 10             	mov    0x10(%ebp),%eax
  105438:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10543b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10543e:	c1 e8 02             	shr    $0x2,%eax
  105441:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105449:	89 d7                	mov    %edx,%edi
  10544b:	89 c6                	mov    %eax,%esi
  10544d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10544f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105452:	83 e1 03             	and    $0x3,%ecx
  105455:	74 02                	je     105459 <memcpy+0x38>
  105457:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105459:	89 f0                	mov    %esi,%eax
  10545b:	89 fa                	mov    %edi,%edx
  10545d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105460:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105463:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105466:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  105469:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10546a:	83 c4 20             	add    $0x20,%esp
  10546d:	5e                   	pop    %esi
  10546e:	5f                   	pop    %edi
  10546f:	5d                   	pop    %ebp
  105470:	c3                   	ret    

00105471 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105471:	55                   	push   %ebp
  105472:	89 e5                	mov    %esp,%ebp
  105474:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105477:	8b 45 08             	mov    0x8(%ebp),%eax
  10547a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10547d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105480:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105483:	eb 2e                	jmp    1054b3 <memcmp+0x42>
        if (*s1 != *s2) {
  105485:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105488:	0f b6 10             	movzbl (%eax),%edx
  10548b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10548e:	0f b6 00             	movzbl (%eax),%eax
  105491:	38 c2                	cmp    %al,%dl
  105493:	74 18                	je     1054ad <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105498:	0f b6 00             	movzbl (%eax),%eax
  10549b:	0f b6 d0             	movzbl %al,%edx
  10549e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1054a1:	0f b6 00             	movzbl (%eax),%eax
  1054a4:	0f b6 c0             	movzbl %al,%eax
  1054a7:	29 c2                	sub    %eax,%edx
  1054a9:	89 d0                	mov    %edx,%eax
  1054ab:	eb 18                	jmp    1054c5 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  1054ad:	ff 45 fc             	incl   -0x4(%ebp)
  1054b0:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1054b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1054b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054b9:	89 55 10             	mov    %edx,0x10(%ebp)
  1054bc:	85 c0                	test   %eax,%eax
  1054be:	75 c5                	jne    105485 <memcmp+0x14>
    }
    return 0;
  1054c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1054c5:	c9                   	leave  
  1054c6:	c3                   	ret    

001054c7 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1054c7:	55                   	push   %ebp
  1054c8:	89 e5                	mov    %esp,%ebp
  1054ca:	83 ec 58             	sub    $0x58,%esp
  1054cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1054d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1054d3:	8b 45 14             	mov    0x14(%ebp),%eax
  1054d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1054d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1054e5:	8b 45 18             	mov    0x18(%ebp),%eax
  1054e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054f4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1054f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105501:	74 1c                	je     10551f <printnum+0x58>
  105503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105506:	ba 00 00 00 00       	mov    $0x0,%edx
  10550b:	f7 75 e4             	divl   -0x1c(%ebp)
  10550e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105514:	ba 00 00 00 00       	mov    $0x0,%edx
  105519:	f7 75 e4             	divl   -0x1c(%ebp)
  10551c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10551f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105522:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105525:	f7 75 e4             	divl   -0x1c(%ebp)
  105528:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10552b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10552e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105534:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105537:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10553a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10553d:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105540:	8b 45 18             	mov    0x18(%ebp),%eax
  105543:	ba 00 00 00 00       	mov    $0x0,%edx
  105548:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10554b:	72 56                	jb     1055a3 <printnum+0xdc>
  10554d:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  105550:	77 05                	ja     105557 <printnum+0x90>
  105552:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105555:	72 4c                	jb     1055a3 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105557:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10555a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10555d:	8b 45 20             	mov    0x20(%ebp),%eax
  105560:	89 44 24 18          	mov    %eax,0x18(%esp)
  105564:	89 54 24 14          	mov    %edx,0x14(%esp)
  105568:	8b 45 18             	mov    0x18(%ebp),%eax
  10556b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10556f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105572:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105575:	89 44 24 08          	mov    %eax,0x8(%esp)
  105579:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10557d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105580:	89 44 24 04          	mov    %eax,0x4(%esp)
  105584:	8b 45 08             	mov    0x8(%ebp),%eax
  105587:	89 04 24             	mov    %eax,(%esp)
  10558a:	e8 38 ff ff ff       	call   1054c7 <printnum>
  10558f:	eb 1b                	jmp    1055ac <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105591:	8b 45 0c             	mov    0xc(%ebp),%eax
  105594:	89 44 24 04          	mov    %eax,0x4(%esp)
  105598:	8b 45 20             	mov    0x20(%ebp),%eax
  10559b:	89 04 24             	mov    %eax,(%esp)
  10559e:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a1:	ff d0                	call   *%eax
        while (-- width > 0)
  1055a3:	ff 4d 1c             	decl   0x1c(%ebp)
  1055a6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1055aa:	7f e5                	jg     105591 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1055ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1055af:	05 00 6b 10 00       	add    $0x106b00,%eax
  1055b4:	0f b6 00             	movzbl (%eax),%eax
  1055b7:	0f be c0             	movsbl %al,%eax
  1055ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055bd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055c1:	89 04 24             	mov    %eax,(%esp)
  1055c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c7:	ff d0                	call   *%eax
}
  1055c9:	90                   	nop
  1055ca:	c9                   	leave  
  1055cb:	c3                   	ret    

001055cc <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1055cc:	55                   	push   %ebp
  1055cd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055d3:	7e 14                	jle    1055e9 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1055d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d8:	8b 00                	mov    (%eax),%eax
  1055da:	8d 48 08             	lea    0x8(%eax),%ecx
  1055dd:	8b 55 08             	mov    0x8(%ebp),%edx
  1055e0:	89 0a                	mov    %ecx,(%edx)
  1055e2:	8b 50 04             	mov    0x4(%eax),%edx
  1055e5:	8b 00                	mov    (%eax),%eax
  1055e7:	eb 30                	jmp    105619 <getuint+0x4d>
    }
    else if (lflag) {
  1055e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055ed:	74 16                	je     105605 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1055ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1055f2:	8b 00                	mov    (%eax),%eax
  1055f4:	8d 48 04             	lea    0x4(%eax),%ecx
  1055f7:	8b 55 08             	mov    0x8(%ebp),%edx
  1055fa:	89 0a                	mov    %ecx,(%edx)
  1055fc:	8b 00                	mov    (%eax),%eax
  1055fe:	ba 00 00 00 00       	mov    $0x0,%edx
  105603:	eb 14                	jmp    105619 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105605:	8b 45 08             	mov    0x8(%ebp),%eax
  105608:	8b 00                	mov    (%eax),%eax
  10560a:	8d 48 04             	lea    0x4(%eax),%ecx
  10560d:	8b 55 08             	mov    0x8(%ebp),%edx
  105610:	89 0a                	mov    %ecx,(%edx)
  105612:	8b 00                	mov    (%eax),%eax
  105614:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105619:	5d                   	pop    %ebp
  10561a:	c3                   	ret    

0010561b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10561b:	55                   	push   %ebp
  10561c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10561e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105622:	7e 14                	jle    105638 <getint+0x1d>
        return va_arg(*ap, long long);
  105624:	8b 45 08             	mov    0x8(%ebp),%eax
  105627:	8b 00                	mov    (%eax),%eax
  105629:	8d 48 08             	lea    0x8(%eax),%ecx
  10562c:	8b 55 08             	mov    0x8(%ebp),%edx
  10562f:	89 0a                	mov    %ecx,(%edx)
  105631:	8b 50 04             	mov    0x4(%eax),%edx
  105634:	8b 00                	mov    (%eax),%eax
  105636:	eb 28                	jmp    105660 <getint+0x45>
    }
    else if (lflag) {
  105638:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10563c:	74 12                	je     105650 <getint+0x35>
        return va_arg(*ap, long);
  10563e:	8b 45 08             	mov    0x8(%ebp),%eax
  105641:	8b 00                	mov    (%eax),%eax
  105643:	8d 48 04             	lea    0x4(%eax),%ecx
  105646:	8b 55 08             	mov    0x8(%ebp),%edx
  105649:	89 0a                	mov    %ecx,(%edx)
  10564b:	8b 00                	mov    (%eax),%eax
  10564d:	99                   	cltd   
  10564e:	eb 10                	jmp    105660 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105650:	8b 45 08             	mov    0x8(%ebp),%eax
  105653:	8b 00                	mov    (%eax),%eax
  105655:	8d 48 04             	lea    0x4(%eax),%ecx
  105658:	8b 55 08             	mov    0x8(%ebp),%edx
  10565b:	89 0a                	mov    %ecx,(%edx)
  10565d:	8b 00                	mov    (%eax),%eax
  10565f:	99                   	cltd   
    }
}
  105660:	5d                   	pop    %ebp
  105661:	c3                   	ret    

00105662 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105662:	55                   	push   %ebp
  105663:	89 e5                	mov    %esp,%ebp
  105665:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105668:	8d 45 14             	lea    0x14(%ebp),%eax
  10566b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10566e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105671:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105675:	8b 45 10             	mov    0x10(%ebp),%eax
  105678:	89 44 24 08          	mov    %eax,0x8(%esp)
  10567c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10567f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105683:	8b 45 08             	mov    0x8(%ebp),%eax
  105686:	89 04 24             	mov    %eax,(%esp)
  105689:	e8 03 00 00 00       	call   105691 <vprintfmt>
    va_end(ap);
}
  10568e:	90                   	nop
  10568f:	c9                   	leave  
  105690:	c3                   	ret    

00105691 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105691:	55                   	push   %ebp
  105692:	89 e5                	mov    %esp,%ebp
  105694:	56                   	push   %esi
  105695:	53                   	push   %ebx
  105696:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105699:	eb 17                	jmp    1056b2 <vprintfmt+0x21>
            if (ch == '\0') {
  10569b:	85 db                	test   %ebx,%ebx
  10569d:	0f 84 bf 03 00 00    	je     105a62 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  1056a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056aa:	89 1c 24             	mov    %ebx,(%esp)
  1056ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1056b0:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1056b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1056b5:	8d 50 01             	lea    0x1(%eax),%edx
  1056b8:	89 55 10             	mov    %edx,0x10(%ebp)
  1056bb:	0f b6 00             	movzbl (%eax),%eax
  1056be:	0f b6 d8             	movzbl %al,%ebx
  1056c1:	83 fb 25             	cmp    $0x25,%ebx
  1056c4:	75 d5                	jne    10569b <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1056c6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1056ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1056d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1056d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1056de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056e1:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1056e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1056e7:	8d 50 01             	lea    0x1(%eax),%edx
  1056ea:	89 55 10             	mov    %edx,0x10(%ebp)
  1056ed:	0f b6 00             	movzbl (%eax),%eax
  1056f0:	0f b6 d8             	movzbl %al,%ebx
  1056f3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1056f6:	83 f8 55             	cmp    $0x55,%eax
  1056f9:	0f 87 37 03 00 00    	ja     105a36 <vprintfmt+0x3a5>
  1056ff:	8b 04 85 24 6b 10 00 	mov    0x106b24(,%eax,4),%eax
  105706:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105708:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10570c:	eb d6                	jmp    1056e4 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10570e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105712:	eb d0                	jmp    1056e4 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105714:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10571b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10571e:	89 d0                	mov    %edx,%eax
  105720:	c1 e0 02             	shl    $0x2,%eax
  105723:	01 d0                	add    %edx,%eax
  105725:	01 c0                	add    %eax,%eax
  105727:	01 d8                	add    %ebx,%eax
  105729:	83 e8 30             	sub    $0x30,%eax
  10572c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10572f:	8b 45 10             	mov    0x10(%ebp),%eax
  105732:	0f b6 00             	movzbl (%eax),%eax
  105735:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105738:	83 fb 2f             	cmp    $0x2f,%ebx
  10573b:	7e 38                	jle    105775 <vprintfmt+0xe4>
  10573d:	83 fb 39             	cmp    $0x39,%ebx
  105740:	7f 33                	jg     105775 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105742:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105745:	eb d4                	jmp    10571b <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105747:	8b 45 14             	mov    0x14(%ebp),%eax
  10574a:	8d 50 04             	lea    0x4(%eax),%edx
  10574d:	89 55 14             	mov    %edx,0x14(%ebp)
  105750:	8b 00                	mov    (%eax),%eax
  105752:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105755:	eb 1f                	jmp    105776 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  105757:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10575b:	79 87                	jns    1056e4 <vprintfmt+0x53>
                width = 0;
  10575d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105764:	e9 7b ff ff ff       	jmp    1056e4 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105769:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105770:	e9 6f ff ff ff       	jmp    1056e4 <vprintfmt+0x53>
            goto process_precision;
  105775:	90                   	nop

        process_precision:
            if (width < 0)
  105776:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10577a:	0f 89 64 ff ff ff    	jns    1056e4 <vprintfmt+0x53>
                width = precision, precision = -1;
  105780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105783:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105786:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10578d:	e9 52 ff ff ff       	jmp    1056e4 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105792:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105795:	e9 4a ff ff ff       	jmp    1056e4 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10579a:	8b 45 14             	mov    0x14(%ebp),%eax
  10579d:	8d 50 04             	lea    0x4(%eax),%edx
  1057a0:	89 55 14             	mov    %edx,0x14(%ebp)
  1057a3:	8b 00                	mov    (%eax),%eax
  1057a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057ac:	89 04 24             	mov    %eax,(%esp)
  1057af:	8b 45 08             	mov    0x8(%ebp),%eax
  1057b2:	ff d0                	call   *%eax
            break;
  1057b4:	e9 a4 02 00 00       	jmp    105a5d <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1057b9:	8b 45 14             	mov    0x14(%ebp),%eax
  1057bc:	8d 50 04             	lea    0x4(%eax),%edx
  1057bf:	89 55 14             	mov    %edx,0x14(%ebp)
  1057c2:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1057c4:	85 db                	test   %ebx,%ebx
  1057c6:	79 02                	jns    1057ca <vprintfmt+0x139>
                err = -err;
  1057c8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1057ca:	83 fb 06             	cmp    $0x6,%ebx
  1057cd:	7f 0b                	jg     1057da <vprintfmt+0x149>
  1057cf:	8b 34 9d e4 6a 10 00 	mov    0x106ae4(,%ebx,4),%esi
  1057d6:	85 f6                	test   %esi,%esi
  1057d8:	75 23                	jne    1057fd <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  1057da:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1057de:	c7 44 24 08 11 6b 10 	movl   $0x106b11,0x8(%esp)
  1057e5:	00 
  1057e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f0:	89 04 24             	mov    %eax,(%esp)
  1057f3:	e8 6a fe ff ff       	call   105662 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1057f8:	e9 60 02 00 00       	jmp    105a5d <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  1057fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105801:	c7 44 24 08 1a 6b 10 	movl   $0x106b1a,0x8(%esp)
  105808:	00 
  105809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10580c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105810:	8b 45 08             	mov    0x8(%ebp),%eax
  105813:	89 04 24             	mov    %eax,(%esp)
  105816:	e8 47 fe ff ff       	call   105662 <printfmt>
            break;
  10581b:	e9 3d 02 00 00       	jmp    105a5d <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105820:	8b 45 14             	mov    0x14(%ebp),%eax
  105823:	8d 50 04             	lea    0x4(%eax),%edx
  105826:	89 55 14             	mov    %edx,0x14(%ebp)
  105829:	8b 30                	mov    (%eax),%esi
  10582b:	85 f6                	test   %esi,%esi
  10582d:	75 05                	jne    105834 <vprintfmt+0x1a3>
                p = "(null)";
  10582f:	be 1d 6b 10 00       	mov    $0x106b1d,%esi
            }
            if (width > 0 && padc != '-') {
  105834:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105838:	7e 76                	jle    1058b0 <vprintfmt+0x21f>
  10583a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10583e:	74 70                	je     1058b0 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105843:	89 44 24 04          	mov    %eax,0x4(%esp)
  105847:	89 34 24             	mov    %esi,(%esp)
  10584a:	e8 f6 f7 ff ff       	call   105045 <strnlen>
  10584f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105852:	29 c2                	sub    %eax,%edx
  105854:	89 d0                	mov    %edx,%eax
  105856:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105859:	eb 16                	jmp    105871 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  10585b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10585f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105862:	89 54 24 04          	mov    %edx,0x4(%esp)
  105866:	89 04 24             	mov    %eax,(%esp)
  105869:	8b 45 08             	mov    0x8(%ebp),%eax
  10586c:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  10586e:	ff 4d e8             	decl   -0x18(%ebp)
  105871:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105875:	7f e4                	jg     10585b <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105877:	eb 37                	jmp    1058b0 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  105879:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10587d:	74 1f                	je     10589e <vprintfmt+0x20d>
  10587f:	83 fb 1f             	cmp    $0x1f,%ebx
  105882:	7e 05                	jle    105889 <vprintfmt+0x1f8>
  105884:	83 fb 7e             	cmp    $0x7e,%ebx
  105887:	7e 15                	jle    10589e <vprintfmt+0x20d>
                    putch('?', putdat);
  105889:	8b 45 0c             	mov    0xc(%ebp),%eax
  10588c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105890:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105897:	8b 45 08             	mov    0x8(%ebp),%eax
  10589a:	ff d0                	call   *%eax
  10589c:	eb 0f                	jmp    1058ad <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  10589e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058a5:	89 1c 24             	mov    %ebx,(%esp)
  1058a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ab:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1058ad:	ff 4d e8             	decl   -0x18(%ebp)
  1058b0:	89 f0                	mov    %esi,%eax
  1058b2:	8d 70 01             	lea    0x1(%eax),%esi
  1058b5:	0f b6 00             	movzbl (%eax),%eax
  1058b8:	0f be d8             	movsbl %al,%ebx
  1058bb:	85 db                	test   %ebx,%ebx
  1058bd:	74 27                	je     1058e6 <vprintfmt+0x255>
  1058bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058c3:	78 b4                	js     105879 <vprintfmt+0x1e8>
  1058c5:	ff 4d e4             	decl   -0x1c(%ebp)
  1058c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058cc:	79 ab                	jns    105879 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  1058ce:	eb 16                	jmp    1058e6 <vprintfmt+0x255>
                putch(' ', putdat);
  1058d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058d7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1058de:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e1:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1058e3:	ff 4d e8             	decl   -0x18(%ebp)
  1058e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058ea:	7f e4                	jg     1058d0 <vprintfmt+0x23f>
            }
            break;
  1058ec:	e9 6c 01 00 00       	jmp    105a5d <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1058f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f8:	8d 45 14             	lea    0x14(%ebp),%eax
  1058fb:	89 04 24             	mov    %eax,(%esp)
  1058fe:	e8 18 fd ff ff       	call   10561b <getint>
  105903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105906:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10590c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10590f:	85 d2                	test   %edx,%edx
  105911:	79 26                	jns    105939 <vprintfmt+0x2a8>
                putch('-', putdat);
  105913:	8b 45 0c             	mov    0xc(%ebp),%eax
  105916:	89 44 24 04          	mov    %eax,0x4(%esp)
  10591a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105921:	8b 45 08             	mov    0x8(%ebp),%eax
  105924:	ff d0                	call   *%eax
                num = -(long long)num;
  105926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10592c:	f7 d8                	neg    %eax
  10592e:	83 d2 00             	adc    $0x0,%edx
  105931:	f7 da                	neg    %edx
  105933:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105936:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105939:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105940:	e9 a8 00 00 00       	jmp    1059ed <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105945:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105948:	89 44 24 04          	mov    %eax,0x4(%esp)
  10594c:	8d 45 14             	lea    0x14(%ebp),%eax
  10594f:	89 04 24             	mov    %eax,(%esp)
  105952:	e8 75 fc ff ff       	call   1055cc <getuint>
  105957:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10595a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10595d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105964:	e9 84 00 00 00       	jmp    1059ed <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105969:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10596c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105970:	8d 45 14             	lea    0x14(%ebp),%eax
  105973:	89 04 24             	mov    %eax,(%esp)
  105976:	e8 51 fc ff ff       	call   1055cc <getuint>
  10597b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10597e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105981:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105988:	eb 63                	jmp    1059ed <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  10598a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10598d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105991:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105998:	8b 45 08             	mov    0x8(%ebp),%eax
  10599b:	ff d0                	call   *%eax
            putch('x', putdat);
  10599d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1059ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ae:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1059b0:	8b 45 14             	mov    0x14(%ebp),%eax
  1059b3:	8d 50 04             	lea    0x4(%eax),%edx
  1059b6:	89 55 14             	mov    %edx,0x14(%ebp)
  1059b9:	8b 00                	mov    (%eax),%eax
  1059bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1059c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1059cc:	eb 1f                	jmp    1059ed <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1059ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d5:	8d 45 14             	lea    0x14(%ebp),%eax
  1059d8:	89 04 24             	mov    %eax,(%esp)
  1059db:	e8 ec fb ff ff       	call   1055cc <getuint>
  1059e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1059e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1059ed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1059f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059f4:	89 54 24 18          	mov    %edx,0x18(%esp)
  1059f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1059fb:	89 54 24 14          	mov    %edx,0x14(%esp)
  1059ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  105a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a09:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a0d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a18:	8b 45 08             	mov    0x8(%ebp),%eax
  105a1b:	89 04 24             	mov    %eax,(%esp)
  105a1e:	e8 a4 fa ff ff       	call   1054c7 <printnum>
            break;
  105a23:	eb 38                	jmp    105a5d <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a2c:	89 1c 24             	mov    %ebx,(%esp)
  105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a32:	ff d0                	call   *%eax
            break;
  105a34:	eb 27                	jmp    105a5d <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a3d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105a44:	8b 45 08             	mov    0x8(%ebp),%eax
  105a47:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105a49:	ff 4d 10             	decl   0x10(%ebp)
  105a4c:	eb 03                	jmp    105a51 <vprintfmt+0x3c0>
  105a4e:	ff 4d 10             	decl   0x10(%ebp)
  105a51:	8b 45 10             	mov    0x10(%ebp),%eax
  105a54:	48                   	dec    %eax
  105a55:	0f b6 00             	movzbl (%eax),%eax
  105a58:	3c 25                	cmp    $0x25,%al
  105a5a:	75 f2                	jne    105a4e <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105a5c:	90                   	nop
    while (1) {
  105a5d:	e9 37 fc ff ff       	jmp    105699 <vprintfmt+0x8>
                return;
  105a62:	90                   	nop
        }
    }
}
  105a63:	83 c4 40             	add    $0x40,%esp
  105a66:	5b                   	pop    %ebx
  105a67:	5e                   	pop    %esi
  105a68:	5d                   	pop    %ebp
  105a69:	c3                   	ret    

00105a6a <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a6a:	55                   	push   %ebp
  105a6b:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a70:	8b 40 08             	mov    0x8(%eax),%eax
  105a73:	8d 50 01             	lea    0x1(%eax),%edx
  105a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a79:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a7f:	8b 10                	mov    (%eax),%edx
  105a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a84:	8b 40 04             	mov    0x4(%eax),%eax
  105a87:	39 c2                	cmp    %eax,%edx
  105a89:	73 12                	jae    105a9d <sprintputch+0x33>
        *b->buf ++ = ch;
  105a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a8e:	8b 00                	mov    (%eax),%eax
  105a90:	8d 48 01             	lea    0x1(%eax),%ecx
  105a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a96:	89 0a                	mov    %ecx,(%edx)
  105a98:	8b 55 08             	mov    0x8(%ebp),%edx
  105a9b:	88 10                	mov    %dl,(%eax)
    }
}
  105a9d:	90                   	nop
  105a9e:	5d                   	pop    %ebp
  105a9f:	c3                   	ret    

00105aa0 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105aa0:	55                   	push   %ebp
  105aa1:	89 e5                	mov    %esp,%ebp
  105aa3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105aa6:	8d 45 14             	lea    0x14(%ebp),%eax
  105aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aaf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  105ab6:	89 44 24 08          	mov    %eax,0x8(%esp)
  105aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  105abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac4:	89 04 24             	mov    %eax,(%esp)
  105ac7:	e8 08 00 00 00       	call   105ad4 <vsnprintf>
  105acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ad2:	c9                   	leave  
  105ad3:	c3                   	ret    

00105ad4 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105ad4:	55                   	push   %ebp
  105ad5:	89 e5                	mov    %esp,%ebp
  105ad7:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105ada:	8b 45 08             	mov    0x8(%ebp),%eax
  105add:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae3:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae9:	01 d0                	add    %edx,%eax
  105aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105af5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105af9:	74 0a                	je     105b05 <vsnprintf+0x31>
  105afb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b01:	39 c2                	cmp    %eax,%edx
  105b03:	76 07                	jbe    105b0c <vsnprintf+0x38>
        return -E_INVAL;
  105b05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105b0a:	eb 2a                	jmp    105b36 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  105b0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b13:	8b 45 10             	mov    0x10(%ebp),%eax
  105b16:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b1a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b21:	c7 04 24 6a 5a 10 00 	movl   $0x105a6a,(%esp)
  105b28:	e8 64 fb ff ff       	call   105691 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b30:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b36:	c9                   	leave  
  105b37:	c3                   	ret    
