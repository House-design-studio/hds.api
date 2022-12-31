namespace HDS.MathCore.Common.Base
{
    public class Point2D
    {
        public double X { get; set; } = 0;
        public double Y { get; set; } = 0;

        public Point2D(double x, double y)
        {
            X = x;
            Y = y;
        }

        public Point2D()
        {
        }
    }
}
