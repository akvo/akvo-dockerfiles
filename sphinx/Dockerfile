FROM python:3.9.13-slim

WORKDIR /docs
COPY . .
RUN ./run.sh

CMD ["make", "html"]
