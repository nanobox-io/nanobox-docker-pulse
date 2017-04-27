FROM nanobox/runit

# Create directories
RUN mkdir -p \
  /var/log/gonano \
  /var/nanobox \
  /opt/nanobox/hooks

# Don't use apt-get to install influx until 1.0 gets to the main repo

# Install influxdb and rsync
# RUN apt-get update -qq && \
#     apt-get install -y apt-transport-https && \
#     curl -sL https://repos.influxdata.com/influxdb.key | apt-key add - && \
#     echo "deb https://repos.influxdata.com/ubuntu trusty stable" \
#       > /etc/apt/sources.list.d/influxdb.list && \
#     apt-get update -qq && \
#     apt-get install -y rsync influxdb && \
#     apt-get clean all && \
#     rm -rf /var/lib/apt/lists/*

RUN apt-get update -qq && \
    apt-get install -y rsync && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# Install influx
RUN wget -O /tmp/influxdb_1.2.2_amd64.deb https://dl.influxdata.com/influxdb/releases/influxdb_1.2.2_amd64.deb && \
    dpkg -i /tmp/influxdb_1.2.2_amd64.deb && \
    rm /tmp/influxdb_1.2.2_amd64.deb

# Install kapacitor
RUN wget -O /tmp/kapacitor_1.2.0_amd64.deb https://dl.influxdata.com/kapacitor/releases/kapacitor_1.2.0_amd64.deb && \
    dpkg -i /tmp/kapacitor_1.2.0_amd64.deb && \
    rm /tmp/kapacitor_1.2.0_amd64.deb

# Download pulse
RUN curl \
      -f \
      -k \
      -o /usr/local/bin/pulse \
      https://s3.amazonaws.com/tools.nanopack.io/pulse/linux/amd64/pulse && \
    chmod 755 /usr/local/bin/pulse

# Download md5 (used to perform updates in hooks)
RUN curl \
      -f \
      -k \
      -o /var/nanobox/pulse.md5 \
      https://s3.amazonaws.com/tools.nanopack.io/pulse/linux/amd64/pulse.md5

# Install hooks
RUN curl \
      -f \
      -k \
      https://s3.amazonaws.com/tools.nanobox.io/hooks/pulse-stable.tgz \
        | tar -xz -C /opt/nanobox/hooks

# Download hooks md5 (used to perform updates)
RUN curl \
      -f \
      -k \
      -o /var/nanobox/hooks.md5 \
      https://s3.amazonaws.com/tools.nanobox.io/hooks/pulse-stable.md5

# Run runit automatically
CMD [ "/opt/gonano/bin/nanoinit" ]
