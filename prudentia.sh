#!/bin/bash

#http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "${SOURCE}" ]; do
  DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
  SOURCE="$(readlink "${SOURCE}")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}"
done
DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"

# Change cwd in Prudentia dir
cd ${DIR}

if [ -z "$( which python )" ]; then
    echo "Please, install Python (>=2.6)."
    exit 1
elif [ -z "$( which virtualenv )" ]; then
    echo "Please, install Virtualenv."
    exit 1
fi

if [ ! -d "./p-env/" ]; then
    virtualenv p-env
fi

source ./p-env/bin/activate

pip install -q -r ./requirements.txt

PYTHONPATH=. bin/prudentia "$@" 2>&1
