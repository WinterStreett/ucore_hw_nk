# ucore_hw_nk
本仓库作为os课程实验作业的远程仓库，随着课程不断更新


笔记：
控制流：kern_inti --> proc_init --> 创建idleproc，0号线程 --
> kernel_thread创建initproc线程 -->kernel_thread_entry -->main

lab1：kern/debug/kdebug.c
      trap/trap.c

lab2: mm/pmm.c
      mm/default_pmm.c


lab3: mm/vmm.c
      mm/swap_fifo.c

lab4: process/proc.c