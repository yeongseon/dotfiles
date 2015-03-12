#==============================================================================
#
#          FILE:  changeAccountPassword.tcl
#         USAGE:  ./changeAccountPassword.tcl
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

set _CNAME "changeAccountPassword";
set _METHOD_NAME "changeAccountPassword";
set _RANDOM_GENERATOR "/dev/urandom";
set _PASSWD_LENGTH "64";
set _LINE_TERMINATOR "\r\n";

set timeout 10;

proc changeAccountPassword { _REQUEST_TYPE _USER_NAME _CURRENT_PASSWD { _NEW_PASSWD "" } } {
    global env;
    global tcl_platform;
    global _RANDOM_GENERATOR;
    global _PASSWD_LENGTH;
    global _LINE_TERMINATOR;

    set _PASSWD_LENGTH "64";
    set _RANDOM_GENERATOR "/dev/urandom";

    set i 0;
    set x 0;

    if { [ string length $_NEW_PASSWD ] == 0 } {
        set _NEW_PASSWD [ exec /bin/sh -c "cat $_RANDOM_GENERATOR | tr -dc \"A-Za-z0-9_\" | head -c $_PASSWD_LENGTH" ];
    }

    switch $_REQUEST_TYPE {
        key {
            eval spawn ssh-keygen -f $_SSH_KEYFILE -p;

            expect {
                "*old passphrase*" {
                    exp_send "$_CURRENT_PASSPHRASE\r";
                    exp_continue;
                }
                "*?nter new passphrase*" {
                    exp_send "$_NEW_PASSWD\r";
                    exp_continue;
                }
                "*?nter same passphrase*" {
                    exp_send "$_NEW_PASSWD\r";
                    exp_continue;
                }
                $_LINE_TERMINATOR {
                    return "$_NEW_PASSWD";
                }
            }
        }
        account {
            expect {
                "*(current) UNIX password:*" {
                    exp_send "$_CURRENT_PASSWD\r";
                    exp_continue;
                }
                "*Changing password for \"$_USER_NAME\"*" {
                    exp_send "$_CURRENT_PASSWD\r";
                    exp_continue;
                }
                "*$_USER_NAME's ?ld password:*" {
                    exp_send "$_CURRENT_PASSWD\r";
                    exp_continue;
                }
                "*?ld password*" {
                    exp_send "$_CURRENT_PASSWD\r";
                    exp_continue;
                }
                "*$_USER_NAME's ?ew password:*" {
                    exp_send "$_NEW_PASSWD\r";
                    exp_continue;
                }
                "*?ew*password*" {
                    exp_send "$_NEW_PASSWD\r";
                    exp_continue;
                }
                "*Enter the new password again:" {
                    exp_send "$_NEW_PASSWD\r";
                    exp_continue;
                }
                "*Retype new UNIX password: *" {
                    exp_send "$_NEW_PASSWD\r";
                    exp_continue;
                }
                "*Authentication token manipulation error*" {
                    return 2;
                }
                "*BAD PASSWORD:*" {
                    if { ! [ expr { $x > 3 } ] } {
                        set _NEW_PASSWD [ exec /bin/sh -c "cat $_RANDOM_GENERATOR | tr -dc \"A-Za-z0-9_\" | head -c $_PASSWD_LENGTH" ];
                        set x [ expr { $x + 1 } ];
                    } else {
                        return 2;
                    }

                    set x [ expr { $x + 1 } ];
                    set _NEW_PASSWD [ exec /bin/sh -c "cat $_RANDOM_GENERATOR | tr -dc \"A-Za-z0-9_\" | head -c $_PASSWD_LENGTH" ];

                    exp_continue;
                }
                "*passwd: Have exhausted maximum number of retries for service*" {
                    return 2;
                }
                "*passwd: all authentication tokens updated successfully.*" {
                    ## success!
                    return "$_NEW_PASSWD";
                }
                "*?assword:*" {
                    if { [ expr { $i == 1 } ] } {
                        return 1;
                    }

                    set i [ expr { $i + 1 } ];

                    exp_send "$_CURRENT_PASSWD\r";
                    exp_continue;
                }
                $_LINE_TERMINATOR {
                    exp_continue;
                }
                "*\$*" {
                    exp_send "exit\r";

                    return "$_NEW_PASSWD";
                }
                default {
                    exp_continue;
                }
            }
        }
    }
}
