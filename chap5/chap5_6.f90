!.. 1. sections指令在大多数情况下与一个独立的parallel指令一起使用，因此openmp提供了一个指令!$parallel sections来方便编程人员编程
!.. 2. 一个程序中可以定义多个sections结构，每个sections结构中又可以定义多个section
!.. 3. 同一个sections中section之间处于并行状态，sections与其他sections之间处于串行状态
!.. 4. section内部不允许出现能够到达section之外的跳转语句，也不允许有外部的跳转语句到达section内部
Program multi_sections
  use omp_lib
  implicit none
  integer :: tid, nthreads

  call omp_set_num_threads(6)
  write(*,'(1x,a)') "Section No.    section no.    nthreads    id"
  write(*,'(1x,a)') "Sections A "

  !$omp parallel private(tid, nthreads)
  !$omp sections
  !$omp section
  tid      = omp_get_thread_num()
  nthreads = omp_get_num_threads()
  write(*,'(1x,a,i8,i8)') "                section 1: ", nthreads, tid 

  !$omp section
  tid      = omp_get_thread_num()
  nthreads = omp_get_num_threads()
  write(*,'(1x,a,i8,i8)') "                section 2: ", nthreads, tid 

  !$omp section
  tid      = omp_get_thread_num()
  nthreads = omp_get_num_threads()
  write(*,'(1x,a,i8,i8)') "                section 3: ", nthreads, tid 
  !$omp end sections
  !$omp end parallel
  
  write(*,'(1x,a)') "Sections B "
  !$omp parallel private(tid, nthreads)
  !$omp sections
  !$omp section
  tid      = omp_get_thread_num()
  nthreads = omp_get_num_threads()
  write(*,'(1x,a,i8,i8)') "                section 4: ", nthreads, tid 

  !$omp section
  tid      = omp_get_thread_num()
  nthreads = omp_get_num_threads()
  write(*,'(1x,a,i8,i8)') "                section 5: ", nthreads, tid 

  !$omp section
  tid      = omp_get_thread_num()
  nthreads = omp_get_num_threads()
  write(*,'(1x,a,i8,i8)') "                section 6: ", nthreads, tid 
  !$omp end sections
  !$omp end parallel

End program multi_sections

!.. 总结
!.. 1. 程序定义了两个sections并行域。每个sections并行域有三个section，sections并行域中执行section的三个子进程号各不相同
!.. 2. sections A与sections B的并行域在程序中处于串行状态
