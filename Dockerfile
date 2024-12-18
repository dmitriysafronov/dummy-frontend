# --------------> The builder image
FROM node:20.13.1 AS builder
ENV NODE_ENV=production
WORKDIR /app
RUN npm install -g npm@10.8.0
ARG NPM_TOKEN
COPY package*.json ./
RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc && \
   npm ci --omit=dev && \
   rm -f .npmrc
COPY . .
RUN npm run build

# --------------> The production image
FROM nginxinc/nginx-unprivileged:1.26.0 AS production
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build/ /usr/share/nginx/html/
