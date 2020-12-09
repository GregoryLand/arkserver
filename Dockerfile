FROM thmhoag/steamcmd:latest
EXPOSE 7777/udp
EXPOSE 7777/tcp
EXPOSE 7778/udp
EXPOSE 7778/tcp
EXPOSE 27015/udp
EXPOSE 27015/tcp
EXPOSE 32330/udp
EXPOSE 32330/tcp

USER root

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl cron bzip2 perl-modules lsof libc6-i386 lib32gcc1 sudo

RUN curl -sL "https://raw.githubusercontent.com/FezVrasta/ark-server-tools/v1.6.57/netinstall.sh" | bash -s steam && \
    ln -s /usr/local/bin/arkmanager /usr/bin/arkmanager

COPY arkmanager/arkmanager.cfg /etc/arkmanager/arkmanager.cfg
COPY arkmanager/instance.cfg /etc/arkmanager/instances/main.cfg
COPY run.sh /home/steam/run.sh
COPY log.sh /home/steam/log.sh

RUN mkdir /ark && \
    chown -R steam:steam /home/steam/ /ark

RUN echo "%sudo   ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers && \
    usermod -a -G sudo steam && \
    touch /home/steam/.sudo_as_admin_successful

WORKDIR /home/steam
USER steam

ENV am_ark_SessionName="Lina's Loonies" \
    am_serverMap="TheIsland" \
    am_ark_ServerPassword="thistooktoodamnlong" \
    am_ark_ServerAdminPassword="yeaitdid" \
    am_ark_MaxPlayers=70 \
    am_ark_QueryPort=27015 \
    am_ark_Port=7778 \
    am_ark_RCONPort=32330 \
    am_ark_serverPVE=True \
    am_ark_DisableStructureDecayPvE=True \
    am_ark_DisableDinoDecayPvE=True \
    am_ark_AllowFlyerCarryPvE=True \
    am_ark_AllowCaveBuildingPvE=True \
    am_ark_EggHatchSpeedMultiplier=15.0 \
    am_ark_BabyMatureSpeedMultiplier=37.0 \
    am_ark_BabyImprintingStatScaleMultiplier=1.0 \
    am_ark_BabyCuddleIntervalMultiplier=0.08 \
    am_ark_BabyCuddleGracePeriodMultiplier=5.0 \
    am_ark_BabyCuddleLoseImprintQualitySpeedMultiplier=0.1 \
    am_arkwarnminutes=15 


VOLUME /ark

CMD [ "./run.sh" ]
