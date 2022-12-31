namespace HDS.Core.Common.Interfaces
{
    public interface IGeometricCharacteristicable
    {
        double Width { get; set; }
        double Height { get; set; }
        double Length { get; set; }

        /// <summary>
        /// Величина усушки доски по ширине
        /// </summary>
        double ShrinkageInWidth { get; }
        /// <summary>
        /// Величина усушки доски по высоте
        /// </summary>
        double ShrinkageInHeight { get; }
        /// <summary>
        /// Расчётная ширина сечения балки
        /// </summary>
        double EffectiveWidth { get; }
        /// <summary>
        /// Расчётная высота сечения балки
        /// </summary>
        double EffectiveHeight { get; }
        /// <summary>
        /// Площадь поперечного сечения балки
        /// </summary>
        double CrossSectionArea { get; }
        /// <summary>
        /// Полярный момент инерции сечения
        /// </summary>
        double PolarMomentOfInertia { get; }
        /// <summary>
        /// Осевой момент инерции сечения относительно оси Y
        /// </summary>
        double MomentOfInertiaY { get; }
        /// <summary>
        /// Осевой момент инерции сечения относительно оси Z
        /// </summary>
        double MomentOfInertiaZ { get; }
        /// <summary>
        /// Момент сопротивления сечения относительно оси Y
        /// </summary>
        double MomentOfResistanceY { get; }
        /// <summary>
        /// Момент сопротивления сечения относительно оси Z
        /// </summary>
        double MomentOfResistanceZ { get; }
        /// <summary>
        /// Статический момент площади сдвигаемого сечения относительно оси Y
        /// </summary>
        double StaticMomentOfShearSectionY { get; }
        /// <summary>
        /// Статический момент площади сдвигаемого сечения относительно оси Z
        /// </summary>
        double StaticMomentOfShearSectionZ { get; }
    }
}
