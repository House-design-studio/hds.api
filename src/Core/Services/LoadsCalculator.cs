using Core.Common.Interfaces;
using MathCore.Common.Interfaces;
using MathCore.FemCalculator;

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
        public async Task<string> GetFullReportAsync(TObj model)
        {
            FemModel data = new FemModel();
            var res = await _femCalculator.CalculateAsync(data);
            // parse 
            // try to add Cache by hash 
            // unparse

            return "";
        }
    }
}
