.PHONY: docker
docker:
	chmod u+x ./scripts/*
	./scripts/sort-manifests.sh
	docker build -t saloon .

.PHONY: clean
clean:
	docker image rm --force saloon
