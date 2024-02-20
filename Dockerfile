# VERSIONS
ARG NODE_VERSION=20.11.1
ARG NPM_VERSION=10.4.0
ARG NGINX_VERSION=1.25.4

# --------------> The builder image
FROM node:$NODE_VERSION AS builder
ENV NODE_ENV production
WORKDIR /app
ARG NPM_TOKEN
COPY package*.json ./
RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc && \
   npm install -g npm@$NPM_VERSION && \
   npm ci --omit=dev && \
   rm -f .npmrc
COPY . .
RUN npm run build
 
# --------------> The production image
FROM nginxinc/nginx-unprivileged:$NGINX_VERSION AS production
# Copy built assets from `builder` image
COPY --from=builder /app/build/ /usr/share/nginx/html/
