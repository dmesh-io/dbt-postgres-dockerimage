# DBT-Postgres-Dockerimage

## Getting Started

You can use the `makefile` for a quick getting-started into the repo:

- `make run` builds the docker image and runs `dbt debug`
- `make interactive-run` lets you jump into the container quickly.
- `make scan` executes trivy image scan for vulnerabilities

## Postgres Credentials
 
Dbt obtains the credentials used to connect to the postgres server in the `profiles.yml` file:

```yaml
your_dbt_project:
  target: dev
  outputs:
    dev:
      type: postgres
      threads: "{{ env_var('DBT_POSTGRES_NUM_THREADS') | int }}"
      host: "{{ env_var('DBT_POSTGRES_HOST') }}"
      port: "{{ env_var('DBT_POSTGRES_PORT') | as_number }}"
      user: "{{ env_var('DBT_POSTGRES_USER') }}"
      pass: "{{ env_var('DBT_POSTGRES_PASS') }}"
      dbname: "{{ env_var('DBT_POSTGRES_DBNAME') }}"
      schema: "{{ env_var('DBT_POSTGRES_SCHEMA') }}"   
```

There, it is possible to read credentials from environment variables. It will look for environment variables in the docker container and injects them into the yaml file. Note: numbers need to be converted. More can be found [here](https://docs.getdbt.com/reference/dbt-jinja-functions/env_var). Furthermore, do not forget that the project name configured in `profiles.yml` needs to match with your project name.

The environment variables can be fed into the docker container when executing docker run. Have a look at the `make run` command: 

```makefile
run: build
	docker run --env-file $(ENV_FILE_NAME) $(IMAGE_NAME)
```

A path to a .env file can be specified that for example looks like this:

```bash
DBT_POSTGRES_HOST=hh-pgsql-public.ebi.ac.uk
DBT_POSTGRES_PORT=5432
DBT_POSTGRES_USER=reader
DBT_POSTGRES_PASS=NWDMCE5xdipIjRrp
DBT_POSTGRES_DBNAME=pfmegrnargs
DBT_POSTGRES_SCHEMA=RNAcentral
DBT_POSTGRES_NUM_THREADS=1
```
These are credentials for a public postgres database used to test whether connecting works within the alpine image.

## Use Git or not?

When running `dbt debug` without having git installed on the alpine image, an error occurs because of missing git dependency. It needs to be evaluated if this has any effect on the functionality of dbt or layer two of the dockerfile can be removed.

## Official dbt-postgres docker image

There is an official dbt-postgres [image](https://github.com/dbt-labs/dbt-core/pkgs/container/dbt-postgres), but trivy inspection reveals many vulnerabilities.