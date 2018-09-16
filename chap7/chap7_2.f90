!.. openmp时间函数：omp_get_wtime
Program timetick
  use omp_lib
  implicit none
  integer, parameter :: m = 1000000
  integer :: i, j

  real(kind=8) :: starttime, endtime, usedtime
  real(kind=8) :: x 

  call omp_set_num_threads(2)
  starttime = omp_get_wtime()
  write( *,'(1x,a,g0,a)' ) "starttime = ", starttime, " seconds "
  
  do i = 1, m
    !$omp parallel do private( j, x )
    do j = 1, m
      x = log( exp( sin( 1.1**1.1 )**1.1 + 1.0 ) + 1.0 )
    end do
    !$omp end parallel do
  end do

  endtime = omp_get_wtime()
  write( *,'(1x,a,g0,a)' ) "endtime = ", endtime, " seconds "
 
  usedtime = endtime - starttime 
  write( *,'(1x,a,g0,a)' ) "usedtime = ", usedtime, " seconds "

End program timetick

!.. 小结
!.. 编程人员一般只关心程序运行的准确耗时，而不关心当前时间
!.. 此程序只对内循环实行了并行。这样，没执行一次外循环，就进行一次创建和回合线程组的操作，大大增加了时间的消耗
!.. 因此，在对循环的实际应用中，尽量对外层循环进行并行