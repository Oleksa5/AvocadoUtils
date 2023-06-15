[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Scope='Function', Target='Expect-*')]
param()

#region Expect
#—————————————

  <#
  .SYNOPSIS
  Assert a path is the current location.
  .DESCRIPTION
  EFFECT
  TODO
  -Documentation
  -Test
  .PARAMETER Path
  .OUTPUTS
  No output.
  #>
  function Expect-Location {
    [OutputType([void])]
    param (
      [string] $Path
    )

    Expect-Condition { (Get-Location).Path -eq $Path }
  }

  <#
  .SYNOPSIS
  Assert an item at a path exists.
  .DESCRIPTION
  EFFECT
  TODO
  -Documentation
  -Test
  .PARAMETER Path
  .OUTPUTS
  No output.
  #>
  function Expect-Item {
    [OutputType([void])]
    param (
      [string] $Path
    )

    Expect-Condition { Test-Path $Path }
  }

  <#
  .SYNOPSIS
  Assert an item at a path doesn't exist.
  .DESCRIPTION
  EFFECT
  TODO
  -Documentation
  -Test
  .PARAMETER Path
  .OUTPUTS
  No output.
  #>
  function Expect-NoItem {
    [OutputType([void])]
    param (
      [string] $Path
    )

    Expect-Condition { -not (Test-Path $Path) }
  }

  <#
  .SYNOPSIS
  Assert an object is null.
  .DESCRIPTION
  EFFECT
  TODO
  -Documentation
  -Test
  .PARAMETER Path
  .OUTPUTS
  No output.
  #>
  function Expect-Null {
    [OutputType([void])]
    param (
      [Object] $Object
    )

    Expect-Condition { $null -eq $Object }
  }

  <#
  .SYNOPSIS
  Assert an object is not null.
  .DESCRIPTION
  EFFECT
  TODO
  -Documentation
  -Test
  .PARAMETER Path
  .OUTPUTS
  No output.
  #>
  function Expect-NotNull {
    [OutputType([void])]
    param (
      [Object] $Object
    )

    Expect-Condition { $null -ne $Object }
  }

  <#
  .SYNOPSIS
  Assert an object's count is zero.
  .DESCRIPTION
  EFFECT
  TODO
  -Documentation
  -Test
  .PARAMETER Path
  .OUTPUTS
  No output.
  #>
  function Expect-Empty {
    [OutputType([void])]
    param (
      [Object] $Object
    )

    Expect-Condition { $Object.Count -eq 0 }
  }

  Export-ModuleMember @(
    'Expect-Location'
    'Expect-Item'
    'Expect-NoItem'
    'Expect-Null'
    'Expect-NotNull'
    'Expect-Empty'
  )

#—————————
#endregion

#region NewTest
#——————————————

  enum GetHelpDetail {
    Basic
    Detailed
    Full
  }

  <#
  .SYNOPSIS
  Test Get-Help for commands.
  .PARAMETER Names
  Names of the commands.
  .PARAMETER Detail
  .OUTPUTS
  string[]
  .TODO
  test
  #>
  function New-TestDocumentation {
    param (
      [string[]]      $Names,
      [GetHelpDetail] $Detail
    )

    New-Test -Group "Documentation" -R "" {
      foreach ($name in $Names) {
        New-TestHelp $name $Detail
      }
    }
  }

  <#
  .SYNOPSIS
  Test Get-Help for a command.
  .PARAMETER Name
  Name of the command.
  .PARAMETER Detail
  .OUTPUTS
  string[]
  .TODO
  test
  #>
  function New-TestHelp {
    [OutputType([string[]])]
    param(
      [string]        $Name,
      [GetHelpDetail] $Detail
    )

    New-Test $Name -R "" -First {
      #region Code
      #———————————

        switch ($Detail) {
          Basic {
            Get-Help $Name | Out-String
          } Detailed {
            Get-Help $Name -Detailed | Out-String
          } Full {
            Get-Help $Name -Full | Out-String
          } Default {
            throw "Unknown help detail level $Detail."
          }
        }

      #—————————
      #endregion
    }
  }

  Export-ModuleMember @(
    'New-TestDocumentation'
    'New-TestHelp'
  )

#—————————
#endregion

#region Format
#—————————————

  <#
  .SYNOPSIS
  .DESCRIPTION
  EFFECT
  TODO
  -Documentation
  -Test
  Format-Expanded use it
  .PARAMETER
  .OUTPUTS
  string
  An array of strings.
  #>
  function Format-TestLabeled {
    [OutputType([string])]
    param (
      [string] $Label,
      [Object] $Object
    )

    ""
    Format-Labeled $Label $Object -Style $PSStyle.Foreground.Magenta
  }

  Export-ModuleMember @(
    'Format-TestLabeled'
  )

#—————————
#endregion