SHELL=bash
IMAGE:=garbage-cleaner
FIND := $(shell if [ "$$(uname -s)" = "Darwin" ] && command -v gfind >/dev/null 2>&1; then echo gfind; else echo find; fi)


docker:
	docker build -t $(IMAGE) .


run:
	docker run -it  -p 9080:9080 -e PURGE_FOLDERS="/share,/data/letterbox,/data/assets:-atime +7,/data/uploads:-atime +7" -e "CRON_PURGE=0 3 * * *" $(IMAGE)

explore:
	docker run -it  -p 9080:9080 -v /data:/data -e PURGE_FOLDERS="/share,/data/letterbox,/data/assets:-atime +7,/data/uploads:-atime +7" -e "CRON_PURGE=0 3 * * *" --entrypoint /bin/sh $(IMAGE)

test_purge:
	@ACTION=-ls FIND='$(FIND)' ./purge.sh /tmp
	@ACTION=-ls FIND='$(FIND)' ./purge.sh "/share,/data/letterbox,/data/assets:-atime +7,/data/uploads:-atime +7"
