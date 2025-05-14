FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y libpq-dev build-essential

WORKDIR /app

COPY . .

RUN bundle install

EXPOSE 4567

CMD ["ruby", "app.rb"]