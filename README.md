# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Getting Started

There is a dependency on the development branch of the gem `isbm2_adaptor_rest`, which
is accessible via the [Assetricity GitHub](https://github.com/assetricity/isbm2_adaptor_rest).
As there is a problem automatically building the gem when it is listed in the Gemfile for
Windows (some of the test files cause a `path too long` error), it is necessary to independently
clone the repository, build the gem, and install it locally. That is,

```bat
cd "Some\short\path"
git clone https://github.com/assetricity/isbm2_adaptor_rest.git
git checkout 'the-appropriate-branch'
cd isbm2_adaptor_rest
gem build .\isbm2_adaptor_rest.gemspec
gem install .\isbm2_adaptor_rest-<version.number>.gem
cp .\isbm2_adaptor_rest-<version.number>.gem "path\to\ogipilot-demo-run\vendor\"
```

The last line, copying into the vendor folder, is required for the Dockerfile to be able to
build the image successfully. If a new germ version is being built, the Dockerfile will need
to be updated to install the correct version.

For convenience for the time being, the build gem in the vendor folder is committed to git.
