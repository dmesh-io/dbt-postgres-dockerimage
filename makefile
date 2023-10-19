IMAGE_NAME = dbt-postgres-image
ENV_FILE_NAME = .env

build:
	docker build . -t $(IMAGE_NAME)

run: build
	docker run --env-file $(ENV_FILE_NAME) $(IMAGE_NAME)

interactive-run: build
	docker run --rm -it --env-file $(ENV_FILE_NAME) $(IMAGE_NAME) /bin/sh

scan:
	trivy image $(IMAGE_NAME)