FROM ubuntu

ENV SEARCH_ROOT="."
ENV AGE_MINUTES=60

ENTRYPOINT /bin/bash -c 'while sleep 1; do find $SEARCH_ROOT \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -mmin +$AGE_MINUTES -delete; done'


