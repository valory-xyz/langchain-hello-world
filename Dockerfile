FROM python:3.12

# Let uv manage the venv at the project root; copy-link mode keeps the
# image hermetic when the cache lives outside the project dir.
ENV UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/langchain_hello_world/.venv

WORKDIR /langchain_hello_world

# Project metadata + lockfile first so the install layer caches when
# only source changes.
COPY pyproject.toml uv.lock README.md ./
COPY start.sh start.sh
COPY langchain_hello_world/ langchain_hello_world/

# Install uv, then resolve the runtime deps from the committed lock.
# --no-default-groups skips the `release` dev group (pyinstaller) that
# only the binary-build workflow needs.
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && mv /root/.local/bin/uv /usr/local/bin/uv \
    && uv --version \
    && uv sync --frozen --no-default-groups

RUN chmod +x start.sh

ENTRYPOINT ["/langchain_hello_world/start.sh"]

HEALTHCHECK --interval=3s --timeout=600s --retries=600 CMD echo "Add your healthcheck command here" > /dev/null; if [ 0 != $? ]; then exit 1; fi;
