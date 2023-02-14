using Application.Account.Tokens;
using Application.Common.Interfaces;
using Infrastructure.Database;
using Microsoft.EntityFrameworkCore;
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
            user.RefreshTokenHash = HashToken(refreshToken);
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

        public async Task<TokensResponse> RefreshTokensAsync(RefreshTokenRequest model)
        {            
            var userPrincipal = GetPrincipalFromExpiredToken(model.AccessToken);
            var userRepository = _unitOfWork.Repository<User>();

            var userId = Int32.Parse(userPrincipal.Claims.Single(c => c.Type == ClaimTypes.NameIdentifier).Value);
            var user = await userRepository.GetByIdAsync(userId) ?? throw new SecurityTokenException("user not found by token");

            if (user.RefreshTokenExpireTime <= DateTime.UtcNow)
            {
                throw new SecurityTokenException("refresh token timeout");
            }

            if(user.RefreshTokenHash != HashToken(model.RefreshToken))
            {
                throw new SecurityTokenException("bad refresh token");
            }

            var refreshToken = GenerateRefreshToken();
            user.RefreshTokenHash = HashToken(refreshToken);
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

        private static IList<Claim> GetUserClaims(User user)
        {
            var claims = new List<Claim>()
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString())
            };

            var bestSubscription = user.GetBestSubscription();

            if (bestSubscription != null)
            {
                claims.Add(new Claim(CustomClaimTypes.SubscriptionLevel, bestSubscription.SubscriptionLevelId.ToString()));
                claims.Add(new Claim(CustomClaimTypes.SubscriptionTime, bestSubscription.Valid.ToString()));
            }
            return claims;
        }
        private ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
        {
            var tokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = _config.GetSymmetricSecurityKey(),
                ValidateIssuer = true,
                ValidIssuer = _config.Issuer,
                ValidateAudience = true,
                ValidAudience = _config.Audience,
                ClockSkew = TimeSpan.Zero,
                ValidateLifetime = false
            };
            var tokenHandler = new JwtSecurityTokenHandler();
            var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out var securityToken);
            if (securityToken is not JwtSecurityToken jwtSecurityToken || 
                !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
            {
                throw new SecurityTokenException("Invalid token");
            }

            return principal;
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
        private static string HashToken(string token)
        {
            return Encoding.UTF8.GetString(SHA256.HashData(Encoding.UTF8.GetBytes(token)));
        }
    }
}
