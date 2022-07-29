using Microsoft.EntityFrameworkCore;

namespace website.Models.Database
{
    public partial class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext()
        {
        }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Locality> Localities { get; set; } = null!;
        public virtual DbSet<OauthGoogle> OauthGoogles { get; set; } = null!;
        public virtual DbSet<Order> Orders { get; set; } = null!;
        public virtual DbSet<PayedOrder> PayedOrders { get; set; } = null!;
        public virtual DbSet<Payment> Payments { get; set; } = null!;
        public virtual DbSet<Sp131133302012ColdPeriod> Sp131133302012ColdPeriods { get; set; } = null!;
        public virtual DbSet<Sp131133302012WindDirection> Sp131133302012WindDirections { get; set; } = null!;
        public virtual DbSet<Sp20133302016LocalitySnowLoad> Sp20133302016LocalitySnowLoads { get; set; } = null!;
        public virtual DbSet<Sp20133302016Setting> Sp20133302016Settings { get; set; } = null!;
        public virtual DbSet<Sp20133302016SnowArea> Sp20133302016SnowAreas { get; set; } = null!;
        public virtual DbSet<Sp20133302016WindArea> Sp20133302016WindAreas { get; set; } = null!;
        public virtual DbSet<State> States { get; set; } = null!;
        public virtual DbSet<Subscription> Subscriptions { get; set; } = null!;
        public virtual DbSet<SubscriptionLevel> SubscriptionLevels { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; } = null!;
        public virtual DbSet<UserSetting> UserSettings { get; set; } = null!;
        public virtual DbSet<UserSettingsSp131133302012ColdPeriod> UserSettingsSp131133302012ColdPeriods { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Locality>(entity =>
            {
                entity.ToTable("localities");

                entity.HasIndex(e => new { e.StateId, e.Name }, "localities_state_id_name_key")
                    .IsUnique();

                entity.Property(e => e.LocalityId)
                    .HasColumnName("locality_id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Name)
                    .HasColumnType("character varying")
                    .HasColumnName("name");

                entity.Property(e => e.StateId).HasColumnName("state_id");

                entity.HasOne(d => d.State)
                    .WithMany(p => p.Localities)
                    .HasForeignKey(d => d.StateId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("localities_state_id_fkey");
            });

            modelBuilder.Entity<OauthGoogle>(entity =>
            {
                entity.HasKey(e => e.Subject)
                    .HasName("oauth_google_pkey");

                entity.ToTable("oauth_google");

                entity.HasIndex(e => e.UserId, "oauth_google_user_id_key")
                    .IsUnique();

                entity.Property(e => e.Subject)
                    .HasColumnType("character varying")
                    .HasColumnName("subject");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.User)
                    .WithOne(p => p.OauthGoogle)
                    .HasForeignKey<OauthGoogle>(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("oauth_google_user_id_fkey");
            });

            modelBuilder.Entity<Order>(entity =>
            {
                entity.ToTable("orders");

                entity.Property(e => e.OrderId)
                    .HasColumnName("order_id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Amount)
                    .HasPrecision(8, 2)
                    .HasColumnName("amount");

                entity.Property(e => e.Created)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("created");

                entity.Property(e => e.Service).HasColumnName("service");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Orders)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("orders_user_id_fkey");
            });

            modelBuilder.Entity<PayedOrder>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("payed_orders");

                entity.Property(e => e.Created)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("created");

                entity.Property(e => e.InvoicedAmount)
                    .HasPrecision(8, 2)
                    .HasColumnName("invoiced_amount");

                entity.Property(e => e.OrderId).HasColumnName("order_id");

                entity.Property(e => e.Payed)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("payed");

                entity.Property(e => e.ReceivedAmount)
                    .HasPrecision(8, 2)
                    .HasColumnName("received_amount");

                entity.Property(e => e.Service).HasColumnName("service");

                entity.Property(e => e.UserId).HasColumnName("user_id");
            });

            modelBuilder.Entity<Payment>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("payments");

                entity.Property(e => e.Amount)
                    .HasPrecision(8, 2)
                    .HasColumnName("amount");

                entity.Property(e => e.OrderId).HasColumnName("order_id");

                entity.Property(e => e.Payed)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("payed");

                entity.HasOne(d => d.Order)
                    .WithMany()
                    .HasForeignKey(d => d.OrderId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("payments_order_id_fkey");
            });

