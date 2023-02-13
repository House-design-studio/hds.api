using Application.Account.Tokens;
using Application.Common.Interfaces;
using Core;
using Infrastructure.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace Infrastructure.Identity
{
    public class TokenService : ITokenService
    {
        private readonly TokenServiceConfig _config;
        private readonly IUnitOfWork _unitOfWork;

        public TokenService(
            IConfigureOptions<TokenServiceConfig> configureOptions, 
            IUnitOfWork unitOfWork)
        {
            configureOptions.Configure(_config = new TokenServiceConfig());
            _unitOfWork = unitOfWork;
        }

        public async Task<TokensResponse> LoginByGoogleAsync(string googleId)
        {
            var userRepository = _unitOfWork.Repository<User>();
            var user = await userRepository.Entities.FirstOrDefaultAsync(u => u.OauthGoogle.Subject == googleId);

            if (user == null)
            {
                user = User.SignUpWithSubscription();
                user.OauthGoogle.Subject = googleId;
            }
            
            var refreshToken = GenerateRefreshToken();
            user.RefreshTokenHash = ToHashToBase64(refreshToken);
            user.RefreshTokenExpireTime = DateTime.UtcNow + _config.RefreshTokenExpireTime;

            var accessToken = GenerateAccessToken(GetUserClaims(user));

            await _unitOfWork.Commit();
           
            return new TokensResponse 
            { 
                AccessToken = accessToken,
                RefreshToken = refreshToken,
                RefreshTokenExpireTime = DateTime.UtcNow + _config.RefreshTokenExpireTime
            };
        }

        public Task<TokensResponse> RefreshTokensAsync(RefreshTokenRequest model)
        {
            throw new NotImplementedException();
        }

        private static IList<Claim> GetUserClaims(User user)
        {
            var claims = new List<Claim>()
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString())
            };

            var bestSubscription = user.Subscriptions
                .Where(s => s.Valid > DateOnly.FromDateTime(DateTime.UtcNow))
                .OrderByDescending(s => s.SubscriptionLevel)
                .ThenByDescending(s => s.Valid)
                .FirstOrDefault();

            if (bestSubscription != null)
            {
                claims.Add(new Claim(CustomClaimTypes.SubscriptionLevel, bestSubscription.SubscriptionLevelId.ToString()));
                claims.Add(new Claim(CustomClaimTypes.SubscriptionTime, bestSubscription.Valid.ToString()));
            }
            return claims;
        }

        private string GenerateAccessToken(IEnumerable<Claim> claims)
        {
            var token = new JwtSecurityToken(
                issuer: _config.Issuer,
                audience: _config.Audience,
                claims: claims,
                expires: DateTime.UtcNow + _config.AccessTokenExpireTime,
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
        private string ToHashToBase64(string data)
        {
            using var hasher = SHA256.Create();
            return Convert.ToBase64String(hasher.ComputeHash(Encoding.UTF8.GetBytes(data)));
        }
    }
}
