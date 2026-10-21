# CSharpPluginTemplate

A minimal source-compiled C# plugin for the Hosihikari framework. The C# provider compiles
`main.cs` at load with Roslyn and runs it in a collectible ALC; there is no build step for the
author.

## Use it

1. Copy this repository into your server as `plugins/MyCSharpPlugin/`.
2. Rename the plugin: change `manifest.json` `name`, rename `MyCSharpPlugin.conf`, and rename the
   class in `main.cs`. The package directory name must equal the manifest `name`.
3. Install the shim variant for the server and the C# provider:

   ```powershell
   lip install github.com/HosihikariFramework/Shim#levilamina   # or #endstone
   lip install github.com/HosihikariFramework/CSharpProvider
   ```

4. Restart the server. The log shows the plugin loading and enabling.

For the self-hosted Linux carrier, install the suffix-less shim package and start the server through
`hosihikari-server`; providers and plugins still live under `plugins/`.

## Files

- `manifest.json` — `provider: csharp`, depends on `hosihikari` and `hosihikari-csharp`.
- `main.cs` — a public parameterless type implementing `IPlugin`.
- `MyCSharpPlugin.conf` — package defaults.

## Configuration and data

- Package defaults: `plugins/<name>/<name>.conf`.
- Server override: `config/hosihikari/<name>.conf`.
- Environment variables override the same keys.
- Runtime data: `data/hosihikari/<name>/`.

## Lifecycle

`OnLoad` runs after dependencies are ready. `OnEnable` opens the event/timer gate; a refusal keeps
the plugin loaded and disabled. `OnUnload` releases what the plugin owns. An exception from a hook
is a fault and the host unloads the plugin.

See the [authoring guide](https://hosihikariframework.github.io/authoring-csharp/) for the full
contract.

## Licence

MIT-0, see [LICENSE.md](LICENSE.md).
