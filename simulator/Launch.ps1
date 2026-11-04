$ErrorActionPreference = 'Stop'
$nodeCommand = Get-Command node -ErrorAction SilentlyContinue
$nodePath = if ($nodeCommand) { $nodeCommand.Source } else { Join-Path $env:USERPROFILE '.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node.exe' }
if (!(Test-Path -LiteralPath $nodePath)) {
    if (!(Test-Path -LiteralPath (Join-Path $PSScriptRoot 'viewer.js'))) { throw 'Node.js is required to build the viewer. Install Node.js LTS and dependencies, then launch again.' }
} else {
    & $nodePath (Join-Path $PSScriptRoot 'build.mjs')
    if ($LASTEXITCODE -ne 0) { throw 'Viewer build failed. Install dependencies with pnpm install (or npm install) in the simulator folder, then try again.' }
}
Start-Process (Join-Path $PSScriptRoot 'index.html')
Write-Host 'TD3 model opened from disk. No local server is required.'