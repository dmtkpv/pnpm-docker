# ---------------------
# Common
# ---------------------

FROM guergeiro/pnpm:22-10 as base

ARG WORK_DIR=/app
ARG PNPM_DIR=/root/pnpm
RUN pnpm config set store-dir ${PNPM_DIR} --global

WORKDIR ${WORK_DIR}
ENTRYPOINT ["bash", "-c"]



# ---------------------
# Production
# ---------------------

FROM base as production

COPY package.json pnpm-*.yaml ./
COPY packages/backend/package.json ./packages/backend/
COPY packages/frontend/package.json ./packages/frontend/
COPY packages/shared/package.json ./packages/shared/

RUN pnpm install --frozen-lockfile

COPY . .
