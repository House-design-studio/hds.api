using System.Security.Claims;
using Application.Account.Tokens;
using Application.Common.Interfaces;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace Server.Controllers;

[ApiController]
[Route("api/account")]
public class AccountController : Controller
{
    private readonly ITokenService _tokenService;

    public AccountController(ITokenService tokenService)
    {
        _tokenService = tokenService;
    }

    /// <summary>
    /// redirects to google login page
    /// </summary>
    /// <returns></returns>
    [Route("/login-google")]
    [AllowAnonymous]
    public IActionResult RedirectToGoogle()
    {
        var options = new AuthenticationProperties()
        {
            RedirectUri = "/google-exchange"
        };
        return new ChallengeResult(GoogleDefaults.AuthenticationScheme, options);
    }

    /// <summary>
    /// exchange google cookies to jwt tokens
    /// </summary>
    /// <returns>jwt tokens</returns>
    [Route("/google-exchange")]
    [Authorize(AuthenticationSchemes = "Identity.External")] // IdentityConstants.ExternalScheme is a readonly parameter. Probably it will be fixed in dotnet 8
    public async Task<IActionResult> LoginWithGoogle()
    {
        var googleId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        await HttpContext.SignOutAsync(IdentityConstants.ExternalScheme);

        if (String.IsNullOrEmpty(googleId)) return Unauthorized("Google cookies not found");

        return Ok(await _tokenService.LoginByGoogleAsync(googleId));
    }

    /// <summary>
    /// refresh expired access token
    /// </summary>
    /// <param name="model">access and refresh token</param>
    /// <returns>jwt tokens</returns>
    [Route("/refresh")]
    [AllowAnonymous]
    public async Task<IActionResult> RefreshTokens(RefreshTokenRequest model)
    {
        return Ok(await _tokenService.RefreshTokensAsync(model));
    }
}