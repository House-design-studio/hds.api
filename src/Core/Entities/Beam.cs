using HDS.Core.Beam.Entities;
using HDS.Core;

namespace Core.Entities
{
    public class Beam
    {
        #region Базовые характеристики балки
        public Data.BeamMatireals Material { get; set; }
        public bool DryWood { get; set; }
        public bool FlameRetardants { get; set; }
        public double Width { get; set; }
        public double Height { get; set; }
        public double Length { get; set; }
        public int Amount { get; set; }
        public Data.Exploitations Exploitation { get; set; }
        public int LifeTime { get; set; }
        public int SteadyTemperature { get; set; }
        public Data.LoadingModes LoadingMode { get; set; }
        public IEnumerable<double> Supports { get; set; } = null!;
        public IEnumerable<DistributedLoad> DistributedLoads { get; set; } = null!;
        public IEnumerable<ConcentratedLoad> ConcentratedLoads { get; set; } = null!;
        #endregion
        #region Геометрические характеристики балки
        /// <summary>
        /// Величина усушки доски по ширине
        /// </summary>
        public double ShrinkageInWidth { get; set; }
        /// <summary>
        /// Величина усушки доски по высоте
        /// </summary>
        public double ShrinkageInHeight { get; set; }
        /// <summary>
        /// Расчётная ширина сечения балки
        /// </summary>
        public double EffectiveWidth { get; set; }
        /// <summary>
        /// Расчётная высота сечения балки
        /// </summary>
        public double EffectiveHeight { get; set; }
        /// <summary>
        /// Площадь поперечного сечения балки
        /// </summary>
        public double CrossSectionArea { get; set; }
        /// <summary>
        /// Полярный момент инерции сечения
        /// </summary>
        public double PolarMomentOfInertia { get; set; }
        /// <summary>
        /// Осевой момент инерции сечения относительно оси Y
        /// </summary>
        public double MomentOfInertiaY { get; set; }
        /// <summary>
        /// Осевой момент инерции сечения относительно оси Z
        /// </summary>
        public double MomentOfInertiaZ { get; set; }
        /// <summary>
        /// Момент сопротивления сечения относительно оси Y
        /// </summary>
        public double MomentOfResistanceY { get; set; }
        /// <summary>
        /// Момент сопротивления сечения относительно оси Z
        /// </summary>
        public double MomentOfResistanceZ { get; set; }
        /// <summary>
        /// Статический момент площади сдвигаемого сечения относительно оси Y
        /// </summary>
        public double StaticMomentOfShearSectionY { get; set; }
        /// <summary>
        /// Статический момент площади сдвигаемого сечения относительно оси Z
        /// </summary>
        public double StaticMomentOfShearSectionZ { get; set; }
        /// <summary>
        /// Нормативный модуль упругости при изгибе с обеспеченностью 0.95 <br/>
        /// Нормативное значение модуля упругости, 5-процентный квантиль B.3
        /// </summary>
        #endregion
        #region Физико-механические характеристики материала
        public double StiffnessModulus { get; set; }
        /// <summary>
        /// Средний модуль упругости при изгибе <br/>
        /// Среднее значение модуля упругости при изгибе B.3
        /// </summary>
        public double StiffnessModulusAverage { get; set; }
        /// <summary>
        /// Средний модуль сдвига <br/>
        /// Среднее значение модуля сдвига B.3
        /// </summary>
        public double ShearModulusAverage { get; set; }
        /// <summary>
        /// Расчётное сопротивление изгибу <br/>
        /// Расчетное сопротивление , Rаи МПа, для сортов древесины "Таблица 3"   
        /// </summary>
        public double BendingResistance { get; set; }
        /// <summary>
        /// Расчётное сопротивление скалыванию при изгибе
        /// RАск
        /// </summary>
        public double BendingShearResistance { get; set; }
        /// <summary>
        /// коэффициент ma
        /// </summary>
        public double MaCoefficient { get; set; }
        /// <summary>
        /// коэффициент mb
        /// </summary>
        public double MbCoefficient { get; set; }
        /// <summary>
        /// коэффициент mc c
        /// </summary>
        public double MccCoefficient { get; set; }
        #endregion

        public async Task CalculateLoadsAsync()
        {
            throw new NotImplementedException();
        }
    }
}
