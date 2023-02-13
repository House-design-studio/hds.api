using Application.Common.Interfaces;
using Core.Common.Interfaces;
using Infrastructure.Database;
using Microsoft.EntityFrameworkCore;
using System.Collections;
using System.Security.Cryptography;

namespace Infrastructure.Repositories;
public class UnitOfWork : IUnitOfWork
{
    private readonly ApplicationDbContext _db;

    private Hashtable _repositories;
    private bool _disposed;

    public UnitOfWork(ApplicationDbContext db)
    {
        _db = db;
        _repositories = new Hashtable();
    }
    public IRepositoryAsync<T> Repository<T>() where T : IAuditableEntity
    {
        var type = typeof(T).Name;

        if (!_repositories.ContainsKey(type))
        {
            var repositoryType = typeof(RepositoryAsync<>);
            var repositoryInstance = Activator.CreateInstance(repositoryType.MakeGenericType(typeof(T)), _db);
            _repositories.Add(type, repositoryInstance);
        }

        return (IRepositoryAsync<T>)_repositories[type]!;
    }

    public async Task<int> Commit(CancellationToken cancellationToken)
    {
        return await _db.SaveChangesAsync(cancellationToken);
    }

    public Task Rollback()
    {
        _db.ChangeTracker.Entries().ToList().ForEach(x => x.Reload());
        return Task.CompletedTask;
    }

    public void Dispose()
    {
        if (!_disposed)
        {
            _db.Dispose();
        }
        _disposed = true;

        GC.SuppressFinalize(this);
    }
}