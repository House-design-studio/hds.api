using System.ComponentModel.DataAnnotations;

namespace website.Models
{
    public class BeamInputModel
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
        public string[] LoadAreaWidth { get; set; }
        public string[] ReliabilityCoefficient { get; set; }
        public string[] ReducingFactor { get; set; }

        public string[] LoadForFirstGroup { get; set; }
        public string[] LoadForSecondGroup { get; set; }


#pragma warning restore CS8618 // Поле, не допускающее значения NULL, должно содержать значение, отличное от NULL, при выходе из конструктора. Возможно, стоит объявить поле как допускающее значения NULL.

        public BeamModel GetBeamModel()
        {
            bool dryWood;
            bool flameRetardants;
            int[] supports = new int[Supports.Length];

            List<BeamModel.NormativeEvenlyDistributedLoadV1>? normativeEvenlyDistributedLoadsV1;
            List<BeamModel.NormativeEvenlyDistributedLoadV2>? normativeEvenlyDistributedLoadsV2;

            if (this.NormativeValue != null)
            {
                normativeEvenlyDistributedLoadsV1 = new List<BeamModel.NormativeEvenlyDistributedLoadV1>();

                for (int i = 0; i < NormativeValue.Length; i++)
                {
                    normativeEvenlyDistributedLoadsV1.Add(
                        new BeamModel.NormativeEvenlyDistributedLoadV1(
                            Int32.Parse(this.NormativeValue[i]),
                            Int32.Parse(this.LoadAreaWidth[i]),
                            Int32.Parse(this.ReliabilityCoefficient[i]),
                            Int32.Parse(this.ReducingFactor[i])));
                }
            }
            else
            {
                normativeEvenlyDistributedLoadsV1 = null;
            }


            
            if (this.LoadForFirstGroup != null)
            {
                normativeEvenlyDistributedLoadsV2 = new List<BeamModel.NormativeEvenlyDistributedLoadV2>();

                for (int i = 0; i < LoadForFirstGroup.Length; i++)
                {
                    normativeEvenlyDistributedLoadsV2.Add(
                        new BeamModel.NormativeEvenlyDistributedLoadV2(
                            Int32.Parse(this.LoadForFirstGroup[i]),
                            Int32.Parse(this.LoadForSecondGroup[i])));
                }
            }
            else
            {
                normativeEvenlyDistributedLoadsV2 = null;
            }

            if (String.IsNullOrEmpty(this.DryWood))
            {
                dryWood = false;
            }else if(this.DryWood == "on")
            {
                dryWood = true;
            }
            else
            {
                throw new ArgumentException("bad dry wood input");
            }

            if (String.IsNullOrEmpty(this.FlameRetardants))
            {
                flameRetardants = false;
            }
            else if (this.FlameRetardants == "on")
            {
                flameRetardants = true;
            }
            else
            {
                throw new ArgumentException("bad flame retardants input");
            }

            for(int i = 0; i < this.Supports.Length; i++)
            {
                supports[i] = Int32.Parse(this.Supports[i]);
            }



            return new BeamModel(
                Enum.Parse<BeamModel.Matireals>(this.Material),
                dryWood,
                flameRetardants,
                Int32.Parse(this.Width),
                Int32.Parse(this.Height),
                Int32.Parse(this.Length),
                Int32.Parse(this.Amount),
                Enum.Parse<BeamModel.Exploitations>(this.Exploitation),
                Int32.Parse(this.LifeTime),
                Enum.Parse<BeamModel.LoadingModes>(this.LoadingMode),
                supports,
                normativeEvenlyDistributedLoadsV1,
                normativeEvenlyDistributedLoadsV2
                );

        }
    }
}
