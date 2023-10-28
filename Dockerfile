FROM node:19
WORKDIR /app
COPY package*.json ./
COPY src ./src
COPY .env ./
COPY tsconfig.json ./
RUN npm install
EXPOSE 3000
CMD ["npm", "start"]
