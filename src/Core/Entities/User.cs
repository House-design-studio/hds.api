using Core.Common.Interfaces;

namespace Infrastructure.Database;

public class User : IAuditableEntity
{
    public User()
    {
        Orders = new HashSet<Order>();
    }

    public int Id { get; set; }
    public DateOnly SignupDate { get; set; }
    public byte[]? RefreshTokenHash { get; set; }
    public DateTime? RefreshTokenExpireTime { get; set; }

    public virtual ICollection<Subscription> Subscriptions { get; set; } = new List<Subscription>();
    public virtual OauthGoogle OauthGoogle { get; set; } = null!;
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();


    public static User SignUpWithSubscription()
    {
        var user = new User
        {
            SignupDate = DateOnly.FromDateTime(DateTime.UtcNow),
            Subscriptions = new List<Subscription>
            {
                new()
                {
                    SubscriptionLevelId = 1,
                    Valid = DateOnly.FromDateTime(DateTime.UtcNow + TimeSpan.FromDays(30))
                }
            }
        };
        return user;
    }


    public Subscription? GetBestSubscription()
    {
        return Subscriptions
            .Where(s => s.Valid > DateOnly.FromDateTime(DateTime.UtcNow))
            .OrderByDescending(s => s.SubscriptionLevel)
            .ThenByDescending(s => s.Valid)
            .FirstOrDefault();
    }
}