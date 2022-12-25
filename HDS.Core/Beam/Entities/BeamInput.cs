namespace HDS.Core.Beam.Entities
{
    public class BeamInput
    {
        public Data.BeamMatireals Material { get; set; }

        public bool DryWood { get; set; } = false;
        public bool FlameRetardants { get; set; } = false;

        public double Width { get; set; }
        public double Height { get; set; }
        public double Length { get; set; }
        public int Amount { get; set; } = 1;

        public Data.Exploitations Exploitation { get; set; }

        public int LifeTime { get; set; }

        public int SteadyTemperature { get; set; }

        public Data.LoadingModes LoadingMode { get; set; }

        public List<double> Supports { get; set; } = new List<double>();

        public List<DistributedLoad> DistributedLoads { get; set; } = new List<DistributedLoad>();
        public List<ConcentratedLoad> ConcentratedLoads { get; set; } = new List<ConcentratedLoad>();
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
