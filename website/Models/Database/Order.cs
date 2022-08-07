namespace HDS.Web.Models.Database
{
    public partial class Order
    {
        public int UserId { get; set; }
        public int OrderId { get; set; }
        public int Service { get; set; }
        public DateTime Created { get; set; }
        public decimal Amount { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
