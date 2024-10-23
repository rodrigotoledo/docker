# Use a imagem Ruby oficial com a versão 3.1
FROM ruby:3.1

# Atualize o sistema e instale as dependências
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Crie um diretório de trabalho no contêiner
WORKDIR /app

# Copie o Gemfile e o Gemfile.lock para o contêiner
COPY Gemfile ./

# Instale as gemas
RUN bundle install

# Copie todo o código fonte para o contêiner
COPY . .

# Exponha a porta 3000 para o servidor Rails
EXPOSE 3000

# Inicialize o servidor Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
