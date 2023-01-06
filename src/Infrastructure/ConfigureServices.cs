using HDS.Infrastructure.Database;
using HDS.MathCore.Common.Interfaces;
using HDS.MathCore.FemCalculator;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace Microsoft.Extensions.DependencyInjection
{
    public static class ConfigureServices
    {
        public static IServiceCollection AddInfrastructureServices(this IServiceCollection services, IConfiguration configuration)
        {
            string connection = configuration.GetValue<string>("Database:ConnectionString") ?? throw new ApplicationException("undefined connection string");
            services.AddDbContext<ApplicationDbContext>(options => options.UseNpgsql(connection));
            services.AddScoped<IFemCalculator, FemClient>();
            return services;
        }
    }
}
