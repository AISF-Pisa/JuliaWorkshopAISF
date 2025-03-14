program rand_mul
    implicit none
    integer :: i
    real(8) :: start_time, end_time, elapsed_time
    character(len=100) :: filename
    logical :: to_file
    integer :: unit
    real(8), allocatable :: z(:,:)
    integer, parameter :: samples = 10, evals = 8
    integer :: sample, eval
    real(8), dimension(samples, evals) :: times

    ! Set output to file or stdout
    to_file = .true.
    if (to_file) then
        filename = 'rand_mul.f90.dat'
        open(unit=10, file=filename, status='replace')
        unit = 10
    else
        unit = 6  ! stdout
    end if

    do i = 2, 100
        do sample = 1, samples
            do eval = 1, evals
                times(sample, eval) = bench_rand_mul(i)
            end do
        end do
        elapsed_time = minval(sum(times, 2)/evals)

        write(unit, '(I3, 1X, E22.15)') i, elapsed_time
        print*, z
    end do

    if (to_file) then
        close(10)
    end if

contains
    function bench_rand_mul(size) result(etime)
        integer, intent(in) :: size
        real(8) :: etime

        real(8), dimension(size, size) :: z

        call cpu_time(start_time)
        z = rand_mul_fun(size)
        call cpu_time(end_time)
        write(*,*) z
        
        etime = end_time - start_time
    end function bench_rand_mul
    function rand_mul_fun(size) result(c)
        integer, intent(in) :: size
        real(8), dimension(size, size) :: a, b, c

        call random_number(a)
        call random_number(b)

        c = matmul(a, b)
    end function rand_mul_fun
end program rand_mul