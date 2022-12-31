using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HDS.Server.Controllers
{
    public class AccountController : Controller
    {
        public AccountController()
        {
        }

        [AllowAnonymous]
        public IActionResult SignIn(string provider, string returnUrl)
        {
            return Challenge(new AuthenticationProperties { RedirectUri = "https://localhost:3001/Account/SignInCallback" }, provider);

        }

        [Authorize]
        public async Task<IActionResult> SignInCallback()
        {/*
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
                _logger.LogInformation($"Registration. userId : {user.UserId}");
            }

            var userSubscriptions = await _db.Subscriptions.Where(s => s.UserId == user.UserId).ToListAsync();
            if (userSubscriptions is not null)
            {
                var lastSubscriptinTime = userSubscriptions.Max(s => s.Valid);
                var subscriptionLevel = userSubscriptions.Find(s => s.Valid == lastSubscriptinTime)?.SubscriptionLevelId;

                newClaims = new List<Claim>()
                {
                    new Claim("SubscriptionLevel", $"{subscriptionLevel}"),
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
            newClaims.Add(User.Claims.First(c => c.Type == ClaimTypes.Name));
            newClaims.Add(new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()));

            _logger.LogInformation($"SignIn. userId : {user.UserId}");

            var applicationClaimsIdentity = new ClaimsIdentity(newClaims, "Cookies");
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(applicationClaimsIdentity));
            // потеря всех данных с гугла
            await _db.SaveChangesAsync();
            return Redirect("/Account/");
        }

        [Authorize, ActionName("SignOut")]
        public async Task<IActionResult> AccountSignOut()
        {
            await HttpContext.SignOutAsync();
            _logger.LogInformation($"SignOut. userId : {User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value}");
            return Redirect("/");
        }

        [Authorize]
        public IActionResult Index()
        {
            return View();
        }*/
            return Json(null);
        }
    }
}
