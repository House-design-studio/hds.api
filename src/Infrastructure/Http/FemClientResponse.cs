using Newtonsoft.Json;

namespace Infrastructure;

public class FemClientResponse
{
    public class Beam
    {
        [JsonProperty("first")]
        public First First { get; set; }

        [JsonProperty("second")]
        public Second Second { get; set; }
    }

    public class Displacement
    {
        [JsonProperty("z")]
        public double Z { get; set; }

        [JsonProperty("x")]
        public double X { get; set; }

        [JsonProperty("w")]
        public double W { get; set; }

        [JsonProperty("v")]
        public double V { get; set; }

        [JsonProperty("u")]
        public double U { get; set; }

        [JsonProperty("y")]
        public double Y { get; set; }
    }

    public class First
    {
        [JsonProperty("displacement")]
        public Displacement Displacement { get; set; }

        [JsonProperty("force")]
        public Force Force { get; set; }
    }

    public class Force
    {
        [JsonProperty("z")]
        public double Z { get; set; }

        [JsonProperty("x")]
        public double X { get; set; }

        [JsonProperty("w")]
        public double W { get; set; }

        [JsonProperty("v")]
        public double V { get; set; }

        [JsonProperty("u")]
        public double U { get; set; }

        [JsonProperty("y")]
        public double Y { get; set; }
    }

    public class Node
    {
        [JsonProperty("displacement")]
        public Displacement Displacement { get; set; }
    }

    public class Root
    {
        [JsonProperty("bc")]
        public int Bc { get; set; }

        [JsonProperty("nc")]
        public int Nc { get; set; }

        [JsonProperty("nodes")]
        public List<Node> Nodes { get; set; }

        [JsonProperty("beams")]
        public List<Beam> Beams { get; set; }
    }

    public class Second
    {
        [JsonProperty("displacement")]
        public Displacement Displacement { get; set; }

        [JsonProperty("force")]
        public Force Force { get; set; }
    }
}