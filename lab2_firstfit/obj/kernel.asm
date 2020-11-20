
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 90 11 00       	mov    $0x119000,%eax
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
c0100020:	a3 00 90 11 c0       	mov    %eax,0xc0119000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
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
c010003c:	ba 88 bf 11 c0       	mov    $0xc011bf88,%edx
c0100041:	b8 00 b0 11 c0       	mov    $0xc011b000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 b0 11 c0 	movl   $0xc011b000,(%esp)
c010005d:	e8 ca 5a 00 00       	call   c0105b2c <memset>

    cons_init();                // init the console
c0100062:	e8 9c 15 00 00       	call   c0101603 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 40 63 10 c0 	movl   $0xc0106340,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 5c 63 10 c0 	movl   $0xc010635c,(%esp)
c010007c:	e8 21 02 00 00       	call   c01002a2 <cprintf>

    print_kerninfo();
c0100081:	e8 c2 08 00 00       	call   c0100948 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 8e 00 00 00       	call   c0100119 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 53 34 00 00       	call   c01034e3 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 d3 16 00 00       	call   c0101768 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 58 18 00 00       	call   c01018f2 <idt_init>

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
c010015a:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 61 63 10 c0 	movl   $0xc0106361,(%esp)
c010016e:	e8 2f 01 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 6f 63 10 c0 	movl   $0xc010636f,(%esp)
c010018d:	e8 10 01 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 7d 63 10 c0 	movl   $0xc010637d,(%esp)
c01001ac:	e8 f1 00 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 8b 63 10 c0 	movl   $0xc010638b,(%esp)
c01001cb:	e8 d2 00 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 99 63 10 c0 	movl   $0xc0106399,(%esp)
c01001ea:	e8 b3 00 00 00       	call   c01002a2 <cprintf>
    round ++;
c01001ef:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 b0 11 c0       	mov    %eax,0xc011b000
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
c010021f:	c7 04 24 a8 63 10 c0 	movl   $0xc01063a8,(%esp)
c0100226:	e8 77 00 00 00       	call   c01002a2 <cprintf>
    lab1_switch_to_user();
c010022b:	e8 cd ff ff ff       	call   c01001fd <lab1_switch_to_user>
    lab1_print_cur_status();
c0100230:	e8 0a ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100235:	c7 04 24 c8 63 10 c0 	movl   $0xc01063c8,(%esp)
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
c0100298:	e8 e2 5b 00 00       	call   c0105e7f <vprintfmt>
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
c0100357:	c7 04 24 e7 63 10 c0 	movl   $0xc01063e7,(%esp)
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
c01003a5:	88 90 20 b0 11 c0    	mov    %dl,-0x3fee4fe0(%eax)
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
c01003e3:	05 20 b0 11 c0       	add    $0xc011b020,%eax
c01003e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003eb:	b8 20 b0 11 c0       	mov    $0xc011b020,%eax
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
c01003ff:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100404:	85 c0                	test   %eax,%eax
c0100406:	75 5b                	jne    c0100463 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100408:	c7 05 20 b4 11 c0 01 	movl   $0x1,0xc011b420
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
c0100426:	c7 04 24 ea 63 10 c0 	movl   $0xc01063ea,(%esp)
c010042d:	e8 70 fe ff ff       	call   c01002a2 <cprintf>
    vcprintf(fmt, ap);
c0100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100435:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100439:	8b 45 10             	mov    0x10(%ebp),%eax
c010043c:	89 04 24             	mov    %eax,(%esp)
c010043f:	e8 2b fe ff ff       	call   c010026f <vcprintf>
    cprintf("\n");
c0100444:	c7 04 24 06 64 10 c0 	movl   $0xc0106406,(%esp)
c010044b:	e8 52 fe ff ff       	call   c01002a2 <cprintf>
    
    cprintf("stack trackback:\n");
c0100450:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
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
c0100491:	c7 04 24 1a 64 10 c0 	movl   $0xc010641a,(%esp)
c0100498:	e8 05 fe ff ff       	call   c01002a2 <cprintf>
    vcprintf(fmt, ap);
c010049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a7:	89 04 24             	mov    %eax,(%esp)
c01004aa:	e8 c0 fd ff ff       	call   c010026f <vcprintf>
    cprintf("\n");
c01004af:	c7 04 24 06 64 10 c0 	movl   $0xc0106406,(%esp)
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
c01004c1:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
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
c010061f:	c7 00 38 64 10 c0    	movl   $0xc0106438,(%eax)
    info->eip_line = 0;
c0100625:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010062f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100632:	c7 40 08 38 64 10 c0 	movl   $0xc0106438,0x8(%eax)
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
c0100656:	c7 45 f4 b0 76 10 c0 	movl   $0xc01076b0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010065d:	c7 45 f0 f8 2a 11 c0 	movl   $0xc0112af8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100664:	c7 45 ec f9 2a 11 c0 	movl   $0xc0112af9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010066b:	c7 45 e8 1a 56 11 c0 	movl   $0xc011561a,-0x18(%ebp)

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
c01007c6:	e8 dd 51 00 00       	call   c01059a8 <strfind>
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
c010094e:	c7 04 24 42 64 10 c0 	movl   $0xc0106442,(%esp)
c0100955:	e8 48 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010095a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100961:	c0 
c0100962:	c7 04 24 5b 64 10 c0 	movl   $0xc010645b,(%esp)
c0100969:	e8 34 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010096e:	c7 44 24 04 26 63 10 	movl   $0xc0106326,0x4(%esp)
c0100975:	c0 
c0100976:	c7 04 24 73 64 10 c0 	movl   $0xc0106473,(%esp)
c010097d:	e8 20 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100982:	c7 44 24 04 00 b0 11 	movl   $0xc011b000,0x4(%esp)
c0100989:	c0 
c010098a:	c7 04 24 8b 64 10 c0 	movl   $0xc010648b,(%esp)
c0100991:	e8 0c f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100996:	c7 44 24 04 88 bf 11 	movl   $0xc011bf88,0x4(%esp)
c010099d:	c0 
c010099e:	c7 04 24 a3 64 10 c0 	movl   $0xc01064a3,(%esp)
c01009a5:	e8 f8 f8 ff ff       	call   c01002a2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009aa:	b8 88 bf 11 c0       	mov    $0xc011bf88,%eax
c01009af:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009b5:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009ba:	29 c2                	sub    %eax,%edx
c01009bc:	89 d0                	mov    %edx,%eax
c01009be:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009c4:	85 c0                	test   %eax,%eax
c01009c6:	0f 48 c2             	cmovs  %edx,%eax
c01009c9:	c1 f8 0a             	sar    $0xa,%eax
c01009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d0:	c7 04 24 bc 64 10 c0 	movl   $0xc01064bc,(%esp)
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
c0100a05:	c7 04 24 e6 64 10 c0 	movl   $0xc01064e6,(%esp)
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
c0100a73:	c7 04 24 02 65 10 c0 	movl   $0xc0106502,(%esp)
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
c0100ac6:	c7 04 24 14 65 10 c0 	movl   $0xc0106514,(%esp)
c0100acd:	e8 d0 f7 ff ff       	call   c01002a2 <cprintf>
         cprintf("arg:");
c0100ad2:	c7 04 24 2f 65 10 c0 	movl   $0xc010652f,(%esp)
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
c0100b05:	c7 04 24 34 65 10 c0 	movl   $0xc0106534,(%esp)
c0100b0c:	e8 91 f7 ff ff       	call   c01002a2 <cprintf>
         for(j=0; j<=4; j++)
c0100b11:	ff 45 ec             	incl   -0x14(%ebp)
c0100b14:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
c0100b18:	7e d6                	jle    c0100af0 <print_stackframe+0x5d>
         cprintf("\n");
c0100b1a:	c7 04 24 3f 65 10 c0 	movl   $0xc010653f,(%esp)
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
c0100b8d:	c7 04 24 c4 65 10 c0 	movl   $0xc01065c4,(%esp)
c0100b94:	e8 dd 4d 00 00       	call   c0105976 <strchr>
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
c0100bb5:	c7 04 24 c9 65 10 c0 	movl   $0xc01065c9,(%esp)
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
c0100bf7:	c7 04 24 c4 65 10 c0 	movl   $0xc01065c4,(%esp)
c0100bfe:	e8 73 4d 00 00       	call   c0105976 <strchr>
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
c0100c56:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100c5b:	8b 00                	mov    (%eax),%eax
c0100c5d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c61:	89 04 24             	mov    %eax,(%esp)
c0100c64:	e8 70 4c 00 00       	call   c01058d9 <strcmp>
c0100c69:	85 c0                	test   %eax,%eax
c0100c6b:	75 31                	jne    c0100c9e <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c70:	89 d0                	mov    %edx,%eax
c0100c72:	01 c0                	add    %eax,%eax
c0100c74:	01 d0                	add    %edx,%eax
c0100c76:	c1 e0 02             	shl    $0x2,%eax
c0100c79:	05 08 80 11 c0       	add    $0xc0118008,%eax
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
c0100cb0:	c7 04 24 e7 65 10 c0 	movl   $0xc01065e7,(%esp)
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
c0100ccd:	c7 04 24 00 66 10 c0 	movl   $0xc0106600,(%esp)
c0100cd4:	e8 c9 f5 ff ff       	call   c01002a2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cd9:	c7 04 24 28 66 10 c0 	movl   $0xc0106628,(%esp)
c0100ce0:	e8 bd f5 ff ff       	call   c01002a2 <cprintf>

    if (tf != NULL) {
c0100ce5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ce9:	74 0b                	je     c0100cf6 <kmonitor+0x2f>
        print_trapframe(tf);
c0100ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cee:	89 04 24             	mov    %eax,(%esp)
c0100cf1:	e8 b2 0d 00 00       	call   c0101aa8 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cf6:	c7 04 24 4d 66 10 c0 	movl   $0xc010664d,(%esp)
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
c0100d42:	05 04 80 11 c0       	add    $0xc0118004,%eax
c0100d47:	8b 08                	mov    (%eax),%ecx
c0100d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d4c:	89 d0                	mov    %edx,%eax
c0100d4e:	01 c0                	add    %eax,%eax
c0100d50:	01 d0                	add    %edx,%eax
c0100d52:	c1 e0 02             	shl    $0x2,%eax
c0100d55:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100d5a:	8b 00                	mov    (%eax),%eax
c0100d5c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d64:	c7 04 24 51 66 10 c0 	movl   $0xc0106651,(%esp)
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
c0100de5:	c7 05 0c bf 11 c0 00 	movl   $0x0,0xc011bf0c
c0100dec:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100def:	c7 04 24 5a 66 10 c0 	movl   $0xc010665a,(%esp)
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
c0100ec7:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
c0100ece:	b4 03 
c0100ed0:	eb 13                	jmp    c0100ee5 <cga_init+0x54>
    } else {
        *cp = was;
c0100ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ed9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100edc:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100ee3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee5:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100eec:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ef0:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ef8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100efc:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100efd:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
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
c0100f23:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f2a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f2e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f32:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f36:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f3a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f3b:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
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
c0100f61:	a3 40 b4 11 c0       	mov    %eax,0xc011b440
    crt_pos = pos;
c0100f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f69:	0f b7 c0             	movzwl %ax,%eax
c0100f6c:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
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
c010101c:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
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
c0101041:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
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
c0101145:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010114c:	85 c0                	test   %eax,%eax
c010114e:	0f 84 af 00 00 00    	je     c0101203 <cga_putc+0xf1>
            crt_pos --;
c0101154:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010115b:	48                   	dec    %eax
c010115c:	0f b7 c0             	movzwl %ax,%eax
c010115f:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101165:	8b 45 08             	mov    0x8(%ebp),%eax
c0101168:	98                   	cwtl   
c0101169:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010116e:	98                   	cwtl   
c010116f:	83 c8 20             	or     $0x20,%eax
c0101172:	98                   	cwtl   
c0101173:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
c0101179:	0f b7 0d 44 b4 11 c0 	movzwl 0xc011b444,%ecx
c0101180:	01 c9                	add    %ecx,%ecx
c0101182:	01 ca                	add    %ecx,%edx
c0101184:	0f b7 c0             	movzwl %ax,%eax
c0101187:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010118a:	eb 77                	jmp    c0101203 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c010118c:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101193:	83 c0 50             	add    $0x50,%eax
c0101196:	0f b7 c0             	movzwl %ax,%eax
c0101199:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010119f:	0f b7 1d 44 b4 11 c0 	movzwl 0xc011b444,%ebx
c01011a6:	0f b7 0d 44 b4 11 c0 	movzwl 0xc011b444,%ecx
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
c01011d1:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
        break;
c01011d7:	eb 2b                	jmp    c0101204 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011d9:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c01011df:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011e6:	8d 50 01             	lea    0x1(%eax),%edx
c01011e9:	0f b7 d2             	movzwl %dx,%edx
c01011ec:	66 89 15 44 b4 11 c0 	mov    %dx,0xc011b444
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
c0101204:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010120b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101210:	76 5d                	jbe    c010126f <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101212:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101217:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010121d:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101222:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101229:	00 
c010122a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010122e:	89 04 24             	mov    %eax,(%esp)
c0101231:	e8 36 49 00 00       	call   c0105b6c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101236:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010123d:	eb 14                	jmp    c0101253 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c010123f:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
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
c010125c:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101263:	83 e8 50             	sub    $0x50,%eax
c0101266:	0f b7 c0             	movzwl %ax,%eax
c0101269:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010126f:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0101276:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010127a:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c010127e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101282:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101286:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101287:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010128e:	c1 e8 08             	shr    $0x8,%eax
c0101291:	0f b7 c0             	movzwl %ax,%eax
c0101294:	0f b6 c0             	movzbl %al,%eax
c0101297:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c010129e:	42                   	inc    %edx
c010129f:	0f b7 d2             	movzwl %dx,%edx
c01012a2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012a6:	88 45 e9             	mov    %al,-0x17(%ebp)
c01012a9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012ad:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012b1:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012b2:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01012b9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012bd:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c01012c1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012c5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012c9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012ca:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012d1:	0f b6 c0             	movzbl %al,%eax
c01012d4:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
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
c010139d:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01013a2:	8d 50 01             	lea    0x1(%eax),%edx
c01013a5:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c01013ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013ae:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013b4:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01013b9:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013be:	75 0a                	jne    c01013ca <cons_intr+0x3b>
                cons.wpos = 0;
c01013c0:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
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
c0101438:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
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
c0101499:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010149e:	83 c8 40             	or     $0x40,%eax
c01014a1:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c01014a6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ab:	e9 22 01 00 00       	jmp    c01015d2 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c01014b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b4:	84 c0                	test   %al,%al
c01014b6:	79 45                	jns    c01014fd <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014b8:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
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
c01014d7:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c01014de:	0c 40                	or     $0x40,%al
c01014e0:	0f b6 c0             	movzbl %al,%eax
c01014e3:	f7 d0                	not    %eax
c01014e5:	89 c2                	mov    %eax,%edx
c01014e7:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014ec:	21 d0                	and    %edx,%eax
c01014ee:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c01014f3:	b8 00 00 00 00       	mov    $0x0,%eax
c01014f8:	e9 d5 00 00 00       	jmp    c01015d2 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c01014fd:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101502:	83 e0 40             	and    $0x40,%eax
c0101505:	85 c0                	test   %eax,%eax
c0101507:	74 11                	je     c010151a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101509:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010150d:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101512:	83 e0 bf             	and    $0xffffffbf,%eax
c0101515:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    }

    shift |= shiftcode[data];
c010151a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151e:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c0101525:	0f b6 d0             	movzbl %al,%edx
c0101528:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010152d:	09 d0                	or     %edx,%eax
c010152f:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    shift ^= togglecode[data];
c0101534:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101538:	0f b6 80 40 81 11 c0 	movzbl -0x3fee7ec0(%eax),%eax
c010153f:	0f b6 d0             	movzbl %al,%edx
c0101542:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101547:	31 d0                	xor    %edx,%eax
c0101549:	a3 68 b6 11 c0       	mov    %eax,0xc011b668

    c = charcode[shift & (CTL | SHIFT)][data];
c010154e:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101553:	83 e0 03             	and    $0x3,%eax
c0101556:	8b 14 85 40 85 11 c0 	mov    -0x3fee7ac0(,%eax,4),%edx
c010155d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101561:	01 d0                	add    %edx,%eax
c0101563:	0f b6 00             	movzbl (%eax),%eax
c0101566:	0f b6 c0             	movzbl %al,%eax
c0101569:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010156c:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
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
c010159a:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010159f:	f7 d0                	not    %eax
c01015a1:	83 e0 06             	and    $0x6,%eax
c01015a4:	85 c0                	test   %eax,%eax
c01015a6:	75 27                	jne    c01015cf <kbd_proc_data+0x17f>
c01015a8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015af:	75 1e                	jne    c01015cf <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c01015b1:	c7 04 24 75 66 10 c0 	movl   $0xc0106675,(%esp)
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
c0101618:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c010161d:	85 c0                	test   %eax,%eax
c010161f:	75 0c                	jne    c010162d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101621:	c7 04 24 81 66 10 c0 	movl   $0xc0106681,(%esp)
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
c010168c:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c0101692:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101697:	39 c2                	cmp    %eax,%edx
c0101699:	74 31                	je     c01016cc <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010169b:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c01016a0:	8d 50 01             	lea    0x1(%eax),%edx
c01016a3:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c01016a9:	0f b6 80 60 b4 11 c0 	movzbl -0x3fee4ba0(%eax),%eax
c01016b0:	0f b6 c0             	movzbl %al,%eax
c01016b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016b6:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c01016bb:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016c0:	75 0a                	jne    c01016cc <cons_getc+0x5f>
                cons.rpos = 0;
c01016c2:	c7 05 60 b6 11 c0 00 	movl   $0x0,0xc011b660
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
c01016ec:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init) {
c01016f2:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
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
c010174f:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
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
c010176e:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
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
c0101882:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101889:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010188e:	74 0f                	je     c010189f <pic_init+0x137>
        pic_setmask(irq_mask);
c0101890:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
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
c01018be:	c7 04 24 a0 66 10 c0 	movl   $0xc01066a0,(%esp)
c01018c5:	e8 d8 e9 ff ff       	call   c01002a2 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018ca:	c7 04 24 aa 66 10 c0 	movl   $0xc01066aa,(%esp)
c01018d1:	e8 cc e9 ff ff       	call   c01002a2 <cprintf>
    panic("EOT: kernel seems ok.");
c01018d6:	c7 44 24 08 b8 66 10 	movl   $0xc01066b8,0x8(%esp)
c01018dd:	c0 
c01018de:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018e5:	00 
c01018e6:	c7 04 24 ce 66 10 c0 	movl   $0xc01066ce,(%esp)
c01018ed:	e8 07 eb ff ff       	call   c01003f9 <__panic>

c01018f2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018f2:	55                   	push   %ebp
c01018f3:	89 e5                	mov    %esp,%ebp
c01018f5:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
          extern uintptr_t __vectors[];
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018ff:	e9 c4 00 00 00       	jmp    c01019c8 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c010190e:	0f b7 d0             	movzwl %ax,%edx
c0101911:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101914:	66 89 14 c5 80 b6 11 	mov    %dx,-0x3fee4980(,%eax,8)
c010191b:	c0 
c010191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191f:	66 c7 04 c5 82 b6 11 	movw   $0x8,-0x3fee497e(,%eax,8)
c0101926:	c0 08 00 
c0101929:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192c:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c0101933:	c0 
c0101934:	80 e2 e0             	and    $0xe0,%dl
c0101937:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c010193e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101941:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c0101948:	c0 
c0101949:	80 e2 1f             	and    $0x1f,%dl
c010194c:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c0101953:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101956:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c010195d:	c0 
c010195e:	80 e2 f0             	and    $0xf0,%dl
c0101961:	80 ca 0e             	or     $0xe,%dl
c0101964:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c010196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196e:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101975:	c0 
c0101976:	80 e2 ef             	and    $0xef,%dl
c0101979:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101980:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101983:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c010198a:	c0 
c010198b:	80 e2 9f             	and    $0x9f,%dl
c010198e:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101995:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101998:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c010199f:	c0 
c01019a0:	80 ca 80             	or     $0x80,%dl
c01019a3:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ad:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c01019b4:	c1 e8 10             	shr    $0x10,%eax
c01019b7:	0f b7 d0             	movzwl %ax,%edx
c01019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019bd:	66 89 14 c5 86 b6 11 	mov    %dx,-0x3fee497a(,%eax,8)
c01019c4:	c0 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019c5:	ff 45 fc             	incl   -0x4(%ebp)
c01019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019cb:	3d ff 00 00 00       	cmp    $0xff,%eax
c01019d0:	0f 86 2e ff ff ff    	jbe    c0101904 <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
c01019d6:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c01019db:	0f b7 c0             	movzwl %ax,%eax
c01019de:	66 a3 48 ba 11 c0    	mov    %ax,0xc011ba48
c01019e4:	66 c7 05 4a ba 11 c0 	movw   $0x8,0xc011ba4a
c01019eb:	08 00 
c01019ed:	0f b6 05 4c ba 11 c0 	movzbl 0xc011ba4c,%eax
c01019f4:	24 e0                	and    $0xe0,%al
c01019f6:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c01019fb:	0f b6 05 4c ba 11 c0 	movzbl 0xc011ba4c,%eax
c0101a02:	24 1f                	and    $0x1f,%al
c0101a04:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c0101a09:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a10:	0c 0f                	or     $0xf,%al
c0101a12:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a17:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a1e:	24 ef                	and    $0xef,%al
c0101a20:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a25:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a2c:	0c 60                	or     $0x60,%al
c0101a2e:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a33:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a3a:	0c 80                	or     $0x80,%al
c0101a3c:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a41:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c0101a46:	c1 e8 10             	shr    $0x10,%eax
c0101a49:	0f b7 c0             	movzwl %ax,%eax
c0101a4c:	66 a3 4e ba 11 c0    	mov    %ax,0xc011ba4e
c0101a52:	c7 45 f8 60 85 11 c0 	movl   $0xc0118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a59:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a5c:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
c0101a5f:	90                   	nop
c0101a60:	c9                   	leave  
c0101a61:	c3                   	ret    

c0101a62 <trapname>:

static const char *
trapname(int trapno) {
c0101a62:	55                   	push   %ebp
c0101a63:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a65:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a68:	83 f8 13             	cmp    $0x13,%eax
c0101a6b:	77 0c                	ja     c0101a79 <trapname+0x17>
        return excnames[trapno];
c0101a6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a70:	8b 04 85 20 6a 10 c0 	mov    -0x3fef95e0(,%eax,4),%eax
c0101a77:	eb 18                	jmp    c0101a91 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a79:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a7d:	7e 0d                	jle    c0101a8c <trapname+0x2a>
c0101a7f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a83:	7f 07                	jg     c0101a8c <trapname+0x2a>
        return "Hardware Interrupt";
c0101a85:	b8 df 66 10 c0       	mov    $0xc01066df,%eax
c0101a8a:	eb 05                	jmp    c0101a91 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a8c:	b8 f2 66 10 c0       	mov    $0xc01066f2,%eax
}
c0101a91:	5d                   	pop    %ebp
c0101a92:	c3                   	ret    

c0101a93 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a93:	55                   	push   %ebp
c0101a94:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a99:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a9d:	83 f8 08             	cmp    $0x8,%eax
c0101aa0:	0f 94 c0             	sete   %al
c0101aa3:	0f b6 c0             	movzbl %al,%eax
}
c0101aa6:	5d                   	pop    %ebp
c0101aa7:	c3                   	ret    

c0101aa8 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101aa8:	55                   	push   %ebp
c0101aa9:	89 e5                	mov    %esp,%ebp
c0101aab:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab5:	c7 04 24 33 67 10 c0 	movl   $0xc0106733,(%esp)
c0101abc:	e8 e1 e7 ff ff       	call   c01002a2 <cprintf>
    print_regs(&tf->tf_regs);
c0101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac4:	89 04 24             	mov    %eax,(%esp)
c0101ac7:	e8 8f 01 00 00       	call   c0101c5b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101acc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acf:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad7:	c7 04 24 44 67 10 c0 	movl   $0xc0106744,(%esp)
c0101ade:	e8 bf e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ae3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101aea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aee:	c7 04 24 57 67 10 c0 	movl   $0xc0106757,(%esp)
c0101af5:	e8 a8 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101afa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afd:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b05:	c7 04 24 6a 67 10 c0 	movl   $0xc010676a,(%esp)
c0101b0c:	e8 91 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b14:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b1c:	c7 04 24 7d 67 10 c0 	movl   $0xc010677d,(%esp)
c0101b23:	e8 7a e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2b:	8b 40 30             	mov    0x30(%eax),%eax
c0101b2e:	89 04 24             	mov    %eax,(%esp)
c0101b31:	e8 2c ff ff ff       	call   c0101a62 <trapname>
c0101b36:	89 c2                	mov    %eax,%edx
c0101b38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3b:	8b 40 30             	mov    0x30(%eax),%eax
c0101b3e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b46:	c7 04 24 90 67 10 c0 	movl   $0xc0106790,(%esp)
c0101b4d:	e8 50 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b55:	8b 40 34             	mov    0x34(%eax),%eax
c0101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5c:	c7 04 24 a2 67 10 c0 	movl   $0xc01067a2,(%esp)
c0101b63:	e8 3a e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6b:	8b 40 38             	mov    0x38(%eax),%eax
c0101b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b72:	c7 04 24 b1 67 10 c0 	movl   $0xc01067b1,(%esp)
c0101b79:	e8 24 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b81:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b89:	c7 04 24 c0 67 10 c0 	movl   $0xc01067c0,(%esp)
c0101b90:	e8 0d e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b98:	8b 40 40             	mov    0x40(%eax),%eax
c0101b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b9f:	c7 04 24 d3 67 10 c0 	movl   $0xc01067d3,(%esp)
c0101ba6:	e8 f7 e6 ff ff       	call   c01002a2 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101bb2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101bb9:	eb 3d                	jmp    c0101bf8 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbe:	8b 50 40             	mov    0x40(%eax),%edx
c0101bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bc4:	21 d0                	and    %edx,%eax
c0101bc6:	85 c0                	test   %eax,%eax
c0101bc8:	74 28                	je     c0101bf2 <print_trapframe+0x14a>
c0101bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bcd:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101bd4:	85 c0                	test   %eax,%eax
c0101bd6:	74 1a                	je     c0101bf2 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0101bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bdb:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101be2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be6:	c7 04 24 e2 67 10 c0 	movl   $0xc01067e2,(%esp)
c0101bed:	e8 b0 e6 ff ff       	call   c01002a2 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bf2:	ff 45 f4             	incl   -0xc(%ebp)
c0101bf5:	d1 65 f0             	shll   -0x10(%ebp)
c0101bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bfb:	83 f8 17             	cmp    $0x17,%eax
c0101bfe:	76 bb                	jbe    c0101bbb <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c03:	8b 40 40             	mov    0x40(%eax),%eax
c0101c06:	c1 e8 0c             	shr    $0xc,%eax
c0101c09:	83 e0 03             	and    $0x3,%eax
c0101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c10:	c7 04 24 e6 67 10 c0 	movl   $0xc01067e6,(%esp)
c0101c17:	e8 86 e6 ff ff       	call   c01002a2 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1f:	89 04 24             	mov    %eax,(%esp)
c0101c22:	e8 6c fe ff ff       	call   c0101a93 <trap_in_kernel>
c0101c27:	85 c0                	test   %eax,%eax
c0101c29:	75 2d                	jne    c0101c58 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2e:	8b 40 44             	mov    0x44(%eax),%eax
c0101c31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c35:	c7 04 24 ef 67 10 c0 	movl   $0xc01067ef,(%esp)
c0101c3c:	e8 61 e6 ff ff       	call   c01002a2 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c44:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4c:	c7 04 24 fe 67 10 c0 	movl   $0xc01067fe,(%esp)
c0101c53:	e8 4a e6 ff ff       	call   c01002a2 <cprintf>
    }
}
c0101c58:	90                   	nop
c0101c59:	c9                   	leave  
c0101c5a:	c3                   	ret    

c0101c5b <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c5b:	55                   	push   %ebp
c0101c5c:	89 e5                	mov    %esp,%ebp
c0101c5e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c64:	8b 00                	mov    (%eax),%eax
c0101c66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6a:	c7 04 24 11 68 10 c0 	movl   $0xc0106811,(%esp)
c0101c71:	e8 2c e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c79:	8b 40 04             	mov    0x4(%eax),%eax
c0101c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c80:	c7 04 24 20 68 10 c0 	movl   $0xc0106820,(%esp)
c0101c87:	e8 16 e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8f:	8b 40 08             	mov    0x8(%eax),%eax
c0101c92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c96:	c7 04 24 2f 68 10 c0 	movl   $0xc010682f,(%esp)
c0101c9d:	e8 00 e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca5:	8b 40 0c             	mov    0xc(%eax),%eax
c0101ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cac:	c7 04 24 3e 68 10 c0 	movl   $0xc010683e,(%esp)
c0101cb3:	e8 ea e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbb:	8b 40 10             	mov    0x10(%eax),%eax
c0101cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc2:	c7 04 24 4d 68 10 c0 	movl   $0xc010684d,(%esp)
c0101cc9:	e8 d4 e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cce:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd1:	8b 40 14             	mov    0x14(%eax),%eax
c0101cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd8:	c7 04 24 5c 68 10 c0 	movl   $0xc010685c,(%esp)
c0101cdf:	e8 be e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce7:	8b 40 18             	mov    0x18(%eax),%eax
c0101cea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cee:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0101cf5:	e8 a8 e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfd:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d04:	c7 04 24 7a 68 10 c0 	movl   $0xc010687a,(%esp)
c0101d0b:	e8 92 e5 ff ff       	call   c01002a2 <cprintf>
}
c0101d10:	90                   	nop
c0101d11:	c9                   	leave  
c0101d12:	c3                   	ret    

c0101d13 <trap_dispatch>:
struct trapframe switchk2u, *switchu2k;
/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d13:	55                   	push   %ebp
c0101d14:	89 e5                	mov    %esp,%ebp
c0101d16:	57                   	push   %edi
c0101d17:	56                   	push   %esi
c0101d18:	53                   	push   %ebx
c0101d19:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1f:	8b 40 30             	mov    0x30(%eax),%eax
c0101d22:	83 f8 2f             	cmp    $0x2f,%eax
c0101d25:	77 21                	ja     c0101d48 <trap_dispatch+0x35>
c0101d27:	83 f8 2e             	cmp    $0x2e,%eax
c0101d2a:	0f 83 f9 03 00 00    	jae    c0102129 <trap_dispatch+0x416>
c0101d30:	83 f8 21             	cmp    $0x21,%eax
c0101d33:	0f 84 9c 00 00 00    	je     c0101dd5 <trap_dispatch+0xc2>
c0101d39:	83 f8 24             	cmp    $0x24,%eax
c0101d3c:	74 6e                	je     c0101dac <trap_dispatch+0x99>
c0101d3e:	83 f8 20             	cmp    $0x20,%eax
c0101d41:	74 1c                	je     c0101d5f <trap_dispatch+0x4c>
c0101d43:	e9 ac 03 00 00       	jmp    c01020f4 <trap_dispatch+0x3e1>
c0101d48:	83 f8 78             	cmp    $0x78,%eax
c0101d4b:	0f 84 42 02 00 00    	je     c0101f93 <trap_dispatch+0x280>
c0101d51:	83 f8 79             	cmp    $0x79,%eax
c0101d54:	0f 84 1d 03 00 00    	je     c0102077 <trap_dispatch+0x364>
c0101d5a:	e9 95 03 00 00       	jmp    c01020f4 <trap_dispatch+0x3e1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101d5f:	a1 0c bf 11 c0       	mov    0xc011bf0c,%eax
c0101d64:	40                   	inc    %eax
c0101d65:	a3 0c bf 11 c0       	mov    %eax,0xc011bf0c
        if(ticks % 100 == 0)
c0101d6a:	8b 0d 0c bf 11 c0    	mov    0xc011bf0c,%ecx
c0101d70:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d75:	89 c8                	mov    %ecx,%eax
c0101d77:	f7 e2                	mul    %edx
c0101d79:	c1 ea 05             	shr    $0x5,%edx
c0101d7c:	89 d0                	mov    %edx,%eax
c0101d7e:	c1 e0 02             	shl    $0x2,%eax
c0101d81:	01 d0                	add    %edx,%eax
c0101d83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101d8a:	01 d0                	add    %edx,%eax
c0101d8c:	c1 e0 02             	shl    $0x2,%eax
c0101d8f:	29 c1                	sub    %eax,%ecx
c0101d91:	89 ca                	mov    %ecx,%edx
c0101d93:	85 d2                	test   %edx,%edx
c0101d95:	0f 85 91 03 00 00    	jne    c010212c <trap_dispatch+0x419>
            print_ticks("100 ticks");
c0101d9b:	c7 04 24 89 68 10 c0 	movl   $0xc0106889,(%esp)
c0101da2:	e8 09 fb ff ff       	call   c01018b0 <print_ticks>
        break;
c0101da7:	e9 80 03 00 00       	jmp    c010212c <trap_dispatch+0x419>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101dac:	e8 bc f8 ff ff       	call   c010166d <cons_getc>
c0101db1:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101db4:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101db8:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101dbc:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dc4:	c7 04 24 93 68 10 c0 	movl   $0xc0106893,(%esp)
c0101dcb:	e8 d2 e4 ff ff       	call   c01002a2 <cprintf>
        break;
c0101dd0:	e9 5e 03 00 00       	jmp    c0102133 <trap_dispatch+0x420>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dd5:	e8 93 f8 ff ff       	call   c010166d <cons_getc>
c0101dda:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101ddd:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101de1:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101de5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101de9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ded:	c7 04 24 a5 68 10 c0 	movl   $0xc01068a5,(%esp)
c0101df4:	e8 a9 e4 ff ff       	call   c01002a2 <cprintf>
        switch (c)
c0101df9:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101dfd:	83 f8 30             	cmp    $0x30,%eax
c0101e00:	74 0e                	je     c0101e10 <trap_dispatch+0xfd>
c0101e02:	83 f8 33             	cmp    $0x33,%eax
c0101e05:	0f 84 90 00 00 00    	je     c0101e9b <trap_dispatch+0x188>
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
            print_trapframe(tf);
        }
        break;
        default:
            break;
