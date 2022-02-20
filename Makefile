up:
	docker-compose up -d

stop:
	docker-compose stop

shell:
	docker-compose exec wordpress bash
	
shell-db:
	docker-compose exec db bash

node:
	docker-compose exec node bash

cli-shell:
	docker run -it --rm --volumes-from wordpressjkb --network container:wordpressjkb  wordpress:cli /bin/bash

bundle:
	docker-compose exec node npm run bundle

compile:
	docker-compose exec node npm run compile:build

upload:
	rsync htdocs/wp-content/themes/jkb-child.zip dev:/var/www/nrw.tom-rose.de/site/themes/

install:
	ssh dev "cd /var/www/nrw.tom-rose.de/site/themes/ && wp theme install jkb-child.zip --force"

activate:
	ssh dev "cd /var/www/nrw.tom-rose.de/site/themes/ && wp theme activate jkb-child"

deploy:
	make bundle upload install
	
sync-shared:
	rsync -av dev:/var/www/tom-rose.de/wordpress/wp-content/uploads/ htdocs/wp-content/uploads

sync-db:
	ssh dev "cd /var/www/tom-rose.de && mysqldump wordpress-lil > sync.sql" && \
	rsync dev:/var/www/tom-rose.de/sync.sql sync.sql && \
	ssh dev "rm /var/www/tom-rose.de/sync.sql" && \
	sed -i 's/https:\/\/tom-rose.de\/wordpress/http:\/\/localhost:8300/g' sync.sql && \
	mysql -h db wordpress < sync.sql && \
	rm sync.sql
	#docker-compose exec -T db mysql wordpress < sync.sql
	#nano /root/.my.cnf -> [client] \n password=somewordpress

browser-sync:
	browser-sync start --proxy "localhost:8800" --files "htdocs/wp-content/themes/jkb-child/*.css"


log:
	docker logs wordpressjkb -f

error-log:
	docker logs wordpressjkb -f 1>/dev/null

