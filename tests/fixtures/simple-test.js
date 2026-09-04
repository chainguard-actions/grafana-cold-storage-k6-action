import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 1,
  iterations: 1,
  thresholds: {
    http_req_duration: ['p(95)<5000'],
  },
};

export default function () {
  const result = http.get('https://test-api.k6.io');
  check(result, {
    'http response status code is 200': result.status === 200,
  });
}
