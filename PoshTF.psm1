# === Class Input ========================================================== #

. ".\Class\ValidFilterValues.ps1"

# === Get-TFResourceData =================================================== #

function Get-TFResourceData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('n')]
        [ValidateSet([ValidFilterValues])]
        [string]$ResourceName,

        [Parameter(Mandatory = $false)]
        [Alias('p')]
        [string[]]$Properties
    )
    
    begin {
        
        try {
            Test-Path ".\terrafrom.tfstate" -ErrorAction Stop | Out-Null
        }
        catch {
            Write-Error "terraform.tfstate was not found in the current directory. Please make sure this file exists before running this cmd."
        }

        Write-Verbose "Storing Json into memory"
        $Json = terraform show -json terraform.tfstate | ConvertFrom-Json
        $JsonResources = $json.values.root_module.resources 
    }
    
    process {

        Write-Verbose "Filtering Json Object"
        $JsonResource = $JsonResources.Where({ $_.address -like "$ResourceName" })
        
        if ($null -ne $Properties) {
            $JsonFilteredProperties = $JsonResource.Values | Select-Object $Properties
        }
    }
    
    end {
        Write-Verbose "Returning Json Object"
        if ($null -eq $Properties) {
            return $JsonResource
        }
        else {
            return $JsonFilteredProperties
        } 
    }
}
