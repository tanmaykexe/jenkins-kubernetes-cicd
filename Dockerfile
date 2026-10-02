FROM nginx:alpine

COPY app.txt /usr/share/nginx/html/index.html

EXPOSE 80
