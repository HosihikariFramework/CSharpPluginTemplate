# CSharpPluginTemplate

A minimal source-compiled C# plugin for the Hosihikari framework. The C# loader compiles
`main.cs` at load with Roslyn and runs it in a collectible ALC; there is no build step for the
author.

## Use it

1. Keep this repository outside the server. Rename the plugin: change `manifest.json` `name`,
   rename `MyCSharpPlugin.conf`, and rename the class in `main.cs`. The package directory name must
   equal the manifest `name`.
2. Pack it with the framework packer. It restores `#:package` and copies the included source:

   ```powershell
   pwsh ./pack.ps1
   ```

   ```bash
   bash ./pack.sh
   ```

   The packer needs a sibling `PluginManager` checkout, or
   `HOSIHIKARI_PLUGINMANAGER` pointing at one.
3. Copy `dist/MyCSharpPlugin/` to `<server>/plugins/MyCSharpPlugin/`.
4. Install the carrier bundle and the C# loader with Seiko:

   ```powershell
   sk init                                  # once per server root
   sk add hosihikari-hosting-levilamina     # LeviLamina
   # or: sk add hosihikari-hosting-endstone
   # or: sk add hosihikari-hosting-selfhosted
   sk add hosihikari-csharp
   ```

5. Restart the server. The log shows the plugin loading and enabling.

For the self-hosted carriers, `sk add hosihikari-hosting-selfhosted` selects Windows or Linux; start the server through `hosihikari-server` (`hosihikari-server.exe` on Windows). Loaders and plugins still live under `plugins/`.

## Files

- `manifest.json` — `loader: csharp`, depends on `hosihikari` and `hosihikari-csharp`.
- `main.cs` — a public parameterless type implementing `IPlugin`. It also demonstrates two
  file-based directives: `#:package System.IO.Hashing@10.0.13` and `#:include parts/helper.cs`.
- `parts/helper.cs` — compiled with `main.cs` through `#:include`.
- `pack.ps1` / `pack.sh` — run the framework packer; `dist/MyCSharpPlugin/` is the installable package.
- `MyCSharpPlugin.conf` — package defaults.

The packer restores `#:package` at pack time and copies the included source; the server does not
download packages when it loads the plugin. `#:include` paths are relative to the including file
and may use globs such as `../shared/*.cs`.

## Configuration and data

- Package defaults: `plugins/<name>/<name>.conf`.
- Server override: `config/hosihikari/<name>.conf`.
- Environment variables override the same keys.
- Runtime data: `data/hosihikari/<name>/`.

## Lifecycle

`OnLoad` runs after dependencies are ready. `OnEnable` opens the event/timer gate; a refusal keeps
the plugin loaded and disabled. `OnUnload` releases what the plugin owns. An exception from a hook
is a fault and the host unloads the plugin.

See the [authoring guide](https://hoshi.srcz.one/framework/develop/authoring-csharp/) for the full
contract.

## Licence

MIT-0, see [LICENSE.md](LICENSE.md).
