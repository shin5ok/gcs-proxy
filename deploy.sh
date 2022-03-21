#!/bin/sh
IMAGE=gcr.io/$PROJECT/gcs-proxy:$(date '+%Y%m%d%H%M')
INSTANCES_COUNT=${INSTANCES_COUNT:-2}

gcloud builds submit -t $IMAGE && \
gcloud beta run deploy \
--image=$IMAGE \
--platform=managed \
--allow-unauthenticated \
--region=us-central1 \
--set-env-vars=GCS_BUCKET=$GCS_BUCKET \
--project=$PROJECT \
gcs-proxy \
--ingress=internal-and-cloud-load-balancing \
--min-instances $INSTANCES_COUNT \
--max-instances $INSTANCES_COUNT \
--no-cpu-throttling \
--execution-environment=gen2

