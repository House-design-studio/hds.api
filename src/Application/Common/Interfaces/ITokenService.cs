using Application.Account.Tokens;

namespace Application.Common.Interfaces;

public interface ITokenService
{
    Task<TokensResponse> LoginByEmailAsync(string email); 
    Task<TokensResponse> RefreshTokensAsync(RefreshTokenRequest model);
}

