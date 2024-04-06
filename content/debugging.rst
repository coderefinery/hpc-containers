Debugging Containers
====================

.. objectives::

   * Understand the importance of being able to debug applications within container environments.
   * Learn to enter an Apptainer container using a shell for debugging purposes.
   * Develop practical troubleshooting skills for containerized applications in an HPC setting.

   This demo will instruct on how to access an Apptainer container with a shell interface to perform debugging and troubleshooting tasks. Debugging within containers is crucial because it allows developers and administrators to directly interact with the running environment and resolve issues that may not be apparent from outside the container.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * A container with a misbehaving application or one prepared for debugging.
   * Basic familiarity with command-line interface operations and debugging tools.

Containers encapsulate dependencies and environments but can sometimes obscure problems from the host system. By entering the container itself, you can use standard debugging tools and inspect the state of the application as it runs within its isolated environment.

First, we'll set up a simple container that includes tools and an application setup conducive to debugging. Then, we'll demonstrate how to enter this container to troubleshoot issues.

.. code-block::  bash
   # Example Apptainer definition file for a debuggable environment
   Bootstrap: library
   From: ubuntu:20.04
   
   %post
       apt-get update && apt-get install -y python3 python3-pip gdb vim
       pip3 install flask
       echo "from flask import Flask" > /app.py
       echo "app = Flask(__name__)" >> /app.py
       echo "@app.route('/')" >> /app.py
       echo "def hello():" >> /app.py
       echo "    raise Exception('Intentional Error for Debugging')" >> /app.py
       echo "if __name__ == '__main__':" >> /app.py
       echo "    app.run(host='0.0.0.0', port=5000, debug=True)" >> /app.py

   %environment
       export FLASK_APP=/app.py
   
   %runscript
       echo "Running Flask app with intentional errors for debugging..."
       python3 /app.py


.. code-block::  bash
   # Build the container for debugging
   apptainer build debug_container.sif debug.def


This block constructs the ``debug_container.sif`` from the ``debug.def`` file, which sets up a Flask application programmed to raise an exception. This setup is useful for demonstrating how to handle errors within a live application.

.. code-block::  bash
   # Enter the container with a shell to start debugging
   apptainer shell debug_container.sif


This command launches a shell within the ``debug_container.sif``, allowing you to interact directly with the container's environment. Inside the container, you can run the application, use tools like ``gdb`` or ``vim`` to inspect and modify files, or check logs to diagnose issues.

Summary
-------
In this tutorial, you've learned how to enter an Apptainer container with a shell for the purpose of debugging applications. This skill is essential for software development and system administration in containerized environments, particularly in HPC where applications may behave differently due to complex interactions with underlying hardware and software layers. By mastering container debugging, you can significantly improve the reliability and performance of your applications.

