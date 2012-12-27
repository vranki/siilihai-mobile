#/bin/bash
version=0.9.8
target=siilihai-mobile

rm -rf /tmp/$target-*
rm *.tar.gz
rm ../../$target*.tar.gz ../../$target*.dsc

pushd ..
qmake
make clean
make distclean
popd

pushd ../..
cd libsiilihai
make clean
make distclean
popd
pushd ..
rm -rf libsiilihai
cp -r ../libsiilihai .
rm -rf libsiilihai/.git
popd

pushd ../..
cp -r $target /tmp/$target-$version
rm -rf /tmp/$target-$version/.git
popd

pushd /tmp
tar cvfz $target-$version.tar.gz $target-$version
popd

mv /tmp/$target-$version.tar.gz .

pushd ..
debuild -S -us -uc -i$target-$version.tar.gz -i.git
popd
