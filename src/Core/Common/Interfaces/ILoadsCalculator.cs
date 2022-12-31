namespace HDS.Core.Common.Interfaces
{
    public interface ILoadsCalculator<TObj>
        where TObj : ILoadable, IPhysicMechanicalCharacteristicable, IGeometricCharacteristicable
    {
        Task<string> GetFirstGroupOfLimitStates(TObj model);
        Task<string> GetSecondGroupOfLimitStates(TObj model);
    }
}
