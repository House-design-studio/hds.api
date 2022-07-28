using System;
using System.Collections.Generic;

namespace website.Models.Database
{
    public partial class UserSettingsSp131133302012ColdPeriod
    {
        public int UserId { get; set; }
        public float? ColdestDayTemperature98 { get; set; }
        public float? ColdestDayTemperature92 { get; set; }
        public float? ColdestFiveTemperature98 { get; set; }
        public float? ColdestFiveTemperature92 { get; set; }
        public float? Temperature94 { get; set; }
        public float? AbsoluteMinimumTemperature { get; set; }
        public float? AverageTemperatureAmplitude { get; set; }
        public int? Duration0 { get; set; }
        public float? AverageTemperature0 { get; set; }
        public int? Duration8 { get; set; }
        public float? AverageTemperature8 { get; set; }
        public int? Duration10 { get; set; }
        public float? AverageTemperature10 { get; set; }
        public float? AverageMonthMoisture { get; set; }
        public float? AverageMonthMoistureAt1500 { get; set; }
        public float? RainfallNovMar { get; set; }
        public int? WindDirectionId { get; set; }
        public float? MaximumWindSpeedJan { get; set; }
        public float? AverageWindSpeed8 { get; set; }

        public virtual User User { get; set; } = null!;
        public virtual Sp131133302012WindDirection? WindDirection { get; set; }
    }
}
