using HDS.Core.Common.Interfaces;
using HDS.Core.Services;

namespace Microsoft.Extensions.DependencyInjection
{
    public static class ConfigureServices
    {
        public static IServiceCollection AddCoreServices(this IServiceCollection services)
        {
            services.AddScoped(typeof(ILoadsCalculator<>), typeof(LoadsCalculator<>));
            return services;
        }
    }
}
