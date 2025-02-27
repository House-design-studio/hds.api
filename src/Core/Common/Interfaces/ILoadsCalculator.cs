using MathCore.FemCalculator;
using MathCore.FemCalculator.Model;

namespace Core.Common.Interfaces;

public interface ILoadsCalculator<in TObj>
    where TObj : ILoadable, IPhysicMechanicalCharacteristic, IGeometricCharacteristic
{
    IEnumerable<SegmentDisplacementMaximum> GetSegmentDisplacementMaximums(TObj model, FemModel fem);
    /// <summary>
    /// Расчёт поперечной силы и касательного напряжения в расчётном сечении
    /// </summary>
    /// <returns>Максимум силы</returns>
    ForceMaximum GetForceMaximum(TObj model, FemModel fem);
    
    SupportReaction[] GetSupportReactions(TObj model, FemModel fem);
}
public record SegmentDisplacementMaximum(Node Node, double AbsoluteValue, double RelativeValue);
/// <summary>
/// Максимум силы
/// </summary>
/// <param name="Moment">My. Максимальный момент</param>
/// <param name="MomentOffset">Смещение максимального момента</param>
/// <param name="NormalStress">σ. Нормальное напряжение в расчётном сечении</param>
/// <param name="NormalStressLoadingCoefficient">σ / Rи. Коэффициент перегрузки</param>
/// <param name="TransverseForce">Q. Максимальная поперечная сила</param>
/// <param name="TransverseForceOffset">Смещение максимальной поперечной силы</param>
/// <param name="TangentialStress">τ. ((Q*Sy)/Iy*bрас) Касательное напряжение в расчётном сечении</param>
/// <param name="TangentialStressLoadingCoefficient">τ / Rск. Коэффициент использования</param>
public record ForceMaximum(
    double Moment,
    double MomentOffset,
    double NormalStress,
    double NormalStressLoadingCoefficient,
    double TransverseForce, 
    double TransverseForceOffset, 
    double TangentialStress, 
    double TangentialStressLoadingCoefficient);

public record struct SupportReaction(double Force, double Weight);