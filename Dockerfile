FROM rocker/shiny:4.5.0

# System dependencies
RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libglpk-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    pandoc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('Cairo', 'shiny', 'shinydashboard', 'shinyjs', 'DT', 'plotly', 'heatmaply', 'shinycssloaders', 'ggplot2', 'ggnewscale', 'data.table', 'fastcluster', 'remotes'))"


# Install Bioconductor and GitHub packages
RUN R -e "install.packages('BiocManager'); \
          BiocManager::install('ComplexHeatmap'); \
          BiocManager::install('circlize'); \
          remotes::install_github('jokergoo/InteractiveComplexHeatmap'); \
          remotes::install_github('satijalab/seurat', upgrade = 'never')"

# Copy your Shiny app to the image
COPY app /srv/shiny-server/

# Permissions
RUN chown -R shiny:shiny /srv/shiny-server

# Set host and port
ENV SHINY_PORT=3838
ENV SHINY_HOST=0.0.0.0

EXPOSE 3838

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
