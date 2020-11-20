
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 94 af 25 c0       	mov    $0xc025af94,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 dc 52 00 00       	call   c010533e <memset>

    cons_init();                // init the console
c0100062:	e8 9c 15 00 00       	call   c0101603 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 40 5b 10 c0 	movl   $0xc0105b40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 5c 5b 10 c0 	movl   $0xc0105b5c,(%esp)
c010007c:	e8 21 02 00 00       	call   c01002a2 <cprintf>

    print_kerninfo();
c0100081:	e8 c2 08 00 00       	call   c0100948 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 8e 00 00 00       	call   c0100119 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 2e 34 00 00       	call   c01034be <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 d3 16 00 00       	call   c0101768 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 33 18 00 00       	call   c01018cd <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 07 0d 00 00       	call   c0100da6 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 fe 17 00 00       	call   c01018a2 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
c01000a4:	e8 6b 01 00 00       	call   c0100214 <lab1_switch_test>

    /* do nothing */
    while (1);
c01000a9:	eb fe                	jmp    c01000a9 <kern_init+0x73>

c01000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000ab:	55                   	push   %ebp
c01000ac:	89 e5                	mov    %esp,%ebp
c01000ae:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b8:	00 
c01000b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c0:	00 
c01000c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c8:	e8 c7 0c 00 00       	call   c0100d94 <mon_backtrace>
}
c01000cd:	90                   	nop
c01000ce:	c9                   	leave  
c01000cf:	c3                   	ret    

c01000d0 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d0:	55                   	push   %ebp
c01000d1:	89 e5                	mov    %esp,%ebp
c01000d3:	53                   	push   %ebx
c01000d4:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d7:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000da:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000dd:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ef:	89 04 24             	mov    %eax,(%esp)
c01000f2:	e8 b4 ff ff ff       	call   c01000ab <grade_backtrace2>
}
c01000f7:	90                   	nop
c01000f8:	83 c4 14             	add    $0x14,%esp
c01000fb:	5b                   	pop    %ebx
c01000fc:	5d                   	pop    %ebp
c01000fd:	c3                   	ret    

c01000fe <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fe:	55                   	push   %ebp
c01000ff:	89 e5                	mov    %esp,%ebp
c0100101:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100104:	8b 45 10             	mov    0x10(%ebp),%eax
c0100107:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010b:	8b 45 08             	mov    0x8(%ebp),%eax
c010010e:	89 04 24             	mov    %eax,(%esp)
c0100111:	e8 ba ff ff ff       	call   c01000d0 <grade_backtrace1>
}
c0100116:	90                   	nop
c0100117:	c9                   	leave  
c0100118:	c3                   	ret    

c0100119 <grade_backtrace>:

void
grade_backtrace(void) {
c0100119:	55                   	push   %ebp
c010011a:	89 e5                	mov    %esp,%ebp
c010011c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011f:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100124:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012b:	ff 
c010012c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100137:	e8 c2 ff ff ff       	call   c01000fe <grade_backtrace0>
}
c010013c:	90                   	nop
c010013d:	c9                   	leave  
c010013e:	c3                   	ret    

c010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013f:	55                   	push   %ebp
c0100140:	89 e5                	mov    %esp,%ebp
c0100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100155:	83 e0 03             	and    $0x3,%eax
c0100158:	89 c2                	mov    %eax,%edx
c010015a:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 61 5b 10 c0 	movl   $0xc0105b61,(%esp)
c010016e:	e8 2f 01 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 6f 5b 10 c0 	movl   $0xc0105b6f,(%esp)
c010018d:	e8 10 01 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 7d 5b 10 c0 	movl   $0xc0105b7d,(%esp)
c01001ac:	e8 f1 00 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 8b 5b 10 c0 	movl   $0xc0105b8b,(%esp)
c01001cb:	e8 d2 00 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 99 5b 10 c0 	movl   $0xc0105b99,(%esp)
c01001ea:	e8 b3 00 00 00       	call   c01002a2 <cprintf>
    round ++;
c01001ef:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001fa:	90                   	nop
c01001fb:	c9                   	leave  
c01001fc:	c3                   	ret    

c01001fd <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001fd:	55                   	push   %ebp
c01001fe:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
        asm volatile (
c0100200:	83 ec 08             	sub    $0x8,%esp
c0100203:	cd 78                	int    $0x78
c0100205:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c0100207:	90                   	nop
c0100208:	5d                   	pop    %ebp
c0100209:	c3                   	ret    

c010020a <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020a:	55                   	push   %ebp
c010020b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
        asm volatile (
c010020d:	cd 79                	int    $0x79
c010020f:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
c0100211:	90                   	nop
c0100212:	5d                   	pop    %ebp
c0100213:	c3                   	ret    

c0100214 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100214:	55                   	push   %ebp
c0100215:	89 e5                	mov    %esp,%ebp
c0100217:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021a:	e8 20 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021f:	c7 04 24 a8 5b 10 c0 	movl   $0xc0105ba8,(%esp)
c0100226:	e8 77 00 00 00       	call   c01002a2 <cprintf>
    lab1_switch_to_user();
c010022b:	e8 cd ff ff ff       	call   c01001fd <lab1_switch_to_user>
    lab1_print_cur_status();
c0100230:	e8 0a ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100235:	c7 04 24 c8 5b 10 c0 	movl   $0xc0105bc8,(%esp)
c010023c:	e8 61 00 00 00       	call   c01002a2 <cprintf>
    lab1_switch_to_kernel();
c0100241:	e8 c4 ff ff ff       	call   c010020a <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100246:	e8 f4 fe ff ff       	call   c010013f <lab1_print_cur_status>
}
c010024b:	90                   	nop
c010024c:	c9                   	leave  
c010024d:	c3                   	ret    

c010024e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010024e:	55                   	push   %ebp
c010024f:	89 e5                	mov    %esp,%ebp
c0100251:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100254:	8b 45 08             	mov    0x8(%ebp),%eax
c0100257:	89 04 24             	mov    %eax,(%esp)
c010025a:	e8 d1 13 00 00       	call   c0101630 <cons_putc>
    (*cnt) ++;
c010025f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100262:	8b 00                	mov    (%eax),%eax
c0100264:	8d 50 01             	lea    0x1(%eax),%edx
c0100267:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026a:	89 10                	mov    %edx,(%eax)
}
c010026c:	90                   	nop
c010026d:	c9                   	leave  
c010026e:	c3                   	ret    

c010026f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010026f:	55                   	push   %ebp
c0100270:	89 e5                	mov    %esp,%ebp
c0100272:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010027c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010027f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100283:	8b 45 08             	mov    0x8(%ebp),%eax
c0100286:	89 44 24 08          	mov    %eax,0x8(%esp)
c010028a:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010028d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100291:	c7 04 24 4e 02 10 c0 	movl   $0xc010024e,(%esp)
c0100298:	e8 f4 53 00 00       	call   c0105691 <vprintfmt>
    return cnt;
c010029d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002a0:	c9                   	leave  
c01002a1:	c3                   	ret    

c01002a2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002a2:	55                   	push   %ebp
c01002a3:	89 e5                	mov    %esp,%ebp
c01002a5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002a8:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01002b8:	89 04 24             	mov    %eax,(%esp)
c01002bb:	e8 af ff ff ff       	call   c010026f <vcprintf>
c01002c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c6:	c9                   	leave  
c01002c7:	c3                   	ret    

c01002c8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002c8:	55                   	push   %ebp
c01002c9:	89 e5                	mov    %esp,%ebp
c01002cb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d1:	89 04 24             	mov    %eax,(%esp)
c01002d4:	e8 57 13 00 00       	call   c0101630 <cons_putc>
}
c01002d9:	90                   	nop
c01002da:	c9                   	leave  
c01002db:	c3                   	ret    

c01002dc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002dc:	55                   	push   %ebp
c01002dd:	89 e5                	mov    %esp,%ebp
c01002df:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002e9:	eb 13                	jmp    c01002fe <cputs+0x22>
        cputch(c, &cnt);
c01002eb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002ef:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002f2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002f6:	89 04 24             	mov    %eax,(%esp)
c01002f9:	e8 50 ff ff ff       	call   c010024e <cputch>
    while ((c = *str ++) != '\0') {
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	8d 50 01             	lea    0x1(%eax),%edx
c0100304:	89 55 08             	mov    %edx,0x8(%ebp)
c0100307:	0f b6 00             	movzbl (%eax),%eax
c010030a:	88 45 f7             	mov    %al,-0x9(%ebp)
c010030d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100311:	75 d8                	jne    c01002eb <cputs+0xf>
    }
    cputch('\n', &cnt);
c0100313:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100316:	89 44 24 04          	mov    %eax,0x4(%esp)
c010031a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100321:	e8 28 ff ff ff       	call   c010024e <cputch>
    return cnt;
c0100326:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100329:	c9                   	leave  
c010032a:	c3                   	ret    

c010032b <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010032b:	55                   	push   %ebp
c010032c:	89 e5                	mov    %esp,%ebp
c010032e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100331:	e8 37 13 00 00       	call   c010166d <cons_getc>
c0100336:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010033d:	74 f2                	je     c0100331 <getchar+0x6>
        /* do nothing */;
    return c;
c010033f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100342:	c9                   	leave  
c0100343:	c3                   	ret    

c0100344 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100344:	55                   	push   %ebp
c0100345:	89 e5                	mov    %esp,%ebp
c0100347:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010034a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010034e:	74 13                	je     c0100363 <readline+0x1f>
        cprintf("%s", prompt);
c0100350:	8b 45 08             	mov    0x8(%ebp),%eax
c0100353:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100357:	c7 04 24 e7 5b 10 c0 	movl   $0xc0105be7,(%esp)
c010035e:	e8 3f ff ff ff       	call   c01002a2 <cprintf>
    }
    int i = 0, c;
c0100363:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010036a:	e8 bc ff ff ff       	call   c010032b <getchar>
c010036f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100372:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100376:	79 07                	jns    c010037f <readline+0x3b>
            return NULL;
c0100378:	b8 00 00 00 00       	mov    $0x0,%eax
c010037d:	eb 78                	jmp    c01003f7 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010037f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100383:	7e 28                	jle    c01003ad <readline+0x69>
c0100385:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010038c:	7f 1f                	jg     c01003ad <readline+0x69>
            cputchar(c);
c010038e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100391:	89 04 24             	mov    %eax,(%esp)
c0100394:	e8 2f ff ff ff       	call   c01002c8 <cputchar>
            buf[i ++] = c;
c0100399:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010039c:	8d 50 01             	lea    0x1(%eax),%edx
c010039f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003a5:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c01003ab:	eb 45                	jmp    c01003f2 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01003ad:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003b1:	75 16                	jne    c01003c9 <readline+0x85>
c01003b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003b7:	7e 10                	jle    c01003c9 <readline+0x85>
            cputchar(c);
c01003b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003bc:	89 04 24             	mov    %eax,(%esp)
c01003bf:	e8 04 ff ff ff       	call   c01002c8 <cputchar>
            i --;
c01003c4:	ff 4d f4             	decl   -0xc(%ebp)
c01003c7:	eb 29                	jmp    c01003f2 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003c9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003cd:	74 06                	je     c01003d5 <readline+0x91>
c01003cf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003d3:	75 95                	jne    c010036a <readline+0x26>
            cputchar(c);
c01003d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003d8:	89 04 24             	mov    %eax,(%esp)
c01003db:	e8 e8 fe ff ff       	call   c01002c8 <cputchar>
            buf[i] = '\0';
c01003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003e3:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01003e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003eb:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01003f0:	eb 05                	jmp    c01003f7 <readline+0xb3>
        c = getchar();
c01003f2:	e9 73 ff ff ff       	jmp    c010036a <readline+0x26>
        }
    }
}
c01003f7:	c9                   	leave  
c01003f8:	c3                   	ret    

c01003f9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003f9:	55                   	push   %ebp
c01003fa:	89 e5                	mov    %esp,%ebp
c01003fc:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003ff:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c0100404:	85 c0                	test   %eax,%eax
c0100406:	75 5b                	jne    c0100463 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100408:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c010040f:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100412:	8d 45 14             	lea    0x14(%ebp),%eax
c0100415:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100418:	8b 45 0c             	mov    0xc(%ebp),%eax
c010041b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010041f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100422:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100426:	c7 04 24 ea 5b 10 c0 	movl   $0xc0105bea,(%esp)
c010042d:	e8 70 fe ff ff       	call   c01002a2 <cprintf>
    vcprintf(fmt, ap);
c0100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100435:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100439:	8b 45 10             	mov    0x10(%ebp),%eax
c010043c:	89 04 24             	mov    %eax,(%esp)
c010043f:	e8 2b fe ff ff       	call   c010026f <vcprintf>
    cprintf("\n");
c0100444:	c7 04 24 06 5c 10 c0 	movl   $0xc0105c06,(%esp)
c010044b:	e8 52 fe ff ff       	call   c01002a2 <cprintf>
    
    cprintf("stack trackback:\n");
c0100450:	c7 04 24 08 5c 10 c0 	movl   $0xc0105c08,(%esp)
c0100457:	e8 46 fe ff ff       	call   c01002a2 <cprintf>
    print_stackframe();
c010045c:	e8 32 06 00 00       	call   c0100a93 <print_stackframe>
c0100461:	eb 01                	jmp    c0100464 <__panic+0x6b>
        goto panic_dead;
c0100463:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100464:	e8 40 14 00 00       	call   c01018a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100469:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100470:	e8 52 08 00 00       	call   c0100cc7 <kmonitor>
c0100475:	eb f2                	jmp    c0100469 <__panic+0x70>

c0100477 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100477:	55                   	push   %ebp
c0100478:	89 e5                	mov    %esp,%ebp
c010047a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c010047d:	8d 45 14             	lea    0x14(%ebp),%eax
c0100480:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100483:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100486:	89 44 24 08          	mov    %eax,0x8(%esp)
c010048a:	8b 45 08             	mov    0x8(%ebp),%eax
c010048d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100491:	c7 04 24 1a 5c 10 c0 	movl   $0xc0105c1a,(%esp)
c0100498:	e8 05 fe ff ff       	call   c01002a2 <cprintf>
    vcprintf(fmt, ap);
c010049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a7:	89 04 24             	mov    %eax,(%esp)
c01004aa:	e8 c0 fd ff ff       	call   c010026f <vcprintf>
    cprintf("\n");
c01004af:	c7 04 24 06 5c 10 c0 	movl   $0xc0105c06,(%esp)
c01004b6:	e8 e7 fd ff ff       	call   c01002a2 <cprintf>
    va_end(ap);
}
c01004bb:	90                   	nop
c01004bc:	c9                   	leave  
c01004bd:	c3                   	ret    

c01004be <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004be:	55                   	push   %ebp
c01004bf:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004c1:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c01004c6:	5d                   	pop    %ebp
c01004c7:	c3                   	ret    

c01004c8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004c8:	55                   	push   %ebp
c01004c9:	89 e5                	mov    %esp,%ebp
c01004cb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 00                	mov    (%eax),%eax
c01004d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004d6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d9:	8b 00                	mov    (%eax),%eax
c01004db:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004e5:	e9 ca 00 00 00       	jmp    c01005b4 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004f0:	01 d0                	add    %edx,%eax
c01004f2:	89 c2                	mov    %eax,%edx
c01004f4:	c1 ea 1f             	shr    $0x1f,%edx
c01004f7:	01 d0                	add    %edx,%eax
c01004f9:	d1 f8                	sar    %eax
c01004fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100501:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100504:	eb 03                	jmp    c0100509 <stab_binsearch+0x41>
            m --;
c0100506:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100509:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010050f:	7c 1f                	jl     c0100530 <stab_binsearch+0x68>
c0100511:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100514:	89 d0                	mov    %edx,%eax
c0100516:	01 c0                	add    %eax,%eax
c0100518:	01 d0                	add    %edx,%eax
c010051a:	c1 e0 02             	shl    $0x2,%eax
c010051d:	89 c2                	mov    %eax,%edx
c010051f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100522:	01 d0                	add    %edx,%eax
c0100524:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100528:	0f b6 c0             	movzbl %al,%eax
c010052b:	39 45 14             	cmp    %eax,0x14(%ebp)
c010052e:	75 d6                	jne    c0100506 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100530:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100533:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100536:	7d 09                	jge    c0100541 <stab_binsearch+0x79>
            l = true_m + 1;
c0100538:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010053b:	40                   	inc    %eax
c010053c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010053f:	eb 73                	jmp    c01005b4 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100541:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100548:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010054b:	89 d0                	mov    %edx,%eax
c010054d:	01 c0                	add    %eax,%eax
c010054f:	01 d0                	add    %edx,%eax
c0100551:	c1 e0 02             	shl    $0x2,%eax
c0100554:	89 c2                	mov    %eax,%edx
c0100556:	8b 45 08             	mov    0x8(%ebp),%eax
c0100559:	01 d0                	add    %edx,%eax
c010055b:	8b 40 08             	mov    0x8(%eax),%eax
c010055e:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100561:	76 11                	jbe    c0100574 <stab_binsearch+0xac>
            *region_left = m;
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100569:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010056b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010056e:	40                   	inc    %eax
c010056f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100572:	eb 40                	jmp    c01005b4 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c0100574:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100577:	89 d0                	mov    %edx,%eax
c0100579:	01 c0                	add    %eax,%eax
c010057b:	01 d0                	add    %edx,%eax
c010057d:	c1 e0 02             	shl    $0x2,%eax
c0100580:	89 c2                	mov    %eax,%edx
c0100582:	8b 45 08             	mov    0x8(%ebp),%eax
c0100585:	01 d0                	add    %edx,%eax
c0100587:	8b 40 08             	mov    0x8(%eax),%eax
c010058a:	39 45 18             	cmp    %eax,0x18(%ebp)
c010058d:	73 14                	jae    c01005a3 <stab_binsearch+0xdb>
            *region_right = m - 1;
c010058f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100592:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100595:	8b 45 10             	mov    0x10(%ebp),%eax
c0100598:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010059a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059d:	48                   	dec    %eax
c010059e:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005a1:	eb 11                	jmp    c01005b4 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005a9:	89 10                	mov    %edx,(%eax)
            l = m;
c01005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005b1:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005ba:	0f 8e 2a ff ff ff    	jle    c01004ea <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005c4:	75 0f                	jne    c01005d5 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005c9:	8b 00                	mov    (%eax),%eax
c01005cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005d3:	eb 3e                	jmp    c0100613 <stab_binsearch+0x14b>
        l = *region_right;
c01005d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d8:	8b 00                	mov    (%eax),%eax
c01005da:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005dd:	eb 03                	jmp    c01005e2 <stab_binsearch+0x11a>
c01005df:	ff 4d fc             	decl   -0x4(%ebp)
c01005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005e5:	8b 00                	mov    (%eax),%eax
c01005e7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005ea:	7e 1f                	jle    c010060b <stab_binsearch+0x143>
c01005ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005ef:	89 d0                	mov    %edx,%eax
c01005f1:	01 c0                	add    %eax,%eax
c01005f3:	01 d0                	add    %edx,%eax
c01005f5:	c1 e0 02             	shl    $0x2,%eax
c01005f8:	89 c2                	mov    %eax,%edx
c01005fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01005fd:	01 d0                	add    %edx,%eax
c01005ff:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100603:	0f b6 c0             	movzbl %al,%eax
c0100606:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100609:	75 d4                	jne    c01005df <stab_binsearch+0x117>
        *region_left = l;
c010060b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100611:	89 10                	mov    %edx,(%eax)
}
c0100613:	90                   	nop
c0100614:	c9                   	leave  
c0100615:	c3                   	ret    

c0100616 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100616:	55                   	push   %ebp
c0100617:	89 e5                	mov    %esp,%ebp
c0100619:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010061c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061f:	c7 00 38 5c 10 c0    	movl   $0xc0105c38,(%eax)
    info->eip_line = 0;
c0100625:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010062f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100632:	c7 40 08 38 5c 10 c0 	movl   $0xc0105c38,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100643:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100646:	8b 55 08             	mov    0x8(%ebp),%edx
c0100649:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010064c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010064f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100656:	c7 45 f4 7c 6c 10 c0 	movl   $0xc0106c7c,-0xc(%ebp)
    stab_end = __STAB_END__;
c010065d:	c7 45 f0 b0 19 11 c0 	movl   $0xc01119b0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100664:	c7 45 ec b1 19 11 c0 	movl   $0xc01119b1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010066b:	c7 45 e8 20 46 11 c0 	movl   $0xc0114620,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100675:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100678:	76 0b                	jbe    c0100685 <debuginfo_eip+0x6f>
c010067a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067d:	48                   	dec    %eax
c010067e:	0f b6 00             	movzbl (%eax),%eax
c0100681:	84 c0                	test   %al,%al
c0100683:	74 0a                	je     c010068f <debuginfo_eip+0x79>
        return -1;
c0100685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010068a:	e9 b7 02 00 00       	jmp    c0100946 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010068f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100696:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100699:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069c:	29 c2                	sub    %eax,%edx
c010069e:	89 d0                	mov    %edx,%eax
c01006a0:	c1 f8 02             	sar    $0x2,%eax
c01006a3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006a9:	48                   	dec    %eax
c01006aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01006b0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006b4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006bb:	00 
c01006bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006bf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006cd:	89 04 24             	mov    %eax,(%esp)
c01006d0:	e8 f3 fd ff ff       	call   c01004c8 <stab_binsearch>
    if (lfile == 0)
c01006d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d8:	85 c0                	test   %eax,%eax
c01006da:	75 0a                	jne    c01006e6 <debuginfo_eip+0xd0>
        return -1;
c01006dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006e1:	e9 60 02 00 00       	jmp    c0100946 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01006f5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006f9:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100700:	00 
c0100701:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100704:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100708:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010070b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010070f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100712:	89 04 24             	mov    %eax,(%esp)
c0100715:	e8 ae fd ff ff       	call   c01004c8 <stab_binsearch>

    if (lfun <= rfun) {
c010071a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010071d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100720:	39 c2                	cmp    %eax,%edx
c0100722:	7f 7c                	jg     c01007a0 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100724:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100727:	89 c2                	mov    %eax,%edx
c0100729:	89 d0                	mov    %edx,%eax
c010072b:	01 c0                	add    %eax,%eax
c010072d:	01 d0                	add    %edx,%eax
c010072f:	c1 e0 02             	shl    $0x2,%eax
c0100732:	89 c2                	mov    %eax,%edx
c0100734:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	8b 00                	mov    (%eax),%eax
c010073b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010073e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100741:	29 d1                	sub    %edx,%ecx
c0100743:	89 ca                	mov    %ecx,%edx
c0100745:	39 d0                	cmp    %edx,%eax
c0100747:	73 22                	jae    c010076b <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100749:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010074c:	89 c2                	mov    %eax,%edx
c010074e:	89 d0                	mov    %edx,%eax
c0100750:	01 c0                	add    %eax,%eax
c0100752:	01 d0                	add    %edx,%eax
c0100754:	c1 e0 02             	shl    $0x2,%eax
c0100757:	89 c2                	mov    %eax,%edx
c0100759:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075c:	01 d0                	add    %edx,%eax
c010075e:	8b 10                	mov    (%eax),%edx
c0100760:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100763:	01 c2                	add    %eax,%edx
c0100765:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100768:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010076b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010076e:	89 c2                	mov    %eax,%edx
c0100770:	89 d0                	mov    %edx,%eax
c0100772:	01 c0                	add    %eax,%eax
c0100774:	01 d0                	add    %edx,%eax
c0100776:	c1 e0 02             	shl    $0x2,%eax
c0100779:	89 c2                	mov    %eax,%edx
c010077b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010077e:	01 d0                	add    %edx,%eax
c0100780:	8b 50 08             	mov    0x8(%eax),%edx
c0100783:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100786:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100789:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078c:	8b 40 10             	mov    0x10(%eax),%eax
c010078f:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100792:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100795:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100798:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010079b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010079e:	eb 15                	jmp    c01007b5 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a3:	8b 55 08             	mov    0x8(%ebp),%edx
c01007a6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b8:	8b 40 08             	mov    0x8(%eax),%eax
c01007bb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007c2:	00 
c01007c3:	89 04 24             	mov    %eax,(%esp)
c01007c6:	e8 ef 49 00 00       	call   c01051ba <strfind>
c01007cb:	89 c2                	mov    %eax,%edx
c01007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d0:	8b 40 08             	mov    0x8(%eax),%eax
c01007d3:	29 c2                	sub    %eax,%edx
c01007d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007db:	8b 45 08             	mov    0x8(%ebp),%eax
c01007de:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007e2:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007e9:	00 
c01007ea:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007f1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007fb:	89 04 24             	mov    %eax,(%esp)
c01007fe:	e8 c5 fc ff ff       	call   c01004c8 <stab_binsearch>
    if (lline <= rline) {
c0100803:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100806:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100809:	39 c2                	cmp    %eax,%edx
c010080b:	7f 23                	jg     c0100830 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
c010080d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100810:	89 c2                	mov    %eax,%edx
c0100812:	89 d0                	mov    %edx,%eax
c0100814:	01 c0                	add    %eax,%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	c1 e0 02             	shl    $0x2,%eax
c010081b:	89 c2                	mov    %eax,%edx
c010081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100820:	01 d0                	add    %edx,%eax
c0100822:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100826:	89 c2                	mov    %eax,%edx
c0100828:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082b:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010082e:	eb 11                	jmp    c0100841 <debuginfo_eip+0x22b>
        return -1;
c0100830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100835:	e9 0c 01 00 00       	jmp    c0100946 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010083a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083d:	48                   	dec    %eax
c010083e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100841:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100847:	39 c2                	cmp    %eax,%edx
c0100849:	7c 56                	jl     c01008a1 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
c010084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084e:	89 c2                	mov    %eax,%edx
c0100850:	89 d0                	mov    %edx,%eax
c0100852:	01 c0                	add    %eax,%eax
c0100854:	01 d0                	add    %edx,%eax
c0100856:	c1 e0 02             	shl    $0x2,%eax
c0100859:	89 c2                	mov    %eax,%edx
c010085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085e:	01 d0                	add    %edx,%eax
c0100860:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100864:	3c 84                	cmp    $0x84,%al
c0100866:	74 39                	je     c01008a1 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100868:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010086b:	89 c2                	mov    %eax,%edx
c010086d:	89 d0                	mov    %edx,%eax
c010086f:	01 c0                	add    %eax,%eax
c0100871:	01 d0                	add    %edx,%eax
c0100873:	c1 e0 02             	shl    $0x2,%eax
c0100876:	89 c2                	mov    %eax,%edx
c0100878:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010087b:	01 d0                	add    %edx,%eax
c010087d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100881:	3c 64                	cmp    $0x64,%al
c0100883:	75 b5                	jne    c010083a <debuginfo_eip+0x224>
c0100885:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100888:	89 c2                	mov    %eax,%edx
c010088a:	89 d0                	mov    %edx,%eax
c010088c:	01 c0                	add    %eax,%eax
c010088e:	01 d0                	add    %edx,%eax
c0100890:	c1 e0 02             	shl    $0x2,%eax
c0100893:	89 c2                	mov    %eax,%edx
c0100895:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100898:	01 d0                	add    %edx,%eax
c010089a:	8b 40 08             	mov    0x8(%eax),%eax
c010089d:	85 c0                	test   %eax,%eax
c010089f:	74 99                	je     c010083a <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008a7:	39 c2                	cmp    %eax,%edx
c01008a9:	7c 46                	jl     c01008f1 <debuginfo_eip+0x2db>
c01008ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008ae:	89 c2                	mov    %eax,%edx
c01008b0:	89 d0                	mov    %edx,%eax
c01008b2:	01 c0                	add    %eax,%eax
c01008b4:	01 d0                	add    %edx,%eax
c01008b6:	c1 e0 02             	shl    $0x2,%eax
c01008b9:	89 c2                	mov    %eax,%edx
c01008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008be:	01 d0                	add    %edx,%eax
c01008c0:	8b 00                	mov    (%eax),%eax
c01008c2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008c8:	29 d1                	sub    %edx,%ecx
c01008ca:	89 ca                	mov    %ecx,%edx
c01008cc:	39 d0                	cmp    %edx,%eax
c01008ce:	73 21                	jae    c01008f1 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d3:	89 c2                	mov    %eax,%edx
c01008d5:	89 d0                	mov    %edx,%eax
c01008d7:	01 c0                	add    %eax,%eax
c01008d9:	01 d0                	add    %edx,%eax
c01008db:	c1 e0 02             	shl    $0x2,%eax
c01008de:	89 c2                	mov    %eax,%edx
c01008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e3:	01 d0                	add    %edx,%eax
c01008e5:	8b 10                	mov    (%eax),%edx
c01008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008ea:	01 c2                	add    %eax,%edx
c01008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ef:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008f7:	39 c2                	cmp    %eax,%edx
c01008f9:	7d 46                	jge    c0100941 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
c01008fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008fe:	40                   	inc    %eax
c01008ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100902:	eb 16                	jmp    c010091a <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100904:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100907:	8b 40 14             	mov    0x14(%eax),%eax
c010090a:	8d 50 01             	lea    0x1(%eax),%edx
c010090d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100910:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100916:	40                   	inc    %eax
c0100917:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010091a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100920:	39 c2                	cmp    %eax,%edx
c0100922:	7d 1d                	jge    c0100941 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100924:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100927:	89 c2                	mov    %eax,%edx
c0100929:	89 d0                	mov    %edx,%eax
c010092b:	01 c0                	add    %eax,%eax
c010092d:	01 d0                	add    %edx,%eax
c010092f:	c1 e0 02             	shl    $0x2,%eax
c0100932:	89 c2                	mov    %eax,%edx
c0100934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100937:	01 d0                	add    %edx,%eax
c0100939:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010093d:	3c a0                	cmp    $0xa0,%al
c010093f:	74 c3                	je     c0100904 <debuginfo_eip+0x2ee>
        }
    }
    return 0;
c0100941:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100946:	c9                   	leave  
c0100947:	c3                   	ret    

c0100948 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100948:	55                   	push   %ebp
c0100949:	89 e5                	mov    %esp,%ebp
c010094b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010094e:	c7 04 24 42 5c 10 c0 	movl   $0xc0105c42,(%esp)
c0100955:	e8 48 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010095a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100961:	c0 
c0100962:	c7 04 24 5b 5c 10 c0 	movl   $0xc0105c5b,(%esp)
c0100969:	e8 34 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010096e:	c7 44 24 04 38 5b 10 	movl   $0xc0105b38,0x4(%esp)
c0100975:	c0 
c0100976:	c7 04 24 73 5c 10 c0 	movl   $0xc0105c73,(%esp)
c010097d:	e8 20 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100982:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c0100989:	c0 
c010098a:	c7 04 24 8b 5c 10 c0 	movl   $0xc0105c8b,(%esp)
c0100991:	e8 0c f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100996:	c7 44 24 04 94 af 25 	movl   $0xc025af94,0x4(%esp)
c010099d:	c0 
c010099e:	c7 04 24 a3 5c 10 c0 	movl   $0xc0105ca3,(%esp)
c01009a5:	e8 f8 f8 ff ff       	call   c01002a2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009aa:	b8 94 af 25 c0       	mov    $0xc025af94,%eax
c01009af:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009b5:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009ba:	29 c2                	sub    %eax,%edx
c01009bc:	89 d0                	mov    %edx,%eax
c01009be:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009c4:	85 c0                	test   %eax,%eax
c01009c6:	0f 48 c2             	cmovs  %edx,%eax
c01009c9:	c1 f8 0a             	sar    $0xa,%eax
c01009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d0:	c7 04 24 bc 5c 10 c0 	movl   $0xc0105cbc,(%esp)
c01009d7:	e8 c6 f8 ff ff       	call   c01002a2 <cprintf>
}
c01009dc:	90                   	nop
c01009dd:	c9                   	leave  
c01009de:	c3                   	ret    

c01009df <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009df:	55                   	push   %ebp
c01009e0:	89 e5                	mov    %esp,%ebp
c01009e2:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009e8:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01009f2:	89 04 24             	mov    %eax,(%esp)
c01009f5:	e8 1c fc ff ff       	call   c0100616 <debuginfo_eip>
c01009fa:	85 c0                	test   %eax,%eax
c01009fc:	74 15                	je     c0100a13 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a05:	c7 04 24 e6 5c 10 c0 	movl   $0xc0105ce6,(%esp)
c0100a0c:	e8 91 f8 ff ff       	call   c01002a2 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a11:	eb 6c                	jmp    c0100a7f <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a1a:	eb 1b                	jmp    c0100a37 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a22:	01 d0                	add    %edx,%eax
c0100a24:	0f b6 00             	movzbl (%eax),%eax
c0100a27:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a30:	01 ca                	add    %ecx,%edx
c0100a32:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a34:	ff 45 f4             	incl   -0xc(%ebp)
c0100a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a3a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a3d:	7c dd                	jl     c0100a1c <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100a3f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a48:	01 d0                	add    %edx,%eax
c0100a4a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a50:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a53:	89 d1                	mov    %edx,%ecx
c0100a55:	29 c1                	sub    %eax,%ecx
c0100a57:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a5d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a61:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a73:	c7 04 24 02 5d 10 c0 	movl   $0xc0105d02,(%esp)
c0100a7a:	e8 23 f8 ff ff       	call   c01002a2 <cprintf>
}
c0100a7f:	90                   	nop
c0100a80:	c9                   	leave  
c0100a81:	c3                   	ret    

c0100a82 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a82:	55                   	push   %ebp
c0100a83:	89 e5                	mov    %esp,%ebp
c0100a85:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a88:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a91:	c9                   	leave  
c0100a92:	c3                   	ret    

c0100a93 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a93:	55                   	push   %ebp
c0100a94:	89 e5                	mov    %esp,%ebp
c0100a96:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a99:	89 e8                	mov    %ebp,%eax
c0100a9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp();
c0100aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip  = read_eip();
c0100aa4:	e8 d9 ff ff ff       	call   c0100a82 <read_eip>
c0100aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
     int j ;
     for(int i = 0;ebp!=0 && i<STACKFRAME_DEPTH;i++)
c0100aac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100ab3:	e9 90 00 00 00       	jmp    c0100b48 <print_stackframe+0xb5>
     {
         cprintf("ebp:0x%08x  eip:0x%08x    ", ebp, eip);
c0100ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac6:	c7 04 24 14 5d 10 c0 	movl   $0xc0105d14,(%esp)
c0100acd:	e8 d0 f7 ff ff       	call   c01002a2 <cprintf>
         cprintf("arg:");
c0100ad2:	c7 04 24 2f 5d 10 c0 	movl   $0xc0105d2f,(%esp)
c0100ad9:	e8 c4 f7 ff ff       	call   c01002a2 <cprintf>
         uint32_t *args = (uint32_t *)ebp + 2;
c0100ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae1:	83 c0 08             	add    $0x8,%eax
c0100ae4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
         for(j=0; j<=4; j++)
c0100ae7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100aee:	eb 24                	jmp    c0100b14 <print_stackframe+0x81>
             cprintf("0x%08x    ", args[j]);
c0100af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100afd:	01 d0                	add    %edx,%eax
c0100aff:	8b 00                	mov    (%eax),%eax
c0100b01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b05:	c7 04 24 34 5d 10 c0 	movl   $0xc0105d34,(%esp)
c0100b0c:	e8 91 f7 ff ff       	call   c01002a2 <cprintf>
         for(j=0; j<=4; j++)
c0100b11:	ff 45 ec             	incl   -0x14(%ebp)
c0100b14:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
c0100b18:	7e d6                	jle    c0100af0 <print_stackframe+0x5d>
         cprintf("\n");
c0100b1a:	c7 04 24 3f 5d 10 c0 	movl   $0xc0105d3f,(%esp)
c0100b21:	e8 7c f7 ff ff       	call   c01002a2 <cprintf>
         print_debuginfo(eip-1);
c0100b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b29:	48                   	dec    %eax
c0100b2a:	89 04 24             	mov    %eax,(%esp)
c0100b2d:	e8 ad fe ff ff       	call   c01009df <print_debuginfo>
         eip = ((uint32_t *)ebp)[1];
c0100b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b35:	83 c0 04             	add    $0x4,%eax
c0100b38:	8b 00                	mov    (%eax),%eax
c0100b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
         ebp = ((uint32_t *)ebp)[0];
c0100b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b40:	8b 00                	mov    (%eax),%eax
c0100b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for(int i = 0;ebp!=0 && i<STACKFRAME_DEPTH;i++)
c0100b45:	ff 45 e8             	incl   -0x18(%ebp)
c0100b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b4c:	74 0a                	je     c0100b58 <print_stackframe+0xc5>
c0100b4e:	83 7d e8 13          	cmpl   $0x13,-0x18(%ebp)
c0100b52:	0f 8e 60 ff ff ff    	jle    c0100ab8 <print_stackframe+0x25>
     }
}
c0100b58:	90                   	nop
c0100b59:	c9                   	leave  
c0100b5a:	c3                   	ret    

c0100b5b <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b5b:	55                   	push   %ebp
c0100b5c:	89 e5                	mov    %esp,%ebp
c0100b5e:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b68:	eb 0c                	jmp    c0100b76 <parse+0x1b>
            *buf ++ = '\0';
c0100b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6d:	8d 50 01             	lea    0x1(%eax),%edx
c0100b70:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b73:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b76:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b79:	0f b6 00             	movzbl (%eax),%eax
c0100b7c:	84 c0                	test   %al,%al
c0100b7e:	74 1d                	je     c0100b9d <parse+0x42>
c0100b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b83:	0f b6 00             	movzbl (%eax),%eax
c0100b86:	0f be c0             	movsbl %al,%eax
c0100b89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b8d:	c7 04 24 c4 5d 10 c0 	movl   $0xc0105dc4,(%esp)
c0100b94:	e8 ef 45 00 00       	call   c0105188 <strchr>
c0100b99:	85 c0                	test   %eax,%eax
c0100b9b:	75 cd                	jne    c0100b6a <parse+0xf>
        }
        if (*buf == '\0') {
c0100b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba0:	0f b6 00             	movzbl (%eax),%eax
c0100ba3:	84 c0                	test   %al,%al
c0100ba5:	74 65                	je     c0100c0c <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ba7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bab:	75 14                	jne    c0100bc1 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bad:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bb4:	00 
c0100bb5:	c7 04 24 c9 5d 10 c0 	movl   $0xc0105dc9,(%esp)
c0100bbc:	e8 e1 f6 ff ff       	call   c01002a2 <cprintf>
        }
        argv[argc ++] = buf;
c0100bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc4:	8d 50 01             	lea    0x1(%eax),%edx
c0100bc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bd4:	01 c2                	add    %eax,%edx
c0100bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bdb:	eb 03                	jmp    c0100be0 <parse+0x85>
            buf ++;
c0100bdd:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100be0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100be3:	0f b6 00             	movzbl (%eax),%eax
c0100be6:	84 c0                	test   %al,%al
c0100be8:	74 8c                	je     c0100b76 <parse+0x1b>
c0100bea:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bed:	0f b6 00             	movzbl (%eax),%eax
c0100bf0:	0f be c0             	movsbl %al,%eax
c0100bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bf7:	c7 04 24 c4 5d 10 c0 	movl   $0xc0105dc4,(%esp)
c0100bfe:	e8 85 45 00 00       	call   c0105188 <strchr>
c0100c03:	85 c0                	test   %eax,%eax
c0100c05:	74 d6                	je     c0100bdd <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c07:	e9 6a ff ff ff       	jmp    c0100b76 <parse+0x1b>
            break;
c0100c0c:	90                   	nop
        }
    }
    return argc;
c0100c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c10:	c9                   	leave  
c0100c11:	c3                   	ret    

c0100c12 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c12:	55                   	push   %ebp
c0100c13:	89 e5                	mov    %esp,%ebp
c0100c15:	53                   	push   %ebx
c0100c16:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c19:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c23:	89 04 24             	mov    %eax,(%esp)
c0100c26:	e8 30 ff ff ff       	call   c0100b5b <parse>
c0100c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c32:	75 0a                	jne    c0100c3e <runcmd+0x2c>
        return 0;
c0100c34:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c39:	e9 83 00 00 00       	jmp    c0100cc1 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c45:	eb 5a                	jmp    c0100ca1 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c47:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c4d:	89 d0                	mov    %edx,%eax
c0100c4f:	01 c0                	add    %eax,%eax
c0100c51:	01 d0                	add    %edx,%eax
c0100c53:	c1 e0 02             	shl    $0x2,%eax
c0100c56:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c5b:	8b 00                	mov    (%eax),%eax
c0100c5d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c61:	89 04 24             	mov    %eax,(%esp)
c0100c64:	e8 82 44 00 00       	call   c01050eb <strcmp>
c0100c69:	85 c0                	test   %eax,%eax
c0100c6b:	75 31                	jne    c0100c9e <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c70:	89 d0                	mov    %edx,%eax
c0100c72:	01 c0                	add    %eax,%eax
c0100c74:	01 d0                	add    %edx,%eax
c0100c76:	c1 e0 02             	shl    $0x2,%eax
c0100c79:	05 08 70 11 c0       	add    $0xc0117008,%eax
c0100c7e:	8b 10                	mov    (%eax),%edx
c0100c80:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c83:	83 c0 04             	add    $0x4,%eax
c0100c86:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c89:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100c8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c97:	89 1c 24             	mov    %ebx,(%esp)
c0100c9a:	ff d2                	call   *%edx
c0100c9c:	eb 23                	jmp    c0100cc1 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9e:	ff 45 f4             	incl   -0xc(%ebp)
c0100ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca4:	83 f8 02             	cmp    $0x2,%eax
c0100ca7:	76 9e                	jbe    c0100c47 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100ca9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cb0:	c7 04 24 e7 5d 10 c0 	movl   $0xc0105de7,(%esp)
c0100cb7:	e8 e6 f5 ff ff       	call   c01002a2 <cprintf>
    return 0;
c0100cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc1:	83 c4 64             	add    $0x64,%esp
c0100cc4:	5b                   	pop    %ebx
c0100cc5:	5d                   	pop    %ebp
c0100cc6:	c3                   	ret    

c0100cc7 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cc7:	55                   	push   %ebp
c0100cc8:	89 e5                	mov    %esp,%ebp
c0100cca:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100ccd:	c7 04 24 00 5e 10 c0 	movl   $0xc0105e00,(%esp)
c0100cd4:	e8 c9 f5 ff ff       	call   c01002a2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cd9:	c7 04 24 28 5e 10 c0 	movl   $0xc0105e28,(%esp)
c0100ce0:	e8 bd f5 ff ff       	call   c01002a2 <cprintf>

    if (tf != NULL) {
c0100ce5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ce9:	74 0b                	je     c0100cf6 <kmonitor+0x2f>
        print_trapframe(tf);
c0100ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cee:	89 04 24             	mov    %eax,(%esp)
c0100cf1:	e8 8d 0d 00 00       	call   c0101a83 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cf6:	c7 04 24 4d 5e 10 c0 	movl   $0xc0105e4d,(%esp)
c0100cfd:	e8 42 f6 ff ff       	call   c0100344 <readline>
c0100d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d09:	74 eb                	je     c0100cf6 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100d0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d15:	89 04 24             	mov    %eax,(%esp)
c0100d18:	e8 f5 fe ff ff       	call   c0100c12 <runcmd>
c0100d1d:	85 c0                	test   %eax,%eax
c0100d1f:	78 02                	js     c0100d23 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100d21:	eb d3                	jmp    c0100cf6 <kmonitor+0x2f>
                break;
c0100d23:	90                   	nop
            }
        }
    }
}
c0100d24:	90                   	nop
c0100d25:	c9                   	leave  
c0100d26:	c3                   	ret    

c0100d27 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d27:	55                   	push   %ebp
c0100d28:	89 e5                	mov    %esp,%ebp
c0100d2a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d34:	eb 3d                	jmp    c0100d73 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d39:	89 d0                	mov    %edx,%eax
c0100d3b:	01 c0                	add    %eax,%eax
c0100d3d:	01 d0                	add    %edx,%eax
c0100d3f:	c1 e0 02             	shl    $0x2,%eax
c0100d42:	05 04 70 11 c0       	add    $0xc0117004,%eax
c0100d47:	8b 08                	mov    (%eax),%ecx
c0100d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d4c:	89 d0                	mov    %edx,%eax
c0100d4e:	01 c0                	add    %eax,%eax
c0100d50:	01 d0                	add    %edx,%eax
c0100d52:	c1 e0 02             	shl    $0x2,%eax
c0100d55:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100d5a:	8b 00                	mov    (%eax),%eax
c0100d5c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d64:	c7 04 24 51 5e 10 c0 	movl   $0xc0105e51,(%esp)
c0100d6b:	e8 32 f5 ff ff       	call   c01002a2 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d70:	ff 45 f4             	incl   -0xc(%ebp)
c0100d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d76:	83 f8 02             	cmp    $0x2,%eax
c0100d79:	76 bb                	jbe    c0100d36 <mon_help+0xf>
    }
    return 0;
c0100d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d80:	c9                   	leave  
c0100d81:	c3                   	ret    

c0100d82 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d88:	e8 bb fb ff ff       	call   c0100948 <print_kerninfo>
    return 0;
c0100d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d92:	c9                   	leave  
c0100d93:	c3                   	ret    

c0100d94 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d94:	55                   	push   %ebp
c0100d95:	89 e5                	mov    %esp,%ebp
c0100d97:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d9a:	e8 f4 fc ff ff       	call   c0100a93 <print_stackframe>
    return 0;
c0100d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100da4:	c9                   	leave  
c0100da5:	c3                   	ret    

c0100da6 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100da6:	55                   	push   %ebp
c0100da7:	89 e5                	mov    %esp,%ebp
c0100da9:	83 ec 28             	sub    $0x28,%esp
c0100dac:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100db2:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100db6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dba:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dbe:	ee                   	out    %al,(%dx)
c0100dbf:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dc5:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dc9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dcd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dd1:	ee                   	out    %al,(%dx)
c0100dd2:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100dd8:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100ddc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100de0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100de4:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100de5:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100dec:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100def:	c7 04 24 5a 5e 10 c0 	movl   $0xc0105e5a,(%esp)
c0100df6:	e8 a7 f4 ff ff       	call   c01002a2 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e02:	e8 2e 09 00 00       	call   c0101735 <pic_enable>
}
c0100e07:	90                   	nop
c0100e08:	c9                   	leave  
c0100e09:	c3                   	ret    

c0100e0a <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e0a:	55                   	push   %ebp
c0100e0b:	89 e5                	mov    %esp,%ebp
c0100e0d:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e10:	9c                   	pushf  
c0100e11:	58                   	pop    %eax
c0100e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e18:	25 00 02 00 00       	and    $0x200,%eax
c0100e1d:	85 c0                	test   %eax,%eax
c0100e1f:	74 0c                	je     c0100e2d <__intr_save+0x23>
        intr_disable();
c0100e21:	e8 83 0a 00 00       	call   c01018a9 <intr_disable>
        return 1;
c0100e26:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e2b:	eb 05                	jmp    c0100e32 <__intr_save+0x28>
    }
    return 0;
c0100e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e32:	c9                   	leave  
c0100e33:	c3                   	ret    

c0100e34 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e34:	55                   	push   %ebp
c0100e35:	89 e5                	mov    %esp,%ebp
c0100e37:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e3e:	74 05                	je     c0100e45 <__intr_restore+0x11>
        intr_enable();
c0100e40:	e8 5d 0a 00 00       	call   c01018a2 <intr_enable>
    }
}
c0100e45:	90                   	nop
c0100e46:	c9                   	leave  
c0100e47:	c3                   	ret    

c0100e48 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e48:	55                   	push   %ebp
c0100e49:	89 e5                	mov    %esp,%ebp
c0100e4b:	83 ec 10             	sub    $0x10,%esp
c0100e4e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e54:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e58:	89 c2                	mov    %eax,%edx
c0100e5a:	ec                   	in     (%dx),%al
c0100e5b:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e5e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e64:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e68:	89 c2                	mov    %eax,%edx
c0100e6a:	ec                   	in     (%dx),%al
c0100e6b:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e74:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e78:	89 c2                	mov    %eax,%edx
c0100e7a:	ec                   	in     (%dx),%al
c0100e7b:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e7e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e84:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e88:	89 c2                	mov    %eax,%edx
c0100e8a:	ec                   	in     (%dx),%al
c0100e8b:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e8e:	90                   	nop
c0100e8f:	c9                   	leave  
c0100e90:	c3                   	ret    

c0100e91 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e91:	55                   	push   %ebp
c0100e92:	89 e5                	mov    %esp,%ebp
c0100e94:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e97:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea1:	0f b7 00             	movzwl (%eax),%eax
c0100ea4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eab:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb3:	0f b7 00             	movzwl (%eax),%eax
c0100eb6:	0f b7 c0             	movzwl %ax,%eax
c0100eb9:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100ebe:	74 12                	je     c0100ed2 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ec0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ec7:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100ece:	b4 03 
c0100ed0:	eb 13                	jmp    c0100ee5 <cga_init+0x54>
    } else {
        *cp = was;
c0100ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ed9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100edc:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ee3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee5:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100eec:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ef0:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ef8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100efc:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100efd:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f04:	40                   	inc    %eax
c0100f05:	0f b7 c0             	movzwl %ax,%eax
c0100f08:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f0c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f10:	89 c2                	mov    %eax,%edx
c0100f12:	ec                   	in     (%dx),%al
c0100f13:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f1a:	0f b6 c0             	movzbl %al,%eax
c0100f1d:	c1 e0 08             	shl    $0x8,%eax
c0100f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f23:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f2a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f2e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f32:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f36:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f3a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f3b:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f42:	40                   	inc    %eax
c0100f43:	0f b7 c0             	movzwl %ax,%eax
c0100f46:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f4a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f4e:	89 c2                	mov    %eax,%edx
c0100f50:	ec                   	in     (%dx),%al
c0100f51:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f54:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f58:	0f b6 c0             	movzbl %al,%eax
c0100f5b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f61:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f69:	0f b7 c0             	movzwl %ax,%eax
c0100f6c:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f72:	90                   	nop
c0100f73:	c9                   	leave  
c0100f74:	c3                   	ret    

c0100f75 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f75:	55                   	push   %ebp
c0100f76:	89 e5                	mov    %esp,%ebp
c0100f78:	83 ec 48             	sub    $0x48,%esp
c0100f7b:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f81:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f85:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f89:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f8d:	ee                   	out    %al,(%dx)
c0100f8e:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f94:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0100f98:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f9c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fa0:	ee                   	out    %al,(%dx)
c0100fa1:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fa7:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0100fab:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100faf:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fb3:	ee                   	out    %al,(%dx)
c0100fb4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fba:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100fbe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fc2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fc6:	ee                   	out    %al,(%dx)
c0100fc7:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100fcd:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0100fd1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd9:	ee                   	out    %al,(%dx)
c0100fda:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fe0:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0100fe4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fe8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fec:	ee                   	out    %al,(%dx)
c0100fed:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100ff3:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0100ff7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ffb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fff:	ee                   	out    %al,(%dx)
c0101000:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101006:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010100a:	89 c2                	mov    %eax,%edx
c010100c:	ec                   	in     (%dx),%al
c010100d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101010:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101014:	3c ff                	cmp    $0xff,%al
c0101016:	0f 95 c0             	setne  %al
c0101019:	0f b6 c0             	movzbl %al,%eax
c010101c:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0101021:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101027:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010102b:	89 c2                	mov    %eax,%edx
c010102d:	ec                   	in     (%dx),%al
c010102e:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101031:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101037:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010103b:	89 c2                	mov    %eax,%edx
c010103d:	ec                   	in     (%dx),%al
c010103e:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101041:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101046:	85 c0                	test   %eax,%eax
c0101048:	74 0c                	je     c0101056 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010104a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101051:	e8 df 06 00 00       	call   c0101735 <pic_enable>
    }
}
c0101056:	90                   	nop
c0101057:	c9                   	leave  
c0101058:	c3                   	ret    

c0101059 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101059:	55                   	push   %ebp
c010105a:	89 e5                	mov    %esp,%ebp
c010105c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101066:	eb 08                	jmp    c0101070 <lpt_putc_sub+0x17>
        delay();
c0101068:	e8 db fd ff ff       	call   c0100e48 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010106d:	ff 45 fc             	incl   -0x4(%ebp)
c0101070:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101076:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010107a:	89 c2                	mov    %eax,%edx
c010107c:	ec                   	in     (%dx),%al
c010107d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101080:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101084:	84 c0                	test   %al,%al
c0101086:	78 09                	js     c0101091 <lpt_putc_sub+0x38>
c0101088:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010108f:	7e d7                	jle    c0101068 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0101091:	8b 45 08             	mov    0x8(%ebp),%eax
c0101094:	0f b6 c0             	movzbl %al,%eax
c0101097:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c010109d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a8:	ee                   	out    %al,(%dx)
c01010a9:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010af:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010b3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010b7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010bb:	ee                   	out    %al,(%dx)
c01010bc:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010c2:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c01010c6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010ca:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010ce:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010cf:	90                   	nop
c01010d0:	c9                   	leave  
c01010d1:	c3                   	ret    

c01010d2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010d2:	55                   	push   %ebp
c01010d3:	89 e5                	mov    %esp,%ebp
c01010d5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010d8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010dc:	74 0d                	je     c01010eb <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010de:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e1:	89 04 24             	mov    %eax,(%esp)
c01010e4:	e8 70 ff ff ff       	call   c0101059 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010e9:	eb 24                	jmp    c010110f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c01010eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f2:	e8 62 ff ff ff       	call   c0101059 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010f7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010fe:	e8 56 ff ff ff       	call   c0101059 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101103:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010110a:	e8 4a ff ff ff       	call   c0101059 <lpt_putc_sub>
}
c010110f:	90                   	nop
c0101110:	c9                   	leave  
c0101111:	c3                   	ret    

c0101112 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101112:	55                   	push   %ebp
c0101113:	89 e5                	mov    %esp,%ebp
c0101115:	53                   	push   %ebx
c0101116:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101119:	8b 45 08             	mov    0x8(%ebp),%eax
c010111c:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101121:	85 c0                	test   %eax,%eax
c0101123:	75 07                	jne    c010112c <cga_putc+0x1a>
        c |= 0x0700;
c0101125:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010112c:	8b 45 08             	mov    0x8(%ebp),%eax
c010112f:	0f b6 c0             	movzbl %al,%eax
c0101132:	83 f8 0a             	cmp    $0xa,%eax
c0101135:	74 55                	je     c010118c <cga_putc+0x7a>
c0101137:	83 f8 0d             	cmp    $0xd,%eax
c010113a:	74 63                	je     c010119f <cga_putc+0x8d>
c010113c:	83 f8 08             	cmp    $0x8,%eax
c010113f:	0f 85 94 00 00 00    	jne    c01011d9 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c0101145:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010114c:	85 c0                	test   %eax,%eax
c010114e:	0f 84 af 00 00 00    	je     c0101203 <cga_putc+0xf1>
            crt_pos --;
c0101154:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010115b:	48                   	dec    %eax
c010115c:	0f b7 c0             	movzwl %ax,%eax
c010115f:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101165:	8b 45 08             	mov    0x8(%ebp),%eax
c0101168:	98                   	cwtl   
c0101169:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010116e:	98                   	cwtl   
c010116f:	83 c8 20             	or     $0x20,%eax
c0101172:	98                   	cwtl   
c0101173:	8b 15 40 a4 11 c0    	mov    0xc011a440,%edx
c0101179:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c0101180:	01 c9                	add    %ecx,%ecx
c0101182:	01 ca                	add    %ecx,%edx
c0101184:	0f b7 c0             	movzwl %ax,%eax
c0101187:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010118a:	eb 77                	jmp    c0101203 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c010118c:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101193:	83 c0 50             	add    $0x50,%eax
c0101196:	0f b7 c0             	movzwl %ax,%eax
c0101199:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010119f:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c01011a6:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c01011ad:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01011b2:	89 c8                	mov    %ecx,%eax
c01011b4:	f7 e2                	mul    %edx
c01011b6:	c1 ea 06             	shr    $0x6,%edx
c01011b9:	89 d0                	mov    %edx,%eax
c01011bb:	c1 e0 02             	shl    $0x2,%eax
c01011be:	01 d0                	add    %edx,%eax
c01011c0:	c1 e0 04             	shl    $0x4,%eax
c01011c3:	29 c1                	sub    %eax,%ecx
c01011c5:	89 c8                	mov    %ecx,%eax
c01011c7:	0f b7 c0             	movzwl %ax,%eax
c01011ca:	29 c3                	sub    %eax,%ebx
c01011cc:	89 d8                	mov    %ebx,%eax
c01011ce:	0f b7 c0             	movzwl %ax,%eax
c01011d1:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011d7:	eb 2b                	jmp    c0101204 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011d9:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011df:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011e6:	8d 50 01             	lea    0x1(%eax),%edx
c01011e9:	0f b7 d2             	movzwl %dx,%edx
c01011ec:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011f3:	01 c0                	add    %eax,%eax
c01011f5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01011fb:	0f b7 c0             	movzwl %ax,%eax
c01011fe:	66 89 02             	mov    %ax,(%edx)
        break;
c0101201:	eb 01                	jmp    c0101204 <cga_putc+0xf2>
        break;
c0101203:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101204:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010120b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101210:	76 5d                	jbe    c010126f <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101212:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101217:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010121d:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101222:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101229:	00 
c010122a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010122e:	89 04 24             	mov    %eax,(%esp)
c0101231:	e8 48 41 00 00       	call   c010537e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101236:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010123d:	eb 14                	jmp    c0101253 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c010123f:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101244:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101247:	01 d2                	add    %edx,%edx
c0101249:	01 d0                	add    %edx,%eax
c010124b:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101250:	ff 45 f4             	incl   -0xc(%ebp)
c0101253:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010125a:	7e e3                	jle    c010123f <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
c010125c:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101263:	83 e8 50             	sub    $0x50,%eax
c0101266:	0f b7 c0             	movzwl %ax,%eax
c0101269:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010126f:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101276:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010127a:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c010127e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101282:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101286:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101287:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010128e:	c1 e8 08             	shr    $0x8,%eax
c0101291:	0f b7 c0             	movzwl %ax,%eax
c0101294:	0f b6 c0             	movzbl %al,%eax
c0101297:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c010129e:	42                   	inc    %edx
c010129f:	0f b7 d2             	movzwl %dx,%edx
c01012a2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012a6:	88 45 e9             	mov    %al,-0x17(%ebp)
c01012a9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012ad:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012b1:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012b2:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c01012b9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012bd:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c01012c1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012c5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012c9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012ca:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012d1:	0f b6 c0             	movzbl %al,%eax
c01012d4:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012db:	42                   	inc    %edx
c01012dc:	0f b7 d2             	movzwl %dx,%edx
c01012df:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012e3:	88 45 f1             	mov    %al,-0xf(%ebp)
c01012e6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012ea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012ee:	ee                   	out    %al,(%dx)
}
c01012ef:	90                   	nop
c01012f0:	83 c4 34             	add    $0x34,%esp
c01012f3:	5b                   	pop    %ebx
c01012f4:	5d                   	pop    %ebp
c01012f5:	c3                   	ret    

c01012f6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012f6:	55                   	push   %ebp
c01012f7:	89 e5                	mov    %esp,%ebp
c01012f9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101303:	eb 08                	jmp    c010130d <serial_putc_sub+0x17>
        delay();
c0101305:	e8 3e fb ff ff       	call   c0100e48 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010130a:	ff 45 fc             	incl   -0x4(%ebp)
c010130d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101313:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101317:	89 c2                	mov    %eax,%edx
c0101319:	ec                   	in     (%dx),%al
c010131a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010131d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101321:	0f b6 c0             	movzbl %al,%eax
c0101324:	83 e0 20             	and    $0x20,%eax
c0101327:	85 c0                	test   %eax,%eax
c0101329:	75 09                	jne    c0101334 <serial_putc_sub+0x3e>
c010132b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101332:	7e d1                	jle    c0101305 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101334:	8b 45 08             	mov    0x8(%ebp),%eax
c0101337:	0f b6 c0             	movzbl %al,%eax
c010133a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101340:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101343:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101347:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010134b:	ee                   	out    %al,(%dx)
}
c010134c:	90                   	nop
c010134d:	c9                   	leave  
c010134e:	c3                   	ret    

c010134f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010134f:	55                   	push   %ebp
c0101350:	89 e5                	mov    %esp,%ebp
c0101352:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101355:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101359:	74 0d                	je     c0101368 <serial_putc+0x19>
        serial_putc_sub(c);
c010135b:	8b 45 08             	mov    0x8(%ebp),%eax
c010135e:	89 04 24             	mov    %eax,(%esp)
c0101361:	e8 90 ff ff ff       	call   c01012f6 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101366:	eb 24                	jmp    c010138c <serial_putc+0x3d>
        serial_putc_sub('\b');
c0101368:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010136f:	e8 82 ff ff ff       	call   c01012f6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101374:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010137b:	e8 76 ff ff ff       	call   c01012f6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101380:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101387:	e8 6a ff ff ff       	call   c01012f6 <serial_putc_sub>
}
c010138c:	90                   	nop
c010138d:	c9                   	leave  
c010138e:	c3                   	ret    

c010138f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010138f:	55                   	push   %ebp
c0101390:	89 e5                	mov    %esp,%ebp
c0101392:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101395:	eb 33                	jmp    c01013ca <cons_intr+0x3b>
        if (c != 0) {
c0101397:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010139b:	74 2d                	je     c01013ca <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010139d:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01013a2:	8d 50 01             	lea    0x1(%eax),%edx
c01013a5:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c01013ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013ae:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013b4:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01013b9:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013be:	75 0a                	jne    c01013ca <cons_intr+0x3b>
                cons.wpos = 0;
c01013c0:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01013c7:	00 00 00 
    while ((c = (*proc)()) != -1) {
c01013ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01013cd:	ff d0                	call   *%eax
c01013cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013d2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013d6:	75 bf                	jne    c0101397 <cons_intr+0x8>
            }
        }
    }
}
c01013d8:	90                   	nop
c01013d9:	c9                   	leave  
c01013da:	c3                   	ret    

c01013db <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013db:	55                   	push   %ebp
c01013dc:	89 e5                	mov    %esp,%ebp
c01013de:	83 ec 10             	sub    $0x10,%esp
c01013e1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013eb:	89 c2                	mov    %eax,%edx
c01013ed:	ec                   	in     (%dx),%al
c01013ee:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013f1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013f5:	0f b6 c0             	movzbl %al,%eax
c01013f8:	83 e0 01             	and    $0x1,%eax
c01013fb:	85 c0                	test   %eax,%eax
c01013fd:	75 07                	jne    c0101406 <serial_proc_data+0x2b>
        return -1;
c01013ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101404:	eb 2a                	jmp    c0101430 <serial_proc_data+0x55>
c0101406:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010140c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101410:	89 c2                	mov    %eax,%edx
c0101412:	ec                   	in     (%dx),%al
c0101413:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101416:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010141a:	0f b6 c0             	movzbl %al,%eax
c010141d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101420:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101424:	75 07                	jne    c010142d <serial_proc_data+0x52>
        c = '\b';
c0101426:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010142d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101430:	c9                   	leave  
c0101431:	c3                   	ret    

c0101432 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101432:	55                   	push   %ebp
c0101433:	89 e5                	mov    %esp,%ebp
c0101435:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101438:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010143d:	85 c0                	test   %eax,%eax
c010143f:	74 0c                	je     c010144d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101441:	c7 04 24 db 13 10 c0 	movl   $0xc01013db,(%esp)
c0101448:	e8 42 ff ff ff       	call   c010138f <cons_intr>
    }
}
c010144d:	90                   	nop
c010144e:	c9                   	leave  
c010144f:	c3                   	ret    

c0101450 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101450:	55                   	push   %ebp
c0101451:	89 e5                	mov    %esp,%ebp
c0101453:	83 ec 38             	sub    $0x38,%esp
c0101456:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010145f:	89 c2                	mov    %eax,%edx
c0101461:	ec                   	in     (%dx),%al
c0101462:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101465:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101469:	0f b6 c0             	movzbl %al,%eax
c010146c:	83 e0 01             	and    $0x1,%eax
c010146f:	85 c0                	test   %eax,%eax
c0101471:	75 0a                	jne    c010147d <kbd_proc_data+0x2d>
        return -1;
c0101473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101478:	e9 55 01 00 00       	jmp    c01015d2 <kbd_proc_data+0x182>
c010147d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101486:	89 c2                	mov    %eax,%edx
c0101488:	ec                   	in     (%dx),%al
c0101489:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010148c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101490:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101493:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101497:	75 17                	jne    c01014b0 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101499:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010149e:	83 c8 40             	or     $0x40,%eax
c01014a1:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014a6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ab:	e9 22 01 00 00       	jmp    c01015d2 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c01014b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b4:	84 c0                	test   %al,%al
c01014b6:	79 45                	jns    c01014fd <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014b8:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014bd:	83 e0 40             	and    $0x40,%eax
c01014c0:	85 c0                	test   %eax,%eax
c01014c2:	75 08                	jne    c01014cc <kbd_proc_data+0x7c>
c01014c4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c8:	24 7f                	and    $0x7f,%al
c01014ca:	eb 04                	jmp    c01014d0 <kbd_proc_data+0x80>
c01014cc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014d3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d7:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014de:	0c 40                	or     $0x40,%al
c01014e0:	0f b6 c0             	movzbl %al,%eax
c01014e3:	f7 d0                	not    %eax
c01014e5:	89 c2                	mov    %eax,%edx
c01014e7:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014ec:	21 d0                	and    %edx,%eax
c01014ee:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014f3:	b8 00 00 00 00       	mov    $0x0,%eax
c01014f8:	e9 d5 00 00 00       	jmp    c01015d2 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c01014fd:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101502:	83 e0 40             	and    $0x40,%eax
c0101505:	85 c0                	test   %eax,%eax
c0101507:	74 11                	je     c010151a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101509:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010150d:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101512:	83 e0 bf             	and    $0xffffffbf,%eax
c0101515:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c010151a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151e:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c0101525:	0f b6 d0             	movzbl %al,%edx
c0101528:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010152d:	09 d0                	or     %edx,%eax
c010152f:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c0101534:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101538:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c010153f:	0f b6 d0             	movzbl %al,%edx
c0101542:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101547:	31 d0                	xor    %edx,%eax
c0101549:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c010154e:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101553:	83 e0 03             	and    $0x3,%eax
c0101556:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c010155d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101561:	01 d0                	add    %edx,%eax
c0101563:	0f b6 00             	movzbl (%eax),%eax
c0101566:	0f b6 c0             	movzbl %al,%eax
c0101569:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010156c:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101571:	83 e0 08             	and    $0x8,%eax
c0101574:	85 c0                	test   %eax,%eax
c0101576:	74 22                	je     c010159a <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101578:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010157c:	7e 0c                	jle    c010158a <kbd_proc_data+0x13a>
c010157e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101582:	7f 06                	jg     c010158a <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c0101584:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101588:	eb 10                	jmp    c010159a <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c010158a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010158e:	7e 0a                	jle    c010159a <kbd_proc_data+0x14a>
c0101590:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101594:	7f 04                	jg     c010159a <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101596:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010159a:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010159f:	f7 d0                	not    %eax
c01015a1:	83 e0 06             	and    $0x6,%eax
c01015a4:	85 c0                	test   %eax,%eax
c01015a6:	75 27                	jne    c01015cf <kbd_proc_data+0x17f>
c01015a8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015af:	75 1e                	jne    c01015cf <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c01015b1:	c7 04 24 75 5e 10 c0 	movl   $0xc0105e75,(%esp)
c01015b8:	e8 e5 ec ff ff       	call   c01002a2 <cprintf>
c01015bd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015c3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01015ce:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015d2:	c9                   	leave  
c01015d3:	c3                   	ret    

c01015d4 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015d4:	55                   	push   %ebp
c01015d5:	89 e5                	mov    %esp,%ebp
c01015d7:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015da:	c7 04 24 50 14 10 c0 	movl   $0xc0101450,(%esp)
c01015e1:	e8 a9 fd ff ff       	call   c010138f <cons_intr>
}
c01015e6:	90                   	nop
c01015e7:	c9                   	leave  
c01015e8:	c3                   	ret    

c01015e9 <kbd_init>:

static void
kbd_init(void) {
c01015e9:	55                   	push   %ebp
c01015ea:	89 e5                	mov    %esp,%ebp
c01015ec:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015ef:	e8 e0 ff ff ff       	call   c01015d4 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015fb:	e8 35 01 00 00       	call   c0101735 <pic_enable>
}
c0101600:	90                   	nop
c0101601:	c9                   	leave  
c0101602:	c3                   	ret    

c0101603 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101603:	55                   	push   %ebp
c0101604:	89 e5                	mov    %esp,%ebp
c0101606:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101609:	e8 83 f8 ff ff       	call   c0100e91 <cga_init>
    serial_init();
c010160e:	e8 62 f9 ff ff       	call   c0100f75 <serial_init>
    kbd_init();
c0101613:	e8 d1 ff ff ff       	call   c01015e9 <kbd_init>
    if (!serial_exists) {
c0101618:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010161d:	85 c0                	test   %eax,%eax
c010161f:	75 0c                	jne    c010162d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101621:	c7 04 24 81 5e 10 c0 	movl   $0xc0105e81,(%esp)
c0101628:	e8 75 ec ff ff       	call   c01002a2 <cprintf>
    }
}
c010162d:	90                   	nop
c010162e:	c9                   	leave  
c010162f:	c3                   	ret    

c0101630 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101630:	55                   	push   %ebp
c0101631:	89 e5                	mov    %esp,%ebp
c0101633:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101636:	e8 cf f7 ff ff       	call   c0100e0a <__intr_save>
c010163b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010163e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101641:	89 04 24             	mov    %eax,(%esp)
c0101644:	e8 89 fa ff ff       	call   c01010d2 <lpt_putc>
        cga_putc(c);
c0101649:	8b 45 08             	mov    0x8(%ebp),%eax
c010164c:	89 04 24             	mov    %eax,(%esp)
c010164f:	e8 be fa ff ff       	call   c0101112 <cga_putc>
        serial_putc(c);
c0101654:	8b 45 08             	mov    0x8(%ebp),%eax
c0101657:	89 04 24             	mov    %eax,(%esp)
c010165a:	e8 f0 fc ff ff       	call   c010134f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010165f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101662:	89 04 24             	mov    %eax,(%esp)
c0101665:	e8 ca f7 ff ff       	call   c0100e34 <__intr_restore>
}
c010166a:	90                   	nop
c010166b:	c9                   	leave  
c010166c:	c3                   	ret    

c010166d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010166d:	55                   	push   %ebp
c010166e:	89 e5                	mov    %esp,%ebp
c0101670:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101673:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010167a:	e8 8b f7 ff ff       	call   c0100e0a <__intr_save>
c010167f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101682:	e8 ab fd ff ff       	call   c0101432 <serial_intr>
        kbd_intr();
c0101687:	e8 48 ff ff ff       	call   c01015d4 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010168c:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101692:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101697:	39 c2                	cmp    %eax,%edx
c0101699:	74 31                	je     c01016cc <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010169b:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01016a0:	8d 50 01             	lea    0x1(%eax),%edx
c01016a3:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c01016a9:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c01016b0:	0f b6 c0             	movzbl %al,%eax
c01016b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016b6:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01016bb:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016c0:	75 0a                	jne    c01016cc <cons_getc+0x5f>
                cons.rpos = 0;
c01016c2:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016c9:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016cf:	89 04 24             	mov    %eax,(%esp)
c01016d2:	e8 5d f7 ff ff       	call   c0100e34 <__intr_restore>
    return c;
c01016d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016da:	c9                   	leave  
c01016db:	c3                   	ret    

c01016dc <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016dc:	55                   	push   %ebp
c01016dd:	89 e5                	mov    %esp,%ebp
c01016df:	83 ec 14             	sub    $0x14,%esp
c01016e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016e5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016ec:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016f2:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016f7:	85 c0                	test   %eax,%eax
c01016f9:	74 37                	je     c0101732 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016fe:	0f b6 c0             	movzbl %al,%eax
c0101701:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101707:	88 45 f9             	mov    %al,-0x7(%ebp)
c010170a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010170e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101712:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101713:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101717:	c1 e8 08             	shr    $0x8,%eax
c010171a:	0f b7 c0             	movzwl %ax,%eax
c010171d:	0f b6 c0             	movzbl %al,%eax
c0101720:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101726:	88 45 fd             	mov    %al,-0x3(%ebp)
c0101729:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010172d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101731:	ee                   	out    %al,(%dx)
    }
}
c0101732:	90                   	nop
c0101733:	c9                   	leave  
c0101734:	c3                   	ret    

c0101735 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101735:	55                   	push   %ebp
c0101736:	89 e5                	mov    %esp,%ebp
c0101738:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010173b:	8b 45 08             	mov    0x8(%ebp),%eax
c010173e:	ba 01 00 00 00       	mov    $0x1,%edx
c0101743:	88 c1                	mov    %al,%cl
c0101745:	d3 e2                	shl    %cl,%edx
c0101747:	89 d0                	mov    %edx,%eax
c0101749:	98                   	cwtl   
c010174a:	f7 d0                	not    %eax
c010174c:	0f bf d0             	movswl %ax,%edx
c010174f:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101756:	98                   	cwtl   
c0101757:	21 d0                	and    %edx,%eax
c0101759:	98                   	cwtl   
c010175a:	0f b7 c0             	movzwl %ax,%eax
c010175d:	89 04 24             	mov    %eax,(%esp)
c0101760:	e8 77 ff ff ff       	call   c01016dc <pic_setmask>
}
c0101765:	90                   	nop
c0101766:	c9                   	leave  
c0101767:	c3                   	ret    

c0101768 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101768:	55                   	push   %ebp
c0101769:	89 e5                	mov    %esp,%ebp
c010176b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010176e:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c0101775:	00 00 00 
c0101778:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010177e:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c0101782:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101786:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010178a:	ee                   	out    %al,(%dx)
c010178b:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101791:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101795:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101799:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010179d:	ee                   	out    %al,(%dx)
c010179e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01017a4:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c01017a8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01017ac:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01017b0:	ee                   	out    %al,(%dx)
c01017b1:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c01017b7:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c01017bb:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01017bf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01017c3:	ee                   	out    %al,(%dx)
c01017c4:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01017ca:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c01017ce:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017d2:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017d6:	ee                   	out    %al,(%dx)
c01017d7:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017dd:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c01017e1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017e5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017e9:	ee                   	out    %al,(%dx)
c01017ea:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017f0:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c01017f4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017f8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017fc:	ee                   	out    %al,(%dx)
c01017fd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101803:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c0101807:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010180b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010180f:	ee                   	out    %al,(%dx)
c0101810:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101816:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c010181a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010181e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101822:	ee                   	out    %al,(%dx)
c0101823:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101829:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c010182d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101831:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101835:	ee                   	out    %al,(%dx)
c0101836:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c010183c:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c0101840:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101844:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101848:	ee                   	out    %al,(%dx)
c0101849:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010184f:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c0101853:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101857:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010185b:	ee                   	out    %al,(%dx)
c010185c:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101862:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101866:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010186a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010186e:	ee                   	out    %al,(%dx)
c010186f:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101875:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0101879:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010187d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101881:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101882:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101889:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010188e:	74 0f                	je     c010189f <pic_init+0x137>
        pic_setmask(irq_mask);
c0101890:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101897:	89 04 24             	mov    %eax,(%esp)
c010189a:	e8 3d fe ff ff       	call   c01016dc <pic_setmask>
    }
}
c010189f:	90                   	nop
c01018a0:	c9                   	leave  
c01018a1:	c3                   	ret    

c01018a2 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01018a2:	55                   	push   %ebp
c01018a3:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c01018a5:	fb                   	sti    
    sti();
}
c01018a6:	90                   	nop
c01018a7:	5d                   	pop    %ebp
c01018a8:	c3                   	ret    

c01018a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01018a9:	55                   	push   %ebp
c01018aa:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c01018ac:	fa                   	cli    
    cli();
}
c01018ad:	90                   	nop
c01018ae:	5d                   	pop    %ebp
c01018af:	c3                   	ret    

c01018b0 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01018b0:	55                   	push   %ebp
c01018b1:	89 e5                	mov    %esp,%ebp
c01018b3:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01018b6:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01018bd:	00 
c01018be:	c7 04 24 a0 5e 10 c0 	movl   $0xc0105ea0,(%esp)
c01018c5:	e8 d8 e9 ff ff       	call   c01002a2 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01018ca:	90                   	nop
c01018cb:	c9                   	leave  
c01018cc:	c3                   	ret    

c01018cd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018cd:	55                   	push   %ebp
c01018ce:	89 e5                	mov    %esp,%ebp
c01018d0:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
          extern uintptr_t __vectors[];
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018da:	e9 c4 00 00 00       	jmp    c01019a3 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e2:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018e9:	0f b7 d0             	movzwl %ax,%edx
c01018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ef:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c01018f6:	c0 
c01018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fa:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c0101901:	c0 08 00 
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c010190e:	c0 
c010190f:	80 e2 e0             	and    $0xe0,%dl
c0101912:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191c:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101923:	c0 
c0101924:	80 e2 1f             	and    $0x1f,%dl
c0101927:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101931:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101938:	c0 
c0101939:	80 e2 f0             	and    $0xf0,%dl
c010193c:	80 ca 0e             	or     $0xe,%dl
c010193f:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101949:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101950:	c0 
c0101951:	80 e2 ef             	and    $0xef,%dl
c0101954:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195e:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101965:	c0 
c0101966:	80 e2 9f             	and    $0x9f,%dl
c0101969:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101973:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010197a:	c0 
c010197b:	80 ca 80             	or     $0x80,%dl
c010197e:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101985:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101988:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c010198f:	c1 e8 10             	shr    $0x10,%eax
c0101992:	0f b7 d0             	movzwl %ax,%edx
c0101995:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101998:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c010199f:	c0 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019a0:	ff 45 fc             	incl   -0x4(%ebp)
c01019a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a6:	3d ff 00 00 00       	cmp    $0xff,%eax
c01019ab:	0f 86 2e ff ff ff    	jbe    c01018df <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
c01019b1:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c01019b6:	0f b7 c0             	movzwl %ax,%eax
c01019b9:	66 a3 48 aa 11 c0    	mov    %ax,0xc011aa48
c01019bf:	66 c7 05 4a aa 11 c0 	movw   $0x8,0xc011aa4a
c01019c6:	08 00 
c01019c8:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019cf:	24 e0                	and    $0xe0,%al
c01019d1:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019d6:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019dd:	24 1f                	and    $0x1f,%al
c01019df:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019e4:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019eb:	0c 0f                	or     $0xf,%al
c01019ed:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c01019f2:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019f9:	24 ef                	and    $0xef,%al
c01019fb:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a00:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a07:	0c 60                	or     $0x60,%al
c0101a09:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a0e:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a15:	0c 80                	or     $0x80,%al
c0101a17:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a1c:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c0101a21:	c1 e8 10             	shr    $0x10,%eax
c0101a24:	0f b7 c0             	movzwl %ax,%eax
c0101a27:	66 a3 4e aa 11 c0    	mov    %ax,0xc011aa4e
c0101a2d:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a34:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a37:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
c0101a3a:	90                   	nop
c0101a3b:	c9                   	leave  
c0101a3c:	c3                   	ret    

c0101a3d <trapname>:

static const char *
trapname(int trapno) {
c0101a3d:	55                   	push   %ebp
c0101a3e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a43:	83 f8 13             	cmp    $0x13,%eax
c0101a46:	77 0c                	ja     c0101a54 <trapname+0x17>
        return excnames[trapno];
c0101a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4b:	8b 04 85 00 62 10 c0 	mov    -0x3fef9e00(,%eax,4),%eax
c0101a52:	eb 18                	jmp    c0101a6c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a54:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a58:	7e 0d                	jle    c0101a67 <trapname+0x2a>
c0101a5a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a5e:	7f 07                	jg     c0101a67 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a60:	b8 aa 5e 10 c0       	mov    $0xc0105eaa,%eax
c0101a65:	eb 05                	jmp    c0101a6c <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a67:	b8 bd 5e 10 c0       	mov    $0xc0105ebd,%eax
}
c0101a6c:	5d                   	pop    %ebp
c0101a6d:	c3                   	ret    

c0101a6e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a6e:	55                   	push   %ebp
c0101a6f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a74:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a78:	83 f8 08             	cmp    $0x8,%eax
c0101a7b:	0f 94 c0             	sete   %al
c0101a7e:	0f b6 c0             	movzbl %al,%eax
}
c0101a81:	5d                   	pop    %ebp
c0101a82:	c3                   	ret    

c0101a83 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a83:	55                   	push   %ebp
c0101a84:	89 e5                	mov    %esp,%ebp
c0101a86:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a89:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a90:	c7 04 24 fe 5e 10 c0 	movl   $0xc0105efe,(%esp)
c0101a97:	e8 06 e8 ff ff       	call   c01002a2 <cprintf>
    print_regs(&tf->tf_regs);
c0101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9f:	89 04 24             	mov    %eax,(%esp)
c0101aa2:	e8 8f 01 00 00       	call   c0101c36 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aaa:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101aae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab2:	c7 04 24 0f 5f 10 c0 	movl   $0xc0105f0f,(%esp)
c0101ab9:	e8 e4 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101abe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac1:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac9:	c7 04 24 22 5f 10 c0 	movl   $0xc0105f22,(%esp)
c0101ad0:	e8 cd e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ad5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad8:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae0:	c7 04 24 35 5f 10 c0 	movl   $0xc0105f35,(%esp)
c0101ae7:	e8 b6 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101aec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aef:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101af3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af7:	c7 04 24 48 5f 10 c0 	movl   $0xc0105f48,(%esp)
c0101afe:	e8 9f e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b06:	8b 40 30             	mov    0x30(%eax),%eax
c0101b09:	89 04 24             	mov    %eax,(%esp)
c0101b0c:	e8 2c ff ff ff       	call   c0101a3d <trapname>
c0101b11:	89 c2                	mov    %eax,%edx
c0101b13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b16:	8b 40 30             	mov    0x30(%eax),%eax
c0101b19:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b21:	c7 04 24 5b 5f 10 c0 	movl   $0xc0105f5b,(%esp)
c0101b28:	e8 75 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b30:	8b 40 34             	mov    0x34(%eax),%eax
c0101b33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b37:	c7 04 24 6d 5f 10 c0 	movl   $0xc0105f6d,(%esp)
c0101b3e:	e8 5f e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b46:	8b 40 38             	mov    0x38(%eax),%eax
c0101b49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b4d:	c7 04 24 7c 5f 10 c0 	movl   $0xc0105f7c,(%esp)
c0101b54:	e8 49 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b64:	c7 04 24 8b 5f 10 c0 	movl   $0xc0105f8b,(%esp)
c0101b6b:	e8 32 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b70:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b73:	8b 40 40             	mov    0x40(%eax),%eax
c0101b76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b7a:	c7 04 24 9e 5f 10 c0 	movl   $0xc0105f9e,(%esp)
c0101b81:	e8 1c e7 ff ff       	call   c01002a2 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b8d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b94:	eb 3d                	jmp    c0101bd3 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b99:	8b 50 40             	mov    0x40(%eax),%edx
c0101b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b9f:	21 d0                	and    %edx,%eax
c0101ba1:	85 c0                	test   %eax,%eax
c0101ba3:	74 28                	je     c0101bcd <print_trapframe+0x14a>
c0101ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba8:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101baf:	85 c0                	test   %eax,%eax
c0101bb1:	74 1a                	je     c0101bcd <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0101bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb6:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc1:	c7 04 24 ad 5f 10 c0 	movl   $0xc0105fad,(%esp)
c0101bc8:	e8 d5 e6 ff ff       	call   c01002a2 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bcd:	ff 45 f4             	incl   -0xc(%ebp)
c0101bd0:	d1 65 f0             	shll   -0x10(%ebp)
c0101bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bd6:	83 f8 17             	cmp    $0x17,%eax
c0101bd9:	76 bb                	jbe    c0101b96 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bde:	8b 40 40             	mov    0x40(%eax),%eax
c0101be1:	c1 e8 0c             	shr    $0xc,%eax
c0101be4:	83 e0 03             	and    $0x3,%eax
c0101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101beb:	c7 04 24 b1 5f 10 c0 	movl   $0xc0105fb1,(%esp)
c0101bf2:	e8 ab e6 ff ff       	call   c01002a2 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfa:	89 04 24             	mov    %eax,(%esp)
c0101bfd:	e8 6c fe ff ff       	call   c0101a6e <trap_in_kernel>
c0101c02:	85 c0                	test   %eax,%eax
c0101c04:	75 2d                	jne    c0101c33 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c09:	8b 40 44             	mov    0x44(%eax),%eax
c0101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c10:	c7 04 24 ba 5f 10 c0 	movl   $0xc0105fba,(%esp)
c0101c17:	e8 86 e6 ff ff       	call   c01002a2 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1f:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c27:	c7 04 24 c9 5f 10 c0 	movl   $0xc0105fc9,(%esp)
c0101c2e:	e8 6f e6 ff ff       	call   c01002a2 <cprintf>
    }
}
c0101c33:	90                   	nop
c0101c34:	c9                   	leave  
c0101c35:	c3                   	ret    

c0101c36 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c36:	55                   	push   %ebp
c0101c37:	89 e5                	mov    %esp,%ebp
c0101c39:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3f:	8b 00                	mov    (%eax),%eax
c0101c41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c45:	c7 04 24 dc 5f 10 c0 	movl   $0xc0105fdc,(%esp)
c0101c4c:	e8 51 e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c54:	8b 40 04             	mov    0x4(%eax),%eax
c0101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5b:	c7 04 24 eb 5f 10 c0 	movl   $0xc0105feb,(%esp)
c0101c62:	e8 3b e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6a:	8b 40 08             	mov    0x8(%eax),%eax
c0101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c71:	c7 04 24 fa 5f 10 c0 	movl   $0xc0105ffa,(%esp)
c0101c78:	e8 25 e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c80:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c87:	c7 04 24 09 60 10 c0 	movl   $0xc0106009,(%esp)
c0101c8e:	e8 0f e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c96:	8b 40 10             	mov    0x10(%eax),%eax
c0101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9d:	c7 04 24 18 60 10 c0 	movl   $0xc0106018,(%esp)
c0101ca4:	e8 f9 e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cac:	8b 40 14             	mov    0x14(%eax),%eax
c0101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb3:	c7 04 24 27 60 10 c0 	movl   $0xc0106027,(%esp)
c0101cba:	e8 e3 e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc2:	8b 40 18             	mov    0x18(%eax),%eax
c0101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc9:	c7 04 24 36 60 10 c0 	movl   $0xc0106036,(%esp)
c0101cd0:	e8 cd e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd8:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cdf:	c7 04 24 45 60 10 c0 	movl   $0xc0106045,(%esp)
c0101ce6:	e8 b7 e5 ff ff       	call   c01002a2 <cprintf>
}
c0101ceb:	90                   	nop
c0101cec:	c9                   	leave  
c0101ced:	c3                   	ret    

c0101cee <trap_dispatch>:
struct trapframe switchk2u, *switchu2k;
/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cee:	55                   	push   %ebp
c0101cef:	89 e5                	mov    %esp,%ebp
c0101cf1:	57                   	push   %edi
c0101cf2:	56                   	push   %esi
c0101cf3:	53                   	push   %ebx
c0101cf4:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfa:	8b 40 30             	mov    0x30(%eax),%eax
c0101cfd:	83 f8 2f             	cmp    $0x2f,%eax
c0101d00:	77 21                	ja     c0101d23 <trap_dispatch+0x35>
c0101d02:	83 f8 2e             	cmp    $0x2e,%eax
c0101d05:	0f 83 f9 03 00 00    	jae    c0102104 <trap_dispatch+0x416>
c0101d0b:	83 f8 21             	cmp    $0x21,%eax
c0101d0e:	0f 84 9c 00 00 00    	je     c0101db0 <trap_dispatch+0xc2>
c0101d14:	83 f8 24             	cmp    $0x24,%eax
c0101d17:	74 6e                	je     c0101d87 <trap_dispatch+0x99>
c0101d19:	83 f8 20             	cmp    $0x20,%eax
c0101d1c:	74 1c                	je     c0101d3a <trap_dispatch+0x4c>
c0101d1e:	e9 ac 03 00 00       	jmp    c01020cf <trap_dispatch+0x3e1>
c0101d23:	83 f8 78             	cmp    $0x78,%eax
c0101d26:	0f 84 42 02 00 00    	je     c0101f6e <trap_dispatch+0x280>
c0101d2c:	83 f8 79             	cmp    $0x79,%eax
c0101d2f:	0f 84 1d 03 00 00    	je     c0102052 <trap_dispatch+0x364>
c0101d35:	e9 95 03 00 00       	jmp    c01020cf <trap_dispatch+0x3e1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101d3a:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101d3f:	40                   	inc    %eax
c0101d40:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
        if(ticks % 100 == 0)
c0101d45:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101d4b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d50:	89 c8                	mov    %ecx,%eax
c0101d52:	f7 e2                	mul    %edx
c0101d54:	c1 ea 05             	shr    $0x5,%edx
c0101d57:	89 d0                	mov    %edx,%eax
c0101d59:	c1 e0 02             	shl    $0x2,%eax
c0101d5c:	01 d0                	add    %edx,%eax
c0101d5e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101d65:	01 d0                	add    %edx,%eax
c0101d67:	c1 e0 02             	shl    $0x2,%eax
c0101d6a:	29 c1                	sub    %eax,%ecx
c0101d6c:	89 ca                	mov    %ecx,%edx
c0101d6e:	85 d2                	test   %edx,%edx
c0101d70:	0f 85 91 03 00 00    	jne    c0102107 <trap_dispatch+0x419>
            print_ticks("100 ticks");
c0101d76:	c7 04 24 54 60 10 c0 	movl   $0xc0106054,(%esp)
c0101d7d:	e8 2e fb ff ff       	call   c01018b0 <print_ticks>
        break;
c0101d82:	e9 80 03 00 00       	jmp    c0102107 <trap_dispatch+0x419>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d87:	e8 e1 f8 ff ff       	call   c010166d <cons_getc>
c0101d8c:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d8f:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101d93:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101d97:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d9f:	c7 04 24 5e 60 10 c0 	movl   $0xc010605e,(%esp)
c0101da6:	e8 f7 e4 ff ff       	call   c01002a2 <cprintf>
        break;
c0101dab:	e9 5e 03 00 00       	jmp    c010210e <trap_dispatch+0x420>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101db0:	e8 b8 f8 ff ff       	call   c010166d <cons_getc>
c0101db5:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101db8:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101dbc:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101dc0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dc8:	c7 04 24 70 60 10 c0 	movl   $0xc0106070,(%esp)
c0101dcf:	e8 ce e4 ff ff       	call   c01002a2 <cprintf>
        switch (c)
c0101dd4:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101dd8:	83 f8 30             	cmp    $0x30,%eax
c0101ddb:	74 0e                	je     c0101deb <trap_dispatch+0xfd>
c0101ddd:	83 f8 33             	cmp    $0x33,%eax
c0101de0:	0f 84 90 00 00 00    	je     c0101e76 <trap_dispatch+0x188>
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
            print_trapframe(tf);
        }
        break;
        default:
            break;
c0101de6:	e9 7e 01 00 00       	jmp    c0101f69 <trap_dispatch+0x27b>
            if (tf->tf_cs != KERNEL_CS) {
c0101deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dee:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101df2:	83 f8 08             	cmp    $0x8,%eax
c0101df5:	0f 84 67 01 00 00    	je     c0101f62 <trap_dispatch+0x274>
            tf->tf_cs = KERNEL_CS;
c0101dfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dfe:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101e04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e07:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e10:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e17:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1e:	8b 40 40             	mov    0x40(%eax),%eax
c0101e21:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101e26:	89 c2                	mov    %eax,%edx
c0101e28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e2b:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e31:	8b 40 44             	mov    0x44(%eax),%eax
c0101e34:	83 e8 44             	sub    $0x44,%eax
c0101e37:	a3 6c af 11 c0       	mov    %eax,0xc011af6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101e3c:	a1 6c af 11 c0       	mov    0xc011af6c,%eax
c0101e41:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101e48:	00 
c0101e49:	8b 55 08             	mov    0x8(%ebp),%edx
c0101e4c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101e50:	89 04 24             	mov    %eax,(%esp)
c0101e53:	e8 26 35 00 00       	call   c010537e <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0101e58:	8b 15 6c af 11 c0    	mov    0xc011af6c,%edx
c0101e5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e61:	83 e8 04             	sub    $0x4,%eax
c0101e64:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
c0101e66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e69:	89 04 24             	mov    %eax,(%esp)
c0101e6c:	e8 12 fc ff ff       	call   c0101a83 <print_trapframe>
            break;
c0101e71:	e9 ec 00 00 00       	jmp    c0101f62 <trap_dispatch+0x274>
            if (tf->tf_cs != USER_CS) {
c0101e76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e79:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e7d:	83 f8 1b             	cmp    $0x1b,%eax
c0101e80:	0f 84 e2 00 00 00    	je     c0101f68 <trap_dispatch+0x27a>
            switchk2u = *tf;
c0101e86:	8b 55 08             	mov    0x8(%ebp),%edx
c0101e89:	b8 20 af 11 c0       	mov    $0xc011af20,%eax
c0101e8e:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101e93:	89 c1                	mov    %eax,%ecx
c0101e95:	83 e1 01             	and    $0x1,%ecx
c0101e98:	85 c9                	test   %ecx,%ecx
c0101e9a:	74 0c                	je     c0101ea8 <trap_dispatch+0x1ba>
c0101e9c:	0f b6 0a             	movzbl (%edx),%ecx
c0101e9f:	88 08                	mov    %cl,(%eax)
c0101ea1:	8d 40 01             	lea    0x1(%eax),%eax
c0101ea4:	8d 52 01             	lea    0x1(%edx),%edx
c0101ea7:	4b                   	dec    %ebx
c0101ea8:	89 c1                	mov    %eax,%ecx
c0101eaa:	83 e1 02             	and    $0x2,%ecx
c0101ead:	85 c9                	test   %ecx,%ecx
c0101eaf:	74 0f                	je     c0101ec0 <trap_dispatch+0x1d2>
c0101eb1:	0f b7 0a             	movzwl (%edx),%ecx
c0101eb4:	66 89 08             	mov    %cx,(%eax)
c0101eb7:	8d 40 02             	lea    0x2(%eax),%eax
c0101eba:	8d 52 02             	lea    0x2(%edx),%edx
c0101ebd:	83 eb 02             	sub    $0x2,%ebx
c0101ec0:	89 df                	mov    %ebx,%edi
c0101ec2:	83 e7 fc             	and    $0xfffffffc,%edi
c0101ec5:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101eca:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0101ecd:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0101ed0:	83 c1 04             	add    $0x4,%ecx
c0101ed3:	39 f9                	cmp    %edi,%ecx
c0101ed5:	72 f3                	jb     c0101eca <trap_dispatch+0x1dc>
c0101ed7:	01 c8                	add    %ecx,%eax
c0101ed9:	01 ca                	add    %ecx,%edx
c0101edb:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101ee0:	89 de                	mov    %ebx,%esi
c0101ee2:	83 e6 02             	and    $0x2,%esi
c0101ee5:	85 f6                	test   %esi,%esi
c0101ee7:	74 0b                	je     c0101ef4 <trap_dispatch+0x206>
c0101ee9:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0101eed:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0101ef1:	83 c1 02             	add    $0x2,%ecx
c0101ef4:	83 e3 01             	and    $0x1,%ebx
c0101ef7:	85 db                	test   %ebx,%ebx
c0101ef9:	74 07                	je     c0101f02 <trap_dispatch+0x214>
c0101efb:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0101eff:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
c0101f02:	66 c7 05 5c af 11 c0 	movw   $0x1b,0xc011af5c
c0101f09:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0101f0b:	66 c7 05 68 af 11 c0 	movw   $0x23,0xc011af68
c0101f12:	23 00 
c0101f14:	0f b7 05 68 af 11 c0 	movzwl 0xc011af68,%eax
c0101f1b:	66 a3 48 af 11 c0    	mov    %ax,0xc011af48
c0101f21:	0f b7 05 48 af 11 c0 	movzwl 0xc011af48,%eax
c0101f28:	66 a3 4c af 11 c0    	mov    %ax,0xc011af4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0101f2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f31:	83 c0 44             	add    $0x44,%eax
c0101f34:	a3 64 af 11 c0       	mov    %eax,0xc011af64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101f39:	a1 60 af 11 c0       	mov    0xc011af60,%eax
c0101f3e:	0d 00 30 00 00       	or     $0x3000,%eax
c0101f43:	a3 60 af 11 c0       	mov    %eax,0xc011af60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101f48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f4b:	83 e8 04             	sub    $0x4,%eax
c0101f4e:	ba 20 af 11 c0       	mov    $0xc011af20,%edx
c0101f53:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
c0101f55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f58:	89 04 24             	mov    %eax,(%esp)
c0101f5b:	e8 23 fb ff ff       	call   c0101a83 <print_trapframe>
        break;
c0101f60:	eb 06                	jmp    c0101f68 <trap_dispatch+0x27a>
            break;
c0101f62:	90                   	nop
c0101f63:	e9 a6 01 00 00       	jmp    c010210e <trap_dispatch+0x420>
        break;
c0101f68:	90                   	nop
        }
        break;  
c0101f69:	e9 a0 01 00 00       	jmp    c010210e <trap_dispatch+0x420>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
            if (tf->tf_cs != USER_CS) {
c0101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f75:	83 f8 1b             	cmp    $0x1b,%eax
c0101f78:	0f 84 8c 01 00 00    	je     c010210a <trap_dispatch+0x41c>
            switchk2u = *tf;
c0101f7e:	8b 55 08             	mov    0x8(%ebp),%edx
c0101f81:	b8 20 af 11 c0       	mov    $0xc011af20,%eax
c0101f86:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101f8b:	89 c1                	mov    %eax,%ecx
c0101f8d:	83 e1 01             	and    $0x1,%ecx
c0101f90:	85 c9                	test   %ecx,%ecx
c0101f92:	74 0c                	je     c0101fa0 <trap_dispatch+0x2b2>
c0101f94:	0f b6 0a             	movzbl (%edx),%ecx
c0101f97:	88 08                	mov    %cl,(%eax)
c0101f99:	8d 40 01             	lea    0x1(%eax),%eax
c0101f9c:	8d 52 01             	lea    0x1(%edx),%edx
c0101f9f:	4b                   	dec    %ebx
c0101fa0:	89 c1                	mov    %eax,%ecx
c0101fa2:	83 e1 02             	and    $0x2,%ecx
c0101fa5:	85 c9                	test   %ecx,%ecx
c0101fa7:	74 0f                	je     c0101fb8 <trap_dispatch+0x2ca>
c0101fa9:	0f b7 0a             	movzwl (%edx),%ecx
c0101fac:	66 89 08             	mov    %cx,(%eax)
c0101faf:	8d 40 02             	lea    0x2(%eax),%eax
c0101fb2:	8d 52 02             	lea    0x2(%edx),%edx
c0101fb5:	83 eb 02             	sub    $0x2,%ebx
c0101fb8:	89 df                	mov    %ebx,%edi
c0101fba:	83 e7 fc             	and    $0xfffffffc,%edi
c0101fbd:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101fc2:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0101fc5:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0101fc8:	83 c1 04             	add    $0x4,%ecx
c0101fcb:	39 f9                	cmp    %edi,%ecx
c0101fcd:	72 f3                	jb     c0101fc2 <trap_dispatch+0x2d4>
c0101fcf:	01 c8                	add    %ecx,%eax
c0101fd1:	01 ca                	add    %ecx,%edx
c0101fd3:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101fd8:	89 de                	mov    %ebx,%esi
c0101fda:	83 e6 02             	and    $0x2,%esi
c0101fdd:	85 f6                	test   %esi,%esi
c0101fdf:	74 0b                	je     c0101fec <trap_dispatch+0x2fe>
c0101fe1:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0101fe5:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0101fe9:	83 c1 02             	add    $0x2,%ecx
c0101fec:	83 e3 01             	and    $0x1,%ebx
c0101fef:	85 db                	test   %ebx,%ebx
c0101ff1:	74 07                	je     c0101ffa <trap_dispatch+0x30c>
c0101ff3:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0101ff7:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
c0101ffa:	66 c7 05 5c af 11 c0 	movw   $0x1b,0xc011af5c
c0102001:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0102003:	66 c7 05 68 af 11 c0 	movw   $0x23,0xc011af68
c010200a:	23 00 
c010200c:	0f b7 05 68 af 11 c0 	movzwl 0xc011af68,%eax
c0102013:	66 a3 48 af 11 c0    	mov    %ax,0xc011af48
c0102019:	0f b7 05 48 af 11 c0 	movzwl 0xc011af48,%eax
c0102020:	66 a3 4c af 11 c0    	mov    %ax,0xc011af4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0102026:	8b 45 08             	mov    0x8(%ebp),%eax
c0102029:	83 c0 44             	add    $0x44,%eax
c010202c:	a3 64 af 11 c0       	mov    %eax,0xc011af64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0102031:	a1 60 af 11 c0       	mov    0xc011af60,%eax
c0102036:	0d 00 30 00 00       	or     $0x3000,%eax
c010203b:	a3 60 af 11 c0       	mov    %eax,0xc011af60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0102040:	8b 45 08             	mov    0x8(%ebp),%eax
c0102043:	83 e8 04             	sub    $0x4,%eax
c0102046:	ba 20 af 11 c0       	mov    $0xc011af20,%edx
c010204b:	89 10                	mov    %edx,(%eax)
        }
        break;
c010204d:	e9 b8 00 00 00       	jmp    c010210a <trap_dispatch+0x41c>
    case T_SWITCH_TOK:
         if (tf->tf_cs != KERNEL_CS) {
c0102052:	8b 45 08             	mov    0x8(%ebp),%eax
c0102055:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102059:	83 f8 08             	cmp    $0x8,%eax
c010205c:	0f 84 ab 00 00 00    	je     c010210d <trap_dispatch+0x41f>
            tf->tf_cs = KERNEL_CS;
c0102062:	8b 45 08             	mov    0x8(%ebp),%eax
c0102065:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c010206b:	8b 45 08             	mov    0x8(%ebp),%eax
c010206e:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0102074:	8b 45 08             	mov    0x8(%ebp),%eax
c0102077:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010207b:	8b 45 08             	mov    0x8(%ebp),%eax
c010207e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0102082:	8b 45 08             	mov    0x8(%ebp),%eax
c0102085:	8b 40 40             	mov    0x40(%eax),%eax
c0102088:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c010208d:	89 c2                	mov    %eax,%edx
c010208f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102092:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0102095:	8b 45 08             	mov    0x8(%ebp),%eax
c0102098:	8b 40 44             	mov    0x44(%eax),%eax
c010209b:	83 e8 44             	sub    $0x44,%eax
c010209e:	a3 6c af 11 c0       	mov    %eax,0xc011af6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c01020a3:	a1 6c af 11 c0       	mov    0xc011af6c,%eax
c01020a8:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c01020af:	00 
c01020b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01020b3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01020b7:	89 04 24             	mov    %eax,(%esp)
c01020ba:	e8 bf 32 00 00       	call   c010537e <memmove>
            //*((uint32_t *)tf - 1) = (uint32_t)tf;
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c01020bf:	8b 15 6c af 11 c0    	mov    0xc011af6c,%edx
c01020c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01020c8:	83 e8 04             	sub    $0x4,%eax
c01020cb:	89 10                	mov    %edx,(%eax)
        }
        break;
c01020cd:	eb 3e                	jmp    c010210d <trap_dispatch+0x41f>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01020cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01020d2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01020d6:	83 e0 03             	and    $0x3,%eax
c01020d9:	85 c0                	test   %eax,%eax
c01020db:	75 31                	jne    c010210e <trap_dispatch+0x420>
            print_trapframe(tf);
c01020dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01020e0:	89 04 24             	mov    %eax,(%esp)
c01020e3:	e8 9b f9 ff ff       	call   c0101a83 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01020e8:	c7 44 24 08 7f 60 10 	movl   $0xc010607f,0x8(%esp)
c01020ef:	c0 
c01020f0:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01020f7:	00 
c01020f8:	c7 04 24 9b 60 10 c0 	movl   $0xc010609b,(%esp)
c01020ff:	e8 f5 e2 ff ff       	call   c01003f9 <__panic>
        break;
c0102104:	90                   	nop
c0102105:	eb 07                	jmp    c010210e <trap_dispatch+0x420>
        break;
c0102107:	90                   	nop
c0102108:	eb 04                	jmp    c010210e <trap_dispatch+0x420>
        break;
c010210a:	90                   	nop
c010210b:	eb 01                	jmp    c010210e <trap_dispatch+0x420>
        break;
c010210d:	90                   	nop
        }
    }
}
c010210e:	90                   	nop
c010210f:	83 c4 2c             	add    $0x2c,%esp
c0102112:	5b                   	pop    %ebx
c0102113:	5e                   	pop    %esi
c0102114:	5f                   	pop    %edi
c0102115:	5d                   	pop    %ebp
c0102116:	c3                   	ret    

c0102117 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102117:	55                   	push   %ebp
c0102118:	89 e5                	mov    %esp,%ebp
c010211a:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010211d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102120:	89 04 24             	mov    %eax,(%esp)
c0102123:	e8 c6 fb ff ff       	call   c0101cee <trap_dispatch>
}
c0102128:	90                   	nop
c0102129:	c9                   	leave  
c010212a:	c3                   	ret    

c010212b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010212b:	6a 00                	push   $0x0
  pushl $0
c010212d:	6a 00                	push   $0x0
  jmp __alltraps
c010212f:	e9 69 0a 00 00       	jmp    c0102b9d <__alltraps>

c0102134 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102134:	6a 00                	push   $0x0
  pushl $1
c0102136:	6a 01                	push   $0x1
  jmp __alltraps
c0102138:	e9 60 0a 00 00       	jmp    c0102b9d <__alltraps>

c010213d <vector2>:
.globl vector2
vector2:
  pushl $0
c010213d:	6a 00                	push   $0x0
  pushl $2
c010213f:	6a 02                	push   $0x2
  jmp __alltraps
c0102141:	e9 57 0a 00 00       	jmp    c0102b9d <__alltraps>

c0102146 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102146:	6a 00                	push   $0x0
  pushl $3
c0102148:	6a 03                	push   $0x3
  jmp __alltraps
c010214a:	e9 4e 0a 00 00       	jmp    c0102b9d <__alltraps>

c010214f <vector4>:
.globl vector4
vector4:
  pushl $0
c010214f:	6a 00                	push   $0x0
  pushl $4
c0102151:	6a 04                	push   $0x4
  jmp __alltraps
c0102153:	e9 45 0a 00 00       	jmp    c0102b9d <__alltraps>

c0102158 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102158:	6a 00                	push   $0x0
  pushl $5
c010215a:	6a 05                	push   $0x5
  jmp __alltraps
c010215c:	e9 3c 0a 00 00       	jmp    c0102b9d <__alltraps>

c0102161 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102161:	6a 00                	push   $0x0
  pushl $6
c0102163:	6a 06                	push   $0x6
  jmp __alltraps
c0102165:	e9 33 0a 00 00       	jmp    c0102b9d <__alltraps>

c010216a <vector7>:
.globl vector7
vector7:
  pushl $0
c010216a:	6a 00                	push   $0x0
  pushl $7
c010216c:	6a 07                	push   $0x7
  jmp __alltraps
c010216e:	e9 2a 0a 00 00       	jmp    c0102b9d <__alltraps>

c0102173 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102173:	6a 08                	push   $0x8
  jmp __alltraps
c0102175:	e9 23 0a 00 00       	jmp    c0102b9d <__alltraps>

c010217a <vector9>:
.globl vector9
vector9:
  pushl $0
c010217a:	6a 00                	push   $0x0
  pushl $9
c010217c:	6a 09                	push   $0x9
  jmp __alltraps
c010217e:	e9 1a 0a 00 00       	jmp    c0102b9d <__alltraps>

c0102183 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102183:	6a 0a                	push   $0xa
  jmp __alltraps
c0102185:	e9 13 0a 00 00       	jmp    c0102b9d <__alltraps>

c010218a <vector11>:
.globl vector11
vector11:
  pushl $11
c010218a:	6a 0b                	push   $0xb
  jmp __alltraps
c010218c:	e9 0c 0a 00 00       	jmp    c0102b9d <__alltraps>

c0102191 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102191:	6a 0c                	push   $0xc
  jmp __alltraps
c0102193:	e9 05 0a 00 00       	jmp    c0102b9d <__alltraps>

c0102198 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102198:	6a 0d                	push   $0xd
  jmp __alltraps
c010219a:	e9 fe 09 00 00       	jmp    c0102b9d <__alltraps>

c010219f <vector14>:
.globl vector14
vector14:
  pushl $14
c010219f:	6a 0e                	push   $0xe
  jmp __alltraps
c01021a1:	e9 f7 09 00 00       	jmp    c0102b9d <__alltraps>

c01021a6 <vector15>:
.globl vector15
vector15:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $15
c01021a8:	6a 0f                	push   $0xf
  jmp __alltraps
c01021aa:	e9 ee 09 00 00       	jmp    c0102b9d <__alltraps>

c01021af <vector16>:
.globl vector16
vector16:
  pushl $0
c01021af:	6a 00                	push   $0x0
  pushl $16
c01021b1:	6a 10                	push   $0x10
  jmp __alltraps
c01021b3:	e9 e5 09 00 00       	jmp    c0102b9d <__alltraps>

c01021b8 <vector17>:
.globl vector17
vector17:
  pushl $17
c01021b8:	6a 11                	push   $0x11
  jmp __alltraps
c01021ba:	e9 de 09 00 00       	jmp    c0102b9d <__alltraps>

c01021bf <vector18>:
.globl vector18
vector18:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $18
c01021c1:	6a 12                	push   $0x12
  jmp __alltraps
c01021c3:	e9 d5 09 00 00       	jmp    c0102b9d <__alltraps>

c01021c8 <vector19>:
.globl vector19
vector19:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $19
c01021ca:	6a 13                	push   $0x13
  jmp __alltraps
c01021cc:	e9 cc 09 00 00       	jmp    c0102b9d <__alltraps>

c01021d1 <vector20>:
.globl vector20
vector20:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $20
c01021d3:	6a 14                	push   $0x14
  jmp __alltraps
c01021d5:	e9 c3 09 00 00       	jmp    c0102b9d <__alltraps>

c01021da <vector21>:
.globl vector21
vector21:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $21
c01021dc:	6a 15                	push   $0x15
  jmp __alltraps
c01021de:	e9 ba 09 00 00       	jmp    c0102b9d <__alltraps>

c01021e3 <vector22>:
.globl vector22
vector22:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $22
c01021e5:	6a 16                	push   $0x16
  jmp __alltraps
c01021e7:	e9 b1 09 00 00       	jmp    c0102b9d <__alltraps>

c01021ec <vector23>:
.globl vector23
vector23:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $23
c01021ee:	6a 17                	push   $0x17
  jmp __alltraps
c01021f0:	e9 a8 09 00 00       	jmp    c0102b9d <__alltraps>

c01021f5 <vector24>:
.globl vector24
vector24:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $24
c01021f7:	6a 18                	push   $0x18
  jmp __alltraps
c01021f9:	e9 9f 09 00 00       	jmp    c0102b9d <__alltraps>

c01021fe <vector25>:
.globl vector25
vector25:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $25
c0102200:	6a 19                	push   $0x19
  jmp __alltraps
c0102202:	e9 96 09 00 00       	jmp    c0102b9d <__alltraps>

c0102207 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102207:	6a 00                	push   $0x0
  pushl $26
c0102209:	6a 1a                	push   $0x1a
  jmp __alltraps
c010220b:	e9 8d 09 00 00       	jmp    c0102b9d <__alltraps>

c0102210 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102210:	6a 00                	push   $0x0
  pushl $27
c0102212:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102214:	e9 84 09 00 00       	jmp    c0102b9d <__alltraps>

c0102219 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $28
c010221b:	6a 1c                	push   $0x1c
  jmp __alltraps
c010221d:	e9 7b 09 00 00       	jmp    c0102b9d <__alltraps>

c0102222 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102222:	6a 00                	push   $0x0
  pushl $29
c0102224:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102226:	e9 72 09 00 00       	jmp    c0102b9d <__alltraps>

c010222b <vector30>:
.globl vector30
vector30:
  pushl $0
c010222b:	6a 00                	push   $0x0
  pushl $30
c010222d:	6a 1e                	push   $0x1e
  jmp __alltraps
c010222f:	e9 69 09 00 00       	jmp    c0102b9d <__alltraps>

c0102234 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102234:	6a 00                	push   $0x0
  pushl $31
c0102236:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102238:	e9 60 09 00 00       	jmp    c0102b9d <__alltraps>

c010223d <vector32>:
.globl vector32
vector32:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $32
c010223f:	6a 20                	push   $0x20
  jmp __alltraps
c0102241:	e9 57 09 00 00       	jmp    c0102b9d <__alltraps>

c0102246 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102246:	6a 00                	push   $0x0
  pushl $33
c0102248:	6a 21                	push   $0x21
  jmp __alltraps
c010224a:	e9 4e 09 00 00       	jmp    c0102b9d <__alltraps>

c010224f <vector34>:
.globl vector34
vector34:
  pushl $0
c010224f:	6a 00                	push   $0x0
  pushl $34
c0102251:	6a 22                	push   $0x22
  jmp __alltraps
c0102253:	e9 45 09 00 00       	jmp    c0102b9d <__alltraps>

c0102258 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102258:	6a 00                	push   $0x0
  pushl $35
c010225a:	6a 23                	push   $0x23
  jmp __alltraps
c010225c:	e9 3c 09 00 00       	jmp    c0102b9d <__alltraps>

c0102261 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $36
c0102263:	6a 24                	push   $0x24
  jmp __alltraps
c0102265:	e9 33 09 00 00       	jmp    c0102b9d <__alltraps>

c010226a <vector37>:
.globl vector37
vector37:
  pushl $0
c010226a:	6a 00                	push   $0x0
  pushl $37
c010226c:	6a 25                	push   $0x25
  jmp __alltraps
c010226e:	e9 2a 09 00 00       	jmp    c0102b9d <__alltraps>

c0102273 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102273:	6a 00                	push   $0x0
  pushl $38
c0102275:	6a 26                	push   $0x26
  jmp __alltraps
c0102277:	e9 21 09 00 00       	jmp    c0102b9d <__alltraps>

c010227c <vector39>:
.globl vector39
vector39:
  pushl $0
c010227c:	6a 00                	push   $0x0
  pushl $39
c010227e:	6a 27                	push   $0x27
  jmp __alltraps
c0102280:	e9 18 09 00 00       	jmp    c0102b9d <__alltraps>

c0102285 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $40
c0102287:	6a 28                	push   $0x28
  jmp __alltraps
c0102289:	e9 0f 09 00 00       	jmp    c0102b9d <__alltraps>

c010228e <vector41>:
.globl vector41
vector41:
  pushl $0
c010228e:	6a 00                	push   $0x0
  pushl $41
c0102290:	6a 29                	push   $0x29
  jmp __alltraps
c0102292:	e9 06 09 00 00       	jmp    c0102b9d <__alltraps>

c0102297 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102297:	6a 00                	push   $0x0
  pushl $42
c0102299:	6a 2a                	push   $0x2a
  jmp __alltraps
c010229b:	e9 fd 08 00 00       	jmp    c0102b9d <__alltraps>

c01022a0 <vector43>:
.globl vector43
vector43:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $43
c01022a2:	6a 2b                	push   $0x2b
  jmp __alltraps
c01022a4:	e9 f4 08 00 00       	jmp    c0102b9d <__alltraps>

c01022a9 <vector44>:
.globl vector44
vector44:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $44
c01022ab:	6a 2c                	push   $0x2c
  jmp __alltraps
c01022ad:	e9 eb 08 00 00       	jmp    c0102b9d <__alltraps>

c01022b2 <vector45>:
.globl vector45
vector45:
  pushl $0
c01022b2:	6a 00                	push   $0x0
  pushl $45
c01022b4:	6a 2d                	push   $0x2d
  jmp __alltraps
c01022b6:	e9 e2 08 00 00       	jmp    c0102b9d <__alltraps>

c01022bb <vector46>:
.globl vector46
vector46:
  pushl $0
c01022bb:	6a 00                	push   $0x0
  pushl $46
c01022bd:	6a 2e                	push   $0x2e
  jmp __alltraps
c01022bf:	e9 d9 08 00 00       	jmp    c0102b9d <__alltraps>

c01022c4 <vector47>:
.globl vector47
vector47:
  pushl $0
c01022c4:	6a 00                	push   $0x0
  pushl $47
c01022c6:	6a 2f                	push   $0x2f
  jmp __alltraps
c01022c8:	e9 d0 08 00 00       	jmp    c0102b9d <__alltraps>

c01022cd <vector48>:
.globl vector48
vector48:
  pushl $0
c01022cd:	6a 00                	push   $0x0
  pushl $48
c01022cf:	6a 30                	push   $0x30
  jmp __alltraps
c01022d1:	e9 c7 08 00 00       	jmp    c0102b9d <__alltraps>

c01022d6 <vector49>:
.globl vector49
vector49:
  pushl $0
c01022d6:	6a 00                	push   $0x0
  pushl $49
c01022d8:	6a 31                	push   $0x31
  jmp __alltraps
c01022da:	e9 be 08 00 00       	jmp    c0102b9d <__alltraps>

c01022df <vector50>:
.globl vector50
vector50:
  pushl $0
c01022df:	6a 00                	push   $0x0
  pushl $50
c01022e1:	6a 32                	push   $0x32
  jmp __alltraps
c01022e3:	e9 b5 08 00 00       	jmp    c0102b9d <__alltraps>

c01022e8 <vector51>:
.globl vector51
vector51:
  pushl $0
c01022e8:	6a 00                	push   $0x0
  pushl $51
c01022ea:	6a 33                	push   $0x33
  jmp __alltraps
c01022ec:	e9 ac 08 00 00       	jmp    c0102b9d <__alltraps>

c01022f1 <vector52>:
.globl vector52
vector52:
  pushl $0
c01022f1:	6a 00                	push   $0x0
  pushl $52
c01022f3:	6a 34                	push   $0x34
  jmp __alltraps
c01022f5:	e9 a3 08 00 00       	jmp    c0102b9d <__alltraps>

c01022fa <vector53>:
.globl vector53
vector53:
  pushl $0
c01022fa:	6a 00                	push   $0x0
  pushl $53
c01022fc:	6a 35                	push   $0x35
  jmp __alltraps
c01022fe:	e9 9a 08 00 00       	jmp    c0102b9d <__alltraps>

c0102303 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102303:	6a 00                	push   $0x0
  pushl $54
c0102305:	6a 36                	push   $0x36
  jmp __alltraps
c0102307:	e9 91 08 00 00       	jmp    c0102b9d <__alltraps>

c010230c <vector55>:
.globl vector55
vector55:
  pushl $0
c010230c:	6a 00                	push   $0x0
  pushl $55
c010230e:	6a 37                	push   $0x37
  jmp __alltraps
c0102310:	e9 88 08 00 00       	jmp    c0102b9d <__alltraps>

c0102315 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102315:	6a 00                	push   $0x0
  pushl $56
c0102317:	6a 38                	push   $0x38
  jmp __alltraps
c0102319:	e9 7f 08 00 00       	jmp    c0102b9d <__alltraps>

c010231e <vector57>:
.globl vector57
vector57:
  pushl $0
c010231e:	6a 00                	push   $0x0
  pushl $57
c0102320:	6a 39                	push   $0x39
  jmp __alltraps
c0102322:	e9 76 08 00 00       	jmp    c0102b9d <__alltraps>

c0102327 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102327:	6a 00                	push   $0x0
  pushl $58
c0102329:	6a 3a                	push   $0x3a
  jmp __alltraps
c010232b:	e9 6d 08 00 00       	jmp    c0102b9d <__alltraps>

c0102330 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102330:	6a 00                	push   $0x0
  pushl $59
c0102332:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102334:	e9 64 08 00 00       	jmp    c0102b9d <__alltraps>

c0102339 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102339:	6a 00                	push   $0x0
  pushl $60
c010233b:	6a 3c                	push   $0x3c
  jmp __alltraps
c010233d:	e9 5b 08 00 00       	jmp    c0102b9d <__alltraps>

c0102342 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102342:	6a 00                	push   $0x0
  pushl $61
c0102344:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102346:	e9 52 08 00 00       	jmp    c0102b9d <__alltraps>

c010234b <vector62>:
.globl vector62
vector62:
  pushl $0
c010234b:	6a 00                	push   $0x0
  pushl $62
c010234d:	6a 3e                	push   $0x3e
  jmp __alltraps
c010234f:	e9 49 08 00 00       	jmp    c0102b9d <__alltraps>

c0102354 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102354:	6a 00                	push   $0x0
  pushl $63
c0102356:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102358:	e9 40 08 00 00       	jmp    c0102b9d <__alltraps>

c010235d <vector64>:
.globl vector64
vector64:
  pushl $0
c010235d:	6a 00                	push   $0x0
  pushl $64
c010235f:	6a 40                	push   $0x40
  jmp __alltraps
c0102361:	e9 37 08 00 00       	jmp    c0102b9d <__alltraps>

c0102366 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102366:	6a 00                	push   $0x0
  pushl $65
c0102368:	6a 41                	push   $0x41
  jmp __alltraps
c010236a:	e9 2e 08 00 00       	jmp    c0102b9d <__alltraps>

c010236f <vector66>:
.globl vector66
vector66:
  pushl $0
c010236f:	6a 00                	push   $0x0
  pushl $66
c0102371:	6a 42                	push   $0x42
  jmp __alltraps
c0102373:	e9 25 08 00 00       	jmp    c0102b9d <__alltraps>

c0102378 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102378:	6a 00                	push   $0x0
  pushl $67
c010237a:	6a 43                	push   $0x43
  jmp __alltraps
c010237c:	e9 1c 08 00 00       	jmp    c0102b9d <__alltraps>

c0102381 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102381:	6a 00                	push   $0x0
  pushl $68
c0102383:	6a 44                	push   $0x44
  jmp __alltraps
c0102385:	e9 13 08 00 00       	jmp    c0102b9d <__alltraps>

c010238a <vector69>:
.globl vector69
vector69:
  pushl $0
c010238a:	6a 00                	push   $0x0
  pushl $69
c010238c:	6a 45                	push   $0x45
  jmp __alltraps
c010238e:	e9 0a 08 00 00       	jmp    c0102b9d <__alltraps>

c0102393 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102393:	6a 00                	push   $0x0
  pushl $70
c0102395:	6a 46                	push   $0x46
  jmp __alltraps
c0102397:	e9 01 08 00 00       	jmp    c0102b9d <__alltraps>

c010239c <vector71>:
.globl vector71
vector71:
  pushl $0
c010239c:	6a 00                	push   $0x0
  pushl $71
c010239e:	6a 47                	push   $0x47
  jmp __alltraps
c01023a0:	e9 f8 07 00 00       	jmp    c0102b9d <__alltraps>

c01023a5 <vector72>:
.globl vector72
vector72:
  pushl $0
c01023a5:	6a 00                	push   $0x0
  pushl $72
c01023a7:	6a 48                	push   $0x48
  jmp __alltraps
c01023a9:	e9 ef 07 00 00       	jmp    c0102b9d <__alltraps>

c01023ae <vector73>:
.globl vector73
vector73:
  pushl $0
c01023ae:	6a 00                	push   $0x0
  pushl $73
c01023b0:	6a 49                	push   $0x49
  jmp __alltraps
c01023b2:	e9 e6 07 00 00       	jmp    c0102b9d <__alltraps>

c01023b7 <vector74>:
.globl vector74
vector74:
  pushl $0
c01023b7:	6a 00                	push   $0x0
  pushl $74
c01023b9:	6a 4a                	push   $0x4a
  jmp __alltraps
c01023bb:	e9 dd 07 00 00       	jmp    c0102b9d <__alltraps>

c01023c0 <vector75>:
.globl vector75
vector75:
  pushl $0
c01023c0:	6a 00                	push   $0x0
  pushl $75
c01023c2:	6a 4b                	push   $0x4b
  jmp __alltraps
c01023c4:	e9 d4 07 00 00       	jmp    c0102b9d <__alltraps>

c01023c9 <vector76>:
.globl vector76
vector76:
  pushl $0
c01023c9:	6a 00                	push   $0x0
  pushl $76
c01023cb:	6a 4c                	push   $0x4c
  jmp __alltraps
c01023cd:	e9 cb 07 00 00       	jmp    c0102b9d <__alltraps>

c01023d2 <vector77>:
.globl vector77
vector77:
  pushl $0
c01023d2:	6a 00                	push   $0x0
  pushl $77
c01023d4:	6a 4d                	push   $0x4d
  jmp __alltraps
c01023d6:	e9 c2 07 00 00       	jmp    c0102b9d <__alltraps>

c01023db <vector78>:
.globl vector78
vector78:
  pushl $0
c01023db:	6a 00                	push   $0x0
  pushl $78
c01023dd:	6a 4e                	push   $0x4e
  jmp __alltraps
c01023df:	e9 b9 07 00 00       	jmp    c0102b9d <__alltraps>

c01023e4 <vector79>:
.globl vector79
vector79:
  pushl $0
c01023e4:	6a 00                	push   $0x0
  pushl $79
c01023e6:	6a 4f                	push   $0x4f
  jmp __alltraps
c01023e8:	e9 b0 07 00 00       	jmp    c0102b9d <__alltraps>

c01023ed <vector80>:
.globl vector80
vector80:
  pushl $0
c01023ed:	6a 00                	push   $0x0
  pushl $80
c01023ef:	6a 50                	push   $0x50
  jmp __alltraps
c01023f1:	e9 a7 07 00 00       	jmp    c0102b9d <__alltraps>

c01023f6 <vector81>:
.globl vector81
vector81:
  pushl $0
c01023f6:	6a 00                	push   $0x0
  pushl $81
c01023f8:	6a 51                	push   $0x51
  jmp __alltraps
c01023fa:	e9 9e 07 00 00       	jmp    c0102b9d <__alltraps>

c01023ff <vector82>:
.globl vector82
vector82:
  pushl $0
c01023ff:	6a 00                	push   $0x0
  pushl $82
c0102401:	6a 52                	push   $0x52
  jmp __alltraps
c0102403:	e9 95 07 00 00       	jmp    c0102b9d <__alltraps>

c0102408 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102408:	6a 00                	push   $0x0
  pushl $83
c010240a:	6a 53                	push   $0x53
  jmp __alltraps
c010240c:	e9 8c 07 00 00       	jmp    c0102b9d <__alltraps>

c0102411 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $84
c0102413:	6a 54                	push   $0x54
  jmp __alltraps
c0102415:	e9 83 07 00 00       	jmp    c0102b9d <__alltraps>

c010241a <vector85>:
.globl vector85
vector85:
  pushl $0
c010241a:	6a 00                	push   $0x0
  pushl $85
c010241c:	6a 55                	push   $0x55
  jmp __alltraps
c010241e:	e9 7a 07 00 00       	jmp    c0102b9d <__alltraps>

c0102423 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102423:	6a 00                	push   $0x0
  pushl $86
c0102425:	6a 56                	push   $0x56
  jmp __alltraps
c0102427:	e9 71 07 00 00       	jmp    c0102b9d <__alltraps>

c010242c <vector87>:
.globl vector87
vector87:
  pushl $0
c010242c:	6a 00                	push   $0x0
  pushl $87
c010242e:	6a 57                	push   $0x57
  jmp __alltraps
c0102430:	e9 68 07 00 00       	jmp    c0102b9d <__alltraps>

c0102435 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $88
c0102437:	6a 58                	push   $0x58
  jmp __alltraps
c0102439:	e9 5f 07 00 00       	jmp    c0102b9d <__alltraps>

c010243e <vector89>:
.globl vector89
vector89:
  pushl $0
c010243e:	6a 00                	push   $0x0
  pushl $89
c0102440:	6a 59                	push   $0x59
  jmp __alltraps
c0102442:	e9 56 07 00 00       	jmp    c0102b9d <__alltraps>

c0102447 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102447:	6a 00                	push   $0x0
  pushl $90
c0102449:	6a 5a                	push   $0x5a
  jmp __alltraps
c010244b:	e9 4d 07 00 00       	jmp    c0102b9d <__alltraps>

c0102450 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $91
c0102452:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102454:	e9 44 07 00 00       	jmp    c0102b9d <__alltraps>

c0102459 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102459:	6a 00                	push   $0x0
  pushl $92
c010245b:	6a 5c                	push   $0x5c
  jmp __alltraps
c010245d:	e9 3b 07 00 00       	jmp    c0102b9d <__alltraps>

c0102462 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102462:	6a 00                	push   $0x0
  pushl $93
c0102464:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102466:	e9 32 07 00 00       	jmp    c0102b9d <__alltraps>

c010246b <vector94>:
.globl vector94
vector94:
  pushl $0
c010246b:	6a 00                	push   $0x0
  pushl $94
c010246d:	6a 5e                	push   $0x5e
  jmp __alltraps
c010246f:	e9 29 07 00 00       	jmp    c0102b9d <__alltraps>

c0102474 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $95
c0102476:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102478:	e9 20 07 00 00       	jmp    c0102b9d <__alltraps>

c010247d <vector96>:
.globl vector96
vector96:
  pushl $0
c010247d:	6a 00                	push   $0x0
  pushl $96
c010247f:	6a 60                	push   $0x60
  jmp __alltraps
c0102481:	e9 17 07 00 00       	jmp    c0102b9d <__alltraps>

c0102486 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102486:	6a 00                	push   $0x0
  pushl $97
c0102488:	6a 61                	push   $0x61
  jmp __alltraps
c010248a:	e9 0e 07 00 00       	jmp    c0102b9d <__alltraps>

c010248f <vector98>:
.globl vector98
vector98:
  pushl $0
c010248f:	6a 00                	push   $0x0
  pushl $98
c0102491:	6a 62                	push   $0x62
  jmp __alltraps
c0102493:	e9 05 07 00 00       	jmp    c0102b9d <__alltraps>

c0102498 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $99
c010249a:	6a 63                	push   $0x63
  jmp __alltraps
c010249c:	e9 fc 06 00 00       	jmp    c0102b9d <__alltraps>

c01024a1 <vector100>:
.globl vector100
vector100:
  pushl $0
c01024a1:	6a 00                	push   $0x0
  pushl $100
c01024a3:	6a 64                	push   $0x64
  jmp __alltraps
c01024a5:	e9 f3 06 00 00       	jmp    c0102b9d <__alltraps>

c01024aa <vector101>:
.globl vector101
vector101:
  pushl $0
c01024aa:	6a 00                	push   $0x0
  pushl $101
c01024ac:	6a 65                	push   $0x65
  jmp __alltraps
c01024ae:	e9 ea 06 00 00       	jmp    c0102b9d <__alltraps>

c01024b3 <vector102>:
.globl vector102
vector102:
  pushl $0
c01024b3:	6a 00                	push   $0x0
  pushl $102
c01024b5:	6a 66                	push   $0x66
  jmp __alltraps
c01024b7:	e9 e1 06 00 00       	jmp    c0102b9d <__alltraps>

c01024bc <vector103>:
.globl vector103
vector103:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $103
c01024be:	6a 67                	push   $0x67
  jmp __alltraps
c01024c0:	e9 d8 06 00 00       	jmp    c0102b9d <__alltraps>

c01024c5 <vector104>:
.globl vector104
vector104:
  pushl $0
c01024c5:	6a 00                	push   $0x0
  pushl $104
c01024c7:	6a 68                	push   $0x68
  jmp __alltraps
c01024c9:	e9 cf 06 00 00       	jmp    c0102b9d <__alltraps>

c01024ce <vector105>:
.globl vector105
vector105:
  pushl $0
c01024ce:	6a 00                	push   $0x0
  pushl $105
c01024d0:	6a 69                	push   $0x69
  jmp __alltraps
c01024d2:	e9 c6 06 00 00       	jmp    c0102b9d <__alltraps>

c01024d7 <vector106>:
.globl vector106
vector106:
  pushl $0
c01024d7:	6a 00                	push   $0x0
  pushl $106
c01024d9:	6a 6a                	push   $0x6a
  jmp __alltraps
c01024db:	e9 bd 06 00 00       	jmp    c0102b9d <__alltraps>

c01024e0 <vector107>:
.globl vector107
vector107:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $107
c01024e2:	6a 6b                	push   $0x6b
  jmp __alltraps
c01024e4:	e9 b4 06 00 00       	jmp    c0102b9d <__alltraps>

c01024e9 <vector108>:
.globl vector108
vector108:
  pushl $0
c01024e9:	6a 00                	push   $0x0
  pushl $108
c01024eb:	6a 6c                	push   $0x6c
  jmp __alltraps
c01024ed:	e9 ab 06 00 00       	jmp    c0102b9d <__alltraps>

c01024f2 <vector109>:
.globl vector109
vector109:
  pushl $0
c01024f2:	6a 00                	push   $0x0
  pushl $109
c01024f4:	6a 6d                	push   $0x6d
  jmp __alltraps
c01024f6:	e9 a2 06 00 00       	jmp    c0102b9d <__alltraps>

c01024fb <vector110>:
.globl vector110
vector110:
  pushl $0
c01024fb:	6a 00                	push   $0x0
  pushl $110
c01024fd:	6a 6e                	push   $0x6e
  jmp __alltraps
c01024ff:	e9 99 06 00 00       	jmp    c0102b9d <__alltraps>

c0102504 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $111
c0102506:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102508:	e9 90 06 00 00       	jmp    c0102b9d <__alltraps>

c010250d <vector112>:
.globl vector112
vector112:
  pushl $0
c010250d:	6a 00                	push   $0x0
  pushl $112
c010250f:	6a 70                	push   $0x70
  jmp __alltraps
c0102511:	e9 87 06 00 00       	jmp    c0102b9d <__alltraps>

c0102516 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102516:	6a 00                	push   $0x0
  pushl $113
c0102518:	6a 71                	push   $0x71
  jmp __alltraps
c010251a:	e9 7e 06 00 00       	jmp    c0102b9d <__alltraps>

c010251f <vector114>:
.globl vector114
vector114:
  pushl $0
c010251f:	6a 00                	push   $0x0
  pushl $114
c0102521:	6a 72                	push   $0x72
  jmp __alltraps
c0102523:	e9 75 06 00 00       	jmp    c0102b9d <__alltraps>

c0102528 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $115
c010252a:	6a 73                	push   $0x73
  jmp __alltraps
c010252c:	e9 6c 06 00 00       	jmp    c0102b9d <__alltraps>

c0102531 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102531:	6a 00                	push   $0x0
  pushl $116
c0102533:	6a 74                	push   $0x74
  jmp __alltraps
c0102535:	e9 63 06 00 00       	jmp    c0102b9d <__alltraps>

c010253a <vector117>:
.globl vector117
vector117:
  pushl $0
c010253a:	6a 00                	push   $0x0
  pushl $117
c010253c:	6a 75                	push   $0x75
  jmp __alltraps
c010253e:	e9 5a 06 00 00       	jmp    c0102b9d <__alltraps>

c0102543 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102543:	6a 00                	push   $0x0
  pushl $118
c0102545:	6a 76                	push   $0x76
  jmp __alltraps
c0102547:	e9 51 06 00 00       	jmp    c0102b9d <__alltraps>

c010254c <vector119>:
.globl vector119
vector119:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $119
c010254e:	6a 77                	push   $0x77
  jmp __alltraps
c0102550:	e9 48 06 00 00       	jmp    c0102b9d <__alltraps>

c0102555 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102555:	6a 00                	push   $0x0
  pushl $120
c0102557:	6a 78                	push   $0x78
  jmp __alltraps
c0102559:	e9 3f 06 00 00       	jmp    c0102b9d <__alltraps>

c010255e <vector121>:
.globl vector121
vector121:
  pushl $0
c010255e:	6a 00                	push   $0x0
  pushl $121
c0102560:	6a 79                	push   $0x79
  jmp __alltraps
c0102562:	e9 36 06 00 00       	jmp    c0102b9d <__alltraps>

c0102567 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102567:	6a 00                	push   $0x0
  pushl $122
c0102569:	6a 7a                	push   $0x7a
  jmp __alltraps
c010256b:	e9 2d 06 00 00       	jmp    c0102b9d <__alltraps>

c0102570 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $123
c0102572:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102574:	e9 24 06 00 00       	jmp    c0102b9d <__alltraps>

c0102579 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102579:	6a 00                	push   $0x0
  pushl $124
c010257b:	6a 7c                	push   $0x7c
  jmp __alltraps
c010257d:	e9 1b 06 00 00       	jmp    c0102b9d <__alltraps>

c0102582 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102582:	6a 00                	push   $0x0
  pushl $125
c0102584:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102586:	e9 12 06 00 00       	jmp    c0102b9d <__alltraps>

c010258b <vector126>:
.globl vector126
vector126:
  pushl $0
c010258b:	6a 00                	push   $0x0
  pushl $126
c010258d:	6a 7e                	push   $0x7e
  jmp __alltraps
c010258f:	e9 09 06 00 00       	jmp    c0102b9d <__alltraps>

c0102594 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $127
c0102596:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102598:	e9 00 06 00 00       	jmp    c0102b9d <__alltraps>

c010259d <vector128>:
.globl vector128
vector128:
  pushl $0
c010259d:	6a 00                	push   $0x0
  pushl $128
c010259f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01025a4:	e9 f4 05 00 00       	jmp    c0102b9d <__alltraps>

c01025a9 <vector129>:
.globl vector129
vector129:
  pushl $0
c01025a9:	6a 00                	push   $0x0
  pushl $129
c01025ab:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01025b0:	e9 e8 05 00 00       	jmp    c0102b9d <__alltraps>

c01025b5 <vector130>:
.globl vector130
vector130:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $130
c01025b7:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01025bc:	e9 dc 05 00 00       	jmp    c0102b9d <__alltraps>

c01025c1 <vector131>:
.globl vector131
vector131:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $131
c01025c3:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01025c8:	e9 d0 05 00 00       	jmp    c0102b9d <__alltraps>

c01025cd <vector132>:
.globl vector132
vector132:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $132
c01025cf:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01025d4:	e9 c4 05 00 00       	jmp    c0102b9d <__alltraps>

c01025d9 <vector133>:
.globl vector133
vector133:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $133
c01025db:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01025e0:	e9 b8 05 00 00       	jmp    c0102b9d <__alltraps>

c01025e5 <vector134>:
.globl vector134
vector134:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $134
c01025e7:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01025ec:	e9 ac 05 00 00       	jmp    c0102b9d <__alltraps>

c01025f1 <vector135>:
.globl vector135
vector135:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $135
c01025f3:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01025f8:	e9 a0 05 00 00       	jmp    c0102b9d <__alltraps>

c01025fd <vector136>:
.globl vector136
vector136:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $136
c01025ff:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102604:	e9 94 05 00 00       	jmp    c0102b9d <__alltraps>

c0102609 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $137
c010260b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102610:	e9 88 05 00 00       	jmp    c0102b9d <__alltraps>

c0102615 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $138
c0102617:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010261c:	e9 7c 05 00 00       	jmp    c0102b9d <__alltraps>

c0102621 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $139
c0102623:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102628:	e9 70 05 00 00       	jmp    c0102b9d <__alltraps>

c010262d <vector140>:
.globl vector140
vector140:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $140
c010262f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102634:	e9 64 05 00 00       	jmp    c0102b9d <__alltraps>

c0102639 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $141
c010263b:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102640:	e9 58 05 00 00       	jmp    c0102b9d <__alltraps>

c0102645 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $142
c0102647:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010264c:	e9 4c 05 00 00       	jmp    c0102b9d <__alltraps>

c0102651 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $143
c0102653:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102658:	e9 40 05 00 00       	jmp    c0102b9d <__alltraps>

c010265d <vector144>:
.globl vector144
vector144:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $144
c010265f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102664:	e9 34 05 00 00       	jmp    c0102b9d <__alltraps>

c0102669 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $145
c010266b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102670:	e9 28 05 00 00       	jmp    c0102b9d <__alltraps>

c0102675 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $146
c0102677:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010267c:	e9 1c 05 00 00       	jmp    c0102b9d <__alltraps>

c0102681 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $147
c0102683:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102688:	e9 10 05 00 00       	jmp    c0102b9d <__alltraps>

c010268d <vector148>:
.globl vector148
vector148:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $148
c010268f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102694:	e9 04 05 00 00       	jmp    c0102b9d <__alltraps>

c0102699 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $149
c010269b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01026a0:	e9 f8 04 00 00       	jmp    c0102b9d <__alltraps>

c01026a5 <vector150>:
.globl vector150
vector150:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $150
c01026a7:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01026ac:	e9 ec 04 00 00       	jmp    c0102b9d <__alltraps>

c01026b1 <vector151>:
.globl vector151
vector151:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $151
c01026b3:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01026b8:	e9 e0 04 00 00       	jmp    c0102b9d <__alltraps>

c01026bd <vector152>:
.globl vector152
vector152:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $152
c01026bf:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01026c4:	e9 d4 04 00 00       	jmp    c0102b9d <__alltraps>

c01026c9 <vector153>:
.globl vector153
vector153:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $153
c01026cb:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01026d0:	e9 c8 04 00 00       	jmp    c0102b9d <__alltraps>

c01026d5 <vector154>:
.globl vector154
vector154:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $154
c01026d7:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01026dc:	e9 bc 04 00 00       	jmp    c0102b9d <__alltraps>

c01026e1 <vector155>:
.globl vector155
vector155:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $155
c01026e3:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01026e8:	e9 b0 04 00 00       	jmp    c0102b9d <__alltraps>

c01026ed <vector156>:
.globl vector156
vector156:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $156
c01026ef:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01026f4:	e9 a4 04 00 00       	jmp    c0102b9d <__alltraps>

c01026f9 <vector157>:
.globl vector157
vector157:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $157
c01026fb:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102700:	e9 98 04 00 00       	jmp    c0102b9d <__alltraps>

c0102705 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $158
c0102707:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010270c:	e9 8c 04 00 00       	jmp    c0102b9d <__alltraps>

c0102711 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $159
c0102713:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102718:	e9 80 04 00 00       	jmp    c0102b9d <__alltraps>

c010271d <vector160>:
.globl vector160
vector160:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $160
c010271f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102724:	e9 74 04 00 00       	jmp    c0102b9d <__alltraps>

c0102729 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $161
c010272b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102730:	e9 68 04 00 00       	jmp    c0102b9d <__alltraps>

c0102735 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $162
c0102737:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010273c:	e9 5c 04 00 00       	jmp    c0102b9d <__alltraps>

c0102741 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $163
c0102743:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102748:	e9 50 04 00 00       	jmp    c0102b9d <__alltraps>

c010274d <vector164>:
.globl vector164
vector164:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $164
c010274f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102754:	e9 44 04 00 00       	jmp    c0102b9d <__alltraps>

c0102759 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $165
c010275b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102760:	e9 38 04 00 00       	jmp    c0102b9d <__alltraps>

c0102765 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $166
c0102767:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010276c:	e9 2c 04 00 00       	jmp    c0102b9d <__alltraps>

c0102771 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $167
c0102773:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102778:	e9 20 04 00 00       	jmp    c0102b9d <__alltraps>

c010277d <vector168>:
.globl vector168
vector168:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $168
c010277f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102784:	e9 14 04 00 00       	jmp    c0102b9d <__alltraps>

c0102789 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $169
c010278b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102790:	e9 08 04 00 00       	jmp    c0102b9d <__alltraps>

c0102795 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $170
c0102797:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010279c:	e9 fc 03 00 00       	jmp    c0102b9d <__alltraps>

c01027a1 <vector171>:
.globl vector171
vector171:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $171
c01027a3:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01027a8:	e9 f0 03 00 00       	jmp    c0102b9d <__alltraps>

c01027ad <vector172>:
.globl vector172
vector172:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $172
c01027af:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01027b4:	e9 e4 03 00 00       	jmp    c0102b9d <__alltraps>

c01027b9 <vector173>:
.globl vector173
vector173:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $173
c01027bb:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01027c0:	e9 d8 03 00 00       	jmp    c0102b9d <__alltraps>

c01027c5 <vector174>:
.globl vector174
vector174:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $174
c01027c7:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01027cc:	e9 cc 03 00 00       	jmp    c0102b9d <__alltraps>

c01027d1 <vector175>:
.globl vector175
vector175:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $175
c01027d3:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01027d8:	e9 c0 03 00 00       	jmp    c0102b9d <__alltraps>

c01027dd <vector176>:
.globl vector176
vector176:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $176
c01027df:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01027e4:	e9 b4 03 00 00       	jmp    c0102b9d <__alltraps>

c01027e9 <vector177>:
.globl vector177
vector177:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $177
c01027eb:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01027f0:	e9 a8 03 00 00       	jmp    c0102b9d <__alltraps>

c01027f5 <vector178>:
.globl vector178
vector178:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $178
c01027f7:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01027fc:	e9 9c 03 00 00       	jmp    c0102b9d <__alltraps>

c0102801 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $179
c0102803:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102808:	e9 90 03 00 00       	jmp    c0102b9d <__alltraps>

c010280d <vector180>:
.globl vector180
vector180:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $180
c010280f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102814:	e9 84 03 00 00       	jmp    c0102b9d <__alltraps>

c0102819 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $181
c010281b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102820:	e9 78 03 00 00       	jmp    c0102b9d <__alltraps>

c0102825 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102825:	6a 00                	push   $0x0
  pushl $182
c0102827:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010282c:	e9 6c 03 00 00       	jmp    c0102b9d <__alltraps>

c0102831 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $183
c0102833:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102838:	e9 60 03 00 00       	jmp    c0102b9d <__alltraps>

c010283d <vector184>:
.globl vector184
vector184:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $184
c010283f:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102844:	e9 54 03 00 00       	jmp    c0102b9d <__alltraps>

c0102849 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102849:	6a 00                	push   $0x0
  pushl $185
c010284b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102850:	e9 48 03 00 00       	jmp    c0102b9d <__alltraps>

c0102855 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $186
c0102857:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010285c:	e9 3c 03 00 00       	jmp    c0102b9d <__alltraps>

c0102861 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $187
c0102863:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102868:	e9 30 03 00 00       	jmp    c0102b9d <__alltraps>

c010286d <vector188>:
.globl vector188
vector188:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $188
c010286f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102874:	e9 24 03 00 00       	jmp    c0102b9d <__alltraps>

c0102879 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $189
c010287b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102880:	e9 18 03 00 00       	jmp    c0102b9d <__alltraps>

c0102885 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $190
c0102887:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010288c:	e9 0c 03 00 00       	jmp    c0102b9d <__alltraps>

c0102891 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102891:	6a 00                	push   $0x0
  pushl $191
c0102893:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102898:	e9 00 03 00 00       	jmp    c0102b9d <__alltraps>

c010289d <vector192>:
.globl vector192
vector192:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $192
c010289f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01028a4:	e9 f4 02 00 00       	jmp    c0102b9d <__alltraps>

c01028a9 <vector193>:
.globl vector193
vector193:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $193
c01028ab:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01028b0:	e9 e8 02 00 00       	jmp    c0102b9d <__alltraps>

c01028b5 <vector194>:
.globl vector194
vector194:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $194
c01028b7:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01028bc:	e9 dc 02 00 00       	jmp    c0102b9d <__alltraps>

c01028c1 <vector195>:
.globl vector195
vector195:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $195
c01028c3:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01028c8:	e9 d0 02 00 00       	jmp    c0102b9d <__alltraps>

c01028cd <vector196>:
.globl vector196
vector196:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $196
c01028cf:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01028d4:	e9 c4 02 00 00       	jmp    c0102b9d <__alltraps>

c01028d9 <vector197>:
.globl vector197
vector197:
  pushl $0
c01028d9:	6a 00                	push   $0x0
  pushl $197
c01028db:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01028e0:	e9 b8 02 00 00       	jmp    c0102b9d <__alltraps>

c01028e5 <vector198>:
.globl vector198
vector198:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $198
c01028e7:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01028ec:	e9 ac 02 00 00       	jmp    c0102b9d <__alltraps>

c01028f1 <vector199>:
.globl vector199
vector199:
  pushl $0
c01028f1:	6a 00                	push   $0x0
  pushl $199
c01028f3:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01028f8:	e9 a0 02 00 00       	jmp    c0102b9d <__alltraps>

c01028fd <vector200>:
.globl vector200
vector200:
  pushl $0
c01028fd:	6a 00                	push   $0x0
  pushl $200
c01028ff:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102904:	e9 94 02 00 00       	jmp    c0102b9d <__alltraps>

c0102909 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $201
c010290b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102910:	e9 88 02 00 00       	jmp    c0102b9d <__alltraps>

c0102915 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102915:	6a 00                	push   $0x0
  pushl $202
c0102917:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010291c:	e9 7c 02 00 00       	jmp    c0102b9d <__alltraps>

c0102921 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102921:	6a 00                	push   $0x0
  pushl $203
c0102923:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102928:	e9 70 02 00 00       	jmp    c0102b9d <__alltraps>

c010292d <vector204>:
.globl vector204
vector204:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $204
c010292f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102934:	e9 64 02 00 00       	jmp    c0102b9d <__alltraps>

c0102939 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102939:	6a 00                	push   $0x0
  pushl $205
c010293b:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102940:	e9 58 02 00 00       	jmp    c0102b9d <__alltraps>

c0102945 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102945:	6a 00                	push   $0x0
  pushl $206
c0102947:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010294c:	e9 4c 02 00 00       	jmp    c0102b9d <__alltraps>

c0102951 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102951:	6a 00                	push   $0x0
  pushl $207
c0102953:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102958:	e9 40 02 00 00       	jmp    c0102b9d <__alltraps>

c010295d <vector208>:
.globl vector208
vector208:
  pushl $0
c010295d:	6a 00                	push   $0x0
  pushl $208
c010295f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102964:	e9 34 02 00 00       	jmp    c0102b9d <__alltraps>

c0102969 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102969:	6a 00                	push   $0x0
  pushl $209
c010296b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102970:	e9 28 02 00 00       	jmp    c0102b9d <__alltraps>

c0102975 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102975:	6a 00                	push   $0x0
  pushl $210
c0102977:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010297c:	e9 1c 02 00 00       	jmp    c0102b9d <__alltraps>

c0102981 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102981:	6a 00                	push   $0x0
  pushl $211
c0102983:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102988:	e9 10 02 00 00       	jmp    c0102b9d <__alltraps>

c010298d <vector212>:
.globl vector212
vector212:
  pushl $0
c010298d:	6a 00                	push   $0x0
  pushl $212
c010298f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102994:	e9 04 02 00 00       	jmp    c0102b9d <__alltraps>

c0102999 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102999:	6a 00                	push   $0x0
  pushl $213
c010299b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01029a0:	e9 f8 01 00 00       	jmp    c0102b9d <__alltraps>

c01029a5 <vector214>:
.globl vector214
vector214:
  pushl $0
c01029a5:	6a 00                	push   $0x0
  pushl $214
c01029a7:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01029ac:	e9 ec 01 00 00       	jmp    c0102b9d <__alltraps>

c01029b1 <vector215>:
.globl vector215
vector215:
  pushl $0
c01029b1:	6a 00                	push   $0x0
  pushl $215
c01029b3:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01029b8:	e9 e0 01 00 00       	jmp    c0102b9d <__alltraps>

c01029bd <vector216>:
.globl vector216
vector216:
  pushl $0
c01029bd:	6a 00                	push   $0x0
  pushl $216
c01029bf:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01029c4:	e9 d4 01 00 00       	jmp    c0102b9d <__alltraps>

c01029c9 <vector217>:
.globl vector217
vector217:
  pushl $0
c01029c9:	6a 00                	push   $0x0
  pushl $217
c01029cb:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01029d0:	e9 c8 01 00 00       	jmp    c0102b9d <__alltraps>

c01029d5 <vector218>:
.globl vector218
vector218:
  pushl $0
c01029d5:	6a 00                	push   $0x0
  pushl $218
c01029d7:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01029dc:	e9 bc 01 00 00       	jmp    c0102b9d <__alltraps>

c01029e1 <vector219>:
.globl vector219
vector219:
  pushl $0
c01029e1:	6a 00                	push   $0x0
  pushl $219
c01029e3:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01029e8:	e9 b0 01 00 00       	jmp    c0102b9d <__alltraps>

c01029ed <vector220>:
.globl vector220
vector220:
  pushl $0
c01029ed:	6a 00                	push   $0x0
  pushl $220
c01029ef:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01029f4:	e9 a4 01 00 00       	jmp    c0102b9d <__alltraps>

c01029f9 <vector221>:
.globl vector221
vector221:
  pushl $0
c01029f9:	6a 00                	push   $0x0
  pushl $221
c01029fb:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102a00:	e9 98 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a05 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102a05:	6a 00                	push   $0x0
  pushl $222
c0102a07:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102a0c:	e9 8c 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a11 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102a11:	6a 00                	push   $0x0
  pushl $223
c0102a13:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102a18:	e9 80 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a1d <vector224>:
.globl vector224
vector224:
  pushl $0
c0102a1d:	6a 00                	push   $0x0
  pushl $224
c0102a1f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102a24:	e9 74 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a29 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102a29:	6a 00                	push   $0x0
  pushl $225
c0102a2b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102a30:	e9 68 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a35 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102a35:	6a 00                	push   $0x0
  pushl $226
c0102a37:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102a3c:	e9 5c 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a41 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102a41:	6a 00                	push   $0x0
  pushl $227
c0102a43:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102a48:	e9 50 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a4d <vector228>:
.globl vector228
vector228:
  pushl $0
c0102a4d:	6a 00                	push   $0x0
  pushl $228
c0102a4f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102a54:	e9 44 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a59 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102a59:	6a 00                	push   $0x0
  pushl $229
c0102a5b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102a60:	e9 38 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a65 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102a65:	6a 00                	push   $0x0
  pushl $230
c0102a67:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102a6c:	e9 2c 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a71 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102a71:	6a 00                	push   $0x0
  pushl $231
c0102a73:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102a78:	e9 20 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a7d <vector232>:
.globl vector232
vector232:
  pushl $0
c0102a7d:	6a 00                	push   $0x0
  pushl $232
c0102a7f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102a84:	e9 14 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a89 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102a89:	6a 00                	push   $0x0
  pushl $233
c0102a8b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102a90:	e9 08 01 00 00       	jmp    c0102b9d <__alltraps>

c0102a95 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102a95:	6a 00                	push   $0x0
  pushl $234
c0102a97:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102a9c:	e9 fc 00 00 00       	jmp    c0102b9d <__alltraps>

c0102aa1 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102aa1:	6a 00                	push   $0x0
  pushl $235
c0102aa3:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102aa8:	e9 f0 00 00 00       	jmp    c0102b9d <__alltraps>

c0102aad <vector236>:
.globl vector236
vector236:
  pushl $0
c0102aad:	6a 00                	push   $0x0
  pushl $236
c0102aaf:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102ab4:	e9 e4 00 00 00       	jmp    c0102b9d <__alltraps>

c0102ab9 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102ab9:	6a 00                	push   $0x0
  pushl $237
c0102abb:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102ac0:	e9 d8 00 00 00       	jmp    c0102b9d <__alltraps>

c0102ac5 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102ac5:	6a 00                	push   $0x0
  pushl $238
c0102ac7:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102acc:	e9 cc 00 00 00       	jmp    c0102b9d <__alltraps>

c0102ad1 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102ad1:	6a 00                	push   $0x0
  pushl $239
c0102ad3:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102ad8:	e9 c0 00 00 00       	jmp    c0102b9d <__alltraps>

c0102add <vector240>:
.globl vector240
vector240:
  pushl $0
c0102add:	6a 00                	push   $0x0
  pushl $240
c0102adf:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102ae4:	e9 b4 00 00 00       	jmp    c0102b9d <__alltraps>

c0102ae9 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102ae9:	6a 00                	push   $0x0
  pushl $241
c0102aeb:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102af0:	e9 a8 00 00 00       	jmp    c0102b9d <__alltraps>

c0102af5 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102af5:	6a 00                	push   $0x0
  pushl $242
c0102af7:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102afc:	e9 9c 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b01 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102b01:	6a 00                	push   $0x0
  pushl $243
c0102b03:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102b08:	e9 90 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b0d <vector244>:
.globl vector244
vector244:
  pushl $0
c0102b0d:	6a 00                	push   $0x0
  pushl $244
c0102b0f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102b14:	e9 84 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b19 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102b19:	6a 00                	push   $0x0
  pushl $245
c0102b1b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102b20:	e9 78 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b25 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102b25:	6a 00                	push   $0x0
  pushl $246
c0102b27:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102b2c:	e9 6c 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b31 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102b31:	6a 00                	push   $0x0
  pushl $247
c0102b33:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102b38:	e9 60 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b3d <vector248>:
.globl vector248
vector248:
  pushl $0
c0102b3d:	6a 00                	push   $0x0
  pushl $248
c0102b3f:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102b44:	e9 54 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b49 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102b49:	6a 00                	push   $0x0
  pushl $249
c0102b4b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102b50:	e9 48 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b55 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102b55:	6a 00                	push   $0x0
  pushl $250
c0102b57:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102b5c:	e9 3c 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b61 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102b61:	6a 00                	push   $0x0
  pushl $251
c0102b63:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102b68:	e9 30 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b6d <vector252>:
.globl vector252
vector252:
  pushl $0
c0102b6d:	6a 00                	push   $0x0
  pushl $252
c0102b6f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102b74:	e9 24 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b79 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102b79:	6a 00                	push   $0x0
  pushl $253
c0102b7b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102b80:	e9 18 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b85 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102b85:	6a 00                	push   $0x0
  pushl $254
c0102b87:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102b8c:	e9 0c 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b91 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102b91:	6a 00                	push   $0x0
  pushl $255
c0102b93:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102b98:	e9 00 00 00 00       	jmp    c0102b9d <__alltraps>

c0102b9d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102b9d:	1e                   	push   %ds
    pushl %es
c0102b9e:	06                   	push   %es
    pushl %fs
c0102b9f:	0f a0                	push   %fs
    pushl %gs
c0102ba1:	0f a8                	push   %gs
    pushal
c0102ba3:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102ba4:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102ba9:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102bab:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102bad:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102bae:	e8 64 f5 ff ff       	call   c0102117 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102bb3:	5c                   	pop    %esp

c0102bb4 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102bb4:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102bb5:	0f a9                	pop    %gs
    popl %fs
c0102bb7:	0f a1                	pop    %fs
    popl %es
c0102bb9:	07                   	pop    %es
    popl %ds
c0102bba:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102bbb:	83 c4 08             	add    $0x8,%esp
    iret
c0102bbe:	cf                   	iret   

c0102bbf <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102bbf:	55                   	push   %ebp
c0102bc0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bc5:	8b 15 78 af 11 c0    	mov    0xc011af78,%edx
c0102bcb:	29 d0                	sub    %edx,%eax
c0102bcd:	c1 f8 02             	sar    $0x2,%eax
c0102bd0:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102bd6:	5d                   	pop    %ebp
c0102bd7:	c3                   	ret    

c0102bd8 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102bd8:	55                   	push   %ebp
c0102bd9:	89 e5                	mov    %esp,%ebp
c0102bdb:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0102be1:	89 04 24             	mov    %eax,(%esp)
c0102be4:	e8 d6 ff ff ff       	call   c0102bbf <page2ppn>
c0102be9:	c1 e0 0c             	shl    $0xc,%eax
}
c0102bec:	c9                   	leave  
c0102bed:	c3                   	ret    

c0102bee <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102bee:	55                   	push   %ebp
c0102bef:	89 e5                	mov    %esp,%ebp
c0102bf1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102bf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bf7:	c1 e8 0c             	shr    $0xc,%eax
c0102bfa:	89 c2                	mov    %eax,%edx
c0102bfc:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102c01:	39 c2                	cmp    %eax,%edx
c0102c03:	72 1c                	jb     c0102c21 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102c05:	c7 44 24 08 50 62 10 	movl   $0xc0106250,0x8(%esp)
c0102c0c:	c0 
c0102c0d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0102c14:	00 
c0102c15:	c7 04 24 6f 62 10 c0 	movl   $0xc010626f,(%esp)
c0102c1c:	e8 d8 d7 ff ff       	call   c01003f9 <__panic>
    }
    return &pages[PPN(pa)];
c0102c21:	8b 0d 78 af 11 c0    	mov    0xc011af78,%ecx
c0102c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c2a:	c1 e8 0c             	shr    $0xc,%eax
c0102c2d:	89 c2                	mov    %eax,%edx
c0102c2f:	89 d0                	mov    %edx,%eax
c0102c31:	c1 e0 02             	shl    $0x2,%eax
c0102c34:	01 d0                	add    %edx,%eax
c0102c36:	c1 e0 02             	shl    $0x2,%eax
c0102c39:	01 c8                	add    %ecx,%eax
}
c0102c3b:	c9                   	leave  
c0102c3c:	c3                   	ret    

c0102c3d <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102c3d:	55                   	push   %ebp
c0102c3e:	89 e5                	mov    %esp,%ebp
c0102c40:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c46:	89 04 24             	mov    %eax,(%esp)
c0102c49:	e8 8a ff ff ff       	call   c0102bd8 <page2pa>
c0102c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c54:	c1 e8 0c             	shr    $0xc,%eax
c0102c57:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c5a:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102c5f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102c62:	72 23                	jb     c0102c87 <page2kva+0x4a>
c0102c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c67:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102c6b:	c7 44 24 08 80 62 10 	movl   $0xc0106280,0x8(%esp)
c0102c72:	c0 
c0102c73:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0102c7a:	00 
c0102c7b:	c7 04 24 6f 62 10 c0 	movl   $0xc010626f,(%esp)
c0102c82:	e8 72 d7 ff ff       	call   c01003f9 <__panic>
c0102c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c8a:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102c8f:	c9                   	leave  
c0102c90:	c3                   	ret    

c0102c91 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102c91:	55                   	push   %ebp
c0102c92:	89 e5                	mov    %esp,%ebp
c0102c94:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9a:	83 e0 01             	and    $0x1,%eax
c0102c9d:	85 c0                	test   %eax,%eax
c0102c9f:	75 1c                	jne    c0102cbd <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102ca1:	c7 44 24 08 a4 62 10 	movl   $0xc01062a4,0x8(%esp)
c0102ca8:	c0 
c0102ca9:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102cb0:	00 
c0102cb1:	c7 04 24 6f 62 10 c0 	movl   $0xc010626f,(%esp)
c0102cb8:	e8 3c d7 ff ff       	call   c01003f9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102cbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102cc5:	89 04 24             	mov    %eax,(%esp)
c0102cc8:	e8 21 ff ff ff       	call   c0102bee <pa2page>
}
c0102ccd:	c9                   	leave  
c0102cce:	c3                   	ret    

c0102ccf <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102ccf:	55                   	push   %ebp
c0102cd0:	89 e5                	mov    %esp,%ebp
c0102cd2:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102cdd:	89 04 24             	mov    %eax,(%esp)
c0102ce0:	e8 09 ff ff ff       	call   c0102bee <pa2page>
}
c0102ce5:	c9                   	leave  
c0102ce6:	c3                   	ret    

c0102ce7 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102ce7:	55                   	push   %ebp
c0102ce8:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102cea:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ced:	8b 00                	mov    (%eax),%eax
}
c0102cef:	5d                   	pop    %ebp
c0102cf0:	c3                   	ret    

c0102cf1 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102cf1:	55                   	push   %ebp
c0102cf2:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cfa:	89 10                	mov    %edx,(%eax)
}
c0102cfc:	90                   	nop
c0102cfd:	5d                   	pop    %ebp
c0102cfe:	c3                   	ret    

c0102cff <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102cff:	55                   	push   %ebp
c0102d00:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102d02:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d05:	8b 00                	mov    (%eax),%eax
c0102d07:	8d 50 01             	lea    0x1(%eax),%edx
c0102d0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102d0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d12:	8b 00                	mov    (%eax),%eax
}
c0102d14:	5d                   	pop    %ebp
c0102d15:	c3                   	ret    

c0102d16 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102d16:	55                   	push   %ebp
c0102d17:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102d19:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d1c:	8b 00                	mov    (%eax),%eax
c0102d1e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102d21:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d24:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d29:	8b 00                	mov    (%eax),%eax
}
c0102d2b:	5d                   	pop    %ebp
c0102d2c:	c3                   	ret    

c0102d2d <__intr_save>:
__intr_save(void) {
c0102d2d:	55                   	push   %ebp
c0102d2e:	89 e5                	mov    %esp,%ebp
c0102d30:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102d33:	9c                   	pushf  
c0102d34:	58                   	pop    %eax
c0102d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102d3b:	25 00 02 00 00       	and    $0x200,%eax
c0102d40:	85 c0                	test   %eax,%eax
c0102d42:	74 0c                	je     c0102d50 <__intr_save+0x23>
        intr_disable();
c0102d44:	e8 60 eb ff ff       	call   c01018a9 <intr_disable>
        return 1;
c0102d49:	b8 01 00 00 00       	mov    $0x1,%eax
c0102d4e:	eb 05                	jmp    c0102d55 <__intr_save+0x28>
    return 0;
c0102d50:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102d55:	c9                   	leave  
c0102d56:	c3                   	ret    

c0102d57 <__intr_restore>:
__intr_restore(bool flag) {
c0102d57:	55                   	push   %ebp
c0102d58:	89 e5                	mov    %esp,%ebp
c0102d5a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102d5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102d61:	74 05                	je     c0102d68 <__intr_restore+0x11>
        intr_enable();
c0102d63:	e8 3a eb ff ff       	call   c01018a2 <intr_enable>
}
c0102d68:	90                   	nop
c0102d69:	c9                   	leave  
c0102d6a:	c3                   	ret    

c0102d6b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102d6b:	55                   	push   %ebp
c0102d6c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102d6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d71:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102d74:	b8 23 00 00 00       	mov    $0x23,%eax
c0102d79:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102d7b:	b8 23 00 00 00       	mov    $0x23,%eax
c0102d80:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102d82:	b8 10 00 00 00       	mov    $0x10,%eax
c0102d87:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102d89:	b8 10 00 00 00       	mov    $0x10,%eax
c0102d8e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102d90:	b8 10 00 00 00       	mov    $0x10,%eax
c0102d95:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102d97:	ea 9e 2d 10 c0 08 00 	ljmp   $0x8,$0xc0102d9e
}
c0102d9e:	90                   	nop
c0102d9f:	5d                   	pop    %ebp
c0102da0:	c3                   	ret    

c0102da1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102da1:	55                   	push   %ebp
c0102da2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102da4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da7:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0102dac:	90                   	nop
c0102dad:	5d                   	pop    %ebp
c0102dae:	c3                   	ret    

c0102daf <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102daf:	55                   	push   %ebp
c0102db0:	89 e5                	mov    %esp,%ebp
c0102db2:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102db5:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102dba:	89 04 24             	mov    %eax,(%esp)
c0102dbd:	e8 df ff ff ff       	call   c0102da1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102dc2:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0102dc9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102dcb:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102dd2:	68 00 
c0102dd4:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102dd9:	0f b7 c0             	movzwl %ax,%eax
c0102ddc:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102de2:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102de7:	c1 e8 10             	shr    $0x10,%eax
c0102dea:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102def:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102df6:	24 f0                	and    $0xf0,%al
c0102df8:	0c 09                	or     $0x9,%al
c0102dfa:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102dff:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102e06:	24 ef                	and    $0xef,%al
c0102e08:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102e0d:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102e14:	24 9f                	and    $0x9f,%al
c0102e16:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102e1b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102e22:	0c 80                	or     $0x80,%al
c0102e24:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102e29:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102e30:	24 f0                	and    $0xf0,%al
c0102e32:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102e37:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102e3e:	24 ef                	and    $0xef,%al
c0102e40:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102e45:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102e4c:	24 df                	and    $0xdf,%al
c0102e4e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102e53:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102e5a:	0c 40                	or     $0x40,%al
c0102e5c:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102e61:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102e68:	24 7f                	and    $0x7f,%al
c0102e6a:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102e6f:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102e74:	c1 e8 18             	shr    $0x18,%eax
c0102e77:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102e7c:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0102e83:	e8 e3 fe ff ff       	call   c0102d6b <lgdt>
c0102e88:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102e8e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102e92:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102e95:	90                   	nop
c0102e96:	c9                   	leave  
c0102e97:	c3                   	ret    

c0102e98 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102e98:	55                   	push   %ebp
c0102e99:	89 e5                	mov    %esp,%ebp
c0102e9b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102e9e:	c7 05 70 af 11 c0 60 	movl   $0xc0106a60,0xc011af70
c0102ea5:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102ea8:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102ead:	8b 00                	mov    (%eax),%eax
c0102eaf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102eb3:	c7 04 24 d0 62 10 c0 	movl   $0xc01062d0,(%esp)
c0102eba:	e8 e3 d3 ff ff       	call   c01002a2 <cprintf>
    pmm_manager->init();
c0102ebf:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102ec4:	8b 40 04             	mov    0x4(%eax),%eax
c0102ec7:	ff d0                	call   *%eax
}
c0102ec9:	90                   	nop
c0102eca:	c9                   	leave  
c0102ecb:	c3                   	ret    

c0102ecc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102ecc:	55                   	push   %ebp
c0102ecd:	89 e5                	mov    %esp,%ebp
c0102ecf:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102ed2:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102ed7:	8b 40 08             	mov    0x8(%eax),%eax
c0102eda:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102edd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102ee1:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ee4:	89 14 24             	mov    %edx,(%esp)
c0102ee7:	ff d0                	call   *%eax
}
c0102ee9:	90                   	nop
c0102eea:	c9                   	leave  
c0102eeb:	c3                   	ret    

c0102eec <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102eec:	55                   	push   %ebp
c0102eed:	89 e5                	mov    %esp,%ebp
c0102eef:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102ef2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102ef9:	e8 2f fe ff ff       	call   c0102d2d <__intr_save>
c0102efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102f01:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102f06:	8b 40 0c             	mov    0xc(%eax),%eax
c0102f09:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f0c:	89 14 24             	mov    %edx,(%esp)
c0102f0f:	ff d0                	call   *%eax
c0102f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f17:	89 04 24             	mov    %eax,(%esp)
c0102f1a:	e8 38 fe ff ff       	call   c0102d57 <__intr_restore>
    return page;
c0102f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102f22:	c9                   	leave  
c0102f23:	c3                   	ret    

c0102f24 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102f24:	55                   	push   %ebp
c0102f25:	89 e5                	mov    %esp,%ebp
c0102f27:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102f2a:	e8 fe fd ff ff       	call   c0102d2d <__intr_save>
c0102f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102f32:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102f37:	8b 40 10             	mov    0x10(%eax),%eax
c0102f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102f3d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102f41:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f44:	89 14 24             	mov    %edx,(%esp)
c0102f47:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f4c:	89 04 24             	mov    %eax,(%esp)
c0102f4f:	e8 03 fe ff ff       	call   c0102d57 <__intr_restore>
}
c0102f54:	90                   	nop
c0102f55:	c9                   	leave  
c0102f56:	c3                   	ret    

c0102f57 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102f57:	55                   	push   %ebp
c0102f58:	89 e5                	mov    %esp,%ebp
c0102f5a:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102f5d:	e8 cb fd ff ff       	call   c0102d2d <__intr_save>
c0102f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102f65:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102f6a:	8b 40 14             	mov    0x14(%eax),%eax
c0102f6d:	ff d0                	call   *%eax
c0102f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f75:	89 04 24             	mov    %eax,(%esp)
c0102f78:	e8 da fd ff ff       	call   c0102d57 <__intr_restore>
    return ret;
c0102f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102f80:	c9                   	leave  
c0102f81:	c3                   	ret    

c0102f82 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102f82:	55                   	push   %ebp
c0102f83:	89 e5                	mov    %esp,%ebp
c0102f85:	57                   	push   %edi
c0102f86:	56                   	push   %esi
c0102f87:	53                   	push   %ebx
c0102f88:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102f8e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102f95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102f9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cprintf("e820map:\n");
c0102fa3:	c7 04 24 e7 62 10 c0 	movl   $0xc01062e7,(%esp)
c0102faa:	e8 f3 d2 ff ff       	call   c01002a2 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102faf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fb6:	e9 22 01 00 00       	jmp    c01030dd <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102fbb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fbe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fc1:	89 d0                	mov    %edx,%eax
c0102fc3:	c1 e0 02             	shl    $0x2,%eax
c0102fc6:	01 d0                	add    %edx,%eax
c0102fc8:	c1 e0 02             	shl    $0x2,%eax
c0102fcb:	01 c8                	add    %ecx,%eax
c0102fcd:	8b 50 08             	mov    0x8(%eax),%edx
c0102fd0:	8b 40 04             	mov    0x4(%eax),%eax
c0102fd3:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102fd6:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102fd9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fdf:	89 d0                	mov    %edx,%eax
c0102fe1:	c1 e0 02             	shl    $0x2,%eax
c0102fe4:	01 d0                	add    %edx,%eax
c0102fe6:	c1 e0 02             	shl    $0x2,%eax
c0102fe9:	01 c8                	add    %ecx,%eax
c0102feb:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102fee:	8b 58 10             	mov    0x10(%eax),%ebx
c0102ff1:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ff4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102ff7:	01 c8                	add    %ecx,%eax
c0102ff9:	11 da                	adc    %ebx,%edx
c0102ffb:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102ffe:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103001:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103004:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103007:	89 d0                	mov    %edx,%eax
c0103009:	c1 e0 02             	shl    $0x2,%eax
c010300c:	01 d0                	add    %edx,%eax
c010300e:	c1 e0 02             	shl    $0x2,%eax
c0103011:	01 c8                	add    %ecx,%eax
c0103013:	83 c0 14             	add    $0x14,%eax
c0103016:	8b 00                	mov    (%eax),%eax
c0103018:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010301b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010301e:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103021:	83 c0 ff             	add    $0xffffffff,%eax
c0103024:	83 d2 ff             	adc    $0xffffffff,%edx
c0103027:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c010302d:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0103033:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103036:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103039:	89 d0                	mov    %edx,%eax
c010303b:	c1 e0 02             	shl    $0x2,%eax
c010303e:	01 d0                	add    %edx,%eax
c0103040:	c1 e0 02             	shl    $0x2,%eax
c0103043:	01 c8                	add    %ecx,%eax
c0103045:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103048:	8b 58 10             	mov    0x10(%eax),%ebx
c010304b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010304e:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0103052:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0103058:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c010305e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103062:	89 54 24 18          	mov    %edx,0x18(%esp)
c0103066:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103069:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010306c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103070:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103074:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103078:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c010307c:	c7 04 24 f4 62 10 c0 	movl   $0xc01062f4,(%esp)
c0103083:	e8 1a d2 ff ff       	call   c01002a2 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103088:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010308b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010308e:	89 d0                	mov    %edx,%eax
c0103090:	c1 e0 02             	shl    $0x2,%eax
c0103093:	01 d0                	add    %edx,%eax
c0103095:	c1 e0 02             	shl    $0x2,%eax
c0103098:	01 c8                	add    %ecx,%eax
c010309a:	83 c0 14             	add    $0x14,%eax
c010309d:	8b 00                	mov    (%eax),%eax
c010309f:	83 f8 01             	cmp    $0x1,%eax
c01030a2:	75 36                	jne    c01030da <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c01030a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01030aa:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c01030ad:	77 2b                	ja     c01030da <page_init+0x158>
c01030af:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c01030b2:	72 05                	jb     c01030b9 <page_init+0x137>
c01030b4:	3b 45 98             	cmp    -0x68(%ebp),%eax
c01030b7:	73 21                	jae    c01030da <page_init+0x158>
c01030b9:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01030bd:	77 1b                	ja     c01030da <page_init+0x158>
c01030bf:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01030c3:	72 09                	jb     c01030ce <page_init+0x14c>
c01030c5:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c01030cc:	77 0c                	ja     c01030da <page_init+0x158>
                maxpa = end;
c01030ce:	8b 45 98             	mov    -0x68(%ebp),%eax
c01030d1:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01030d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01030d7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c01030da:	ff 45 dc             	incl   -0x24(%ebp)
c01030dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01030e0:	8b 00                	mov    (%eax),%eax
c01030e2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030e5:	0f 8c d0 fe ff ff    	jl     c0102fbb <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01030eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01030ef:	72 1d                	jb     c010310e <page_init+0x18c>
c01030f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01030f5:	77 09                	ja     c0103100 <page_init+0x17e>
c01030f7:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01030fe:	76 0e                	jbe    c010310e <page_init+0x18c>
        maxpa = KMEMSIZE;
c0103100:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103107:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010310e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103111:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103114:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103118:	c1 ea 0c             	shr    $0xc,%edx
c010311b:	89 c1                	mov    %eax,%ecx
c010311d:	89 d3                	mov    %edx,%ebx
c010311f:	89 c8                	mov    %ecx,%eax
c0103121:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103126:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c010312d:	b8 94 af 25 c0       	mov    $0xc025af94,%eax
c0103132:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103135:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103138:	01 d0                	add    %edx,%eax
c010313a:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010313d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103140:	ba 00 00 00 00       	mov    $0x0,%edx
c0103145:	f7 75 c0             	divl   -0x40(%ebp)
c0103148:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010314b:	29 d0                	sub    %edx,%eax
c010314d:	a3 78 af 11 c0       	mov    %eax,0xc011af78
    for (i = 0; i < npage; i ++) {
c0103152:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103159:	eb 2e                	jmp    c0103189 <page_init+0x207>
        SetPageReserved(pages + i);
c010315b:	8b 0d 78 af 11 c0    	mov    0xc011af78,%ecx
c0103161:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103164:	89 d0                	mov    %edx,%eax
c0103166:	c1 e0 02             	shl    $0x2,%eax
c0103169:	01 d0                	add    %edx,%eax
c010316b:	c1 e0 02             	shl    $0x2,%eax
c010316e:	01 c8                	add    %ecx,%eax
c0103170:	83 c0 04             	add    $0x4,%eax
c0103173:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c010317a:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010317d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103180:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103183:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0103186:	ff 45 dc             	incl   -0x24(%ebp)
c0103189:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010318c:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103191:	39 c2                	cmp    %eax,%edx
c0103193:	72 c6                	jb     c010315b <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103195:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c010319b:	89 d0                	mov    %edx,%eax
c010319d:	c1 e0 02             	shl    $0x2,%eax
c01031a0:	01 d0                	add    %edx,%eax
c01031a2:	c1 e0 02             	shl    $0x2,%eax
c01031a5:	89 c2                	mov    %eax,%edx
c01031a7:	a1 78 af 11 c0       	mov    0xc011af78,%eax
c01031ac:	01 d0                	add    %edx,%eax
c01031ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01031b1:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c01031b8:	77 23                	ja     c01031dd <page_init+0x25b>
c01031ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01031bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01031c1:	c7 44 24 08 24 63 10 	movl   $0xc0106324,0x8(%esp)
c01031c8:	c0 
c01031c9:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01031d0:	00 
c01031d1:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01031d8:	e8 1c d2 ff ff       	call   c01003f9 <__panic>
c01031dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01031e0:	05 00 00 00 40       	add    $0x40000000,%eax
c01031e5:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01031e8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01031ef:	e9 69 01 00 00       	jmp    c010335d <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01031f4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031fa:	89 d0                	mov    %edx,%eax
c01031fc:	c1 e0 02             	shl    $0x2,%eax
c01031ff:	01 d0                	add    %edx,%eax
c0103201:	c1 e0 02             	shl    $0x2,%eax
c0103204:	01 c8                	add    %ecx,%eax
c0103206:	8b 50 08             	mov    0x8(%eax),%edx
c0103209:	8b 40 04             	mov    0x4(%eax),%eax
c010320c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010320f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103212:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103215:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103218:	89 d0                	mov    %edx,%eax
c010321a:	c1 e0 02             	shl    $0x2,%eax
c010321d:	01 d0                	add    %edx,%eax
c010321f:	c1 e0 02             	shl    $0x2,%eax
c0103222:	01 c8                	add    %ecx,%eax
c0103224:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103227:	8b 58 10             	mov    0x10(%eax),%ebx
c010322a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010322d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103230:	01 c8                	add    %ecx,%eax
c0103232:	11 da                	adc    %ebx,%edx
c0103234:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103237:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010323a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010323d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103240:	89 d0                	mov    %edx,%eax
c0103242:	c1 e0 02             	shl    $0x2,%eax
c0103245:	01 d0                	add    %edx,%eax
c0103247:	c1 e0 02             	shl    $0x2,%eax
c010324a:	01 c8                	add    %ecx,%eax
c010324c:	83 c0 14             	add    $0x14,%eax
c010324f:	8b 00                	mov    (%eax),%eax
c0103251:	83 f8 01             	cmp    $0x1,%eax
c0103254:	0f 85 00 01 00 00    	jne    c010335a <page_init+0x3d8>
            if (begin < freemem) {
c010325a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010325d:	ba 00 00 00 00       	mov    $0x0,%edx
c0103262:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0103265:	77 17                	ja     c010327e <page_init+0x2fc>
c0103267:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010326a:	72 05                	jb     c0103271 <page_init+0x2ef>
c010326c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010326f:	73 0d                	jae    c010327e <page_init+0x2fc>
                begin = freemem;
c0103271:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103274:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103277:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010327e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103282:	72 1d                	jb     c01032a1 <page_init+0x31f>
c0103284:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103288:	77 09                	ja     c0103293 <page_init+0x311>
c010328a:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103291:	76 0e                	jbe    c01032a1 <page_init+0x31f>
                end = KMEMSIZE;
c0103293:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010329a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01032a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032a7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01032aa:	0f 87 aa 00 00 00    	ja     c010335a <page_init+0x3d8>
c01032b0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01032b3:	72 09                	jb     c01032be <page_init+0x33c>
c01032b5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01032b8:	0f 83 9c 00 00 00    	jae    c010335a <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
c01032be:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c01032c5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01032c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01032cb:	01 d0                	add    %edx,%eax
c01032cd:	48                   	dec    %eax
c01032ce:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01032d1:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01032d4:	ba 00 00 00 00       	mov    $0x0,%edx
c01032d9:	f7 75 b0             	divl   -0x50(%ebp)
c01032dc:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01032df:	29 d0                	sub    %edx,%eax
c01032e1:	ba 00 00 00 00       	mov    $0x0,%edx
c01032e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01032e9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01032ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01032ef:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01032f2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01032f5:	ba 00 00 00 00       	mov    $0x0,%edx
c01032fa:	89 c3                	mov    %eax,%ebx
c01032fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103302:	89 de                	mov    %ebx,%esi
c0103304:	89 d0                	mov    %edx,%eax
c0103306:	83 e0 00             	and    $0x0,%eax
c0103309:	89 c7                	mov    %eax,%edi
c010330b:	89 75 c8             	mov    %esi,-0x38(%ebp)
c010330e:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103311:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103314:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103317:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010331a:	77 3e                	ja     c010335a <page_init+0x3d8>
c010331c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010331f:	72 05                	jb     c0103326 <page_init+0x3a4>
c0103321:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103324:	73 34                	jae    c010335a <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103326:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103329:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010332c:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010332f:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103332:	89 c1                	mov    %eax,%ecx
c0103334:	89 d3                	mov    %edx,%ebx
c0103336:	89 c8                	mov    %ecx,%eax
c0103338:	89 da                	mov    %ebx,%edx
c010333a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010333e:	c1 ea 0c             	shr    $0xc,%edx
c0103341:	89 c3                	mov    %eax,%ebx
c0103343:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103346:	89 04 24             	mov    %eax,(%esp)
c0103349:	e8 a0 f8 ff ff       	call   c0102bee <pa2page>
c010334e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103352:	89 04 24             	mov    %eax,(%esp)
c0103355:	e8 72 fb ff ff       	call   c0102ecc <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010335a:	ff 45 dc             	incl   -0x24(%ebp)
c010335d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103360:	8b 00                	mov    (%eax),%eax
c0103362:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103365:	0f 8c 89 fe ff ff    	jl     c01031f4 <page_init+0x272>
                }
            }
        }
    }
}
c010336b:	90                   	nop
c010336c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103372:	5b                   	pop    %ebx
c0103373:	5e                   	pop    %esi
c0103374:	5f                   	pop    %edi
c0103375:	5d                   	pop    %ebp
c0103376:	c3                   	ret    

c0103377 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103377:	55                   	push   %ebp
c0103378:	89 e5                	mov    %esp,%ebp
c010337a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010337d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103380:	33 45 14             	xor    0x14(%ebp),%eax
c0103383:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103388:	85 c0                	test   %eax,%eax
c010338a:	74 24                	je     c01033b0 <boot_map_segment+0x39>
c010338c:	c7 44 24 0c 56 63 10 	movl   $0xc0106356,0xc(%esp)
c0103393:	c0 
c0103394:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c010339b:	c0 
c010339c:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01033a3:	00 
c01033a4:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01033ab:	e8 49 d0 ff ff       	call   c01003f9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01033b0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01033b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033ba:	25 ff 0f 00 00       	and    $0xfff,%eax
c01033bf:	89 c2                	mov    %eax,%edx
c01033c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01033c4:	01 c2                	add    %eax,%edx
c01033c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033c9:	01 d0                	add    %edx,%eax
c01033cb:	48                   	dec    %eax
c01033cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033d2:	ba 00 00 00 00       	mov    $0x0,%edx
c01033d7:	f7 75 f0             	divl   -0x10(%ebp)
c01033da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033dd:	29 d0                	sub    %edx,%eax
c01033df:	c1 e8 0c             	shr    $0xc,%eax
c01033e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01033e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01033f3:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01033f6:	8b 45 14             	mov    0x14(%ebp),%eax
c01033f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01033fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103404:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103407:	eb 68                	jmp    c0103471 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103409:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103410:	00 
c0103411:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103414:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103418:	8b 45 08             	mov    0x8(%ebp),%eax
c010341b:	89 04 24             	mov    %eax,(%esp)
c010341e:	e8 81 01 00 00       	call   c01035a4 <get_pte>
c0103423:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103426:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010342a:	75 24                	jne    c0103450 <boot_map_segment+0xd9>
c010342c:	c7 44 24 0c 82 63 10 	movl   $0xc0106382,0xc(%esp)
c0103433:	c0 
c0103434:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c010343b:	c0 
c010343c:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103443:	00 
c0103444:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c010344b:	e8 a9 cf ff ff       	call   c01003f9 <__panic>
        *ptep = pa | PTE_P | perm;
c0103450:	8b 45 14             	mov    0x14(%ebp),%eax
c0103453:	0b 45 18             	or     0x18(%ebp),%eax
c0103456:	83 c8 01             	or     $0x1,%eax
c0103459:	89 c2                	mov    %eax,%edx
c010345b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010345e:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103460:	ff 4d f4             	decl   -0xc(%ebp)
c0103463:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010346a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103475:	75 92                	jne    c0103409 <boot_map_segment+0x92>
    }
}
c0103477:	90                   	nop
c0103478:	c9                   	leave  
c0103479:	c3                   	ret    

c010347a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010347a:	55                   	push   %ebp
c010347b:	89 e5                	mov    %esp,%ebp
c010347d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0103480:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103487:	e8 60 fa ff ff       	call   c0102eec <alloc_pages>
c010348c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010348f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103493:	75 1c                	jne    c01034b1 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0103495:	c7 44 24 08 8f 63 10 	movl   $0xc010638f,0x8(%esp)
c010349c:	c0 
c010349d:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01034a4:	00 
c01034a5:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01034ac:	e8 48 cf ff ff       	call   c01003f9 <__panic>
    }
    return page2kva(p);
c01034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b4:	89 04 24             	mov    %eax,(%esp)
c01034b7:	e8 81 f7 ff ff       	call   c0102c3d <page2kva>
}
c01034bc:	c9                   	leave  
c01034bd:	c3                   	ret    

c01034be <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01034be:	55                   	push   %ebp
c01034bf:	89 e5                	mov    %esp,%ebp
c01034c1:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01034c4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01034c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034cc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01034d3:	77 23                	ja     c01034f8 <pmm_init+0x3a>
c01034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034dc:	c7 44 24 08 24 63 10 	movl   $0xc0106324,0x8(%esp)
c01034e3:	c0 
c01034e4:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c01034eb:	00 
c01034ec:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01034f3:	e8 01 cf ff ff       	call   c01003f9 <__panic>
c01034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034fb:	05 00 00 00 40       	add    $0x40000000,%eax
c0103500:	a3 74 af 11 c0       	mov    %eax,0xc011af74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103505:	e8 8e f9 ff ff       	call   c0102e98 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010350a:	e8 73 fa ff ff       	call   c0102f82 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010350f:	e8 de 03 00 00       	call   c01038f2 <check_alloc_page>

    check_pgdir();
c0103514:	e8 f8 03 00 00       	call   c0103911 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103519:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010351e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103521:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103528:	77 23                	ja     c010354d <pmm_init+0x8f>
c010352a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010352d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103531:	c7 44 24 08 24 63 10 	movl   $0xc0106324,0x8(%esp)
c0103538:	c0 
c0103539:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0103540:	00 
c0103541:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103548:	e8 ac ce ff ff       	call   c01003f9 <__panic>
c010354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103550:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103556:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010355b:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103560:	83 ca 03             	or     $0x3,%edx
c0103563:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103565:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010356a:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0103571:	00 
c0103572:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103579:	00 
c010357a:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0103581:	38 
c0103582:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0103589:	c0 
c010358a:	89 04 24             	mov    %eax,(%esp)
c010358d:	e8 e5 fd ff ff       	call   c0103377 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103592:	e8 18 f8 ff ff       	call   c0102daf <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103597:	e8 11 0a 00 00       	call   c0103fad <check_boot_pgdir>

    print_pgdir();
c010359c:	e8 8a 0e 00 00       	call   c010442b <print_pgdir>

}
c01035a1:	90                   	nop
c01035a2:	c9                   	leave  
c01035a3:	c3                   	ret    

c01035a4 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01035a4:	55                   	push   %ebp
c01035a5:	89 e5                	mov    %esp,%ebp
c01035a7:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];//获取二级页表的地址
c01035aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035ad:	c1 e8 16             	shr    $0x16,%eax
c01035b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01035b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ba:	01 d0                	add    %edx,%eax
c01035bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {//如果该二级页表还没有分配物理空间
c01035bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c2:	8b 00                	mov    (%eax),%eax
c01035c4:	83 e0 01             	and    $0x1,%eax
c01035c7:	85 c0                	test   %eax,%eax
c01035c9:	0f 85 af 00 00 00    	jne    c010367e <get_pte+0xda>
        struct Page *page;//分配一个
        if (!create || (page = alloc_page()) == NULL) {
c01035cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01035d3:	74 15                	je     c01035ea <get_pte+0x46>
c01035d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035dc:	e8 0b f9 ff ff       	call   c0102eec <alloc_pages>
c01035e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01035e8:	75 0a                	jne    c01035f4 <get_pte+0x50>
            return NULL;
c01035ea:	b8 00 00 00 00       	mov    $0x0,%eax
c01035ef:	e9 e7 00 00 00       	jmp    c01036db <get_pte+0x137>
        }
        //下面都是给新页初始化属性
        set_page_ref(page, 1);
c01035f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035fb:	00 
c01035fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035ff:	89 04 24             	mov    %eax,(%esp)
c0103602:	e8 ea f6 ff ff       	call   c0102cf1 <set_page_ref>
        uintptr_t pa = page2pa(page);
c0103607:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010360a:	89 04 24             	mov    %eax,(%esp)
c010360d:	e8 c6 f5 ff ff       	call   c0102bd8 <page2pa>
c0103612:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0103615:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103618:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010361e:	c1 e8 0c             	shr    $0xc,%eax
c0103621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103624:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103629:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010362c:	72 23                	jb     c0103651 <get_pte+0xad>
c010362e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103631:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103635:	c7 44 24 08 80 62 10 	movl   $0xc0106280,0x8(%esp)
c010363c:	c0 
c010363d:	c7 44 24 04 71 01 00 	movl   $0x171,0x4(%esp)
c0103644:	00 
c0103645:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c010364c:	e8 a8 cd ff ff       	call   c01003f9 <__panic>
c0103651:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103654:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103659:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103660:	00 
c0103661:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103668:	00 
c0103669:	89 04 24             	mov    %eax,(%esp)
c010366c:	e8 cd 1c 00 00       	call   c010533e <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0103671:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103674:	83 c8 07             	or     $0x7,%eax
c0103677:	89 c2                	mov    %eax,%edx
c0103679:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010367c:	89 10                	mov    %edx,(%eax)
        //得到一个被引用数为1，内容为空，权限极低的二级页表页
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];//通过查二级页表返回对应页表项的地址
c010367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103681:	8b 00                	mov    (%eax),%eax
c0103683:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103688:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010368b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010368e:	c1 e8 0c             	shr    $0xc,%eax
c0103691:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103694:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103699:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010369c:	72 23                	jb     c01036c1 <get_pte+0x11d>
c010369e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01036a5:	c7 44 24 08 80 62 10 	movl   $0xc0106280,0x8(%esp)
c01036ac:	c0 
c01036ad:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c01036b4:	00 
c01036b5:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01036bc:	e8 38 cd ff ff       	call   c01003f9 <__panic>
c01036c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036c4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01036c9:	89 c2                	mov    %eax,%edx
c01036cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036ce:	c1 e8 0c             	shr    $0xc,%eax
c01036d1:	25 ff 03 00 00       	and    $0x3ff,%eax
c01036d6:	c1 e0 02             	shl    $0x2,%eax
c01036d9:	01 d0                	add    %edx,%eax
}
c01036db:	c9                   	leave  
c01036dc:	c3                   	ret    

c01036dd <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01036dd:	55                   	push   %ebp
c01036de:	89 e5                	mov    %esp,%ebp
c01036e0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01036e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01036ea:	00 
c01036eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f5:	89 04 24             	mov    %eax,(%esp)
c01036f8:	e8 a7 fe ff ff       	call   c01035a4 <get_pte>
c01036fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103700:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103704:	74 08                	je     c010370e <get_page+0x31>
        *ptep_store = ptep;
c0103706:	8b 45 10             	mov    0x10(%ebp),%eax
c0103709:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010370c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010370e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103712:	74 1b                	je     c010372f <get_page+0x52>
c0103714:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103717:	8b 00                	mov    (%eax),%eax
c0103719:	83 e0 01             	and    $0x1,%eax
c010371c:	85 c0                	test   %eax,%eax
c010371e:	74 0f                	je     c010372f <get_page+0x52>
        return pte2page(*ptep);
c0103720:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103723:	8b 00                	mov    (%eax),%eax
c0103725:	89 04 24             	mov    %eax,(%esp)
c0103728:	e8 64 f5 ff ff       	call   c0102c91 <pte2page>
c010372d:	eb 05                	jmp    c0103734 <get_page+0x57>
    }
    return NULL;
c010372f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103734:	c9                   	leave  
c0103735:	c3                   	ret    

c0103736 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103736:	55                   	push   %ebp
c0103737:	89 e5                	mov    %esp,%ebp
c0103739:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
        if (*ptep & PTE_P) {//如果逻辑地址所映射到的page，已经分配了内存
c010373c:	8b 45 10             	mov    0x10(%ebp),%eax
c010373f:	8b 00                	mov    (%eax),%eax
c0103741:	83 e0 01             	and    $0x1,%eax
c0103744:	85 c0                	test   %eax,%eax
c0103746:	74 4d                	je     c0103795 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);//通过宏，得到二级页表项所指向的page
c0103748:	8b 45 10             	mov    0x10(%ebp),%eax
c010374b:	8b 00                	mov    (%eax),%eax
c010374d:	89 04 24             	mov    %eax,(%esp)
c0103750:	e8 3c f5 ff ff       	call   c0102c91 <pte2page>
c0103755:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {//由于这个逻辑地址不再指向page了，所以page少了一次引用次数
c0103758:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010375b:	89 04 24             	mov    %eax,(%esp)
c010375e:	e8 b3 f5 ff ff       	call   c0102d16 <page_ref_dec>
c0103763:	85 c0                	test   %eax,%eax
c0103765:	75 13                	jne    c010377a <page_remove_pte+0x44>
            free_page(page);//如果page的被引用次数为0，就释放掉该页
c0103767:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010376e:	00 
c010376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103772:	89 04 24             	mov    %eax,(%esp)
c0103775:	e8 aa f7 ff ff       	call   c0102f24 <free_pages>
        }
        *ptep = 0;//讲该二级页表项清空
c010377a:	8b 45 10             	mov    0x10(%ebp),%eax
c010377d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);//TLB更新
c0103783:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103786:	89 44 24 04          	mov    %eax,0x4(%esp)
c010378a:	8b 45 08             	mov    0x8(%ebp),%eax
c010378d:	89 04 24             	mov    %eax,(%esp)
c0103790:	e8 01 01 00 00       	call   c0103896 <tlb_invalidate>
    }
}
c0103795:	90                   	nop
c0103796:	c9                   	leave  
c0103797:	c3                   	ret    

c0103798 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103798:	55                   	push   %ebp
c0103799:	89 e5                	mov    %esp,%ebp
c010379b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010379e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037a5:	00 
c01037a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01037b0:	89 04 24             	mov    %eax,(%esp)
c01037b3:	e8 ec fd ff ff       	call   c01035a4 <get_pte>
c01037b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01037bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037bf:	74 19                	je     c01037da <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01037c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01037c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01037d2:	89 04 24             	mov    %eax,(%esp)
c01037d5:	e8 5c ff ff ff       	call   c0103736 <page_remove_pte>
    }
}
c01037da:	90                   	nop
c01037db:	c9                   	leave  
c01037dc:	c3                   	ret    

c01037dd <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01037dd:	55                   	push   %ebp
c01037de:	89 e5                	mov    %esp,%ebp
c01037e0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01037e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01037ea:	00 
c01037eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01037ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01037f5:	89 04 24             	mov    %eax,(%esp)
c01037f8:	e8 a7 fd ff ff       	call   c01035a4 <get_pte>
c01037fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103804:	75 0a                	jne    c0103810 <page_insert+0x33>
        return -E_NO_MEM;
c0103806:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010380b:	e9 84 00 00 00       	jmp    c0103894 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0103810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103813:	89 04 24             	mov    %eax,(%esp)
c0103816:	e8 e4 f4 ff ff       	call   c0102cff <page_ref_inc>
    if (*ptep & PTE_P) {
c010381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010381e:	8b 00                	mov    (%eax),%eax
c0103820:	83 e0 01             	and    $0x1,%eax
c0103823:	85 c0                	test   %eax,%eax
c0103825:	74 3e                	je     c0103865 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0103827:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010382a:	8b 00                	mov    (%eax),%eax
c010382c:	89 04 24             	mov    %eax,(%esp)
c010382f:	e8 5d f4 ff ff       	call   c0102c91 <pte2page>
c0103834:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103837:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010383a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010383d:	75 0d                	jne    c010384c <page_insert+0x6f>
            page_ref_dec(page);
c010383f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103842:	89 04 24             	mov    %eax,(%esp)
c0103845:	e8 cc f4 ff ff       	call   c0102d16 <page_ref_dec>
c010384a:	eb 19                	jmp    c0103865 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010384f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103853:	8b 45 10             	mov    0x10(%ebp),%eax
c0103856:	89 44 24 04          	mov    %eax,0x4(%esp)
c010385a:	8b 45 08             	mov    0x8(%ebp),%eax
c010385d:	89 04 24             	mov    %eax,(%esp)
c0103860:	e8 d1 fe ff ff       	call   c0103736 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103865:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103868:	89 04 24             	mov    %eax,(%esp)
c010386b:	e8 68 f3 ff ff       	call   c0102bd8 <page2pa>
c0103870:	0b 45 14             	or     0x14(%ebp),%eax
c0103873:	83 c8 01             	or     $0x1,%eax
c0103876:	89 c2                	mov    %eax,%edx
c0103878:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010387b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010387d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103880:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103884:	8b 45 08             	mov    0x8(%ebp),%eax
c0103887:	89 04 24             	mov    %eax,(%esp)
c010388a:	e8 07 00 00 00       	call   c0103896 <tlb_invalidate>
    return 0;
c010388f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103894:	c9                   	leave  
c0103895:	c3                   	ret    

c0103896 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103896:	55                   	push   %ebp
c0103897:	89 e5                	mov    %esp,%ebp
c0103899:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010389c:	0f 20 d8             	mov    %cr3,%eax
c010389f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01038a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01038a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01038a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01038ab:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01038b2:	77 23                	ja     c01038d7 <tlb_invalidate+0x41>
c01038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01038bb:	c7 44 24 08 24 63 10 	movl   $0xc0106324,0x8(%esp)
c01038c2:	c0 
c01038c3:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
c01038ca:	00 
c01038cb:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01038d2:	e8 22 cb ff ff       	call   c01003f9 <__panic>
c01038d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038da:	05 00 00 00 40       	add    $0x40000000,%eax
c01038df:	39 d0                	cmp    %edx,%eax
c01038e1:	75 0c                	jne    c01038ef <tlb_invalidate+0x59>
        invlpg((void *)la);
c01038e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01038e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038ec:	0f 01 38             	invlpg (%eax)
    }
}
c01038ef:	90                   	nop
c01038f0:	c9                   	leave  
c01038f1:	c3                   	ret    

c01038f2 <check_alloc_page>:

static void
check_alloc_page(void) {
c01038f2:	55                   	push   %ebp
c01038f3:	89 e5                	mov    %esp,%ebp
c01038f5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01038f8:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c01038fd:	8b 40 18             	mov    0x18(%eax),%eax
c0103900:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103902:	c7 04 24 a8 63 10 c0 	movl   $0xc01063a8,(%esp)
c0103909:	e8 94 c9 ff ff       	call   c01002a2 <cprintf>
}
c010390e:	90                   	nop
c010390f:	c9                   	leave  
c0103910:	c3                   	ret    

c0103911 <check_pgdir>:

static void
check_pgdir(void) {
c0103911:	55                   	push   %ebp
c0103912:	89 e5                	mov    %esp,%ebp
c0103914:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103917:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010391c:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103921:	76 24                	jbe    c0103947 <check_pgdir+0x36>
c0103923:	c7 44 24 0c c7 63 10 	movl   $0xc01063c7,0xc(%esp)
c010392a:	c0 
c010392b:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103932:	c0 
c0103933:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c010393a:	00 
c010393b:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103942:	e8 b2 ca ff ff       	call   c01003f9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103947:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010394c:	85 c0                	test   %eax,%eax
c010394e:	74 0e                	je     c010395e <check_pgdir+0x4d>
c0103950:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103955:	25 ff 0f 00 00       	and    $0xfff,%eax
c010395a:	85 c0                	test   %eax,%eax
c010395c:	74 24                	je     c0103982 <check_pgdir+0x71>
c010395e:	c7 44 24 0c e4 63 10 	movl   $0xc01063e4,0xc(%esp)
c0103965:	c0 
c0103966:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c010396d:	c0 
c010396e:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0103975:	00 
c0103976:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c010397d:	e8 77 ca ff ff       	call   c01003f9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103982:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103987:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010398e:	00 
c010398f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103996:	00 
c0103997:	89 04 24             	mov    %eax,(%esp)
c010399a:	e8 3e fd ff ff       	call   c01036dd <get_page>
c010399f:	85 c0                	test   %eax,%eax
c01039a1:	74 24                	je     c01039c7 <check_pgdir+0xb6>
c01039a3:	c7 44 24 0c 1c 64 10 	movl   $0xc010641c,0xc(%esp)
c01039aa:	c0 
c01039ab:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c01039b2:	c0 
c01039b3:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c01039ba:	00 
c01039bb:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01039c2:	e8 32 ca ff ff       	call   c01003f9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01039c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039ce:	e8 19 f5 ff ff       	call   c0102eec <alloc_pages>
c01039d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01039d6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01039db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01039e2:	00 
c01039e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039ea:	00 
c01039eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01039ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01039f2:	89 04 24             	mov    %eax,(%esp)
c01039f5:	e8 e3 fd ff ff       	call   c01037dd <page_insert>
c01039fa:	85 c0                	test   %eax,%eax
c01039fc:	74 24                	je     c0103a22 <check_pgdir+0x111>
c01039fe:	c7 44 24 0c 44 64 10 	movl   $0xc0106444,0xc(%esp)
c0103a05:	c0 
c0103a06:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103a0d:	c0 
c0103a0e:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0103a15:	00 
c0103a16:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103a1d:	e8 d7 c9 ff ff       	call   c01003f9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103a22:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103a27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a2e:	00 
c0103a2f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103a36:	00 
c0103a37:	89 04 24             	mov    %eax,(%esp)
c0103a3a:	e8 65 fb ff ff       	call   c01035a4 <get_pte>
c0103a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a46:	75 24                	jne    c0103a6c <check_pgdir+0x15b>
c0103a48:	c7 44 24 0c 70 64 10 	movl   $0xc0106470,0xc(%esp)
c0103a4f:	c0 
c0103a50:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103a57:	c0 
c0103a58:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0103a5f:	00 
c0103a60:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103a67:	e8 8d c9 ff ff       	call   c01003f9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a6f:	8b 00                	mov    (%eax),%eax
c0103a71:	89 04 24             	mov    %eax,(%esp)
c0103a74:	e8 18 f2 ff ff       	call   c0102c91 <pte2page>
c0103a79:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a7c:	74 24                	je     c0103aa2 <check_pgdir+0x191>
c0103a7e:	c7 44 24 0c 9d 64 10 	movl   $0xc010649d,0xc(%esp)
c0103a85:	c0 
c0103a86:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103a8d:	c0 
c0103a8e:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0103a95:	00 
c0103a96:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103a9d:	e8 57 c9 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p1) == 1);
c0103aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa5:	89 04 24             	mov    %eax,(%esp)
c0103aa8:	e8 3a f2 ff ff       	call   c0102ce7 <page_ref>
c0103aad:	83 f8 01             	cmp    $0x1,%eax
c0103ab0:	74 24                	je     c0103ad6 <check_pgdir+0x1c5>
c0103ab2:	c7 44 24 0c b3 64 10 	movl   $0xc01064b3,0xc(%esp)
c0103ab9:	c0 
c0103aba:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103ac1:	c0 
c0103ac2:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0103ac9:	00 
c0103aca:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103ad1:	e8 23 c9 ff ff       	call   c01003f9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103ad6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103adb:	8b 00                	mov    (%eax),%eax
c0103add:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ae2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ae8:	c1 e8 0c             	shr    $0xc,%eax
c0103aeb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103aee:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103af3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103af6:	72 23                	jb     c0103b1b <check_pgdir+0x20a>
c0103af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103afb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103aff:	c7 44 24 08 80 62 10 	movl   $0xc0106280,0x8(%esp)
c0103b06:	c0 
c0103b07:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0103b0e:	00 
c0103b0f:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103b16:	e8 de c8 ff ff       	call   c01003f9 <__panic>
c0103b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b1e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103b23:	83 c0 04             	add    $0x4,%eax
c0103b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103b29:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103b2e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103b35:	00 
c0103b36:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b3d:	00 
c0103b3e:	89 04 24             	mov    %eax,(%esp)
c0103b41:	e8 5e fa ff ff       	call   c01035a4 <get_pte>
c0103b46:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103b49:	74 24                	je     c0103b6f <check_pgdir+0x25e>
c0103b4b:	c7 44 24 0c c8 64 10 	movl   $0xc01064c8,0xc(%esp)
c0103b52:	c0 
c0103b53:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103b5a:	c0 
c0103b5b:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0103b62:	00 
c0103b63:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103b6a:	e8 8a c8 ff ff       	call   c01003f9 <__panic>

    p2 = alloc_page();
c0103b6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b76:	e8 71 f3 ff ff       	call   c0102eec <alloc_pages>
c0103b7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103b7e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103b83:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103b8a:	00 
c0103b8b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103b92:	00 
c0103b93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103b96:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b9a:	89 04 24             	mov    %eax,(%esp)
c0103b9d:	e8 3b fc ff ff       	call   c01037dd <page_insert>
c0103ba2:	85 c0                	test   %eax,%eax
c0103ba4:	74 24                	je     c0103bca <check_pgdir+0x2b9>
c0103ba6:	c7 44 24 0c f0 64 10 	movl   $0xc01064f0,0xc(%esp)
c0103bad:	c0 
c0103bae:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103bb5:	c0 
c0103bb6:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0103bbd:	00 
c0103bbe:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103bc5:	e8 2f c8 ff ff       	call   c01003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103bca:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103bcf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103bd6:	00 
c0103bd7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103bde:	00 
c0103bdf:	89 04 24             	mov    %eax,(%esp)
c0103be2:	e8 bd f9 ff ff       	call   c01035a4 <get_pte>
c0103be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bee:	75 24                	jne    c0103c14 <check_pgdir+0x303>
c0103bf0:	c7 44 24 0c 28 65 10 	movl   $0xc0106528,0xc(%esp)
c0103bf7:	c0 
c0103bf8:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103bff:	c0 
c0103c00:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0103c07:	00 
c0103c08:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103c0f:	e8 e5 c7 ff ff       	call   c01003f9 <__panic>
    assert(*ptep & PTE_U);
c0103c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c17:	8b 00                	mov    (%eax),%eax
c0103c19:	83 e0 04             	and    $0x4,%eax
c0103c1c:	85 c0                	test   %eax,%eax
c0103c1e:	75 24                	jne    c0103c44 <check_pgdir+0x333>
c0103c20:	c7 44 24 0c 58 65 10 	movl   $0xc0106558,0xc(%esp)
c0103c27:	c0 
c0103c28:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103c2f:	c0 
c0103c30:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103c37:	00 
c0103c38:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103c3f:	e8 b5 c7 ff ff       	call   c01003f9 <__panic>
    assert(*ptep & PTE_W);
c0103c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c47:	8b 00                	mov    (%eax),%eax
c0103c49:	83 e0 02             	and    $0x2,%eax
c0103c4c:	85 c0                	test   %eax,%eax
c0103c4e:	75 24                	jne    c0103c74 <check_pgdir+0x363>
c0103c50:	c7 44 24 0c 66 65 10 	movl   $0xc0106566,0xc(%esp)
c0103c57:	c0 
c0103c58:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103c5f:	c0 
c0103c60:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0103c67:	00 
c0103c68:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103c6f:	e8 85 c7 ff ff       	call   c01003f9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103c74:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c79:	8b 00                	mov    (%eax),%eax
c0103c7b:	83 e0 04             	and    $0x4,%eax
c0103c7e:	85 c0                	test   %eax,%eax
c0103c80:	75 24                	jne    c0103ca6 <check_pgdir+0x395>
c0103c82:	c7 44 24 0c 74 65 10 	movl   $0xc0106574,0xc(%esp)
c0103c89:	c0 
c0103c8a:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103c91:	c0 
c0103c92:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0103c99:	00 
c0103c9a:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103ca1:	e8 53 c7 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 1);
c0103ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ca9:	89 04 24             	mov    %eax,(%esp)
c0103cac:	e8 36 f0 ff ff       	call   c0102ce7 <page_ref>
c0103cb1:	83 f8 01             	cmp    $0x1,%eax
c0103cb4:	74 24                	je     c0103cda <check_pgdir+0x3c9>
c0103cb6:	c7 44 24 0c 8a 65 10 	movl   $0xc010658a,0xc(%esp)
c0103cbd:	c0 
c0103cbe:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103cc5:	c0 
c0103cc6:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0103ccd:	00 
c0103cce:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103cd5:	e8 1f c7 ff ff       	call   c01003f9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103cda:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103cdf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103ce6:	00 
c0103ce7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103cee:	00 
c0103cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103cf2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cf6:	89 04 24             	mov    %eax,(%esp)
c0103cf9:	e8 df fa ff ff       	call   c01037dd <page_insert>
c0103cfe:	85 c0                	test   %eax,%eax
c0103d00:	74 24                	je     c0103d26 <check_pgdir+0x415>
c0103d02:	c7 44 24 0c 9c 65 10 	movl   $0xc010659c,0xc(%esp)
c0103d09:	c0 
c0103d0a:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103d11:	c0 
c0103d12:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0103d19:	00 
c0103d1a:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103d21:	e8 d3 c6 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p1) == 2);
c0103d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d29:	89 04 24             	mov    %eax,(%esp)
c0103d2c:	e8 b6 ef ff ff       	call   c0102ce7 <page_ref>
c0103d31:	83 f8 02             	cmp    $0x2,%eax
c0103d34:	74 24                	je     c0103d5a <check_pgdir+0x449>
c0103d36:	c7 44 24 0c c8 65 10 	movl   $0xc01065c8,0xc(%esp)
c0103d3d:	c0 
c0103d3e:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103d45:	c0 
c0103d46:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103d4d:	00 
c0103d4e:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103d55:	e8 9f c6 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d5d:	89 04 24             	mov    %eax,(%esp)
c0103d60:	e8 82 ef ff ff       	call   c0102ce7 <page_ref>
c0103d65:	85 c0                	test   %eax,%eax
c0103d67:	74 24                	je     c0103d8d <check_pgdir+0x47c>
c0103d69:	c7 44 24 0c da 65 10 	movl   $0xc01065da,0xc(%esp)
c0103d70:	c0 
c0103d71:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103d78:	c0 
c0103d79:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103d80:	00 
c0103d81:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103d88:	e8 6c c6 ff ff       	call   c01003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103d8d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d92:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103d99:	00 
c0103d9a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103da1:	00 
c0103da2:	89 04 24             	mov    %eax,(%esp)
c0103da5:	e8 fa f7 ff ff       	call   c01035a4 <get_pte>
c0103daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103db1:	75 24                	jne    c0103dd7 <check_pgdir+0x4c6>
c0103db3:	c7 44 24 0c 28 65 10 	movl   $0xc0106528,0xc(%esp)
c0103dba:	c0 
c0103dbb:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103dc2:	c0 
c0103dc3:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0103dca:	00 
c0103dcb:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103dd2:	e8 22 c6 ff ff       	call   c01003f9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dda:	8b 00                	mov    (%eax),%eax
c0103ddc:	89 04 24             	mov    %eax,(%esp)
c0103ddf:	e8 ad ee ff ff       	call   c0102c91 <pte2page>
c0103de4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103de7:	74 24                	je     c0103e0d <check_pgdir+0x4fc>
c0103de9:	c7 44 24 0c 9d 64 10 	movl   $0xc010649d,0xc(%esp)
c0103df0:	c0 
c0103df1:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103df8:	c0 
c0103df9:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0103e00:	00 
c0103e01:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103e08:	e8 ec c5 ff ff       	call   c01003f9 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e10:	8b 00                	mov    (%eax),%eax
c0103e12:	83 e0 04             	and    $0x4,%eax
c0103e15:	85 c0                	test   %eax,%eax
c0103e17:	74 24                	je     c0103e3d <check_pgdir+0x52c>
c0103e19:	c7 44 24 0c ec 65 10 	movl   $0xc01065ec,0xc(%esp)
c0103e20:	c0 
c0103e21:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103e28:	c0 
c0103e29:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0103e30:	00 
c0103e31:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103e38:	e8 bc c5 ff ff       	call   c01003f9 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103e3d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103e42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103e49:	00 
c0103e4a:	89 04 24             	mov    %eax,(%esp)
c0103e4d:	e8 46 f9 ff ff       	call   c0103798 <page_remove>
    assert(page_ref(p1) == 1);
c0103e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e55:	89 04 24             	mov    %eax,(%esp)
c0103e58:	e8 8a ee ff ff       	call   c0102ce7 <page_ref>
c0103e5d:	83 f8 01             	cmp    $0x1,%eax
c0103e60:	74 24                	je     c0103e86 <check_pgdir+0x575>
c0103e62:	c7 44 24 0c b3 64 10 	movl   $0xc01064b3,0xc(%esp)
c0103e69:	c0 
c0103e6a:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103e71:	c0 
c0103e72:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103e79:	00 
c0103e7a:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103e81:	e8 73 c5 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e89:	89 04 24             	mov    %eax,(%esp)
c0103e8c:	e8 56 ee ff ff       	call   c0102ce7 <page_ref>
c0103e91:	85 c0                	test   %eax,%eax
c0103e93:	74 24                	je     c0103eb9 <check_pgdir+0x5a8>
c0103e95:	c7 44 24 0c da 65 10 	movl   $0xc01065da,0xc(%esp)
c0103e9c:	c0 
c0103e9d:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103ea4:	c0 
c0103ea5:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0103eac:	00 
c0103ead:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103eb4:	e8 40 c5 ff ff       	call   c01003f9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103eb9:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103ebe:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103ec5:	00 
c0103ec6:	89 04 24             	mov    %eax,(%esp)
c0103ec9:	e8 ca f8 ff ff       	call   c0103798 <page_remove>
    assert(page_ref(p1) == 0);
c0103ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ed1:	89 04 24             	mov    %eax,(%esp)
c0103ed4:	e8 0e ee ff ff       	call   c0102ce7 <page_ref>
c0103ed9:	85 c0                	test   %eax,%eax
c0103edb:	74 24                	je     c0103f01 <check_pgdir+0x5f0>
c0103edd:	c7 44 24 0c 01 66 10 	movl   $0xc0106601,0xc(%esp)
c0103ee4:	c0 
c0103ee5:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103eec:	c0 
c0103eed:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0103ef4:	00 
c0103ef5:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103efc:	e8 f8 c4 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f04:	89 04 24             	mov    %eax,(%esp)
c0103f07:	e8 db ed ff ff       	call   c0102ce7 <page_ref>
c0103f0c:	85 c0                	test   %eax,%eax
c0103f0e:	74 24                	je     c0103f34 <check_pgdir+0x623>
c0103f10:	c7 44 24 0c da 65 10 	movl   $0xc01065da,0xc(%esp)
c0103f17:	c0 
c0103f18:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103f1f:	c0 
c0103f20:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103f27:	00 
c0103f28:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103f2f:	e8 c5 c4 ff ff       	call   c01003f9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103f34:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103f39:	8b 00                	mov    (%eax),%eax
c0103f3b:	89 04 24             	mov    %eax,(%esp)
c0103f3e:	e8 8c ed ff ff       	call   c0102ccf <pde2page>
c0103f43:	89 04 24             	mov    %eax,(%esp)
c0103f46:	e8 9c ed ff ff       	call   c0102ce7 <page_ref>
c0103f4b:	83 f8 01             	cmp    $0x1,%eax
c0103f4e:	74 24                	je     c0103f74 <check_pgdir+0x663>
c0103f50:	c7 44 24 0c 14 66 10 	movl   $0xc0106614,0xc(%esp)
c0103f57:	c0 
c0103f58:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0103f5f:	c0 
c0103f60:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0103f67:	00 
c0103f68:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103f6f:	e8 85 c4 ff ff       	call   c01003f9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103f74:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103f79:	8b 00                	mov    (%eax),%eax
c0103f7b:	89 04 24             	mov    %eax,(%esp)
c0103f7e:	e8 4c ed ff ff       	call   c0102ccf <pde2page>
c0103f83:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f8a:	00 
c0103f8b:	89 04 24             	mov    %eax,(%esp)
c0103f8e:	e8 91 ef ff ff       	call   c0102f24 <free_pages>
    boot_pgdir[0] = 0;
c0103f93:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103f98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103f9e:	c7 04 24 3b 66 10 c0 	movl   $0xc010663b,(%esp)
c0103fa5:	e8 f8 c2 ff ff       	call   c01002a2 <cprintf>
}
c0103faa:	90                   	nop
c0103fab:	c9                   	leave  
c0103fac:	c3                   	ret    

c0103fad <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103fad:	55                   	push   %ebp
c0103fae:	89 e5                	mov    %esp,%ebp
c0103fb0:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103fb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103fba:	e9 ca 00 00 00       	jmp    c0104089 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fc8:	c1 e8 0c             	shr    $0xc,%eax
c0103fcb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103fce:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103fd3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103fd6:	72 23                	jb     c0103ffb <check_boot_pgdir+0x4e>
c0103fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103fdf:	c7 44 24 08 80 62 10 	movl   $0xc0106280,0x8(%esp)
c0103fe6:	c0 
c0103fe7:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0103fee:	00 
c0103fef:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0103ff6:	e8 fe c3 ff ff       	call   c01003f9 <__panic>
c0103ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ffe:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104003:	89 c2                	mov    %eax,%edx
c0104005:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010400a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104011:	00 
c0104012:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104016:	89 04 24             	mov    %eax,(%esp)
c0104019:	e8 86 f5 ff ff       	call   c01035a4 <get_pte>
c010401e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104021:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104025:	75 24                	jne    c010404b <check_boot_pgdir+0x9e>
c0104027:	c7 44 24 0c 58 66 10 	movl   $0xc0106658,0xc(%esp)
c010402e:	c0 
c010402f:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0104036:	c0 
c0104037:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c010403e:	00 
c010403f:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0104046:	e8 ae c3 ff ff       	call   c01003f9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010404b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010404e:	8b 00                	mov    (%eax),%eax
c0104050:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104055:	89 c2                	mov    %eax,%edx
c0104057:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010405a:	39 c2                	cmp    %eax,%edx
c010405c:	74 24                	je     c0104082 <check_boot_pgdir+0xd5>
c010405e:	c7 44 24 0c 95 66 10 	movl   $0xc0106695,0xc(%esp)
c0104065:	c0 
c0104066:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c010406d:	c0 
c010406e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104075:	00 
c0104076:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c010407d:	e8 77 c3 ff ff       	call   c01003f9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104082:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104089:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010408c:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104091:	39 c2                	cmp    %eax,%edx
c0104093:	0f 82 26 ff ff ff    	jb     c0103fbf <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104099:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010409e:	05 ac 0f 00 00       	add    $0xfac,%eax
c01040a3:	8b 00                	mov    (%eax),%eax
c01040a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01040aa:	89 c2                	mov    %eax,%edx
c01040ac:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01040b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01040b4:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01040bb:	77 23                	ja     c01040e0 <check_boot_pgdir+0x133>
c01040bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040c4:	c7 44 24 08 24 63 10 	movl   $0xc0106324,0x8(%esp)
c01040cb:	c0 
c01040cc:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c01040d3:	00 
c01040d4:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01040db:	e8 19 c3 ff ff       	call   c01003f9 <__panic>
c01040e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040e3:	05 00 00 00 40       	add    $0x40000000,%eax
c01040e8:	39 d0                	cmp    %edx,%eax
c01040ea:	74 24                	je     c0104110 <check_boot_pgdir+0x163>
c01040ec:	c7 44 24 0c ac 66 10 	movl   $0xc01066ac,0xc(%esp)
c01040f3:	c0 
c01040f4:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c01040fb:	c0 
c01040fc:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104103:	00 
c0104104:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c010410b:	e8 e9 c2 ff ff       	call   c01003f9 <__panic>

    assert(boot_pgdir[0] == 0);
c0104110:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104115:	8b 00                	mov    (%eax),%eax
c0104117:	85 c0                	test   %eax,%eax
c0104119:	74 24                	je     c010413f <check_boot_pgdir+0x192>
c010411b:	c7 44 24 0c e0 66 10 	movl   $0xc01066e0,0xc(%esp)
c0104122:	c0 
c0104123:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c010412a:	c0 
c010412b:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104132:	00 
c0104133:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c010413a:	e8 ba c2 ff ff       	call   c01003f9 <__panic>

    struct Page *p;
    p = alloc_page();
c010413f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104146:	e8 a1 ed ff ff       	call   c0102eec <alloc_pages>
c010414b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010414e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104153:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010415a:	00 
c010415b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104162:	00 
c0104163:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104166:	89 54 24 04          	mov    %edx,0x4(%esp)
c010416a:	89 04 24             	mov    %eax,(%esp)
c010416d:	e8 6b f6 ff ff       	call   c01037dd <page_insert>
c0104172:	85 c0                	test   %eax,%eax
c0104174:	74 24                	je     c010419a <check_boot_pgdir+0x1ed>
c0104176:	c7 44 24 0c f4 66 10 	movl   $0xc01066f4,0xc(%esp)
c010417d:	c0 
c010417e:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0104185:	c0 
c0104186:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c010418d:	00 
c010418e:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0104195:	e8 5f c2 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p) == 1);
c010419a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010419d:	89 04 24             	mov    %eax,(%esp)
c01041a0:	e8 42 eb ff ff       	call   c0102ce7 <page_ref>
c01041a5:	83 f8 01             	cmp    $0x1,%eax
c01041a8:	74 24                	je     c01041ce <check_boot_pgdir+0x221>
c01041aa:	c7 44 24 0c 22 67 10 	movl   $0xc0106722,0xc(%esp)
c01041b1:	c0 
c01041b2:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c01041b9:	c0 
c01041ba:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c01041c1:	00 
c01041c2:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01041c9:	e8 2b c2 ff ff       	call   c01003f9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01041ce:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01041d3:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01041da:	00 
c01041db:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01041e2:	00 
c01041e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041e6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01041ea:	89 04 24             	mov    %eax,(%esp)
c01041ed:	e8 eb f5 ff ff       	call   c01037dd <page_insert>
c01041f2:	85 c0                	test   %eax,%eax
c01041f4:	74 24                	je     c010421a <check_boot_pgdir+0x26d>
c01041f6:	c7 44 24 0c 34 67 10 	movl   $0xc0106734,0xc(%esp)
c01041fd:	c0 
c01041fe:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0104205:	c0 
c0104206:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c010420d:	00 
c010420e:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0104215:	e8 df c1 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p) == 2);
c010421a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010421d:	89 04 24             	mov    %eax,(%esp)
c0104220:	e8 c2 ea ff ff       	call   c0102ce7 <page_ref>
c0104225:	83 f8 02             	cmp    $0x2,%eax
c0104228:	74 24                	je     c010424e <check_boot_pgdir+0x2a1>
c010422a:	c7 44 24 0c 6b 67 10 	movl   $0xc010676b,0xc(%esp)
c0104231:	c0 
c0104232:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c0104239:	c0 
c010423a:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104241:	00 
c0104242:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0104249:	e8 ab c1 ff ff       	call   c01003f9 <__panic>

    const char *str = "ucore: Hello world!!";
c010424e:	c7 45 e8 7c 67 10 c0 	movl   $0xc010677c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0104255:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104258:	89 44 24 04          	mov    %eax,0x4(%esp)
c010425c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104263:	e8 0c 0e 00 00       	call   c0105074 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104268:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010426f:	00 
c0104270:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104277:	e8 6f 0e 00 00       	call   c01050eb <strcmp>
c010427c:	85 c0                	test   %eax,%eax
c010427e:	74 24                	je     c01042a4 <check_boot_pgdir+0x2f7>
c0104280:	c7 44 24 0c 94 67 10 	movl   $0xc0106794,0xc(%esp)
c0104287:	c0 
c0104288:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c010428f:	c0 
c0104290:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0104297:	00 
c0104298:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c010429f:	e8 55 c1 ff ff       	call   c01003f9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01042a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042a7:	89 04 24             	mov    %eax,(%esp)
c01042aa:	e8 8e e9 ff ff       	call   c0102c3d <page2kva>
c01042af:	05 00 01 00 00       	add    $0x100,%eax
c01042b4:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01042b7:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01042be:	e8 5b 0d 00 00       	call   c010501e <strlen>
c01042c3:	85 c0                	test   %eax,%eax
c01042c5:	74 24                	je     c01042eb <check_boot_pgdir+0x33e>
c01042c7:	c7 44 24 0c cc 67 10 	movl   $0xc01067cc,0xc(%esp)
c01042ce:	c0 
c01042cf:	c7 44 24 08 6d 63 10 	movl   $0xc010636d,0x8(%esp)
c01042d6:	c0 
c01042d7:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c01042de:	00 
c01042df:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c01042e6:	e8 0e c1 ff ff       	call   c01003f9 <__panic>

    free_page(p);
c01042eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042f2:	00 
c01042f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042f6:	89 04 24             	mov    %eax,(%esp)
c01042f9:	e8 26 ec ff ff       	call   c0102f24 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01042fe:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104303:	8b 00                	mov    (%eax),%eax
c0104305:	89 04 24             	mov    %eax,(%esp)
c0104308:	e8 c2 e9 ff ff       	call   c0102ccf <pde2page>
c010430d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104314:	00 
c0104315:	89 04 24             	mov    %eax,(%esp)
c0104318:	e8 07 ec ff ff       	call   c0102f24 <free_pages>
    boot_pgdir[0] = 0;
c010431d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104322:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104328:	c7 04 24 f0 67 10 c0 	movl   $0xc01067f0,(%esp)
c010432f:	e8 6e bf ff ff       	call   c01002a2 <cprintf>
}
c0104334:	90                   	nop
c0104335:	c9                   	leave  
c0104336:	c3                   	ret    

c0104337 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104337:	55                   	push   %ebp
c0104338:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010433a:	8b 45 08             	mov    0x8(%ebp),%eax
c010433d:	83 e0 04             	and    $0x4,%eax
c0104340:	85 c0                	test   %eax,%eax
c0104342:	74 04                	je     c0104348 <perm2str+0x11>
c0104344:	b0 75                	mov    $0x75,%al
c0104346:	eb 02                	jmp    c010434a <perm2str+0x13>
c0104348:	b0 2d                	mov    $0x2d,%al
c010434a:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c010434f:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104356:	8b 45 08             	mov    0x8(%ebp),%eax
c0104359:	83 e0 02             	and    $0x2,%eax
c010435c:	85 c0                	test   %eax,%eax
c010435e:	74 04                	je     c0104364 <perm2str+0x2d>
c0104360:	b0 77                	mov    $0x77,%al
c0104362:	eb 02                	jmp    c0104366 <perm2str+0x2f>
c0104364:	b0 2d                	mov    $0x2d,%al
c0104366:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c010436b:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c0104372:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c0104377:	5d                   	pop    %ebp
c0104378:	c3                   	ret    

c0104379 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104379:	55                   	push   %ebp
c010437a:	89 e5                	mov    %esp,%ebp
c010437c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010437f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104382:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104385:	72 0d                	jb     c0104394 <get_pgtable_items+0x1b>
        return 0;
c0104387:	b8 00 00 00 00       	mov    $0x0,%eax
c010438c:	e9 98 00 00 00       	jmp    c0104429 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104391:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104394:	8b 45 10             	mov    0x10(%ebp),%eax
c0104397:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010439a:	73 18                	jae    c01043b4 <get_pgtable_items+0x3b>
c010439c:	8b 45 10             	mov    0x10(%ebp),%eax
c010439f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01043a6:	8b 45 14             	mov    0x14(%ebp),%eax
c01043a9:	01 d0                	add    %edx,%eax
c01043ab:	8b 00                	mov    (%eax),%eax
c01043ad:	83 e0 01             	and    $0x1,%eax
c01043b0:	85 c0                	test   %eax,%eax
c01043b2:	74 dd                	je     c0104391 <get_pgtable_items+0x18>
    }
    if (start < right) {
c01043b4:	8b 45 10             	mov    0x10(%ebp),%eax
c01043b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043ba:	73 68                	jae    c0104424 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c01043bc:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01043c0:	74 08                	je     c01043ca <get_pgtable_items+0x51>
            *left_store = start;
c01043c2:	8b 45 18             	mov    0x18(%ebp),%eax
c01043c5:	8b 55 10             	mov    0x10(%ebp),%edx
c01043c8:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01043ca:	8b 45 10             	mov    0x10(%ebp),%eax
c01043cd:	8d 50 01             	lea    0x1(%eax),%edx
c01043d0:	89 55 10             	mov    %edx,0x10(%ebp)
c01043d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01043da:	8b 45 14             	mov    0x14(%ebp),%eax
c01043dd:	01 d0                	add    %edx,%eax
c01043df:	8b 00                	mov    (%eax),%eax
c01043e1:	83 e0 07             	and    $0x7,%eax
c01043e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01043e7:	eb 03                	jmp    c01043ec <get_pgtable_items+0x73>
            start ++;
c01043e9:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01043ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01043ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043f2:	73 1d                	jae    c0104411 <get_pgtable_items+0x98>
c01043f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01043f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01043fe:	8b 45 14             	mov    0x14(%ebp),%eax
c0104401:	01 d0                	add    %edx,%eax
c0104403:	8b 00                	mov    (%eax),%eax
c0104405:	83 e0 07             	and    $0x7,%eax
c0104408:	89 c2                	mov    %eax,%edx
c010440a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010440d:	39 c2                	cmp    %eax,%edx
c010440f:	74 d8                	je     c01043e9 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0104411:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104415:	74 08                	je     c010441f <get_pgtable_items+0xa6>
            *right_store = start;
c0104417:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010441a:	8b 55 10             	mov    0x10(%ebp),%edx
c010441d:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010441f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104422:	eb 05                	jmp    c0104429 <get_pgtable_items+0xb0>
    }
    return 0;
c0104424:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104429:	c9                   	leave  
c010442a:	c3                   	ret    

c010442b <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010442b:	55                   	push   %ebp
c010442c:	89 e5                	mov    %esp,%ebp
c010442e:	57                   	push   %edi
c010442f:	56                   	push   %esi
c0104430:	53                   	push   %ebx
c0104431:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104434:	c7 04 24 10 68 10 c0 	movl   $0xc0106810,(%esp)
c010443b:	e8 62 be ff ff       	call   c01002a2 <cprintf>
    size_t left, right = 0, perm;
c0104440:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104447:	e9 fa 00 00 00       	jmp    c0104546 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010444c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010444f:	89 04 24             	mov    %eax,(%esp)
c0104452:	e8 e0 fe ff ff       	call   c0104337 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104457:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010445a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010445d:	29 d1                	sub    %edx,%ecx
c010445f:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104461:	89 d6                	mov    %edx,%esi
c0104463:	c1 e6 16             	shl    $0x16,%esi
c0104466:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104469:	89 d3                	mov    %edx,%ebx
c010446b:	c1 e3 16             	shl    $0x16,%ebx
c010446e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104471:	89 d1                	mov    %edx,%ecx
c0104473:	c1 e1 16             	shl    $0x16,%ecx
c0104476:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104479:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010447c:	29 d7                	sub    %edx,%edi
c010447e:	89 fa                	mov    %edi,%edx
c0104480:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104484:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104488:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010448c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104490:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104494:	c7 04 24 41 68 10 c0 	movl   $0xc0106841,(%esp)
c010449b:	e8 02 be ff ff       	call   c01002a2 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01044a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044a3:	c1 e0 0a             	shl    $0xa,%eax
c01044a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01044a9:	eb 54                	jmp    c01044ff <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01044ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044ae:	89 04 24             	mov    %eax,(%esp)
c01044b1:	e8 81 fe ff ff       	call   c0104337 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01044b6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01044b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01044bc:	29 d1                	sub    %edx,%ecx
c01044be:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01044c0:	89 d6                	mov    %edx,%esi
c01044c2:	c1 e6 0c             	shl    $0xc,%esi
c01044c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01044c8:	89 d3                	mov    %edx,%ebx
c01044ca:	c1 e3 0c             	shl    $0xc,%ebx
c01044cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01044d0:	89 d1                	mov    %edx,%ecx
c01044d2:	c1 e1 0c             	shl    $0xc,%ecx
c01044d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01044d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01044db:	29 d7                	sub    %edx,%edi
c01044dd:	89 fa                	mov    %edi,%edx
c01044df:	89 44 24 14          	mov    %eax,0x14(%esp)
c01044e3:	89 74 24 10          	mov    %esi,0x10(%esp)
c01044e7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01044eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01044ef:	89 54 24 04          	mov    %edx,0x4(%esp)
c01044f3:	c7 04 24 60 68 10 c0 	movl   $0xc0106860,(%esp)
c01044fa:	e8 a3 bd ff ff       	call   c01002a2 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01044ff:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104504:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104507:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010450a:	89 d3                	mov    %edx,%ebx
c010450c:	c1 e3 0a             	shl    $0xa,%ebx
c010450f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104512:	89 d1                	mov    %edx,%ecx
c0104514:	c1 e1 0a             	shl    $0xa,%ecx
c0104517:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010451a:	89 54 24 14          	mov    %edx,0x14(%esp)
c010451e:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104521:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104525:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0104529:	89 44 24 08          	mov    %eax,0x8(%esp)
c010452d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104531:	89 0c 24             	mov    %ecx,(%esp)
c0104534:	e8 40 fe ff ff       	call   c0104379 <get_pgtable_items>
c0104539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010453c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104540:	0f 85 65 ff ff ff    	jne    c01044ab <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104546:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010454b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010454e:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104551:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104555:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104558:	89 54 24 10          	mov    %edx,0x10(%esp)
c010455c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104560:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104564:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010456b:	00 
c010456c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104573:	e8 01 fe ff ff       	call   c0104379 <get_pgtable_items>
c0104578:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010457b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010457f:	0f 85 c7 fe ff ff    	jne    c010444c <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104585:	c7 04 24 84 68 10 c0 	movl   $0xc0106884,(%esp)
c010458c:	e8 11 bd ff ff       	call   c01002a2 <cprintf>
}
c0104591:	90                   	nop
c0104592:	83 c4 4c             	add    $0x4c,%esp
c0104595:	5b                   	pop    %ebx
c0104596:	5e                   	pop    %esi
c0104597:	5f                   	pop    %edi
c0104598:	5d                   	pop    %ebp
c0104599:	c3                   	ret    

c010459a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010459a:	55                   	push   %ebp
c010459b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010459d:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01045a3:	89 10                	mov    %edx,(%eax)
}
c01045a5:	90                   	nop
c01045a6:	5d                   	pop    %ebp
c01045a7:	c3                   	ret    

c01045a8 <fixsize>:

// total 是对size进行修正后的二叉树的size大小
unsigned total;

// 如果size不是2的幂次，进行修正
static unsigned fixsize(unsigned size) {
c01045a8:	55                   	push   %ebp
c01045a9:	89 e5                	mov    %esp,%ebp
	size |= size >> 1;
c01045ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ae:	d1 e8                	shr    %eax
c01045b0:	09 45 08             	or     %eax,0x8(%ebp)
	size |= size >> 2;
c01045b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b6:	c1 e8 02             	shr    $0x2,%eax
c01045b9:	09 45 08             	or     %eax,0x8(%ebp)
	size |= size >> 4;
c01045bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01045bf:	c1 e8 04             	shr    $0x4,%eax
c01045c2:	09 45 08             	or     %eax,0x8(%ebp)
	size |= size >> 8;
c01045c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c8:	c1 e8 08             	shr    $0x8,%eax
c01045cb:	09 45 08             	or     %eax,0x8(%ebp)
	size |= size >> 16;
c01045ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d1:	c1 e8 10             	shr    $0x10,%eax
c01045d4:	09 45 08             	or     %eax,0x8(%ebp)
	return size+1;
c01045d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045da:	40                   	inc    %eax
}
c01045db:	5d                   	pop    %ebp
c01045dc:	c3                   	ret    

c01045dd <Buddy_init>:

static void
Buddy_init(void) {
c01045dd:	55                   	push   %ebp
c01045de:	89 e5                	mov    %esp,%ebp
    //list_init(&free_list);用不到这个树了
    nr_free = 0;
c01045e0:	c7 05 90 af 25 c0 00 	movl   $0x0,0xc025af90
c01045e7:	00 00 00 
}
c01045ea:	90                   	nop
c01045eb:	5d                   	pop    %ebp
c01045ec:	c3                   	ret    

c01045ed <init_tree>:

//递归建树 ，对节点进行初始化
void init_tree(int root, int l, int r, struct Page *p){
c01045ed:	55                   	push   %ebp
c01045ee:	89 e5                	mov    %esp,%ebp
c01045f0:	83 ec 28             	sub    $0x28,%esp
	bu[root].left = l;
c01045f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01045f6:	8b 55 08             	mov    0x8(%ebp),%edx
c01045f9:	89 d0                	mov    %edx,%eax
c01045fb:	c1 e0 02             	shl    $0x2,%eax
c01045fe:	01 d0                	add    %edx,%eax
c0104600:	c1 e0 02             	shl    $0x2,%eax
c0104603:	05 80 af 11 c0       	add    $0xc011af80,%eax
c0104608:	89 08                	mov    %ecx,(%eax)
	bu[root].right = r;
c010460a:	8b 4d 10             	mov    0x10(%ebp),%ecx
c010460d:	8b 55 08             	mov    0x8(%ebp),%edx
c0104610:	89 d0                	mov    %edx,%eax
c0104612:	c1 e0 02             	shl    $0x2,%eax
c0104615:	01 d0                	add    %edx,%eax
c0104617:	c1 e0 02             	shl    $0x2,%eax
c010461a:	05 84 af 11 c0       	add    $0xc011af84,%eax
c010461f:	89 08                	mov    %ecx,(%eax)
	bu[root].longest = r-l+1;
c0104621:	8b 45 10             	mov    0x10(%ebp),%eax
c0104624:	2b 45 0c             	sub    0xc(%ebp),%eax
c0104627:	40                   	inc    %eax
c0104628:	89 c1                	mov    %eax,%ecx
c010462a:	8b 55 08             	mov    0x8(%ebp),%edx
c010462d:	89 d0                	mov    %edx,%eax
c010462f:	c1 e0 02             	shl    $0x2,%eax
c0104632:	01 d0                	add    %edx,%eax
c0104634:	c1 e0 02             	shl    $0x2,%eax
c0104637:	05 88 af 11 c0       	add    $0xc011af88,%eax
c010463c:	89 08                	mov    %ecx,(%eax)
	bu[root].page = p;
c010463e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104641:	89 d0                	mov    %edx,%eax
c0104643:	c1 e0 02             	shl    $0x2,%eax
c0104646:	01 d0                	add    %edx,%eax
c0104648:	c1 e0 02             	shl    $0x2,%eax
c010464b:	8d 90 90 af 11 c0    	lea    -0x3fee5070(%eax),%edx
c0104651:	8b 45 14             	mov    0x14(%ebp),%eax
c0104654:	89 02                	mov    %eax,(%edx)
	bu[root].free=0;
c0104656:	8b 55 08             	mov    0x8(%ebp),%edx
c0104659:	89 d0                	mov    %edx,%eax
c010465b:	c1 e0 02             	shl    $0x2,%eax
c010465e:	01 d0                	add    %edx,%eax
c0104660:	c1 e0 02             	shl    $0x2,%eax
c0104663:	05 8c af 11 c0       	add    $0xc011af8c,%eax
c0104668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (l==r) return;
c010466e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104671:	3b 45 10             	cmp    0x10(%ebp),%eax
c0104674:	74 7a                	je     c01046f0 <init_tree+0x103>
	int mid=(l+r)>>1;
c0104676:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104679:	8b 45 10             	mov    0x10(%ebp),%eax
c010467c:	01 d0                	add    %edx,%eax
c010467e:	d1 f8                	sar    %eax
c0104680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	init_tree(LEFT_LEAF(root),l,mid,p);
c0104683:	8b 45 08             	mov    0x8(%ebp),%eax
c0104686:	01 c0                	add    %eax,%eax
c0104688:	8d 50 01             	lea    0x1(%eax),%edx
c010468b:	8b 45 14             	mov    0x14(%ebp),%eax
c010468e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104692:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104695:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104699:	8b 45 0c             	mov    0xc(%ebp),%eax
c010469c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046a0:	89 14 24             	mov    %edx,(%esp)
c01046a3:	e8 45 ff ff ff       	call   c01045ed <init_tree>
	init_tree(RIGHT_LEAF(root),mid+1,r,p+(r-l+1)/2);
c01046a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01046ab:	2b 45 0c             	sub    0xc(%ebp),%eax
c01046ae:	40                   	inc    %eax
c01046af:	89 c2                	mov    %eax,%edx
c01046b1:	c1 ea 1f             	shr    $0x1f,%edx
c01046b4:	01 d0                	add    %edx,%eax
c01046b6:	d1 f8                	sar    %eax
c01046b8:	89 c2                	mov    %eax,%edx
c01046ba:	89 d0                	mov    %edx,%eax
c01046bc:	c1 e0 02             	shl    $0x2,%eax
c01046bf:	01 d0                	add    %edx,%eax
c01046c1:	c1 e0 02             	shl    $0x2,%eax
c01046c4:	89 c2                	mov    %eax,%edx
c01046c6:	8b 45 14             	mov    0x14(%ebp),%eax
c01046c9:	01 d0                	add    %edx,%eax
c01046cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01046ce:	8d 4a 01             	lea    0x1(%edx),%ecx
c01046d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01046d4:	42                   	inc    %edx
c01046d5:	01 d2                	add    %edx,%edx
c01046d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046db:	8b 45 10             	mov    0x10(%ebp),%eax
c01046de:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01046e6:	89 14 24             	mov    %edx,(%esp)
c01046e9:	e8 ff fe ff ff       	call   c01045ed <init_tree>
c01046ee:	eb 01                	jmp    c01046f1 <init_tree+0x104>
	if (l==r) return;
c01046f0:	90                   	nop
}
c01046f1:	c9                   	leave  
c01046f2:	c3                   	ret    

c01046f3 <fixtree>:
// 对树进行修正，因为有一些空间是不能被分配的
void fixtree(int index,int n)
{
c01046f3:	55                   	push   %ebp
c01046f4:	89 e5                	mov    %esp,%ebp
c01046f6:	83 ec 28             	sub    $0x28,%esp
	int l = bu[index].left;
c01046f9:	8b 55 08             	mov    0x8(%ebp),%edx
c01046fc:	89 d0                	mov    %edx,%eax
c01046fe:	c1 e0 02             	shl    $0x2,%eax
c0104701:	01 d0                	add    %edx,%eax
c0104703:	c1 e0 02             	shl    $0x2,%eax
c0104706:	05 80 af 11 c0       	add    $0xc011af80,%eax
c010470b:	8b 00                	mov    (%eax),%eax
c010470d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int r = bu[index].right;
c0104710:	8b 55 08             	mov    0x8(%ebp),%edx
c0104713:	89 d0                	mov    %edx,%eax
c0104715:	c1 e0 02             	shl    $0x2,%eax
c0104718:	01 d0                	add    %edx,%eax
c010471a:	c1 e0 02             	shl    $0x2,%eax
c010471d:	05 84 af 11 c0       	add    $0xc011af84,%eax
c0104722:	8b 00                	mov    (%eax),%eax
c0104724:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int mid = (l+r)>>1;
c0104727:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010472a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010472d:	01 d0                	add    %edx,%eax
c010472f:	d1 f8                	sar    %eax
c0104731:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (r < n)return ;
c0104734:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104737:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010473a:	0f 8c b5 00 00 00    	jl     c01047f5 <fixtree+0x102>
	if (l>=n)
c0104740:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104743:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104746:	7c 32                	jl     c010477a <fixtree+0x87>
	{
		bu[index].longest=0;
c0104748:	8b 55 08             	mov    0x8(%ebp),%edx
c010474b:	89 d0                	mov    %edx,%eax
c010474d:	c1 e0 02             	shl    $0x2,%eax
c0104750:	01 d0                	add    %edx,%eax
c0104752:	c1 e0 02             	shl    $0x2,%eax
c0104755:	05 88 af 11 c0       	add    $0xc011af88,%eax
c010475a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		bu[index].free=1;
c0104760:	8b 55 08             	mov    0x8(%ebp),%edx
c0104763:	89 d0                	mov    %edx,%eax
c0104765:	c1 e0 02             	shl    $0x2,%eax
c0104768:	01 d0                	add    %edx,%eax
c010476a:	c1 e0 02             	shl    $0x2,%eax
c010476d:	05 8c af 11 c0       	add    $0xc011af8c,%eax
c0104772:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		return;
c0104778:	eb 7c                	jmp    c01047f6 <fixtree+0x103>
	}
	fixtree(LEFT_LEAF(index),n);
c010477a:	8b 45 08             	mov    0x8(%ebp),%eax
c010477d:	01 c0                	add    %eax,%eax
c010477f:	8d 50 01             	lea    0x1(%eax),%edx
c0104782:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104785:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104789:	89 14 24             	mov    %edx,(%esp)
c010478c:	e8 62 ff ff ff       	call   c01046f3 <fixtree>
	fixtree(RIGHT_LEAF(index),n);
c0104791:	8b 45 08             	mov    0x8(%ebp),%eax
c0104794:	40                   	inc    %eax
c0104795:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0104798:	8b 45 0c             	mov    0xc(%ebp),%eax
c010479b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010479f:	89 14 24             	mov    %edx,(%esp)
c01047a2:	e8 4c ff ff ff       	call   c01046f3 <fixtree>
	bu[index].longest = MAX(bu[LEFT_LEAF(index)].longest,bu[RIGHT_LEAF(index)].longest);
c01047a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01047aa:	40                   	inc    %eax
c01047ab:	8d 14 00             	lea    (%eax,%eax,1),%edx
c01047ae:	89 d0                	mov    %edx,%eax
c01047b0:	c1 e0 02             	shl    $0x2,%eax
c01047b3:	01 d0                	add    %edx,%eax
c01047b5:	c1 e0 02             	shl    $0x2,%eax
c01047b8:	05 88 af 11 c0       	add    $0xc011af88,%eax
c01047bd:	8b 10                	mov    (%eax),%edx
c01047bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c2:	01 c0                	add    %eax,%eax
c01047c4:	8d 48 01             	lea    0x1(%eax),%ecx
c01047c7:	89 c8                	mov    %ecx,%eax
c01047c9:	c1 e0 02             	shl    $0x2,%eax
c01047cc:	01 c8                	add    %ecx,%eax
c01047ce:	c1 e0 02             	shl    $0x2,%eax
c01047d1:	05 88 af 11 c0       	add    $0xc011af88,%eax
c01047d6:	8b 00                	mov    (%eax),%eax
c01047d8:	39 c2                	cmp    %eax,%edx
c01047da:	0f 43 c2             	cmovae %edx,%eax
c01047dd:	89 c1                	mov    %eax,%ecx
c01047df:	8b 55 08             	mov    0x8(%ebp),%edx
c01047e2:	89 d0                	mov    %edx,%eax
c01047e4:	c1 e0 02             	shl    $0x2,%eax
c01047e7:	01 d0                	add    %edx,%eax
c01047e9:	c1 e0 02             	shl    $0x2,%eax
c01047ec:	05 88 af 11 c0       	add    $0xc011af88,%eax
c01047f1:	89 08                	mov    %ecx,(%eax)
c01047f3:	eb 01                	jmp    c01047f6 <fixtree+0x103>
	if (r < n)return ;
c01047f5:	90                   	nop
}
c01047f6:	c9                   	leave  
c01047f7:	c3                   	ret    

c01047f8 <Buddy_init_memmap>:

// 传入size ，这个size不一定是2的幂次，进行修正以后建二叉树，再对页进行初始化
static void
Buddy_init_memmap(struct Page *base, size_t n) {
c01047f8:	55                   	push   %ebp
c01047f9:	89 e5                	mov    %esp,%ebp
c01047fb:	83 ec 38             	sub    $0x38,%esp
	cprintf("\n----------------------------init_memap total_free_page:%d\n",n);
c01047fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104801:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104805:	c7 04 24 c0 68 10 c0 	movl   $0xc01068c0,(%esp)
c010480c:	e8 91 ba ff ff       	call   c01002a2 <cprintf>
    assert(n > 0);
c0104811:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104815:	75 24                	jne    c010483b <Buddy_init_memmap+0x43>
c0104817:	c7 44 24 0c fc 68 10 	movl   $0xc01068fc,0xc(%esp)
c010481e:	c0 
c010481f:	c7 44 24 08 02 69 10 	movl   $0xc0106902,0x8(%esp)
c0104826:	c0 
c0104827:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c010482e:	00 
c010482f:	c7 04 24 17 69 10 c0 	movl   $0xc0106917,(%esp)
c0104836:	e8 be bb ff ff       	call   c01003f9 <__panic>
	total = fixsize(n);
c010483b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010483e:	89 04 24             	mov    %eax,(%esp)
c0104841:	e8 62 fd ff ff       	call   c01045a8 <fixsize>
c0104846:	a3 84 af 25 c0       	mov    %eax,0xc025af84
	treebase = base;
c010484b:	8b 45 08             	mov    0x8(%ebp),%eax
c010484e:	a3 80 af 25 c0       	mov    %eax,0xc025af80
	cprintf("----------------------------tree size is :%d.\n",total);
c0104853:	a1 84 af 25 c0       	mov    0xc025af84,%eax
c0104858:	89 44 24 04          	mov    %eax,0x4(%esp)
c010485c:	c7 04 24 30 69 10 c0 	movl   $0xc0106930,(%esp)
c0104863:	e8 3a ba ff ff       	call   c01002a2 <cprintf>
	init_tree(0,0,total-1,base);
c0104868:	a1 84 af 25 c0       	mov    0xc025af84,%eax
c010486d:	48                   	dec    %eax
c010486e:	89 c2                	mov    %eax,%edx
c0104870:	8b 45 08             	mov    0x8(%ebp),%eax
c0104873:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104877:	89 54 24 08          	mov    %edx,0x8(%esp)
c010487b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104882:	00 
c0104883:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010488a:	e8 5e fd ff ff       	call   c01045ed <init_tree>
	fixtree(0,n);
c010488f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104892:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104896:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010489d:	e8 51 fe ff ff       	call   c01046f3 <fixtree>
	struct Page *p = base;
c01048a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01048a8:	e9 94 00 00 00       	jmp    c0104941 <Buddy_init_memmap+0x149>
        assert(PageReserved(p));
c01048ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b0:	83 c0 04             	add    $0x4,%eax
c01048b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01048ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01048bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01048c3:	0f a3 10             	bt     %edx,(%eax)
c01048c6:	19 c0                	sbb    %eax,%eax
c01048c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01048cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01048cf:	0f 95 c0             	setne  %al
c01048d2:	0f b6 c0             	movzbl %al,%eax
c01048d5:	85 c0                	test   %eax,%eax
c01048d7:	75 24                	jne    c01048fd <Buddy_init_memmap+0x105>
c01048d9:	c7 44 24 0c 5f 69 10 	movl   $0xc010695f,0xc(%esp)
c01048e0:	c0 
c01048e1:	c7 44 24 08 02 69 10 	movl   $0xc0106902,0x8(%esp)
c01048e8:	c0 
c01048e9:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c01048f0:	00 
c01048f1:	c7 04 24 17 69 10 c0 	movl   $0xc0106917,(%esp)
c01048f8:	e8 fc ba ff ff       	call   c01003f9 <__panic>
        p->flags = 0;
c01048fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104900:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c0104907:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010490a:	83 c0 04             	add    $0x4,%eax
c010490d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0104914:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104917:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010491a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010491d:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0104920:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104923:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c010492a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104931:	00 
c0104932:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104935:	89 04 24             	mov    %eax,(%esp)
c0104938:	e8 5d fc ff ff       	call   c010459a <set_page_ref>
    for (; p != base + n; p ++) {
c010493d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104941:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104944:	89 d0                	mov    %edx,%eax
c0104946:	c1 e0 02             	shl    $0x2,%eax
c0104949:	01 d0                	add    %edx,%eax
c010494b:	c1 e0 02             	shl    $0x2,%eax
c010494e:	89 c2                	mov    %eax,%edx
c0104950:	8b 45 08             	mov    0x8(%ebp),%eax
c0104953:	01 d0                	add    %edx,%eax
c0104955:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104958:	0f 85 4f ff ff ff    	jne    c01048ad <Buddy_init_memmap+0xb5>
    }
	cprintf("----------------------------init end\n\n");
c010495e:	c7 04 24 70 69 10 c0 	movl   $0xc0106970,(%esp)
c0104965:	e8 38 b9 ff ff       	call   c01002a2 <cprintf>
    nr_free += n;
c010496a:	8b 15 90 af 25 c0    	mov    0xc025af90,%edx
c0104970:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104973:	01 d0                	add    %edx,%eax
c0104975:	a3 90 af 25 c0       	mov    %eax,0xc025af90
    //first block
    base->property = n;
c010497a:	8b 45 08             	mov    0x8(%ebp),%eax
c010497d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104980:	89 50 08             	mov    %edx,0x8(%eax)
}
c0104983:	90                   	nop
c0104984:	c9                   	leave  
c0104985:	c3                   	ret    

c0104986 <search>:

// 通过递归 找到size大小的空闲区间，返回地址； 被alloc函数调用
struct Page * 
	search(int index,int size){
c0104986:	55                   	push   %ebp
c0104987:	89 e5                	mov    %esp,%ebp
c0104989:	83 ec 28             	sub    $0x28,%esp
	int longest = bu[index].longest;
c010498c:	8b 55 08             	mov    0x8(%ebp),%edx
c010498f:	89 d0                	mov    %edx,%eax
c0104991:	c1 e0 02             	shl    $0x2,%eax
c0104994:	01 d0                	add    %edx,%eax
c0104996:	c1 e0 02             	shl    $0x2,%eax
c0104999:	05 88 af 11 c0       	add    $0xc011af88,%eax
c010499e:	8b 00                	mov    (%eax),%eax
c01049a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
	if(size>longest) return NULL;
c01049a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049a9:	7e 0a                	jle    c01049b5 <search+0x2f>
c01049ab:	b8 00 00 00 00       	mov    $0x0,%eax
c01049b0:	e9 5b 01 00 00       	jmp    c0104b10 <search+0x18a>
	if(bu[LEFT_LEAF(index)].longest >= size){
c01049b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01049b8:	01 c0                	add    %eax,%eax
c01049ba:	8d 50 01             	lea    0x1(%eax),%edx
c01049bd:	89 d0                	mov    %edx,%eax
c01049bf:	c1 e0 02             	shl    $0x2,%eax
c01049c2:	01 d0                	add    %edx,%eax
c01049c4:	c1 e0 02             	shl    $0x2,%eax
c01049c7:	05 88 af 11 c0       	add    $0xc011af88,%eax
c01049cc:	8b 10                	mov    (%eax),%edx
c01049ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049d1:	39 c2                	cmp    %eax,%edx
c01049d3:	72 6e                	jb     c0104a43 <search+0xbd>
		struct Page * tmp = search(LEFT_LEAF(index),size);
c01049d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01049d8:	01 c0                	add    %eax,%eax
c01049da:	8d 50 01             	lea    0x1(%eax),%edx
c01049dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01049e4:	89 14 24             	mov    %edx,(%esp)
c01049e7:	e8 9a ff ff ff       	call   c0104986 <search>
c01049ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bu[index].longest = MAX(bu[LEFT_LEAF(index)].longest,bu[RIGHT_LEAF(index)].longest);
c01049ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01049f2:	40                   	inc    %eax
c01049f3:	8d 14 00             	lea    (%eax,%eax,1),%edx
c01049f6:	89 d0                	mov    %edx,%eax
c01049f8:	c1 e0 02             	shl    $0x2,%eax
c01049fb:	01 d0                	add    %edx,%eax
c01049fd:	c1 e0 02             	shl    $0x2,%eax
c0104a00:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104a05:	8b 10                	mov    (%eax),%edx
c0104a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a0a:	01 c0                	add    %eax,%eax
c0104a0c:	8d 48 01             	lea    0x1(%eax),%ecx
c0104a0f:	89 c8                	mov    %ecx,%eax
c0104a11:	c1 e0 02             	shl    $0x2,%eax
c0104a14:	01 c8                	add    %ecx,%eax
c0104a16:	c1 e0 02             	shl    $0x2,%eax
c0104a19:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104a1e:	8b 00                	mov    (%eax),%eax
c0104a20:	39 c2                	cmp    %eax,%edx
c0104a22:	0f 43 c2             	cmovae %edx,%eax
c0104a25:	89 c1                	mov    %eax,%ecx
c0104a27:	8b 55 08             	mov    0x8(%ebp),%edx
c0104a2a:	89 d0                	mov    %edx,%eax
c0104a2c:	c1 e0 02             	shl    $0x2,%eax
c0104a2f:	01 d0                	add    %edx,%eax
c0104a31:	c1 e0 02             	shl    $0x2,%eax
c0104a34:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104a39:	89 08                	mov    %ecx,(%eax)
		return tmp;
c0104a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a3e:	e9 cd 00 00 00       	jmp    c0104b10 <search+0x18a>
	}
	if(bu[RIGHT_LEAF(index)].longest >= size){
c0104a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a46:	40                   	inc    %eax
c0104a47:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0104a4a:	89 d0                	mov    %edx,%eax
c0104a4c:	c1 e0 02             	shl    $0x2,%eax
c0104a4f:	01 d0                	add    %edx,%eax
c0104a51:	c1 e0 02             	shl    $0x2,%eax
c0104a54:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104a59:	8b 10                	mov    (%eax),%edx
c0104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a5e:	39 c2                	cmp    %eax,%edx
c0104a60:	72 6a                	jb     c0104acc <search+0x146>
		struct Page * tmp = search(RIGHT_LEAF(index),size);
c0104a62:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a65:	40                   	inc    %eax
c0104a66:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0104a69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a70:	89 14 24             	mov    %edx,(%esp)
c0104a73:	e8 0e ff ff ff       	call   c0104986 <search>
c0104a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bu[index].longest = MAX(bu[LEFT_LEAF(index)].longest,bu[RIGHT_LEAF(index)].longest);
c0104a7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a7e:	40                   	inc    %eax
c0104a7f:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0104a82:	89 d0                	mov    %edx,%eax
c0104a84:	c1 e0 02             	shl    $0x2,%eax
c0104a87:	01 d0                	add    %edx,%eax
c0104a89:	c1 e0 02             	shl    $0x2,%eax
c0104a8c:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104a91:	8b 10                	mov    (%eax),%edx
c0104a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a96:	01 c0                	add    %eax,%eax
c0104a98:	8d 48 01             	lea    0x1(%eax),%ecx
c0104a9b:	89 c8                	mov    %ecx,%eax
c0104a9d:	c1 e0 02             	shl    $0x2,%eax
c0104aa0:	01 c8                	add    %ecx,%eax
c0104aa2:	c1 e0 02             	shl    $0x2,%eax
c0104aa5:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104aaa:	8b 00                	mov    (%eax),%eax
c0104aac:	39 c2                	cmp    %eax,%edx
c0104aae:	0f 43 c2             	cmovae %edx,%eax
c0104ab1:	89 c1                	mov    %eax,%ecx
c0104ab3:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ab6:	89 d0                	mov    %edx,%eax
c0104ab8:	c1 e0 02             	shl    $0x2,%eax
c0104abb:	01 d0                	add    %edx,%eax
c0104abd:	c1 e0 02             	shl    $0x2,%eax
c0104ac0:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104ac5:	89 08                	mov    %ecx,(%eax)
		return tmp;
c0104ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aca:	eb 44                	jmp    c0104b10 <search+0x18a>
	}
	bu[index].longest = 0;
c0104acc:	8b 55 08             	mov    0x8(%ebp),%edx
c0104acf:	89 d0                	mov    %edx,%eax
c0104ad1:	c1 e0 02             	shl    $0x2,%eax
c0104ad4:	01 d0                	add    %edx,%eax
c0104ad6:	c1 e0 02             	shl    $0x2,%eax
c0104ad9:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104ade:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	bu[index].free=1;
c0104ae4:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ae7:	89 d0                	mov    %edx,%eax
c0104ae9:	c1 e0 02             	shl    $0x2,%eax
c0104aec:	01 d0                	add    %edx,%eax
c0104aee:	c1 e0 02             	shl    $0x2,%eax
c0104af1:	05 8c af 11 c0       	add    $0xc011af8c,%eax
c0104af6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	return bu[index].page;
c0104afc:	8b 55 08             	mov    0x8(%ebp),%edx
c0104aff:	89 d0                	mov    %edx,%eax
c0104b01:	c1 e0 02             	shl    $0x2,%eax
c0104b04:	01 d0                	add    %edx,%eax
c0104b06:	c1 e0 02             	shl    $0x2,%eax
c0104b09:	05 90 af 11 c0       	add    $0xc011af90,%eax
c0104b0e:	8b 00                	mov    (%eax),%eax
	}
c0104b10:	c9                   	leave  
c0104b11:	c3                   	ret    

c0104b12 <Buddy_alloc_pages>:

// 分配空间
static struct Page *
Buddy_alloc_pages(size_t n) {
c0104b12:	55                   	push   %ebp
c0104b13:	89 e5                	mov    %esp,%ebp
c0104b15:	83 ec 28             	sub    $0x28,%esp
	
    assert(n > 0);
c0104b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104b1c:	75 24                	jne    c0104b42 <Buddy_alloc_pages+0x30>
c0104b1e:	c7 44 24 0c fc 68 10 	movl   $0xc01068fc,0xc(%esp)
c0104b25:	c0 
c0104b26:	c7 44 24 08 02 69 10 	movl   $0xc0106902,0x8(%esp)
c0104b2d:	c0 
c0104b2e:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
c0104b35:	00 
c0104b36:	c7 04 24 17 69 10 c0 	movl   $0xc0106917,(%esp)
c0104b3d:	e8 b7 b8 ff ff       	call   c01003f9 <__panic>
    if (n > nr_free) {
c0104b42:	a1 90 af 25 c0       	mov    0xc025af90,%eax
c0104b47:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104b4a:	76 0a                	jbe    c0104b56 <Buddy_alloc_pages+0x44>
        return NULL;
c0104b4c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b51:	e9 8b 00 00 00       	jmp    c0104be1 <Buddy_alloc_pages+0xcf>
    }
	struct Page * start =  search(0,n);
c0104b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104b64:	e8 1d fe ff ff       	call   c0104986 <search>
c0104b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(start == NULL) return NULL;
c0104b6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b70:	75 07                	jne    c0104b79 <Buddy_alloc_pages+0x67>
c0104b72:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b77:	eb 68                	jmp    c0104be1 <Buddy_alloc_pages+0xcf>
	int i;
	for(i = 0; i < n; i++){
c0104b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104b80:	eb 2d                	jmp    c0104baf <Buddy_alloc_pages+0x9d>
		SetPageReserved(start+i);
c0104b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b85:	89 d0                	mov    %edx,%eax
c0104b87:	c1 e0 02             	shl    $0x2,%eax
c0104b8a:	01 d0                	add    %edx,%eax
c0104b8c:	c1 e0 02             	shl    $0x2,%eax
c0104b8f:	89 c2                	mov    %eax,%edx
c0104b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b94:	01 d0                	add    %edx,%eax
c0104b96:	83 c0 04             	add    $0x4,%eax
c0104b99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104ba0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ba6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104ba9:	0f ab 10             	bts    %edx,(%eax)
	for(i = 0; i < n; i++){
c0104bac:	ff 45 f4             	incl   -0xc(%ebp)
c0104baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bb2:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104bb5:	77 cb                	ja     c0104b82 <Buddy_alloc_pages+0x70>
	}
	nr_free -= n;
c0104bb7:	a1 90 af 25 c0       	mov    0xc025af90,%eax
c0104bbc:	2b 45 08             	sub    0x8(%ebp),%eax
c0104bbf:	a3 90 af 25 c0       	mov    %eax,0xc025af90
	//cprintf("----alloc pages:%d %x\n",n,start);
	//if (n>1)
	cprintf("----alloc pages:%d %x\n",n,start);
c0104bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bc7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104bd2:	c7 04 24 97 69 10 c0 	movl   $0xc0106997,(%esp)
c0104bd9:	e8 c4 b6 ff ff       	call   c01002a2 <cprintf>
	return start;
c0104bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
    
}
c0104be1:	c9                   	leave  
c0104be2:	c3                   	ret    

c0104be3 <freetree>:

// 通过递归，查找相应位置，释放空间  free_pages函数调用
void freetree(int index, int pos, int size){
c0104be3:	55                   	push   %ebp
c0104be4:	89 e5                	mov    %esp,%ebp
c0104be6:	83 ec 38             	sub    $0x38,%esp
	int l = bu[index].left;
c0104be9:	8b 55 08             	mov    0x8(%ebp),%edx
c0104bec:	89 d0                	mov    %edx,%eax
c0104bee:	c1 e0 02             	shl    $0x2,%eax
c0104bf1:	01 d0                	add    %edx,%eax
c0104bf3:	c1 e0 02             	shl    $0x2,%eax
c0104bf6:	05 80 af 11 c0       	add    $0xc011af80,%eax
c0104bfb:	8b 00                	mov    (%eax),%eax
c0104bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int r = bu[index].right;
c0104c00:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c03:	89 d0                	mov    %edx,%eax
c0104c05:	c1 e0 02             	shl    $0x2,%eax
c0104c08:	01 d0                	add    %edx,%eax
c0104c0a:	c1 e0 02             	shl    $0x2,%eax
c0104c0d:	05 84 af 11 c0       	add    $0xc011af84,%eax
c0104c12:	8b 00                	mov    (%eax),%eax
c0104c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int longest = bu[index].longest;
c0104c17:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c1a:	89 d0                	mov    %edx,%eax
c0104c1c:	c1 e0 02             	shl    $0x2,%eax
c0104c1f:	01 d0                	add    %edx,%eax
c0104c21:	c1 e0 02             	shl    $0x2,%eax
c0104c24:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104c29:	8b 00                	mov    (%eax),%eax
c0104c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	bool free =bu[index].free;
c0104c2e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c31:	89 d0                	mov    %edx,%eax
c0104c33:	c1 e0 02             	shl    $0x2,%eax
c0104c36:	01 d0                	add    %edx,%eax
c0104c38:	c1 e0 02             	shl    $0x2,%eax
c0104c3b:	05 8c af 11 c0       	add    $0xc011af8c,%eax
c0104c40:	8b 00                	mov    (%eax),%eax
c0104c42:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (free==1)
c0104c45:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
c0104c49:	75 3a                	jne    c0104c85 <freetree+0xa2>
	{
		bu[index].longest=r-l+1;
c0104c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c4e:	2b 45 f4             	sub    -0xc(%ebp),%eax
c0104c51:	40                   	inc    %eax
c0104c52:	89 c1                	mov    %eax,%ecx
c0104c54:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c57:	89 d0                	mov    %edx,%eax
c0104c59:	c1 e0 02             	shl    $0x2,%eax
c0104c5c:	01 d0                	add    %edx,%eax
c0104c5e:	c1 e0 02             	shl    $0x2,%eax
c0104c61:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104c66:	89 08                	mov    %ecx,(%eax)
		bu[index].free=0;
c0104c68:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c6b:	89 d0                	mov    %edx,%eax
c0104c6d:	c1 e0 02             	shl    $0x2,%eax
c0104c70:	01 d0                	add    %edx,%eax
c0104c72:	c1 e0 02             	shl    $0x2,%eax
c0104c75:	05 8c af 11 c0       	add    $0xc011af8c,%eax
c0104c7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return;
c0104c80:	e9 db 00 00 00       	jmp    c0104d60 <freetree+0x17d>
	}
	int mid=(l+r)>>1;
c0104c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c8b:	01 d0                	add    %edx,%eax
c0104c8d:	d1 f8                	sar    %eax
c0104c8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (mid>=pos) freetree(LEFT_LEAF(index),pos,size);
c0104c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c95:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104c98:	7c 20                	jl     c0104cba <freetree+0xd7>
c0104c9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9d:	01 c0                	add    %eax,%eax
c0104c9f:	8d 50 01             	lea    0x1(%eax),%edx
c0104ca2:	8b 45 10             	mov    0x10(%ebp),%eax
c0104ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104cac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104cb0:	89 14 24             	mov    %edx,(%esp)
c0104cb3:	e8 2b ff ff ff       	call   c0104be3 <freetree>
c0104cb8:	eb 1d                	jmp    c0104cd7 <freetree+0xf4>
	else
		freetree(RIGHT_LEAF(index),pos,size);
c0104cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cbd:	40                   	inc    %eax
c0104cbe:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0104cc1:	8b 45 10             	mov    0x10(%ebp),%eax
c0104cc4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ccf:	89 14 24             	mov    %edx,(%esp)
c0104cd2:	e8 0c ff ff ff       	call   c0104be3 <freetree>
	int l1 = bu[LEFT_LEAF(index)].longest;
c0104cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cda:	01 c0                	add    %eax,%eax
c0104cdc:	8d 50 01             	lea    0x1(%eax),%edx
c0104cdf:	89 d0                	mov    %edx,%eax
c0104ce1:	c1 e0 02             	shl    $0x2,%eax
c0104ce4:	01 d0                	add    %edx,%eax
c0104ce6:	c1 e0 02             	shl    $0x2,%eax
c0104ce9:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104cee:	8b 00                	mov    (%eax),%eax
c0104cf0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int r1 = bu[RIGHT_LEAF(index)].longest;
c0104cf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cf6:	40                   	inc    %eax
c0104cf7:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0104cfa:	89 d0                	mov    %edx,%eax
c0104cfc:	c1 e0 02             	shl    $0x2,%eax
c0104cff:	01 d0                	add    %edx,%eax
c0104d01:	c1 e0 02             	shl    $0x2,%eax
c0104d04:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104d09:	8b 00                	mov    (%eax),%eax
c0104d0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	//cprintf("%d,%d,%d\n",l1,r1,r-l+1);
	if (l1+r1==r-l+1) bu[index].longest =r-l+1;
c0104d0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104d11:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d14:	01 c2                	add    %eax,%edx
c0104d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d19:	2b 45 f4             	sub    -0xc(%ebp),%eax
c0104d1c:	40                   	inc    %eax
c0104d1d:	39 c2                	cmp    %eax,%edx
c0104d1f:	75 1f                	jne    c0104d40 <freetree+0x15d>
c0104d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d24:	2b 45 f4             	sub    -0xc(%ebp),%eax
c0104d27:	40                   	inc    %eax
c0104d28:	89 c1                	mov    %eax,%ecx
c0104d2a:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d2d:	89 d0                	mov    %edx,%eax
c0104d2f:	c1 e0 02             	shl    $0x2,%eax
c0104d32:	01 d0                	add    %edx,%eax
c0104d34:	c1 e0 02             	shl    $0x2,%eax
c0104d37:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104d3c:	89 08                	mov    %ecx,(%eax)
c0104d3e:	eb 20                	jmp    c0104d60 <freetree+0x17d>
	else
		bu[index].longest = MAX(l1,r1);
c0104d40:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d43:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104d46:	0f 4d 45 dc          	cmovge -0x24(%ebp),%eax
c0104d4a:	89 c1                	mov    %eax,%ecx
c0104d4c:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d4f:	89 d0                	mov    %edx,%eax
c0104d51:	c1 e0 02             	shl    $0x2,%eax
c0104d54:	01 d0                	add    %edx,%eax
c0104d56:	c1 e0 02             	shl    $0x2,%eax
c0104d59:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104d5e:	89 08                	mov    %ecx,(%eax)
}
c0104d60:	c9                   	leave  
c0104d61:	c3                   	ret    

c0104d62 <Buddy_free_pages>:

// 释放空间 
static void
Buddy_free_pages(struct Page *base, size_t n) {
c0104d62:	55                   	push   %ebp
c0104d63:	89 e5                	mov    %esp,%ebp
c0104d65:	83 ec 28             	sub    $0x28,%esp
	cprintf("----free pages:%d %x\n",n,base,nr_free);
c0104d68:	a1 90 af 25 c0       	mov    0xc025af90,%eax
c0104d6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d71:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d74:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104d78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d7f:	c7 04 24 ae 69 10 c0 	movl   $0xc01069ae,(%esp)
c0104d86:	e8 17 b5 ff ff       	call   c01002a2 <cprintf>
    assert(n > 0);
c0104d8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104d8f:	75 24                	jne    c0104db5 <Buddy_free_pages+0x53>
c0104d91:	c7 44 24 0c fc 68 10 	movl   $0xc01068fc,0xc(%esp)
c0104d98:	c0 
c0104d99:	c7 44 24 08 02 69 10 	movl   $0xc0106902,0x8(%esp)
c0104da0:	c0 
c0104da1:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0104da8:	00 
c0104da9:	c7 04 24 17 69 10 c0 	movl   $0xc0106917,(%esp)
c0104db0:	e8 44 b6 ff ff       	call   c01003f9 <__panic>
    assert(PageReserved(base));
c0104db5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104db8:	83 c0 04             	add    $0x4,%eax
c0104dbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104dc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104dcb:	0f a3 10             	bt     %edx,(%eax)
c0104dce:	19 c0                	sbb    %eax,%eax
c0104dd0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0104dd3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104dd7:	0f 95 c0             	setne  %al
c0104dda:	0f b6 c0             	movzbl %al,%eax
c0104ddd:	85 c0                	test   %eax,%eax
c0104ddf:	75 24                	jne    c0104e05 <Buddy_free_pages+0xa3>
c0104de1:	c7 44 24 0c c4 69 10 	movl   $0xc01069c4,0xc(%esp)
c0104de8:	c0 
c0104de9:	c7 44 24 08 02 69 10 	movl   $0xc0106902,0x8(%esp)
c0104df0:	c0 
c0104df1:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0104df8:	00 
c0104df9:	c7 04 24 17 69 10 c0 	movl   $0xc0106917,(%esp)
c0104e00:	e8 f4 b5 ff ff       	call   c01003f9 <__panic>
	int tmp = base - treebase;
c0104e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e08:	8b 15 80 af 25 c0    	mov    0xc025af80,%edx
c0104e0e:	29 d0                	sub    %edx,%eax
c0104e10:	c1 f8 02             	sar    $0x2,%eax
c0104e13:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
c0104e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//cprintf("tmp:%d\n",tmp);
	freetree(0,tmp,n);
c0104e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e1f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104e2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104e31:	e8 ad fd ff ff       	call   c0104be3 <freetree>
	set_page_ref(base, 0);
c0104e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104e3d:	00 
c0104e3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e41:	89 04 24             	mov    %eax,(%esp)
c0104e44:	e8 51 f7 ff ff       	call   c010459a <set_page_ref>
    nr_free += n;
c0104e49:	8b 15 90 af 25 c0    	mov    0xc025af90,%edx
c0104e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e52:	01 d0                	add    %edx,%eax
c0104e54:	a3 90 af 25 c0       	mov    %eax,0xc025af90
    return ;
c0104e59:	90                   	nop
}
c0104e5a:	c9                   	leave  
c0104e5b:	c3                   	ret    

c0104e5c <Buddy_nr_free_pages>:

static size_t
Buddy_nr_free_pages(void) {
c0104e5c:	55                   	push   %ebp
c0104e5d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104e5f:	a1 90 af 25 c0       	mov    0xc025af90,%eax
}
c0104e64:	5d                   	pop    %ebp
c0104e65:	c3                   	ret    

c0104e66 <showpage_tree>:

// 输出树的信息
static void showpage_tree(int index)
{
c0104e66:	55                   	push   %ebp
c0104e67:	89 e5                	mov    %esp,%ebp
c0104e69:	83 ec 28             	sub    $0x28,%esp
	int l = bu[index].left;
c0104e6c:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e6f:	89 d0                	mov    %edx,%eax
c0104e71:	c1 e0 02             	shl    $0x2,%eax
c0104e74:	01 d0                	add    %edx,%eax
c0104e76:	c1 e0 02             	shl    $0x2,%eax
c0104e79:	05 80 af 11 c0       	add    $0xc011af80,%eax
c0104e7e:	8b 00                	mov    (%eax),%eax
c0104e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int r = bu[index].right;
c0104e83:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e86:	89 d0                	mov    %edx,%eax
c0104e88:	c1 e0 02             	shl    $0x2,%eax
c0104e8b:	01 d0                	add    %edx,%eax
c0104e8d:	c1 e0 02             	shl    $0x2,%eax
c0104e90:	05 84 af 11 c0       	add    $0xc011af84,%eax
c0104e95:	8b 00                	mov    (%eax),%eax
c0104e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int longest = bu[index].longest;
c0104e9a:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e9d:	89 d0                	mov    %edx,%eax
c0104e9f:	c1 e0 02             	shl    $0x2,%eax
c0104ea2:	01 d0                	add    %edx,%eax
c0104ea4:	c1 e0 02             	shl    $0x2,%eax
c0104ea7:	05 88 af 11 c0       	add    $0xc011af88,%eax
c0104eac:	8b 00                	mov    (%eax),%eax
c0104eae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	bool free=bu[index].free;
c0104eb1:	8b 55 08             	mov    0x8(%ebp),%edx
c0104eb4:	89 d0                	mov    %edx,%eax
c0104eb6:	c1 e0 02             	shl    $0x2,%eax
c0104eb9:	01 d0                	add    %edx,%eax
c0104ebb:	c1 e0 02             	shl    $0x2,%eax
c0104ebe:	05 8c af 11 c0       	add    $0xc011af8c,%eax
c0104ec3:	8b 00                	mov    (%eax),%eax
c0104ec5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (r-l+1==longest)
c0104ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ecb:	2b 45 f4             	sub    -0xc(%ebp),%eax
c0104ece:	40                   	inc    %eax
c0104ecf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104ed2:	75 23                	jne    c0104ef7 <showpage_tree+0x91>
	{
		cprintf("[%d,%d] is free, longest =%d\n",l,r,longest);
c0104ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ed7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ede:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ee9:	c7 04 24 d7 69 10 c0 	movl   $0xc01069d7,(%esp)
c0104ef0:	e8 ad b3 ff ff       	call   c01002a2 <cprintf>
		return;
c0104ef5:	eb 49                	jmp    c0104f40 <showpage_tree+0xda>
	}
	if (free==1)
c0104ef7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
c0104efb:	75 27                	jne    c0104f24 <showpage_tree+0xbe>
	{
		cprintf("[%d,%d] is reserved, longest =%d\n",l,r,r-l+1);
c0104efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f00:	2b 45 f4             	sub    -0xc(%ebp),%eax
c0104f03:	40                   	inc    %eax
c0104f04:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f0b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f16:	c7 04 24 f8 69 10 c0 	movl   $0xc01069f8,(%esp)
c0104f1d:	e8 80 b3 ff ff       	call   c01002a2 <cprintf>
		return;
c0104f22:	eb 1c                	jmp    c0104f40 <showpage_tree+0xda>
	}
	showpage_tree(LEFT_LEAF(index));
c0104f24:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f27:	01 c0                	add    %eax,%eax
c0104f29:	40                   	inc    %eax
c0104f2a:	89 04 24             	mov    %eax,(%esp)
c0104f2d:	e8 34 ff ff ff       	call   c0104e66 <showpage_tree>
	showpage_tree(RIGHT_LEAF(index));
c0104f32:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f35:	40                   	inc    %eax
c0104f36:	01 c0                	add    %eax,%eax
c0104f38:	89 04 24             	mov    %eax,(%esp)
c0104f3b:	e8 26 ff ff ff       	call   c0104e66 <showpage_tree>
		
}
c0104f40:	c9                   	leave  
c0104f41:	c3                   	ret    

c0104f42 <showpage>:
static void showpage()
{
c0104f42:	55                   	push   %ebp
c0104f43:	89 e5                	mov    %esp,%ebp
c0104f45:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n------------------\n");
c0104f48:	c7 04 24 1a 6a 10 c0 	movl   $0xc0106a1a,(%esp)
c0104f4f:	e8 4e b3 ff ff       	call   c01002a2 <cprintf>
	showpage_tree(0);
c0104f54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104f5b:	e8 06 ff ff ff       	call   c0104e66 <showpage_tree>
	cprintf("------------------\n\n");
c0104f60:	c7 04 24 2f 6a 10 c0 	movl   $0xc0106a2f,(%esp)
c0104f67:	e8 36 b3 ff ff       	call   c01002a2 <cprintf>
	
}
c0104f6c:	90                   	nop
c0104f6d:	c9                   	leave  
c0104f6e:	c3                   	ret    

c0104f6f <Buddy_check>:
static void
Buddy_check(void) {
c0104f6f:	55                   	push   %ebp
c0104f70:	89 e5                	mov    %esp,%ebp
c0104f72:	83 ec 28             	sub    $0x28,%esp
	showpage();
c0104f75:	e8 c8 ff ff ff       	call   c0104f42 <showpage>
	struct Page *p0 = alloc_pages(5);
c0104f7a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104f81:	e8 66 df ff ff       	call   c0102eec <alloc_pages>
c0104f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct Page *p1 = alloc_pages(120);
c0104f89:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0104f90:	e8 57 df ff ff       	call   c0102eec <alloc_pages>
c0104f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct Page *p2 = alloc_pages(100);
c0104f98:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
c0104f9f:	e8 48 df ff ff       	call   c0102eec <alloc_pages>
c0104fa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	showpage();
c0104fa7:	e8 96 ff ff ff       	call   c0104f42 <showpage>
	free_pages(p1,120);
c0104fac:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0104fb3:	00 
c0104fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fb7:	89 04 24             	mov    %eax,(%esp)
c0104fba:	e8 65 df ff ff       	call   c0102f24 <free_pages>
	free_pages(p2,100);
c0104fbf:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0104fc6:	00 
c0104fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fca:	89 04 24             	mov    %eax,(%esp)
c0104fcd:	e8 52 df ff ff       	call   c0102f24 <free_pages>
	showpage();
c0104fd2:	e8 6b ff ff ff       	call   c0104f42 <showpage>
	struct Page *p3 = alloc_pages(5000);
c0104fd7:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
c0104fde:	e8 09 df ff ff       	call   c0102eec <alloc_pages>
c0104fe3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	showpage();
c0104fe6:	e8 57 ff ff ff       	call   c0104f42 <showpage>
	free_pages(p0,5);
c0104feb:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104ff2:	00 
c0104ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ff6:	89 04 24             	mov    %eax,(%esp)
c0104ff9:	e8 26 df ff ff       	call   c0102f24 <free_pages>
    showpage();
c0104ffe:	e8 3f ff ff ff       	call   c0104f42 <showpage>
	free_pages(p3,5000);
c0105003:	c7 44 24 04 88 13 00 	movl   $0x1388,0x4(%esp)
c010500a:	00 
c010500b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010500e:	89 04 24             	mov    %eax,(%esp)
c0105011:	e8 0e df ff ff       	call   c0102f24 <free_pages>
	showpage();
c0105016:	e8 27 ff ff ff       	call   c0104f42 <showpage>
}
c010501b:	90                   	nop
c010501c:	c9                   	leave  
c010501d:	c3                   	ret    

c010501e <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010501e:	55                   	push   %ebp
c010501f:	89 e5                	mov    %esp,%ebp
c0105021:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105024:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010502b:	eb 03                	jmp    c0105030 <strlen+0x12>
        cnt ++;
c010502d:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105030:	8b 45 08             	mov    0x8(%ebp),%eax
c0105033:	8d 50 01             	lea    0x1(%eax),%edx
c0105036:	89 55 08             	mov    %edx,0x8(%ebp)
c0105039:	0f b6 00             	movzbl (%eax),%eax
c010503c:	84 c0                	test   %al,%al
c010503e:	75 ed                	jne    c010502d <strlen+0xf>
    }
    return cnt;
c0105040:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105043:	c9                   	leave  
c0105044:	c3                   	ret    

c0105045 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105045:	55                   	push   %ebp
c0105046:	89 e5                	mov    %esp,%ebp
c0105048:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010504b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105052:	eb 03                	jmp    c0105057 <strnlen+0x12>
        cnt ++;
c0105054:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105057:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010505a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010505d:	73 10                	jae    c010506f <strnlen+0x2a>
c010505f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105062:	8d 50 01             	lea    0x1(%eax),%edx
c0105065:	89 55 08             	mov    %edx,0x8(%ebp)
c0105068:	0f b6 00             	movzbl (%eax),%eax
c010506b:	84 c0                	test   %al,%al
c010506d:	75 e5                	jne    c0105054 <strnlen+0xf>
    }
    return cnt;
c010506f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105072:	c9                   	leave  
c0105073:	c3                   	ret    

c0105074 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105074:	55                   	push   %ebp
c0105075:	89 e5                	mov    %esp,%ebp
c0105077:	57                   	push   %edi
c0105078:	56                   	push   %esi
c0105079:	83 ec 20             	sub    $0x20,%esp
c010507c:	8b 45 08             	mov    0x8(%ebp),%eax
c010507f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105082:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105085:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105088:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010508b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010508e:	89 d1                	mov    %edx,%ecx
c0105090:	89 c2                	mov    %eax,%edx
c0105092:	89 ce                	mov    %ecx,%esi
c0105094:	89 d7                	mov    %edx,%edi
c0105096:	ac                   	lods   %ds:(%esi),%al
c0105097:	aa                   	stos   %al,%es:(%edi)
c0105098:	84 c0                	test   %al,%al
c010509a:	75 fa                	jne    c0105096 <strcpy+0x22>
c010509c:	89 fa                	mov    %edi,%edx
c010509e:	89 f1                	mov    %esi,%ecx
c01050a0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01050a3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01050a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01050a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c01050ac:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01050ad:	83 c4 20             	add    $0x20,%esp
c01050b0:	5e                   	pop    %esi
c01050b1:	5f                   	pop    %edi
c01050b2:	5d                   	pop    %ebp
c01050b3:	c3                   	ret    

c01050b4 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01050b4:	55                   	push   %ebp
c01050b5:	89 e5                	mov    %esp,%ebp
c01050b7:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01050ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01050bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01050c0:	eb 1e                	jmp    c01050e0 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c01050c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050c5:	0f b6 10             	movzbl (%eax),%edx
c01050c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050cb:	88 10                	mov    %dl,(%eax)
c01050cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050d0:	0f b6 00             	movzbl (%eax),%eax
c01050d3:	84 c0                	test   %al,%al
c01050d5:	74 03                	je     c01050da <strncpy+0x26>
            src ++;
c01050d7:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01050da:	ff 45 fc             	incl   -0x4(%ebp)
c01050dd:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01050e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01050e4:	75 dc                	jne    c01050c2 <strncpy+0xe>
    }
    return dst;
c01050e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01050e9:	c9                   	leave  
c01050ea:	c3                   	ret    

c01050eb <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01050eb:	55                   	push   %ebp
c01050ec:	89 e5                	mov    %esp,%ebp
c01050ee:	57                   	push   %edi
c01050ef:	56                   	push   %esi
c01050f0:	83 ec 20             	sub    $0x20,%esp
c01050f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01050f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01050ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105102:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105105:	89 d1                	mov    %edx,%ecx
c0105107:	89 c2                	mov    %eax,%edx
c0105109:	89 ce                	mov    %ecx,%esi
c010510b:	89 d7                	mov    %edx,%edi
c010510d:	ac                   	lods   %ds:(%esi),%al
c010510e:	ae                   	scas   %es:(%edi),%al
c010510f:	75 08                	jne    c0105119 <strcmp+0x2e>
c0105111:	84 c0                	test   %al,%al
c0105113:	75 f8                	jne    c010510d <strcmp+0x22>
c0105115:	31 c0                	xor    %eax,%eax
c0105117:	eb 04                	jmp    c010511d <strcmp+0x32>
c0105119:	19 c0                	sbb    %eax,%eax
c010511b:	0c 01                	or     $0x1,%al
c010511d:	89 fa                	mov    %edi,%edx
c010511f:	89 f1                	mov    %esi,%ecx
c0105121:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105124:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105127:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c010512a:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c010512d:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010512e:	83 c4 20             	add    $0x20,%esp
c0105131:	5e                   	pop    %esi
c0105132:	5f                   	pop    %edi
c0105133:	5d                   	pop    %ebp
c0105134:	c3                   	ret    

c0105135 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105135:	55                   	push   %ebp
c0105136:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105138:	eb 09                	jmp    c0105143 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c010513a:	ff 4d 10             	decl   0x10(%ebp)
c010513d:	ff 45 08             	incl   0x8(%ebp)
c0105140:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105143:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105147:	74 1a                	je     c0105163 <strncmp+0x2e>
c0105149:	8b 45 08             	mov    0x8(%ebp),%eax
c010514c:	0f b6 00             	movzbl (%eax),%eax
c010514f:	84 c0                	test   %al,%al
c0105151:	74 10                	je     c0105163 <strncmp+0x2e>
c0105153:	8b 45 08             	mov    0x8(%ebp),%eax
c0105156:	0f b6 10             	movzbl (%eax),%edx
c0105159:	8b 45 0c             	mov    0xc(%ebp),%eax
c010515c:	0f b6 00             	movzbl (%eax),%eax
c010515f:	38 c2                	cmp    %al,%dl
c0105161:	74 d7                	je     c010513a <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105163:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105167:	74 18                	je     c0105181 <strncmp+0x4c>
c0105169:	8b 45 08             	mov    0x8(%ebp),%eax
c010516c:	0f b6 00             	movzbl (%eax),%eax
c010516f:	0f b6 d0             	movzbl %al,%edx
c0105172:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105175:	0f b6 00             	movzbl (%eax),%eax
c0105178:	0f b6 c0             	movzbl %al,%eax
c010517b:	29 c2                	sub    %eax,%edx
c010517d:	89 d0                	mov    %edx,%eax
c010517f:	eb 05                	jmp    c0105186 <strncmp+0x51>
c0105181:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105186:	5d                   	pop    %ebp
c0105187:	c3                   	ret    

c0105188 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105188:	55                   	push   %ebp
c0105189:	89 e5                	mov    %esp,%ebp
c010518b:	83 ec 04             	sub    $0x4,%esp
c010518e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105191:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105194:	eb 13                	jmp    c01051a9 <strchr+0x21>
        if (*s == c) {
c0105196:	8b 45 08             	mov    0x8(%ebp),%eax
c0105199:	0f b6 00             	movzbl (%eax),%eax
c010519c:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010519f:	75 05                	jne    c01051a6 <strchr+0x1e>
            return (char *)s;
c01051a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a4:	eb 12                	jmp    c01051b8 <strchr+0x30>
        }
        s ++;
c01051a6:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01051a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ac:	0f b6 00             	movzbl (%eax),%eax
c01051af:	84 c0                	test   %al,%al
c01051b1:	75 e3                	jne    c0105196 <strchr+0xe>
    }
    return NULL;
c01051b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01051b8:	c9                   	leave  
c01051b9:	c3                   	ret    

c01051ba <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01051ba:	55                   	push   %ebp
c01051bb:	89 e5                	mov    %esp,%ebp
c01051bd:	83 ec 04             	sub    $0x4,%esp
c01051c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051c3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01051c6:	eb 0e                	jmp    c01051d6 <strfind+0x1c>
        if (*s == c) {
c01051c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01051cb:	0f b6 00             	movzbl (%eax),%eax
c01051ce:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01051d1:	74 0f                	je     c01051e2 <strfind+0x28>
            break;
        }
        s ++;
c01051d3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01051d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d9:	0f b6 00             	movzbl (%eax),%eax
c01051dc:	84 c0                	test   %al,%al
c01051de:	75 e8                	jne    c01051c8 <strfind+0xe>
c01051e0:	eb 01                	jmp    c01051e3 <strfind+0x29>
            break;
c01051e2:	90                   	nop
    }
    return (char *)s;
c01051e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01051e6:	c9                   	leave  
c01051e7:	c3                   	ret    

c01051e8 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01051e8:	55                   	push   %ebp
c01051e9:	89 e5                	mov    %esp,%ebp
c01051eb:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01051ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01051f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01051fc:	eb 03                	jmp    c0105201 <strtol+0x19>
        s ++;
c01051fe:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105201:	8b 45 08             	mov    0x8(%ebp),%eax
c0105204:	0f b6 00             	movzbl (%eax),%eax
c0105207:	3c 20                	cmp    $0x20,%al
c0105209:	74 f3                	je     c01051fe <strtol+0x16>
c010520b:	8b 45 08             	mov    0x8(%ebp),%eax
c010520e:	0f b6 00             	movzbl (%eax),%eax
c0105211:	3c 09                	cmp    $0x9,%al
c0105213:	74 e9                	je     c01051fe <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105215:	8b 45 08             	mov    0x8(%ebp),%eax
c0105218:	0f b6 00             	movzbl (%eax),%eax
c010521b:	3c 2b                	cmp    $0x2b,%al
c010521d:	75 05                	jne    c0105224 <strtol+0x3c>
        s ++;
c010521f:	ff 45 08             	incl   0x8(%ebp)
c0105222:	eb 14                	jmp    c0105238 <strtol+0x50>
    }
    else if (*s == '-') {
c0105224:	8b 45 08             	mov    0x8(%ebp),%eax
c0105227:	0f b6 00             	movzbl (%eax),%eax
c010522a:	3c 2d                	cmp    $0x2d,%al
c010522c:	75 0a                	jne    c0105238 <strtol+0x50>
        s ++, neg = 1;
c010522e:	ff 45 08             	incl   0x8(%ebp)
c0105231:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105238:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010523c:	74 06                	je     c0105244 <strtol+0x5c>
c010523e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105242:	75 22                	jne    c0105266 <strtol+0x7e>
c0105244:	8b 45 08             	mov    0x8(%ebp),%eax
c0105247:	0f b6 00             	movzbl (%eax),%eax
c010524a:	3c 30                	cmp    $0x30,%al
c010524c:	75 18                	jne    c0105266 <strtol+0x7e>
c010524e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105251:	40                   	inc    %eax
c0105252:	0f b6 00             	movzbl (%eax),%eax
c0105255:	3c 78                	cmp    $0x78,%al
c0105257:	75 0d                	jne    c0105266 <strtol+0x7e>
        s += 2, base = 16;
c0105259:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010525d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105264:	eb 29                	jmp    c010528f <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105266:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010526a:	75 16                	jne    c0105282 <strtol+0x9a>
c010526c:	8b 45 08             	mov    0x8(%ebp),%eax
c010526f:	0f b6 00             	movzbl (%eax),%eax
c0105272:	3c 30                	cmp    $0x30,%al
c0105274:	75 0c                	jne    c0105282 <strtol+0x9a>
        s ++, base = 8;
c0105276:	ff 45 08             	incl   0x8(%ebp)
c0105279:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105280:	eb 0d                	jmp    c010528f <strtol+0xa7>
    }
    else if (base == 0) {
c0105282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105286:	75 07                	jne    c010528f <strtol+0xa7>
        base = 10;
c0105288:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010528f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105292:	0f b6 00             	movzbl (%eax),%eax
c0105295:	3c 2f                	cmp    $0x2f,%al
c0105297:	7e 1b                	jle    c01052b4 <strtol+0xcc>
c0105299:	8b 45 08             	mov    0x8(%ebp),%eax
c010529c:	0f b6 00             	movzbl (%eax),%eax
c010529f:	3c 39                	cmp    $0x39,%al
c01052a1:	7f 11                	jg     c01052b4 <strtol+0xcc>
            dig = *s - '0';
c01052a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a6:	0f b6 00             	movzbl (%eax),%eax
c01052a9:	0f be c0             	movsbl %al,%eax
c01052ac:	83 e8 30             	sub    $0x30,%eax
c01052af:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052b2:	eb 48                	jmp    c01052fc <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01052b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01052b7:	0f b6 00             	movzbl (%eax),%eax
c01052ba:	3c 60                	cmp    $0x60,%al
c01052bc:	7e 1b                	jle    c01052d9 <strtol+0xf1>
c01052be:	8b 45 08             	mov    0x8(%ebp),%eax
c01052c1:	0f b6 00             	movzbl (%eax),%eax
c01052c4:	3c 7a                	cmp    $0x7a,%al
c01052c6:	7f 11                	jg     c01052d9 <strtol+0xf1>
            dig = *s - 'a' + 10;
c01052c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01052cb:	0f b6 00             	movzbl (%eax),%eax
c01052ce:	0f be c0             	movsbl %al,%eax
c01052d1:	83 e8 57             	sub    $0x57,%eax
c01052d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052d7:	eb 23                	jmp    c01052fc <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01052d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01052dc:	0f b6 00             	movzbl (%eax),%eax
c01052df:	3c 40                	cmp    $0x40,%al
c01052e1:	7e 3b                	jle    c010531e <strtol+0x136>
c01052e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052e6:	0f b6 00             	movzbl (%eax),%eax
c01052e9:	3c 5a                	cmp    $0x5a,%al
c01052eb:	7f 31                	jg     c010531e <strtol+0x136>
            dig = *s - 'A' + 10;
c01052ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01052f0:	0f b6 00             	movzbl (%eax),%eax
c01052f3:	0f be c0             	movsbl %al,%eax
c01052f6:	83 e8 37             	sub    $0x37,%eax
c01052f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01052fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052ff:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105302:	7d 19                	jge    c010531d <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105304:	ff 45 08             	incl   0x8(%ebp)
c0105307:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010530a:	0f af 45 10          	imul   0x10(%ebp),%eax
c010530e:	89 c2                	mov    %eax,%edx
c0105310:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105313:	01 d0                	add    %edx,%eax
c0105315:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105318:	e9 72 ff ff ff       	jmp    c010528f <strtol+0xa7>
            break;
c010531d:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c010531e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105322:	74 08                	je     c010532c <strtol+0x144>
        *endptr = (char *) s;
c0105324:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105327:	8b 55 08             	mov    0x8(%ebp),%edx
c010532a:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010532c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105330:	74 07                	je     c0105339 <strtol+0x151>
c0105332:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105335:	f7 d8                	neg    %eax
c0105337:	eb 03                	jmp    c010533c <strtol+0x154>
c0105339:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010533c:	c9                   	leave  
c010533d:	c3                   	ret    

c010533e <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010533e:	55                   	push   %ebp
c010533f:	89 e5                	mov    %esp,%ebp
c0105341:	57                   	push   %edi
c0105342:	83 ec 24             	sub    $0x24,%esp
c0105345:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105348:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010534b:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010534f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105352:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105355:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105358:	8b 45 10             	mov    0x10(%ebp),%eax
c010535b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010535e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105361:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105365:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105368:	89 d7                	mov    %edx,%edi
c010536a:	f3 aa                	rep stos %al,%es:(%edi)
c010536c:	89 fa                	mov    %edi,%edx
c010536e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105371:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105374:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105377:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105378:	83 c4 24             	add    $0x24,%esp
c010537b:	5f                   	pop    %edi
c010537c:	5d                   	pop    %ebp
c010537d:	c3                   	ret    

c010537e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010537e:	55                   	push   %ebp
c010537f:	89 e5                	mov    %esp,%ebp
c0105381:	57                   	push   %edi
c0105382:	56                   	push   %esi
c0105383:	53                   	push   %ebx
c0105384:	83 ec 30             	sub    $0x30,%esp
c0105387:	8b 45 08             	mov    0x8(%ebp),%eax
c010538a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010538d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105390:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105393:	8b 45 10             	mov    0x10(%ebp),%eax
c0105396:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105399:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010539c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010539f:	73 42                	jae    c01053e3 <memmove+0x65>
c01053a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01053b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053b6:	c1 e8 02             	shr    $0x2,%eax
c01053b9:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01053bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01053be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053c1:	89 d7                	mov    %edx,%edi
c01053c3:	89 c6                	mov    %eax,%esi
c01053c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01053c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01053ca:	83 e1 03             	and    $0x3,%ecx
c01053cd:	74 02                	je     c01053d1 <memmove+0x53>
c01053cf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01053d1:	89 f0                	mov    %esi,%eax
c01053d3:	89 fa                	mov    %edi,%edx
c01053d5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01053d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01053db:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01053de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01053e1:	eb 36                	jmp    c0105419 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01053e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053e6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01053e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053ec:	01 c2                	add    %eax,%edx
c01053ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053f1:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01053f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053f7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01053fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053fd:	89 c1                	mov    %eax,%ecx
c01053ff:	89 d8                	mov    %ebx,%eax
c0105401:	89 d6                	mov    %edx,%esi
c0105403:	89 c7                	mov    %eax,%edi
c0105405:	fd                   	std    
c0105406:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105408:	fc                   	cld    
c0105409:	89 f8                	mov    %edi,%eax
c010540b:	89 f2                	mov    %esi,%edx
c010540d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105410:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105413:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105416:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105419:	83 c4 30             	add    $0x30,%esp
c010541c:	5b                   	pop    %ebx
c010541d:	5e                   	pop    %esi
c010541e:	5f                   	pop    %edi
c010541f:	5d                   	pop    %ebp
c0105420:	c3                   	ret    

c0105421 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105421:	55                   	push   %ebp
c0105422:	89 e5                	mov    %esp,%ebp
c0105424:	57                   	push   %edi
c0105425:	56                   	push   %esi
c0105426:	83 ec 20             	sub    $0x20,%esp
c0105429:	8b 45 08             	mov    0x8(%ebp),%eax
c010542c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010542f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105432:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105435:	8b 45 10             	mov    0x10(%ebp),%eax
c0105438:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010543b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010543e:	c1 e8 02             	shr    $0x2,%eax
c0105441:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105443:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105449:	89 d7                	mov    %edx,%edi
c010544b:	89 c6                	mov    %eax,%esi
c010544d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010544f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105452:	83 e1 03             	and    $0x3,%ecx
c0105455:	74 02                	je     c0105459 <memcpy+0x38>
c0105457:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105459:	89 f0                	mov    %esi,%eax
c010545b:	89 fa                	mov    %edi,%edx
c010545d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105460:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105463:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105466:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105469:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010546a:	83 c4 20             	add    $0x20,%esp
c010546d:	5e                   	pop    %esi
c010546e:	5f                   	pop    %edi
c010546f:	5d                   	pop    %ebp
c0105470:	c3                   	ret    

c0105471 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105471:	55                   	push   %ebp
c0105472:	89 e5                	mov    %esp,%ebp
c0105474:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105477:	8b 45 08             	mov    0x8(%ebp),%eax
c010547a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010547d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105480:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105483:	eb 2e                	jmp    c01054b3 <memcmp+0x42>
        if (*s1 != *s2) {
c0105485:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105488:	0f b6 10             	movzbl (%eax),%edx
c010548b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010548e:	0f b6 00             	movzbl (%eax),%eax
c0105491:	38 c2                	cmp    %al,%dl
c0105493:	74 18                	je     c01054ad <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105495:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105498:	0f b6 00             	movzbl (%eax),%eax
c010549b:	0f b6 d0             	movzbl %al,%edx
c010549e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01054a1:	0f b6 00             	movzbl (%eax),%eax
c01054a4:	0f b6 c0             	movzbl %al,%eax
c01054a7:	29 c2                	sub    %eax,%edx
c01054a9:	89 d0                	mov    %edx,%eax
c01054ab:	eb 18                	jmp    c01054c5 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c01054ad:	ff 45 fc             	incl   -0x4(%ebp)
c01054b0:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c01054b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01054b6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054b9:	89 55 10             	mov    %edx,0x10(%ebp)
c01054bc:	85 c0                	test   %eax,%eax
c01054be:	75 c5                	jne    c0105485 <memcmp+0x14>
    }
    return 0;
c01054c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01054c5:	c9                   	leave  
c01054c6:	c3                   	ret    

c01054c7 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01054c7:	55                   	push   %ebp
c01054c8:	89 e5                	mov    %esp,%ebp
c01054ca:	83 ec 58             	sub    $0x58,%esp
c01054cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01054d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01054d3:	8b 45 14             	mov    0x14(%ebp),%eax
c01054d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01054d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054df:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01054e5:	8b 45 18             	mov    0x18(%ebp),%eax
c01054e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054f4:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01054f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105501:	74 1c                	je     c010551f <printnum+0x58>
c0105503:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105506:	ba 00 00 00 00       	mov    $0x0,%edx
c010550b:	f7 75 e4             	divl   -0x1c(%ebp)
c010550e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105511:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105514:	ba 00 00 00 00       	mov    $0x0,%edx
c0105519:	f7 75 e4             	divl   -0x1c(%ebp)
c010551c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010551f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105522:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105525:	f7 75 e4             	divl   -0x1c(%ebp)
c0105528:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010552b:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010552e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105531:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105534:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105537:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010553a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010553d:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105540:	8b 45 18             	mov    0x18(%ebp),%eax
c0105543:	ba 00 00 00 00       	mov    $0x0,%edx
c0105548:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010554b:	72 56                	jb     c01055a3 <printnum+0xdc>
c010554d:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105550:	77 05                	ja     c0105557 <printnum+0x90>
c0105552:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105555:	72 4c                	jb     c01055a3 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105557:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010555a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010555d:	8b 45 20             	mov    0x20(%ebp),%eax
c0105560:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105564:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105568:	8b 45 18             	mov    0x18(%ebp),%eax
c010556b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010556f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105572:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105575:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105579:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010557d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105580:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105584:	8b 45 08             	mov    0x8(%ebp),%eax
c0105587:	89 04 24             	mov    %eax,(%esp)
c010558a:	e8 38 ff ff ff       	call   c01054c7 <printnum>
c010558f:	eb 1b                	jmp    c01055ac <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105591:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105594:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105598:	8b 45 20             	mov    0x20(%ebp),%eax
c010559b:	89 04 24             	mov    %eax,(%esp)
c010559e:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a1:	ff d0                	call   *%eax
        while (-- width > 0)
c01055a3:	ff 4d 1c             	decl   0x1c(%ebp)
c01055a6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01055aa:	7f e5                	jg     c0105591 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01055ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01055af:	05 00 6b 10 c0       	add    $0xc0106b00,%eax
c01055b4:	0f b6 00             	movzbl (%eax),%eax
c01055b7:	0f be c0             	movsbl %al,%eax
c01055ba:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055bd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055c1:	89 04 24             	mov    %eax,(%esp)
c01055c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c7:	ff d0                	call   *%eax
}
c01055c9:	90                   	nop
c01055ca:	c9                   	leave  
c01055cb:	c3                   	ret    

c01055cc <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01055cc:	55                   	push   %ebp
c01055cd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055d3:	7e 14                	jle    c01055e9 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01055d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d8:	8b 00                	mov    (%eax),%eax
c01055da:	8d 48 08             	lea    0x8(%eax),%ecx
c01055dd:	8b 55 08             	mov    0x8(%ebp),%edx
c01055e0:	89 0a                	mov    %ecx,(%edx)
c01055e2:	8b 50 04             	mov    0x4(%eax),%edx
c01055e5:	8b 00                	mov    (%eax),%eax
c01055e7:	eb 30                	jmp    c0105619 <getuint+0x4d>
    }
    else if (lflag) {
c01055e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055ed:	74 16                	je     c0105605 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01055ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f2:	8b 00                	mov    (%eax),%eax
c01055f4:	8d 48 04             	lea    0x4(%eax),%ecx
c01055f7:	8b 55 08             	mov    0x8(%ebp),%edx
c01055fa:	89 0a                	mov    %ecx,(%edx)
c01055fc:	8b 00                	mov    (%eax),%eax
c01055fe:	ba 00 00 00 00       	mov    $0x0,%edx
c0105603:	eb 14                	jmp    c0105619 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105605:	8b 45 08             	mov    0x8(%ebp),%eax
c0105608:	8b 00                	mov    (%eax),%eax
c010560a:	8d 48 04             	lea    0x4(%eax),%ecx
c010560d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105610:	89 0a                	mov    %ecx,(%edx)
c0105612:	8b 00                	mov    (%eax),%eax
c0105614:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105619:	5d                   	pop    %ebp
c010561a:	c3                   	ret    

c010561b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010561b:	55                   	push   %ebp
c010561c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010561e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105622:	7e 14                	jle    c0105638 <getint+0x1d>
        return va_arg(*ap, long long);
c0105624:	8b 45 08             	mov    0x8(%ebp),%eax
c0105627:	8b 00                	mov    (%eax),%eax
c0105629:	8d 48 08             	lea    0x8(%eax),%ecx
c010562c:	8b 55 08             	mov    0x8(%ebp),%edx
c010562f:	89 0a                	mov    %ecx,(%edx)
c0105631:	8b 50 04             	mov    0x4(%eax),%edx
c0105634:	8b 00                	mov    (%eax),%eax
c0105636:	eb 28                	jmp    c0105660 <getint+0x45>
    }
    else if (lflag) {
c0105638:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010563c:	74 12                	je     c0105650 <getint+0x35>
        return va_arg(*ap, long);
c010563e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105641:	8b 00                	mov    (%eax),%eax
c0105643:	8d 48 04             	lea    0x4(%eax),%ecx
c0105646:	8b 55 08             	mov    0x8(%ebp),%edx
c0105649:	89 0a                	mov    %ecx,(%edx)
c010564b:	8b 00                	mov    (%eax),%eax
c010564d:	99                   	cltd   
c010564e:	eb 10                	jmp    c0105660 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105650:	8b 45 08             	mov    0x8(%ebp),%eax
c0105653:	8b 00                	mov    (%eax),%eax
c0105655:	8d 48 04             	lea    0x4(%eax),%ecx
c0105658:	8b 55 08             	mov    0x8(%ebp),%edx
c010565b:	89 0a                	mov    %ecx,(%edx)
c010565d:	8b 00                	mov    (%eax),%eax
c010565f:	99                   	cltd   
    }
}
c0105660:	5d                   	pop    %ebp
c0105661:	c3                   	ret    

c0105662 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105662:	55                   	push   %ebp
c0105663:	89 e5                	mov    %esp,%ebp
c0105665:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105668:	8d 45 14             	lea    0x14(%ebp),%eax
c010566b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010566e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105671:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105675:	8b 45 10             	mov    0x10(%ebp),%eax
c0105678:	89 44 24 08          	mov    %eax,0x8(%esp)
c010567c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010567f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105683:	8b 45 08             	mov    0x8(%ebp),%eax
c0105686:	89 04 24             	mov    %eax,(%esp)
c0105689:	e8 03 00 00 00       	call   c0105691 <vprintfmt>
    va_end(ap);
}
c010568e:	90                   	nop
c010568f:	c9                   	leave  
c0105690:	c3                   	ret    

c0105691 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105691:	55                   	push   %ebp
c0105692:	89 e5                	mov    %esp,%ebp
c0105694:	56                   	push   %esi
c0105695:	53                   	push   %ebx
c0105696:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105699:	eb 17                	jmp    c01056b2 <vprintfmt+0x21>
            if (ch == '\0') {
c010569b:	85 db                	test   %ebx,%ebx
c010569d:	0f 84 bf 03 00 00    	je     c0105a62 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c01056a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056aa:	89 1c 24             	mov    %ebx,(%esp)
c01056ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b0:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01056b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01056b5:	8d 50 01             	lea    0x1(%eax),%edx
c01056b8:	89 55 10             	mov    %edx,0x10(%ebp)
c01056bb:	0f b6 00             	movzbl (%eax),%eax
c01056be:	0f b6 d8             	movzbl %al,%ebx
c01056c1:	83 fb 25             	cmp    $0x25,%ebx
c01056c4:	75 d5                	jne    c010569b <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01056c6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01056ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01056d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01056d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01056de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056e1:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01056e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01056e7:	8d 50 01             	lea    0x1(%eax),%edx
c01056ea:	89 55 10             	mov    %edx,0x10(%ebp)
c01056ed:	0f b6 00             	movzbl (%eax),%eax
c01056f0:	0f b6 d8             	movzbl %al,%ebx
c01056f3:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01056f6:	83 f8 55             	cmp    $0x55,%eax
c01056f9:	0f 87 37 03 00 00    	ja     c0105a36 <vprintfmt+0x3a5>
c01056ff:	8b 04 85 24 6b 10 c0 	mov    -0x3fef94dc(,%eax,4),%eax
c0105706:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105708:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010570c:	eb d6                	jmp    c01056e4 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010570e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105712:	eb d0                	jmp    c01056e4 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105714:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010571b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010571e:	89 d0                	mov    %edx,%eax
c0105720:	c1 e0 02             	shl    $0x2,%eax
c0105723:	01 d0                	add    %edx,%eax
c0105725:	01 c0                	add    %eax,%eax
c0105727:	01 d8                	add    %ebx,%eax
c0105729:	83 e8 30             	sub    $0x30,%eax
c010572c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010572f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105732:	0f b6 00             	movzbl (%eax),%eax
c0105735:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105738:	83 fb 2f             	cmp    $0x2f,%ebx
c010573b:	7e 38                	jle    c0105775 <vprintfmt+0xe4>
c010573d:	83 fb 39             	cmp    $0x39,%ebx
c0105740:	7f 33                	jg     c0105775 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105742:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105745:	eb d4                	jmp    c010571b <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105747:	8b 45 14             	mov    0x14(%ebp),%eax
c010574a:	8d 50 04             	lea    0x4(%eax),%edx
c010574d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105750:	8b 00                	mov    (%eax),%eax
c0105752:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105755:	eb 1f                	jmp    c0105776 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0105757:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010575b:	79 87                	jns    c01056e4 <vprintfmt+0x53>
                width = 0;
c010575d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105764:	e9 7b ff ff ff       	jmp    c01056e4 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105769:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105770:	e9 6f ff ff ff       	jmp    c01056e4 <vprintfmt+0x53>
            goto process_precision;
c0105775:	90                   	nop

        process_precision:
            if (width < 0)
c0105776:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010577a:	0f 89 64 ff ff ff    	jns    c01056e4 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105783:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105786:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010578d:	e9 52 ff ff ff       	jmp    c01056e4 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105792:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105795:	e9 4a ff ff ff       	jmp    c01056e4 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010579a:	8b 45 14             	mov    0x14(%ebp),%eax
c010579d:	8d 50 04             	lea    0x4(%eax),%edx
c01057a0:	89 55 14             	mov    %edx,0x14(%ebp)
c01057a3:	8b 00                	mov    (%eax),%eax
c01057a5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057ac:	89 04 24             	mov    %eax,(%esp)
c01057af:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b2:	ff d0                	call   *%eax
            break;
c01057b4:	e9 a4 02 00 00       	jmp    c0105a5d <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01057b9:	8b 45 14             	mov    0x14(%ebp),%eax
c01057bc:	8d 50 04             	lea    0x4(%eax),%edx
c01057bf:	89 55 14             	mov    %edx,0x14(%ebp)
c01057c2:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01057c4:	85 db                	test   %ebx,%ebx
c01057c6:	79 02                	jns    c01057ca <vprintfmt+0x139>
                err = -err;
c01057c8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01057ca:	83 fb 06             	cmp    $0x6,%ebx
c01057cd:	7f 0b                	jg     c01057da <vprintfmt+0x149>
c01057cf:	8b 34 9d e4 6a 10 c0 	mov    -0x3fef951c(,%ebx,4),%esi
c01057d6:	85 f6                	test   %esi,%esi
c01057d8:	75 23                	jne    c01057fd <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c01057da:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01057de:	c7 44 24 08 11 6b 10 	movl   $0xc0106b11,0x8(%esp)
c01057e5:	c0 
c01057e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f0:	89 04 24             	mov    %eax,(%esp)
c01057f3:	e8 6a fe ff ff       	call   c0105662 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01057f8:	e9 60 02 00 00       	jmp    c0105a5d <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c01057fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105801:	c7 44 24 08 1a 6b 10 	movl   $0xc0106b1a,0x8(%esp)
c0105808:	c0 
c0105809:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105810:	8b 45 08             	mov    0x8(%ebp),%eax
c0105813:	89 04 24             	mov    %eax,(%esp)
c0105816:	e8 47 fe ff ff       	call   c0105662 <printfmt>
            break;
c010581b:	e9 3d 02 00 00       	jmp    c0105a5d <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105820:	8b 45 14             	mov    0x14(%ebp),%eax
c0105823:	8d 50 04             	lea    0x4(%eax),%edx
c0105826:	89 55 14             	mov    %edx,0x14(%ebp)
c0105829:	8b 30                	mov    (%eax),%esi
c010582b:	85 f6                	test   %esi,%esi
c010582d:	75 05                	jne    c0105834 <vprintfmt+0x1a3>
                p = "(null)";
c010582f:	be 1d 6b 10 c0       	mov    $0xc0106b1d,%esi
            }
            if (width > 0 && padc != '-') {
c0105834:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105838:	7e 76                	jle    c01058b0 <vprintfmt+0x21f>
c010583a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010583e:	74 70                	je     c01058b0 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105843:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105847:	89 34 24             	mov    %esi,(%esp)
c010584a:	e8 f6 f7 ff ff       	call   c0105045 <strnlen>
c010584f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105852:	29 c2                	sub    %eax,%edx
c0105854:	89 d0                	mov    %edx,%eax
c0105856:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105859:	eb 16                	jmp    c0105871 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c010585b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010585f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105862:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105866:	89 04 24             	mov    %eax,(%esp)
c0105869:	8b 45 08             	mov    0x8(%ebp),%eax
c010586c:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c010586e:	ff 4d e8             	decl   -0x18(%ebp)
c0105871:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105875:	7f e4                	jg     c010585b <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105877:	eb 37                	jmp    c01058b0 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105879:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010587d:	74 1f                	je     c010589e <vprintfmt+0x20d>
c010587f:	83 fb 1f             	cmp    $0x1f,%ebx
c0105882:	7e 05                	jle    c0105889 <vprintfmt+0x1f8>
c0105884:	83 fb 7e             	cmp    $0x7e,%ebx
c0105887:	7e 15                	jle    c010589e <vprintfmt+0x20d>
                    putch('?', putdat);
c0105889:	8b 45 0c             	mov    0xc(%ebp),%eax
c010588c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105890:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105897:	8b 45 08             	mov    0x8(%ebp),%eax
c010589a:	ff d0                	call   *%eax
c010589c:	eb 0f                	jmp    c01058ad <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c010589e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058a5:	89 1c 24             	mov    %ebx,(%esp)
c01058a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ab:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01058ad:	ff 4d e8             	decl   -0x18(%ebp)
c01058b0:	89 f0                	mov    %esi,%eax
c01058b2:	8d 70 01             	lea    0x1(%eax),%esi
c01058b5:	0f b6 00             	movzbl (%eax),%eax
c01058b8:	0f be d8             	movsbl %al,%ebx
c01058bb:	85 db                	test   %ebx,%ebx
c01058bd:	74 27                	je     c01058e6 <vprintfmt+0x255>
c01058bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058c3:	78 b4                	js     c0105879 <vprintfmt+0x1e8>
c01058c5:	ff 4d e4             	decl   -0x1c(%ebp)
c01058c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058cc:	79 ab                	jns    c0105879 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c01058ce:	eb 16                	jmp    c01058e6 <vprintfmt+0x255>
                putch(' ', putdat);
c01058d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01058de:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e1:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c01058e3:	ff 4d e8             	decl   -0x18(%ebp)
c01058e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058ea:	7f e4                	jg     c01058d0 <vprintfmt+0x23f>
            }
            break;
c01058ec:	e9 6c 01 00 00       	jmp    c0105a5d <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01058f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f8:	8d 45 14             	lea    0x14(%ebp),%eax
c01058fb:	89 04 24             	mov    %eax,(%esp)
c01058fe:	e8 18 fd ff ff       	call   c010561b <getint>
c0105903:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105906:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105909:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010590c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010590f:	85 d2                	test   %edx,%edx
c0105911:	79 26                	jns    c0105939 <vprintfmt+0x2a8>
                putch('-', putdat);
c0105913:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105916:	89 44 24 04          	mov    %eax,0x4(%esp)
c010591a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105921:	8b 45 08             	mov    0x8(%ebp),%eax
c0105924:	ff d0                	call   *%eax
                num = -(long long)num;
c0105926:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105929:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010592c:	f7 d8                	neg    %eax
c010592e:	83 d2 00             	adc    $0x0,%edx
c0105931:	f7 da                	neg    %edx
c0105933:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105936:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105939:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105940:	e9 a8 00 00 00       	jmp    c01059ed <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105945:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105948:	89 44 24 04          	mov    %eax,0x4(%esp)
c010594c:	8d 45 14             	lea    0x14(%ebp),%eax
c010594f:	89 04 24             	mov    %eax,(%esp)
c0105952:	e8 75 fc ff ff       	call   c01055cc <getuint>
c0105957:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010595a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010595d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105964:	e9 84 00 00 00       	jmp    c01059ed <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105969:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010596c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105970:	8d 45 14             	lea    0x14(%ebp),%eax
c0105973:	89 04 24             	mov    %eax,(%esp)
c0105976:	e8 51 fc ff ff       	call   c01055cc <getuint>
c010597b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010597e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105981:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105988:	eb 63                	jmp    c01059ed <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c010598a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010598d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105991:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105998:	8b 45 08             	mov    0x8(%ebp),%eax
c010599b:	ff d0                	call   *%eax
            putch('x', putdat);
c010599d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01059ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ae:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01059b0:	8b 45 14             	mov    0x14(%ebp),%eax
c01059b3:	8d 50 04             	lea    0x4(%eax),%edx
c01059b6:	89 55 14             	mov    %edx,0x14(%ebp)
c01059b9:	8b 00                	mov    (%eax),%eax
c01059bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01059c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01059cc:	eb 1f                	jmp    c01059ed <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01059ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059d5:	8d 45 14             	lea    0x14(%ebp),%eax
c01059d8:	89 04 24             	mov    %eax,(%esp)
c01059db:	e8 ec fb ff ff       	call   c01055cc <getuint>
c01059e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01059e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01059ed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01059f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059f4:	89 54 24 18          	mov    %edx,0x18(%esp)
c01059f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01059fb:	89 54 24 14          	mov    %edx,0x14(%esp)
c01059ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a09:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a0d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105a11:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a1b:	89 04 24             	mov    %eax,(%esp)
c0105a1e:	e8 a4 fa ff ff       	call   c01054c7 <printnum>
            break;
c0105a23:	eb 38                	jmp    c0105a5d <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105a25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a2c:	89 1c 24             	mov    %ebx,(%esp)
c0105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a32:	ff d0                	call   *%eax
            break;
c0105a34:	eb 27                	jmp    c0105a5d <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105a36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a3d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105a44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a47:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105a49:	ff 4d 10             	decl   0x10(%ebp)
c0105a4c:	eb 03                	jmp    c0105a51 <vprintfmt+0x3c0>
c0105a4e:	ff 4d 10             	decl   0x10(%ebp)
c0105a51:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a54:	48                   	dec    %eax
c0105a55:	0f b6 00             	movzbl (%eax),%eax
c0105a58:	3c 25                	cmp    $0x25,%al
c0105a5a:	75 f2                	jne    c0105a4e <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105a5c:	90                   	nop
    while (1) {
c0105a5d:	e9 37 fc ff ff       	jmp    c0105699 <vprintfmt+0x8>
                return;
c0105a62:	90                   	nop
        }
    }
}
c0105a63:	83 c4 40             	add    $0x40,%esp
c0105a66:	5b                   	pop    %ebx
c0105a67:	5e                   	pop    %esi
c0105a68:	5d                   	pop    %ebp
c0105a69:	c3                   	ret    

c0105a6a <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a6a:	55                   	push   %ebp
c0105a6b:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a70:	8b 40 08             	mov    0x8(%eax),%eax
c0105a73:	8d 50 01             	lea    0x1(%eax),%edx
c0105a76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a79:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a7f:	8b 10                	mov    (%eax),%edx
c0105a81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a84:	8b 40 04             	mov    0x4(%eax),%eax
c0105a87:	39 c2                	cmp    %eax,%edx
c0105a89:	73 12                	jae    c0105a9d <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a8e:	8b 00                	mov    (%eax),%eax
c0105a90:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a93:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a96:	89 0a                	mov    %ecx,(%edx)
c0105a98:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a9b:	88 10                	mov    %dl,(%eax)
    }
}
c0105a9d:	90                   	nop
c0105a9e:	5d                   	pop    %ebp
c0105a9f:	c3                   	ret    

c0105aa0 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105aa0:	55                   	push   %ebp
c0105aa1:	89 e5                	mov    %esp,%ebp
c0105aa3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105aa6:	8d 45 14             	lea    0x14(%ebp),%eax
c0105aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aaf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ab3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ab6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105aba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105abd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac4:	89 04 24             	mov    %eax,(%esp)
c0105ac7:	e8 08 00 00 00       	call   c0105ad4 <vsnprintf>
c0105acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ad2:	c9                   	leave  
c0105ad3:	c3                   	ret    

c0105ad4 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105ad4:	55                   	push   %ebp
c0105ad5:	89 e5                	mov    %esp,%ebp
c0105ad7:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0105add:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae9:	01 d0                	add    %edx,%eax
c0105aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105af5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105af9:	74 0a                	je     c0105b05 <vsnprintf+0x31>
c0105afb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b01:	39 c2                	cmp    %eax,%edx
c0105b03:	76 07                	jbe    c0105b0c <vsnprintf+0x38>
        return -E_INVAL;
c0105b05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105b0a:	eb 2a                	jmp    c0105b36 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105b0c:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b13:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b16:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b1a:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b21:	c7 04 24 6a 5a 10 c0 	movl   $0xc0105a6a,(%esp)
c0105b28:	e8 64 fb ff ff       	call   c0105691 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b30:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b36:	c9                   	leave  
c0105b37:	c3                   	ret    
