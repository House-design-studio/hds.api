using Core.Common.Interfaces;
using MathCore.Common.Base;
using MathCore.Common.Interfaces;
using MathCore.FemCalculator;
using MathCore.FemCalculator.Model;
using static Core.Helpers.Fem.FemNodeSetter;

namespace Core.Services;

public class LoadsCalculator<TObj> : ILoadsCalculator<TObj>
    where TObj : ILoadable, IPhysicMechanicalCharacteristic, IGeometricCharacteristic
{
    private readonly IFemCalculator _femCalculator;

    public LoadsCalculator(IFemCalculator femCalculator)
    {
        _femCalculator = femCalculator;
    }

    public async Task<FemModel> GetFirstGroupOfLimitStates(TObj model)
    {
        var baseDots = CreateBaseDots(model);

        var maxDots = CreateAdditionalDots(baseDots);

        maxDots.SetSupportsValues(model.Supports)
            .SetConcentratedLoadsValues(model.ConcentratedLoads
                .Select(l => (l.Offset, l.LoadForFirstGroup)))
            .SetDistributedLoadsValues(model.DistributedLoads
                .Select(l => (l.OffsetStart, l.OffsetEnd, l.LoadForFirstGroup)));

        var data = new FemModel(CreateSegments(model, maxDots.Count() - 1), maxDots);

        await _femCalculator.CalculateAsync(data);
        return data;
    }

    public async Task<FemModel> GetSecondGroupOfLimitStates(TObj model)
    {
        var baseDots = CreateBaseDots(model);

        var maxDots = CreateAdditionalDots(baseDots);

        maxDots.SetSupportsValues(model.Supports)
            .SetConcentratedLoadsValues(model.ConcentratedLoads
                .Select(l => (l.Offset, l.LoadForSecondGroup)))
            .SetDistributedLoadsValues(model.DistributedLoads
                .Select(l => (l.OffsetStart, l.OffsetEnd, l.LoadForSecondGroup)));

        var data = new FemModel(CreateSegments(model, maxDots.Count() - 1), maxDots);

        await _femCalculator.CalculateAsync(data);
        return data;
    }

    public IEnumerable<SegmentDisplacementMaximum> GetSegmentDisplacementMaximums(TObj model, FemModel fem)
    {
        var baseDots = GetSupportWithConsolesCoordinates(model);
        var maxNodes = new SegmentDisplacementMaximum[baseDots.Count - 1];
        
        for (var i = 0; i < baseDots.Count - 1; i++)
        {
            var leftDot = baseDots[i];
            var rightDot = baseDots[i + 1];
            var offset = rightDot - leftDot;

            var nodesInside = fem.Nodes.Where(n => n.Coordinate.X >= leftDot && n.Coordinate.X <= rightDot);

            var node = nodesInside.MaxBy(x => Math.Abs(x.Displacement.Z))!;

            maxNodes[i] = new SegmentDisplacementMaximum(
                node, 
                node.Displacement.Z, 
                node.Displacement.Z / offset);
        }
        return maxNodes;
    }

    public ForceMaximum GetForceMaximum(TObj model, FemModel fem)
    {
        var maxSegment = fem.Segments
            .SelectMany(s => new[] { s.First, s.Second})
            .MaxBy(s => s.Force!.Z);

        var stress = GetTangentialStress(
            maxSegment.Force!.Z,
            model.StaticMomentOfShearSectionY,
            model.MomentOfInertiaY,
            model.Width);

        return new ForceMaximum(
            maxSegment.Force!.Z,
            stress,
            stress / model.BendingShearResistance);
    }

    private static List<double> GetSupportWithConsolesCoordinates(TObj model)
    {
        var dots = new List<double>();
        dots.AddRange(model.Supports);

        if (!dots.Any(d => d < 0.0000001)) dots.Add(0);
        if (!(dots.Any(d => Math.Abs(d - model.Length) < 0.0000001))) dots.Add(model.Length);

        return dots;
    }

    private static IEnumerable<Node> CreateBaseDots(TObj model)
    {
        var nodes = new List<Node>
        {
            new(0),
            new(model.Length)
        };
        nodes
            .AddRange(model.Supports
                .Select(support => new Node(support)));

        nodes
            .AddRange(model.ConcentratedLoads
                .Select(load => new Node(load.Offset)));

        foreach (var load in model.DistributedLoads)
        {
            nodes.Add(new Node(load.OffsetStart));
            nodes.Add(new Node(load.OffsetStart));
        }

        return nodes;
    }

    private static IOrderedEnumerable<Node> CreateAdditionalDots(IEnumerable<Node> importantNodes, double step = 0.05)
    {
        var importantNodesList = importantNodes.OrderBy(n => n.Coordinate.X).ToList();
        if (importantNodesList.Count < 2) throw new ArgumentException("number of nodes < 2");

        var newNodes = new List<Node>((int)(importantNodesList.Max(n => n.Coordinate.X) / step));

        for (var i = 0; i < importantNodesList.Count - 1; i++)
        {
            newNodes.Add(importantNodesList[i]);
            var distance = importantNodesList[i + 1].Coordinate.X - importantNodesList[i].Coordinate.X;
            if (distance <= 0.01) continue;

            var numberOfSegments = (int)Math.Ceiling(distance / step);

            var segmentSize = numberOfSegments < 3 ? distance / 3 : distance / numberOfSegments;

            for (var j = 1; j <= numberOfSegments; j++)
                newNodes.Add(new Node(importantNodesList[i].Coordinate.X + segmentSize * j));
        }

        newNodes.Add(importantNodesList[^1]);

        var preRes = newNodes.OrderBy(n => n.Coordinate.X).ToList();
        var res = new List<Node>(preRes.Count);

        foreach (var node in preRes)
            if (!res.Any(v => Math.Abs(v.Coordinate.X - node.Coordinate.X) < .00005))
                res.Add(node);

        return res.OrderBy(r => r.Coordinate.X);
    }

    private static IEnumerable<Segment> CreateSegments(TObj model, int count)
    {
        var segments = new Segment[count];
        for (var i = 0; i < count; i++)
            segments[i] = new Segment
            {
                First = new SegmentEnd(i + 1,
                    new Vector6D<bool>(),
                    new Vector6D<bool> { U = true }),

                Second = new SegmentEnd(i + 2,
                    new Vector6D<bool>(),
                    new Vector6D<bool> { U = true }),

                ZDirection = new Point3D(0, 0, 1),
                StiffnessModulus = model.StiffnessModulus,
                ShearModulus = model.ShearModulusAverage,
                CrossSectionalArea = model.CrossSectionArea,
                ShearAreaY = model.CrossSectionArea * 5 / 6,
                ShearAreaZ = model.CrossSectionArea * 5 / 6,
                MomentOfInertiaX = model.PolarMomentOfInertia,
                MomentOfInertiaY = model.MomentOfInertiaY,
                MomentOfInertiaZ = model.MomentOfInertiaZ
            };
        return segments;
    }

    /// <summary>
    ///     расчёт касательного напряжения
    /// </summary>
    /// <param name="force">Q - расчётная поперечная сила</param>
    /// <param name="staticMomentOfShearSection">Sбр - статический момент брутто сдвигаемой части относительно нейтральной оси </param>
    /// <param name="momentOfInertia">момент инерции брутто поперечного сечения элемента относительно нейтральной оси</param>
    /// <param name="width">bрас - расчётная ширина сечения элемента</param>
    /// <param name="bendingShearResistance">Rск - расчётное сопротивление скалыванию при изгибе, коэффициенты аналогичны Rи</param>
    /// <returns>касательное напряжение</returns>
    private static double GetTangentialStress(double force, double staticMomentOfShearSection, double momentOfInertia, double width)
    {
        return force * staticMomentOfShearSection / momentOfInertia * width;
    }
}