using MathCore.FemCalculator;

namespace MathCore.Common.Interfaces
{
    public interface IFemCalculator
    {
        public Task CalculateAsync(FemModel model);
    }
}
