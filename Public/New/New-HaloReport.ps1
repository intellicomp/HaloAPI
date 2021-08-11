Function New-HaloReport {
    <#
    .SYNOPSIS
        Creates a report via the Halo API.
    .DESCRIPTION
        Function to send a report creation request to the Halo API
    .OUTPUTS
        Outputs an object containing the response from the web request.
    #>
    [CmdletBinding()]
    Param (
        # Object containing properties and values used to create a new report.
        [Parameter( Mandatory = $True )]
        [PSCustomObject]$Report
    )
    Invoke-HaloUpdate -Object $Report -Endpoint "report"
}