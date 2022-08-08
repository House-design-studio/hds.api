using HDS.BusinessLogic.FemClient;

namespace HDS.BusinessLogic.Interfaces
{
    public interface IFemClient
    {
        public Task<FemClientResponse?> DoRequest(FemClientRequest request);
    }
}
