# The builder image
FROM node:23.6.1 AS builder
ENV NODE_ENV=production
WORKDIR /app
COPY package*.json ./
RUN --mount=type=secret,id=npmrc,target=/home/node/.npmrc \
    npm ci --omit=dev
COPY . .
RUN npm run build

# The production image
FROM nginxinc/nginx-unprivileged:1.27.3 AS production
COPY --from=builder /app/build/ /usr/share/nginx/html/
