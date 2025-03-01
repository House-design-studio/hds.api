using System.Drawing;
using Svg;

namespace Application.Services.DrawingService;

public partial class DrawingService
{
    private const float SupportCircleRadius = 1f;
    private const float SupportStrokeWidth = 0.5f;

    public SvgDocument DrawSupports(SvgDocument svg, IEnumerable<double> supports, double maxX, double offsetX = 0, double offsetY = 0)
    {
        foreach (var support in supports)
        {
            DrawSupport(svg, support, maxX, offsetX, offsetY);
        }

        return svg;
    }
    public SvgDocument DrawSupport(SvgDocument svg, double support, double maxX, double offsetX = 0, double offsetY = 0)
    {
        var supportScaled = ScaleDefault * support + OffsetX + offsetX;
        var coefY = maxX * SizeCoef * ScaleDefault;
        var c1 = new SvgCircle
        {
            CenterX = (float) (supportScaled),
            CenterY = (float) (offsetY + SupportCircleRadius + coefY),
            StrokeWidth = SupportStrokeWidth,
            Radius = SupportCircleRadius,
            Fill = SvgPaintServer.None,
            Stroke = new SvgColourServer(Color.Black)
        };
        var c2 = new SvgCircle
        {
            CenterX = (float) (supportScaled),
            CenterY = (float) (offsetY + 5.5 * SupportCircleRadius + coefY),
            StrokeWidth = SupportStrokeWidth,
            Radius = SupportCircleRadius,
            Fill = SvgPaintServer.None,
            Stroke = new SvgColourServer(Color.Black)
        };
        var polyline = new SvgPolyline()
        {
            Points = new SvgPointCollection(),
            Fill = SvgPaintServer.None,
            Stroke = new SvgColourServer(Color.Black),
            StrokeWidth = SupportStrokeWidth
        };
        polyline.Points.Add((float) (supportScaled)); // x1
        polyline.Points.Add((float) (offsetY + SupportCircleRadius * 2 + coefY)); // y1
        
        polyline.Points.Add((float) (supportScaled)); // x2
        polyline.Points.Add((float) (offsetY + SupportCircleRadius * 4.5 + coefY)); // y2
        
        svg.Children.Add(c1);
        svg.Children.Add(c2);
        svg.Children.Add(polyline);

        return svg;
    }
}