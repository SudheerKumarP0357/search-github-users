# syntax=docker/dockerfile:1

FROM node:22-alpine3.21 AS build

WORKDIR /app

COPY package*.json .

RUN npm install

COPY . .

RUN npm run build


FROM nginx:1.27.3-alpine3.20-slim AS prod

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]