!.. collapse子句
!.. collapse子句只能用于一个嵌套循环，它可以将多层嵌套循环进行合并并展开到一个更大的循环空间
!.. 这样可以增加将在线程组上进行划分调度的循环总数
Program do_collapse
  use omp_lib
  implicit none 
  integer, parameter :: l = 4, m = 4, n = 2
  integer :: i, j, k, tid

  call omp_set_num_threads(3)
  !$omp parallel do collapse(2) private(i,j,k,tid) default( shared )
  Do i = 1, l
    do j = 1, m
      Do k = 1, n
        tid = omp_get_thread_num()
        write( *,'(1x,a,4(2x,i4))' ) "tid, i, j, k = ", tid, i, j, k
      End do
    end do
  End do
  !$omp end parallel do
End program do_collapse

!.. 小结
!.. 1. 此程序包含3层嵌套循环。应用collapse(2)将最外面的两层循环(i=1,4;j=1,4)合并成一个大循环
!.. 2. 本例中此大循环由线程组中的线程来完成，而最内部循环(循环下标为k)并未并行化
!.. 3. 最外层的两个嵌套循环合并化的大循环共循环16次。分别分给线程组中的3个线程来完成