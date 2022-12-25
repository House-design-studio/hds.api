------------------------------------------------------------------------------
--                                                                          --
--                         House Designer's Studio                          --
--                                                                          --
------------------------------------------------------------------------------
--                                                                          --
-- Copyright © 2022, Vadim Godunko <vgodunko@gmail.com>                     --
-- All rights reserved.                                                     --
--                                                                          --
------------------------------------------------------------------------------

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
