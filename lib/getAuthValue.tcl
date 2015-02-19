#==============================================================================
#
#          FILE:  getAuthValue
#         USAGE:  ./getAuthValue
#   DESCRIPTION:  Executes an scp connection to a pre-defined server
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
#==============================================================================

set _CNAME "getAuthValue";
set _METHOD_NAME "getAuthValue";

proc getAuthValue { _HOSTNAME _USERNAME { _AUTH_VARIABLE "" } { _ID_FILE "" } } {
    global env;
    global tcl_platform;

    set _ENCRYPTED "GPG"
    set _AUTH_VALUE "none";
    set _PASSWD_LENGTH "64";
    set _RANDOM_GENERATOR "/dev/urandom";
    set _AUTH_VARIABLE [ split "file:$env(HOME)/.etc/password.asc" ":" ];

    if { [info exists env(PASSWD_FILE)] } {
        set _AUTH_VARIABLE [ split $env(PASSWD_FILE) ":" ];
        set _ENCRYPTED $env(ENCR_TYPE);
    }

    switch [ lindex $_AUTH_VARIABLE 0 ] {
        pass {
            set _AUTH_VALUE [ lindex $_AUTH_VARIABLE 1 ];
        }
        key {
            set _USER_KEY [ lindex $_AUTH_VARIABLE 1 ]

            if { [ llength $_AUTH_VARIABLE ] == 3 } {
                # key has a password
                set _USER_PASSWD [ lindex $_AUTH_VARIABLE 2 ]
            }
        }
        file {
            if { [ file exists [ lindex $_AUTH_VARIABLE 1 ] ] == 1 } {
                if { [ string length $_ENCRYPTED ] != 0 } {
                    if { [ string match -nocase $_ENCRYPTED "gpg" ] } {
                        set _DECRYPTED [ split [ exec /usr/bin/env gpg --decrypt [ lindex $_AUTH_VARIABLE 1 ] 2>/dev/null ] "\n" ]
                    } elseif { [ string match -nocase $_ENCRYPTED "openssl" ] } {
                        set _DECRYPTED [ split [ exec /usr/bin/env gpg --decrypt [ lindex $_AUTH_VARIABLE 1 ] 2>/dev/null ] "\n" ]
                    }

                    foreach _ENTRY $_DECRYPTED {
                        if { [ string match "#*" $_ENTRY ] } {
                            # ignore by just going straight to the next loop iteration
                            continue;
                        }

                        set _AUTH_ENTRY [ split $_ENTRY " " ];

                        if { [ string match "id_*" [ lindex $_AUTH_ENTRY 0 ] ] } {
                            if { [ string match [ lindex $_AUTH_ENTRY 0 ] $_ID_FILE ] } {
                                set _AUTH_VALUE [ lindex $_AUTH_ENTRY 1 ];

                                break;
                            } else {
                                continue;
                            }
                        } elseif { [ string match -nocase [ lindex $_AUTH_ENTRY 0 ] $_USERNAME ] } {
                            # username:home directory:pass:password:(new pass)
                            if { [ string match [ lindex $_AUTH_ENTRY 2 ] "none" ] } {
                                return;
                            } elseif { [ string match [ lindex $_AUTH_ENTRY 2 ] "pass" ] } {
                                set _AUTH_VALUE [ lindex $_AUTH_ENTRY 3 ];

                                break;
                            } elseif { [ string match [ lindex $_AUTH_ENTRY 2 ] "key" ] } {
                                set _AUTH_VALUE [ lindex $_AUTH_ENTRY 3 ];

                                break;
                            } else {
                                continue;
                            }
                        } elseif { [ string match -nocase [ lindex $_AUTH_ENTRY 0 ] $_HOSTNAME ] } {
                            # hostname:username:home directory:pass:password:(new pass)
                            if { [ string match -nocase [ lindex $_AUTH_ENTRY 1 ] $_USERNAME ] } {
                                if { [ string match [ lindex $_AUTH_ENTRY 3 ] "none" ] } {
                                    return;
                                } elseif { [ string match [ lindex $_AUTH_ENTRY 3 ] "pass" ] } {
                                    set _AUTH_VALUE [ lindex $_AUTH_ENTRY 4 ];

                                    break;
                                } elseif { [ string match [ lindex $_AUTH_ENTRY 3 ] "key" ] } {
                                    set _AUTH_VALUE [ lindex $_AUTH_ENTRY 4 ];

                                    break;
                                } else {
                                    continue;
                                }
                            } else {
                                continue;
                            }
                        } else {
                            continue;
                        }
                    }
                } else {
                    set _AUTH_FILE [ open [ lindex $_AUTH_VARIABLE 1 ] r ];
                    fconfigure $_AUTH_FILE -buffering line;

                    while { [ gets $_AUTH_FILE _ENTRY ] >= 0 } {
                        if { [ string match "#*" $_ENTRY ] } {
                            # ignore by just going straight to the next loop iteration
                            continue;
                        }

                        set _AUTH_ENTRY [ split $_ENTRY " " ];

                        if { [ string length $_HOSTNAME ] == 0 && [ string length $_USERNAME ] == 0 && [ string length $_ID_FILE ] == 0 } {
                            ## assume only one line entry and use that
                            set _AUTH_VALUE [ lindex $_AUTH_ENTRY 0 ];
                        } else {
                            if { [ string match "id_*" [ lindex $_AUTH_ENTRY 0 ] ] } {
                                if { [ string match [ lindex $_AUTH_ENTRY 0 ] $_ID_FILE ] } {
                                    set _AUTH_VALUE [ lindex $_AUTH_ENTRY 1 ];

                                    break;
                                } else {
                                    continue;
                                }
                            } elseif { [ string match -nocase [ lindex $_AUTH_ENTRY 0 ] $_USERNAME ] } {
                                # username:home directory:pass:password:(new pass)
                                if { [ string match [ lindex $_AUTH_ENTRY 2 ] "none" ] } {
                                    return;
                                } elseif { [ string match [ lindex $_AUTH_ENTRY 2 ] "pass" ] } {
                                    set _AUTH_VALUE [ lindex $_AUTH_ENTRY 3 ];

                                    break;
                                } elseif { [ string match [ lindex $_AUTH_ENTRY 2 ] "key" ] } {
                                    set _AUTH_VALUE [ lindex $_AUTH_ENTRY 3 ];

                                    break;
                                } else {
                                    continue;
                                }
                            } elseif { [ string match -nocase [ lindex $_AUTH_ENTRY 0 ] $_HOSTNAME ] } {
                                # hostname:username:home directory:pass:password:(new pass)
                                if { [ string match -nocase [ lindex $_AUTH_ENTRY 1 ] $_USERNAME ] } {
                                    if { [ string match [ lindex $_AUTH_ENTRY 3 ] "none" ] } {
                                        return;
                                    } elseif { [ string match [ lindex $_AUTH_ENTRY 3 ] "pass" ] } {
                                        set _AUTH_VALUE [ lindex $_AUTH_ENTRY 4 ];

                                        break;
                                    } elseif { [ string match [ lindex $_AUTH_ENTRY 3 ] "key" ] } {
                                        set _AUTH_VALUE [ lindex $_AUTH_ENTRY 4 ];

                                        break;
                                    } else {
                                        continue;
                                    }
                                } else {
                                    continue;
                                }
                            } else {
                                continue;
                            }
                        }
                    }

                    close $_AUTH_FILE;
                }
            }
        }
    }

    return "$_AUTH_VALUE";
}
