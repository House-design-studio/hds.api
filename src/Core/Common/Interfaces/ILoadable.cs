using HDS.Core.Common.Enums;
using HDS.Core.Entities.Loads;

namespace HDS.Core.Common.Interfaces
{
    public interface ILoadable
    {
        LoadingModes LoadingMode { get; set; }
        IEnumerable<double> Supports { get; set; }
        IEnumerable<DistributedLoad> DistributedLoads { get; set; }
        IEnumerable<ConcentratedLoad> ConcentratedLoads { get; set; }
    }
}
