# AGENTS.md

Source-compiled C# plugin template for the Hosihikari Framework. The C# loader compiles `main.cs`
at load; the package ships source and no build output.

## Repository map

- `main.cs` — plugin entry and hooks.
- `parts/` — files pulled in with `#:include`.
- `manifest.json` — package manifest (`loader: csharp`, `entry: main.cs`).
- `MyCSharpPlugin.conf` — package defaults.
- `pack.ps1`, `pack.sh` — invoke the core packer and write `dist/MyCSharpPlugin/`.

## Build and pack

```powershell
pwsh ./pack.ps1
```

```bash
bash ./pack.sh
```

The packer needs a sibling `PluginManager` checkout, or `HOSIHIKARI_PLUGINMANAGER` pointing at one.
The server never restores packages at load; `#:package` is resolved at pack time.

## Invariants

- The manifest `name`, package directory name, and `.conf` name stay aligned.
- Keep the `hosihikari-csharp` dependency and `extraInfo.loader: csharp`.
- Do not commit `dist/` or generated compiler output.
- After changing `main.cs`, verify the plugin loads and enables under a real server or the loader
  host.
- Public default branches are protected. Work on a branch, open a pull request, and squash merge.

## Context

- [C# plugin guide](https://hf.srcz.one/develop/authoring-csharp/).
- [C# loader](https://github.com/HosihikariFramework/CSharpLoader).
