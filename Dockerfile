FROM centos

RUN yum update -y
RUN yum install wget unzip epel-release -y
RUN yum install python2-pip -y
RUN yum install mariadb-devel -y
RUN yum install docker-compose-1.9.0 -y
RUN yum install python-devel -y
RUN yum install gcc -y
RUN yum install libffi-devel -y
RUN pip install --upgrade pip
RUN pip install msrestazure
RUN pip install 'azure==2.0.0rc6'
RUN pip install 'azure-keyvault==0.3.4'
RUN pip install versioning
RUN pip install packaging
RUN yum clean all

RUN mkdir -p /tmp/working && cd /tmp/working

RUN mkdir -p /var/lib/terraform && \
    curl http://hc-releases.s3-website-us-east-1.amazonaws.com/terraform/0.9.11/terraform_0.9.11_linux_amd64.zip --output terraform.zip && \
    unzip terraform.zip -d /var/lib/terraform && \
    rm terraform.zip && \
    /var/lib/terraform/terraform --version && \
    echo "------------------ Terraform Successfully Installed ------------------"

RUN yum install git -y && \
    git --version && \
    echo "------------------ Git Successfully Installed ------------------"

RUN yum install ansible -y && \
    ansible --version && \
    echo "------------------ Ansible Successfully Installed ------------------"

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/msprod.repo && \
    ACCEPT_EULA=Y yum install mssql-tools unixODBC-devel -y && \
    localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    /opt/mssql-tools/bin/sqlcmd && \
    echo "------------------ Microsoft SQLServer Client Successfully Installed ------------------"

RUN yum install -y gcc-c++ make && \
    curl -sL https://rpm.nodesource.com/setup_6.x | bash - && \
    yum install nodejs -y && \
    npm -v && \
    node -v && \
    echo "------------------ NodeJS and NPM Successfully Installed ------------------"

RUN yum install gcc libffi-devel python-devel openssl-devel -y && \
    curl -L https://aka.ms/InstallAzureCliBundled -o azure-cli_bundle.tar.gz && \
    tar -xvzf azure-cli_bundle.tar.gz && \
    azure-cli_bundle_*/installer && \
    rm azure-cli_bundle.tar.gz && \
    rm -rf azure-cli_bundle_2.0.10 && \
    /root/bin/az --version && \
    echo "------------------ Azure CLI Successfully Installed ------------------"

ENV PATH="/opt/mssql-tools/bin:/var/lib/terraform:/root/bin:${PATH}"