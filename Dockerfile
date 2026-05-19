FROM python:3.12

# Let uv manage the venv at the project root; copy-link mode keeps the
# image hermetic when the cache lives outside the project dir.
ENV UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/langchain_hello_world/.venv

WORKDIR /langchain_hello_world

# Install uv first so the install layer is reused across builds.
# UV_INSTALL_DIR sets the binary's destination directly — avoids
# hard-coding the installer's /root/.local/bin path (which only
# happens to be correct because the image runs as root).
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh \
    && uv --version

# Project metadata + lockfile first so the dep-install layer is reused
# whenever only application source changes. --no-default-groups skips
# the `release` dev group (pyinstaller) that only the binary-build
# workflow needs.
COPY pyproject.toml uv.lock README.md ./
RUN uv sync --frozen --no-default-groups

# Application source last so source-only edits don't bust the dep cache.
COPY start.sh start.sh
COPY langchain_hello_world/ langchain_hello_world/

RUN chmod +x start.sh

ENTRYPOINT ["/langchain_hello_world/start.sh"]

HEALTHCHECK --interval=3s --timeout=600s --retries=600 CMD echo "Add your healthcheck command here" > /dev/null; if [ 0 != $? ]; then exit 1; fi;
