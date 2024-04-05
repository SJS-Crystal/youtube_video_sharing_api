FROM ruby:3.1.2

WORKDIR /app
COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install -j $(nproc)
RUN bundle lock --add-platform arm64-darwin-22
RUN bundle lock --add-platform aarch64-linux
RUN bundle lock --add-platform x86_64-linux
COPY . .
CMD ["rails", "s", "-p", "3000", "-b", "0.0.0.0"]
