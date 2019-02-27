#FROM debian
#RUN apt-get install libdw-dev
#RUN mkdir -p /usr/local/apprun
#CMD /usr/local/apprun/app/run.sh


FROM debian:latest

# docker build -t spedservice .

# LIBS PRE-REQUISITOS
RUN apt-get -y update && apt-get -y install libdw-dev \
  libxcb-xinerama0-dev \
  libgl1-mesa-dev \
  libgl1-mesa-glx \
  libglib2.0-0 \
  libnss3-dev \
  unixodbc \
  unixodbc-dev \
  freetds-dev \
  freetds-bin \
  tdsodbc \
  postgresql-server-dev-all \
  sudo \
  #ubuntu-sdk \
  build-essential \
  mcedit iputils-ping

RUN apt install -y libxcomposite-dev libxcursor1 libxi6 libgconf-2-4 libxtst6 libfontconfig default-dbus-session-bus libxrandr2 libasound2 libegl1-mesa tar openssh-server openssh-client curl

RUN useradd -G root user

# USUARIO
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/user && \
    echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
    echo "user:x:${uid}:" >> /etc/group && \
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user && \
    chown ${uid}:${gid} -R /home/user

USER user
ENV HOME /home/user

ENV DIR_PROJETO_QT app

VOLUME ["/tmp/.X11-unix", "/tmp/.X11-unix"]

ADD dockerRun.sh $HOME/dockerRun.sh

WORKDIR $HOME

#COPY /qt/odbcinst.ini /etc/
#COPY /qt/odbc.ini /etc/
# docker run -ti --rm -v $(pwd)/app/:/home/user/app/ -v /usr/local/appversion/qtlibs/qt5.9.3:/home/user/qt/ -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix 192.168.6.184:5000/ithappens/spedservice:latest bash start.sh