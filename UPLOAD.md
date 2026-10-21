# Platform upload

Upload **upload/game-build.zip**. The upload folder contains only this archive.
The archive has index.html at its root and only the exported runtime files and license.
It contains no project source, engine templates, Hub artwork/metadata or duplicate .gz/.br files.

web-build/ is a separate local Game Hub preview with its HTTP compression cache; do not upload it.
Run build-web.ps1 to rebuild both. To recreate only the upload archive from an existing
validated preview: python tools/web-size/package_web.py . --upload-only.

The .wasm and .pck inside the ZIP are required game binaries, not source files.
The platform extracts this ZIP to run the game and may compress HTTP responses itself.
