#!/usr/bin/env sh

curmode="$(aerospace list-modes --current)"
focusedapp="$(aerospace list-windows --focused --format "%{app-bundle-id}")"

# say "curmode is $curmode, focusedapp is $focusedapp"

if [ "$curmode" = "main" ]; then
	if [ "$focusedapp" = "com.microsoft.rdc.macos" ]; then
		aerospace mode remote
	fi
elif [ "$curmode" = "remote" ]; then
	if [ "$focusedapp" != "com.microsoft.rdc.macos" ]; then
		aerospace mode main
	fi
fi
