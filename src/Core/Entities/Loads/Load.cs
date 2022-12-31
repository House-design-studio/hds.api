namespace Core.Entities.Loads
{
    public abstract class Load
    {
        public virtual double LoadForFirstGroup { get; set; }
        public virtual double LoadForSecondGroup { get; set; }

        public Load(
            double loadForFirstGroup,
            double loadForSecondGroup)
        {
            LoadForFirstGroup = loadForFirstGroup;
            LoadForSecondGroup = loadForSecondGroup;
        }
        public Load()
        {
            LoadForFirstGroup = 0;
            LoadForSecondGroup = 0;
        }
    }
}
