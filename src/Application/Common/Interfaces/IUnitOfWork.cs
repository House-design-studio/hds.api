using Core.Common.Interfaces;

namespace Application.Common.Interfaces;
public interface IUnitOfWork : IDisposable
{
    IRepositoryAsync<T> Repository<T>() where T : IAuditableEntity;
    Task<int> Commit(CancellationToken cancellationToken);
    Task Rollback();
}