c0101e0b:	e9 7e 01 00 00       	jmp    c0101f8e <trap_dispatch+0x27b>
            if (tf->tf_cs != KERNEL_CS) {
c0101e10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e13:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e17:	83 f8 08             	cmp    $0x8,%eax
c0101e1a:	0f 84 67 01 00 00    	je     c0101f87 <trap_dispatch+0x274>
            tf->tf_cs = KERNEL_CS;
c0101e20:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e23:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101e29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e2c:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e35:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e3c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e43:	8b 40 40             	mov    0x40(%eax),%eax
c0101e46:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101e4b:	89 c2                	mov    %eax,%edx
c0101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e50:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101e53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e56:	8b 40 44             	mov    0x44(%eax),%eax
c0101e59:	83 e8 44             	sub    $0x44,%eax
c0101e5c:	a3 6c bf 11 c0       	mov    %eax,0xc011bf6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101e61:	a1 6c bf 11 c0       	mov    0xc011bf6c,%eax
c0101e66:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101e6d:	00 
c0101e6e:	8b 55 08             	mov    0x8(%ebp),%edx
c0101e71:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101e75:	89 04 24             	mov    %eax,(%esp)
c0101e78:	e8 ef 3c 00 00       	call   c0105b6c <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0101e7d:	8b 15 6c bf 11 c0    	mov    0xc011bf6c,%edx
c0101e83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e86:	83 e8 04             	sub    $0x4,%eax
c0101e89:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
c0101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8e:	89 04 24             	mov    %eax,(%esp)
c0101e91:	e8 12 fc ff ff       	call   c0101aa8 <print_trapframe>
            break;
c0101e96:	e9 ec 00 00 00       	jmp    c0101f87 <trap_dispatch+0x274>
            if (tf->tf_cs != USER_CS) {
c0101e9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ea2:	83 f8 1b             	cmp    $0x1b,%eax
c0101ea5:	0f 84 e2 00 00 00    	je     c0101f8d <trap_dispatch+0x27a>
            switchk2u = *tf;
c0101eab:	8b 55 08             	mov    0x8(%ebp),%edx
c0101eae:	b8 20 bf 11 c0       	mov    $0xc011bf20,%eax
c0101eb3:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101eb8:	89 c1                	mov    %eax,%ecx
c0101eba:	83 e1 01             	and    $0x1,%ecx
c0101ebd:	85 c9                	test   %ecx,%ecx
c0101ebf:	74 0c                	je     c0101ecd <trap_dispatch+0x1ba>
c0101ec1:	0f b6 0a             	movzbl (%edx),%ecx
c0101ec4:	88 08                	mov    %cl,(%eax)
c0101ec6:	8d 40 01             	lea    0x1(%eax),%eax
c0101ec9:	8d 52 01             	lea    0x1(%edx),%edx
c0101ecc:	4b                   	dec    %ebx
c0101ecd:	89 c1                	mov    %eax,%ecx
c0101ecf:	83 e1 02             	and    $0x2,%ecx
c0101ed2:	85 c9                	test   %ecx,%ecx
c0101ed4:	74 0f                	je     c0101ee5 <trap_dispatch+0x1d2>
c0101ed6:	0f b7 0a             	movzwl (%edx),%ecx
c0101ed9:	66 89 08             	mov    %cx,(%eax)
c0101edc:	8d 40 02             	lea    0x2(%eax),%eax
c0101edf:	8d 52 02             	lea    0x2(%edx),%edx
c0101ee2:	83 eb 02             	sub    $0x2,%ebx
c0101ee5:	89 df                	mov    %ebx,%edi
c0101ee7:	83 e7 fc             	and    $0xfffffffc,%edi
c0101eea:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101eef:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0101ef2:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0101ef5:	83 c1 04             	add    $0x4,%ecx
c0101ef8:	39 f9                	cmp    %edi,%ecx
c0101efa:	72 f3                	jb     c0101eef <trap_dispatch+0x1dc>
c0101efc:	01 c8                	add    %ecx,%eax
c0101efe:	01 ca                	add    %ecx,%edx
c0101f00:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101f05:	89 de                	mov    %ebx,%esi
c0101f07:	83 e6 02             	and    $0x2,%esi
c0101f0a:	85 f6                	test   %esi,%esi
c0101f0c:	74 0b                	je     c0101f19 <trap_dispatch+0x206>
c0101f0e:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0101f12:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0101f16:	83 c1 02             	add    $0x2,%ecx
c0101f19:	83 e3 01             	and    $0x1,%ebx
c0101f1c:	85 db                	test   %ebx,%ebx
c0101f1e:	74 07                	je     c0101f27 <trap_dispatch+0x214>
c0101f20:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0101f24:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
c0101f27:	66 c7 05 5c bf 11 c0 	movw   $0x1b,0xc011bf5c
c0101f2e:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0101f30:	66 c7 05 68 bf 11 c0 	movw   $0x23,0xc011bf68
c0101f37:	23 00 
c0101f39:	0f b7 05 68 bf 11 c0 	movzwl 0xc011bf68,%eax
c0101f40:	66 a3 48 bf 11 c0    	mov    %ax,0xc011bf48
c0101f46:	0f b7 05 48 bf 11 c0 	movzwl 0xc011bf48,%eax
c0101f4d:	66 a3 4c bf 11 c0    	mov    %ax,0xc011bf4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0101f53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f56:	83 c0 44             	add    $0x44,%eax
c0101f59:	a3 64 bf 11 c0       	mov    %eax,0xc011bf64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101f5e:	a1 60 bf 11 c0       	mov    0xc011bf60,%eax
c0101f63:	0d 00 30 00 00       	or     $0x3000,%eax
c0101f68:	a3 60 bf 11 c0       	mov    %eax,0xc011bf60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f70:	83 e8 04             	sub    $0x4,%eax
c0101f73:	ba 20 bf 11 c0       	mov    $0xc011bf20,%edx
c0101f78:	89 10                	mov    %edx,(%eax)
            print_trapframe(tf);
c0101f7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f7d:	89 04 24             	mov    %eax,(%esp)
c0101f80:	e8 23 fb ff ff       	call   c0101aa8 <print_trapframe>
        break;
c0101f85:	eb 06                	jmp    c0101f8d <trap_dispatch+0x27a>
            break;
c0101f87:	90                   	nop
c0101f88:	e9 a6 01 00 00       	jmp    c0102133 <trap_dispatch+0x420>
        break;
c0101f8d:	90                   	nop
        }
        break;  
c0101f8e:	e9 a0 01 00 00       	jmp    c0102133 <trap_dispatch+0x420>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
            if (tf->tf_cs != USER_CS) {
c0101f93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f96:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f9a:	83 f8 1b             	cmp    $0x1b,%eax
c0101f9d:	0f 84 8c 01 00 00    	je     c010212f <trap_dispatch+0x41c>
            switchk2u = *tf;
c0101fa3:	8b 55 08             	mov    0x8(%ebp),%edx
c0101fa6:	b8 20 bf 11 c0       	mov    $0xc011bf20,%eax
c0101fab:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101fb0:	89 c1                	mov    %eax,%ecx
c0101fb2:	83 e1 01             	and    $0x1,%ecx
c0101fb5:	85 c9                	test   %ecx,%ecx
c0101fb7:	74 0c                	je     c0101fc5 <trap_dispatch+0x2b2>
c0101fb9:	0f b6 0a             	movzbl (%edx),%ecx
c0101fbc:	88 08                	mov    %cl,(%eax)
c0101fbe:	8d 40 01             	lea    0x1(%eax),%eax
c0101fc1:	8d 52 01             	lea    0x1(%edx),%edx
c0101fc4:	4b                   	dec    %ebx
c0101fc5:	89 c1                	mov    %eax,%ecx
c0101fc7:	83 e1 02             	and    $0x2,%ecx
c0101fca:	85 c9                	test   %ecx,%ecx
c0101fcc:	74 0f                	je     c0101fdd <trap_dispatch+0x2ca>
c0101fce:	0f b7 0a             	movzwl (%edx),%ecx
c0101fd1:	66 89 08             	mov    %cx,(%eax)
c0101fd4:	8d 40 02             	lea    0x2(%eax),%eax
c0101fd7:	8d 52 02             	lea    0x2(%edx),%edx
c0101fda:	83 eb 02             	sub    $0x2,%ebx
c0101fdd:	89 df                	mov    %ebx,%edi
c0101fdf:	83 e7 fc             	and    $0xfffffffc,%edi
c0101fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101fe7:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0101fea:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0101fed:	83 c1 04             	add    $0x4,%ecx
c0101ff0:	39 f9                	cmp    %edi,%ecx
c0101ff2:	72 f3                	jb     c0101fe7 <trap_dispatch+0x2d4>
c0101ff4:	01 c8                	add    %ecx,%eax
c0101ff6:	01 ca                	add    %ecx,%edx
c0101ff8:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101ffd:	89 de                	mov    %ebx,%esi
c0101fff:	83 e6 02             	and    $0x2,%esi
c0102002:	85 f6                	test   %esi,%esi
c0102004:	74 0b                	je     c0102011 <trap_dispatch+0x2fe>
c0102006:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c010200a:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c010200e:	83 c1 02             	add    $0x2,%ecx
c0102011:	83 e3 01             	and    $0x1,%ebx
c0102014:	85 db                	test   %ebx,%ebx
c0102016:	74 07                	je     c010201f <trap_dispatch+0x30c>
c0102018:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c010201c:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
c010201f:	66 c7 05 5c bf 11 c0 	movw   $0x1b,0xc011bf5c
c0102026:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0102028:	66 c7 05 68 bf 11 c0 	movw   $0x23,0xc011bf68
c010202f:	23 00 
c0102031:	0f b7 05 68 bf 11 c0 	movzwl 0xc011bf68,%eax
c0102038:	66 a3 48 bf 11 c0    	mov    %ax,0xc011bf48
c010203e:	0f b7 05 48 bf 11 c0 	movzwl 0xc011bf48,%eax
c0102045:	66 a3 4c bf 11 c0    	mov    %ax,0xc011bf4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c010204b:	8b 45 08             	mov    0x8(%ebp),%eax
c010204e:	83 c0 44             	add    $0x44,%eax
c0102051:	a3 64 bf 11 c0       	mov    %eax,0xc011bf64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0102056:	a1 60 bf 11 c0       	mov    0xc011bf60,%eax
c010205b:	0d 00 30 00 00       	or     $0x3000,%eax
c0102060:	a3 60 bf 11 c0       	mov    %eax,0xc011bf60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0102065:	8b 45 08             	mov    0x8(%ebp),%eax
c0102068:	83 e8 04             	sub    $0x4,%eax
c010206b:	ba 20 bf 11 c0       	mov    $0xc011bf20,%edx
c0102070:	89 10                	mov    %edx,(%eax)
        }
        break;
c0102072:	e9 b8 00 00 00       	jmp    c010212f <trap_dispatch+0x41c>
    case T_SWITCH_TOK:
         if (tf->tf_cs != KERNEL_CS) {
c0102077:	8b 45 08             	mov    0x8(%ebp),%eax
c010207a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010207e:	83 f8 08             	cmp    $0x8,%eax
c0102081:	0f 84 ab 00 00 00    	je     c0102132 <trap_dispatch+0x41f>
            tf->tf_cs = KERNEL_CS;
c0102087:	8b 45 08             	mov    0x8(%ebp),%eax
c010208a:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0102090:	8b 45 08             	mov    0x8(%ebp),%eax
c0102093:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0102099:	8b 45 08             	mov    0x8(%ebp),%eax
c010209c:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c01020a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01020a3:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c01020a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01020aa:	8b 40 40             	mov    0x40(%eax),%eax
c01020ad:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c01020b2:	89 c2                	mov    %eax,%edx
c01020b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b7:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c01020ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01020bd:	8b 40 44             	mov    0x44(%eax),%eax
c01020c0:	83 e8 44             	sub    $0x44,%eax
c01020c3:	a3 6c bf 11 c0       	mov    %eax,0xc011bf6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c01020c8:	a1 6c bf 11 c0       	mov    0xc011bf6c,%eax
c01020cd:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c01020d4:	00 
c01020d5:	8b 55 08             	mov    0x8(%ebp),%edx
c01020d8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01020dc:	89 04 24             	mov    %eax,(%esp)
c01020df:	e8 88 3a 00 00       	call   c0105b6c <memmove>
            //*((uint32_t *)tf - 1) = (uint32_t)tf;
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c01020e4:	8b 15 6c bf 11 c0    	mov    0xc011bf6c,%edx
c01020ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01020ed:	83 e8 04             	sub    $0x4,%eax
c01020f0:	89 10                	mov    %edx,(%eax)
        }
        break;
c01020f2:	eb 3e                	jmp    c0102132 <trap_dispatch+0x41f>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01020f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01020f7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01020fb:	83 e0 03             	and    $0x3,%eax
c01020fe:	85 c0                	test   %eax,%eax
c0102100:	75 31                	jne    c0102133 <trap_dispatch+0x420>
            print_trapframe(tf);
c0102102:	8b 45 08             	mov    0x8(%ebp),%eax
c0102105:	89 04 24             	mov    %eax,(%esp)
c0102108:	e8 9b f9 ff ff       	call   c0101aa8 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010210d:	c7 44 24 08 b4 68 10 	movl   $0xc01068b4,0x8(%esp)
c0102114:	c0 
c0102115:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010211c:	00 
c010211d:	c7 04 24 ce 66 10 c0 	movl   $0xc01066ce,(%esp)
c0102124:	e8 d0 e2 ff ff       	call   c01003f9 <__panic>
        break;
c0102129:	90                   	nop
c010212a:	eb 07                	jmp    c0102133 <trap_dispatch+0x420>
        break;
c010212c:	90                   	nop
c010212d:	eb 04                	jmp    c0102133 <trap_dispatch+0x420>
        break;
c010212f:	90                   	nop
c0102130:	eb 01                	jmp    c0102133 <trap_dispatch+0x420>
        break;
c0102132:	90                   	nop
        }
    }
}
c0102133:	90                   	nop
c0102134:	83 c4 2c             	add    $0x2c,%esp
c0102137:	5b                   	pop    %ebx
c0102138:	5e                   	pop    %esi
c0102139:	5f                   	pop    %edi
c010213a:	5d                   	pop    %ebp
c010213b:	c3                   	ret    

c010213c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010213c:	55                   	push   %ebp
c010213d:	89 e5                	mov    %esp,%ebp
c010213f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102142:	8b 45 08             	mov    0x8(%ebp),%eax
c0102145:	89 04 24             	mov    %eax,(%esp)
c0102148:	e8 c6 fb ff ff       	call   c0101d13 <trap_dispatch>
}
c010214d:	90                   	nop
c010214e:	c9                   	leave  
c010214f:	c3                   	ret    

c0102150 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $0
c0102152:	6a 00                	push   $0x0
  jmp __alltraps
c0102154:	e9 69 0a 00 00       	jmp    c0102bc2 <__alltraps>

c0102159 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $1
c010215b:	6a 01                	push   $0x1
  jmp __alltraps
c010215d:	e9 60 0a 00 00       	jmp    c0102bc2 <__alltraps>

c0102162 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $2
c0102164:	6a 02                	push   $0x2
  jmp __alltraps
c0102166:	e9 57 0a 00 00       	jmp    c0102bc2 <__alltraps>

c010216b <vector3>:
.globl vector3
vector3:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $3
c010216d:	6a 03                	push   $0x3
  jmp __alltraps
c010216f:	e9 4e 0a 00 00       	jmp    c0102bc2 <__alltraps>

c0102174 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $4
c0102176:	6a 04                	push   $0x4
  jmp __alltraps
c0102178:	e9 45 0a 00 00       	jmp    c0102bc2 <__alltraps>

c010217d <vector5>:
.globl vector5
vector5:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $5
c010217f:	6a 05                	push   $0x5
  jmp __alltraps
c0102181:	e9 3c 0a 00 00       	jmp    c0102bc2 <__alltraps>

c0102186 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $6
c0102188:	6a 06                	push   $0x6
  jmp __alltraps
c010218a:	e9 33 0a 00 00       	jmp    c0102bc2 <__alltraps>

c010218f <vector7>:
.globl vector7
vector7:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $7
c0102191:	6a 07                	push   $0x7
  jmp __alltraps
c0102193:	e9 2a 0a 00 00       	jmp    c0102bc2 <__alltraps>

c0102198 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102198:	6a 08                	push   $0x8
  jmp __alltraps
c010219a:	e9 23 0a 00 00       	jmp    c0102bc2 <__alltraps>

c010219f <vector9>:
.globl vector9
vector9:
  pushl $0
c010219f:	6a 00                	push   $0x0
  pushl $9
c01021a1:	6a 09                	push   $0x9
  jmp __alltraps
c01021a3:	e9 1a 0a 00 00       	jmp    c0102bc2 <__alltraps>

c01021a8 <vector10>:
.globl vector10
vector10:
  pushl $10
c01021a8:	6a 0a                	push   $0xa
  jmp __alltraps
c01021aa:	e9 13 0a 00 00       	jmp    c0102bc2 <__alltraps>

c01021af <vector11>:
.globl vector11
vector11:
  pushl $11
c01021af:	6a 0b                	push   $0xb
  jmp __alltraps
c01021b1:	e9 0c 0a 00 00       	jmp    c0102bc2 <__alltraps>

c01021b6 <vector12>:
.globl vector12
vector12:
  pushl $12
c01021b6:	6a 0c                	push   $0xc
  jmp __alltraps
c01021b8:	e9 05 0a 00 00       	jmp    c0102bc2 <__alltraps>

c01021bd <vector13>:
.globl vector13
vector13:
  pushl $13
c01021bd:	6a 0d                	push   $0xd
  jmp __alltraps
c01021bf:	e9 fe 09 00 00       	jmp    c0102bc2 <__alltraps>

c01021c4 <vector14>:
.globl vector14
vector14:
  pushl $14
c01021c4:	6a 0e                	push   $0xe
  jmp __alltraps
c01021c6:	e9 f7 09 00 00       	jmp    c0102bc2 <__alltraps>

c01021cb <vector15>:
.globl vector15
vector15:
  pushl $0
c01021cb:	6a 00                	push   $0x0
  pushl $15
c01021cd:	6a 0f                	push   $0xf
  jmp __alltraps
c01021cf:	e9 ee 09 00 00       	jmp    c0102bc2 <__alltraps>

c01021d4 <vector16>:
.globl vector16
vector16:
  pushl $0
c01021d4:	6a 00                	push   $0x0
  pushl $16
c01021d6:	6a 10                	push   $0x10
  jmp __alltraps
c01021d8:	e9 e5 09 00 00       	jmp    c0102bc2 <__alltraps>

c01021dd <vector17>:
.globl vector17
vector17:
  pushl $17
c01021dd:	6a 11                	push   $0x11
  jmp __alltraps
c01021df:	e9 de 09 00 00       	jmp    c0102bc2 <__alltraps>

c01021e4 <vector18>:
.globl vector18
vector18:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $18
c01021e6:	6a 12                	push   $0x12
  jmp __alltraps
c01021e8:	e9 d5 09 00 00       	jmp    c0102bc2 <__alltraps>

c01021ed <vector19>:
.globl vector19
vector19:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $19
c01021ef:	6a 13                	push   $0x13
  jmp __alltraps
c01021f1:	e9 cc 09 00 00       	jmp    c0102bc2 <__alltraps>

c01021f6 <vector20>:
.globl vector20
vector20:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $20
c01021f8:	6a 14                	push   $0x14
  jmp __alltraps
c01021fa:	e9 c3 09 00 00       	jmp    c0102bc2 <__alltraps>

c01021ff <vector21>:
.globl vector21
vector21:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $21
c0102201:	6a 15                	push   $0x15
  jmp __alltraps
c0102203:	e9 ba 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102208 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $22
c010220a:	6a 16                	push   $0x16
  jmp __alltraps
c010220c:	e9 b1 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102211 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $23
c0102213:	6a 17                	push   $0x17
  jmp __alltraps
c0102215:	e9 a8 09 00 00       	jmp    c0102bc2 <__alltraps>

c010221a <vector24>:
.globl vector24
vector24:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $24
c010221c:	6a 18                	push   $0x18
  jmp __alltraps
c010221e:	e9 9f 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102223 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $25
c0102225:	6a 19                	push   $0x19
  jmp __alltraps
c0102227:	e9 96 09 00 00       	jmp    c0102bc2 <__alltraps>

c010222c <vector26>:
.globl vector26
vector26:
  pushl $0
c010222c:	6a 00                	push   $0x0
  pushl $26
c010222e:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102230:	e9 8d 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102235 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $27
c0102237:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102239:	e9 84 09 00 00       	jmp    c0102bc2 <__alltraps>

c010223e <vector28>:
.globl vector28
vector28:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $28
c0102240:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102242:	e9 7b 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102247 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $29
c0102249:	6a 1d                	push   $0x1d
  jmp __alltraps
c010224b:	e9 72 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102250 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102250:	6a 00                	push   $0x0
  pushl $30
c0102252:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102254:	e9 69 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102259 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $31
c010225b:	6a 1f                	push   $0x1f
  jmp __alltraps
c010225d:	e9 60 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102262 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $32
c0102264:	6a 20                	push   $0x20
  jmp __alltraps
c0102266:	e9 57 09 00 00       	jmp    c0102bc2 <__alltraps>

c010226b <vector33>:
.globl vector33
vector33:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $33
c010226d:	6a 21                	push   $0x21
  jmp __alltraps
c010226f:	e9 4e 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102274 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102274:	6a 00                	push   $0x0
  pushl $34
c0102276:	6a 22                	push   $0x22
  jmp __alltraps
c0102278:	e9 45 09 00 00       	jmp    c0102bc2 <__alltraps>

c010227d <vector35>:
.globl vector35
vector35:
  pushl $0
c010227d:	6a 00                	push   $0x0
  pushl $35
c010227f:	6a 23                	push   $0x23
  jmp __alltraps
c0102281:	e9 3c 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102286 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $36
c0102288:	6a 24                	push   $0x24
  jmp __alltraps
c010228a:	e9 33 09 00 00       	jmp    c0102bc2 <__alltraps>

c010228f <vector37>:
.globl vector37
vector37:
  pushl $0
c010228f:	6a 00                	push   $0x0
  pushl $37
c0102291:	6a 25                	push   $0x25
  jmp __alltraps
c0102293:	e9 2a 09 00 00       	jmp    c0102bc2 <__alltraps>

c0102298 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $38
c010229a:	6a 26                	push   $0x26
  jmp __alltraps
c010229c:	e9 21 09 00 00       	jmp    c0102bc2 <__alltraps>

c01022a1 <vector39>:
.globl vector39
vector39:
  pushl $0
c01022a1:	6a 00                	push   $0x0
  pushl $39
c01022a3:	6a 27                	push   $0x27
  jmp __alltraps
c01022a5:	e9 18 09 00 00       	jmp    c0102bc2 <__alltraps>

c01022aa <vector40>:
.globl vector40
vector40:
  pushl $0
c01022aa:	6a 00                	push   $0x0
  pushl $40
c01022ac:	6a 28                	push   $0x28
  jmp __alltraps
c01022ae:	e9 0f 09 00 00       	jmp    c0102bc2 <__alltraps>

c01022b3 <vector41>:
.globl vector41
vector41:
  pushl $0
c01022b3:	6a 00                	push   $0x0
  pushl $41
c01022b5:	6a 29                	push   $0x29
  jmp __alltraps
c01022b7:	e9 06 09 00 00       	jmp    c0102bc2 <__alltraps>

c01022bc <vector42>:
.globl vector42
vector42:
  pushl $0
c01022bc:	6a 00                	push   $0x0
  pushl $42
c01022be:	6a 2a                	push   $0x2a
  jmp __alltraps
c01022c0:	e9 fd 08 00 00       	jmp    c0102bc2 <__alltraps>

c01022c5 <vector43>:
.globl vector43
vector43:
  pushl $0
c01022c5:	6a 00                	push   $0x0
  pushl $43
c01022c7:	6a 2b                	push   $0x2b
  jmp __alltraps
c01022c9:	e9 f4 08 00 00       	jmp    c0102bc2 <__alltraps>

c01022ce <vector44>:
.globl vector44
vector44:
  pushl $0
c01022ce:	6a 00                	push   $0x0
  pushl $44
c01022d0:	6a 2c                	push   $0x2c
  jmp __alltraps
c01022d2:	e9 eb 08 00 00       	jmp    c0102bc2 <__alltraps>

c01022d7 <vector45>:
.globl vector45
vector45:
  pushl $0
c01022d7:	6a 00                	push   $0x0
  pushl $45
c01022d9:	6a 2d                	push   $0x2d
  jmp __alltraps
c01022db:	e9 e2 08 00 00       	jmp    c0102bc2 <__alltraps>

c01022e0 <vector46>:
.globl vector46
vector46:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $46
c01022e2:	6a 2e                	push   $0x2e
  jmp __alltraps
c01022e4:	e9 d9 08 00 00       	jmp    c0102bc2 <__alltraps>

c01022e9 <vector47>:
.globl vector47
vector47:
  pushl $0
c01022e9:	6a 00                	push   $0x0
  pushl $47
c01022eb:	6a 2f                	push   $0x2f
  jmp __alltraps
c01022ed:	e9 d0 08 00 00       	jmp    c0102bc2 <__alltraps>

c01022f2 <vector48>:
.globl vector48
vector48:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $48
c01022f4:	6a 30                	push   $0x30
  jmp __alltraps
c01022f6:	e9 c7 08 00 00       	jmp    c0102bc2 <__alltraps>

c01022fb <vector49>:
.globl vector49
vector49:
  pushl $0
c01022fb:	6a 00                	push   $0x0
  pushl $49
c01022fd:	6a 31                	push   $0x31
  jmp __alltraps
c01022ff:	e9 be 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102304 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $50
c0102306:	6a 32                	push   $0x32
  jmp __alltraps
c0102308:	e9 b5 08 00 00       	jmp    c0102bc2 <__alltraps>

c010230d <vector51>:
.globl vector51
vector51:
  pushl $0
c010230d:	6a 00                	push   $0x0
  pushl $51
c010230f:	6a 33                	push   $0x33
  jmp __alltraps
c0102311:	e9 ac 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102316 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $52
c0102318:	6a 34                	push   $0x34
  jmp __alltraps
c010231a:	e9 a3 08 00 00       	jmp    c0102bc2 <__alltraps>

c010231f <vector53>:
.globl vector53
vector53:
  pushl $0
c010231f:	6a 00                	push   $0x0
  pushl $53
c0102321:	6a 35                	push   $0x35
  jmp __alltraps
c0102323:	e9 9a 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102328 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $54
c010232a:	6a 36                	push   $0x36
  jmp __alltraps
c010232c:	e9 91 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102331 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102331:	6a 00                	push   $0x0
  pushl $55
c0102333:	6a 37                	push   $0x37
  jmp __alltraps
c0102335:	e9 88 08 00 00       	jmp    c0102bc2 <__alltraps>

c010233a <vector56>:
.globl vector56
vector56:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $56
c010233c:	6a 38                	push   $0x38
  jmp __alltraps
c010233e:	e9 7f 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102343 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102343:	6a 00                	push   $0x0
  pushl $57
c0102345:	6a 39                	push   $0x39
  jmp __alltraps
c0102347:	e9 76 08 00 00       	jmp    c0102bc2 <__alltraps>

c010234c <vector58>:
.globl vector58
vector58:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $58
c010234e:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102350:	e9 6d 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102355 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102355:	6a 00                	push   $0x0
  pushl $59
c0102357:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102359:	e9 64 08 00 00       	jmp    c0102bc2 <__alltraps>

c010235e <vector60>:
.globl vector60
vector60:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $60
c0102360:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102362:	e9 5b 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102367 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102367:	6a 00                	push   $0x0
  pushl $61
c0102369:	6a 3d                	push   $0x3d
  jmp __alltraps
c010236b:	e9 52 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102370 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $62
c0102372:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102374:	e9 49 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102379 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102379:	6a 00                	push   $0x0
  pushl $63
c010237b:	6a 3f                	push   $0x3f
  jmp __alltraps
c010237d:	e9 40 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102382 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $64
c0102384:	6a 40                	push   $0x40
  jmp __alltraps
c0102386:	e9 37 08 00 00       	jmp    c0102bc2 <__alltraps>

c010238b <vector65>:
.globl vector65
vector65:
  pushl $0
c010238b:	6a 00                	push   $0x0
  pushl $65
c010238d:	6a 41                	push   $0x41
  jmp __alltraps
c010238f:	e9 2e 08 00 00       	jmp    c0102bc2 <__alltraps>

c0102394 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $66
c0102396:	6a 42                	push   $0x42
  jmp __alltraps
c0102398:	e9 25 08 00 00       	jmp    c0102bc2 <__alltraps>

c010239d <vector67>:
.globl vector67
vector67:
  pushl $0
c010239d:	6a 00                	push   $0x0
  pushl $67
c010239f:	6a 43                	push   $0x43
  jmp __alltraps
c01023a1:	e9 1c 08 00 00       	jmp    c0102bc2 <__alltraps>

c01023a6 <vector68>:
.globl vector68
vector68:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $68
c01023a8:	6a 44                	push   $0x44
  jmp __alltraps
c01023aa:	e9 13 08 00 00       	jmp    c0102bc2 <__alltraps>

c01023af <vector69>:
.globl vector69
vector69:
  pushl $0
c01023af:	6a 00                	push   $0x0
  pushl $69
c01023b1:	6a 45                	push   $0x45
  jmp __alltraps
c01023b3:	e9 0a 08 00 00       	jmp    c0102bc2 <__alltraps>

c01023b8 <vector70>:
.globl vector70
vector70:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $70
c01023ba:	6a 46                	push   $0x46
  jmp __alltraps
c01023bc:	e9 01 08 00 00       	jmp    c0102bc2 <__alltraps>

c01023c1 <vector71>:
.globl vector71
vector71:
  pushl $0
c01023c1:	6a 00                	push   $0x0
  pushl $71
c01023c3:	6a 47                	push   $0x47
  jmp __alltraps
c01023c5:	e9 f8 07 00 00       	jmp    c0102bc2 <__alltraps>

c01023ca <vector72>:
.globl vector72
vector72:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $72
c01023cc:	6a 48                	push   $0x48
  jmp __alltraps
c01023ce:	e9 ef 07 00 00       	jmp    c0102bc2 <__alltraps>

c01023d3 <vector73>:
.globl vector73
vector73:
  pushl $0
c01023d3:	6a 00                	push   $0x0
  pushl $73
c01023d5:	6a 49                	push   $0x49
  jmp __alltraps
c01023d7:	e9 e6 07 00 00       	jmp    c0102bc2 <__alltraps>

c01023dc <vector74>:
.globl vector74
vector74:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $74
c01023de:	6a 4a                	push   $0x4a
  jmp __alltraps
c01023e0:	e9 dd 07 00 00       	jmp    c0102bc2 <__alltraps>

c01023e5 <vector75>:
.globl vector75
vector75:
  pushl $0
c01023e5:	6a 00                	push   $0x0
  pushl $75
c01023e7:	6a 4b                	push   $0x4b
  jmp __alltraps
c01023e9:	e9 d4 07 00 00       	jmp    c0102bc2 <__alltraps>

c01023ee <vector76>:
.globl vector76
vector76:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $76
c01023f0:	6a 4c                	push   $0x4c
  jmp __alltraps
c01023f2:	e9 cb 07 00 00       	jmp    c0102bc2 <__alltraps>

c01023f7 <vector77>:
.globl vector77
vector77:
  pushl $0
c01023f7:	6a 00                	push   $0x0
  pushl $77
c01023f9:	6a 4d                	push   $0x4d
  jmp __alltraps
c01023fb:	e9 c2 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102400 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102400:	6a 00                	push   $0x0
  pushl $78
c0102402:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102404:	e9 b9 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102409 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102409:	6a 00                	push   $0x0
  pushl $79
c010240b:	6a 4f                	push   $0x4f
  jmp __alltraps
c010240d:	e9 b0 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102412 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102412:	6a 00                	push   $0x0
  pushl $80
c0102414:	6a 50                	push   $0x50
  jmp __alltraps
c0102416:	e9 a7 07 00 00       	jmp    c0102bc2 <__alltraps>

c010241b <vector81>:
.globl vector81
vector81:
  pushl $0
c010241b:	6a 00                	push   $0x0
  pushl $81
c010241d:	6a 51                	push   $0x51
  jmp __alltraps
c010241f:	e9 9e 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102424 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102424:	6a 00                	push   $0x0
  pushl $82
c0102426:	6a 52                	push   $0x52
  jmp __alltraps
c0102428:	e9 95 07 00 00       	jmp    c0102bc2 <__alltraps>

c010242d <vector83>:
.globl vector83
vector83:
  pushl $0
c010242d:	6a 00                	push   $0x0
  pushl $83
c010242f:	6a 53                	push   $0x53
  jmp __alltraps
c0102431:	e9 8c 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102436 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102436:	6a 00                	push   $0x0
  pushl $84
c0102438:	6a 54                	push   $0x54
  jmp __alltraps
c010243a:	e9 83 07 00 00       	jmp    c0102bc2 <__alltraps>

c010243f <vector85>:
.globl vector85
vector85:
  pushl $0
c010243f:	6a 00                	push   $0x0
  pushl $85
c0102441:	6a 55                	push   $0x55
  jmp __alltraps
c0102443:	e9 7a 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102448 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102448:	6a 00                	push   $0x0
  pushl $86
c010244a:	6a 56                	push   $0x56
  jmp __alltraps
c010244c:	e9 71 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102451 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102451:	6a 00                	push   $0x0
  pushl $87
c0102453:	6a 57                	push   $0x57
  jmp __alltraps
c0102455:	e9 68 07 00 00       	jmp    c0102bc2 <__alltraps>

c010245a <vector88>:
.globl vector88
vector88:
  pushl $0
c010245a:	6a 00                	push   $0x0
  pushl $88
c010245c:	6a 58                	push   $0x58
  jmp __alltraps
c010245e:	e9 5f 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102463 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102463:	6a 00                	push   $0x0
  pushl $89
c0102465:	6a 59                	push   $0x59
  jmp __alltraps
c0102467:	e9 56 07 00 00       	jmp    c0102bc2 <__alltraps>

c010246c <vector90>:
.globl vector90
vector90:
  pushl $0
c010246c:	6a 00                	push   $0x0
  pushl $90
c010246e:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102470:	e9 4d 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102475 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102475:	6a 00                	push   $0x0
  pushl $91
c0102477:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102479:	e9 44 07 00 00       	jmp    c0102bc2 <__alltraps>

c010247e <vector92>:
.globl vector92
vector92:
  pushl $0
c010247e:	6a 00                	push   $0x0
  pushl $92
c0102480:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102482:	e9 3b 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102487 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102487:	6a 00                	push   $0x0
  pushl $93
c0102489:	6a 5d                	push   $0x5d
  jmp __alltraps
c010248b:	e9 32 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102490 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102490:	6a 00                	push   $0x0
  pushl $94
c0102492:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102494:	e9 29 07 00 00       	jmp    c0102bc2 <__alltraps>

c0102499 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102499:	6a 00                	push   $0x0
  pushl $95
