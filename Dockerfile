FROM piwik:3.0.0

RUN apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
		nginx ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 5000

COPY docker-entrypoint.sh /entrypoint.sh
COPY nginx.conf /etc/nginx/conf.d/piwik.conf

CMD ["nginx", "-g", "daemon off;"]
