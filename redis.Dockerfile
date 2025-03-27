FROM redis:alpine

# Argumentos para a plataforma
ARG TARGETPLATFORM=linux/arm64

# Copiar o script de inicialização personalizado
COPY ./config/init-redis.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-redis.sh

# Criar diretório para dados do Redis
RUN mkdir -p /data && chown redis:redis /data

# Variável de ambiente para senha do Redis
ENV REDIS_PASSWORD=12345678

# Expor a porta do Redis
EXPOSE 6379

# Usar o usuário redis por segurança
USER redis

# Executar o script de inicialização
CMD ["/usr/local/bin/init-redis.sh"]