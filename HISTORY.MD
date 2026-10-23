# Release History - Langchain Hello World

## v0.1.1 (2026-10-23)

* Added a release workflow that builds PyInstaller binaries for Linux and macOS
* Migrated from Poetry to uv; the Docker image and binaries install from `uv.lock`
* Made the package importable and the container start hermetic
* Ported the legacy vulnerability exceptions to `.safety-policy.yml` and added an "All checks passed" CI gate
* Updated the macOS release runner and dropped the unsupported Windows ARM build
* Bumped `uv` to `0.13.4` and relocked `certifi` to `2026.10.23`, dropping the compromised eMudhra intermediates from the binaries' trust store

## v0.1.0 (2025-02-20)

* Initial Release
