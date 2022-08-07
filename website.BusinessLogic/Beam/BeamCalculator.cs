using HDS.BusinessLogic.Beam.Entities;
using HDS.BusinessLogic.Interfaces;

namespace HDS.BusinessLogic.Beam
{
    public class BeamCalculator : IBeamCalculator
    {
        private readonly FullReport _report = new();

        public BeamInputBuilder GetBeamInputBuilder()
        {
            return new BeamInputBuilder();
        }

        public async Task<FullReport> GetFullReportAsync(BeamInput input)
        {
            _report.Input = input;

            SetStaticData();
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
    }
}
