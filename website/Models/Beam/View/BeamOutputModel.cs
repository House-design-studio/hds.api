namespace website.Models.Beam.View
{
    public class BeamOutputModel
    {
        public BeamInputModel Input { get; init; }

        public BeamOutputModel(BeamInputModel input)
        {
            Input = input;
        }
    }
}
