using MCMC, HDF5

import Base: Semaphore, acquire, release

const semaphore = Semaphore(Threads.nthreads())

MCMC.should_save(::PiMCMC, i::Int) = i % 1_000 == 0

function main(file::HDF5.File)

    acquire(semaphore)

    pi_mcmc = PiMCMC([0.0, 0.0], checkpoint_file=file)
    Base.with_logger(mcmc_logger(id(pi_mcmc), 1_000)) do
        try
            run!(pi_mcmc, 1_000_000)
        finally
            close(save_file(pi_mcmc))
        end
    end
    release(semaphore)
end

h5open("checkpoint.h5", "w") do file
    tasks = [Threads.@spawn main($file) for _ in 1:10]
    wait.(tasks)
end