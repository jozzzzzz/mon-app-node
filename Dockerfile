# Stage 1: Base - Utiliser Ubuntu pour récupérer les fichiers source
FROM ubuntu:20.04 as base
RUN apt-get update && apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Stage 2: Builder - Héberger l'application avec Apache
FROM httpd:2.4 as httpd
COPY --from=base /app /usr/local/apache2/htdocs/

# Stage 3: Nginx - Héberger l'application avec Nginx
FROM nginx:alpine as nginx
COPY --from=base /app /usr/share/nginx/html
