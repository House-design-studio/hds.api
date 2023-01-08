using Serilog;
using Server.Middlewares;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();

try
{
    var builder = WebApplication.CreateBuilder(args);

    builder.Services.AddHttpClient();

    builder.Services.AddServerServices(builder.Configuration);
    builder.Services.AddApplicationServices();
    builder.Services.AddInfrastructureServices(builder.Configuration);
    builder.Services.AddCoreServices();


    builder.Host.UseSerilog();
    var app = builder.Build();

    
    if (!app.Environment.IsDevelopment())
    {
        app.UseExceptionsMiddleware();
        app.UseHsts();
    }
    app.UseCors(corsPolicyBuilder => corsPolicyBuilder.AllowAnyOrigin());
    app.UseHttpsRedirection();

    if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI();
        app.UseWebAssemblyDebugging();
    }
    //app.UseBlazorFrameworkFiles();
    app.UseStaticFiles();
    app.UseRouting();

    app.UseCookiePolicy();
    app.UseAuthentication();
    app.UseAuthorization();

    app.MapControllers();
    //app.MapFallbackToFile("index.html");

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