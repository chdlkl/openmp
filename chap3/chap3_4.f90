Module mod1
  implicit none
  integer :: x
End module mod1

Program test_copyin_and_copyprivate
  use mod1
  use omp_lib
  implicit none
  integer :: tid, a

  !$omp threadprivate( x )
  !.. 利用threadprivate子句将全局变量x定义成私有变量,并在下面的第一个并行区域内用copyin子句对并行区域内各子线程的全局变量x的副本进行初始化
  !.. 此时,第一个并行域内各子线程的x值均等于第一个串行域内x的值(x=-2)
  call omp_set_num_threads(4) !// 设置线程数
  tid = omp_get_thread_num()  !// 获取当前线程号...主线程号为0
  
  a = -1; x = -2
  write( *,'(1x,a)' ) '1st serial region.....'
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '   id =  ', tid
  write( *,'(1x,a)' ) '......'
  write( *,'(1x,a)' )  '1st parallel region'

  !$omp parallel firstprivate( a ) private( tid ) copyin( x )
  !.. 在第一个并行区域内采用firstprivate子句将局部变量a定义为私有变量并进行初始化
  !.. 在第一个并行区域内各子线程的变量a的私有副本的初始值均等于第一个串行区域内同名原始变量的值(a=-1)
  tid = omp_get_thread_num()  !// 获取当前线程号...主线程号为0
  write( *,'(1x,a,2(i4),a,i4)' ) 'a, x =  ', a, x, '   id =  ', tid
  
  a = a + tid + 10
  x = x + tid + 100
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '  a&&x changed, id =  ', tid
  write( *,'(1x,a)' ) '......'
  !$omp end parallel
  
  !.. 退出第一个并行区域后,第二个串行区域主线程编号为0
  !.. 第一个并行区域内子线程0的全局变量x的私有副本的值即为串行区全局变量x的值
  !** 但是，在第二个串行区域内局部变量a继承的是第一个串行区域内同名变量a的值(a=-1),与第一个并行区域的a值无关
  tid = omp_get_thread_num()  !// 获取当前线程号...主线程号为0
  write( *,'(1x,a)' ) '2nd serial region.....'
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '   id =  ', tid
  write( *,'(1x,a)' ) '......'
  
  a = a + tid + 10
  x = x + tid + 100
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '  a&&x changed, id =  ', tid
  write( *,'(1x,a)' )  '2nd parallel region'

  !$omp parallel firstprivate( a ) private( tid )
  !.. 第二个并行域内，用firstprivate将局部变量a定义成私有变量并进行初始化，等于第二个串行域内同名变量a的值
  !.. 由于在第二个并行域内未用copyin子句对全局变量x进行初始化,所以各子线程x的私有副本等于第一个并行域内相应子线程的值
  tid = omp_get_thread_num()
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) '2nd parallel: a, x =  ', a, x, '   id =  ', tid
  !$omp single
  !.. 在single指令中,只有一个子线程去执行这部分代码，且这个子线程是随机确定的
  write( *,'(1x,a)' ) '......'
  write( *,'(1x,a)' ) '2nd parallel region single block'
  
  tid = omp_get_thread_num()  !// 获取当前线程号...主线程号为0
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '   id =  ', tid
  
  a = a + tid + 10
  x = x + tid + 100
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '  a&&x changed, id =  ', tid
  write( *,'(1x,a)' ) '......'
  !$omp end single copyprivate( x, a )
  !.. 在single块结束后，通过copyprivate子句将执行single的子线程拥有的局部变量a的值以及全局变量x的值广播给其他子线程
  write( *,'(1x,a)' ) '2nd parallel region after single '
  tid = omp_get_thread_num()
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, '   id =  ', tid
  !$omp end parallel

  write( *,'(1x,a)' ) '......'
  write( *,'(1x,a)' ) '3rd serial region.....'
  write( *,'(1x,a,i4,2x,i4,a,i4)' ) 'a, x =  ', a, x, ' id =  ', tid
 
End program test_copyin_and_copyprivate
