!.. atomic指令
!.. atomic指令要求一个特定的内存地址必须自动更新，而不让其他的线程对此内存地址进行写操作
!.. atomic操作实际上是一个'微型'的critical指令。
!.. atomic指令在语法上可以认为等价于critical和end critical
!.. critical指令对一个代码块有效，而atomic指令只对一个表达式语句有效
!.. openmp利用atomic结构指令主要用于防止多线程对内存的同一地址的并发写
!.. atomic的指令语法格式如下：
!.. !$omp atomic
!..   expression code

!.. atomic操作与critical操作相比有如下特点：
!.. 1. critical操作可以完成多有的atomic操作
!.. 2. 与critical操作相比，atomic操作可以更好地被编译优化，开销小，执行快
!.. 3. critical操作可以作用在任意的代码块上，且critical指令最终被翻译为加锁和解锁操作
!..    而使用atomic指令的前提是相应的语句块能够转化为一条机器指令，使处理器能够一次执行完毕而不会被打断
!.. 4. 能使用atomic指令就不适用critical指令
!.. 5. 当对一个数据进行atomic操作保护时，就不能对数据进行critical保护。
!..    这是因为两者有完全不同的保护机制，openmp在运行过程中不能对两种保护机制之间建立配合机制
Program atomic_max_sum
  use omp_lib
  implicit none 
  integer, parameter :: m = 10
  integer :: i, xymax, sum1
  integer :: x(m), y(m)

  call omp_set_num_threads(3)
  
  xymax = -10
  sum1 = 0

  !$omp parallel private( i ) shared( x, y, xymax, sum1 )
  !$omp do
  do i = 1, m
    x(i) = i 
    y(i) = 10*i
  end do
  !$omp end do
 
  !$omp do
  do i = 1, m
    !$omp atomic
    sum1 = sum1 + x(i) + y(i)
    
    !$omp atomic
    xymax = max( xymax, x(i), y(i) )
    write( *,'(1x,a,*(g0,3x))' ) "i, x(i), y(i) = ", i, x(i), y(i)
  end do
  !$omp end do

  !$omp end parallel
  print*, "----------------------------------------------"
  write( *,'(1x,a,*(g0,3x))' ) "xymax, sum1 = ", xymax, sum1

End program atomic_max_sum

!.. 总结
!.. 1. !$omp atomic后的表达式语句只能是一个。如果存在多个表达式，则需要使用多个atomic指令
!.. 2. !$omp atomic只能单独出现，不存在相应的!$omp end atomic
