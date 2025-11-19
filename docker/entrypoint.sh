#!/bin/sh

# Vérifie que le hostname du backend est bien défini
if [ -z "${BACKEND_HOSTNAME}" ]; then
    echo "BACKEND_HOSTNAME not set"
    exit 1
fi

# HTTPS par défaut
HTTP_MODE=${HTTP_MODE:-https}

# Remplace l'URL par défaut du backend Piped dans les assets du frontend
# 1) Remplace https://pipedapi.kavin.rocks par http(s)://TON_BACKEND
sed -i "s@https://pipedapi.kavin.rocks@${HTTP_MODE}://${BACKEND_HOSTNAME}@g" /usr/share/nginx/html/assets/*

# 2) Remplace tous les pipedapi.kavin.rocks restants par TON_BACKEND
sed -i "s/pipedapi.kavin.rocks/${BACKEND_HOSTNAME}/g" /usr/share/nginx/html/assets/*

# Optionnel: modifier le nombre de workers Nginx
if [ -n "${HTTP_WORKERS}" ]; then
    sed -i "s/worker_processes  auto;/worker_processes  ${HTTP_WORKERS};/g" /etc/nginx/nginx.conf
fi

# Optionnel: changer le port HTTP exposé
if [ -n "${HTTP_PORT}" ]; then
    sed -i "s/80;/${HTTP_PORT};/g" /etc/nginx/conf.d/default.conf
fi

# Lance nginx en mode foreground
nginx -g "daemon off;"
