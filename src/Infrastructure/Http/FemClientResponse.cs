using Newtonsoft.Json;

namespace Infrastructure;

public class FemClientResponse
{
    public class Root
    {
        [JsonProperty("nc")] public int Nc { get; set; }

        [JsonProperty("bc")] public int Bc { get; set; }

        [JsonProperty("nodes")] public List<Node> Nodes { get; set; }

        [JsonProperty("beams")] public List<Beam> Beams { get; set; }
    }

    public class Node
    {
        [JsonProperty("displacement")] public AxisValues Displacement { get; set; }
    }

    public class Beam
    {
        [JsonProperty("displacement")] public AxisValues Displacement { get; set; }

        [JsonProperty("force")] public AxisValues Force { get; set; }
    }

    public class AxisValues
    {
        [JsonProperty("x")] public double X { get; set; }

        [JsonProperty("y")] public double Y { get; set; }

        [JsonProperty("z")] public double Z { get; set; }

        [JsonProperty("u")] public double U { get; set; }

        [JsonProperty("v")] public double V { get; set; }

        [JsonProperty("w")] public double W { get; set; }
    }
}