c010249b:	6a 5f                	push   $0x5f
  jmp __alltraps
c010249d:	e9 20 07 00 00       	jmp    c0102bc2 <__alltraps>

c01024a2 <vector96>:
.globl vector96
vector96:
  pushl $0
c01024a2:	6a 00                	push   $0x0
  pushl $96
c01024a4:	6a 60                	push   $0x60
  jmp __alltraps
c01024a6:	e9 17 07 00 00       	jmp    c0102bc2 <__alltraps>

c01024ab <vector97>:
.globl vector97
vector97:
  pushl $0
c01024ab:	6a 00                	push   $0x0
  pushl $97
c01024ad:	6a 61                	push   $0x61
  jmp __alltraps
c01024af:	e9 0e 07 00 00       	jmp    c0102bc2 <__alltraps>

c01024b4 <vector98>:
.globl vector98
vector98:
  pushl $0
c01024b4:	6a 00                	push   $0x0
  pushl $98
c01024b6:	6a 62                	push   $0x62
  jmp __alltraps
c01024b8:	e9 05 07 00 00       	jmp    c0102bc2 <__alltraps>

c01024bd <vector99>:
.globl vector99
vector99:
  pushl $0
c01024bd:	6a 00                	push   $0x0
  pushl $99
c01024bf:	6a 63                	push   $0x63
  jmp __alltraps
c01024c1:	e9 fc 06 00 00       	jmp    c0102bc2 <__alltraps>

c01024c6 <vector100>:
.globl vector100
vector100:
  pushl $0
c01024c6:	6a 00                	push   $0x0
  pushl $100
c01024c8:	6a 64                	push   $0x64
  jmp __alltraps
c01024ca:	e9 f3 06 00 00       	jmp    c0102bc2 <__alltraps>

c01024cf <vector101>:
.globl vector101
vector101:
  pushl $0
c01024cf:	6a 00                	push   $0x0
  pushl $101
c01024d1:	6a 65                	push   $0x65
  jmp __alltraps
c01024d3:	e9 ea 06 00 00       	jmp    c0102bc2 <__alltraps>

c01024d8 <vector102>:
.globl vector102
vector102:
  pushl $0
c01024d8:	6a 00                	push   $0x0
  pushl $102
c01024da:	6a 66                	push   $0x66
  jmp __alltraps
c01024dc:	e9 e1 06 00 00       	jmp    c0102bc2 <__alltraps>

c01024e1 <vector103>:
.globl vector103
vector103:
  pushl $0
c01024e1:	6a 00                	push   $0x0
  pushl $103
c01024e3:	6a 67                	push   $0x67
  jmp __alltraps
c01024e5:	e9 d8 06 00 00       	jmp    c0102bc2 <__alltraps>

c01024ea <vector104>:
.globl vector104
vector104:
  pushl $0
c01024ea:	6a 00                	push   $0x0
  pushl $104
c01024ec:	6a 68                	push   $0x68
  jmp __alltraps
c01024ee:	e9 cf 06 00 00       	jmp    c0102bc2 <__alltraps>

c01024f3 <vector105>:
.globl vector105
vector105:
  pushl $0
c01024f3:	6a 00                	push   $0x0
  pushl $105
c01024f5:	6a 69                	push   $0x69
  jmp __alltraps
c01024f7:	e9 c6 06 00 00       	jmp    c0102bc2 <__alltraps>

c01024fc <vector106>:
.globl vector106
vector106:
  pushl $0
c01024fc:	6a 00                	push   $0x0
  pushl $106
c01024fe:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102500:	e9 bd 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102505 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102505:	6a 00                	push   $0x0
  pushl $107
c0102507:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102509:	e9 b4 06 00 00       	jmp    c0102bc2 <__alltraps>

c010250e <vector108>:
.globl vector108
vector108:
  pushl $0
c010250e:	6a 00                	push   $0x0
  pushl $108
c0102510:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102512:	e9 ab 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102517 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102517:	6a 00                	push   $0x0
  pushl $109
c0102519:	6a 6d                	push   $0x6d
  jmp __alltraps
c010251b:	e9 a2 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102520 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102520:	6a 00                	push   $0x0
  pushl $110
c0102522:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102524:	e9 99 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102529 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102529:	6a 00                	push   $0x0
  pushl $111
c010252b:	6a 6f                	push   $0x6f
  jmp __alltraps
c010252d:	e9 90 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102532 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102532:	6a 00                	push   $0x0
  pushl $112
c0102534:	6a 70                	push   $0x70
  jmp __alltraps
c0102536:	e9 87 06 00 00       	jmp    c0102bc2 <__alltraps>

c010253b <vector113>:
.globl vector113
vector113:
  pushl $0
c010253b:	6a 00                	push   $0x0
  pushl $113
c010253d:	6a 71                	push   $0x71
  jmp __alltraps
c010253f:	e9 7e 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102544 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102544:	6a 00                	push   $0x0
  pushl $114
c0102546:	6a 72                	push   $0x72
  jmp __alltraps
c0102548:	e9 75 06 00 00       	jmp    c0102bc2 <__alltraps>

c010254d <vector115>:
.globl vector115
vector115:
  pushl $0
c010254d:	6a 00                	push   $0x0
  pushl $115
c010254f:	6a 73                	push   $0x73
  jmp __alltraps
c0102551:	e9 6c 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102556 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102556:	6a 00                	push   $0x0
  pushl $116
c0102558:	6a 74                	push   $0x74
  jmp __alltraps
c010255a:	e9 63 06 00 00       	jmp    c0102bc2 <__alltraps>

c010255f <vector117>:
.globl vector117
vector117:
  pushl $0
c010255f:	6a 00                	push   $0x0
  pushl $117
c0102561:	6a 75                	push   $0x75
  jmp __alltraps
c0102563:	e9 5a 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102568 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102568:	6a 00                	push   $0x0
  pushl $118
c010256a:	6a 76                	push   $0x76
  jmp __alltraps
c010256c:	e9 51 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102571 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102571:	6a 00                	push   $0x0
  pushl $119
c0102573:	6a 77                	push   $0x77
  jmp __alltraps
c0102575:	e9 48 06 00 00       	jmp    c0102bc2 <__alltraps>

c010257a <vector120>:
.globl vector120
vector120:
  pushl $0
c010257a:	6a 00                	push   $0x0
  pushl $120
c010257c:	6a 78                	push   $0x78
  jmp __alltraps
c010257e:	e9 3f 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102583 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102583:	6a 00                	push   $0x0
  pushl $121
c0102585:	6a 79                	push   $0x79
  jmp __alltraps
c0102587:	e9 36 06 00 00       	jmp    c0102bc2 <__alltraps>

c010258c <vector122>:
.globl vector122
vector122:
  pushl $0
c010258c:	6a 00                	push   $0x0
  pushl $122
c010258e:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102590:	e9 2d 06 00 00       	jmp    c0102bc2 <__alltraps>

c0102595 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102595:	6a 00                	push   $0x0
  pushl $123
c0102597:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102599:	e9 24 06 00 00       	jmp    c0102bc2 <__alltraps>

c010259e <vector124>:
.globl vector124
vector124:
  pushl $0
c010259e:	6a 00                	push   $0x0
  pushl $124
c01025a0:	6a 7c                	push   $0x7c
  jmp __alltraps
c01025a2:	e9 1b 06 00 00       	jmp    c0102bc2 <__alltraps>

c01025a7 <vector125>:
.globl vector125
vector125:
  pushl $0
c01025a7:	6a 00                	push   $0x0
  pushl $125
c01025a9:	6a 7d                	push   $0x7d
  jmp __alltraps
c01025ab:	e9 12 06 00 00       	jmp    c0102bc2 <__alltraps>

c01025b0 <vector126>:
.globl vector126
vector126:
  pushl $0
c01025b0:	6a 00                	push   $0x0
  pushl $126
c01025b2:	6a 7e                	push   $0x7e
  jmp __alltraps
c01025b4:	e9 09 06 00 00       	jmp    c0102bc2 <__alltraps>

c01025b9 <vector127>:
.globl vector127
vector127:
  pushl $0
c01025b9:	6a 00                	push   $0x0
  pushl $127
c01025bb:	6a 7f                	push   $0x7f
  jmp __alltraps
c01025bd:	e9 00 06 00 00       	jmp    c0102bc2 <__alltraps>

c01025c2 <vector128>:
.globl vector128
vector128:
  pushl $0
c01025c2:	6a 00                	push   $0x0
  pushl $128
c01025c4:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01025c9:	e9 f4 05 00 00       	jmp    c0102bc2 <__alltraps>

c01025ce <vector129>:
.globl vector129
vector129:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $129
c01025d0:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01025d5:	e9 e8 05 00 00       	jmp    c0102bc2 <__alltraps>

c01025da <vector130>:
.globl vector130
vector130:
  pushl $0
c01025da:	6a 00                	push   $0x0
  pushl $130
c01025dc:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01025e1:	e9 dc 05 00 00       	jmp    c0102bc2 <__alltraps>

c01025e6 <vector131>:
.globl vector131
vector131:
  pushl $0
c01025e6:	6a 00                	push   $0x0
  pushl $131
c01025e8:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01025ed:	e9 d0 05 00 00       	jmp    c0102bc2 <__alltraps>

c01025f2 <vector132>:
.globl vector132
vector132:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $132
c01025f4:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01025f9:	e9 c4 05 00 00       	jmp    c0102bc2 <__alltraps>

c01025fe <vector133>:
.globl vector133
vector133:
  pushl $0
c01025fe:	6a 00                	push   $0x0
  pushl $133
c0102600:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102605:	e9 b8 05 00 00       	jmp    c0102bc2 <__alltraps>

c010260a <vector134>:
.globl vector134
vector134:
  pushl $0
c010260a:	6a 00                	push   $0x0
  pushl $134
c010260c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102611:	e9 ac 05 00 00       	jmp    c0102bc2 <__alltraps>

c0102616 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $135
c0102618:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010261d:	e9 a0 05 00 00       	jmp    c0102bc2 <__alltraps>

c0102622 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102622:	6a 00                	push   $0x0
  pushl $136
c0102624:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102629:	e9 94 05 00 00       	jmp    c0102bc2 <__alltraps>

c010262e <vector137>:
.globl vector137
vector137:
  pushl $0
c010262e:	6a 00                	push   $0x0
  pushl $137
c0102630:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102635:	e9 88 05 00 00       	jmp    c0102bc2 <__alltraps>

c010263a <vector138>:
.globl vector138
vector138:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $138
c010263c:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102641:	e9 7c 05 00 00       	jmp    c0102bc2 <__alltraps>

c0102646 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102646:	6a 00                	push   $0x0
  pushl $139
c0102648:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010264d:	e9 70 05 00 00       	jmp    c0102bc2 <__alltraps>

c0102652 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102652:	6a 00                	push   $0x0
  pushl $140
c0102654:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102659:	e9 64 05 00 00       	jmp    c0102bc2 <__alltraps>

c010265e <vector141>:
.globl vector141
vector141:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $141
c0102660:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102665:	e9 58 05 00 00       	jmp    c0102bc2 <__alltraps>

c010266a <vector142>:
.globl vector142
vector142:
  pushl $0
c010266a:	6a 00                	push   $0x0
  pushl $142
c010266c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102671:	e9 4c 05 00 00       	jmp    c0102bc2 <__alltraps>

c0102676 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102676:	6a 00                	push   $0x0
  pushl $143
c0102678:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010267d:	e9 40 05 00 00       	jmp    c0102bc2 <__alltraps>

c0102682 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $144
c0102684:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102689:	e9 34 05 00 00       	jmp    c0102bc2 <__alltraps>

c010268e <vector145>:
.globl vector145
vector145:
  pushl $0
c010268e:	6a 00                	push   $0x0
  pushl $145
c0102690:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102695:	e9 28 05 00 00       	jmp    c0102bc2 <__alltraps>

c010269a <vector146>:
.globl vector146
vector146:
  pushl $0
c010269a:	6a 00                	push   $0x0
  pushl $146
c010269c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01026a1:	e9 1c 05 00 00       	jmp    c0102bc2 <__alltraps>

c01026a6 <vector147>:
.globl vector147
vector147:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $147
c01026a8:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01026ad:	e9 10 05 00 00       	jmp    c0102bc2 <__alltraps>

c01026b2 <vector148>:
.globl vector148
vector148:
  pushl $0
c01026b2:	6a 00                	push   $0x0
  pushl $148
c01026b4:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01026b9:	e9 04 05 00 00       	jmp    c0102bc2 <__alltraps>

c01026be <vector149>:
.globl vector149
vector149:
  pushl $0
c01026be:	6a 00                	push   $0x0
  pushl $149
c01026c0:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01026c5:	e9 f8 04 00 00       	jmp    c0102bc2 <__alltraps>

c01026ca <vector150>:
.globl vector150
vector150:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $150
c01026cc:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01026d1:	e9 ec 04 00 00       	jmp    c0102bc2 <__alltraps>

c01026d6 <vector151>:
.globl vector151
vector151:
  pushl $0
c01026d6:	6a 00                	push   $0x0
  pushl $151
c01026d8:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01026dd:	e9 e0 04 00 00       	jmp    c0102bc2 <__alltraps>

c01026e2 <vector152>:
.globl vector152
vector152:
  pushl $0
c01026e2:	6a 00                	push   $0x0
  pushl $152
c01026e4:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01026e9:	e9 d4 04 00 00       	jmp    c0102bc2 <__alltraps>

c01026ee <vector153>:
.globl vector153
vector153:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $153
c01026f0:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01026f5:	e9 c8 04 00 00       	jmp    c0102bc2 <__alltraps>

c01026fa <vector154>:
.globl vector154
vector154:
  pushl $0
c01026fa:	6a 00                	push   $0x0
  pushl $154
c01026fc:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102701:	e9 bc 04 00 00       	jmp    c0102bc2 <__alltraps>

c0102706 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102706:	6a 00                	push   $0x0
  pushl $155
c0102708:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010270d:	e9 b0 04 00 00       	jmp    c0102bc2 <__alltraps>

c0102712 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $156
c0102714:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102719:	e9 a4 04 00 00       	jmp    c0102bc2 <__alltraps>

c010271e <vector157>:
.globl vector157
vector157:
  pushl $0
c010271e:	6a 00                	push   $0x0
  pushl $157
c0102720:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102725:	e9 98 04 00 00       	jmp    c0102bc2 <__alltraps>

c010272a <vector158>:
.globl vector158
vector158:
  pushl $0
c010272a:	6a 00                	push   $0x0
  pushl $158
c010272c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102731:	e9 8c 04 00 00       	jmp    c0102bc2 <__alltraps>

c0102736 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102736:	6a 00                	push   $0x0
  pushl $159
c0102738:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010273d:	e9 80 04 00 00       	jmp    c0102bc2 <__alltraps>

c0102742 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102742:	6a 00                	push   $0x0
  pushl $160
c0102744:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102749:	e9 74 04 00 00       	jmp    c0102bc2 <__alltraps>

c010274e <vector161>:
.globl vector161
vector161:
  pushl $0
c010274e:	6a 00                	push   $0x0
  pushl $161
c0102750:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102755:	e9 68 04 00 00       	jmp    c0102bc2 <__alltraps>

c010275a <vector162>:
.globl vector162
vector162:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $162
c010275c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102761:	e9 5c 04 00 00       	jmp    c0102bc2 <__alltraps>

c0102766 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102766:	6a 00                	push   $0x0
  pushl $163
c0102768:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010276d:	e9 50 04 00 00       	jmp    c0102bc2 <__alltraps>

c0102772 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $164
c0102774:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102779:	e9 44 04 00 00       	jmp    c0102bc2 <__alltraps>

c010277e <vector165>:
.globl vector165
vector165:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $165
c0102780:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102785:	e9 38 04 00 00       	jmp    c0102bc2 <__alltraps>

c010278a <vector166>:
.globl vector166
vector166:
  pushl $0
c010278a:	6a 00                	push   $0x0
  pushl $166
c010278c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102791:	e9 2c 04 00 00       	jmp    c0102bc2 <__alltraps>

c0102796 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $167
c0102798:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010279d:	e9 20 04 00 00       	jmp    c0102bc2 <__alltraps>

c01027a2 <vector168>:
.globl vector168
vector168:
  pushl $0
c01027a2:	6a 00                	push   $0x0
  pushl $168
c01027a4:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01027a9:	e9 14 04 00 00       	jmp    c0102bc2 <__alltraps>

c01027ae <vector169>:
.globl vector169
vector169:
  pushl $0
c01027ae:	6a 00                	push   $0x0
  pushl $169
c01027b0:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01027b5:	e9 08 04 00 00       	jmp    c0102bc2 <__alltraps>

c01027ba <vector170>:
.globl vector170
vector170:
  pushl $0
c01027ba:	6a 00                	push   $0x0
  pushl $170
c01027bc:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01027c1:	e9 fc 03 00 00       	jmp    c0102bc2 <__alltraps>

c01027c6 <vector171>:
.globl vector171
vector171:
  pushl $0
c01027c6:	6a 00                	push   $0x0
  pushl $171
c01027c8:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01027cd:	e9 f0 03 00 00       	jmp    c0102bc2 <__alltraps>

c01027d2 <vector172>:
.globl vector172
vector172:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $172
c01027d4:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01027d9:	e9 e4 03 00 00       	jmp    c0102bc2 <__alltraps>

c01027de <vector173>:
.globl vector173
vector173:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $173
c01027e0:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01027e5:	e9 d8 03 00 00       	jmp    c0102bc2 <__alltraps>

c01027ea <vector174>:
.globl vector174
vector174:
  pushl $0
c01027ea:	6a 00                	push   $0x0
  pushl $174
c01027ec:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01027f1:	e9 cc 03 00 00       	jmp    c0102bc2 <__alltraps>

c01027f6 <vector175>:
.globl vector175
vector175:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $175
c01027f8:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01027fd:	e9 c0 03 00 00       	jmp    c0102bc2 <__alltraps>

c0102802 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $176
c0102804:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102809:	e9 b4 03 00 00       	jmp    c0102bc2 <__alltraps>

c010280e <vector177>:
.globl vector177
vector177:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $177
c0102810:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102815:	e9 a8 03 00 00       	jmp    c0102bc2 <__alltraps>

c010281a <vector178>:
.globl vector178
vector178:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $178
c010281c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102821:	e9 9c 03 00 00       	jmp    c0102bc2 <__alltraps>

c0102826 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $179
c0102828:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010282d:	e9 90 03 00 00       	jmp    c0102bc2 <__alltraps>

c0102832 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102832:	6a 00                	push   $0x0
  pushl $180
c0102834:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102839:	e9 84 03 00 00       	jmp    c0102bc2 <__alltraps>

c010283e <vector181>:
.globl vector181
vector181:
  pushl $0
c010283e:	6a 00                	push   $0x0
  pushl $181
c0102840:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102845:	e9 78 03 00 00       	jmp    c0102bc2 <__alltraps>

c010284a <vector182>:
.globl vector182
vector182:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $182
c010284c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102851:	e9 6c 03 00 00       	jmp    c0102bc2 <__alltraps>

c0102856 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102856:	6a 00                	push   $0x0
  pushl $183
c0102858:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010285d:	e9 60 03 00 00       	jmp    c0102bc2 <__alltraps>

c0102862 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102862:	6a 00                	push   $0x0
  pushl $184
c0102864:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102869:	e9 54 03 00 00       	jmp    c0102bc2 <__alltraps>

c010286e <vector185>:
.globl vector185
vector185:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $185
c0102870:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102875:	e9 48 03 00 00       	jmp    c0102bc2 <__alltraps>

c010287a <vector186>:
.globl vector186
vector186:
  pushl $0
c010287a:	6a 00                	push   $0x0
  pushl $186
c010287c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102881:	e9 3c 03 00 00       	jmp    c0102bc2 <__alltraps>

c0102886 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102886:	6a 00                	push   $0x0
  pushl $187
c0102888:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010288d:	e9 30 03 00 00       	jmp    c0102bc2 <__alltraps>

c0102892 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $188
c0102894:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102899:	e9 24 03 00 00       	jmp    c0102bc2 <__alltraps>

c010289e <vector189>:
.globl vector189
vector189:
  pushl $0
c010289e:	6a 00                	push   $0x0
  pushl $189
c01028a0:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01028a5:	e9 18 03 00 00       	jmp    c0102bc2 <__alltraps>

c01028aa <vector190>:
.globl vector190
vector190:
  pushl $0
c01028aa:	6a 00                	push   $0x0
  pushl $190
c01028ac:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01028b1:	e9 0c 03 00 00       	jmp    c0102bc2 <__alltraps>

c01028b6 <vector191>:
.globl vector191
vector191:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $191
c01028b8:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01028bd:	e9 00 03 00 00       	jmp    c0102bc2 <__alltraps>

c01028c2 <vector192>:
.globl vector192
vector192:
  pushl $0
c01028c2:	6a 00                	push   $0x0
  pushl $192
c01028c4:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01028c9:	e9 f4 02 00 00       	jmp    c0102bc2 <__alltraps>

c01028ce <vector193>:
.globl vector193
vector193:
  pushl $0
c01028ce:	6a 00                	push   $0x0
  pushl $193
c01028d0:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01028d5:	e9 e8 02 00 00       	jmp    c0102bc2 <__alltraps>

c01028da <vector194>:
.globl vector194
vector194:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $194
c01028dc:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01028e1:	e9 dc 02 00 00       	jmp    c0102bc2 <__alltraps>

c01028e6 <vector195>:
.globl vector195
vector195:
  pushl $0
c01028e6:	6a 00                	push   $0x0
  pushl $195
c01028e8:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01028ed:	e9 d0 02 00 00       	jmp    c0102bc2 <__alltraps>

c01028f2 <vector196>:
.globl vector196
vector196:
  pushl $0
c01028f2:	6a 00                	push   $0x0
  pushl $196
c01028f4:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01028f9:	e9 c4 02 00 00       	jmp    c0102bc2 <__alltraps>

c01028fe <vector197>:
.globl vector197
vector197:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $197
c0102900:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102905:	e9 b8 02 00 00       	jmp    c0102bc2 <__alltraps>

c010290a <vector198>:
.globl vector198
vector198:
  pushl $0
c010290a:	6a 00                	push   $0x0
  pushl $198
c010290c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102911:	e9 ac 02 00 00       	jmp    c0102bc2 <__alltraps>

c0102916 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102916:	6a 00                	push   $0x0
  pushl $199
c0102918:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010291d:	e9 a0 02 00 00       	jmp    c0102bc2 <__alltraps>

c0102922 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $200
c0102924:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102929:	e9 94 02 00 00       	jmp    c0102bc2 <__alltraps>

c010292e <vector201>:
.globl vector201
vector201:
  pushl $0
c010292e:	6a 00                	push   $0x0
  pushl $201
c0102930:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102935:	e9 88 02 00 00       	jmp    c0102bc2 <__alltraps>

c010293a <vector202>:
.globl vector202
vector202:
  pushl $0
c010293a:	6a 00                	push   $0x0
  pushl $202
c010293c:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102941:	e9 7c 02 00 00       	jmp    c0102bc2 <__alltraps>

c0102946 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $203
c0102948:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010294d:	e9 70 02 00 00       	jmp    c0102bc2 <__alltraps>

c0102952 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102952:	6a 00                	push   $0x0
  pushl $204
c0102954:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102959:	e9 64 02 00 00       	jmp    c0102bc2 <__alltraps>

c010295e <vector205>:
.globl vector205
vector205:
  pushl $0
c010295e:	6a 00                	push   $0x0
  pushl $205
c0102960:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102965:	e9 58 02 00 00       	jmp    c0102bc2 <__alltraps>

c010296a <vector206>:
.globl vector206
vector206:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $206
c010296c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102971:	e9 4c 02 00 00       	jmp    c0102bc2 <__alltraps>

c0102976 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102976:	6a 00                	push   $0x0
  pushl $207
c0102978:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010297d:	e9 40 02 00 00       	jmp    c0102bc2 <__alltraps>

c0102982 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102982:	6a 00                	push   $0x0
  pushl $208
c0102984:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102989:	e9 34 02 00 00       	jmp    c0102bc2 <__alltraps>

c010298e <vector209>:
.globl vector209
vector209:
  pushl $0
c010298e:	6a 00                	push   $0x0
  pushl $209
c0102990:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102995:	e9 28 02 00 00       	jmp    c0102bc2 <__alltraps>

c010299a <vector210>:
.globl vector210
vector210:
  pushl $0
c010299a:	6a 00                	push   $0x0
  pushl $210
c010299c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01029a1:	e9 1c 02 00 00       	jmp    c0102bc2 <__alltraps>

c01029a6 <vector211>:
.globl vector211
vector211:
  pushl $0
c01029a6:	6a 00                	push   $0x0
  pushl $211
c01029a8:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01029ad:	e9 10 02 00 00       	jmp    c0102bc2 <__alltraps>

c01029b2 <vector212>:
.globl vector212
vector212:
  pushl $0
c01029b2:	6a 00                	push   $0x0
  pushl $212
c01029b4:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01029b9:	e9 04 02 00 00       	jmp    c0102bc2 <__alltraps>

c01029be <vector213>:
.globl vector213
vector213:
  pushl $0
c01029be:	6a 00                	push   $0x0
  pushl $213
c01029c0:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01029c5:	e9 f8 01 00 00       	jmp    c0102bc2 <__alltraps>

c01029ca <vector214>:
.globl vector214
vector214:
  pushl $0
c01029ca:	6a 00                	push   $0x0
  pushl $214
c01029cc:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01029d1:	e9 ec 01 00 00       	jmp    c0102bc2 <__alltraps>

c01029d6 <vector215>:
.globl vector215
vector215:
  pushl $0
c01029d6:	6a 00                	push   $0x0
  pushl $215
c01029d8:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01029dd:	e9 e0 01 00 00       	jmp    c0102bc2 <__alltraps>

c01029e2 <vector216>:
.globl vector216
vector216:
  pushl $0
c01029e2:	6a 00                	push   $0x0
  pushl $216
c01029e4:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01029e9:	e9 d4 01 00 00       	jmp    c0102bc2 <__alltraps>

c01029ee <vector217>:
.globl vector217
vector217:
  pushl $0
c01029ee:	6a 00                	push   $0x0
  pushl $217
c01029f0:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01029f5:	e9 c8 01 00 00       	jmp    c0102bc2 <__alltraps>

c01029fa <vector218>:
.globl vector218
vector218:
  pushl $0
c01029fa:	6a 00                	push   $0x0
  pushl $218
c01029fc:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102a01:	e9 bc 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a06 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102a06:	6a 00                	push   $0x0
  pushl $219
c0102a08:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102a0d:	e9 b0 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a12 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102a12:	6a 00                	push   $0x0
  pushl $220
c0102a14:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102a19:	e9 a4 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a1e <vector221>:
.globl vector221
vector221:
  pushl $0
c0102a1e:	6a 00                	push   $0x0
  pushl $221
c0102a20:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102a25:	e9 98 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a2a <vector222>:
.globl vector222
vector222:
  pushl $0
c0102a2a:	6a 00                	push   $0x0
  pushl $222
c0102a2c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102a31:	e9 8c 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a36 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102a36:	6a 00                	push   $0x0
  pushl $223
c0102a38:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102a3d:	e9 80 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a42 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102a42:	6a 00                	push   $0x0
  pushl $224
c0102a44:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102a49:	e9 74 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a4e <vector225>:
.globl vector225
vector225:
  pushl $0
c0102a4e:	6a 00                	push   $0x0
  pushl $225
c0102a50:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102a55:	e9 68 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a5a <vector226>:
.globl vector226
vector226:
  pushl $0
c0102a5a:	6a 00                	push   $0x0
  pushl $226
c0102a5c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102a61:	e9 5c 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a66 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102a66:	6a 00                	push   $0x0
  pushl $227
c0102a68:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102a6d:	e9 50 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a72 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102a72:	6a 00                	push   $0x0
  pushl $228
c0102a74:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102a79:	e9 44 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a7e <vector229>:
.globl vector229
vector229:
  pushl $0
c0102a7e:	6a 00                	push   $0x0
  pushl $229
c0102a80:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102a85:	e9 38 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a8a <vector230>:
.globl vector230
vector230:
  pushl $0
c0102a8a:	6a 00                	push   $0x0
  pushl $230
c0102a8c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102a91:	e9 2c 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102a96 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102a96:	6a 00                	push   $0x0
  pushl $231
c0102a98:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102a9d:	e9 20 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102aa2 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102aa2:	6a 00                	push   $0x0
  pushl $232
c0102aa4:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102aa9:	e9 14 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102aae <vector233>:
.globl vector233
vector233:
  pushl $0
c0102aae:	6a 00                	push   $0x0
  pushl $233
c0102ab0:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102ab5:	e9 08 01 00 00       	jmp    c0102bc2 <__alltraps>

c0102aba <vector234>:
.globl vector234
vector234:
  pushl $0
c0102aba:	6a 00                	push   $0x0
  pushl $234
c0102abc:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102ac1:	e9 fc 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102ac6 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102ac6:	6a 00                	push   $0x0
  pushl $235
c0102ac8:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102acd:	e9 f0 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102ad2 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102ad2:	6a 00                	push   $0x0
  pushl $236
c0102ad4:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102ad9:	e9 e4 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102ade <vector237>:
.globl vector237
vector237:
  pushl $0
c0102ade:	6a 00                	push   $0x0
  pushl $237
c0102ae0:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102ae5:	e9 d8 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102aea <vector238>:
.globl vector238
vector238:
  pushl $0
c0102aea:	6a 00                	push   $0x0
  pushl $238
c0102aec:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102af1:	e9 cc 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102af6 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102af6:	6a 00                	push   $0x0
  pushl $239
c0102af8:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102afd:	e9 c0 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b02 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102b02:	6a 00                	push   $0x0
  pushl $240
c0102b04:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102b09:	e9 b4 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b0e <vector241>:
.globl vector241
vector241:
  pushl $0
c0102b0e:	6a 00                	push   $0x0
  pushl $241
c0102b10:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102b15:	e9 a8 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b1a <vector242>:
.globl vector242
vector242:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $242
c0102b1c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102b21:	e9 9c 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b26 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102b26:	6a 00                	push   $0x0
  pushl $243
c0102b28:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102b2d:	e9 90 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b32 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102b32:	6a 00                	push   $0x0
  pushl $244
c0102b34:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102b39:	e9 84 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b3e <vector245>:
.globl vector245
vector245:
  pushl $0
c0102b3e:	6a 00                	push   $0x0
  pushl $245
c0102b40:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102b45:	e9 78 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b4a <vector246>:
.globl vector246
vector246:
  pushl $0
c0102b4a:	6a 00                	push   $0x0
  pushl $246
c0102b4c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102b51:	e9 6c 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b56 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102b56:	6a 00                	push   $0x0
  pushl $247
c0102b58:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102b5d:	e9 60 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b62 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102b62:	6a 00                	push   $0x0
  pushl $248
c0102b64:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102b69:	e9 54 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b6e <vector249>:
.globl vector249
vector249:
  pushl $0
c0102b6e:	6a 00                	push   $0x0
  pushl $249
c0102b70:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102b75:	e9 48 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b7a <vector250>:
.globl vector250
vector250:
  pushl $0
c0102b7a:	6a 00                	push   $0x0
  pushl $250
c0102b7c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102b81:	e9 3c 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b86 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102b86:	6a 00                	push   $0x0
  pushl $251
c0102b88:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102b8d:	e9 30 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b92 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102b92:	6a 00                	push   $0x0
  pushl $252
c0102b94:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102b99:	e9 24 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102b9e <vector253>:
.globl vector253
vector253:
  pushl $0
c0102b9e:	6a 00                	push   $0x0
  pushl $253
c0102ba0:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102ba5:	e9 18 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102baa <vector254>:
.globl vector254
vector254:
  pushl $0
c0102baa:	6a 00                	push   $0x0
  pushl $254
c0102bac:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102bb1:	e9 0c 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102bb6 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102bb6:	6a 00                	push   $0x0
  pushl $255
c0102bb8:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102bbd:	e9 00 00 00 00       	jmp    c0102bc2 <__alltraps>

c0102bc2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102bc2:	1e                   	push   %ds
    pushl %es
c0102bc3:	06                   	push   %es
    pushl %fs
c0102bc4:	0f a0                	push   %fs
    pushl %gs
c0102bc6:	0f a8                	push   %gs
    pushal
c0102bc8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102bc9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102bce:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102bd0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102bd2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102bd3:	e8 64 f5 ff ff       	call   c010213c <trap>

    # pop the pushed stack pointer
    popl %esp
c0102bd8:	5c                   	pop    %esp

c0102bd9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102bd9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102bda:	0f a9                	pop    %gs
    popl %fs
c0102bdc:	0f a1                	pop    %fs
    popl %es
c0102bde:	07                   	pop    %es
    popl %ds
c0102bdf:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102be0:	83 c4 08             	add    $0x8,%esp
    iret
c0102be3:	cf                   	iret   

c0102be4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102be4:	55                   	push   %ebp
c0102be5:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102be7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bea:	8b 15 78 bf 11 c0    	mov    0xc011bf78,%edx
c0102bf0:	29 d0                	sub    %edx,%eax
c0102bf2:	c1 f8 02             	sar    $0x2,%eax
c0102bf5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102bfb:	5d                   	pop    %ebp
c0102bfc:	c3                   	ret    

c0102bfd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102bfd:	55                   	push   %ebp
c0102bfe:	89 e5                	mov    %esp,%ebp
c0102c00:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c06:	89 04 24             	mov    %eax,(%esp)
c0102c09:	e8 d6 ff ff ff       	call   c0102be4 <page2ppn>
c0102c0e:	c1 e0 0c             	shl    $0xc,%eax
}
c0102c11:	c9                   	leave  
c0102c12:	c3                   	ret    

c0102c13 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102c13:	55                   	push   %ebp
c0102c14:	89 e5                	mov    %esp,%ebp
c0102c16:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c1c:	c1 e8 0c             	shr    $0xc,%eax
c0102c1f:	89 c2                	mov    %eax,%edx
c0102c21:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0102c26:	39 c2                	cmp    %eax,%edx
c0102c28:	72 1c                	jb     c0102c46 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102c2a:	c7 44 24 08 70 6a 10 	movl   $0xc0106a70,0x8(%esp)
c0102c31:	c0 
c0102c32:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102c39:	00 
c0102c3a:	c7 04 24 8f 6a 10 c0 	movl   $0xc0106a8f,(%esp)
c0102c41:	e8 b3 d7 ff ff       	call   c01003f9 <__panic>
    }
    return &pages[PPN(pa)];
