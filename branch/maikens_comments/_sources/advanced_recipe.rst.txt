Advanced Container Recipes
==========================

.. objectives::

   * Understand the complexities of building advanced scientific software stacks within containers.
   * Learn to construct detailed Apptainer definition files that encapsulate comprehensive scientific environments.
   * Develop proficiency in crafting container recipes that ensure reproducibility and consistency across different HPC systems.

   This demo will walk you through the process of creating advanced container recipes using Apptainer, aimed at constructing robust scientific software environments. These environments often require multiple, intricately linked software tools and libraries that must be correctly configured to work together seamlessly.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * Basic to intermediate knowledge of Linux, shell scripting, and scientific software installation.
   * Understanding of dependency management and environment configuration for scientific computing.

Building a scientific software stack in a container can be challenging due to dependencies and the need for specific configurations. By using advanced container recipes, researchers can encapsulate these environments, making them portable and reproducible. This is particularly important in scientific research, where precise control over software versions and settings is crucial for validating experimental results.

First, we'll outline a container recipe that includes a typical setup for a bioinformatics analysis environment, featuring tools like BLAST, Python, and R.

.. code-block:: bash

   # Example Apptainer definition file for a bioinformatics stack
   Bootstrap: library
   From: ubuntu:20.04
   
   %post
       apt-get update && apt-get install -y wget build-essential python3 python3-pip r-base
       pip3 install numpy scipy pandas biopython
       wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.10.1+-x64-linux.tar.gz
       tar -xzf ncbi-blast-2.10.1+-x64-linux.tar.gz -C /usr/local/bin --strip-components=1
       echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc

   %environment
       export PATH=/usr/local/bin:$PATH

   %runscript
       echo "Environment for bioinformatics analysis ready. Tools available: BLAST, Python, R."
       exec /bin/bash
   

.. code-block:: bash
   
   # Build the container for the bioinformatics stack
   apptainer build bioinfo_container.sif bioinfo.def


This block constructs the ``bioinfo_container.sif`` from the ``bioinfo.def`` file. It installs critical tools for bioinformatics, including BLAST for sequence analysis, and a suite of Python and R libraries commonly used in data analysis and visualization.

.. code-block:: bash
   
   # Run the container, providing an interactive shell
   apptainer shell bioinfo_container.sif


This command provides an interactive shell within the ``bioinfo_container.sif``, allowing users to execute the installed tools and perform analyses as if they were running on a native environment. This setup is ideal for ensuring that all users, regardless of their host system configuration, can reproduce the scientific computations.

Summary
-------
In this tutorial, you've learned how to create advanced container recipes using Apptainer to build a comprehensive scientific software stack. This skill is invaluable for researchers who need to ensure the reproducibility of their experiments and for IT administrators tasked with maintaining consistent

