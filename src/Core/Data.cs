using Core.Entities;

namespace HDS.Core
{
    public static class Data
    {
        public enum Units
        {
            kgm2,
            kgm
        }
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
            I,
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
        public static readonly Dictionary<Materials, (double StiffnessModulus, double StiffnessModulusAverage, double ShearModulusAverage, double BendingResistance, double BendingShearResistance)> MaterialCharacteristics = new()
        {
            {Materials.PlankK16, new (5.4 * 1000000000, 8.0 * 1000000000, 0.50 * 1000000000, 13.0 * 1000000, 2.4 * 1000000)},
            {Materials.PlankK24, new(7.4 * 1000000000, 11.0 * 1000000000, 0.69 * 1000000000, 19.5 * 1000000, 2.4 * 1000000)},
            {Materials.PlankK26, new(8.0 * 1000000000, 11.5 * 1000000000, 0.72 * 1000000000, 21.0 * 1000000, 2.7 * 1000000)},
            {Materials.LvlK35, new(10.0 * 1000000000, 10.0 * 1000000000, 0.50 * 1000000000, 30.0 * 1000000, 2.9 * 1000000)},
            {Materials.LvlK40, new(10.0 * 1000000000, 10.0 * 1000000000, 0.60 * 1000000000, 34.0 * 1000000, 3.0 * 1000000)},
            {Materials.LvlK45, new(10.0 * 1000000000, 10.0 * 1000000000, 0.70 * 1000000000, 39.0 * 1000000, 3.2 * 1000000)},
        };
        public static readonly KeyValuePair<double, double>[] ShrinkageValues = new KeyValuePair<double, double>[]
        {
            new(0.013, 0.0007),
            new(0.016, 0.0009),
            new(0.019, 0.001),
            new(0.022, 0.0011),
            new(0.025, 0.0017),
            new(0.028, 0.0014),
            new(0.032, 0.0014),
            new(0.040, 0.0017),
            new(0.045, 0.002),
            new(0.050, 0.0022),
            new(0.056, 0.0024),
            new(0.060, 0.0026),
            new(0.063, 0.0028),
            new(0.066, 0.0029),
            new(0.070, 0.0030),
            new(0.075, 0.0033),
            new(0.080, 0.0035),
            new(0.086, 0.0037),
            new(0.090, 0.0039),
            new(0.096, 0.0041),
            new(0.100, 0.0042),
            new(0.110, 0.0046),
            new(0.116, 0.0048),
            new(0.120, 0.0051),
            new(0.125, 0.0051),
            new(0.130, 0.0054),
            new(0.140, 0.0058),
            new(0.150, 0.0059),
            new(0.160, 0.0062),
            new(0.165, 0.0064),
            new(0.170, 0.0067),
            new(0.180, 0.007),
            new(0.190, 0.0073),
            new(0.200, 0.0078),
            new(0.210, 0.0081),
            new(0.220, 0.0085),
            new(0.230, 0.0089),
            new(0.240, 0.0093),
            new(0.250, 0.0097),
            new(0.254, 0.0098),
            new(0.260, 0.0099),
            new(0.270, 0.0101),
            new(0.280, 0.0105),
            new(0.290, 0.0107),
            new(0.300, 0.0109)
        };
    }
}
