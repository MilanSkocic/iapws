shopt -s expand_aliases
source ~/.bashrc

rm -r build
rm -r dist
rm ./pyiapws/g704*.so

py37 setup.py build_ext --inplace
py38 setup.py build_ext --inplace
py39 setup.py build_ext --inplace
py310 setup.py build_ext --inplace
py311 setup.py build_ext --inplace

py37 setup.py bdist_wheel
py38 setup.py bdist_wheel
py39 setup.py bdist_wheel
py310 setup.py bdist_wheel
py311 setup.py bdist_wheel

py37 -m unittest -v
py38 -m unittest -v
py39 -m unittest -v
py310 -m unittest -v
py311 -m unittest -v

if [[ "$OSTYPE" == "linux"* ]];then
    cd ./dist
    auditwheel repair --plat manylinux_2_17_x86_64 *.whl
    cd ..
fi