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


INSERT INTO states (sort_key, name) VALUES (1, 'Республика Адыгея (Адыгея)');
INSERT INTO states (sort_key, name) VALUES (2, 'Алтайский край');
INSERT INTO states (sort_key, name) VALUES (3, 'Республика Алтай');
INSERT INTO states (sort_key, name) VALUES (4, 'Амурская область');
INSERT INTO states (sort_key, name) VALUES (5, 'Архангельская область');
INSERT INTO states (sort_key, name) VALUES (6, 'Астраханская область');
INSERT INTO states (sort_key, name) VALUES (7, 'Республика Башкортостан');
INSERT INTO states (sort_key, name) VALUES (8, 'Белгородская область');
INSERT INTO states (sort_key, name) VALUES (9, 'Брянская область');
INSERT INTO states (sort_key, name) VALUES (10, 'Республика Бурятия');
INSERT INTO states (sort_key, name) VALUES (11, 'Владимирская область');
INSERT INTO states (sort_key, name) VALUES (12, 'Волгоградская область');
INSERT INTO states (sort_key, name) VALUES (13, 'Вологодская область');
INSERT INTO states (sort_key, name) VALUES (14, 'Воронежская область');
INSERT INTO states (sort_key, name) VALUES (15, 'Республика Дагестан');
INSERT INTO states (sort_key, name) VALUES (16, 'Еврейская автономная область');
INSERT INTO states (sort_key, name) VALUES (17, 'Забайкальский край');
INSERT INTO states (sort_key, name) VALUES (18, 'Ивановская область');
INSERT INTO states (sort_key, name) VALUES (19, 'Республика Ингушения');
INSERT INTO states (sort_key, name) VALUES (20, 'Иркутская область');
INSERT INTO states (sort_key, name) VALUES (21, 'Кабардино-Балкарская Республика');
INSERT INTO states (sort_key, name) VALUES (22, 'Калининградская область');
INSERT INTO states (sort_key, name) VALUES (23, 'Республика Калмыкия');
INSERT INTO states (sort_key, name) VALUES (24, 'Калужская область');
INSERT INTO states (sort_key, name) VALUES (25, 'Камчатский край');
INSERT INTO states (sort_key, name) VALUES (26, 'Карачаево-Черкесская Республика');
INSERT INTO states (sort_key, name) VALUES (27, 'Республика Карелия');
INSERT INTO states (sort_key, name) VALUES (28, 'Кемеровская область');
INSERT INTO states (sort_key, name) VALUES (29, 'Кировская область');
INSERT INTO states (sort_key, name) VALUES (30, 'Республика Коми');
INSERT INTO states (sort_key, name) VALUES (31, 'Костромская область');
INSERT INTO states (sort_key, name) VALUES (32, 'Краснодарский край');
INSERT INTO states (sort_key, name) VALUES (33, 'Красноярский край');
INSERT INTO states (sort_key, name) VALUES (34, 'Республика Крым');
INSERT INTO states (sort_key, name) VALUES (35, 'Курганская область');
INSERT INTO states (sort_key, name) VALUES (36, 'Курская область');
INSERT INTO states (sort_key, name) VALUES (37, 'Ленинградская область');
INSERT INTO states (sort_key, name) VALUES (38, 'Липецкая область');
INSERT INTO states (sort_key, name) VALUES (39, 'Магаданская область');
INSERT INTO states (sort_key, name) VALUES (40, 'Республика Марий Эл');
INSERT INTO states (sort_key, name) VALUES (41, 'Республика Мордовия');
INSERT INTO states (sort_key, name) VALUES (42, 'Московская область');
INSERT INTO states (sort_key, name) VALUES (43, 'Мурманская область');
INSERT INTO states (sort_key, name) VALUES (44, 'Ненецкий автономный округ');
INSERT INTO states (sort_key, name) VALUES (45, 'Нижегородская область');
INSERT INTO states (sort_key, name) VALUES (46, 'Новгородская область');
INSERT INTO states (sort_key, name) VALUES (47, 'Новосибирская область');
INSERT INTO states (sort_key, name) VALUES (48, 'Омская область');
INSERT INTO states (sort_key, name) VALUES (49, 'Оренбургская область');
INSERT INTO states (sort_key, name) VALUES (50, 'Орловская область');
INSERT INTO states (sort_key, name) VALUES (51, 'Пензенская область');
INSERT INTO states (sort_key, name) VALUES (52, 'Пермский край');
INSERT INTO states (sort_key, name) VALUES (53, 'Приморский край');
INSERT INTO states (sort_key, name) VALUES (54, 'Псковская область');
INSERT INTO states (sort_key, name) VALUES (55, 'Ростовская область');
INSERT INTO states (sort_key, name) VALUES (56, 'Рязанская область');
INSERT INTO states (sort_key, name) VALUES (57, 'Самарская область');
INSERT INTO states (sort_key, name) VALUES (58, 'Саратовская область');
INSERT INTO states (sort_key, name) VALUES (59, 'Республика Саха (Якутия)');
INSERT INTO states (sort_key, name) VALUES (60, 'Сахалинская область');
INSERT INTO states (sort_key, name) VALUES (61, 'Свердловская область');
INSERT INTO states (sort_key, name) VALUES (62, 'Республика Северная Осетия - Алания');
INSERT INTO states (sort_key, name) VALUES (63, 'Смоленская область');
INSERT INTO states (sort_key, name) VALUES (64, 'Ставропольский край');
INSERT INTO states (sort_key, name) VALUES (65, 'Тамбовская область');
INSERT INTO states (sort_key, name) VALUES (66, 'Республика Татарстан (Татарстан)');
INSERT INTO states (sort_key, name) VALUES (67, 'Тверская область');
INSERT INTO states (sort_key, name) VALUES (68, 'Томская область');
INSERT INTO states (sort_key, name) VALUES (69, 'Республика Тыва');
INSERT INTO states (sort_key, name) VALUES (70, 'Тульская область');
INSERT INTO states (sort_key, name) VALUES (71, 'Тюменская область');
INSERT INTO states (sort_key, name) VALUES (72, 'Удмуртская Республика');
INSERT INTO states (sort_key, name) VALUES (73, 'Ульяновская область');
INSERT INTO states (sort_key, name) VALUES (74, 'Хабаровский край');
INSERT INTO states (sort_key, name) VALUES (75, 'Республика Хакасия');
INSERT INTO states (sort_key, name) VALUES (76, 'Ханты-Мансийский автономный округ - Юрга');
INSERT INTO states (sort_key, name) VALUES (77, 'Челябинская область');
INSERT INTO states (sort_key, name) VALUES (78, 'Чеченская Республика');
INSERT INTO states (sort_key, name) VALUES (79, 'Чувашская Республика - Чувашия');
INSERT INTO states (sort_key, name) VALUES (80, 'Чукотский автономный округ');
INSERT INTO states (sort_key, name) VALUES (81, 'Ямало-Ненецкий автономный округ');
INSERT INTO states (sort_key, name) VALUES (82, 'Ярославская область');

