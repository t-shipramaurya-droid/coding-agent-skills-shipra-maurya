# Build Rust scoring engine
FROM rust:1.83-bookworm AS engine-build
WORKDIR /build/engine
COPY engine/ ./
RUN cargo build --release

# Node worker runtime
FROM node:20-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=engine-build /build/engine/target/release/fraud-score /usr/local/bin/fraud-score

WORKDIR /app
COPY worker/package.json ./
COPY worker/src ./src

ENV FRAUD_API_URL=http://api:8100 \
    FRAUD_ENGINE_PATH=/usr/local/bin/fraud-score \
    WORKER_POLL_MS=3000

CMD ["npm", "start"]
