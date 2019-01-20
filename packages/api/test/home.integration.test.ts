import * as request from 'supertest';
import * as test from 'tape';
import app from '../src/server';

test('/ Route should return "hello world"', async t => {
    t.plan(2);
    const response = await request(app.callback()).get('/');

    t.equal(response.status, 200);
    t.equal(response.text, "Hello World");
})