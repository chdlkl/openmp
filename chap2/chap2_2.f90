Program hi_parallel
  use omp_lib
  implicit none
  integer :: tid, mcpu

  !call omp_set_num_threads(8) !.. 设置线程数
  
  tid = omp_get_thread_num()  !.. 获取当前线程号...主线程号为0
  mcpu = omp_get_num_threads()  !.. 获取程序执行时的cpu(线程)数。由于此时没有进入并行域，所以mcpu=1
  write( *,'(1x,a)' ) 'before paralled......'
  write( *,'(1x,a,i2,a,i2,a)' ) 'hi from thread ', tid, ' in ', mcpu, 'CPUs!'

  write( *,'(1x,a)' ) 'during paralled......'
  !$omp parallel default(none) private( tid, mcpu )
  !.. 由于用来表示每个线程的线程号与cpu的个数的变量相同，所以用private子句将tid,mcpu声明为每个线程的私有变量
  tid = omp_get_thread_num()  
  mcpu = omp_get_num_threads()  
  write( *,'(1x,a,i2,a,i2,a)' ) 'hi from thread ', tid, ' in ', mcpu, 'CPUs!'
  !$omp end parallel
 
  write( *,'(1x,a)' ) 'after paralled......'
  write( *,'(1x,a,i2,a,i2,a)' ) 'hi from thread ', tid, ' in ', mcpu, 'CPUs!'
  
End program hi_parallel
