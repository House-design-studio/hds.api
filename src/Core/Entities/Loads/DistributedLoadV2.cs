using Core.Entities.Loads;
using static HDS.Core.Data;

namespace HDS.Shared
{
    public class DistributedLoadV2 : DistributedLoad
    {
        public override double LoadForFirstGroup
        {
            get
            {
                if (NormativeValueUM == Units.kgm) return ReliabilityCoefficient * NormativeValue;
                else return ReliabilityCoefficient * NormativeValue * (LoadAreaWidth ?? 0);
            }
        }
        public override double LoadForSecondGroup
        {
            get
            {
                if (NormativeValueUM == Units.kgm) return ReducingFactor * NormativeValue;
                else return ReducingFactor * NormativeValue * (LoadAreaWidth ?? 0);
            }
        }

        public double NormativeValue { get; set; }
        public Units NormativeValueUM { get; set; }
        public double? LoadAreaWidth { get; set; }
        public double ReliabilityCoefficient { get; set; }
        public double ReducingFactor { get; set; }

        public DistributedLoadV2()
        {
            NormativeValue = 0;
            NormativeValueUM = Units.kgm;
            LoadAreaWidth = 0;
            ReliabilityCoefficient = 0;
            ReducingFactor = 0;
        }
    }
}
