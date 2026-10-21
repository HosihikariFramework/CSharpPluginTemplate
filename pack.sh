#!/usr/bin/env bash
# Pack the source plugin with the framework's packer. The packer restores
# #:package dependencies and copies #:include files.
#
# Requires a sibling Hosihikari.PluginManager checkout, or HOSIHIKARI_PLUGINMANAGER.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
core=${HOSIHIKARI_PLUGINMANAGER:-"$(cd "$here/.." && pwd)/Hosihikari.PluginManager"}
tool="$core/tools/Pack/Hosihikari.Plugin.Pack.csproj"
if [ ! -f "$tool" ]; then
    echo "找不到核心打包器：$tool。请并列检出 Hosihikari.PluginManager，或设置 HOSIHIKARI_PLUGINMANAGER。" >&2
    exit 1
fi

# 打包器拒绝输出目录与源目录相交；先复制到临时目录，排除仓库元数据与旧产物。
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
(cd "$here" && tar -cf - --exclude=.git --exclude=dist --exclude=bin --exclude=obj .) |
    (cd "$stage" && tar -xf -)

dotnet run --project "$tool" -c Release -- pack-plugin "$stage" "$here/manifest.json" "$here/dist"
