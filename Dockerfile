FROM jupyter/scipy-notebook:3f4324b0e654
MAINTAINER Insight Software Consortium <community@itk.org>

USER root

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  cmake \
  git \
  ninja-build \
  wget \
  vim

USER $NB_USER

# master 2016-09-12
ENV ITK_GIT_TAG f83bfdb890314b663b60e5fb05cd82899a91502f
RUN cd /home/$NB_USER/ && \
  mkdir -p src && cd src && \
  git clone https://itk.org/ITK.git && \
  cd ITK && \
  git checkout ${ITK_GIT_TAG} && \
  cd /home/$NB_USER/ && \
  mkdir -p bin && cd bin && \
  mkdir ITK-build && \
  cd ITK-build && \
  cmake \
    -G Ninja \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DBUILD_TESTING:BOOL=OFF \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DITK_WRAP_PYTHON:BOOL=ON \
    -DPYTHON_EXECUTABLE:FILEPATH=/opt/conda/bin/python \
    -DPYTHON_INCLUDE_DIR:PATH=/opt/conda/include/python3.5m \
    -DPYTHON_LIBRARY:FILEPATH=/opt/conda/lib/libpython3.5m.so \
    -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
    -DITK_LEGACY_REMOVE:BOOL=ON \
    -DITK_BUILD_DEFAULT_MODULES:BOOL=ON \
    ../../src/ITK && \
  ninja && \
  find . -name '*.o' -delete

