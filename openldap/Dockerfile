FROM almalinux:8.4

RUN yum update -y
RUN dnf install \
    wget \
    vim \
    cyrus-sasl-devel \
    libtool-ltdl-devel \
    openssl-devel \
    libdb-devel \
    make \
    libtool \
    autoconf \
    tar \
    gcc \
    perl \
    perl-devel \
    -y
RUN useradd -r -M -d /var/lib/openldap -u 55 -s /usr/sbin/nologin ldap
RUN dnf groupinstall "Development Tools" -y

WORKDIR /build

RUN wget https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.3.tgz
RUN tar xzf openldap-2.6.3.tgz
RUN mv openldap-2.6.3 /opt

WORKDIR /opt/openldap-2.6.3

RUN ./configure --prefix=/usr --sysconfdir=/etc \
    --enable-debug --with-tls=openssl --with-cyrus-sasl --enable-dynamic \
    --enable-crypt --enable-spasswd --enable-slapd --enable-modules \
    --enable-rlookups

RUN make depend
RUN make
RUN make install

CMD ["sleep", "infinity"]
