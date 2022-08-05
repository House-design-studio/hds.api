using Newtonsoft.Json;
using static HDS.BusinessLogic.Mathematics;

namespace HDS.BusinessLogic.FemClient
{
    /// <summary>
    /// модель данных для api
    /// </summary>
    internal class FemClientRequest
    {
        public int Nc => Nodes.Length;
        public int Bc => Beams.Length;
        public Node[] Nodes { get; set; }
        public Beam[] Beams { get; set; }

        public class Node
        {
            public Point3D Coordinate { get; set; }
            public Support support { get; set; }
            public Load load { get; set; }

            public Node(Point3D coordinate, Support support, Load load)
            {
                Coordinate = coordinate;
                this.support = support;
                this.load = load;
            }
        }

        public class Beam
        {
            public BeamInfo First { get; set; }
            public BeamInfo Second { get; set; }
            public ZDirection Z_Direction { get; set; }
            public double Stiffness_modulus { get; set; }
            public double Shear_modulus { get; set; }
            public double Cross_section_area { get; set; }
            public double Shear_area_y { get; set; }
            public double Shear_area_z { get; set; }
            public double Moment_of_inertia_x { get; set; }
            public double Moment_of_inertia_y { get; set; }
            public double Moment_of_inertia_z { get; set; }

            public Beam(BeamInfo first, BeamInfo second, ZDirection z_Direction, double stiffness_modulus, double shear_modulus, double cross_section_area, double shear_area_y, double shear_area_z, double moment_of_inertia_x, double moment_of_inertia_y, double moment_of_inertia_z)
            {
                First = first;
                Second = second;
                Z_Direction = z_Direction;
                Stiffness_modulus = stiffness_modulus;
                Shear_modulus = shear_modulus;
                Cross_section_area = cross_section_area;
                Shear_area_y = shear_area_y;
                Shear_area_z = shear_area_z;
                Moment_of_inertia_x = moment_of_inertia_x;
                Moment_of_inertia_y = moment_of_inertia_y;
                Moment_of_inertia_z = moment_of_inertia_z;
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
        }



        public class BeamInfo
        {
            public int Node { get; set; }
            public Flexible Is_Flexible { get; set; }
            public Fixed Is_Fixed { get; set; }

            public BeamInfo(int node, Flexible is_Flexible, Fixed is_Fixed)
            {
                Node = node;
                Is_Flexible = is_Flexible;
                Is_Fixed = is_Fixed;
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
