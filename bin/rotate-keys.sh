#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
usage() {
  echo "Usage: $0 -h DOMAIN/IP_ADDRESS  [-u SSH_USER] [-b BITS ] [-c COMMENT] [-t TYPE] [-f PATH ]  [-p PASS] [ -k UNIQUE_KEY ] "
  exit 1
}
while getopts "u:h:b:c:t:f:p:k:" option; do
  case "${option}" in
    u) SSH_USER="${OPTARG}" ;;
    h) DOMAIN="${OPTARG}" ;;
    b) BITS="${OPTARG}" ;;
    c) COMMENT="${OPTARG}" ;;
    t) TYPE="${OPTARG}" ;;
    f) KEY_PATH="${OPTARG}" ;;
    p) PASS="${OPTARG}" ;;
    k) UNIQUE_KEY="${OPTARG}" ;;
    *) usage ;;
  esac
done

# step 1 Generating the ssh Key
generateNewSshKey() {
  ssh-keygen -t "${TYPE}" -b "${BITS}" -C "${COMMENT}" -N "${PASS}" -f "${KEY_PATH}" -q
}

# step 2 add the ssh keys
addNewSshPublicKey() {
  ssh-copy-id -i "${KEY_PATH}"  "${SSH_USER}@${DOMAIN}"
}
# step 3 remove the old key
removeOldPublicKey() {
  ssh "${SSH_USER}@${DOMAIN}" "sed -i.bak '/${UNIQUE_KEY}/d' ~/.ssh/authorized_keys"
}

main() {
  [ -z ${DOMAIN} ] && usage
  # set defaults values if not specified
  [ -z ${SSH_USER} ] && SSH_USER="ubuntu"
  [ -z ${BITS} ] && BITS="4096"
  [ -z ${COMMENT} ] && COMMENT="${SSH_USER}@${DOMAIN}"
  [ -z ${TYPE} ] && TYPE="rsa"
  [ -z ${KEY_PATH} ] && KEY_PATH="${DIR}/${SSH_USER}-ssh-key"
  [ -z ${PASS} ] && PASS="${SSH_USER}"
  [ -z ${UNIQUE_KEY} ] && UNIQUE_KEY="${SSH_USER}"

  generateNewSshKey
  addNewSshPublicKey
  removeOldPublicKey
}

main
