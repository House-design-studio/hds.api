# hds.api

It's a new backend application for [mycalcs.ru](mycalcs.ru)

## how to start

First things first. You need to create ``.env`` based on ``.env.sample`` <br>
for [docker compose](https://github.com/House-design-studio/hds.api/blob/master/docker-compose.override.yml) file

## how to run

After a configuration you can use ``docker-compose up`` to run a programm <br>
Or... you can run programm with ``dotnet run --project .\src\Server\`` <br>
with next environment variables:
  - OAuth__Google__ClientSecret
  - OAuth__Google__ClientId
  - ConnectionStrings__DefaultConnection

and launched postgresql

