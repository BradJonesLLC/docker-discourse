# docker-discourse

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=brjllc&url=https://github.com/BradJonesLLC/docker-discourse&title=docker-discourse&language=&tags=github&category=software) 

This Docker container is an effort to provide a more self-contained, immediately-deployable
image for the [Discourse](http://www.discourse.org/) discussion platform.

For background, see [this discussion](https://meta.discourse.org/t/can-discourse-ship-frequent-docker-images-that-do-not-need-to-be-bootstrapped/33205/49?u=bradj)
on the Discourse Meta forum.

This image is still very much a work in progress and you are encouraged to
build your own image instead of depending on the Docker Hub automated build,
until the architecture is more settled. I would hope this repository can be
deprecated in the future in favor of a recognized image from the maintainers.

## Usage

At the moment, this image assumes you are running a PostgreSQL server at `postgres`,
and a Redis instance at `redis`.

You should set the following (hopefully self-explanatory) environment variables for the app container:

* `DISCOURSE_DEVELOPER_EMAILS`
* `DISCOURSE_SMTP_ADDRESS`
* `DISCOURSE_SMTP_PORT`
* `DISCOURSE_SMTP_USER_NAME`
* `DISCOURSE_SMTP_PASSWORD`
* `DISCOURSE_DB_PASSWORD` (the username is pre-set to `postgres`)

A sample `docker-compose.yml` file is included for testing purposes. Database migration
and regular asset creation are not yet configured; to bootstrap the application
for the first time, run:

```
docker-compose run -u discourse app rake db:migrate assets:precompile
```

In production, you will want to mount `/shared` in the `app` container for data permanence.

## Known issues and OFI's

- [ ] Log rotation?

## License and Copyright

&copy; 2016 Brad Jones LLC and Civilized Discourse Construction Kit, Inc.

GPL License.
