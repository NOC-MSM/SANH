# South Asian Nitrogen Hub (SANH) NEMO regional model

![Bathymetry for SANH domain](https://github.com/NOC-MSM/SANH/wiki/FIGURES/SANH_bathy.png)


Repository contents
===================

This repository contains the scripts and initialisation files to run NEMO for the SANH model configuration. This contains instructions for:

* setting up the required paths and file directory structure
* downloading and compiling xios
* downloading and compiling NEMO 
* downloading the reanalysis (CMEMS) and forcing (ERA5) data
* installing PyNEMO
* setting up the SANH domain
* creating the initial conditions (ICS), ocean boundary conditions (OBC) and forcing data
* running NEMO for the SANH model domain 

Getting started
===============

**Clone** this repository onto your favourite linux box:

<pre>
  git clone https://github.com/NOC-MSM/SANH.git
</pre>

Large data files are stored on the Jasmin sci servers, found here: 

<pre>
  /gws/nopw/j04/accord/SANH
</pre>

File Hierarchy 
==============
Recommend the following file structure

<pre>
  SANH
  |
  |__JASMIN_TRANSFER
  |__EXTRA_TOOLS
  |__MY_SRC
  |__SCRIPTS
  |
  |__README.md
</pre>

 
