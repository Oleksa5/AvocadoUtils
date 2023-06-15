foreach ($item in (Get-ChildItem "$PSScriptRoot\libraries\*.ps1" -Recurse)) {
  if ($item.Name -notmatch "copy") {
    . $item
  }
}

Export-ModuleMember -Function (
  (Get-Module AvocadoCore).ExportedFunctions.Keys | ForEach-Object { $_ }
)

Export-ModuleMember -Variable (
  (Get-Module AvocadoCore).ExportedVariables.Keys | ForEach-Object { $_ }
)