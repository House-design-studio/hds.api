namespace website.Models
{
    public class BeamModel
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

        public int[] Supports { get; private set;}

        public List<NormativeEvenlyDistributedLoadV1>? NormativeEvenlyDistributedLoadsV1 { get; set; }
        public List<NormativeEvenlyDistributedLoadV2>? NormativeEvenlyDistributedLoadsV2 { get; set; }


        public class NormativeEvenlyDistributedLoadV1
        {
            public int NormativeValue { get; private set; }
            public int LoadAreaWidth { get; private set; }
            public int ReliabilityCoefficient { get; private set; }
            public int ReducingFactor { get; private set; }

            public NormativeEvenlyDistributedLoadV1(
                int normativeValue,
                int loadAreaWidth,
                int reliabilityCoefficient,
                int reducingFactor)
            {
                this.NormativeValue = normativeValue;
                this.LoadAreaWidth = loadAreaWidth;
                this.ReliabilityCoefficient = reliabilityCoefficient;
                this.ReducingFactor = reducingFactor;
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
                this.LoadForFirstGroup = loadForFirstGroup;
                this.LoadForSecondGroup = loadForSecondGroup;
            }
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

        public BeamModel(Matireals material,
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
            this.Material = material;
            this.DryWood = dryWood;
            this.Width = width;
            this.Height = height;
            this.Length = length;
            this.Amount = amount;
            this.Exploitation = exploitation;

            if(lifeTime < 0)
            {
                throw new ArgumentException("not valid life time");
            }
            this.LifeTime = lifeTime;
            this.LoadingMode = loadingMode;
            this.Supports = supports;

            this.NormativeEvenlyDistributedLoadsV1 = normativeEvenlyDistributedLoadsV1;
            this.NormativeEvenlyDistributedLoadsV2 = normativeEvenlyDistributedLoadsV2;
        }

        public override string ToString()
        {

            string supports = "\t";
            string loads = "\t";

            foreach (var s in this.Supports)
            {
                supports = $"{supports} \n\t {s}";
            }

            if(this.NormativeEvenlyDistributedLoadsV1 != null)
            {
                foreach(var n in this.NormativeEvenlyDistributedLoadsV1)
                {
                    loads = $"{loads} \n\t {n.NormativeValue} {n.LoadAreaWidth} {n.ReliabilityCoefficient} {n.ReducingFactor} \n\t";
                }
            }

            if (this.NormativeEvenlyDistributedLoadsV2 != null)
            {
                foreach (var n in this.NormativeEvenlyDistributedLoadsV2)
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
