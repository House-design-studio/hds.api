namespace Infrastructure.Database;

public class PayedOrder
{
    public int? UserId { get; set; }
    public int? OrderId { get; set; }
    public int? Service { get; set; }
    public decimal? InvoicedAmount { get; set; }
    public decimal? ReceivedAmount { get; set; }
    public DateTime? Created { get; set; }
    public DateTime? Payed { get; set; }
}