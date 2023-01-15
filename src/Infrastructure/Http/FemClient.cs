using System.Net.Http.Headers;
using System.Text;
using System.Text.Json.Serialization;
using MathCore.Common.Base;
using MathCore.Common.Interfaces;
using MathCore.FemCalculator;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using JsonSerializer = System.Text.Json.JsonSerializer;

namespace Infrastructure;

public class FemClient : IFemCalculator
{
    private readonly HttpClient _httpClient;
    private readonly string _femUri;
    
    public FemClient(HttpClient httpClient, IConfigureOptions<FemClientConfig> options)
    {
        var config = new FemClientConfig();
        options.Configure(config);
        
        _httpClient = httpClient;
        _femUri = config.Connection;
    }
    public async Task CalculateAsync(FemModel model)
    {
        var request = new StringContent(MapToJson(model), Encoding.UTF8,"application/json");
        var response = await _httpClient.PostAsync(_femUri, request);
        var result = JsonConvert.DeserializeObject<FemClientResponse.Root>(
            await response.Content.ReadAsStringAsync());
        MapFromJson(result!, model);
    }

    private void MapFromJson(FemClientResponse.Root response, FemModel model)
    {
        for (var i = 0; i < model.Segments.Count(); i++)
        {
            model.Segments[i].Displacement = new Vector6D<double>()
            {
                X = response.Beams[i].Displacement.X,
                Y = response.Beams[i].Displacement.Y,
                Z = response.Beams[i].Displacement.Z,
                U = response.Beams[i].Displacement.U,
                V = response.Beams[i].Displacement.V,
                W = response.Beams[i].Displacement.W
            };
            model.Segments[i].Force = new Vector6D<double>()
            {
                X = response.Beams[i].Force.X,
                Y = response.Beams[i].Force.Y,
                Z = response.Beams[i].Force.Z,
                U = response.Beams[i].Force.U,
                V = response.Beams[i].Force.V,
                W = response.Beams[i].Force.W
            };
        }

        for (var i = 0; i < model.Nodes.Count(); i++)
        {
            model.Nodes[i].Displacement = new Vector6D<double>()
            {
                X = response.Nodes[i].Displacement.X,
                Y = response.Nodes[i].Displacement.Y,
                Z = response.Nodes[i].Displacement.Z,
                U = response.Nodes[i].Displacement.U,
                V = response.Nodes[i].Displacement.V,
                W = response.Nodes[i].Displacement.W
            };
        }
    }
    private string MapToJson(FemModel model)
    {
        return JsonConvert.SerializeObject(new FemClientRequest.Root()
        {
            Nc = model.Nodes.Count(),
            Bc = model.Segments.Count(),
            Beams = model.Segments.Select(s => new FemClientRequest.Beam()
            {
                First = new FemClientRequest.First()
                {
                    Node = s.First.Node,
                    Fixed = new FemClientRequest.Fixed()
                    {
                        X = s.First.IsFixed.X,
                        Y = s.First.IsFixed.Y,
                        Z = s.First.IsFixed.Z,
                        U = s.First.IsFixed.U,
                        V = s.First.IsFixed.V,
                        W = s.First.IsFixed.W
                    },
                    Flexible = new FemClientRequest.Flexible()
                    {
                        X = s.First.IsFlexible.X,
                        Y = s.First.IsFlexible.Y,
                        Z = s.First.IsFlexible.Z,
                        U = s.First.IsFlexible.U,
                        V = s.First.IsFlexible.V,
                        W = s.First.IsFlexible.W
                    }
                },
                Second = new FemClientRequest.Second()
                {
                    Node = s.Second.Node,
                    Fixed = new FemClientRequest.Fixed()
                    {
                        X = s.Second.IsFixed.X,
                        Y = s.Second.IsFixed.Y,
                        Z = s.Second.IsFixed.Z,
                        U = s.Second.IsFixed.U,
                        V = s.Second.IsFixed.V,
                        W = s.Second.IsFixed.W
                    },
                    Flexible = new FemClientRequest.Flexible()
                    {
                        X = s.Second.IsFlexible.X,
                        Y = s.Second.IsFlexible.Y,
                        Z = s.Second.IsFlexible.Z,
                        U = s.Second.IsFlexible.U,
                        V = s.Second.IsFlexible.V,
                        W = s.Second.IsFlexible.W
                    }
                },
                CrossSectionArea = s.CrossSectionalArea,
                MomentOfInertiaX = s.MomentOfInertiaX,
                MomentOfInertiaY = s.MomentOfInertiaY,
                MomentOfInertiaZ = s.MomentOfInertiaZ,
                ShearAreaY = s.ShearAreaY,
                ShearAreaZ = s.ShearAreaZ,
                StiffnessModulus = s.StiffnessModulus,
                ShearModulus = s.ShearModulus,
                ZDirection = new FemClientRequest.ZDirection()
                {
                    X = s.ZDirection.X,
                    Y = s.ZDirection.Y,
                    Z = s.ZDirection.Z
                }
            }),
            Nodes = model.Nodes.Select(n => new FemClientRequest.Node()
            {
                Coordinate = new FemClientRequest.Coordinate()
                {
                    X = n.Coordinate.X,
                    Y = n.Coordinate.Y,
                    Z = n.Coordinate.Z
                },
                Support = new FemClientRequest.Support()
                {
                    X = n.Support.X,
                    Y = n.Support.Y,
                    Z = n.Support.Z,
                    U = n.Support.U,
                    V = n.Support.V,
                    W = n.Support.W
                },
                Load = new FemClientRequest.Load()
                {
                    X = n.Load.X,
                    Y = n.Load.Y,
                    Z = n.Load.Z,
                    U = n.Load.U,
                    V = n.Load.V,
                    W = n.Load.W
                }
            })
        });
    }
}