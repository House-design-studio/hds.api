using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers
{
    [ApiController]
    [Route("api/[controller]/pro/[action]")]
    public class BeamController : ControllerBase
    {
        private readonly ILogger<BeamController> _logger;

        public BeamController(ILogger<BeamController> logger)
        {
            _logger = logger;
        }

        [HttpPost]
        public IActionResult FullCalculate(bool tryCode)
        {
            if (tryCode)
            {
                return Ok();
            }
            else
            {
                return BadRequest();
            }

        }
    }
}