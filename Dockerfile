FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    openssh-server libpam-ldapd nscd rsyslog auditd && \
    mkdir /var/run/sshd && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "UsePAM yes" >> /etc/ssh/sshd_config

# Configure rsyslog to forward logs
COPY rsyslog.conf /etc/rsyslog.conf

# Configure LDAP (this will vary depending on your LDAP server)
COPY ldap.conf /etc/ldap/ldap.conf
COPY nslcd.conf /etc/nslcd.conf
COPY nsswitch.conf /etc/nsswitch.conf

EXPOSE 22

CMD service rsyslog start && service nscd start && /usr/sbin/sshd -D

