using MediatR.Pipeline;
using Microsoft.Extensions.Logging;

namespace Application.Common.Behaviour;

public class LoggingBehaviour<TRequest> : IRequestPreProcessor<TRequest>
    where TRequest : notnull
{
    private readonly ILogger<TRequest> _logger;

    public LoggingBehaviour(ILogger<TRequest> logger)
    {
        _logger = logger;
    }

    public Task Process(TRequest request, CancellationToken cancellationToken)
    {
        var requestName = typeof(TRequest).Name;

        _logger.LogInformation($"CleanArchitecture Request: {requestName}  {request}");

        return Task.CompletedTask;
    }
}