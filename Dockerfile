FROM python:3-slim-trixie

ENV WEEWX_VERSION="5.4.0"
ENV REQUEST_VERSION="2.34.2"
ENV LANG="en_US.UTF-8"
ENV LC_ALL=${LANG}
ENV TZ="Etc/UTC"

# Setup workdir and volume
WORKDIR /root
RUN mkdir -p /root/weewx-data /root/weewx-html

VOLUME /root/weewx-data
VOLUME /root/weewx-html

# update/install required packages
RUN apt update &&\
    apt install -y python3-venv locales wget unzip &&\
    apt-get clean autoclean &&\
    apt-get autoremove --yes &&\
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# install weewx using pip
RUN python3 -m venv /root/weewx-venv && \
    /root/weewx-venv/bin/pip install --upgrade pip && \
    /root/weewx-venv/bin/pip install "weewx==${WEEWX_VERSION}" "requests==${REQUEST_VERSION}"

# copy entrypoint and make executable
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY logging.conf /root/logging.conf
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [ "weewxd" ]
