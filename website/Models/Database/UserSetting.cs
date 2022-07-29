﻿using System;
using System.Collections.Generic;

namespace website.Models.Database
{
    public partial class UserSetting
    {
        public int UserId { get; set; }
        public int LocalityId { get; set; }

        public virtual Locality Locality { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}