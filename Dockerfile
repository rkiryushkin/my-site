FROM alpine:3.12 as site
ENV HUGO_VERSION=0.81.0

# Install Hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp
RUN apk add --no-cache py-pygments ca-certificates \
    && cd /tmp \
    && tar -xf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz hugo \
    && mv /tmp/hugo /usr/local/bin/hugo \
    && rm -rf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

# Decide working directory
WORKDIR /site

# Copy all files to container
COPY . .

# Run build site
RUN hugo -D

# Pull nginx 
FROM nginx:1.18.0-alpine

# Copy static files
COPY --from=site /site/public /usr/share/nginx/html

# Expose port
EXPOSE 80

# Run nginx
CMD ["nginx","-g","daemon off;"]
