!.. parallel do指令静态调度用法
Program do_schedule_static
  use omp_lib
  implicit none
  integer, parameter :: m = 12
  integer :: nthreads, tid, i

  call omp_set_num_threads(3)
  !$omp parallel do private(i,tid,nthreads) schedule(static)
  do i = 1, m
    tid      = omp_get_thread_num()
    nthreads = omp_get_num_threads()
    write(*,'(1x,a,*(g0,3x))') "nthreads, id, i = ", nthreads, tid, i
  end do
  !$omp end parallel do
  
  write(*,'(1x,a)') "----------------------------"
  
  !$omp parallel do private(i,tid,nthreads) schedule(static,3)
  do i = 1, m
    tid      = omp_get_thread_num()
    nthreads = omp_get_num_threads()
    write(*,'(1x,a,*(g0,3x))') "nthreads, id, i = ", nthreads, tid, i
  end do
  !$omp end parallel do

End program do_schedule_static

!.. 总结
!.. 1. 采用不带size参数的静态分配时，每个线程负责一段连续的循环
!.. 2. 采用带size=3的参数时，每次分配给线程3个连续的循环
