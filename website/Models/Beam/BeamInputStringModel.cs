using System.ComponentModel.DataAnnotations;

namespace website.Models
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

        public BeamInputModel Parse()
        {
            bool dryWood;
            bool flameRetardants;
            int[] supports = new int[Supports.Length];

            List<BeamInputModel.NormativeEvenlyDistributedLoadV1>? normativeEvenlyDistributedLoadsV1;
            List<BeamInputModel.NormativeEvenlyDistributedLoadV2>? normativeEvenlyDistributedLoadsV2;

            if (this.NormativeValue != null)
            {
                normativeEvenlyDistributedLoadsV1 = new List<BeamInputModel.NormativeEvenlyDistributedLoadV1>();
                int loadAreaIterator = 0;

                for (int i = 0; i < NormativeValue.Length; i++)
                {
                    var normativValue = Int32.Parse(this.NormativeValue[i]);
                    var normativValueUM = Enum.Parse<BeamInputModel.UnitsOfMeasurement>(this.NormativeValueumUM[i]);
                    var reliabilityCoefficient = Int32.Parse(this.ReliabilityCoefficient[i]);
                    var reducingFactor = Int32.Parse(this.ReducingFactor[i]);
                    int? loadAreaWidth;

                    if (normativValueUM == BeamInputModel.UnitsOfMeasurement.kgm)
                    {
                        loadAreaWidth = null;
                    }
                    else if(normativValueUM == BeamInputModel.UnitsOfMeasurement.kgm2)
                    {
                        loadAreaWidth = Int32.Parse(this.LoadAreaWidth[loadAreaIterator]);
                        loadAreaIterator++;
                    }
                    else
                    {
                        throw new ArgumentException("bad unit of measurement");
                    }
                    normativeEvenlyDistributedLoadsV1.Add(
                        new BeamInputModel.NormativeEvenlyDistributedLoadV1(
                            normativValue,
                            normativValueUM,
                            loadAreaWidth,
                            reliabilityCoefficient,
                            reducingFactor));
                }
            }
            else
            {
                normativeEvenlyDistributedLoadsV1 = null;
            }


            
            if (this.LoadForFirstGroup != null)
            {
                normativeEvenlyDistributedLoadsV2 = new List<BeamInputModel.NormativeEvenlyDistributedLoadV2>();

                for (int i = 0; i < LoadForFirstGroup.Length; i++)
                {
                    normativeEvenlyDistributedLoadsV2.Add(
                        new BeamInputModel.NormativeEvenlyDistributedLoadV2(
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



            return new BeamInputModel(
                Enum.Parse<BeamInputModel.Matireals>(this.Material),
                dryWood,
                flameRetardants,
                Int32.Parse(this.Width),
                Int32.Parse(this.Height),
                Int32.Parse(this.Length),
                Int32.Parse(this.Amount),
                Enum.Parse<BeamInputModel.Exploitations>(this.Exploitation),
                Int32.Parse(this.LifeTime),
                Enum.Parse<BeamInputModel.LoadingModes>(this.LoadingMode),
                supports,
                normativeEvenlyDistributedLoadsV1,
                normativeEvenlyDistributedLoadsV2
                );

        }
    }
}
