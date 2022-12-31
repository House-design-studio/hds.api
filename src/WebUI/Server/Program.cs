using HDS.Core.Beam;
using HDS.Core.Interfaces;
using HDS.Core.Services;
using HDS.Server.Models.Database;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();

try
{

    var builder = WebApplication.CreateBuilder(args);

    // Add services to the container.
    builder.Services.AddHttpClient();

    string connection = builder.Configuration.GetConnectionString("DefaultConnection");
    builder.Services.AddDbContext<ApplicationDbContext>(options => options.UseNpgsql(connection));

    builder.Services.AddScoped<IBeamCalculator, BeamCalculator>();
    builder.Services.AddScoped<IFemClient, FemClient>();
    builder.Services.AddScoped(typeof(LoadsCalculator<>));

    builder.Services.AddAuthentication(options =>
        {
            options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
            options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;
        })
        .AddCookie()
        .AddGoogle(options =>
        {
            options.ClientId = builder.Configuration["Oauth:Google:ClientId"];
            options.ClientSecret = builder.Configuration["Oauth:Google:ClientSecret"];
            options.SaveTokens = true;
        });

    builder.Services.AddAuthorization(options =>
    {
        options.AddPolicy("Subscriber 1", builder =>
        {
            builder.RequireAssertion(x => UserHaveSubscriptin(x, 1) && UserSubscriptionValid(x));
        });
        options.AddPolicy("Subscriber 2", builder =>
        {
            builder.RequireAssertion(x => UserHaveSubscriptin(x, 2) && UserSubscriptionValid(x));
        });

        bool UserHaveSubscriptin(AuthorizationHandlerContext context, int level)
        {
            if (level == 1)
            {
                return (context.User.HasClaim("SubscriptionLevel", "1") || context.User.HasClaim("SubscriptionLevel", "2"));
            }
            else if (level == 2)
            {
                return context.User.HasClaim("SubscriptionLevel", "2");
            }
            else
            {
                throw new Exception();
            }
        }

        bool UserSubscriptionValid(AuthorizationHandlerContext context)
        {
            var currentTime = DateOnly.FromDateTime(DateTime.Now);
            var userTime = context.User.Claims.FirstOrDefault(c => c.Type == "SubscriptionTime") ?? throw new Exception();
            return (DateOnly.Parse(userTime.Value) > currentTime);
        }
    });
    builder.Services.AddMvc();

    builder.Host.UseSerilog();
    var app = builder.Build();

    // Configure the HTTP request pipeline. 
    if (!app.Environment.IsDevelopment())
    {
        // app.UseExceptionHandler("/Home/Error");
        // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
        app.UseHsts();
    }
    app.UseHttpsRedirection();

    app.UseBlazorFrameworkFiles();
    app.UseStaticFiles();
    app.UseRouting();

    app.UseAuthentication();
    app.UseAuthorization();
    app.UseCookiePolicy();

    app.MapFallbackToFile("index.html");

    //app.MapControllerRoute(
    //    name: "default",
    //    pattern: "{controller=Home}/{action=Index}");

    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Application terminated unexpectedly");
}
finally
{
    Log.CloseAndFlush();
}