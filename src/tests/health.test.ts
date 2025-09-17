import { expect, test, vi } from 'vitest'

import type { VercelRequest, VercelResponse } from '@vercel/node'

import handler from '../../api/health'

test('health check returns 200', () => {
  const req = {} as VercelRequest
  const res = {
    status: vi.fn().mockReturnThis(),
    send: vi.fn(),
  } as unknown as VercelResponse

  handler(req, res)

  expect(res.status).toHaveBeenCalledWith(200)
  expect(res.send).toHaveBeenCalledWith({ status: 'ok' })
})
