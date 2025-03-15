ARG PNPM_IMAGE=22-10



# ---------------------
# Base
# ---------------------

FROM guergeiro/pnpm:${PNPM_IMAGE} AS base

ARG WORK_DIR=/app
ARG PNPM_DIR=/root/pnpm
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
# Backend
# ---------------------

FROM data AS backend-prune
RUN pnpm backend --prod deploy --legacy pruned/backend

FROM base AS backend
COPY --from=backend-prune ${WORK_DIR}/pruned/backend ./



# ---------------------
# Frontend
# ---------------------

FROM data AS frontend-prune
RUN pnpm frontend --prod deploy --legacy pruned/frontend

FROM base AS frontend
COPY --from=frontend-prune ${WORK_DIR}/pruned/frontend ./
RUN pnpm run build