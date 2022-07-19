using static website.BusinessLogic.Math;

namespace website.Tests
{
    public class MathTests
    {
        [Test]
        public void Do_Linear_Interpolation_Returns_Positive()
        {
            var point1 = new Point2D(0, 0);
            var point2 = new Point2D(3, 3);
            var X = 1.5d;

            var result = LinearInterpolation(point1, point2, X);

            Assert.That(result, Is.EqualTo(1.5d));
        }

        [Test]
        public void Do_Linear_Interpolation_Returns_0()
        {
            var point1 = new Point2D(0, 0);
            var point2 = new Point2D(0, 0);
            var X = 0;

            var result = LinearInterpolation(point1, point2, X);

            Assert.That(result, Is.EqualTo(0));
        }

        [Test]
        public void Do_Linear_Interpolation_Returns_Negative()
        {
            var point1 = new Point2D(-3d, -3d);
            var point2 = new Point2D(1d, -1d);
            var X = -1.5d;

            var result = LinearInterpolation(point1, point2, X);

            Assert.That(result, Is.EqualTo(-2.25d));
        }
    }
}