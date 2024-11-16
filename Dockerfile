FROM node:18-alpine AS node-builder
WORKDIR /app
COPY . .
RUN cd /app/themes/theme/static && npm i

FROM klakegg/hugo:ext AS builder
WORKDIR /app
COPY --from=node-builder /app .
RUN hugo --minify

FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/public/ .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
