# Pack the source plugin with the framework's packer. The packer restores
# #:package dependencies and copies #:include files.
#
# Requires a sibling Hosihikari.PluginManager checkout, or HOSIHIKARI_PLUGINMANAGER.
$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$core = if ($env:HOSIHIKARI_PLUGINMANAGER) {
    $env:HOSIHIKARI_PLUGINMANAGER
} else {
    Join-Path (Split-Path -Parent $here) 'Hosihikari.PluginManager'
}
$tool = Join-Path $core 'tools\Pack\Hosihikari.Plugin.Pack.csproj'
if (-not (Test-Path $tool)) {
    throw "找不到核心打包器：$tool。请并列检出 Hosihikari.PluginManager，或设置 HOSIHIKARI_PLUGINMANAGER。"
}

# 打包器拒绝输出目录与源目录相交；先复制到临时目录，排除仓库元数据与旧产物。
$stage = Join-Path $env:TEMP ("hosihikari-template-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force $stage | Out-Null
try {
    Get-ChildItem -Force $here |
        Where-Object { $_.Name -notin @('.git', 'dist', 'bin', 'obj') } |
        Copy-Item -Destination $stage -Recurse -Force

    dotnet run --project $tool -c Release -- pack-plugin $stage (Join-Path $here 'manifest.json') (Join-Path $here 'dist')
} finally {
    if (Test-Path $stage) {
        Remove-Item -Recurse -Force $stage -ErrorAction SilentlyContinue
    }
}
