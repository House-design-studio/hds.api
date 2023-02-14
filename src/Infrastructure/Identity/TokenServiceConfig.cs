using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace Infrastructure.Identity;

public class TokenServiceConfig
{
    public string Issuer { get; set; } = null!;
    public string Audience { get; set; } = null!;
    public string Key { get; set; } = null!;
    public TimeSpan AccessTokenExpireTime { get; set; }
    public TimeSpan RefreshTokenExpireTime { get; set; }

    public SymmetricSecurityKey GetSymmetricSecurityKey() => new(Encoding.UTF8.GetBytes(Key));
}