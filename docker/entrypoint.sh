#!/bin/sh

# Vérifie que le backend est défini
if [ -z "${BACKEND_HOSTNAME}" ]; then
    echo "BACKEND_HOSTNAME not set"
    exit 1
fi

# https par défaut
HTTP_MODE=${HTTP_MODE:-https}

# Remplace l'ancien backend par le nouveau dans tous les assets du frontend
# ancien : backend-fuvb.onrender.com
# nouveau : ${BACKEND_HOSTNAME}
sed -i "s@https://backend-fuvb.onrender.com@${HTTP_MODE}://${BACKEND_HOSTNAME}@g" /usr/share/nginx/html/assets/*
sed -i "s/backend-fuvb.onrender.com/${BACKEND_HOSTNAME}/g" /usr/share/nginx/html/assets/*

# Optionnel : modifier worker_processes
if [ -n "${HTTP_WORKERS}" ]; then
    sed -i "s/worker_processes  auto;/worker_processes  ${HTTP_WORKERS};/g" /etc/nginx/nginx.conf
fi

# Optionnel : modifier le port du serveur
if [ -n "${HTTP_PORT}" ]; then
    sed -i "s/80;/${HTTP_PORT};/g" /etc/nginx/conf.d/default.conf
fi

# Démarre nginx
nginx -g "daemon off;"
