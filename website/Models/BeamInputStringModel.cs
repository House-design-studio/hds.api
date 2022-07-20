using website.BusinessLogic.Beam;

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

        public Input Parse()
        {
            bool dryWood;
            bool flameRetardants;
            int[] supports = new int[Supports.Length];

            List<Input.NormativeEvenlyDistributedLoadV1>? normativeEvenlyDistributedLoadsV1;
            List<Input.NormativeEvenlyDistributedLoadV2>? normativeEvenlyDistributedLoadsV2;

            if (NormativeValue != null)
            {
                normativeEvenlyDistributedLoadsV1 = new List<Input.NormativeEvenlyDistributedLoadV1>();
                int loadAreaIterator = 0;

                for (int i = 0; i < NormativeValue.Length; i++)
                {
                    var normativValue = int.Parse(NormativeValue[i]);
                    var normativValueUM = Enum.Parse<Input.UnitsOfMeasurement>(NormativeValueumUM[i]);

                    var tmp = ReliabilityCoefficient[i].Replace('.', ',');
                    var tmp2 = ReducingFactor[i].Replace('.', ',');
                    var reliabilityCoefficient = double.Parse(tmp);
                    var reducingFactor = double.Parse(tmp2);

                    int? loadAreaWidth;

                    if (normativValueUM == Input.UnitsOfMeasurement.kgm)
                    {
                        loadAreaWidth = null;
                    }
                    else if (normativValueUM == Input.UnitsOfMeasurement.kgm2)
                    {
                        loadAreaWidth = int.Parse(LoadAreaWidth[loadAreaIterator]);
                        loadAreaIterator++;
                    }
                    else
                    {
                        throw new ArgumentException("bad unit of measurement");
                    }
                    normativeEvenlyDistributedLoadsV1.Add(
                        new Input.NormativeEvenlyDistributedLoadV1(
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
                normativeEvenlyDistributedLoadsV2 = new List<Input.NormativeEvenlyDistributedLoadV2>();

                for (int i = 0; i < LoadForFirstGroup.Length; i++)
                {
                    normativeEvenlyDistributedLoadsV2.Add(
                        new Input.NormativeEvenlyDistributedLoadV2(
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
                supports[i] = int.Parse(Supports[i]);
            }



            return new Input(
                Enum.Parse<Input.Matireals>(Material),
                dryWood,
                flameRetardants,
                int.Parse(Width),
                int.Parse(Height),
                int.Parse(Length),
                int.Parse(Amount),
                Enum.Parse<Input.Exploitations>(Exploitation),
                int.Parse(LifeTime),
                Enum.Parse<Input.LoadingModes>(LoadingMode),
                supports,
                normativeEvenlyDistributedLoadsV1,
                normativeEvenlyDistributedLoadsV2
                );

        }
    }
}
