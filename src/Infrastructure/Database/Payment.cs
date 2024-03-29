﻿namespace Infrastructure.Database;

public class Payment
{
    public int OrderId { get; set; }
    public decimal Amount { get; set; }
    public DateTime Payed { get; set; }

    public virtual Order Order { get; set; } = null!;
}