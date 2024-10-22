FROM ubuntu:20.04

# Suppress interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages including CA certificates
RUN apt-get update && apt-get install -y \
    openssh-server libpam-ldapd nscd rsyslog auditd ca-certificates && \
    update-ca-certificates && \
    mkdir /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "UsePAM yes" >> /etc/ssh/sshd_config && \
    echo "AllowUsers admin mscott" >> /etc/ssh/sshd_config  # Allow specific users

# Copy custom CA certificates into the container (optional)
COPY custom-ca-certificates/ /usr/local/share/ca-certificates/

# Update CA certificates to include custom ones
RUN update-ca-certificates

# Add a local admin account with password authentication
RUN useradd -m -s /bin/bash admin && \
echo "admin:password123" | chpasswd && \
usermod -aG sudo admin  # Add admin to sudo group

# Copy user session logging script to be executed during login
COPY hostmachine-config/user_sessions.sh /etc/profile.d/user_sessions.sh
RUN chmod +x /etc/profile.d/user_sessions.sh

# Copy rsyslog configuration files
COPY rsyslog.conf /etc/rsyslog.conf
COPY ldap.conf /etc/ldap/ldap.conf
COPY nslcd.conf /etc/nslcd.conf
COPY nsswitch.conf /etc/nsswitch.conf
COPY pam.d/sshd /etc/pam.d/sshd

# Expose the SSH port
EXPOSE 22

# Use JSON-style CMD for better signal handling
CMD ["bash", "-c", "service rsyslog start && service nscd start && /usr/sbin/sshd -D"]
