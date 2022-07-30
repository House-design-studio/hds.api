using HDS.BusinessLogic.Beam.Entities;

namespace HDS.BusinessLogic.Interfaces
{
    public interface IBeamCalculator
    {
        public Task<FullReport> GetFullReportAsync(BeamInput input);  
    }
}
