#:package System.IO.Hashing@10.0.15
#:include parts/helper.cs

using System;
using System.IO.Hashing;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Hosihikari;
using Microsoft.Extensions.Logging;

/// <summary>The C# loader finds this public parameterless type and constructs it.</summary>
public sealed class MyCSharpPlugin : IPlugin
{
    public ValueTask OnLoad(IPluginContext context, CancellationToken cancellationToken)
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
        return ValueTask.CompletedTask;
    }

    public ValueTask<PluginHookResult> OnEnable(CancellationToken cancellationToken) =>
        ValueTask.FromResult(PluginHookResult.Allow());

    public ValueTask<PluginHookResult> OnDisable(CancellationToken cancellationToken) =>
        ValueTask.FromResult(PluginHookResult.Allow());

    public ValueTask OnUnload(CancellationToken cancellationToken) => ValueTask.CompletedTask;
}
