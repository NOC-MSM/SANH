==============================================================================
Setting up a Bay of Bengal and East Arabian Sea (BoBEAS) NEMO v4 configuration
==============================================================================

Machines: ARCHER

archer$

Set up and move into new config space::

  cd /work/n01/n01/$USER
  mkdir BoBEAS
  cd BoBEAS

Get Git Repo::

  git clone https://github.com/NOC-MSM/BoBEAS.git

Run master script::

  cd BoBEAS/SCRIPTS
  . main1.sh
