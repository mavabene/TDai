$ErrorActionPreference = 'Stop'
$source = [IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent)).TrimEnd('\')
$destination = [IO.Path]::GetFullPath('C:\Users\jcheney\Box\Jam\Documents\ojjoDev\TD_Projects\Jam_TD3_box\prod_dev_ai').TrimEnd('\')
if ($source -eq $destination -or $destination.StartsWith($source + '\', [StringComparison]::OrdinalIgnoreCase) -or $source.StartsWith($destination + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Source/destination overlap' }
if (Test-Path -LiteralPath (Join-Path $source '.git\index.lock')) { throw 'Git index is busy; retry after Git operations finish' }
if (-not (Test-Path -LiteralPath $destination -PathType Container)) { throw 'Configured Box folder is unavailable' }

# Full workspace copy; retain existing older versions and unrelated Box files.
# Compatibility paths also update the existing flat code layout in Box.
$mappings = @(
    @($source, $destination),
    @((Join-Path $source 'Production_dev\TD3-Auto'), (Join-Path $destination 'TD3-Auto')),
    @((Join-Path $source 'Production_dev\TD3-HMI'), (Join-Path $destination 'TD3-HMI')),
    @((Join-Path $source 'Production_dev\libraries'), (Join-Path $destination 'Libraries'))
)
$manifest = @()
foreach ($mapping in $mappings) {
    foreach ($file in Get-ChildItem -LiteralPath $mapping[0] -Recurse -Force -File) {
        $relative = $file.FullName.Substring($mapping[0].Length).TrimStart('\')
        $target = [IO.Path]::GetFullPath((Join-Path $mapping[1] $relative))
        if (-not $target.StartsWith($destination + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Copy target escapes Box folder' }
        $manifest += [pscustomobject]@{ Source=$file.FullName; Destination=$target; SHA256=(Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash }
    }
}
foreach ($mapping in $mappings) {
    & robocopy $mapping[0] $mapping[1] /E /COPY:DAT /DCOPY:DAT /R:1 /W:1 /XJ /NFL /NDL /NJH /NJS /NP
    if ($LASTEXITCODE -ge 8) { throw ('Box copy failed with robocopy code ' + $LASTEXITCODE) }
}
$verified = 0
foreach ($entry in $manifest) {
    if ((Get-FileHash -LiteralPath $entry.Source -Algorithm SHA256).Hash -ne $entry.SHA256) { throw ('Source changed during backup: ' + $entry.Source) }
    if ((Get-FileHash -LiteralPath $entry.Destination -Algorithm SHA256).Hash -ne $entry.SHA256) { throw ('Box copy mismatch: ' + $entry.Destination) }
    $verified++
}
$result = [ordered]@{status='verified_local_copy'; completed_utc=[DateTime]::UtcNow.ToString('o'); destination=$destination; verified_files=$verified; deleted_files=0; cloud_sync='not_verified'}
$result | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $source '.box-copy-result.json') -Encoding utf8
Copy-Item -LiteralPath (Join-Path $source '.box-copy-result.json') -Destination (Join-Path $destination '.box-copy-result.json')
$result | ConvertTo-Json
