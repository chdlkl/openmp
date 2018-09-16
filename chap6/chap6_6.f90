!.. ordered指令
!.. ordered指令要求循环区域内的代码必须按照循环迭代的次序来执行
!.. 这是因为在执行循环的过程中，部分工作是可以并行执行的
!.. 然而特定部分工作需要等待前面的工作全部完成以后才能够正确执行

!.. 语法格式如下：
!.. !$omp do ordered
!.. do loop
!..   !$omp ordered
!..   code
!..   !$omp end ordered
!.  end do loop

!.. ordered指令在使用过程中需要满足如下条件：
!.. 1. ordered指令一般与do指令或parallel do指令联合起来使用
!..    并且ordered指令需要与end ordered子句结合起来使用
!.. 2. 在任意时刻，只允许一个线程执行ordered结构
!.. 3. 在ordered结构内部不允许出现能够到达ordered外部的跳转语句
!..    也不允许外部语句跳转至ordered结构内部
!.. 4. 一个do循环内部只能出现一次ordered指令
Program ordered_do
  use omp_lib
  integer, parameter :: m = 10
  integer :: a(m)
  integer :: i, tid, nthreads

  call omp_set_num_threads(3)

  write( *,'(1x,a)' ) "nthreads   id   i   a(i)"

  !$omp parallel private( i, tid, nthreads ) shared(a)
  !$omp do 
  do i = 1, m
    nthreads = omp_get_num_threads()
    tid      = omp_get_thread_num()
    a(i)      = i 
    write( *,'(4(i6))' ) nthreads, tid, i, a(i)
  end do
  !$omp end do

  write(*,'(1x,a)') "------------------------------------"
  
  !$omp do ordered
  do i = 2, m
    !$omp ordered
    nthreads = omp_get_num_threads()
    tid = omp_get_thread_num()
    a(i) = a(i-1) - 1
    write( *,'(4(i6))' ) nthreads, tid, i, a(i)
    !$omp end ordered
  end do
  !$omp end do
  !$omp end parallel

End program ordered_do

!.. 总结
!.. 1. 代码a(i) = a(i-1) - 1需要按照循环迭代依次执行，否则会出现数据竞争，因此需要ordered结构
!..    这样，各线程在执行这一段代码时严格遵照循环迭代次序进行
!.. 2. 同一循环内只能使用一个ordered指令。换言之，在同一个循环内不能多次使用ordered指令
