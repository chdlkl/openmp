!.. if子句：条件并行
!.. 如果if条件得到满足，就采用并行方式运行并行区域内的代码
!.. 如果if条件不能够满足，就采用串行方式来运行并行区域的代码
Program if_parallel
  use omp_lib
  implicit none
  Integer :: nthreads, tid, ncpu

  ncpu = omp_get_num_procs()  !.. 利用函数omp_get_num_procs()得到系统的处理器数目
  write(*,'(1x,a,g0)') "number of CPUs: ", ncpu
  write(*,'(1x,a)') "-------------------------"

  !.. 通过if子句来决定是否进行并行执行
  !.. 如果系统处理器数目大于1，则用并行。如果等于1，用串行
  !$omp parallel private( nthreads, tid ) if ( ncpu > 1 )
  nthreads = omp_get_num_threads()
  tid = omp_get_thread_num()
  write(*,'(1x,a,g0,a,g0)') "number of threads: ", nthreads, "  id = ", tid
  !$omp end parallel

End program if_parallel
