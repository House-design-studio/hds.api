using System;
using System.Collections.Generic;

namespace website.Models.Database
{
    public partial class Subscription
    {
        public int UserId { get; set; }
        public int SubscriptionLevelId { get; set; }
        public DateOnly Valid { get; set; }

        public virtual SubscriptionLevel SubscriptionLevel { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}
