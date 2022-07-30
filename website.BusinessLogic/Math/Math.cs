namespace HDS.BusinessLogic
{
    /// <summary>
    /// Класс для математический рассчётов
    /// </summary>
    public static partial class Math
    {
        /// <summary>
        /// Точка в трёхмерном пространстве
        /// </summary>
        /// <param name="X">координата X</param>
        /// <param name="Y">координата Y</param>
        /// <param name="Z">координата Z</param>
        public record struct Point3D(double X, double Y, double Z);

        /// <summary>
        /// Точка в двухмерном пространстве
        /// </summary>
        /// <param name="X">координата X</param>
        /// <param name="Y">координата Y</param>
        public record struct Point2D(double X, double Y);
    }
}
