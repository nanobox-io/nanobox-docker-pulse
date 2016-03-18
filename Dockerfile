FROM nanobox/runit

# Create directories
RUN mkdir -p \
  /var/log/gonano \
  /var/nanobox \
  /opt/nanobox/hooks

# Install rsync
RUN apt-get update -qq && \
    apt-get install -y rsync && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

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

# # Install hooks
# RUN curl \
#       -f \
#       -k \
#       https://s3.amazonaws.com/tools.nanobox.io/hooks/pulse-stable.tgz \
#         | tar -xz -C /opt/nanobox/hooks
#
# # Download hooks md5 (used to perform updates)
# RUN curl \
#       -f \
#       -k \
#       -o /var/nanobox/hooks.md5 \
#       https://s3.amazonaws.com/tools.nanobox.io/hooks/pulse-stable.md5

# Run runit automatically
CMD [ "/opt/gonano/bin/nanoinit" ]
