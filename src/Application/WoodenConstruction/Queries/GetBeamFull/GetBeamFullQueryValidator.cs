using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.WoodenConstruction.Queries.GetBeamFull
{
    public class GetBeamFullQueryValidator : AbstractValidator<GetBeamFullQuery>
    {
        public GetBeamFullQueryValidator()
        {
            RuleFor(v => v.Amount)
                .GreaterThan(0);
        }
    }
}
