import { VERSION } from '@this/shared/constants.js'
import express from 'express'

const app = express();
const port = process.env.BACKEND_PORT

app.get('/', (req, res) => {
    res.json({
        title: 'PNPM + Docker'
    })
})

app.listen(port, () => {
    console.log('Version:', VERSION);
    console.log('Port:', port);
})