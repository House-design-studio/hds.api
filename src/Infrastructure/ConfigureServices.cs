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

        services.AddFemClient(options => options.Connection = configuration.GetValue<string>("Api:FemServer")!);
        services.AddTokenService(options =>
        {
            options.Issuer = configuration.GetValue<string>("Auth:Jwt:Issuer")!;
            options.Audience = configuration.GetValue<string>("Auth:Jwt:Audience")!;
            options.Key = configuration.GetValue<string>("Auth:Jwt:Key")!;
            options.AccessTokenExpireTime = TimeSpan.Parse(configuration.GetValue<string>("Auth:Jwt:AccessTokenTime")!);
            options.RefreshTokenExpireTime =
                TimeSpan.Parse(configuration.GetValue<string>("Auth:Jwt:RefreshTokenTime")!);
        });
        services.AddTransient<IUnitOfWork, UnitOfWork>();
        return services;
    }

    private static IServiceCollection AddFemClient(this IServiceCollection services,
        Action<FemClientConfig> optionsAction)
    {
        return services.AddScoped<IFemCalculator, FemClient>()
            .Configure(optionsAction);
    }

    private static IServiceCollection AddTokenService(this IServiceCollection services,
        Action<TokenServiceConfig> optionsAction)
    {
        return services.AddScoped<ITokenService, TokenService>()
            .Configure(optionsAction);
    }
}