using Application.Common.Interfaces;
using Infrastructure.Database;
using Infrastructure.Identity;
using Infrastructure.Repositories;
using MathCore.Common.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Infrastructure;

public static class ConfigureServices
{
    public static IServiceCollection AddInfrastructureServices(this IServiceCollection services,
        IConfiguration configuration)
    {
        var connection = configuration.GetValue<string>("ConnectionStrings:DefaultConnection")!;

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