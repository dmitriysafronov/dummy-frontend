# VERSIONS
ARG NODE_VERSION=20.13.1
ARG NGINX_VERSION=1.26.0

# --------------> The builder image
FROM node:$NODE_VERSION AS builder
ENV NODE_ENV production
WORKDIR /app
# Install NPM with version
ARG NPM_VERSION=10.8.0
RUN npm install -g npm@$NPM_VERSION
# Install dependencies
COPY package*.json ./
ARG NPM_TOKEN
RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc && \
   npm ci --omit=dev && \
   rm -f .npmrc
# Build app
COPY . .
RUN npm run build
 
# --------------> The production image
FROM nginxinc/nginx-unprivileged:$NGINX_VERSION AS production
# Copy built assets from `builder` image
COPY --from=builder /app/build/ /usr/share/nginx/html/
