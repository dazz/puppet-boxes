# puppet-boxes


Puppet and Vagrant Boxes building a development, testing and staging flow.

The application development workflow will be supported by a setup of virtual machine "boxes". Each box will have its purpose and its predecessor in order to develop easily and fast for and in the web-stack (means web-applications, web- and mvc-frameworks, interfaces).

### In this document:

* [Getting started](#getting-started)
   * [Installation](#installation-pre-requisites)
   * [Setup the BASE BOX](#setup-the-base-box)
   * [Setup the SETUP BOX](#setup-the-setup-box)
* [About: The box model](#about-the-box-model)
   * [BASE BOX](#base-box)
   * [SETUP BOX](#setup-box)
   * [PRODUCTION BOX](#production-box)
   * [STAGE BOX](#stage-box)
   * [DEVELOPMENT BOX](#development-box)
   * [TEST BOX](#test-box)
* [Hints and tips](#hints-and-tips)
* [Future plans](#future-plans)
* [License](#license)

## Getting started

To work with this setup you do the following:

**To clarify**: I will not explain vagrant much or puppet or git or do know how host operating systems work. I will however try to explain how this virtualization box model works.

## Installation Pre-requisites

1. Install [vagrant](vagrantup.com)
1. Install [Virtualbox](https://www.virtualbox.org)
1. Clone $this project and edit to your likes:
1. Load all submodules from .gitmodules and get the [submodules][4] code from github

Linux / Mac:

        sudo apt-get install virtualbox
        sudo apt-get install vagrant
        git clone git://github.com/dazz/puppet-boxes.git
        git submodule init
        git submodule update

### Versioning (Optional)

* Install [git-flow (git branching model)](http://nvie.com/posts/a-successful-git-branching-model/)
* [Initialize with git-flow](http://yakiloo.com/getting-started-git-flow/)
* Create a new feature/<branch_name> to start customizing the project to your likes to make a pull request later.

### Adding new puppet modules to the project

        git submodule add <repo> modules/<modulename>

To see all modules:

        git submodule status

## Setup the boxes with build_boxes.sh

Go with terminal into `<project_dir>` and run

        ./build_boxes boxes build

Thats it.

## Setup the boxes manually (with the first box as example)

### first start of vm with vagrant

Go with terminal into `<project_dir>/boxes/basebox` and run all the commands in this directory.

        vagrant up

Vagrant will run with the Vagrantfile, download the box from the specified box_url and add it to vagrants boxes (see all with `vagrant box list`). Run the provisioner Puppet startting with the manifest.pp in the same directory (this is how we do it for every box).

Vagrant will start a virtual machine in Virtualbox with

* IP: 192.168.23.42
* User: vagrant, password: vagrant

You can have a look with `vagrant ssh`(Linux and Mac) but don't touch anything yet, we are not finished :)

### Packing the first box

**Linux:** There is a bug that the VM 'remembers' the previously set mac-address of VM. So when you reuse or copy it, it still knows it's copied. See fix [here](https://github.com/dazz/puppet-boxes#networking).

When the vagrant comes back with finished setting up the BASE BOX you stop the vm with

        vagrant halt

Run following to package the vm as box. Vagrant will package the vm as a box and put it into the directory that xou are in.

        vagrant package basebox --output basebox.box

**Tip:** (add `*.box` to your .gitignore)

### Adding first box as a base box

        vagrant box add basebox basebox.box

We add it to the other vagrant boxes so we can reference it as base in another Vagrantfile. If you have a look in `~/.vagrant.d/boxes/` there should now be the basebox folder with your previous packed box.

# About: The box model

## BASE BOX

The base box will download the first base box from puppetlabs or your chosen url. Everything that needs to be prepared before all the software will be setup will happen in this step.

You can set your own url here with `basebox.vm.box_url`, but make sure that you do not maintain this box to stay clear of your project scope. it ends here.

## SETUP BOX

The setup box will take the BASE BOX, install all needed packages and setup users and directories.

In this case:

* Apache2.2
* PHP 5.3 / 5.4
* MySQL (datastorage will go to its own vm, in v2)

## PRODUCTION BOX

The production box takes the SETUP BOX and installs the application and sets all the configuration to run it in production environment.

* Set users and rights for files and directories
* Create database user
* Deploy application (from git repo)

## STAGE BOX

The staging box takes the PRODUCTION BOX and sets up a configuration for. If you have a symfony project this would represent your stage environment where you have everything setup like in your production environment, but with profiling and other tools to see what will be deployed.

* translations
* profiling
* stuff that management or production wants to do or to see before going life

## DEVELOPMENT BOX

The development box takes the stagebox and sets up the system for development. There will be a lot of tools needed.

* installing stuff: aptitude (I install stuff and put it then into this project after coding)
* text editing: vim
* debugging: xdebug
* shell: zShell, setup .bash_aliases
* git
   * git user setup (ssh agent forward)
   * git-core
   * [git flow](https://github.com/nvie/gitflow)
   * gitk


## TEST BOX

The test box is for running all the tests. The test box takes the PRODUCTION BOX. We need all the software for running tests and reporting

* user acceptance tests
* unit tests
* functional tests


# Future plans

Now we have the setupbox as base box for every iteration we want to do next:

* PRODUCTION BOX
* STAGE BOX and finally the
* DEVELOPER BOX

In the first two stages we won't do anything by hand, but let machines to the work. How many iterations you will need to have a production close environment to develop in depends on your usecase or the company you work for.

# Hints and tips

## Networking

### [udev][5]
There is a problem with machines of the Debian osfamily with writing the mac-address.
Fixed this with the basebox with deleting the generated and its generator file.


# License

   Copyright 2012 Anne-Julia Scheuermann

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.


[1]: http://askubuntu.com/questions/9375/new-mac-address-now-i-have-no-network-access
[2]: http://www.artwork.com/support/linux/eth0_configuration.htm
[3]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1032790
[4]: http://chrisjean.com/2009/04/20/git-submodules-adding-using-removing-and-updating/
[5]: http://www.ducea.com/2008/09/01/remove-debian-udev-persistent-net-rules/