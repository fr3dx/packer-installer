#!/bin/bash

<<comment
 "This script downloads packer version 1.8.5, it checks the GPG signature
  of packer_1.8.5_SHA256SUMS file, select the desired packer version 1.8.5 from it
  and compares the selected hash with packer_1.8.5_linux_amd64.zip file"
comment

PACKER_DOWNLOAD_URL="https://releases.hashicorp.com/packer"
PACKER_VERSION="1.8.5"
PACKER_LINUX_BINARY="packer_${PACKER_VERSION}_linux_amd64.zip"

wget ${PACKER_DOWNLOAD_URL}/${PACKER_VERSION}/${PACKER_LINUX_BINARY} &&
wget ${PACKER_DOWNLOAD_URL}/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS &&
wget ${PACKER_DOWNLOAD_URL}/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS.sig &&
curl https://keybase.io/hashicorp/pgp_keys.asc | gpg --import &&
(gpg --verify packer_${PACKER_VERSION}_SHA256SUMS.sig packer_${PACKER_VERSION}_SHA256SUMS && echo "The signature is GOOD!") ||
(echo "The signature is BAD!" && exit 1)

PACKER_BINARY_HASH=$(sha256sum ${PACKER_LINUX_BINARY} | awk '{ print $1 }')

VERIFIED_PACKER_HASH=$(awk -e '/p.+linux_amd64.+/ {print $1}' packer_${PACKER_VERSION}_SHA256SUMS)

([ "${VERIFIED_PACKER_HASH}" == "${PACKER_BINARY_HASH}" ] && echo "The hash is GOOD!") ||
(echo "The hash is BAD!" && exit 1)

#unzip ${PACKER_LINUX_BINARY} &&
#mv packer /usr/bin

#packer --version
