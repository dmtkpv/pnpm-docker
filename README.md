# pnpm-docker
An example of using Docker with PNPM monorepo

```shell
# for development
docker compose up --build

# for production
docker compose -f compose.yml -f compose.prod.yml up --build 
```