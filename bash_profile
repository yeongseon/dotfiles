#==============================================================================
#
#          FILE:  bash_profile
#         USAGE:  . bash_profile
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

trap "[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] || set +x; [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] set +v;" INT TERM EXIT;

trap 'logoutUser; exit' 0;

typeset -x PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin";

## load profile
for PROFILE in ${HOME}/.profile.d/*
do
    [ -z "${PROFILE}" ] && continue;

    if [ -d "${PROFILE}" ]
    then
        for PROFILE1 in ${HOME}/${PROFILE}
        do
            if [ ! -z "$(awk -F "/" '{print $NF}' <<< "${PROFILE1}" | egrep "^PA([0-9]{1,3})-.*")" ]
            then
    	        [ "${ENABLE_VERBOSE}" ] && . ${PROFILE1} || . ${PROFILE} >| /dev/null 2>&1;
    	    fi

            [ ! -z "${PROFILE1}" ] && unset -v PROFILE1;
    	done

        [ ! -z "${PROFILE}" ] && unset -v PROFILE;
    else
        if [ ! -z "$(awk -F "/" '{print $NF}' <<< "${PROFILE1}" | egrep "^PA([0-9]{1,3})-.*")" ]
        then
    	    [ "${ENABLE_VERBOSE}" ] && . ${PROFILE1} || . ${PROFILE} >| /dev/null 2>&1;
    	fi

        [ ! -z "${PROFILE1}" ] && unset -v PROFILE1;
        [ ! -z "${PROFILE}" ] && unset -v PROFILE;
    fi

    [ ! -z "${PROFILE1}" ] && unset PROFILE1;
    [ ! -z "${PROFILE}" ] && unset PROFILE;
done

if [ -d "${HOME}/.profile.d/profiles" ]
then
    for PROFILE in ${HOME}/.profile.d/profiles/*
    do
        [ -z "${PROFILE}" ] && continue;

        if [ ! -z "$(awk -F "/" '{print $NF}' <<< "${PROFILE1}" | egrep "^PA([0-9]{1,3})-.*")" ]
        then
            [ "${ENABLE_VERBOSE}" ] && . ${PROFILE1} || . ${PROFILE} >| /dev/null 2>&1;
        fi

        [ ! -z "${PROFILE}" ] && unset PROFILE;
    done
done

[ ! -z "${INPUT}" ] && unset INPUT;
[ ! -z "${PROFILE}" ] && unset PROFILE;

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

[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "true" ] && set +x;
[ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "true" ] && set +v;
