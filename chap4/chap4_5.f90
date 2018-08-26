Program if_parallel_print
  use omp_lib
  implicit none

  call printnumthreads(2)
  write(*,'(1x,a)') "------------------------"
  call printnumthreads(20)
End program if_parallel_print

Subroutine printnumthreads( n )
  use omp_lib
  implicit none
  
  Integer :: n, nthreads, tid
  
  !$omp parallel private( nthreads ) if ( n > 10 ) num_threads(4)
  nthreads = omp_get_num_threads()
  write(*,'(1x,a,g0,3x,g0)') "number of threads, n = ", nthreads, n
  tid = omp_get_thread_num()
  write(*,'(1x,a,g0)') "tid = ", tid
  !$omp end parallel
End subroutine printnumthreads

!.. 总结
!.. 1. if( n > 10 )num_threads(4)的含义是：如果条件(n>10)成立，则执行num_threads(4)
!..    即用四个线程执行并行域的代码
!.. 2. 通过if子句中的条件来判断是否进行并行执行
!..    如果工程负载小，则单线程方式串行执行所需要的时间少
!..    如果工程负载大，则多线程方式并行执行所需要的时间少
