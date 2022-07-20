namespace website.BusinessLogic.Beam
{
    public class Input
    {
        public Matireals Material { get; private set; }

        public bool DryWood { get; private set; }
        public bool FlameRetardants { get; private set; }

        public int Width { get; private set; }
        public int Height { get; private set; }
        public int Length { get; private set; }
        public int Amount { get; private set; }

        public Exploitations Exploitation { get; private set; }

        public int LifeTime { get; private set; }

        public LoadingModes LoadingMode { get; private set; }

        public int[] Supports { get; private set; }

        public List<NormativeEvenlyDistributedLoadV1>? NormativeEvenlyDistributedLoadsV1 { get; set; }
        public List<NormativeEvenlyDistributedLoadV2>? NormativeEvenlyDistributedLoadsV2 { get; set; }


        public class NormativeEvenlyDistributedLoadV1
        {
            public int NormativeValue { get; private set; }
            public UnitsOfMeasurement NormativValueUM { get; private set; }
            public int? LoadAreaWidth { get; private set; }
            public double ReliabilityCoefficient { get; private set; }
            public double ReducingFactor { get; private set; }

            public NormativeEvenlyDistributedLoadV1(
                int normativeValue,
                UnitsOfMeasurement normativValueUM,
                int? loadAreaWidth,
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
            public int LoadForFirstGroup { get; set; }
            public int LoadForSecondGroup { get; set; }

            public NormativeEvenlyDistributedLoadV2(
                int loadForFirstGroup,
                int loadForSecondGroup)
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
        public enum LoadingModes
        {
            a,
            b,
            v,
            g,
            d,
            e,
            j,
            z,
            k,
            l,
            m
        }

        public enum Exploitations
        {
            class_1a,
            class_1b,
            class_2,
            class_3,
            class_4a,
            class_4b
        }

        public enum Matireals
        {
            plank_k16,
            plank_k24,
            plank_k26,
            lvl_k35,
            lvl_k40,
            lvl_k45
        }

        public Input(Matireals material,
                         bool dryWood,
                         bool flameRetardants,
                         int width,
                         int height,
                         int length,
                         int amount,
                         Exploitations exploitation,
                         int lifeTime,
                         LoadingModes loadingMode,
                         int[] supports,
                         List<NormativeEvenlyDistributedLoadV1>? normativeEvenlyDistributedLoadsV1,
                         List<NormativeEvenlyDistributedLoadV2>? normativeEvenlyDistributedLoadsV2)
        {
            Material = material;
            DryWood = dryWood;
            Width = width;
            Height = height;
            Length = length;
            Amount = amount;
            Exploitation = exploitation;

            if (lifeTime < 0)
            {
                throw new ArgumentException("not valid life time");
            }
            LifeTime = lifeTime;
            LoadingMode = loadingMode;
            Supports = supports;

            NormativeEvenlyDistributedLoadsV1 = normativeEvenlyDistributedLoadsV1;
            NormativeEvenlyDistributedLoadsV2 = normativeEvenlyDistributedLoadsV2;
        }

        public override string ToString()
        {

            string supports = "\t";
            string loads = "\t";

            foreach (var s in Supports)
            {
                supports = $"{supports} \n\t {s}";
            }

            if (NormativeEvenlyDistributedLoadsV1 != null)
            {
                foreach (var n in NormativeEvenlyDistributedLoadsV1)
                {
                    loads = $"{loads} \n\t {n.NormativeValue} {n.NormativValueUM} {n.LoadAreaWidth} {n.ReliabilityCoefficient} {n.ReducingFactor} \n\t";
                }
            }

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
                $" Width: {Width} \n " +
                $" Height: {Height} \n " +
                $" Length: {Length} \n " +
                $" Amount: {Amount} \n " +
                $" Exploitation: {Exploitation} \n" +
                $" LoadingMode: {LoadingMode} \n" +
                $" Supports: {supports} \n" +
                $" loads: {loads}";
        }
    }
}
