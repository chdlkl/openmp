Program double_do_array_plus_i
  use omp_lib
  implicit none
  integer, parameter :: m = 3, n = 3
  integer :: nthreads, tid, i, j
  integer :: a(m,n), b(m,n), c(m,n)

  call omp_set_num_threads(3)
  write(*,'(1x,a)') "nthreads   tid      i       j    a(i,j)  b(i,j)  c(i,j)"

  Do j = 1, n
  !$omp parallel do private(i, tid, nthreads) default( shared ) 
    do i = 1, m
      a(i,j)   = i + j
      b(i,j)   = (i+j) * 10
      c(i,j)   = a(i,j) + b(i,j) 
      tid      = omp_get_thread_num()
      nthreads = omp_get_num_threads()
      write(*,'(i6,6(i8))') nthreads, tid, i, j, a(i,j), b(i,j), c(i,j)
    end do
  !$omp end parallel do
  write(*,'(1x,a)') "-------------------------"
  End do
End program double_do_array_plus_i

!.. 总结
!.. 1. 由于程序对内循环i设置了并行线程数量为3，所以内循环下标i被分割为3部分。
!.. 2. 主线程0负责i=1; 子线程1负责i=2; 子线程2负责i=3
!.. 3. 内循环区域是并行区域。对于外循环下标j的每次取值，此并行区域执行一次。
!.. 4. 在本例中，j的取值为1-3，并行区域也被创建和并行执行了3次，这样的程序并行效率低
!.. 5. 为了对循环进行并行化，需要仔细检查程序，保证并行化的线程之间不出现数据竞争.
!.. 6. 如果出现数据竞争，可以通过增加适当的同步操作，或者通过程序改写来消除这种数据竞争。
