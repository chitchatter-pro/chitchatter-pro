import type { VercelRequest, VercelResponse } from '@vercel/node'

export default (_req: VercelRequest, res: VercelResponse) => {
  res.status(200).send({
    urls: process.env.TURN_URL || 'turn:dummy-turn-server.com:3478',
    username: process.env.TURN_USERNAME || 'dummy-user',
    credential: process.env.TURN_PASSWORD || 'dummy-password',
  })
}
