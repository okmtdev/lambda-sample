FROM public.ecr.aws/lambda/provided:al2

COPY ./docker/lambda/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/main"]