using HDS.BusinessLogic;
using HDS.BusinessLogic.Beam.Entities;

namespace HDS.Models
{
    public class BeamInputStringModel
    {
#pragma warning disable CS8618 // Поле, не допускающее значения NULL, должно содержать значение, отличное от NULL, при выходе из конструктора. Возможно, стоит объявить поле как допускающее значения NULL.
        public string Material { get; set; }

        public string? DryWood { get; set; }
        public string? FlameRetardants { get; set; }

        public string Width { get; set; }
        public string Height { get; set; }
        public string Length { get; set; }

        public string Amount { get; set; }

        public string Exploitation { get; set; }

        public string LifeTime { get; set; }

        public string LoadingMode { get; set; }

        public string[] Supports { get; set; }


        public string[] DNormativeValue { get; set; }
        public string[] DNormativeValueumUM { get; set; }
        public string[] DLoadAreaWidth { get; set; }
        public string[] DReliabilityCoefficient { get; set; }
        public string[] DReducingFactor { get; set; }

        public string[] DLoadForFirstGroup { get; set; }
        public string[] DLoadForSecondGroup { get; set; }

        public string[] CNormativeValue { get; set; }
        public string[] CNormativeValueumUM { get; set; }
        public string[] CLoadAreaWidth { get; set; }
        public string[] CReliabilityCoefficient { get; set; }
        public string[] CReducingFactor { get; set; }

        public string[] CLoadForFirstGroup { get; set; }
        public string[] CLoadForSecondGroup { get; set; }


#pragma warning restore CS8618 // Поле, не допускающее значения NULL, должно содержать значение, отличное от NULL, при выходе из конструктора. Возможно, стоит объявить поле как допускающее значения NULL.
        public BeamInput Parse(BeamInputBuilder builder)
        {
            builder.SetMaterial(Enum.Parse<Data.BeamMatireals>(Material));
            builder.SetSizes(Int32.Parse(Width) * 0.001,
                             Int32.Parse(Height) * 0.001,
                             Int32.Parse(Length) * 0.001);

            builder.SetAmount(Int32.Parse(Amount));
            builder.SetExploitation(Enum.Parse<Data.Exploitations>(Exploitation));

            builder.SetLifetime(Int32.Parse(LifeTime));
            builder.SetLoadingMode(Enum.Parse<Data.LoadingModes>(LoadingMode));

            foreach (var support in Supports)
            {
                builder.AddSupport(Int32.Parse(support) * 0.001);
            }

            for (int i = 0; i < DLoadForFirstGroup?.Length; i++)
            {
                builder.AddNormativeEvenlyDistributedLoad(
                    Int32.Parse(DLoadForFirstGroup[i]),
                    Int32.Parse(DLoadForSecondGroup[i]));
            }

            if (DryWood == "on") builder.SetDryWood(true);
            if (FlameRetardants == "on") builder.SetFlameRetardant(true);

            if (DNormativeValue != null)
            {
                int loadAreaIterator = 0;

                for (int i = 0; i < DNormativeValue.Length; i++)
                {
                    var tmp1 = DNormativeValue[i].Replace('.', ',');
                    var normativValue = Double.Parse(tmp1);

                    var tmp2 = DReliabilityCoefficient[i].Replace('.', ',');
                    var reliabilityCoefficient = double.Parse(tmp2);

                    var tmp3 = DReducingFactor[i].Replace('.', ',');
                    var reducingFactor = double.Parse(tmp3);

                    if (DNormativeValueumUM[i] == "kgm")
                    {
                        builder.AddNormativeEvenlyDistributedLoad(normativValue, reliabilityCoefficient, reducingFactor);
                    }
                    else //kgm^2
                    {
                        builder.AddNormativeEvenlyDistributedLoad(
                            normativValue,
                            Double.Parse(DLoadAreaWidth[loadAreaIterator]) * 0.001,
                            reliabilityCoefficient,
                            reducingFactor);

                        loadAreaIterator++;
                    }
                }
            }

            return builder.Build();

        }
    }
}
