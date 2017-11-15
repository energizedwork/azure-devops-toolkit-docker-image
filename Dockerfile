FROM centos7

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/msprod.repo
RUN sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

RUN yum update -y
RUN yum install wget unzip epel-release -y
RUN yum install python2-pip -y
RUN yum install mariadb-devel -y
RUN yum install docker-compose-1.9.0 -y
RUN yum install python-devel -y
RUN yum install gcc -y
RUN yum install libffi-devel -y
RUN yum install jq -y
RUN yum install openssl-devel -y
RUN yum install gcc-c++ -y
RUN yum install make -y

RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install 'msrestazure==0.4.16'
RUN pip install 'azure==2.0.0rc6'
RUN pip install 'azure-keyvault==0.3.4'
RUN pip install versioning
RUN pip install packaging

RUN pip install 'https://github.com/energizedwork/azure-log-analytics-alerts-cli/archive/0.1.5.zip '
RUN az-la-cli version && echo "------------------ Azure Log Analytics CLI Successfully Installed ------------------"

RUN mkdir -p /tmp/working && cd /tmp/working

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN yum install azure-cli-2.0.20-1.el7 -y
RUN az --version && \
    echo "------------------ Azure CLI Successfully Installed ------------------"

RUN mkdir -p /var/lib/terraform && \
    curl https://releases.hashicorp.com/terraform/0.9.11/terraform_0.9.11_linux_amd64.zip --output terraform.zip && \
    unzip terraform.zip -d /var/lib/terraform && \
    rm terraform.zip && \
    /var/lib/terraform/terraform --version && \
    echo "------------------ Terraform Successfully Installed ------------------"

RUN yum install git -y
RUN git --version && \
    echo "------------------ Git Successfully Installed ------------------"

RUN yum install ansible -y
RUN ansible --version && \
    echo "------------------ Ansible Successfully Installed ------------------"

RUN ACCEPT_EULA=Y yum install mssql-tools unixODBC-devel -y
RUN localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    /opt/mssql-tools/bin/sqlcmd && \
    echo "------------------ Microsoft SQLServer Client Successfully Installed ------------------"

RUN curl -sL https://rpm.nodesource.com/setup_6.x | bash -
RUN yum install nodejs -y
RUN npm -v && \
    node -v && \
    echo "------------------ NodeJS and NPM Successfully Installed ------------------"

ENV PATH="/opt/mssql-tools/bin:/var/lib/terraform:/root/bin:${PATH}"

RUN yum clean all