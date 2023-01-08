﻿using System.Security.Claims;
using Application.Common.Interfaces;
using Infrastructure.Identity;
using MediatR;

namespace Application.Account.Commands
{
    public class SignInByGoogleCommand : IRequest<string>
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
    }
    public class SignInByGoogleCommandHandler : IRequestHandler<SignInByGoogleCommand, string>
    {
        private readonly IAccountRepository _accountRepository;
        private readonly IJwtBuilder _jwtBuilder;
        public SignInByGoogleCommandHandler(
            IAccountRepository accountRepository,
            IJwtBuilder jwtBuilder)
        {
            _accountRepository = accountRepository;
            _jwtBuilder = jwtBuilder;
        }
        public async Task<string> Handle(SignInByGoogleCommand request, CancellationToken cancellationToken)
        {
            if (!await _accountRepository.IsExistAccount(request.Id))
            {
                await _accountRepository.CreateAccount(request.Id);
                return _jwtBuilder
                    .AddSubscriptionClaims(1, TimeSpan.FromDays(30))
                    .AddName(request.Name)
                    .GetNewJwt(TimeSpan.FromDays(30));
            }
            else
            {
                var id = await _accountRepository.GetUserByGoogleId(request.Id) ?? throw new Exception();
                var subscription = await _accountRepository.GetSubscription(id);

                if (subscription == null)
                {
                    return _jwtBuilder
                        .AddName(request.Name)
                        .GetNewJwt(TimeSpan.FromDays(30));
                }
                else
                {
                    return _jwtBuilder
                        .AddName(request.Name)
                        .AddSubscriptionClaims(subscription.Level, subscription.Valid)
                        .GetNewJwt(TimeSpan.FromDays(30));
                }
            }
        }
    }
}
