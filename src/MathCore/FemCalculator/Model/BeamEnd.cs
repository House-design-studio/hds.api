using MathCore.Common.Base;

namespace MathCore.FemCalculator.Model;

public class BeamEnd
{
    public BeamEnd()
    {
        IsFlexible = new Vector6D<bool>();
        IsFixed = new Vector6D<bool>();
    }

    public int Node { get; set; }

    public Vector6D<bool> IsFlexible { get; set; }
    public Vector6D<bool> IsFixed { get; set; }
}