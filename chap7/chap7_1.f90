!.. 环境变量设置方法举例说明
Program do_schedule_runtime
  use omp_lib
  implicit none 
  integer, parameter :: m = 10
  integer :: i, tid, nthreads

  !$omp parallel do private(i) schedule( runtime )
  do i = 1, m
    nthreads = omp_get_num_threads()
    tid      = omp_get_thread_num()
    write( *,'(1x,a,3(i6))' ) "nthreads, id, i = ", nthreads, tid, i
  end do
  !$omp end parallel do 

End program do_schedule_runtime

!.. 小结
!.. 1. 环境变量omp_dynamic的缺省值是true，因此在实际使用中可省略此环境变量的设置
!.. 2. export omp_num_threads = 3设置并行区域内子线程数量为3
!.. 3. 利用export omp_schedule = static, 4设置do循环的并行调度类型为静态
!..    每次分配给子线程的循环迭代次数为4
!.. 4. 循环区域由3个子线程并行执行。子线程0负责i=1,4；子线程1负责i=5,8；子线程2负责i=9,10
