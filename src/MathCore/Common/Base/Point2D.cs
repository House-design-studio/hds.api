namespace MathCore.Common.Base;

public class Point2D : IEquatable<Point2D>
{
    public Point2D(double x, double y)
    {
        X = x;
        Y = y;
    }

    public Point2D()
    {
    }

    public double X { get; set; }
    public double Y { get; set; }

    public bool Equals(Point2D? other)
    {
        if (ReferenceEquals(null, other)) return false;
        if (ReferenceEquals(this, other)) return true;
        return X.Equals(other.X) && Y.Equals(other.Y);
    }

    public override bool Equals(object? obj)
    {
        if (ReferenceEquals(null, obj)) return false;
        if (ReferenceEquals(this, obj)) return true;
        if (obj.GetType() != GetType()) return false;
        return Equals((Point2D)obj);
    }

    public override int GetHashCode()
    {
        return HashCode.Combine(X, Y);
    }
}