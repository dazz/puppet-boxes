#! /bin/bash

boxes=(basebox setupbox productionbox stagebox developmentbox testbox)

#SET vagrant_info=DEBUG

boxes_build() {
  for box in ${boxes[@]}
  do
    pushd boxes/$box >/dev/null
    vagrant up
    vagrant halt
    vagrant package $box --output $box.box
    vagrant box add $box $box.box

    popd >/dev/null
    # other stuff on $name
  done
}

boxes_status() {

  for box in ${boxes[@]}
  do
    pushd boxes/$box >/dev/null

    vagrant status

    popd >/dev/null
    # other stuff on $name
  done

}

boxes_status
#boxes_build