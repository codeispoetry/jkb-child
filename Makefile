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
	docker run -it --rm --volumes-from wordpress --network container:wordpress  wordpress:cli /bin/bash

deploy:
	cd htdocs && rsync -avhz wp-content/themes/mytheme dev:/var/www/tom-rose.de/wordpress/wp-content/themes/mytheme

deploy_s:
	make bundle_s upload_s install_s

bundle_s:
	docker-compose exec node npm run bundle

upload_s:
	rsync htdocs/wp-content/themes/_s.zip dev:/var/www/tom-rose.de/wordpress/wp-content/themes/

install_s:
	ssh dev "cd /var/www/tom-rose.de/wordpress/wp-content/themes/ && wp theme install _s.zip --force"

activate_s:
	ssh dev "cd /var/www/tom-rose.de/wordpress/wp-content/themes/ && wp theme activate _s"


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
