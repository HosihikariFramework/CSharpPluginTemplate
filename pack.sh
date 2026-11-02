#!/usr/bin/env bash
# Pack the source plugin with the framework's packer. The packer restores
# #:package dependencies and copies #:include files.
#
# Requires a sibling PluginManager checkout, or HOSIHIKARI_PLUGINMANAGER.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
core=${HOSIHIKARI_PLUGINMANAGER:-"$(cd "$here/.." && pwd)/PluginManager"}
tool="$core/tools/Pack/Hosihikari.Plugin.Pack.csproj"
if [ ! -f "$tool" ]; then
packer_language=${LC_ALL:-}
if [ -z "$packer_language" ]; then
    packer_language=${LC_MESSAGES:-}
fi
if [ -z "$packer_language" ]; then
    packer_language=${LANG:-}
fi
packer_language=${packer_language%%_*}
packer_language=${packer_language%%.*}
case "$packer_language" in
    ar) packer_message='لم يتم العثور على أداة التغليف الأساسية: %s. شغّل من نسخة تحتوي على Hosihikari.PluginManager بجانبها، أو اضبط HOSIHIKARI_PLUGINMANAGER.' ;;
    fr) packer_message='Outil de packaging principal introuvable : %s. Lancez depuis une copie avec Hosihikari.PluginManager à côté, ou définissez HOSIHIKARI_PLUGINMANAGER.' ;;
    ru) packer_message='Основной упаковщик не найден: %s. Запустите из копии с соседним Hosihikari.PluginManager или задайте HOSIHIKARI_PLUGINMANAGER.' ;;
    es) packer_message='No se encontró el empaquetador principal: %s. Ejecuta desde una copia con Hosihikari.PluginManager al lado, o define HOSIHIKARI_PLUGINMANAGER.' ;;
    zh) packer_message='找不到核心打包器：%s。请并列检出 Hosihikari.PluginManager，或设置 HOSIHIKARI_PLUGINMANAGER。' ;;
    *) packer_message='Core packer not found: %s. Run with a sibling Hosihikari.PluginManager checkout, or set HOSIHIKARI_PLUGINMANAGER.' ;;
esac
printf "$packer_message
" "$tool" >&2
    exit 1
fi

# 打包器拒绝输出目录与源目录相交；先复制到临时目录，排除仓库元数据与旧产物。
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
(cd "$here" && tar -cf - --exclude=.git --exclude=dist --exclude=bin --exclude=obj .) |
    (cd "$stage" && tar -xf -)

dotnet run --project "$tool" -c Release -- pack-plugin "$stage" "$here/manifest.json" "$here/dist"
