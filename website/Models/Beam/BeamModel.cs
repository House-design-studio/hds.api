namespace website.Models
{
    public class BeamModel
    {
        public Matireals Material { get; private set; }
        
        public bool DryWood { get; private set; }
        public bool FlameRetardants { get; private set; }

        public int Width { get; private set; }
        public int Height { get; private set; }
        public int Length { get; private set; }

        public int Amount { get; private set; }

        public Exploitations Exploitation { get; private set; }

        public int LifeTime { get; private set; }

        public LoadingModes LoadingMode { get; private set; }

        public int[] Supports { get; private set;}


        public enum LoadingModes
        {
            a,
            b,
            v,
            g,
            d,
            e,
            j,
            z,
            k,
            l,
            m
        }

        public enum Exploitations
        {
            class_1a,
            class_1b,
            class_2,
            class_3,
            class_4a,
            class_4b
        }

        public enum Matireals
        {
            plank_k16,
            plank_k24,
            plank_k26,
            lvl_k35,
            lvl_k40,
            lvl_k45
        }

        public BeamModel(string material,
                         string? dryWood,
                         string? flameRetardants,
                         string width,
                         string height,
                         string length,
                         string amount,
                         string exploitation,
                         string lifeTime,
                         string loadingMode,
                         string[] supports)
        {   
            try
            {
                this.Material = Enum.Parse<Matireals>(material);

                if (String.IsNullOrEmpty(dryWood))
                {
                    this.DryWood = false;
                }
                else if(dryWood == "on")
                {
                    this.DryWood = true;
                }

                if (String.IsNullOrEmpty(flameRetardants))
                {
                    this.FlameRetardants = false;
                }
                else if (flameRetardants == "on")
                {
                    this.FlameRetardants = true;
                }

                this.Width = Int32.Parse(width);
                this.Height = Int32.Parse(height);
                this.Length = Int32.Parse(length);

                this.Amount = Int32.Parse(amount);

                this.Exploitation = Enum.Parse<Exploitations>(exploitation);

                if(Int32.Parse(lifeTime) < 0)
                {
                    throw new ArgumentException("life time < 0 ");
                }
                this.LifeTime = Int32.Parse(lifeTime);
                
                this.LoadingMode = Enum.Parse<LoadingModes>(loadingMode);


                this.Supports = new int[supports.Length];
                for(int i = 0; i < supports.Length; i++)
                {
                    this.Supports[i] = Int32.Parse(supports[i]);
                }
            }
            catch
            {
                throw new ArgumentException("wrong Beam Model init arguments");
            }
        }

        public override string ToString()
        {

            string supports = "\t";

            foreach (var s in this.Supports)
            {
                supports = $"{supports} \n\t {s}";
            }

            return 
                $" Material: {Material} \n " +
                $" Dry_wood: {DryWood} \n " +
                $" FlameRetardants: {FlameRetardants} \n " +
                $" Width: {Width} \n " +
                $" Height: {Height} \n " +
                $" Length: {Length} \n " +
                $" Amount: {Amount} \n " +
                $" Exploitation: {Exploitation} \n" +
                $" LoadingMode: {LoadingMode} \n" +
                $" Supports: {supports}";
        }
    }
}
