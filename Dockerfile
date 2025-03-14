FROM guergeiro/pnpm:22-10 as base
ARG WORK_DIR=/app
ARG PNPM_DIR=/root/pnpm
WORKDIR ${WORK_DIR}
RUN pnpm config set store-dir ${PNPM_DIR} --global
ENTRYPOINT ["sh", "-c"]

FROM base as production
COPY package.json pnpm-*.yaml ./
COPY packages/backend/package.json ./packages/backend/
COPY packages/frontend/package.json ./packages/frontend/
COPY packages/shared/package.json ./packages/shared/
RUN pnpm install --frozen-lockfile
COPY . .
