CLoud Front Command Line Demo
=============================

# Prerequisite

AWS CLI

    pip install awscli

    # Configure AWS CLI
    aws configure

    # Enable CloudFront preview
    aws configure set preview.cloudfront true


# Create Distribution

    aws cloudfront create-distribution --distribution-config \
    '{
      "CallerReference": "UNIQUE_STRING",
      "Aliases": {
        "Quantity": 0
      },
      "DefaultRootObject": "index.html",
      "Origins": {
        "Quantity": 1,
        "Items": [
          {
            "Id": "ORIGIN_ID",
            "DomainName": "ORIGIN_DOMAIN",
            "S3OriginConfig": {
              "OriginAccessIdentity": null
            }
          }
        ]
      },
      "DefaultCacheBehavior": {
        "TargetOriginId": "ORIGIN_ID",
        "ForwardedValues": {
          "QueryString": true,
          "Cookies": {
            "Forward": "none"
          },
          "Headers": {
            "Quantity": 0
          }
        },
        "TrustedSigners": {
          "Enabled": false,
          "Quantity": 0
        },
        "ViewerProtocolPolicy": "allow-all",
        "MinTTL": 0,
        "AllowedMethods": {
          "Quantity": 2,
          "Items": ["GET", "HEAD"]
        },
        "SmoothStreaming": false
      },
      "CacheBehaviors": {
        "Quantity": 1,
        "Items": [
          {
            "PathPattern": "*.jpg",
            "TargetOriginId": "ORIGIN_ID",
            "ForwardedValues": {
              "QueryString": false,
              "Cookies": {
                "Forward": "none"
              },
              "Headers": {
                "Quantity": 0
              }
            },
            "TrustedSigners": {
              "Enabled": false,
              "Quantity": 0
            },
            "ViewerProtocolPolicy": "allow-all",
            "MinTTL": 0,
            "AllowedMethods": {
              "Quantity": 2,
              "Items": ["GET", "HEAD"]
            },
            "SmoothStreaming": false
          }
        ]
      },
      "CustomErrorResponses": {
        "Quantity": 1,
        "Items": [
          {
            "ErrorCode": 404,
            "ResponsePagePath": "/404.html",
            "ResponseCode": "404",
            "ErrorCachingMinTTL": 300
          }
        ]
      },
      "Comment": "My distribution created by AWS CLI",
      "Logging": {
        "Enabled": true,
        "IncludeCookies": false,
        "Bucket": "LOGGING_S3_BUCKET",
        "Prefix": "logs/cloudfront/"
      },
      "PriceClass": "PriceClass_All",
      "Enabled": true,
      "ViewerCertificate": {
        "CloudFrontDefaultCertificate": true
      },
      "Restrictions": {
        "GeoRestriction": {
          "RestrictionType": "none",
          "Quantity": 0
        }
      }
    }'


# List Distribution

    aws cloudfront list-distributions

# Get Distribution

    aws cloudfront get-distribution --id DISTRIBUTION_ID

# Sync images to S3

    aws s3 sync --acl=public-read images/ s3://BUCKET/images/

# Access image on S3

    https://s3-REGION.amazonaws.com/BUCKET/images/myimage.jpg

# Access images via CloudFront

    xxxxxxxx.cloudfront.net/images/myimage.jpg

# Blacklist / Whitelist

    aws cloudfront update-distribution --id DISTRIBUTION_ID \
    --if-match ETAG_VALUE \
    --distribution-config \
    '{
      "CallerReference": "UNIQUE_STRING",
      "Aliases": {
        "Quantity": 0
      },
      "DefaultRootObject": "index.html",
      "Origins": {
        "Quantity": 1,
        "Items": [
          {
            "Id": "ORIGIN_ID",
            "DomainName": "ORIGIN_DOMAIN",
            "S3OriginConfig": {
              "OriginAccessIdentity": null
            }
          }
        ]
      },
      "DefaultCacheBehavior": {
        "TargetOriginId": "ORIGIN_ID",
        "ForwardedValues": {
          "QueryString": true,
          "Cookies": {
            "Forward": "none"
          },
          "Headers": {
            "Quantity": 0
          }
        },
        "TrustedSigners": {
          "Enabled": false,
          "Quantity": 0
        },
        "ViewerProtocolPolicy": "allow-all",
        "MinTTL": 0,
        "AllowedMethods": {
          "Quantity": 2,
          "Items": ["GET", "HEAD"]
        },
        "SmoothStreaming": false
      },
      "CacheBehaviors": {
        "Quantity": 1,
        "Items": [
          {
            "PathPattern": "*.jpg",
            "TargetOriginId": "ORIGIN_ID",
            "ForwardedValues": {
              "QueryString": false,
              "Cookies": {
                "Forward": "none"
              },
              "Headers": {
                "Quantity": 0
              }
            },
            "TrustedSigners": {
              "Enabled": false,
              "Quantity": 0
            },
            "ViewerProtocolPolicy": "allow-all",
            "MinTTL": 0,
            "AllowedMethods": {
              "Quantity": 2,
              "Items": ["GET", "HEAD"]
            },
            "SmoothStreaming": false
          }
        ]
      },
      "CustomErrorResponses": {
        "Quantity": 1,
        "Items": [
          {
            "ErrorCode": 404,
            "ResponsePagePath": "/404.html",
            "ResponseCode": "404",
            "ErrorCachingMinTTL": 300
          }
        ]
      },
      "Comment": "My distribution created by AWS CLI",
      "Logging": {
        "Enabled": true,
        "IncludeCookies": false,
        "Bucket": "LOGGING_S3_BUCKET",
        "Prefix": "logs/cloudfront/"
      },
      "PriceClass": "PriceClass_All",
      "Enabled": true,
      "ViewerCertificate": {
        "CloudFrontDefaultCertificate": true
      },
      "Restrictions": {
        "GeoRestriction": {
          "RestrictionType": "whitelist",
          "Quantity": 1,
          "Items": ["JP"]
        }
      }
    }'


# Invalidate Objects

    aws cloudfront create-invalidation --distribution-id DISTRIBUTION_ID \
    --invalidation-batch \
    '{
        "Paths": {
          "Quantity": 2,
          "Items": ["/images/myimage1.jpg", "/images/myimage2.jpg"]
        },
        "CallerReference": "UNIQUE_STRING"
      }'


# Generate loads to demo real-time monitoring feature

    ./cfdemo
