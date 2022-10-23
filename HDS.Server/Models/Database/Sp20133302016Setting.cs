namespace HDS.Server.Models.Database
{
    public partial class Sp20133302016Setting
    {
        public int UserId { get; set; }
        public int? SnowAreaId { get; set; }
        public int? SnowLocalityId { get; set; }
        public int WindAreaId { get; set; }

        public virtual Sp20133302016SnowArea? SnowArea { get; set; }
        public virtual Sp20133302016LocalitySnowLoad? SnowLocality { get; set; }
        public virtual User User { get; set; } = null!;
        public virtual Sp20133302016WindArea WindArea { get; set; } = null!;
    }
}
