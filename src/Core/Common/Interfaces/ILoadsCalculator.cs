namespace Core.Common.Interfaces;

public interface ILoadsCalculator<in TObj>
    where TObj : ILoadable, IPhysicMechanicalCharacteristic, IGeometricCharacteristic
{
    Task<string> GetFirstGroupOfLimitStates(TObj model);
    Task<string> GetSecondGroupOfLimitStates(TObj model);
}