INSERT INTO localities (name, state_id) VALUES ('Майкоп', (SELECT state_id FROM states WHERE name = 'Республика Адыгея (Адыгея)'));
INSERT INTO localities (name, state_id) VALUES ('Алейск', (SELECT state_id FROM states WHERE name = 'Алтайский край'));
INSERT INTO localities (name, state_id) VALUES ('Барнаул', (SELECT state_id FROM states WHERE name = 'Алтайский край'));
INSERT INTO localities (name, state_id) VALUES ('Беля', (SELECT state_id FROM states WHERE name = 'Алтайский край'));
INSERT INTO localities (name, state_id) VALUES ('Бийск', (SELECT state_id FROM states WHERE name = 'Алтайский край'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Бийск-Зональная', (SELECT state_id FROM states WHERE name = 'Алтайский край'));
INSERT INTO localities (name, state_id) VALUES ('Змеиногорск', (SELECT state_id FROM states WHERE name = 'Алтайский край'));
INSERT INTO localities (name, state_id) VALUES ('Родино', (SELECT state_id FROM states WHERE name = 'Алтайский край'));
INSERT INTO localities (name, state_id) VALUES ('Рубцовск', (SELECT state_id FROM states WHERE name = 'Алтайский край'));
INSERT INTO localities (name, state_id) VALUES ('Славгород', (SELECT state_id FROM states WHERE name = 'Алтайский край'));
INSERT INTO localities (name, state_id) VALUES ('Тогул', (SELECT state_id FROM states WHERE name = 'Алтайский край'));
INSERT INTO localities (name, state_id) VALUES ('Горно-Алтайск', (SELECT state_id FROM states WHERE name = 'Республика Алтай'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Катанда', (SELECT state_id FROM states WHERE name = 'Республика Алтай'));
INSERT INTO localities (name, state_id) VALUES ('Кош-Агач', (SELECT state_id FROM states WHERE name = 'Республика Алтай'));
INSERT INTO localities (name, state_id) VALUES ('Онгудай', (SELECT state_id FROM states WHERE name = 'Республика Алтай'));
INSERT INTO localities (name, state_id) VALUES ('Архара', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Белогорск', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Благовещенск', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Бомнак', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Братолюбовка', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Бысса', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Гош', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Дамбуки', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Ерофей Павлович', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Завитинск', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Зея', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Норский Склад', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Огорон', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Поярково', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Свободный', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Сковородино', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Средняя Нюкжа', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Тыган-Уркан', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Тында', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Унаха', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Нюкжа', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Черняево', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Шимановск', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Экимчан', (SELECT state_id FROM states WHERE name = 'Амурская область'));
INSERT INTO localities (name, state_id) VALUES ('Архангельск', (SELECT state_id FROM states WHERE name = 'Архангельская область'));
INSERT INTO localities (name, state_id) VALUES ('Борковская', (SELECT state_id FROM states WHERE name = 'Архангельская область'));
INSERT INTO localities (name, state_id) VALUES ('Емецк', (SELECT state_id FROM states WHERE name = 'Архангельская область'));
INSERT INTO localities (name, state_id) VALUES ('Койнас', (SELECT state_id FROM states WHERE name = 'Архангельская область'));
INSERT INTO localities (name, state_id) VALUES ('Котлас', (SELECT state_id FROM states WHERE name = 'Архангельская область'));
INSERT INTO localities (name, state_id) VALUES ('Мезень', (SELECT state_id FROM states WHERE name = 'Архангельская область'));
INSERT INTO localities (name, state_id) VALUES ('Онега', (SELECT state_id FROM states WHERE name = 'Архангельская область'));
INSERT INTO localities (name, state_id) VALUES ('Северодвинск', (SELECT state_id FROM states WHERE name = 'Архангельская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Астрахань', (SELECT state_id FROM states WHERE name = 'Астраханская область'));
INSERT INTO localities (name, state_id) VALUES ('Верхний Баскунчак', (SELECT state_id FROM states WHERE name = 'Астраханская область'));
INSERT INTO localities (name, state_id) VALUES ('Белорецк', (SELECT state_id FROM states WHERE name = 'Республика Башкортостан'));
INSERT INTO localities (name, state_id) VALUES ('Дуван', (SELECT state_id FROM states WHERE name = 'Республика Башкортостан'));
INSERT INTO localities (name, state_id) VALUES ('Мелеуз', (SELECT state_id FROM states WHERE name = 'Республика Башкортостан'));
INSERT INTO localities (name, state_id) VALUES ('Нефтекамск', (SELECT state_id FROM states WHERE name = 'Республика Башкортостан'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Октябрьский', (SELECT state_id FROM states WHERE name = 'Республика Башкортостан'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Салават', (SELECT state_id FROM states WHERE name = 'Республика Башкортостан'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Стерлитамак', (SELECT state_id FROM states WHERE name = 'Республика Башкортостан'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Уфа', (SELECT state_id FROM states WHERE name = 'Республика Башкортостан'));
INSERT INTO localities (name, state_id) VALUES ('Янаул', (SELECT state_id FROM states WHERE name = 'Республика Башкортостан'));
INSERT INTO localities (name, state_id) VALUES ('Белгород', (SELECT state_id FROM states WHERE name = 'Белгородская область'));
INSERT INTO localities (name, state_id) VALUES ('Старый Оскол', (SELECT state_id FROM states WHERE name = 'Белгородская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Брянск', (SELECT state_id FROM states WHERE name = 'Брянская область'));
INSERT INTO localities (name, state_id) VALUES ('Бабушкин', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Багдарин', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Баргузин', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Кяхта', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Монды', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Нижнеангарск', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Сосново-Озерское', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Уакит', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Улан-Удэ', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Хоринск', (SELECT state_id FROM states WHERE name = 'Республика Бурятия'));
INSERT INTO localities (name, state_id) VALUES ('Владимир', (SELECT state_id FROM states WHERE name = 'Владимирская область'));
INSERT INTO localities (name, state_id) VALUES ('Ковров', (SELECT state_id FROM states WHERE name = 'Владимирская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Муром', (SELECT state_id FROM states WHERE name = 'Владимирская область'));
INSERT INTO localities (name, state_id) VALUES ('Волгоград', (SELECT state_id FROM states WHERE name = 'Волгоградская область'));
INSERT INTO localities (name, state_id) VALUES ('Волжский', (SELECT state_id FROM states WHERE name = 'Волгоградская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Камышин', (SELECT state_id FROM states WHERE name = 'Волгоградская область'));
INSERT INTO localities (name, state_id) VALUES ('Костычевка', (SELECT state_id FROM states WHERE name = 'Волгоградская область'));
INSERT INTO localities (name, state_id) VALUES ('Котельниково', (SELECT state_id FROM states WHERE name = 'Волгоградская область'));
INSERT INTO localities (name, state_id) VALUES ('Новоаннинский', (SELECT state_id FROM states WHERE name = 'Волгоградская область'));
INSERT INTO localities (name, state_id) VALUES ('Эльтон', (SELECT state_id FROM states WHERE name = 'Волгоградская область'));
INSERT INTO localities (name, state_id) VALUES ('Бабаево', (SELECT state_id FROM states WHERE name = 'Вологодская область'));
INSERT INTO localities (name, state_id) VALUES ('Вологда', (SELECT state_id FROM states WHERE name = 'Вологодская область'));
INSERT INTO localities (name, state_id) VALUES ('Вытегра', (SELECT state_id FROM states WHERE name = 'Вологодская область'));
INSERT INTO localities (name, state_id) VALUES ('Никольск', (SELECT state_id FROM states WHERE name = 'Вологодская область'));
INSERT INTO localities (name, state_id) VALUES ('Тотьма', (SELECT state_id FROM states WHERE name = 'Вологодская область'));
INSERT INTO localities (name, state_id) VALUES ('Череповец', (SELECT state_id FROM states WHERE name = 'Вологодская область'));
INSERT INTO localities (name, state_id) VALUES ('Воронеж', (SELECT state_id FROM states WHERE name = 'Воронежская область'));
INSERT INTO localities (name, state_id) VALUES ('Дербент', (SELECT state_id FROM states WHERE name = 'Республика Дагестан'));
INSERT INTO localities (name, state_id) VALUES ('Каспийск', (SELECT state_id FROM states WHERE name = 'Республика Дагестан'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Махачкала', (SELECT state_id FROM states WHERE name = 'Республика Дагестан'));
INSERT INTO localities (name, state_id) VALUES ('Южно-Сухокумск', (SELECT state_id FROM states WHERE name = 'Республика Дагестан'));
INSERT INTO localities (name, state_id) VALUES ('Хасавьюрт', (SELECT state_id FROM states WHERE name = 'Республика Дагестан'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Биробиджан', (SELECT state_id FROM states WHERE name = 'Еврейская автономная область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Агинское', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Акша', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Александровский Завод', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Борзя', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Дарасун', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Калакан', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Красный Чикой', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Могоча', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Нерчинск', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Нерчинский Завод', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Средний Калар', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Тунгокочен', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Тупик', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Чара', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Чита', (SELECT state_id FROM states WHERE name = 'Забайкальский край'));
INSERT INTO localities (name, state_id) VALUES ('Иваново', (SELECT state_id FROM states WHERE name = 'Ивановская область'));
INSERT INTO localities (name, state_id) VALUES ('Кинешма', (SELECT state_id FROM states WHERE name = 'Ивановская область'));
INSERT INTO localities (name, state_id) VALUES ('Назрань', (SELECT state_id FROM states WHERE name = 'Республика Ингушения'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Алыгджер', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Ангарск', (SELECT state_id FROM states WHERE name = 'Иркутская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Бодайбо', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Братск', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Верхняя Гутара', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Дубровское', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Ербогачен', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Жигалово', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Зима', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Ика', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Илимск', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Иркутск', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Ичера', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Киренск', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Мама', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Марково', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Наканно', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Невон', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Непа', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Орлинга', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Перевоз', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Преображенка', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Саянск', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Слюдянка', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Тайшет', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Тулун', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Илимск', (SELECT state_id FROM states WHERE name = 'Иркутская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Усть-Ордынский', (SELECT state_id FROM states WHERE name = 'Иркутская область'));
INSERT INTO localities (name, state_id) VALUES ('Нальчик', (SELECT state_id FROM states WHERE name = 'Кабардино-Балкарская Республика'));
INSERT INTO localities (name, state_id) VALUES ('Калининград', (SELECT state_id FROM states WHERE name = 'Калининградская область'));
INSERT INTO localities (name, state_id) VALUES ('Элиста', (SELECT state_id FROM states WHERE name = 'Республика Калмыкия'));
INSERT INTO localities (name, state_id) VALUES ('Калуга', (SELECT state_id FROM states WHERE name = 'Калужская область'));
INSERT INTO localities (name, state_id) VALUES ('Апука', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Ича', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Ключи', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Козыревск', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Корф', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Кроноки', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Лопатка, мыс', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Мильково', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Начики', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('о.Беринга', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Оссора', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Октябрьская', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Петропавловск-Камчатский', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Семлячики', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Соболево', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Ука', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Воямполка', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Камчатск', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Хайрюзово', (SELECT state_id FROM states WHERE name = 'Камчатский край'));
INSERT INTO localities (name, state_id) VALUES ('Черкесск', (SELECT state_id FROM states WHERE name = 'Карачаево-Черкесская Республика'));
INSERT INTO localities (name, state_id) VALUES ('Кемь', (SELECT state_id FROM states WHERE name = 'Республика Карелия'));
INSERT INTO localities (name, state_id) VALUES ('Лоухи', (SELECT state_id FROM states WHERE name = 'Республика Карелия'));
INSERT INTO localities (name, state_id) VALUES ('Олонец', (SELECT state_id FROM states WHERE name = 'Республика Карелия'));
INSERT INTO localities (name, state_id) VALUES ('Паданы', (SELECT state_id FROM states WHERE name = 'Республика Карелия'));
INSERT INTO localities (name, state_id) VALUES ('Петрозаводск', (SELECT state_id FROM states WHERE name = 'Республика Карелия'));
INSERT INTO localities (name, state_id) VALUES ('Реболы', (SELECT state_id FROM states WHERE name = 'Республика Карелия'));
INSERT INTO localities (name, state_id) VALUES ('Сортавала', (SELECT state_id FROM states WHERE name = 'Республика Карелия'));
INSERT INTO localities (name, state_id) VALUES ('Кемерово', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));
INSERT INTO localities (name, state_id) VALUES ('Киселевск', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));
INSERT INTO localities (name, state_id) VALUES ('Кондома', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));
INSERT INTO localities (name, state_id) VALUES ('Мариинск', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));
INSERT INTO localities (name, state_id) VALUES ('Междуреченск', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Новокузнецк', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Прокопьевск', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Тайга', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));
INSERT INTO localities (name, state_id) VALUES ('Тисуль', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));
INSERT INTO localities (name, state_id) VALUES ('Топки', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Кабырза', (SELECT state_id FROM states WHERE name = 'Кемеровская область'));
INSERT INTO localities (name, state_id) VALUES ('Вятка', (SELECT state_id FROM states WHERE name = 'Кировская область'));
INSERT INTO localities (name, state_id) VALUES ('Киров', (SELECT state_id FROM states WHERE name = 'Кировская область'));
INSERT INTO localities (name, state_id) VALUES ('Нагорское', (SELECT state_id FROM states WHERE name = 'Кировская область'));
INSERT INTO localities (name, state_id) VALUES ('Савали', (SELECT state_id FROM states WHERE name = 'Кировская область'));
INSERT INTO localities (name, state_id) VALUES ('Вендинга', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Воркута', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Объячево', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Петрунь', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Печора', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Сыктывкар', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Троицко-Печорск', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Уса', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Цильма', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Щугор', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Ухта', (SELECT state_id FROM states WHERE name = 'Республика Коми'));
INSERT INTO localities (name, state_id) VALUES ('Кострома', (SELECT state_id FROM states WHERE name = 'Костромская область'));
INSERT INTO localities (name, state_id) VALUES ('Чухлома', (SELECT state_id FROM states WHERE name = 'Костромская область'));
INSERT INTO localities (name, state_id) VALUES ('Шарья', (SELECT state_id FROM states WHERE name = 'Костромская область'));
INSERT INTO localities (name, state_id) VALUES ('Армавир', (SELECT state_id FROM states WHERE name = 'Краснодарский край'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Красная Поляна', (SELECT state_id FROM states WHERE name = 'Краснодарский край'));
INSERT INTO localities (name, state_id) VALUES ('Краснодар', (SELECT state_id FROM states WHERE name = 'Краснодарский край'));
INSERT INTO localities (name, state_id) VALUES ('Кропоткин', (SELECT state_id FROM states WHERE name = 'Краснодарский край'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Приморско-Ахтарск', (SELECT state_id FROM states WHERE name = 'Краснодарский край'));
INSERT INTO localities (name, state_id) VALUES ('Сочи', (SELECT state_id FROM states WHERE name = 'Краснодарский край'));
INSERT INTO localities (name, state_id) VALUES ('Тихорецк', (SELECT state_id FROM states WHERE name = 'Краснодарский край'));
INSERT INTO localities (name, state_id) VALUES ('Агата', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Ачинск', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Байкит', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Боготол', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Богучаны', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Ванавара', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Вельмо', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Верхнеимбатск', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Волочанка', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Диксон', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Дудинка', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Енисейск', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Ессей', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Игарка', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Канск', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Кежма', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Ключи', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Красноярск', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Минусинск', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Норильск', (SELECT state_id FROM states WHERE name = 'Красноярский край'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Таимба', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Троицкое', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Тура', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Туруханск', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Хатанга', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Челюскин, мыс', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Ярцево', (SELECT state_id FROM states WHERE name = 'Красноярский край'));
INSERT INTO localities (name, state_id) VALUES ('Ай-Петри', (SELECT state_id FROM states WHERE name = 'Республика Крым'));
INSERT INTO localities (name, state_id) VALUES ('Евпатория', (SELECT state_id FROM states WHERE name = 'Республика Крым'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Керчь', (SELECT state_id FROM states WHERE name = 'Республика Крым'));
INSERT INTO localities (name, state_id) VALUES ('Клепинино', (SELECT state_id FROM states WHERE name = 'Республика Крым'));
INSERT INTO localities (name, state_id) VALUES ('Севастополь', (SELECT state_id FROM states WHERE name = 'Республика Крым'));
INSERT INTO localities (name, state_id) VALUES ('Симферополь', (SELECT state_id FROM states WHERE name = 'Республика Крым'));
INSERT INTO localities (name, state_id) VALUES ('Феодосия', (SELECT state_id FROM states WHERE name = 'Республика Крым'));
INSERT INTO localities (name, state_id) VALUES ('Ялта', (SELECT state_id FROM states WHERE name = 'Республика Крым'));
INSERT INTO localities (name, state_id) VALUES ('Курган', (SELECT state_id FROM states WHERE name = 'Курганская область'));
INSERT INTO localities (name, state_id) VALUES ('Железногорск', (SELECT state_id FROM states WHERE name = 'Курская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Курск', (SELECT state_id FROM states WHERE name = 'Курская область'));
INSERT INTO localities (name, state_id) VALUES ('Выборг', (SELECT state_id FROM states WHERE name = 'Ленинградская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Гатчина', (SELECT state_id FROM states WHERE name = 'Ленинградская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Пушкин', (SELECT state_id FROM states WHERE name = 'Ленинградская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Санкт-Петербург', (SELECT state_id FROM states WHERE name = 'Ленинградская область'));
INSERT INTO localities (name, state_id) VALUES ('Свирица', (SELECT state_id FROM states WHERE name = 'Ленинградская область'));
INSERT INTO localities (name, state_id) VALUES ('Тихвин', (SELECT state_id FROM states WHERE name = 'Ленинградская область'));
INSERT INTO localities (name, state_id) VALUES ('Елец', (SELECT state_id FROM states WHERE name = 'Липецкая область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Липецк', (SELECT state_id FROM states WHERE name = 'Липецкая область'));
INSERT INTO localities (name, state_id) VALUES ('Аркагала', (SELECT state_id FROM states WHERE name = 'Магаданская область'));
INSERT INTO localities (name, state_id) VALUES ('Брохово', (SELECT state_id FROM states WHERE name = 'Магаданская область'));
INSERT INTO localities (name, state_id) VALUES ('Магадан (Нагаева, бухта)', (SELECT state_id FROM states WHERE name = 'Магаданская область'));
INSERT INTO localities (name, state_id) VALUES ('Омсукчан', (SELECT state_id FROM states WHERE name = 'Магаданская область'));
INSERT INTO localities (name, state_id) VALUES ('Палатка', (SELECT state_id FROM states WHERE name = 'Магаданская область'));
INSERT INTO localities (name, state_id) VALUES ('Среднекан', (SELECT state_id FROM states WHERE name = 'Магаданская область'));
INSERT INTO localities (name, state_id) VALUES ('Сусуман', (SELECT state_id FROM states WHERE name = 'Магаданская область'));
INSERT INTO localities (name, state_id) VALUES ('Йошкар-Ола', (SELECT state_id FROM states WHERE name = 'Республика Марий Эл'));
INSERT INTO localities (name, state_id) VALUES ('Саранск', (SELECT state_id FROM states WHERE name = 'Республика Мордовия'));
INSERT INTO localities (name, state_id) VALUES ('Дмитров', (SELECT state_id FROM states WHERE name = 'Московская область'));
INSERT INTO localities (name, state_id) VALUES ('Кашира', (SELECT state_id FROM states WHERE name = 'Московская область'));
INSERT INTO localities (name, state_id) VALUES ('Клин', (SELECT state_id FROM states WHERE name = 'Московская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Коломна', (SELECT state_id FROM states WHERE name = 'Московская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Москва', (SELECT state_id FROM states WHERE name = 'Московская область'));
INSERT INTO localities (name, state_id) VALUES ('Новомосковский АО', (SELECT state_id FROM states WHERE name = 'Московская область'));
INSERT INTO localities (name, state_id) VALUES ('Сергиев Посад', (SELECT state_id FROM states WHERE name = 'Московская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Серпухов', (SELECT state_id FROM states WHERE name = 'Московская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Троицкий АО', (SELECT state_id FROM states WHERE name = 'Московская область'));
INSERT INTO localities (name, state_id) VALUES ('Вайда-Губа', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Кандалакша', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Ковдор', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Краснощелье', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Ловозеро', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Мончегорск', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Мурманск', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Ниванкюль', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Пулозеро', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Пялица', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Териберка', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Терско-Орловский', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Умба', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Юкспор', (SELECT state_id FROM states WHERE name = 'Мурманская область'));
INSERT INTO localities (name, state_id) VALUES ('Варандей', (SELECT state_id FROM states WHERE name = 'Ненецкий автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Индига', (SELECT state_id FROM states WHERE name = 'Ненецкий автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Канин Нос', (SELECT state_id FROM states WHERE name = 'Ненецкий автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Коткино', (SELECT state_id FROM states WHERE name = 'Ненецкий автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Нарьян-Мар', (SELECT state_id FROM states WHERE name = 'Ненецкий автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Ходовариха', (SELECT state_id FROM states WHERE name = 'Ненецкий автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Хоседа-Хард', (SELECT state_id FROM states WHERE name = 'Ненецкий автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Арзамас', (SELECT state_id FROM states WHERE name = 'Нижегородская область'));
INSERT INTO localities (name, state_id) VALUES ('Выкса', (SELECT state_id FROM states WHERE name = 'Нижегородская область'));
INSERT INTO localities (name, state_id) VALUES ('Нижний Новгород', (SELECT state_id FROM states WHERE name = 'Нижегородская область'));
INSERT INTO localities (name, state_id) VALUES ('Саров', (SELECT state_id FROM states WHERE name = 'Нижегородская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Боровичи', (SELECT state_id FROM states WHERE name = 'Новгородская область'));
INSERT INTO localities (name, state_id) VALUES ('Великий Новгород', (SELECT state_id FROM states WHERE name = 'Новгородская область'));
INSERT INTO localities (name, state_id) VALUES ('Барабинск', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));
INSERT INTO localities (name, state_id) VALUES ('Бердск', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Болотное', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));
INSERT INTO localities (name, state_id) VALUES ('Карасук', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));
INSERT INTO localities (name, state_id) VALUES ('Кочки', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));
INSERT INTO localities (name, state_id) VALUES ('Купино', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));
INSERT INTO localities (name, state_id) VALUES ('Кыштовка', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));
INSERT INTO localities (name, state_id) VALUES ('Новосибирск', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));
INSERT INTO localities (name, state_id) VALUES ('Татарск', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));
INSERT INTO localities (name, state_id) VALUES ('Чулым', (SELECT state_id FROM states WHERE name = 'Новосибирская область'));
INSERT INTO localities (name, state_id) VALUES ('Исилькуль', (SELECT state_id FROM states WHERE name = 'Омская область'));
INSERT INTO localities (name, state_id) VALUES ('Омск', (SELECT state_id FROM states WHERE name = 'Омская область'));
INSERT INTO localities (name, state_id) VALUES ('Тара', (SELECT state_id FROM states WHERE name = 'Омская область'));
INSERT INTO localities (name, state_id) VALUES ('Черлак', (SELECT state_id FROM states WHERE name = 'Омская область'));
INSERT INTO localities (name, state_id) VALUES ('Бузулук', (SELECT state_id FROM states WHERE name = 'Оренбургская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Кувандык', (SELECT state_id FROM states WHERE name = 'Оренбургская область'));
INSERT INTO localities (name, state_id) VALUES ('Оренбург', (SELECT state_id FROM states WHERE name = 'Оренбургская область'));
INSERT INTO localities (name, state_id) VALUES ('Орск', (SELECT state_id FROM states WHERE name = 'Оренбургская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Сорочинск', (SELECT state_id FROM states WHERE name = 'Оренбургская область'));
INSERT INTO localities (name, state_id) VALUES ('Орел', (SELECT state_id FROM states WHERE name = 'Орловская область'));
INSERT INTO localities (name, state_id) VALUES ('Земетчино', (SELECT state_id FROM states WHERE name = 'Пензенская область'));
INSERT INTO localities (name, state_id) VALUES ('Кузнецк', (SELECT state_id FROM states WHERE name = 'Пензенская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Пенза', (SELECT state_id FROM states WHERE name = 'Пензенская область'));
INSERT INTO localities (name, state_id) VALUES ('Березники', (SELECT state_id FROM states WHERE name = 'Пермский край'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Бисер', (SELECT state_id FROM states WHERE name = 'Пермский край'));
INSERT INTO localities (name, state_id) VALUES ('Ножовка', (SELECT state_id FROM states WHERE name = 'Пермский край'));
INSERT INTO localities (name, state_id) VALUES ('Пермь', (SELECT state_id FROM states WHERE name = 'Пермский край'));
INSERT INTO localities (name, state_id) VALUES ('Соликамск', (SELECT state_id FROM states WHERE name = 'Пермский край'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Чайковский', (SELECT state_id FROM states WHERE name = 'Пермский край'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Чердынь', (SELECT state_id FROM states WHERE name = 'Пермский край'));
INSERT INTO localities (name, state_id) VALUES ('Агзу', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Анучино', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Астраханка', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Богополь', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Владивосток', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Дальнереченск', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Кировский', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Красный Яр', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Маргаритово', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Мельничное', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Партизанск', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Посьет', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Преображение', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Рудная Пристань', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Сосуново', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Чугуевка', (SELECT state_id FROM states WHERE name = 'Приморский край'));
INSERT INTO localities (name, state_id) VALUES ('Уссурийск', (SELECT state_id FROM states WHERE name = 'Приморский край'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Великие Луки', (SELECT state_id FROM states WHERE name = 'Псковская область'));
INSERT INTO localities (name, state_id) VALUES ('Псков', (SELECT state_id FROM states WHERE name = 'Псковская область'));
INSERT INTO localities (name, state_id) VALUES ('Волгодонск', (SELECT state_id FROM states WHERE name = 'Ростовская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Миллерово', (SELECT state_id FROM states WHERE name = 'Ростовская область'));
INSERT INTO localities (name, state_id) VALUES ('Новочеркасск', (SELECT state_id FROM states WHERE name = 'Ростовская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Новошахтинск', (SELECT state_id FROM states WHERE name = 'Ростовская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Ростов-на-Дону', (SELECT state_id FROM states WHERE name = 'Ростовская область'));
INSERT INTO localities (name, state_id) VALUES ('Таганрог', (SELECT state_id FROM states WHERE name = 'Ростовская область'));
INSERT INTO localities (name, state_id) VALUES ('Шахты', (SELECT state_id FROM states WHERE name = 'Ростовская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Рязань', (SELECT state_id FROM states WHERE name = 'Рязанская область'));
INSERT INTO localities (name, state_id) VALUES ('Новокуйбышевск', (SELECT state_id FROM states WHERE name = 'Самарская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Самара', (SELECT state_id FROM states WHERE name = 'Самарская область'));
INSERT INTO localities (name, state_id) VALUES ('Сызрань', (SELECT state_id FROM states WHERE name = 'Самарская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Тольятти', (SELECT state_id FROM states WHERE name = 'Самарская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Александров Гай', (SELECT state_id FROM states WHERE name = 'Саратовская область'));
INSERT INTO localities (name, state_id) VALUES ('Балашов', (SELECT state_id FROM states WHERE name = 'Саратовская область'));
INSERT INTO localities (name, state_id) VALUES ('Саратов', (SELECT state_id FROM states WHERE name = 'Саратовская область'));
INSERT INTO localities (name, state_id) VALUES ('Энгельс', (SELECT state_id FROM states WHERE name = 'Саратовская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Алдан', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Аллах-Юнь', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Амга', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Батамай', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Бердигястях', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Буяга', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Верхоянск', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Вилюйск', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Витим', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Воронцово', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Джалинда', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Джарджан', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Джикимда', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Дружина', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Екючю', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Жиганск', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Зырянка', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Исить', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Иэма', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Крест-Хальджай', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Кюсюр', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Ленск', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Нагорный', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Нера', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Нюрба', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Нюя', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Оймякон', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Олекминск', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Оленек', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Охотский Перевоз', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Сангар', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Саскылах', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Среднеколымск', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Сунтар', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Сухана', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Сюльдюкар', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Сюрен-Кюель', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Токо', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Томмот', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Томпо', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Туой-Хая', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Тяня', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Мая', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Миль', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Мома', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Чульман', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Чурапча', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Шелагонцы', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Эйк', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Якутск', (SELECT state_id FROM states WHERE name = 'Республика Саха (Якутия)'));
INSERT INTO localities (name, state_id) VALUES ('Александровск-Сахалинский', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Долинск', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Кировское', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Корсаков', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Курильск', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Макаров', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Невельск', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Ноглики', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Оха', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Погиби', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Поронайск', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Рыбновск', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Холмск', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Южно-Курильск', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Южно-Сахалинск', (SELECT state_id FROM states WHERE name = 'Сахалинская область'));
INSERT INTO localities (name, state_id) VALUES ('Верхотурье', (SELECT state_id FROM states WHERE name = 'Свердловская область'));
INSERT INTO localities (name, state_id) VALUES ('Екатеринбург', (SELECT state_id FROM states WHERE name = 'Свердловская область'));
INSERT INTO localities (name, state_id) VALUES ('Ивдель', (SELECT state_id FROM states WHERE name = 'Свердловская область'));
INSERT INTO localities (name, state_id) VALUES ('Каменск-Уральский', (SELECT state_id FROM states WHERE name = 'Свердловская область'));
INSERT INTO localities (name, state_id) VALUES ('Нижний Тагил', (SELECT state_id FROM states WHERE name = 'Свердловская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Первоуральск', (SELECT state_id FROM states WHERE name = 'Свердловская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Серов', (SELECT state_id FROM states WHERE name = 'Свердловская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Туринск', (SELECT state_id FROM states WHERE name = 'Свердловская область'));
INSERT INTO localities (name, state_id) VALUES ('Шамары', (SELECT state_id FROM states WHERE name = 'Свердловская область'));
INSERT INTO localities (name, state_id) VALUES ('Владикавказ', (SELECT state_id FROM states WHERE name = 'Республика Северная Осетия - Алания'));
INSERT INTO localities (name, state_id) VALUES ('Вязьма', (SELECT state_id FROM states WHERE name = 'Смоленская область'));
INSERT INTO localities (name, state_id) VALUES ('Смоленск', (SELECT state_id FROM states WHERE name = 'Смоленская область'));
INSERT INTO localities (name, state_id) VALUES ('Арзгир', (SELECT state_id FROM states WHERE name = 'Ставропольский край'));
INSERT INTO localities (name, state_id) VALUES ('Ессентуки', (SELECT state_id FROM states WHERE name = 'Ставропольский край'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Кисловодск', (SELECT state_id FROM states WHERE name = 'Ставропольский край'));
INSERT INTO localities (name, state_id) VALUES ('Невинномысск', (SELECT state_id FROM states WHERE name = 'Ставропольский край'));
INSERT INTO localities (name, state_id) VALUES ('Пятигорск', (SELECT state_id FROM states WHERE name = 'Ставропольский край'));
INSERT INTO localities (name, state_id) VALUES ('Ставрополь', (SELECT state_id FROM states WHERE name = 'Ставропольский край'));
INSERT INTO localities (name, state_id) VALUES ('Мичуринск', (SELECT state_id FROM states WHERE name = 'Тамбовская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Тамбов', (SELECT state_id FROM states WHERE name = 'Тамбовская область'));
INSERT INTO localities (name, state_id) VALUES ('Альметьевск', (SELECT state_id FROM states WHERE name = 'Республика Татарстан (Татарстан)'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Бугульма', (SELECT state_id FROM states WHERE name = 'Республика Татарстан (Татарстан)'));
INSERT INTO localities (name, state_id) VALUES ('Елабуга', (SELECT state_id FROM states WHERE name = 'Республика Татарстан (Татарстан)'));
INSERT INTO localities (name, state_id) VALUES ('Казань', (SELECT state_id FROM states WHERE name = 'Республика Татарстан (Татарстан)'));
INSERT INTO localities (name, state_id) VALUES ('Набережные Челны', (SELECT state_id FROM states WHERE name = 'Республика Татарстан (Татарстан)'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Нижнекамск', (SELECT state_id FROM states WHERE name = 'Республика Татарстан (Татарстан)'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Бежецк', (SELECT state_id FROM states WHERE name = 'Тверская область'));
INSERT INTO localities (name, state_id) VALUES ('Ржев', (SELECT state_id FROM states WHERE name = 'Тверская область'));
INSERT INTO localities (name, state_id) VALUES ('Тверь', (SELECT state_id FROM states WHERE name = 'Тверская область'));
INSERT INTO localities (name, state_id) VALUES ('Александровское', (SELECT state_id FROM states WHERE name = 'Томская область'));
INSERT INTO localities (name, state_id) VALUES ('Колпашево', (SELECT state_id FROM states WHERE name = 'Томская область'));
INSERT INTO localities (name, state_id) VALUES ('Северск', (SELECT state_id FROM states WHERE name = 'Томская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Средний Васюган', (SELECT state_id FROM states WHERE name = 'Томская область'));
INSERT INTO localities (name, state_id) VALUES ('Томск', (SELECT state_id FROM states WHERE name = 'Томская область'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Озерное', (SELECT state_id FROM states WHERE name = 'Томская область'));
INSERT INTO localities (name, state_id) VALUES ('Кызыл', (SELECT state_id FROM states WHERE name = 'Республика Тыва'));
INSERT INTO localities (name, state_id) VALUES ('Новомосковск', (SELECT state_id FROM states WHERE name = 'Тульская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Тула', (SELECT state_id FROM states WHERE name = 'Тульская область'));
INSERT INTO localities (name, state_id) VALUES ('Демьянское', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Леуши', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Марресаля', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Надым', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Октябрьское', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Салехард', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Сосьва', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Сургут', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Тобольск', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Тюмень', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Угут', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Уренгой', (SELECT state_id FROM states WHERE name = 'Тюменская область'));
INSERT INTO localities (name, state_id) VALUES ('Воткинск', (SELECT state_id FROM states WHERE name = 'Удмуртская Республика'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Глазов', (SELECT state_id FROM states WHERE name = 'Удмуртская Республика'));
INSERT INTO localities (name, state_id) VALUES ('Ижевск', (SELECT state_id FROM states WHERE name = 'Удмуртская Республика'));
INSERT INTO localities (name, state_id) VALUES ('Сарапул', (SELECT state_id FROM states WHERE name = 'Удмуртская Республика'));
INSERT INTO localities (name, state_id) VALUES ('Димитровград', (SELECT state_id FROM states WHERE name = 'Ульяновская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Сурское', (SELECT state_id FROM states WHERE name = 'Ульяновская область'));
INSERT INTO localities (name, state_id) VALUES ('Ульяновск', (SELECT state_id FROM states WHERE name = 'Ульяновская область'));
INSERT INTO localities (name, state_id) VALUES ('Аян', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Байдуков', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Бикин', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Бира', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Биробиджан', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Вяземский', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Гвасюги', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Гроссевичи', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Де-Кастри', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Джаорэ', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Екатерино-Никольское', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Им.Полины Осипенко', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Комсомольск-на-Амуре', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Нижнетамбовское', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Николаевск-на-Амуре', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Облучье', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Охотск', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Сизиман', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Советская Гавань', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Софийский Прииск', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Средний Ургал', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Троицкое', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Хабаровск', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Чумикан', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Энкэн', (SELECT state_id FROM states WHERE name = 'Хабаровский край'));
INSERT INTO localities (name, state_id) VALUES ('Абакан', (SELECT state_id FROM states WHERE name = 'Республика Хакасия'));
INSERT INTO localities (name, state_id) VALUES ('Шира', (SELECT state_id FROM states WHERE name = 'Республика Хакасия'));
INSERT INTO localities (name, state_id) VALUES ('Березово', (SELECT state_id FROM states WHERE name = 'Ханты-Мансийский автономный округ - Юрга'));
INSERT INTO localities (name, state_id) VALUES ('Кондинское', (SELECT state_id FROM states WHERE name = 'Ханты-Мансийский автономный округ - Юрга'));
INSERT INTO localities (name, state_id) VALUES ('Нефтеюганск', (SELECT state_id FROM states WHERE name = 'Ханты-Мансийский автономный округ - Юрга'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Нижневартовск', (SELECT state_id FROM states WHERE name = 'Ханты-Мансийский автономный округ - Юрга'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Сургут', (SELECT state_id FROM states WHERE name = 'Ханты-Мансийский автономный округ - Юрга'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Ханты-Мансийск', (SELECT state_id FROM states WHERE name = 'Ханты-Мансийский автономный округ - Юрга'));
INSERT INTO localities (name, state_id) VALUES ('Верхнеуральск', (SELECT state_id FROM states WHERE name = 'Челябинская область'));
INSERT INTO localities (name, state_id) VALUES ('Златоуст', (SELECT state_id FROM states WHERE name = 'Челябинская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Копейск', (SELECT state_id FROM states WHERE name = 'Челябинская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Магнитогорск', (SELECT state_id FROM states WHERE name = 'Челябинская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Миасс', (SELECT state_id FROM states WHERE name = 'Челябинская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Нязепетровск', (SELECT state_id FROM states WHERE name = 'Челябинская область'));
INSERT INTO localities (name, state_id) VALUES ('Челябинск', (SELECT state_id FROM states WHERE name = 'Челябинская область'));
INSERT INTO localities (name, state_id) VALUES ('Грозный', (SELECT state_id FROM states WHERE name = 'Чеченская Республика'));
INSERT INTO localities (name, state_id) VALUES ('Новочебоксарск', (SELECT state_id FROM states WHERE name = 'Чувашская Республика - Чувашия'));
INSERT INTO localities (name, state_id) VALUES ('Порецкое', (SELECT state_id FROM states WHERE name = 'Чувашская Республика - Чувашия'));
INSERT INTO localities (name, state_id) VALUES ('Чебоксары', (SELECT state_id FROM states WHERE name = 'Чувашская Республика - Чувашия'));
INSERT INTO localities (name, state_id) VALUES ('Анадырь', (SELECT state_id FROM states WHERE name = 'Чукотский автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Березово', (SELECT state_id FROM states WHERE name = 'Чукотский автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Марково', (SELECT state_id FROM states WHERE name = 'Чукотский автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Омолон', (SELECT state_id FROM states WHERE name = 'Чукотский автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Островное', (SELECT state_id FROM states WHERE name = 'Чукотский автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Усть-Олой', (SELECT state_id FROM states WHERE name = 'Чукотский автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Эньмувеем', (SELECT state_id FROM states WHERE name = 'Чукотский автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Новый Уренгой', (SELECT state_id FROM states WHERE name = 'Ямало-Ненецкий автономный округ'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Тарко-Сале', (SELECT state_id FROM states WHERE name = 'Ямало-Ненецкий автономный округ'));
INSERT INTO localities (name, state_id) VALUES ('Рыбинск', (SELECT state_id FROM states WHERE name = 'Ярославская область'));  --  СП 20.13330.2016
INSERT INTO localities (name, state_id) VALUES ('Ярославль', (SELECT state_id FROM states WHERE name = 'Ярославская область'));

INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Адыгея (Адыгея)' AND localities.name = 'Майкоп'),
          -27, -22, -21, -19, -6, -34, 9.0, 40, -1, 148, 2.3, 169, 3.1, 79, 72, 276, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.7, 3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Алтай' AND localities.name = 'Катанда'),
          -43, -42, -42, -40, -28, -48, 12.3, 175, -14.0, 237, -9.2, 258, -7.8, 81, 79, 81, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 1.8, 1.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Алтай' AND localities.name = 'Кош-Агач'),
          -46, -44, -44, -42, -34, -55, 11.5, 191, -17.6, 256, -12.0, 274, -10.7, 81, 80, 15, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 1.5, 1.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Алтай' AND localities.name = 'Онгудай'),
          -42, -41, -40, -38, -26, -46, 11.1, 168, -13.0, 231, -8.3, 249, -7.3, 79, 71, 46, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.3, 9.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Алтайский край' AND localities.name = 'Алейск'),
          -44, -42, -41, -38, -23, -46, 9.5, 164, -11.5, 216, -7.8, 230, -6.7, 80, 78, 130, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 6.8, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Алтайский край' AND localities.name = 'Барнаул'),
          -44, -40, -39, -36, -21, -52, 9.3, 163, -11.1, 213, -7.5, 230, -6.3, 78, 75, 117, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Алтайский край' AND localities.name = 'Беля'),
          -27, -26, -25, -23, -14, -35, 5.9, 149, -6.0, 223, -2.7, 242, -1.7, 59, 55, 121, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 7, 4.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Алтайский край' AND localities.name = 'Бийск-Зональная'),
          -45, -42, -41, -35, -21, -52, 11.3, 163, -11.3, 213, -7.6, 229, -6.5, 78, 75, 182, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.0, 1.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Алтайский край' AND localities.name = 'Змеиногорск'),
          -43, -41, -40, -36, -18, -49, 11.3, 159, -10.2, 211, -6.7, 227, -5.5, 74, 69, 258, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.3, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Алтайский край' AND localities.name = 'Родино'),
          -44, -42, -41, -38, -23, -49, 9.6, 165, -11.8, 215, -8.1, 228, -7.0, 80, 79, 76, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 6.0, 4.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Алтайский край' AND localities.name = 'Рубцовск'),
          -43, -41, -41, -35, -21, -49, 9.5, 160, -11.3, 206, -7.9, 221, -6.7, 79, 76, 98, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 7.2, 4.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Алтайский край' AND localities.name = 'Славгород'),
          -43, -40, -39, -36, -22, -48, 9.2, 163, -12.2, 206, -8.8, 221, -7.6, 81, 79, 94, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.0, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Алтайский край' AND localities.name = 'Тогул'),
          -43, -41, -40, -37, -22, -48, 8.6, 170, -11.0, 225, -7.3, 240, -6.3, 79, 77, 145, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Архара'),
          -41, -38, -38, -36, -30, -50, 12.4, 167, -17.2, 211, -12.7, 227, -11.2, 77, 71, 58, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 2.5, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Белогорск'),
          -43, -40, -41, -37, -32, -48, 10.0, 174, -16.4, 223, -11.9, 236, -10.7, 76, 73, 53, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 2.7, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Благовещенск'),
          -37, -35, -35, -33, -27, -45, 10.7, 164, -14.9, 210, -10.7, 225, -9.4, 73, 65, 43, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 2.6, 2.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Бомнак'),
          -45, -44, -42, -40, -35, -52, 9.9, 189, -19.9, 240, -14.7, 255, -13.3, 75, 71, 49, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 2.0, 1.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Братолюбовка'),
          -41, -40, -39, -37, -33, -51, 11.2, 179, -17.1, 229, -12.4, 242, -11.2, 75, 72, 58, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Бысса'),
          -44, -43, -42, -41, -36, -51, 14.8, 186, -18.4, 236, -13.6, 252, -12.2, 76, 69, 71, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 1.3, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Гош'),
          -46, -44, -43, -42, -36, -52, 15.9, 183, -18.9, 233, -14.0, 247, -12.7, 73, 66, 50, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 1.5, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Дамбуки'),
          -47, -46, -46, -43, -36, -54, 13.6, 196, -18.8, 244, -14.3, 261, -12.8, 66, 59, 57, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 5.2, 1.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Ерофей Павлович'),
          -43, -42, -40, -38, -33, -51, 15.6, 195, -17.0, 245, -12.7, 262, -11.3, 79, 71, 47, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), NULL, 2.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Завитинск'),
          -41, -39, -38, -36, -32, -50, 9.5, 176, -16.4, 226, -11.8, 240, -10.7, 79, 74, 78, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 3.3, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Зея'),
          -46, -44, -43, -42, -35, -52, 14.7, 190, -18.3, 238, -13.8, 254, -12.4, 69, 63, 35, NULL, 3.5, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Норский Склад'),
          -46, -44, -44, -43, -37, -55, 15.0, 183, -19.2, 232, -14.3, 246, -13.0, 74, 68, 58, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 2.1, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Огорон'),
          -43, -41, -41, -40, -34, -50, 10.4, 198, -17.6, 247, -13.3, 265, -11.7, 70, 64, 64, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 3.2, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Поярково'),
          -43, -40, -39, -37, -32, -50, 12.5, 173, -16.5, 222, -11.9, 235, -10.7, 76, 70, 53, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.4, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Свободный'),
          -44, -42, -41, -39, -33, -52, 12.2, 179, -17.1, 229, -12.4, 242, -11.3, 70, 63, 66, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Сковородино'),
          -44, -43, -43, -38, -32, -52, 14.9, 192, -18.7, 245, -13.7, 260, -12.4, 73, 63, 66, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 2.8, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Средняя Нюкжа'),
          -52, -49, -47, -45, -40, -58, 13.3, 213, -20.8, 262, -16.1, 278, -14.7, 76, 72, 77, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Тыган-Уркан'),
          -43, -41, -38, -37, -31, -50, 12.8, 196, -16.5, 245, -12.4, 262, -11.0, 69, 61, 52, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 5.2, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Тында'),
          -48, -46, -44, -42, -37, -54, 12.5, 208, -19.2, 258, -14.7, 274, -13.3, 75, 71, 62, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 5.3, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Унаха'),
          -48, -45, -44, -42, -35, -55, 16.1, 206, -18.4, 255, -14.0, 271, -12.6, 67, 59, 64, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Усть-Нюкжа'),
          -47, -46, -45, -43, -35, -51, 8.1, 199, -20.2, 252, -15.1, 265, -13.9, 76, 74, 31, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 1.7, 1.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Черняево'),
          -45, -44, -43, -40, -31, -51, 13.0, 180, -17.9, 229, -13.1, 245, -11.7, 73, 66, 38, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.7, 1.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Шимановск'),
          -43, -41, -40, -38, -33, -52, 13.4, 182, -17.0, 233, -12.5, 246, -11.3, NULL, 70, 60, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 2.3, 2.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Амурская область' AND localities.name = 'Экимчан'),
          -45, -43, -44, -42, -36, -53, 11.0, 193, -19.8, 249, -14.4, 264, -13.1, 75, 69, 65, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 1.6, 1.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Архангельская область' AND localities.name = 'Архангельск'),
          -38, -37, -35, -33, -16, -45, 7.6, 176, -8.2, 250, -4.5, 271, -3.5, 85, 84, 174, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.4, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Архангельская область' AND localities.name = 'Борковская'),
          -49, -47, -44, -42, -23, -55, 10.0, 203, -10.5, 277, -6.6, 297, -5.6, 83, 83, 191, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Архангельская область' AND localities.name = 'Емецк'),
          -39, -38, -35, -33, -19, -48, 7.6, 175, -8.3, 249, -4.7, 268, -3.7, 85, 85, 150, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), NULL, 3.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Архангельская область' AND localities.name = 'Койнас'),
          -48, -47, -44, -41, -20, -52, 8.9, 190, -10.1, 262, -6.2, 281, -5.1, 83, 83, 185, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.0, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Архангельская область' AND localities.name = 'Котлас'),
          -42, -41, -41, -31, -16, -47, 7.5, 166, -8.9, 237, -5.0, 257, -3.9, 84, NULL, 161, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.6, 2.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Архангельская область' AND localities.name = 'Мезень'),
          -40, -40, -38, -35, -17, -49, 7.8, 194, -8.9, 268, -5.3, 290, -4.2, 84, 83, 149, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.5, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Архангельская область' AND localities.name = 'Онега'),
          -38, -37, -36, -32, -15, -43, 7.0, 168, -7.5, 243, -4.0, 264, -2.9, 84, 84, 188, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.7, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Астраханская область' AND localities.name = 'Астрахань'),
          -25, -24, -23, -21, -10, -33, 6.8, 103, -3.5, 164, -0.8, 179, 0.1, 83, 76, 73, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 3.8, 3.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Астраханская область' AND localities.name = 'Верхний Баскунчак'),
          -30, -28, -28, -24, -12, -37, 6.4, 121, -5.4, 174, -2.5, 187, -1.7, 83, 79, 110, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 3.7, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Белорецк'),
          -39, -37, -37, -34, -21, -45, 8.5, 171, -10.3, 231, -6.5, 249, -5.4, 79, 76, 132, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.6, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Дуван'),
          -42, -38, -36, -34, -19, -50, 7.9, 164, -9.7, 224, -6.0, 240, -5.0, 82, 81, 121, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.6, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Мелеуз'),
          -42, -39, -38, -35, -20, -45, 8.9, 158, -9.9, 210, -6.4, 224, -5.4, 80, 78, 151, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.0, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Уфа'),
          -41, -38, -38, -33, -18, -49, 8.9, 155, -9.5, 209, -6.0, 224, -5.0, 82, 79, 205, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.0, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Янаул'),
          -43, -40, -39, -34, -18, -51, 8.4, 162, -9.7, 218, -6.1, 234, -5.1, 82, 82, 133, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 6.0, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Белгородская область' AND localities.name = 'Белгород'),
          -29, -28, -27, -23, -13, -35, 5.9, 126, -5.0, 191, -1.9, 209, -1.0, 84, 84, 191, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.9, 5.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Брянская область' AND localities.name = 'Брянск'),
          -30, -27, -26, -24, -12, -42, 5.6, 131, -5.2, 199, -2.0, 217, -1.1, 84, 82, 210, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.4, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Бабушкин'),
          -33, -31, -30, -29, -19, -39, 10.3, 175, -9.8, 250, -5.5, 272, -4.4, 78, 72, 87, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 5.7, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Баргузин'),
          -46, -43, -42, -41, -30, -52, 10.1, 183, -16.7, 240, -11.7, 255, -10.5, 79, 78, 94, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.2, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Багдарин'),
          -46, -44, -44, -42, -34, -51, 16.3, 205, -18.2, 261, -13.4, 276, -12.2, 76, 69, 18, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 1.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Кяхта'),
          -37, -35, -35, -31, -25, -40, 9.7, 171, -13.1, 229, -8.7, 245, -7.6, 75, 68, 22, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.2, 1.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Монды'),
          -38, -36, -36, -33, -25, -48, 16.0, 198, -12.2, 266, -8.1, 284, -6.9, 65, 51, 20, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 5.2, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Нижнеангарск'),
          -35, -35, -32, -32, -26, -47, 7.3, 194, -14, 255, -9.6, 271, -8.5, 74, 71, 71, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 1.9, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Сосново-Озерское'),
          -42, -38, -38, -36, -28, -49, 11.2, 197, -14.9, 258, -10.5, 271, -9.5, 77, 75, 18, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 5, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Уакит'),
          -43, -42, -42, -40, -33, -48, 10.4, 217, -17.1, 274, -12.7, 290, -11.4, 74, 70, 26, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Улан-Удэ'),
          -38, -37, -36, -35, -28, -51, 9.9, 175, -14.8, 230, -10.3, 246, -9.0, 76, 70, 28, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.1, 1.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Бурятия' AND localities.name = 'Хоринск'),
          -44, -41, -43, -39, -31, -49, 12.7, 184, -15.4, 241, -10.8, 257, -9.6, 75, 72, 25, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Владимирская область' AND localities.name = 'Владимир'),
          -38, -34, -32, -28, -16, -48, 6.3, 148, -6.9, 213, -3.5, 230, -2.6, 84, 83, 194, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.5, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Владимирская область' AND localities.name = 'Муром'),
          -39, -35, -33, -30, -16, -45, 6.4, 150, -7.4, 214, -4.0, 230, -3.1, 84, 83, 166, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Волгоградская область' AND localities.name = 'Волгоград'),
          -27, -26, -25, -22, -12, -35, 5.6, 122, -5.1, 176, -2.3, 190, -1.5, 85, 82, 151, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 5.1, 3.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Волгоградская область' AND localities.name = 'Камышин'),
          -32, -30, -29, -26, -12, -37, 7.1, 134, -7.2, 188, -4.1, 200, -3.3, 86, 81, 220, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 8.5, 6.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Волгоградская область' AND localities.name = 'Костычевка'),
          -32, -30, -29, -26, NULL, -40, 8.1, 146, -6.7, 190, -3.9, 205, -3.1, 84, 81, 109, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), NULL, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Волгоградская область' AND localities.name = 'Котельниково'),
          -32, -29, -27, -24, -12, -38, 6.8, 112, -4.7, 176, -1.6, 190, -0.8, 85, 84, 161, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 4.2, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Волгоградская область' AND localities.name = 'Новоаннинский'),
          -32, -30, -29, -26, NULL, -38, 7.2, 139, -5.7, 191, -3.4, 204, -2.6, 82, 80, 177, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), NULL, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Волгоградская область' AND localities.name = 'Эльтон'),
          -31, -28, -28, -25, -13, -36, 6.8, 126, -6.1, 177, -3.2, 191, -2.3, 81, 78, 97, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 5.7, 4.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Вологодская область' AND localities.name = 'Бабаево'),
          -40, -36, -36, -31, -17, -47, 7.5, 158, -7.3, 231, -3.8, 250, -2.7, 86, 84, 174, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Вологодская область' AND localities.name = 'Вологда'),
          -42, -37, -37, -32, -15, -47, 7.4, 157, -7.6, 228, -4, 246, -3, 85, 84, 163, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.9, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Вологодская область' AND localities.name = 'Вытегра'),
          -40, -36, -35, -32, -14, -49, 7.3, 154, -7.0, 230, -3.4, 250, -2.4, 84, 84, 210, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.5, 3.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Вологодская область' AND localities.name = 'Никольск'),
          -42, -38, -38, -35, -16, -49, 7.3, 162, -8.5, 231, -4.7, 250, -3.7, 84, 84, 182, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.6, 2.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Вологодская область' AND localities.name = 'Тотьма'),
          -39, -36, -36, -32, -16, -46, 6.9, 161, -8.2, 232, -4.5, 251, -3.4, 84, 83, 188, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.1, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Воронежская область' AND localities.name = 'Воронеж'),
          -31, -29, -25, -24, -13, -37, 5.9, 130, -5.5, 190, -2.5, 206, -1.6, 82, 80, 201, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4, 3.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Дагестан' AND localities.name = 'Дербент'),
          -16, -13, -11, -9, -3, -19, 5.2, 0, NULL, 138, 3.7, 161, 4.5, 84, 82, 179, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 5.2, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Дагестан' AND localities.name = 'Махачкала'),
          -20, -17, -17, -13, -3, -25, 5.6, 0, NULL, 144, 2.7, 164, 3.5, 83, 78, 140, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 5.1, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Дагестан' AND localities.name = 'Южно-Сухокумск'),
          -24, -23, -21, -19, -10, -35, 6.2, 77, -2.5, 162, 0.8, 178, 1.6, 88, 85, 99, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Агинское'),
          -42, -38, -40, -36, -28, -48, 13.9, 182, -14.8, 238, -10.4, 255, -9.1, 72, 67, 19, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Акша'),
          -41, -38, -36, -34, -28, -47, 14.7, 179, -14.0, 237, -9.6, 254, -8.3, 73, 65, 21, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 5.2, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Александровский Завод'),
          -43, -41, -40, -38, -32, -48, 12.1, 194, -16.6, 250, -12.0, 267, -10.6, 80, 75, 38, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Борзя'),
          -43, -41, -41, -38, -30, -50, 14.3, 180, -17.1, 232, -12.4, 247, -11.1, 78, 74, 16, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 1.9, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Дарасун'),
          -40, -37, -38, -34, -27, -48, 13.9, 188, -13.7, 247, -9.5, 265, -8.2, 72, 64, 28, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Калакан'),
          -49, -48, -46, -45, -38, -56, 15.1, 203, -21.7, 257, -16.3, 271, -15, 76, 68, 27, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.4, 0.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Красный Чикой'),
          -42, -41, -37, -37, -29, -48, 12.7, 181, -16.2, 240, -11.2, 256, -9.9, 79, 73, 24, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.4, 1.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Могоча'),
          -46, -42, -43, -39, -33, -53, 15.1, 195, -18.9, 250, -13.8, 266, -12.4, 77, 70, 29, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 3.6, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Нерчинск'),
          -48, -46, -47, -44, -36, -54, 13.3, 183, -19.1, 233, -14.1, 247, -12.8, 77, 73, 23, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.4, 2.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Нерчинский Завод'),
          -42, -40, -41, -38, -32, -53, 9.1, 180, -17.7, 233, -12.7, 249, -11.3, 80, 77, 28, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 2.3, 1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Средний Калар'),
          -52, -50, -48, -46, -41, -56, 17.2, 218, -21.5, 271, -16.4, 287, -15.0, 78, 73, 20, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), NULL, 0.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Тунгокочен'),
          -48, -46, -47, -45, -36, -54, 18.7, 205, -18.7, 262, -13.8, 278, -12.4, 76, 68, 27, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Тупик'),
          -50, -46, -46, -44, -38, -56, 15.4, 207, -19.7, 260, -14.8, 276, -13.4, 76, 70, 45, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Чара'),
          -49, -47, -47, -45, -37, -56, 12.8, 210, -20.8, 263, -15.8, 276, -14.6, 78, 76, 19, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 1.6, 1.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Забайкальский край' AND localities.name = 'Чита'),
          -41, -39, -39, -38, -29, -47, 13.9, 182, -16.1, 238, -11.3, 252, -10.2, 76, 69, 17, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 1.6, 2.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ивановская область' AND localities.name = 'Иваново'),
          -38, -34, -34, -30, -17, -45, 7.1, 152, -7.4, 219, -3.9, 236, -2.9, 85, 84, 209, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.9, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ивановская область' AND localities.name = 'Кинешма'),
          -39, -35, -33, -31, -17, -45, 6.4, 155, -7.6, 221, -4.1, 238, -3.2, 84, 83, 268, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Алыгджер'),
          -41, -39, -38, -36, -22, -47, 11.3, 187, -10.8, 264, -6.4, 284, -5.3, 64, 59, 63, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.8, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Бодайбо'),
          -51, -49, -49, -46, -34, -55, 7.4, 198, -19.1, 253, -14.1, 267, -12.9, 78, 77, 102, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 2.3, 1.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Братск'),
          -43, -46, -40, -39, -26, -46, 8.2, 188, -12.7, 249, -8.6, 266, -7.5, 81, 78, 95, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.4, 2.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Верхняя Гутара'),
          -41, -39, -37, -35, -23, -47, 13.3, 197, -11.9, 267, -7.7, 285, -6.7, 75, 65, 32, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.1, 0.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Дубровское'),
          -53, -52, -52, -50, -34, -55, 9.2, 200, -16.9, 257, -12.3, 272, -11.1, 78, 76, 143, NULL, NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Ербогачен'),
          -56, -54, -53, -51, -34, -61, 10.8, 211, -19.9, 261, -15.3, 274, -14.2, 76, 76, 81, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Жигалово'),
          -50, -48, -46, -44, -31, -54, 10.7, 190, -17.4, 249, -12.3, 265, -11, 81, 79, 56, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.4, 0.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Зима'),
          -47, -45, -43, -42, -28, -50, 11.8, 179, -14.4, 239, -9.7, 257, -8.5, 80, 76, 92, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 4.9, 2.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Ика'),
          -55, -53, -51, -50, -32, -60, 13.0, 208, -18.6, 263, -13.8, 277, -12.7, 75, 74, 44, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.7, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Илимск'),
          -50, -49, -48, -45, -30, -59, 11.8, 195, -15.6, 255, -11.0, 270, -9.8, 79, 76, 109, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Иркутск'),
          -39, -37, -38, -33, -24, -50, 9.2, 170, -12, 232, -7.7, 249, -6.6, 81, 77, 70, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.0, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Ичера'),
          -56, -54, -53, -50, -33, -60, 11.9, 200, -17.5, 254, -12.9, 270, -11.6, 78, 76, 131, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Киренск'),
          -54, -51, -50, -49, -30, -58, 11.5, 196, -17.5, 251, -12.8, 264, -11.7, 77, 77, 95, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.6, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Мама'),
          -50, -49, -48, -46, -34, -56, 7.4, 198, -17.3, 255, -12.6, 271, -11.3, 77, 76, 179, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), NULL, 2.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Марково'),
          -53, -51, -51, -49, -33, -55, 11.1, 194, -16.9, 250, -12.3, 265, -11.0, 78, 76, 117, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.2, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Наканно'),
          -59, -57, -56, -54, -38, -61, 10.7, 216, -21.8, 266, -16.9, 278, -15.8, 78, 77, 94, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Невон'),
          -52, -50, -50, -48, -30, -56, 11.3, 193, -15.8, 253, -11.1, 269, -9.9, 78, 76, 103, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 2.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Непа'),
          -55, -52, -51, -50, -33, -58, 11.1, 206, -17.4, 261, -12.9, 277, -11.6, 78, 77, 100, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), NULL, 2.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Орлинга'),
          -50, -49, -47, -45, -30, -55, 10.8, 194, -16.8, 252, -12.0, 267, -10.8, 80, 77, 92, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 2.6, 1.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Перевоз'),
          -51, -50, -48, -46, -29, -56, 9.3, 202, -17.3, 258, -12.6, 271, -11.6, 72, 70, 41, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 3.1, 1.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Преображенка'),
          -55, -53, -51, -50, -34, -60, 10.5, 207, -17.8, 259, -13.3, 274, -12.1, 78, 77, 124, NULL, NULL, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Саянск'),
          -43, -40, -42, -39, -25, -50, -10.2, 176, -14.0, 234, -9.1, 250, 7.9, 81, 77, 86, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.4, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Слюдянка'),
          -32, -31, -30, -28, -22, -40, 8.8, 177, -11.0, 254, -6.4, 274, -5.3, 76, 68, 50, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 1.5, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Тайшет'),
          -46, -44, -42, -39, -23, -50, 10.1, 177, -12.3, 237, -8.1, 253, -7.1, 79, 77, 98, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.4, 2.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Тулун'),
          -45, -43, -41, -39, -24, -50, 10.0, 182, -12.8, 241, -8.6, 257, -7.5, 78, 73, 60, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.4, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Иркутская область' AND localities.name = 'Усть-Ордынский'),
          -46, -44, -44, -41, -30, -50, 11.1, 183, -15.8, 243, -10.9, 259, -9.6, 80, 79, 46, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), NULL, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кабардино-Балкарская Республика' AND localities.name = 'Нальчик'),
          -24, -21, -20, -18, -9, -31, 7.0, 86, -2.5, 168, 0.6, 187, 1.4, 86, 81, 136, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 2.5, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Калининградская область' AND localities.name = 'Калининград'),
          -25, -22, -21, -19, -6, -33, 4.8, 87, -1.6, 188, 1.2, 213, 2.1, 86, 83, 306, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.6, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Калмыкия' AND localities.name = 'Элиста'),
          -29, -26, -24, -23, -10, -34, 5.7, 108, -3.7, 169, -1, 184, -0.1, 88, 85, 121, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 8.5, 6.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Калужская область' AND localities.name = 'Калуга'),
          -34, -31, -30, -27, -15, -46, 7.3, 142, -6.2, 210, -2.9, 228, -1.9, 83, 83, 213, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.9, 3.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Апука'),
          -34, -31, -30, -28, -16, -40, 6.4, 212, -9.3, 286, -5.8, 317, -4.3, 75, 75, 185, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 8.5, 6.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Ича'),
          -30, -28, -27, -26, -16, -36, 7.6, 184, -8.3, 276, -4.1, 306, -2.8, 77, 76, 209, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 4.2, 4.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Ключи'),
          -38, -36, -34, -33, -19, -49, 7.8, 184, -10.5, 251, -6.6, 270, -5.5, 82, 82, 303, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.9, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Козыревск'),
          -41, -39, -39, -37, -23, -48, 12.0, 189, -11.3, 256, -7.3, 276, -6.1, 82, 81, 234, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Корф'),
          -35, -32, -31, -29, -19, -41, 6.9, 208, -10.5, 270, -7.1, 293, -5.8, 72, 67, 147, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 5.8, 5.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Лопатка, мыс'),
          -18, -15, -15, -13, -8, -21, 3.2, 169, -3.4, 297, -0.2, 365, 1.6, 85, 82, 404, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 11.9, 9.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Мильково'),
          -43, -40, -40, -38, -25, -51, 12.8, 191, -12.5, 256, -8.3, 276, -7.0, 82, 80, 291, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Начики'),
          -37, -36, -34, -32, -21, -51, 15.2, 197, -11.9, 275, -7.4, 296, -6.2, 81, 75, 409, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 2.8, 2.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'о.Беринга'),
          -15, -13, -12, -11, -7, -24, 3.6, 156, -2.5, 283, 0.4, 320, 1.4, 82, 82, 302, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 8.7, 7.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Оссора'),
          -35, -34, -32, -31, -19, -41, 8.9, 206, -10.1, 272, -6.6, 294, -5.5, 78, 74, 401, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Петропавловск-Камчатский'),
          -22, -20, -19, -18, -10, -32, 5.3, 160, -4.8, 250, -1.7, 277, -0.6, 67, 64, 863, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 5.0, 4.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Семлячики'),
          -19, -18, -16, -15, -9, -25, 4.3, 167, -4.5, 260, -1.5, 289, -0.4, 67, 66, 541, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 7.5, 5.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Соболево'),
          -36, -34, -33, -30, -17, -45, 12.2, 185, -9.3, 268, -5.1, 297, -3.7, 80, 75, 331, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 2.9, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Кроноки'),
          -26, -22, -23, -20, -13, -36, 7.3, 179, -5.7, 280, -2.2, 312, -1.1, 69, 64, 865, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Ука'),
          -39, -37, -36, -34, -21, -43, 9.6, 210, -10.3, 281, -6.7, 305, -5.5, 82, 81, 407, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 9.2, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Октябрьская'),
          -32, -30, -28, -25, -18, -42, 9.2, 180, -7.8, 281, -3.5, 318, -2.0, 81, 79, NULL, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 6.4, 6.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Усть-Воямполка'),
          -41, -38, -36, -34, -20, -45, 9.4, 201, -11.5, 286, -6.8, 319, -5.2, 84, 85, 117, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.9, 4.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Усть-Камчатск'),
          -37, -33, -30, -28, -16, -42, 8.3, 192, -7.6, 277, -4.0, 305, -2.8, 81, 80, 664, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 7.1, 4.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Камчатский край' AND localities.name = 'Усть-Хайрюзово'),
          -38, -34, -33, -30, -17, -42, 8.9, 189, -9.5, 273, -5.2, 299, -4, 80, 80, 162, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 5.5, 4.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Карачаево-Черкесская Республика' AND localities.name = 'Черкесск'),
          -23, -21, -20, -18, -9, -29, 8.3, 85, -2.5, 169, 0.6, 189, 1.5, 81, 73, 119, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Карелия' AND localities.name = 'Кемь'),
          -34, -33, -31, -28, -14, -40, 7.2, 176, -6.9, 255, -3.5, 277, -2.5, 85, 82, 125, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.7, 4.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Карелия' AND localities.name = 'Лоухи'),
          -38, -36, -34, -31, -17, -47, 8.7, 184, -7.6, 261, -4.2, 281, -3.2, 86, 86, 159, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Карелия' AND localities.name = 'Олонец'),
          -38, -35, -34, -29, -15, -54, 8.4, 156, -6.7, 233, -3.2, 255, -2.1, 86, 86, 215, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 6.5, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Карелия' AND localities.name = 'Паданы'),
          -35, -34, -32, -30, -14, -46, 7.1, 170, -7.1, 246, -3.7, 266, -2.7, 85, 85, 142, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Карелия' AND localities.name = 'Петрозаводск'),
          -35, -33, -31, -28, -14, -43, 6.4, 158, -6.6, 235, -3.2, 256, -2.2, 86, 84, 169, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.2, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Карелия' AND localities.name = 'Реболы'),
          -40, -37, -35, -33, -15, -42, 7.6, 175, -7.6, 248, -4.2, 267, -3.3, 85, 84, 184, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.1, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Карелия' AND localities.name = 'Сортавала'),
          -36, -32, -31, -29, -14, -43, 7.5, 151, -6, 232, -2.5, 253, -1.6, 85, NULL, 217, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.3, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кемеровская область' AND localities.name = 'Кемерово'),
          -45, -43, -42, -39, -22, -50, 9.5, 172, -12, 227, -8, 243, -6.9, 78, 77, 94, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.4, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кемеровская область' AND localities.name = 'Киселевск'),
          -45, -42, -40, -39, -22, -50, 8.5, 169, -11.2, 227, -7.3, 242, -6.7, 78, 75, 98, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.5, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кемеровская область' AND localities.name = 'Кондома'),
          -46, -44, -43, -40, -24, -52, 13.6, 175, -12.0, 236, -7.8, 254, -6.6, 82, 74, 315, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.6, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кемеровская область' AND localities.name = 'Мариинск'),
          -47, -43, -44, -40, -23, -55, 9.5, 176, -11.6, 235, -7.7, 251, -6.6, 80, 77, 99, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.7, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кемеровская область' AND localities.name = 'Тайга'),
          -43, -42, -40, -39, -22, -53, 9.2, 181, -11.9, 240, -8, 257, -6.8, 81, 79, 169, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.1, 3.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кемеровская область' AND localities.name = 'Тисуль'),
          -44, -43, -42, -39, -20, -51, 9.9, 172, -11, 231, -7.1, 248, -6, 74, 71, 80, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 6.6, 3.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кемеровская область' AND localities.name = 'Топки'),
          -46, -42, -42, -39, -23, -51, 7.7, 180, -11.9, 235, -8.2, 251, -7.1, 84, 82, 256, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кемеровская область' AND localities.name = 'Усть-Кабырза'),
          -46, -44, -43, -41, -27, -54, 13.8, 182, -13.2, 241, -9.0, 259, -7.7, 80, 73, 243, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кировская область' AND localities.name = 'Вятка'),
          -39, -37, -35, -33, -19, -45, 7.2, 168, -9.0, 231, -5.4, 247, -4.8, 86, 82, 167, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.3, 3.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кировская область' AND localities.name = 'Нагорское'),
          -42, -38, -36, -34, -20, -47, 6.3, 174, -9.5, 239, -5.8, 258, -4.7, 87, 87, 172, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 4.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Кировская область' AND localities.name = 'Савали'),
          -40, -37, -37, -33, -19, -48, 7.2, 162, -9.1, 220, -5.7, 235, -4.7, 82, 80, 229, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 4.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Вендинга'),
          -46, -44, -40, -39, -21, -52, 8.7, 183, -9.9, 257, -5.9, 277, -4.8, 83, 83, 159, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.8, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Воркута'),
          -46, -45, -43, -41, -26, -52, 8.6, 239, -12.8, 306, -9.1, 328, -7.8, 81, 81, 178, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 10.1, 5.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Объячево'),
          -41, -39, -37, -34, -20, -47, 7.0, 172, -8.9, 239, -5.3, 259, -4.2, 83, 83, 182, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Петрунь'),
          -48, -47, -45, -43, -23, -53, 9.4, 221, -12.7, 285, -8.8, 303, -7.8, 80, 80, 154, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.4, 4.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Печора'),
          -50, -48, -46, -43, -23, -55, 8.3, 205, -11.7, 268, -7.9, 288, -6.8, 80, 80, 184, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 4.5, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Сыктывкар'),
          -41, -41, -39, -36, -18, -47, 7.5, 173, -9.6, 243, -5.6, 263, -4.5, 83, 82, 169, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Троицко-Печорск'),
          -46, -46, -43, -41, -21, -51, 8.2, 188, -11, 258, -6.9, 277, -5.8, 81, 80, 202, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.6, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Усть-Уса'),
          -46, -44, -43, -41, -21, -53, 7.9, 213, -11.6, 278, -7.9, 299, -6.7, 83, 83, 151, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.2, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Усть-Цильма'),
          -45, -44, -41, -39, -20, -52, 7.8, 202, -10.6, 270, -6.9, 290, -5.8, 82, 82, 166, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 4.8, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Усть-Щугор'),
          -53, -50, -49, -45, -25, -58, 10.0, 200, -12.0, 268, -7.9, 286, -6.8, 82, 82, 198, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.0, 3.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Коми' AND localities.name = 'Ухта'),
          -46, -44, -41, -39, -22, -49, 7.4, 189, -10.4, 261, -6.4, 280, -5.4, 83, 83, 161, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.8, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Костромская область' AND localities.name = 'Кострома'),
          -40, -35, -34, -31, -17, -46, 6.5, 154, -7.4, 222, -3.9, 239, -3.0, 85, 81, 169, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.8, 4.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Костромская область' AND localities.name = 'Чухлома'),
          -41, -37, -36, -32, -18, -46, 6.9, 160, -7.9, 230, -4.3, 248, -3.3, 85, 84, 175, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 3.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Костромская область' AND localities.name = 'Шарья'),
          -40, -37, -36, -32, -18, -44, 6.9, 162, -8.3, 228, -4.7, 245, -3.7, 86, 85, 273, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.5, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Краснодарский край' AND localities.name = 'Красная Поляна'),
          -14, -12, -11, -9, -4, -23, 7.9, 0, NULL, 155, 3.0, 181, 3.8, 83, 80, 998, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), NULL, 1.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Краснодарский край' AND localities.name = 'Краснодар'),
          -23, -20, -21, -16, -5, -36, 7.0, 41, -0.2, 145, 2.5, 165, 3.3, 81, 74, 290, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 3.7, 2.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Краснодарский край' AND localities.name = 'Приморско-Ахтарск'),
          -27, -24, -23, -20, -16, -30, 6.0, 80, -1.9, 159, 1.0, 175, 1.8, 85, 75, 232, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, 4.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Краснодарский край' AND localities.name = 'Сочи'),
          -7, -5, -3, -2, 3, -13, 6.2, 0, NULL, 94, 6.6, 129, 7.2, 72, 68, 789, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 2.5, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Краснодарский край' AND localities.name = 'Тихорецк'),
          -26, -22, -21, -17, -6, -32, 6.5, 73, -1.7, 156, 1.2, 172, 1.9, 85, 78, 242, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 3.9, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Агата'),
          -57, -55, -54, -53, -38, -59, 9.9, 233, -22, 292, -16.7, 307, -15.5, 74, 75, 124, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.9, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Ачинск'),
          -44, -39, -41, -36, -21, -60, 7.2, 175, -10.6, 232, -7, 250, -5.8, 75, 72, 93, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.8, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Байкит'),
          -54, -53, -51, -50, -34, -57, 8.6, 211, -18.8, 266, -14.1, 280, -12.9, 77, 76, 146, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 1.8, 1.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Боготол'),
          -46, -43, -43, -39, -22, -53, 7.8, 178, -11.5, 239, -7.6, 257, -6.4, 77, 75, 106, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 4.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Богучаны'),
          -51, -48, -49, -45, -27, -54, 9.6, 186, -15.3, 244, -10.7, 259, -9.6, 79, 77, 78, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.2, 1.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Ванавара'),
          -56, -55, -52, -50, -33, -61, 12.4, 206, -18.7, 260, -14, 274, -12.8, 78, 77, 103, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.4, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Вельмо'),
          -55, -54, -52, -49, -33, -59, 13.2, 207, -17.1, 264, -12.5, 280, -11.3, 79, 79, 184, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Верхнеимбатск'),
          -55, -51, -51, -48, -28, -57, 7.9, 212, -15.7, 265, -11.7, 280, -10.6, 80, 80, 182, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.2, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Волочанка'),
          -56, -53, -53, -49, -34, -59, 9.1, 252, -21, 300, -17, 316, -15.6, 76, 77, 93, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 6.5, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Диксон'),
          -44, -43, -42, -40, -29, -48, 6.8, 267, -17.4, 365, -11.5, 365, -11.5, 84, 84, 130, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 9.6, 6.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Дудинка'),
          -53, -50, -47, -46, -31, -57, 8.3, 247, -19, 296, -15.2, 310, -14.1, 74, 74, 202, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 6.7, 5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Енисейск'),
          -53, -49, -50, -46, -27, -59, 11.5, 187, -13.9, 245, -9.6, 262, -8.4, 79, 78, 141, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.7, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Ессей'),
          -57, -56, -56, -55, -39, -59, 10.5, 245, -23.1, 296, -18.4, 311, -17.1, 79, 78, 39, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 3.1, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Игарка'),
          -54, -52, -50, -49, -31, -57, 8.4, 233, -22, 292, -16.7, 307, -15.5, 76, 76, 157, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.4, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Канск'),
          -48, -46, -45, -42, -25, -51, 10.4, 178, -13.1, 237, -8.8, 254, -7.7, 77, 75, 80, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 7.3, 3.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Кежма'),
          -54, -52, -51, -48, -32, -60, 11.9, 196, -17.0, 252, -12.3, 268, -11.1, 78, 77, 79, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.5, 2.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Ключи'),
          -45, -43, -40, -39, -23, -50, 9.1, 177, -11.5, 240, -7.4, 257, -6.3, 75, 71, 156, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Красноярск'),
          -42, -39, -40, -37, -20, -48, 8.4, 171, -10.7, 233, -6.7, 250, -5.7, 78, 75, 104, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.3, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Минусинск'),
          -44, -41, -41, -40, -24, -52, 12.1, 163, -12.2, 221, -7.9, 238, -6.7, 77, 72, 46, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.1, 1.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Таимба'),
          -55, -53, -53, -51, -35, -58, 12.6, 207, -18.5, 264, -13.6, 280, -12.3, 76, 73, 101, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, 1.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Троицкое'),
          -51, -50, -49, -47, -28, -57, 13.1, 188, -14.4, 251, -9.8, 268, -8.6, 76, 73, 121, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 1.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Тура'),
          -56, -55, -54, -53, -40, -59, 8.5, 218, -22.3, 270, -17.2, 283, -16, 77, 77, 81, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 1.9, 1.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Туруханск'),
          -54, -52, -49, -49, -30, -61, 8.3, 225, -17.1, 274, -13.3, 289, -12.1, 75, 76, 174, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.2, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Хатанга'),
          -55, -52, -52, -49, -36, -59, 7.8, 255, -22.2, 304, -18, 319, -16.7, 76, 76, 71, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.2, 4.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Челюскин, мыс'),
          -46, -44, -44, -41, -33, -49, 7.0, 311, -17.3, 365, -14.7, 365, -14.7, 84, 84, NULL, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 9.3, 6.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Красноярский край' AND localities.name = 'Ярцево'),
          -53, -50, -50, -47, -29, -56, 9.9, 198, -14.9, 254, -10.8, 270, -9.6, 79, 78, 170, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 4.7, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Курганская область' AND localities.name = 'Курган'),
          -42, -40, -39, -36, -21, -48, 8.5, 161, -11.3, 212, -7.6, 229, -6.3, 80, 79, 89, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.6, 4.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Курская область' AND localities.name = 'Курск'),
          -29, -27, -24, -24, -12, -35, 5.6, 132, -5.3, 194, -2.3, 211, -1.4, 85, 83, 217, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.9, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Липецкая область' AND localities.name = 'Липецк'),
          -34, -31, -29, -27, -15, -38, 6.8, 141, -6.6, 202, -3.4, 218, -2.5, 85, 84, 248, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.9, 4.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ленинградская область' AND localities.name = 'Санкт-Петербург'),
          -32, -27, -28, -24, -11, -36, 5.3, 131, -4.6, 213, -1.3, 232, -0.4, 86, 84, 202, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.3, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ленинградская область' AND localities.name = 'Свирица'),
          -37, -34, -32, -29, -15, -48, 7.1, 152, -6.4, 228, -2.9, 249, -1.9, 86, 86, 231, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.5, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ленинградская область' AND localities.name = 'Тихвин'),
          -37, -34, -33, -29, -13, -51, 7, 148, -6.2, 223, -2.7, 243, -1.8, 86, 85, 257, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.3, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Магаданская область' AND localities.name = 'Аркагала'),
          -56, -54, -54, -51, -42, -58, 7.5, 238, -24.1, 289, -19.0, 304, -17.7, 73, 72, 45, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 6.4, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Магаданская область' AND localities.name = 'Брохово'),
          -41, -37, -37, -35, -23, -46, 7.1, 214, -13.3, 278, -9.3, 299, -8, 78, 77, 211, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 9.8, 5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Магаданская область' AND localities.name = 'Магадан (Нагаева, бухта)'),
          -31, -30, -31, -29, -20, -35, 4.5, 210, -11.3, 279, -7.5, 302, -6.2, 64, 63, 114, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 4.6, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Магаданская область' AND localities.name = 'Омсукчан'),
          -56, -53, -54, -50, -38, -56, 8.0, 234, -21.9, 286, -17.2, 301, -15.9, 74, 74, 80, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 6.9, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Магаданская область' AND localities.name = 'Палатка'),
          -46, -41, -44, -38, -27, -44, 9.1, 222, -14.6, 280, -10.7, 301, -9.3, 69, 69, 77, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 7.6, 3.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Магаданская область' AND localities.name = 'Среднекан'),
          -58, -53, -55, -52, -42, -56, 6.3, 229, -23.9, 274, -19.3, 287, -17.9, 77, 76, 160, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 2.0, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Магаданская область' AND localities.name = 'Сусуман'),
          -58, -57, -56, -54, -41, -61, 8.2, 231, -25.5, 274, -20.8, 292, -19, 75, 73, 50, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 3.6, 1.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Марий Эл' AND localities.name = 'Йошкар-Ола'),
          -41, -37, -36, -33, -17, -47, 7.2, 154, -8.4, 215, -4.9, 232, -3.8, 83, 83, 160, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.9, 4.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Мордовия' AND localities.name = 'Саранск'),
          -38, -34, -34, -30, -17, -44, 6.7, 150, -7.9, 209, -4.5, 225, -3.6, 83, 83, 155, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 6.9, 5.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Московская область' AND localities.name = 'Дмитров'),
          -36, -33, -32, -28, -15, -43, 6.3, 147, -6.5, 216, -3.1, 235, -2.2, 84, 84, 183, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.2, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Московская область' AND localities.name = 'Кашира'),
          -36, -32, -31, -27, -16, -44, 6.3, 147, -6.7, 212, -3.4, 229, -2.5, 85, 85, 167, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, 5.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Московская область' AND localities.name = 'Москва'),
          -35, -28, -29, -25, -13, -43, 5.4, 135, -5.5, 205, -2.2, 223, -1.3, 83, 82, 225, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2, 2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Московская область' AND localities.name = 'Новомосковский АО'),
          NULL, NULL, NULL, NULL, NULL, -44, 6.7, 141, -5.7, 212, -2.4, 230, -1.5, 84, 76, 186, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.0, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Московская область' AND localities.name = 'Троицкий АО'),
          -36, -31, -31, -26, -14, -42, 6.7, 140, -6.0, 211, -2.6, 229, -1.7, 84, 81, 209, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.9, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Вайда-Губа'),
          -23, -20, -19, -16, -9, -27, 5.4, 180, -3.7, 287, -0.8, 321, 0.3, 85, 84, 217, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 8.8, 7.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Кандалакша'),
          -38, -35, -34, -30, -15, -44, 8.6, 190, -8.1, 265, -4.6, 285, -3.7, 85, 86, 164, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 3.3, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Ковдор'),
          -41, -38, -36, -35, -17, -44, 7.9, 198, -8.2, 271, -4.9, 293, -3.9, 84, 83, 159, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.7, 2.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Краснощелье'),
          -42, -40, -37, -35, -17, -49, 9.3, 204, -8.9, 279, -5.4, 301, -4.3, 86, 86, 141, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.6, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Ловозеро'),
          -40, -38, -33, -31, -19, -47, 10.3, 204, -8.5, 281, -5.0, 304, -4.0, 85, 85, 114, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.9, 3.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Мончегорск'),
          -40, -38, -34, -30, -18, -44, 9.5, 193, -7.9, 271, -4.5, 291, -3.6, 84, 84, 126, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.7, 4.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Мурманск'),
          -35, -33, -32, -30, -14, -39, 6.5, 189, -6.9, 275, -3.4, 300, -2.4, 84, 84, 138, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.6, 4.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Ниванкюль'),
          -46, -40, -38, -36, -18, -45, 9.0, 191, -8.2, 271, -4.6, 292, -3.6, 83, 83, 169, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Пулозеро'),
          -44, -39, -40, -35, -19, -47, 9.3, 198, -8.3, 277, -4.8, 299, -3.8, 84, 81, 129, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.5, 3.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Пялица'),
          -32, -29, -28, -25, -16, -38, 7.2, 194, -6.5, 298, -2.8, 354, -0.9, 86, 86, 133, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 5.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Териберка'),
          -26, -24, -23, -22, -11, -31, 5.8, 190, -5.2, 282, -2.2, 313, -1.1, 79, 79, 149, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 9.2, 7.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Терско-Орловский'),
          -29, -27, -24, -22, -16, -38, 6.5, 200, -6.3, 312, -2.5, 365, -0.9, 87, 87, 134, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 7.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Умба'),
          -37, -34, -32, -31, -15, -40, 7.1, 187, -7.3, 263, -4, 284, -3.1, 86, 85, 164, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 4.7, 3.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Мурманская область' AND localities.name = 'Юкспор'),
          -31, -26, -27, -24, -18, -35, 4.8, 243, -8.1, 340, -4.5, 365, -3.7, 92, 91, 389, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 5.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Нижегородская область' AND localities.name = 'Арзамас'),
          -40, -36, -35, -32, -17, -43, 7.0, 156, -8.1, 216, -4.7, 232, -3.8, 85, 84, 238, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 7.5, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Нижегородская область' AND localities.name = 'Выкса'),
          -38, -34, -33, -30, -16, -45, 6.9, 149, -7.3, 212, -4.0, 228, -3.1, 85, 82, 232, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Нижегородская область' AND localities.name = 'Нижний Новгород'),
          -38, -34, -34, -31, -17, -41, 6.1, 151, -7.5, 215, -4.1, 231, -3.2, 84, 80, 172, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.1, 3.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новгородская область' AND localities.name = 'Боровичи'),
          -39, -34, -32, -29, -13, -54, 6.6, 145, -6.4, 220, -2.8, 239, -1.8, 85, 83, 144, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.9, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новгородская область' AND localities.name = 'Великий Новгород'),
          -38, -31, -33, -27, -14, -45, 6.8, 143, -5.7, 221, -2.3, 239, -1.4, 85, 85, 176, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 6.6, 4.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новосибирская область' AND localities.name = 'Барабинск'),
          -44, -42, -42, -39, -25, -48, 9.2, 177, -12.9, 230, -9, 243, -8, 82, 81, 104, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 6.5, 6.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новосибирская область' AND localities.name = 'Болотное'),
          -42, -42, -40, -39, -22, -51, 8.1, 173, -11.7, 228, -7.9, 246, -6.6, 80, 77, 123, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.9, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новосибирская область' AND localities.name = 'Карасук'),
          -42, -41, -40, -37, -24, -46, 9.5, 169, -12.7, 218, -8.9, 232, -7.8, 80, 79, 68, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новосибирская область' AND localities.name = 'Кочки'),
          -45, -42, -43, -39, -25, -50, 9.3, 175, -12.9, 228, -8.9, 242, -7.9, 81, 80, 90, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новосибирская область' AND localities.name = 'Купино'),
          -42, -41, -40, -38, -23, -47, 8.7, 167, -12.6, 215, -8.9, 232, -7.6, 80, 79, 65, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.7, 4.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новосибирская область' AND localities.name = 'Кыштовка'),
          -46, -43, -42, -40, -25, -52, 9.9, 176, -12.9, 231, -8.9, 248, 7.7, 80, 78, 87, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новосибирская область' AND localities.name = 'Новосибирск'),
          -43, -41, -41, -37, -22, -50, 9, 169, -11.8, 221, -8.1, 238, -6.9, 79, 76, 104, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.7, 3.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новосибирская область' AND localities.name = 'Татарск'),
          -43, -41, -40, -38, -23, -50, 8.7, 168, -12.2, 220, -8.3, 236, -7.1, 81, 80, 88, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.7, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Новосибирская область' AND localities.name = 'Чулым'),
          -44, -42, -42, -39, -25, -52, 9.2, 177, -12.7, 230, -8.8, 244, -7.8, 80, 79, 111, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 6.2, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Омская область' AND localities.name = 'Исилькуль'),
          -43, -40, -39, -36, -24, -46, 9.4, 174, -12.3, 225, -8.6, 238, -7.7, 82, 80, 78, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.2, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Омская область' AND localities.name = 'Омск'),
          -42, -40, -38, -37, -22, -49, 8.6, 165, -11.9, 216, -8.1, 232, -6.9, 80, 78, 104, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 2.8, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Омская область' AND localities.name = 'Тара'),
          -46, -43, -41, -38, -23, -50, 9.3, 171, -12.4, 229, -8.2, 245, -7, 78, 78, 97, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3, 3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Омская область' AND localities.name = 'Черлак'),
          -41, -40, -39, -37, -22, -44, 8.4, 164, -12.3, 211, -8.7, 227, -7.4, 82, 81, 98, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.4, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Оренбургская область' AND localities.name = 'Кувандык'),
          -41, -38, -34, -30, -20, -44, 8.1, 153, -10.6, 204, -6.9, 217, -6.0, 76, 74, 169, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 5.7, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Оренбургская область' AND localities.name = 'Оренбург'),
          -36, -34, -34, -32, -18, -43, 7.8, 149, -9.2, 195, -6.1, 208, -5.1, 79, 77, 134, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 5.9, 4.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Оренбургская область' AND localities.name = 'Сорочинск'),
          -36, -34, -33, -29, -20, -43, 8.1, 153, -9.6, 201, -6.3, 215, -5.3, 81, 79, 116, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 7.6, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Орловская область' AND localities.name = 'Орел'),
          -31, -29, -26, -25, -13, -39, 6, 135, -5.5, 199, -2.4, 216, -1.5, 84, 82, 178, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.7, 4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Пензенская область' AND localities.name = 'Земетчино'),
          -37, -34, -30, -28, -15, -43, 6.9, 142, -7, 200, -3.8, 216, -2.9, 85, 84, 179, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.3, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Пензенская область' AND localities.name = 'Пенза'),
          -34, -31, -29, -27, -15, -43, 6.5, 143, -7.3, 200, -4.1, 214, -3.2, 83, 82, 221, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.4, 3.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Пермский край' AND localities.name = 'Бисер'),
          -44, -39, -38, -35, -23, -53, 7.1, 183, -10.7, 250, -6.7, 270, -5.6, 85, 86, 264, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.8, 3.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Пермский край' AND localities.name = 'Ножовка'),
          -44, -42, -40, -36, -21, -50, 7.1, 164, -9.6, 221, -6.1, 237, -5.1, 80, 77, 183, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Пермский край' AND localities.name = 'Пермь'),
          -42, -38, -36, -35, -18, -47, 7.1, 161, -9.3, 225, -5.5, 243, -4.4, 82, 81, 181, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.4, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Пермский край' AND localities.name = 'Чердынь'),
          -45, -42, -40, -37, -22, -52, 6.9, 176, -10.9, 245, -6.7, 261, -5.7, 86, 83, 229, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 4.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Агзу'),
          -34, -32, -30, -28, -16, -43, 16.1, 165, -12.8, 231, -7.9, 249, -6.6, 69, 64, 116, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 1.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Анучино'),
          -35, -33, -33, -31, -25, -44, 16.6, 152, -12.2, 203, -8.1, 219, -6.8, 73, 59, 120, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Астраханка'),
          -30, -29, -28, -26, -23, -40, 10.6, 148, -10.5, 202, -6.6, 218, -5.5, 68, 63, 47, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Богополь'),
          -26, -25, -23, -21, -18, -30, 9.3, 142, -8.1, 208, -4.2, 229, -2.9, 52, 46, 101, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Владивосток'),
          -27, -24, -24, -23, -16, -31, 7.5, 136, -8.2, 198, -4.3, 220, -3, 59, 52, 89, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 7.3, 5.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Дальнереченск'),
          -33, -30, -29, -29, -23, -42, 10.4, 151, -12.8, 199, -8.7, 214, -7.5, 73, 64, 82, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.9, 3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Кировский'),
          -37, -35, -34, -31, -25, -44, 13.7, 151, -13.3, 201, -8.8, 217, -7.5, 73, 69, 98, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 2.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Красный Яр'),
          -39, -36, -35, -34, -25, -47, 17.1, 164, -14.7, 217, -10.0, 234, -8.6, 75, 66, 129, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 1.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Маргаритово'),
          -26, -25, -22, -21, -14, -36, 14.7, 144, -8.0, 209, -4.1, 227, -3.0, 58, 52, 147, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 2.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Мельничное'),
          -35, -34, -32, -31, -26, -49, 16.1, 165, -14.3, 221, -9.6, 239, -8.2, 73, 63, 97, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.2, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Партизанск'),
          -26, -24, -23, -22, -18, -30, 9.9, 139, -8.2, 198, -4.5, 216, -3.4, 54, 47, 128, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 8.4, 5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Посьет'),
          -23, -22, -20, -19, -14, -27, 8.3, 125, -6.4, 187, -2.9, 207, -1.7, 53, 49, 67, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 6.7, 4.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Преображение'),
          -22, -20, -18, -16, -12, -27, 9.3, 123, -5.3, 202, -1.6, 229, -0.3, 45, 42, 123, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 3.7, 3.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Рудная Пристань'),
          -23, -22, -21, -19, -15, -31, 9.9, 137, -7.3, 215, -3.1, 240, -1.9, 47, 43, 119, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.6, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Сосуново'),
          -26, -24, -23, -22, -14, -30, 9.4, 153, -8.7, 245, -3.8, 266, -2.7, 53, 47, 76, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, 6.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Приморский край' AND localities.name = 'Чугуевка'),
          -36, -35, -33, -32, -26, -47, 17.2, 158, -12.9, 211, -8.6, 227, -7.3, 76, 65, 129, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 1.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Псковская область' AND localities.name = 'Великие Луки'),
          -34, -30, -29, -27, -12, -46, 6.3, 130, -4.9, 208, -1.5, 228, -0.6, 83, 81, 174, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.2, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Псковская область' AND localities.name = 'Псков'),
          -35, -29, -28, -26, -10, -41, 6.8, 130, -4.6, 208, -1.3, 229, -0.4, 83, 78, 198, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.5, 3.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ростовская область' AND localities.name = 'Миллерово'),
          -27, -25, -23, -21, -11, -36, 6.1, 118, -4.6, 179, -1.7, 195, -0.8, 83, 81, 192, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 6.1, 4.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ростовская область' AND localities.name = 'Ростов-на-Дону'),
          -25, -23, -22, -19, -9, -33, 5.2, 97, -2.8, 166, -0.1, 182, 0.7, 82, 77, 219, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 4.8, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ростовская область' AND localities.name = 'Таганрог'),
          -24, -22, -21, -18, -8, -32, 5.1, 97, -2.6, 165, 0, 180, 0.8, 85, 82, 232, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 4, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Рязанская область' AND localities.name = 'Рязань'),
          -36, -33, -30, -27, -16, -41, 7, 145, -6.8, 208, -3.5, 224, -2.6, 83, 84, 172, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 7.3, 4.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Самарская область' AND localities.name = 'Самара'),
          -39, -36, -36, -30, -18, -43, 6.7, 149, -8.5, 203, -5.2, 217, -4.3, 84, 78, 176, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 5.4, 4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Саратовская область' AND localities.name = 'Александров Гай'),
          -31, -30, -29, -28, -17, -40, 8.3, 141, -8.3, 191, -5.2, 204, -4.2, 82, 79, 127, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, 4.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Саратовская область' AND localities.name = 'Балашов'),
          -34, -33, -32, -29, -16, -38, 6.5, 142, -7.4, 199, -4.2, 213, -3.2, 84, 82, 171, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 7.3, 5.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Саратовская область' AND localities.name = 'Саратов'),
          -32, -28, -29, -25, -14, -37, 5.9, 134, -6.5, 188, -3.5, 202, -2.6, 80, 80, 183, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 4.4, 3.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Александровск-Сахалинский'),
          -31, -29, -28, -27, -21, -41, 8.4, 167, -10.9, 237, -6.4, 257, -5.2, 79, 73, 189, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 5.9, 4.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Долинск'),
          -29, -27, -25, -24, -18, -35, 10.1, 154, -8.1, 231, -4.0, 253, -2.9, 78, 67, 348, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.6, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Кировское'),
          -40, -39, -38, -36, -29, -48, 14.4, 183, -13.9, 246, -9.2, 263, -8.0, 79, 77, 172, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 5.7, 2.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Корсаков'),
          -25, -23, -23, -20, -16, -33, 8.0, 147, -6.7, 232, -2.7, 255, -1.9, 76, 66, 223, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 5.6, 4.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Курильск'),
          -20, -16, -18, -15, -10, -27, 6.4, 126, -3.9, 223, -0.4, 253, 0.7, 82, 79, 466, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 9.5, 6.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Макаров'),
          -27, -26, -24, -23, -19, -32, 8.6, 158, -8.6, 241, -4.2, 264, -3, 66, 59, 212, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Невельск'),
          -20, -18, -17, -16, -12, -25, 4.8, 140, -5.6, 219, -2.1, 241, -1.1, 74, 72, 332, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 7.4, 6.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Ноглики'),
          -32, -32, -30, -30, -23, -48, 8.9, 182, -11.7, 254, -7.2, 274, -6, 76, 69, 188, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 5.3, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Оха'),
          -34, -32, -31, -29, -25, -39, 6.8, 194, -11.5, 266, -7.3, 286, -6.1, 81, 81, 192, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 11.2, 5.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Погиби'),
          -34, -33, -31, -30, -24, -44, 7.7, 190, -12.6, 249, -8.7, 265, -7.6, 82, 79, 152, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 6.1, 4.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Поронайск'),
          -30, -28, -27, -26, -20, -40, 9.9, 166, -10.5, 245, -5.8, 267, -4.6, 70, 63, 172, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 3.9, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Рыбновск'),
          -38, -36, -35, -33, -27, -45, 8.5, 193, -13.1, 255, -8.9, 272, -7.3, 84, 84, 135, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 5.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Холмск'),
          -22, -21, -19, -18, -15, -25, 5.9, 140, -6.0, 220, -2.3, 244, -1.2, 75, 68, 305, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 10.7, 6.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Южно-Курильск'),
          -16, -15, -15, -13, -9, -20, 5.6, 119, -3.7, 225, 0, 253, 1, 73, 68, 347, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 6.8, 5.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Сахалинская область' AND localities.name = 'Южно-Сахалинск'),
          -25, -24, -24, -22, -17, -36, 10.7, 153, -8.5, 227, -4.4, 249, -3.2, 82, 70, 268, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 3.3, 2.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Свердловская область' AND localities.name = 'Верхотурье'),
          -45, -41, -40, -36, -20, -52, 9.2, 165, -10.8, 233, -6.4, 252, -5.3, 79, 78, 114, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.1, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Свердловская область' AND localities.name = 'Екатеринбург'),
          -41, -38, -37, -32, -18, -47, 6.8, 158, -9.2, 221, -5.4, 239, -4.3, 78, 75, 112, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.1, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Свердловская область' AND localities.name = 'Ивдель'),
          -46, -43, -42, -39, -22, -49, 10.6, 176, -12.2, 245, -7.6, 264, -6.4, 78, 77, 114, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 2.8, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Свердловская область' AND localities.name = 'Каменск-Уральский'),
          -42, -40, -38, -35, -20, -46, 8.5, 166, -10.7, 222, -6.9, 240, -5.7, 78, 76, 116, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Свердловская область' AND localities.name = 'Туринск'),
          -44, -42, -40, -35, -21, -51, 9.9, 169, -11.7, 226, -7.7, 245, -6.4, 80, 77, 106, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Свердловская область' AND localities.name = 'Шамары'),
          -42, -40, -38, -35, -20, -51, 8.0, 171, -10.4, 235, -6.4, 254, -5.2, 82, 78, 205, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Северная Осетия - Алания' AND localities.name = 'Владикавказ'),
          -19, -17, -15, -13, -7, -28, 9.1, 90, -2.1, 169, 0.7, 189, 1.6, 81, 69, 176, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Смоленская область' AND localities.name = 'Вязьма'),
          -35, -32, -29, -27, -15, -43, 6.3, 145, -6.1, 217, -2.8, 236, -1.8, 87, 86, 284, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), NULL, 4.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Смоленская область' AND localities.name = 'Смоленск'),
          -33, -28, -26, -25, -12, -40, 5.6, 136, -5.3, 209, -2, 227, -1.1, 86, 85, 234, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.9, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ставропольский край' AND localities.name = 'Арзгир'),
          -30, -26, -25, -22, -10, -37, 6.2, 88, -3.0, 163, 0.1, 180, 1.0, 86, 83, 115, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 4.6, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ставропольский край' AND localities.name = 'Кисловодск'),
          -22, -20, -18, -16, -6, -29, 9.4, 91, -2.4, 179, 0.4, 201, 1.6, 70, 56, NULL, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 2.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ставропольский край' AND localities.name = 'Невинномысск'),
          -23, -21, -20, -18, -6, -36, 8.0, 92, -3.2, 168, 0.1, 186, 1.0, 84, 81, 152, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ставропольский край' AND localities.name = 'Пятигорск'),
          -26, -23, -22, -20, -7, -33, 8.3, 97, -2.7, 175, 0.2, 191, 0.9, 83, 73, 114, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 6.3, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ставропольский край' AND localities.name = 'Ставрополь'),
          -25, -23, -22, -18, -6, -31, 6.6, 91, -2.2, 168, 0.5, 185, 1.3, 84, 78, 159, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 7.4, 4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тамбовская область' AND localities.name = 'Тамбов'),
          -34, -32, -30, -28, -16, -39, 6.7, 140, -7, 201, -3.7, 217, -2.7, 84, 83, 194, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 4.7, 4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Татарстан (Татарстан)' AND localities.name = 'Бугульма'),
          -40, -36, -36, -33, -19, -47, 6.7, 164, -9.2, 221, -5.8, 235, -4.9, 86, 85, 264, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 7.5, 5.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Татарстан (Татарстан)' AND localities.name = 'Елабуга'),
          -40, -36, -34, -32, -17, -47, 7.1, 152, -8.7, 209, -5.2, 223, -4.3, 82, 81, 177, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.1, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Татарстан (Татарстан)' AND localities.name = 'Казань'),
          -41, -33, -33, -31, -16, -47, 6.5, 151, -8.1, 208, -4.8, 223, -3.8, 83, 82, 171, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.8, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тверская область' AND localities.name = 'Бежецк'),
          -38, -34, -34, -31, -16, -52, 6.8, 151, -6.8, 222, -3.4, 240, -2.4, 84, 84, 169, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.0, 4.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тверская область' AND localities.name = 'Ржев'),
          -37, -33, -31, -28, -15, -47, 6.6, 144, -6.1, 217, -2.7, 236, -1.8, 85, 85, 210, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тверская область' AND localities.name = 'Тверь'),
          -37, -33, -33, -29, -15, -50, 7.2, 146, -6.4, 218, -3.0, 236, -2.0, 85, 85, 206, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 6.2, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Томская область' AND localities.name = 'Александровское'),
          -49, -46, -44, -43, -25, -53, 9, 196, -13.4, 252, -9.5, 269, -8.4, 81, 81, 114, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.9, 3.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Томская область' AND localities.name = 'Колпашево'),
          -47, -45, -43, -42, -24, -51, 8.6, 185, -12.9, 243, -8.8, 260, -7.7, 80, 80, 123, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.1, 2.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Томская область' AND localities.name = 'Средний Васюган'),
          -47, -46, -44, -41, -23, -51, 8.6, 185, -12.8, 243, -8.8, 260, -7.6, 81, 80, 136, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.2, 2.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Томская область' AND localities.name = 'Томск'),
          -44, -43, -41, -39, -22, -55, 8.2, 176, -11.8, 233, -7.9, 249, -6.8, 79, 78, 171, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.4, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Томская область' AND localities.name = 'Усть-Озерное'),
          -48, -47, -44, -43, -25, -52, 9, 190, -13.5, 249, -9.3, 264, -8.3, 80, 80, 155, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.8, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Тыва' AND localities.name = 'Кызыл'),
          -49, -48, -48, -47, -37, -54, 10.9, 178, -20.1, 225, -15, 238, -13.7, 73, 69, 58, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 1.7, 1.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тульская область' AND localities.name = 'Тула'),
          -35, -31, -30, -27, -15, -42, 6.8, 140, -6.4, 207, -3, 224, -2.1, 83, 82, 187, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 4.9, 4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ханты-Мансийский автономный округ - Юрга' AND localities.name = 'Березово'),
          -50, -45, -45, -42, -25, -53, 8.8, 208, -13.8, 266, -9.9, 284, -8.7, 81, 81, 131, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.9, 4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ханты-Мансийский автономный округ - Юрга' AND localities.name = 'Кондинское'),
          -47, -44, -44, -40, -25, -49, 8.9, 183, -12.3, 238, -8.6, 256, -7.4, 84, 84, 107, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.7, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ханты-Мансийский автономный округ - Юрга' AND localities.name = 'Сургут'),
          -48, -47, -45, -43, -27, -55, 9.7, 200, -13.8, 257, -9.9, 274, -8.8, 79, 78, 209, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 5.3, 5.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ханты-Мансийский автономный округ - Юрга' AND localities.name = 'Ханты-Мансийск'),
          -46, -45, -44, -40, -25, -49, 8.3, 191, -12.6, 247, -8.8, 264, -7.6, 82, 83, 139, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.1, 2.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ямало-Ненецкий автономный округ' AND localities.name = 'Тарко-Сале'),
          -54, -50, -49, -47, -28, -55, 8.9, 227, -16.1, 274, -12.6, 290, -11.4, 79, 79, 137, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.7, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ямало-Ненецкий автономный округ' AND localities.name = 'Новый Уренгой'),
          -53, -50, -49, -46, -31, -56, 9.9, 236, -16.8, 286, -13.1, 304, -11.8, 78, 78, 117, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Демьянское'),
          -47, -45, -44, -40, -24, -51, 8.4, 179, -12.1, 241, -8.0, 258, -6.8, 81, 80, 115, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.6, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Леуши'),
          -45, -43, -41, -37, -21, -48, 7.9, 176, -11.4, 237, -7.4, 255, -6.3, 80, 79, 115, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.9, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Марресаля'),
          -46, -45, -42, -39, -24, -50, 8, 249, -14.4, 365, -8, 365, -8, 82, 81, 91, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 7.7, 6.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Надым'),
          -52, -49, -47, -45, -28, -58, 8.8, 225, -15.3, 278, -11.5, 294, -10.4, 80, 79, 118, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.5, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Октябрьское'),
          -46, -45, -44, -41, -26, -54, 7.9, 199, -12.9, 257, -9.1, 276, -7.8, 82, 83, 159, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 2.8, 2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Салехард'),
          -49, -47, -45, -43, -27, -54, 9.2, 228, -15.5, 285, -11.5, 303, -10.3, 82, 82, 106, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.6, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Сосьва'),
          -51, -48, -49, -44, -28, -55, 11.3, 198, -13.9, 261, -9.5, 280, -8.3, 80, 80, 127, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Тобольск'),
          -47, -43, -44, -39, -23, -52, 9.1, 171, -12.2, 232, -7.9, 248, -6.8, 81, 80, 110, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.2, 3.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Тюмень'),
          -44, -41, -42, -35, -20, -50, 8.8, 163, -10.9, 223, -6.9, 241, -5.7, 79, 77, 107, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3, 2.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Тюменская область' AND localities.name = 'Угут'),
          -49, -46, -45, -42, -26, -54, 9.4, 191, -13.3, 251, -9.1, 270, -7.9, 82, 80, 123, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.4, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Удмуртская Республика' AND localities.name = 'Глазов'),
          -42, -39, -38, -35, -20, -50, 8, 168, -9.7, 231, -6, 247, -5, 85, 84, 248, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.9, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Удмуртская Республика' AND localities.name = 'Ижевск'),
          -41, -36, -35, -33, -18, -48, 7.2, 160, -9.1, 219, -5.6, 236, -4.6, 83, 82, 152, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.5, 4.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Удмуртская Республика' AND localities.name = 'Сарапул'),
          -40, -36, -35, -33, -17, -48, 7.2, 159, -9, 215, -5.6, 231, -4.6, 82, 82, 178, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.6, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ульяновская область' AND localities.name = 'Сурское'),
          -39, -36, -36, -31, -18, -46, 9.3, 152, -8.2, 211, -4.8, 226, -3.9, 81, 80, 140, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ульяновская область' AND localities.name = 'Ульяновск'),
          -38, -36, -36, -31, -19, -48, 7.4, 155, -8.9, 212, -5.4, 228, -4.4, 82, 81, 220, NULL, NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Аян'),
          -33, -31, -30, -28, -24, -37, 7.2, 203, -11.7, 278, -7.4, 300, -6.2, 50, 47, 129, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 3.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Байдуков'),
          -37, -35, -34, -31, -27, -44, 7.6, 198, -12.8, 255, -9.0, 271, -7.9, 81, 80, NULL, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 5.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Бикин'),
          -38, -34, -35, -32, -27, -46, 12.8, 159, -13.3, 208, -9.1, 223, -7.8, 76, 66, 96, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.2, 2.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Бира'),
          -37, -35, -34, -31, -27, -43, 11.0, 166, -13.4, 220, -9.1, 234, -7.9, 70, 64, 85, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Биробиджан'),
          -38, -34, -35, -32, -28, -43, 14.9, 169, -14.8, 219, -10.4, 234, -9.2, 74, 65, 84, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Вяземский'),
          -38, -34, -34, -31, -27, -48, 11.9, 163, -13.5, 213, -9.3, 227, -8.1, 74, 66, 114, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.1, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Гвасюги'),
          -39, -37, -37, -35, -30, -52, 17.3, 174, -14.9, 228, -10.4, 242, -9.2, 77, 64, 128, NULL, NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Гроссевичи'),
          -26, -25, -23, -22, -20, -36, 8.7, 161, -8.8, 248, -4.3, 270, -3.2, 54, 47, NULL, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Де-Кастри'),
          -30, -29, -28, -27, -24, -39, 7.8, 183, -11.4, 256, -6.9, 276, -5.8, 68, 61, 131, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Джаорэ'),
          -36, -32, -33, -30, -25, -42, 7.7, 191, -11.7, 252, -7.9, 268, -7, 70, 65, NULL, NULL, NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Екатерино-Никольское'),
          -34, -31, -32, -29, -24, -40, 10.4, 158, -13.2, 204, -9.3, 220, -8, 69, 63, 46, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 4.4, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Комсомольск-на-Амуре'),
          -38, -37, -37, -35, -31, -45, 9.9, 171, -15.4, 223, -10.8, 238, -9.5, 79, 77, 93, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.7, 3.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Нижнетамбовское'),
          -40, -38, -38, -36, -31, -53, 13.7, 175, -15.5, 229, -10.9, 244, -9.6, 78, 72, 119, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Николаевск-на-Амуре'),
          -39, -36, -36, -33, -27, -47, 8, 187, -14.4, 245, -10.1, 261, -8.9, 77, 75, 193, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.8, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Облучье'),
          -40, -39, -37, -36, -31, -46, 13.1, 176, -16.2, 227, -11.5, 241, -10.4, 79, 70, 82, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Охотск'),
          -37, -34, -33, -32, -25, -40, 5.7, 207, -14.1, 274, -9.6, 293, -8.4, 62, 62, 74, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 3.9, 3.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Им.Полины Осипенко'),
          -43, -43, -42, -40, -32, -52, 13.1, 179, -17.4, 232, -12.5, 248, -11.1, 77, 72, 63, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 3.5, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Сизиман'),
          -30, -29, -28, -26, -23, -43, 11.6, 181, -10.8, 263, -6.2, 283, -5.1, 65, 53, 133, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, 3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Советская Гавань'),
          -28, -27, -26, -24, -21, -40, 9.9, 162, -10.5, 234, -6, 254, -4.8, 65, 57, 153, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.2, 3.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Софийский Прииск'),
          -46, -45, -45, -44, -35, -51, 14.7, 206, -19.9, 262, -14.7, 280, -13.2, 74, 68, 59, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 1.7, 1.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Средний Ургал'),
          -43, -42, -41, -40, -36, -52, 12.1, 183, -18.4, 238, -13.3, 253, -11.9, 76, 69, 57, NULL, NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Троицкое'),
          -36, -34, -32, -31, -28, -47, 8.7, 166, -13.9, 217, -9.7, 231, -8.5, 74, 70, 137, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Хабаровск'),
          -34, -32, -32, -29, -25, -43, 7.7, 158, -13.6, 204, -9.5, 219, -8.3, 74, 67, 81, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.9, 3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Чумикан'),
          -35, -34, -34, -32, -29, -43, 5.3, 198, -13.8, 274, -8.8, 292, -7.7, 73, 71, NULL, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 10.3, 6.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Хабаровский край' AND localities.name = 'Энкэн'),
          -31, -30, -30, -28, -25, -41, 6.2, 206, -12.0, 281, -7.7, 303, -6.5, 48, 45, NULL, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 4.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Хакасия' AND localities.name = 'Абакан'),
          -42, -39, -40, -37, -23, -47, 10.9, 164, -12.3, 223, -7.9, 239, -6.8, 79, 76, 35, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.8, 2.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Хакасия' AND localities.name = 'Шира'),
          -43, -40, -39, -38, -24, -49, 10.5, 174, -11.9, 236, -7.7, 254, -6.6, 73, 70, 36, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.1, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Челябинская область' AND localities.name = 'Верхнеуральск'),
          -39, -38, -35, -34, -21, -48, 10.3, 170, -11.1, 221, -7.5, 242, -6.1, 78, 75, 81, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Челябинская область' AND localities.name = 'Нязепетровск'),
          -42, -40, -38, -35, -22, -52, 9.2, 172, -10.6, 229, -6.8, 248, -5.6, 81, 78, 149, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 2.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Челябинская область' AND localities.name = 'Челябинск'),
          -39, -38, -35, -34, -21, -48, 9.4, 162, -10.1, 218, -6.5, 233, -5.5, 78, 78, 104, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.5, 3.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чеченская Республика' AND localities.name = 'Грозный'),
          -23, -22, -20, -17, -7, -32, 7, 83, -1.8, 159, 0.9, 176, 1.7, 87, 80, 127, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.8, 2.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чувашская Республика - Чувашия' AND localities.name = 'Порецкое'),
          -39, -33, -32, -30, -15, -45, 6.9, 150, -7.8, 207, -4.5, 223, -3.5, 84, 84, 192, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.6, 4.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чувашская Республика - Чувашия' AND localities.name = 'Чебоксары'),
          -40, -36, -35, -32, -18, -44, 6.8, 156, -8.3, 217, -4.9, 232, -3.9, 84, 84, 160, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 5.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чукотский автономный округ' AND localities.name = 'Анадырь'),
          -42, -41, -39, -38, -25, -45, 7.4, 235, -15.5, 299, -11.3, 322, -9.8, 81, 80, 164, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 6.3, 6.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чукотский автономный округ' AND localities.name = 'Березово'),
          -52, -51, -51, -50, -37, -53, 11.6, 236, -18.2, 296, -13.6, 314, -12.3, 77, 76, 113, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чукотский автономный округ' AND localities.name = 'Марково'),
          -51, -50, -49, -47, -29, -60, 9.8, 233, -18.7, 274, -15.3, 290, -13.9, 78, 77, 142, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 4, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чукотский автономный округ' AND localities.name = 'Омолон'),
          -56, -53, -50, -47, -37, -61, 9.6, 232, -25.2, 283, -19.8, 299, -18.3, 75, 74, 88, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 4.2, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чукотский автономный округ' AND localities.name = 'Островное'),
          -57, -53, -55, -51, -39, -58, 9.2, 231, -23.7, 278, -19, 296, -17.3, 75, 75, 71, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 4.5, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чукотский автономный округ' AND localities.name = 'Усть-Олой'),
          -54, -53, -53, -51, -39, -60, 7.5, 230, -24.6, 278, -19.6, 295, -17.9, 75, 73, 66, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 1.7, 1.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Чукотский автономный округ' AND localities.name = 'Эньмувеем'),
          -53, -51, -51, -48, -30, -56, 10.1, 237, -19.2, 283, -15.3, 301, -13.9, 72, 71, 95, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 4.6, 1.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Алдан'),
          -47, -43, -43, -41, -31, -51, 8.4, 214, -17.7, 263, -13.6, 276, -12.6, 78, 76, 146, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 2.3, 2.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Аллах-Юнь'),
          -57, -56, -55, -54, -49, -59, 9.2, 231, -27.0, 280, -21.4, 295, -19.9, 75, 75, 32, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 3.2, 0.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Амга'),
          -59, -58, -57, -55, -48, -63, 8.9, 217, -26.1, 259, -21.3, 273, -19.7, 76, 76, 58, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.5, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Батамай'),
          -58, -56, -54, -52, -47, -63, 7.9, 222, -25.7, 265, -20.8, 279, -19.4, 72, 69, 53, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, 2.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Бердигястях'),
          -58, -57, -56, -54, -45, -61, 10.7, 222, -24.5, 268, -19.6, 282, -18.1, 73, 72, 56, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, 1.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Буяга'),
          -57, -55, -55, -52, -43, -61, 12.3, 218, -23.1, 266, -18.2, 280, -16.7, 74, 72, 56, NULL, NULL, 0.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Верхоянск'),
          -62, -60, -61, -58, -51, -68, 6.0, 228, -30.6, 272, -25, 285, -23.4, 74, 73, 35, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 1.5, 1.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Вилюйск'),
          -57, -55, -54, -51, -41, -61, 7.1, 213, -23.7, 259, -18.8, 271, -17.5, 74, 73, 55, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.1, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Витим'),
          -55, -52, -53, -50, -32, -61, 10.1, 202, -18.5, 255, -13.8, 268, -12.7, 77, 76, 131, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 3.8, 2.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Воронцово'),
          -55, -53, -52, -51, -43, -57, 8.7, 246, -24.5, 297, -19.6, 324, -17.2, 76, 76, 64, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Джалинда'),
          -62, -59, -60, -56, -44, -64, 9.4, 247, -24.2, 296, -19.5, 316, -17.7, 74, 74, 53, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), NULL, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Джарджан'),
          -59, -57, -57, -54, -42, -60, 6.4, 234, -24.8, 283, -19.8, 296, -18.5, 71, 71, 63, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.9, 3.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Джикимда'),
          -54, -54, -52, -51, -38, -59, 10.5, 203, -22.1, 256, -16.6, 269, -15.4, 77, 77, 68, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 1.7, 0.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Дружина'),
          -57, -56, -53, -52, -44, -58, 8.8, 236, -25.2, 284, -20.2, 297, -18.9, 76, 76, 78, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 2.8, 1.5);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Екючю'),
          -62, -60, -61, -58, -51, -65, 7.0, 234, -28.5, 281, -23.0, 294, -21.6, 74, 74, 31, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 1.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Жиганск'),
          -58, -55, -54, -52, -42, -60, 5.9, 229, -24.8, 275, -20, 288, -18.7, 74, 74, 61, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.1, 3.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Зырянка'),
          -54, -53, -51, -50, -40, -59, 6.3, 225, -24.8, 265, -20.4, 280, -18.8, 77, 77, 70, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 3.1, 2.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Исить'),
          -53, -51, -51, -49, -39, -54, 7.1, 207, -23, 255, -17.9, 269, -16.5, 75, 75, 54, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 4.7, 2.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Иэма'),
          -61, -60, -59, -57, -51, -63, 7.4, 242, -28.6, 292, -22.9, 311, -21, 73, 73, 38, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 1.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Крест-Хальджай'),
          -58, -57, -56, -54, -48, -62, 6.9, 211, -28.3, 254, -22.7, 267, -21.2, 72, 72, 37, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 1.4, 0.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Кюсюр'),
          -58, -56, -56, -54, -41, -62, 8, 244, -24.6, 295, -19.7, 312, -18.1, 74, 74, 84, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 4.2, 3.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Ленск'),
          -55, -52, -52, -50, -33, -57, 8.4, 207, -18.8, 258, -14.3, 270, -13.3, 76, 75, 93, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 3.2, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Нагорный'),
          -47, -45, -43, -40, -33, -57, 9.3, 219, -19.2, 270, -14.8, 285, -13.5, 75, 73, 42, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 4.7, 2.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Нера'),
          -62, -60, -60, -58, -51, -62, 5.2, 229, -29.1, 272, -23.8, 286, -22.2, 71, 70, 2, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 1.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Нюрба'),
          -58, -56, -53, -52, -41, -62, 10.2, 217, -22.3, 263, -17.7, 277, -16.3, 75, 75, 61, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.3, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Нюя'),
          -56, -53, -52, -50, -35, -61, 9.3, 203, -18.8, 253, -14.2, 268, -12.9, 73, 73, 61, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 5.3, 2.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Оймякон'),
          -63, -61, -60, -59, -51, -68, 7.3, 231, -31.3, 277, -25.4, 292, -23.6, 74, 75, 37, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 1.4, 0.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Олекминск'),
          -55, -53, -53, -49, -35, -60, 7.9, 204, -20.4, 253, -15.7, 267, -14.4, 79, 78, 72, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.7, 2.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Оленек'),
          -59, -58, -57, -55, -44, -63, 7.4, 240, -23.4, 287, -18.9, 300, -17.7, 78, 78, 62, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 2.5, 2.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Охотский Перевоз'),
          -58, -57, -56, -55, -49, -60, 7.9, 218, -26.7, 260, -21.7, 274, -20.1, 74, 74, 54, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 1.8, 1.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Сангар'),
          -53, -52, -51, -50, -44, -61, 6.4, 220, -24.0, 261, -19.6, 274, -18.2, 70, 70, 58, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 7.6, 3.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Саскылах'),
          -57, -54, -55, -53, -38, -60, 7.5, 257, -23.9, 308, -19.3, 327, -17.6, 74, 73, 46, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮВ'), 3.4, 3.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Среднеколымск'),
          -54, -52, -52, -50, -40, -58, 6.5, 232, -24.5, 277, -19.8, 294, -18.1, 77, 77, 64, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 1.9, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Сунтар'),
          -56, -55, -55, -52, -37, -60, 9.4, 208, -21.7, 257, -16.8, 270, -15.5, 77, 73, 63, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.3, 2.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Сухана'),
          -62, -61, -60, -59, -46, -64, 8.6, 235, -26.7, 284, -21.4, 297, -20.1, 72, 72, 49, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 2.6, 1.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Сюльдюкар'),
          -61, -58, -56, -53, -43, -63, 11.8, 222, -22.8, 270, -18.0, 284, -16.7, 75, 75, 64, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 1.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Сюрен-Кюель'),
          -51, -50, -49, -46, -40, -53, 7.2, 239, -22.1, 292, -17.4, 311, -15.8, 75, 75, 34, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 8.7, 3.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Токо'),
          -54, -53, -52, -51, -43, -61, 14.3, 221, -24.4, 273, -18.9, 288, -17.4, 78, 76, 53, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), 2.5, 0.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Томмот'),
          -56, -54, -54, -51, -41, -60, 12.1, 214, -21.9, 262, -17.1, 277, -15.7, 77, 77, 92, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Томпо'),
          -58, -57, -55, -54, -47, -60, 6.6, 224, -28.8, 269, -23.3, 283, -21.7, 75, 76, 31, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 2.7, 2.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Туой-Хая'),
          -58, -55, -54, -52, -38, -59, 10.4, 216, -20.4, 266, -15.8, 280, -14.5, 76, 75, 72, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 3.0, 1.9);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Тяня'),
          -55, -53, -52, -50, -38, -57, 11.9, 211, -20.5, 262, -15.7, 278, -14.4, 78, 77, 89, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 0.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Усть-Мая'),
          -56, -55, -54, -52, -45, -60, 7.2, 206, -26.2, 251, -20.8, 264, -19.3, 76, 73, 55, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 1.5, 1.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Усть-Миль'),
          -55, -54, -54, -51, -45, -59, 10.4, 213, -24.0, 259, -18.9, 274, -17.4, 75, 74, 68, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, 1.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Усть-Мома'),
          -61, -60, -58, -56, -48, -62, 7.4, 227, -29.1, 267, -24.1, 282, -22.3, 75, 75, 37, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 2.9, 0.8);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Чульман'),
          -48, -46, -45, -44, -40, -61, 7.3, 217, -19.7, 266, -15.4, 279, -14.2, 79, 80, 76, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 3.6, 2.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Чурапча'),
          -61, -59, -59, -56, -49, -64, 9.1, 219, -26.6, 239, -21.8, 273, -20.2, 73, 73, 46, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, 1.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Шелагонцы'),
          -60, -59, -58, -57, -45, -65, 10.0, 233, -26.1, 282, -20.8, 296, -19.4, 75, 76, 52, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), 1.7, 1.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Эйк'),
          -56, -54, -54, -52, -43, -59, 9.6, 236, -23.1, 284, -18.5, 298, -17.3, 75, 75, 38, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), NULL, 2.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Якутск'),
          -57, -55, -54, -52, -46, -64, 6.3, 209, -26, 252, -20.9, 263, -19.6, 76, 72, 47, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'С'), 1.8, 1.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ненецкий автономный округ' AND localities.name = 'Варандей'),
          -40, -39, -37, -36, -24, -44, 8.8, 238, -11.5, 323, -7.3, 365, -5.6, 86, 85, 126, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 6.1);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ненецкий автономный округ' AND localities.name = 'Индига'),
          -40, -39, -37, -34, -18, -43, 7.6, 215, -9.5, 298, -5.6, 328, -4.3, 83, 82, 124, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), 10.1, 6.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ненецкий автономный округ' AND localities.name = 'Канин Нос'),
          -29, -26, -25, -23, -13, -33, 5.4, 208, -5.8, 316, -2.4, 365, -0.8, 88, 88, 170, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 9.9, 8.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ненецкий автономный округ' AND localities.name = 'Коткино'),
          -49, -47, -43, -41, -23, -51, 10.0, 215, -10.7, 285, -7.1, 309, -5.8, 82, 81, 148, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 3.7);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ненецкий автономный округ' AND localities.name = 'Нарьян-Мар'),
          -44, -43, -41, -39, -20, -48, 9.0, 218, -11.4, 289, -7.5, 309, -6.5, 82, 82, 132, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 4.3, 4.2);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ненецкий автономный округ' AND localities.name = 'Ходовариха'),
          -39, -37, -34, -32, -22, -40, 8.6, 181, -8.4, 330, -6.2, 365, -4.5, 86, 86, 167, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'ЮЗ'), NULL, 6.6);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ненецкий автономный округ' AND localities.name = 'Хоседа-Хард'),
          -48, -46, -43, -42, -25, -53, 9.5, 229, -13.3, 296, -8.6, 318, -7.3, 83, 82, 118, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 7.2, 4.4);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Ярославская область' AND localities.name = 'Ярославль'),
          -37, -34, -34, -31, -17, -46, 8.3, 152, -7.8, 221, -4, 239, -2.8, 83, 82, 174, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'Ю'), 5.5, 4.3);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Крым' AND localities.name = 'Ай-Петри'),
          -24, -22, -20, -18, -7, -27, NULL, 105, -2.6, 210, 0.7, 242, 1.7, 81, NULL, 638, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Крым' AND localities.name = 'Клепинино'),
          -27, -25, -23, -21, -10, -33, NULL, 55, -1.1, 157, 2, 177, 2.8, 86, NULL, 160, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'В'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Крым' AND localities.name = 'Симферополь'),
          -22, -20, -18, -15, -4, -30, 7.1, 37, -0.5, 154, 2.6, 175, 3.4, 84, NULL, 210, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), 7.4, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Крым' AND localities.name = 'Феодосия'),
          -22, -19, -17, -15, -3, -25, NULL, 0, NULL, 142, 3.4, 163, 4.1, 82, NULL, 185, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), 6.5, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Крым' AND localities.name = 'Ялта'),
          -10, -8, -7, -6, 0, -15, NULL, 0, NULL, 126, 5.1, 152, 5.9, 74, NULL, 355, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'З'), NULL, NULL);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Крым' AND localities.name = 'Керчь'),
          -20, -17, -16, -13, -3.1, -23.7, 5.9, 38, -0.1, 155, 2.6, 175, 3.3, 85, 59, 183, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СЗ'), NULL, 5.0);
INSERT INTO sp_131_13330_2012_cold_period (locality_id, coldest_day_temperature_98, coldest_day_temperature_92, coldest_five_temperature_98, coldest_five_temperature_92, temperature_94, absolute_minimum_temperature, average_temperature_amplitude, duration_0, average_temperature_0, duration_8, average_temperature_8, duration_10, average_temperature_10, average_month_moisture, average_month_moisture_at_1500, rainfall_nov_mar, wind_direction_id, maximum_wind_speed_jan, average_wind_speed_8)
  VALUES ((SELECT locality_id FROM localities JOIN states USING (state_id)
             WHERE states.name = 'Республика Крым' AND localities.name = 'Севастополь'),
          -18, -16, -14, -11, -0.1, -22.0, 6.4, 0, NULL, 136, 4.7, 163, 5.4, 78, 62, 204, (SELECT wind_direction_id FROM sp_131_13330_2012_wind_directions WHERE image = 'СВ'), NULL, 4.5);

INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (900, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Адыгея (Адыгея)' AND localities.name = 'Майкоп'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Алтайский край' AND localities.name = 'Барнаул'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2150, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Алтайский край' AND localities.name = 'Бийск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1900, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Алтай' AND localities.name = 'Горно-Алтайск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1000, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Алтайский край' AND localities.name = 'Рубцовск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Амурская область' AND localities.name = 'Благовещенск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Архангельская область' AND localities.name = 'Архангельск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2250, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Архангельская область' AND localities.name = 'Северодвинск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Астраханская область' AND localities.name = 'Астрахань'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2050, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Нефтекамск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Октябрьский'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Салават'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2200, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Стерлитамак'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Башкортостан' AND localities.name = 'Уфа'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Белгородская область' AND localities.name = 'Белгород'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Белгородская область' AND localities.name = 'Старый Оскол'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Брянская область' AND localities.name = 'Брянск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Бурятия' AND localities.name = 'Улан-Удэ'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Владимирская область' AND localities.name = 'Владимир'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Владимирская область' AND localities.name = 'Ковров'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Владимирская область' AND localities.name = 'Муром'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1000, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Волгоградская область' AND localities.name = 'Волгоград'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1000, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Волгоградская область' AND localities.name = 'Волжский'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1150, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Волгоградская область' AND localities.name = 'Камышин'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1650, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Вологодская область' AND localities.name = 'Вологда'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Вологодская область' AND localities.name = 'Череповец'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Воронежская область' AND localities.name = 'Воронеж'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Дагестан' AND localities.name = 'Каспийск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Дагестан' AND localities.name = 'Махачкала'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (650, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Дагестан' AND localities.name = 'Хасавьюрт'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (950, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Еврейская автономная область' AND localities.name = 'Биробиджан'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Забайкальский край' AND localities.name = 'Чита'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1700, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ивановская область' AND localities.name = 'Иваново'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1900, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ивановская область' AND localities.name = 'Кинешма'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (650, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Ингушения' AND localities.name = 'Назрань'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1050, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Иркутская область' AND localities.name = 'Ангарск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1250, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Иркутская область' AND localities.name = 'Братск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1050, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Иркутская область' AND localities.name = 'Иркутск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1250, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Иркутская область' AND localities.name = 'Усть-Илимск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Кабардино-Балкарская Республика' AND localities.name = 'Нальчик'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Калининградская область' AND localities.name = 'Калининград'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (700, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Калмыкия' AND localities.name = 'Элиста'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1900, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Калужская область' AND localities.name = 'Калуга'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (4100, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Камчатский край' AND localities.name = 'Петропавловск-Камчатский'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Карачаево-Черкесская Республика' AND localities.name = 'Черкесск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1700, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Карелия' AND localities.name = 'Петрозаводск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Кемеровская область' AND localities.name = 'Кемерово'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Кемеровская область' AND localities.name = 'Киселевск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (3500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Кемеровская область' AND localities.name = 'Междуреченск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Кемеровская область' AND localities.name = 'Новокузнецк'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Кемеровская область' AND localities.name = 'Прокопьевск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2100, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Кировская область' AND localities.name = 'Киров'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Коми' AND localities.name = 'Сыктывкар'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2150, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Коми' AND localities.name = 'Ухта'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Костромская область' AND localities.name = 'Кострома'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Краснодарский край' AND localities.name = 'Армавир'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1100, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Краснодарский край' AND localities.name = 'Краснодар'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (700, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Краснодарский край' AND localities.name = 'Кропоткин'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1250, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Красноярский край' AND localities.name = 'Ачинск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1100, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Красноярский край' AND localities.name = 'Канск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1350, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Красноярский край' AND localities.name = 'Красноярск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Красноярский край' AND localities.name = 'Норильск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Крым' AND localities.name = 'Евпатория'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Крым' AND localities.name = 'Ялта'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1300, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Курганская область' AND localities.name = 'Курган'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Курская область' AND localities.name = 'Железногорск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1250, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Курская область' AND localities.name = 'Курск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ленинградская область' AND localities.name = 'Выборг'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ленинградская область' AND localities.name = 'Гатчина'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1300, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ленинградская область' AND localities.name = 'Пушкин'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1300, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ленинградская область' AND localities.name = 'Санкт-Петербург'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1350, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Липецкая область' AND localities.name = 'Елец'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Липецкая область' AND localities.name = 'Липецк'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1350, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Магаданская область' AND localities.name = 'Магадан (Нагаева, бухта)'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Марий Эл' AND localities.name = 'Йошкар-Ола'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Мордовия' AND localities.name = 'Саранск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Московская область' AND localities.name = 'Дмитров'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Московская область' AND localities.name = 'Клин'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Московская область' AND localities.name = 'Коломна'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Московская область' AND localities.name = 'Москва'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Московская область' AND localities.name = 'Сергиев Посад'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Московская область' AND localities.name = 'Серпухов'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (3200, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Мурманская область' AND localities.name = 'Мурманск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Нижегородская область' AND localities.name = 'Арзамас'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2100, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Нижегородская область' AND localities.name = 'Нижний Новгород'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1650, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Нижегородская область' AND localities.name = 'Саров'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Новгородская область' AND localities.name = 'Великий Новгород'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Новосибирская область' AND localities.name = 'Бердск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Новосибирская область' AND localities.name = 'Новосибирск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1350, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Омская область' AND localities.name = 'Омск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1300, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Оренбургская область' AND localities.name = 'Бузулук'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1250, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Оренбургская область' AND localities.name = 'Оренбург'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1200, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Оренбургская область' AND localities.name = 'Орск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Орловская область' AND localities.name = 'Орел'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Пензенская область' AND localities.name = 'Кузнецк'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Пензенская область' AND localities.name = 'Пенза'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Пермский край' AND localities.name = 'Березники'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1950, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Пермский край' AND localities.name = 'Пермь'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Пермский край' AND localities.name = 'Соликамск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Пермский край' AND localities.name = 'Чайковский'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (700, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Приморский край' AND localities.name = 'Уссурийск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1100, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Псковская область' AND localities.name = 'Великие Луки'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1300, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Псковская область' AND localities.name = 'Псков'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ростовская область' AND localities.name = 'Волгодонск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ростовская область' AND localities.name = 'Новочеркасск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ростовская область' AND localities.name = 'Новошахтинск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ростовская область' AND localities.name = 'Ростов-на-Дону'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ростовская область' AND localities.name = 'Таганрог'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ростовская область' AND localities.name = 'Шахты'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Рязанская область' AND localities.name = 'Рязань'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Самарская область' AND localities.name = 'Новокуйбышевск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Самарская область' AND localities.name = 'Самара'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Самарская область' AND localities.name = 'Сызрань'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1650, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Самарская область' AND localities.name = 'Тольятти'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Саратовская область' AND localities.name = 'Саратов'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Саратовская область' AND localities.name = 'Энгельс'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (700, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Саха (Якутия)' AND localities.name = 'Якутск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (3850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Сахалинская область' AND localities.name = 'Южно-Сахалинск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1350, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Свердловская область' AND localities.name = 'Екатеринбург'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1250, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Свердловская область' AND localities.name = 'Каменск-Уральский'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Свердловская область' AND localities.name = 'Нижний Тагил'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Свердловская область' AND localities.name = 'Первоуральск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Свердловская область' AND localities.name = 'Серов'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (650, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Северная Осетия - Алания' AND localities.name = 'Владикавказ'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Смоленская область' AND localities.name = 'Смоленск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (650, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ставропольский край' AND localities.name = 'Ессентуки'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (650, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ставропольский край' AND localities.name = 'Кисловодск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (750, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ставропольский край' AND localities.name = 'Невинномысск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ставропольский край' AND localities.name = 'Пятигорск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (950, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ставропольский край' AND localities.name = 'Ставрополь'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Тамбовская область' AND localities.name = 'Мичуринск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Тамбовская область' AND localities.name = 'Тамбов'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Татарстан (Татарстан)' AND localities.name = 'Альметьевск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Татарстан (Татарстан)' AND localities.name = 'Бугульма'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2300, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Татарстан (Татарстан)' AND localities.name = 'Казань'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2250, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Татарстан (Татарстан)' AND localities.name = 'Набережные Челны'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2100, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Татарстан (Татарстан)' AND localities.name = 'Нижнекамск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Тверская область' AND localities.name = 'Тверь'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2150, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Томская область' AND localities.name = 'Северск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2150, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Томская область' AND localities.name = 'Томск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Республика Тыва' AND localities.name = 'Кызыл'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Тульская область' AND localities.name = 'Новомосковск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1500, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Тульская область' AND localities.name = 'Тула'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Тюменская область' AND localities.name = 'Тобольск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1600, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Тюменская область' AND localities.name = 'Тюмень'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2350, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Удмуртская Республика' AND localities.name = 'Воткинск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1700, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Удмуртская Республика' AND localities.name = 'Глазов'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2150, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Удмуртская Республика' AND localities.name = 'Ижевск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Удмуртская Республика' AND localities.name = 'Сарапул'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2050, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ульяновская область' AND localities.name = 'Димитровград'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1400, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ульяновская область' AND localities.name = 'Ульяновск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1250, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Хабаровский край' AND localities.name = 'Комсомольск-на-Амуре'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1100, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Хабаровский край' AND localities.name = 'Хабаровск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ханты-Мансийский автономный округ - Юрга' AND localities.name = 'Нефтеюганск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2300, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ханты-Мансийский автономный округ - Юрга' AND localities.name = 'Нижневартовск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ханты-Мансийский автономный округ - Юрга' AND localities.name = 'Сургут'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1950, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ханты-Мансийский автономный округ - Юрга' AND localities.name = 'Ханты-Мансийск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1850, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Челябинская область' AND localities.name = 'Златоуст'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1200, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Челябинская область' AND localities.name = 'Копейск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1300, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Челябинская область' AND localities.name = 'Магнитогорск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1100, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Челябинская область' AND localities.name = 'Миасс'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1200, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Челябинская область' AND localities.name = 'Челябинск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (450, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Чеченская Республика' AND localities.name = 'Грозный'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1950, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Чувашская Республика - Чувашия' AND localities.name = 'Новочебоксарск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1950, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Чувашская Республика - Чувашия' AND localities.name = 'Чебоксары'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2550, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ямало-Ненецкий автономный округ' AND localities.name = 'Новый Уренгой'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (2000, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ярославская область' AND localities.name = 'Рыбинск'));
INSERT INTO sp_20_13330_2016_locality_snow_loads (normative_load, locality_id)
  VALUES (1800, (SELECT locality_id FROM localities JOIN states USING (state_id)
    WHERE states.name = 'Ярославская область' AND localities.name = 'Ярославль'));
