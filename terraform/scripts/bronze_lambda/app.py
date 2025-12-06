import json
import boto3

s3 = boto3.client("s3")

import os

TARGET_BUCKET = os.environ["TARGET_BUCKET"]

def handler(event, context):
    print("Event:", event)

    for record in event.get("Records", []):
        body = record.get("body")

        try:
            sns_payload = json.loads(body)
        except:
            sns_payload = None

        if sns_payload and "Message" in sns_payload:
            try:
                original = json.loads(sns_payload["Message"])
            except:
                original = sns_payload["Message"]
        else:
            try:
                original = json.loads(body)
            except:
                original = body

        if not isinstance(original, dict):
            continue

        # We expect an S3 event
        if "Records" not in original:
            continue

        for s3rec in original["Records"]:
            src_bucket = s3rec["s3"]["bucket"]["name"]
            src_key = s3rec["s3"]["object"]["key"]

            print(f"Source bucket={src_bucket}, key={src_key}")

            # Define destination
            dest_bucket = TARGET_BUCKET
            dest_key = src_key  # same key

            print(f"Copying to => bucket={dest_bucket}, key={dest_key}")

            # Actual copy operation
            s3.copy_object(
                CopySource={"Bucket": src_bucket, "Key": src_key},
                Bucket=dest_bucket,
                Key=dest_key
            )

    return {"status": "copied-to-silver"}
