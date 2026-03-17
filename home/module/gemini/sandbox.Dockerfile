FROM nixos/nix:latest
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
RUN mkdir -p /bin && \
    ln -sf $(which bash) /bin/bash && \
    ln -sf $(which sh) /bin/sh
RUN echo 'if [ -z "$HAS_ENTERED_NIX_DEVELOP" ]; then \
            export HAS_ENTERED_NIX_DEVELOP=1; \
            exec nix develop; \
          fi' >> /etc/bash.bashrc && \
    echo 'if [ -z "$HAS_ENTERED_NIX_DEVELOP" ]; then \
            export HAS_ENTERED_NIX_DEVELOP=1; \
            exec nix develop; \
          fi' >> /root/.bashrc
# RUN echo 'if [ -z "$HAS_ENTERED_NIX_DEVELOP" ]; then \
#             export HAS_ENTERED_NIX_DEVELOP=1; \
#             exec nix develop; \
#           fi' >> /root/.bashrc
CMD ["/bin/sh", "-c", "sleep infinity"]
