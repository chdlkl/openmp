Program test_omp_in_parallel
  use omp_lib
  implicit none
  Integer :: tid, Nthreads

  Nthreads = omp_get_num_threads()  !.. 获得串行域线程数，Nthreads =1，只有主线程一个线程
  tid = omp_get_thread_num()  !.. 获得当前线程号，主线程号一般为0
  If ( omp_in_parallel() ) then
    write( *,'(1x,a,g0)' ) 'In the parallel region!, id = ', tid
    write( *,'(1x,a,g0)' ) 'number of threads:', Nthreads
  else
    write( *,'(1x,a,g0)' ) 'In the serial region!, id = ', tid
    write( *,'(1x,a,g0)' ) 'number of threads:', Nthreads
  End if
  write( *,'(1x,a)' ) '------Before parallel region------'

  !$omp parallel private( tid, Nthreads )
  Nthreads = omp_get_num_threads()  !.. 获得并行域线程数，Nthreads为默认的机器线程
  tid = omp_get_thread_num()  !.. 获得当前线程号
  If ( omp_in_parallel() ) then
    write( *,'(1x,a,g0)' ) 'In the parallel region!, id = ', tid
    write( *,'(1x,a,g0)' ) 'number of threads:', Nthreads
  else
    write( *,'(1x,a,g0)' ) 'In the serial region!, id = ', tid
    write( *,'(1x,a,g0)' ) 'number of threads:', Nthreads
  End if
  !$omp end parallel
  write( *,'(1x,a)' ) '------After parallel region------'
  
  Nthreads = omp_get_num_threads()  !.. 获得串行域线程数，Nthreads =1，只有主线程一个线程
  tid = omp_get_thread_num()  !.. 获得当前线程号，主线程号一般为0
  If ( omp_in_parallel() ) then
    write( *,'(1x,a,g0)' ) 'In the parallel region!, id = ', tid
    write( *,'(1x,a,g0)' ) 'number of threads:', Nthreads
  else
    write( *,'(1x,a,g0)' ) 'In the serial region!, id = ', tid
    write( *,'(1x,a,g0)' ) 'number of threads:', Nthreads
  End if
  write( *,'(1x,a)' ) '------Before parallel region------'

End program test_omp_in_parallel
!.. 上述程序有如下特点
!.. 1. parallel指令对之前的代码段采用单线程串行执行，线程号为0
!.. 2. 子线程的执行次序是随机的
!.. 3. parallel指令对之后的代码段采用单线程穿行执行，线程号为0
!.. 4. 采用omp_get_num_threads函数获得程序执行过程中(串行域为1，并行域如是默认，则线程数为机器总线程数)
!.. 5. 采用omp_get_thread_num函数获得目前正在执行的子线程的线程号
!.. 6. 采用omp_in_parallel函数来检测正在执行的代码是在串行域还是在并行域

!.. 线程数为默认模式的优缺点
!.. 优点
!.. 1. 扩展性好，能充分利用机器的性能

!.. 缺点
!.. 1. 如果并行的执行结果依赖于线程的数量和线程号，那么默认模式就会给出错误的结果
!.. 2. 如果多用户同时使用服务器，采用默认模式就会抢占资源，影响其他用户
!.. 3. 如果计算负载小，线程过多有时会造成实际计算时间的延长。所以并不是线程数越多越好，需要根据自己的计算量适量选择线程数

