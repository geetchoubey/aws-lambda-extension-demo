// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));

const dispatchPostUri = process.env.DISPATCH_POST_URI;
const dispatchMinBatchSize = parseInt(process.env.DISPATCH_MIN_BATCH_SIZE || 1);

async function dispatch(queue, force) {
  if (queue.length !== 0 && (force || queue.length >= dispatchMinBatchSize)) {
    console.log('[telementry-dispatcher:dispatch] Dispatching', queue.length, 'telemetry events');;
    const requestBody = JSON.stringify(queue);
    queue.splice(0);

    if (!dispatchPostUri){
      console.log('[telementry-dispatcher:dispatch] dispatchPostUri not found. Discarding log events from the queue');
      return;
    }
    console.log(`[telementry-dispatcher:dispatch] dispatchPostUri: ${dispatchPostUri}`);
    await fetch(dispatchPostUri, {
      method: 'POST',
      body: requestBody,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }
}

module.exports = {
  dispatch
}
