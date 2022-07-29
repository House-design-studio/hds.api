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

        /// <summary>
        /// расчёт коэффициента ma
        /// </summary>
        /// <param name="flameRetardants">Пропитан ли материал антипиренами?</param>
        /// <returns>коэффициэнт ma</returns>
        public static double GetMaCoefficient(bool flameRetardants)
        {
            return flameRetardants ? 0.9 : 1.0;
        }

        /// <summary>
        /// расчёт коэффициента mB
        /// </summary>
        /// <param name="flameRetardants">Класс условий эксплуатации материала</param>
        /// <returns>коэффициэнт mB</returns>
        public static double GetMBCoefficient(Data.Exploitations exploitation)
        {
            switch (exploitation)
            {
                case Data.Exploitations.class_1a:
                case Data.Exploitations.class_1b:
                case Data.Exploitations.class_2:
                    return 1.0;

                case Data.Exploitations.class_3:
                    return 0.9;

                case Data.Exploitations.class_4a:
                    return 0.85;

                case Data.Exploitations.class_4b:
                    return 0.75;
            }
            throw new NotImplementedException("Коэффициент mb для данного типа нагрузки не реализован");
        }

        /// <summary>
        /// расчёт коэффициента mB
        /// </summary>
        /// <param name="flameRetardants">Класс условий эксплуатации материала</param>
        /// <returns>коэффициэнт mB</returns>
        public static double GetMccCoefficient(int lifeTime)
        {
            if (lifeTime <= 50)
                return 1.0;

            else if (lifeTime <= 75)
                return Math.LinearInterpolation(new(50, 1.0), new(75, 0.9), lifeTime);

            else if (lifeTime <= 100)
                return Math.LinearInterpolation(new(75, 0.9), new(100, 0.8), lifeTime);

            else
                return 0.8;
        }

    }
}