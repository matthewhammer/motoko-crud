echo PATH = $PATH
echo vessel @ `which vessel`

echo
echo == Build.
echo

dfx start --background
dfx canister create --all
dfx build

echo
echo == NatIntMap test.
echo

dfx canister install NatIntMap
dfx canister call NatIntMap test '()'

echo
echo == RawMap test.
echo

dfx canister install RawMap
dfx canister call RawMap selfTest '()'
