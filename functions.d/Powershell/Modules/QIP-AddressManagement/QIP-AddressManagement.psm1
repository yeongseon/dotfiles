#=====  FUNCTION  =============================================================
#          NAME:  returnRandomCharacters
#   DESCRIPTION:  Returns a random string of alphanumeric characters
#    PARAMETERS:  Length of string, include special characters
#       RETURNS:  0 regardless of result.
#==============================================================================

function QIP-DeleteAddresses ($AddressList)
{
    foreach ($address in get-content $AddressList) {
        Write-Host $address
    }
}

Export-ModuleMember -Function QIP-DeleteAddresses
