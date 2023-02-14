namespace Infrastructure.Database;

public class Subscription
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public int SubscriptionLevelId { get; set; }
    public DateOnly Valid { get; set; }

    public virtual SubscriptionLevel SubscriptionLevel { get; set; } = null!;
    public virtual User User { get; set; } = null!;
}