c0102c46:	8b 0d 78 bf 11 c0    	mov    0xc011bf78,%ecx
c0102c4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c4f:	c1 e8 0c             	shr    $0xc,%eax
c0102c52:	89 c2                	mov    %eax,%edx
c0102c54:	89 d0                	mov    %edx,%eax
c0102c56:	c1 e0 02             	shl    $0x2,%eax
c0102c59:	01 d0                	add    %edx,%eax
c0102c5b:	c1 e0 02             	shl    $0x2,%eax
c0102c5e:	01 c8                	add    %ecx,%eax
}
c0102c60:	c9                   	leave  
c0102c61:	c3                   	ret    

c0102c62 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102c62:	55                   	push   %ebp
c0102c63:	89 e5                	mov    %esp,%ebp
c0102c65:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102c68:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c6b:	89 04 24             	mov    %eax,(%esp)
c0102c6e:	e8 8a ff ff ff       	call   c0102bfd <page2pa>
c0102c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c79:	c1 e8 0c             	shr    $0xc,%eax
c0102c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c7f:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0102c84:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102c87:	72 23                	jb     c0102cac <page2kva+0x4a>
c0102c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102c90:	c7 44 24 08 a0 6a 10 	movl   $0xc0106aa0,0x8(%esp)
c0102c97:	c0 
c0102c98:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102c9f:	00 
c0102ca0:	c7 04 24 8f 6a 10 c0 	movl   $0xc0106a8f,(%esp)
c0102ca7:	e8 4d d7 ff ff       	call   c01003f9 <__panic>
c0102cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102caf:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102cb4:	c9                   	leave  
c0102cb5:	c3                   	ret    

c0102cb6 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102cb6:	55                   	push   %ebp
c0102cb7:	89 e5                	mov    %esp,%ebp
c0102cb9:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cbf:	83 e0 01             	and    $0x1,%eax
c0102cc2:	85 c0                	test   %eax,%eax
c0102cc4:	75 1c                	jne    c0102ce2 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102cc6:	c7 44 24 08 c4 6a 10 	movl   $0xc0106ac4,0x8(%esp)
c0102ccd:	c0 
c0102cce:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102cd5:	00 
c0102cd6:	c7 04 24 8f 6a 10 c0 	movl   $0xc0106a8f,(%esp)
c0102cdd:	e8 17 d7 ff ff       	call   c01003f9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102ce2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102cea:	89 04 24             	mov    %eax,(%esp)
c0102ced:	e8 21 ff ff ff       	call   c0102c13 <pa2page>
}
c0102cf2:	c9                   	leave  
c0102cf3:	c3                   	ret    

c0102cf4 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102cf4:	55                   	push   %ebp
c0102cf5:	89 e5                	mov    %esp,%ebp
c0102cf7:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102d02:	89 04 24             	mov    %eax,(%esp)
c0102d05:	e8 09 ff ff ff       	call   c0102c13 <pa2page>
}
c0102d0a:	c9                   	leave  
c0102d0b:	c3                   	ret    

c0102d0c <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102d0c:	55                   	push   %ebp
c0102d0d:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102d0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d12:	8b 00                	mov    (%eax),%eax
}
c0102d14:	5d                   	pop    %ebp
c0102d15:	c3                   	ret    

c0102d16 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102d16:	55                   	push   %ebp
c0102d17:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102d19:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d1f:	89 10                	mov    %edx,(%eax)
}
c0102d21:	90                   	nop
c0102d22:	5d                   	pop    %ebp
c0102d23:	c3                   	ret    

c0102d24 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102d24:	55                   	push   %ebp
c0102d25:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102d27:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d2a:	8b 00                	mov    (%eax),%eax
c0102d2c:	8d 50 01             	lea    0x1(%eax),%edx
c0102d2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d32:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102d34:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d37:	8b 00                	mov    (%eax),%eax
}
c0102d39:	5d                   	pop    %ebp
c0102d3a:	c3                   	ret    

c0102d3b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102d3b:	55                   	push   %ebp
c0102d3c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d41:	8b 00                	mov    (%eax),%eax
c0102d43:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d49:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102d4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d4e:	8b 00                	mov    (%eax),%eax
}
c0102d50:	5d                   	pop    %ebp
c0102d51:	c3                   	ret    

c0102d52 <__intr_save>:
__intr_save(void) {
c0102d52:	55                   	push   %ebp
c0102d53:	89 e5                	mov    %esp,%ebp
c0102d55:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102d58:	9c                   	pushf  
c0102d59:	58                   	pop    %eax
c0102d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102d60:	25 00 02 00 00       	and    $0x200,%eax
c0102d65:	85 c0                	test   %eax,%eax
c0102d67:	74 0c                	je     c0102d75 <__intr_save+0x23>
        intr_disable();
c0102d69:	e8 3b eb ff ff       	call   c01018a9 <intr_disable>
        return 1;
c0102d6e:	b8 01 00 00 00       	mov    $0x1,%eax
c0102d73:	eb 05                	jmp    c0102d7a <__intr_save+0x28>
    return 0;
c0102d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102d7a:	c9                   	leave  
c0102d7b:	c3                   	ret    

c0102d7c <__intr_restore>:
__intr_restore(bool flag) {
c0102d7c:	55                   	push   %ebp
c0102d7d:	89 e5                	mov    %esp,%ebp
c0102d7f:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102d82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102d86:	74 05                	je     c0102d8d <__intr_restore+0x11>
        intr_enable();
c0102d88:	e8 15 eb ff ff       	call   c01018a2 <intr_enable>
}
c0102d8d:	90                   	nop
c0102d8e:	c9                   	leave  
c0102d8f:	c3                   	ret    

c0102d90 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102d90:	55                   	push   %ebp
c0102d91:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102d93:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d96:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102d99:	b8 23 00 00 00       	mov    $0x23,%eax
c0102d9e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102da0:	b8 23 00 00 00       	mov    $0x23,%eax
c0102da5:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102da7:	b8 10 00 00 00       	mov    $0x10,%eax
c0102dac:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102dae:	b8 10 00 00 00       	mov    $0x10,%eax
c0102db3:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102db5:	b8 10 00 00 00       	mov    $0x10,%eax
c0102dba:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102dbc:	ea c3 2d 10 c0 08 00 	ljmp   $0x8,$0xc0102dc3
}
c0102dc3:	90                   	nop
c0102dc4:	5d                   	pop    %ebp
c0102dc5:	c3                   	ret    

c0102dc6 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102dc6:	55                   	push   %ebp
c0102dc7:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102dc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dcc:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
}
c0102dd1:	90                   	nop
c0102dd2:	5d                   	pop    %ebp
c0102dd3:	c3                   	ret    

c0102dd4 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102dd4:	55                   	push   %ebp
c0102dd5:	89 e5                	mov    %esp,%ebp
c0102dd7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102dda:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0102ddf:	89 04 24             	mov    %eax,(%esp)
c0102de2:	e8 df ff ff ff       	call   c0102dc6 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102de7:	66 c7 05 a8 be 11 c0 	movw   $0x10,0xc011bea8
c0102dee:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102df0:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0102df7:	68 00 
c0102df9:	b8 a0 be 11 c0       	mov    $0xc011bea0,%eax
c0102dfe:	0f b7 c0             	movzwl %ax,%eax
c0102e01:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0102e07:	b8 a0 be 11 c0       	mov    $0xc011bea0,%eax
c0102e0c:	c1 e8 10             	shr    $0x10,%eax
c0102e0f:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0102e14:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0102e1b:	24 f0                	and    $0xf0,%al
c0102e1d:	0c 09                	or     $0x9,%al
c0102e1f:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0102e24:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0102e2b:	24 ef                	and    $0xef,%al
c0102e2d:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0102e32:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0102e39:	24 9f                	and    $0x9f,%al
c0102e3b:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0102e40:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0102e47:	0c 80                	or     $0x80,%al
c0102e49:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0102e4e:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102e55:	24 f0                	and    $0xf0,%al
c0102e57:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102e5c:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102e63:	24 ef                	and    $0xef,%al
c0102e65:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102e6a:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102e71:	24 df                	and    $0xdf,%al
c0102e73:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102e78:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102e7f:	0c 40                	or     $0x40,%al
c0102e81:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102e86:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102e8d:	24 7f                	and    $0x7f,%al
c0102e8f:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102e94:	b8 a0 be 11 c0       	mov    $0xc011bea0,%eax
c0102e99:	c1 e8 18             	shr    $0x18,%eax
c0102e9c:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102ea1:	c7 04 24 30 8a 11 c0 	movl   $0xc0118a30,(%esp)
c0102ea8:	e8 e3 fe ff ff       	call   c0102d90 <lgdt>
c0102ead:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102eb3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102eb7:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102eba:	90                   	nop
c0102ebb:	c9                   	leave  
c0102ebc:	c3                   	ret    

c0102ebd <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102ebd:	55                   	push   %ebp
c0102ebe:	89 e5                	mov    %esp,%ebp
c0102ec0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102ec3:	c7 05 70 bf 11 c0 98 	movl   $0xc0107498,0xc011bf70
c0102eca:	74 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102ecd:	a1 70 bf 11 c0       	mov    0xc011bf70,%eax
c0102ed2:	8b 00                	mov    (%eax),%eax
c0102ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102ed8:	c7 04 24 f0 6a 10 c0 	movl   $0xc0106af0,(%esp)
c0102edf:	e8 be d3 ff ff       	call   c01002a2 <cprintf>
    pmm_manager->init();
c0102ee4:	a1 70 bf 11 c0       	mov    0xc011bf70,%eax
c0102ee9:	8b 40 04             	mov    0x4(%eax),%eax
c0102eec:	ff d0                	call   *%eax
}
c0102eee:	90                   	nop
c0102eef:	c9                   	leave  
c0102ef0:	c3                   	ret    

c0102ef1 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102ef1:	55                   	push   %ebp
c0102ef2:	89 e5                	mov    %esp,%ebp
c0102ef4:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102ef7:	a1 70 bf 11 c0       	mov    0xc011bf70,%eax
c0102efc:	8b 40 08             	mov    0x8(%eax),%eax
c0102eff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102f02:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102f06:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f09:	89 14 24             	mov    %edx,(%esp)
c0102f0c:	ff d0                	call   *%eax
}
c0102f0e:	90                   	nop
c0102f0f:	c9                   	leave  
c0102f10:	c3                   	ret    

c0102f11 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102f11:	55                   	push   %ebp
c0102f12:	89 e5                	mov    %esp,%ebp
c0102f14:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102f17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102f1e:	e8 2f fe ff ff       	call   c0102d52 <__intr_save>
c0102f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102f26:	a1 70 bf 11 c0       	mov    0xc011bf70,%eax
c0102f2b:	8b 40 0c             	mov    0xc(%eax),%eax
c0102f2e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f31:	89 14 24             	mov    %edx,(%esp)
c0102f34:	ff d0                	call   *%eax
c0102f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f3c:	89 04 24             	mov    %eax,(%esp)
c0102f3f:	e8 38 fe ff ff       	call   c0102d7c <__intr_restore>
    return page;
c0102f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102f47:	c9                   	leave  
c0102f48:	c3                   	ret    

c0102f49 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102f49:	55                   	push   %ebp
c0102f4a:	89 e5                	mov    %esp,%ebp
c0102f4c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102f4f:	e8 fe fd ff ff       	call   c0102d52 <__intr_save>
c0102f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102f57:	a1 70 bf 11 c0       	mov    0xc011bf70,%eax
c0102f5c:	8b 40 10             	mov    0x10(%eax),%eax
c0102f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102f62:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102f66:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f69:	89 14 24             	mov    %edx,(%esp)
c0102f6c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f71:	89 04 24             	mov    %eax,(%esp)
c0102f74:	e8 03 fe ff ff       	call   c0102d7c <__intr_restore>
}
c0102f79:	90                   	nop
c0102f7a:	c9                   	leave  
c0102f7b:	c3                   	ret    

c0102f7c <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102f7c:	55                   	push   %ebp
c0102f7d:	89 e5                	mov    %esp,%ebp
c0102f7f:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102f82:	e8 cb fd ff ff       	call   c0102d52 <__intr_save>
c0102f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102f8a:	a1 70 bf 11 c0       	mov    0xc011bf70,%eax
c0102f8f:	8b 40 14             	mov    0x14(%eax),%eax
c0102f92:	ff d0                	call   *%eax
c0102f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f9a:	89 04 24             	mov    %eax,(%esp)
c0102f9d:	e8 da fd ff ff       	call   c0102d7c <__intr_restore>
    return ret;
c0102fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102fa5:	c9                   	leave  
c0102fa6:	c3                   	ret    

c0102fa7 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102fa7:	55                   	push   %ebp
c0102fa8:	89 e5                	mov    %esp,%ebp
c0102faa:	57                   	push   %edi
c0102fab:	56                   	push   %esi
c0102fac:	53                   	push   %ebx
c0102fad:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102fb3:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102fba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102fc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102fc8:	c7 04 24 07 6b 10 c0 	movl   $0xc0106b07,(%esp)
c0102fcf:	e8 ce d2 ff ff       	call   c01002a2 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102fd4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fdb:	e9 22 01 00 00       	jmp    c0103102 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102fe0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fe3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fe6:	89 d0                	mov    %edx,%eax
c0102fe8:	c1 e0 02             	shl    $0x2,%eax
c0102feb:	01 d0                	add    %edx,%eax
c0102fed:	c1 e0 02             	shl    $0x2,%eax
c0102ff0:	01 c8                	add    %ecx,%eax
c0102ff2:	8b 50 08             	mov    0x8(%eax),%edx
c0102ff5:	8b 40 04             	mov    0x4(%eax),%eax
c0102ff8:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102ffb:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102ffe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103001:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103004:	89 d0                	mov    %edx,%eax
c0103006:	c1 e0 02             	shl    $0x2,%eax
c0103009:	01 d0                	add    %edx,%eax
c010300b:	c1 e0 02             	shl    $0x2,%eax
c010300e:	01 c8                	add    %ecx,%eax
c0103010:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103013:	8b 58 10             	mov    0x10(%eax),%ebx
c0103016:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103019:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010301c:	01 c8                	add    %ecx,%eax
c010301e:	11 da                	adc    %ebx,%edx
c0103020:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103023:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103026:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103029:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010302c:	89 d0                	mov    %edx,%eax
c010302e:	c1 e0 02             	shl    $0x2,%eax
c0103031:	01 d0                	add    %edx,%eax
c0103033:	c1 e0 02             	shl    $0x2,%eax
c0103036:	01 c8                	add    %ecx,%eax
c0103038:	83 c0 14             	add    $0x14,%eax
c010303b:	8b 00                	mov    (%eax),%eax
c010303d:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103040:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103043:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103046:	83 c0 ff             	add    $0xffffffff,%eax
c0103049:	83 d2 ff             	adc    $0xffffffff,%edx
c010304c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0103052:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0103058:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010305b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010305e:	89 d0                	mov    %edx,%eax
c0103060:	c1 e0 02             	shl    $0x2,%eax
c0103063:	01 d0                	add    %edx,%eax
c0103065:	c1 e0 02             	shl    $0x2,%eax
c0103068:	01 c8                	add    %ecx,%eax
c010306a:	8b 48 0c             	mov    0xc(%eax),%ecx
c010306d:	8b 58 10             	mov    0x10(%eax),%ebx
c0103070:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103073:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0103077:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010307d:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0103083:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103087:	89 54 24 18          	mov    %edx,0x18(%esp)
c010308b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010308e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103091:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103095:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103099:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010309d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01030a1:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c01030a8:	e8 f5 d1 ff ff       	call   c01002a2 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01030ad:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030b3:	89 d0                	mov    %edx,%eax
c01030b5:	c1 e0 02             	shl    $0x2,%eax
c01030b8:	01 d0                	add    %edx,%eax
c01030ba:	c1 e0 02             	shl    $0x2,%eax
c01030bd:	01 c8                	add    %ecx,%eax
c01030bf:	83 c0 14             	add    $0x14,%eax
c01030c2:	8b 00                	mov    (%eax),%eax
c01030c4:	83 f8 01             	cmp    $0x1,%eax
c01030c7:	75 36                	jne    c01030ff <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c01030c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01030cf:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c01030d2:	77 2b                	ja     c01030ff <page_init+0x158>
c01030d4:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c01030d7:	72 05                	jb     c01030de <page_init+0x137>
c01030d9:	3b 45 98             	cmp    -0x68(%ebp),%eax
c01030dc:	73 21                	jae    c01030ff <page_init+0x158>
c01030de:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01030e2:	77 1b                	ja     c01030ff <page_init+0x158>
c01030e4:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01030e8:	72 09                	jb     c01030f3 <page_init+0x14c>
c01030ea:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c01030f1:	77 0c                	ja     c01030ff <page_init+0x158>
                maxpa = end;
c01030f3:	8b 45 98             	mov    -0x68(%ebp),%eax
c01030f6:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01030f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01030fc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c01030ff:	ff 45 dc             	incl   -0x24(%ebp)
c0103102:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103105:	8b 00                	mov    (%eax),%eax
c0103107:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010310a:	0f 8c d0 fe ff ff    	jl     c0102fe0 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103110:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103114:	72 1d                	jb     c0103133 <page_init+0x18c>
c0103116:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010311a:	77 09                	ja     c0103125 <page_init+0x17e>
c010311c:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103123:	76 0e                	jbe    c0103133 <page_init+0x18c>
        maxpa = KMEMSIZE;
c0103125:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010312c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103133:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103136:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103139:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010313d:	c1 ea 0c             	shr    $0xc,%edx
c0103140:	89 c1                	mov    %eax,%ecx
c0103142:	89 d3                	mov    %edx,%ebx
c0103144:	89 c8                	mov    %ecx,%eax
c0103146:	a3 80 be 11 c0       	mov    %eax,0xc011be80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010314b:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0103152:	b8 88 bf 11 c0       	mov    $0xc011bf88,%eax
c0103157:	8d 50 ff             	lea    -0x1(%eax),%edx
c010315a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010315d:	01 d0                	add    %edx,%eax
c010315f:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103162:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103165:	ba 00 00 00 00       	mov    $0x0,%edx
c010316a:	f7 75 c0             	divl   -0x40(%ebp)
c010316d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103170:	29 d0                	sub    %edx,%eax
c0103172:	a3 78 bf 11 c0       	mov    %eax,0xc011bf78

    for (i = 0; i < npage; i ++) {
c0103177:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010317e:	eb 2e                	jmp    c01031ae <page_init+0x207>
        SetPageReserved(pages + i);
c0103180:	8b 0d 78 bf 11 c0    	mov    0xc011bf78,%ecx
c0103186:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103189:	89 d0                	mov    %edx,%eax
c010318b:	c1 e0 02             	shl    $0x2,%eax
c010318e:	01 d0                	add    %edx,%eax
c0103190:	c1 e0 02             	shl    $0x2,%eax
c0103193:	01 c8                	add    %ecx,%eax
c0103195:	83 c0 04             	add    $0x4,%eax
c0103198:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c010319f:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01031a2:	8b 45 90             	mov    -0x70(%ebp),%eax
c01031a5:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01031a8:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c01031ab:	ff 45 dc             	incl   -0x24(%ebp)
c01031ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031b1:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01031b6:	39 c2                	cmp    %eax,%edx
c01031b8:	72 c6                	jb     c0103180 <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01031ba:	8b 15 80 be 11 c0    	mov    0xc011be80,%edx
c01031c0:	89 d0                	mov    %edx,%eax
c01031c2:	c1 e0 02             	shl    $0x2,%eax
c01031c5:	01 d0                	add    %edx,%eax
c01031c7:	c1 e0 02             	shl    $0x2,%eax
c01031ca:	89 c2                	mov    %eax,%edx
c01031cc:	a1 78 bf 11 c0       	mov    0xc011bf78,%eax
c01031d1:	01 d0                	add    %edx,%eax
c01031d3:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01031d6:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c01031dd:	77 23                	ja     c0103202 <page_init+0x25b>
c01031df:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01031e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01031e6:	c7 44 24 08 44 6b 10 	movl   $0xc0106b44,0x8(%esp)
c01031ed:	c0 
c01031ee:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01031f5:	00 
c01031f6:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01031fd:	e8 f7 d1 ff ff       	call   c01003f9 <__panic>
c0103202:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103205:	05 00 00 00 40       	add    $0x40000000,%eax
c010320a:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010320d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103214:	e9 69 01 00 00       	jmp    c0103382 <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103219:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010321c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010321f:	89 d0                	mov    %edx,%eax
c0103221:	c1 e0 02             	shl    $0x2,%eax
c0103224:	01 d0                	add    %edx,%eax
c0103226:	c1 e0 02             	shl    $0x2,%eax
c0103229:	01 c8                	add    %ecx,%eax
c010322b:	8b 50 08             	mov    0x8(%eax),%edx
c010322e:	8b 40 04             	mov    0x4(%eax),%eax
c0103231:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103234:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103237:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010323a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010323d:	89 d0                	mov    %edx,%eax
c010323f:	c1 e0 02             	shl    $0x2,%eax
c0103242:	01 d0                	add    %edx,%eax
c0103244:	c1 e0 02             	shl    $0x2,%eax
c0103247:	01 c8                	add    %ecx,%eax
c0103249:	8b 48 0c             	mov    0xc(%eax),%ecx
c010324c:	8b 58 10             	mov    0x10(%eax),%ebx
c010324f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103252:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103255:	01 c8                	add    %ecx,%eax
c0103257:	11 da                	adc    %ebx,%edx
c0103259:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010325c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010325f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103262:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103265:	89 d0                	mov    %edx,%eax
c0103267:	c1 e0 02             	shl    $0x2,%eax
c010326a:	01 d0                	add    %edx,%eax
c010326c:	c1 e0 02             	shl    $0x2,%eax
c010326f:	01 c8                	add    %ecx,%eax
c0103271:	83 c0 14             	add    $0x14,%eax
c0103274:	8b 00                	mov    (%eax),%eax
c0103276:	83 f8 01             	cmp    $0x1,%eax
c0103279:	0f 85 00 01 00 00    	jne    c010337f <page_init+0x3d8>
            if (begin < freemem) {
c010327f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103282:	ba 00 00 00 00       	mov    $0x0,%edx
c0103287:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010328a:	77 17                	ja     c01032a3 <page_init+0x2fc>
c010328c:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010328f:	72 05                	jb     c0103296 <page_init+0x2ef>
c0103291:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103294:	73 0d                	jae    c01032a3 <page_init+0x2fc>
                begin = freemem;
c0103296:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103299:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010329c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01032a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01032a7:	72 1d                	jb     c01032c6 <page_init+0x31f>
c01032a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01032ad:	77 09                	ja     c01032b8 <page_init+0x311>
c01032af:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01032b6:	76 0e                	jbe    c01032c6 <page_init+0x31f>
                end = KMEMSIZE;
c01032b8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01032bf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01032c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032cc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01032cf:	0f 87 aa 00 00 00    	ja     c010337f <page_init+0x3d8>
c01032d5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01032d8:	72 09                	jb     c01032e3 <page_init+0x33c>
c01032da:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01032dd:	0f 83 9c 00 00 00    	jae    c010337f <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
c01032e3:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c01032ea:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01032ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01032f0:	01 d0                	add    %edx,%eax
c01032f2:	48                   	dec    %eax
c01032f3:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01032f6:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01032f9:	ba 00 00 00 00       	mov    $0x0,%edx
c01032fe:	f7 75 b0             	divl   -0x50(%ebp)
c0103301:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103304:	29 d0                	sub    %edx,%eax
c0103306:	ba 00 00 00 00       	mov    $0x0,%edx
c010330b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010330e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103311:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103314:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103317:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010331a:	ba 00 00 00 00       	mov    $0x0,%edx
c010331f:	89 c3                	mov    %eax,%ebx
c0103321:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103327:	89 de                	mov    %ebx,%esi
c0103329:	89 d0                	mov    %edx,%eax
c010332b:	83 e0 00             	and    $0x0,%eax
c010332e:	89 c7                	mov    %eax,%edi
c0103330:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103333:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103336:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103339:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010333c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010333f:	77 3e                	ja     c010337f <page_init+0x3d8>
c0103341:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103344:	72 05                	jb     c010334b <page_init+0x3a4>
c0103346:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103349:	73 34                	jae    c010337f <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010334b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010334e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103351:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103354:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103357:	89 c1                	mov    %eax,%ecx
c0103359:	89 d3                	mov    %edx,%ebx
c010335b:	89 c8                	mov    %ecx,%eax
c010335d:	89 da                	mov    %ebx,%edx
c010335f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103363:	c1 ea 0c             	shr    $0xc,%edx
c0103366:	89 c3                	mov    %eax,%ebx
c0103368:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010336b:	89 04 24             	mov    %eax,(%esp)
c010336e:	e8 a0 f8 ff ff       	call   c0102c13 <pa2page>
c0103373:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103377:	89 04 24             	mov    %eax,(%esp)
c010337a:	e8 72 fb ff ff       	call   c0102ef1 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010337f:	ff 45 dc             	incl   -0x24(%ebp)
c0103382:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103385:	8b 00                	mov    (%eax),%eax
c0103387:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010338a:	0f 8c 89 fe ff ff    	jl     c0103219 <page_init+0x272>
                }
            }
        }
    }
}
c0103390:	90                   	nop
c0103391:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103397:	5b                   	pop    %ebx
c0103398:	5e                   	pop    %esi
c0103399:	5f                   	pop    %edi
c010339a:	5d                   	pop    %ebp
c010339b:	c3                   	ret    

c010339c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010339c:	55                   	push   %ebp
c010339d:	89 e5                	mov    %esp,%ebp
c010339f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01033a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033a5:	33 45 14             	xor    0x14(%ebp),%eax
c01033a8:	25 ff 0f 00 00       	and    $0xfff,%eax
c01033ad:	85 c0                	test   %eax,%eax
c01033af:	74 24                	je     c01033d5 <boot_map_segment+0x39>
c01033b1:	c7 44 24 0c 76 6b 10 	movl   $0xc0106b76,0xc(%esp)
c01033b8:	c0 
c01033b9:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c01033c0:	c0 
c01033c1:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01033c8:	00 
c01033c9:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01033d0:	e8 24 d0 ff ff       	call   c01003f9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01033d5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01033dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033df:	25 ff 0f 00 00       	and    $0xfff,%eax
c01033e4:	89 c2                	mov    %eax,%edx
c01033e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01033e9:	01 c2                	add    %eax,%edx
c01033eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033ee:	01 d0                	add    %edx,%eax
c01033f0:	48                   	dec    %eax
c01033f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033f7:	ba 00 00 00 00       	mov    $0x0,%edx
c01033fc:	f7 75 f0             	divl   -0x10(%ebp)
c01033ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103402:	29 d0                	sub    %edx,%eax
c0103404:	c1 e8 0c             	shr    $0xc,%eax
c0103407:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010340a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010340d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103410:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103413:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103418:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010341b:	8b 45 14             	mov    0x14(%ebp),%eax
c010341e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103424:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103429:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010342c:	eb 68                	jmp    c0103496 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010342e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103435:	00 
c0103436:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103439:	89 44 24 04          	mov    %eax,0x4(%esp)
c010343d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103440:	89 04 24             	mov    %eax,(%esp)
c0103443:	e8 81 01 00 00       	call   c01035c9 <get_pte>
c0103448:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010344b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010344f:	75 24                	jne    c0103475 <boot_map_segment+0xd9>
c0103451:	c7 44 24 0c a2 6b 10 	movl   $0xc0106ba2,0xc(%esp)
c0103458:	c0 
c0103459:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103460:	c0 
c0103461:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103468:	00 
c0103469:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103470:	e8 84 cf ff ff       	call   c01003f9 <__panic>
        *ptep = pa | PTE_P | perm;
c0103475:	8b 45 14             	mov    0x14(%ebp),%eax
c0103478:	0b 45 18             	or     0x18(%ebp),%eax
c010347b:	83 c8 01             	or     $0x1,%eax
c010347e:	89 c2                	mov    %eax,%edx
c0103480:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103483:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103485:	ff 4d f4             	decl   -0xc(%ebp)
c0103488:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010348f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010349a:	75 92                	jne    c010342e <boot_map_segment+0x92>
    }
}
c010349c:	90                   	nop
c010349d:	c9                   	leave  
c010349e:	c3                   	ret    

c010349f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010349f:	55                   	push   %ebp
c01034a0:	89 e5                	mov    %esp,%ebp
c01034a2:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01034a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034ac:	e8 60 fa ff ff       	call   c0102f11 <alloc_pages>
c01034b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01034b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034b8:	75 1c                	jne    c01034d6 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01034ba:	c7 44 24 08 af 6b 10 	movl   $0xc0106baf,0x8(%esp)
c01034c1:	c0 
c01034c2:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01034c9:	00 
c01034ca:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01034d1:	e8 23 cf ff ff       	call   c01003f9 <__panic>
    }
    return page2kva(p);
c01034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d9:	89 04 24             	mov    %eax,(%esp)
c01034dc:	e8 81 f7 ff ff       	call   c0102c62 <page2kva>
}
c01034e1:	c9                   	leave  
c01034e2:	c3                   	ret    

c01034e3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01034e3:	55                   	push   %ebp
c01034e4:	89 e5                	mov    %esp,%ebp
c01034e6:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01034e9:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01034ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034f1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01034f8:	77 23                	ja     c010351d <pmm_init+0x3a>
c01034fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103501:	c7 44 24 08 44 6b 10 	movl   $0xc0106b44,0x8(%esp)
c0103508:	c0 
c0103509:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103510:	00 
c0103511:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103518:	e8 dc ce ff ff       	call   c01003f9 <__panic>
c010351d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103520:	05 00 00 00 40       	add    $0x40000000,%eax
c0103525:	a3 74 bf 11 c0       	mov    %eax,0xc011bf74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010352a:	e8 8e f9 ff ff       	call   c0102ebd <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010352f:	e8 73 fa ff ff       	call   c0102fa7 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103534:	e8 de 03 00 00       	call   c0103917 <check_alloc_page>

    check_pgdir();
c0103539:	e8 f8 03 00 00       	call   c0103936 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010353e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103543:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103546:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010354d:	77 23                	ja     c0103572 <pmm_init+0x8f>
c010354f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103552:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103556:	c7 44 24 08 44 6b 10 	movl   $0xc0106b44,0x8(%esp)
c010355d:	c0 
c010355e:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0103565:	00 
c0103566:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c010356d:	e8 87 ce ff ff       	call   c01003f9 <__panic>
c0103572:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103575:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010357b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103580:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103585:	83 ca 03             	or     $0x3,%edx
c0103588:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010358a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010358f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0103596:	00 
c0103597:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010359e:	00 
c010359f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01035a6:	38 
c01035a7:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01035ae:	c0 
c01035af:	89 04 24             	mov    %eax,(%esp)
c01035b2:	e8 e5 fd ff ff       	call   c010339c <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01035b7:	e8 18 f8 ff ff       	call   c0102dd4 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01035bc:	e8 11 0a 00 00       	call   c0103fd2 <check_boot_pgdir>

    print_pgdir();
c01035c1:	e8 8a 0e 00 00       	call   c0104450 <print_pgdir>

}
c01035c6:	90                   	nop
c01035c7:	c9                   	leave  
c01035c8:	c3                   	ret    

c01035c9 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01035c9:	55                   	push   %ebp
c01035ca:	89 e5                	mov    %esp,%ebp
c01035cc:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];//获取二级页表的地址
c01035cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035d2:	c1 e8 16             	shr    $0x16,%eax
c01035d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01035dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01035df:	01 d0                	add    %edx,%eax
c01035e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {//如果该二级页表还没有分配物理空间
c01035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e7:	8b 00                	mov    (%eax),%eax
c01035e9:	83 e0 01             	and    $0x1,%eax
c01035ec:	85 c0                	test   %eax,%eax
c01035ee:	0f 85 af 00 00 00    	jne    c01036a3 <get_pte+0xda>
        struct Page *page;//分配一个
        if (!create || (page = alloc_page()) == NULL) {
c01035f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01035f8:	74 15                	je     c010360f <get_pte+0x46>
c01035fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103601:	e8 0b f9 ff ff       	call   c0102f11 <alloc_pages>
c0103606:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010360d:	75 0a                	jne    c0103619 <get_pte+0x50>
            return NULL;
c010360f:	b8 00 00 00 00       	mov    $0x0,%eax
c0103614:	e9 e7 00 00 00       	jmp    c0103700 <get_pte+0x137>
        }
        //下面都是给新页初始化属性
        set_page_ref(page, 1);
c0103619:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103620:	00 
c0103621:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103624:	89 04 24             	mov    %eax,(%esp)
c0103627:	e8 ea f6 ff ff       	call   c0102d16 <set_page_ref>
        uintptr_t pa = page2pa(page);
c010362c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010362f:	89 04 24             	mov    %eax,(%esp)
c0103632:	e8 c6 f5 ff ff       	call   c0102bfd <page2pa>
c0103637:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010363a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010363d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103640:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103643:	c1 e8 0c             	shr    $0xc,%eax
c0103646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103649:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c010364e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103651:	72 23                	jb     c0103676 <get_pte+0xad>
c0103653:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103656:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010365a:	c7 44 24 08 a0 6a 10 	movl   $0xc0106aa0,0x8(%esp)
c0103661:	c0 
c0103662:	c7 44 24 04 73 01 00 	movl   $0x173,0x4(%esp)
c0103669:	00 
c010366a:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103671:	e8 83 cd ff ff       	call   c01003f9 <__panic>
c0103676:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103679:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010367e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103685:	00 
c0103686:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010368d:	00 
c010368e:	89 04 24             	mov    %eax,(%esp)
c0103691:	e8 96 24 00 00       	call   c0105b2c <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0103696:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103699:	83 c8 07             	or     $0x7,%eax
c010369c:	89 c2                	mov    %eax,%edx
c010369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036a1:	89 10                	mov    %edx,(%eax)
        //得到一个被引用数为1，内容为空，权限极低的二级页表页
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];//通过查二级页表返回对应页表项的地址
c01036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036a6:	8b 00                	mov    (%eax),%eax
c01036a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01036ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01036b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036b3:	c1 e8 0c             	shr    $0xc,%eax
c01036b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01036b9:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01036be:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01036c1:	72 23                	jb     c01036e6 <get_pte+0x11d>
c01036c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01036ca:	c7 44 24 08 a0 6a 10 	movl   $0xc0106aa0,0x8(%esp)
c01036d1:	c0 
c01036d2:	c7 44 24 04 77 01 00 	movl   $0x177,0x4(%esp)
c01036d9:	00 
c01036da:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01036e1:	e8 13 cd ff ff       	call   c01003f9 <__panic>
c01036e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036e9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01036ee:	89 c2                	mov    %eax,%edx
c01036f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036f3:	c1 e8 0c             	shr    $0xc,%eax
c01036f6:	25 ff 03 00 00       	and    $0x3ff,%eax
c01036fb:	c1 e0 02             	shl    $0x2,%eax
c01036fe:	01 d0                	add    %edx,%eax
}
c0103700:	c9                   	leave  
c0103701:	c3                   	ret    

