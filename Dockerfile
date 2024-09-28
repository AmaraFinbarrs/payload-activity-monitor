# Use a lightweight Ruby image
FROM ruby:3.1.2

# Set environment variables
ENV RAILS_ENV=production
ENV APP_HOME=/app

# Install necessary dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn

# Set the working directory inside the container
WORKDIR $APP_HOME

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Configure bundler to exclude development and test groups
RUN bundle config set --local without 'development test'

# Install the gems
RUN bundle install

# Copy the entire app into the container
COPY . .

# Precompile assets (if needed) and setup the Rails app
RUN bundle exec rails db:setup

# Expose the port the app runs on
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
