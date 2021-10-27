# Lotta

<img src="https://static.startpunkt.io/lotta/lotta_app_icon.png" alt="Lotta Logo" width="100"/>

Lotta is a personal productivity tool, that allows you to write an infinite stream of notes and tasks, organized with inline projects and tags.

Host it yourself (see below), or choose the hosted version at Lotta.Cloud.

Give it a try - it's free to get started.  [Lotta.Cloud](https://lotta.cloud)

[![Screenshot](https://static.startpunkt.io/lotta/lotta_screenshot.png)](https://blazer.dokkuapp.com)

Lotta is still very early in its development. It'll evolve over the coming months, but I'd also love to see anyone else's contributions. :smile:

## Features

- **Endless notes** - Write an endless list of notes
- **Projects and tags** - Smart inline parsing of @projects and #tags
- **Passwordless Auth** - Emails and magic login links


## Stack
- Ruby on Rails 6
- Hotwire (Turbo + Stimulus)
- SQLite or Postgres

## Docs

- [Installation](#installation)
- [Authentication](#authentication)

## Installation

Depending on the hosting service of your choice, you'll be able to deploy Lotta very quickly:

### Deployment

#### Heroku
1. Clone the repo 
2. Install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) and sign in to Heroku
3. Create a new app on Heroku and [deploy Lotta](https://devcenter.heroku.com/articles/getting-started-with-rails6)
4. Run `heroku run rails db:migrate` from you command line and you're off to the races. All that's left is to set up email sending.

#### DigitalOecan
1. Create a new app service and select the Lotta repo
2. Wait for the deployment and run `rails db:migrate` in the app service's console
3. Set up email sending and use Lotta!

### Configure email setup
Lotta is preconfigured to look for SMTP credentials in the app's environment.

You'll need to set the following environment variables:
- `ACTION_MAILER_SMTP_ADDRESS`
- `ACTION_MAILER_SMTP_USERNAME`
- `ACTION_MAILER_SMTP_PASSWORD`
- `ACTION_MAILER_SMTP_PORT`
- `ACTION_MAILER_HOST_URL` (alternatively uses the `APPLICATION_HOST`)
- `ACTION_MAILER_HOST_PROTOCOL` (otherwise defaults to https)

If you'll want to use rails credentials instead, you'll need to clone the repo, run `rails credentials:edit` to set credentials and configure the `config/environments/production.rb` to use credentials instead. See the below example.

```
  config.action_mailer.smtp_settings = {
    port: 25,
    address: smtp.whateveryoureusing.com,
    user_name: Rails.credentials[:aws][:smtp_user_name],
    password: Rails.credentials[:aws][:smtp_password],
    authentication: :plain,
    enable_starttls_auto: true
  }
```
Don't forget to set the `RAILS_MASTER_KEY` in the environment.

## Authentication

Lotta uses [Passwordless by Mikkel Malmberg](https://github.com/mikker/passwordless) for passwordless authentication. You can simply sign up by visiting the root URL of you app. Any other changes can easily made in the console by editing `User` objects.

Currently there is no password-based authentication planned (e.g. using Devise), but I'd love to see someone doing that.

## Thanks

Lotta uses a number of awesome open source projects, including [Rails](https://github.com/rails/rails/), [Bulma](https://github.com/jgthms/bulma), [Passwordless](https://github.com/mikker/passwordless), [Pagy](https://github.com/ddnexus/pagy) and [ActsAsTaggableOn](https://github.com/mbleigh/acts-as-taggable-on).


## Want to Make Lotta Better?

That’s awesome! Here are a few ways you can help:

- [Report bugs](https://github.com/benedictbartsch/lotta/issues)
- Fix bugs and [submit pull requests](https://github.com/benedictbartsch/lotta/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features (which you can also do in the official [FeatureCat board for Lotta](https://lottacloud.featurecat.app))