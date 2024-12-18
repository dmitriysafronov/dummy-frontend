# --------------> The builder image
FROM node:20.13.1 AS builder
ENV NODE_ENV=production
WORKDIR /app
# Install NPM with version
RUN npm install -g npm@10.8.0
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
FROM nginxinc/nginx-unprivileged:1.26.0 AS production
# Copy built assets from `builder` image
COPY --from=builder /app/build/ /usr/share/nginx/html/
