FROM rockylinux:9

# 필요한 패키지 설치
RUN dnf -y update && dnf -y install openssh-server

# SSH 설정
RUN ssh-keygen -A
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH 서비스 시작
RUN systemctl enable sshd.service

EXPOSE 22 80

CMD ["/usr/sbin/init"]
