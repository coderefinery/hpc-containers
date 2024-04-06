Running Web Applications
========================

.. objectives::

   * Understand how to configure and run web applications within Apptainer containers.
   * Learn to set up network settings that allow web applications to run effectively inside containers.
   * Develop skills to leverage container technology for deploying networked applications in an HPC environment.

   This demo will show you how to deploy a simple web application inside an Apptainer container, highlighting how to configure network settings to support web services. Running web applications in containers is a common scenario in many fields, including data science and web development, as it allows for scalable, consistent environments that are isolated from the host system.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * Basic knowledge of web technologies and network configurations.
   * Familiarity with container networking and security settings.

Containers provide a lightweight, efficient means of deploying web applications, ensuring that they run the same way on any system. This is particularly useful in HPC environments where maintaining consistency across numerous nodes is critical. In this demo, you will set up a basic Python web server inside an Apptainer container to explore this functionality.

First, we'll create a container definition file that includes a Python web application.

``` bash
# Example Apptainer definition file for a Python web server
Bootstrap: library
From: ubuntu:20.04

%post
    apt-get update && apt-get install -y python3 python3-pip
    pip3 install flask
    mkdir /webapp
    echo "from flask import Flask, request" > /webapp/app.py
    echo "app = Flask(__name__)" >> /webapp/app.py
    echo "@app.route('/', methods=['GET'])" >> /webapp/app.py
    echo "def home():" >> /webapp/app.py
    echo "    return 'Hello from Flask inside Apptainer!'" >> /webapp/app.py
    echo "if __name__ == '__main__':" >> /webapp/app.py
    echo "    app.run(host='0.0.0.0', port=5000)" >> /webapp/app.py

%environment
    export FLASK_APP=/webapp/app.py

%runscript
    echo "Starting the Flask web server..."
    python3 /webapp/app.py

```

``` bash
# Build the container for the web application
apptainer build webapp_container.sif webapp.def
```

This block constructs the `webapp_container.sif` from the `webapp.def` definition file, which sets up a basic Flask application in the container. The Flask server is configured to listen on all network interfaces at port 5000, allowing external access.

``` bash
# Run the container with network port mapping
apptainer exec --net --network-args "portmap=5000:5000/tcp" webapp_container.sif
```

This command runs the container with network settings that map port 5000 inside the container to port 5000 on the host. This setup allows you to access the Flask web server from outside the container, demonstrating the container's network capabilities.

Summary
-------
In this tutorial, you've learned how to set up and run a simple web application within an Apptainer container, configuring it to be accessible over a network. This capability is key for deploying scalable, reproducible web services across different computing environments, making it an essential skill for developers and system administrators working in HPC contexts.

