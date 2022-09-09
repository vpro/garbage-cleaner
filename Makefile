SHELL=bash


docker:
	docker build -t garbage-cleaner .


run:
	docker run -i garbage-cleaner
