MPI programs and containers
===========================

.. objectives::

   * Learn what complications are involved with MPI containers
   * Learn how to generate a MPI container for your HPC system


What to consider when creating a container for MPI programs?
------------------------------------------------------------

Message Passing Interface (MPI) is a standard and a programming
paradigm where programs can use MPI directives to send messages across
across thousands of processes. It is commonly used in traditional
HPC computing.

To handle the scale of the MPI programs the MPI installations
are typically tied to the high-speed interconnect available in
the computational cluster and to the queue system that the cluster
uses.

This can create the following problems:

1. Launching of the MPI job can fail if the program does not
   communicate with the queue system.
2. The MPI communication performance can be bad if the program
   does not utilize the high-speed interconnects correctly.
3. The container can have portability issues when taking it to
   a different cluster with different MPI, queue system or
   interconnect.

To solve these problems we first need to know how MPI works.


How MPI works
-------------

The launch process for an MPI program works like this:

1. A reservation is done in the queue system for some number
   of MPI tasks.
2. When the reservation gets the resources, individual MPI
   programs are launched by the queue system (``srun``) or
   by an MPI launcher (``mpirun``).
3. User's MPI program calls the MPI librarires it was built
   against.
4. These libraries ask the queue system how many other MPI
   tasks there are.
5. Individual MPI tasks start running the program collectively.
   Communication between tasks is done via fast interconnects.

.. figure:: img/mpi_job_structure.png
   :width: 100%

   Figure 1: How MPI programs launch

To make this work with various different queue systems and
various different interconnects MPI installations often
utilize Process Management Interface (PMI/PMI2/PMIx) when
they connect to the queue system and Unified Communication X
when they connect to the interconnects.

.. figure:: img/mpi_install_structure.png
   :width: 100%

   Figure 2: How MPI installations are usually constructed


How to use MPI with a container
-------------------------------

Most common way of running MPI programs in containers is
to utilize a
`hybrid model <https://apptainer.org/docs/user/main/mpi.html#hybrid-model>`__,
where the container contains the same MPI version as the host system.

When using this model the MPI launcher will call the MPI
within the container and use it to launch the application.

.. figure:: img/mpi_job_structure_hybrid.png
   :width: 100%

   Figure 3: Hybrid MPI job launch

Do note that the MPI inside the container does not necessarily
know how to utilize the fast interconnects. We'll talk about
solving this later.


Creating a simple MPI container
-------------------------------

Let's construct an example container that runs a simple
MPI benchmark from
`OSU Micro-Benchmarks <http://mvapich.cse.ohio-state.edu/benchmarks/>`__.
This benchmark suite is useful for testing whether the MPI
installation works and whether the MPI can utilize the fast
interconnect.

Because different sites have different MPI versions the definition
files differ as well. Pick a definition file for your site.

.. tabs::

   .. tab:: Triton (Aalto)

      :download:`ompi-triton.def <examples/ompi-triton.def>`:

      .. literalinclude:: examples/ompi-triton.def
         :language: singularity

      To build:

      .. code-block:: console

         srun --mem=16G --cpus-per-task=4 --time=01:00:00 apptainer build ompi-triton.sif ompi-triton.def

      To run (some extra parameters and needed to integrate with the cluster OpenMPI):

      .. code-block:: console
         module load openmpi/4.1.6
         export OMPI_MCA_orte_top_session_dir=/tmp/$USER/openmpi
         export PMIX_MCA_gds=hash
         srun --mem=2G --nodes=2-2 --ntasks-per-node=1 --time=00:10:00 apptainer run ompi-triton.sif

   .. tab:: Puhti (CSC)

      :download:`ompi-puhti.def <examples/ompi-puhti.def>`:

      .. literalinclude:: examples/ompi-puhti.def
         :language: singularity

      To build:

      .. code-block:: console

         apptainer build ompi-puhti.sif ompi-puhti.def

      To run (some extra parameters and needed to integrate with the cluster OpenMPI):

      .. code-block:: console
         module load openmpi/4.1.4
         export PMIX_MCA_gds=hash
         srun --account=project_XXXXXXX --partition=large --mem=2G --nodes=2-2 --ntasks-per-node=1 --time=00:10:00 apptainer run ompi-puhti.sif

   .. tab:: Sigma2 (Norway)

      Follow `these instructions <https://documentation.sigma2.no/code_development/guides/container_mpi.html>`__.


Utilizing the fast interconnects
--------------------------------

In order to get the fast interconnects to work with the hybrid model
one can either:

1. Install the interconnect drivers into the image and build the MPI to
   use them.
2. Mount cluster's MPI and other network libraries into the image and use
   them instead of the container's MPI while running the MPI program.

Below are explanations on how the interconnect libraries were provided.

.. tabs::

   .. tab:: Triton (Aalto)

      The interconnect support was provided by the ``libucx-dev``-package that
      provides Infiniband drivers.

      :download:`ompi-triton.def <examples/ompi-triton.def>`, line 15:

      .. literalinclude:: examples/ompi-triton.def
         :language: singularity
         :lines: 15

      The OpenMPI installation was then configured to use these drivers:

      :download:`ompi-triton.def <examples/ompi-triton.def>`, line 26:

      .. literalinclude:: examples/ompi-triton.def
         :language: singularity
         :lines: 26

   .. tab:: Puhti (CSC)

      The interconnect support is provided by installing drivers from
      Mellanox's Infiniband driver repository:
      :download:`ompi-puhti.def <examples/ompi-puhti.def>`, :

      .. literalinclude:: examples/ompi-puhti.def
         :language: singularity
         :lines: 27-38

   .. tab:: Sigma2 (Norway)

      Interconnect support is not explicitly installed.

Review of this session
----------------------

