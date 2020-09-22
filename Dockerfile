#
# Build image
#

FROM node:12 as builder

#RUN apk add --no-cache make gcc g++ python bash git openssh

RUN mkdir /app

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build && npm ci --production

#
# Production image
#

FROM node:12-slim as app

RUN mkdir /app

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/bin ./bin

ENV NODE_ENV=production

CMD ["./bin/wt-tracker"]
