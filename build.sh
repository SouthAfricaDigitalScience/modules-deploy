#!/bin/bash -e
# Script to build tcl, then modules
# Version of modules is usually 3.2.10
echo ${MODULESHOME}
source /etc/profile.d/modules.sh
SOURCE_FILE=$NAME-$VERSION.tar.gz
echo "we'll now build $NAME-$VERSION" from $SOURCE_FILE
# Add the module for the CI environment
module load ci

# add dependencies
module add gcc/4.9.2

# Get tcl
if [[ ! -s tcl8.6.4-src.tar.gz ]] ; then
  wget http://prdownloads.sourceforge.net/tcl/tcl8.6.4-src.tar.gz -O  tcl8.6.4-src.tar.gz
  tar xfz tcl8.6.4-src.tar.gz
fi

# build tcl8
cd tcl8.6.4/unix
./configure --prefix=${SOFT_DIR}/tcl8
make install

# check tcl

#

if [[ ! -s $SRC_DIR/$SOURCE_FILE ]] ; then
  echo "Seems we are building from scratch - preparing "
  mkdir -p $SRC_DIR
  wget http://sourceforge.net/projects/modules/files/Modules/$NAME-${VERSION}/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
else
  echo "Seems we already have that source file $SRC_DIR/$SOURCE_FILE"
  echo "unpacking from here."
fi
tar -xvzf $SRC_DIR/$SOURCE_FILE -C $WORKSPACE
cd $WORKSPACE/$NAME-$VERSION
# see http://sourceforge.net/p/modules/bugs/62/
CPPFLAGS="-DUSE_INTERP_ERRORLINE" ./configure --with-tcl=${SOFT_DIR}/tcl8/lib --with-tcl-ver=8.6 --without-tclx
make -j 8
