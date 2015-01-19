#!/bin/bash
#
## This script sets up Pidgin to handle Microsoft Lync 2010

### install pidgin + pidgin-sipe for Office Communicator / Lync
sudo dnf install -y pidgin pidgin-sipe

### prefix alias in .bashrc
# dirty workaround due to rhbz#770682
echo 'alias pidgin="NSS_SSL_CBC_RANDOM_IV=0 /usr/bin/pidgin"' | tee --append $HOME/.bashrc >> /dev/null

### echo instructions
echo "Ready for setup in pidgin (restart pidgin if open):"
echo "1) set up a new Office-Communicator account"
echo "2) enter server address (will vary by org)"
echo "3) enter user agent: UCCAPI/4.0.7577.314 OC/4.0.7577.314 (Microsoft Lync 2010)"
echo "4) select auth scheme: TLS-DSK"
echo "5) login is your email address and password"
echo ""
