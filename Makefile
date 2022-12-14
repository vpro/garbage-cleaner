SHELL=bash


docker:
	docker build -t garbage-cleaner .


run:
	docker run  -e PURGE_FOLDERS="/share,/data/letterbox,/data/assets:-atime +7,/data/uploads:-atime +7" -e "CRON_PURGE=0 3 * * *" garbage-cleaner


test_purge:
	@ACTION=-ls ./purge.sh /tmp
	@ACTION=-ls ./purge.sh /share,/data/letterbox,/data/assets:-atime +7,/data/uploads:-atime +7

