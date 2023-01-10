﻿using HDS.Core.Common.Interfaces;
using HDS.MathCore.Common.Interfaces;
using HDS.MathCore.FemCalculator;

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
        public async Task<string> GetFirstGroupOfLimitStates(TObj model)
        {
            FemModel data = new FemModel();
            var res = _femCalculator.CalculateAsync(data);
            // parse 
            // try to add Cache by hash 
            // unparse

            return "";
        }
        public async Task<string> GetSecondGroupOfLimitStates(TObj model)
        {
            FemModel data = new FemModel();
            var res = _femCalculator.CalculateAsync(data);
            // parse 
            // try to add Cache by hash 
            // unparse

            return "";
        }
    }
}
