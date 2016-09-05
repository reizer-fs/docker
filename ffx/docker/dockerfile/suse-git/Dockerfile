FROM suse-refreshed

MAINTAINER Horus "Horus@gmail.com"

# make sure the repositories are up to date
RUN zypper --non-interactive --gpg-auto-import-keys ref -s
RUN zypper --non-interactive --gpg-auto-import-keys in git vim

ENTRYPOINT ["/bin/bash"]
