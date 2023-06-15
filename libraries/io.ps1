[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Scope='Function', Target='Pull-*')]
param()

#region ReadMocked
#—————————————————

  $promptQueue = [Collections.Queue]::new()

  <#
  .SYNOPSIS
  Push input into the prompt queue.
  .DESCRIPTION
  Pushes input into the prompt queue. Read-Host
  then gets the input from the queue instead of
  reading the console.
  EFFECTS
  Changes the state of the prompt queue
  TODO
  Test.
  .PARAMETER Object
  .OUTPUTS
  No output.
  #>
  function Push-Input {
    [OutputType([void])]
    param (
      [Object] $Object
    )

    $promptQueue.Enqueue($Object)
  }

  $mockedRead = [Collections.Generic.List[Object]]::new()
  $logMockedRead = $false

  <#
  .SYNOPSIS
  .DESCRIPTION
  EFFECT
  TODO
  -Documentation
  -Test
  .PARAMETER
  .OUTPUTS
  #>
  function Set-MockReadLog {
    [OutputType([void])]
    param (
      [bool] $Value
    )

    $script:logMockedRead = $Value
  }

  <#
  .SYNOPSIS
  .DESCRIPTION
  EFFECT
  TODO
  -Documentation
  -Test
  .PARAMETER
  .OUTPUTS
  #>
  function Pull-MockRead {
    [OutputType([string[]])]
    param ()

    $mockedRead.ToArray()

    $mockedRead.Clear()
  }

  <#
  .SYNOPSIS
  Read input from the prompt queue or the console.
  .DESCRIPTION
  EFFECT
  If there is pushed input, changes the state of
  the prompt queue by removing the object at the
  beginning of the queue.
  TODO
  Test.
  .PARAMETER Prompt
  .OUTPUTS
  string
  If the prompt queue is empty, outputs string.
  Object
  If there is pushed input, outputs that input.
  #>
  function Read-Host {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidOverwritingBuiltInCmdlets', '')]
    [OutputType([Object])]
    param (
      [Object] $Prompt
    )

    if ($promptQueue.Count) {
      $promptInput = $promptQueue.Dequeue()

      if ($logMockedRead) {
        $mockedRead.AddRange(@(
          "${Prompt}:"
          "$promptInput"
        ))
      }

      $promptInput

    } else {
      Microsoft.PowerShell.Utility\Read-Host $Prompt
    }
  }

  Export-ModuleMember @(
    'Push-Input'
    'Set-MockReadLog'
    'Pull-MockRead'
    'Read-Host'
  )

#—————————
#endregion