!.. task指令解决斐波那契数列中的递归调用
Program fibonacci_task
  use omp_lib
  implicit none 
  integer :: n, fib
  n = 40

  call omp_set_dynamic( .false. )
  call omp_set_num_threads(8)

  !$omp parallel shared(n)
  !$omp single
  write( *,'(1x,a,i3,a,g0)' ) 'fib(', n, ' ) = ', fib(n)
  !$omp end single
  !$omp end parallel

End program 

Recursive function fib(n) result( fib_result )
  use omp_lib
  implicit none
  integer :: i, j, n, fib_result

  if ( n < 2 ) then 
    fib_result = n 
  else
    !$omp task shared( i ) firstprivate( n )
    i = fib( n-1 )
    !$omp end task

    !$omp task shared( j ) firstprivate( n )
    j = fib( n-2 )
    !$omp end task

    !$omp taskwait
    fib_result = i + j 
  end if
End function fib

!.. 小结
!.. 1. 调用函数omp_set_dynamic(.false.)禁止动态调整线程数量，调用omp_set_num_threads(8)确定线程组中最大线程数量为8
!.. 2. single指令确定只有一个线程将执行调用fib(n)中的print语句
!.. 3. recursive function fib(n)表示fib(n)是一个递归函数
!.. 4. 在函数fib中，利用task指令定义两个任务：一个任务是用来计算i=fib(n-1)
!..    一个任务是用来计算j=fib(n-2)。只有当这两个任务完成后，对它们的返回值求和才能产生函数fib(n)的返回值
!.. 5. 在执行当前任务过程中会生成子任务，taskwait指令用来实现完成这些子任务过程中进行等待
!..    在本例中，调用函数fib(n)的过程中生成两个任务(计算i和j)，这样需要确保在对fib(n)调用返回以前，这两个任务已经完成
!.. 6. 虽然只有1个线程执行single指令，也只有1个线程调用递归函数fib(n)，但是所有8个线程都参与执行了所生成的任务。