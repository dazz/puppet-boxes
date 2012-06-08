#! /bin/bash

boxes=(basebox setupbox)
# productionbox stagebox developmentbox testbox)

# set VAGRANT_LOG=DEBUG

boxes_list() {
  echo "boxes: ${boxes[@]}"
}

box_start() {
  box="$1"
  pushd boxes/$box >/dev/null
    vagrant up
  popd >/dev/null
}

box_status() {

  box="$1"

  pushd boxes/$box >/dev/null

  echo "[$box] vagrant status"
  vagrant status

  popd >/dev/null
}

boxes_status() {
  for box in ${boxes[@]}; do
    box_status $box
  done
}

box_destroy() {
  box="$1"
  pushd boxes/$box >/dev/null
    vagrant destroy -f
  popd >/dev/null
}

boxes_destroy() {
  for box in ${boxes[@]}; do
    box_destroy $box
  done
}

box_stop() {
  box="$1"
  pushd boxes/$box >/dev/null
    vagrant halt
  popd >/dev/null
}


boxes_stop() {
  for box in ${boxes[@]}; do
    box_stop $box
  done
}

box_base_destroy() {
  box="$1"
  pushd boxes/$box >/dev/null
    vagrant box remove $box
  popd >/dev/null
}

boxes_base_destroy() {
  for box in ${boxes[@]}; do
    box_base_destroy $box
  done
}

box_package() {
  box="$1"
  pushd boxes/$box >/dev/null
    vagrant package $box --output $box.box
  popd >/dev/null
}

box_add() {
  box="$1"
  pushd boxes/$box >/dev/null
    vagrant box add $box $box.box
  popd >/dev/null
}

box_build() {
  if [ -z "$1" ]; then
    echo "Please chose one of them: "
    boxes_list
    exit
  else
    echo "Starting to build box $1"
  fi

  box=""
  # set $box
  for check_box in ${boxes[@]}; do
    if [ "$1" = "$check_box" ]; then
      echo "Checking that box $check_box exists"
      box=$check_box
    fi
  done

  if [ ! -n "${box}" ]; then
    echo "The box you chose '$1' is not existing. Please edit enabled boxes or check that the box you want to build exists"
    boxes_list
    exit
  fi

  echo_this="[box_build][$box]"

  pushd boxes/$box >/dev/null

    box_status $box

    box_start $box

    box_stop $box

    rm $box.box

    box_package $box

    box_base_destroy $box

    box_add $box

  popd >/dev/null

}

boxes_build() {
  echo "[boxes_build] start: building boxes"
  for box in ${boxes[@]}; do

    box_build $box

  done
  echo "[boxes_build] finish: all boxes build for happy developers"
}

start() {

  case "$1" in
  'box')
    case "$2" in
    'build')
      box_build $3
      ;;
    'start')
      box_start $3
      ;;
    'stop')
      box_stop $3
      ;;
    'delete')
      box_delete $3
      ;;
    'status')
      box_status $3
      ;;
    'base')
      case "$3" in
      'destroy')
        box_base_destroy $4
        ;;
      *)
        echo "Usage: box base <option>
Options:
  - destroy    destroy base (must be added previously)
"
        ;;
      esac
      ;;
    *)
      echo "Usage: box <option>
Options:
  - build    build a box
  - start    start a box
  - stop     halt a box
  - delete   delete created box
  - status   show status of box
  - base     .. more options here
"
      ;;
    esac
    ;;
  'boxes')
    case "$2" in
    'build')
      boxes_build
      ;;
    'stop')
      boxes_stop
      ;;
    'destroy')
      boxes_destroy
      ;;
    'status')
      boxes_status
      ;;
    'base')
      case "$3" in
      'destroy')
        boxes_base_destroy
        ;;
      *)
        ;;
      esac
      ;;
    *)
    echo "Usage: boxes <option>
Options:
  - build    build all boxes
  - stop     halt all boxes
  - destroy  destroy all boxes
  - status   show status of all boxes
  - base     .. more options here
"
      ;;
    esac
    ;;
  *)
    echo "Usage: <option>
Options:
  - box
  - boxes
"
    ;;
  esac
}


echo "\$1: $1"
echo "\$2: $2"
echo "\$3: $3"
echo "\$4: $4"

start $@
#boxes_status
#boxes_destroy
#boxes_start setupbox
#boxes_build