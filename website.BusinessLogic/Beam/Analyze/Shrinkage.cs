using static website.BusinessLogic.Math;
namespace website.BusinessLogic.Beam
{
    public static partial class Analyze
    {
        /// <summary>
        /// Величины усушки пилопродукции смешанной распиловки из древесины ели, сосны, кедра, пихты для конечной влажности от 11 до 13%
        /// https://docs.cntd.ru/document/1200006340
        /// </summary>
        private static ShrinkageValue[] ShrinkageValues =
        {
            new ShrinkageValue(0.013, 0.0007),
            new ShrinkageValue(0.016, 0.0009),
            new ShrinkageValue(0.019, 0.001),
            new ShrinkageValue(0.022, 0.0011),
            new ShrinkageValue(0.025, 0.0017),
            new ShrinkageValue(0.028, 0.0014),
            new ShrinkageValue(0.032, 0.0014),
            new ShrinkageValue(0.040, 0.0017),
            new ShrinkageValue(0.045, 0.002),
            new ShrinkageValue(0.050, 0.0022),
            new ShrinkageValue(0.056, 0.0024),
            new ShrinkageValue(0.060, 0.0026),
            new ShrinkageValue(0.063, 0.0028),
            new ShrinkageValue(0.066, 0.0029),
            new ShrinkageValue(0.070, 0.0030),
            new ShrinkageValue(0.075, 0.0033),
            new ShrinkageValue(0.080, 0.0035),
            new ShrinkageValue(0.086, 0.0037),
            new ShrinkageValue(0.090, 0.0039),
            new ShrinkageValue(0.096, 0.0041),
            new ShrinkageValue(0.100, 0.0042),
            new ShrinkageValue(0.110, 0.0046),
            new ShrinkageValue(0.116, 0.0048),
            new ShrinkageValue(0.120, 0.0051),
            new ShrinkageValue(0.125, 0.0051),
            new ShrinkageValue(0.130, 0.0054),
            new ShrinkageValue(0.140, 0.0058),
            new ShrinkageValue(0.150, 0.0059),
            new ShrinkageValue(0.160, 0.0062),
            new ShrinkageValue(0.165, 0.0064),
            new ShrinkageValue(0.170, 0.0067),
            new ShrinkageValue(0.180, 0.007),
            new ShrinkageValue(0.190, 0.0073),
            new ShrinkageValue(0.200, 0.0078),
            new ShrinkageValue(0.210, 0.0081),
            new ShrinkageValue(0.220, 0.0085),
            new ShrinkageValue(0.230, 0.0089),
            new ShrinkageValue(0.240, 0.0093),
            new ShrinkageValue(0.250, 0.0097),
            new ShrinkageValue(0.254, 0.0098),
            new ShrinkageValue(0.260, 0.0099),
            new ShrinkageValue(0.270, 0.0101),
            new ShrinkageValue(0.280, 0.0105),
            new ShrinkageValue(0.290, 0.0107),
            new ShrinkageValue(0.300, 0.0109),
        };

        /// <summary>
        /// Расчитывает величину усушки планки 
        /// </summary>
        /// <param name="thickness">толщина планки</param>
        /// <returns>величина усушки</returns>
        public static double GetShrinkage(double thickness)
        {
            var point1_index = Array.FindIndex(ShrinkageValues, (v) => thickness <= v.size);
            var point2_index = point1_index + 1;

            Point2D point1;
            Point2D point2;

            if(point1_index == 0)
            {
                point1 = new Point2D(ShrinkageValues[0].size, ShrinkageValues[0].Value);
                point2 = new Point2D(ShrinkageValues[1].size, ShrinkageValues[1].Value);
            }
            else if(point1_index == -1)
            {
                point1 = new Point2D(ShrinkageValues[ShrinkageValues.Length - 2].size, ShrinkageValues[ShrinkageValues.Length - 2].Value);
                point2 = new Point2D(ShrinkageValues[ShrinkageValues.Length - 1].size, ShrinkageValues[ShrinkageValues.Length - 1].Value);
            }
            else
            {
                point1 = new Point2D(ShrinkageValues[point1_index].size, ShrinkageValues[point1_index].Value);
                point2 = new Point2D(ShrinkageValues[point2_index].size, ShrinkageValues[point2_index].Value);
            }
            return LinearInterpolation(point1, point2, thickness);
        }

        private record struct ShrinkageValue(double size, double Value);
    }
}
