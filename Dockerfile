FROM ruby:2.6.5
ENV TZ Asia/Tokyo

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs \
    && npm install -g yarn

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# Yarnパッケージのインストール
COPY app/package.json app/yarn.lock /myapp/app/
WORKDIR /myapp/app
RUN yarn install
WORKDIR /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
