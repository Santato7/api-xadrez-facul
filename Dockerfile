FROM ruby:3.2

# Instala dependências
RUN apt-get update -qq && apt-get install -y libpq-dev build-essential

# Cria diretório da app
WORKDIR /app

# Copia arquivos
COPY . .

# Instala gems
RUN bundle install

# Expõe a porta padrão do Sinatra
EXPOSE 4567

# Inicia o servidor
CMD ["ruby", "app.rb"]
