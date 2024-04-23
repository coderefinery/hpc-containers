Basics of running containers
============================

.. objectives::

   * How you can run a container?
   * What methods are available to run a container?


Obtaining a container from container registry
---------------------------------------------

For these examples let's use the official Ubuntu image from
`Docker Hub <https://hub.docker.com/_/ubuntu>`__.

.. code-block:: console

   $ apptainer pull ubuntu.sif docker://ubuntu
