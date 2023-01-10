using MathCore.FemCalculator.Model;

namespace MathCore.FemCalculator;

public class FemModel
{
    public FemModel(IEnumerable<Beam> beams, IEnumerable<Node> nodes)
    {
        Beams = beams;
        Nodes = nodes;
    }

    public FemModel()
    {
        Beams = new List<Beam>();
        Nodes = new List<Node>();
    }

    public IEnumerable<Beam> Beams { get; set; }
    public IEnumerable<Node> Nodes { get; set; }
}