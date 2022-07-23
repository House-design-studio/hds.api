using website.BusinessLogic;

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

        /// <summary>
        /// Расчёт осевого момента инерции сечения относительно оси Y
        /// </summary>
        /// <param name="width">ширина</param>
        /// <param name="height">высота</param>
        /// <returns>Осевой момент инерции сечения относительно оси Y</returns>
        public static double GetMomentOfInertiaY(double width, double height) =>
            (width * height * height * height) / 12;

        /// <summary>
        /// Расчёт осевого момента инерции сечения относительно оси Z
        /// </summary>
        /// <param name="width">ширина</param>
        /// <param name="height">высота</param>
        /// <returns>Осевой момент инерции сечения относительно оси Z</returns>
        public static double GetMomentOfInertiaZ(double width, double height) =>
            (width * width * width * height) / 12;

        /// <summary>
        /// Расчёт момента сопротивления сечения относительно оси Y
        /// </summary>
        /// <param name="width">ширина</param>
        /// <param name="height">высота</param>
        /// <returns>Момент сопротивления сечения относительно оси Y</returns>
        public static double GetMomentOfResistanceY(double width, double height) =>
            width * height * height / 6;

        /// <summary>
        /// Расчёт момента сопротивления сечения относительно оси Z
        /// </summary>
        /// <param name="width">ширина</param>
        /// <param name="height">высота</param>
        /// <returns>Момент сопротивления сечения относительно оси Z</returns>
        public static double GetMomentOfResistanceZ(double width, double height) =>
            width * width * height / 6;

        /// <summary>
        /// Расчёт статического момента площади сдвигаемого сечения относительно оси Y
        /// </summary>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <returns>Статический момент площади сдвигаемого сечения относительно оси Y</returns>
        public static double GetStaticMomentOfShearSectionY(double width, double height) =>
            width * height * height / 8;

        /// <summary>
        /// Расчёт статического момента площади сдвигаемого сечения относительно оси Z
        /// </summary>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <returns>Статический момент площади сдвигаемого сечения относительно оси Z</returns>
        public static double GetStaticMomentOfShearSectionZ(double width, double height) =>
            width * width * height / 8;
    }
}