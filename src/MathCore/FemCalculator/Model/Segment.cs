using MathCore.Common.Base;

namespace MathCore.FemCalculator.Model;

public class Segment
{
    public Segment()
    {
        First = new SegmentEnd();
        Second = new SegmentEnd();
        ZDirection = new Point3D();
    }

    public SegmentEnd First;
    public SegmentEnd Second;
    public Point3D ZDirection { get; set; }
    public double StiffnessModulus { get; set; }
    public double ShearModulus { get; set; }
    public double CrossSectionalArea { get; set; }
    public double ShearAreaY { get; set; }
    public double ShearAreaZ { get; set; }
    public double MomentOfInertiaX { get; set; }
    public double MomentOfInertiaY { get; set; }
    public double MomentOfInertiaZ { get; set; }
}