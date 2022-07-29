namespace website.BusinessLogic.Beam
{
    /// <summary>
    /// Полный расчёт информации по балке
    /// </summary>
    public class FullReport
    {
        /// <summary>
        /// Входные данные
        /// </summary>
        public Input Input { get; set; }


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
        public double MBCoefficient { get; set; }
        /// <summary>
        /// коэффициент mc c
        /// </summary>
        public double mccCoefficient { get; set; }

        public FullReport(Input input)
        {
            this.Input = input;

            this.ShrinkageInWidth = Analyze.GetShrinkage(input.Width);
            this.ShrinkageInHeight = Analyze.GetShrinkage(input.Height);

            this.EffectiveWidth = input.Width - this.ShrinkageInWidth;
            this.EffectiveHeight = input.Height - this.ShrinkageInHeight;

            this.CrossSectionArea = Analyze.GetCrossSectionArea(this.EffectiveWidth, this.EffectiveHeight);

            this.PolarMomentOfInertia = Analyze.GetPolarMomentOfInertia(this.EffectiveWidth, this.EffectiveHeight);

            this.MomentOfInertiaY = Analyze.GetMomentOfInertiaY(this.EffectiveWidth, this.EffectiveHeight);
            this.MomentOfInertiaZ = Analyze.GetMomentOfInertiaZ(this.EffectiveWidth, this.EffectiveHeight);

            this.MomentOfResistanceY = Analyze.GetMomentOfResistanceY(this.EffectiveWidth, this.EffectiveHeight);
            this.MomentOfResistanceZ = Analyze.GetMomentOfResistanceZ(this.EffectiveWidth, this.EffectiveHeight);

            this.StaticMomentOfShearSectionY = Analyze.GetStaticMomentOfShearSectionY(this.EffectiveWidth, this.EffectiveHeight);
            this.StaticMomentOfShearSectionZ = Analyze.GetStaticMomentOfShearSectionZ(this.EffectiveWidth, this.EffectiveHeight);

            this.StiffnessModulus = Data.BeamMaterialСharacteristics[input.Material].StiffnessModulus;
            this.StiffnessModulusAverage = Data.BeamMaterialСharacteristics[input.Material].StiffnessModulusAverage;
            this.ShearModulusAverage = Data.BeamMaterialСharacteristics[input.Material].ShearModulusAverage;
            this.BendingResistance = Data.BeamMaterialСharacteristics[input.Material].BendingResistance;
            this.BendingShearResistance = Data.BeamMaterialСharacteristics[input.Material].BendingShearResistance;

            this.MaCoefficient = Analyze.GetMaCoefficient(input.FlameRetardants);
            this.MBCoefficient = Analyze.GetMBCoefficient(input.Exploitation);
            this.mccCoefficient = Analyze.GetMccCoefficient(input.LifeTime);

        }
    }
}
