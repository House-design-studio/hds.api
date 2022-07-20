using website.BusinessLogic.Beam;

namespace website.BusinessLogic.Beam
{
    public class FullReport
    {
        public Input Input { get; set; }
        
        public double ShrinkageInWidth { get; set; }
        public double ShrinkageInHeight { get; set; }

        public double EstimatedWidth { get; set; }
        public double EstimatedHeight { get; set; }

        public FullReport(Input input)
        {
            this.Input = input;
            
            this.ShrinkageInWidth = Shrinkage.GetShrinkage(input.Width);
            this.ShrinkageInHeight = Shrinkage.GetShrinkage(input.Height);

            this.EstimatedWidth = Input.Width - this.ShrinkageInWidth;
            this.EstimatedHeight = Input.Height - this.ShrinkageInHeight;
        }
    }
}
