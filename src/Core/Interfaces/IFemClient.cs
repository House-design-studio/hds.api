namespace HDS.Core.Interfaces
{
    public interface IFemClient
    {
        public Task<FemClientResponse?> DoRequest(FemClientRequest request);
    }
}
