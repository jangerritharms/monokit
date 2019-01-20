#!/bin/sh

dev() {
    yarn install
    yarn workspace @monokit/api dev
}

test() {
    yarn workspace @monokit/api test
}

production() {
    yarn workspace @monokit/api production
}

if [ "${NODE_ENV}" = "test" ]; then
    test
elif [ "${NODE_ENV}" = "production" ]; then
    production
else
    dev
fi
