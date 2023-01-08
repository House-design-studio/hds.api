namespace Application.Common.Interfaces;

public interface IJwtBuilder
{
    IJwtBuilder AddSubscriptionClaims(int level, TimeSpan lifetime);
    IJwtBuilder AddName(string name);
    string GetNewJwt(TimeSpan lifetime);
}