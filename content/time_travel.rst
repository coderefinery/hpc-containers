Time Travelling with Containers
===============================

.. objectives::

   * Understand the benefits of using containers to access and run legacy software versions.
   * Learn how to install an older version of R and RStudio within an Apptainer container for interactive use.
   * Develop the ability to manage software versions effectively in a containerized environment, ensuring compatibility and reproducibility.

   This demo illustrates how to "time travel" by using containers to install and run older versions of software that are no longer supported or compatible with current operating systems. This is particularly useful in scientific research, where reproducing results from past studies often requires software versions that were used originally.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * Basic familiarity with the R programming language and Linux command line operations.

The ability to work with specific software versions is crucial for ensuring that scientific findings are reproducible. Containers encapsulate software in an environment that includes everything needed to run it, thus preserving functionality even when host systems evolve.

First, we'll create a container that includes R 3.2 and RStudio Server 0.99, which are older versions no longer typically supported on modern systems.

``` bash
# Example Apptainer definition file for R 3.2 and RStudio 0.99
Bootstrap: library
From: ubuntu:16.04

%post
    apt-get update && apt-get install -y sudo gdebi-core
    wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-0.99.903-amd64.deb
    gdebi --non-interactive rstudio-server-0.99.903-amd64.deb
    apt-get install -y r-base=3.2.*
    echo 'options(repos = list(CRAN = "http://cran.rstudio.com"))' >> /etc/R/Rprofile.site

%runscript
    echo "Starting RStudio Server..."
    /usr/lib/rstudio-server/bin/rserver --server-daemonize=0

```

``` bash
# Build the container with old R and RStudio
apptainer build rstudio_container.sif rstudio.def
```

This block constructs the `rstudio_container.sif` from the `rstudio.def` file, setting up an Ubuntu 16.04 environment with R 3.2 and RStudio Server 0.99. These versions ensure compatibility with older scripts and packages.

``` bash
# Run the container, accessing RStudio Server
apptainer run -p rstudio_container.sif
```

This command starts the RStudio Server within the container. You can access RStudio interactively by connecting to the host's IP address at the specified port (default is 8787), where RStudio Server is configured to run. This setup allows users to interact with an older R environment as if it were installed directly on their machine.

Summary
-------
In this tutorial, you've learned how to use Apptainer to create a containerized environment that supports running older versions of R and RStudio. This "time travelling" capability is essential for reproducing past scientific results and maintaining long-term accessibility to software tools, regardless of their age or compatibility with current systems. By mastering these techniques, researchers can ensure their work remains valid and reproducible for years to come.

