FROM akvo/akvo-node-17-alpine

RUN npm install -g selenium-side-runner

ADD run.sh /opt/bin/run.sh

RUN mkdir /sides

WORKDIR /root

VOLUME [ "/sides" ]

CMD "/opt/bin/run.sh"
