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

        public List<DistributedLoad> DistributedLoads { get; internal set; } = new List<DistributedLoad>();
        public List<ConcentratedLoad> ConcentratedLoads { get; internal set; } = new List<ConcentratedLoad>();

        public abstract class Load
        {
            public double LoadForFirstGroup { get; internal set; }
            public double LoadForSecondGroup { get; internal set; }

            protected Load(
                double loadForFirstGroup,
                double loadForSecondGroup)
            {
                LoadForFirstGroup = loadForFirstGroup;
                LoadForSecondGroup = loadForSecondGroup;
            }
        }
        public class DistributedLoad : Load
        {
            public double OffsetStart { get; internal set; }
            public double OffsetEnd { get; internal set; }
            public DistributedLoad(double offsetStart, double offsetEnd, double loadForFirstGroup, double loadForSecondGroup)
                : base(loadForFirstGroup, loadForSecondGroup)
            {
                OffsetStart = offsetStart;
                OffsetEnd = offsetEnd;
            }
        }

        public class ConcentratedLoad : Load
        {
            public double Offset { get; internal set; }
            public ConcentratedLoad(double offset, double loadForFirstGroup, double loadForSecondGroup)
                : base(loadForFirstGroup, loadForSecondGroup)
            {
                Offset = offset;
            }
        }

        public override string ToString()
        {
            var supports = Supports.Aggregate("", (current, s) => $"{current}{s * 1000}, ");
            supports = supports.Remove(supports.Length - 2);

            var distributedLoad = DistributedLoads.Aggregate("", (current, s) => $"{current} {s.OffsetStart * 1000} {s.OffsetEnd * 1000} {s.LoadForFirstGroup} {s.LoadForSecondGroup}, ");
            if (distributedLoad.Length > 0) distributedLoad = distributedLoad.Remove(distributedLoad.Length - 2);

            var concentratedLoad = ConcentratedLoads.Aggregate("", (current, s) => $"{current} {s.Offset * 1000} {s.LoadForFirstGroup} {s.LoadForSecondGroup}, ");
            if (concentratedLoad.Length > 0) concentratedLoad = concentratedLoad.Remove(concentratedLoad.Length - 2);

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
                $" DistributedLoads: {distributedLoad} \n " +
                $" ConcentratedLoads: {concentratedLoad}";
        }
    }
}
