<#
.SYNOPSIS
Determine whether a path is absolute.
.PARAMETER Path
.OUTPUTS
bool
#>
function PathIsAbsolute {
  [OutputType([bool])]
  param(
    [string] $Path
  )

  Split-Path $Path -IsAbsolute
}

#region Config
#—————————————

<#
.SYNOPSIS
Get a configuration.
.DESCRIPTION
Gets a configuration stored in JSON file with
Name in a Parent directory. If the function
can't find the file, it creates a new one.
TODO
Test output type.
.PARAMETER Parent
.PARAMETER Name
.OUTPUTS
hashtable
Configuration as a hash table.
#>
function Get-Config {
  [OutputType([hashtable])]
  param (
    [string] $Parent = ".\",
    [string] $Name = "config"
  )

  $path = Join-Path $Parent "$Name.json"

  if (!(Test-Path $path)) {
    New-Item $path -ItemType File | Out-Null

    @{}
  } else {
    (Get-Content $path -Raw | ConvertFrom-Json -AsHashtable) ?? @{}
  }
}

<#
.SYNOPSIS
Save a configuration to a file.
.DESCRIPTION
Converts an object to JSON and save
it to a file with Name in a Parent
directory.
TODO
Test.
.PARAMETER Parent
.PARAMETER Value
.PARAMETER Name
.OUTPUTS
No output.
#>
function Set-Config {
  [OutputType([void])]
  param (
    [string] $Parent = ".\",
    [Object] $Value,
    [string] $Name = "config"
  )

  $path = Join-Path $Parent "$Name.json"

  ConvertTo-Json $Value | Set-Content $path
}

<#
.SYNOPSIS
Get a property of the configuration.
.DESCRIPTION
EFFECT
Writes to the configuration file with
a Name in a Parent directory if there
is no property with the Name and a
NewValue factory is provided.
TODO
-Test
-Test output type
.PARAMETER Parent
.PARAMETER Property
Name of the property.
.PARAMETER NewValue
Value factory used when the property
doesn't exist.
.PARAMETER Name
.OUTPUTS
Object
Property value or null if there is no
Property and a NewValue factory is not
provided.
#>
function Get-ConfigProperty {
  [OutputType([Object])]
  param (
    [string]      $Parent = ".\",
    [string]      $Property,
    [scriptblock] $NewValue,
    [string]      $Name = "config"
  )

  $config = Get-Config $Parent $Name
  $value = $config[$Name]

  if (($null -eq $value) -and
      ($null -ne $NewValue)) {
    $value = &$NewValue
    $config[$Name] = $value
    Set-Config $Parent -Name $Name $config
  }

  $value
}

<#
.SYNOPSIS
Remove a configuration file.
.DESCRIPTION
Removes a configuration file with a Name
in a Parent directory.
EFFECT
TODO
-Finish the doc
-Test
.PARAMETER Parent
.PARAMETER Name
.OUTPUTS
No output.
#>
function Remove-Config {
  [OutputType([void])]
  param (
    [string] $Parent = ".\",
    [string] $Name = "config"
  )

  $path = Join-Path $Parent "$Name.json"

  Remove-Item $path
}

Export-ModuleMember @(
  'Get-Config'
  'Set-Config'
  'Get-ConfigProperty'
  'Remove-Config'
)

#—————————
#endregion

Export-ModuleMember @(
  'PathIsAbsolute'
)