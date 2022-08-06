using static HDS.BusinessLogic.Data;

namespace HDS.BusinessLogic.Beam.Entities
{
    public class BeamInputBuilder
    {
        private BeamInput result = new();

        public BeamInput Build()
        {
            if (result.Supports.Count < 2) throw new Exception("num of supports < 2");
            if (result.Width == 0) throw new Exception("sizes not entered");

            foreach(var load in result.DistributedLoads)
            {
                if (load.OffsetEnd > result.Length) throw new Exception("load out of beam");
            }
            foreach(var load in result.ConcentratedLoads)
            {
                if (load.Offset > result.Length) throw new Exception("load out of beam");
            }
            return result;
        }

        public void SetMaterial(BeamMatireals material)
        {
            result.Material = material;
        }
        public void SetDryWood(bool dryWood)
        {
            result.DryWood = dryWood;
        }
        public void SetFlameRetardant(bool flameRetardant)
        {
            result.FlameRetardants = flameRetardant;
        }
        public void SetSizes(double width, double height, double length)
        {
            result.Width = width > 0 ? width : throw new ArgumentException($"{nameof(width)} <= 0", nameof(width));
            result.Height = height > 0 ? height : throw new ArgumentException($"{nameof(height)} <= 0", nameof(height));
            result.Length = length > 0 ? length : throw new ArgumentException($"{nameof(length)} <= 0", nameof(length));
        }
        public void SetAmount(int amount)
        {
            result.Amount = amount > 0 ? amount : throw new ArgumentException($"{nameof(amount)} <= 0", nameof(amount));
        }
        public void SetExploitation(Exploitations exploitation)
        {
            result.Exploitation = exploitation;
        }
        public void SetLoadingMode(LoadingModes loadingMode)
        {
            result.LoadingMode = loadingMode;
        }
        public void AddSupport(double offset)
        {
            result.Supports.Add(offset >= 0 ? offset : throw new ArgumentException($"{nameof(offset)} <= 0", nameof(offset)));
        }
        public void SetLifetime(int lifeTime)
        {
            result.LifeTime = lifeTime >= 0 ? lifeTime : throw new ArgumentException($"{nameof(lifeTime)} < 0", nameof(lifeTime));
        }
        public void AddDistributedLoad(double offsetStart, double offsetEnd, double normativeValue, double loadAreaWidth, double reliabilityCoefficient, double reducingFactor)
        {
            if (offsetStart < 0) throw new ArgumentException($"{nameof(offsetStart)} < 0", nameof(offsetStart));
            if (offsetEnd < 0) throw new ArgumentException($"{nameof(offsetEnd)} < 0", nameof(offsetEnd));
            if (normativeValue <= 0) throw new ArgumentException($"{nameof(normativeValue)} <= 0", nameof(normativeValue));
            if (loadAreaWidth <= 0) throw new ArgumentException($"{nameof(loadAreaWidth)} <= 0", nameof(loadAreaWidth));
            if (reliabilityCoefficient <= 0) throw new ArgumentException($"{nameof(reliabilityCoefficient)} <= 0", nameof(reliabilityCoefficient));
            if (reducingFactor <= 0) throw new ArgumentException($"{nameof(reducingFactor)} <= 0", nameof(reducingFactor));

            double firstLoad = reliabilityCoefficient * normativeValue * loadAreaWidth;
            double secondLoad = reducingFactor * normativeValue * loadAreaWidth;

            var load = new BeamInput.DistributedLoad(offsetStart, offsetEnd, firstLoad, secondLoad);
            result.DistributedLoads.Add(load);
        }
        public void AddDistributedLoad(double offsetStart, double offsetEnd, double normativeValue, double reliabilityCoefficient, double reducingFactor)
        {
            if (offsetStart < 0) throw new ArgumentException($"{nameof(offsetStart)} < 0", nameof(offsetStart));
            if (offsetEnd < 0) throw new ArgumentException($"{nameof(offsetEnd)} < 0", nameof(offsetEnd));
            if (normativeValue <= 0) throw new ArgumentException($"{nameof(normativeValue)} <= 0", nameof(normativeValue));
            if (reliabilityCoefficient <= 0) throw new ArgumentException($"{nameof(reliabilityCoefficient)} <= 0", nameof(reliabilityCoefficient));
            if (reducingFactor <= 0) throw new ArgumentException($"{nameof(reducingFactor)} <= 0", nameof(reducingFactor));

            double firstLoad = reliabilityCoefficient * normativeValue;
            double secondLoad = reducingFactor * normativeValue;

            var load = new BeamInput.DistributedLoad(offsetStart, offsetEnd, firstLoad, secondLoad);
            result.DistributedLoads.Add(load);
        }
        public void AddDistributedLoad(double offsetStart, double offsetEnd, double loadForFirstGroup, double loadForSecondGroup)
        {
            if (offsetStart < 0) throw new ArgumentException($"{nameof(offsetStart)} < 0", nameof(offsetStart));
            if (offsetEnd < 0) throw new ArgumentException($"{nameof(offsetEnd)} < 0", nameof(offsetEnd));

            var load = new BeamInput.DistributedLoad(
                offsetStart,
                offsetEnd,
                loadForFirstGroup > 0 ? loadForFirstGroup : throw new ArgumentException($"{nameof(loadForFirstGroup)} <= 0", nameof(loadForFirstGroup)),
                loadForSecondGroup > 0 ? loadForSecondGroup : throw new ArgumentException($"{nameof(loadForSecondGroup)} <= 0", nameof(loadForSecondGroup)));

            result.DistributedLoads.Add(load);
        }

        public void AddСoncentratedLoad(double offset, double normativeValue, double reliabilityCoefficient, double reducingFactor)
        {
            if (offset < 0) throw new ArgumentException($"{nameof(offset)} < 0", nameof(offset));
            if (normativeValue <= 0) throw new ArgumentException($"{nameof(normativeValue)} <= 0", nameof(normativeValue));
            if (reliabilityCoefficient <= 0) throw new ArgumentException($"{nameof(reliabilityCoefficient)} <= 0", nameof(reliabilityCoefficient));
            if (reducingFactor <= 0) throw new ArgumentException($"{nameof(reducingFactor)} <= 0", nameof(reducingFactor));

            double firstLoad = reliabilityCoefficient * normativeValue;
            double secondLoad = reducingFactor * normativeValue;

            var load = new BeamInput.ConcentratedLoad(offset, firstLoad, secondLoad);
            result.ConcentratedLoads.Add(load);
        }

        public void AddСoncentratedLoad(double offset, double loadForFirstGroup, double loadForSecondGroup)
        {
            if (offset < 0) throw new ArgumentException($"{nameof(offset)} < 0", nameof(offset));

            var load = new BeamInput.ConcentratedLoad(
                offset,
                loadForFirstGroup > 0 ? loadForFirstGroup : throw new ArgumentException($"{nameof(loadForFirstGroup)} <= 0", nameof(loadForFirstGroup)),
                loadForSecondGroup > 0 ? loadForSecondGroup : throw new ArgumentException($"{nameof(loadForSecondGroup)} <= 0", nameof(loadForSecondGroup)));

            result.ConcentratedLoads.Add(load);
        }
    }
}
