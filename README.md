puppet-boxes
============

Puppet and Vagrant Boxes building a development, testing and staging flow

The applikation development worklow will be supported by a setup of virtual machines "boxes". Each box will have its purpose in order to develop easily for the webstack.

[SETUP_BOX]
The setup box will take a defined Vagrant base_box (and download it if it does not exist, install all packages and setup users and directories.

- Apache2.2
- PHP 5.3 / 5.4
- MySQL

[PRODUCTION_BOX]
The production box takes the SETUP_BOX and installs the application and sets all the configuration to run it in production environment.

- 

[STAGE_BOX]
The staging box takes the PRODUCTION_BOX and sets up a configuration for

- translations
- user acceptance tests

[DEVELOPMENT_BOX]
The development box takes the STAGE_BOX and sets up the system for development. There will be a lot of tools needed.

- XDebug
- zShell
- setup .bash_aliases
- git


[TEST BOX]