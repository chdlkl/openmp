Program test_shared_and_private
  use omp_lib
  implicit none
  integer :: tid
  integer :: a, b, c

  write( *,'(1x,a)' ) 'before parallel......'
  call omp_set_num_threads(7)  !// 设定程序执行的线程数
  a = -1; b = -2; c = -3
  write( *,'(1x,a,3(i4),a,i4)' ) 'a,b,c = ', a, b, c, ' id =  ', tid

  write( *,'(1x,a)' ) 'during parallel......'
  !// 这里要注意的一点是: paralle中的write语句并不是严格按照代码中的顺序输出
  !$omp parallel private(a,b) shared(c) ! or omp parallel default(private) shared(c)
  tid = omp_get_thread_num()
  write( *,'(1x,a,3(i4),a,i4)' ) 'a,b,c = ', a, b, c, ' id =  ', tid
  b = b + tid  
  c = c + tid
  write( *,'(1x,a,3(i4),a)' ) 'a,b,c = ', a, b, c, ' b and c changed!'
  !$omp end parallel
  
  tid = omp_get_thread_num()
  write( *,'(1x,a)' ) 'after parallel......'
  write( *,'(1x,a,3(i4),a,i4)' ) 'a,b,c = ', a, b, c, ' id =  ', tid

End program test_shared_and_private
