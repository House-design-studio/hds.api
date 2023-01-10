using HDS.MathCore.Common.Base;

namespace HDS.MathCore.FemCalculator.Model
{
    public class BeamEnd
    {
        public int Node { get; set; }

        public Vector6D<bool> IsFlexible { get; set; }
        public Vector6D<bool> IsFixed { get; set; }

        public BeamEnd()
        {
            IsFlexible = new Vector6D<bool>();
            IsFixed = new Vector6D<bool>();
        }
    }
}
