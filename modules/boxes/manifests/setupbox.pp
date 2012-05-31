class boxes::setupbox {

    notice("boxes::setupbox install apache and php")
    apache::php

    notice("boxes::setupbox install mysql")
    include mysql

}