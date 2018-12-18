QT += core
QT += gui

CONFIG += c++11

TARGET = mobileNetSSDTensorRT-Qt
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    common.cpp \
    mathFunctions.cpp \
    pluginImplement.cpp \
    tensorNet.cpp \
    util/loadImage.cpp

HEADERS += \
    common.h \
    cudaUtility.h \
    mathFunctions.h \
    pluginImplement.h \
    tensorNet.h \
    cuda/cudaUtility.h \
    util/loadImage.h \
    util/cuda/cudaMappedMemory.h \
    util/cuda/cudaNormalize.h \
    util/cuda/cudaOverlay.h \
    util/cuda/cudaResize.h \
    util/cuda/cudaRGB.h \
    util/cuda/cudaUtility.h \
    util/cuda/cudaYUV.h

DISTFILES += \
    mathFunctions.cu \
    kernel.cu

INCLUDEPATH += util


#################
SYSTEM_TYPE = 64
CUDA_ARCH = sm_50

CUDA_SDK = "/usr/local/cuda"   # Path to cuda SDK install
CUDA_DIR = "/usr/local/cuda"   # Path to cuda toolkit install

NVCC_OPTIONS  =  --use_fast_math
INCLUDEPATH   += $$CUDA_DIR/include
QMAKE_LIBDIR  += $$CUDA_DIR/lib64/

CUDA_OBJECTS_DIR = ./
CUDA_LIBS = cudart cufft
CUDA_INC = $$join(INCLUDEPATH,'" -I"','-I"','"')
NVCC_LIBS = $$join(CUDA_LIBS,' -l','-l', '')


CUDA_SOURCES  += mathFunctions.cu
CUDA_SOURCES  += kernel.cu
CUDA_SOURCES  += util/cuda/cudaNormalize.cu
CUDA_SOURCES  += util/cuda/cudaOverlay.cu
CUDA_SOURCES  += util/cuda/cudaResize.cu
CUDA_SOURCES  += util/cuda/cudaRGB.cu
CUDA_SOURCES  += util/cuda/cudaYUV-NV12.cu
CUDA_SOURCES  += util/cuda/cudaYUV-YUYV.cu
CUDA_SOURCES  += util/cuda/cudaYUV-YV12.cu


#cuda
INCLUDEPATH += /usr/local/cuda-9.0/include
LIBS += -L/usr/local/cuda/lib64 \
-lcublas  -lcufft    -lcurand    -lnppc  -lnvToolsExt   \
-lcudart  -lcufftw   -lcusolver  \
-lcudnn   -lcuinj64  -lcusparse  -lnpps
#-lnppi

#tensorRT
LIBS += -lnvcaffe_parser\
    -lnvinfer_plugin\
    -lnvparsers\
    -lnvinfer

#opencv
INCLUDEPATH += /usr/local/include\
               /usr/local/include/opencv\
               /usr/local/include/opencv2
LIBS +=/usr/local/lib/libopencv_*.so


CONFIG(debug, debug|release) {
     # Debug mode
     cuda_d.input = CUDA_SOURCES
     cuda_d.output = $$CUDA_OBJECTS_DIR/${QMAKE_FILE_BASE}_cuda.o
     cuda_d.commands = $$CUDA_DIR/bin/nvcc -g -D_DEBUG $$NVCC_OPTIONS $$CUDA_INC $$NVCC_LIBS --machine $$SYSTEM_TYPE -arch=$$CUDA_ARCH -c -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME}
     cuda_d.dependency_type = TYPE_C
     QMAKE_EXTRA_COMPILERS += cuda_d
 }
 else {
     # Release mode
     cuda.input = CUDA_SOURCES
     cuda.output = $$CUDA_OBJECTS_DIR/${QMAKE_FILE_BASE}_cuda.o
     cuda.commands = $$CUDA_DIR/bin/nvcc -g -D_DEBUG $$NVCC_OPTIONS $$CUDA_INC $$NVCC_LIBS --machine $$SYSTEM_TYPE -arch=$$CUDA_ARCH -c -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME}
     cuda.dependency_type = TYPE_C
     QMAKE_EXTRA_COMPILERS += cuda
}


