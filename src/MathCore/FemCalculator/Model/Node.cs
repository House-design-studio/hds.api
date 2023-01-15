using MathCore.Common.Base;

namespace MathCore.FemCalculator.Model;

public class Node : Vector6D<double>
{
    public Node()
    {
        Coordinate = new Point3D();
        Support = new Vector6D<bool>();
        Load = new Vector6D<double>();
    }
    public Node(Point3D coordinate)
    {
        Coordinate = coordinate;
        Support = new Vector6D<bool>();
        Load = new Vector6D<double>();
    }

    public Node(double x)
    {
        Coordinate = new Point3D(x, 0, 0);
        Support = new Vector6D<bool>();
        Load = new Vector6D<double>();
    }
    
    public Point3D Coordinate { get; set; }
    public Vector6D<bool> Support { get; set; }
    public Vector6D<double> Load { get; set; }
    
    public Vector6D<double> Displacement { get; set; }
}