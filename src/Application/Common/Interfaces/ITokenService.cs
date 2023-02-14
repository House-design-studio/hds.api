using Application.Account.Tokens;

namespace Application.Common.Interfaces;

public interface ITokenService
{
    /// <summary>
    /// Generate tokens by google id
    /// </summary>
    /// <param name="googleId">google account id</param>
    /// <returns>refresh and access tokes model <see cref="TokensResponse"/></returns>
    Task<TokensResponse> LoginByGoogleAsync(string googleId);

    /// <summary>
    /// Refresh tokens when access token "died"
    /// </summary>
    /// <param name="model"> <see cref="RefreshTokenRequest"/> model </param>
    /// <returns> refresh and access tokes model <see cref="TokensResponse"/></returns>
    Task<TokensResponse> RefreshTokensAsync(RefreshTokenRequest model);
}

