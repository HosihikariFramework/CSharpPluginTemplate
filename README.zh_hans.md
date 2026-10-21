# CSharpPluginTemplate

星光框架的最小 C# 源码插件模板。C# loader 在装载时用 Roslyn 编译 `main.cs`，放进 collectible ALC 运行；作者不需要自己构建。

## 使用

1. 把本仓放在服务端目录之外。改名：改 `manifest.json` 的 `name`，重命名
   `MyCSharpPlugin.conf`，再改 `main.cs` 里的类名。包目录名必须与清单里的 `name` 一致。
2. 用框架打包器打包。它会还原 `#:package` 并复制 include 的源码：

   ```powershell
   pwsh ./pack.ps1
   ```

   ```bash
   bash ./pack.sh
   ```

   打包器需要同级的 `Hosihikari.PluginManager` 检出，或由 `HOSIHIKARI_PLUGINMANAGER` 指向一个。
3. 把 `dist/MyCSharpPlugin/` 复制到 `<服务端>/plugins/MyCSharpPlugin/`。
4. 按服务端安装 Shim 变体与 C# loader：

   ```powershell
   lip install github.com/HosihikariFramework/HostingShim#levilamina   # 或 #endstone
   lip install github.com/HosihikariFramework/CSharpLoader
   ```

5. 重启服务端，日志里会看到插件加载与启用。

自持态 Linux 用无后缀 Shim 包，并通过 `hosihikari-server` 启动；加载器与插件仍然放在 `plugins/` 下。

## 文件

- `manifest.json` —— `loader: csharp`，依赖 `hosihikari` 与 `hosihikari-csharp`。
- `main.cs` —— 实现 `IPlugin` 的公开无参类型，同时演示两个 file-based 指令：
  `#:package System.IO.Hashing@10.0.13` 与 `#:include parts/helper.cs`。
- `parts/helper.cs` —— 通过 `#:include` 与 `main.cs` 一起编译。
- `pack.ps1` / `pack.sh` —— 调用框架打包器；`dist/MyCSharpPlugin/` 是可安装的插件包。
- `MyCSharpPlugin.conf` —— 包内默认配置。

打包器在打包期还原 `#:package` 并复制 include 的源码；服务端装载插件时不下载包。
`#:include` 路径相对于当前文件，也可以用 `../shared/*.cs` 这类通配符。

## 配置与数据

- 包内默认：`plugins/<name>/<name>.conf`。
- 服务端覆盖：`config/hosihikari/<name>.conf`。
- 环境变量覆盖同名键。
- 运行期数据：`data/hosihikari/<name>/`。

## 生命周期

`OnLoad` 在依赖就绪后执行；`OnEnable` 打开事件/定时器闸门，拒绝则保持已加载未启用；
`OnUnload` 释放插件持有的东西。钩子抛出异常属于故障，宿主会卸载插件。

完整契约见[作者文档](https://hosihikariframework.github.io/zh/authoring-csharp/)。

## 许可

MIT-0，见 [LICENSE.md](LICENSE.md)。
