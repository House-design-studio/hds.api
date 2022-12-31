using Core.Common.Interfaces;
using static HDS.Core.Data;

namespace Core.Entities
{
    public class WoodenConstruction : Construction, IPhysicMechanicalCharacteristicable
    {
        public Exploitations Exploitation { get; set; }
        public Materials Material { get; set; }
        public bool DryWood { get; set; }
        public bool FlameRetardants { get; set; }
        public int Amount { get; set; }
        public int LifeTime { get; set; }
        public int SteadyTemperature { get; set; }

        public double StiffnessModulus => MaterialCharacteristics[Material].StiffnessModulus;
        public double StiffnessModulusAverage => MaterialCharacteristics[Material].StiffnessModulusAverage;
        public double ShearModulusAverage => MaterialCharacteristics[Material].ShearModulusAverage;
        public double BendingResistance => MaterialCharacteristics[Material].BendingResistance;
        public double BendingShearResistance => MaterialCharacteristics[Material].BendingShearResistance;
        public double MaCoefficient => FlameRetardants ? 0.9 : 1.0;
        public double MbCoefficient => Exploitation switch
        {
            Exploitations.Class1A or
            Exploitations.Class1B or
            Exploitations.Class2 => 1.0,
            Exploitations.Class3 => 0.9,
            Exploitations.Class4A => 0.85,
            Exploitations.Class4B => 0.75,
            _ => throw new NotImplementedException("Коэффициент mb для данного типа нагрузки не реализован"),
        };
        public double MccCoefficient => LifeTime switch
        {
            <= 50 => 1.0,
            <= 75 => LinearInterpolation(new(50d, 1.0), new(75, 0.9), LifeTime),
            <= 100 => LinearInterpolation(new(75d, 0.9), new(100, 0.8), LifeTime),
            _ => 0.8,
        };
    }
}
