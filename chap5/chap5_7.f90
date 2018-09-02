!.. workshare指令
!.. 1. workshare结构中的代码只能包括如下语句：数组赋值语句、标量赋值语句
!..    forall/where语句和结构、atomic结构、critical结构和parallel结构
!..    其中，数组赋值语句允许使用算术操作符，包括+,-,*,/和**
!.. 2. workshare指令指出代码块中的每条语句均为计算的共享单元
!..    即可被分为若干独立的工作单元来执行，并使一组线程并行执行这些工作单元
!.. 3. 由于workshare指令在大多数情况下与一个独立的parallel指令一起使用
!..    因此，openmp提供了一个指令!$parallel workshare来方便编程人员编程
Program workshare
  use omp_lib
  implicit none
  integer, parameter :: l = 80, m = 80, n= 80
  integer :: i, j, k
  integer, dimension(l,m,n) :: a, b, c, d
  real(kind=8) :: starttime, endtime, time 

  call omp_set_num_threads(4)
  Do k = 1, n
    do j = 1, m
      Do i = 1, l
        a(i,j,k) = i
        b(i,j,k) = j
      End do
    end do
  End do

  starttime = omp_get_wtime()
  !$omp parallel private(k) shared(i,j,a,b,c,d)
  !$omp do
  Do k = 1, n
    do j = 1, m
      Do i = 1, l
        c(i,j,k) = a(i,j,k) * b(i,j,k) + a(i,j,k)
        d(i,j,k) = a(i,j,k) ** 2 - b(i,j,k) ** 2
      End do
    end do
  End do
  !$omp end do
  !$omp end parallel

  endtime = omp_get_wtime()
  time = (endtime - starttime) * 1000.
  write(*,'(1x,a)') "parallel do......"
  write(*,'(1x,a,g0,a)') "static schedule time: ", time, " ms"
  
  write(*,'(1x,a,*(g0,3x))') "a(l,m,n), b(l,m,n) = ", a(l,m,n), b(l,m,n)
  write(*,'(1x,a,*(g0,3x))') "c(l,m,n), d(l,m,n) = ", c(l,m,n), d(l,m,n)
  write(*,'(1x,a)') "----------------------------------------------"

  starttime = omp_get_wtime()
  !$omp parallel shared(a,b,c,d)
  !$omp workshare
  c = a*b + a
  d = a**2 + b**2
  !$omp end workshare nowait
  !$omp end parallel
  
  endtime = omp_get_wtime()
  time = (endtime - starttime) * 1000.
  write(*,'(1x,a)') "parallel workshare......"
  write(*,'(1x,a,g0,a)') "workshare time: ", time, " ms"

  write(*,'(1x,a,*(g0,3x))') "a(l,m,n), b(l,m,n) = ", a(l,m,n), b(l,m,n)
  write(*,'(1x,a,*(g0,3x))') "c(l,m,n), d(l,m,n) = ", c(l,m,n), d(l,m,n)

End program workshare

!.. 小结
!.. 1. 采用!$omp parallel workshare并行的代码块可以采用!$omp parallel do来实现
!..    但是!$omp parallel workshare并行的书写格式相对简单，而且消耗时间比较少
!..    但是，在某些情况下，!$omp parallel workshare对数组的操作消耗时间比!$omp parallel do要大
!..    这主要取决于数组的大小、维度以及系统资源情况。
!.. 2. !$omp parallel do方式需要写出数组的具体表达式，书写比较繁琐
!..    正因为这样，它可以实现较为复杂的计算，比如向量的点积与叉积
