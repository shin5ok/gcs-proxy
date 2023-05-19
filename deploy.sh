#!/bin/sh
IMAGE=gcr.io/$PROJECT/gcs-proxy:$(date '+%Y%m%d%H%M')
INSTANCES_COUNT=${INSTANCES_COUNT:-2}
REGION=${REGION:asia-northeast1}

gcloud builds submit -t $IMAGE && \
gcloud beta run deploy \
--image=$IMAGE \
--platform=managed \
--allow-unauthenticated \
--region=$REGION \
--set-env-vars=GCS_BUCKET=$GCS_BUCKET \
--project=$PROJECT \
gcs-proxy \
--min-instances $INSTANCES_COUNT \
--max-instances $INSTANCES_COUNT \
--no-cpu-throttling \
--execution-environment=gen2

