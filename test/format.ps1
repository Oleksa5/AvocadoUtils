Import-Module AvocadoUtils -Force -DisableNameChecking

$PSModuleAutoLoadingPreference = 'none'
$WarningPreference = 'Continue'
$ErrorActionPreference = 'Stop'

try {
  New-Test -Group "Format-ChildItem" {
    New-Test "" -First {
      #region Code
      #———————————

        Format-ChildItem (Get-ChildItem -Recurse)

      #—————————
      #endregion
      #region Test
      #———————————
      #—————————
      #endregion
    }
  }
} catch {
  Format-Exception $_
}