echo PATH = $PATH
echo vessel @ `which vessel`

echo
echo == Build.
echo

dfx start --background
dfx build

echo
echo == Test.
echo

dfx canister install Test
dfx canister call Test test '()'

echo
echo == Rawmap.
echo

dfx canister install RawMap
dfx canister call RawMap selfTest '()'
