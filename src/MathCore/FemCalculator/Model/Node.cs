﻿using HDS.MathCore.Common.Base;

namespace HDS.MathCore.FemCalculator.Model
{
    public class Node : Vector6D<double>
    {
        public Point3D Coordinate { get; set; }
        public Vector6D<bool> Support { get; set; }
        public Vector6D<double> Load { get; set; }

        public Node()
        {
            Coordinate = new Point3D();
            Support = new Vector6D<bool>();
            Load = new Vector6D<double>();
        }
    }
}
