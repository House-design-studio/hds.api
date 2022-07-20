using static website.BusinessLogic.Math;
namespace website.BusinessLogic.Beam
{
    /// <summary>
    /// Класс для расчётов планки 
    /// </summary>
    public static partial class Analyze
    {
        /// <summary>
        /// Расчёт площади поперечного сечения
        /// </summary>
        /// <param name="width">ширина</param>
        /// <param name="height">высота</param>
        /// <returns>площадь поперечного сечения</returns>
        public static double GetCrossSectionArea(double width, double height) => 
            width * height;

        /// <summary>
        /// Расчёт полярного момента инерции сечения
        /// </summary>
        /// <param name="width">ширина</param>
        /// <param name="height">высота</param>
        /// <returns>Полярный момент инерции сечения</returns>
        public static double GetPolarMomentOfInertia(double width, double height) => 
            width * height * (width * width + height * height) / 12;
    }
}