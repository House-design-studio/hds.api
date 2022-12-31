namespace HDS.Core.Entities.Loads
{
    public class ConcentratedLoad : Load
    {
        public double Offset { get; set; }

        public ConcentratedLoad() :
            base()
        {
            Offset = 0;
        }
        public ConcentratedLoad(double offset) : base()
        {
            Offset = offset;
        }
        public ConcentratedLoad(double offset, double loadForFirstGroup, double loadForSecondGroup)
            : base(loadForFirstGroup, loadForSecondGroup)
        {
            Offset = offset;
        }
    }
}
