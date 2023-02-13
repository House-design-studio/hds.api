using Application.Account.Tokens;
using Application.Common.Interfaces;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;

namespace Infrastructure.Identity
{
    public class TokenService : ITokenService
    {
        private readonly TokenServiceConfig _config;

        public TokenService(
            IConfigureOptions<TokenServiceConfig> configureOptions)
        {
            configureOptions.Configure(_config = new TokenServiceConfig());
        }   

        public Task<TokensResponse> LoginByEmailAsync(string email)
        {
            throw new NotImplementedException();
        }

        public Task<TokensResponse> RefreshTokensAsync(RefreshTokenRequest model)
        {
            throw new NotImplementedException();
        }
        private string GenerateAccessToken(IEnumerable<Claim> claims)
        {
            var token = new JwtSecurityToken(
                issuer: _config.Issuer,
                audience: _config.Audience,
                claims: claims,
                expires: DateTime.UtcNow.AddDays(_config.AccessTokenExpireTimeInDays),
                signingCredentials: new SigningCredentials(_config.GetSymmetricSecurityKey(), SecurityAlgorithms.HmacSha256));

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
        
        private string GenerateRefreshToken()
        {
            var randomNumber = new byte[192];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(randomNumber);
            return Convert.ToBase64String(randomNumber);
        }
    }
}
