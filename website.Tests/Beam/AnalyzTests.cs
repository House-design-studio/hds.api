using static HDS.BusinessLogic.Beam.Analyze;

namespace HDS.BuisnessLogic.Tests.Beam
{
    internal class AnalyzTests
    {
        [Test]
        public void Get_Polar_Moment_Of_Inertia()
        {
            var width = 47.8 * 0.001;
            var height = 144.1 * 0.001;

            var result = GetPolarMomentOfInertia(width, height);

            Assert.That(result * 1000 * 1000 * 1000 * 1000, Is.EqualTo(13230460).Within(1));
        }

        [Test]
        public void Get_Moment_Of_Inertia_Y()
        {
            var width = 47.8 * 0.001;
            var height = 144.1 * 0.001;

            var result = GetMomentOfInertiaY(width, height);

            Assert.That(result * 1000 * 1000 * 1000 * 1000, Is.EqualTo(11918966).Within(1));
        }

        [Test]
        public void Get_Moment_Of_Inertia_Z()
        {
            var width = 47.8 * 0.001;
            var height = 144.1 * 0.001;

            var result = GetMomentOfInertiaZ(width, height);

            Assert.That(result * 1000 * 1000 * 1000 * 1000, Is.EqualTo(1311494).Within(1));
        }

        [Test]
        public void Get_Moment_Of_Resistance_Y()
        {
            var width = 47.8 * 0.001;
            var height = 144.1 * 0.001;

            var result = GetMomentOfResistanceY(width, height);

            Assert.That(result * 1000 * 1000 * 1000, Is.EqualTo(165426).Within(1));
        }

        [Test]
        public void Get_Moment_Of_Resistance_Z()
        {
            var width = 47.8 * 0.001;
            var height = 144.1 * 0.001;

            var result = GetMomentOfResistanceZ(width, height);

            Assert.That(result * 1000 * 1000 * 1000, Is.EqualTo(54874).Within(1));
        }

        [Test]
        public void Get_Static_Moment_Of_Shear_Section_Y()
        {
            var width = 47.8 * 0.001;
            var height = 144.1 * 0.001;

            var result = GetStaticMomentOfShearSectionY(width, height);

            Assert.That(result * 1000 * 1000 * 1000, Is.EqualTo(124069).Within(1));
        }

        [Test]
        public void Get_Static_Moment_Of_Shear_Section_Z()
        {
            var width = 47.8 * 0.001;
            var height = 144.1 * 0.001;

            var result = GetStaticMomentOfShearSectionZ(width, height);

            Assert.That(result * 1000 * 1000 * 1000, Is.EqualTo(41155).Within(1));
        }
    }
}
