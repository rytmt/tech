# usage: docker run --net host --rm --env-file env.list arpreq
# env.list must not contain single or double quote.

FROM python:3.8-slim

ENV http_proxy http://proxy.local:8080
ENV https_proxy http://proxy.local:8080

RUN mkdir /arpreq
COPY ./arpreq.py /arpreq

RUN pip install scapy

WORKDIR /arpreq
CMD ["python", "arpreq.py"]
