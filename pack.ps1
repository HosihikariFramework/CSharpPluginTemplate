# Pack the source plugin with the framework's packer. The packer restores
# #:package dependencies and copies #:include files.
#
# Requires a sibling PluginManager checkout, or HOSIHIKARI_PLUGINMANAGER.
$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$core = if ($env:HOSIHIKARI_PLUGINMANAGER) {
    $env:HOSIHIKARI_PLUGINMANAGER
} else {
    Join-Path (Split-Path -Parent $here) 'PluginManager'
}
$tool = Join-Path $core 'tools\Pack\Hosihikari.Plugin.Pack.csproj'
if (-not (Test-Path $tool)) {
$packerMessages = @{
    ar = 'لم يتم العثور على أداة التغليف الأساسية: {0}. شغّل من نسخة تحتوي على Hosihikari.PluginManager بجانبها، أو اضبط HOSIHIKARI_PLUGINMANAGER.'
    fr = 'Outil de packaging principal introuvable : {0}. Lancez depuis une copie avec Hosihikari.PluginManager à côté, ou définissez HOSIHIKARI_PLUGINMANAGER.'
    ru = 'Основной упаковщик не найден: {0}. Запустите из копии с соседним Hosihikari.PluginManager или задайте HOSIHIKARI_PLUGINMANAGER.'
    es = 'No se encontró el empaquetador principal: {0}. Ejecuta desde una copia con Hosihikari.PluginManager al lado, o define HOSIHIKARI_PLUGINMANAGER.'
    zh = '找不到核心打包器：{0}。请并列检出 Hosihikari.PluginManager，或设置 HOSIHIKARI_PLUGINMANAGER。'
}
$packerLanguage = [System.Globalization.CultureInfo]::CurrentUICulture.TwoLetterISOLanguageName
$packerFormat = $packerMessages[$packerLanguage]
if (-not $packerFormat) {
    $packerFormat = 'Core packer not found: {0}. Run with a sibling Hosihikari.PluginManager checkout, or set HOSIHIKARI_PLUGINMANAGER.'
}
throw ($packerFormat -f $tool)
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
