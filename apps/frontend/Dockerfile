FROM node:18

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

# RUN npm install
# RUN npm run build
# If you are building your code for production
RUN npm ci --omit=dev

RUN npm install react-scripts@1.1.0 -g

COPY . .

EXPOSE 3000 

CMD ["npm","start"];