﻿namespace HDS.Infrastructure.Database
{
    public partial class OauthGoogle
    {
        public string Subject { get; set; } = null!;
        public int UserId { get; set; }

        public virtual User User { get; set; } = null!;
    }
}