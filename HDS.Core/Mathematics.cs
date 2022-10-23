namespace HDS.Core
{
    /// <summary>
    /// Класс для математический рассчётов
    /// </summary>
    public static class Mathematics
    {
        /// <summary>
        /// Точка в трёхмерном пространстве
        /// </summary>
        public class Point3D : Point2D
        {
            public double Z { get; set; }

            public Point3D(double x, double y, double z) : base(x, y)
            {
                Z = z;
            }

            public Point3D() : base()
            {
                Z = 0;
            }
        }

        /// <summary>
        /// Точка в двухмерном пространстве
        /// </summary>
        public class Point2D
        {
            public double X { get; set; }
            public double Y { get; set; }

            public Point2D(double x, double y)
            {
                X = x;
                Y = y;
            }

            public Point2D()
            {
                X = 0;
                Y = 0;
            }
        }

        /// <summary>
        /// Вычисляет промежуточное значение функции в точке с координатой X по двум данным точкам 
        /// </summary>
        /// <param name="first">Первая точка</param>
        /// <param name="second">Вторая точка</param>
        /// <param name="x"></param>
        /// <returns>Значение функции в точке X</returns>
        public static double LinearInterpolation(Point2D first, Point2D second, double x)
        {
            if (first.X == 0 && second.X == 0)
            {
                return 0;
            }
            return (first.Y - second.Y) * (x - first.X) / (first.X - second.X) + first.Y;
        }
    }
}
