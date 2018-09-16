!.. flush指令: 此指令很少被使用
!.. flush定义了一个同步点，在该同步点处强制存储器的一致性，即确保并行执行的各线程对共享变量进行读写操作时读取的是最新值
!.. 高速缓存一致性确保了所有的处理器最终能看到单个地址空间

!.. flush的语法格式如下：
!.. !$omp flush(var list) 即列表中的变量需要更新。
!.. 如果变量列表省略，则表明对调用线程可见的所有变量进行更新
Program flush
  use omp_lib
  implicit none 
  integer, parameter :: m = 1600000
  integer :: tid, x(0:m)

  call omp_set_num_threads(2)

  x = -10
  !$omp parallel private(tid) shared(x)
  tid = omp_get_thread_num()
  write( *,'(a,3(i5))' ) "initialization: x(i), tid = ", x(0), x(m), tid
  
  !$omp barrier
  if ( tid == 1 ) then 
    x = 1
  end if

  write( *,'(a,3(i5))' ) "before flush: x(i), tid = ", x(0), x(m), tid
  !$omp flush(x)
  write( *,'(a,3(i5))' ) "after flush: x(i), tid = ", x(0), x(m), tid
  !$omp barrier

  write( *,'(a,3(i5))' ) "after barrier: x(i), tid = ", x(0), x(m), tid
  !$omp end parallel

End program flush
