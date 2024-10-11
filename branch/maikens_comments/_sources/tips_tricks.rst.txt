Tips, tricks and frequently asked questions
===========================================


Where should I install my software?
-----------------------------------

Quite often in Docker images software is installed under ``root``-user's
home folder (``/root``). This is **the wrong approach**. Installing software
there with the assumption that the container will be run by ``root``-user
can cause permission headaches.

Folders under ``/home`` are also bad as that is commonly mounted by Apptainer
and thus the bind mount hides software installed there.

You should install manual installations of software to, for example,
``/opt`` or ``/usr/local``. See
`Filesystem Hierarchy Standard <https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard>`__
for explanation on how different folders are organized.


I have sensitive code that I would need to have in the container
----------------------------------------------------------------

Instead of installing your sensitive application to the image
you can instead mount the application directory inside the container.

If your program requires compilations or installations, you can
install dependencies into the container image and then install software
in a bound folder or on a
`persistent overlay <https://apptainer.org/docs/user/latest/persistent_overlays.html>`__.

If you still decide to put sensitive code in your image,
remember that it is visible to everyone who has access to the image.


I have an existing container, but I would want to do small modifications to the code
------------------------------------------------------------------------------------

If you want to do you're own modifications to the code
you can either use
`persistent overlays <https://apptainer.org/docs/user/latest/persistent_overlays.html>`__
or you can use the following trick:

1. Copy the code that you want to modify from the container to a folder outside
   of the container:

   .. code-block:: console

      $ apptainer exec my_container.sif cp -r /path/to/code/src src

2. Modify the code outside of the container
3. Bind mount modified code from outside of the container back into the container

   .. code-block:: console

      $ apptainer run --bind src:/path/to/code/src my_container.sif


My container starts to become huge
----------------------------------

Remember to clean up any unnecessary source code or software in your
``%post``-block. If your program does not need e.g. development headers
once it has been installed, you can remove them.

You can also try
`multi-stage builds <https://apptainer.org/docs/user/latest/definition_files.html#multi-stage-builds>`__
where one container is used to build a software, which is then copied
to another container that has only those packages required to run the software.


I would want to install my conda environment in a container
-----------------------------------------------------------

See
`this repository <https://github.com/simo-tuomisto/micromamba-apptainer>`__
for an example definition file that can be used to bootstrap
conda environment into a Apptainer container image.
