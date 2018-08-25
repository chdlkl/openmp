Program set_num_threads
  use omp_lib
  implicit none
  
  Integer :: nthreads_set, nthreads, tid

  !$omp parallel private( nthreads, tid )
  nthreads = omp_get_num_threads()
  tid = omp_get_thread_num()
  write(*,'(1x,a,g0)') "number of threads(default) = ", nthreads
  write(*,'(1x,a,g0)') "id = ", tid
  !$omp end parallel

  write(*,'(1x,a)') "------------------------------------------"
  write(*,'(1x,a)') "before omp_set_num_threas !"
  write(*,*)

  nthreads_set = 3
  call omp_set_num_threads( nthreads_set ) !.. 设置可用线程数
  write(*,'(1x,a,g0)') "set_number_threads = ", nthreads_set

  !$omp parallel private( nthreads, tid )
  nthreads = omp_get_num_threads()
  tid = omp_get_thread_num()
  write(*,'(1x,a,g0)') "number of available threads = ", nthreads
  write(*,'(1x,a,g0)') "id = ", tid
  !$omp end parallel

End program set_num_threads

!.. 总结
!.. 1. 默认模式下进行并行计算的线程数为系统中可以提供的线程数
!.. 2. 静态模式下设置的可用线程数量可以不等于系统中可提供的线程总数
!.. 3. 环境库函数omp_set_num_threads必须置于并行区域前
