using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Infrastructure.Database.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "sp_131_13330_2012_wind_directions",
                columns: table => new
                {
                    winddirectionid = table.Column<int>(name: "wind_direction_id", type: "integer", nullable: false),
                    image = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("sp_131_13330_2012_wind_directions_pkey", x => x.winddirectionid);
                });

            migrationBuilder.CreateTable(
                name: "sp_20_13330_2016_snow_areas",
                columns: table => new
                {
                    snowareaid = table.Column<int>(name: "snow_area_id", type: "integer", nullable: false),
                    name = table.Column<string>(type: "character varying", nullable: true),
                    normativeload = table.Column<double>(name: "normative_load", type: "double precision", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("sp_20_13330_2016_snow_areas_pkey", x => x.snowareaid);
                });

            migrationBuilder.CreateTable(
                name: "sp_20_13330_2016_wind_areas",
                columns: table => new
                {
                    windareaid = table.Column<int>(name: "wind_area_id", type: "integer", nullable: false),
                    name = table.Column<string>(type: "character varying", nullable: true),
                    normativeload = table.Column<double>(name: "normative_load", type: "double precision", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("sp_20_13330_2016_wind_areas_pkey", x => x.windareaid);
                });

            migrationBuilder.CreateTable(
                name: "states",
                columns: table => new
                {
                    stateid = table.Column<int>(name: "state_id", type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityAlwaysColumn),
                    name = table.Column<string>(type: "character varying", nullable: false),
                    sortkey = table.Column<int>(name: "sort_key", type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_states", x => x.stateid);
                });

            migrationBuilder.CreateTable(
                name: "subscription_levels",
                columns: table => new
                {
                    subscriptionlevelid = table.Column<int>(name: "subscription_level_id", type: "integer", nullable: false),
                    name = table.Column<string>(type: "character varying", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_subscription_levels", x => x.subscriptionlevelid);
                });

            migrationBuilder.CreateTable(
                name: "users",
                columns: table => new
                {
                    userid = table.Column<int>(name: "user_id", type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityAlwaysColumn),
                    signupdate = table.Column<DateOnly>(name: "signup_date", type: "date", nullable: false, defaultValueSql: "CURRENT_DATE")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_users", x => x.userid);
                });

            migrationBuilder.CreateTable(
                name: "localities",
                columns: table => new
                {
                    localityid = table.Column<int>(name: "locality_id", type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityAlwaysColumn),
                    name = table.Column<string>(type: "character varying", nullable: false),
                    stateid = table.Column<int>(name: "state_id", type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_localities", x => x.localityid);
                    table.ForeignKey(
                        name: "localities_state_id_fkey",
                        column: x => x.stateid,
                        principalTable: "states",
                        principalColumn: "state_id");
                });

            migrationBuilder.CreateTable(
                name: "oauth_google",
                columns: table => new
                {
                    subject = table.Column<string>(type: "character varying", nullable: false),
                    userid = table.Column<int>(name: "user_id", type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("oauth_google_pkey", x => x.subject);
                    table.ForeignKey(
                        name: "oauth_google_user_id_fkey",
                        column: x => x.userid,
                        principalTable: "users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "orders",
                columns: table => new
                {
                    orderid = table.Column<int>(name: "order_id", type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityAlwaysColumn),
                    userid = table.Column<int>(name: "user_id", type: "integer", nullable: false),
                    service = table.Column<int>(type: "integer", nullable: false),
                    created = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    amount = table.Column<decimal>(type: "numeric(8,2)", precision: 8, scale: 2, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_orders", x => x.orderid);
                    table.ForeignKey(
                        name: "orders_user_id_fkey",
                        column: x => x.userid,
                        principalTable: "users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "subscriptions",
                columns: table => new
                {
                    userid = table.Column<int>(name: "user_id", type: "integer", nullable: false),
                    subscriptionlevelid = table.Column<int>(name: "subscription_level_id", type: "integer", nullable: false),
                    valid = table.Column<DateOnly>(type: "date", nullable: false)
                },
                constraints: table =>
                {
                    table.ForeignKey(
                        name: "subscriptions_subscription_level_id_fkey",
                        column: x => x.subscriptionlevelid,
                        principalTable: "subscription_levels",
                        principalColumn: "subscription_level_id");
                    table.ForeignKey(
                        name: "subscriptions_user_id_fkey",
                        column: x => x.userid,
                        principalTable: "users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "user_settings_sp_131_13330_2012_cold_period",
                columns: table => new
                {
                    userid = table.Column<int>(name: "user_id", type: "integer", nullable: false),
                    coldestdaytemperature98 = table.Column<float>(name: "coldest_day_temperature_98", type: "real", nullable: true),
                    coldestdaytemperature92 = table.Column<float>(name: "coldest_day_temperature_92", type: "real", nullable: true),
                    coldestfivetemperature98 = table.Column<float>(name: "coldest_five_temperature_98", type: "real", nullable: true),
                    coldestfivetemperature92 = table.Column<float>(name: "coldest_five_temperature_92", type: "real", nullable: true),
                    temperature94 = table.Column<float>(name: "temperature_94", type: "real", nullable: true),
                    absoluteminimumtemperature = table.Column<float>(name: "absolute_minimum_temperature", type: "real", nullable: true),
                    averagetemperatureamplitude = table.Column<float>(name: "average_temperature_amplitude", type: "real", nullable: true),
                    duration0 = table.Column<int>(name: "duration_0", type: "integer", nullable: true),
                    averagetemperature0 = table.Column<float>(name: "average_temperature_0", type: "real", nullable: true),
                    duration8 = table.Column<int>(name: "duration_8", type: "integer", nullable: true),
                    averagetemperature8 = table.Column<float>(name: "average_temperature_8", type: "real", nullable: true),
                    duration10 = table.Column<int>(name: "duration_10", type: "integer", nullable: true),
                    averagetemperature10 = table.Column<float>(name: "average_temperature_10", type: "real", nullable: true),
                    averagemonthmoisture = table.Column<float>(name: "average_month_moisture", type: "real", nullable: true),
                    averagemonthmoistureat1500 = table.Column<float>(name: "average_month_moisture_at_1500", type: "real", nullable: true),
                    rainfallnovmar = table.Column<float>(name: "rainfall_nov_mar", type: "real", nullable: true),
                    winddirectionid = table.Column<int>(name: "wind_direction_id", type: "integer", nullable: true),
                    maximumwindspeedjan = table.Column<float>(name: "maximum_wind_speed_jan", type: "real", nullable: true),
                    averagewindspeed8 = table.Column<float>(name: "average_wind_speed_8", type: "real", nullable: true)
                },
                constraints: table =>
                {
                    table.ForeignKey(
                        name: "user_settings_sp_131_13330_2012_cold_per_wind_direction_id_fkey",
                        column: x => x.winddirectionid,
                        principalTable: "sp_131_13330_2012_wind_directions",
                        principalColumn: "wind_direction_id");
                    table.ForeignKey(
                        name: "user_settings_sp_131_13330_2012_cold_period_user_id_fkey",
                        column: x => x.userid,
                        principalTable: "users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "sp_131_13330_2012_cold_period",
                columns: table => new
                {
                    localityid = table.Column<int>(name: "locality_id", type: "integer", nullable: false),
                    coldestdaytemperature98 = table.Column<float>(name: "coldest_day_temperature_98", type: "real", nullable: true),
                    coldestdaytemperature92 = table.Column<float>(name: "coldest_day_temperature_92", type: "real", nullable: true),
                    coldestfivetemperature98 = table.Column<float>(name: "coldest_five_temperature_98", type: "real", nullable: true),
                    coldestfivetemperature92 = table.Column<float>(name: "coldest_five_temperature_92", type: "real", nullable: true),
                    temperature94 = table.Column<float>(name: "temperature_94", type: "real", nullable: true),
                    absoluteminimumtemperature = table.Column<float>(name: "absolute_minimum_temperature", type: "real", nullable: false),
                    averagetemperatureamplitude = table.Column<float>(name: "average_temperature_amplitude", type: "real", nullable: true),
                    duration0 = table.Column<int>(name: "duration_0", type: "integer", nullable: false),
                    averagetemperature0 = table.Column<float>(name: "average_temperature_0", type: "real", nullable: true),
                    duration8 = table.Column<int>(name: "duration_8", type: "integer", nullable: false),
                    averagetemperature8 = table.Column<float>(name: "average_temperature_8", type: "real", nullable: false),
                    duration10 = table.Column<int>(name: "duration_10", type: "integer", nullable: false),
                    averagetemperature10 = table.Column<float>(name: "average_temperature_10", type: "real", nullable: false),
                    averagemonthmoisture = table.Column<float>(name: "average_month_moisture", type: "real", nullable: true),
                    averagemonthmoistureat1500 = table.Column<float>(name: "average_month_moisture_at_1500", type: "real", nullable: true),
                    rainfallnovmar = table.Column<float>(name: "rainfall_nov_mar", type: "real", nullable: true),
                    winddirectionid = table.Column<int>(name: "wind_direction_id", type: "integer", nullable: true),
                    maximumwindspeedjan = table.Column<float>(name: "maximum_wind_speed_jan", type: "real", nullable: true),
                    averagewindspeed8 = table.Column<float>(name: "average_wind_speed_8", type: "real", nullable: true)
                },
                constraints: table =>
                {
                    table.ForeignKey(
                        name: "sp_131_13330_2012_cold_period_locality_id_fkey",
                        column: x => x.localityid,
                        principalTable: "localities",
                        principalColumn: "locality_id");
                    table.ForeignKey(
                        name: "sp_131_13330_2012_cold_period_wind_direction_id_fkey",
                        column: x => x.winddirectionid,
                        principalTable: "sp_131_13330_2012_wind_directions",
                        principalColumn: "wind_direction_id");
                });

            migrationBuilder.CreateTable(
                name: "sp_20_13330_2016_locality_snow_loads",
                columns: table => new
                {
                    localityid = table.Column<int>(name: "locality_id", type: "integer", nullable: false),
                    normativeload = table.Column<double>(name: "normative_load", type: "double precision", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("sp_20_13330_2016_locality_snow_loads_pkey", x => x.localityid);
                    table.ForeignKey(
                        name: "sp_20_13330_2016_locality_snow_loads_locality_id_fkey",
                        column: x => x.localityid,
                        principalTable: "localities",
                        principalColumn: "locality_id");
                });

            migrationBuilder.CreateTable(
                name: "user_settings",
                columns: table => new
                {
                    userid = table.Column<int>(name: "user_id", type: "integer", nullable: false),
                    localityid = table.Column<int>(name: "locality_id", type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.ForeignKey(
                        name: "user_settings_locality_id_fkey",
                        column: x => x.localityid,
                        principalTable: "localities",
                        principalColumn: "locality_id");
                    table.ForeignKey(
                        name: "user_settings_user_id_fkey",
                        column: x => x.userid,
                        principalTable: "users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "payments",
                columns: table => new
                {
                    orderid = table.Column<int>(name: "order_id", type: "integer", nullable: false),
                    amount = table.Column<decimal>(type: "numeric(8,2)", precision: 8, scale: 2, nullable: false),
                    payed = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.ForeignKey(
                        name: "payments_order_id_fkey",
                        column: x => x.orderid,
                        principalTable: "orders",
                        principalColumn: "order_id");
                });

            migrationBuilder.CreateTable(
                name: "sp_20_13330_2016_settings",
                columns: table => new
                {
                    userid = table.Column<int>(name: "user_id", type: "integer", nullable: false),
                    snowareaid = table.Column<int>(name: "snow_area_id", type: "integer", nullable: true),
                    snowlocalityid = table.Column<int>(name: "snow_locality_id", type: "integer", nullable: true),
                    windareaid = table.Column<int>(name: "wind_area_id", type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.ForeignKey(
                        name: "sp_20_13330_2016_settings_snow_area_id_fkey",
                        column: x => x.snowareaid,
                        principalTable: "sp_20_13330_2016_snow_areas",
                        principalColumn: "snow_area_id");
                    table.ForeignKey(
                        name: "sp_20_13330_2016_settings_snow_locality_id_fkey",
                        column: x => x.snowlocalityid,
                        principalTable: "sp_20_13330_2016_locality_snow_loads",
                        principalColumn: "locality_id");
                    table.ForeignKey(
                        name: "sp_20_13330_2016_settings_user_id_fkey",
                        column: x => x.userid,
                        principalTable: "users",
                        principalColumn: "user_id");
                    table.ForeignKey(
                        name: "sp_20_13330_2016_settings_wind_area_id_fkey",
                        column: x => x.windareaid,
                        principalTable: "sp_20_13330_2016_wind_areas",
                        principalColumn: "wind_area_id");
                });

            migrationBuilder.CreateIndex(
                name: "localities_state_id_name_key",
                table: "localities",
                columns: new[] { "state_id", "name" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "oauth_google_user_id_key",
                table: "oauth_google",
                column: "user_id",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_orders_user_id",
                table: "orders",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_payments_order_id",
                table: "payments",
                column: "order_id");

            migrationBuilder.CreateIndex(
                name: "IX_sp_131_13330_2012_cold_period_wind_direction_id",
                table: "sp_131_13330_2012_cold_period",
                column: "wind_direction_id");

            migrationBuilder.CreateIndex(
                name: "sp_131_13330_2012_cold_period_locality_id_key",
                table: "sp_131_13330_2012_cold_period",
                column: "locality_id",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "sp_131_13330_2012_wind_directions_image_key",
                table: "sp_131_13330_2012_wind_directions",
                column: "image",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "sp_20_13330_2016_locality_snow_loads_locality_id_key",
                table: "sp_20_13330_2016_locality_snow_loads",
                column: "locality_id",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_sp_20_13330_2016_settings_snow_area_id",
                table: "sp_20_13330_2016_settings",
                column: "snow_area_id");

            migrationBuilder.CreateIndex(
                name: "IX_sp_20_13330_2016_settings_snow_locality_id",
                table: "sp_20_13330_2016_settings",
                column: "snow_locality_id");

            migrationBuilder.CreateIndex(
                name: "IX_sp_20_13330_2016_settings_wind_area_id",
                table: "sp_20_13330_2016_settings",
                column: "wind_area_id");

            migrationBuilder.CreateIndex(
                name: "sp_20_13330_2016_settings_user_id_key",
                table: "sp_20_13330_2016_settings",
                column: "user_id",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "states_name_key",
                table: "states",
                column: "name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "states_sort_key_key",
                table: "states",
                column: "sort_key",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "subscription_levels_name_key",
                table: "subscription_levels",
                column: "name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_subscriptions_subscription_level_id",
                table: "subscriptions",
                column: "subscription_level_id");

            migrationBuilder.CreateIndex(
                name: "IX_subscriptions_user_id",
                table: "subscriptions",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_user_settings_locality_id",
                table: "user_settings",
                column: "locality_id");

            migrationBuilder.CreateIndex(
                name: "user_settings_user_id_key",
                table: "user_settings",
                column: "user_id",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_user_settings_sp_131_13330_2012_cold_period_wind_direction_~",
                table: "user_settings_sp_131_13330_2012_cold_period",
                column: "wind_direction_id");

            migrationBuilder.CreateIndex(
                name: "user_settings_sp_131_13330_2012_cold_period_user_id_key",
                table: "user_settings_sp_131_13330_2012_cold_period",
                column: "user_id",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "oauth_google");

            migrationBuilder.DropTable(
                name: "payments");

            migrationBuilder.DropTable(
                name: "sp_131_13330_2012_cold_period");

            migrationBuilder.DropTable(
                name: "sp_20_13330_2016_settings");

            migrationBuilder.DropTable(
                name: "subscriptions");

            migrationBuilder.DropTable(
                name: "user_settings");

            migrationBuilder.DropTable(
                name: "user_settings_sp_131_13330_2012_cold_period");

            migrationBuilder.DropTable(
                name: "orders");

            migrationBuilder.DropTable(
                name: "sp_20_13330_2016_snow_areas");

            migrationBuilder.DropTable(
                name: "sp_20_13330_2016_locality_snow_loads");

            migrationBuilder.DropTable(
                name: "sp_20_13330_2016_wind_areas");

            migrationBuilder.DropTable(
                name: "subscription_levels");

            migrationBuilder.DropTable(
                name: "sp_131_13330_2012_wind_directions");

            migrationBuilder.DropTable(
                name: "users");

            migrationBuilder.DropTable(
                name: "localities");

            migrationBuilder.DropTable(
                name: "states");
        }
    }
}
