#! /bin/bash

boxes=(basebox setupbox)
# productionbox stagebox developmentbox testbox)

set VAGRANT_LOG=DEBUG

boxes_build() {
  for box in ${boxes[@]}
  do
    pushd boxes/$box >/dev/null
    echo "[$box] vagrant status"
    vagrant status

    echo "[$box] vagrant up"
    vagrant up

    echo "[$box] vagrant status"
    vagrant status

    echo "[$box] vagrant halt"
    vagrant halt

    echo "[$box] vagrant status"
    vagrant status

    echo "[$box] vagrant package $box --output $box.box"
    vagrant package $box --output $box.box

    echo "[$box] vagrant box add $box $box.box"
    vagrant box add $box $box.box

    echo "[$box] finish building box"

    popd >/dev/null
    # other stuff on $name
  done
  echo "[boxes] finish: all boxes build for happy developers :)"
}

boxes_status() {
  for box in ${boxes[@]}; do
    pushd boxes/$box >/dev/null

    echo "[$box] vagrant status
    "
    vagrant status

    popd >/dev/null
    # other stuff on $name
  done
}

boxes_destroy() {
  for box in ${boxes[@]}; do
    pushd boxes/$box >/dev/null

    echo "[$box] vagrant destroy -f"
    vagrant status
    vagrant destroy -f

    popd >/dev/null
    # other stuff on $name
  done
}

boxes_start() {
  if [ -n $1 ]; then
    echo "pushd boxes/$1 >/dev/null"
    echo "vagrant up"
    echo "popd >/dev/null"
  else
    echo "Please chose one of them: $boxes"
  fi

}


boxes_status
#boxes_destroy
#boxes_start setupbox
#boxes_build