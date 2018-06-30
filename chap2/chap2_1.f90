program chap2_1
  implicit none
  
  !.. 串行区域主线程为0，输出一次hello
  write( *,'(1x,a)' ) '第一个串行区'
  write( *,'(1x,a)' ) 'hello!'

  !.. 在并行区域，如果没有设置程序运行的线程数时，默认为最大线程
  write( *,'(1x,a)' ) '并行区'
  !$omp parallel
  write( *,'(1x,a)' ) 'hello, world!'
  !$omp end parallel

  write( *,'(1x,a)' ) '第二个串行区'
  write( *,'(1x,a)' ) 'hello!'
end program chap2_1
  
