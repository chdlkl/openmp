!.. 单重循环：下面的例子不存在循环依赖
!.. 采用do指令来实现数组相加运算的并行
Program do_array_plus
  use omp_lib
  implicit none
  integer, parameter :: m = 10
  integer :: nthreads, tid, i
  integer :: a(m), b(m), c(m)

  call omp_set_num_threads(3)
  Do i = 1, m
    a(i) = 10 * i
    b(i) = i 
    tid      = omp_get_thread_num()
    nthreads = omp_get_num_threads()
    write(*,'(1x,a,*(g0,3x))') "nthreads, tid, i, a(i) = ", nthreads, tid, i, a(i)
  End do
  write(*,'(1x,a)') "before paralled......"
  write(*,*) "--------------------------------------------------"

  !$omp parallel private(i, tid, nthreads) default( shared )
  !$omp do
  Do i = 1, m
    tid      = omp_get_thread_num()
    nthreads = omp_get_num_threads()
    c(i) = a(i) + b(i)
    write(*,'(1x,a,*(g0,3x))') "nthreads, tid, i, c(i) = ", nthreads, tid, i, c(i)
  End do
  !$omp end do
  !$omp end parallel
  write(*,*) "--------------------------------------------------"
  write(*,'(1x,a)') "after paralled......"
  
  tid      = omp_get_thread_num()
  nthreads = omp_get_num_threads()
  write(*,'(1x,a,*(g0,3x))') "nthreads, tid = ", nthreads, tid

End program do_array_plus

!.. 总结
!.. 1. 对数组a和b的赋值循环中，由于未使用!$omp do指令，因此赋值的循环全部由主线程0执行，没有并行
!.. 2. 如果实现将一个do循环的工作量(例如：i = 1,10)分配给不同线程，那么do循环必须位于并行区域中且在do循环体前增加!$omp do指令。
!.. 3. 在对循环执行并行时，循环下标i被定义为私有变量；数组a,b,c被定为共享变量。如果对i不加以说明，默认为私有变量
!.. 4. 在遇到!$omp end do语句后，循环并行结束，程序重新由主线程0串行执行。
