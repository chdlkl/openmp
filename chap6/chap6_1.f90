!.. barrier指令：要求并行区域内所有线程在此处同步等待其他线程
!.. 然后恢复并行执行barrier后面的语句
Program barrier_parallel
  use omp_lib
  implicit none
  integer :: tid, nthreads
  
  call omp_set_num_threads(3)
  !$omp parallel private(tid, nthreads)
  tid = omp_get_thread_num()
  write(*,'(1x,a,g0)') "hello from thread id = ", tid
  !$omp barrier
  if ( tid == 0 ) then 
    nthreads = omp_get_num_threads()
    write(*,'(1x,a,g0,a)') "there are ", nthreads, " threads to say hello!"
  end if
  !$omp end parallel
End program barrier_parallel

!.. 小结
!.. 1. 程序首先建立了3个线程，然后各个线程分别输出并行区域线程总数和各自的线程号
!.. 2. 最后进行统计并输出"hello from thread id"的线程数的个数
!.. 3. 因为第二项任务(统计)与第一项任务(输出hellr from thread id)存在数据相关
!..    所以必须等全部线程处理完第一个任务后才可以由主线程去执行第二项任务
!..    如果各线程在打印输出后不进行同步，那么，在各线程未完成打印输出时，就出现线程总数统计情况
