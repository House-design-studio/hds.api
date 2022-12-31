namespace MathCore.Common.Base
{
    public class Point3D : Point2D, IEquatable<Point3D>
    {
        public double Z { get; set; } = 0;

        public Point3D(double x, double y, double z) : base(x, y)
        {
            Z = z;
        }

        public Point3D()
        {
        }

        public bool Equals(Point3D? other)
        {
            if (other == null) return false;
            return (this.X == other.X &&
                    this.Y == other.Y &&
                    this.Z == other.Z);
        }
    }
}
