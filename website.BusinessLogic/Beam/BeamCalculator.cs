using HDS.BusinessLogic.Beam.Entities;
using HDS.BusinessLogic.FemClient;
using HDS.BusinessLogic.Interfaces;

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
            _report.ShrinkageInWidth = Analyze.Analyze.GetShrinkage(_report.Input.Width);
            _report.ShrinkageInHeight = Analyze.Analyze.GetShrinkage(_report.Input.Height);

            _report.EffectiveWidth = _report.Input.Width - _report.ShrinkageInWidth;
            _report.EffectiveHeight = _report.Input.Height - _report.ShrinkageInHeight;

            _report.CrossSectionArea = Analyze.Analyze.GetCrossSectionArea(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.PolarMomentOfInertia = Analyze.Analyze.GetPolarMomentOfInertia(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.MomentOfInertiaY = Analyze.Analyze.GetMomentOfInertiaY(_report.EffectiveWidth, _report.EffectiveHeight);
            _report.MomentOfInertiaZ = Analyze.Analyze.GetMomentOfInertiaZ(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.MomentOfResistanceY = Analyze.Analyze.GetMomentOfResistanceY(_report.EffectiveWidth, _report.EffectiveHeight);
            _report.MomentOfResistanceZ = Analyze.Analyze.GetMomentOfResistanceZ(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.StaticMomentOfShearSectionY = Analyze.Analyze.GetStaticMomentOfShearSectionY(_report.EffectiveWidth, _report.EffectiveHeight);
            _report.StaticMomentOfShearSectionZ = Analyze.Analyze.GetStaticMomentOfShearSectionZ(_report.EffectiveWidth, _report.EffectiveHeight);

            _report.StiffnessModulus = Data.BeamMaterialСharacteristics[_report.Input.Material].StiffnessModulus;
            _report.StiffnessModulusAverage = Data.BeamMaterialСharacteristics[_report.Input.Material].StiffnessModulusAverage;
            _report.ShearModulusAverage = Data.BeamMaterialСharacteristics[_report.Input.Material].ShearModulusAverage;
            _report.BendingResistance = Data.BeamMaterialСharacteristics[_report.Input.Material].BendingResistance;
            _report.BendingShearResistance = Data.BeamMaterialСharacteristics[_report.Input.Material].BendingShearResistance;

            _report.MaCoefficient = Analyze.Analyze.GetMaCoefficient(_report.Input.FlameRetardants);
            _report.MbCoefficient = Analyze.Analyze.GetMbCoefficient(_report.Input.Exploitation);
            _report.MccCoefficient = Analyze.Analyze.GetMccCoefficient(_report.Input.LifeTime);
        }

        private async Task SetApiData()
        {
            var nodes = new List<FemClientRequest.Node>();
            FemClientRequest.Node tmp;
            // начальная точка
            nodes.Add(new FemClientRequest.Node());
            // конечная точка
            nodes.Add(new FemClientRequest.Node(
                new Mathematics.Point3D(_report.Input.Length, 0, 0 )));
            
            // опоры
            var supports = _report.Input.Supports.ToArray();
            Array.Sort(supports);
            for (int i = 0; i < supports.Length; i++)
            {
                tmp = new FemClientRequest.Node(
                    new Mathematics.Point3D(supports[i], 0, 0));
                tmp.Support.X = (i == 0);
                tmp.Support.Y = true;
                tmp.Support.Z = true;
                nodes.Add(tmp);
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

            nodes = nodes.OrderBy(n => n.Coordinate.X).ToList();
            var nodesArray = nodes.ToArray();
            // вставка доп точек
            // не менее 3х между важными с шагом не более 0.05 метра (5см)
            for (int i = 0; i < nodesArray.Length - 1; i++)
            {
                var distance = nodesArray[i+1].Coordinate.X - nodesArray[i].Coordinate.X; 
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
                else if(distance > 0.2)
                {
                    int numOfPoints = (int) Math.Ceiling(distance / 0.05) - 1;
                    var distanceBetween = distance / numOfPoints;

                    for (int j = 0; j < numOfPoints; j++)
                    {
                        newNodes.Add(new FemClientRequest.Node(
                        new Mathematics.Point3D(nodesArray[i].Coordinate.X + distanceBetween * j, 0, 0)));
                    }
                }
                
                nodes.InsertRange(i + 1, newNodes);
            }

            //var request = new FemClientRequest();
            //var response = await _femClient.DoRequest(req);
            
        }
    }
}
