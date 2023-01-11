using Core.Common.Interfaces;
using MathCore.Common.Base;
using static Core.Data;
using static MathCore.Mathematics;

namespace Core.Entities;

public class Construction : IGeometricCharacteristic
{
    public double Width { get; set; }
    public double Height { get; set; }
    public double Length { get; set; }
    public double CrossSectionArea => Width * Height;
    public double ShrinkageInWidth => GetShrinkage(Width);
    public double ShrinkageInHeight => GetShrinkage(Height);
    public double EffectiveWidth => Width - ShrinkageInWidth;
    public double EffectiveHeight => Height - ShrinkageInHeight;

    public double PolarMomentOfInertia => EffectiveWidth * EffectiveHeight *
        (EffectiveWidth * EffectiveWidth + EffectiveHeight * EffectiveHeight) / 12;

    public double MomentOfInertiaY => EffectiveWidth * EffectiveHeight * EffectiveHeight * EffectiveHeight / 12;
    public double MomentOfInertiaZ => EffectiveWidth * EffectiveWidth * EffectiveWidth * EffectiveHeight / 12;
    public double MomentOfResistanceY => EffectiveWidth * EffectiveHeight * EffectiveHeight / 6;
    public double MomentOfResistanceZ => EffectiveWidth * EffectiveWidth * EffectiveHeight / 6;
    public double StaticMomentOfShearSectionY => EffectiveWidth * EffectiveHeight * EffectiveHeight / 8;
    public double StaticMomentOfShearSectionZ => EffectiveWidth * EffectiveWidth * EffectiveHeight / 8;

    private static double GetShrinkage(double thickness)
    {
        KeyValuePair<double, double> point1;
        KeyValuePair<double, double> point2;
        try
        {
            point1 = ShrinkageValues.LastOrDefault(v => v.Key <= thickness);
        }
        catch
        {
            point1 = ShrinkageValues[1];
        }

        try
        {
            point2 = ShrinkageValues.FirstOrDefault(v => v.Key >= thickness);
        }
        catch
        {
            point2 = ShrinkageValues[^1];
        }

        return LinearInterpolation(new Point2D(point1.Key, point1.Value), new Point2D(point2.Key, point2.Value),
            thickness);
    }
}