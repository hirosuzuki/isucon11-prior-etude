REMOTEHOST=hirosuzuki@34.85.57.101

build:
	go build -o webapp

deploy:
	scp webapp ${REMOTEHOST}:webapp
	ssh ${REMOTEHOST} sudo systemctl stop isucon
	cat webapp | ssh ${REMOTEHOST} "sudo tee /home/isucon/bin/webapp > /dev/null"
	ssh ${REMOTEHOST} sudo systemctl start isucon

shell:
	ssh ${REMOTEHOST}

nginx:
	cat nginx.conf | ssh ${REMOTEHOST} "sudo tee /etc/nginx/nginx.conf"
	ssh ${REMOTEHOST} sudo systemctl restart nginx

load:
	scp ${REMOTEHOST}:/etc/nginx/nginx.conf nginx.conf.orig

