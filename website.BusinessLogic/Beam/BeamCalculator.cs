using HDS.BusinessLogic.Beam.Entities;
using HDS.BusinessLogic.Interfaces;

namespace HDS.BusinessLogic.Beam
{
    public class BeamCalculator : IBeamCalculator
    {
        private FullReport Report = new();

        public async Task<FullReport> GetFullReportAsync(BeamInput input)
        {
            Report.Input = input;

            SetStaticData();
            return Report;
        }
        
        private void SetStaticData()
        {
            Report.ShrinkageInWidth = Analyze.GetShrinkage(Report.Input.Width);
            Report.ShrinkageInHeight = Analyze.GetShrinkage(Report.Input.Height);

            Report.EffectiveWidth = Report.Input.Width - Report.ShrinkageInWidth;
            Report.EffectiveHeight = Report.Input.Height - Report.ShrinkageInHeight;

            Report.CrossSectionArea = Analyze.GetCrossSectionArea(Report.EffectiveWidth, Report.EffectiveHeight);

            Report.PolarMomentOfInertia = Analyze.GetPolarMomentOfInertia(Report.EffectiveWidth, Report.EffectiveHeight);

            Report.MomentOfInertiaY = Analyze.GetMomentOfInertiaY(Report.EffectiveWidth, Report.EffectiveHeight);
            Report.MomentOfInertiaZ = Analyze.GetMomentOfInertiaZ(Report.EffectiveWidth, Report.EffectiveHeight);

            Report.MomentOfResistanceY = Analyze.GetMomentOfResistanceY(Report.EffectiveWidth, Report.EffectiveHeight);
            Report.MomentOfResistanceZ = Analyze.GetMomentOfResistanceZ(Report.EffectiveWidth, Report.EffectiveHeight);

            Report.StaticMomentOfShearSectionY = Analyze.GetStaticMomentOfShearSectionY(Report.EffectiveWidth, Report.EffectiveHeight);
            Report.StaticMomentOfShearSectionZ = Analyze.GetStaticMomentOfShearSectionZ(Report.EffectiveWidth, Report.EffectiveHeight);

            Report.StiffnessModulus = Data.BeamMaterialСharacteristics[Report.Input.Material].StiffnessModulus;
            Report.StiffnessModulusAverage = Data.BeamMaterialСharacteristics[Report.Input.Material].StiffnessModulusAverage;
            Report.ShearModulusAverage = Data.BeamMaterialСharacteristics[Report.Input.Material].ShearModulusAverage;
            Report.BendingResistance = Data.BeamMaterialСharacteristics[Report.Input.Material].BendingResistance;
            Report.BendingShearResistance = Data.BeamMaterialСharacteristics[Report.Input.Material].BendingShearResistance;

            Report.MaCoefficient = Analyze.GetMaCoefficient(Report.Input.FlameRetardants);
            Report.MBCoefficient = Analyze.GetMBCoefficient(Report.Input.Exploitation);
            Report.mccCoefficient = Analyze.GetMccCoefficient(Report.Input.LifeTime);
        }
    }
}
