using HDS.BusinessLogic.Beam.Entities;
using HDS.BusinessLogic.Interfaces;
using HDS.Models;
using Microsoft.AspNetCore.Mvc;

namespace HDS.Controllers
{
    [Route("/{controller}/pro/{action=Index}")]
    public class BeamController : Controller
    {
        private readonly ILogger<BeamController> _logger;
        private readonly IBeamCalculator _beamCalculator;

        public BeamController(ILogger<BeamController> logger, IBeamCalculator beamCalculator)
        {
            _logger = logger;
            _beamCalculator = beamCalculator;
        }

        [HttpGet]
        public IActionResult Index()
        {
            // try to load 
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> IndexAsync(BeamInputStringModel input)
        {
            BeamInput beamModel;
            try
            {
                beamModel = input.Parse(_beamCalculator.GetBeamInputBuilder());
            }
            catch
            {
                return Redirect("/Beam/pro/Index"); //TODO: добавить параметр строки ?alert=message и скрипт на js который при загрузке его обработает
            }

            var output = await _beamCalculator.GetFullReportAsync(beamModel);
            _logger.LogTrace($"New calculation : {output}, \n {beamModel.ToString()}");

            return View("Calculate", output);
        }
    }
}