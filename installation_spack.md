# Installation of femus dependencies using spack

## System requirements

These packages must be available for the following steps

### OpenSUSE Leap 15.4/15.5

* `gcc10`

* `gcc10-c++`

* `gcc10-fortran`

* `python3`

## Clone the `NumericPlatform` repository

```bash
# select a directory where to install (absolute path)
export SOFTWARE_DIR=<software_dir>

cd $SOFTWARE_DIR
git clone https://github.com/FemusPlatform/NumericPlatform
```

## Install `spack`

Select a directory where to install `spack` and `cd` to it

```bash
cd $SOFTWARE_DIR

# clone the spack repository
git clone -c feature.manyFiles=true https://github.com/capitalaslash/spack.git -b v0.21_femus

# set up bashrc for spack automatic activation
echo "source $SOFTWARE_DIR/spack/share/spack/setup-env.sh" | tee -a ~/.bashrc

# set up spack for the current shell
source $SOFTWARE_DIR/spack/share/spack/setup-env.sh
```

Currently the upstream version of `spack` does not include all the required versions
that have been included in a custom fork.

## Install third party dependencies and some platform codes

```bash
cd $SOFTWARE_DIR/NumericPlatform
./spack_setup.sh
```

## Usage

In order to use the packages installed via `spack`, it is sufficient to activate an
environment

```bash
spack env activate $SOFTWARE_DIR/NumericPlatform/spack_env
```

## Package versions

The versions of the various packages and compiler can be set editing the file
`spack_env/spack.yaml`.

After editing the file, uninstall old versions

```bash
spack uninstall <package>@<old_version>
```

and then run

```bash
cd $SOFTWARE_DIR/NumericPlatform
./spack_setup.sh
```

## Salome

This guide does not install the `salome` platform, it can be installed separately
using a pre-compiled version. An example is given in the script `salome_setup.sh`.
