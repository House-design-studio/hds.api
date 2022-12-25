using Newtonsoft.Json;
using static HDS.Core.Mathematics;

namespace HDS.Core.FemClient
{
    /// <summary>
    /// модель данных для api
    /// </summary>
    public class FemClientRequest
    {
        public int Nc => Nodes.Length;
        public int Bc => Beams.Length;
        public Node[] Nodes { get; set; }
        public Beam[] Beams { get; set; }

        public FemClientRequest(Node[] nodes, Beam[] beams)
        {
            Nodes = nodes;
            Beams = beams;
        }
        public string ToJson()
        {
            return JsonConvert.SerializeObject(new { Nc, Bc, Nodes, Beams }).ToLower();
        }
        public class Node
        {
            public Point3D Coordinate { get; set; }
            public Support Support { get; set; }
            public Load Load { get; set; }

            public Node(Point3D coordinate, Support support, Load load)
            {
                Coordinate = coordinate;
                this.Support = support;
                this.Load = load;
            }
            public Node()
            {
                Coordinate = new Point3D();
                this.Support = new Support();
                this.Load = new Load();
            }
            public Node(Point3D coordinate)
            {
                Coordinate = coordinate;
                this.Support = new Support();
                this.Load = new Load();
            }
        }

        public class Beam
        {
            public BeamInfo First { get; set; }
            public BeamInfo Second { get; set; }
            public Point3D Z_Direction { get; set; }
            public double Stiffness_Modulus { get; set; }
            public double Shear_Modulus { get; set; }
            public double Cross_Sectional_Area { get; set; }
            public double Shear_Area_Y { get; set; }
            public double Shear_Area_Z { get; set; }
            public double Moment_Of_Inertia_X { get; set; }
            public double Moment_Of_Inertia_Y { get; set; }
            public double Moment_Of_Inertia_Z { get; set; }

            public Beam(BeamInfo first, BeamInfo second, Point3D z_Direction, double stiffness_Modulus, double shear_Modulus, double cross_Sectional_Area, double shear_Area_Y, double shear_Area_Z, double moment_Of_Inertia_X, double moment_Of_Inertia_Y, double moment_Of_Inertia_Z)
            {
                First = first;
                Second = second;
                Z_Direction = z_Direction;
                Stiffness_Modulus = stiffness_Modulus;
                Shear_Modulus = shear_Modulus;
                Cross_Sectional_Area = cross_Sectional_Area;
                Shear_Area_Y = shear_Area_Y;
                Shear_Area_Z = shear_Area_Z;
                Moment_Of_Inertia_X = moment_Of_Inertia_X;
                Moment_Of_Inertia_Y = moment_Of_Inertia_Y;
                Moment_Of_Inertia_Z = moment_Of_Inertia_Z;
            }
        }
        public class Support
        {
            public bool X { get; set; }
            public bool Y { get; set; }
            public bool Z { get; set; }
            public bool U { get; set; }
            public bool V { get; set; }
            public bool W { get; set; }

            public Support(bool x, bool y, bool z, bool u, bool v, bool w)
            {
                X = x;
                Y = y;
                Z = z;
                U = u;
                V = v;
                W = w;
            }
            public Support()
            {
                X = false;
                Y = false;
                Z = false;
                U = false;
                V = false;
                W = false;
            }
        }
        public class Load : Point3D
        {
            public double U { get; set; }
            public double V { get; set; }
            public double W { get; set; }
            public Load(double x, double y, double z, double u, double v, double w) : base(x, y, z)
            {
                U = u;
                V = v;
                W = w;
            }
            public Load() : base()
            {
                U = 0;
                V = 0;
                W = 0;
            }
        }



        public class BeamInfo
        {
            public int Node { get; set; }
            public Flexible Is_Flexible { get; set; }
            public Fixed Is_Fixed { get; set; }

            public BeamInfo(int node, Flexible isFlexible, Fixed isFixed)
            {
                Node = node;
                Is_Flexible = isFlexible;
                Is_Fixed = isFixed;
            }
        }
        public class Flexible
        {
            public bool X { get; set; }
            public bool Y { get; set; }
            public bool Z { get; set; }
            public bool U { get; set; }
            public bool V { get; set; }
            public bool W { get; set; }
            public Flexible(bool x, bool y, bool z, bool u, bool v, bool w)
            {
                X = x;
                Y = y;
                Z = z;
                U = u;
                V = v;
                W = w;
            }
        }
        public class Fixed
        {
            public bool X { get; set; }
            public bool Y { get; set; }
            public bool Z { get; set; }
            public bool U { get; set; }
            public bool V { get; set; }
            public bool W { get; set; }
            public Fixed(bool x, bool y, bool z, bool u, bool v, bool w)
            {
                X = x;
                Y = y;
                Z = z;
                U = u;
                V = v;
                W = w;
            }
        }
    }
}
