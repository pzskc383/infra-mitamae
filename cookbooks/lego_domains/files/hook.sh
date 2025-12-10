#!/bin/ksh

set -eu

_log() {
    echo " + $*"
    logger -t lego-hook "$*"
}

_err() {
    _log "ERROR: $*"
    exit 1
}

# deploy certificate after successful acquisition
deploy_cert() {
    domain="${LEGO_CERT_DOMAIN}"
    keyfile="${LEGO_CERT_KEY_PATH}"
    certfile="${LEGO_CERT_PATH}"

    _log "Deploying cert for ${domain}"

    # copy to /etc/ssl/ (relayd format)
    cp "${certfile}" "/etc/ssl/${domain}.crt" || _err "Failed to copy cert"
    cp "${keyfile}" "/etc/ssl/private/${domain}.key" || _err "Failed to copy key"

    # fix perms
    chown root:wheel "/etc/ssl/${domain}.crt" "/etc/ssl/private/${domain}.key"
    chmod 640 "/etc/ssl/${domain}.crt" "/etc/ssl/private/${domain}.key"

    _log "Distributing certificates to other hosts"
    rdist -P "/usr/bin/ssh -p 38322" -f /var/lego/distfile

    touch /etc/ssl/.needs_restart

    _log "Certificate deployed successfully"
}

deploy_cert

# vim: sts=4 ts=4 sw=4 et
