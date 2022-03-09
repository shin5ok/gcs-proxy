FROM google/cloud-sdk:latest

RUN apt update && apt install -y libnginx-mod-http-lua cron supervisor procps nginx gettext-base
COPY ./default /etc/nginx/sites-enabled/
COPY supervisord.conf /etc/supervisor/
COPY renew-token /etc/cron.d/
RUN rm -Rf /var/log/nginx/*.log ; ln -s /dev/stderr /var/log/nginx/error.log && ln -s /dev/stdout /var/log/nginx/access.log
ENV GCS_BUCKET shingo-ar-bne0308
CMD ["supervisord"]
