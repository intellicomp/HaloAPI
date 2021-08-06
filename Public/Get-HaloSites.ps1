#Requires -Version 7
function Get-HaloSite {
    <#
        .SYNOPSIS
            Gets sites from the Halo API.
        .DESCRIPTION
            Retrieves sites from the Halo API - supports a variety of filtering parameters.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( DefaultParameterSetName = "Multi" )]
    Param(
        # Site ID
        [Parameter( ParameterSetName = "Single", Mandatory = $True )]
        [int64]$SiteID,
        # Paginate results
        [Parameter( ParameterSetName = "Multi" )]
        [Alias("pageinate")]
        [switch]$Paginate,
        # Number of results per page.
        [Parameter( ParameterSetName = "Multi" )]
        [Alias("page_size")]
        [int32]$PageSize,
        # Which page to return.
        [Parameter( ParameterSetName = "Multi" )]
        [Alias("page_no")]
        [int32]$PageNo,
        # The field to order the results by.
        [Parameter( ParameterSetName = "Multi" )]
        [string]$Order,
        # Order results in descending order (respects the field choice in '-Order')
        [Parameter( ParameterSetName = "Multi" )]
        [switch]$OrderDesc,
        # Return contracts matching the search term in the results.
        [Parameter( ParameterSetName = "Multi" )]
        [string]$Search,
        # Filter by the specified top level ID.
        [Parameter( ParameterSetName = "Multi" )]
        [Alias("toplevel_id")]
        [int32]$TopLevelID,
        # Filter by the specified client ID.
        [Parameter( ParameterSetName = "Multi" )]
        [Alias("client_id")]
        [int32]$ClientID,
        # Include inactive sites in the results.
        [Parameter( ParameterSetName = "Multi" )]
        [switch]$IncludeInactive,
        # Include active sites in the results.
        [Parameter( ParameterSetName = "Multi" )]
        [switch]$IncludeActive,
        # The number of sites to return if not using pagination.
        [Parameter( ParameterSetName = "Multi" )]
        [int32]$Count

    )
    $CommandName = $PSCmdlet.MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding a 'siteid=' parameter by removing it from the set parameters.
    if ($SiteID) {
        $Parameters.Remove("SiteID") | Out-Null
    }
    $QueryString = New-HaloQueryString -CommandName $CommandName -Parameters $Parameters
    try {
        if ($SiteID) {
            Write-Verbose "Running in single-site mode because '-SiteID' was provided."
            $Resource = "api/site/$SiteID$QueryString"
        } else {
            Write-Verbose "Running in multi-site mode."
            $Resource = "api/site$($QueryString)"
        }    
        $RequestParams = @{
            Method = "GET"
            Resource = $Resource
        }
        $SiteResults = Invoke-HaloRequest @RequestParams
        Return $SiteResults
    } catch {
        Write-Error "Failed to get sites from the Halo API. You'll see more detail if using '-Verbose'"
        Write-Verbose "$_"
    }
}