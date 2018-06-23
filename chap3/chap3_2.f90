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
