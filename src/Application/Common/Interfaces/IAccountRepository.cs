namespace Application.Common.Interfaces
{
    public interface IAccountRepository
    {
        /// <summary>
        /// create new user by google oauth
        /// </summary>
        /// <param name="googleId">google id</param>
        /// <returns>system id</returns>
        Task<int> CreateAccount(int googleId);
        Task<bool> IsExistAccount(int googleId);
        Task<int?> GetUserByGoogleId(int googleId);
        Task AddSubscription(int userId, int level, TimeSpan lifeTime);
        Task<SubscriptionData?> GetSubscription(int userId);
    }

    public record class SubscriptionData(int Level, TimeSpan Valid);
}
