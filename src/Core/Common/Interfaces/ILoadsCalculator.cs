using MathCore.FemCalculator;

namespace Core.Common.Interfaces;

public interface ILoadsCalculator<in TObj>
    where TObj : ILoadable, IPhysicMechanicalCharacteristic, IGeometricCharacteristic
{
    Task<FemModel> GetFirstGroupOfLimitStates(TObj model);
    Task<FemModel> GetSecondGroupOfLimitStates(TObj model);
}