namespace Application.Common.Interfaces;

public interface IRepositoryAsync<T> 
{
    IQueryable<T> Entities { get; }

    Task<T?> GetByIdAsync(int id);

    Task<List<T>> GetAllAsync();

    Task<T> AddAsync(T entity);

    Task UpdateAsync(T entity);

    Task DeleteAsync(T entity);
}