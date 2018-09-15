!.. critical指令
!.. critical语法
!.. !$omp critical
!..   code
!.. $omp end critical
!.. 使用critical的注意事项：
!.. 1. 在同一时间内，只允许一个线程执行critical结构，其他线程必须排队依次执行critical结构
!.. 2. critical指令不允许相互嵌套
!.. 3. critical结构不允许跳转。即跳转出critical或跳转入critical结构
Program critical_max
  use omp_lib
  implicit none 
  integer, parameter :: m = 10
  integer :: i, pmax, px
  integer :: tid, nthreads
  integer :: p(m)

  call omp_set_num_threads(3)
  do i = 1, m
    p(i) = i 
  end do 

  px = 0
  !$omp parallel private( pmax, i, tid, nthreads ) shared( p, px )
  pmax = 0
  !$omp do 
  do i = 1, m
    pmax = max( pmax,p(i) )
  end do
  !$omp end do nowait

  !$omp critical
  nthreads = omp_get_num_threads()
  tid      = omp_get_thread_num()
  write( *,'(1x,a,g0,3x,g0)' ) "number of threads, id = ", nthreads, tid
  write( *,'(1x,a,g0,3x,g0)' ) "pmax, px = ", pmax, px
  px = max( px, pmax )
  !$omp end critical

  !$omp end parallel
  write( *,'(1x,a,g0)' ) "max(p) = ", px

End program critical_max

!.. 总结
!.. 1. 进入并行区域时，3个子线程各自拥有变量pmax的副本
!.. 2. px时共享变量，如果3个子线程拥有的变量pmax的副本同时与px比较后将最大值写入
!..    就会出现数据竞争现象。
!..    因此，建立一个临界块，使每个线程排队执行临界块，从而实现各线程逐个与px求最大值后将结果写入共享变量px
