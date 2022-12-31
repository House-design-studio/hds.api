using Application.WoodenConstruction.Queries.GetBeamFull;
using AutoMapper;
using Core.Entities;
using HDS.Core.Beam.Entities;

namespace Application.Common.Mappings
{
    public class BeamMappingProfile : Profile
    {
        public BeamMappingProfile()
        {
            CreateMap<GetBeamFullQuery, Beam>();
            CreateMap<Beam, FullReport>();
        }
    }
}
