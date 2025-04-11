# Etapa 1: build do projeto
FROM node:18-alpine AS builder

# Adiciona link do repositório
LABEL org.opencontainers.image.source="https://github.com/atendefacil-ai/${REPO_NAME}"

WORKDIR /app
COPY . .

RUN npm install
RUN npm run build

# Etapa 2: servir com Nginx
FROM nginx:alpine

# Remove configurações padrão
RUN rm -rf /usr/share/nginx/html/* /etc/nginx/conf.d/*

# Copia build e configuração
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
