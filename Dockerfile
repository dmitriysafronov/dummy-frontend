# --------------> The build image
FROM node:18.12.1 AS builder
ARG NPM_TOKEN
WORKDIR /app
COPY package*.json ./
RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc && \
   npm ci --only=production && \
   rm -f .npmrc
COPY . .
RUN npm run build
 
# --------------> The production image
FROM nginxinc/nginx-unprivileged:1.25.3 as production
ENV NODE_ENV production
# Copy built assets from `builder` image
COPY --from=builder /app/build/ /usr/share/nginx/html/
