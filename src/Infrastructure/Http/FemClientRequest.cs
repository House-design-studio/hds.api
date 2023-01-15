using Newtonsoft.Json;
namespace Infrastructure;

public class FemClientRequest
{
        public class Beam
    {
        [JsonProperty("first")]
        public First First { get; set; }

        [JsonProperty("second")]
        public Second Second { get; set; }

        [JsonProperty("z_direction")]
        public ZDirection ZDirection { get; set; }

        [JsonProperty("stiffness_modulus")]
        public double StiffnessModulus { get; set; }

        [JsonProperty("shear_modulus")]
        public double ShearModulus { get; set; }

        [JsonProperty("cross_section_area")]
        public double CrossSectionArea { get; set; }

        [JsonProperty("shear_area_y")]
        public double ShearAreaY { get; set; }

        [JsonProperty("shear_area_z")]
        public double ShearAreaZ { get; set; }

        [JsonProperty("moment_of_inertia_x")]
        public double MomentOfInertiaX { get; set; }

        [JsonProperty("moment_of_inertia_y")]
        public double MomentOfInertiaY { get; set; }

        [JsonProperty("moment_of_inertia_z")]
        public double MomentOfInertiaZ { get; set; }
    }

    public class Coordinate
    {
        [JsonProperty("x")]
        public double X { get; set; }

        [JsonProperty("y")]
        public double Y { get; set; }

        [JsonProperty("z")]
        public double Z { get; set; }
    }

    public class First
    {
        [JsonProperty("node")]
        public int Node { get; set; }

        [JsonProperty("flexible")]
        public Flexible Flexible { get; set; }

        [JsonProperty("fixed")]
        public Fixed Fixed { get; set; }
    }

    public class Fixed
    {
        [JsonProperty("x")]
        public bool X { get; set; }

        [JsonProperty("y")]
        public bool Y { get; set; }

        [JsonProperty("z")]
        public bool Z { get; set; }

        [JsonProperty("u")]
        public bool U { get; set; }

        [JsonProperty("v")]
        public bool V { get; set; }

        [JsonProperty("w")]
        public bool W { get; set; }
    }

    public class Flexible
    {
        [JsonProperty("x")]
        public bool X { get; set; }

        [JsonProperty("y")]
        public bool Y { get; set; }

        [JsonProperty("z")]
        public bool Z { get; set; }

        [JsonProperty("u")]
        public bool U { get; set; }

        [JsonProperty("v")]
        public bool V { get; set; }

        [JsonProperty("w")]
        public bool W { get; set; }
    }

    public class Load
    {
        [JsonProperty("x")]
        public double X { get; set; }

        [JsonProperty("y")]
        public double Y { get; set; }

        [JsonProperty("z")]
        public double Z { get; set; }

        [JsonProperty("u")]
        public double U { get; set; }

        [JsonProperty("v")]
        public double V { get; set; }

        [JsonProperty("w")]
        public double W { get; set; }
    }

    public class Node
    {
        [JsonProperty("coordinate")]
        public Coordinate Coordinate { get; set; }

        [JsonProperty("support")]
        public Support Support { get; set; }

        [JsonProperty("load")]
        public Load Load { get; set; }
    }

    public class Root
    {
        [JsonProperty("nc")]
        public int Nc { get; set; }

        [JsonProperty("bc")]
        public int Bc { get; set; }

        [JsonProperty("nodes")]
        public IEnumerable<Node> Nodes { get; set; }

        [JsonProperty("beams")]
        public IEnumerable<Beam> Beams { get; set; }
    }

    public class Second
    {
        [JsonProperty("node")]
        public int Node { get; set; }

        [JsonProperty("flexible")]
        public Flexible Flexible { get; set; }

        [JsonProperty("fixed")]
        public Fixed Fixed { get; set; }
    }

    public class Support
    {
        [JsonProperty("x")]
        public bool X { get; set; }

        [JsonProperty("y")]
        public bool Y { get; set; }

        [JsonProperty("z")]
        public bool Z { get; set; }

        [JsonProperty("u")]
        public bool U { get; set; }

        [JsonProperty("v")]
        public bool V { get; set; }

        [JsonProperty("w")]
        public bool W { get; set; }
    }

    public class ZDirection
    {
        [JsonProperty("x")]
        public double X { get; set; }

        [JsonProperty("y")]
        public double Y { get; set; }

        [JsonProperty("z")]
        public double Z { get; set; }
    }
}