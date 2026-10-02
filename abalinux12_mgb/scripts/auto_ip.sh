#!/bin/bash



# Datos de configuración
IP="10.55.96.200/24" # /24 equivale a 255.255.255.0
GATEWAY="10.55.96.1"
DNS="8.8.8.8"

# 1. Identificar la conexión cableada activa
# Filtra las conexiones de tipo '802-3-ethernet'
CONEXION=$(nmcli -t -f name,type connection show --active | grep ":802-3-ethernet$" | cut -d: -f1 | head -n 1)

if [ -z "$CONEXION" ]; then
    echo "Error: No se encontró ninguna conexión por cable activa."
    exit 1
fi

echo "Configurando la conexión: '$CONEXION'..."

# 2. Aplicar los cambios
nmcli connection modify "$CONEXION" \
    ipv4.addresses "$IP" \
    ipv4.gateway "$GATEWAY" \
    ipv4.dns "$DNS" \
    ipv4.method manual

# 3. Reiniciar la conexión para aplicar
nmcli connection up "$CONEXION"

echo "¡Configuración aplicada con éxito!"
echo "IP: $IP"
echo "Gateway: $GATEWAY"
echo "DNS: $DNS"
