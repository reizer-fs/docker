FROM opensuse:42.2

MAINTAINER Horus "Horus@gmail.com"
ENV http_proxy=http://proxy:8080/
ENV https_proxy=http://proxy:8080/

# make sure the repositories are up to date
RUN zypper --non-interactive --gpg-auto-import-keys ref -s
RUN zypper --non-interactive --gpg-auto-import-keys in git vim
RUN zypper clean -a

ENTRYPOINT ["/bin/bash"]
