using AutoMapper;
using HDS.Application.WoodenConstruction.Queries.GetBeamFull;
using HDS.Core.Entities;

namespace HDS.Application.Common.Mappings
{
    public class BeamMappingProfile : Profile
    {
        public BeamMappingProfile()
        {
            CreateMap<GetBeamFullQuery, Beam>();
        }
    }
}
