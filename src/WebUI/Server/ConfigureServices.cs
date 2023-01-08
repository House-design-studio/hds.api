using Infrastructure.Identity;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Security.Claims;

namespace Microsoft.Extensions.DependencyInjection
{
    public static partial class ConfigureServices
    {
        public static IServiceCollection AddServerServices(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddControllers();
            services.AddCors();

            services.AddSwaggerGen(options =>
            {
                options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    In = ParameterLocation.Header,
                    Description = "Please enter a valid token",
                    Name = "Authorization",
                    Type = SecuritySchemeType.Http,
                    BearerFormat = "JWT",
                    Scheme = "Bearer"
                });
                options.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type=ReferenceType.SecurityScheme,
                                Id="Bearer"
                            }
                        },
                        Array.Empty<string>()
                    }
                });
            });

            services.AddAuthentication(options =>
                {
                    options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;
                })
                .AddJwtBearer(options =>
                {
                    var jwtOptions = new JwtBuilderConfig(configuration.GetRequiredSection("Auth:Jwt"));
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidIssuer = jwtOptions.Issuer,
                        ValidateAudience = true,
                        ValidAudience = jwtOptions.Audience,
                        ValidateLifetime = true,
                        IssuerSigningKey = jwtOptions.GetSymmetricSecurityKey(),
                        ValidateIssuerSigningKey = true,
                    };
                })
                .AddGoogle(options =>
                {
                    options.ClientSecret = configuration.GetValue<string>("Auth:Google:ClientSecret")!;
                    options.ClientId = configuration.GetValue<string>("Auth:Google:ClientId")!;
                    options.SaveTokens = false;
                });

            services.AddAuthorizationBuilder()
                .AddPolicy("subscriber_1", policy => policy
                    .RequireAssertion(context =>
                        context.User.IsInRole("admin") ||
                        context.User.HasValidSubscription(1) ||
                        context.User.HasValidSubscription(2)))
                .AddPolicy("subscriber_2", policy => policy
                    .RequireAssertion(context =>
                        context.User.IsInRole("admin") ||
                        context.User.HasValidSubscription(2)))
                .AddPolicy("admin", policy => policy
                    .RequireRole("admin"));
            return services;
        }
        private static bool HasValidSubscription(this ClaimsPrincipal user, int level)
        {
            var userTimeClaim = user.FindFirst(CustomClaimTypes.SubscriptionTime);
            if (userTimeClaim == null) return false;
            var userCurrentTime = DateOnly.Parse(userTimeClaim.Value);

            var currentTime = DateOnly.FromDateTime(DateTime.UtcNow);

            return user.HasClaim(CustomClaimTypes.SubscriptionLevel, level.ToString()) &&
                   (userCurrentTime > currentTime);
        }
        // TODO: move this class to other place (mb infrastructure)
    }
}
