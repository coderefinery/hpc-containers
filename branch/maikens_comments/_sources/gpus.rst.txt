Running containers that use GPUs
================================

.. objectives::

   * Learn how you can use GPUs with containers

If your program uses GPUs, you'll need to make the GPUs visible in
the container. This is done by giving additional flag to the
apptainer command.

The container itself must have the correct GPU computing libraries
installed inside the image (CUDA toolkit for NVIDIA and ROCm for AMD).
Code inside the image needs to be installed with GPU support as well.
Apptainer will only mount the driver libraries and the GPU devices
that these toolkits need to run the code on GPUs.

Using NVIDIA's GPUs
*******************

When using NVIDIA's GPUs that use the CUDA-framework the flag is ``--nv``.

As an example, let's get a CUDA-enabled PyTorch-image:

.. code-block:: console

   $ apptainer pull pytorch-cuda.sif docker://docker.io/pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime

Now when we launch the image, we can give the image GPU access with

.. code-block:: console

   $ apptainer exec --nv pytorch-cuda.sif python -c 'import torch; print(torch.cuda.is_available())'

.. figure:: img/nv_example.png

   Figure 1: Enabling NVIDIA's GPUs in containers

.. admonition:: Expected result
   :class: dropdown

   If you run this in a system with an NVIDIA GPU, you should see the following result:

   .. code-block:: console

      $ apptainer exec --nv pytorch-cuda.sif python -c 'import torch; print(torch.cuda.is_available())'
      True

.. admonition:: Key points to remember

   - Code inside the container image needs to support GPU calculations.
   - Container image should have a working CUDA toolkit installed.
   - Use ``--nv``-flag to mount the device drivers inside of the image.


Using AMD's GPUs
****************

When using AMD's GPUs that use the ROCm-framework the flag is ``--rocm``.

As an example, let's get a ROCm-enabled PyTorch-image:

.. code-block:: console

   $ apptainer pull pytorch-rocm.sif docker://docker.io/rocm/pytorch:rocm6.1_ubuntu22.04_py3.10_pytorch_2.1.2

Now when we launch the image, we can give the image GPU access with

.. code-block:: console

   $ apptainer exec --rocm pytorch-rocm.sif python -c 'import torch; print(torch.cuda.is_available())'

.. figure:: img/rocm_example.png

   Figure 2: Enabling AMD's GPUs in containers


.. admonition:: Expected result
   :class: dropdown

   If you run this in a system with an AMD GPU, you should see the following result:

   .. code-block:: console

      $ apptainer exec --rocm pytorch-rocm.sif python -c 'import torch; print(torch.cuda.is_available())'
      True

.. admonition:: Key points to remember

   - Code inside the container image needs to support GPU calculations.
   - Container image should have a working ROCm toolkit installed.
   - Use ``--rocm``-flag to mount the device drivers inside of the image.
