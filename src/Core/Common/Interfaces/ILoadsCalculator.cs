using MathCore.FemCalculator;
using MathCore.FemCalculator.Model;

namespace Core.Common.Interfaces;

public interface ILoadsCalculator<in TObj>
    where TObj : ILoadable, IPhysicMechanicalCharacteristic, IGeometricCharacteristic
{
    Task<FemModel> GetFirstGroupOfLimitStates(TObj model);
    Task<FemModel> GetSecondGroupOfLimitStates(TObj model);
    IEnumerable<double> GetAbsoluteSupportsMaximum(TObj model, FemModel fem);
    IEnumerable<double> GetRelativeSupportsMaximum(TObj model, FemModel fem);
}