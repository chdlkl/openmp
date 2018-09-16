!.. 简单锁
!.. 简单锁不可以多次上锁，即使是同一个线程也不允许
!.. 除了线程尝试给已经被某个线程持有的锁进行上锁操作不会被阻塞外，其他线程均处于阻塞状态
!.. 下面举例说明阻塞加锁的用法
Program lock
  use omp_lib
  implicit none 
  integer, parameter :: m = 5
  integer :: i, tid
  integer(omp_lock_kind) :: lck

  call omp_set_num_threads(3)
  call omp_init_lock(lck)  !.. 对锁初始化

  !$omp parallel do private( i, tid ) shared(lck)
  do i = 1, m
    tid = omp_get_thread_num()
    call omp_set_lock(lck)  !.. 加锁
    write( *,'(1x,a,i3,a,i3)' ) "thread id = ", tid, " i = ", i
    call omp_unset_lock(lck)  !.. 解锁
  end do
  !$omp end parallel do

  call omp_destroy_lock(lck)  !.. 销毁锁

End program lock

!.. 小结
!.. 加锁操作的特点是：当1个线程加锁以后，其余请求锁的线程将形成1个等待队列
!.. 并在解锁后按优先级获得锁
!.. 因此，do结构内加锁和解锁之间的代码只允许1个线程执行
!..
!虽然试图将此do循环采用3个线程进行并行，但在实际过程中，当有1个线程执行任务时，其他线程处于阻塞状态

