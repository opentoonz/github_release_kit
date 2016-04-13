github_release_kit
==================

Release binaries to github

```
bundle install
bundle exec bin/github_release_kit release \
  --api_url=http://your.github.url/api/v3 \
  --token XXXXXXXXXXXXXXXXXX \
  --user kogaki \
  http://your.github.url/opentoonz/opentoonz \
  ../test.pkg
```
