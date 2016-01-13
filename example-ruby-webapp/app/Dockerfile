# Use the onbuild ruby language image that installs our dependencies 
# and copies the app source automatically.
# See https://hub.docker.com/_/ruby/
FROM ruby:2.3-onbuild

# Set environment variables used by our app for configuration
ENV RACK_ENV  production
ENV REDIS_URL redis://redis:6379

# Open up port 5000 for consumption by other containers
EXPOSE 5000

# The default command to execute when running this container
CMD ["bundle", "exec", "puma", "-p", "5000"]