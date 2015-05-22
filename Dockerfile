FROM ubuntu:14.04.2
MAINTAINER Doro Wu <fcwu.tw@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        sikuli-ide firefox \
        fonts-wqy-microhei \
        language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant \
        nginx \
        python-pip python-dev build-essential \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD web /web/
RUN pip install -r /web/requirements.txt

ADD noVNC /noVNC/
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/

RUN echo "#!/bin/sh" > /usr/bin/sikuli-ide
RUN echo "LC_NUMERIC=C exec /usr/bin/java -cp \"/usr/share/maven-repo/com/google/guava/guava/debian/guava-debian.jar:/usr/share/maven-repo/org/jruby/ext/posix/jnr-posix/debian/jnr-posix-debian.jar:/usr/share/java/jaffl.jar:/usr/share/java/jna.jar:/usr/share/java/asm3.jar:/usr/share/java/asm3-commons.jar:/usr/share/java/antlr3-runtime.jar:/usr/share/java/libconstantine-java.jar:/usr/share/java/jython.jar:/usr/share/java/commons-cli.jar:/usr/share/java/JXGrabKey.jar:/usr/share/java/json_simple.jar:/usr/share/java/swing-layout.jar:/usr/share/java/swingx-core.jar:/usr/share/java/forms.jar:/usr/share/java/jgoodies-common.jar:/usr/share/java/mac_widgets.jar:/usr/share/java/junit.jar:/usr/share/sikuli/sikuli-ide.jar:/usr/share/java/sikuli-script.jar\" -Dsikuli.console=true -Dsikuli.debug=0 -Xms64M -Xmx512M -Dfile.encoding=UTF-8 -Dpython.home=/usr/share/jython -Dpython.path=\"/usr/share/sikuli/Lib\" -Dpython.cachedir=$HOME/.jython-cache org.sikuli.ide.SikuliIDE \"$@\"" >> /usr/bin/sikuli-ide

EXPOSE 6080
WORKDIR /root
ENTRYPOINT ["/startup.sh"]
