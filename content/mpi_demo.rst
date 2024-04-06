Running Parallel Jobs
=====================

.. objectives::

   * Understand the integration of MPI with containerized environments.
   * Learn to execute a script that runs parallel computational jobs using MPI inside an Apptainer container.
   * Acquire skills to leverage HPC resources for parallel computing within containerized applications.

   This demo demonstrates how to run parallel computational jobs inside an Apptainer container using the Message Passing Interface (MPI). Parallel computing is essential in HPC for solving complex and large-scale problems efficiently. By running these jobs inside containers, you can enhance portability and reproducibility of your computations across different HPC systems. This example will guide you through setting up an MPI environment inside a container and executing a parallel job script.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * Basic knowledge of parallel computing and MPI.
   * User permissions to run jobs on the HPC cluster.

Containers can encapsulate all the necessary software and libraries, providing a consistent runtime environment for applications. This is particularly beneficial for parallel computing where environmental consistency can significantly affect computational results. In this demo, you will use Apptainer to encapsulate the MPI environment and ensure that your parallel jobs can be executed seamlessly on any HPC system.

First, you will create a definition file for an Apptainer container that includes MPI libraries and a simple MPI script. Then, you will build the container and run a parallel job using MPI.

.. code-block::  bash
   # Apptainer definition file for MPI environment
   Bootstrap: library
   From: ubuntu:20.04
   
   %post
       apt-get update && apt-get install -y mpich
       echo "Hello from MPI" > /mpi_test.c
       echo "#include <mpi.h>" >> /mpi_test.c
       echo "int main(int argc, char* argv[]) {" >> /mpi_test.c
       echo "    MPI_Init(&argc, &argv);" >> /mpi_test.c
       echo "    int rank;" >> /mpi_test.c
       echo "    MPI_Comm_rank(MPI_COMM_WORLD, &rank);" >> /mpi_test.c
       echo "    printf(\"Rank %d: Hello MPI World!\\n\", rank);" >> /mpi_test.c
       echo "    MPI_Finalize();" >> /mpi_test.c
       echo "    return 0;" >> /mpi_test.c
       echo "}" >> /mpi_test.c
       mpicc /mpi_test.c -o /mpi_hello

   %environment
       export PATH=/usr/local/bin:$PATH

   %runscript
       mpirun -np 4 /mpi_hello


.. code-block::  bash
   # Build the MPI container
   apptainer build mpi_container.sif mpi.def


This block creates the container ``mpi_container.sif`` from the definition file ``mpi.def``. It includes installing MPICH, a popular MPI implementation, and compiling a simple MPI program that will be executed within the container.

.. code-block::  bash
   # Run the MPI container job
   apptainer exec --nv mpi_container.sif mpirun -np 4 /mpi_hello


This command runs the MPI program inside the container across four processes. The ``--nv`` option allows the container to access the host's Nvidia GPU resources if available, which is useful for MPI jobs that may benefit from GPU acceleration.

Summary
-------
You have successfully learned how to set up and execute parallel computational jobs using MPI inside an Apptainer container. This ability is critical for ensuring that your scientific computing tasks are both scalable and reproducible, regardless of the underlying HPC infrastructure. By encapsulating the MPI environment inside a container, you maintain consistency and control over the software dependencies, significantly enhancing the reliability of your computational results.

