namespace Infrastructure.Database;

public class Sp20133302016LocalitySnowLoad
{
    public int LocalityId { get; set; }
    public double NormativeLoad { get; set; }

    public virtual Locality Locality { get; set; } = null!;
}