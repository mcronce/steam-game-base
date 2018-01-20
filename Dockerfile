FROM debian
MAINTAINER mcronce@sevone.com

RUN \
	apt-get update && \
	apt-get install -y lib32gcc1 && \
	rm -Rvf /var/lib/apt/*

RUN mkdir -pv /opt/steamcmd /app

# TODO:  Find a repo with steamcmd in it
RUN \
	apt-get update && \
	apt-get install -y curl && \
	curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -zxv -C /opt/steamcmd/ && \
	chown -Rc root:root /app && \
	apt-get remove -y curl && \
	apt-get autoremove -y && \
	rm -Rvf /var/lib/apt/*

# This will update steamcmd
RUN \
	/opt/steamcmd/steamcmd.sh +login anonymous +quit && \
	rm -Rvf /root/Steam

ADD steamcmd functions.sh /app/

