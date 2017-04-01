#!/bin/bash

# ================================
# update packages
# ================================

su

yum -y update

# ================================
# install packages
# ================================

yum -y groups mark install "Development Tools"
yum -y groups mark convert "Development Tools"
yum -y groupinstall "Development Tools"

yum -y install vim

yum -y install yum-cron

# ================================
# enable to update automatically
# ================================

vim /etc/yum/yum-cron.conf
# from: apply_updates = no
# to:   apply_updates = yes

systemctl start yum-cron
systemctl enable yum-cron

systemctl status yum-cron
# check: active

# ================================
# version control
# ================================

yum -y install etckeeper

cat << _EOF > /etc/.gitignore
shadow*
gshadow*
passwd*
group*
_EOF

etckeeper init

etckeeper commit "First Commit"

# ================================
# cache clean
# ================================

cat << \_EOF > /etc/cron.daily/yum-clean
#!/bin/bash

yum clean all

_EOF

chmod 755 /etc/cron.daily/yum-clean
