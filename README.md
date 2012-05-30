puppet-boxes
============

Puppet and Vagrant Boxes building a development, testing and staging flow

The application development workflow will be supported by a setup of virtual 
machines "boxes". Each box will have its purpose and its predecessor in order to develop easily
for the webstack.

[BASE BOX]
--------
The base box will download the first base_box from puppetlabs or your chosen url.
Everything that needs to be prepared before all the software will be setup will happen in this step.

[SETUP BOX]
--------
The setup box will take the BASE BOX, install all needed packages and setup users and directories.

In this case:
- Apache2.2
- PHP 5.3 / 5.4
- MySQL (datastorage will go to its own vm, in v2)

[PRODUCTION BOX]
--------
The production box takes the SETUP BOX and installs the application and sets
all the configuration to run it in production environment.

- Set users and rights for files and directories
- Create database user
- Deploy application (from git repo)

[STAGE BOX]
--------
The staging box takes the PRODUCTION BOX and sets up a configuration for.
If you have a symfony project this would represent your stage environment where you have everything setup
like in your production environment, but with profiling and other tools to see what will be deployed.

- translations
- profiling
- stuff that management or production wants to do or to see before going life

[DEVELOPMENT BOX]
--------
The development box takes the STAGE BOX and sets up the system for development. There will be a lot of tools needed.

- installing stuff
  - aptitude (I install stuff and put it then into this project after coding)
- text
  - vim
- debugging
  - XDebug
- shell
  - zShell
  - setup .bash_aliases
- git
  - git user setup (ssh agent forward)
  - git-core
  - git flow
  - gitk


[TEST BOX]
--------
The test box is for running all the tests. The test box takes the PRODUCTION BOX
We need all the software for running tests and reporting

- user acceptance tests
- unit tests
- functional tests


To work with this setup you do the following:

# clone project and edit to your likes.

Setup the BASE BOX
# go with terminal into boxes/basebox and run the command 'vagrant up'
# when it comes back with finished setting up the BASE BOX you stop the vm with 'vagrant halt'
# run 'vagrant package basebox --output basebox' to export the vm