            modelBuilder.Entity<Sp131133302012ColdPeriod>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("sp_131_13330_2012_cold_period");

                entity.HasIndex(e => e.LocalityId, "sp_131_13330_2012_cold_period_locality_id_key")
                    .IsUnique();

                entity.Property(e => e.AbsoluteMinimumTemperature).HasColumnName("absolute_minimum_temperature");

                entity.Property(e => e.AverageMonthMoisture).HasColumnName("average_month_moisture");

                entity.Property(e => e.AverageMonthMoistureAt1500).HasColumnName("average_month_moisture_at_1500");

                entity.Property(e => e.AverageTemperature0).HasColumnName("average_temperature_0");

                entity.Property(e => e.AverageTemperature10).HasColumnName("average_temperature_10");

                entity.Property(e => e.AverageTemperature8).HasColumnName("average_temperature_8");

                entity.Property(e => e.AverageTemperatureAmplitude).HasColumnName("average_temperature_amplitude");

                entity.Property(e => e.AverageWindSpeed8).HasColumnName("average_wind_speed_8");

                entity.Property(e => e.ColdestDayTemperature92).HasColumnName("coldest_day_temperature_92");

                entity.Property(e => e.ColdestDayTemperature98).HasColumnName("coldest_day_temperature_98");

                entity.Property(e => e.ColdestFiveTemperature92).HasColumnName("coldest_five_temperature_92");

                entity.Property(e => e.ColdestFiveTemperature98).HasColumnName("coldest_five_temperature_98");

                entity.Property(e => e.Duration0).HasColumnName("duration_0");

                entity.Property(e => e.Duration10).HasColumnName("duration_10");

                entity.Property(e => e.Duration8).HasColumnName("duration_8");

                entity.Property(e => e.LocalityId).HasColumnName("locality_id");

                entity.Property(e => e.MaximumWindSpeedJan).HasColumnName("maximum_wind_speed_jan");

                entity.Property(e => e.RainfallNovMar).HasColumnName("rainfall_nov_mar");

                entity.Property(e => e.Temperature94).HasColumnName("temperature_94");

                entity.Property(e => e.WindDirectionId).HasColumnName("wind_direction_id");

