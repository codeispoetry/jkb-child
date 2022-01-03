# WPSetup

## Installation
- docker-compose up -d
- Aufruf via Browser und dortige Installation
- anschließend `docker-compose run node bash` und `npm install`

## WordPress CLI
``docker run -it --rm --volumes-from wordpress --network container:wordpress  wordpress:cli /bin/bash``
## Node
- ``docker-compose build``
- ``docker-compose run node npm install``
- ``docker-compose up -d``

## Weitere Befehle
Weitere Befehle siehe Datei _Makefile_.

