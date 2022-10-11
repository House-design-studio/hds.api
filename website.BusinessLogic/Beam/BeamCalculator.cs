using HDS.BusinessLogic.Beam.Entities;
using HDS.BusinessLogic.FemClient;
using HDS.BusinessLogic.Interfaces;
using static HDS.BusinessLogic.Beam.Analyze;

namespace HDS.BusinessLogic.Beam
{
    public class BeamCalculator : IBeamCalculator
    {
        private readonly IFemClient _femClient;
        private readonly FullReport _report = new();

        public BeamCalculator(IFemClient femClient)
        {
            _femClient = femClient;
        }
        public BeamInputBuilder GetBeamInputBuilder()
        {
            return new BeamInputBuilder();
        }

        public async Task<FullReport> GetFullReportAsync(BeamInput input)
        {
            _report.Input = input;

            SetStaticData();
            await SetApiData();

            return _report;
        }

        private void SetStaticData()
        {
            _report.ShrinkageInWidth = GetShrinkage(_report.Input.Width);
            _report.ShrinkageInHeight = GetShrinkage(_report.Input.Height);

            _report.EffectiveWidth = _report.Input.Width - _report.ShrinkageInWidth;
            _report.EffectiveHeight = _report.Input.Height - _report.ShrinkageInHeight;

            _report.CrossSectionArea = GetCrossSectionArea(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.PolarMomentOfInertia = GetPolarMomentOfInertia(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.MomentOfInertiaY = GetMomentOfInertiaY(_report.EffectiveWidth, _report.EffectiveHeight);
            _report.MomentOfInertiaZ = GetMomentOfInertiaZ(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.MomentOfResistanceY = GetMomentOfResistanceY(_report.EffectiveWidth, _report.EffectiveHeight);
            _report.MomentOfResistanceZ = GetMomentOfResistanceZ(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.StaticMomentOfShearSectionY = GetStaticMomentOfShearSectionY(_report.EffectiveWidth, _report.EffectiveHeight);
            _report.StaticMomentOfShearSectionZ = GetStaticMomentOfShearSectionZ(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.StiffnessModulus = Data.BeamMaterialСharacteristics[_report.Input.Material].StiffnessModulus;
            _report.StiffnessModulusAverage = Data.BeamMaterialСharacteristics[_report.Input.Material].StiffnessModulusAverage;
            _report.ShearModulusAverage = Data.BeamMaterialСharacteristics[_report.Input.Material].ShearModulusAverage;
            _report.BendingResistance = Data.BeamMaterialСharacteristics[_report.Input.Material].BendingResistance;
            _report.BendingShearResistance = Data.BeamMaterialСharacteristics[_report.Input.Material].BendingShearResistance;

            _report.MaCoefficient = GetMaCoefficient(_report.Input.FlameRetardants);
            _report.MbCoefficient = GetMbCoefficient(_report.Input.Exploitation);
            _report.MccCoefficient = GetMccCoefficient(_report.Input.LifeTime);
        }

        private async Task SetApiData()
        {
            var nodes = new List<FemClientRequest.Node>();

            AddBaseDots();
            nodes = nodes.DistinctBy(n => n.Coordinate.X).OrderBy(n => n.Coordinate.X).ToList();

            AddAdditionsDots();
            nodes = nodes.DistinctBy(n => n.Coordinate.X).OrderBy(n => n.Coordinate.X).ToList();

            SetValues();
            nodes = nodes.DistinctBy(n => n.Coordinate.X).OrderBy(n => n.Coordinate.X).ToList();

            Console.WriteLine("asdasda");


            void AddBaseDots()
            {
                // начальная точка
                nodes.Add(new FemClientRequest.Node());

                // конечная точка
                nodes.Add(new FemClientRequest.Node(
                    new Mathematics.Point3D(_report.Input.Length, 0, 0)));

                // опоры
                foreach (var supportOffset in _report.Input.Supports)
                {
                    nodes.Add(new FemClientRequest.Node(new Mathematics.Point3D(supportOffset, 0, 0)));
                }

                // распределённые нагрузки
                foreach (var load in _report.Input.DistributedLoads)
                {
                    nodes.Add(new FemClientRequest.Node(new Mathematics.Point3D(load.OffsetStart, 0, 0)));
                    nodes.Add(new FemClientRequest.Node(new Mathematics.Point3D(load.OffsetEnd, 0, 0)));
                }

                // сосредоточенные нагрузки
                foreach (var load in _report.Input.ConcentratedLoads)
                {
                    nodes.Add(new FemClientRequest.Node(new Mathematics.Point3D(load.Offset, 0, 0)));
                }
            }
            void AddAdditionsDots()
            {
                // вставка доп точек
                // не менее 3х между важными с шагом не более 0.05 метра (5см)
                var nodesArray = nodes.ToArray();
                for (int i = 0; i < nodesArray.Length - 1; i++)
                {
                    var distance = nodesArray[i + 1].Coordinate.X - nodesArray[i].Coordinate.X;
                    if (distance <= 0.01) continue;

                    var newNodes = new List<FemClientRequest.Node>();

                    if (distance > 0.01 && distance <= 0.2)
                    {
                        newNodes.Add(new FemClientRequest.Node(
                            new Mathematics.Point3D(nodesArray[i].Coordinate.X + (distance / 4), 0, 0)));

                        newNodes.Add(new FemClientRequest.Node(
                            new Mathematics.Point3D(nodesArray[i].Coordinate.X + (distance / 4 * 2), 0, 0)));

                        newNodes.Add(new FemClientRequest.Node(
                            new Mathematics.Point3D(nodesArray[i].Coordinate.X + (distance / 4 * 3), 0, 0)));
                    }
                    else if (distance > 0.2)
                    {
                        int numOfPoints = (int)Math.Ceiling(distance / 0.05) + 1;
                        var distanceBetween = distance / (numOfPoints - 1);

                        for (int j = 1; j <= numOfPoints - 1; j++)
                        {
                            newNodes.Add(new FemClientRequest.Node(
                            new Mathematics.Point3D(nodesArray[i].Coordinate.X + distanceBetween * j, 0, 0)));
                        }
                    }
                    nodes.InsertRange(i, newNodes);
                }
            }
            void SetValues()
            {
                // опоры
                var supportsArray = _report.Input.Supports.OrderBy(s => s).ToArray();
                for (int i = 0; i < supportsArray.Length; i++)
                {
                    double supportOffset = _report.Input.Supports[i];
                    var supportViaNode = nodes.First(n => n.Coordinate.X == supportOffset);
                    supportViaNode.Support.X = (i == 0);
                    supportViaNode.Support.Y = true;
                    supportViaNode.Support.Z = true;
                }

                // сосредоточенные нагрузки
                foreach (var load in _report.Input.ConcentratedLoads)
                {
                    var concentratedLoadsViaNode = nodes.First(n => n.Coordinate.X == load.Offset);

                    concentratedLoadsViaNode.Load.Z += -load.LoadForFirstGroup;
                }

                // распределённые нагрузки
                foreach (var load in _report.Input.DistributedLoads)
                {
                    var nodesBetweenLoad = nodes.Where(node => node.Coordinate.X >= load.OffsetStart &&
                                                               node.Coordinate.X <= load.OffsetEnd)
                                                .OrderBy(node => node.Coordinate.X)
                                                .ToArray();

                    for (int i = 0; i < nodesBetweenLoad.Length - 1; i++)
                    {
                        var leftNode = nodesBetweenLoad[i];
                        var rightNode = nodesBetweenLoad[i + 1];
                        var l = rightNode.Coordinate.X - leftNode.Coordinate.X;
                        var F = load.LoadForFirstGroup * l / 2;
                        var M = load.LoadForFirstGroup * l * l / 12;

                        leftNode.Load.Z += -F;
                        rightNode.Load.Z += -F;

                        leftNode.Load.V += -M;
                        rightNode.Load.V += M;
                    }
                }
            }

            //var request = new FemClientRequest();
            //var response = await _femClient.DoRequest(req);
        }
    }
}
