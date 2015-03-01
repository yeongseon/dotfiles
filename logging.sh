#======  FUNTION  ===============================================================
#          NAME:  rotateLogsByTime
#   DESCRIPTION:  Rotates log files based on size or time.
#    PARAMETERS:  The log file name to take action against
#       RETURNS:  0 regardless of result.
#==============================================================================
function rotateLogsByTime
{
    trap '[ ! -z "${TEMPFILE}" ] && [ -f "${TEMPFILE}" ] && rm -f "${TEMPFILE}"; \
        [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] || set +x; [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set +v; set -o noclobber' INT TERM EXIT;

    [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set -x || set +x;
    [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set -v || set +v;

    set +o noclobber;
    typeset METHOD_NAME="${0}#${FUNCNAME[0]}";
    typeset -i RETURN_CODE=0;

    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} START: $(/usr/bin/env date +"${TIMESTAMP_OPTS}")";
    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i START_EPOCH=$(/usr/bin/env date +"%s");

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} -> enter";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "Provided arguments: ${*}";

    if [ ${#} -eq 0 ]
    then
        RETURN_CODE=3;

        writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} - Rotate provided log files based on timestamp";
        writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "Usage: ${METHOD_NAME} [ log ]
                -> The log file to rotate";

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";
        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} -> exit";

        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i END_EPOCH=$(/usr/bin/env date +"%s");
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i RUNTIME=$(( START_EPOCH - END_EPOCH ));
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} TOTAL RUNTIME: $(( RUNTIME / 60)) MINUTES, TOTAL ELAPSED: $(( RUNTIME % 60)) SECONDS";
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} END: $(/usr/bin/env date +"${TIMESTAMP_OPTS}")";

        [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
        [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
        [ ! -z "${LOG_FILE_NAME}" ] && unset LOG_FILE_NAME;
        [ ! -z "${DATESTAMP}" ] && unset DATESTAMP;
        [ ! -z "${ROLLOVER_CHECK}" ] && unset ROLLOVER_CHECK;
        [ ! -z "${BASE_FILE_NAME}" ] && unset BASE_FILE_NAME;
        [ ! -z "${FILE_STAT_TIME}" ] && unset FILE_STAT_TIME;
        [ ! -z "${CURRENT_NUMBER}" ] && unset CURRENT_NUMBER;
        [ ! -z "${ADD_NUMBER}" ] && unset ADD_NUMBER;
        [ ! -z "${METHOD_NAME}" ] && unset METHOD_NAME;

        [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set +x;
        [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set +v;

        return ${RETURN_CODE};
    fi

    typeset LOG_FILE_NAME="${LOG_ROOT}/${1}";
    typeset -i DATESTAMP=$(/usr/bin/env date +"%s");
    typeset -i ROLLOVER_CHECK=$(echo "${ROLLOVER_PERIOD} * 60 * 60" | bc);

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "A -> ${A}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "LOG_FILE_NAME -> ${LOG_FILE_NAME}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "DATESTAMP -> ${DATESTAMP}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ROLLOVER_CHECK -> ${ROLLOVER_CHECK}";

    if [ ! -f "${LOG_FILE_NAME}" ]
    then
        RETURN_CODE=1;

        writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";
        writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";
        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} -> exit";

        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i END_EPOCH=$(/usr/bin/env date +"%s");
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i RUNTIME=$(( START_EPOCH - END_EPOCH ));
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} TOTAL RUNTIME: $(( RUNTIME / 60)) MINUTES, TOTAL ELAPSED: $(( RUNTIME % 60)) SECONDS";
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} END: $(/usr/bin/env date +"${TIMESTAMP_OPTS}")";

        [ ! -z "${ARCHIVE_NUMBER}" ] && unset ARCHIVE_NUMBER;
        [ ! -z "${ARCHIVED_FILE}" ] && unset ARCHIVED_FILE;
        [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
        [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
        [ ! -z "${LOG_FILE_NAME}" ] && unset LOG_FILE_NAME;
        [ ! -z "${DATESTAMP}" ] && unset DATESTAMP;
        [ ! -z "${ROLLOVER_CHECK}" ] && unset ROLLOVER_CHECK;
        [ ! -z "${BASE_FILE_NAME}" ] && unset BASE_FILE_NAME;
        [ ! -z "${FILE_STAT_TIME}" ] && unset FILE_STAT_TIME;
        [ ! -z "${CURRENT_NUMBER}" ] && unset CURRENT_NUMBER;
        [ ! -z "${ADD_NUMBER}" ] && unset ADD_NUMBER;
        [ ! -z "${METHOD_NAME}" ] && unset METHOD_NAME;

        [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set +x;
        [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set +v;

        return ${RETURN_CODE};
    fi

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env basename \"${LOG_FILE_NAME}\"";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env stat -L --format %Y \"${LOG_FILE_NAME}\"";

    typeset BASE_FILE_NAME="$(/usr/bin/env basename "${LOG_FILE_NAME}")";
    typeset -i FILE_STAT_TIME=$(/usr/bin/env stat -L --format %Y "${LOG_FILE_NAME}");

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "BASE_FILE_NAME -> ${BASE_FILE_NAME}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "FILE_STAT_TIME -> ${FILE_STAT_TIME}";

    if [ ${FILE_STAT_TIME} -gt ${ROLLOVER_CHECK} ]
    then
        case "${ARCHIVE_ENABLED}" in
            "${_TRUE}")
                for ((A=0; A <= (( LOG_RETENTION_PERIOD + 1 )); A++))
                do
                    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "A -> ${A}";

                    if [ -f "${LOG_ROOT}/${BASE_FILE_NAME}.${A}" ]
                    then
                        typeset -i CURRENT_NUMBER=$(/usr/bin/env basename "${LOG_ROOT}/${BASE_FILE_NAME}.${A}" | cut -d "." -f 2);
                        typeset -i ADD_NUMBER=$(echo ${CURRENT_NUMBER} + 1 | bc);

                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "CURRENT_NUMBER -> ${CURRENT_NUMBER}";
                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ADD_NUMBER -> ${ADD_NUMBER}";

                        if [ -f "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}" ]
                        then
                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cp \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}\" \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\"";

                            /usr/bin/env cp "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}" "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}";

                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}\" | awk '{print $1}'";
                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\" | awk '{print $1}'";

                            typeset -i CURRENT_FILE_CKSUM=$(/usr/bin/env cksum "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}" | awk '{print $1}');
                            typeset -i ARCHIVE_FILE_CKSUM=$(/usr/bin/env cksum "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}" | awk '{print $1}');

                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "CURRENT_FILE_CKSUM -> ${CURRENT_FILE_CKSUM}";
                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVE_FILE_CKSUM -> ${ARCHIVE_FILE_CKSUM}";

                            if [ ${ARCHIVE_FILE_CKSUM} -ne ${CURRENT_FILE_CKSUM} ]
                            then
                                writeLogEntry "ERROR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A} and ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER} do NOT match";
                                writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A} and ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER} do NOT match";
                            fi

                            [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
                            [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
                        fi

                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cp \"${LOG_ROOT}/${BASE_FILE_NAME}.${A}\" \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\"";

                        /usr/bin/env cp "${LOG_ROOT}/${BASE_FILE_NAME}.${A}" "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}";

                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${LOG_ROOT}/${BASE_FILE_NAME}.${A}\" | awk '{print $1}'";
                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\" | awk '{print $1}'";

                        typeset -i CURRENT_FILE_CKSUM=$(/usr/bin/env cksum "${LOG_ROOT}/${BASE_FILE_NAME}.${A}" | awk '{print $1}');
                        typeset -i ARCHIVE_FILE_CKSUM=$(/usr/bin/env cksum "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}" | awk '{print $1}');

                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "CURRENT_FILE_CKSUM -> ${CURRENT_FILE_CKSUM}";
                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVE_FILE_CKSUM -> ${ARCHIVE_FILE_CKSUM}";

                        if [ ${ARCHIVE_FILE_CKSUM} -ne ${CURRENT_FILE_CKSUM} ]
                        then
                            writeLogEntry "ERROR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${LOG_ROOT}/${BASE_FILE_NAME}.${A} and ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER} do NOT match";
                            writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${LOG_ROOT}/${BASE_FILE_NAME}.${A} and ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER} do NOT match";
                        else
                            /usr/bin/env rm -f "${LOG_ROOT}/${BASE_FILE_NAME}.${A}";
                        fi
                    fi

                    [ ! -z "${CURRENT_NUMBER}" ] && unset CURRENT_NUMBER;
                    [ ! -z "${ADD_NUMBER}" ] && unset ADD_NUMBER;
                    [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
                    [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
                done

                ## clean up anything higher than the retention count
                for ARCHIVED_FILE in ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.*
                do
                    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVED_FILE -> ${ARCHIVED_FILE}";

                    [ -z "${ARCHIVED_FILE}" ] || [ ! -f "${ARCHIVED_FILE}" ] && continue || typeset -i ARCHIVE_NUMBER=$(awk -F "." '{print $NF}' <<< "${ARCHIVED_FILE}");

                    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVED_FILE -> ${ARCHIVED_FILE}";

                    [ ${ARCHIVE_NUMBER} -ge ${LOG_RETENTION_PERIOD} ] && rm -f "${ARCHIVED_FILE}";

                    [ ! -z "${ARCHIVE_NUMBER}" ] && unset ARCHIVE_NUMBER;
                    [ ! -z "${ARCHIVED_FILE}" ] && unset ARCHIVED_FILE;
                done
                ;;
        esac

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cp \"${LOG_ROOT}/${BASE_FILE_NAME}\" \"${LOG_ROOT}/${BASE_FILE_NAME}.0\"";

        /usr/bin/env cp "${LOG_ROOT}/${BASE_FILE_NAME}" "${LOG_ROOT}/${BASE_FILE_NAME}.0";

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${LOG_ROOT}/${BASE_FILE_NAME}.${A}\" | awk '{print $1}'";
        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\" | awk '{print $1}'";

        typeset -i CURRENT_FILE_CKSUM=$(/usr/bin/env cksum "${LOG_ROOT}/${BASE_FILE_NAME}" | awk '{print $1}');
        typeset -i ARCHIVE_FILE_CKSUM=$(/usr/bin/env cksum "${LOG_ROOT}/${BASE_FILE_NAME}.0" | awk '{print $1}');

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "CURRENT_FILE_CKSUM -> ${CURRENT_FILE_CKSUM}";
        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVE_FILE_CKSUM -> ${ARCHIVE_FILE_CKSUM}";

        if [ ${ARCHIVE_FILE_CKSUM} -ne ${CURRENT_FILE_CKSUM} ]
        then
            writeLogEntry "ERROR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${LOG_ROOT}/${BASE_FILE_NAME} and ${LOG_ROOT}/${BASE_FILE_NAME}.0 do NOT match";
            writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${LOG_ROOT}/${BASE_FILE_NAME} and ${LOG_ROOT}/${BASE_FILE_NAME}.0 do NOT match";
        fi

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cat /dev/null >| \"${LOG_FILE_NAME}\"";

        /usr/bin/env cat /dev/null >| "${LOG_FILE_NAME}";
    fi

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} -> exit";

    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i END_EPOCH=$(/usr/bin/env date +"%s");
    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i RUNTIME=$(( START_EPOCH - END_EPOCH ));
    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} TOTAL RUNTIME: $(( RUNTIME / 60)) MINUTES, TOTAL ELAPSED: $(( RUNTIME % 60)) SECONDS";
    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} END: $(/usr/bin/env date +"${TIMESTAMP_OPTS}")";

    [ ! -z "${ARCHIVE_NUMBER}" ] && unset ARCHIVE_NUMBER;
    [ ! -z "${ARCHIVED_FILE}" ] && unset ARCHIVED_FILE;
    [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
    [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
    [ ! -z "${LOG_FILE_NAME}" ] && unset LOG_FILE_NAME;
    [ ! -z "${DATESTAMP}" ] && unset DATESTAMP;
    [ ! -z "${ROLLOVER_CHECK}" ] && unset ROLLOVER_CHECK;
    [ ! -z "${BASE_FILE_NAME}" ] && unset BASE_FILE_NAME;
    [ ! -z "${FILE_STAT_TIME}" ] && unset FILE_STAT_TIME;
    [ ! -z "${CURRENT_NUMBER}" ] && unset CURRENT_NUMBER;
    [ ! -z "${ADD_NUMBER}" ] && unset ADD_NUMBER;
    [ ! -z "${METHOD_NAME}" ] && unset METHOD_NAME;

    [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set +x;
    [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set +v;

    return ${RETURN_CODE};
}

#======  FUNTION  ===============================================================
#          NAME:  rotateLogsBySize
#   DESCRIPTION:  Rotates log files based on size or time.
#    PARAMETERS:  The log file name to take action against
#       RETURNS:  0 regardless of result.
#==============================================================================
function rotateLogsBySize
{
    trap '[ ! -z "${TEMPFILE}" ] && [ -f "${TEMPFILE}" ] && rm -f "${TEMPFILE}"; \
        [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] || set +x; [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set +v; set -o noclobber' INT TERM EXIT;

    [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set -x || set +x;
    [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set -v || set +v;

    set +o noclobber;
    typeset METHOD_NAME="${0}#${FUNCNAME[0]}";
    typeset -i RETURN_CODE=0;

    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} START: $(/usr/bin/env date +"${TIMESTAMP_OPTS}")";
    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i START_EPOCH=$(/usr/bin/env date +"%s");

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} -> enter";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "Provided arguments: ${*}";

    if [ ${#} -eq 0 ]
    then
        RETURN_CODE=3;

        writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} - Rotate provided log files based on timestamp";
        writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "Usage: ${METHOD_NAME} [ log ]
                -> The log file to rotate";

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";
        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} -> exit";

        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i END_EPOCH=$(/usr/bin/env date +"%s");
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i RUNTIME=$(( START_EPOCH - END_EPOCH ));
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} TOTAL RUNTIME: $(( RUNTIME / 60)) MINUTES, TOTAL ELAPSED: $(( RUNTIME % 60)) SECONDS";
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} END: $(/usr/bin/env date +"${TIMESTAMP_OPTS}")";

        [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
        [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
        [ ! -z "${LOG_FILE_NAME}" ] && unset LOG_FILE_NAME;
        [ ! -z "${DATESTAMP}" ] && unset DATESTAMP;
        [ ! -z "${ROLLOVER_CHECK}" ] && unset ROLLOVER_CHECK;
        [ ! -z "${BASE_FILE_NAME}" ] && unset BASE_FILE_NAME;
        [ ! -z "${FILE_STAT_TIME}" ] && unset FILE_STAT_TIME;
        [ ! -z "${CURRENT_NUMBER}" ] && unset CURRENT_NUMBER;
        [ ! -z "${ADD_NUMBER}" ] && unset ADD_NUMBER;
        [ ! -z "${METHOD_NAME}" ] && unset METHOD_NAME;

        [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set +x;
        [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set +v;

        return ${RETURN_CODE};
    fi

    typeset LOG_FILE_NAME="${LOG_ROOT}/${1}";
    typeset -i DATESTAMP=$(/usr/bin/env date +"%s");

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "A -> ${A}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "LOG_FILE_NAME -> ${LOG_FILE_NAME}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "DATESTAMP -> ${DATESTAMP}";

    if [ ! -f "${LOG_FILE_NAME}" ]
    then
        RETURN_CODE=1;

        writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";
        writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";
        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} -> exit";

        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i END_EPOCH=$(/usr/bin/env date +"%s");
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i RUNTIME=$(( START_EPOCH - END_EPOCH ));
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} TOTAL RUNTIME: $(( RUNTIME / 60)) MINUTES, TOTAL ELAPSED: $(( RUNTIME % 60)) SECONDS";
        [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} END: $(/usr/bin/env date +"${TIMESTAMP_OPTS}")";

        [ ! -z "${ARCHIVE_NUMBER}" ] && unset ARCHIVE_NUMBER;
        [ ! -z "${ARCHIVED_FILE}" ] && unset ARCHIVED_FILE;
        [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
        [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
        [ ! -z "${LOG_FILE_NAME}" ] && unset LOG_FILE_NAME;
        [ ! -z "${DATESTAMP}" ] && unset DATESTAMP;
        [ ! -z "${ROLLOVER_CHECK}" ] && unset ROLLOVER_CHECK;
        [ ! -z "${BASE_FILE_NAME}" ] && unset BASE_FILE_NAME;
        [ ! -z "${FILE_STAT_TIME}" ] && unset FILE_STAT_TIME;
        [ ! -z "${CURRENT_NUMBER}" ] && unset CURRENT_NUMBER;
        [ ! -z "${ADD_NUMBER}" ] && unset ADD_NUMBER;
        [ ! -z "${METHOD_NAME}" ] && unset METHOD_NAME;

        [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set +x;
        [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set +v;

        return ${RETURN_CODE};
    fi

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env basename \"${LOG_FILE_NAME}\"";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env stat -L --format %Y \"${LOG_FILE_NAME}\"";

    typeset BASE_FILE_NAME="$(/usr/bin/env basename "${LOG_FILE_NAME}")";
    typeset -i MAX_FILE_SIZE=$(echo "scale=2; ${FILE_SIZE_LIMIT} / 1024" | bc);
    typeset -i FILE_STAT_SIZE=$(echo $(( $( /usr/bin/env stat -L --format %s "${LOG_FILE_NAME}" ) / 1024 / 1024 )));

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "BASE_FILE_NAME -> ${BASE_FILE_NAME}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "MAX_FILE_SIZE -> ${MAX_FILE_SIZE}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "FILE_STAT_SIZE -> ${FILE_STAT_SIZE}";

    if [ ${FILE_STAT_SIZE} -gt ${MAX_FILE_SIZE} ]
    then
        case "${ARCHIVE_ENABLED}" in
            "${_TRUE}")
                for ((A=0; A <= (( LOG_RETENTION_PERIOD + 1 )); A++))
                do
                    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "A -> ${A}";

                    if [ -f "${LOG_ROOT}/${BASE_FILE_NAME}.${A}" ]
                    then
                        typeset -i CURRENT_NUMBER=$(/usr/bin/env basename "${LOG_ROOT}/${BASE_FILE_NAME}.${A}" | cut -d "." -f 2);
                        typeset -i ADD_NUMBER=$(echo ${CURRENT_NUMBER} + 1 | bc);

                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "CURRENT_NUMBER -> ${CURRENT_NUMBER}";
                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ADD_NUMBER -> ${ADD_NUMBER}";

                        if [ -f "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}" ]
                        then
                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cp \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}\" \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\"";

                            /usr/bin/env cp "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}" "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}";

                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}\" | awk '{print $1}'";
                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\" | awk '{print $1}'";

                            typeset -i CURRENT_FILE_CKSUM=$(/usr/bin/env cksum "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A}" | awk '{print $1}');
                            typeset -i ARCHIVE_FILE_CKSUM=$(/usr/bin/env cksum "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}" | awk '{print $1}');

                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "CURRENT_FILE_CKSUM -> ${CURRENT_FILE_CKSUM}";
                            [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVE_FILE_CKSUM -> ${ARCHIVE_FILE_CKSUM}";

                            if [ ${ARCHIVE_FILE_CKSUM} -ne ${CURRENT_FILE_CKSUM} ]
                            then
                                writeLogEntry "ERROR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A} and ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER} do NOT match";
                                writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${A} and ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER} do NOT match";
                            fi

                            [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
                            [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
                        fi

                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cp \"${LOG_ROOT}/${BASE_FILE_NAME}.${A}\" \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\"";

                        /usr/bin/env cp "${LOG_ROOT}/${BASE_FILE_NAME}.${A}" "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}";

                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${LOG_ROOT}/${BASE_FILE_NAME}.${A}\" | awk '{print $1}'";
                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\" | awk '{print $1}'";

                        typeset -i CURRENT_FILE_CKSUM=$(/usr/bin/env cksum "${LOG_ROOT}/${BASE_FILE_NAME}.${A}" | awk '{print $1}');
                        typeset -i ARCHIVE_FILE_CKSUM=$(/usr/bin/env cksum "${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}" | awk '{print $1}');

                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "CURRENT_FILE_CKSUM -> ${CURRENT_FILE_CKSUM}";
                        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVE_FILE_CKSUM -> ${ARCHIVE_FILE_CKSUM}";

                        if [ ${ARCHIVE_FILE_CKSUM} -ne ${CURRENT_FILE_CKSUM} ]
                        then
                            writeLogEntry "ERROR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${LOG_ROOT}/${BASE_FILE_NAME}.${A} and ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER} do NOT match";
                            writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${LOG_ROOT}/${BASE_FILE_NAME}.${A} and ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER} do NOT match";
                        else
                            /usr/bin/env rm -f "${LOG_ROOT}/${BASE_FILE_NAME}.${A}";
                        fi
                    fi

                    [ ! -z "${CURRENT_NUMBER}" ] && unset CURRENT_NUMBER;
                    [ ! -z "${ADD_NUMBER}" ] && unset ADD_NUMBER;
                    [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
                    [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
                done

                ## clean up anything higher than the retention count
                for ARCHIVED_FILE in ${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.*
                do
                    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVED_FILE -> ${ARCHIVED_FILE}";

                    [ -z "${ARCHIVED_FILE}" ] || [ ! -f "${ARCHIVED_FILE}" ] && continue || typeset -i ARCHIVE_NUMBER=$(awk -F "." '{print $NF}' <<< "${ARCHIVED_FILE}");

                    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVED_FILE -> ${ARCHIVED_FILE}";

                    [ ${ARCHIVE_NUMBER} -ge ${LOG_RETENTION_PERIOD} ] && rm -f "${ARCHIVED_FILE}";

                    [ ! -z "${ARCHIVE_NUMBER}" ] && unset ARCHIVE_NUMBER;
                    [ ! -z "${ARCHIVED_FILE}" ] && unset ARCHIVED_FILE;
                done
                ;;
        esac

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cp \"${LOG_ROOT}/${BASE_FILE_NAME}\" \"${LOG_ROOT}/${BASE_FILE_NAME}.0\"";

        /usr/bin/env cp "${LOG_ROOT}/${BASE_FILE_NAME}" "${LOG_ROOT}/${BASE_FILE_NAME}.0";

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${LOG_ROOT}/${BASE_FILE_NAME}.${A}\" | awk '{print $1}'";
        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cksum \"${ARCHIVE_LOG_ROOT}/${BASE_FILE_NAME}.${ADD_NUMBER}\" | awk '{print $1}'";

        typeset -i CURRENT_FILE_CKSUM=$(/usr/bin/env cksum "${LOG_ROOT}/${BASE_FILE_NAME}" | awk '{print $1}');
        typeset -i ARCHIVE_FILE_CKSUM=$(/usr/bin/env cksum "${LOG_ROOT}/${BASE_FILE_NAME}.0" | awk '{print $1}');

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "CURRENT_FILE_CKSUM -> ${CURRENT_FILE_CKSUM}";
        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "ARCHIVE_FILE_CKSUM -> ${ARCHIVE_FILE_CKSUM}";

        if [ ${ARCHIVE_FILE_CKSUM} -ne ${CURRENT_FILE_CKSUM} ]
        then
            writeLogEntry "ERROR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${LOG_ROOT}/${BASE_FILE_NAME} and ${LOG_ROOT}/${BASE_FILE_NAME}.0 do NOT match";
            writeLogEntry "STDERR" "${METHOD_NAME}" "${0}" "${LINENO}" "Checksums for file ${LOG_ROOT}/${BASE_FILE_NAME} and ${LOG_ROOT}/${BASE_FILE_NAME}.0 do NOT match";
        fi

        [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RUN COMMAND -> /usr/bin/env cat /dev/null >| \"${LOG_FILE_NAME}\"";

        /usr/bin/env cat /dev/null >| "${LOG_FILE_NAME}";
    fi

    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "RETURN_CODE -> ${RETURN_CODE}";
    [ ! -z "${ENABLE_DEBUG}" ] && [ "${ENABLE_DEBUG}" = "${_TRUE}" ] && writeLogEntry "DEBUG" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} -> exit";

    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i END_EPOCH=$(/usr/bin/env date +"%s");
    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && typeset -i RUNTIME=$(( START_EPOCH - END_EPOCH ));
    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} TOTAL RUNTIME: $(( RUNTIME / 60)) MINUTES, TOTAL ELAPSED: $(( RUNTIME % 60)) SECONDS";
    [ ! -z "${ENABLE_PERFORMANCE}" ] && [ "${ENABLE_PERFORMANCE}" = "${_TRUE}" ] && writeLogEntry "PERFORMANCE" "${METHOD_NAME}" "${0}" "${LINENO}" "${METHOD_NAME} END: $(/usr/bin/env date +"${TIMESTAMP_OPTS}")";

    [ ! -z "${ARCHIVE_NUMBER}" ] && unset ARCHIVE_NUMBER;
    [ ! -z "${ARCHIVED_FILE}" ] && unset ARCHIVED_FILE;
    [ ! -z "${CURRENT_FILE_CKSUM}" ] && unset CURRENT_FILE_CKSUM;
    [ ! -z "${ARCHIVE_FILE_CKSUM}" ] && unset ARCHIVE_FILE_CKSUM;
    [ ! -z "${LOG_FILE_NAME}" ] && unset LOG_FILE_NAME;
    [ ! -z "${DATESTAMP}" ] && unset DATESTAMP;
    [ ! -z "${ROLLOVER_CHECK}" ] && unset ROLLOVER_CHECK;
    [ ! -z "${BASE_FILE_NAME}" ] && unset BASE_FILE_NAME;
    [ ! -z "${FILE_STAT_TIME}" ] && unset FILE_STAT_TIME;
    [ ! -z "${CURRENT_NUMBER}" ] && unset CURRENT_NUMBER;
    [ ! -z "${ADD_NUMBER}" ] && unset ADD_NUMBER;
    [ ! -z "${METHOD_NAME}" ] && unset METHOD_NAME;

    [ ! -z "${ENABLE_VERBOSE}" ] && [ "${ENABLE_VERBOSE}" = "${_TRUE}" ] && set +x;
    [ ! -z "${ENABLE_TRACE}" ] && [ "${ENABLE_TRACE}" = "${_TRUE}" ] && set +v;

    return ${RETURN_CODE};
}
