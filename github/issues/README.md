# Importacion de Issues

## Archivos

- `github/issues/backlog_issues.csv`: lista exportada desde `BACKLOG.md`
- `github/issues/BACKLOG_ISSUES_IMPORT.md`: version legible para copy/paste

## Regenerar export

```powershell
.\scripts\export_backlog_issues.ps1
```

## Crear issues con GitHub CLI

Prerequisito: `gh auth login` y permisos en el repo.

Dry run:

```powershell
.\scripts\create_github_issues_from_csv.ps1 -DryRun
```

Creacion real:

```powershell
.\scripts\create_github_issues_from_csv.ps1
```

Si no quieres aplicar labels:

```powershell
.\scripts\create_github_issues_from_csv.ps1 -SkipLabels
```
