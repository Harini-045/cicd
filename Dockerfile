# ---- Stage 1: Build the Angular app ----
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy package files first (for better caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the source code
COPY . .

# Build the Angular app for production
RUN npm run build -- --configuration production

# ---- Stage 2: Serve the app with NGINX ----
FROM nginx:alpine

# Copy the compiled Angular build from Stage 1
COPY --from=build /app/dist/* /usr/share/nginx/html/

# Copy custom NGINX configuration (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]


