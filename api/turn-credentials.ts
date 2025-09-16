import type { VercelRequest, VercelResponse } from '@vercel/node'

export default (_req: VercelRequest, res: VercelResponse) => {
  res.status(200).send({
    urls: 'turn:dummy-turn-server.com:3478',
    username: 'dummy-user',
    credential: 'dummy-password',
  })
}
