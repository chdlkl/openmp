Module mod1
  implicit none
  integer :: x
End module mod1

Program test_threadprivate
  use mod1
  use omp_lib
  implicit none
  integer :: tid, a

  !$omp threadprivate( x )
  !.. threadprivate子句将全局变量指定为私有变量后，此变量可以在前后多个并行域之间保持连续性
  !.. 而且在退出并行域之后，子线程0的全局变量的值将会继承于后面串行域的同名变量
  !** 值得注意的是: 并行域内，子线程0的全局变量的副本继承了并行区域外同名原始变量的值，而其他子线程的全局变量的副本则与并行域外同名变量无关
  call omp_set_num_threads(4) !// 设置线程数
  tid = omp_get_thread_num()  !// 获取当前线程号...主线程号为0
  
  a = -1; x = -2
  write( *,'(1x,a)' ) '1st serial region.....'
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '   id =  ', tid
  write( *,'(1x,a)' ) '......'
  write( *,'(1x,a)' )  '1st parallel region'

  !$omp parallel default(none) private( tid, a )
  tid = omp_get_thread_num()  !// 获取当前线程号...主线程号为0
  write( *,'(1x,a,2(i4),a,i4)' ) 'a, x =  ', a, x, '   id =  ', tid
  
  a = a + tid + 10
  x = x + tid + 100
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '  a&&x changed, id =  ', tid
  write( *,'(1x,a)' ) '......'
  !$omp end parallel
 
  tid = omp_get_thread_num()  !// 获取当前线程号...主线程号为0
  write( *,'(1x,a)' ) '2nd serial region.....'
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '   id =  ', tid
  write( *,'(1x,a)' ) '......'
  
  a = a + tid + 10
  x = x + tid + 100
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '  a&&x changed, id =  ', tid
  write( *,'(1x,a)' )  '2nd parallel region'

  !$omp parallel private( tid )
  tid = omp_get_thread_num()  !// 获取当前线程号...主线程号为0
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '   id =  ', tid
  
  a = a + tid + 10
  x = x + tid + 100
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '  a&&x changed, id =  ', tid
  write( *,'(1x,a)' ) '......'
  !$omp end parallel

  write( *,'(1x,a)' ) '......'
  write( *,'(1x,a)' ) '3rd serial region.....'
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, ' id =  ', tid
 
End program test_threadprivate
