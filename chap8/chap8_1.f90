!.. 采用!$omp do指令执行任务
!Program print_do
!  use omp_lib
!  implicit none 
!  integer :: i, m
!  integer :: a(100), b(100)
!
!  call omp_set_num_threads(6)
!  m = 4
!  do i = 1, size(a)
!    a(i) = i 
!    b(i) = i 
!  end do
!
!  !$omp parallel private(i) shared( a, m )
!  !$omp do
!  do i = 1, m
!    call print_task( a(i) )
!  end do
!  !$omp end do
!  !$omp end parallel
!
!End program print_do
!
!Subroutine print_task( i )
!  use omp_lib
!  implicit none 
!  integer :: i, tid, nthreads
!
!  nthreads = omp_get_num_threads()
!  tid      = omp_get_thread_num()
!  write( *,'(1x,a,3(i8))' ) "print task: nthreads, tid, i = ", nthreads, tid, i
!End subroutine print_task

!.. 接下来用!$omp sections指令重写上述代码
!Program print_sections
!  use omp_lib
!  implicit none
!  integer :: i, a(100)
!  
!  call omp_set_num_threads(6)
!  do i = 1, 100
!    a(i) = i 
!  end do
!  
!  !$omp parallel private(i) shared(a)
!  !$omp sections
!  !$omp section
!  i = 1
!  call print_task( a(i) )
!  !$omp section
!  i = 2
!  call print_task( a(i) )
!  !$omp section
!  i = 3
!  call print_task( a(i) )
!  !$omp section
!  i = 4
!  call print_task( a(i) )
!  !$omp end sections
!  !$omp end parallel
!End program print_sections
!  
!Subroutine print_task( i )
!  use omp_lib
!  implicit none 
!  integer :: i, tid, nthreads
!
!  nthreads = omp_get_num_threads()
!  tid      = omp_get_thread_num()
!  write( *,'(1x,a,3(i8))' ) "print task: nthreads, tid, i = ", nthreads, tid, i
!End subroutine print_task  

!.. 小结
!.. 1. do指令与sections指令具有一些类似之处
!.. 2. 可以将sections指令理解为do指令的展开形式。
!.. 3. sections指令适合执行少量的任务，而且这些任务之间没有迭代关系，且与循环迭代变量也没有关系

!.. 接下来用task指令重新给上述代码
Program print_do
  use omp_lib
  implicit none 
  integer :: i, m
  integer :: a(100), b(100)

  call omp_set_num_threads(6)
  m = 4
  do i = 1, 100
    a(i) = i 
    b(i) = i 
  end do

  !$omp parallel private(i) shared(a,m)
  !$omp single
  do i = 1, m
    !$omp task firstprivate(i) shared(a)
    call print_task( a(i) )
    !$omp end task
  end do
  !$omp end single
  !$omp end parallel

End program print_do

Subroutine print_task( i )
  use omp_lib
  implicit none 
  integer :: i, tid, nthreads

  nthreads = omp_get_num_threads()
  tid      = omp_get_thread_num()
  call pause_seconds(2)
  write( *,'(1x,a,3(i8))' ) "print task: nthreads, tid, i = ", nthreads, tid, i
End subroutine print_task  

Subroutine pause_seconds(i)
  use omp_lib
  implicit none 
  integer :: i 
  real(kind=8) :: starttime, endtime, usedtime, pausetime

  pausetime = abs(i)
  starttime = omp_get_wtime()
  usedtime  = -1.0

  do while ( usedtime < pausetime )
    endtime  = omp_get_wtime()
    usedtime = endtime - starttime
  end do
End subroutine pause_seconds

!.. 小结
!.. 1. 采用single指令表示只有一个线程会执行下面的代码，但是所有的6个线程均可以参与执行生成的任务
!.. 2. 如果取消single指令，那么会执行6次
