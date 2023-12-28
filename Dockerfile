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
FROM nginx:1.23.3-alpine as production
ENV NODE_ENV production
# Copy built assets from `builder` image
COPY --from=builder /app/build/ /usr/share/nginx/html/
