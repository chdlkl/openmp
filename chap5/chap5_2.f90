Program double_do_array_plus_j
  use omp_lib
  implicit none
  integer, parameter :: m = 3, n = 3
  integer :: nthreads, tid, i, j
  integer :: a(m,n), b(m,n), c(m,n)

  call omp_set_num_threads(3)
  write(*,'(1x,a)') "nthreads   tid      i       j    a(i,j)  b(i,j)  c(i,j)"

  !$omp parallel do private(i, j, tid, nthreads) default( shared )
  Do j = 1, n
    do i = 1, m
      a(i,j)   = i + j
      b(i,j)   = (i+j) * 10
      c(i,j)   = a(i,j) + b(i,j) 
      tid      = omp_get_thread_num()
      nthreads = omp_get_num_threads()
      write(*,'(i6,6(i8))') nthreads, tid, i, j, a(i,j), b(i,j), c(i,j)
    end do
  write(*,'(1x,a)') "-------------------------"
  End do
  !$omp end parallel do
End program double_do_array_plus

!.. 总结
!.. 1. 指令!$omp parallel do是指令!$omp parallel和指令!$omp do的缩写
!.. 2. 指令!$omp end parallel do是指令!$omp end parallel和指令!$omp end do的缩写
!.. 3. 程序设置了并行线程数量为3，并且两个循环标量i,j均被定义为私有变量
!.. 4. 由于!$omp parallel do位于外循环的上部。所以对只对外部循环进行并行处理
