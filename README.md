# All Apple Devices

It provides the complete list of devices found in Xcode's databases.

## How it does work...

For every Xcode instance installed, there is a `/Developer` directory where relevant development tools are located, including the command-line tool.

> /Applications/Xcode.app/Contents/Developer

The public databases of Apple devices are **organized by device traits** and can be found inside this `/Developer` folder, under the `/Platforms` directory:

```
/Applications/Xcode.app/Contents/Developer/Platforms/{platform}/usr/standalone/device_traits.db
```
... where `platform` is any of:

+ `iPhoneOS.platform`
+ `AppleTVOS.platform`
+ `WatchOS.platform`

Internally, this package takes the path of the selected Xcode's command-line tool by executing the command:

```
xcode-select -p
```

... this way, it is ensured to always work over the selected development environment.

> *Developers can switch among different command-line tools installed by using the `xcode-select` CLI.*
> 
> ```
> xcode-select --switch <path>
> ```

To provide the information on the Xcode version used during the code generation, it is being used the `xcodebuild` CLI by executing the command:

```
xcodebuild -version
```

## The Command-Line Interface

The `all-apple-devices` CLI provides the information of all the devices available in the selected command-line tool database.

### Installation

Simply run `make install` within a local copy of the `AllAppleDevices ` repo:

```
git clone https://github.com/EmilioOjeda/AllAppleDevices.git
cd AllAppleDevices
make install
cd ../
rm -rf AllAppleDevices
```

When getting a **Permissions Denied** error, i.e.:

```
install .build/release/all-apple-devices /usr/local/bin/all-apple-devices
install: /usr/local/bin/all-apple-devices: Permission denied
make: *** [install] Error 71
```

... execute `sudo make install` instead.

### The `generate` command

The `generate` command triggers the code generation of the `Device.swift` file.

The file's content may vary depending on the **Platform IDs** set to the `--platforms` option. This option can be omitted, and by doing so, the data of all the platforms are generated.

And the file generated is written out to the path set to the `--output` option.

Command help documentation can be read by executing `all-apple-devices generate -h`.

```
OVERVIEW: Generates the 'Device.swift' file for the given 'platforms' at the given 'path'.

USAGE: all-apple-devices generate [--platforms <platforms> ...] --output <output>

OPTIONS:
  -p, --platforms <platforms>
                          The platform traits to produce -- i.e., '--platforms iphoneos tvos watchos'. (default: iphoneos, tvos, watchos)
  -o, --output <output>   The path where the 'Device.swift' file is going to be written.
  -h, --help              Show help information.
```
