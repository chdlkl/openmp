Program test_shared_and_private
  use omp_lib
  !.. 上面一句也可替换为include 'omp_lib.h'
  implicit none
  integer :: tid
  integer :: a, b, c

  write( *,'(1x,a)' ) 'before parallel......'
  call omp_set_num_threads(7)  !// 设定程序执行的线程数
  a = -1; b = -2; c = -3
  write( *,'(1x,a,3(i4),a,i4)' ) 'a,b,c = ', a, b, c, ' id =  ', tid

  write( *,'(1x,a)' ) 'during parallel......'
  !.. 这里要注意的一点是: paralle中的write语句并不是严格按照代码中的顺序输出
  !.. private子句将变量定义成私有变量，并在并行区域开始处为线程组的那个线程产生一个该变量的私有副本
  !.. 值得注意的是，private子句声明的私有变量的初始值在并行域的入口处是未定义的，它不会继承并行域外同名原始变量的值
  !.. private声明的变量，在并行域内的值与并行域外的同名变量没有关系

  !.. shared子句将其变量定义为公有变量，此变量只能存在于内存区域的一个固定位置
  !.. 各个线程均能访问此变量，并进行读写操作。但是在对共有变量进行写操作时，必须采用critical等指令来避免数据竞争的现象 
  !.. 串行域与并行域都指向shared所声明变量的内存  

  !.. default子句。default(shared):传入并行域内的同名变量均是共享变量，各线程不会产生变量的私有副本
  !.. default(private):传入并行域的同名变量均是私有变量
  !.. default(none):除了具有明确定义的变量以外，线程所使用的变量必须显式地进行声明是私有变量还是共享变量
  !.. 循环下标变量不用声明，默认为私有变量

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
