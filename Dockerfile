FROM python:3.10-slim-bullseye

LABEL maintainer="i@hanfangyuan.cn"
ARG TZ='Asia/Shanghai'

ENV BUILD_PREFIX=/app

WORKDIR ${BUILD_PREFIX}

COPY . ${BUILD_PREFIX}

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ffmpeg \
        espeak \
        libavcodec-extra \
        gcc \
        g++ \
        make \
    && cp config-template.json config.json \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r requirements-optional.txt \
    && pip install --no-cache-dir -r plugins/jina_sum/requirements.txt \
    # Clean up build tools and caches
    && apt-get remove -y gcc g++ make \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* ~/.cache/pip

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
