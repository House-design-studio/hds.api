using Core.Entities;
using MathCore.FemCalculator;
using Svg;
using System.Drawing;
using System.Drawing.Drawing2D;
using MathCore.FemCalculator.Model;

namespace Application.Services;
public class DrawingService
{
    private const double ScaleDefault = 100;
    private const double ScaleDisplacement = ScaleDefault * 10_000;
    private const double ScaleForce = 1d / 2d;
    private const double OffsetX = 5;
    private const double OffsetY = 50;

    public SvgDocument DrawDisplacement(FemModel fem)
    {

        var svg = new SvgDocument();

        var beamBase = DrawValues(fem.Nodes
            .Select(node => new KeyValuePair<double, double>(node.Coordinate.X * ScaleDefault, 0)),
            Color.Coral);

        var beamDisplacementZ = DrawValues(fem.Nodes
                .Select(node => new KeyValuePair<double, double>(node.Coordinate.X * ScaleDefault, -(node.Displacement.Z * ScaleDisplacement))),
            Color.DarkGreen);

        svg.Children.Add(beamBase);
        svg.Children.Add(beamDisplacementZ);

        return svg;
    }

    public SvgDocument DrawMoments(FemModel fem)
    {

        var svg = new SvgDocument();

        var beamBase = DrawValues(fem.Nodes
                .Select(node => new KeyValuePair<double, double>(node.Coordinate.X * ScaleDefault, 0)),
            Color.Coral);

        var beamDisplacementZ = DrawValues(fem.Nodes
                .Select(node => new KeyValuePair<double, double>(node.Coordinate.X * ScaleDefault, -(node.Displacement.V * ScaleDisplacement))),
            Color.DarkGreen);

        svg.Children.Add(beamBase);
        svg.Children.Add(beamDisplacementZ);

        return svg;
    }

    public SvgDocument DrawForce(FemModel fem)
    {
        var svg = new SvgDocument();
        var beamBase = DrawValues(fem.Nodes
                .Select(node => new KeyValuePair<double, double>(node.Coordinate.X * ScaleDefault, 0)),
            Color.Coral);

        var points = new List<KeyValuePair<double, double>>();
        foreach (var segment in fem.Segments)
        {
            var node = fem.Nodes[segment.First.Node - 1];
            var force = segment.First.Force!.Z;

            points.Add(new KeyValuePair<double, double>(node.Coordinate.X * ScaleDefault, force * ScaleForce));
        }
        points.Add(new KeyValuePair<double, double>(
            fem.Nodes[fem.Segments.Last().Second.Node - 1].Coordinate.X * ScaleDefault,
            -fem.Segments.Last().Second.Force!.Z * ScaleForce));

        svg.Children.Add(beamBase);
        svg.Children.Add(DrawValues(points, Color.DarkOliveGreen));

        return svg;
    }

    private static SvgPolyline DrawValues(IEnumerable<KeyValuePair<double, double>> values, Color color)
    {
        var line = new SvgPolyline
        {
            Points = new SvgPointCollection(),
            Fill = SvgPaintServer.None,
            Stroke = new SvgColourServer(color),
            StrokeWidth = 1f
        };
        foreach (var point in values)
        {
            line.Points.Add(new SvgUnit((float) (OffsetX + point.Key))); //x
            line.Points.Add(new SvgUnit((float) (OffsetY + point.Value))); //y
        }
        return line;
    }
}
