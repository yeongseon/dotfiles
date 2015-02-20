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

[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set -x || set +x;
[ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set -v || set +v;

[ -z "${PS1}" ] && return;

trap "[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] || set +x; [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] set +v;" INT TERM EXIT;

trap 'logoutUser; exit' 0;

export PATH                         ; PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin";

[ -f /etc/environment ] && source /etc/environment > /dev/null 2>&1;
[ -f /etc/profile ] && source /etc/profile > /dev/null 2>&1;

## load profile
for PROFILE in ${HOME}/.profile.d/*
do
    [ -z "${PROFILE}" ] || [ ! -f "${PROFILE}" ] || [ "$(awk '{print substr($0, 0, 1)}' <<< "$(basename "${PROFILE}")")" != "P" ] && continue;

    typeset INPUT=$(echo $(basename "${PROFILE}") | awk '{print substr($0, 2, 2)}');

    case $([ ${INPUT} -ge 0 ] || [ ${INPUT} -lt 0 ] && echo 1 || echo 0) in
        1)
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
        [ -f ${HOME}/.alias ] && source ${HOME}/.alias;
        [ -f ${HOME}/.functions ] && source ${HOME}/.functions;
        ;;
    *)
        [ -f ${HOME}/.alias ] && source ${HOME}/.alias >| /dev/null 2>&1;
        [ -f ${HOME}/.functions ] && source ${HOME}/.functions >| /dev/null 2>&1;
        ;;
esac

[ ! -z "${INPUT}" ] && unset INPUT;
[ ! -z "${PROFILE}" ] && unset PROFILE;

[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "true" ] && set +x;
[ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "true" ] && set +v;

