# Use the official logstash image from docker hub
FROM logstash
# Install logstash plugin for consuming RSS feeds
RUN /opt/logstash/bin/plugin install logstash-input-rss
# Copy our custom logstash configuration file into our image
ADD logstash.conf /logstash.conf