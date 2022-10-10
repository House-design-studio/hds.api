using Newtonsoft.Json;
using static HDS.BusinessLogic.Mathematics;

namespace HDS.BusinessLogic.FemClient
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
            public ZDirection ZDirection { get; set; }
            public double StiffnessModulus { get; set; }
            public double ShearModulus { get; set; }
            public double CrossSectionArea { get; set; }
            public double ShearAreaY { get; set; }
            public double ShearAreaZ { get; set; }
            public double MomentOfInertiaX { get; set; }
            public double MomentOfInertiaY { get; set; }
            public double MomentOfInertiaZ { get; set; }

            public Beam(BeamInfo first, BeamInfo second, ZDirection zDirection, double stiffnessModulus, double shearModulus, double crossSectionArea, double shearAreaY, double shearAreaZ, double momentOfInertiaX, double momentOfInertiaY, double momentOfInertiaZ)
            {
                First = first;
                Second = second;
                ZDirection = zDirection;
                StiffnessModulus = stiffnessModulus;
                ShearModulus = shearModulus;
                CrossSectionArea = crossSectionArea;
                ShearAreaY = shearAreaY;
                ShearAreaZ = shearAreaZ;
                MomentOfInertiaX = momentOfInertiaX;
                MomentOfInertiaY = momentOfInertiaY;
                MomentOfInertiaZ = momentOfInertiaZ;
            }
            //todo: no args class init
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
            public Flexible IsFlexible { get; set; }
            public Fixed IsFixed { get; set; }

            public BeamInfo(int node, Flexible isFlexible, Fixed isFixed)
            {
                Node = node;
                IsFlexible = isFlexible;
                IsFixed = isFixed;
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
        public class ZDirection : Point3D
        {
            public ZDirection(double x, double y, double z) : base(x, y, z)
            {
                X = x;
                Y = y;
                Z = z;
            }
        }
    }
}
