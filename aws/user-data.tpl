#!/bin/bash

# create replicated unattended installer config
cat > /etc/replicated.conf <<EOF
{
  "DaemonAuthenticationType": "password",
  "DaemonAuthenticationPassword": "ptfe-pwd",
  "TlsBootstrapType": "self-signed",
  "LogLevel": "debug",
  "ImportSettingsFrom": "/tmp/replicated-settings.json",
  "LicenseFileLocation": "/tmp/license.rli"
  "BypassPreflightChecks": true
}
EOF
cat > /tmp/replicated-settings.json <<EOF
{
  "hostname": {
    "value": "jiyeon-ptfe-pes.hashidemos.io"
  }
  "installation_type": {
    "value": "production"
  },
  "production_type": {
    "value": "external"
  },
  "pg_user": {
    "value": "ptfe"
  },
  "pg_password": {
    "value": ""
  },
  "pg_netloc": {
    "value": "host:port"
  },
  "pg_dbname": {
      "value": "ptfe"
  },
  "letsencrypt_auto": {
    "value": "1"
  },
  "letsencrypt_email": {
    "value": "jiyeon01.kim@samsung.com"
  },
}
EOF

# install replicated
curl https://install.terraform.io/ptfe/stable> /home/ubuntu/install.sh
bash /home/ubuntu/install.sh no-proxy
