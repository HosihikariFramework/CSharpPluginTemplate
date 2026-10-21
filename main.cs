#:package System.IO.Hashing@10.0.13
#:include parts/helper.cs

using System;
using System.IO.Hashing;
using System.Text;
using Hosihikari;
using Microsoft.Extensions.Logging;

/// <summary>The C# provider finds this public parameterless type and constructs it.</summary>
public sealed class MyCSharpPlugin : IPlugin
{
    public void OnLoad(IPluginContext context)
    {
        // The packer restores the #:package and copies the #:include file beside main.cs.
        var hash = Convert.ToHexStringLower(
            XxHash128.Hash(Encoding.UTF8.GetBytes(TemplateHelper.Message)));
        context.Logger.LogInformation(
            "{Name} loaded from {Directory} ({Message}, {Hash})",
            context.Name,
            context.PackageDirectory,
            TemplateHelper.Message,
            hash);
    }

    public PluginHookResult OnEnable() => PluginHookResult.Allow();

    public PluginHookResult OnDisable() => PluginHookResult.Allow();

    public void OnUnload()
    {
    }
}
