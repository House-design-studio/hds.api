using MathCore.Common.Base;

namespace HDS.MathCore
{
    /// <summary>
    /// Класс для математический рассчётов
    /// </summary>
    public static class Mathematics
    {
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
