FROM akvo/akvo-node-17-alpine:20220121.024749.f30b815

RUN npm install -g selenium-side-runner@4.0.0-alpha.39

COPY run.sh /opt/bin/run.sh
RUN mkdir /sides
WORKDIR /root
VOLUME ["/sides"]

CMD ["/opt/bin/run.sh"]
