﻿using Newtonsoft.Json;
using static HDS.BusinessLogic.Math;

namespace HDS.BusinessLogic.Beam
{
    /// <summary>
    /// Класс для создания запроса к fem server 
    /// </summary>
    public class FemServerRequest
    {
#pragma warning disable IDE1006 // Стили именования
        private int nc;
        private int bc;
        private Node[] nodes;
        private Beam[] beams;

        private void SetUpData()
        {

        }
        /// <summary>
        /// На основе класса сериализует в json
        /// </summary>
        /// <returns>json сериализация</returns>
        private string ToJson()
        {
            var json = JsonConvert.SerializeObject(this);

            json = json.ToLower();
            return json;
        }
        private class Node
        {
            public Point3D coordinate { get; set; }
            public Support support { get; set; }
            public Load load { get; set; }
        }

        private class Support
        {
            public bool x { get; set; }
            public bool y { get; set; }
            public bool z { get; set; }
            public bool u { get; set; }
            public bool v { get; set; }
            public bool w { get; set; }
        }
        private class Load : Coordinate
        {
            public double u { get; set; }
            public double v { get; set; }
            public double w { get; set; }
        }

        private class Beam
        {
            public BeamInfo first { get; set; }
            public BeamInfo second { get; set; }
            public ZDirection z_direction { get; set; }
            public double stiffness_modulus { get; set; }
            public double shear_modulus { get; set; }
            public double cross_section_area { get; set; }
            public double shear_area_y { get; set; }
            public double shear_area_z { get; set; }
            public double moment_of_inertia_x { get; set; }
            public double moment_of_inertia_y { get; set; }
            public double moment_of_inertia_z { get; set; }
        }
        private class BeamInfo
        {
            public int node { get; set; }
            public Flexible flexible { get; set; }
            public Fixed Fixed { get; set; }
        }
        private class Flexible
        {
            public bool x { get; set; }
            public bool y { get; set; }
            public bool z { get; set; }
            public bool u { get; set; }
            public bool v { get; set; }
            public bool w { get; set; }
        }
        private class Fixed : Flexible
        {
        }
        private class ZDirection : Coordinate
        {
        }
        //to lowwercase
#pragma warning restore IDE1006 // Стили именования
    }
}