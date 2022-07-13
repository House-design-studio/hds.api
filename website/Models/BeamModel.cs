namespace website.Models
{
    public class BeamModel
    {
        public Matireals Material { get; private set; }
        
        public bool Dry_wood { get; private set; }
        public bool Flame_retardants { get; private set; }

        public int Width { get; private set; }
        public int Height { get; private set; }
        public int Length { get; private set; }

        public int Amount { get; private set; }

        public Exploitations Exploitation { get; private set; }

        public int LifeTime { get; private set; }

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

        public BeamModel(
            string material,
            string? dry_wood,
            string? flame_retardants,
            string width,
            string height,
            string length,
            string amount,
            string exploitation,
            string lifeTime)
        {   
            try
            {
                this.Material = Enum.Parse<Matireals>(material);

                if (String.IsNullOrEmpty(dry_wood))
                {
                    this.Dry_wood = false;
                }
                else if(dry_wood == "on")
                {
                    this.Dry_wood = true;
                }

                if (String.IsNullOrEmpty(flame_retardants))
                {
                    this.Flame_retardants = false;
                }
                else if (flame_retardants == "on")
                {
                    this.Flame_retardants = true;
                }

                this.Width = Int32.Parse(width);
                this.Height = Int32.Parse(height);
                this.Length = Int32.Parse(length);

                this.Amount = Int32.Parse(amount);

                this.Exploitation = Enum.Parse<Exploitations>(exploitation);

                int tmp = Int32.Parse(lifeTime);
                if(tmp < 0)
                {
                    throw new ArgumentException("life time < 0 ");
                }
                this.LifeTime = tmp;
            }
            catch
            {
                throw new ArgumentException("wrong Beam Model init arguments");
            }
        }

        public override string ToString()
        {
            return 
                $" Material: {Material.ToString()} \n " +
                $" Dry_wood: {Dry_wood.ToString()} \n " +
                $" Flame_retardants: {Flame_retardants.ToString()} \n " +
                $" Width: {Width.ToString()} \n " +
                $" Height: {Height.ToString()} \n " +
                $" Length: {Length.ToString()} \n " +
                $" Amount: {Amount.ToString()} \n " +
                $" Exploitation: {Exploitation.ToString()} \n";
        }
    }
}
