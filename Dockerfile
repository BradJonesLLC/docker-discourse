FROM rails

WORKDIR /usr/src/app

ENV DISCOURSE_VERSION 1.5.2

RUN curl --silent --location https://deb.nodesource.com/setup_4.x | sudo bash -
RUN apt-get update && apt-get install -yqq --no-install-recommends \
    libxml2 \
    nodejs \
    npm install uglify-js -g \
    && npm install svgo -g \
    && apt-get install -yqq --no-install-recommends \
    advancecomp jhead jpegoptim libjpeg-turbo-progs optipng
    && rm -rf /var/lib/apt/lists/*

ADD install-imagemagick /tmp/install-imagemagick
RUN /tmp/install-imagemagick

# Validate install
RUN ruby -e "v='`convert -version`'; ['png','tiff','jpeg','freetype'].each{ |f| ((STDERR.puts('no ' + f +  ' support in imagemagick')); exit(-1)) unless v.include?(f)}"

ADD install-pngcrush /tmp/install-pngcrush
RUN /tmp/install-pngcrush

ADD install-gifsicle /tmp/install-gifsicle
RUN /tmp/install-gifsicle

ADD install-pngquant /tmp/install-pngquant
RUN /tmp/install-pngquant

ADD phantomjs /usr/local/bin/phantomjs

RUN curl -L https://github.com/discourse/discourse/archive/v${DISCOURSE_VERSION}.tar.gz \
  | tar -xz -C /usr/src/app --strip-components 1 \
 && bundle config build.nokogiri --use-system-libraries \
 && bundle install --deployment --without test --without development

ENV RAILS_ENV production
ENV RUBY_GC_MALLOC_LIMIT 90000000
ENV DISCOURSE_DB_HOST postgres
ENV DISCOURSE_REDIS_HOST redis
ENV DISCOURSE_SERVE_STATIC_ASSETS true

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
