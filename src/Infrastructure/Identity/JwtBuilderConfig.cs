using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using static System.Collections.Specialized.BitVector32;

namespace Infrastructure.Identity
{
    public class JwtBuilderConfig
    {
        public JwtBuilderConfig(IConfiguration configuration)
        {
            Issuer = configuration.GetValue<string>("Issuer")!;
            Audience = configuration.GetValue<string>("Audience")!;
            Key = configuration.GetValue<string>("Key")!;
        }
        public string Issuer { get; set; }
        public string Audience { get; set; }
        public string Key { get; set; }
        public SymmetricSecurityKey GetSymmetricSecurityKey() =>
            new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Key));
    }
}
