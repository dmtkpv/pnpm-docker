import node from '@astrojs/node'
const { FRONTEND_PORT } = process.env;

export default {

    output: 'server',

    adapter: node({
        mode: 'standalone',
    }),

    server: {
        host: '0.0.0.0',
        port: +FRONTEND_PORT
    }

}