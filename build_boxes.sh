#! /bin/bash

boxes=(basebox setupbox)
# productionbox stagebox developmentbox testbox)

# set VAGRANT_LOG=DEBUG

boxes_list() {
  echo "boxes: ${boxes[@]}"
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

    echo "$echo_this vagrant status"
    #vagrant status

    echo "$echo_this vagrant up"
    #vagrant up

    echo "$echo_this vagrant status"
    #vagrant status

    echo "$echo_this vagrant halt"
    #vagrant halt

    echo "$echo_this vagrant status"
    #vagrant status

    echo "$echo_this vagrant package $box --output $box.box"
    #vagrant package $box --output $box.box

    echo "$echo_this vagrant box add $box $box.box"
    #vagrant box add $box $box.box

  popd >/dev/null

}

boxes_build() {
  echo "[boxes_build] start: building boxes"
  for box in ${boxes[@]}; do

    box_build $box

  done
  echo "[boxes_build] finish: all boxes build for happy developers"
}

box_start() {
  box="$1"
  pushd boxes/$box >/dev/null
    vagrant up
  popd >/dev/null
}


boxes_status() {
  for box in ${boxes[@]}; do
    pushd boxes/$box >/dev/null

    echo "[$box] vagrant status"
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

start2() {
  if [ ! -n "$1" ]; then
    echo "Please specify what you want to do."
    exit
  fi

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
    'destroy')
      box_destroy $3
      ;;
    'status')
      box_status $3
      ;;
    *)
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
      *)
        ;;
      esac
    ;;
  'base')
    case "$2" in
    'delete')
      base_delete $3
      ;;
    *)
      ;;
    esac
    ;;
  *)
    ;;
  esac
}




start() {

 if [ ! -n "$1" ]; then
    echo "Please specify what you want to do."
    exit
 fi

 case "$1" in

 'build')
    #echo "Would call boxes_build"

    case "$2" in
    'box')

      if [ ! -n "$3" ]; then
        echo "Usage: build box <boxname>"
        boxes_list
        exit
      fi

      echo "Building box $3"

      box_build $3

      ;;
    'boxes')
      echo "Would build all boxes"
      boxes_build
      ;;
    *)
      echo "Please specify what you want to build."
      ;;
    esac
    ;;
 'start')
    echo "Would call boxes_start"
    case "$2" in
        'box')
          echo "Start box"
          ;;
    ;;
 'destroy')
    echo "Would call boxes_destroy"
    ;;
 *)
    echo "Nothing to do here!"
    ;;
 esac
}

echo "\$1: $1"
echo "\$2: $2"
echo "\$3: $3"

start $@
#boxes_status
#boxes_destroy
#boxes_start setupbox
#boxes_build