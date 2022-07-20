namespace website.BusinessLogic
{
    public static partial class Math
    {
        /// <summary>
        /// Вычисляет промежуточное значение функции в точке с координатой X по двум данным точкам 
        /// </summary>
        /// <param name="first">Первая точка</param>
        /// <param name="second">Вторая точка</param>
        /// <param name="X"></param>
        /// <returns>Значение функции в точке X</returns>
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
