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

    public virtual OauthGoogle OauthGoogle { get; set; } = null!;
    public virtual ICollection<Order> Orders { get; set; }
}