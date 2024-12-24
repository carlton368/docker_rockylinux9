# Rocky Linux Docker Environment

This project provides a Docker container based on Rocky Linux 9 with SSH access and systemd support for system service management.

## Key Features

- Rocky Linux 9 based environment
- Built-in SSH server
- systemd support
- Volume mounting for data sharing
- Timezone configuration (Asia/Seoul)

## Prerequisites

- Docker
- Docker Compose

## Installation and Setup

1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd [repository-name]
   ```

2. Build and run the Docker container:
   ```bash
   docker-compose up -d
   ```

## Access Information

- SSH Access:
  - Host: localhost
  - Port: 2222
  - User: root
  - Password: password

```bash
ssh root@localhost -p 2222
```

- Web Server Access:
  - URL: http://localhost:8080

## Volume Mounting

The host's `./data` directory is mounted to the container's `/data` directory, enabling file sharing between the host and container.

## Port Mapping

- SSH: 2222 -> 22
- Web Server: 8080 -> 80

## Important Notes

- The current configuration is intended for development environments. Security settings should be strengthened for production use.
- Make sure to change the root password before deployment.
- Be cautious with privileged mode as it has security implications.

## Customizing Configuration

### Changing Timezone

Modify the TZ value in the environment section of `docker-compose.yml`:

```yaml
environment:
  - TZ=Asia/Seoul  # Change to desired timezone
```

### Changing Ports

Modify the port mapping in the ports section of `docker-compose.yml`:

```yaml
ports:
  - "desired_port:22"  # SSH
  - "desired_port:80"  # Web Server
```

## File Structure

### docker-compose.yml
```yaml
services:
  rockylinux:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "2222:22"  # SSH port forwarding
      - "8080:80"  # Web server port forwarding
    volumes:
      - ./data:/data  # Data sharing between host and container
    environment:
      - TZ=Asia/Seoul  # Timezone setting
    command: /usr/sbin/init  # Using systemd
    privileged: true  # Required for systemd
```

### Dockerfile
```dockerfile
FROM rockylinux:9

# Install required packages
RUN dnf -y update && dnf -y install openssh-server

# Configure SSH
RUN ssh-keygen -A
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Enable SSH service
RUN systemctl enable sshd.service

EXPOSE 22 80

CMD ["/usr/sbin/init"]
```
