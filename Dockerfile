FROM mirror.gcr.io/library/node:18-alpine AS api

WORKDIR /api

COPY ./api .

RUN npm ci
RUN npm run build

FROM mirror.gcr.io/library/node:18-alpine AS ui

WORKDIR /ui

COPY ./ui .

RUN npm ci
RUN npm run build

FROM mirror.gcr.io/library/node:18-alpine AS package

WORKDIR /opt/rackpilot

COPY ./api/package*.json ./
COPY --from=api /api/dist ./dist
COPY --from=ui /ui/dist/ui ./assets

RUN npm ci --omit=dev

# Expose the port
EXPOSE 3000

# Start the app
CMD [ "node", "./dist/main.js" ]