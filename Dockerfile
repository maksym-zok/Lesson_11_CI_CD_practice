FROM node:21.7.1-bullseye
WORKDIR /home/node/app

SHELL ["/bin/bash", "-c"]
RUN shopt -s dotglob
RUN wget https://github.com/japananh/node-express-postgres-boilerplate/archive/refs/heads/master.zip && \
    unzip master.zip && \
    mv node-express-postgres-boilerplate-master/* . && \
    rm -rf node-express-postgres-boilerplate-master master.zip
RUN npm install --save-dev cross-env
RUN yarn install

COPY .env.example .env

ENV TEST_VAR=true

EXPOSE 3000

CMD [ "yarn", "dev" ]