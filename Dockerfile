# Use lightweight Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy app files
COPY app/package*.json ./
RUN npm install

COPY app/ .

# Expose the app port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]

