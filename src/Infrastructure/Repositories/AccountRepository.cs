using Application.Common.Interfaces;
using HDS.Infrastructure.Database;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repositories
{
    public class AccountRepository : IAccountRepository
    {
        private readonly ApplicationDbContext _db;
        public AccountRepository(
            ApplicationDbContext db)
        {
            _db = db;
        }
        public async Task<int> CreateAccount(int googleId)
        {
            var user = new User()
            {
                SignupDate = DateOnly.FromDateTime(DateTime.UtcNow),
                OauthGoogle = new OauthGoogle()
                {
                    Subject = googleId.ToString() // REVIEW: id or subject is it?
                }
            };
            await _db.Users.AddAsync(user);
            await _db.SaveChangesAsync();
            return _db.Users
                .First(u => u.OauthGoogle.Subject == googleId.ToString())
                .UserId;
        }

        public async Task<bool> IsExistAccount(int googleId)
        {
            return await _db.Users.AnyAsync(u => u.OauthGoogle.Subject == googleId.ToString());
        }

        public async Task<int?> GetUserByGoogleId(int googleId)
        {
            return (await _db
                .Users
                .SingleOrDefaultAsync(u => u.OauthGoogle.Subject == googleId.ToString()))?
                .UserId;
        }

        public async Task AddSubscription(int userId, int level, TimeSpan time)
        {
            if (!await _db
                    .SubscriptionLevels
                    .AnyAsync(x => x.SubscriptionLevelId == level))
                throw new ArgumentException($"subscription level {level} not found");
            if (!await _db
                    .Users
                    .AnyAsync(x => x.UserId == userId))
                throw new ArgumentException($"user {userId} not found");

            await _db.Subscriptions.AddAsync(new Subscription()
            {
                UserId = userId,
                SubscriptionLevelId = level,
                Valid = DateOnly.FromDateTime(DateTime.UtcNow + time)
            });

            await _db.SaveChangesAsync();
        }

        public async Task<SubscriptionData?> GetSubscription(int userId)
        {
            return await _db
                .Subscriptions
                .Where(s => s.Valid > DateOnly.FromDateTime(DateTime.UtcNow))
                .OrderByDescending(s => s.SubscriptionLevel)
                .ThenByDescending(s => s.Valid)
                .Select(s => new SubscriptionData(
                    s.SubscriptionLevelId,
                    new TimeSpan(s.Valid.DayNumber - DateOnly.FromDateTime(DateTime.UtcNow).DayNumber, 0, 0, 0)))
                .FirstOrDefaultAsync();
        }
    }
}
