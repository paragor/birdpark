FROM alpine:latest

RUN apk add bird

COPY bird.conf /bird.conf
COPY init_script.sh /init_script.sh
RUN chmod +x /init_script.sh
ENTRYPOINT [ "/init_script.sh" ]