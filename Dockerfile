FROM haskell:9.4 AS builder

WORKDIR /app

COPY *.cabal ./
RUN cabal update

COPY . .
RUN cabal install --install-method=copy --installdir=/dist

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y libgmp10 locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

WORKDIR /root/

COPY --from=builder /dist/NSemiGroup /usr/local/bin/nsgroup

CMD ["nsgroup"]