puppet-boxes
============

Puppet and Vagrant Boxes building a development, testing and staging flow

The application development workflow will be supported by a setup of virtual 
machines "boxes". Each box will have its purpose and its predecessor in order to develop easily and fast
for and in the web-stack (means web-applications, web- and mvc-frameworks, interfaces).

[BASE BOX]
--------
The base box will download the first base box from puppetlabs or your chosen url.
Everything that needs to be prepared before all the software will be setup will happen in this step.

You can set your own url here with `basebox.vm.box_url`, but make sure that you do not maintain this
box to stay clear of your project scope. it ends here.

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
  - [git flow](https://github.com/nvie/gitflow)
  - gitk


[TEST BOX]
--------
The test box is for running all the tests. The test box takes the PRODUCTION BOX
We need all the software for running tests and reporting

- user acceptance tests
- unit tests
- functional tests

HOWTO
============
To work with this setup you do the following:

*To clarify*: I will not explain vagrant much or puppet or git or how your host operating system works.
I will however explain how this virtualization box model works.

1. Install [vagrant](vagrantup.com)

 * Linux: `sudo apt-get install vagrant`

2. Install [Virtualbox](https://www.virtualbox.org)

 * Linux: `sudo apt-get install virtualbox`

3. Clone $this project

Clone this project and edit to your likes:

 * `git clone git@github.com:dazz/puppet-boxes.git`
 * `git submodule init` (to load all submodules from .gitmodules) and
 * `git submodule update` (to get the [submodules][4] code from github)

4. Versioning

 * install [git-flow (git branching model)](http://nvie.com/posts/a-successful-git-branching-model/)
 * [initialize](http://yakiloo.com/getting-started-git-flow/)
 * create a new feature/<branch_name> to start customizing to your likes to make a pull request later

5. Setup the BASE BOX

 * Go with terminal into `<project_dir>/boxes/basebox` and run the command `vagrant up`
  * It will:
   * Run with included Vagrantfile,
   * Download the box from the specified box_url and add it to vagrants boxes (see all with `vagrant box list`)
   * Run the provisioner Puppet startting with the manifest.pp in the same directory (this is how we do it for every box)
  * Vagrant will start a virtual machine in Virtualbox with
   * IP: 192.168.23.42
   * User: vagrant, password: vagrant
  * You can have a look with `vagrant ssh`(Linux and Mac) but don't touch anything yet, we are not finished :)

 * When the vagrant comes back with finished setting up the BASE BOX you stop the vm with 'vagrant halt'

 * Run following to export the vm as base box for the next iteration, the SETUP BOX
  * mkdir -R ~/Development/puppet_boxes
  * `vagrant package basebox --output basebox.box` (add `*.box` to your .gitignore)
   * It will package the vm as a box
  * `vagrant box add basebox basebox.box`
   * We add it to the other vagrant boxes so we can reference it as base in another Vagrantfile
   * If you have a look in `~/.vagrant.d/boxes/` there should now be the basebox folder with your previous packed box

6. Setup the SETUP BOX

 * Do the same steps above but for the SETUP BOX:
 * cd `<project_dir>/boxes/setupbox`
 * `vagrant up` (Vagrant import the basebox we previously added)
 * if you don't see your machine with 192.168.23.24 you manually have to delete following:
    `sudo rm /etc/udev/rules.d/70-persistent-net.rules` and then run `vagrant up` again [source][1][2][3]
 * `vagrant halt`
 * `vagrant package setupbox --output setupbox.box`
 * `vagrant box add setupbox setupbox.box`

Now we have the setupbox as base box for every iteration we want to do next:

 * PRODUCTION BOX
 * STAGE BOX and finally the
 * DEVELOPER BOX

In the first two stages we won't do anything by hand, but let machines to the work.
How many iterations you will need to have a production close environment to develop in
depends on your usecase or the company you work for.


[1](http://askubuntu.com/questions/9375/new-mac-address-now-i-have-no-network-access) Can be fixed with static mac-address
[2](http://www.artwork.com/support/linux/eth0_configuration.htm)
[3](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1032790)
[4](http://chrisjean.com/2009/04/20/git-submodules-adding-using-removing-and-updating/)