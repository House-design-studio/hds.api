namespace Core.Common.Interfaces
{
    public interface ILoadsCalculator<TObj>
        where TObj : ILoadable, IPhysicMechanicalCharacteristicable, IGeometricCharacteristicable
    {
        Task<string> GetFullReportAsync(TObj model);
    }
}
