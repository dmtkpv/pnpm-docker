ARG WORK_DIR=/app
ARG PNPM_DIR=/root/pnpm



# ---------------------
# Base
# ---------------------

FROM guergeiro/pnpm:22-10-slim AS base

ARG WORK_DIR
ARG PNPM_DIR
RUN pnpm config set store-dir ${PNPM_DIR} --global

WORKDIR ${WORK_DIR}
ENTRYPOINT ["sh", "-c"]



# ---------------------
# Data
# ---------------------

FROM base AS data
COPY package.json pnpm-*.yaml ./
COPY packages/backend/package.json ./packages/backend/
COPY packages/frontend/package.json ./packages/frontend/
COPY packages/shared/package.json ./packages/shared/

RUN pnpm install --frozen-lockfile

COPY . .



# ---------------------
# Prune
# ---------------------

FROM data AS prune
ARG PACKAGE
RUN pnpm ${PACKAGE} --prod deploy --legacy pruned/${PACKAGE}



# ---------------------
# Production
# ---------------------

FROM base AS production
ARG PACKAGE
COPY --from=prune ${WORK_DIR}/pruned/${PACKAGE} ./
RUN if [ "$PACKAGE" = "frontend" ]; then pnpm run build; fi