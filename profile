#==============================================================================
#
#          FILE:  profile
#         USAGE:  . profile
#   DESCRIPTION:  Sets application-wide functions
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Kevin Huntly <kmhuntly@gmail.com>
#       COMPANY:  ---
#       VERSION:  1.0
#       CREATED:  ---
#      REVISION:  ---
#
#==============================================================================

[ ! -z "${ENABLE_VERBOSE}" -a "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set -x || set +x;
[ ! -z "${ENABLE_TRACE}" -a "${ENABLE_TRACE}" = "${_TRUE}" ] && set -v || set +v;

trap '[ ! -z "${ENABLE_VERBOSE}" -a "${ENABLE_VERBOSE}" = "${_TRUE}" ] || set +x; [ ! -z "${ENABLE_TRACE}" -a "${ENABLE_TRACE}" = "${_TRUE}" ] set +v; set -o noclobber' INT TERM EXIT;

typeset -x ENV=${HOME}/.bin/profile;

[ ! -z "${ENABLE_VERBOSE}" -a "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set -x || set +x;
[ ! -z "${ENABLE_TRACE}" -a "${ENABLE_TRACE}" = "${_TRUE}" ] && set -v || set +v;
