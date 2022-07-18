using System.ComponentModel.DataAnnotations;

namespace website.Models
{
    public class BeamInputModel
    {
        [Required]
#pragma warning disable CS8618 // Поле, не допускающее значения NULL, должно содержать значение, отличное от NULL, при выходе из конструктора. Возможно, стоит объявить поле как допускающее значения NULL.
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

        [Required]
        public string LoadingMode { get; set; }

        [Required]
        public string[] Supports { get; set; }
#pragma warning restore CS8618 // Поле, не допускающее значения NULL, должно содержать значение, отличное от NULL, при выходе из конструктора. Возможно, стоит объявить поле как допускающее значения NULL.

        public BeamModel GetBeamModel()
        {
            return new BeamModel(Material, DryWood, FlameRetardants, Width, Height, Length, Amount, Exploitation, LifeTime, LoadingMode, Supports);
        }

        public override string ToString()
        {
            return 
                $" Material: {Material} \n" +
                $" DryWood: {DryWood} \n" +
                $" FlameRetardants: {FlameRetardants} \n" +
                $" Width: {Width} \n" +
                $" Height: {Height} \n" +
                $" Length: {Length} \n" +
                $" Amount: {Amount} \n" +
                $" Exploitation: {Exploitation} \n" +
                $" LifeTime : {LifeTime} \n" +
                $" LoadingMode : {LoadingMode}";
        }
    }
}
