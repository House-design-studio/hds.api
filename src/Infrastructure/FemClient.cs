using MathCore.Common.Interfaces;
using MathCore.FemCalculator;

namespace Infrastructure;

public class FemClient : IFemCalculator
{
    public Task CalculateAsync(FemModel model)
    {
        throw new NotImplementedException();
    }
}