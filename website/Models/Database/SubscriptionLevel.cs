using System;
using System.Collections.Generic;

namespace website.Models.Database
{
    public partial class SubscriptionLevel
    {
        public int SubscriptionLevelId { get; set; }
        public string Name { get; set; } = null!;
    }
}
