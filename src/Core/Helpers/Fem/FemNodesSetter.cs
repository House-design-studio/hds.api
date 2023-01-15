using MathCore.FemCalculator.Model;

namespace Core.Helpers.Fem;

public static class FemNodeSetter
{
    public static IEnumerable<Node> SetSupportsValues(this IEnumerable<Node> nodes, IEnumerable<double> supports)
    {
        var orderedSupports = supports.OrderBy(s => s);

        for (var i = 0; i < orderedSupports.Count(); i++)
        {
            var supportViaNode = nodes.First(n => Math.Abs(n.Coordinate.X - orderedSupports.ElementAt(i)) < .00005);

            supportViaNode.Support.X = i == 0;
            supportViaNode.Support.Y = true;
            supportViaNode.Support.Z = true;
        }

        return nodes;
    }

    public static IEnumerable<Node> SetConcentratedLoadsValues(this IEnumerable<Node> nodes,
        IEnumerable<(double x, double load)> loads)
    {
        foreach (var load in loads)
        {
            var concentratedLoadsViaNode = nodes.First(n => Math.Abs(n.Coordinate.X - load.x) < 0.000005);

            concentratedLoadsViaNode.Load.Z += -load.load;
        }

        return nodes;
    }

    public static IEnumerable<Node> SetDistributedLoadsValues(this IEnumerable<Node> nodes,
        IEnumerable<(double offsetStart, double offsetEnd, double load)> loads)
    {
        foreach (var load in loads)
        {
            var nodesBetweenLoad = nodes.Where(node => node.Coordinate.X >= load.offsetStart &&
                                                       node.Coordinate.X <= load.offsetEnd)
                .OrderBy(node => node.Coordinate.X)
                .ToArray();

            for (var i = 0; i < nodesBetweenLoad.Length - 1; i++)
            {
                var leftNode = nodesBetweenLoad[i];
                var rightNode = nodesBetweenLoad[i + 1];
                var l = rightNode.Coordinate.X - leftNode.Coordinate.X;
                var F = load.load * l / 2;
                var M = load.load * l * l / 12;

                leftNode.Load.Z += -F;
                rightNode.Load.Z += -F;

                leftNode.Load.V += -M;
                rightNode.Load.V += M;
            }
        }

        return nodes;
    }
}