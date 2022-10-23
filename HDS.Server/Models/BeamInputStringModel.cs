using HDS.Core;
using HDS.Core.Beam.Entities;

namespace HDS.Server.Models
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


        public string[] DOffsetStart { get; set; }
        public string[] DOffsetEnd { get; set; }
        public string[] DNormativeValue { get; set; }
        public string[] DNormativeValueumUm { get; set; }
        public string[] DLoadAreaWidth { get; set; }
        public string[] DReliabilityCoefficient { get; set; }
        public string[] DReducingFactor { get; set; }

        public string[] DLoadForFirstGroup { get; set; }
        public string[] DLoadForSecondGroup { get; set; }

        public string[] COffset { get; set; }
        public string[] CNormativeValue { get; set; }
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

            if (DryWood == "on") builder.SetDryWood(true);
            if (FlameRetardants == "on") builder.SetFlameRetardant(true);

            if (DNormativeValue is not null)
            {
                int loadAreaIterator = 0;

                for (int i = 0; i < DNormativeValue.Length; i++)
                {
                    var normativValue = Double.Parse(DNormativeValue[i].Replace('.', ','));
                    var reliabilityCoefficient = Double.Parse(DReliabilityCoefficient[i].Replace('.', ','));
                    var reducingFactor = Double.Parse(DReducingFactor[i].Replace('.', ','));

                    if (DNormativeValueumUm[i] == "kgm")
                    {
                        builder.AddDistributedLoad(
                            Int32.Parse(DOffsetStart[i]) * 0.001,
                            Int32.Parse(DOffsetEnd[i]) * 0.001,
                            normativValue,
                            reliabilityCoefficient,
                            reducingFactor);
                    }
                    else //kgm^2
                    {
                        builder.AddDistributedLoad(
                            Int32.Parse(DOffsetStart[i]) * 0.001,
                            Int32.Parse(DOffsetEnd[i]) * 0.001,
                            normativValue,
                            Int32.Parse(DLoadAreaWidth[loadAreaIterator]) * 0.001,
                            reliabilityCoefficient,
                            reducingFactor);

                        loadAreaIterator++;
                    }
                }
            }

            int offsetsV2 = DNormativeValue?.Length ?? 0;

            for (int i = 0; i < DLoadForFirstGroup?.Length; i++)
            {
                var loadForFirstGroup = Double.Parse(DLoadForFirstGroup[i].Replace('.', ','));
                var loadForSecondGroup = Double.Parse(DLoadForSecondGroup[i].Replace('.', ','));

                builder.AddDistributedLoad(
                    Int32.Parse(DOffsetStart[i + offsetsV2]) * 0.001,
                    Int32.Parse(DOffsetEnd[i + offsetsV2]) * 0.001,
                    loadForFirstGroup,
                    loadForSecondGroup);
            }

            if (CNormativeValue is not null)
            {
                for (int i = 0; i < CNormativeValue.Length; i++)
                {
                    var normativValue = Double.Parse(CNormativeValue[i].Replace('.', ','));
                    var reliabilityCoefficient = Double.Parse(CReliabilityCoefficient[i].Replace('.', ','));
                    var reducingFactor = Double.Parse(CReducingFactor[i].Replace('.', ','));

                    builder.AddСoncentratedLoad(
                        Int32.Parse(COffset[i]) * 0.001,
                        normativValue,
                        reliabilityCoefficient,
                        reducingFactor);
                }
            }

            offsetsV2 = CNormativeValue?.Length ?? 0;

            for (int i = 0; i < CLoadForFirstGroup?.Length; i++)
            {
                var loadForFirstGroup = Double.Parse(CLoadForFirstGroup[i].Replace('.', ','));
                var loadForSecondGroup = Double.Parse(CLoadForSecondGroup[i].Replace('.', ','));
                builder.AddСoncentratedLoad(
                    Int32.Parse(COffset[i + offsetsV2]) * 0.001,
                    loadForFirstGroup,
                    loadForSecondGroup);
            }
            return builder.Build();
        }
    }
}
