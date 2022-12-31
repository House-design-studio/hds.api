namespace HDS.Core.Common.Interfaces
{
    public interface IPhysicMechanicalCharacteristicable
    {
        /// <summary>
        /// Нормативный модуль упругости при изгибе с обеспеченностью 0.95 <br/>
        /// Нормативное значение модуля упругости, 5-процентный квантиль B.3
        /// </summary>
        double StiffnessModulus { get; }
        /// <summary>
        /// Средний модуль упругости при изгибе <br/>
        /// Среднее значение модуля упругости при изгибе B.3
        /// </summary>
        double StiffnessModulusAverage { get; }
        /// <summary>
        /// Средний модуль сдвига <br/>
        /// Среднее значение модуля сдвига B.3
        /// </summary>
        double ShearModulusAverage { get; }
        /// <summary>
        /// Расчётное сопротивление изгибу <br/>
        /// Расчетное сопротивление , Rаи МПа, для сортов древесины "Таблица 3"   
        /// </summary>
        double BendingResistance { get; }
        /// <summary>
        /// Расчётное сопротивление скалыванию при изгибе
        /// RАск
        /// </summary>
        double BendingShearResistance { get; }
        /// <summary>
        /// коэффициент ma
        /// </summary>
        double MaCoefficient { get; }
        /// <summary>
        /// коэффициент mb
        /// </summary>
        double MbCoefficient { get; }
        /// <summary>
        /// коэффициент mc c
        /// </summary>
        double MccCoefficient { get; }
    }
}
