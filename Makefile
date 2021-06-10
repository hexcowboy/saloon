.PHONY: docker
docker:
	docker build -t jackbox .

.PHONY: clean
clean:
	docker image rm --force jackbox
