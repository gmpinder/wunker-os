# This is the Containerfile for your custom image. 

# It takes in the recipe, version, and base image as arguments,
# all of which are provided by build.yml when doing builds
# in the cloud. The ARGs have default values, but changing those
# does nothing if the image is built in the cloud.

ARG FEDORA_MAJOR_VERSION=37
# Warning: changing this might not do anything for you. Read comment above.
ARG BASE_IMAGE_URL=ghcr.io/ublue-os/kinoite-main

# This is to install xboxdrv for the Xbox 360 controller.
FROM registry.fedoraproject.org/fedora-toolbox:${FEDORA_MAJOR_VERSION} as xboxdrv-bin

COPY scripts/install-xboxdrv.sh /tmp/scripts/install-xboxdrv.sh

RUN /tmp/scripts/install-xboxdrv.sh

FROM ${BASE_IMAGE_URL}:${FEDORA_MAJOR_VERSION}

# The default recipe set to the recipe's default filename
# so that `podman build` should just work for many people.
ARG RECIPE=./recipe-framework.yml

# Copy static configurations and component files.
# Warning: If you want to place anything in "/etc" of the final image, you MUST
# place them in "./usr/etc" in your repo, so that they're written to "/usr/etc"
# on the final system. That is the proper directory for "system" configuration
# templates on immutable Fedora distros, whereas the normal "/etc" is ONLY meant
# for manual overrides and editing by the machine's admin AFTER installation!
# See issue #28 (https://github.com/ublue-os/startingpoint/issues/28).
COPY usr/bin /usr/bin
COPY usr/lib /usr/lib
COPY usr/etc /usr/etc
COPY usr/share /usr/share

# Copy the recipe that we're building.
COPY ${RECIPE} /usr/share/ublue-os/recipe.yml

# "yq" used in build.sh and the "setup-flatpaks" just-action to read recipe.yml.
# Copied from the official container image since it's not available as an RPM.
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

# Install cosign for verifying signatures for images.
COPY --from=gcr.io/projectsigstore/cosign /ko-app/cosign /usr/bin/cosign

# Install xboxdrv for the Xbox 360 controller.
COPY --from=xboxdrv-bin /usr/local/bin/xboxdrv /usr/bin/xboxdrv
COPY --from=xboxdrv-bin /usr/local/bin/xboxdrvctl /usr/bin/xboxdrvctl
COPY --from=xboxdrv-bin /usr/local/share/man/man1/xboxdrv.1 /usr/share/man/man1/xboxdrv.1

# Copy the build script and all custom scripts.
COPY scripts /tmp/scripts

# Run the build script, then clean up temp files and finalize container build.
RUN chmod +x /tmp/scripts/build.sh && \
        /tmp/scripts/build.sh && \
        rm -rf /tmp/* /var/* && \
        ostree container commit
