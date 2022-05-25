FROM python:3.9.13-slim

WORKDIR /docs
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      graphviz \
      imagemagick \
      make \
 && apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install -U pip
RUN python3 -m pip install \
    Sphinx==4.5.0 \
    Pillow \
    sphinx-rtd-theme==1.0.0

CMD ["make", "html"]
