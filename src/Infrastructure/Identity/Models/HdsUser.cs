using Infrastructure.Database;
using Microsoft.AspNetCore.Identity;

namespace Infrastructure.Identity.Models;

public class HdsUser : IdentityUser
{
    public HdsUser() : base() { }

    public HdsUser(string userName) : base(userName) { }
    
    public virtual OauthGoogle OauthGoogle { get; set; } = null!;
    public virtual ICollection<Order> Orders { get; set; } = default!;
}