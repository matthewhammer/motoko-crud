\#!/bin/bash
VERSION=`cat .DFX_VERSION`
export PATH=~/.cache/dfinity/versions/$VERSION:`pwd`:$PATH

echo
echo Starting: test...using DFINITY SDK replica
echo
dfx start --background --clean

echo
echo test suite started.
echo

echo
echo == NatIntMap test.
echo

dfx canister create NatIntMap &&\
dfx build NatIntMap &&\
dfx canister install NatIntMap &&\
dfx canister call NatIntMap selfTest '()'

echo
echo == RawMap test.
echo

dfx canister create RawMap &&\
dfx build RawMap &&\
dfx canister install RawMap &&\
dfx canister call RawMap selfTest '()'

echo
echo == Color palette test.
echo

dfx canister create ColorPalette &&\
dfx build ColorPalette &&\
dfx canister install ColorPalette &&\
dfx canister call ColorPalette selfTest '()'

echo
echo == Game entity test.
echo

dfx canister create GameEntities &&\
dfx build GameEntities &&\
dfx canister install GameEntities &&\
dfx canister call GameEntities selfTest '()'

echo
echo test suite done.
echo
