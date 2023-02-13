using Application.Account.Tokens;
using Application.Common.Interfaces;

namespace Infrastructure.Identity
{
    public class TokenService : ITokenService
    {
        public Task<TokensResponse> LoginByEmailAsync(string email)
        {
            throw new NotImplementedException();
        }

        public Task<TokensResponse> RefreshTokensAsync(RefreshTokenRequest model)
        {
            throw new NotImplementedException();
        }
    }
}
