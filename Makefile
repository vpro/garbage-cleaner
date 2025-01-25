SHELL=bash
IMAGE:=garbage-cleaner


docker:
	docker build -t $(IMAGE) .


run:
	docker run -it  -p 9080:9080 -e PURGE_FOLDERS="/share,/data/letterbox,/data/assets:-atime +7,/data/uploads:-atime +7" -e "CRON_PURGE=0 3 * * *" $(IMAGE)

explore:
	docker run -it  -p 9080:9080 -v /data:/data -e PURGE_FOLDERS="/share,/data/letterbox,/data/assets:-atime +7,/data/uploads:-atime +7" -e "CRON_PURGE=0 3 * * *" --entrypoint /bin/sh $(IMAGE)

test_purge:
	@ACTION=-ls ./purge.sh /tmp
	@ACTION=-ls ./purge.sh /share,/data/letterbox,/data/assets:-atime +7,/data/uploads:-atime +7
