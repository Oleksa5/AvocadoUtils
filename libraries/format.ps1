<#
.SYNOPSIS
.DESCRIPTION
EFFECT
TODO
-Documentation
-Test
-Maybe move to AvocadoCore and make
Format-Expanded use it
.PARAMETER
.OUTPUTS
string
An array of strings.
#>
function Format-Labeled {
  [OutputType([string])]
  param (
    [string] $Label,
    [Object] $Object,
    [string] $Style
  )

  if ($null -ne $Object) {
    Use-AnsiOutputRendering
    $Object = Indent-Line ($Object | Out-String)
    $Object = Trim-EmptyLine $Object
    Reset-OutputRendering
  }

  $Style ??= $AvocadoColor.Label

  "$Style${Label}:$($PSStyle.Reset)"
  if ($null -ne $Object) {
  ""
  $Object
  }
}

<#
.SYNOPSIS
Format the output of Get-ChildItem.
.DESCRIPTION
EFFECT
TODO
-Review, clean up, optimize
-Documentation
-Test
.PARAMETER
.OUTPUTS
Object
Format objects.
#>
function Format-ChildItem {
  [OutputType([Object])]
  param (
    [Object[]] $Item
  )

  if (($null -ne $Item) -and ($Item.Count)) {
    #region FindParent
    #—————————————————

      $parent = (Split-Path $Item[0].FullName) -split '\\'

      for ($i = 1; $i -lt $Item.Count; $i++) {
        $itm = $Item[$i]
        $prn = (Split-Path $itm.FullName) -split '\\'

        #region CompareComponent
        #———————————————————————

          for ($j = 0; $j -lt $parent.Count; $j++) {
            $component = $parent[$j]
            $cmp = $prn[$j]

            if ($component -ne $cmp) {
              break
            }
          }

          if ($j -eq 0) {
            throw "Items don't have a common parent"
          }

          $parent = $parent[0..$j]

        #—————————
        #endregion
      }

    #—————————
    #endregion

    $Item = $Item | Sort-Object FullName

    #region FormatItem
    #—————————————————

      $items = [Collections.Generic.List[Object]]::new()
      $prevPath = @()

      for ($i = 0; $i -lt $Item.Count; $i++) {
        $itm  = $Item[$i]

        $path = $itm.FullName -split '\\'
        $path = $path[$parent.Count..$path.Count]

        #region CompareComponent
        #———————————————————————

          $omitCount = 0
          for ($j = 0; $j -lt $path.Count; $j++) {
            $component = $path[$j]

            if ($component -ne $prevPath[$j]) {
              break
            } else {
              $omitCount += [Math]::Min(2, $component.Length)
            }
          }

          $name = $path[$j..($path.Count-1)]
          $name = "$(' ' * $omitCount)$($name -join '\')"

        #—————————
        #endregion

        $isDir = $itm.Attributes -contains 'Directory'

        $items.Add(
          [pscustomobject]@{
            Name          = $name
            Length        = $isDir ? $null : $itm.Length
            LastWriteTime = $itm.LastWriteTime
          }
        )

        $prevPath = $path
      }

    #—————————
    #endregion

    "$(' ' * 4)Directory: $($parent -join '\')"
    $items | Format-Table
  }
}

Export-ModuleMember @(
  'Format-Labeled'
  'Format-ChildItem'
)