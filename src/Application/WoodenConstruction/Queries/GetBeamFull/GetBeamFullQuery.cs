using AutoMapper;
using Core.Entities;
using HDS.Core;
using HDS.Core.Beam.Entities;
using MediatR;

namespace Application.WoodenConstruction.Queries.GetBeamFull
{
    public class GetBeamFullQuery : IRequest<FullReport>
    {
        public Materials Material { get; set; }
        public bool DryWood { get; set; }
        public bool FlameRetardants { get; set; }
        public double Width { get; set; }
        public double Height { get; set; }
        public double Length { get; set; }
        public int Amount { get; set; }
        public Data.Exploitations Exploitation { get; set; }
        public int LifeTime { get; set; }
        public int SteadyTemperature { get; set; }
        public Data.LoadingModes LoadingMode { get; set; }
        public IEnumerable<double> Supports { get; set; } = null!;
        public IEnumerable<DistributedLoad> DistributedLoads { get; set; } = null!;
        public IEnumerable<ConcentratedLoad> ConcentratedLoads { get; set; } = null!;
    }

    public class GetBeamFullQueryHandeler : IRequestHandler<GetBeamFullQuery, FullReport>
    {
        private readonly IMapper _mapper;
        private readonly ILoa
        public GetBeamFullQueryHandeler(IMapper mapper)
        {
            _mapper = mapper;
        }
        public async Task<FullReport> Handle(GetBeamFullQuery request, CancellationToken cancellationToken)
        {
            Beam beam = _mapper.Map<Beam>(request);
            return _mapper.Map<FullReport>(beam);
        }
    }
}
