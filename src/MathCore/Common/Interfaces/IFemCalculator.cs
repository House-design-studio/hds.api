using MathCore.FemCalculator;

namespace MathCore.Common.Interfaces
{
    public interface IFemCalculator
    {
        public void Calc(FemModel model);
    }
}
