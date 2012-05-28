class boxes::setupbox {

    include php

    include apache
    include apache::php

    include php::apache

    include mysql
}