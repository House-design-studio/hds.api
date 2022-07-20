using website.BusinessLogic.Beam;

namespace website.BusinessLogic.Beam
{
    /// <summary>
    /// Полный расчёт информации по планке
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


        public FullReport(Input input)
        {
            this.Input = input;
            
            this.ShrinkageInWidth = Analyze.GetShrinkage(input.Width);
            this.ShrinkageInHeight = Analyze.GetShrinkage(input.Height);

            this.EffectiveWidth = Input.Width - this.ShrinkageInWidth;
            this.EffectiveHeight = Input.Height - this.ShrinkageInHeight;

            this.CrossSectionArea = Analyze.GetCrossSectionArea(this.EffectiveWidth, this.EffectiveHeight);

            this.PolarMomentOfInertia = Analyze.GetPolarMomentOfInertia(this.EffectiveWidth, this.EffectiveHeight);

            this.MomentOfInertiaY = Analyze.GetMomentOfInertiaY(this.EffectiveWidth, this.EffectiveHeight);
            this.MomentOfInertiaZ = Analyze.GetMomentOfInertiaZ(this.EffectiveWidth, this.EffectiveHeight);

            this.MomentOfResistanceY = Analyze.GetMomentOfResistanceY(this.EffectiveWidth, this.EffectiveHeight);
            this.MomentOfResistanceZ = Analyze.GetMomentOfResistanceZ(this.EffectiveWidth, this.EffectiveHeight);

            this.StaticMomentOfShearSectionY = Analyze.GetStaticMomentOfShearSectionY(this.EffectiveWidth, this.EffectiveHeight);
            this.StaticMomentOfShearSectionZ = Analyze.GetStaticMomentOfShearSectionZ(this.EffectiveWidth, this.EffectiveHeight);
        }
    }
}
