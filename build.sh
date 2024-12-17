. configure.sh

echo ""
d=./build/install
make
make install prefix=$d

echo ""
echo "DEPLOY GFORTRAN LIBS"
for lib in ${LIBS[@]}; do
    if [ -f $ROOT$lib$EXT ]; then
        cp -v $ROOT$lib$EXT $d/lib/
    else
        echo -n $lib$EXT" -> "
        echo "Not found."
    fi
done

echo ""
echo "DEPLOY LIBS TO PYTHON"
cp -vf $d/bin/* py/src/$PYNAME/
cp -vf $d/include/$NAME*.h py/src/$PYNAME/
cp -vf $d/lib/* py/src/$PYNAME/

echo ""
echo "ZIP"
cd $d/
zip -r $NAME-$PLATFORM-$ARCH.zip .
cd ../../
mv $d/$NAME-$PLATFORM-$ARCH.zip ./build/

