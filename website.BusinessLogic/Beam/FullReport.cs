using website.BusinessLogic.Beam;

namespace website.BusinessLogic.Beam
{
    public class FullReport
    {
        public Input Input { get; set; }
        
        public double ShrinkageInWidth { get; set; }
        public double ShrinkageInHeight { get; set; }

        public double EffectiveWidth { get; set; }
        public double EffectiveHeight { get; set; }

        public double CrossSectionArea { get; set; }

        public FullReport(Input input)
        {
            this.Input = input;
            
            this.ShrinkageInWidth = Analyze.GetShrinkage(input.Width);
            this.ShrinkageInHeight = Analyze.GetShrinkage(input.Height);

            this.EffectiveWidth = Input.Width - this.ShrinkageInWidth;
            this.EffectiveHeight = Input.Height - this.ShrinkageInHeight;

            this.CrossSectionArea = this.EffectiveWidth * this.EffectiveHeight;
        }
    }
}
