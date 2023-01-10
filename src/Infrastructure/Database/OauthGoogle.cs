namespace Infrastructure.Database;

public class OauthGoogle
{
    public string Subject { get; set; } = null!;
    public int UserId { get; set; }

    public virtual User User { get; set; } = null!;
}