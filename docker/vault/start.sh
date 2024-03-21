#!/bin/bash

# =============================================================
: 'Number of key shares to split the generated master key into. 
This is the number of "unseal keys" to generate '
export key_shares=3
# =============================================================
: 'Number of key shares required to reconstruct the root key.
This must be less than or equal to -key-shares. '
export key_threshold=2
## Expose the Vault service IF RUNNING ON LOCAL 
export VAULT_ADDR=http://localhost:8200

echo $VAULT_ADDR
# vault.vault.svc.cluster.local:8200
## THIS IS FOR INIT THE VAULT AND PUT ITS KEYS AND TOKEN INTO FILE /tmp/vault-keys.json
docker exec -it  vault vault operator init -format=json -key-shares=$key_shares -key-threshold=$key_threshold > ./vault-keys.json
# COPY THE FILE FORM ORIGINAL LOCATION INTO OUR PROJECT ROOT DIR 
# cp /tmp/vault-keys.json ./vault.json
# DECLARE THE VAULT TOKEN TO LOGIN 
export VAULT_TOKEN=$(cat ./vault-keys.json | jq -r .root_token)
# FIRST STEP OF USSEALING BY USING THE FIRST KEY
docker exec -it vault vault operator unseal $(cat  ./vault-keys.json | jq -r .unseal_keys_b64[0]) || true
# FIRST STEP OF USSEALING BY USING THE FIRST KEY
docker exec -it vault vault operator unseal $(cat ./vault-keys.json | jq -r .unseal_keys_b64[1]) || true

# Create the Vault Policy
# vault policy write vaultpolicy ./vaultpolicy.hcl
#TO KILL THE PROCESS OF PORT FORWARD IF USING THE SCRIPT LOCALY
# pkill -f 'kubectl -n vault port-forward'
# export PID=$(ps aux | grep 'kubectl -n vault port-forward' | grep -v grep | awk '{print $2}')
# kill $PID