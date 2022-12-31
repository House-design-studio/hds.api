namespace MathCore.Common.Base
{
    public class Vector6D<TValue>
        where TValue : struct
    {
        public TValue X { get; set; }
        public TValue Y { get; set; }
        public TValue Z { get; set; }
        public TValue U { get; set; }
        public TValue V { get; set; }
        public TValue W { get; set; }
    }

}