c0103702 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103702:	55                   	push   %ebp
c0103703:	89 e5                	mov    %esp,%ebp
c0103705:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103708:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010370f:	00 
c0103710:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103713:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103717:	8b 45 08             	mov    0x8(%ebp),%eax
c010371a:	89 04 24             	mov    %eax,(%esp)
c010371d:	e8 a7 fe ff ff       	call   c01035c9 <get_pte>
c0103722:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103725:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103729:	74 08                	je     c0103733 <get_page+0x31>
        *ptep_store = ptep;
c010372b:	8b 45 10             	mov    0x10(%ebp),%eax
c010372e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103731:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103733:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103737:	74 1b                	je     c0103754 <get_page+0x52>
c0103739:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010373c:	8b 00                	mov    (%eax),%eax
c010373e:	83 e0 01             	and    $0x1,%eax
c0103741:	85 c0                	test   %eax,%eax
c0103743:	74 0f                	je     c0103754 <get_page+0x52>
        return pte2page(*ptep);
c0103745:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103748:	8b 00                	mov    (%eax),%eax
c010374a:	89 04 24             	mov    %eax,(%esp)
c010374d:	e8 64 f5 ff ff       	call   c0102cb6 <pte2page>
c0103752:	eb 05                	jmp    c0103759 <get_page+0x57>
    }
    return NULL;
c0103754:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103759:	c9                   	leave  
c010375a:	c3                   	ret    

c010375b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010375b:	55                   	push   %ebp
c010375c:	89 e5                	mov    %esp,%ebp
c010375e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
        if (*ptep & PTE_P) {//如果逻辑地址所映射到的page，已经分配了内存
c0103761:	8b 45 10             	mov    0x10(%ebp),%eax
c0103764:	8b 00                	mov    (%eax),%eax
c0103766:	83 e0 01             	and    $0x1,%eax
c0103769:	85 c0                	test   %eax,%eax
c010376b:	74 4d                	je     c01037ba <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);//通过宏，得到二级页表项所指向的page
c010376d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103770:	8b 00                	mov    (%eax),%eax
c0103772:	89 04 24             	mov    %eax,(%esp)
c0103775:	e8 3c f5 ff ff       	call   c0102cb6 <pte2page>
c010377a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {//由于这个逻辑地址不再指向page了，所以page少了一次引用次数
c010377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103780:	89 04 24             	mov    %eax,(%esp)
c0103783:	e8 b3 f5 ff ff       	call   c0102d3b <page_ref_dec>
c0103788:	85 c0                	test   %eax,%eax
c010378a:	75 13                	jne    c010379f <page_remove_pte+0x44>
            free_page(page);//如果page的被引用次数为0，就释放掉该页
c010378c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103793:	00 
c0103794:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103797:	89 04 24             	mov    %eax,(%esp)
c010379a:	e8 aa f7 ff ff       	call   c0102f49 <free_pages>
        }
        *ptep = 0;//讲该二级页表项清空
c010379f:	8b 45 10             	mov    0x10(%ebp),%eax
c01037a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);//TLB更新
c01037a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037af:	8b 45 08             	mov    0x8(%ebp),%eax
c01037b2:	89 04 24             	mov    %eax,(%esp)
c01037b5:	e8 01 01 00 00       	call   c01038bb <tlb_invalidate>
    }
}
c01037ba:	90                   	nop
c01037bb:	c9                   	leave  
c01037bc:	c3                   	ret    

c01037bd <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01037bd:	55                   	push   %ebp
c01037be:	89 e5                	mov    %esp,%ebp
c01037c0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01037c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037ca:	00 
c01037cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01037d5:	89 04 24             	mov    %eax,(%esp)
c01037d8:	e8 ec fd ff ff       	call   c01035c9 <get_pte>
c01037dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01037e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037e4:	74 19                	je     c01037ff <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01037e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01037ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01037f7:	89 04 24             	mov    %eax,(%esp)
c01037fa:	e8 5c ff ff ff       	call   c010375b <page_remove_pte>
    }
}
c01037ff:	90                   	nop
c0103800:	c9                   	leave  
c0103801:	c3                   	ret    

c0103802 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103802:	55                   	push   %ebp
c0103803:	89 e5                	mov    %esp,%ebp
c0103805:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103808:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010380f:	00 
c0103810:	8b 45 10             	mov    0x10(%ebp),%eax
c0103813:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103817:	8b 45 08             	mov    0x8(%ebp),%eax
c010381a:	89 04 24             	mov    %eax,(%esp)
c010381d:	e8 a7 fd ff ff       	call   c01035c9 <get_pte>
c0103822:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103829:	75 0a                	jne    c0103835 <page_insert+0x33>
        return -E_NO_MEM;
c010382b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103830:	e9 84 00 00 00       	jmp    c01038b9 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0103835:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103838:	89 04 24             	mov    %eax,(%esp)
c010383b:	e8 e4 f4 ff ff       	call   c0102d24 <page_ref_inc>
    if (*ptep & PTE_P) {
c0103840:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103843:	8b 00                	mov    (%eax),%eax
c0103845:	83 e0 01             	and    $0x1,%eax
c0103848:	85 c0                	test   %eax,%eax
c010384a:	74 3e                	je     c010388a <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010384f:	8b 00                	mov    (%eax),%eax
c0103851:	89 04 24             	mov    %eax,(%esp)
c0103854:	e8 5d f4 ff ff       	call   c0102cb6 <pte2page>
c0103859:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010385c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010385f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103862:	75 0d                	jne    c0103871 <page_insert+0x6f>
            page_ref_dec(page);
c0103864:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103867:	89 04 24             	mov    %eax,(%esp)
c010386a:	e8 cc f4 ff ff       	call   c0102d3b <page_ref_dec>
c010386f:	eb 19                	jmp    c010388a <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103871:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103874:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103878:	8b 45 10             	mov    0x10(%ebp),%eax
c010387b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010387f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103882:	89 04 24             	mov    %eax,(%esp)
c0103885:	e8 d1 fe ff ff       	call   c010375b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010388a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010388d:	89 04 24             	mov    %eax,(%esp)
c0103890:	e8 68 f3 ff ff       	call   c0102bfd <page2pa>
c0103895:	0b 45 14             	or     0x14(%ebp),%eax
c0103898:	83 c8 01             	or     $0x1,%eax
c010389b:	89 c2                	mov    %eax,%edx
c010389d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038a0:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01038a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01038a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01038a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ac:	89 04 24             	mov    %eax,(%esp)
c01038af:	e8 07 00 00 00       	call   c01038bb <tlb_invalidate>
    return 0;
c01038b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038b9:	c9                   	leave  
c01038ba:	c3                   	ret    

c01038bb <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01038bb:	55                   	push   %ebp
c01038bc:	89 e5                	mov    %esp,%ebp
c01038be:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01038c1:	0f 20 d8             	mov    %cr3,%eax
c01038c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01038c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01038ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01038cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01038d0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01038d7:	77 23                	ja     c01038fc <tlb_invalidate+0x41>
c01038d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01038e0:	c7 44 24 08 44 6b 10 	movl   $0xc0106b44,0x8(%esp)
c01038e7:	c0 
c01038e8:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c01038ef:	00 
c01038f0:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01038f7:	e8 fd ca ff ff       	call   c01003f9 <__panic>
c01038fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038ff:	05 00 00 00 40       	add    $0x40000000,%eax
c0103904:	39 d0                	cmp    %edx,%eax
c0103906:	75 0c                	jne    c0103914 <tlb_invalidate+0x59>
        invlpg((void *)la);
c0103908:	8b 45 0c             	mov    0xc(%ebp),%eax
c010390b:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010390e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103911:	0f 01 38             	invlpg (%eax)
    }
}
c0103914:	90                   	nop
c0103915:	c9                   	leave  
c0103916:	c3                   	ret    

c0103917 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103917:	55                   	push   %ebp
c0103918:	89 e5                	mov    %esp,%ebp
c010391a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010391d:	a1 70 bf 11 c0       	mov    0xc011bf70,%eax
c0103922:	8b 40 18             	mov    0x18(%eax),%eax
c0103925:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103927:	c7 04 24 c8 6b 10 c0 	movl   $0xc0106bc8,(%esp)
c010392e:	e8 6f c9 ff ff       	call   c01002a2 <cprintf>
}
c0103933:	90                   	nop
c0103934:	c9                   	leave  
c0103935:	c3                   	ret    

c0103936 <check_pgdir>:

static void
check_pgdir(void) {
c0103936:	55                   	push   %ebp
c0103937:	89 e5                	mov    %esp,%ebp
c0103939:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010393c:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103941:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103946:	76 24                	jbe    c010396c <check_pgdir+0x36>
c0103948:	c7 44 24 0c e7 6b 10 	movl   $0xc0106be7,0xc(%esp)
c010394f:	c0 
c0103950:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103957:	c0 
c0103958:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c010395f:	00 
c0103960:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103967:	e8 8d ca ff ff       	call   c01003f9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010396c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103971:	85 c0                	test   %eax,%eax
c0103973:	74 0e                	je     c0103983 <check_pgdir+0x4d>
c0103975:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010397a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010397f:	85 c0                	test   %eax,%eax
c0103981:	74 24                	je     c01039a7 <check_pgdir+0x71>
c0103983:	c7 44 24 0c 04 6c 10 	movl   $0xc0106c04,0xc(%esp)
c010398a:	c0 
c010398b:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103992:	c0 
c0103993:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c010399a:	00 
c010399b:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01039a2:	e8 52 ca ff ff       	call   c01003f9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01039a7:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01039ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039b3:	00 
c01039b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01039bb:	00 
c01039bc:	89 04 24             	mov    %eax,(%esp)
c01039bf:	e8 3e fd ff ff       	call   c0103702 <get_page>
c01039c4:	85 c0                	test   %eax,%eax
c01039c6:	74 24                	je     c01039ec <check_pgdir+0xb6>
c01039c8:	c7 44 24 0c 3c 6c 10 	movl   $0xc0106c3c,0xc(%esp)
c01039cf:	c0 
c01039d0:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c01039d7:	c0 
c01039d8:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c01039df:	00 
c01039e0:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01039e7:	e8 0d ca ff ff       	call   c01003f9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01039ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039f3:	e8 19 f5 ff ff       	call   c0102f11 <alloc_pages>
c01039f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01039fb:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103a00:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103a07:	00 
c0103a08:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a0f:	00 
c0103a10:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a13:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103a17:	89 04 24             	mov    %eax,(%esp)
c0103a1a:	e8 e3 fd ff ff       	call   c0103802 <page_insert>
c0103a1f:	85 c0                	test   %eax,%eax
c0103a21:	74 24                	je     c0103a47 <check_pgdir+0x111>
c0103a23:	c7 44 24 0c 64 6c 10 	movl   $0xc0106c64,0xc(%esp)
c0103a2a:	c0 
c0103a2b:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103a32:	c0 
c0103a33:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0103a3a:	00 
c0103a3b:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103a42:	e8 b2 c9 ff ff       	call   c01003f9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103a47:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103a4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a53:	00 
c0103a54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103a5b:	00 
c0103a5c:	89 04 24             	mov    %eax,(%esp)
c0103a5f:	e8 65 fb ff ff       	call   c01035c9 <get_pte>
c0103a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a6b:	75 24                	jne    c0103a91 <check_pgdir+0x15b>
c0103a6d:	c7 44 24 0c 90 6c 10 	movl   $0xc0106c90,0xc(%esp)
c0103a74:	c0 
c0103a75:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103a7c:	c0 
c0103a7d:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0103a84:	00 
c0103a85:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103a8c:	e8 68 c9 ff ff       	call   c01003f9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a94:	8b 00                	mov    (%eax),%eax
c0103a96:	89 04 24             	mov    %eax,(%esp)
c0103a99:	e8 18 f2 ff ff       	call   c0102cb6 <pte2page>
c0103a9e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103aa1:	74 24                	je     c0103ac7 <check_pgdir+0x191>
c0103aa3:	c7 44 24 0c bd 6c 10 	movl   $0xc0106cbd,0xc(%esp)
c0103aaa:	c0 
c0103aab:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103ab2:	c0 
c0103ab3:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103aba:	00 
c0103abb:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103ac2:	e8 32 c9 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p1) == 1);
c0103ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aca:	89 04 24             	mov    %eax,(%esp)
c0103acd:	e8 3a f2 ff ff       	call   c0102d0c <page_ref>
c0103ad2:	83 f8 01             	cmp    $0x1,%eax
c0103ad5:	74 24                	je     c0103afb <check_pgdir+0x1c5>
c0103ad7:	c7 44 24 0c d3 6c 10 	movl   $0xc0106cd3,0xc(%esp)
c0103ade:	c0 
c0103adf:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103ae6:	c0 
c0103ae7:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0103aee:	00 
c0103aef:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103af6:	e8 fe c8 ff ff       	call   c01003f9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103afb:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103b00:	8b 00                	mov    (%eax),%eax
c0103b02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b07:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b0d:	c1 e8 0c             	shr    $0xc,%eax
c0103b10:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103b13:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103b18:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103b1b:	72 23                	jb     c0103b40 <check_pgdir+0x20a>
c0103b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b20:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103b24:	c7 44 24 08 a0 6a 10 	movl   $0xc0106aa0,0x8(%esp)
c0103b2b:	c0 
c0103b2c:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0103b33:	00 
c0103b34:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103b3b:	e8 b9 c8 ff ff       	call   c01003f9 <__panic>
c0103b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b43:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103b48:	83 c0 04             	add    $0x4,%eax
c0103b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103b4e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103b53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103b5a:	00 
c0103b5b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b62:	00 
c0103b63:	89 04 24             	mov    %eax,(%esp)
c0103b66:	e8 5e fa ff ff       	call   c01035c9 <get_pte>
c0103b6b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103b6e:	74 24                	je     c0103b94 <check_pgdir+0x25e>
c0103b70:	c7 44 24 0c e8 6c 10 	movl   $0xc0106ce8,0xc(%esp)
c0103b77:	c0 
c0103b78:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103b7f:	c0 
c0103b80:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103b87:	00 
c0103b88:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103b8f:	e8 65 c8 ff ff       	call   c01003f9 <__panic>

    p2 = alloc_page();
c0103b94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b9b:	e8 71 f3 ff ff       	call   c0102f11 <alloc_pages>
c0103ba0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103ba3:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103ba8:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103baf:	00 
c0103bb0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103bb7:	00 
c0103bb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103bbf:	89 04 24             	mov    %eax,(%esp)
c0103bc2:	e8 3b fc ff ff       	call   c0103802 <page_insert>
c0103bc7:	85 c0                	test   %eax,%eax
c0103bc9:	74 24                	je     c0103bef <check_pgdir+0x2b9>
c0103bcb:	c7 44 24 0c 10 6d 10 	movl   $0xc0106d10,0xc(%esp)
c0103bd2:	c0 
c0103bd3:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103bda:	c0 
c0103bdb:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103be2:	00 
c0103be3:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103bea:	e8 0a c8 ff ff       	call   c01003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103bef:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103bf4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103bfb:	00 
c0103bfc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103c03:	00 
c0103c04:	89 04 24             	mov    %eax,(%esp)
c0103c07:	e8 bd f9 ff ff       	call   c01035c9 <get_pte>
c0103c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c13:	75 24                	jne    c0103c39 <check_pgdir+0x303>
c0103c15:	c7 44 24 0c 48 6d 10 	movl   $0xc0106d48,0xc(%esp)
c0103c1c:	c0 
c0103c1d:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103c24:	c0 
c0103c25:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0103c2c:	00 
c0103c2d:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103c34:	e8 c0 c7 ff ff       	call   c01003f9 <__panic>
    assert(*ptep & PTE_U);
c0103c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c3c:	8b 00                	mov    (%eax),%eax
c0103c3e:	83 e0 04             	and    $0x4,%eax
c0103c41:	85 c0                	test   %eax,%eax
c0103c43:	75 24                	jne    c0103c69 <check_pgdir+0x333>
c0103c45:	c7 44 24 0c 78 6d 10 	movl   $0xc0106d78,0xc(%esp)
c0103c4c:	c0 
c0103c4d:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103c54:	c0 
c0103c55:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0103c5c:	00 
c0103c5d:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103c64:	e8 90 c7 ff ff       	call   c01003f9 <__panic>
    assert(*ptep & PTE_W);
c0103c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c6c:	8b 00                	mov    (%eax),%eax
c0103c6e:	83 e0 02             	and    $0x2,%eax
c0103c71:	85 c0                	test   %eax,%eax
c0103c73:	75 24                	jne    c0103c99 <check_pgdir+0x363>
c0103c75:	c7 44 24 0c 86 6d 10 	movl   $0xc0106d86,0xc(%esp)
c0103c7c:	c0 
c0103c7d:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103c84:	c0 
c0103c85:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0103c8c:	00 
c0103c8d:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103c94:	e8 60 c7 ff ff       	call   c01003f9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103c99:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103c9e:	8b 00                	mov    (%eax),%eax
c0103ca0:	83 e0 04             	and    $0x4,%eax
c0103ca3:	85 c0                	test   %eax,%eax
c0103ca5:	75 24                	jne    c0103ccb <check_pgdir+0x395>
c0103ca7:	c7 44 24 0c 94 6d 10 	movl   $0xc0106d94,0xc(%esp)
c0103cae:	c0 
c0103caf:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103cb6:	c0 
c0103cb7:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103cbe:	00 
c0103cbf:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103cc6:	e8 2e c7 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 1);
c0103ccb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cce:	89 04 24             	mov    %eax,(%esp)
c0103cd1:	e8 36 f0 ff ff       	call   c0102d0c <page_ref>
c0103cd6:	83 f8 01             	cmp    $0x1,%eax
c0103cd9:	74 24                	je     c0103cff <check_pgdir+0x3c9>
c0103cdb:	c7 44 24 0c aa 6d 10 	movl   $0xc0106daa,0xc(%esp)
c0103ce2:	c0 
c0103ce3:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103cea:	c0 
c0103ceb:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0103cf2:	00 
c0103cf3:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103cfa:	e8 fa c6 ff ff       	call   c01003f9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103cff:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103d04:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103d0b:	00 
c0103d0c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103d13:	00 
c0103d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d17:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d1b:	89 04 24             	mov    %eax,(%esp)
c0103d1e:	e8 df fa ff ff       	call   c0103802 <page_insert>
c0103d23:	85 c0                	test   %eax,%eax
c0103d25:	74 24                	je     c0103d4b <check_pgdir+0x415>
c0103d27:	c7 44 24 0c bc 6d 10 	movl   $0xc0106dbc,0xc(%esp)
c0103d2e:	c0 
c0103d2f:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103d36:	c0 
c0103d37:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103d3e:	00 
c0103d3f:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103d46:	e8 ae c6 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p1) == 2);
c0103d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d4e:	89 04 24             	mov    %eax,(%esp)
c0103d51:	e8 b6 ef ff ff       	call   c0102d0c <page_ref>
c0103d56:	83 f8 02             	cmp    $0x2,%eax
c0103d59:	74 24                	je     c0103d7f <check_pgdir+0x449>
c0103d5b:	c7 44 24 0c e8 6d 10 	movl   $0xc0106de8,0xc(%esp)
c0103d62:	c0 
c0103d63:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103d6a:	c0 
c0103d6b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0103d72:	00 
c0103d73:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103d7a:	e8 7a c6 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d82:	89 04 24             	mov    %eax,(%esp)
c0103d85:	e8 82 ef ff ff       	call   c0102d0c <page_ref>
c0103d8a:	85 c0                	test   %eax,%eax
c0103d8c:	74 24                	je     c0103db2 <check_pgdir+0x47c>
c0103d8e:	c7 44 24 0c fa 6d 10 	movl   $0xc0106dfa,0xc(%esp)
c0103d95:	c0 
c0103d96:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103d9d:	c0 
c0103d9e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0103da5:	00 
c0103da6:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103dad:	e8 47 c6 ff ff       	call   c01003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103db2:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103db7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103dbe:	00 
c0103dbf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103dc6:	00 
c0103dc7:	89 04 24             	mov    %eax,(%esp)
c0103dca:	e8 fa f7 ff ff       	call   c01035c9 <get_pte>
c0103dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103dd6:	75 24                	jne    c0103dfc <check_pgdir+0x4c6>
c0103dd8:	c7 44 24 0c 48 6d 10 	movl   $0xc0106d48,0xc(%esp)
c0103ddf:	c0 
c0103de0:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103de7:	c0 
c0103de8:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0103def:	00 
c0103df0:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103df7:	e8 fd c5 ff ff       	call   c01003f9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dff:	8b 00                	mov    (%eax),%eax
c0103e01:	89 04 24             	mov    %eax,(%esp)
c0103e04:	e8 ad ee ff ff       	call   c0102cb6 <pte2page>
c0103e09:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103e0c:	74 24                	je     c0103e32 <check_pgdir+0x4fc>
c0103e0e:	c7 44 24 0c bd 6c 10 	movl   $0xc0106cbd,0xc(%esp)
c0103e15:	c0 
c0103e16:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103e1d:	c0 
c0103e1e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0103e25:	00 
c0103e26:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103e2d:	e8 c7 c5 ff ff       	call   c01003f9 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e35:	8b 00                	mov    (%eax),%eax
c0103e37:	83 e0 04             	and    $0x4,%eax
c0103e3a:	85 c0                	test   %eax,%eax
c0103e3c:	74 24                	je     c0103e62 <check_pgdir+0x52c>
c0103e3e:	c7 44 24 0c 0c 6e 10 	movl   $0xc0106e0c,0xc(%esp)
c0103e45:	c0 
c0103e46:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103e4d:	c0 
c0103e4e:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103e55:	00 
c0103e56:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103e5d:	e8 97 c5 ff ff       	call   c01003f9 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103e62:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103e67:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103e6e:	00 
c0103e6f:	89 04 24             	mov    %eax,(%esp)
c0103e72:	e8 46 f9 ff ff       	call   c01037bd <page_remove>
    assert(page_ref(p1) == 1);
c0103e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e7a:	89 04 24             	mov    %eax,(%esp)
c0103e7d:	e8 8a ee ff ff       	call   c0102d0c <page_ref>
c0103e82:	83 f8 01             	cmp    $0x1,%eax
c0103e85:	74 24                	je     c0103eab <check_pgdir+0x575>
c0103e87:	c7 44 24 0c d3 6c 10 	movl   $0xc0106cd3,0xc(%esp)
c0103e8e:	c0 
c0103e8f:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103e96:	c0 
c0103e97:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0103e9e:	00 
c0103e9f:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103ea6:	e8 4e c5 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103eae:	89 04 24             	mov    %eax,(%esp)
c0103eb1:	e8 56 ee ff ff       	call   c0102d0c <page_ref>
c0103eb6:	85 c0                	test   %eax,%eax
c0103eb8:	74 24                	je     c0103ede <check_pgdir+0x5a8>
c0103eba:	c7 44 24 0c fa 6d 10 	movl   $0xc0106dfa,0xc(%esp)
c0103ec1:	c0 
c0103ec2:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103ec9:	c0 
c0103eca:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103ed1:	00 
c0103ed2:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103ed9:	e8 1b c5 ff ff       	call   c01003f9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103ede:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103ee3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103eea:	00 
c0103eeb:	89 04 24             	mov    %eax,(%esp)
c0103eee:	e8 ca f8 ff ff       	call   c01037bd <page_remove>
    assert(page_ref(p1) == 0);
c0103ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ef6:	89 04 24             	mov    %eax,(%esp)
c0103ef9:	e8 0e ee ff ff       	call   c0102d0c <page_ref>
c0103efe:	85 c0                	test   %eax,%eax
c0103f00:	74 24                	je     c0103f26 <check_pgdir+0x5f0>
c0103f02:	c7 44 24 0c 21 6e 10 	movl   $0xc0106e21,0xc(%esp)
c0103f09:	c0 
c0103f0a:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103f11:	c0 
c0103f12:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0103f19:	00 
c0103f1a:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103f21:	e8 d3 c4 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f29:	89 04 24             	mov    %eax,(%esp)
c0103f2c:	e8 db ed ff ff       	call   c0102d0c <page_ref>
c0103f31:	85 c0                	test   %eax,%eax
c0103f33:	74 24                	je     c0103f59 <check_pgdir+0x623>
c0103f35:	c7 44 24 0c fa 6d 10 	movl   $0xc0106dfa,0xc(%esp)
c0103f3c:	c0 
c0103f3d:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103f44:	c0 
c0103f45:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0103f4c:	00 
c0103f4d:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103f54:	e8 a0 c4 ff ff       	call   c01003f9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103f59:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103f5e:	8b 00                	mov    (%eax),%eax
c0103f60:	89 04 24             	mov    %eax,(%esp)
c0103f63:	e8 8c ed ff ff       	call   c0102cf4 <pde2page>
c0103f68:	89 04 24             	mov    %eax,(%esp)
c0103f6b:	e8 9c ed ff ff       	call   c0102d0c <page_ref>
c0103f70:	83 f8 01             	cmp    $0x1,%eax
c0103f73:	74 24                	je     c0103f99 <check_pgdir+0x663>
c0103f75:	c7 44 24 0c 34 6e 10 	movl   $0xc0106e34,0xc(%esp)
c0103f7c:	c0 
c0103f7d:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0103f84:	c0 
c0103f85:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0103f8c:	00 
c0103f8d:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0103f94:	e8 60 c4 ff ff       	call   c01003f9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103f99:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103f9e:	8b 00                	mov    (%eax),%eax
c0103fa0:	89 04 24             	mov    %eax,(%esp)
c0103fa3:	e8 4c ed ff ff       	call   c0102cf4 <pde2page>
c0103fa8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103faf:	00 
c0103fb0:	89 04 24             	mov    %eax,(%esp)
c0103fb3:	e8 91 ef ff ff       	call   c0102f49 <free_pages>
    boot_pgdir[0] = 0;
c0103fb8:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0103fbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103fc3:	c7 04 24 5b 6e 10 c0 	movl   $0xc0106e5b,(%esp)
c0103fca:	e8 d3 c2 ff ff       	call   c01002a2 <cprintf>
}
c0103fcf:	90                   	nop
c0103fd0:	c9                   	leave  
c0103fd1:	c3                   	ret    

c0103fd2 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103fd2:	55                   	push   %ebp
c0103fd3:	89 e5                	mov    %esp,%ebp
c0103fd5:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103fd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103fdf:	e9 ca 00 00 00       	jmp    c01040ae <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fe7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fed:	c1 e8 0c             	shr    $0xc,%eax
c0103ff0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103ff3:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103ff8:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103ffb:	72 23                	jb     c0104020 <check_boot_pgdir+0x4e>
c0103ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104000:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104004:	c7 44 24 08 a0 6a 10 	movl   $0xc0106aa0,0x8(%esp)
c010400b:	c0 
c010400c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104013:	00 
c0104014:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c010401b:	e8 d9 c3 ff ff       	call   c01003f9 <__panic>
c0104020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104023:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104028:	89 c2                	mov    %eax,%edx
c010402a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010402f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104036:	00 
c0104037:	89 54 24 04          	mov    %edx,0x4(%esp)
c010403b:	89 04 24             	mov    %eax,(%esp)
c010403e:	e8 86 f5 ff ff       	call   c01035c9 <get_pte>
c0104043:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104046:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010404a:	75 24                	jne    c0104070 <check_boot_pgdir+0x9e>
c010404c:	c7 44 24 0c 78 6e 10 	movl   $0xc0106e78,0xc(%esp)
c0104053:	c0 
c0104054:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c010405b:	c0 
c010405c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104063:	00 
c0104064:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c010406b:	e8 89 c3 ff ff       	call   c01003f9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104070:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104073:	8b 00                	mov    (%eax),%eax
c0104075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010407a:	89 c2                	mov    %eax,%edx
c010407c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010407f:	39 c2                	cmp    %eax,%edx
c0104081:	74 24                	je     c01040a7 <check_boot_pgdir+0xd5>
c0104083:	c7 44 24 0c b5 6e 10 	movl   $0xc0106eb5,0xc(%esp)
c010408a:	c0 
c010408b:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0104092:	c0 
c0104093:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c010409a:	00 
c010409b:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01040a2:	e8 52 c3 ff ff       	call   c01003f9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01040a7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01040ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01040b1:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01040b6:	39 c2                	cmp    %eax,%edx
c01040b8:	0f 82 26 ff ff ff    	jb     c0103fe4 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01040be:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01040c3:	05 ac 0f 00 00       	add    $0xfac,%eax
c01040c8:	8b 00                	mov    (%eax),%eax
c01040ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01040cf:	89 c2                	mov    %eax,%edx
c01040d1:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01040d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01040d9:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01040e0:	77 23                	ja     c0104105 <check_boot_pgdir+0x133>
c01040e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040e9:	c7 44 24 08 44 6b 10 	movl   $0xc0106b44,0x8(%esp)
c01040f0:	c0 
c01040f1:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01040f8:	00 
c01040f9:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0104100:	e8 f4 c2 ff ff       	call   c01003f9 <__panic>
c0104105:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104108:	05 00 00 00 40       	add    $0x40000000,%eax
c010410d:	39 d0                	cmp    %edx,%eax
c010410f:	74 24                	je     c0104135 <check_boot_pgdir+0x163>
c0104111:	c7 44 24 0c cc 6e 10 	movl   $0xc0106ecc,0xc(%esp)
c0104118:	c0 
c0104119:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c0104120:	c0 
c0104121:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104128:	00 
c0104129:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c0104130:	e8 c4 c2 ff ff       	call   c01003f9 <__panic>

    assert(boot_pgdir[0] == 0);
c0104135:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010413a:	8b 00                	mov    (%eax),%eax
c010413c:	85 c0                	test   %eax,%eax
c010413e:	74 24                	je     c0104164 <check_boot_pgdir+0x192>
c0104140:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c0104147:	c0 
c0104148:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c010414f:	c0 
c0104150:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104157:	00 
c0104158:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c010415f:	e8 95 c2 ff ff       	call   c01003f9 <__panic>

    struct Page *p;
    p = alloc_page();
c0104164:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010416b:	e8 a1 ed ff ff       	call   c0102f11 <alloc_pages>
c0104170:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104173:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104178:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010417f:	00 
c0104180:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104187:	00 
c0104188:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010418b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010418f:	89 04 24             	mov    %eax,(%esp)
c0104192:	e8 6b f6 ff ff       	call   c0103802 <page_insert>
c0104197:	85 c0                	test   %eax,%eax
c0104199:	74 24                	je     c01041bf <check_boot_pgdir+0x1ed>
c010419b:	c7 44 24 0c 14 6f 10 	movl   $0xc0106f14,0xc(%esp)
c01041a2:	c0 
c01041a3:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c01041aa:	c0 
c01041ab:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c01041b2:	00 
c01041b3:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01041ba:	e8 3a c2 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p) == 1);
c01041bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041c2:	89 04 24             	mov    %eax,(%esp)
c01041c5:	e8 42 eb ff ff       	call   c0102d0c <page_ref>
c01041ca:	83 f8 01             	cmp    $0x1,%eax
c01041cd:	74 24                	je     c01041f3 <check_boot_pgdir+0x221>
c01041cf:	c7 44 24 0c 42 6f 10 	movl   $0xc0106f42,0xc(%esp)
c01041d6:	c0 
c01041d7:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c01041de:	c0 
c01041df:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c01041e6:	00 
c01041e7:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01041ee:	e8 06 c2 ff ff       	call   c01003f9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01041f3:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01041f8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01041ff:	00 
c0104200:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104207:	00 
c0104208:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010420b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010420f:	89 04 24             	mov    %eax,(%esp)
c0104212:	e8 eb f5 ff ff       	call   c0103802 <page_insert>
c0104217:	85 c0                	test   %eax,%eax
c0104219:	74 24                	je     c010423f <check_boot_pgdir+0x26d>
c010421b:	c7 44 24 0c 54 6f 10 	movl   $0xc0106f54,0xc(%esp)
c0104222:	c0 
c0104223:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c010422a:	c0 
c010422b:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104232:	00 
c0104233:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c010423a:	e8 ba c1 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p) == 2);
c010423f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104242:	89 04 24             	mov    %eax,(%esp)
c0104245:	e8 c2 ea ff ff       	call   c0102d0c <page_ref>
c010424a:	83 f8 02             	cmp    $0x2,%eax
c010424d:	74 24                	je     c0104273 <check_boot_pgdir+0x2a1>
c010424f:	c7 44 24 0c 8b 6f 10 	movl   $0xc0106f8b,0xc(%esp)
c0104256:	c0 
c0104257:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c010425e:	c0 
c010425f:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0104266:	00 
c0104267:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c010426e:	e8 86 c1 ff ff       	call   c01003f9 <__panic>

    const char *str = "ucore: Hello world!!";
c0104273:	c7 45 e8 9c 6f 10 c0 	movl   $0xc0106f9c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c010427a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010427d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104281:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104288:	e8 d5 15 00 00       	call   c0105862 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010428d:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104294:	00 
c0104295:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010429c:	e8 38 16 00 00       	call   c01058d9 <strcmp>
c01042a1:	85 c0                	test   %eax,%eax
c01042a3:	74 24                	je     c01042c9 <check_boot_pgdir+0x2f7>
c01042a5:	c7 44 24 0c b4 6f 10 	movl   $0xc0106fb4,0xc(%esp)
c01042ac:	c0 
c01042ad:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c01042b4:	c0 
c01042b5:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c01042bc:	00 
c01042bd:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c01042c4:	e8 30 c1 ff ff       	call   c01003f9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01042c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042cc:	89 04 24             	mov    %eax,(%esp)
c01042cf:	e8 8e e9 ff ff       	call   c0102c62 <page2kva>
c01042d4:	05 00 01 00 00       	add    $0x100,%eax
c01042d9:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01042dc:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01042e3:	e8 24 15 00 00       	call   c010580c <strlen>
c01042e8:	85 c0                	test   %eax,%eax
c01042ea:	74 24                	je     c0104310 <check_boot_pgdir+0x33e>
c01042ec:	c7 44 24 0c ec 6f 10 	movl   $0xc0106fec,0xc(%esp)
c01042f3:	c0 
c01042f4:	c7 44 24 08 8d 6b 10 	movl   $0xc0106b8d,0x8(%esp)
c01042fb:	c0 
c01042fc:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104303:	00 
c0104304:	c7 04 24 68 6b 10 c0 	movl   $0xc0106b68,(%esp)
c010430b:	e8 e9 c0 ff ff       	call   c01003f9 <__panic>

    free_page(p);
