using MathCore.Common.Base;

namespace MathCore.FemCalculator.Model;

public struct SegmentEnd
{
    public SegmentEnd(int node, Vector6D<bool> isFlexible, Vector6D<bool> isFixed)
    {
        Node = node;
        IsFlexible = isFlexible;
        IsFixed = isFixed;
    }

    public SegmentEnd()
    {
        IsFlexible = new Vector6D<bool>();
        IsFixed = new Vector6D<bool>();
    }

    public int Node { get; set; }

    public Vector6D<bool> IsFlexible { get; set; }
    public Vector6D<bool> IsFixed { get; set; }
}