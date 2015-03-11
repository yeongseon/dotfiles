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
#       COMPANY:  CaspersBox Web Services
#       VERSION:  1.0
#       CREATED:  ---
#      REVISION:  ---
#==============================================================================

set _CNAME "getAuthValue";
set _METHOD_NAME "getAuthValue";
set _DEFAULT_ENCRYPTION "GPG";
set _AUTH_VALUE "none";
set _PASSWD_LENGTH "64";
set _RANDOM_GENERATOR "/dev/urandom";
set _DEFAULT_AUTH [ split "file:env(HOME)/.etc/password.asc" ":" ];

proc getAuthValue { _HOSTNAME _USERNAME { _AUTH_FILE "" } { _ID_FILE "" } { _ENCRYPTED 0 } { _ENCRYPTION_PRG "" } } {
    global env;
    global tcl_platform;
    global _AUTH_VALUE;
    global _PASSWD_LENGTH;
    global _RANDOM_GENERATOR;
    global _DEFAULT_AUTH;

    if { [ string length $_AUTH_FILE ] != 0 } {
        set _AUTH_VARIABLE [ split $_AUTH_FILE ":" ];
    } elseif { [ info exists env(PASSWD_FILE) ] } {
        set _AUTH_VARIABLE [ split $env(PASSWD_FILE) ":" ];
    } else {
        puts "default"
        set _AUTH_VARIABLE [ split $_DEFAULT_AUTH ":" ];
    }

    if { [ expr { $_ENCRYPTED ne 0 } == 0 ] } {
        if { [ info exists env(ENCR_TYPE) ] } {
            set _ENCRYPTION_TYPE $env(ENCR_TYPE);
        } elseif { [ string length $_ENCRYPTION_PRG ] != 0 } {
            set _ENCRYPTION_TYPE $_ENCRYPTION_PRG;
        } else {
            set _ENCRYPTION_TYPE $_DEFAULT_ENCRYPTION;
        }
    } else {
        set _ENCRYPTION_TYPE "";
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
                if { [ string length $_ENCRYPTION_TYPE ] != 0 } {
                    puts "encrypted file"
                    if { [ string match -nocase $_ENCRYPTION_TYPE "gpg" ] } {
                        set _DECRYPTED [ split [ exec /usr/bin/env gpg --decrypt [ lindex $_AUTH_VARIABLE 1 ] 2>/dev/null ] "\n" ]
                    } elseif { [ string match -nocase $_ENCRYPTION_TYPE "openssl" ] } {
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
