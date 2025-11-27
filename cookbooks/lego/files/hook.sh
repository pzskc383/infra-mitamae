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
    cp "${keyfile}" "/etc/ssl/${domain}.key" || _err "Failed to copy key"

    # fix perms
    chown root:wheel "/etc/ssl/${domain}.crt" "/etc/ssl/${domain}.key"
    chmod 640 "/etc/ssl/${domain}.crt" "/etc/ssl/${domain}.key"

    _log "Distributing certificates to other hosts"
    rdist -f /var/lego/distfile

    _log "Restarting services locally"
    for svc in httpd relayd dovecot smtpd; do
        if rcctl check "$svc" >/dev/null 2>&1; then
            _log "Restarting $svc"
            rcctl restart "$svc" || _log "Failed to restart $svc"
        fi
    done

    _log "Certificate deployed successfully"
}

deploy_cert

# vim: sts=4 ts=4 sw=4 et
