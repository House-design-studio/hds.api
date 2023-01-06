using HDS.Application.WoodenConstruction.Queries.GetBeamFull;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace HDS.Server.Controllers
{
    [ApiController]
    [Route("api/beam")]
    public class BeamController : Controller
    {
        private readonly IMediator _mediator;
        public BeamController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet("full_report")]
        public async Task<FullBeamVM> IndexAsync(
            [FromBody] GetBeamFullQuery query)
            => await _mediator.Send(query);
    }
}