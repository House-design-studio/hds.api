﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Infrastructure.Database.Migrations
{
    [DbContext(typeof(ApplicationDbContext))]
    [Migration("20230109004816_SubscriptionId")]
    partial class SubscriptionId
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.1")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("HDS.Infrastructure.Database.Locality", b =>
                {
                    b.Property<int>("LocalityId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("locality_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityAlwaysColumn(b.Property<int>("LocalityId"));

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("character varying")
                        .HasColumnName("name");

                    b.Property<int>("StateId")
                        .HasColumnType("integer")
                        .HasColumnName("state_id");

                    b.HasKey("LocalityId");

                    b.HasIndex(new[] { "StateId", "Name" }, "localities_state_id_name_key")
                        .IsUnique();

                    b.ToTable("localities", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.OauthGoogle", b =>
                {
                    b.Property<string>("Subject")
                        .HasColumnType("character varying")
                        .HasColumnName("subject");

                    b.Property<int>("UserId")
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    b.HasKey("Subject")
                        .HasName("oauth_google_pkey");

                    b.HasIndex(new[] { "UserId" }, "oauth_google_user_id_key")
                        .IsUnique();

                    b.ToTable("oauth_google", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Order", b =>
                {
                    b.Property<int>("OrderId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("order_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityAlwaysColumn(b.Property<int>("OrderId"));

                    b.Property<decimal>("Amount")
                        .HasPrecision(8, 2)
                        .HasColumnType("numeric(8,2)")
                        .HasColumnName("amount");

                    b.Property<DateTime>("Created")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("created");

                    b.Property<int>("Service")
                        .HasColumnType("integer")
                        .HasColumnName("service");

                    b.Property<int>("UserId")
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    b.HasKey("OrderId");

                    b.HasIndex("UserId");

                    b.ToTable("orders", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.PayedOrder", b =>
                {
                    b.Property<DateTime?>("Created")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("created");

                    b.Property<decimal?>("InvoicedAmount")
                        .HasPrecision(8, 2)
                        .HasColumnType("numeric(8,2)")
                        .HasColumnName("invoiced_amount");

                    b.Property<int?>("OrderId")
                        .HasColumnType("integer")
                        .HasColumnName("order_id");

                    b.Property<DateTime?>("Payed")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("payed");

                    b.Property<decimal?>("ReceivedAmount")
                        .HasPrecision(8, 2)
                        .HasColumnType("numeric(8,2)")
                        .HasColumnName("received_amount");

                    b.Property<int?>("Service")
                        .HasColumnType("integer")
                        .HasColumnName("service");

                    b.Property<int?>("UserId")
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    b.ToTable((string)null);

                    b.ToView("payed_orders", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Payment", b =>
                {
                    b.Property<decimal>("Amount")
                        .HasPrecision(8, 2)
                        .HasColumnType("numeric(8,2)")
                        .HasColumnName("amount");

                    b.Property<int>("OrderId")
                        .HasColumnType("integer")
                        .HasColumnName("order_id");

                    b.Property<DateTime>("Payed")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("payed");

                    b.HasIndex("OrderId");

                    b.ToTable("payments", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Sp131133302012ColdPeriod", b =>
                {
                    b.Property<float>("AbsoluteMinimumTemperature")
                        .HasColumnType("real")
                        .HasColumnName("absolute_minimum_temperature");

                    b.Property<float?>("AverageMonthMoisture")
                        .HasColumnType("real")
                        .HasColumnName("average_month_moisture");

                    b.Property<float?>("AverageMonthMoistureAt1500")
                        .HasColumnType("real")
                        .HasColumnName("average_month_moisture_at_1500");

                    b.Property<float?>("AverageTemperature0")
                        .HasColumnType("real")
                        .HasColumnName("average_temperature_0");

                    b.Property<float>("AverageTemperature10")
                        .HasColumnType("real")
                        .HasColumnName("average_temperature_10");

                    b.Property<float>("AverageTemperature8")
                        .HasColumnType("real")
                        .HasColumnName("average_temperature_8");

                    b.Property<float?>("AverageTemperatureAmplitude")
                        .HasColumnType("real")
                        .HasColumnName("average_temperature_amplitude");

                    b.Property<float?>("AverageWindSpeed8")
                        .HasColumnType("real")
                        .HasColumnName("average_wind_speed_8");

                    b.Property<float?>("ColdestDayTemperature92")
                        .HasColumnType("real")
                        .HasColumnName("coldest_day_temperature_92");

                    b.Property<float?>("ColdestDayTemperature98")
                        .HasColumnType("real")
                        .HasColumnName("coldest_day_temperature_98");

                    b.Property<float?>("ColdestFiveTemperature92")
                        .HasColumnType("real")
                        .HasColumnName("coldest_five_temperature_92");

                    b.Property<float?>("ColdestFiveTemperature98")
                        .HasColumnType("real")
                        .HasColumnName("coldest_five_temperature_98");

                    b.Property<int>("Duration0")
                        .HasColumnType("integer")
                        .HasColumnName("duration_0");

                    b.Property<int>("Duration10")
                        .HasColumnType("integer")
                        .HasColumnName("duration_10");

                    b.Property<int>("Duration8")
                        .HasColumnType("integer")
                        .HasColumnName("duration_8");

                    b.Property<int>("LocalityId")
                        .HasColumnType("integer")
                        .HasColumnName("locality_id");

                    b.Property<float?>("MaximumWindSpeedJan")
                        .HasColumnType("real")
                        .HasColumnName("maximum_wind_speed_jan");

                    b.Property<float?>("RainfallNovMar")
                        .HasColumnType("real")
                        .HasColumnName("rainfall_nov_mar");

                    b.Property<float?>("Temperature94")
                        .HasColumnType("real")
                        .HasColumnName("temperature_94");

                    b.Property<int?>("WindDirectionId")
                        .HasColumnType("integer")
                        .HasColumnName("wind_direction_id");

                    b.HasIndex("WindDirectionId");

                    b.HasIndex(new[] { "LocalityId" }, "sp_131_13330_2012_cold_period_locality_id_key")
                        .IsUnique();

                    b.ToTable("sp_131_13330_2012_cold_period", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Sp131133302012WindDirection", b =>
                {
                    b.Property<int>("WindDirectionId")
                        .HasColumnType("integer")
                        .HasColumnName("wind_direction_id");

                    b.Property<string>("Image")
                        .IsRequired()
                        .HasMaxLength(2)
                        .HasColumnType("character varying(2)")
                        .HasColumnName("image");

                    b.HasKey("WindDirectionId")
                        .HasName("sp_131_13330_2012_wind_directions_pkey");

                    b.HasIndex(new[] { "Image" }, "sp_131_13330_2012_wind_directions_image_key")
                        .IsUnique();

                    b.ToTable("sp_131_13330_2012_wind_directions", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Sp20133302016LocalitySnowLoad", b =>
                {
                    b.Property<int>("LocalityId")
                        .HasColumnType("integer")
                        .HasColumnName("locality_id");

                    b.Property<double>("NormativeLoad")
                        .HasColumnType("double precision")
                        .HasColumnName("normative_load");

                    b.HasKey("LocalityId")
                        .HasName("sp_20_13330_2016_locality_snow_loads_pkey");

                    b.HasIndex(new[] { "LocalityId" }, "sp_20_13330_2016_locality_snow_loads_locality_id_key")
                        .IsUnique();

                    b.ToTable("sp_20_13330_2016_locality_snow_loads", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Sp20133302016Setting", b =>
                {
                    b.Property<int?>("SnowAreaId")
                        .HasColumnType("integer")
                        .HasColumnName("snow_area_id");

                    b.Property<int?>("SnowLocalityId")
                        .HasColumnType("integer")
                        .HasColumnName("snow_locality_id");

                    b.Property<int>("UserId")
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    b.Property<int>("WindAreaId")
                        .HasColumnType("integer")
                        .HasColumnName("wind_area_id");

                    b.HasIndex("SnowAreaId");

                    b.HasIndex("SnowLocalityId");

                    b.HasIndex("WindAreaId");

                    b.HasIndex(new[] { "UserId" }, "sp_20_13330_2016_settings_user_id_key")
                        .IsUnique();

                    b.ToTable("sp_20_13330_2016_settings", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Sp20133302016SnowArea", b =>
                {
                    b.Property<int>("SnowAreaId")
                        .HasColumnType("integer")
                        .HasColumnName("snow_area_id");

                    b.Property<string>("Name")
                        .HasColumnType("character varying")
                        .HasColumnName("name");

                    b.Property<double>("NormativeLoad")
                        .HasColumnType("double precision")
                        .HasColumnName("normative_load");

                    b.HasKey("SnowAreaId")
                        .HasName("sp_20_13330_2016_snow_areas_pkey");

                    b.ToTable("sp_20_13330_2016_snow_areas", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Sp20133302016WindArea", b =>
                {
                    b.Property<int>("WindAreaId")
                        .HasColumnType("integer")
                        .HasColumnName("wind_area_id");

                    b.Property<string>("Name")
                        .HasColumnType("character varying")
                        .HasColumnName("name");

                    b.Property<double>("NormativeLoad")
                        .HasColumnType("double precision")
                        .HasColumnName("normative_load");

                    b.HasKey("WindAreaId")
                        .HasName("sp_20_13330_2016_wind_areas_pkey");

                    b.ToTable("sp_20_13330_2016_wind_areas", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.State", b =>
                {
                    b.Property<int>("StateId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("state_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityAlwaysColumn(b.Property<int>("StateId"));

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("character varying")
                        .HasColumnName("name");

                    b.Property<int>("SortKey")
                        .HasColumnType("integer")
                        .HasColumnName("sort_key");

                    b.HasKey("StateId");

                    b.HasIndex(new[] { "Name" }, "states_name_key")
                        .IsUnique();

                    b.HasIndex(new[] { "SortKey" }, "states_sort_key_key")
                        .IsUnique();

                    b.ToTable("states", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Subscription", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityAlwaysColumn(b.Property<int>("Id"));

                    b.Property<int>("SubscriptionLevelId")
                        .HasColumnType("integer")
                        .HasColumnName("subscription_level_id");

                    b.Property<int>("UserId")
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    b.Property<DateOnly>("Valid")
                        .HasColumnType("date")
                        .HasColumnName("valid");

                    b.HasKey("Id");

                    b.HasIndex("SubscriptionLevelId");

                    b.HasIndex("UserId");

                    b.ToTable("subscriptions", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.SubscriptionLevel", b =>
                {
                    b.Property<int>("SubscriptionLevelId")
                        .HasColumnType("integer")
                        .HasColumnName("subscription_level_id");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("character varying")
                        .HasColumnName("name");

                    b.HasKey("SubscriptionLevelId");

                    b.HasIndex(new[] { "Name" }, "subscription_levels_name_key")
                        .IsUnique();

                    b.ToTable("subscription_levels", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.User", b =>
                {
                    b.Property<int>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityAlwaysColumn(b.Property<int>("UserId"));

                    b.Property<DateOnly>("SignupDate")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("date")
                        .HasColumnName("signup_date")
                        .HasDefaultValueSql("CURRENT_DATE");

                    b.HasKey("UserId");

                    b.ToTable("users", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.UserSetting", b =>
                {
                    b.Property<int>("LocalityId")
                        .HasColumnType("integer")
                        .HasColumnName("locality_id");

                    b.Property<int>("UserId")
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    b.HasIndex("LocalityId");

                    b.HasIndex(new[] { "UserId" }, "user_settings_user_id_key")
                        .IsUnique();

                    b.ToTable("user_settings", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.UserSettingsSp131133302012ColdPeriod", b =>
                {
                    b.Property<float?>("AbsoluteMinimumTemperature")
                        .HasColumnType("real")
                        .HasColumnName("absolute_minimum_temperature");

                    b.Property<float?>("AverageMonthMoisture")
                        .HasColumnType("real")
                        .HasColumnName("average_month_moisture");

                    b.Property<float?>("AverageMonthMoistureAt1500")
                        .HasColumnType("real")
                        .HasColumnName("average_month_moisture_at_1500");

                    b.Property<float?>("AverageTemperature0")
                        .HasColumnType("real")
                        .HasColumnName("average_temperature_0");

                    b.Property<float?>("AverageTemperature10")
                        .HasColumnType("real")
                        .HasColumnName("average_temperature_10");

                    b.Property<float?>("AverageTemperature8")
                        .HasColumnType("real")
                        .HasColumnName("average_temperature_8");

                    b.Property<float?>("AverageTemperatureAmplitude")
                        .HasColumnType("real")
                        .HasColumnName("average_temperature_amplitude");

                    b.Property<float?>("AverageWindSpeed8")
                        .HasColumnType("real")
                        .HasColumnName("average_wind_speed_8");

                    b.Property<float?>("ColdestDayTemperature92")
                        .HasColumnType("real")
                        .HasColumnName("coldest_day_temperature_92");

                    b.Property<float?>("ColdestDayTemperature98")
                        .HasColumnType("real")
                        .HasColumnName("coldest_day_temperature_98");

                    b.Property<float?>("ColdestFiveTemperature92")
                        .HasColumnType("real")
                        .HasColumnName("coldest_five_temperature_92");

                    b.Property<float?>("ColdestFiveTemperature98")
                        .HasColumnType("real")
                        .HasColumnName("coldest_five_temperature_98");

                    b.Property<int?>("Duration0")
                        .HasColumnType("integer")
                        .HasColumnName("duration_0");

                    b.Property<int?>("Duration10")
                        .HasColumnType("integer")
                        .HasColumnName("duration_10");

                    b.Property<int?>("Duration8")
                        .HasColumnType("integer")
                        .HasColumnName("duration_8");

                    b.Property<float?>("MaximumWindSpeedJan")
                        .HasColumnType("real")
                        .HasColumnName("maximum_wind_speed_jan");

                    b.Property<float?>("RainfallNovMar")
                        .HasColumnType("real")
                        .HasColumnName("rainfall_nov_mar");

                    b.Property<float?>("Temperature94")
                        .HasColumnType("real")
                        .HasColumnName("temperature_94");

                    b.Property<int>("UserId")
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    b.Property<int?>("WindDirectionId")
                        .HasColumnType("integer")
                        .HasColumnName("wind_direction_id");

                    b.HasIndex("WindDirectionId");

                    b.HasIndex(new[] { "UserId" }, "user_settings_sp_131_13330_2012_cold_period_user_id_key")
                        .IsUnique();

                    b.ToTable("user_settings_sp_131_13330_2012_cold_period", (string)null);
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Locality", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.State", "State")
                        .WithMany("Localities")
                        .HasForeignKey("StateId")
                        .IsRequired()
                        .HasConstraintName("localities_state_id_fkey");

                    b.Navigation("State");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.OauthGoogle", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.User", "User")
                        .WithOne("OauthGoogle")
                        .HasForeignKey("HDS.Infrastructure.Database.OauthGoogle", "UserId")
                        .IsRequired()
                        .HasConstraintName("oauth_google_user_id_fkey");

                    b.Navigation("User");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Order", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.User", "User")
                        .WithMany("Orders")
                        .HasForeignKey("UserId")
                        .IsRequired()
                        .HasConstraintName("orders_user_id_fkey");

                    b.Navigation("User");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Payment", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.Order", "Order")
                        .WithMany()
                        .HasForeignKey("OrderId")
                        .IsRequired()
                        .HasConstraintName("payments_order_id_fkey");

                    b.Navigation("Order");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Sp131133302012ColdPeriod", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.Locality", "Locality")
                        .WithOne()
                        .HasForeignKey("HDS.Infrastructure.Database.Sp131133302012ColdPeriod", "LocalityId")
                        .IsRequired()
                        .HasConstraintName("sp_131_13330_2012_cold_period_locality_id_fkey");

                    b.HasOne("HDS.Infrastructure.Database.Sp131133302012WindDirection", "WindDirection")
                        .WithMany()
                        .HasForeignKey("WindDirectionId")
                        .HasConstraintName("sp_131_13330_2012_cold_period_wind_direction_id_fkey");

                    b.Navigation("Locality");

                    b.Navigation("WindDirection");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Sp20133302016LocalitySnowLoad", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.Locality", "Locality")
                        .WithOne("Sp20133302016LocalitySnowLoad")
                        .HasForeignKey("HDS.Infrastructure.Database.Sp20133302016LocalitySnowLoad", "LocalityId")
                        .IsRequired()
                        .HasConstraintName("sp_20_13330_2016_locality_snow_loads_locality_id_fkey");

                    b.Navigation("Locality");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Sp20133302016Setting", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.Sp20133302016SnowArea", "SnowArea")
                        .WithMany()
                        .HasForeignKey("SnowAreaId")
                        .HasConstraintName("sp_20_13330_2016_settings_snow_area_id_fkey");

                    b.HasOne("HDS.Infrastructure.Database.Sp20133302016LocalitySnowLoad", "SnowLocality")
                        .WithMany()
                        .HasForeignKey("SnowLocalityId")
                        .HasConstraintName("sp_20_13330_2016_settings_snow_locality_id_fkey");

                    b.HasOne("HDS.Infrastructure.Database.User", "User")
                        .WithOne()
                        .HasForeignKey("HDS.Infrastructure.Database.Sp20133302016Setting", "UserId")
                        .IsRequired()
                        .HasConstraintName("sp_20_13330_2016_settings_user_id_fkey");

                    b.HasOne("HDS.Infrastructure.Database.Sp20133302016WindArea", "WindArea")
                        .WithMany()
                        .HasForeignKey("WindAreaId")
                        .IsRequired()
                        .HasConstraintName("sp_20_13330_2016_settings_wind_area_id_fkey");

                    b.Navigation("SnowArea");

                    b.Navigation("SnowLocality");

                    b.Navigation("User");

                    b.Navigation("WindArea");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Subscription", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.SubscriptionLevel", "SubscriptionLevel")
                        .WithMany()
                        .HasForeignKey("SubscriptionLevelId")
                        .IsRequired()
                        .HasConstraintName("subscriptions_subscription_level_id_fkey");

                    b.HasOne("HDS.Infrastructure.Database.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .IsRequired()
                        .HasConstraintName("subscriptions_user_id_fkey");

                    b.Navigation("SubscriptionLevel");

                    b.Navigation("User");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.UserSetting", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.Locality", "Locality")
                        .WithMany()
                        .HasForeignKey("LocalityId")
                        .IsRequired()
                        .HasConstraintName("user_settings_locality_id_fkey");

                    b.HasOne("HDS.Infrastructure.Database.User", "User")
                        .WithOne()
                        .HasForeignKey("HDS.Infrastructure.Database.UserSetting", "UserId")
                        .IsRequired()
                        .HasConstraintName("user_settings_user_id_fkey");

                    b.Navigation("Locality");

                    b.Navigation("User");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.UserSettingsSp131133302012ColdPeriod", b =>
                {
                    b.HasOne("HDS.Infrastructure.Database.User", "User")
                        .WithOne()
                        .HasForeignKey("HDS.Infrastructure.Database.UserSettingsSp131133302012ColdPeriod", "UserId")
                        .IsRequired()
                        .HasConstraintName("user_settings_sp_131_13330_2012_cold_period_user_id_fkey");

                    b.HasOne("HDS.Infrastructure.Database.Sp131133302012WindDirection", "WindDirection")
                        .WithMany()
                        .HasForeignKey("WindDirectionId")
                        .HasConstraintName("user_settings_sp_131_13330_2012_cold_per_wind_direction_id_fkey");

                    b.Navigation("User");

                    b.Navigation("WindDirection");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.Locality", b =>
                {
                    b.Navigation("Sp20133302016LocalitySnowLoad")
                        .IsRequired();
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.State", b =>
                {
                    b.Navigation("Localities");
                });

            modelBuilder.Entity("HDS.Infrastructure.Database.User", b =>
                {
                    b.Navigation("OauthGoogle")
                        .IsRequired();

                    b.Navigation("Orders");
                });
#pragma warning restore 612, 618
        }
    }
}
