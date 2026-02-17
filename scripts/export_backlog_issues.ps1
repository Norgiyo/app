param(
  [string]$InputPath = "BACKLOG.md",
  [string]$CsvOut = "github/issues/backlog_issues.csv",
  [string]$MdOut = "github/issues/BACKLOG_ISSUES_IMPORT.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path $InputPath)) {
  throw "No se encontro el archivo: $InputPath"
}

$lines = Get-Content -Path $InputPath
$issues = @()
$phaseCode = ""
$phaseName = ""

for ($i = 0; $i -lt $lines.Count; $i++) {
  $line = $lines[$i].TrimEnd()

  if ($line -match '^##\s+(F\d+)\s+-\s+(.+)$') {
    $phaseCode = $matches[1]
    $phaseName = $matches[2]
    continue
  }

  if ($line -match '^###\s+(F\d+-\d+)\s+-\s+(.+)$') {
    $id = $matches[1]
    $title = $matches[2]
    $priority = "P1"
    $dependencies = "ninguna"
    $deliverable = ""
    $criteria = @()
    $inCriteria = $false

    $j = $i + 1
    while ($j -lt $lines.Count) {
      $next = $lines[$j].TrimEnd()

      if ($next -match '^###\s+' -or $next -match '^##\s+F\d+\s+-\s+') {
        break
      }

      if ($next -match '^- Prioridad:\s+`([^`]+)`') {
        $priority = $matches[1]
        $j++
        continue
      }

      if ($next -match '^- Dependencias:\s+(.+)$') {
        $dependencies = $matches[1]
        $j++
        continue
      }

      if ($next -match '^- Entregable:\s+(.+)$') {
        $deliverable = $matches[1]
        $j++
        continue
      }

      if ($next -eq '- Criterios de aceptacion:') {
        $inCriteria = $true
        $j++
        continue
      }

      if ($inCriteria -and $next -match '^- (.+)$') {
        $criteria += $matches[1]
        $j++
        continue
      }

      if ($inCriteria -and $next.Trim().Length -eq 0) {
        $j++
        continue
      }

      if ($inCriteria -and $next -notmatch '^- ') {
        $inCriteria = $false
      }

      $j++
    }

    $bodyLines = @(
      "## Fase",
      "- $phaseCode - $phaseName",
      "",
      "## Prioridad",
      "- $priority",
      "",
      "## Dependencias",
      "- $dependencies",
      "",
      "## Entregable",
      "- $deliverable",
      "",
      "## Criterios de aceptacion"
    )

    if ($criteria.Count -eq 0) {
      $bodyLines += "- Definir criterios de aceptacion para este ticket."
    } else {
      foreach ($c in $criteria) {
        $bodyLines += "- $c"
      }
    }

    $bodyLines += @(
      "",
      "## Checklist",
      "- [ ] Implementacion completa",
      "- [ ] Pruebas ejecutadas",
      "- [ ] Documentacion actualizada"
    )

    $labels = "backlog,phase:$phaseCode,priority:$priority"
    $issue = [PSCustomObject]@{
      ID      = $id
      Title   = "[$id] $title"
      Phase   = $phaseCode
      Priority= $priority
      Labels  = $labels
      Body    = ($bodyLines -join "`n")
    }
    $issues += $issue

    $i = $j - 1
  }
}

$outDirCsv = Split-Path -Path $CsvOut -Parent
$outDirMd = Split-Path -Path $MdOut -Parent
if ($outDirCsv -and -not (Test-Path $outDirCsv)) { New-Item -ItemType Directory -Path $outDirCsv -Force | Out-Null }
if ($outDirMd -and -not (Test-Path $outDirMd)) { New-Item -ItemType Directory -Path $outDirMd -Force | Out-Null }

$issues | Select-Object Title,Body,Labels,Phase,Priority,ID | Export-Csv -Path $CsvOut -NoTypeInformation -Encoding UTF8

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Import de Issues desde Backlog")
$md.Add("")
$md.Add('Generado automaticamente desde `BACKLOG.md`.')
$md.Add("")
$md.Add("Total de issues: $($issues.Count)")
$md.Add("")
$md.Add("## Lista")
$md.Add("")

foreach ($issue in $issues) {
  $md.Add("### $($issue.Title)")
  $md.Add(("- Labels: {0}" -f $issue.Labels))
  $md.Add(("- Prioridad: {0}" -f $issue.Priority))
  $md.Add(("- Fase: {0}" -f $issue.Phase))
  $md.Add("")
  $md.Add('```markdown')
  $md.Add($issue.Body)
  $md.Add('```')
  $md.Add("")
}

$md | Set-Content -Path $MdOut -Encoding UTF8

Write-Output "CSV generado: $CsvOut"
Write-Output "Markdown generado: $MdOut"
Write-Output "Issues detectados: $($issues.Count)"
