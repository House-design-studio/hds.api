using static HDS.Core.Beam.Analyze;

namespace HDS.Core.Tests.Beam
{
    public class ShrinkageTests
    {
        [Test]
        public void Get_Shrinkage_Returns_Table()
        {
            var result = GetShrinkage(40 * 0.001);

            Assert.That(result, Is.EqualTo(1.7 * 0.001).Within(0.001));
        }

        [Test]
        public void Get_Shrinkage_Returns_Between()
        {
            var result = GetShrinkage(145 * 0.001);

            Assert.That(result, Is.EqualTo(5.85 * 0.001).Within(0.001));
        }

        [Test]
        public void Get_Shrinkage_Returns_Before()
        {
            var result = GetShrinkage(10 * 0.001);

            Assert.That(result, Is.EqualTo(0.5 * 0.001).Within(0.001));
        }

        [Test]
        public void Get_Shrinkage_Returns_After()
        {
            var result = GetShrinkage(310 * 0.001);

            Assert.That(result, Is.EqualTo(11.1 * 0.001).Within(0.001));
        }
    }
}
