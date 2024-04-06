Verify Apptainer Installation
=============================

.. objectives::

   * Understand the importance of verifying tool installation on HPC systems.
   * Learn how to check the installation and version of Apptainer on an HPC cluster.
   * Gain practical skills in verifying software prerequisites for scientific computing environments.

   This demo guides you through the process of verifying whether Apptainer is installed on your HPC cluster and checking its version. This is a critical first step in ensuring that the necessary tools are correctly configured before moving on to more complex containerization tasks. Knowing the version of Apptainer is essential as it may affect compatibility with container recipes or other tools used in your workflows.

.. prerequisites::

   * No prerequisites for following the demo

The first step in utilizing containers on any high-performance computing (HPC) cluster involves ensuring that the container management software, in this case, Apptainer, is properly installed. This demo is crucial as it confirms the foundational tool's availability, which is necessary for all subsequent container-related operations.

This demo will not only verify the presence of Apptainer on your system but will also teach you how to check its version. Knowing the installed version is important as it helps in troubleshooting and in ensuring compatibility with various container definitions and configurations used in scientific applications.


.. codeblock:: bash
   
   # Check if Apptainer is installed and determine its version
   apptainer --version
   

This command checks if Apptainer is installed and displays the version number. This information is useful for understanding which features and functionalities are available to you, as different versions may have different capabilities.

Summary
-------
In this lesson, you learned how to verify the installation of Apptainer on your HPC cluster and how to check its version. This is a foundational skill that ensures you can proceed with confidence in using Apptainer for more advanced tasks in container management.

.. exercise:: Configure Apptainer

   Explore the online Apptainer documentation and search for the bash environment variables that apptainer uses.
   1. Do you have any apptainer variables set in your shell environment?
   2. How do you set the variables for the CACHEDIR and TMPDIR so that they are pointing to a disk where you have enough free space? (e.g. your work folder)

   .. solution:: Solution
   
      1. Apptainer uses the following environemnt variables:
      2. The following code creates subfolders in your work directory and makes sure that apptainer will use those folders to store temporary files
   

      .. codeblock:: bash
      
         mkdir $WRKDIR/apptainercache/
         mkdir $WRKDIR/apptainertemp/
         export APPTAINER_CACHEDIR="$WRKDIR/apptainercache/"
         export APPTAINER_TMPDIR="$WRKDIR/apptainertemp/"





