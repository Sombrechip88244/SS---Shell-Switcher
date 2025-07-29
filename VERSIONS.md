# Versions:
## To create a new version:
1. Go onto github in the releases column and draft a new release
2. Make the release tag a v1.2.3 for example, make it one more than the last release
3. Name the release "Shell Switcher v1.2.3 or whatever the version is"
4. Then write suitable release notes then press generate release notes then press publish release
5. Then go into /homebrew-tap/Formula/shell-switcher.rb ruby file and change the end bit of the url after tags to the version tag name
6. Then run
```
curl -L https://github.com/Sombrechip88244/ss/archive/refs/tags/VERSION-TAG.tar.gz | shasum -a 256
```
-Replace VERSION TAG with the version tag you created-
7. Then save and commit and push/pull on both "ss" and "HOMEBREW-TAP"
8. Then to download the update run
```
brew update
```
and
```
brew upgrade ss
```