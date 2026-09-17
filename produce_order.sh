#!/usr/bin/env bash

# ======= Configuration =======
BOOTSTRAP="localhost:9092"
TOPIC="orders"

# À adapter selon ton installation Kafka
KAFKA_HOME="/opt/kafka"
KAFKA_BIN="$KAFKA_HOME/bin"
PRODUCER="$KAFKA_BIN/kafka-console-producer.sh"

# 30 commandes / minute => 1 message toutes les 2 secondes
SLEEP_SECONDS=2

# Point de départ des IDs
ID=1452

echo
echo "===== Kafka Orders Producer Simulator ====="
echo "Bootstrap: $BOOTSTRAP"
echo "Topic:     $TOPIC"
echo "Rate:      30 msg/min (1 msg / ${SLEEP_SECONDS}s)"
echo "Press CTRL+C to stop."
echo

# ======= Boucle infinie =======
while true; do

    # Sélection pseudo-aléatoire du produit
    R=$(( RANDOM % 6 ))

    case "$R" in
        0)
            PRODUCT="laptop"
            PRICE=500
            ;;
        1)
            PRODUCT="mouse"
            PRICE=25
            ;;
        2)
            PRODUCT="keyboard"
            PRICE=70
            ;;
        3)
            PRODUCT="screen"
            PRICE=180
            ;;
        4)
            PRODUCT="headset"
            PRICE=60
            ;;
        5)
            PRODUCT="ssd"
            PRICE=120
            ;;
    esac

    # Quantité aléatoire entre 1 et 4
    QTY=$(( RANDOM % 4 + 1 ))

    # Prix total
    TOTAL=$(( PRICE * QTY ))

    # Timestamp ISO
    TS=$(date '+%Y-%m-%dT%H:%M:%S')

    # Construction du JSON
    JSON="{ \"id_order\": $ID, \"product_name\": \"$PRODUCT\", \"nombre\": $QTY, \"total_price\": $TOTAL, \"ts\": \"$TS\" }"

    echo "Sending: $JSON"

    # Envoyer le message à Kafka
    echo "$JSON" | "$PRODUCER" \
        --bootstrap-server "$BOOTSTRAP" \
        --topic "$TOPIC" \
        >/dev/null

    # Incrémenter l'ID
    ID=$(( ID + 1 ))

    # Attendre 2 secondes
    sleep "$SLEEP_SECONDS"

done