!.. 在不设置size参数情况下，分析各种调度方式的时间消耗
Program do_schedule
  use omp_lib
  implicit none
  integer, parameter :: m = 10000, n = 10000
  integer :: i, j, a
  real(kind=8) :: starttime, endtime, time

  call omp_set_num_threads(2)
  starttime = omp_get_wtime()
  !$omp parallel private(i,j,a) default(shared)
  !$omp do schedule(static)
  Do i = 1, m 
    do j = 1, n
      a = i * j
    end do
  End do
  !$omp end do
  !$omp end parallel
  endtime = omp_get_wtime()
  time    = (endtime-starttime) * 1000  !.. 转化成ms
  write(*,'(1x,a,g0,a)') "static schedule time: ", time, "ms"

  starttime = omp_get_wtime()
  !$omp parallel private(i,j,a) default(shared)
  !$omp do schedule(dynamic)
  Do i = 1, m 
    do j = 1, n
      a = i * j
    end do
  End do
  !$omp end do
  !$omp end parallel
  endtime = omp_get_wtime()
  time    = (endtime-starttime) * 1000  !.. 转化成ms
  write(*,'(1x,a,g0,a)') "dynamic schedule time: ", time, "ms"
  
  starttime = omp_get_wtime()
  !$omp parallel private(i,j,a) default(shared)
  !$omp do schedule(guided)
  Do i = 1, m 
    do j = 1, n
      a = i * j
    end do
  End do
  !$omp end do
  !$omp end parallel
  endtime = omp_get_wtime()
  time    = (endtime-starttime) * 1000  !.. 转化成ms
  write(*,'(1x,a,g0,a)') "guided schedule time: ", time, "ms"

End program do_schedule

!.. 总结
!.. 1. 通常不对size进行指定
!.. 2. 静态调度时间最长，动态次之，guided最小
!.. 3. 建议使用guided调度进行负载不平衡的循环计算
!.. 4. 函数omp_get_wtime()返回值的单位是s
!.. 5. 静态调度比较适合每次迭代时间相近的情况，特点：个线程任务明确，在任务分配时无需同步操作，但是运行快的线程要等慢的
!.. 6. 动态调度适合任务数量可变或不确定的情形
!.. 7. 指导性调度与动态调度类似，但是队列相关的调度开销比较小，性能更好
