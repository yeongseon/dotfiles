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

trap "[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] || set +x; [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] set +v;" INT TERM EXIT;

trap 'logoutUser; exit' 0;

typeset -x PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin";

## load profile
for PROFILE in ${HOME}/.profile.d/*
do
    [ -z "${PROFILE}" ] && continue;

    if [ ! -d "${PROFILE}" ]
    then
    	case $([ ! -z "$(awk -F "/" '{print $NF}' <<< "${PROFILE}" | egrep "^P([0-9]{1,3})-.*")" ] && echo "0") in
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
    else
        for PROFILE1 in ${HOME}/.profile.d/*
	do
	    [ -z "${PROFILE1}" ] && continue;

	    if [ -f "${PROFILE1}" ]
	    then
		case $([ ! -z "$(awk -F "/" '{print $NF}' <<< "${PROFILE1}" | egrep "^P([0-9]{1,3})-.*")" ] && echo "0") in
		    0)
			case "${ENABLE_VERBOSE}" in
			    "${_TRUE}")
				. ${PROFILE1};
				;;
			    *)
				. ${PROFILE1} >| /dev/null 2>&1;
				;;
			esac
			;;
		esac
	    fi

	    [ ! -z "${PROFILE1}" ] && unset PROFILE1;
	done
    fi

    [ ! -z "${PROFILE1}" ] && unset PROFILE1;
    [ ! -z "${PROFILE}" ] && unset PROFILE;
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

## system information
typeset HOST_SYSTEM_NAME="$(/usr/bin/env hostname -f | /usr/bin/env tr '[A-Z]' '[a-z]')";
typeset HOST_IP_ADDRESS="$(/usr/bin/env ip addr show 2>/dev/null | grep inet | grep -v "127.0.0.1/8" | head -1 | awk '{print $2}')";
typeset HOST_KERNEL_VERSION="$(/usr/bin/env uname -r)";
typeset -i HOST_CPU_COUNT=$(/usr/bin/env cat /proc/cpuinfo | /usr/bin/env grep "model name" | /usr/bin/env wc -l);
typeset HOST_CPU_INFO="$(/usr/bin/env cat /proc/cpuinfo | /usr/bin/env grep "model name" | /usr/bin/env uniq | /usr/bin/env cut -d ":" -f 2 | /usr/bin/env sed -e 's/^ *//g;s/ *$//g' | /usr/bin/env tr -s " ")";

case $(/usr/bin/env echo "scale=2; $(/usr/bin/env grep MemTotal /proc/meminfo | /usr/bin/env awk '{print $2}') / 1024 ^ 2" | /usr/bin/env bc | cut -d "." -f 1) in
    0)
        typeset HOST_MEMORY_SIZE="$(/usr/bin/env echo "scale=2; $(/usr/bin/env grep MemTotal /proc/meminfo | /usr/bin/env awk '{print $2}') / 1024" | /usr/bin/env bc) MB"
        ;;
    *)
        typeset HOST_MEMORY_SIZE="$(/usr/bin/env echo "scale=2; $(/usr/bin/env grep MemTotal /proc/meminfo | /usr/bin/env awk '{print $2}') / 1024 ^ 2" | /usr/bin/env bc) GB"
        ;;
esac

[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "HOST_SYSTEM_NAME -> ${HOST_SYSTEM_NAME}";
[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "HOST_DOMAIN_NAME -> ${HOST_DOMAIN_NAME}";
[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "HOST_IP_ADDRESS -> ${HOST_IP_ADDRESS}";
[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "HOST_KERNEL_VERSION -> ${HOST_KERNEL_VERSION}";
[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "HOST_CPU_COUNT -> ${HOST_CPU_COUNT}";
[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "HOST_CPU_INFO -> ${HOST_CPU_INFO}";
[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "HOST_MEMORY_SIZE -> ${HOST_MEMORY_SIZE}";

## user information
typeset -i USER_DISK_USAGE=$(/usr/bin/env du -ms ${HOME}/ | /usr/bin/env awk '{print $1}');
typeset -i SYSTEM_PROCESS_COUNT=$(/usr/bin/env ps -ef | /usr/bin/env wc -l | awk '{print $1}');
typeset -i USER_PROCESS_COUNT=$(/usr/bin/env ps -ef | /usr/bin/env grep "${LOGNAME}" | /usr/bin/env wc -l);

[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "USER_DISK_USAGE -> ${USER_DISK_USAGE}";
[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "SYSTEM_PROCESS_COUNT -> ${SYSTEM_PROCESS_COUNT}";
[ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "true" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "USER_PROCESS_COUNT -> ${USER_PROCESS_COUNT}";

clear;

printf "\n";
printf "%s\n" "+-------------------------------------------------------------------+";
printf "%40s\n" "Welcome to ${HOST_SYSTEM_NAME}";
printf "%s\n" "+-------------------------------------------------------------------+";
printf "%s\n" "+---------------------- System Information -------------------------+";
printf "%-14s : %-10s\n" "+ IP Address" "${HOST_IP_ADDRESS}";
printf "%-14s : %-10s\n" "+ Kernel version" "$(uname -r)";
printf "%-14s : %-10s\n" "+ CPU" "${HOST_CPU_COUNT} / ${HOST_CPU_INFO}";
printf "%-14s : %-10s\n" "+ Memory" "${HOST_MEMORY_SIZE}";
printf "%s\n" "+-------------------------------------------------------------------+";
printf "\n";
printf "%s\n" "+----------------------- User Information --------------------------+";
printf "%-14s : %-10s\n" "+ Username" "${LOGNAME}";
printf "%-14s : %-10s %sMB %s\n" "+ Disk Usage" "You're currently using" "${USER_DISK_USAGE}" "in ${HOME}";
printf "%-14s : %s of which %s are yours\n" "+ Processes" "${SYSTEM_PROCESS_COUNT}" "${USER_PROCESS_COUNT}";
printf "+-------------------------------------------------------------------+";
printf "\n";

[ ! -z "${HOST_SYSTEM_NAME}" ] && unset HOST_SYSTEM_NAME;
[ ! -z "${HOST_DOMAIN_NAME}" ] && unset HOST_DOMAIN_NAME;
[ ! -z "${HOST_IP_ADDRESS}" ] && unset HOST_IP_ADDRESS;
[ ! -z "${HOST_KERNEL_VERSION}" ] && unset HOST_KERNEL_VERSION;
[ ! -z "${HOST_CPU_COUNT}" ] && unset HOST_CPU_COUNT;
[ ! -z "${HOST_CPU_INFO}" ] && unset HOST_CPU_INFO;
[ ! -z "${HOST_MEMORY_SIZE}" ] && unset HOST_MEMORY_SIZE;
[ ! -z "${USER_DISK_USAGE}" ] && unset USER_DISK_USAGE;
[ ! -z "${SYSTEM_PROCESS_COUNT}" ] && unset SYSTEM_PROCESS_COUNT;
[ ! -z "${USER_PROCESS_COUNT}" ] && unset USER_PROCESS_COUNT;

[ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "true" ] && set +x;
[ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "true" ] && set +v;
