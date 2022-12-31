using Core.Common.Interfaces;
using MathCore.Common.Interfaces;

namespace HDS.Core.Services
{
    public class LoadsCalculator<TObj> : ILoadsCalculator<TObj>
        where TObj : ILoadable, IPhysicMechanicalCharacteristicable, IGeometricCharacteristicable
    {
        private readonly IFemCalculator _femCalculator;
        public LoadsCalculator(IFemCalculator femCalculator)
        {
            _femCalculator = femCalculator;
        }
        public Task<TObj> GetFullReportAsync()
        {
            throw new NotImplementedException();
        }
    }
}
