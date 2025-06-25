# --- build stage ---
FROM node:18-alpine AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --production
COPY . .
RUN npm run build

# --- runtime stage ---
FROM node:18-alpine
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/dist ./dist
COPY package*.json ./
RUN npm install --production
EXPOSE 4000
CMD ["node","dist/index.js","--url","${SUPABASE_URL}","--anon-key","${SUPABASE_ANON_KEY}"]

