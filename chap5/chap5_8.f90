!.. single指令
!.. 1. 一个single结构只能由一个线程来执行，但并不一定是主线程。
!..    不执行single指令的其他线程则会在single结构结束处同步
!..    但如果存在nowait指令，则不执行single指令的其他线程可以直接越过single继续向下执行
!.. 2. single结构内部不允许出现能够到达single结构之外的跳转语句，也不允许有外部的跳转语句到达single结构内部
Program single_private_copyprivate
  use omp_lib
  integer :: tid, nthreads
  integer :: a

  call omp_set_num_threads(3)
  !$omp parallel private(a,tid)
  tid = omp_get_thread_num()
  a = tid 
  write(*,'(1x,a,g0,a,g0,a)') "a = ", a, " id = ", tid, " before single"
  !$omp single
  write(*,'(1x,a)') "--------------------------------"
  nthreads = omp_get_num_threads()
  tid      = omp_get_thread_num()
  a        = a + 2**tid + 10
  write(*,'(1x,a,2(g0))') "single: nthreads = ", nthreads
  write(*,'(1x,a,g0,a,g0,a)') "a = ", a, " id = ", tid, " during single"
  write(*,'(1x,a)') "--------------------------------"
  !$omp end single copyprivate(a)
  tid = omp_get_thread_num()
  write(*,'(1x,a,g0,a,g0,a)') "a = ", a, " id = ", tid, " after single"
  !$omp end parallel

End program single_private_copyprivate

!.. 小结
!.. 1. single语句的作用范围在!$omp single与!$omp end single之间。
!..    所有关于"after single"的输出均在"before single"和"during single"输出之后
!..    表明线程1和2在子线程0执行single结构时处于空闲状态；
!..    所有线程只有在single指令结束处同步后才能执行后续代码
!.. 2. 线程0(也可以是其他线程)执行了一次single结构，而其他线程执行并行区域single结构以外的语句
!.. 3. 对于个线程的私有变量a，利用single语句改变某个子线程的a的私有副本，再通过copyprivate指令将此子线程的a广播给其他线程
