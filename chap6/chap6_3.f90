!.. master指令
!.. master指令的语法格式如下:
!.. !$omp master
!..     code
!.. !$omp end master

!.. master指令要求主线程去执行并行区域内的部分程序代码
!.. 而其他的线程则越过程序代码直接向下执行

!.. 使用master应注意以下几项：
!.. 1. master与single指令类似，但master没有隐含的栅障，也不能使用nowait
!..    single指令具有隐含的栅障。
!..    当主线程去执行master结构，其他线程可以往下执行master后面的语句不必等主线程
!..    single指令可以采用任意一个线程去执行single内部的结构，其他线程则需要在隐含的栅障处等待同步
!.. 2. master结构内部不允许出现到达master结构之外的跳转语句，也不允许有外部的跳转语句到达master结构内部
Program master_parallel
  use omp_lib
  implicit none 
  integer :: tid, nthreads  

  call omp_set_num_threads(3)

  !$omp parallel private( tid, nthreads )
  nthreads = omp_get_num_threads()
  tid      = omp_get_thread_num()
  write( *,'(1x,a,g0,3x,g0)' ) "before master: nthreads, id = ", nthreads, tid
  
  !$omp master
  nthreads = omp_get_num_threads()
  tid      = omp_get_thread_num()
  write( *,'(1x,a,g0,3x,g0)' ) "master region: nthreads, id = ", nthreads, tid
  !$omp end master
  
  nthreads = omp_get_num_threads()
  tid      = omp_get_thread_num()
  write( *,'(1x,a,g0,3x,g0)' ) "after master:nthreads, id = ", nthreads, tid
  !$omp end parallel 
End program master_parallel

!.. 总结
!.. 1. 主线程0执行了1次master结构，而其他线程只执行了并行区域内除master结构外的语句
!.. 2. 关于"after master..."的输出混杂在"before master..."和"master region..."这些输出中间，表明线程1和线程2在主线程0执行master结构时没有进行同步，而是继续执行后续的代码
