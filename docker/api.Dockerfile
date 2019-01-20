FROM node:10.15.0-alpine as dev

RUN apk --no-cache add curl

RUN mkdir -p /home/node/app  && chown -R node:node /home/node/app

ENV YARN_VERSION 1.12.3
RUN curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz

WORKDIR /home/node/app

COPY package.json /home/node/app/package.json
COPY yarn.lock /home/node/app/yarn.lock
COPY packages/api/package.json /home/node/app/packages/api/package.json

RUN set -ex; \
    touch yarn-error.log; \
    mkdir -p -m 777 node_modules \
        packages/api/node_modules \
        packages/api/dist \
        /home/node/.cache/yarn; \
    chown -R node:node node_modules \
        packages/api/node_modules \
        packages/api/dist \
        package.json \
        yarn.lock \
        yarn-error.log \
        /home/node/.cache/yarn;

ENV PATH /home/node/app/node_modules/.bin:$PATH

USER node

ENTRYPOINT [ "./scripts/api.sh" ]



FROM dev AS test

RUN yarn --frozen-lockfile --no-cache
COPY packages/api /home/node/app/packages/api



FROM test AS build

RUN yarn workspace @monokit/api build


FROM node:10.15.0-alpine as production

COPY --from=build /home/node/app/api/dist /home/node/app/packages/api/dist