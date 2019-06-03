# NEMO_cfgs
NEMO BoBEAS configuration

** IN ORDER TO FINISH THE DELIVERABLES I AM RESTRUCTING THIS REPO. SO THIS IS W.I.P**

** BRANCH:ashbre contains the original structure **

Getting started
===============

**Clone** this repository onto your favourite linux box::

  git clone git@github.com:NOC-MSM/BoBEAS.git

Access **JASMIN data**. For JASMIN file structure see wiki page: JASMIN_data_storage). On your favourite linux box::

  ``exec ssh-agent $SHELL``
  
  ``ssh-add ~/.ssh/id_rsa_jasmin``

On request enter passphrase for ``/login/$USER/.ssh/id_rsa_jasmin``. Hopefully this
is accepted. Then successively log into a login node. This can not see the BoBEAS data::

  ``ssh -A jelt@jasmin-login1.ceda.ac.uk``

From here you can hop to a compute node, which can see the BoBEAS data::

  ``ssh -A jelt@jasmin-sci1.ceda.ac.uk``

  ``cd /gws/nopw/j04/campus/pseudoDropBox/BoBEAS``

File Hierarchy
==============

Each configuration directory should be laid out in the following manner, to
facilitate configuration archival and sharing:

<pre>
BoBEAS
|
|____README.md
|
|____stuff
</pre>
