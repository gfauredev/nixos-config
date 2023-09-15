#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python310Packages.pygobject3 -p gobject-introspection -p libfprint -p gusb

import gi
gi.require_version('FPrint','2.0')
from gi.repository import FPrint

ctx = FPrint.Context()

for dev in ctx.get_devices():
    print(dev)
    print(dev.get_driver())
    print(dev.props.device_id);

    dev.open_sync()

    dev.clear_storage_sync()
    print("All prints deleted.")

    dev.close_sync()
