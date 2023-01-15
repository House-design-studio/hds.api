using MathCore.FemCalculator;

namespace MathCore.Common.Interfaces;

public interface IFemCalculator
{
    Task CalculateAsync(FemModel model);
}