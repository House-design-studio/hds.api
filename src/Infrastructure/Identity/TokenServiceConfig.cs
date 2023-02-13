using Microsoft.IdentityModel.Tokens;
using System.Text;

namespace Infrastructure.Identity;
public class TokenServiceConfig
{
    public string Issuer { get; set; } = null!;
    public string Audience { get; set; } = null!;
    public string Key { get; set; } = null!;
    public int AccessTokenExpireTimeInDays { get; set; } = 2;

    public SymmetricSecurityKey GetSymmetricSecurityKey() =>
        new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Key));
}