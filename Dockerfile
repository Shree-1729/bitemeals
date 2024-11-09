# Step 1: Build the React app using a lightweight Node.js Alpine image
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install --production

# Copy the rest of the application code
COPY . ./

# Build the React app for production
RUN npm run build

# Step 2: Use Nginx to serve the built React app (also using a lightweight Alpine image)
FROM nginx:alpine

# Copy the build output from the build stage to the Nginx HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port that Nginx will serve on
EXPOSE 80

# Run Nginx in the foreground (default for the official Nginx image)
CMD ["nginx", "-g", "daemon off;"]
