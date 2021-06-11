.PHONY: docker
docker:
	chmod u+x ./scripts/*
	docker build -t jackbox .

.PHONY: clean
clean:
	docker image rm --force jackbox
