namespace HDS.BusinessLogic.Beam.Entities
{
    public class BeamInput
    {
        public Data.BeamMatireals Material { get; private set; }

        public bool DryWood { get; private set; }
        public bool FlameRetardants { get; private set; }

        public double Width { get; private set; }
        public double Height { get; private set; }
        public double Length { get; private set; }
        public int Amount { get; private set; }

        public Data.Exploitations Exploitation { get; private set; }

        public int LifeTime { get; private set; }

        public Data.LoadingModes LoadingMode { get; private set; }

        public double[] Supports { get; private set; }

        public List<NormativeEvenlyDistributedLoadV1>? NormativeEvenlyDistributedLoadsV1 { get; set; }
        public List<NormativeEvenlyDistributedLoadV2>? NormativeEvenlyDistributedLoadsV2 { get; set; }


        public class NormativeEvenlyDistributedLoadV1
        {
            public double NormativeValue { get; private set; }
            public UnitsOfMeasurement NormativValueUM { get; private set; }
            public double? LoadAreaWidth { get; private set; }
            public double ReliabilityCoefficient { get; private set; }
            public double ReducingFactor { get; private set; }

            public NormativeEvenlyDistributedLoadV1(
                double normativeValue,
                UnitsOfMeasurement normativValueUM,
                double? loadAreaWidth,
                double reliabilityCoefficient,
                double reducingFactor)
            {
                NormativeValue = normativeValue;
                NormativValueUM = normativValueUM;
                LoadAreaWidth = loadAreaWidth;
                ReliabilityCoefficient = reliabilityCoefficient;
                ReducingFactor = reducingFactor;
            }
        }

        public class NormativeEvenlyDistributedLoadV2
        {
            public double LoadForFirstGroup { get; set; }
            public double LoadForSecondGroup { get; set; }

            public NormativeEvenlyDistributedLoadV2(
                double loadForFirstGroup,
                double loadForSecondGroup)
            {
                LoadForFirstGroup = loadForFirstGroup;
                LoadForSecondGroup = loadForSecondGroup;
            }
        }

        public enum UnitsOfMeasurement
        {
            kgm,
            kgm2
        }

        public BeamInput(Data.BeamMatireals material,
                         bool dryWood,
                         bool flameRetardants,
                         double width,
                         double height,
                         double length,
                         int amount,
                         Data.Exploitations exploitation,
                         int lifeTime,
                         Data.LoadingModes loadingMode,
                         double[] supports,
                         List<NormativeEvenlyDistributedLoadV1>? normativeEvenlyDistributedLoadsV1,
                         List<NormativeEvenlyDistributedLoadV2>? normativeEvenlyDistributedLoadsV2)
        {
            Material = material;
            DryWood = dryWood;
            FlameRetardants = flameRetardants;
            Width = width;
            Height = height;
            Length = length;
            Amount = amount;
            Exploitation = exploitation;

            LifeTime = lifeTime;
            LoadingMode = loadingMode;
            Supports = supports;

            NormativeEvenlyDistributedLoadsV1 = normativeEvenlyDistributedLoadsV1;
            NormativeEvenlyDistributedLoadsV2 = normativeEvenlyDistributedLoadsV2;
        }

        public override string ToString()
        {

            string supports = "";
            string loads = "Type 1:";

            foreach (var s in Supports)
            {
                supports = $"{supports}{s * 1000}, ";
            }
            supports = supports.Remove(supports.Length - 2);

            if (NormativeEvenlyDistributedLoadsV1 != null)
            {
                foreach (var n in NormativeEvenlyDistributedLoadsV1)
                {
                    loads = $"{loads}({n.NormativeValue} {n.NormativValueUM} {n.LoadAreaWidth * 1000} {n.ReliabilityCoefficient} {n.ReducingFactor}), ";
                }
            }
            loads = $"{loads}\n\t Type 2:";
            if (NormativeEvenlyDistributedLoadsV2 != null)
            {
                foreach (var n in NormativeEvenlyDistributedLoadsV2)
                {
                    loads = $"{loads} \n\t {n.LoadForFirstGroup} {n.LoadForSecondGroup} \n\t";
                }
            }

            return
                $" Material: {Material} \n " +
                $" Dry_wood: {DryWood} \n " +
                $" FlameRetardants: {FlameRetardants} \n " +
                $" Width: {Width * 1000} \n " +
                $" Height: {Height * 1000} \n " +
                $" Length: {Length * 1000} \n " +
                $" Amount: {Amount} \n " +
                $" Exploitation: {Exploitation} \n " +
                $" LoadingMode: {LoadingMode} \n " +
                $" Supports: {supports} \n " +
                $" loads: {loads}";
        }
    }
}
