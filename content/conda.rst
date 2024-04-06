Reproducibility with Python
===========================

.. objectives::

   * Understand the role of Conda environments in ensuring reproducibility in scientific computing.
   * Learn how to set up a Conda environment within an Apptainer container.
   * Develop skills to create and manage Python environments that are consistent across various computing platforms.

   This demo demonstrates the creation of a Conda environment within an Apptainer container to enhance reproducibility in scientific computing. Conda is a popular package management system that simplifies package installation and environment management. This is crucial in scientific research where experiments often require specific versions of software and libraries to ensure consistent results.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * Basic knowledge of Python, Conda, and container technologies.

Reproducibility is a cornerstone of scientific research, ensuring that results are consistent over time and across different platforms. By using Conda within Apptainer containers, researchers can encapsulate their computational environment, making their workflows portable and reproducible.

First, we'll define a container with a Conda environment set up for a typical scientific Python stack.

.. code-block:: bash
   # Example Apptainer definition file for setting up a Conda environment
   Bootstrap: library
   From: continuumio/miniconda3
   
   %post
       conda create -n scienv python=3.8 numpy scipy matplotlib ipython -y
       echo "source activate scienv" >> ~/.bashrc
   
   %environment
       export PATH=/opt/conda/envs/scienv/bin:$PATH
   
   %runscript
       echo "Activating Conda environment and launching IPython..."
       source activate scienv
       ipython


.. code-block:: bash
   # Build the container that includes the Conda environment
   apptainer build conda_container.sif conda.def


This block builds the ``conda_container.sif`` from the ``conda.def`` definition file, which uses the Miniconda image to install a Conda environment named ``scienv`` with several essential scientific computing packages like NumPy, SciPy, and Matplotlib.


.. code-block:: bash
   # Run the container, initiating the Conda environment
   apptainer exec conda_container.sif /bin/bash -c "source ~/.bashrc && ipython"


This command starts a shell that activates the Conda environment and launches IPython, a powerful interactive shell for Python. This setup allows users to interactively compute and visualize data within the consistent environment provided by the container.

Summary
-------
In this tutorial, you've learned how to create a reproducible Python computing environment using Conda within an Apptainer container. This approach is invaluable for scientific researchers who need to ensure that their computational experiments are consistent and reproducible, regardless of the underlying hardware or software environment. By leveraging Conda and Apptainer, you can significantly enhance the portability and reliability of your scientific workflows.

