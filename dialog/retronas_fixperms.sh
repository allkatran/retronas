#!/bin/bash

set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

rn_get_dirs() {
  COUNT=3
  cd "${OLDRNPATH}"
  find . -maxdepth 1 -type d | sed 's#^\./##g' | grep -v ^\.$ | sort | while read PATHITEM
  do
    echo "${PATHITEM}" "${PATHITEM}"
    COUNT=$((${COUNT}+1))
  done
}

rn_fix_perms() {
  cd ${DIDIR}

  local MENU_ARRAY=(
    1 "Back"
    all "ALL"
    $(rn_get_dirs)
  )

  local MENU_BLURB="\nPlease choose a directory below ${OLDRNPATH} to fix. \
  \n\nThis will reset all the file ownership to the user \"${OLDRNUSER}\" \
  \n\nPlease be careful, as this is irreversible.  If unsure, exit now."

  DLG_MENU "Fix Permissions" $MENU_ARRAY 10 "${MENU_BLURB}" 
}

CLEAR
rn_fix_perms
case ${CHOICE} in
  1)
    EXIT_OK
    ;;
  *)
    CLEAR
    bash $SCDIR/static/permissions.sh ${CHOICE}
    PAUSE
    ;;
esac
