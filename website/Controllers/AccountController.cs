using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using website.Models.Database;

namespace website.Controllers
{
    public class AccountController : Controller
    {
        private readonly ApplicationDbContext _db;

        public AccountController(ApplicationDbContext dbContext)
        {
            _db = dbContext;
        }

        [AllowAnonymous]
        public IActionResult SignIn(string provider, string returnUrl)
        {
            return Challenge(new AuthenticationProperties { RedirectUri = "https://localhost:3001/Account/SignInCallback" }, provider);
            
        }

        [Authorize]
        public async Task<IActionResult> SignInCallback()
        {
            //переписываем signin гугла на signin куков
            var newClaims = new List<Claim>();
            
            string? userGoogleId = User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;
            if (userGoogleId == null)
            {
                return Redirect("/");
            }

            var user = await _db.Users.FirstOrDefaultAsync(u => u.OauthGoogle.Subject == userGoogleId);

            if (user is null)
            {
                user = new User
                    {
                        SignupDate = DateOnly.FromDateTime(DateTime.Now),
                        OauthGoogle = new OauthGoogle
                        {
                            Subject = userGoogleId
                        }
                    };
                await _db.Users.AddAsync(user);
            }

            var userSubscriptions = await _db.Subscriptions.Where(s => s.UserId == user.UserId).ToListAsync();
            if (userSubscriptions is not null)
            {
                var lastSubscriptinTime = userSubscriptions.Max(s => s.Valid);
                var subscriptionLevel = userSubscriptions.Find(s => s.Valid == lastSubscriptinTime)?.SubscriptionLevelId;

                newClaims = new List<Claim>()
                {
                    new Claim("SubscriptionLevel", $"{subscriptionLevel}") ,
                    new Claim("SubscriptionTime", $"{lastSubscriptinTime}")
                };
            }
            else
            {
                newClaims = new List<Claim>()
                {
                    new Claim("SubscriptionLevel", "0") ,
                    new Claim("SubscriptionTime", "01.01.9999")
                };
            }
            

            ClaimsIdentity applicationClaimsIdentity = new ClaimsIdentity(newClaims, "Cookies");
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(applicationClaimsIdentity));
            // потеря всех данных с гугла
            await _db.SaveChangesAsync();
            return Redirect("/");
        }
    }   
}
