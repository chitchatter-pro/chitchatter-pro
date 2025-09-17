import { expect, test } from 'vitest'

import type { VercelRequest, VercelResponse } from '@vercel/node'

import handler from '../../api/stripe-webhook'

// TODO: Implement this

test('stripe webhook returns 200', () => {
  const req = {} as VercelRequest
  const res = {
    status: (code: number) => ({
      send: (body: { received: boolean }) => {
        expect(code).toBe(200)
        expect(body).toEqual({ received: true })
      },
    }),
  } as VercelResponse
  handler(req, res)
})
