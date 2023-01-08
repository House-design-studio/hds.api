using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HDS.Server.Controllers
{
    [ApiController]
    [Route("api/account")]
    public class AccountController : Controller
    {
        private readonly IMediator _mediator;

        private string? _baseUri;

        private string BaseUri
        {
            get => _baseUri ??= "https://" + HttpContext.Request.Host.ToUriComponent();
            set => _baseUri = value;
        }
        public AccountController(IMediator mediator)
        {
        }

        [AllowAnonymous]
        [HttpGet("login")]
        public IActionResult SignIn()
        {
            return Challenge(new AuthenticationProperties { RedirectUri = BaseUri + "/api/account/callback" }, GoogleDefaults.AuthenticationScheme);
        }

        [Authorize]
        [HttpGet("callback")]
        public async Task<string> SignInCallback()
        { // TODO: refresh tokens
            // тут будут клёвый кук с 5 клаймами гугла - наш аналог логина и пароля
            var user = User;


            /*
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
            return "new token";
        }
    }
}
