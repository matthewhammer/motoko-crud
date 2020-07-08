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

dfx canister install --all
dfx canister call Test test '()'
