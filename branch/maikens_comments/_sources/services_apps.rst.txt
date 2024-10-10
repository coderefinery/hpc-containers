Services and apps
=================

What are services?
------------------

You can use Apptainer to launch services that run in
the background. Service might be, for example, a database
application that your code uses to fetch subsets from a
larger dataset.

Creating containers for these kinds of services can
often be quite complicated as they might need specific
folders to be created or specific environment variables
to be set.

What are apps?
--------------

When we're launching a complicated services or making
containers with more than one application we might also
want to specify multiple run scripts and entrypoints to
the container.

This can be done in Apptainer containers by specifying
multiple apps in the definition file.

Example: PostgreSQL container
-----------------------------

The following example uses a
`PostgreSQL image <https://hub.docker.com/_/postgres/>`__ to
set up a PostgreSQL server. Launching the server requires
that certain directory mounts and environment variables are set.

These have been found by looking at the
`docker-entrypoint.sh <https://github.com/docker-library/postgres/blob/master/docker-entrypoint.sh>`__-script
that would start the image when using Docker.

In the case of PostgreSQL, we'll most likely
want to use the PostgreSQL client to modify our databases.
We can do this by specifying an app for it.

Let's look at the definition file:

.. code-block:: singularity

   Bootstrap: docker
   From: postgres:16

   %environment
       export LC_ALL=C
       export LANG=C
       export LANGUAGE=C

   %startscript
       export POSTGRES_USER=$PGUSER
       export POSTGRES_PASSWORD=$PGPASSWORD
       export PGHOST=$HOSTNAME
       export PGPORT=${PGPORT:-19200}

       # Run the entry script for PostgreSQL Docker image
       exec docker-entrypoint.sh postgres "$@"

   %help

       This is a postgres container.

       The following data locations need to be mounted into the container:

       - Data location for the postgres: /var/lib/postgresql/data
       - Location for the runfiles for postgres: /var/run/postgresql

       The start script needs the following arguments:

       - postgres user name
       - postgres user password

       Usage:

           mkdir postgres_data
           mkdir postgres_run

           export PGUSER=postgres_user
           export PGPASSWORD=postgres_password
           apptainer instance start --bind postgres_data:/var/lib/postgresql/data --bind postgres_run:/var/run/postgresql postgres_container.sif postgres_server

           apptainer instance list

   %apprun psql
       export POSTGRES_USER=$PGUSER
       export POSTGRES_PASSWORD=$PGPASSWORD
       export PGHOST=$HOSTNAME
       export PGPORT=${PGPORT:-19200}
       exec psql "$@"

   %apphelp psql
       Run psql-client in image

       PostgreSQL instance needs to be started beforehand

       Usage:

           export PGUSER=postgres_user
           export PGPASSWORD=postgres_password
           apptainer run --app psql instance://postgres_server -c 'create database test;'
           apptainer run --app psql instance://postgres_server -c '\l'

The definition file has couple of new blocks:

- ``%startscript``: This block defines what commands will be run when we start up the service.
- ``%apprun``: This block allows us to specify individual applications in our image. In this
  case we have an application called ``psql`` for the PostgreSQL client. This block specifies
  how we run this specific application.
- ``%apphelp``: Each app in a container can have it's own help section as well as other
  setup sections. See documentation for all possibilities.

For more information on how to specify multiple apps in a container, see
`this documentation page <https://apptainer.org/docs/user/latest/definition_files.html#scif-app-sections>`__.

After building the image we can start the database with:

.. code-block:: console

   $ mkdir postgres_data
   $ mkdir postgres_run
   $ export POSTGRES_USER=postgres_user
   $ export POSTGRES_PASSWORD=postgres_password
   $ apptainer instance start --bind postgres_data:/var/lib/postgresql/data --bind postgres_run:/var/run/postgresql postgres_container.sif postgres_server


.. figure:: img/instance_example.png

   Figure 1: Starting container as an instance


Now that we have started the instance we can check that the instance is running with:

.. code-block:: console

   $ apptainer instance list

Let's use the ``psql``-app that we have specified. We can use it to make a
connection to the server and to create a new database. Let's also list the
newly created database:

.. code-block:: console

   $ export PGUSER=postgres_user
   $ export PGPASSWORD=postgres_password
   $ apptainer run --app psql instance://postgres_server -c 'create database test;'
   $ apptainer run --app psql instance://postgres_server -c '\l'

.. figure:: img/app_run_example.png

   Figure 2: Running an app from a container


You'll notice that we did not start a new container. Instead ran the application in
the running instance by specifying ``instance://postgres_server`` instead of the
``.sif``-image. You'll also note that we did not need to specify the bind-mounts
again: once the instance is started, bind mounts are made and they are there until
the instance is stopped.

We can then shut down the server with:

.. code-block:: console

   $ apptainer instance stop postgres_server

.. admonition:: Key points to remember

   - You can start containers as instances.
   - You can use ``%startscript``-block to specify how an instance should start.
   - You can create multiple apps in a container with ``%app*``-blocks
   - Started instances with bind mounts have them until instance is stopped.
     This is very useful if you plan on running multiple commands against a
     single container.
