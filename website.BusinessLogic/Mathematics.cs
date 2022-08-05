namespace HDS.BusinessLogic
{
    /// <summary>
    /// Класс для математический рассчётов
    /// </summary>
    public static class Mathematics
    {
        /// <summary>
        /// Точка в трёхмерном пространстве
        /// </summary>
        /// <param name="X">координата X</param>
        /// <param name="Y">координата Y</param>
        /// <param name="Z">координата Z</param>
        public class Point3D : Point2D
        {
            public double Z { get; set; }

            public Point3D(double x, double y, double z) : base(x,y)
            {
                Z = z;
            }
        }

        /// <summary>
        /// Точка в двухмерном пространстве
        /// </summary>
        /// <param name="X">координата X</param>
        /// <param name="Y">координата Y</param>
        public class Point2D
        {
            public double X { get; set; }
            public double Y { get; set; }

            public Point2D(double x, double y)
            {
                X = x;
                Y = y;
            }
        }

        /// <summary>
        /// Вычисляет промежуточное значение функции в точке с координатой X по двум данным точкам 
        /// </summary>
        /// <param name="first">Первая точка</param>
        /// <param name="second">Вторая точка</param>
        /// <param name="X"></param>
        /// <returns>Значение функции в точке X</returns>
        public static double LinearInterpolation(Point2D first, Point2D second, double X)
        {
            if (first.X == 0 && second.X == 0)
            {
                return 0;
            }
            return (first.Y - second.Y) * (X - first.X) / (first.X - second.X) + first.Y;
        }
    }
}
