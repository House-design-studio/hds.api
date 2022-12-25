------------------------------------------------------------------------------
--                                                                          --
--                         House Designer's Studio                          --
--                                                                          --
------------------------------------------------------------------------------
--                                                                          --
-- Copyright © 2018-2022, Vadim Godunko <vgodunko@gmail.com>                --
-- All rights reserved.                                                     --
--                                                                          --
------------------------------------------------------------------------------

CREATE TABLE users
 (user_id     INTEGER NOT NULL UNIQUE PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  signup_date DATE    NOT NULL DEFAULT CURRENT_DATE);

INSERT INTO users (user_id) OVERRIDING SYSTEM VALUE VALUES (0);
--  Специальный идентификатор для анонимного пользователя.

CREATE TABLE oauth_google
 (subject CHARACTER VARYING NOT NULL UNIQUE PRIMARY KEY,
  user_id INTEGER           NOT NULL UNIQUE REFERENCES users);

--  XXX Сохранение сессий между перезапусками сервера не реализовано.
--  CREATE TABLE sessions
--   (session_id         CHARACTER VARYING NOT NULL UNIQUE PRIMARY KEY,
--    creation_time      TIMESTAMP         NOT NULL,
--    last_accessed_time TIMESTAMP         NOT NULL,
--    user_id            INTEGER           NOT NULL REFERENCES users);

CREATE TABLE subscription_levels
 (subscription_level_id  INTEGER NOT NULL UNIQUE PRIMARY KEY,
  name                   CHARACTER VARYING NOT NULL UNIQUE CHECK (name <> ''));

INSERT INTO subscription_levels (subscription_level_id, name)
  VALUES (1, 'gratitude');
INSERT INTO subscription_levels (subscription_level_id, name)
  VALUES (2, 'personal');

CREATE TABLE subscriptions
 (user_id                INTEGER NOT NULL REFERENCES users,
  subscription_level_id  INTEGER NOT NULL REFERENCES subscription_levels,
  valid                  DATE NOT NULL);

CREATE TABLE orders
 (user_id  INTEGER NOT NULL REFERENCES users,
  order_id INTEGER NOT NULL UNIQUE PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  service  INTEGER NOT NULL,
  created  TIMESTAMP NOT NULL,
  amount   DECIMAL (8,2) NOT NULL);

CREATE TABLE payments
 (order_id INTEGER NOT NULL REFERENCES orders,
  amount   DECIMAL (8,2) NOT NULL,
  payed    TIMESTAMP NOT NULL);

CREATE VIEW payed_orders AS
  SELECT user_id, orders.order_id, service, orders.amount AS invoiced_amount,
         payments.amount AS received_amount, created, payed
    FROM payments JOIN orders USING (order_id);

CREATE TABLE states
 (state_id  INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name      CHARACTER VARYING NOT NULL UNIQUE,
  sort_key  INTEGER NOT NULL UNIQUE);

CREATE TABLE localities
 (locality_id INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name        CHARACTER VARYING NOT NULL CHECK (name <> ''),
  state_id    INTEGER NOT NULL REFERENCES states,
  UNIQUE (state_id, name));

CREATE TABLE user_settings
 (user_id     INTEGER NOT NULL UNIQUE REFERENCES users,
  locality_id INTEGER NOT NULL REFERENCES localities);

CREATE TABLE sp_20_13330_2016_snow_areas
 (snow_area_id   INTEGER NOT NULL UNIQUE PRIMARY KEY,
  name           CHARACTER VARYING,
  normative_load DOUBLE PRECISION NOT NULL);

INSERT INTO sp_20_13330_2016_snow_areas (snow_area_id, name, normative_load)
  VALUES (0, 'I',     500.0);
INSERT INTO sp_20_13330_2016_snow_areas (snow_area_id, name, normative_load)
  VALUES (1, 'II',   1000.0);
INSERT INTO sp_20_13330_2016_snow_areas (snow_area_id, name, normative_load)
  VALUES (2, 'III',  1500.0);
INSERT INTO sp_20_13330_2016_snow_areas (snow_area_id, name, normative_load)
  VALUES (3, 'IV',   2000.0);
INSERT INTO sp_20_13330_2016_snow_areas (snow_area_id, name, normative_load)
  VALUES (4, 'V',    2500.0);
INSERT INTO sp_20_13330_2016_snow_areas (snow_area_id, name, normative_load)
  VALUES (5, 'VI',   3000.0);
INSERT INTO sp_20_13330_2016_snow_areas (snow_area_id, name, normative_load)
  VALUES (6, 'VII',  3500.0);
INSERT INTO sp_20_13330_2016_snow_areas (snow_area_id, name, normative_load)
  VALUES (7, 'VIII', 4000.0);

CREATE TABLE sp_20_13330_2016_wind_areas
 (wind_area_id   INTEGER NOT NULL UNIQUE PRIMARY KEY,
  name           CHARACTER VARYING,
  normative_load DOUBLE PRECISION NOT NULL);

INSERT INTO sp_20_13330_2016_wind_areas (wind_area_id, name, normative_load)
  VALUES (0, 'Iа',  170.0);
