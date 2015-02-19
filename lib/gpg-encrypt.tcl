#==============================================================================
#
#          FILE:  gpg-encrypt.tcl
#         USAGE:  ./gpg-encrypt.tcl
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

set _CNAME "gpg-encrypt";
set _METHOD_NAME "gpg-encrypt";

proc gpg-encrypt { _INPUT_FILE _OUTPUT_FILE _PASSPHRASE } {
    global tcl_platform;
    global _CNAME;
    global _METHOD_NAME;

    eval spawn /usr/bin/env gpg -r --encrypt --sign --output $_OUTPUT_FILE $_INPUT_FILE;

    expect {
        "*Enter passphrase:*" {
            exp_send "$_PASSPHRASE\r";
            exp_continue;
        }
        "*File `$_OUTPUT_FILE' exists. Overwrite? (y/N)*" {
            exp_send "y\r";
            exp_continue;
        }
        eof {
            append output $expect_out(buffer);
        }
    }
}
