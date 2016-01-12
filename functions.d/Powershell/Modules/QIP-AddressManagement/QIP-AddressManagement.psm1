#=====  FUNCTION  =============================================================
#          NAME:  returnRandomCharacters
#   DESCRIPTION:  Returns a random string of alphanumeric characters
#    PARAMETERS:  Length of string, include special characters
#       RETURNS:  0 regardless of result.
#==============================================================================

$LOGIN_SERVER = "diquat.prod.mtb.com";
$LOGIN_DBASE = "DNSSVR";
$LOGIN_USER = "qipman";
$LOGIN_PASS = "qipman";
$INTERNAL_ORG = "M&T Internal";

function QIP-DeleteAddresses ($ADDRESSLIST)
{
    $QIPDEL = "C:\qip\cli\qip-del.exe";

    foreach ($ADDRESS in Get-Content $ADDRESSLIST)
    {
        $QIPARGS = @("-g " + $LOGIN_SERVER + " -s " + $LOGIN_DBASE + " -o " + $INTERNAL_ORG + " -u " + $LOGIN_USER + " -u " + $LOGIN_PASS + " -a " + $ADDRESS + " -t object");

        & $QIPDEL $QIPARGS;
    }
}

function QIP-DeleteExpiredLeasesFromServer ($DHCPSERVERLIST)
{
    foreach ($DHCPSERVER in Get-Content $DHCPSERVERLIST)
    {
        $QIPDEL = "C:\qip\cli\qip-active.exe";
        $QIPARGS = @("-g " + $LOGIN_SERVER + " -s " + $LOGIN_DBASE + " -o " + $INTERNAL_ORG + " -n " + $DHCPSERVER + " -u " + $LOGIN_USER + " -u " + $LOGIN_PASS + " -t expired");

        foreach ($ADDRESS in & $QIPDEL $QIPARGS)
        {
            $DELETEARGS = @("-g " + $LOGIN_SERVER + " -s " + $LOGIN_DBASE + " -o " + $INTERNAL_ORG + " -n " + $DHCPSERVER + " -u " + $LOGIN_USER + " -u " + $LOGIN_PASS + " -b " + $ADDRESS + " -t delete");
        }
    }
}

function QIP-DeleteExpiredLeasesFromServerOrg ($DHCPSERVERLIST, $ORGANIZATION)
{
    foreach ($DHCPSERVER in Get-Content $DHCPSERVERLIST)
    {
        $QIPDEL = "C:\qip\cli\qip-active.exe";
        $QIPARGS = @("-g " + $LOGIN_SERVER + " -s " + $LOGIN_DBASE + " -o " + $ORGANIZATION + " -n " + $DHCPSERVER + " -u " + $LOGIN_USER + " -u " + $LOGIN_PASS + " -t expired");

        foreach ($ADDRESS in & $QIPDEL $QIPARGS)
        {
            $DELETEARGS = @("-g " + $LOGIN_SERVER + " -s " + $LOGIN_DBASE + " -o " + $ORGANIZATION + " -n " + $DHCPSERVER + " -u " + $LOGIN_USER + " -u " + $LOGIN_PASS + " -b " + $ADDRESS + " -t delete");
        }
    }
}

function QIP-DeleteExpiredLeasesFromServerOrgSubnet ($DHCPSERVERLIST, $ORGANIZATION, $SUBNET)
{
    foreach ($DHCPSERVER in Get-Content $DHCPSERVERLIST)
    {
        $QIPDEL = "C:\qip\cli\qip-active.exe";
        $QIPARGS = @("-g " + $LOGIN_SERVER + " -s " + $LOGIN_DBASE + " -o " + $ORGANIZATION + " -n " + $DHCPSERVER + " -u " + $LOGIN_USER + " -u " + $LOGIN_PASS + " -b " + $SUBNET + " -t expired");

        foreach ($ADDRESS in & $QIPDEL $QIPARGS)
        {
            $DELETEARGS = @("-g " + $LOGIN_SERVER + " -s " + $LOGIN_DBASE + " -o " + $ORGANIZATION + " -n " + $DHCPSERVER + " -u " + $LOGIN_USER + " -u " + $LOGIN_PASS + " -b " + $ADDRESS + " -t delete");
        }
    }
}

Export-ModuleMember -Function QIP-DeleteAddresses
Export-ModuleMember -Function QIP-DeleteExpiredLeasesFromServer
Export-ModuleMember -Function QIP-DeleteExpiredLeasesFromServerOrg
Export-ModuleMember -Function QIP-DeleteExpiredLeasesFromServerOrgSubnet