c0104310:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104317:	00 
c0104318:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010431b:	89 04 24             	mov    %eax,(%esp)
c010431e:	e8 26 ec ff ff       	call   c0102f49 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0104323:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104328:	8b 00                	mov    (%eax),%eax
c010432a:	89 04 24             	mov    %eax,(%esp)
c010432d:	e8 c2 e9 ff ff       	call   c0102cf4 <pde2page>
c0104332:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104339:	00 
c010433a:	89 04 24             	mov    %eax,(%esp)
c010433d:	e8 07 ec ff ff       	call   c0102f49 <free_pages>
    boot_pgdir[0] = 0;
c0104342:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104347:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010434d:	c7 04 24 10 70 10 c0 	movl   $0xc0107010,(%esp)
c0104354:	e8 49 bf ff ff       	call   c01002a2 <cprintf>
}
c0104359:	90                   	nop
c010435a:	c9                   	leave  
c010435b:	c3                   	ret    

c010435c <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010435c:	55                   	push   %ebp
c010435d:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010435f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104362:	83 e0 04             	and    $0x4,%eax
c0104365:	85 c0                	test   %eax,%eax
c0104367:	74 04                	je     c010436d <perm2str+0x11>
c0104369:	b0 75                	mov    $0x75,%al
c010436b:	eb 02                	jmp    c010436f <perm2str+0x13>
c010436d:	b0 2d                	mov    $0x2d,%al
c010436f:	a2 08 bf 11 c0       	mov    %al,0xc011bf08
    str[1] = 'r';
c0104374:	c6 05 09 bf 11 c0 72 	movb   $0x72,0xc011bf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010437b:	8b 45 08             	mov    0x8(%ebp),%eax
c010437e:	83 e0 02             	and    $0x2,%eax
c0104381:	85 c0                	test   %eax,%eax
c0104383:	74 04                	je     c0104389 <perm2str+0x2d>
c0104385:	b0 77                	mov    $0x77,%al
c0104387:	eb 02                	jmp    c010438b <perm2str+0x2f>
c0104389:	b0 2d                	mov    $0x2d,%al
c010438b:	a2 0a bf 11 c0       	mov    %al,0xc011bf0a
    str[3] = '\0';
c0104390:	c6 05 0b bf 11 c0 00 	movb   $0x0,0xc011bf0b
    return str;
c0104397:	b8 08 bf 11 c0       	mov    $0xc011bf08,%eax
}
c010439c:	5d                   	pop    %ebp
c010439d:	c3                   	ret    

c010439e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010439e:	55                   	push   %ebp
c010439f:	89 e5                	mov    %esp,%ebp
c01043a1:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01043a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01043a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043aa:	72 0d                	jb     c01043b9 <get_pgtable_items+0x1b>
        return 0;
c01043ac:	b8 00 00 00 00       	mov    $0x0,%eax
c01043b1:	e9 98 00 00 00       	jmp    c010444e <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01043b6:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01043b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01043bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043bf:	73 18                	jae    c01043d9 <get_pgtable_items+0x3b>
c01043c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01043c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01043cb:	8b 45 14             	mov    0x14(%ebp),%eax
c01043ce:	01 d0                	add    %edx,%eax
c01043d0:	8b 00                	mov    (%eax),%eax
c01043d2:	83 e0 01             	and    $0x1,%eax
c01043d5:	85 c0                	test   %eax,%eax
c01043d7:	74 dd                	je     c01043b6 <get_pgtable_items+0x18>
    }
    if (start < right) {
c01043d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01043dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043df:	73 68                	jae    c0104449 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c01043e1:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01043e5:	74 08                	je     c01043ef <get_pgtable_items+0x51>
            *left_store = start;
c01043e7:	8b 45 18             	mov    0x18(%ebp),%eax
c01043ea:	8b 55 10             	mov    0x10(%ebp),%edx
c01043ed:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01043ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01043f2:	8d 50 01             	lea    0x1(%eax),%edx
c01043f5:	89 55 10             	mov    %edx,0x10(%ebp)
c01043f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01043ff:	8b 45 14             	mov    0x14(%ebp),%eax
c0104402:	01 d0                	add    %edx,%eax
c0104404:	8b 00                	mov    (%eax),%eax
c0104406:	83 e0 07             	and    $0x7,%eax
c0104409:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010440c:	eb 03                	jmp    c0104411 <get_pgtable_items+0x73>
            start ++;
c010440e:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104411:	8b 45 10             	mov    0x10(%ebp),%eax
c0104414:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104417:	73 1d                	jae    c0104436 <get_pgtable_items+0x98>
c0104419:	8b 45 10             	mov    0x10(%ebp),%eax
c010441c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104423:	8b 45 14             	mov    0x14(%ebp),%eax
c0104426:	01 d0                	add    %edx,%eax
c0104428:	8b 00                	mov    (%eax),%eax
c010442a:	83 e0 07             	and    $0x7,%eax
c010442d:	89 c2                	mov    %eax,%edx
c010442f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104432:	39 c2                	cmp    %eax,%edx
c0104434:	74 d8                	je     c010440e <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0104436:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010443a:	74 08                	je     c0104444 <get_pgtable_items+0xa6>
            *right_store = start;
c010443c:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010443f:	8b 55 10             	mov    0x10(%ebp),%edx
c0104442:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104444:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104447:	eb 05                	jmp    c010444e <get_pgtable_items+0xb0>
    }
    return 0;
c0104449:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010444e:	c9                   	leave  
c010444f:	c3                   	ret    

c0104450 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104450:	55                   	push   %ebp
c0104451:	89 e5                	mov    %esp,%ebp
c0104453:	57                   	push   %edi
c0104454:	56                   	push   %esi
c0104455:	53                   	push   %ebx
c0104456:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104459:	c7 04 24 30 70 10 c0 	movl   $0xc0107030,(%esp)
c0104460:	e8 3d be ff ff       	call   c01002a2 <cprintf>
    size_t left, right = 0, perm;
c0104465:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010446c:	e9 fa 00 00 00       	jmp    c010456b <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104474:	89 04 24             	mov    %eax,(%esp)
c0104477:	e8 e0 fe ff ff       	call   c010435c <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010447c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010447f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104482:	29 d1                	sub    %edx,%ecx
c0104484:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104486:	89 d6                	mov    %edx,%esi
c0104488:	c1 e6 16             	shl    $0x16,%esi
c010448b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010448e:	89 d3                	mov    %edx,%ebx
c0104490:	c1 e3 16             	shl    $0x16,%ebx
c0104493:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104496:	89 d1                	mov    %edx,%ecx
c0104498:	c1 e1 16             	shl    $0x16,%ecx
c010449b:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010449e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01044a1:	29 d7                	sub    %edx,%edi
c01044a3:	89 fa                	mov    %edi,%edx
c01044a5:	89 44 24 14          	mov    %eax,0x14(%esp)
c01044a9:	89 74 24 10          	mov    %esi,0x10(%esp)
c01044ad:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01044b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01044b5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01044b9:	c7 04 24 61 70 10 c0 	movl   $0xc0107061,(%esp)
c01044c0:	e8 dd bd ff ff       	call   c01002a2 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01044c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044c8:	c1 e0 0a             	shl    $0xa,%eax
c01044cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01044ce:	eb 54                	jmp    c0104524 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01044d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044d3:	89 04 24             	mov    %eax,(%esp)
c01044d6:	e8 81 fe ff ff       	call   c010435c <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01044db:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01044de:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01044e1:	29 d1                	sub    %edx,%ecx
c01044e3:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01044e5:	89 d6                	mov    %edx,%esi
c01044e7:	c1 e6 0c             	shl    $0xc,%esi
c01044ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01044ed:	89 d3                	mov    %edx,%ebx
c01044ef:	c1 e3 0c             	shl    $0xc,%ebx
c01044f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01044f5:	89 d1                	mov    %edx,%ecx
c01044f7:	c1 e1 0c             	shl    $0xc,%ecx
c01044fa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01044fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104500:	29 d7                	sub    %edx,%edi
c0104502:	89 fa                	mov    %edi,%edx
c0104504:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104508:	89 74 24 10          	mov    %esi,0x10(%esp)
c010450c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104510:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104514:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104518:	c7 04 24 80 70 10 c0 	movl   $0xc0107080,(%esp)
c010451f:	e8 7e bd ff ff       	call   c01002a2 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104524:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010452c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010452f:	89 d3                	mov    %edx,%ebx
c0104531:	c1 e3 0a             	shl    $0xa,%ebx
c0104534:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104537:	89 d1                	mov    %edx,%ecx
c0104539:	c1 e1 0a             	shl    $0xa,%ecx
c010453c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010453f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104543:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104546:	89 54 24 10          	mov    %edx,0x10(%esp)
c010454a:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010454e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104552:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104556:	89 0c 24             	mov    %ecx,(%esp)
c0104559:	e8 40 fe ff ff       	call   c010439e <get_pgtable_items>
c010455e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104561:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104565:	0f 85 65 ff ff ff    	jne    c01044d0 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010456b:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104570:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104573:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104576:	89 54 24 14          	mov    %edx,0x14(%esp)
c010457a:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010457d:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104581:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104585:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104589:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0104590:	00 
c0104591:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104598:	e8 01 fe ff ff       	call   c010439e <get_pgtable_items>
c010459d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01045a4:	0f 85 c7 fe ff ff    	jne    c0104471 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01045aa:	c7 04 24 a4 70 10 c0 	movl   $0xc01070a4,(%esp)
c01045b1:	e8 ec bc ff ff       	call   c01002a2 <cprintf>
}
c01045b6:	90                   	nop
c01045b7:	83 c4 4c             	add    $0x4c,%esp
c01045ba:	5b                   	pop    %ebx
c01045bb:	5e                   	pop    %esi
c01045bc:	5f                   	pop    %edi
c01045bd:	5d                   	pop    %ebp
c01045be:	c3                   	ret    

c01045bf <page2ppn>:
page2ppn(struct Page *page) {
c01045bf:	55                   	push   %ebp
c01045c0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01045c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c5:	8b 15 78 bf 11 c0    	mov    0xc011bf78,%edx
c01045cb:	29 d0                	sub    %edx,%eax
c01045cd:	c1 f8 02             	sar    $0x2,%eax
c01045d0:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01045d6:	5d                   	pop    %ebp
c01045d7:	c3                   	ret    

c01045d8 <page2pa>:
page2pa(struct Page *page) {
c01045d8:	55                   	push   %ebp
c01045d9:	89 e5                	mov    %esp,%ebp
c01045db:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01045de:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e1:	89 04 24             	mov    %eax,(%esp)
c01045e4:	e8 d6 ff ff ff       	call   c01045bf <page2ppn>
c01045e9:	c1 e0 0c             	shl    $0xc,%eax
}
c01045ec:	c9                   	leave  
c01045ed:	c3                   	ret    

c01045ee <page_ref>:
page_ref(struct Page *page) {
c01045ee:	55                   	push   %ebp
c01045ef:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01045f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01045f4:	8b 00                	mov    (%eax),%eax
}
c01045f6:	5d                   	pop    %ebp
c01045f7:	c3                   	ret    

c01045f8 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01045f8:	55                   	push   %ebp
c01045f9:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01045fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01045fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104601:	89 10                	mov    %edx,(%eax)
}
c0104603:	90                   	nop
c0104604:	5d                   	pop    %ebp
c0104605:	c3                   	ret    

c0104606 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104606:	55                   	push   %ebp
c0104607:	89 e5                	mov    %esp,%ebp
c0104609:	83 ec 10             	sub    $0x10,%esp
c010460c:	c7 45 fc 7c bf 11 c0 	movl   $0xc011bf7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104613:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104616:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104619:	89 50 04             	mov    %edx,0x4(%eax)
c010461c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010461f:	8b 50 04             	mov    0x4(%eax),%edx
c0104622:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104625:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0104627:	c7 05 84 bf 11 c0 00 	movl   $0x0,0xc011bf84
c010462e:	00 00 00 
}
c0104631:	90                   	nop
c0104632:	c9                   	leave  
c0104633:	c3                   	ret    

c0104634 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104634:	55                   	push   %ebp
c0104635:	89 e5                	mov    %esp,%ebp
c0104637:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010463a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010463e:	75 24                	jne    c0104664 <default_init_memmap+0x30>
c0104640:	c7 44 24 0c d8 70 10 	movl   $0xc01070d8,0xc(%esp)
c0104647:	c0 
c0104648:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c010464f:	c0 
c0104650:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104657:	00 
c0104658:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c010465f:	e8 95 bd ff ff       	call   c01003f9 <__panic>
    struct Page *p = base;
c0104664:	8b 45 08             	mov    0x8(%ebp),%eax
c0104667:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010466a:	eb 7d                	jmp    c01046e9 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c010466c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010466f:	83 c0 04             	add    $0x4,%eax
c0104672:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104679:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010467c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010467f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104682:	0f a3 10             	bt     %edx,(%eax)
c0104685:	19 c0                	sbb    %eax,%eax
c0104687:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010468a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010468e:	0f 95 c0             	setne  %al
c0104691:	0f b6 c0             	movzbl %al,%eax
c0104694:	85 c0                	test   %eax,%eax
c0104696:	75 24                	jne    c01046bc <default_init_memmap+0x88>
c0104698:	c7 44 24 0c 09 71 10 	movl   $0xc0107109,0xc(%esp)
c010469f:	c0 
c01046a0:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01046a7:	c0 
c01046a8:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01046af:	00 
c01046b0:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01046b7:	e8 3d bd ff ff       	call   c01003f9 <__panic>
        p->flags = p->property = 0;
c01046bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01046c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c9:	8b 50 08             	mov    0x8(%eax),%edx
c01046cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046cf:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01046d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046d9:	00 
c01046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046dd:	89 04 24             	mov    %eax,(%esp)
c01046e0:	e8 13 ff ff ff       	call   c01045f8 <set_page_ref>
    for (; p != base + n; p ++) {
c01046e5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01046e9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046ec:	89 d0                	mov    %edx,%eax
c01046ee:	c1 e0 02             	shl    $0x2,%eax
c01046f1:	01 d0                	add    %edx,%eax
c01046f3:	c1 e0 02             	shl    $0x2,%eax
c01046f6:	89 c2                	mov    %eax,%edx
c01046f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01046fb:	01 d0                	add    %edx,%eax
c01046fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104700:	0f 85 66 ff ff ff    	jne    c010466c <default_init_memmap+0x38>
    }
    base->property = n;
c0104706:	8b 45 08             	mov    0x8(%ebp),%eax
c0104709:	8b 55 0c             	mov    0xc(%ebp),%edx
c010470c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010470f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104712:	83 c0 04             	add    $0x4,%eax
c0104715:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010471c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010471f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104722:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104725:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0104728:	8b 15 84 bf 11 c0    	mov    0xc011bf84,%edx
c010472e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104731:	01 d0                	add    %edx,%eax
c0104733:	a3 84 bf 11 c0       	mov    %eax,0xc011bf84
    list_add_before(&free_list, &(base->page_link));
c0104738:	8b 45 08             	mov    0x8(%ebp),%eax
c010473b:	83 c0 0c             	add    $0xc,%eax
c010473e:	c7 45 e4 7c bf 11 c0 	movl   $0xc011bf7c,-0x1c(%ebp)
c0104745:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010474b:	8b 00                	mov    (%eax),%eax
c010474d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104750:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104753:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104759:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010475c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010475f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104762:	89 10                	mov    %edx,(%eax)
c0104764:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104767:	8b 10                	mov    (%eax),%edx
c0104769:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010476c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010476f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104772:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104775:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104778:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010477b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010477e:	89 10                	mov    %edx,(%eax)
}
c0104780:	90                   	nop
c0104781:	c9                   	leave  
c0104782:	c3                   	ret    

c0104783 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104783:	55                   	push   %ebp
c0104784:	89 e5                	mov    %esp,%ebp
c0104786:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104789:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010478d:	75 24                	jne    c01047b3 <default_alloc_pages+0x30>
c010478f:	c7 44 24 0c d8 70 10 	movl   $0xc01070d8,0xc(%esp)
c0104796:	c0 
c0104797:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c010479e:	c0 
c010479f:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c01047a6:	00 
c01047a7:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01047ae:	e8 46 bc ff ff       	call   c01003f9 <__panic>
    if (n > nr_free) {
c01047b3:	a1 84 bf 11 c0       	mov    0xc011bf84,%eax
c01047b8:	39 45 08             	cmp    %eax,0x8(%ebp)
c01047bb:	76 0a                	jbe    c01047c7 <default_alloc_pages+0x44>
        return NULL;
c01047bd:	b8 00 00 00 00       	mov    $0x0,%eax
c01047c2:	e9 3d 01 00 00       	jmp    c0104904 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
c01047c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01047ce:	c7 45 f0 7c bf 11 c0 	movl   $0xc011bf7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01047d5:	eb 1c                	jmp    c01047f3 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01047d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047da:	83 e8 0c             	sub    $0xc,%eax
c01047dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01047e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047e3:	8b 40 08             	mov    0x8(%eax),%eax
c01047e6:	39 45 08             	cmp    %eax,0x8(%ebp)
c01047e9:	77 08                	ja     c01047f3 <default_alloc_pages+0x70>
            page = p;
c01047eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01047f1:	eb 18                	jmp    c010480b <default_alloc_pages+0x88>
c01047f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01047f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047fc:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01047ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104802:	81 7d f0 7c bf 11 c0 	cmpl   $0xc011bf7c,-0x10(%ebp)
c0104809:	75 cc                	jne    c01047d7 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c010480b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010480f:	0f 84 ec 00 00 00    	je     c0104901 <default_alloc_pages+0x17e>
        if (page->property > n) {
c0104815:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104818:	8b 40 08             	mov    0x8(%eax),%eax
c010481b:	39 45 08             	cmp    %eax,0x8(%ebp)
c010481e:	0f 83 8c 00 00 00    	jae    c01048b0 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
c0104824:	8b 55 08             	mov    0x8(%ebp),%edx
c0104827:	89 d0                	mov    %edx,%eax
c0104829:	c1 e0 02             	shl    $0x2,%eax
c010482c:	01 d0                	add    %edx,%eax
c010482e:	c1 e0 02             	shl    $0x2,%eax
c0104831:	89 c2                	mov    %eax,%edx
c0104833:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104836:	01 d0                	add    %edx,%eax
c0104838:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010483b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010483e:	8b 40 08             	mov    0x8(%eax),%eax
c0104841:	2b 45 08             	sub    0x8(%ebp),%eax
c0104844:	89 c2                	mov    %eax,%edx
c0104846:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104849:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c010484c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010484f:	83 c0 04             	add    $0x4,%eax
c0104852:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104859:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010485c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010485f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104862:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0104865:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104868:	83 c0 0c             	add    $0xc,%eax
c010486b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010486e:	83 c2 0c             	add    $0xc,%edx
c0104871:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0104874:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104877:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010487a:	8b 40 04             	mov    0x4(%eax),%eax
c010487d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104880:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104883:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104886:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104889:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c010488c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010488f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104892:	89 10                	mov    %edx,(%eax)
c0104894:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104897:	8b 10                	mov    (%eax),%edx
c0104899:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010489c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010489f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01048a2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01048a5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01048a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01048ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01048ae:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c01048b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b3:	83 c0 0c             	add    $0xc,%eax
c01048b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01048b9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01048bc:	8b 40 04             	mov    0x4(%eax),%eax
c01048bf:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01048c2:	8b 12                	mov    (%edx),%edx
c01048c4:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01048c7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01048ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01048cd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01048d0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01048d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01048d6:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01048d9:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c01048db:	a1 84 bf 11 c0       	mov    0xc011bf84,%eax
c01048e0:	2b 45 08             	sub    0x8(%ebp),%eax
c01048e3:	a3 84 bf 11 c0       	mov    %eax,0xc011bf84
        ClearPageProperty(page);
c01048e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048eb:	83 c0 04             	add    $0x4,%eax
c01048ee:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01048f5:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01048f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01048fb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01048fe:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0104901:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104904:	c9                   	leave  
c0104905:	c3                   	ret    

c0104906 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104906:	55                   	push   %ebp
c0104907:	89 e5                	mov    %esp,%ebp
c0104909:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c010490f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104913:	75 24                	jne    c0104939 <default_free_pages+0x33>
c0104915:	c7 44 24 0c d8 70 10 	movl   $0xc01070d8,0xc(%esp)
c010491c:	c0 
c010491d:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104924:	c0 
c0104925:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c010492c:	00 
c010492d:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104934:	e8 c0 ba ff ff       	call   c01003f9 <__panic>
    struct Page *p = base;
c0104939:	8b 45 08             	mov    0x8(%ebp),%eax
c010493c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010493f:	e9 9d 00 00 00       	jmp    c01049e1 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0104944:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104947:	83 c0 04             	add    $0x4,%eax
c010494a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104951:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104954:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104957:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010495a:	0f a3 10             	bt     %edx,(%eax)
c010495d:	19 c0                	sbb    %eax,%eax
c010495f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104962:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104966:	0f 95 c0             	setne  %al
c0104969:	0f b6 c0             	movzbl %al,%eax
c010496c:	85 c0                	test   %eax,%eax
c010496e:	75 2c                	jne    c010499c <default_free_pages+0x96>
c0104970:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104973:	83 c0 04             	add    $0x4,%eax
c0104976:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010497d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104980:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104983:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104986:	0f a3 10             	bt     %edx,(%eax)
c0104989:	19 c0                	sbb    %eax,%eax
c010498b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010498e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104992:	0f 95 c0             	setne  %al
c0104995:	0f b6 c0             	movzbl %al,%eax
c0104998:	85 c0                	test   %eax,%eax
c010499a:	74 24                	je     c01049c0 <default_free_pages+0xba>
c010499c:	c7 44 24 0c 1c 71 10 	movl   $0xc010711c,0xc(%esp)
c01049a3:	c0 
c01049a4:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01049ab:	c0 
c01049ac:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01049b3:	00 
c01049b4:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01049bb:	e8 39 ba ff ff       	call   c01003f9 <__panic>
        p->flags = 0;
c01049c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01049ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049d1:	00 
c01049d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d5:	89 04 24             	mov    %eax,(%esp)
c01049d8:	e8 1b fc ff ff       	call   c01045f8 <set_page_ref>
    for (; p != base + n; p ++) {
c01049dd:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01049e1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01049e4:	89 d0                	mov    %edx,%eax
c01049e6:	c1 e0 02             	shl    $0x2,%eax
c01049e9:	01 d0                	add    %edx,%eax
c01049eb:	c1 e0 02             	shl    $0x2,%eax
c01049ee:	89 c2                	mov    %eax,%edx
c01049f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01049f3:	01 d0                	add    %edx,%eax
c01049f5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01049f8:	0f 85 46 ff ff ff    	jne    c0104944 <default_free_pages+0x3e>
    }
    base->property = n;
c01049fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a01:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104a04:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a0a:	83 c0 04             	add    $0x4,%eax
c0104a0d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104a14:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104a17:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104a1a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a1d:	0f ab 10             	bts    %edx,(%eax)
c0104a20:	c7 45 d4 7c bf 11 c0 	movl   $0xc011bf7c,-0x2c(%ebp)
    return listelm->next;
c0104a27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104a2a:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104a30:	e9 08 01 00 00       	jmp    c0104b3d <default_free_pages+0x237>
        p = le2page(le, page_link);
c0104a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a38:	83 e8 0c             	sub    $0xc,%eax
c0104a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a41:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104a44:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a47:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0104a4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a50:	8b 50 08             	mov    0x8(%eax),%edx
c0104a53:	89 d0                	mov    %edx,%eax
c0104a55:	c1 e0 02             	shl    $0x2,%eax
c0104a58:	01 d0                	add    %edx,%eax
c0104a5a:	c1 e0 02             	shl    $0x2,%eax
c0104a5d:	89 c2                	mov    %eax,%edx
c0104a5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a62:	01 d0                	add    %edx,%eax
c0104a64:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104a67:	75 5a                	jne    c0104ac3 <default_free_pages+0x1bd>
            base->property += p->property;
c0104a69:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a6c:	8b 50 08             	mov    0x8(%eax),%edx
c0104a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a72:	8b 40 08             	mov    0x8(%eax),%eax
c0104a75:	01 c2                	add    %eax,%edx
c0104a77:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a7a:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a80:	83 c0 04             	add    $0x4,%eax
c0104a83:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104a8a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104a8d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104a90:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104a93:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a99:	83 c0 0c             	add    $0xc,%eax
c0104a9c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104a9f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104aa2:	8b 40 04             	mov    0x4(%eax),%eax
c0104aa5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104aa8:	8b 12                	mov    (%edx),%edx
c0104aaa:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104aad:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104ab0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104ab3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ab6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104ab9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104abc:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104abf:	89 10                	mov    %edx,(%eax)
c0104ac1:	eb 7a                	jmp    c0104b3d <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0104ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ac6:	8b 50 08             	mov    0x8(%eax),%edx
c0104ac9:	89 d0                	mov    %edx,%eax
c0104acb:	c1 e0 02             	shl    $0x2,%eax
c0104ace:	01 d0                	add    %edx,%eax
c0104ad0:	c1 e0 02             	shl    $0x2,%eax
c0104ad3:	89 c2                	mov    %eax,%edx
c0104ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ad8:	01 d0                	add    %edx,%eax
c0104ada:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104add:	75 5e                	jne    c0104b3d <default_free_pages+0x237>
            p->property += base->property;
c0104adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ae2:	8b 50 08             	mov    0x8(%eax),%edx
c0104ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ae8:	8b 40 08             	mov    0x8(%eax),%eax
c0104aeb:	01 c2                	add    %eax,%edx
c0104aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104af0:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0104af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104af6:	83 c0 04             	add    $0x4,%eax
c0104af9:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104b00:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104b03:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104b06:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104b09:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b0f:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b15:	83 c0 0c             	add    $0xc,%eax
c0104b18:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104b1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104b1e:	8b 40 04             	mov    0x4(%eax),%eax
c0104b21:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104b24:	8b 12                	mov    (%edx),%edx
c0104b26:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104b29:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104b2c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104b2f:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104b32:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104b35:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104b38:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104b3b:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c0104b3d:	81 7d f0 7c bf 11 c0 	cmpl   $0xc011bf7c,-0x10(%ebp)
c0104b44:	0f 85 eb fe ff ff    	jne    c0104a35 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
c0104b4a:	8b 15 84 bf 11 c0    	mov    0xc011bf84,%edx
c0104b50:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b53:	01 d0                	add    %edx,%eax
c0104b55:	a3 84 bf 11 c0       	mov    %eax,0xc011bf84
c0104b5a:	c7 45 9c 7c bf 11 c0 	movl   $0xc011bf7c,-0x64(%ebp)
    return listelm->next;
c0104b61:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104b64:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0104b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104b6a:	eb 74                	jmp    c0104be0 <default_free_pages+0x2da>
        p = le2page(le, page_link);
c0104b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b6f:	83 e8 0c             	sub    $0xc,%eax
c0104b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0104b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b78:	8b 50 08             	mov    0x8(%eax),%edx
c0104b7b:	89 d0                	mov    %edx,%eax
c0104b7d:	c1 e0 02             	shl    $0x2,%eax
c0104b80:	01 d0                	add    %edx,%eax
c0104b82:	c1 e0 02             	shl    $0x2,%eax
c0104b85:	89 c2                	mov    %eax,%edx
c0104b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b8a:	01 d0                	add    %edx,%eax
c0104b8c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104b8f:	72 40                	jb     c0104bd1 <default_free_pages+0x2cb>
            assert(base + base->property != p);
c0104b91:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b94:	8b 50 08             	mov    0x8(%eax),%edx
c0104b97:	89 d0                	mov    %edx,%eax
c0104b99:	c1 e0 02             	shl    $0x2,%eax
c0104b9c:	01 d0                	add    %edx,%eax
c0104b9e:	c1 e0 02             	shl    $0x2,%eax
c0104ba1:	89 c2                	mov    %eax,%edx
c0104ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ba6:	01 d0                	add    %edx,%eax
c0104ba8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104bab:	75 3e                	jne    c0104beb <default_free_pages+0x2e5>
c0104bad:	c7 44 24 0c 41 71 10 	movl   $0xc0107141,0xc(%esp)
c0104bb4:	c0 
c0104bb5:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104bbc:	c0 
c0104bbd:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0104bc4:	00 
c0104bc5:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104bcc:	e8 28 b8 ff ff       	call   c01003f9 <__panic>
c0104bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bd4:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104bd7:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104bda:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0104bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104be0:	81 7d f0 7c bf 11 c0 	cmpl   $0xc011bf7c,-0x10(%ebp)
c0104be7:	75 83                	jne    c0104b6c <default_free_pages+0x266>
c0104be9:	eb 01                	jmp    c0104bec <default_free_pages+0x2e6>
            break;
c0104beb:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c0104bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bef:	8d 50 0c             	lea    0xc(%eax),%edx
c0104bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bf5:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104bf8:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0104bfb:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104bfe:	8b 00                	mov    (%eax),%eax
c0104c00:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104c03:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104c06:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104c09:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104c0c:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104c0f:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104c12:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104c15:	89 10                	mov    %edx,(%eax)
c0104c17:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104c1a:	8b 10                	mov    (%eax),%edx
c0104c1c:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104c1f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104c22:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104c25:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104c28:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104c2b:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104c2e:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104c31:	89 10                	mov    %edx,(%eax)
}
c0104c33:	90                   	nop
c0104c34:	c9                   	leave  
c0104c35:	c3                   	ret    

c0104c36 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104c36:	55                   	push   %ebp
c0104c37:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104c39:	a1 84 bf 11 c0       	mov    0xc011bf84,%eax
}
c0104c3e:	5d                   	pop    %ebp
c0104c3f:	c3                   	ret    

c0104c40 <basic_check>:

