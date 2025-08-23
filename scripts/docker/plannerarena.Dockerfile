# FROM rocker/shiny-verse:4.0.3
# # RUN apt-get update && \
# #     apt-get install -y libv8-dev libjpeg-dev
# RUN install2.r --error --deps TRUE \
#     shinyjs \
#     V8 \
#     pool \
#     Hmisc \
#     RSQLite \
#     markdown && \
#     rm -rf /tmp/downloaded_packages/
# COPY plannerarena /srv/shiny-server/plannerarena
# COPY docker/plannerarena.conf /etc/shiny-server/shiny-server.conf
# ADD --chown=shiny:shiny https://www.cs.rice.edu/~mmoll/default-benchmark.db \
#     /srv/shiny-server/plannerarena/www/benchmark.db



# Dockerfile for PlannerArena Shiny App
# Build with
# replace your_repo/plannerarena:1.0 with your desired image name
# docker build -f ./docker/plannerarena.Dockerfile -t your_repo/plannerarena:1.0 .
# Run with
# 8888 is defined in plannerarena.conf
# docker run -d --name plannerarena -p 80:8888 your_repo/plannerarena:1.0 .

# sudo docker run -d --name plannerarena -p 80:8888 leonz0u/plannerarena-slim:1.1

# ============== Builder Stage ==============
FROM rocker/shiny:4.0.3 AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libv8-dev \
        libjpeg-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev && \
    rm -rf /var/lib/apt/lists/*

RUN install2.r --error --deps TRUE \
    shinyjs \
    V8 \
    pool \
    Hmisc \
    RSQLite \
    markdown && \
    rm -rf /tmp/downloaded_packages/

# ============== Final Stage ==============
FROM rocker/shiny:4.0.3

COPY --from=builder /usr/local/lib/R/site-library /usr/local/lib/R/site-library

COPY plannerarena /srv/shiny-server/plannerarena
COPY docker/plannerarena.conf /etc/shiny-server/shiny-server.conf

ADD --chown=shiny:shiny https://www.cs.rice.edu/~mmoll/default-benchmark.db \
    /srv/shiny-server/plannerarena/www/benchmark.db