using HDS.MathCore.FemCalculator;

namespace HDS.MathCore.Common.Interfaces
{
    public interface IFemCalculator
    {
        Task CalculateAsync(FemModel model);
    }
}
