namespace website.BusinessLogic
{
    public static partial class Math
    {
        public static double LinearInterpolation(Point2D first, Point2D second, double X)
        {
            if(first.X == 0 && second.X == 0)
            {
                return 0;
            }
            return (first.Y - second.Y) * (X - first.X) / (first.X - second.X) + first.Y;
        }
    }
}
