namespace HDS.BusinessLogic
{
    /// <summary>
    /// Класс для математический рассчётов
    /// </summary>
    public static class Math
    {
        /// <summary>
        /// Точка в трёхмерном пространстве
        /// </summary>
        /// <param name="X">координата X</param>
        /// <param name="Y">координата Y</param>
        /// <param name="Z">координата Z</param>
        public record struct Point3D(double X, double Y, double Z);

        /// <summary>
        /// Точка в двухмерном пространстве
        /// </summary>
        /// <param name="X">координата X</param>
        /// <param name="Y">координата Y</param>
        public record struct Point2D(double X, double Y);

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
