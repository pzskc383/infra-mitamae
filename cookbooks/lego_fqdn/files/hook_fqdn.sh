#!/bin/sh

set -eu

cp "${LEGO_CERT_PATH}" /etc/ssl/fqdn.crt
cp "${LEGO_CERT_KEY_PATH}" /etc/ssl/private/fqdn.key

chown root:_smtpd /etc/ssl/fqdn.crt /etc/ssl/private/fqdn.key
chmod 640 /etc/ssl/fqdn.crt /etc/ssl/private/fqdn.key

rm -f /etc/ssl/${LEGO_CERT_DOMAIN}.crt
ln -s /etc/ssl/fqdn.crt /etc/ssl/${LEGO_CERT_DOMAIN}.crt
rm -f /etc/ssl/private/${LEGO_CERT_DOMAIN}.key
ln -s /etc/ssl/private/fqdn.key /etc/ssl/private/${LEGO_CERT_DOMAIN}.key
