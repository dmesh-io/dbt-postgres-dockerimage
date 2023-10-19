FROM python:alpine3.17

# dbt requests git as requirement and states missing requirements: "git"
# when running dbt debug. Probably will not affect data transformation functionality
RUN apk add git
RUN pip install dbt-postgres

WORKDIR /app
COPY your_dbt_project /app 
COPY profiles.yml /app

CMD [ "dbt", "debug"]
