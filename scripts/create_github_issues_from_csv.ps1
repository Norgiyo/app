param(
  [string]$CsvPath = "github/issues/backlog_issues.csv",
  [switch]$DryRun,
  [switch]$SkipLabels
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path $CsvPath)) {
  throw "No se encontro el archivo CSV: $CsvPath"
}

$rows = Import-Csv -Path $CsvPath
if (-not $rows -or $rows.Count -eq 0) {
  throw "El CSV no contiene filas: $CsvPath"
}

foreach ($row in $rows) {
  $title = $row.Title
  $body = $row.Body
  $labels = @()

  if (-not $SkipLabels -and $row.Labels) {
    $labels = $row.Labels.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
  }

  if ($DryRun) {
    Write-Output "DRY RUN -> $title"
    continue
  }

  $args = @("issue", "create", "--title", $title, "--body", $body)
  foreach ($label in $labels) {
    $args += @("--label", $label)
  }

  & gh @args
}

Write-Output "Proceso completado. Issues procesados: $($rows.Count)"
