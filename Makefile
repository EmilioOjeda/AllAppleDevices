install:
	swift build -c release
	install .build/release/all-apple-devices /usr/local/bin/all-apple-devices
