namespace MathCore.FemCalculator
{
    public class FemModel
    {
        public IEnumerable<Beam> Beams { get; set; }
        public IEnumerable<Node> Nodes { get; set; }

        public FemModel(IEnumerable<Beam> beams, IEnumerable<Node> nodes)
        {
            Beams = beams;
            Nodes = nodes;
        }
    }
}
