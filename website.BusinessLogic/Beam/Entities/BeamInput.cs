namespace HDS.BusinessLogic.Beam.Entities
{
    public class BeamInput
    {
        public Data.BeamMatireals Material { get; internal set; }

        public bool DryWood { get; internal set; } = false;
        public bool FlameRetardants { get; internal set; } = false;

        public double Width { get; internal set; }
        public double Height { get; internal set; }
        public double Length { get; internal set; }
        public int Amount { get; internal set; } = 1;

        public Data.Exploitations Exploitation { get; internal set; }

        public int LifeTime { get; internal set; }

        public Data.LoadingModes LoadingMode { get; internal set; }

        public List<double> Supports { get; internal set; } = new List<double>();

        public List<NormativeEvenlyDistributedLoad> NormativeEvenlyDistributedLoads { get; internal set; } = new List<NormativeEvenlyDistributedLoad>();

        public class NormativeEvenlyDistributedLoad
        {
            public double LoadForFirstGroup { get; internal set; }
            public double LoadForSecondGroup { get; internal set; }

            public NormativeEvenlyDistributedLoad(
                double loadForFirstGroup,
                double loadForSecondGroup)
            {
                LoadForFirstGroup = loadForFirstGroup;
                LoadForSecondGroup = loadForSecondGroup;
            }
        }
        public override string ToString()
        {

            string supports = "";
            string loads = "";

            foreach (var s in Supports)
            {
                supports = $"{supports}{s * 1000}, ";
            }
            supports = supports.Remove(supports.Length - 2);

            foreach (var s in NormativeEvenlyDistributedLoads)
            {
                loads = $"{loads} {s.LoadForFirstGroup * 1000} {s.LoadForSecondGroup * 1000}, ";
            }
            if (loads.Length > 0) loads = loads.Remove(loads.Length - 2);

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
