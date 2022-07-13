using System.ComponentModel.DataAnnotations;

namespace website.Models
{
    public class BeamInputModel
    {
        [Required]
        public string Material { get; set; }

        public string? DryWood { get; set; }
        public string? FlameRetardants { get; set; }

        [Required]
        public string Width { get; set; }
        [Required]
        public string Height { get; set; }
        [Required]
        public string Length { get; set; }

        [Required]
        public string Amount { get; set; }

        [Required]
        public string Exploitation { get; set; }

        [Required]
        public string LifeTime { get; set; }

        public BeamModel GetBeamModel()
        {
            return new BeamModel(Material, DryWood, FlameRetardants, Width, Height, Length, Amount, Exploitation, LifeTime);
        }

        public override string ToString()
        {
            return 
                $" Material: {Material} \n" +
                $" Dry_wood: {DryWood} \n" +
                $" Flame_retardants: {FlameRetardants} \n" +
                $" Width: {Width} \n" +
                $" Height: {Height} \n" +
                $" Length: {Length} \n" +
                $" Amount: {Amount} \n" +
                $" Exploitation: {Exploitation} \n" +
                $" LifeTime : {LifeTime} \n";
        }
    }
}
