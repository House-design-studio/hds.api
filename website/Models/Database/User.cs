using System;
using System.Collections.Generic;

namespace website.Models.Database
{
    public partial class User
    {
        public User()
        {
            Orders = new HashSet<Order>();
        }

        public int UserId { get; set; }
        public DateOnly SignupDate { get; set; }

        public virtual OauthGoogle OauthGoogle { get; set; } = null!;
        public virtual ICollection<Order> Orders { get; set; }
    }
}
