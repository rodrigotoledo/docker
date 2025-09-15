ARG RUBY_VERSION=3.4.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

# UID/GID vindos do docker-compose.yml (definidos com id -u / id -g no .env)
ARG USER_ID=1000
ARG GROUP_ID=1000

# Instala dependências do sistema
RUN apt-get update -qq && apt-get install -y \
  curl \
  libjemalloc2 \
  libvips \
  vim \
  sqlite3 \
  libsqlite3-dev \
  libyaml-dev \
  libpq-dev \
  postgresql-client \
  build-essential \
  pkg-config \
  sudo \
  git \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Cria grupo e usuário com mesmo UID/GID do host
RUN groupadd -g ${GROUP_ID} appuser && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m appuser && \
    echo "appuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Cria diretórios de app/log/tmp/db com permissões
RUN mkdir -p /app/tmp /app/log /app/db && \
    chown -R appuser:appuser /app && \
    chmod -R 775 /app/tmp /app/log /app/db && \
    chmod g+s /app/db /app/tmp /app/log

USER appuser
WORKDIR /app

# Copia Gemfile e instala gems
COPY --chown=appuser:appuser Gemfile* ./
RUN gem install bundler foreman && \
    bundle lock --add-platform x86_64-linux && \
    bundle install

# Copia o restante do projeto
COPY --chown=appuser:appuser . /app
RUN rm -rf tmp/*

# Copie todo o código fonte para o contêiner
COPY . .

# Exponha a porta 3000 para o servidor Rails
EXPOSE 3000

# Inicialize o servidor Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
