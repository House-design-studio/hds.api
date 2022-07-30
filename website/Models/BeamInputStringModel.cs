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
        public BeamInput Parse()
        {
            var material = Enum.Parse<Data.BeamMatireals>(Material);
            bool dryWood;
            bool flameRetardants;

            double width = Int32.Parse(Width) * 0.001;
            double height = Int32.Parse(Height) * 0.001;
            double length = Int32.Parse(Length) * 0.001;

            int amount = Int32.Parse(Amount);

            Data.Exploitations exploitation = Enum.Parse<Data.Exploitations>(Exploitation);

            int lifeTime = Int32.Parse(LifeTime);

            Data.LoadingModes loadingMode = Enum.Parse<Data.LoadingModes>(LoadingMode);

            double[] supports = new double[Supports.Length];

            List<BeamInput.NormativeEvenlyDistributedLoadV1>? normativeEvenlyDistributedLoadsV1;
            List<BeamInput.NormativeEvenlyDistributedLoadV2>? normativeEvenlyDistributedLoadsV2;

            if (NormativeValue != null)
            {
                normativeEvenlyDistributedLoadsV1 = new List<BeamInput.NormativeEvenlyDistributedLoadV1>();
                int loadAreaIterator = 0;

                for (int i = 0; i < NormativeValue.Length; i++)
                {
                    var tmp1 = NormativeValue[i].Replace('.', ',');
                    var normativValue = Double.Parse(tmp1);

                    var normativValueUM = Enum.Parse<BeamInput.UnitsOfMeasurement>(NormativeValueumUM[i]);


                    var tmp2 = ReliabilityCoefficient[i].Replace('.', ',');
                    var reliabilityCoefficient = double.Parse(tmp2);

                    var tmp3 = ReducingFactor[i].Replace('.', ',');
                    var reducingFactor = double.Parse(tmp3);

                    double? loadAreaWidth;

                    if (normativValueUM == BeamInput.UnitsOfMeasurement.kgm)
                    {
                        loadAreaWidth = null;
                    }
                    else if (normativValueUM == BeamInput.UnitsOfMeasurement.kgm2)
                    {
                        loadAreaWidth = Double.Parse(LoadAreaWidth[loadAreaIterator]) * 0.001;
                        loadAreaIterator++;
                    }
                    else
                    {
                        throw new ArgumentException("bad unit of measurement");
                    }
                    normativeEvenlyDistributedLoadsV1.Add(
                        new BeamInput.NormativeEvenlyDistributedLoadV1(
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

            if (LoadForFirstGroup != null)
            {
                normativeEvenlyDistributedLoadsV2 = new List<BeamInput.NormativeEvenlyDistributedLoadV2>();

                for (int i = 0; i < LoadForFirstGroup.Length; i++)
                {
                    normativeEvenlyDistributedLoadsV2.Add(
                        new BeamInput.NormativeEvenlyDistributedLoadV2(
                            int.Parse(LoadForFirstGroup[i]),
                            int.Parse(LoadForSecondGroup[i])));
                }
            }
            else
            {
                normativeEvenlyDistributedLoadsV2 = null;
            }

            if (string.IsNullOrEmpty(DryWood))
            {
                dryWood = false;
            }
            else if (DryWood == "on")
            {
                dryWood = true;
            }
            else
            {
                throw new ArgumentException("bad dry wood input");
            }

            if (string.IsNullOrEmpty(FlameRetardants))
            {
                flameRetardants = false;
            }
            else if (FlameRetardants == "on")
            {
                flameRetardants = true;
            }
            else
            {
                throw new ArgumentException("bad flame retardants input");
            }

            for (int i = 0; i < Supports.Length; i++)
            {
                supports[i] = Double.Parse(Supports[i]) * 0.001;
            }



            return new BeamInput(
                material,
                dryWood,
                flameRetardants,
                width,
                height,
                length,
                amount,
                exploitation,
                lifeTime,
                loadingMode,
                supports,
                normativeEvenlyDistributedLoadsV1,
                normativeEvenlyDistributedLoadsV2
                );

        }
    }
}
