import { sleep } from 'k6';
import { check } from 'k6';

export const options = {
  vus: 1,
  iterations: 1,
};

export default function () {
  // No external HTTP calls — just a simple check that always passes
  const result = check(true, {
    'always true': (v) => v === true,
  });
  sleep(0.1);
}
