using System.Text;
using HDS.BusinessLogic.Interfaces;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;

namespace HDS.BusinessLogic.FemClient
{
    public class FemClient : IFemClient
    {
        private readonly HttpClient _httpClient;
        private readonly string _femServerIp;
        public FemClient(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient;
            _femServerIp = configuration["Api:FemServer"];
            
        }
        
        public async Task<FemClientResponse?> DoRequest(FemClientRequest request)
        {
            var json = request.ToJson();
            var httpContent = new StringContent(json, Encoding.UTF8, "application/json");
            var httpResponse = await _httpClient.PostAsync($"{_femServerIp}fem", httpContent);
            var responseContent = await httpResponse.Content.ReadAsStringAsync();
            FemClientResponse? response = JsonConvert.DeserializeObject<FemClientResponse?>(responseContent);
            return response;
        }
    }
}
