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

# ITK
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
RUN cp /home/$NB_USER/bin/ITK-build/Wrapping/Generators/Python/WrapITK.pth /opt/conda/lib/python3.5/site-packages

# ITKAnisotropicDiffusionLBR
# master 2016-07-13
ENV ITKAnisotropicDiffusionLBR_GIT_TAG c1e74cc933fe86e0738b4df2def965df04c64d3a
RUN  cd /home/$NB_USER/src && \
  git clone https://github.com/InsightSoftwareConsortium/ITKAnisotropicDiffusionLBR && \
  cd ITKAnisotropicDiffusionLBR && \
  git checkout ${ITKAnisotropicDiffusionLBR_GIT_TAG} && \
  cd /home/$NB_USER/bin && \
  mkdir ITKAnisotropicDiffusionLBR-build && \
  cd ITKAnisotropicDiffusionLBR-build && \
  cmake \
    -G Ninja \
    -DBUILD_TESTING:BOOL=OFF \
    -DITK_DIR:PATH=/home/$NB_USER/bin/ITK-build \
    -DPYTHON_EXECUTABLE:FILEPATH=/opt/conda/bin/python \
    -DPYTHON_INCLUDE_DIR:PATH=/opt/conda/include/python3.5m \
    -DPYTHON_LIBRARY:FILEPATH=/opt/conda/lib/libpython3.5m.so \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    ../../src/ITKAnisotropicDiffusionLBR && \
  ninja && \
  find . -name '*.o' -delete

# ITKBridgeNumPy
# master 2016-07-13
ENV ITKBridgeNumPy 99469b9a3bbf95fe29db7ec996a44b73003d767c
RUN  cd /home/$NB_USER/src && \
  git clone https://github.com/InsightSoftwareConsortium/ITKBridgeNumPy && \
  cd ITKBridgeNumPy && \
  git checkout ${ITKBridgeNumPy_GIT_TAG} && \
  cd /home/$NB_USER/bin && \
  mkdir ITKBridgeNumPy-build && \
  cd ITKBridgeNumPy-build && \
  cmake \
    -G Ninja \
    -DBUILD_TESTING:BOOL=OFF \
    -DITK_DIR:PATH=/home/$NB_USER/bin/ITK-build \
    -DPYTHON_EXECUTABLE:FILEPATH=/opt/conda/bin/python \
    -DPYTHON_INCLUDE_DIR:PATH=/opt/conda/include/python3.5m \
    -DPYTHON_LIBRARY:FILEPATH=/opt/conda/lib/libpython3.5m.so \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    ../../src/ITKBridgeNumPy && \
  ninja && \
  find . -name '*.o' -delete

RUN conda install --yes --quiet -c damianavila82 rise

RUN conda install --yes --quiet -c https://conda.anaconda.org/simpleitk SimpleITK

# Don't use the terminal_progress_callback in Jupyter Notebooks
# We will create a permanent fix for this in upstream ITK
ADD .support/itkExtras.py /home/jovyan/bin/ITK-build/Wrapping/Generators/Python/itkExtras.py

ADD . ./
