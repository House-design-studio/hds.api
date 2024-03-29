﻿using System.Security.Claims;
using Application.Account.Commands;
using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Server.Controllers;

[ApiController]
[Route("api/account")]
public class AccountController : Controller
{
    private readonly IMediator _mediator;

    private string? _baseUri;

    public AccountController(IMediator mediator)
    {
        _mediator = mediator;
    }

    private string BaseUri
    {
        get => _baseUri ??= "https://" + HttpContext.Request.Host.ToUriComponent();
        set => _baseUri = value;
    }

    [AllowAnonymous]
    [HttpGet("login")]
    public IActionResult SignIn()
    {
        return Challenge(new AuthenticationProperties { RedirectUri = BaseUri + "/api/account/callback" },
            GoogleDefaults.AuthenticationScheme);
    }

    [Authorize]
    [HttpGet("callback")]
    public async Task<string> SignInCallback()
    {
        // TODO: refresh tokens

        var user = User;

        var newToken = await _mediator.Send(new SignInByGoogleCommand
        {
            Id = User
                .Claims
                .Single(c => c.Type == ClaimTypes.NameIdentifier)
                .Value,
            Name = User
                .Claims
                .Single(c => c.Type == ClaimTypes.Name)
                .Value
        });
        try
        {
            await HttpContext.SignOutAsync();
        }
        catch
        {
        }

        return newToken;
    }
}