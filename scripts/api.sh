#!/bin/sh

dev() {
    yarn install
    yarn workspace @monokit/api dev
}

test() {
    yarn workspace @monokit/api test
}

if [ "${NODE_ENV}" = "test" ]; then
    test
else
    dev
fi
