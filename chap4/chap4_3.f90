!.. 默认模式实际上就是动态模式。即如果在程序中没有设定并行域中线程的数落，则程序自动转为动态模式
!.. 在动态模式中，各并行域可以具有不同的线程数
!.. 因此，一般建议尽量采用显示格式对所需的线程数量进行声明
!.. 可用线程数的动态调整是通过调用环境库函数omp_set_dynamic来实现的
!.. 如果参数为.true.,则表明启用了可用线程数的动态调整
!.. 如果参数为.false.,则表明禁用可用线程数的动态调整。
!.. 在参数缺省状态下，动态调整被启用
Program set_dynamic
  use omp_lib
  implicit none

  Integer :: nthreads_set, nthreads, tid

  nthreads_set = 3
  call omp_set_dynamic( .true. )
  call omp_set_num_threads( nthreads_set )
  write(*,'(1x,a,g0)') "set _number_threads = ", nthreads_set
  write(*,'(1x,a,g0)') "dynamic region(true or false):", omp_get_dynamic()
 
  !$omp parallel private( nthreads, tid )
  nthreads = omp_get_num_threads()
  tid = omp_get_thread_num()
  write(*,'(1x,a,g0)') "number of threads = ", nthreads
  write(*,'(1x,a,g0)') "tid = ", tid
  write(*,'(1x,a)') "----------------------------------"
  !$omp end parallel

End program set_dynamic

!.. 总结
!.. 1. 函数omp_set_dynamic()置于并行域之前，并与函数omp_set_num_threads()或指令num_threads()成对使用
!.. 2. 与函数omp_set_dynamic()对应的函数是omp_get_dynamic()。此函数用来确定程序是否启动了动态线程调整
!.. 3. 实际参与并行执行的线程数不会超过函数omp_set_num_threads()所设置的线程数
