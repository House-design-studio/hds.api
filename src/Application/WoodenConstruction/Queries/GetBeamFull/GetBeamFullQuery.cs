using AutoMapper;
using HDS.Core.Common.Enums;
using HDS.Core.Common.Interfaces;
using HDS.Core.Entities;
using HDS.Core.Entities.Loads;
using MediatR;

namespace HDS.Application.WoodenConstruction.Queries.GetBeamFull
{
    public class GetBeamFullQuery : IRequest<FullBeamVM>
    {
        public WoodenMaterials Material { get; set; }
        public bool DryWood { get; set; }
        public bool FlameRetardants { get; set; }
        public double Width { get; set; }
        public double Height { get; set; }
        public double Length { get; set; }
        public int Amount { get; set; }
        public ExploitationsType Exploitation { get; set; }
        public int LifeTime { get; set; }
        public int SteadyTemperature { get; set; }
        public LoadingModes LoadingMode { get; set; }
        public IEnumerable<double> Supports { get; set; } = null!;
        public IEnumerable<DistributedLoad> DistributedLoads { get; set; } = null!;
        public IEnumerable<ConcentratedLoad> ConcentratedLoads { get; set; } = null!;
    }

    public class GetBeamFullQueryHandeler : IRequestHandler<GetBeamFullQuery, FullBeamVM>
    {
        private readonly IMapper _mapper;
        private readonly ILoadsCalculator<Beam> _loadsCalculator;

        public GetBeamFullQueryHandeler(
            IMapper mapper,
            ILoadsCalculator<Beam> loadsCalculator)
        {
            _mapper = mapper;
            _loadsCalculator = loadsCalculator;
        }

        public async Task<FullBeamVM> Handle(GetBeamFullQuery request, CancellationToken cancellationToken)
        {
            Beam beam = _mapper.Map<Beam>(request);
            var tmp = _loadsCalculator.GetFirstGroupOfLimitStates(beam);
            var tmp2 = _loadsCalculator.GetSecondGroupOfLimitStates(beam);
            return _mapper.Map<FullBeamVM>(beam);
        }
    }
}
