Program test_firstprivate_and_lastprivate
  use omp_lib
  implicit none
  integer, parameter :: m = 4
  integer :: tid, i, j
  integer :: a(m), b(m)

  call omp_set_num_threads(10)

  a = -10; b = -10
  tid = omp_get_thread_num()
  write( *,'(1x,a)' ) 'before parallel......'
  write( *,'(1x,a,4(g0,2x),a,g0)' ) 'a = ', (a(i), i = 1, m), 'id = ', tid
  write( *,'(1x,a,4(g0,2x))' ) 'b = ', (b(i), i = 1, m)
  print*
  
  !.. firstprivate: 将变量定义为私有变量。在进入并行区域时，此子句会将每个线程的私有变量的副本的值初始化为进入并行域前串行域同名原始变量的值
  !.. lastprivate: 在并行域内，当完成对子线程私有变量的计算后，可用lastprivate将变量的值传递给并行域外的同名变量、
  
  !.. openmp的规范指出: 如果是do循环，则在退出并行域会执行最后一次迭代的子线程的私有变量的值带出并行域，给并行域外的同名变量
  !.. 如果是section指令，则将执行最后一次的section子句的子线程的私有变量的值给并行域外的同名变量
  !** 需要指出的是，do循环的最后一次迭代和最后一个section子句是指程序语法的最后一个，不是执行线程的最后一个
  !$omp parallel do private( tid, i, j ) firstprivate( a, b ) lastprivate( b )
  Do i = 1, m  !.. 一般有几次循环，需要几个线程(当循环次数小于设置线程数的或是设备的总线程数)
    tid = omp_get_thread_num()
    write( *,'(1x,a,4(g0,2x),a,g0)' ) 'a = ', (a(j), j = 1, m), 'id = ', tid
    write( *,'(1x,a,4(g0,2x))' ) 'b = ', (b(j), j = 1, m)
    
    a(i) = tid + i * 10
    b(i) = tid + i * 10

    write( *,'(1x,a,4(g0,2x),a,g0)' ) 'a = ', (a(j), j = 1, m), 'id = ', tid
    write( *,'(1x,a,4(g0,2x),a,g0)' ) 'b = ', (b(j), j = 1, m), 'i = ', i
    print*

  end do
  !$omp end parallel do 

  tid = omp_get_thread_num()
  write( *,'(1x,a)' ) 'after parallel......'
  write( *,'(1x,a,4(g0,2x),a,g0)' ) 'a = ', (a(i), i = 1, m), 'id = ', tid
  write( *,'(1x,a,4(g0,2x))' ) 'b = ', (b(i), i = 1, m)

end program
