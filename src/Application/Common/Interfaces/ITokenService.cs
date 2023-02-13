using Application.Account.Tokens;

namespace Application.Common.Interfaces;

public interface ITokenService
{
    /// <summary>
    /// Generate tokens by user email
    /// </summary>
    /// <remarks>
    /// USE ONLY WITH VEREFIED EMAIL
    /// </remarks>
    /// <param name="email"></param>
    /// <returns>refresh and access tokes model <see cref="TokensResponse"/></returns>
    Task<TokensResponse> LoginByEmailAsync(string email);

    /// <summary>
    /// Refresh tokens when access token "died"
    /// </summary>
    /// <param name="model"> <see cref="RefreshTokenRequest"/> model </param>
    /// <returns> refresh and access tokes model <see cref="TokensResponse"/></returns>
    Task<TokensResponse> RefreshTokensAsync(RefreshTokenRequest model);
}

