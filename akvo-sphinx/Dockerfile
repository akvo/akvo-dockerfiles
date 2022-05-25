FROM python:3.9.13-slim

COPY requirements.txt /docs/requirements.txt

WORKDIR /docs
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      graphviz=3.0.0 \
      imagemagick=7.1.0 \
      make=3.75.1 \
 && apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && pip install -r requirements.txt \

CMD ["make", "html"]
