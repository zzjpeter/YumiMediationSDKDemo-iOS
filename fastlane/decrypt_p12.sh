#!/bin/bash
if [ -z "$ENCRYPTION_PASSWORD" ]; then
  echo "no password, stop here..."
else
  openssl aes-256-cbc -k $ENCRYPTION_PASSWORD -in fastlane/Certificates/distribution.p12.enc -d -a -out fastlane/Certificates/distribution.p12
fi
