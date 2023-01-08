using HDS.Application.WoodenConstruction.Queries.GetBeamFull;
using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace HDS.Server.Controllers
{
    [ApiController]
    [Route("api/beam")]
    public class BeamController : Controller
    {
        private readonly IMediator _mediator;
        public BeamController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("full_report")]
        public async Task<FullBeamVM> IndexAsync(
            [FromBody] GetBeamFullQuery query)
            => await _mediator.Send(query);

        [HttpPost("test")]
        public async Task<IActionResult> Test()
        {
            var identity = new ClaimsIdentity(new List<Claim>() { new Claim("test", "result") });
            var principal = new ClaimsPrincipal(identity);
            await HttpContext.SignInAsync(JwtBearerDefaults.AuthenticationScheme, principal);

            Console.WriteLine();
            return Ok();
        }
    }
}