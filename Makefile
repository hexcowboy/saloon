.PHONY: docker
docker:
	chmod u+x ./scripts/*
	docker build -t saloon .

.PHONY: clean
clean:
	docker image rm --force saloon
