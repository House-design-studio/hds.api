var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddMvc();
builder.Services.AddAuthentication()
    .AddGoogle(opt =>
    {
        //
        //opt.CallbackPath = "/signin-google";
        opt.ClientId = "85698311721-oirjtrrfhln6bhite8g4hig2sfd2iend.apps.googleusercontent.com";
        opt.ClientSecret = "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";
    });

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}");

app.Run();
