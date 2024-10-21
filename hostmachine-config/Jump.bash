Add a configuration to /etc/ssh/ssh_config to allow users to use the shared key automatically when connecting from the bastion:

Host target-server
    User user
    IdentityFile /root/.ssh/common_key
    ProxyCommand none
