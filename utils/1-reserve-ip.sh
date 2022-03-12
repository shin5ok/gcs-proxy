
IPNAME=${1:-my-external-ip}

echo "Reserving an External Global IP as '$IPNAME'"
gcloud compute addresses create $IPNAME \
    --ip-version=IPV4 \
    --global
IP=$(gcloud compute addresses describe $IPNAME \
    --format="get(address)" \
    --global)

echo "$IPNAME has been created"
echo "Configure your DNS to point your FQDN $IP"