INSERT INTO sp_20_13330_2016_wind_areas (wind_area_id, name, normative_load)
  VALUES (1, 'I',   230.0);
INSERT INTO sp_20_13330_2016_wind_areas (wind_area_id, name, normative_load)
  VALUES (2, 'II',  300.0);
INSERT INTO sp_20_13330_2016_wind_areas (wind_area_id, name, normative_load)
  VALUES (3, 'III', 380.0);
INSERT INTO sp_20_13330_2016_wind_areas (wind_area_id, name, normative_load)
  VALUES (4, 'IV',  480.0);
INSERT INTO sp_20_13330_2016_wind_areas (wind_area_id, name, normative_load)
  VALUES (5, 'V',   600.0);
INSERT INTO sp_20_13330_2016_wind_areas (wind_area_id, name, normative_load)
  VALUES (6, 'VI',  730.0);
INSERT INTO sp_20_13330_2016_wind_areas (wind_area_id, name, normative_load)
  VALUES (7, 'VII', 850.0);

CREATE TABLE sp_20_13330_2016_locality_snow_loads
 (locality_id INTEGER NOT NULL UNIQUE REFERENCES localities,
  normative_load DOUBLE PRECISION NOT NULL);

CREATE TABLE sp_20_13330_2016_settings
 (user_id          INTEGER NOT NULL UNIQUE REFERENCES users,
  snow_area_id     INTEGER REFERENCES sp_20_13330_2016_snow_areas,
  snow_locality_id INTEGER REFERENCES sp_20_13330_2016_locality_snow_loads (locality_id),
  wind_area_id     INTEGER NOT NULL REFERENCES sp_20_13330_2016_wind_areas,
  CHECK ((snow_area_id IS NOT NULL AND snow_locality_id IS NULL)
           OR (snow_area_id IS NULL AND snow_locality_id IS NOT NULL)));

CREATE TABLE sp_131_13330_2012_wind_directions
 (wind_direction_id INTEGER NOT NULL UNIQUE PRIMARY KEY,
  image             CHARACTER VARYING (2) NOT NULL UNIQUE);

INSERT INTO sp_131_13330_2012_wind_directions (wind_direction_id, image)
  VALUES (0, 'С');
INSERT INTO sp_131_13330_2012_wind_directions (wind_direction_id, image)
  VALUES (1, 'СВ');
INSERT INTO sp_131_13330_2012_wind_directions (wind_direction_id, image)
  VALUES (2, 'В');
INSERT INTO sp_131_13330_2012_wind_directions (wind_direction_id, image)
  VALUES (3, 'ЮВ');
INSERT INTO sp_131_13330_2012_wind_directions (wind_direction_id, image)
  VALUES (4, 'Ю');
INSERT INTO sp_131_13330_2012_wind_directions (wind_direction_id, image)
  VALUES (5, 'ЮЗ');
INSERT INTO sp_131_13330_2012_wind_directions (wind_direction_id, image)
  VALUES (6, 'З');
INSERT INTO sp_131_13330_2012_wind_directions (wind_direction_id, image)
  VALUES (7, 'СЗ');

CREATE TABLE sp_131_13330_2012_cold_period
 (locality_id                    INTEGER NOT NULL UNIQUE REFERENCES localities,
  coldest_day_temperature_98     REAL,
  coldest_day_temperature_92     REAL,
  coldest_five_temperature_98    REAL,
  coldest_five_temperature_92    REAL,
  temperature_94                 REAL,
  absolute_minimum_temperature   REAL NOT NULL,
  average_temperature_amplitude  REAL,
  duration_0                     INTEGER NOT NULL,
  average_temperature_0          REAL,
  duration_8                     INTEGER NOT NULL,
  average_temperature_8          REAL NOT NULL,
  duration_10                    INTEGER NOT NULL,
  average_temperature_10         REAL NOT NULL,
  average_month_moisture         REAL,
  average_month_moisture_at_1500 REAL,
  rainfall_nov_mar               REAL,
  wind_direction_id              INTEGER REFERENCES sp_131_13330_2012_wind_directions (wind_direction_id),
  maximum_wind_speed_jan         REAL,
  average_wind_speed_8           REAL);

CREATE TABLE user_settings_sp_131_13330_2012_cold_period
 (user_id                        INTEGER NOT NULL UNIQUE REFERENCES users,
  coldest_day_temperature_98     REAL,
  coldest_day_temperature_92     REAL,
  coldest_five_temperature_98    REAL,
  coldest_five_temperature_92    REAL,
  temperature_94                 REAL,
  absolute_minimum_temperature   REAL,
  average_temperature_amplitude  REAL,
  duration_0                     INTEGER,
  average_temperature_0          REAL,
  duration_8                     INTEGER,
  average_temperature_8          REAL,
  duration_10                    INTEGER,
  average_temperature_10         REAL,
  average_month_moisture         REAL,
  average_month_moisture_at_1500 REAL,
  rainfall_nov_mar               REAL,
  wind_direction_id              INTEGER REFERENCES sp_131_13330_2012_wind_directions (wind_direction_id),
  maximum_wind_speed_jan         REAL,
  average_wind_speed_8           REAL);
