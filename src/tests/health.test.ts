import { expect, test } from 'vitest'

import type { VercelRequest, VercelResponse } from '@vercel/node'

import handler from '../../api/health'

// TODO: Implement this

test('health check returns 200', () => {
  const req = {} as VercelRequest
  const res = {
    status: (code: number) => ({
      send: (body: { status: string }) => {
        expect(code).toBe(200)
        expect(body).toEqual({ status: 'ok' })
      },
    }),
  } as VercelResponse
  handler(req, res)
})
