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


        public string[] NormativeValue { get; set; }
        public string[] NormativeValueumUM { get; set; }
        public string[] LoadAreaWidth { get; set; }
        public string[] ReliabilityCoefficient { get; set; }
        public string[] ReducingFactor { get; set; }

        public string[] LoadForFirstGroup { get; set; }
        public string[] LoadForSecondGroup { get; set; }


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
            for (int i = 0; i <= LoadForFirstGroup?.Length; i++)
            {
                builder.AddNormativeEvenlyDistributedLoad(
                    Int32.Parse(LoadForFirstGroup[i]),
                    Int32.Parse(LoadForSecondGroup[i]));
            }

            if (DryWood == "on") builder.SetDryWood(true);
            if (FlameRetardants == "on") builder.SetFlameRetardant(true);

            if (NormativeValue != null)
            {
                int loadAreaIterator = 0;

                for (int i = 0; i < NormativeValue.Length; i++)
                {
                    var tmp1 = NormativeValue[i].Replace('.', ',');
                    var normativValue = Double.Parse(tmp1);

                    var tmp2 = ReliabilityCoefficient[i].Replace('.', ',');
                    var reliabilityCoefficient = double.Parse(tmp2);

                    var tmp3 = ReducingFactor[i].Replace('.', ',');
                    var reducingFactor = double.Parse(tmp3);

                    if (NormativeValueumUM[i] == "kgm")
                    {
                        builder.AddNormativeEvenlyDistributedLoad(normativValue, reliabilityCoefficient, reducingFactor);
                    }
                    else //kgm^2
                    {
                        builder.AddNormativeEvenlyDistributedLoad(
                            normativValue,
                            Double.Parse(LoadAreaWidth[loadAreaIterator]) * 0.001,
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
