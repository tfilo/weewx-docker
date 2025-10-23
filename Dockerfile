FROM python:3.13-slim-trixie

ENV WEEWX_VERSION="5.2.0"
ENV LANG="sk_SK.UTF-8"
ENV TZ="Europe/Bratislava"

# Setup workdir and volume
WORKDIR /root
RUN mkdir /root/weewx-data
RUN mkdir /root/weewx-html

# update/install required packages
RUN apt update &&\
    apt install python3-pip python3-venv locales wget unzip -y &&\
    apt-get clean autoclean &&\
    apt-get autoremove --yes &&\
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# enable locale
RUN sed -i "/${LANG}/s/^# //g" /etc/locale.gen && locale-gen
ENV LC_ALL=${LANG}

# install weewx using pip
RUN python3 -m venv ~/weewx-venv
RUN . ~/weewx-venv/bin/activate
RUN python3 -m pip install weewx==${WEEWX_VERSION}

CMD [ "weewxd" ]
