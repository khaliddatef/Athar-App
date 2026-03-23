FROM node:20-bookworm-slim

WORKDIR /app

ENV NODE_ENV=production

COPY backend/package*.json ./
RUN npm ci --omit=dev

COPY backend/prisma ./prisma
COPY backend/prisma.config.ts ./
RUN npx prisma generate

COPY backend/src ./src
COPY backend/README.md ./README.md

EXPOSE 3000

CMD ["npm", "start"]
