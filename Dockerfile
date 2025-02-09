FROM hugomods/hugo:reg-base-0.143.1 AS builder

# Set the working directory inside the container
WORKDIR /src

# Copy the Hugo site files into the container
COPY . .

# Build the Hugo site
RUN hugo

# Use an Nginx image to serve the static files
FROM nginx:alpine

# Copy the built site from the builder stage
COPY --from=builder /src/public /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]