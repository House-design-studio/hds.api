using Application.Common.Interfaces;
using HDS.Infrastructure.Database;
using HDS.MathCore.Common.Interfaces;
using HDS.MathCore.FemCalculator;
using Infrastructure.Identity;
using Infrastructure.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace Microsoft.Extensions.DependencyInjection
{
    public static class ConfigureServices
    {
        public static IServiceCollection AddInfrastructureServices(this IServiceCollection services,
            IConfiguration configuration)
        {
            string connection = configuration.GetValue<string>("ConnectionStrings:DefaultConnection")!;

            services.AddDbContext<ApplicationDbContext>(options => options.UseNpgsql(connection));
            
            services.AddScoped<IFemCalculator, FemClient>();                                                                                                                                                                                                                                                       
            services.AddScoped<IAccountRepository, AccountRepository>();
            services.AddJwtBuilder(options =>
            {
                options.Issuer = configuration.GetValue<string>("Auth:Jwt:Issuer")!;
                options.Audience = configuration.GetValue<string>("Auth:Jwt:Audience")!;
                options.Key = configuration.GetValue<string>("Auth:Jwt:Key")!;
            });
            return services;
        }

        private static IServiceCollection AddJwtBuilder(this IServiceCollection services,
            Action<JwtBuilderConfig> optionsAction)
        {
            return services.AddTransient<IJwtBuilder, JwtBuilder>()
                    .Configure(optionsAction);
        }
    }
}
