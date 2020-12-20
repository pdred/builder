#################################################################################
# Builder Image
FROM quay.io/cloudctl/ubi:minimal as builder
ARG BUILD_PATH='/rootfs'

#################################################################################
# DNF Package Install List
ARG DNF_LIST="\
  git \
  tar \
  pigz \
  bash \
  curl \
  unzip \
  bsdtar \
"

#################################################################################
# DNF Package Install Flags
ARG DNF_FLAGS="\
  -y \
  --releasever 8 \
  --installroot /rootfs \
"
ARG DNF_FLAGS_EXTRA="\
  --nodocs \
  --setopt=install_weak_deps=false \
  ${DNF_FLAGS} \
"

#################################################################################
# Build Rootfs
RUN set -ex \
     && mkdir -p ${BUILD_PATH} \
     && dnf install ${DNF_FLAGS_EXTRA} ${DNF_LIST} \
     && dnf clean all ${DNF_FLAGS} \
     && cp -f /etc/yum.repos.d/ubi.repo ${BUILD_PATH}/etc/yum.repos.d/ubi.repo \
     && rm -rf \
           ${BUILD_PATH}/var/cache/* \
           # Remove the following line to build RH supported UBI Micro
           ${BUILD_PATH}/var/lib/rpm \
    && echo


CMD /bin/sh
#################################################################################
# Finalize Image
MAINTAINER ContainerCraft.io
LABEL \
  license=GPLv3                                                                 \
  name="cloudctl-base"                                                          \
  distribution-scope="public"                                                   \
  io.openshift.tags="cloudctl-base"                                             \
  io.k8s.display-name="cloudctl-base"                                           \
  summary="CloudCtl Base Image | Micro Red Hat UBI Supportable Image"           \
  description="CloudCtl Base Image | Micro Red Hat UBI Supportable Image"       \
  io.k8s.description="CloudCtl Base Image | Micro Red Hat UBI Supportable Image"
