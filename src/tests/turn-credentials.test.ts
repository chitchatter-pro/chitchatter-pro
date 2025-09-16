import { expect, test } from 'vitest'

import type { VercelRequest, VercelResponse } from '@vercel/node'

import handler from '../../api/turn-credentials'

// TODO: Implement this

test('turn credentials returns 200', () => {
  const req = {} as VercelRequest
  const res = {
    status: (code: number) => ({
      send: (body: { urls: string; username: string; credential: string }) => {
        expect(code).toBe(200)
        expect(body).toEqual({
          urls: 'turn:dummy-turn-server.com:3478',
          username: 'dummy-user',
          credential: 'dummy-password',
        })
      },
    }),
  } as VercelResponse
  handler(req, res)
})
