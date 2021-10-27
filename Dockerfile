FROM python:3.9-alpine

ENV SKIDL_VER="1.1.0"
ENV FREEROUTING_VER="latest"

RUN apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk --no-cache add kicad --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN apk --no-cache add bash xdotool xvfb xclip 
RUN apk add --virtual .build-deps gcc musl-dev jpeg-dev zlib-dev libc-dev geos-dev geos libressl-dev musl-dev libffi-dev curl git ca-certificates jq

# Install SKiDL
COPY requirements.txt .
RUN echo -e "\nskidl==${SKIDL_VER}" >> requirements.txt
RUN pip3 install -r requirements.txt

# Install PCBFlow
RUN git clone https://github.com/michaelgale/pcbflow.git && \
    cd pcbflow && \
    python3 setup.py install && \
    cd $HOME

# Install Freerouting
RUN curl -s https://api.github.com/repos/freerouting/freerouting/releases/$FREEROUTING_VER | jq -r '.assets[] | select( .name | test(".jar") ) | .browser_download_url' | xargs curl -L -o freerouting.jar

# Install local scripts for automation
WORKDIR /home/automate
COPY scripts .

# Clean up
RUN apk del .build-deps

ENTRYPOINT ["/bin/bash"]