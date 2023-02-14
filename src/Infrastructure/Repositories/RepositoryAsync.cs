﻿using Application.Common.Interfaces;
using Core.Common.Interfaces;
using Infrastructure.Database;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repositories;

public class RepositoryAsync<T> : IRepositoryAsync<T> where T : class, IAuditableEntity
{
    private readonly ApplicationDbContext _dbContext;

    public RepositoryAsync(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public IQueryable<T> Entities => _dbContext.Set<T>();

    public async Task<T> AddAsync(T entity)
    {
        await _dbContext.Set<T>().AddAsync(entity);
        return entity;
    }

    public Task DeleteAsync(T entity)
    {
        _dbContext.Set<T>().Remove(entity);
        return Task.CompletedTask;
    }

    public async Task<List<T>> GetAllAsync()
    {
        return await _dbContext
            .Set<T>()
            .ToListAsync();
    }

    public async Task<T?> GetByIdAsync(int id)
    {
        return await _dbContext.Set<T>().FindAsync(id);
    }

    public Task UpdateAsync(T entity)
    {
        var exist = _dbContext.Set<T>().Find(entity.Id)!;
        _dbContext.Entry(exist).CurrentValues.SetValues(entity);
        return Task.CompletedTask;
    }
}