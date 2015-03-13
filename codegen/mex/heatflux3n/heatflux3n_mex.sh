MATLAB="/Applications/MATLAB_R2014b.app"
Arch=maci64
ENTRYPOINT=mexFunction
MAPFILE=$ENTRYPOINT'.map'
PREFDIR="/Users/lackner/.matlab/R2014b"
OPTSFILE_NAME="./setEnv.sh"
. $OPTSFILE_NAME
COMPILER=$CC
. $OPTSFILE_NAME
echo "# Make settings for heatflux3n" > heatflux3n_mex.mki
echo "CC=$CC" >> heatflux3n_mex.mki
echo "CFLAGS=$CFLAGS" >> heatflux3n_mex.mki
echo "CLIBS=$CLIBS" >> heatflux3n_mex.mki
echo "COPTIMFLAGS=$COPTIMFLAGS" >> heatflux3n_mex.mki
echo "CDEBUGFLAGS=$CDEBUGFLAGS" >> heatflux3n_mex.mki
echo "CXX=$CXX" >> heatflux3n_mex.mki
echo "CXXFLAGS=$CXXFLAGS" >> heatflux3n_mex.mki
echo "CXXLIBS=$CXXLIBS" >> heatflux3n_mex.mki
echo "CXXOPTIMFLAGS=$CXXOPTIMFLAGS" >> heatflux3n_mex.mki
echo "CXXDEBUGFLAGS=$CXXDEBUGFLAGS" >> heatflux3n_mex.mki
echo "LD=$LD" >> heatflux3n_mex.mki
echo "LDFLAGS=$LDFLAGS" >> heatflux3n_mex.mki
echo "LDOPTIMFLAGS=$LDOPTIMFLAGS" >> heatflux3n_mex.mki
echo "LDDEBUGFLAGS=$LDDEBUGFLAGS" >> heatflux3n_mex.mki
echo "Arch=$Arch" >> heatflux3n_mex.mki
echo OMPFLAGS= >> heatflux3n_mex.mki
echo OMPLINKFLAGS= >> heatflux3n_mex.mki
echo "EMC_COMPILER=Xcode with Clang" >> heatflux3n_mex.mki
echo "EMC_CONFIG=optim" >> heatflux3n_mex.mki
"/Applications/MATLAB_R2014b.app/bin/maci64/gmake" -B -f heatflux3n_mex.mk
