#==============================================================================
#
#          FILE:  bashrc
#         USAGE:  . bashrc
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

[[ "$-" != *i* ]] || [ -z "${PS1}" ] && return;

[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set -x || set +x;
[ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set -v || set +v;

trap '[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] || set +x; [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] set +v; set -o noclobber' INT TERM EXIT;

trap 'logoutUser; exit' 0;

typeset -x PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin";

## load profile
for PROFILE in ${HOME}/.profile.d/*
do
    [ -z "${PROFILE}" ] || [ ! -f "${PROFILE}" ] || [ "$(awk '{print substr($0, 0, 1)}' <<< "$(basename "${PROFILE}")")" != "P" ] && continue;

    typeset INPUT=$(echo $(basename "${PROFILE}") | awk '{print substr($0, 2, 2)}');

    case $([ ! -z "$(echo "${INPUT}" | egrep "^[0-9]+$")" ] && echo "0") in
        0)
            case "${ENABLE_VERBOSE}" in
                "${_TRUE}")
                    . ${PROFILE};
                    ;;
                *)
                    . ${PROFILE} >| /dev/null 2>&1;
                    ;;
            esac
            ;;
    esac

    [ ! -z "${INPUT}" ] && unset INPUT;
    [ ! -z "${PROFILE}" ] && unset PROFILE;
done

case "${ENABLE_VERBOSE}" in
    "${_TRUE}")
        [ -f ${HOME}/.alias ] && . ${HOME}/.alias;
        [ -f ${HOME}/.functions ] && . ${HOME}/.functions;
        ;;
    *)
        [ -f ${HOME}/.alias ] && . ${HOME}/.alias >| /dev/null 2>&1;
        [ -f ${HOME}/.functions ] && . ${HOME}/.functions >| /dev/null 2>&1;
        ;;
esac

[ ! -z "${INPUT}" ] && unset INPUT;
[ ! -z "${PROFILE}" ] && unset PROFILE;

[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "true" ] && set +x;
[ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "true" ] && set +v;
