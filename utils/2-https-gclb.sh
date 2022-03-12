
DOMAIN=$1
IPNAME=${2:-my-external-ip}
REGION=us-central1

if test -z $DOMAIN;
then
    cat << EOD
  \$ $1 YOUR_DOMAIN
EOD
fi

echo "Creating a Serverless NEG"
gcloud compute network-endpoint-groups create gcs-proxy-serverless-neg \
    --region=$REGION \
    --network-endpoint-type=serverless  \
    --cloud-run-service=gcs-proxy

echo "Creating a Backend Service"
gcloud compute backend-services create gcs-proxy-backend-service \
    --global

echo "Adding the NEG to the Backend Service"
gcloud compute backend-services add-backend gcs-proxy-backend-service \
    --global \
    --network-endpoint-group=gcs-proxy-serverless-neg \
    --network-endpoint-group-region=$REGION

echo "Creating a UrlMap for the Backend Service"
gcloud compute url-maps create gcs-proxy-url-map \
    --default-service gcs-proxy-backend-service


echo "Creating a Managed Certificate $DOMAIN"
gcloud compute ssl-certificates create www-ssl-cert \
    --domains $DOMAIN

echo "Creating a Traget HTTPS Proxy"
gcloud compute target-https-proxies create gcs-proxy-https-proxy \
    --ssl-certificates=www-ssl-cert \
    --url-map=gcs-proxy-url-map

echo "Creating a Forwardint Rules for the Traget HTTPS Proxy"
gcloud compute forwarding-rules create https-forwarding-rule \
    --address=$IPNAME \
    --target-https-proxy=gcs-proxy-https-proxy \
    --global \
    --ports=443