static void
basic_check(void) {
c0104c40:	55                   	push   %ebp
c0104c41:	89 e5                	mov    %esp,%ebp
c0104c43:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104c46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c56:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104c59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c60:	e8 ac e2 ff ff       	call   c0102f11 <alloc_pages>
c0104c65:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104c6c:	75 24                	jne    c0104c92 <basic_check+0x52>
c0104c6e:	c7 44 24 0c 5c 71 10 	movl   $0xc010715c,0xc(%esp)
c0104c75:	c0 
c0104c76:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104c7d:	c0 
c0104c7e:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0104c85:	00 
c0104c86:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104c8d:	e8 67 b7 ff ff       	call   c01003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104c92:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c99:	e8 73 e2 ff ff       	call   c0102f11 <alloc_pages>
c0104c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ca1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ca5:	75 24                	jne    c0104ccb <basic_check+0x8b>
c0104ca7:	c7 44 24 0c 78 71 10 	movl   $0xc0107178,0xc(%esp)
c0104cae:	c0 
c0104caf:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104cb6:	c0 
c0104cb7:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0104cbe:	00 
c0104cbf:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104cc6:	e8 2e b7 ff ff       	call   c01003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104ccb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cd2:	e8 3a e2 ff ff       	call   c0102f11 <alloc_pages>
c0104cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cde:	75 24                	jne    c0104d04 <basic_check+0xc4>
c0104ce0:	c7 44 24 0c 94 71 10 	movl   $0xc0107194,0xc(%esp)
c0104ce7:	c0 
c0104ce8:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104cef:	c0 
c0104cf0:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0104cf7:	00 
c0104cf8:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104cff:	e8 f5 b6 ff ff       	call   c01003f9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d07:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104d0a:	74 10                	je     c0104d1c <basic_check+0xdc>
c0104d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d0f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104d12:	74 08                	je     c0104d1c <basic_check+0xdc>
c0104d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d17:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104d1a:	75 24                	jne    c0104d40 <basic_check+0x100>
c0104d1c:	c7 44 24 0c b0 71 10 	movl   $0xc01071b0,0xc(%esp)
c0104d23:	c0 
c0104d24:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104d2b:	c0 
c0104d2c:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104d33:	00 
c0104d34:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104d3b:	e8 b9 b6 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d43:	89 04 24             	mov    %eax,(%esp)
c0104d46:	e8 a3 f8 ff ff       	call   c01045ee <page_ref>
c0104d4b:	85 c0                	test   %eax,%eax
c0104d4d:	75 1e                	jne    c0104d6d <basic_check+0x12d>
c0104d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d52:	89 04 24             	mov    %eax,(%esp)
c0104d55:	e8 94 f8 ff ff       	call   c01045ee <page_ref>
c0104d5a:	85 c0                	test   %eax,%eax
c0104d5c:	75 0f                	jne    c0104d6d <basic_check+0x12d>
c0104d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d61:	89 04 24             	mov    %eax,(%esp)
c0104d64:	e8 85 f8 ff ff       	call   c01045ee <page_ref>
c0104d69:	85 c0                	test   %eax,%eax
c0104d6b:	74 24                	je     c0104d91 <basic_check+0x151>
c0104d6d:	c7 44 24 0c d4 71 10 	movl   $0xc01071d4,0xc(%esp)
c0104d74:	c0 
c0104d75:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104d7c:	c0 
c0104d7d:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0104d84:	00 
c0104d85:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104d8c:	e8 68 b6 ff ff       	call   c01003f9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d94:	89 04 24             	mov    %eax,(%esp)
c0104d97:	e8 3c f8 ff ff       	call   c01045d8 <page2pa>
c0104d9c:	8b 15 80 be 11 c0    	mov    0xc011be80,%edx
c0104da2:	c1 e2 0c             	shl    $0xc,%edx
c0104da5:	39 d0                	cmp    %edx,%eax
c0104da7:	72 24                	jb     c0104dcd <basic_check+0x18d>
c0104da9:	c7 44 24 0c 10 72 10 	movl   $0xc0107210,0xc(%esp)
c0104db0:	c0 
c0104db1:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104db8:	c0 
c0104db9:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104dc0:	00 
c0104dc1:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104dc8:	e8 2c b6 ff ff       	call   c01003f9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd0:	89 04 24             	mov    %eax,(%esp)
c0104dd3:	e8 00 f8 ff ff       	call   c01045d8 <page2pa>
c0104dd8:	8b 15 80 be 11 c0    	mov    0xc011be80,%edx
c0104dde:	c1 e2 0c             	shl    $0xc,%edx
c0104de1:	39 d0                	cmp    %edx,%eax
c0104de3:	72 24                	jb     c0104e09 <basic_check+0x1c9>
c0104de5:	c7 44 24 0c 2d 72 10 	movl   $0xc010722d,0xc(%esp)
c0104dec:	c0 
c0104ded:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104df4:	c0 
c0104df5:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104dfc:	00 
c0104dfd:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104e04:	e8 f0 b5 ff ff       	call   c01003f9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e0c:	89 04 24             	mov    %eax,(%esp)
c0104e0f:	e8 c4 f7 ff ff       	call   c01045d8 <page2pa>
c0104e14:	8b 15 80 be 11 c0    	mov    0xc011be80,%edx
c0104e1a:	c1 e2 0c             	shl    $0xc,%edx
c0104e1d:	39 d0                	cmp    %edx,%eax
c0104e1f:	72 24                	jb     c0104e45 <basic_check+0x205>
c0104e21:	c7 44 24 0c 4a 72 10 	movl   $0xc010724a,0xc(%esp)
c0104e28:	c0 
c0104e29:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104e30:	c0 
c0104e31:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0104e38:	00 
c0104e39:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104e40:	e8 b4 b5 ff ff       	call   c01003f9 <__panic>

    list_entry_t free_list_store = free_list;
c0104e45:	a1 7c bf 11 c0       	mov    0xc011bf7c,%eax
c0104e4a:	8b 15 80 bf 11 c0    	mov    0xc011bf80,%edx
c0104e50:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104e53:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104e56:	c7 45 dc 7c bf 11 c0 	movl   $0xc011bf7c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104e5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e60:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e63:	89 50 04             	mov    %edx,0x4(%eax)
c0104e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e69:	8b 50 04             	mov    0x4(%eax),%edx
c0104e6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e6f:	89 10                	mov    %edx,(%eax)
c0104e71:	c7 45 e0 7c bf 11 c0 	movl   $0xc011bf7c,-0x20(%ebp)
    return list->next == list;
c0104e78:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e7b:	8b 40 04             	mov    0x4(%eax),%eax
c0104e7e:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104e81:	0f 94 c0             	sete   %al
c0104e84:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104e87:	85 c0                	test   %eax,%eax
c0104e89:	75 24                	jne    c0104eaf <basic_check+0x26f>
c0104e8b:	c7 44 24 0c 67 72 10 	movl   $0xc0107267,0xc(%esp)
c0104e92:	c0 
c0104e93:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104e9a:	c0 
c0104e9b:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0104ea2:	00 
c0104ea3:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104eaa:	e8 4a b5 ff ff       	call   c01003f9 <__panic>

    unsigned int nr_free_store = nr_free;
c0104eaf:	a1 84 bf 11 c0       	mov    0xc011bf84,%eax
c0104eb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104eb7:	c7 05 84 bf 11 c0 00 	movl   $0x0,0xc011bf84
c0104ebe:	00 00 00 

    assert(alloc_page() == NULL);
c0104ec1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ec8:	e8 44 e0 ff ff       	call   c0102f11 <alloc_pages>
c0104ecd:	85 c0                	test   %eax,%eax
c0104ecf:	74 24                	je     c0104ef5 <basic_check+0x2b5>
c0104ed1:	c7 44 24 0c 7e 72 10 	movl   $0xc010727e,0xc(%esp)
c0104ed8:	c0 
c0104ed9:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104ee0:	c0 
c0104ee1:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0104ee8:	00 
c0104ee9:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104ef0:	e8 04 b5 ff ff       	call   c01003f9 <__panic>

    free_page(p0);
c0104ef5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104efc:	00 
c0104efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f00:	89 04 24             	mov    %eax,(%esp)
c0104f03:	e8 41 e0 ff ff       	call   c0102f49 <free_pages>
    free_page(p1);
c0104f08:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f0f:	00 
c0104f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f13:	89 04 24             	mov    %eax,(%esp)
c0104f16:	e8 2e e0 ff ff       	call   c0102f49 <free_pages>
    free_page(p2);
c0104f1b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f22:	00 
c0104f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f26:	89 04 24             	mov    %eax,(%esp)
c0104f29:	e8 1b e0 ff ff       	call   c0102f49 <free_pages>
    assert(nr_free == 3);
c0104f2e:	a1 84 bf 11 c0       	mov    0xc011bf84,%eax
c0104f33:	83 f8 03             	cmp    $0x3,%eax
c0104f36:	74 24                	je     c0104f5c <basic_check+0x31c>
c0104f38:	c7 44 24 0c 93 72 10 	movl   $0xc0107293,0xc(%esp)
c0104f3f:	c0 
c0104f40:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104f47:	c0 
c0104f48:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0104f4f:	00 
c0104f50:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104f57:	e8 9d b4 ff ff       	call   c01003f9 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104f5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f63:	e8 a9 df ff ff       	call   c0102f11 <alloc_pages>
c0104f68:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104f6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104f6f:	75 24                	jne    c0104f95 <basic_check+0x355>
c0104f71:	c7 44 24 0c 5c 71 10 	movl   $0xc010715c,0xc(%esp)
c0104f78:	c0 
c0104f79:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104f80:	c0 
c0104f81:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104f88:	00 
c0104f89:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104f90:	e8 64 b4 ff ff       	call   c01003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104f95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f9c:	e8 70 df ff ff       	call   c0102f11 <alloc_pages>
c0104fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104fa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104fa8:	75 24                	jne    c0104fce <basic_check+0x38e>
c0104faa:	c7 44 24 0c 78 71 10 	movl   $0xc0107178,0xc(%esp)
c0104fb1:	c0 
c0104fb2:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104fb9:	c0 
c0104fba:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104fc1:	00 
c0104fc2:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0104fc9:	e8 2b b4 ff ff       	call   c01003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104fce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fd5:	e8 37 df ff ff       	call   c0102f11 <alloc_pages>
c0104fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104fe1:	75 24                	jne    c0105007 <basic_check+0x3c7>
c0104fe3:	c7 44 24 0c 94 71 10 	movl   $0xc0107194,0xc(%esp)
c0104fea:	c0 
c0104feb:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0104ff2:	c0 
c0104ff3:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0104ffa:	00 
c0104ffb:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105002:	e8 f2 b3 ff ff       	call   c01003f9 <__panic>

    assert(alloc_page() == NULL);
c0105007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010500e:	e8 fe de ff ff       	call   c0102f11 <alloc_pages>
c0105013:	85 c0                	test   %eax,%eax
c0105015:	74 24                	je     c010503b <basic_check+0x3fb>
c0105017:	c7 44 24 0c 7e 72 10 	movl   $0xc010727e,0xc(%esp)
c010501e:	c0 
c010501f:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105026:	c0 
c0105027:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c010502e:	00 
c010502f:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105036:	e8 be b3 ff ff       	call   c01003f9 <__panic>

    free_page(p0);
c010503b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105042:	00 
c0105043:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105046:	89 04 24             	mov    %eax,(%esp)
c0105049:	e8 fb de ff ff       	call   c0102f49 <free_pages>
c010504e:	c7 45 d8 7c bf 11 c0 	movl   $0xc011bf7c,-0x28(%ebp)
c0105055:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105058:	8b 40 04             	mov    0x4(%eax),%eax
c010505b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010505e:	0f 94 c0             	sete   %al
c0105061:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0105064:	85 c0                	test   %eax,%eax
c0105066:	74 24                	je     c010508c <basic_check+0x44c>
c0105068:	c7 44 24 0c a0 72 10 	movl   $0xc01072a0,0xc(%esp)
c010506f:	c0 
c0105070:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105077:	c0 
c0105078:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c010507f:	00 
c0105080:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105087:	e8 6d b3 ff ff       	call   c01003f9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010508c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105093:	e8 79 de ff ff       	call   c0102f11 <alloc_pages>
c0105098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010509b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010509e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01050a1:	74 24                	je     c01050c7 <basic_check+0x487>
c01050a3:	c7 44 24 0c b8 72 10 	movl   $0xc01072b8,0xc(%esp)
c01050aa:	c0 
c01050ab:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01050b2:	c0 
c01050b3:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c01050ba:	00 
c01050bb:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01050c2:	e8 32 b3 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c01050c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01050ce:	e8 3e de ff ff       	call   c0102f11 <alloc_pages>
c01050d3:	85 c0                	test   %eax,%eax
c01050d5:	74 24                	je     c01050fb <basic_check+0x4bb>
c01050d7:	c7 44 24 0c 7e 72 10 	movl   $0xc010727e,0xc(%esp)
c01050de:	c0 
c01050df:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01050e6:	c0 
c01050e7:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01050ee:	00 
c01050ef:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01050f6:	e8 fe b2 ff ff       	call   c01003f9 <__panic>

    assert(nr_free == 0);
c01050fb:	a1 84 bf 11 c0       	mov    0xc011bf84,%eax
c0105100:	85 c0                	test   %eax,%eax
c0105102:	74 24                	je     c0105128 <basic_check+0x4e8>
c0105104:	c7 44 24 0c d1 72 10 	movl   $0xc01072d1,0xc(%esp)
c010510b:	c0 
c010510c:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105113:	c0 
c0105114:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c010511b:	00 
c010511c:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105123:	e8 d1 b2 ff ff       	call   c01003f9 <__panic>
    free_list = free_list_store;
c0105128:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010512b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010512e:	a3 7c bf 11 c0       	mov    %eax,0xc011bf7c
c0105133:	89 15 80 bf 11 c0    	mov    %edx,0xc011bf80
    nr_free = nr_free_store;
c0105139:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010513c:	a3 84 bf 11 c0       	mov    %eax,0xc011bf84

    free_page(p);
c0105141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105148:	00 
c0105149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010514c:	89 04 24             	mov    %eax,(%esp)
c010514f:	e8 f5 dd ff ff       	call   c0102f49 <free_pages>
    free_page(p1);
c0105154:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010515b:	00 
c010515c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010515f:	89 04 24             	mov    %eax,(%esp)
c0105162:	e8 e2 dd ff ff       	call   c0102f49 <free_pages>
    free_page(p2);
c0105167:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010516e:	00 
c010516f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105172:	89 04 24             	mov    %eax,(%esp)
c0105175:	e8 cf dd ff ff       	call   c0102f49 <free_pages>
}
c010517a:	90                   	nop
c010517b:	c9                   	leave  
c010517c:	c3                   	ret    

c010517d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010517d:	55                   	push   %ebp
c010517e:	89 e5                	mov    %esp,%ebp
c0105180:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0105186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010518d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0105194:	c7 45 ec 7c bf 11 c0 	movl   $0xc011bf7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010519b:	eb 6a                	jmp    c0105207 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c010519d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051a0:	83 e8 0c             	sub    $0xc,%eax
c01051a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01051a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01051a9:	83 c0 04             	add    $0x4,%eax
c01051ac:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01051b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01051b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01051b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01051bc:	0f a3 10             	bt     %edx,(%eax)
c01051bf:	19 c0                	sbb    %eax,%eax
c01051c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01051c4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01051c8:	0f 95 c0             	setne  %al
c01051cb:	0f b6 c0             	movzbl %al,%eax
c01051ce:	85 c0                	test   %eax,%eax
c01051d0:	75 24                	jne    c01051f6 <default_check+0x79>
c01051d2:	c7 44 24 0c de 72 10 	movl   $0xc01072de,0xc(%esp)
c01051d9:	c0 
c01051da:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01051e1:	c0 
c01051e2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01051e9:	00 
c01051ea:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01051f1:	e8 03 b2 ff ff       	call   c01003f9 <__panic>
        count ++, total += p->property;
c01051f6:	ff 45 f4             	incl   -0xc(%ebp)
c01051f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01051fc:	8b 50 08             	mov    0x8(%eax),%edx
c01051ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105202:	01 d0                	add    %edx,%eax
c0105204:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105207:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010520a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c010520d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105210:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105213:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105216:	81 7d ec 7c bf 11 c0 	cmpl   $0xc011bf7c,-0x14(%ebp)
c010521d:	0f 85 7a ff ff ff    	jne    c010519d <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0105223:	e8 54 dd ff ff       	call   c0102f7c <nr_free_pages>
c0105228:	89 c2                	mov    %eax,%edx
c010522a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010522d:	39 c2                	cmp    %eax,%edx
c010522f:	74 24                	je     c0105255 <default_check+0xd8>
c0105231:	c7 44 24 0c ee 72 10 	movl   $0xc01072ee,0xc(%esp)
c0105238:	c0 
c0105239:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105240:	c0 
c0105241:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0105248:	00 
c0105249:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105250:	e8 a4 b1 ff ff       	call   c01003f9 <__panic>

    basic_check();
c0105255:	e8 e6 f9 ff ff       	call   c0104c40 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010525a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105261:	e8 ab dc ff ff       	call   c0102f11 <alloc_pages>
c0105266:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0105269:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010526d:	75 24                	jne    c0105293 <default_check+0x116>
c010526f:	c7 44 24 0c 07 73 10 	movl   $0xc0107307,0xc(%esp)
c0105276:	c0 
c0105277:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c010527e:	c0 
c010527f:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0105286:	00 
c0105287:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c010528e:	e8 66 b1 ff ff       	call   c01003f9 <__panic>
    assert(!PageProperty(p0));
c0105293:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105296:	83 c0 04             	add    $0x4,%eax
c0105299:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01052a0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01052a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01052a6:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01052a9:	0f a3 10             	bt     %edx,(%eax)
c01052ac:	19 c0                	sbb    %eax,%eax
c01052ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01052b1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01052b5:	0f 95 c0             	setne  %al
c01052b8:	0f b6 c0             	movzbl %al,%eax
c01052bb:	85 c0                	test   %eax,%eax
c01052bd:	74 24                	je     c01052e3 <default_check+0x166>
c01052bf:	c7 44 24 0c 12 73 10 	movl   $0xc0107312,0xc(%esp)
c01052c6:	c0 
c01052c7:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01052ce:	c0 
c01052cf:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c01052d6:	00 
c01052d7:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01052de:	e8 16 b1 ff ff       	call   c01003f9 <__panic>

    list_entry_t free_list_store = free_list;
c01052e3:	a1 7c bf 11 c0       	mov    0xc011bf7c,%eax
c01052e8:	8b 15 80 bf 11 c0    	mov    0xc011bf80,%edx
c01052ee:	89 45 80             	mov    %eax,-0x80(%ebp)
c01052f1:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01052f4:	c7 45 b0 7c bf 11 c0 	movl   $0xc011bf7c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01052fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01052fe:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105301:	89 50 04             	mov    %edx,0x4(%eax)
c0105304:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105307:	8b 50 04             	mov    0x4(%eax),%edx
c010530a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010530d:	89 10                	mov    %edx,(%eax)
c010530f:	c7 45 b4 7c bf 11 c0 	movl   $0xc011bf7c,-0x4c(%ebp)
    return list->next == list;
c0105316:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105319:	8b 40 04             	mov    0x4(%eax),%eax
c010531c:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c010531f:	0f 94 c0             	sete   %al
c0105322:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105325:	85 c0                	test   %eax,%eax
c0105327:	75 24                	jne    c010534d <default_check+0x1d0>
c0105329:	c7 44 24 0c 67 72 10 	movl   $0xc0107267,0xc(%esp)
c0105330:	c0 
c0105331:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105338:	c0 
c0105339:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0105340:	00 
c0105341:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105348:	e8 ac b0 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c010534d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105354:	e8 b8 db ff ff       	call   c0102f11 <alloc_pages>
c0105359:	85 c0                	test   %eax,%eax
c010535b:	74 24                	je     c0105381 <default_check+0x204>
c010535d:	c7 44 24 0c 7e 72 10 	movl   $0xc010727e,0xc(%esp)
c0105364:	c0 
c0105365:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c010536c:	c0 
c010536d:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0105374:	00 
c0105375:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c010537c:	e8 78 b0 ff ff       	call   c01003f9 <__panic>

    unsigned int nr_free_store = nr_free;
c0105381:	a1 84 bf 11 c0       	mov    0xc011bf84,%eax
c0105386:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0105389:	c7 05 84 bf 11 c0 00 	movl   $0x0,0xc011bf84
c0105390:	00 00 00 

    free_pages(p0 + 2, 3);
c0105393:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105396:	83 c0 28             	add    $0x28,%eax
c0105399:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01053a0:	00 
c01053a1:	89 04 24             	mov    %eax,(%esp)
c01053a4:	e8 a0 db ff ff       	call   c0102f49 <free_pages>
    assert(alloc_pages(4) == NULL);
c01053a9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01053b0:	e8 5c db ff ff       	call   c0102f11 <alloc_pages>
c01053b5:	85 c0                	test   %eax,%eax
c01053b7:	74 24                	je     c01053dd <default_check+0x260>
c01053b9:	c7 44 24 0c 24 73 10 	movl   $0xc0107324,0xc(%esp)
c01053c0:	c0 
c01053c1:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01053c8:	c0 
c01053c9:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c01053d0:	00 
c01053d1:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01053d8:	e8 1c b0 ff ff       	call   c01003f9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01053dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053e0:	83 c0 28             	add    $0x28,%eax
c01053e3:	83 c0 04             	add    $0x4,%eax
c01053e6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01053ed:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01053f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01053f3:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01053f6:	0f a3 10             	bt     %edx,(%eax)
c01053f9:	19 c0                	sbb    %eax,%eax
c01053fb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01053fe:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0105402:	0f 95 c0             	setne  %al
c0105405:	0f b6 c0             	movzbl %al,%eax
c0105408:	85 c0                	test   %eax,%eax
c010540a:	74 0e                	je     c010541a <default_check+0x29d>
c010540c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010540f:	83 c0 28             	add    $0x28,%eax
c0105412:	8b 40 08             	mov    0x8(%eax),%eax
c0105415:	83 f8 03             	cmp    $0x3,%eax
c0105418:	74 24                	je     c010543e <default_check+0x2c1>
c010541a:	c7 44 24 0c 3c 73 10 	movl   $0xc010733c,0xc(%esp)
c0105421:	c0 
c0105422:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105429:	c0 
c010542a:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0105431:	00 
c0105432:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105439:	e8 bb af ff ff       	call   c01003f9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010543e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0105445:	e8 c7 da ff ff       	call   c0102f11 <alloc_pages>
c010544a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010544d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105451:	75 24                	jne    c0105477 <default_check+0x2fa>
c0105453:	c7 44 24 0c 68 73 10 	movl   $0xc0107368,0xc(%esp)
c010545a:	c0 
c010545b:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105462:	c0 
c0105463:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c010546a:	00 
c010546b:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105472:	e8 82 af ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c0105477:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010547e:	e8 8e da ff ff       	call   c0102f11 <alloc_pages>
c0105483:	85 c0                	test   %eax,%eax
c0105485:	74 24                	je     c01054ab <default_check+0x32e>
c0105487:	c7 44 24 0c 7e 72 10 	movl   $0xc010727e,0xc(%esp)
c010548e:	c0 
c010548f:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105496:	c0 
c0105497:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010549e:	00 
c010549f:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01054a6:	e8 4e af ff ff       	call   c01003f9 <__panic>
    assert(p0 + 2 == p1);
c01054ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054ae:	83 c0 28             	add    $0x28,%eax
c01054b1:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01054b4:	74 24                	je     c01054da <default_check+0x35d>
c01054b6:	c7 44 24 0c 86 73 10 	movl   $0xc0107386,0xc(%esp)
c01054bd:	c0 
c01054be:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01054c5:	c0 
c01054c6:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c01054cd:	00 
c01054ce:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01054d5:	e8 1f af ff ff       	call   c01003f9 <__panic>

    p2 = p0 + 1;
c01054da:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054dd:	83 c0 14             	add    $0x14,%eax
c01054e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01054e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01054ea:	00 
c01054eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054ee:	89 04 24             	mov    %eax,(%esp)
c01054f1:	e8 53 da ff ff       	call   c0102f49 <free_pages>
    free_pages(p1, 3);
c01054f6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01054fd:	00 
c01054fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105501:	89 04 24             	mov    %eax,(%esp)
c0105504:	e8 40 da ff ff       	call   c0102f49 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0105509:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010550c:	83 c0 04             	add    $0x4,%eax
c010550f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0105516:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105519:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010551c:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010551f:	0f a3 10             	bt     %edx,(%eax)
c0105522:	19 c0                	sbb    %eax,%eax
c0105524:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0105527:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010552b:	0f 95 c0             	setne  %al
c010552e:	0f b6 c0             	movzbl %al,%eax
c0105531:	85 c0                	test   %eax,%eax
c0105533:	74 0b                	je     c0105540 <default_check+0x3c3>
c0105535:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105538:	8b 40 08             	mov    0x8(%eax),%eax
c010553b:	83 f8 01             	cmp    $0x1,%eax
c010553e:	74 24                	je     c0105564 <default_check+0x3e7>
c0105540:	c7 44 24 0c 94 73 10 	movl   $0xc0107394,0xc(%esp)
c0105547:	c0 
c0105548:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c010554f:	c0 
c0105550:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0105557:	00 
c0105558:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c010555f:	e8 95 ae ff ff       	call   c01003f9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0105564:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105567:	83 c0 04             	add    $0x4,%eax
c010556a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0105571:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105574:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105577:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010557a:	0f a3 10             	bt     %edx,(%eax)
c010557d:	19 c0                	sbb    %eax,%eax
c010557f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105582:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105586:	0f 95 c0             	setne  %al
c0105589:	0f b6 c0             	movzbl %al,%eax
c010558c:	85 c0                	test   %eax,%eax
c010558e:	74 0b                	je     c010559b <default_check+0x41e>
c0105590:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105593:	8b 40 08             	mov    0x8(%eax),%eax
c0105596:	83 f8 03             	cmp    $0x3,%eax
c0105599:	74 24                	je     c01055bf <default_check+0x442>
c010559b:	c7 44 24 0c bc 73 10 	movl   $0xc01073bc,0xc(%esp)
c01055a2:	c0 
c01055a3:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01055aa:	c0 
c01055ab:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c01055b2:	00 
c01055b3:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01055ba:	e8 3a ae ff ff       	call   c01003f9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01055bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01055c6:	e8 46 d9 ff ff       	call   c0102f11 <alloc_pages>
c01055cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01055d1:	83 e8 14             	sub    $0x14,%eax
c01055d4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01055d7:	74 24                	je     c01055fd <default_check+0x480>
c01055d9:	c7 44 24 0c e2 73 10 	movl   $0xc01073e2,0xc(%esp)
c01055e0:	c0 
c01055e1:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01055e8:	c0 
c01055e9:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01055f0:	00 
c01055f1:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01055f8:	e8 fc ad ff ff       	call   c01003f9 <__panic>
    free_page(p0);
c01055fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105604:	00 
c0105605:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105608:	89 04 24             	mov    %eax,(%esp)
c010560b:	e8 39 d9 ff ff       	call   c0102f49 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0105610:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0105617:	e8 f5 d8 ff ff       	call   c0102f11 <alloc_pages>
c010561c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010561f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105622:	83 c0 14             	add    $0x14,%eax
c0105625:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105628:	74 24                	je     c010564e <default_check+0x4d1>
c010562a:	c7 44 24 0c 00 74 10 	movl   $0xc0107400,0xc(%esp)
c0105631:	c0 
c0105632:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105639:	c0 
c010563a:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0105641:	00 
c0105642:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105649:	e8 ab ad ff ff       	call   c01003f9 <__panic>

    free_pages(p0, 2);
c010564e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0105655:	00 
c0105656:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105659:	89 04 24             	mov    %eax,(%esp)
c010565c:	e8 e8 d8 ff ff       	call   c0102f49 <free_pages>
    free_page(p2);
c0105661:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105668:	00 
c0105669:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010566c:	89 04 24             	mov    %eax,(%esp)
c010566f:	e8 d5 d8 ff ff       	call   c0102f49 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0105674:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010567b:	e8 91 d8 ff ff       	call   c0102f11 <alloc_pages>
c0105680:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105683:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105687:	75 24                	jne    c01056ad <default_check+0x530>
c0105689:	c7 44 24 0c 20 74 10 	movl   $0xc0107420,0xc(%esp)
c0105690:	c0 
c0105691:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c0105698:	c0 
c0105699:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c01056a0:	00 
c01056a1:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01056a8:	e8 4c ad ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c01056ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01056b4:	e8 58 d8 ff ff       	call   c0102f11 <alloc_pages>
c01056b9:	85 c0                	test   %eax,%eax
c01056bb:	74 24                	je     c01056e1 <default_check+0x564>
c01056bd:	c7 44 24 0c 7e 72 10 	movl   $0xc010727e,0xc(%esp)
c01056c4:	c0 
c01056c5:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01056cc:	c0 
c01056cd:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c01056d4:	00 
c01056d5:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01056dc:	e8 18 ad ff ff       	call   c01003f9 <__panic>

    assert(nr_free == 0);
c01056e1:	a1 84 bf 11 c0       	mov    0xc011bf84,%eax
c01056e6:	85 c0                	test   %eax,%eax
c01056e8:	74 24                	je     c010570e <default_check+0x591>
c01056ea:	c7 44 24 0c d1 72 10 	movl   $0xc01072d1,0xc(%esp)
c01056f1:	c0 
c01056f2:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01056f9:	c0 
c01056fa:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0105701:	00 
c0105702:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105709:	e8 eb ac ff ff       	call   c01003f9 <__panic>
    nr_free = nr_free_store;
c010570e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105711:	a3 84 bf 11 c0       	mov    %eax,0xc011bf84

    free_list = free_list_store;
c0105716:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105719:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010571c:	a3 7c bf 11 c0       	mov    %eax,0xc011bf7c
c0105721:	89 15 80 bf 11 c0    	mov    %edx,0xc011bf80
    free_pages(p0, 5);
c0105727:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010572e:	00 
c010572f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105732:	89 04 24             	mov    %eax,(%esp)
c0105735:	e8 0f d8 ff ff       	call   c0102f49 <free_pages>

    le = &free_list;
c010573a:	c7 45 ec 7c bf 11 c0 	movl   $0xc011bf7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105741:	eb 5a                	jmp    c010579d <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
c0105743:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105746:	8b 40 04             	mov    0x4(%eax),%eax
c0105749:	8b 00                	mov    (%eax),%eax
c010574b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010574e:	75 0d                	jne    c010575d <default_check+0x5e0>
c0105750:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105753:	8b 00                	mov    (%eax),%eax
c0105755:	8b 40 04             	mov    0x4(%eax),%eax
c0105758:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010575b:	74 24                	je     c0105781 <default_check+0x604>
c010575d:	c7 44 24 0c 40 74 10 	movl   $0xc0107440,0xc(%esp)
c0105764:	c0 
c0105765:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c010576c:	c0 
c010576d:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0105774:	00 
c0105775:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c010577c:	e8 78 ac ff ff       	call   c01003f9 <__panic>
        struct Page *p = le2page(le, page_link);
c0105781:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105784:	83 e8 0c             	sub    $0xc,%eax
c0105787:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c010578a:	ff 4d f4             	decl   -0xc(%ebp)
c010578d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105790:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105793:	8b 40 08             	mov    0x8(%eax),%eax
c0105796:	29 c2                	sub    %eax,%edx
c0105798:	89 d0                	mov    %edx,%eax
c010579a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010579d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057a0:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01057a3:	8b 45 88             	mov    -0x78(%ebp),%eax
c01057a6:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01057a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01057ac:	81 7d ec 7c bf 11 c0 	cmpl   $0xc011bf7c,-0x14(%ebp)
c01057b3:	75 8e                	jne    c0105743 <default_check+0x5c6>
    }
    assert(count == 0);
c01057b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01057b9:	74 24                	je     c01057df <default_check+0x662>
c01057bb:	c7 44 24 0c 6d 74 10 	movl   $0xc010746d,0xc(%esp)
c01057c2:	c0 
c01057c3:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01057ca:	c0 
c01057cb:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c01057d2:	00 
c01057d3:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c01057da:	e8 1a ac ff ff       	call   c01003f9 <__panic>
    assert(total == 0);
c01057df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01057e3:	74 24                	je     c0105809 <default_check+0x68c>
c01057e5:	c7 44 24 0c 78 74 10 	movl   $0xc0107478,0xc(%esp)
c01057ec:	c0 
c01057ed:	c7 44 24 08 de 70 10 	movl   $0xc01070de,0x8(%esp)
c01057f4:	c0 
c01057f5:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01057fc:	00 
c01057fd:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0105804:	e8 f0 ab ff ff       	call   c01003f9 <__panic>
}
c0105809:	90                   	nop
c010580a:	c9                   	leave  
c010580b:	c3                   	ret    

c010580c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010580c:	55                   	push   %ebp
c010580d:	89 e5                	mov    %esp,%ebp
c010580f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105812:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105819:	eb 03                	jmp    c010581e <strlen+0x12>
        cnt ++;
c010581b:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c010581e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105821:	8d 50 01             	lea    0x1(%eax),%edx
c0105824:	89 55 08             	mov    %edx,0x8(%ebp)
c0105827:	0f b6 00             	movzbl (%eax),%eax
c010582a:	84 c0                	test   %al,%al
c010582c:	75 ed                	jne    c010581b <strlen+0xf>
    }
    return cnt;
c010582e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105831:	c9                   	leave  
c0105832:	c3                   	ret    

c0105833 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105833:	55                   	push   %ebp
c0105834:	89 e5                	mov    %esp,%ebp
c0105836:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105839:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105840:	eb 03                	jmp    c0105845 <strnlen+0x12>
        cnt ++;
c0105842:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105845:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105848:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010584b:	73 10                	jae    c010585d <strnlen+0x2a>
c010584d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105850:	8d 50 01             	lea    0x1(%eax),%edx
c0105853:	89 55 08             	mov    %edx,0x8(%ebp)
c0105856:	0f b6 00             	movzbl (%eax),%eax
c0105859:	84 c0                	test   %al,%al
c010585b:	75 e5                	jne    c0105842 <strnlen+0xf>
    }
    return cnt;
c010585d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105860:	c9                   	leave  
c0105861:	c3                   	ret    

c0105862 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105862:	55                   	push   %ebp
c0105863:	89 e5                	mov    %esp,%ebp
c0105865:	57                   	push   %edi
c0105866:	56                   	push   %esi
c0105867:	83 ec 20             	sub    $0x20,%esp
c010586a:	8b 45 08             	mov    0x8(%ebp),%eax
c010586d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105870:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105873:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105876:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105879:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010587c:	89 d1                	mov    %edx,%ecx
c010587e:	89 c2                	mov    %eax,%edx
c0105880:	89 ce                	mov    %ecx,%esi
c0105882:	89 d7                	mov    %edx,%edi
c0105884:	ac                   	lods   %ds:(%esi),%al
c0105885:	aa                   	stos   %al,%es:(%edi)
c0105886:	84 c0                	test   %al,%al
c0105888:	75 fa                	jne    c0105884 <strcpy+0x22>
c010588a:	89 fa                	mov    %edi,%edx
c010588c:	89 f1                	mov    %esi,%ecx
c010588e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105891:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105897:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c010589a:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010589b:	83 c4 20             	add    $0x20,%esp
c010589e:	5e                   	pop    %esi
c010589f:	5f                   	pop    %edi
c01058a0:	5d                   	pop    %ebp
c01058a1:	c3                   	ret    

c01058a2 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01058a2:	55                   	push   %ebp
c01058a3:	89 e5                	mov    %esp,%ebp
c01058a5:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01058a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01058ae:	eb 1e                	jmp    c01058ce <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c01058b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b3:	0f b6 10             	movzbl (%eax),%edx
c01058b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01058b9:	88 10                	mov    %dl,(%eax)
c01058bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01058be:	0f b6 00             	movzbl (%eax),%eax
c01058c1:	84 c0                	test   %al,%al
c01058c3:	74 03                	je     c01058c8 <strncpy+0x26>
            src ++;
c01058c5:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01058c8:	ff 45 fc             	incl   -0x4(%ebp)
c01058cb:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01058ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01058d2:	75 dc                	jne    c01058b0 <strncpy+0xe>
    }
    return dst;
c01058d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01058d7:	c9                   	leave  
c01058d8:	c3                   	ret    

c01058d9 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01058d9:	55                   	push   %ebp
c01058da:	89 e5                	mov    %esp,%ebp
c01058dc:	57                   	push   %edi
c01058dd:	56                   	push   %esi
c01058de:	83 ec 20             	sub    $0x20,%esp
c01058e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01058ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058f3:	89 d1                	mov    %edx,%ecx
c01058f5:	89 c2                	mov    %eax,%edx
c01058f7:	89 ce                	mov    %ecx,%esi
c01058f9:	89 d7                	mov    %edx,%edi
c01058fb:	ac                   	lods   %ds:(%esi),%al
c01058fc:	ae                   	scas   %es:(%edi),%al
c01058fd:	75 08                	jne    c0105907 <strcmp+0x2e>
c01058ff:	84 c0                	test   %al,%al
c0105901:	75 f8                	jne    c01058fb <strcmp+0x22>
c0105903:	31 c0                	xor    %eax,%eax
c0105905:	eb 04                	jmp    c010590b <strcmp+0x32>
c0105907:	19 c0                	sbb    %eax,%eax
c0105909:	0c 01                	or     $0x1,%al
c010590b:	89 fa                	mov    %edi,%edx
c010590d:	89 f1                	mov    %esi,%ecx
c010590f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105912:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105915:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105918:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c010591b:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010591c:	83 c4 20             	add    $0x20,%esp
c010591f:	5e                   	pop    %esi
c0105920:	5f                   	pop    %edi
c0105921:	5d                   	pop    %ebp
c0105922:	c3                   	ret    

c0105923 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105923:	55                   	push   %ebp
c0105924:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105926:	eb 09                	jmp    c0105931 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105928:	ff 4d 10             	decl   0x10(%ebp)
c010592b:	ff 45 08             	incl   0x8(%ebp)
c010592e:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105931:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105935:	74 1a                	je     c0105951 <strncmp+0x2e>
c0105937:	8b 45 08             	mov    0x8(%ebp),%eax
c010593a:	0f b6 00             	movzbl (%eax),%eax
c010593d:	84 c0                	test   %al,%al
c010593f:	74 10                	je     c0105951 <strncmp+0x2e>
c0105941:	8b 45 08             	mov    0x8(%ebp),%eax
c0105944:	0f b6 10             	movzbl (%eax),%edx
c0105947:	8b 45 0c             	mov    0xc(%ebp),%eax
c010594a:	0f b6 00             	movzbl (%eax),%eax
c010594d:	38 c2                	cmp    %al,%dl
c010594f:	74 d7                	je     c0105928 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105951:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105955:	74 18                	je     c010596f <strncmp+0x4c>
c0105957:	8b 45 08             	mov    0x8(%ebp),%eax
c010595a:	0f b6 00             	movzbl (%eax),%eax
c010595d:	0f b6 d0             	movzbl %al,%edx
c0105960:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105963:	0f b6 00             	movzbl (%eax),%eax
c0105966:	0f b6 c0             	movzbl %al,%eax
c0105969:	29 c2                	sub    %eax,%edx
c010596b:	89 d0                	mov    %edx,%eax
c010596d:	eb 05                	jmp    c0105974 <strncmp+0x51>
c010596f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105974:	5d                   	pop    %ebp
c0105975:	c3                   	ret    

c0105976 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105976:	55                   	push   %ebp
c0105977:	89 e5                	mov    %esp,%ebp
c0105979:	83 ec 04             	sub    $0x4,%esp
c010597c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010597f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105982:	eb 13                	jmp    c0105997 <strchr+0x21>
        if (*s == c) {
c0105984:	8b 45 08             	mov    0x8(%ebp),%eax
c0105987:	0f b6 00             	movzbl (%eax),%eax
c010598a:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010598d:	75 05                	jne    c0105994 <strchr+0x1e>
            return (char *)s;
c010598f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105992:	eb 12                	jmp    c01059a6 <strchr+0x30>
        }
        s ++;
