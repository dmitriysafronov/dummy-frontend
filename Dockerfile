# --------------> The builder image
FROM node:23.6.0 AS builder
ENV NODE_ENV=production
WORKDIR /app
ARG NPM_TOKEN
COPY package*.json ./
RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc && \
   npm ci --omit=dev && \
   rm -f .npmrc
COPY . .
RUN npm run build

# --------------> The production image
FROM nginxinc/nginx-unprivileged:1.27.3 AS production
COPY --from=builder /app/build/ /usr/share/nginx/html/
