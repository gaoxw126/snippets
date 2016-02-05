### Instroduction

My vim configuration based on the [spf13-vim](https://github.com/spf13/spf13-vim)

### Installation

Follow the manual of installation of spf13-vim, and run the following commands:

```shell
cp .vim.before.local ~/
cp .vim.bundles.local ~/
cp .vim.local ~/
sudo vim +BundleInstall +BundleClean +q
```

### Note

+ Some problems may occur during the installation of [color_coded](https://github.com/jeaye/color_coded).
  If CMake gives error:
```
>   execute_process called with no value for WORKING_DIRECTORY.
```
  just build the project in another directory where you have write access.
