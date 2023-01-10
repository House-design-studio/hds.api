using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Application.Common.Interfaces;
using Microsoft.Extensions.Options;

namespace Infrastructure.Identity
{

    public class JwtBuilder : IJwtBuilder
    {
        private readonly List<Claim> _claims = new List<Claim>(3);
        private readonly JwtBuilderConfig _config;
        public JwtBuilder(IConfigureOptions<JwtBuilderConfig> configOptions)
        {
            var config = new JwtBuilderConfig();
            configOptions.Configure(config);
            _config = config;
        }
        
        public IJwtBuilder AddSubscriptionClaims(int level, TimeSpan lifetime)
        {
            _claims.Add(new Claim(CustomClaimTypes.SubscriptionLevel, level.ToString()));
            _claims.Add(new Claim(CustomClaimTypes.SubscriptionTime, DateOnly.FromDateTime(DateTime.UtcNow + lifetime).ToString()));
            return this;
        }

        public IJwtBuilder AddName(string name)
        {
            _claims.Add(new Claim(ClaimTypes.Name, name));
            return this;
        }

        public string GetNewJwt(TimeSpan lifetime)
        {
            var jwt = new JwtSecurityToken(
                issuer: _config.Issuer,
                audience: _config.Audience,
                claims: _claims,
                expires: DateTime.UtcNow + lifetime,
                signingCredentials: new SigningCredentials(_config.GetSymmetricSecurityKey(),
                    SecurityAlgorithms.HmacSha256));

            return new JwtSecurityTokenHandler().WriteToken(jwt);
        }
    }
}
