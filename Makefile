REGISTRY_PROJECT_URL ?= ghcr.io/kmmndr/controle-qualite
# BUILD_ID = commit_sha
BUILD_ID ?=$(shell test -d .git && git rev-parse HEAD | cut -c -8)
# REF_ID = branch_name
REF_ID ?=$(shell git symbolic-ref --short HEAD)

default: help
include makefiles/*.mk

ci-build: docker-pull docker-build
ci-push: docker-push
ci-push-release: docker-push-release
ci-push-release-stages: docker-push-release-stages

run: ci-build
	export BUILD_SUBPATH=dev \
		COMMIT_IMAGE=${REGISTRY_PROJECT_URL}/${BUILD_SUBPATH}:${BUILD_ID}; \
		docker run --rm -it $$COMMIT_IMAGE /bin/ash
