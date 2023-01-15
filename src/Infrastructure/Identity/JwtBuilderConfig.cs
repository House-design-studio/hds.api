using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace Infrastructure.Identity;

public class JwtBuilderConfig
{
    public string Issuer { get; set; }
    public string Audience { get; set; }
    public string Key { get; set; }

    public SymmetricSecurityKey GetSymmetricSecurityKey()
    {
        return new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Key));
    }
}