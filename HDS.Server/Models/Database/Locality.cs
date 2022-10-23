namespace HDS.Server.Models.Database
{
    public partial class Locality
    {
        public int LocalityId { get; set; }
        public string Name { get; set; } = null!;
        public int StateId { get; set; }

        public virtual State State { get; set; } = null!;
        public virtual Sp20133302016LocalitySnowLoad Sp20133302016LocalitySnowLoad { get; set; } = null!;
    }
}
