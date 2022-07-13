using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace website.Controllers
{
    [AllowAnonymous]
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}