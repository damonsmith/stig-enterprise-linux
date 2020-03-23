#!/bin/sh

echo "check for packer executable"
if [ `packer -v 2>/dev/null` ]; then
    echo "packer exists"
else
    echo "packer does not exist on the path, please download it from https://releases.hashicorp.com/packer/"
fi
rm -f spel/userdata/tmpfsroot-el7.cloud.generated
sed "s|<PROXYSERVER>|$1|" spel/userdata/tmpfsroot-el7.cloud > spel/userdata/tmpfsroot-el7.cloud.generated

packer build -var 'spel_proxyserver=$1' -var-file build_vars.json spel/rhel7.json
rm -f spel/userdata/tmpfsroot-el7.cloud.generated

# install scap-security-guide