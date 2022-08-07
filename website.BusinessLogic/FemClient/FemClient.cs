using HDS.BusinessLogic.Interfaces;

namespace HDS.BusinessLogic.FemClient
{
    public class FemClient : IFemClient
    {
        private FemClientRequest _request = new();
        private FemClientResponse _response = new();

        private readonly HttpClient _httpClient;

        public FemClient(HttpClient httpClient)
        {
            _httpClient = httpClient ?? throw new ArgumentNullException(nameof(httpClient));
        }


    }
}
