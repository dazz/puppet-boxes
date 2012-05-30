class boxes::setupbox {

    notice("boxes::setupbox install php")
    # include php

    # include apache
    # include apache::php

    notice("boxes::setupbox install php::apache")
    # include php::apache

    # include mysql
}