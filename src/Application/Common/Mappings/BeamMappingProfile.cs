using Application.WoodenConstruction.Queries.GetBeamFull;
using AutoMapper;
using Core.Entities;
using HDS.Core.Beam.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
