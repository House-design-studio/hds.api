﻿using AutoMapper;
using Core.Common.Enums;
using Core.Common.Interfaces;
using Core.Entities;
using Core.Entities.Loads;
using HDS.Core;
using HDS.Core.Beam.Entities;
using MediatR;

namespace Application.WoodenConstruction.Queries.GetBeamFull
{
    public class GetBeamFullQuery : IRequest<string>
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

    public class GetBeamFullQueryHandeler : IRequestHandler<GetBeamFullQuery, string>
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
        public async Task<string> Handle(GetBeamFullQuery request, CancellationToken cancellationToken)
        {
            Beam beam = _mapper.Map<Beam>(request);
            var tmp = _loadsCalculator.GetFirstGroupOfLimitStates(beam);
            var tmp2 = _loadsCalculator.GetSecondGroupOfLimitStates(beam);
            return "";
        }
    }
}
