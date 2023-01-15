using MathCore.FemCalculator.Model;

namespace MathCore.FemCalculator;

public class FemModel
{
    public FemModel(IEnumerable<Segment> segments, IEnumerable<Node> nodes)
    {
        Segments = segments.ToList();
        Nodes = nodes.ToList();
    }

    public FemModel()
    {
        Segments = new List<Segment>();
        Nodes = new List<Node>();
    }

    public List<Segment> Segments { get; set; }
    public List<Node> Nodes { get; set; }
}