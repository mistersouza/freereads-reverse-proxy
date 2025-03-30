FROM nginx:alpine

# Remove the default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom NGINX configuration
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Create a directory for SSL certificates if needed later
RUN mkdir -p /etc/nginx/ssl

# Install additional tools for debugging if needed
RUN apk add --no-cache curl bash

# NGINX health check configuration
RUN echo "server { \
    listen 8080; \
    location /health { \
        access_log off; \
        return 200 'ok'; \
    } \
}" > /etc/nginx/conf.d/health.conf

# Expose port 80 for HTTP
EXPOSE 80

# Expose port 8080 for health checks
EXPOSE 8080

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
