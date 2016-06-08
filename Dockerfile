FROM rails

WORKDIR /usr/src/app

ENV DISCOURSE_VERSION 1.5.2

RUN curl --silent --location https://deb.nodesource.com/setup_4.x | bash -

# The above will do an apt-get update
RUN apt-get install -yqq --no-install-recommends \
    libxml2 \
    nodejs \
    wget \
    && npm install uglify-js -g \
    && npm install svgo -g \
    && apt-get install -yqq --no-install-recommends \
    advancecomp jhead jpegoptim libjpeg-turbo-progs optipng

RUN mkdir /jemalloc && cd /jemalloc \
    && wget http://www.canonware.com/download/jemalloc/jemalloc-3.6.0.tar.bz2 \
    && tar -xjf jemalloc-3.6.0.tar.bz2 && cd jemalloc-3.6.0 && ./configure && make \
    && mv lib/libjemalloc.so.1 /usr/lib && cd / && rm -rf /jemalloc

COPY install-imagemagick /tmp/install-imagemagick
RUN /tmp/install-imagemagick

# Validate install
RUN ruby -e "v='`convert -version`'; ['png','tiff','jpeg','freetype'].each{ |f| ((STDERR.puts('no ' + f +  ' support in imagemagick')); exit(-1)) unless v.include?(f)}"

COPY install-pngcrush /tmp/install-pngcrush
RUN /tmp/install-pngcrush

COPY install-gifsicle /tmp/install-gifsicle
RUN /tmp/install-gifsicle

COPY install-pngquant /tmp/install-pngquant
RUN /tmp/install-pngquant

RUN curl -L https://github.com/discourse/discourse/archive/v${DISCOURSE_VERSION}.tar.gz \
  | tar -xz -C /usr/src/app --strip-components 1 \
 && bundle config build.nokogiri --use-system-libraries \
 && bundle install --deployment --without test --without development

RUN rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV production
ENV RUBY_GC_MALLOC_LIMIT 90000000
ENV DISCOURSE_DB_HOST postgres
ENV DISCOURSE_REDIS_HOST redis
ENV DISCOURSE_SERVE_STATIC_ASSETS true

RUN useradd discourse -s /bin/bash -m -U \
    && find /var/www/discourse/vendor/bundle -name tmp -type d -exec rm -rf {} +

EXPOSE 3000
CMD ["unicorn.sh"]
