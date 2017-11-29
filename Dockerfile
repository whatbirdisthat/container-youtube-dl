FROM alpine

#RUN apk add --no-cache youtube-dl youtube-dl-bash-completion
RUN apk add --no-cache youtube-dl

ARG THEUSER=ytdl
RUN adduser -D -g '' ${THEUSER}
RUN chown -R ${THEUSER} /home/${THEUSER}
USER ${THEUSER}

ENTRYPOINT [ "youtube-dl" ]

