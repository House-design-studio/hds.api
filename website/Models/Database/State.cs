namespace HDS.Models.Database
{
    public partial class State
    {
        public State()
        {
            Localities = new HashSet<Locality>();
        }

        public int StateId { get; set; }
        public string Name { get; set; } = null!;
        public int SortKey { get; set; }

        public virtual ICollection<Locality> Localities { get; set; }
    }
}
