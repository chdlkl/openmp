Program test_reduction
  use omp_lib
  implicit none
  integer, parameter :: m = 5
  integer :: i, tid
  integer :: a(m), b(m)
  integer :: s, pdt, abmax

  call omp_set_num_threads(3)
  
  Do i = 1, m  
    a(i) = i
    b(i) = 100 * i
  End do
  write( *,'(1x,a,5(1x,i4))' ) 'a = ', ( a(i), i = 1, m )
  write( *,'(1x,a,5(1x,i4))' ) 'b = ', ( b(i), i = 1, m )
  write( *,'(1x,a)' ) '---------------------'

  s = 0
  !** 在一个循环中使用到了reduction子句,不建议与nowait子句同时使用
  !.. 出现在reduction子句变量列表中的变量被定义为私有变量，因此不能再出现在private子句变量列表中，避免重复定义
  !.. 在并行区域开始的地方,将reduction子句中的变量s定义成私有变量,这样各子线程均建立了自己的私有变量，且它们的初始值均为1
  !$omp parallel do private( i, tid ) shared( a, b ) reduction( +:s )  
  !.. 对数组a,b只进行读操作，因此将其定义为shared属性
  Do i = 1, m
    tid = omp_get_thread_num()
    s = s + a(i) + b(i)
    write( *,'(1x,a,i4,i4,a,i4)' ) 'i, s =  ', i, s, ' id = ', tid
  End do
  !$omp end parallel do
  !.. 在do循环结束处，将个线程的私有变量s的副本通过制定的运算符进行运算,从而得到各子线程的私有变量s的副本的和
  write( *,'(1x,a,g0)' ) 's = ', s
  write( *,'(1x,a)' ) '---------------------'
  
  pdt = 1
  !$omp parallel do private( i, tid ) shared( a ) reduction( *:pdt )
  Do i = 1, m
    tid = omp_get_thread_num()
    pdt = pdt * a(i)
    write( *,'(1x,a,i4,i4,a,i4)' ) 'i, pdt =  ', i, pdt, ' id = ', tid
  End do
  !$omp end parallel do
  
  write( *,'(1x,a,g0)' ) 'pdt = ', pdt
  write( *,'(1x,a)' ) '---------------------'
    
  abmax = -100000
  !$omp parallel do private( i, tid ) shared( a, b ) reduction( max:abmax )
  Do i = 1, m
    tid = omp_get_thread_num()
    abmax = max( abmax, a(i), b(i) )
    write( *,'(1x,a,i4,i4,a,i4)' ) 'i, abmax =  ', i, abmax, ' id = ', tid
  End do
  !$omp end parallel do
  write( *,'(1x,a,g0)' ) 'abmax = ', abmax

End program test_reduction
  

