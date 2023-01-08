using System.Security.Claims;

namespace Infrastructure.Identity;

public interface IJwtBuilder
{
    IJwtBuilder AddSubscriptionClaims(int level, TimeSpan lifetime);
    IJwtBuilder AddName(string name);
    string GetNewJwt(TimeSpan lifetime);
}