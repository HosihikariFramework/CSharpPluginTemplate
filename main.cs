using Hosihikari;
using Microsoft.Extensions.Logging;

/// <summary>The C# provider finds this public parameterless type and constructs it.</summary>
public sealed class MyCSharpPlugin : IPlugin
{
    public void OnLoad(IPluginContext context)
    {
        context.Logger.LogInformation(
            "{Name} loaded from {Directory}",
            context.Name,
            context.PackageDirectory);
    }

    public PluginHookResult OnEnable() => PluginHookResult.Allow();

    public PluginHookResult OnDisable() => PluginHookResult.Allow();

    public void OnUnload()
    {
    }
}
