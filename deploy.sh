IMAGE=gcr.io/$PROJECT/gcs-proxy:$(date '+%Y%m%d%H%M')

gcloud builds submit -t $IMAGE && \
gcloud beta run deploy \
--image=$IMAGE \
--platform=managed \
--allow-unauthenticated \
--region=us-central1 \
--set-env-vars=GCS_BUCKET=$GCS_BUCKET \
--project=$PROJECT \
gcs-proxy \
--min-instances 2 \
--execution-environment=gen2 \
--no-cpu-throttling