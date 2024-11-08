# syntax = docker/dockerfile:1

# Definir a versão do Ruby
ARG RUBY_VERSION=3.2.0
FROM ruby:$RUBY_VERSION-slim AS base

# Diretório onde a aplicação Rails ficará
WORKDIR /rails

# Instalar dependências de sistema essenciais para o Rails
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    sqlite3 \
    build-essential \
    git \
    pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Variáveis de ambiente para o Rails em produção
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Fase de build para instalar as gems
FROM base AS build

# Copiar arquivos Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copiar o código da aplicação
COPY . .

# Pré-compilar os assets para produção
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Fase final para a imagem de produção
FROM base

# Copiar gems e arquivos da aplicação já preparados
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Criar e configurar o usuário não-root para segurança
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Preparar o banco de dados com o entrypoint
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expor a porta 3000 para o servidor Rails
EXPOSE 3000

# Comando padrão para iniciar o servidor Rails
CMD ["./bin/rails", "server"]
