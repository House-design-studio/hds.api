namespace Core.Common.Interfaces
{
    public interface IGeometricCharacteristicable
    {
        double Width { get; set; }
        double Height { get; set; }
        double Length { get; set; }

        /// <summary>
        /// Величина усушки доски по ширине
        /// </summary>
        public double ShrinkageInWidth { get; }
        /// <summary>
        /// Величина усушки доски по высоте
        /// </summary>
        public double ShrinkageInHeight { get; }
        /// <summary>
        /// Расчётная ширина сечения балки
        /// </summary>
        public double EffectiveWidth { get; }
        /// <summary>
        /// Расчётная высота сечения балки
        /// </summary>
        public double EffectiveHeight { get; }
        /// <summary>
        /// Площадь поперечного сечения балки
        /// </summary>
        public double CrossSectionArea { get; }
        /// <summary>
        /// Полярный момент инерции сечения
        /// </summary>
        public double PolarMomentOfInertia { get; }
        /// <summary>
        /// Осевой момент инерции сечения относительно оси Y
        /// </summary>
        public double MomentOfInertiaY { get; }
        /// <summary>
        /// Осевой момент инерции сечения относительно оси Z
        /// </summary>
        public double MomentOfInertiaZ { get; }
        /// <summary>
        /// Момент сопротивления сечения относительно оси Y
        /// </summary>
        public double MomentOfResistanceY { get; }
        /// <summary>
        /// Момент сопротивления сечения относительно оси Z
        /// </summary>
        public double MomentOfResistanceZ { get; }
        /// <summary>
        /// Статический момент площади сдвигаемого сечения относительно оси Y
        /// </summary>
        public double StaticMomentOfShearSectionY { get; }
        /// <summary>
        /// Статический момент площади сдвигаемого сечения относительно оси Z
        /// </summary>
        public double StaticMomentOfShearSectionZ { get; }
    }
}
