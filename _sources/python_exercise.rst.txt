Python environment in a container
=================================

.. objectives::

   * Learn how to create a Python environment in an apptainer image

Background
----------

Python environments are nowadays very popular due to the popularity of
Python as a scientific programming language. These environments can sometimes
be problematic for the filesystem as they require thousands of files.

Exercise 1: Creating Python image with image's pip
--------------------------------------------------

.. exercise:: Install Python environment to base python image

   Use the base python image and install following packages to the image:
      - python
      - numpy
      - pandas

   .. solution:: Solution

      Create the following definition file ``python_definition.def``:

      .. code-block:: singularity

         Bootstrap: docker
         From: python:latest

         %post
             # Python is already installed in the image
             pip install numpy pandas

      You can then create the container with:

      .. code-block:: console

         $ apptainer build python_environment.sif python_definition.def

      You can test out the python with:

      .. code-block:: console

         $ apptainer run python_environment.sif python




Exercise 2: Creating conda/mamba environment in an image
--------------------------------------------------------

.. exercise:: Install an environment to an apptainer image using an optimized definition file

   Create an environment with this definition file customized for
   environment creation:

   https://github.com/simo-tuomisto/micromamba-apptainer

   Install the following packages to the environment:
      - python
      - numpy
      - pandas

   .. solution:: Solution

      Write the following ``environment.yml``:

      .. code-block:: yaml

        name: base
        channels:
          - conda-forge
        dependencies:
          - python
          - numpy
          - pandas

      Obtain the ``micromamba_apptainer.def`` bootstrap definition file from the repository:

      .. code-block:: singularity

        Bootstrap: docker
        From: mambaorg/micromamba:latest

        %files
        environment.yml /opt

        %post
            micromamba install -q -y -n base -f /opt/environment.yml

            micromamba clean --all --yes

        %labels
            EnvironmentFile: /opt/environment.yml

        %help
            This container containes a Python environment created
            from an environment file.

            To run Python from the environment:

                apptainer run my_environment.sif python

            To see the environment file used to create the environment:

                apptainer run my_environment.sif cat /opt/environment.yml

            To see what packags are in the environment:

                apptainer run micromamba list

      You can then create the container with:

      .. code-block:: console

         $ apptainer build my_environment.sif micromamba_apptainer.def

      You can test out the python with:

      .. code-block:: console

         $ apptainer run my_environment.sif python
