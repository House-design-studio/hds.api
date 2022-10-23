using HDS.Core.Beam.Entities;

namespace HDS.Core.Interfaces
{
    public interface IBeamCalculator
    {
        public Task<FullReport> GetFullReportAsync(BeamInput input);
        public BeamInputBuilder GetBeamInputBuilder();
    }
}