                entity.HasOne(d => d.Locality)
                    .WithOne()
                    .HasForeignKey<Sp131133302012ColdPeriod>(d => d.LocalityId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("sp_131_13330_2012_cold_period_locality_id_fkey");

                entity.HasOne(d => d.WindDirection)
                    .WithMany()
                    .HasForeignKey(d => d.WindDirectionId)
                    .HasConstraintName("sp_131_13330_2012_cold_period_wind_direction_id_fkey");
            });

            modelBuilder.Entity<Sp131133302012WindDirection>(entity =>
            {
                entity.HasKey(e => e.WindDirectionId)
                    .HasName("sp_131_13330_2012_wind_directions_pkey");

                entity.ToTable("sp_131_13330_2012_wind_directions");

                entity.HasIndex(e => e.Image, "sp_131_13330_2012_wind_directions_image_key")
                    .IsUnique();

                entity.Property(e => e.WindDirectionId)
                    .ValueGeneratedNever()
                    .HasColumnName("wind_direction_id");

                entity.Property(e => e.Image)
                    .HasMaxLength(2)
                    .HasColumnName("image");
            });

            modelBuilder.Entity<Sp20133302016LocalitySnowLoad>(entity =>
            {
                entity.HasKey(e => e.LocalityId)
                    .HasName("sp_20_13330_2016_locality_snow_loads_pkey");

                entity.ToTable("sp_20_13330_2016_locality_snow_loads");

                entity.HasIndex(e => e.LocalityId, "sp_20_13330_2016_locality_snow_loads_locality_id_key")
                    .IsUnique();

                entity.Property(e => e.LocalityId)
                    .ValueGeneratedNever()
                    .HasColumnName("locality_id");

                entity.Property(e => e.NormativeLoad).HasColumnName("normative_load");

                entity.HasOne(d => d.Locality)
                    .WithOne(p => p.Sp20133302016LocalitySnowLoad)
                    .HasForeignKey<Sp20133302016LocalitySnowLoad>(d => d.LocalityId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("sp_20_13330_2016_locality_snow_loads_locality_id_fkey");
            });

            modelBuilder.Entity<Sp20133302016Setting>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("sp_20_13330_2016_settings");

                entity.HasIndex(e => e.UserId, "sp_20_13330_2016_settings_user_id_key")
                    .IsUnique();

                entity.Property(e => e.SnowAreaId).HasColumnName("snow_area_id");

                entity.Property(e => e.SnowLocalityId).HasColumnName("snow_locality_id");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.WindAreaId).HasColumnName("wind_area_id");

                entity.HasOne(d => d.SnowArea)
                    .WithMany()
                    .HasForeignKey(d => d.SnowAreaId)
                    .HasConstraintName("sp_20_13330_2016_settings_snow_area_id_fkey");

                entity.HasOne(d => d.SnowLocality)
                    .WithMany()
                    .HasForeignKey(d => d.SnowLocalityId)
                    .HasConstraintName("sp_20_13330_2016_settings_snow_locality_id_fkey");

                entity.HasOne(d => d.User)
                    .WithOne()
                    .HasForeignKey<Sp20133302016Setting>(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("sp_20_13330_2016_settings_user_id_fkey");

                entity.HasOne(d => d.WindArea)
                    .WithMany()
                    .HasForeignKey(d => d.WindAreaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("sp_20_13330_2016_settings_wind_area_id_fkey");
            });

            modelBuilder.Entity<Sp20133302016SnowArea>(entity =>
            {
                entity.HasKey(e => e.SnowAreaId)
                    .HasName("sp_20_13330_2016_snow_areas_pkey");

                entity.ToTable("sp_20_13330_2016_snow_areas");

                entity.Property(e => e.SnowAreaId)
                    .ValueGeneratedNever()
                    .HasColumnName("snow_area_id");

                entity.Property(e => e.Name)
                    .HasColumnType("character varying")
                    .HasColumnName("name");

                entity.Property(e => e.NormativeLoad).HasColumnName("normative_load");
            });

            modelBuilder.Entity<Sp20133302016WindArea>(entity =>
            {
                entity.HasKey(e => e.WindAreaId)
                    .HasName("sp_20_13330_2016_wind_areas_pkey");

                entity.ToTable("sp_20_13330_2016_wind_areas");

                entity.Property(e => e.WindAreaId)
                    .ValueGeneratedNever()
                    .HasColumnName("wind_area_id");

                entity.Property(e => e.Name)
                    .HasColumnType("character varying")
                    .HasColumnName("name");

                entity.Property(e => e.NormativeLoad).HasColumnName("normative_load");
            });

            modelBuilder.Entity<State>(entity =>
            {
                entity.ToTable("states");

                entity.HasIndex(e => e.Name, "states_name_key")
                    .IsUnique();

                entity.HasIndex(e => e.SortKey, "states_sort_key_key")
                    .IsUnique();

                entity.Property(e => e.StateId)
                    .HasColumnName("state_id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Name)
                    .HasColumnType("character varying")
                    .HasColumnName("name");

                entity.Property(e => e.SortKey).HasColumnName("sort_key");
            });

            modelBuilder.Entity<Subscription>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("subscriptions");

                entity.Property(e => e.SubscriptionLevelId).HasColumnName("subscription_level_id");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.Valid).HasColumnName("valid");

                entity.HasOne(d => d.SubscriptionLevel)
                    .WithMany()
                    .HasForeignKey(d => d.SubscriptionLevelId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("subscriptions_subscription_level_id_fkey");

                entity.HasOne(d => d.User)
                    .WithMany()
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("subscriptions_user_id_fkey");
            });

            modelBuilder.Entity<SubscriptionLevel>(entity =>
            {
                entity.ToTable("subscription_levels");

                entity.HasIndex(e => e.Name, "subscription_levels_name_key")
                    .IsUnique();

                entity.Property(e => e.SubscriptionLevelId)
                    .ValueGeneratedNever()
                    .HasColumnName("subscription_level_id");

                entity.Property(e => e.Name)
                    .HasColumnType("character varying")
                    .HasColumnName("name");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("users");

                entity.Property(e => e.UserId)
                    .HasColumnName("user_id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.SignupDate)
                    .HasColumnName("signup_date")
                    .HasDefaultValueSql("CURRENT_DATE");
            });

            modelBuilder.Entity<UserSetting>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("user_settings");

                entity.HasIndex(e => e.UserId, "user_settings_user_id_key")
                    .IsUnique();

                entity.Property(e => e.LocalityId).HasColumnName("locality_id");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.Locality)
                    .WithMany()
                    .HasForeignKey(d => d.LocalityId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("user_settings_locality_id_fkey");

                entity.HasOne(d => d.User)
                    .WithOne()
                    .HasForeignKey<UserSetting>(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("user_settings_user_id_fkey");
            });

            modelBuilder.Entity<UserSettingsSp131133302012ColdPeriod>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("user_settings_sp_131_13330_2012_cold_period");

                entity.HasIndex(e => e.UserId, "user_settings_sp_131_13330_2012_cold_period_user_id_key")
                    .IsUnique();

                entity.Property(e => e.AbsoluteMinimumTemperature).HasColumnName("absolute_minimum_temperature");

                entity.Property(e => e.AverageMonthMoisture).HasColumnName("average_month_moisture");

                entity.Property(e => e.AverageMonthMoistureAt1500).HasColumnName("average_month_moisture_at_1500");

                entity.Property(e => e.AverageTemperature0).HasColumnName("average_temperature_0");

                entity.Property(e => e.AverageTemperature10).HasColumnName("average_temperature_10");

                entity.Property(e => e.AverageTemperature8).HasColumnName("average_temperature_8");

                entity.Property(e => e.AverageTemperatureAmplitude).HasColumnName("average_temperature_amplitude");

                entity.Property(e => e.AverageWindSpeed8).HasColumnName("average_wind_speed_8");

                entity.Property(e => e.ColdestDayTemperature92).HasColumnName("coldest_day_temperature_92");

                entity.Property(e => e.ColdestDayTemperature98).HasColumnName("coldest_day_temperature_98");

                entity.Property(e => e.ColdestFiveTemperature92).HasColumnName("coldest_five_temperature_92");

                entity.Property(e => e.ColdestFiveTemperature98).HasColumnName("coldest_five_temperature_98");

                entity.Property(e => e.Duration0).HasColumnName("duration_0");

                entity.Property(e => e.Duration10).HasColumnName("duration_10");

                entity.Property(e => e.Duration8).HasColumnName("duration_8");

                entity.Property(e => e.MaximumWindSpeedJan).HasColumnName("maximum_wind_speed_jan");

                entity.Property(e => e.RainfallNovMar).HasColumnName("rainfall_nov_mar");

                entity.Property(e => e.Temperature94).HasColumnName("temperature_94");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.WindDirectionId).HasColumnName("wind_direction_id");

                entity.HasOne(d => d.User)
                    .WithOne()
                    .HasForeignKey<UserSettingsSp131133302012ColdPeriod>(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("user_settings_sp_131_13330_2012_cold_period_user_id_fkey");

                entity.HasOne(d => d.WindDirection)
                    .WithMany()
                    .HasForeignKey(d => d.WindDirectionId)
                    .HasConstraintName("user_settings_sp_131_13330_2012_cold_per_wind_direction_id_fkey");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
