#/bin/bash
cp *.spec *.changes *.tar.gz ~/src/home:vranki/siilihai-mobile
cp ../../siilihai-mobile_*.tar.gz ../../siilihai-mobile*.dsc ~/src/home:vranki/siilihai-mobile
pushd ~/src/home:vranki/siilihai-mobile
osc add *.tar.gz
osc add *.dsc
osc add *.spec
osc add *.changes
osc commit -m 'new stuff'
popd
