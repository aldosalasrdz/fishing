FROM ruby:3.2.2
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update -qq
RUN apt install -y build-essential yarn
WORKDIR /app
COPY . .
RUN bundle install
RUN yarn install
RUN gem install foreman
EXPOSE 3000
CMD ["bundle","exec","rails","server","-b","0.0.0.0","-p","3000”]
