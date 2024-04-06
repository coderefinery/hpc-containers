Environment Variables and Scripts
=================================

.. objectives::

   * Understand the role of environment variables in configuring software behavior inside containers.
   * Learn to set and export environment variables within an Apptainer container.
   * Develop the ability to customize the behavior of applications running in containers through environmental configuration.

   This demo will show you how to set and manipulate environment variables inside an Apptainer container. Environment variables are a critical component in software development and deployment, allowing you to modify the behavior of applications without changing code. They are especially useful in containerized environments where they can be used to control and customize settings across different deployments seamlessly.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * Basic familiarity with shell scripting and command line operations.

Setting environment variables inside a container is an essential skill for software developers and system administrators. These variables can dictate operational parameters such as database connections, logging levels, and other configurable settings that an application might need to operate correctly in different environments. In this demo, you will learn how to set these variables within an Apptainer container, ensuring your applications behave as expected under various conditions.

First, we will create a simple Apptainer definition file that includes the necessary commands to set environment variables. Then, we will build and run the container to see how these variables affect the application's behavior.

.. code-block::  bash
   
   # Example Apptainer definition file setting environment variables
   Bootstrap: library
   From: ubuntu:20.04
   
   %post
       apt-get update && apt-get install -y vim
       echo 'export MY_VAR="Hello from Apptainer!"' >> /etc/profile
   
   %environment
       export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
       export ANOTHER_VAR="Another example variable"
   
   %runscript
       echo "MY_VAR is set to $MY_VAR"
       echo "ANOTHER_VAR is set to $ANOTHER_VAR"


.. code-block::  bash
   
   # Build the container with environment variables
   apptainer build env_container.sif env.def


This block creates the ``env_container.sif`` container from the ``env.def`` file. It sets up an Ubuntu-based environment and installs Vim as an example application. The ``%post`` section modifies the system profile to permanently set an environment variable, while ``%environment`` sets it specifically for when the container is run.

.. code-block::  bash
   
   # Run the container to see environment variables in action
   apptainer run env_container.sif


This final command executes the container, running the script defined in ``%runscript``. It outputs the values of the environment variables set during the build phase and the runtime environment, demonstrating how these can be manipulated within the container.

Summary
-------
In this tutorial, you've learned how to set and export environment variables within an Apptainer container to influence the behavior of contained software applications. This skill is vital for managing software configurations in a reproducible and scalable manner across various computing environments. By using environment variables effectively, you can ensure that your applications perform consistently no matter where they are deployed.
