using Core.Common.Interfaces;
using Core.Services;
using Microsoft.Extensions.DependencyInjection;

namespace Core;

public static class ConfigureServices
{
    public static IServiceCollection AddCoreServices(this IServiceCollection services)
    {
        services.AddScoped(typeof(ILoadsCalculator<>), typeof(LoadsCalculator<>));
        return services;
    }
}