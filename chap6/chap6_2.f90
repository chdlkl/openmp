!.. nowait指令
Program nowait_do
  use omp_lib
  implicit none 
  integer, parameter :: m = 4
  integer :: tid, nthreads, i

  call omp_set_num_threads(3)
  !$omp parallel private(tid, nthreads, i)
  !$omp do
  Do i = 1, m
    tid      = omp_get_thread_num()
    nthreads = omp_get_num_threads()
    write( *,'(1x,a,*(g0,3x))' ) "first do loop:nthreads, id = ", nthreads, tid
  End do
  !$omp end do

  !$omp do
  Do i = 1, m
    tid      = omp_get_thread_num()
    nthreads = omp_get_num_threads()
    write( *,'(1x,a,*(g0,3x))' ) "second do loop:nthreads, id = ", nthreads, tid
  End do
  !$omp end do nowait

  !$omp do
  Do i = 1, m
    tid      = omp_get_thread_num()
    nthreads = omp_get_num_threads()
    write( *,'(1x,a,*(g0,3x))' ) "third do loop:nthreads, id = ", nthreads, tid
  End do
  !$omp end do

  !$omp end parallel

End program nowait_do

!.. 总结
!.. 1. 由于在第一个循环没有使用nowait，所以在第二个do循环必须等到第一个循环执行完毕才能开始执行
!..    所有关于'first do loop...'的输出打印完毕后，才开始打印关于'second do loop...'的输出
!.. 2. 当第二个循环使用nowait后，第三个do循环并没有等第二个循环执行完毕就开始执行了
!..    换言之，nowait可以将do指令后隐含的栅障去掉。所以'second do loop...'的输出混杂于'third do loop...'的输出中间
