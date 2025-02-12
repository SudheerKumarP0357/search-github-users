# syntax=docker/dockerfile:1

### STAGE 1: Build the React app ###
FROM node:22-alpine3.21 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . ./

# Build the React app (without hardcoding environment variables)
RUN npm run build


### STAGE 2: Serve the app with Nginx ###
FROM nginx:1.27.4-alpine3.21-slim AS prod

WORKDIR /usr/share/nginx/html

# Copy build output
COPY --from=build /app/dist /usr/share/nginx/html

# Copy the template environment JS file
COPY env.template.js env.template.js

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports for HTTP & HTTPS
EXPOSE 80 443

# Run entrypoint script before starting Nginx
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
