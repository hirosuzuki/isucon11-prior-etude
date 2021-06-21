REMOTEHOST=hirosuzuki@34.85.57.101

build:
	go build -o webapp

deploy:
	scp webapp ${REMOTEHOST}:webapp
	ssh ${REMOTEHOST} sudo systemctl stop isucon
	cat webapp | ssh ${REMOTEHOST} "sudo tee /home/isucon/bin/webapp > /dev/null"
	cat start.sh | ssh ${REMOTEHOST} "sudo tee /tmp/start.sh > /dev/null"
	ssh ${REMOTEHOST} sudo systemctl start isucon

bench:
	ssh ${REMOTEHOST} ./benchmarker

nginx:
	cat nginx.conf | ssh ${REMOTEHOST} "sudo tee /etc/nginx/nginx.conf"
	ssh ${REMOTEHOST} sudo systemctl restart nginx

load:
	scp ${REMOTEHOST}:/etc/nginx/nginx.conf nginx.conf.orig

synclogs:
	rsync -av ${REMOTEHOST}:/tmp/isucon/logs/ logs/

pprof:
	go tool pprof -http="127.0.0.1:8020" logs/latest/cpu.pprof

shell:
	ssh ${REMOTEHOST}


schema:
	scp 00_setup.sql ${REMOTEHOST}:/home/hirosuzuki/isucon11-prior/webapp/sql/00_setup.sql
	scp 01_schema.sql ${REMOTEHOST}:/home/hirosuzuki/isucon11-prior/webapp/sql/01_schema.sql
