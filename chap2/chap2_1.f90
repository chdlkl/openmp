program chap2_1
  implicit none
  write( *,'(1x,a)' ) 'hello!'
  !$omp parallel
  write( *,'(1x,a)' ) 'hello, world!'
  !$omp end parallel
  write( *,'(1x,a)' ) 'hello!'
end program chap2_1
  
