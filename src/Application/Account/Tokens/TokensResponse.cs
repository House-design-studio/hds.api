namespace Application.Account.Tokens;

public class TokensResponse
{
    public string AccessToken { get; set; } = null!;
    public string RefreshToken { get; set; } = null!;

    public DateTime RefreshTokenExpireTime { get; set; }
}