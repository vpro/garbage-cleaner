SHELL=bash


docker:
	docker build -t garbage-cleaner .


run:
	docker run  -e TARGET_FOLDERS=/share,/data/letterbox,/data/assets:-atime:7,/data/uploads:-atime:7 garbage-cleaner


test_purge:
	@ACTION=-ls ./purge.sh /tmp
	@ACTION=-ls ./purge.sh /tmp:-mtime

