# **Bastion Server with LDAP Authentication and CA Certificates**

Welcome to the **Bastion Server project**! This project creates a **Docker-based SSH bastion server** that uses **LDAP for user authentication** and **CA certificates** for secure communication.

Follow these steps carefully, and you will have your **bastion server up and running** in no time. 🛡️

---

## **Table of Contents**

1. [What is a Bastion Server?](#what-is-a-bastion-server)
2. [How This Works](#how-this-works)
3. [Prerequisites](#prerequisites)
4. [Step-by-Step Setup](#step-by-step-setup)
5. [Using the Bastion Server](#using-the-bastion-server)
6. [Troubleshooting](#troubleshooting)
7. [Contributing](#contributing)
8. [License](#license)

---

## **What is a Bastion Server?**

A **bastion server** is like a **guard post** that keeps your network safe. When someone wants to log in to one of your computers remotely, they must first go through the **bastion server**. This server helps **track who logs in** and keeps **connections secure**.

---

## **How This Works**

- **Docker**: Runs the bastion server as a container (like a small virtual computer).
- **LDAP Authentication**: Only users with accounts in the **LDAP directory** can log in.
- **CA Certificates**: Secure connections to LDAP and other services.

---

## **Prerequisites**

Before we start, make sure you have:

1. **Docker installed** on your computer.  
   If not, download it here: [Get Docker](https://www.docker.com/products/docker-desktop).
2. **An LDAP server** running (like **OpenLDAP**).
3. **CA certificates** ready (optional) if using **internal LDAP over secure `ldaps`**.

---

## **Step-by-Step Setup**

Follow these instructions step by step.

### 1. **Clone This Repository**

Open your terminal (or **Command Prompt on Windows**) and clone the project:

```bash
git clone https://github.com/your-username/bastion-server.git
cd bastion-server


## 2. **Add Your Custom Certificates (Optional)**

If you have **CA certificates**, copy them into the `custom-ca-certificates/` folder.

```bash
mkdir custom-ca-certificates
cp /path/to/your-cert.crt custom-ca-certificates/

3. Build the Docker Image
Run this command to build the Docker container:

bash
Copy code
docker build -t ldap-bastion .
📝 What’s Happening?
Docker reads the Dockerfile to install the required programs and copy the necessary files.


4. Run the Docker Container
Use this command to start the bastion server:

bash
Copy code
docker run -d -p 2222:22 --name bastion ldap-bastion
📝 What’s Happening?
The bastion server is now running in the background, and it’s listening for SSH connections on port 2222.


5. Test the LDAP Login
Now, let’s log in to the bastion server using your LDAP username:

bash
Copy code
ssh -p 2222 ldapuser@localhost
If everything is set up correctly, you should see a welcome message! 🎉


Using the Bastion Server
Add More Users: Add users to your LDAP server to allow them to access the bastion.

Check Logs: View the logs to see who logged in and when:

bash
Copy code
docker exec -it bastion tail /var/log/auth.log
Forward Logs to a Remote Server: Modify the rsyslog.conf to send logs to a remote monitoring server (like ELK or Graylog).


Troubleshooting
If something goes wrong, try these tips:

Issue: I get an error saying connection refused.
Solution: Make sure the Docker container is running:

bash
Copy code
docker ps


Issue: LDAP users can’t log in.
Solution: Verify the LDAP server address in ldap.conf:

bash
Copy code
docker exec -it bastion cat /etc/ldap/ldap.conf


Issue: Logs are not forwarding to the remote server.
Solution: Check the rsyslog.conf configuration and restart the container:

bash
Copy code
docker restart bastion

