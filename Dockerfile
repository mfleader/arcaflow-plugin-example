ARG package=arcaflow_plugin_example

# build poetry
FROM quay.io/centos/centos:stream8 as poetry
ARG package
RUN dnf -y module install python39 && dnf -y install --setopt=tsflags=nodocs python39 python39-pip

WORKDIR /app

COPY poetry.lock /app/
COPY pyproject.toml /app/

RUN python3.9 -m pip install poetry \
    && python3.9 -m poetry export -f requirements.txt --output requirements.txt --without-hashes


# final image
FROM quay.io/centos/centos:stream8
ARG package
RUN dnf -y module install python39 && dnf -y install --setopt=tsflags=nodocs python39 python39-pip

WORKDIR /app

COPY --from=poetry /app/requirements.txt /app/
COPY LICENSE /app/
COPY README.md /app/
COPY ${package}/ /app/${package}

RUN python3.9 -m pip install -r requirements.txt

WORKDIR /app/${package}

ENTRYPOINT ["python3", "example_plugin.py"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/arcalot/arcaflow-plugin-example"
LABEL org.opencontainers.image.licenses="Apache-2.0+GPL-2.0-only"
LABEL org.opencontainers.image.vendor="Arcalot project"
LABEL org.opencontainers.image.authors="Arcalot contributors"
LABEL org.opencontainers.image.title="Arcaflow Example Plugin"
LABEL io.github.arcalot.arcaflow.plugin.version="1"