c0105994:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105997:	8b 45 08             	mov    0x8(%ebp),%eax
c010599a:	0f b6 00             	movzbl (%eax),%eax
c010599d:	84 c0                	test   %al,%al
c010599f:	75 e3                	jne    c0105984 <strchr+0xe>
    }
    return NULL;
c01059a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01059a6:	c9                   	leave  
c01059a7:	c3                   	ret    

c01059a8 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01059a8:	55                   	push   %ebp
c01059a9:	89 e5                	mov    %esp,%ebp
c01059ab:	83 ec 04             	sub    $0x4,%esp
c01059ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01059b4:	eb 0e                	jmp    c01059c4 <strfind+0x1c>
        if (*s == c) {
c01059b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b9:	0f b6 00             	movzbl (%eax),%eax
c01059bc:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01059bf:	74 0f                	je     c01059d0 <strfind+0x28>
            break;
        }
        s ++;
c01059c1:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01059c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c7:	0f b6 00             	movzbl (%eax),%eax
c01059ca:	84 c0                	test   %al,%al
c01059cc:	75 e8                	jne    c01059b6 <strfind+0xe>
c01059ce:	eb 01                	jmp    c01059d1 <strfind+0x29>
            break;
c01059d0:	90                   	nop
    }
    return (char *)s;
c01059d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01059d4:	c9                   	leave  
c01059d5:	c3                   	ret    

c01059d6 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01059d6:	55                   	push   %ebp
c01059d7:	89 e5                	mov    %esp,%ebp
c01059d9:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01059dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01059e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01059ea:	eb 03                	jmp    c01059ef <strtol+0x19>
        s ++;
c01059ec:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01059ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f2:	0f b6 00             	movzbl (%eax),%eax
c01059f5:	3c 20                	cmp    $0x20,%al
c01059f7:	74 f3                	je     c01059ec <strtol+0x16>
c01059f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059fc:	0f b6 00             	movzbl (%eax),%eax
c01059ff:	3c 09                	cmp    $0x9,%al
c0105a01:	74 e9                	je     c01059ec <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a06:	0f b6 00             	movzbl (%eax),%eax
c0105a09:	3c 2b                	cmp    $0x2b,%al
c0105a0b:	75 05                	jne    c0105a12 <strtol+0x3c>
        s ++;
c0105a0d:	ff 45 08             	incl   0x8(%ebp)
c0105a10:	eb 14                	jmp    c0105a26 <strtol+0x50>
    }
    else if (*s == '-') {
c0105a12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a15:	0f b6 00             	movzbl (%eax),%eax
c0105a18:	3c 2d                	cmp    $0x2d,%al
c0105a1a:	75 0a                	jne    c0105a26 <strtol+0x50>
        s ++, neg = 1;
c0105a1c:	ff 45 08             	incl   0x8(%ebp)
c0105a1f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a2a:	74 06                	je     c0105a32 <strtol+0x5c>
c0105a2c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105a30:	75 22                	jne    c0105a54 <strtol+0x7e>
c0105a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a35:	0f b6 00             	movzbl (%eax),%eax
c0105a38:	3c 30                	cmp    $0x30,%al
c0105a3a:	75 18                	jne    c0105a54 <strtol+0x7e>
c0105a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a3f:	40                   	inc    %eax
c0105a40:	0f b6 00             	movzbl (%eax),%eax
c0105a43:	3c 78                	cmp    $0x78,%al
c0105a45:	75 0d                	jne    c0105a54 <strtol+0x7e>
        s += 2, base = 16;
c0105a47:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105a4b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105a52:	eb 29                	jmp    c0105a7d <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105a54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a58:	75 16                	jne    c0105a70 <strtol+0x9a>
c0105a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5d:	0f b6 00             	movzbl (%eax),%eax
c0105a60:	3c 30                	cmp    $0x30,%al
c0105a62:	75 0c                	jne    c0105a70 <strtol+0x9a>
        s ++, base = 8;
c0105a64:	ff 45 08             	incl   0x8(%ebp)
c0105a67:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105a6e:	eb 0d                	jmp    c0105a7d <strtol+0xa7>
    }
    else if (base == 0) {
c0105a70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a74:	75 07                	jne    c0105a7d <strtol+0xa7>
        base = 10;
c0105a76:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a80:	0f b6 00             	movzbl (%eax),%eax
c0105a83:	3c 2f                	cmp    $0x2f,%al
c0105a85:	7e 1b                	jle    c0105aa2 <strtol+0xcc>
c0105a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8a:	0f b6 00             	movzbl (%eax),%eax
c0105a8d:	3c 39                	cmp    $0x39,%al
c0105a8f:	7f 11                	jg     c0105aa2 <strtol+0xcc>
            dig = *s - '0';
c0105a91:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a94:	0f b6 00             	movzbl (%eax),%eax
c0105a97:	0f be c0             	movsbl %al,%eax
c0105a9a:	83 e8 30             	sub    $0x30,%eax
c0105a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105aa0:	eb 48                	jmp    c0105aea <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105aa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa5:	0f b6 00             	movzbl (%eax),%eax
c0105aa8:	3c 60                	cmp    $0x60,%al
c0105aaa:	7e 1b                	jle    c0105ac7 <strtol+0xf1>
c0105aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aaf:	0f b6 00             	movzbl (%eax),%eax
c0105ab2:	3c 7a                	cmp    $0x7a,%al
c0105ab4:	7f 11                	jg     c0105ac7 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab9:	0f b6 00             	movzbl (%eax),%eax
c0105abc:	0f be c0             	movsbl %al,%eax
c0105abf:	83 e8 57             	sub    $0x57,%eax
c0105ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ac5:	eb 23                	jmp    c0105aea <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aca:	0f b6 00             	movzbl (%eax),%eax
c0105acd:	3c 40                	cmp    $0x40,%al
c0105acf:	7e 3b                	jle    c0105b0c <strtol+0x136>
c0105ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad4:	0f b6 00             	movzbl (%eax),%eax
c0105ad7:	3c 5a                	cmp    $0x5a,%al
c0105ad9:	7f 31                	jg     c0105b0c <strtol+0x136>
            dig = *s - 'A' + 10;
c0105adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ade:	0f b6 00             	movzbl (%eax),%eax
c0105ae1:	0f be c0             	movsbl %al,%eax
c0105ae4:	83 e8 37             	sub    $0x37,%eax
c0105ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105aed:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105af0:	7d 19                	jge    c0105b0b <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105af2:	ff 45 08             	incl   0x8(%ebp)
c0105af5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105af8:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105afc:	89 c2                	mov    %eax,%edx
c0105afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b01:	01 d0                	add    %edx,%eax
c0105b03:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105b06:	e9 72 ff ff ff       	jmp    c0105a7d <strtol+0xa7>
            break;
c0105b0b:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105b0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105b10:	74 08                	je     c0105b1a <strtol+0x144>
        *endptr = (char *) s;
c0105b12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b15:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b18:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105b1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105b1e:	74 07                	je     c0105b27 <strtol+0x151>
c0105b20:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105b23:	f7 d8                	neg    %eax
c0105b25:	eb 03                	jmp    c0105b2a <strtol+0x154>
c0105b27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105b2a:	c9                   	leave  
c0105b2b:	c3                   	ret    

c0105b2c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105b2c:	55                   	push   %ebp
c0105b2d:	89 e5                	mov    %esp,%ebp
c0105b2f:	57                   	push   %edi
c0105b30:	83 ec 24             	sub    $0x24,%esp
c0105b33:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b36:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105b39:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105b3d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b40:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105b43:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105b46:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105b4c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105b4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105b53:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105b56:	89 d7                	mov    %edx,%edi
c0105b58:	f3 aa                	rep stos %al,%es:(%edi)
c0105b5a:	89 fa                	mov    %edi,%edx
c0105b5c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b5f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105b62:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105b65:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105b66:	83 c4 24             	add    $0x24,%esp
c0105b69:	5f                   	pop    %edi
c0105b6a:	5d                   	pop    %ebp
c0105b6b:	c3                   	ret    

c0105b6c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105b6c:	55                   	push   %ebp
c0105b6d:	89 e5                	mov    %esp,%ebp
c0105b6f:	57                   	push   %edi
c0105b70:	56                   	push   %esi
c0105b71:	53                   	push   %ebx
c0105b72:	83 ec 30             	sub    $0x30,%esp
c0105b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b81:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b84:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105b8d:	73 42                	jae    c0105bd1 <memmove+0x65>
c0105b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b98:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b9e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105ba1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ba4:	c1 e8 02             	shr    $0x2,%eax
c0105ba7:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105ba9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105bac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105baf:	89 d7                	mov    %edx,%edi
c0105bb1:	89 c6                	mov    %eax,%esi
c0105bb3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105bb5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105bb8:	83 e1 03             	and    $0x3,%ecx
c0105bbb:	74 02                	je     c0105bbf <memmove+0x53>
c0105bbd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105bbf:	89 f0                	mov    %esi,%eax
c0105bc1:	89 fa                	mov    %edi,%edx
c0105bc3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105bc6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105bc9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0105bcf:	eb 36                	jmp    c0105c07 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105bd4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bda:	01 c2                	add    %eax,%edx
c0105bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105bdf:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105be5:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105be8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105beb:	89 c1                	mov    %eax,%ecx
c0105bed:	89 d8                	mov    %ebx,%eax
c0105bef:	89 d6                	mov    %edx,%esi
c0105bf1:	89 c7                	mov    %eax,%edi
c0105bf3:	fd                   	std    
c0105bf4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105bf6:	fc                   	cld    
c0105bf7:	89 f8                	mov    %edi,%eax
c0105bf9:	89 f2                	mov    %esi,%edx
c0105bfb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105bfe:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105c01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105c07:	83 c4 30             	add    $0x30,%esp
c0105c0a:	5b                   	pop    %ebx
c0105c0b:	5e                   	pop    %esi
c0105c0c:	5f                   	pop    %edi
c0105c0d:	5d                   	pop    %ebp
c0105c0e:	c3                   	ret    

c0105c0f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105c0f:	55                   	push   %ebp
c0105c10:	89 e5                	mov    %esp,%ebp
c0105c12:	57                   	push   %edi
c0105c13:	56                   	push   %esi
c0105c14:	83 ec 20             	sub    $0x20,%esp
c0105c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c23:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c26:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c2c:	c1 e8 02             	shr    $0x2,%eax
c0105c2f:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c37:	89 d7                	mov    %edx,%edi
c0105c39:	89 c6                	mov    %eax,%esi
c0105c3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105c3d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105c40:	83 e1 03             	and    $0x3,%ecx
c0105c43:	74 02                	je     c0105c47 <memcpy+0x38>
c0105c45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105c47:	89 f0                	mov    %esi,%eax
c0105c49:	89 fa                	mov    %edi,%edx
c0105c4b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105c4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105c51:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105c57:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105c58:	83 c4 20             	add    $0x20,%esp
c0105c5b:	5e                   	pop    %esi
c0105c5c:	5f                   	pop    %edi
c0105c5d:	5d                   	pop    %ebp
c0105c5e:	c3                   	ret    

c0105c5f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105c5f:	55                   	push   %ebp
c0105c60:	89 e5                	mov    %esp,%ebp
c0105c62:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105c71:	eb 2e                	jmp    c0105ca1 <memcmp+0x42>
        if (*s1 != *s2) {
c0105c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c76:	0f b6 10             	movzbl (%eax),%edx
c0105c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c7c:	0f b6 00             	movzbl (%eax),%eax
c0105c7f:	38 c2                	cmp    %al,%dl
c0105c81:	74 18                	je     c0105c9b <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c86:	0f b6 00             	movzbl (%eax),%eax
c0105c89:	0f b6 d0             	movzbl %al,%edx
c0105c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c8f:	0f b6 00             	movzbl (%eax),%eax
c0105c92:	0f b6 c0             	movzbl %al,%eax
c0105c95:	29 c2                	sub    %eax,%edx
c0105c97:	89 d0                	mov    %edx,%eax
c0105c99:	eb 18                	jmp    c0105cb3 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105c9b:	ff 45 fc             	incl   -0x4(%ebp)
c0105c9e:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105ca1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ca4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ca7:	89 55 10             	mov    %edx,0x10(%ebp)
c0105caa:	85 c0                	test   %eax,%eax
c0105cac:	75 c5                	jne    c0105c73 <memcmp+0x14>
    }
    return 0;
c0105cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cb3:	c9                   	leave  
c0105cb4:	c3                   	ret    

c0105cb5 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105cb5:	55                   	push   %ebp
c0105cb6:	89 e5                	mov    %esp,%ebp
c0105cb8:	83 ec 58             	sub    $0x58,%esp
c0105cbb:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cbe:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105cc1:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cc4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105cc7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105cca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105ccd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105cd0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105cd3:	8b 45 18             	mov    0x18(%ebp),%eax
c0105cd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105cdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ce2:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105cef:	74 1c                	je     c0105d0d <printnum+0x58>
c0105cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cf4:	ba 00 00 00 00       	mov    $0x0,%edx
c0105cf9:	f7 75 e4             	divl   -0x1c(%ebp)
c0105cfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d02:	ba 00 00 00 00       	mov    $0x0,%edx
c0105d07:	f7 75 e4             	divl   -0x1c(%ebp)
c0105d0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d10:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d13:	f7 75 e4             	divl   -0x1c(%ebp)
c0105d16:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105d19:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105d1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105d22:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105d25:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105d28:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d2b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105d2e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105d31:	ba 00 00 00 00       	mov    $0x0,%edx
c0105d36:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105d39:	72 56                	jb     c0105d91 <printnum+0xdc>
c0105d3b:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105d3e:	77 05                	ja     c0105d45 <printnum+0x90>
c0105d40:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105d43:	72 4c                	jb     c0105d91 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105d45:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105d48:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d4b:	8b 45 20             	mov    0x20(%ebp),%eax
c0105d4e:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105d52:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105d56:	8b 45 18             	mov    0x18(%ebp),%eax
c0105d59:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d60:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105d63:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d67:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d75:	89 04 24             	mov    %eax,(%esp)
c0105d78:	e8 38 ff ff ff       	call   c0105cb5 <printnum>
c0105d7d:	eb 1b                	jmp    c0105d9a <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d86:	8b 45 20             	mov    0x20(%ebp),%eax
c0105d89:	89 04 24             	mov    %eax,(%esp)
c0105d8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8f:	ff d0                	call   *%eax
        while (-- width > 0)
c0105d91:	ff 4d 1c             	decl   0x1c(%ebp)
c0105d94:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105d98:	7f e5                	jg     c0105d7f <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105d9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105d9d:	05 34 75 10 c0       	add    $0xc0107534,%eax
c0105da2:	0f b6 00             	movzbl (%eax),%eax
c0105da5:	0f be c0             	movsbl %al,%eax
c0105da8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105dab:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105daf:	89 04 24             	mov    %eax,(%esp)
c0105db2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db5:	ff d0                	call   *%eax
}
c0105db7:	90                   	nop
c0105db8:	c9                   	leave  
c0105db9:	c3                   	ret    

c0105dba <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105dba:	55                   	push   %ebp
c0105dbb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105dbd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105dc1:	7e 14                	jle    c0105dd7 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc6:	8b 00                	mov    (%eax),%eax
c0105dc8:	8d 48 08             	lea    0x8(%eax),%ecx
c0105dcb:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dce:	89 0a                	mov    %ecx,(%edx)
c0105dd0:	8b 50 04             	mov    0x4(%eax),%edx
c0105dd3:	8b 00                	mov    (%eax),%eax
c0105dd5:	eb 30                	jmp    c0105e07 <getuint+0x4d>
    }
    else if (lflag) {
c0105dd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105ddb:	74 16                	je     c0105df3 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de0:	8b 00                	mov    (%eax),%eax
c0105de2:	8d 48 04             	lea    0x4(%eax),%ecx
c0105de5:	8b 55 08             	mov    0x8(%ebp),%edx
c0105de8:	89 0a                	mov    %ecx,(%edx)
c0105dea:	8b 00                	mov    (%eax),%eax
c0105dec:	ba 00 00 00 00       	mov    $0x0,%edx
c0105df1:	eb 14                	jmp    c0105e07 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df6:	8b 00                	mov    (%eax),%eax
c0105df8:	8d 48 04             	lea    0x4(%eax),%ecx
c0105dfb:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dfe:	89 0a                	mov    %ecx,(%edx)
c0105e00:	8b 00                	mov    (%eax),%eax
c0105e02:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105e07:	5d                   	pop    %ebp
c0105e08:	c3                   	ret    

c0105e09 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105e09:	55                   	push   %ebp
c0105e0a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105e0c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105e10:	7e 14                	jle    c0105e26 <getint+0x1d>
        return va_arg(*ap, long long);
c0105e12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e15:	8b 00                	mov    (%eax),%eax
c0105e17:	8d 48 08             	lea    0x8(%eax),%ecx
c0105e1a:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e1d:	89 0a                	mov    %ecx,(%edx)
c0105e1f:	8b 50 04             	mov    0x4(%eax),%edx
c0105e22:	8b 00                	mov    (%eax),%eax
c0105e24:	eb 28                	jmp    c0105e4e <getint+0x45>
    }
    else if (lflag) {
c0105e26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105e2a:	74 12                	je     c0105e3e <getint+0x35>
        return va_arg(*ap, long);
c0105e2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e2f:	8b 00                	mov    (%eax),%eax
c0105e31:	8d 48 04             	lea    0x4(%eax),%ecx
c0105e34:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e37:	89 0a                	mov    %ecx,(%edx)
c0105e39:	8b 00                	mov    (%eax),%eax
c0105e3b:	99                   	cltd   
c0105e3c:	eb 10                	jmp    c0105e4e <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105e3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e41:	8b 00                	mov    (%eax),%eax
c0105e43:	8d 48 04             	lea    0x4(%eax),%ecx
c0105e46:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e49:	89 0a                	mov    %ecx,(%edx)
c0105e4b:	8b 00                	mov    (%eax),%eax
c0105e4d:	99                   	cltd   
    }
}
c0105e4e:	5d                   	pop    %ebp
c0105e4f:	c3                   	ret    

c0105e50 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105e50:	55                   	push   %ebp
c0105e51:	89 e5                	mov    %esp,%ebp
c0105e53:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105e56:	8d 45 14             	lea    0x14(%ebp),%eax
c0105e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105e63:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e66:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e74:	89 04 24             	mov    %eax,(%esp)
c0105e77:	e8 03 00 00 00       	call   c0105e7f <vprintfmt>
    va_end(ap);
}
c0105e7c:	90                   	nop
c0105e7d:	c9                   	leave  
c0105e7e:	c3                   	ret    

c0105e7f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105e7f:	55                   	push   %ebp
c0105e80:	89 e5                	mov    %esp,%ebp
c0105e82:	56                   	push   %esi
c0105e83:	53                   	push   %ebx
c0105e84:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105e87:	eb 17                	jmp    c0105ea0 <vprintfmt+0x21>
            if (ch == '\0') {
c0105e89:	85 db                	test   %ebx,%ebx
c0105e8b:	0f 84 bf 03 00 00    	je     c0106250 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105e91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e98:	89 1c 24             	mov    %ebx,(%esp)
c0105e9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e9e:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105ea0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ea3:	8d 50 01             	lea    0x1(%eax),%edx
c0105ea6:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ea9:	0f b6 00             	movzbl (%eax),%eax
c0105eac:	0f b6 d8             	movzbl %al,%ebx
c0105eaf:	83 fb 25             	cmp    $0x25,%ebx
c0105eb2:	75 d5                	jne    c0105e89 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105eb4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105eb8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105ebf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ec2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105ec5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105ecc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ecf:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105ed2:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ed5:	8d 50 01             	lea    0x1(%eax),%edx
c0105ed8:	89 55 10             	mov    %edx,0x10(%ebp)
c0105edb:	0f b6 00             	movzbl (%eax),%eax
c0105ede:	0f b6 d8             	movzbl %al,%ebx
c0105ee1:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105ee4:	83 f8 55             	cmp    $0x55,%eax
c0105ee7:	0f 87 37 03 00 00    	ja     c0106224 <vprintfmt+0x3a5>
c0105eed:	8b 04 85 58 75 10 c0 	mov    -0x3fef8aa8(,%eax,4),%eax
c0105ef4:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105ef6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105efa:	eb d6                	jmp    c0105ed2 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105efc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105f00:	eb d0                	jmp    c0105ed2 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105f02:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105f09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f0c:	89 d0                	mov    %edx,%eax
c0105f0e:	c1 e0 02             	shl    $0x2,%eax
c0105f11:	01 d0                	add    %edx,%eax
c0105f13:	01 c0                	add    %eax,%eax
c0105f15:	01 d8                	add    %ebx,%eax
c0105f17:	83 e8 30             	sub    $0x30,%eax
c0105f1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105f1d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f20:	0f b6 00             	movzbl (%eax),%eax
c0105f23:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105f26:	83 fb 2f             	cmp    $0x2f,%ebx
c0105f29:	7e 38                	jle    c0105f63 <vprintfmt+0xe4>
c0105f2b:	83 fb 39             	cmp    $0x39,%ebx
c0105f2e:	7f 33                	jg     c0105f63 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105f30:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105f33:	eb d4                	jmp    c0105f09 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105f35:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f38:	8d 50 04             	lea    0x4(%eax),%edx
c0105f3b:	89 55 14             	mov    %edx,0x14(%ebp)
c0105f3e:	8b 00                	mov    (%eax),%eax
c0105f40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105f43:	eb 1f                	jmp    c0105f64 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0105f45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105f49:	79 87                	jns    c0105ed2 <vprintfmt+0x53>
                width = 0;
c0105f4b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105f52:	e9 7b ff ff ff       	jmp    c0105ed2 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105f57:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105f5e:	e9 6f ff ff ff       	jmp    c0105ed2 <vprintfmt+0x53>
            goto process_precision;
c0105f63:	90                   	nop

        process_precision:
            if (width < 0)
c0105f64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105f68:	0f 89 64 ff ff ff    	jns    c0105ed2 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105f6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f71:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105f74:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105f7b:	e9 52 ff ff ff       	jmp    c0105ed2 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105f80:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105f83:	e9 4a ff ff ff       	jmp    c0105ed2 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105f88:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f8b:	8d 50 04             	lea    0x4(%eax),%edx
c0105f8e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105f91:	8b 00                	mov    (%eax),%eax
c0105f93:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105f96:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f9a:	89 04 24             	mov    %eax,(%esp)
c0105f9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fa0:	ff d0                	call   *%eax
            break;
c0105fa2:	e9 a4 02 00 00       	jmp    c010624b <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105fa7:	8b 45 14             	mov    0x14(%ebp),%eax
c0105faa:	8d 50 04             	lea    0x4(%eax),%edx
c0105fad:	89 55 14             	mov    %edx,0x14(%ebp)
c0105fb0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105fb2:	85 db                	test   %ebx,%ebx
c0105fb4:	79 02                	jns    c0105fb8 <vprintfmt+0x139>
                err = -err;
c0105fb6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105fb8:	83 fb 06             	cmp    $0x6,%ebx
c0105fbb:	7f 0b                	jg     c0105fc8 <vprintfmt+0x149>
c0105fbd:	8b 34 9d 18 75 10 c0 	mov    -0x3fef8ae8(,%ebx,4),%esi
c0105fc4:	85 f6                	test   %esi,%esi
c0105fc6:	75 23                	jne    c0105feb <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0105fc8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105fcc:	c7 44 24 08 45 75 10 	movl   $0xc0107545,0x8(%esp)
c0105fd3:	c0 
c0105fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fde:	89 04 24             	mov    %eax,(%esp)
c0105fe1:	e8 6a fe ff ff       	call   c0105e50 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105fe6:	e9 60 02 00 00       	jmp    c010624b <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0105feb:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105fef:	c7 44 24 08 4e 75 10 	movl   $0xc010754e,0x8(%esp)
c0105ff6:	c0 
c0105ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ffa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ffe:	8b 45 08             	mov    0x8(%ebp),%eax
c0106001:	89 04 24             	mov    %eax,(%esp)
c0106004:	e8 47 fe ff ff       	call   c0105e50 <printfmt>
            break;
c0106009:	e9 3d 02 00 00       	jmp    c010624b <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010600e:	8b 45 14             	mov    0x14(%ebp),%eax
c0106011:	8d 50 04             	lea    0x4(%eax),%edx
c0106014:	89 55 14             	mov    %edx,0x14(%ebp)
c0106017:	8b 30                	mov    (%eax),%esi
c0106019:	85 f6                	test   %esi,%esi
c010601b:	75 05                	jne    c0106022 <vprintfmt+0x1a3>
                p = "(null)";
c010601d:	be 51 75 10 c0       	mov    $0xc0107551,%esi
            }
            if (width > 0 && padc != '-') {
c0106022:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106026:	7e 76                	jle    c010609e <vprintfmt+0x21f>
c0106028:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010602c:	74 70                	je     c010609e <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010602e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106031:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106035:	89 34 24             	mov    %esi,(%esp)
c0106038:	e8 f6 f7 ff ff       	call   c0105833 <strnlen>
c010603d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106040:	29 c2                	sub    %eax,%edx
c0106042:	89 d0                	mov    %edx,%eax
c0106044:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106047:	eb 16                	jmp    c010605f <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0106049:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010604d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106050:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106054:	89 04 24             	mov    %eax,(%esp)
c0106057:	8b 45 08             	mov    0x8(%ebp),%eax
c010605a:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c010605c:	ff 4d e8             	decl   -0x18(%ebp)
c010605f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106063:	7f e4                	jg     c0106049 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106065:	eb 37                	jmp    c010609e <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0106067:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010606b:	74 1f                	je     c010608c <vprintfmt+0x20d>
c010606d:	83 fb 1f             	cmp    $0x1f,%ebx
c0106070:	7e 05                	jle    c0106077 <vprintfmt+0x1f8>
c0106072:	83 fb 7e             	cmp    $0x7e,%ebx
c0106075:	7e 15                	jle    c010608c <vprintfmt+0x20d>
                    putch('?', putdat);
c0106077:	8b 45 0c             	mov    0xc(%ebp),%eax
c010607a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010607e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0106085:	8b 45 08             	mov    0x8(%ebp),%eax
c0106088:	ff d0                	call   *%eax
c010608a:	eb 0f                	jmp    c010609b <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c010608c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010608f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106093:	89 1c 24             	mov    %ebx,(%esp)
c0106096:	8b 45 08             	mov    0x8(%ebp),%eax
c0106099:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010609b:	ff 4d e8             	decl   -0x18(%ebp)
c010609e:	89 f0                	mov    %esi,%eax
c01060a0:	8d 70 01             	lea    0x1(%eax),%esi
c01060a3:	0f b6 00             	movzbl (%eax),%eax
c01060a6:	0f be d8             	movsbl %al,%ebx
c01060a9:	85 db                	test   %ebx,%ebx
c01060ab:	74 27                	je     c01060d4 <vprintfmt+0x255>
c01060ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01060b1:	78 b4                	js     c0106067 <vprintfmt+0x1e8>
c01060b3:	ff 4d e4             	decl   -0x1c(%ebp)
c01060b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01060ba:	79 ab                	jns    c0106067 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c01060bc:	eb 16                	jmp    c01060d4 <vprintfmt+0x255>
                putch(' ', putdat);
c01060be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01060cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01060cf:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c01060d1:	ff 4d e8             	decl   -0x18(%ebp)
c01060d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01060d8:	7f e4                	jg     c01060be <vprintfmt+0x23f>
            }
            break;
c01060da:	e9 6c 01 00 00       	jmp    c010624b <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01060df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01060e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01060e9:	89 04 24             	mov    %eax,(%esp)
c01060ec:	e8 18 fd ff ff       	call   c0105e09 <getint>
c01060f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01060f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01060fd:	85 d2                	test   %edx,%edx
c01060ff:	79 26                	jns    c0106127 <vprintfmt+0x2a8>
                putch('-', putdat);
c0106101:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106104:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106108:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010610f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106112:	ff d0                	call   *%eax
                num = -(long long)num;
c0106114:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106117:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010611a:	f7 d8                	neg    %eax
c010611c:	83 d2 00             	adc    $0x0,%edx
c010611f:	f7 da                	neg    %edx
c0106121:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106124:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0106127:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010612e:	e9 a8 00 00 00       	jmp    c01061db <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0106133:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106136:	89 44 24 04          	mov    %eax,0x4(%esp)
c010613a:	8d 45 14             	lea    0x14(%ebp),%eax
c010613d:	89 04 24             	mov    %eax,(%esp)
c0106140:	e8 75 fc ff ff       	call   c0105dba <getuint>
c0106145:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106148:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010614b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106152:	e9 84 00 00 00       	jmp    c01061db <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106157:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010615a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010615e:	8d 45 14             	lea    0x14(%ebp),%eax
c0106161:	89 04 24             	mov    %eax,(%esp)
c0106164:	e8 51 fc ff ff       	call   c0105dba <getuint>
c0106169:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010616c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010616f:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0106176:	eb 63                	jmp    c01061db <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0106178:	8b 45 0c             	mov    0xc(%ebp),%eax
c010617b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010617f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0106186:	8b 45 08             	mov    0x8(%ebp),%eax
c0106189:	ff d0                	call   *%eax
            putch('x', putdat);
c010618b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010618e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106192:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106199:	8b 45 08             	mov    0x8(%ebp),%eax
c010619c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010619e:	8b 45 14             	mov    0x14(%ebp),%eax
c01061a1:	8d 50 04             	lea    0x4(%eax),%edx
c01061a4:	89 55 14             	mov    %edx,0x14(%ebp)
c01061a7:	8b 00                	mov    (%eax),%eax
c01061a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01061b3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01061ba:	eb 1f                	jmp    c01061db <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01061bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01061bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061c3:	8d 45 14             	lea    0x14(%ebp),%eax
c01061c6:	89 04 24             	mov    %eax,(%esp)
c01061c9:	e8 ec fb ff ff       	call   c0105dba <getuint>
c01061ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01061d4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01061db:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01061df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061e2:	89 54 24 18          	mov    %edx,0x18(%esp)
c01061e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01061e9:	89 54 24 14          	mov    %edx,0x14(%esp)
c01061ed:	89 44 24 10          	mov    %eax,0x10(%esp)
c01061f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01061f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01061fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01061ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106202:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106206:	8b 45 08             	mov    0x8(%ebp),%eax
c0106209:	89 04 24             	mov    %eax,(%esp)
c010620c:	e8 a4 fa ff ff       	call   c0105cb5 <printnum>
            break;
c0106211:	eb 38                	jmp    c010624b <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106213:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106216:	89 44 24 04          	mov    %eax,0x4(%esp)
c010621a:	89 1c 24             	mov    %ebx,(%esp)
c010621d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106220:	ff d0                	call   *%eax
            break;
c0106222:	eb 27                	jmp    c010624b <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106224:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106227:	89 44 24 04          	mov    %eax,0x4(%esp)
c010622b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0106232:	8b 45 08             	mov    0x8(%ebp),%eax
c0106235:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106237:	ff 4d 10             	decl   0x10(%ebp)
c010623a:	eb 03                	jmp    c010623f <vprintfmt+0x3c0>
c010623c:	ff 4d 10             	decl   0x10(%ebp)
c010623f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106242:	48                   	dec    %eax
c0106243:	0f b6 00             	movzbl (%eax),%eax
c0106246:	3c 25                	cmp    $0x25,%al
c0106248:	75 f2                	jne    c010623c <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c010624a:	90                   	nop
    while (1) {
c010624b:	e9 37 fc ff ff       	jmp    c0105e87 <vprintfmt+0x8>
                return;
c0106250:	90                   	nop
        }
    }
}
c0106251:	83 c4 40             	add    $0x40,%esp
c0106254:	5b                   	pop    %ebx
c0106255:	5e                   	pop    %esi
c0106256:	5d                   	pop    %ebp
c0106257:	c3                   	ret    

c0106258 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106258:	55                   	push   %ebp
c0106259:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010625b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010625e:	8b 40 08             	mov    0x8(%eax),%eax
c0106261:	8d 50 01             	lea    0x1(%eax),%edx
c0106264:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106267:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010626a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010626d:	8b 10                	mov    (%eax),%edx
c010626f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106272:	8b 40 04             	mov    0x4(%eax),%eax
c0106275:	39 c2                	cmp    %eax,%edx
c0106277:	73 12                	jae    c010628b <sprintputch+0x33>
        *b->buf ++ = ch;
c0106279:	8b 45 0c             	mov    0xc(%ebp),%eax
c010627c:	8b 00                	mov    (%eax),%eax
c010627e:	8d 48 01             	lea    0x1(%eax),%ecx
c0106281:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106284:	89 0a                	mov    %ecx,(%edx)
c0106286:	8b 55 08             	mov    0x8(%ebp),%edx
c0106289:	88 10                	mov    %dl,(%eax)
    }
}
c010628b:	90                   	nop
c010628c:	5d                   	pop    %ebp
c010628d:	c3                   	ret    

c010628e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010628e:	55                   	push   %ebp
c010628f:	89 e5                	mov    %esp,%ebp
c0106291:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106294:	8d 45 14             	lea    0x14(%ebp),%eax
c0106297:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010629a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010629d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01062a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01062a4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01062a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062af:	8b 45 08             	mov    0x8(%ebp),%eax
c01062b2:	89 04 24             	mov    %eax,(%esp)
c01062b5:	e8 08 00 00 00       	call   c01062c2 <vsnprintf>
c01062ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01062bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01062c0:	c9                   	leave  
c01062c1:	c3                   	ret    

c01062c2 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01062c2:	55                   	push   %ebp
c01062c3:	89 e5                	mov    %esp,%ebp
c01062c5:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01062c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01062cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01062ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062d1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01062d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01062d7:	01 d0                	add    %edx,%eax
c01062d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01062dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01062e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01062e7:	74 0a                	je     c01062f3 <vsnprintf+0x31>
c01062e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01062ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062ef:	39 c2                	cmp    %eax,%edx
c01062f1:	76 07                	jbe    c01062fa <vsnprintf+0x38>
        return -E_INVAL;
c01062f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01062f8:	eb 2a                	jmp    c0106324 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01062fa:	8b 45 14             	mov    0x14(%ebp),%eax
c01062fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106301:	8b 45 10             	mov    0x10(%ebp),%eax
c0106304:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106308:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010630b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010630f:	c7 04 24 58 62 10 c0 	movl   $0xc0106258,(%esp)
c0106316:	e8 64 fb ff ff       	call   c0105e7f <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010631b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010631e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106321:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106324:	c9                   	leave  
c0106325:	c3                   	ret    
