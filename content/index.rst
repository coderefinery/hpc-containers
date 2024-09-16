Containers on HPC with Apptainer
================================

.. admonition:: Course instance in May 2024

   You can follow the dates this course is given on the `course page
   <https://scicomp.aalto.fi/training/scip/workflows-2023/>`__.
   Dates are not yet known and registration is not yet open, though.


Improve your cluster workflows!  You've had a basic course on working
with a cluster - but what do people *actually* do? This course shows
practical examples and tips which may help you, but aren't usually
covered in either basic or advanced courses.

We won't go so deep into each topic that you know everything about it,
but you learn what is possible, see some examples, and know where to
follow up on the tools that are right for *you*.  The format is
designed to be "fireside chat with experts", a combination of demos,
type-along, and independent exercises.  You can engage at different
levels, depending on your interest.


.. prereq::

   * Basic HPC usage course (if you don't have, many of the things we
     talk about won't make sense, but you might pick up something
     anyway).
   * A bit of experience using a HPC cluster (technically optional,
     but will allow you to engage with the material at a deeper
     level).
   * Access to some HPC computer cluster to do most exercises.
     (Slurm-based, but most are these days).  (If you don't have, you
     can't do all exercises - but still might learn something!)


.. csv-table::
   :widths: auto
   :delim: ;

   15 min ; :doc:`intro_and_motivation`
   20 min ; :doc:`basics_running_containers`
   15 min ; :doc:`container_images`
   10 min ; Break
   25 min ; :doc:`building_images`
   15 min ; :doc:`binding_folders`
   05 min ; Open discussion and where to go next


.. toctree::
   :maxdepth: 1
   :caption: The lesson

   intro_and_motivation.rst
   basics_running_containers.rst
   container_images.rst
   building_images.rst
   binding_folders.rst


.. toctree::
   :maxdepth: 1
   :caption: Extras

   sharing
   gpus.rst
   services_apps.rst
   tips_tricks.rst



.. toctree::
   :maxdepth: 1
   :caption: Exercises

   verify_installation.rst
   first_build.rst
   python_exercise.rst



.. _learner-personas:

Who is the course for?
----------------------

This course is for people using clusters or other larger computing
resources.  It's not a basic course, but also not extremely advanced.
It lets you see some examples and know what people actually do, and
then you can follow up with more reading, courses, or direct help
later on.

Some learner personas:

- You've just taken a basic HPC course, and while you mostly
  understand how the basic pices work, you are left wondering *"How
  does this all fit together?  How do people combine all of these
  tools into an actual whole workflow?"*.

  You care about some real examples and things you can use right now,
  but wouldn't mind seeing some advanced or out-of-scope stuff as long
  as you don't have to spend too much mental effort on it.

  You'll probably do the more basic exercises and watch the rest as a
  demo until you come back to it later (if needed).

- You've been using the cluster for a while and doing your work just
  fine - or so you think.  It works well, but you know there must be
  some other tricks out there that can make your life (if not work)
  even better.

  You'll probably attend and do the more advanced exercises, while
  passively watching some of the more basic demos.


About the course
----------------

This lesson is part of `Tuesday Tools & Techniques for High Performance Computing <https://scicomp.aalto.fi/training/scip/ttt4hpc-2024/>`_.
