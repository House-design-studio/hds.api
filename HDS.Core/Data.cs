namespace HDS.Core
{
    public static class Data
    {
        /// <summary>
        /// Режимы нагружения
        /// </summary>
        public enum LoadingModes
        {
            A,
            B,
            V,
            G,
            D,
            E,
            J,
            Z,
            K,
            L,
            M
        }

        /// <summary>
        /// Класс условий эксплуатации
        /// </summary>
        public enum Exploitations
        {
            Class1A,
            Class1B,
            Class2,
            Class3,
            Class4A,
            Class4B
        }

        /// <summary>
        /// Материалы балки
        /// </summary>
        public enum BeamMatireals
        {

            PlankK16,
            PlankK24,
            PlankK26,
            LvlK35,
            LvlK40,
            LvlK45
        }

        /// <summary>
        /// информация по материалам тбалица B.3
        /// https://docs.cntd.ru/document/456082589
        /// </summary>
        public static readonly Dictionary<BeamMatireals, BeamMaterialСharacteristic> BeamMaterialСharacteristics = new()
        {
            {BeamMatireals.PlankK16, new BeamMaterialСharacteristic(5.4 * 1000000000, 8.0 * 1000000000, 0.50 * 1000000000, 13.0 * 1000000, 2.4 * 1000000)},
            {BeamMatireals.PlankK24, new BeamMaterialСharacteristic(7.4 * 1000000000, 11.0 * 1000000000,0.69 * 1000000000, 19.5 * 1000000, 2.4 * 1000000)},
            {BeamMatireals.PlankK26, new BeamMaterialСharacteristic(8.0 * 1000000000, 11.5 * 1000000000,0.72 * 1000000000, 21.0 * 1000000, 2.7 * 1000000)},
            {BeamMatireals.LvlK35, new BeamMaterialСharacteristic(10.0 * 1000000000, 10.0 * 1000000000, 0.50 * 1000000000, 30.0 * 1000000, 2.9 * 1000000)},
            {BeamMatireals.LvlK40, new BeamMaterialСharacteristic(10.0 * 1000000000, 10.0 * 1000000000, 0.60 * 1000000000, 34.0 * 1000000, 3.0 * 1000000)},
            {BeamMatireals.LvlK45, new BeamMaterialСharacteristic(10.0 * 1000000000, 10.0 * 1000000000, 0.70 * 1000000000, 39.0 * 1000000, 3.2 * 1000000)},
        };
        public class BeamMaterialСharacteristic
        {
            /// <summary>
            /// Нормативный модуль упругости при изгибе с обеспеченностью 0.95 <br/>
            /// Нормативное значение модуля упругости, 5-процентный квантиль B.3
            /// </summary>
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

            public BeamMaterialСharacteristic(double stiffnessModulus,
                                              double stiffnessModulusAverage,
                                              double shearModulusAverage,
                                              double bendingResistance,
                                              double bendingShearResistance)
            {

                this.StiffnessModulus = stiffnessModulus;
                this.StiffnessModulusAverage = stiffnessModulusAverage;
                this.ShearModulusAverage = shearModulusAverage;
                this.BendingResistance = bendingResistance;
                this.BendingShearResistance = bendingShearResistance;
            }
        }

    }
}
