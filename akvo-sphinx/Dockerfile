FROM python:3.9.13-slim

WORKDIR /docs
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      graphviz=3.0.0 \
      imagemagick=7.1.0 \
      make=3.75.1 \
 && apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && python3 -m pip install -U pip \
 && python3 -m pip install \
    Sphinx==4.5.0 \
    Pillow \
    sphinx-rtd-theme==1.0.0

CMD ["make", "html"]
