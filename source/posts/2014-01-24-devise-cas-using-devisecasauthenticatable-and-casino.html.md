---
title: Devise & CAS, using devise_cas_authenticatable and CASino
date: 2014-01-24 11:37 UTC
tags: ruby
---

I work on a multi-tenant Rails application that serves four different sites (a.com, b.com, c.com, d.com) from a single instance. The user accounts are *not* constrained to a single site, so a user can log in to any one of the sites with the same credentials.

The business owners asked me to find a way to allow a user who has logged into any one domain (e.g. a.com) to be able to visit any of the others (e.g. b.com, c.com, d.com) without needing to log in again. If these sites were subdomains of the same root domain, it would be easy, as they could simply share the session cookie. But since they are each distinct root domains, the browser cannot share session information.

The app already uses Devise for user authentication, so I started looking for SSO solutions that would work with Devise, such as Omniauth and CAS. I chose a CAS approach, using [devise_cas_authenticatable](https://github.com/nbudin/devise_cas_authenticatable) for my application and [CASino](http://casino.rbcas.com/) for the CAS server.

Here’s how I got everything working:

From the CASino website, I grabbed their ready-to-use [CASinoApp Rails application](https://github.com/rbCAS/CASinoApp).

CASino has a gem for ActiveRecord authentication, but it simply verifies that email and password are correct. In my application, there are cases where email and password may be correct, but I don’t want to authenticate the user (e.g. if they are marked inactive, or haven’t confirmed their sign up yet). So rather than using their casino-activerecord_authenticator gem, I created a small authenticator to be used by CASino:

```
require 'casino/authenticator'
class CASino::ActiveRecordModelAuthenticator < CASino::Authenticator

  # @param [Hash] options
  def initialize(options)
    @options = options

    @model = "#{@options[:table].classify}".constantize
  end

  def validate(username, password)
    @model.validate(username, password)
  end

end
```

Then I modified my cas.yml configuration to use this authenticator:

```
development:
  authenticators:
    my_application:
      class: "CASino::ActiveRecordModelAuthenticator"
      options:
        connection:
          adapter: mysql2
          database: my_application_development
          pool: 5
          username: root
          password:
          socket: /tmp/mysql2.sock
        table: "users"
```

The authenticator determines the name of the user model from the configuration file and then passes the username and password entered to the validate method. I created a User model in the CASino application with that validate method:

```
require 'bcrypt'
class User < ActiveRecord::Base
  establish_connection(CASino.config.authenticators["my_application"]["options"]["connection"])

  def self.validate(username, password)
    user = find_by_email!(username)
    if user.valid_password?(password) && user.active_for_authentication?
      { username: user.email }
    else
      false
    end

  rescue ActiveRecord::RecordNotFound
    false
  end

  def valid_password?(password)
    return false if encrypted_password.blank?
    BCrypt::Password.new(encrypted_password) == password
  end

  def active_for_authentication?
    !inactive && confirmed?
  end

  def confirmed?
    !!confirmed_at
  end

end
```

Now back in my main Rails app, I added the devise_cas_authenticatable gem and replaced `:database_authenticatable` with `:cas_authenticatable`. But CASino is only handling authentication, I still need to be able to register new users and allow existing users to change their passwords in the main application. Devise stil needs access to the DatabaseAuthenticatable model module, so I also added `include Devise::Models::DatabaseAuthenticatable` to my User model.

I then added the following CAS configuration options to my devise.rb:

```
config.cas_base_url = "http://casino.dev"
config.cas_username_column = "email"
config.cas_logout_url_param = "destination"
config.cas_destination_logout_param_name = "service"
config.cas_create_user = false

config.warden do |manager|
  manager.failure_app = DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp
end
```

That last block tells Warden to use devise_cas_authenticatable’s WardenFailureApp, which will sign out of CASino if the user is made inactive during their session.

Finally, I needed to override the Devise confirmations_controller, so that it would redirect to the CASino server after confirming sign up, rather then signing in immediately. In the show action, I replaced these lines:

```
sign_in(resource_name, resource)
respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
```

With this redirect:

```
redirect_to(cas_login_url)
```

And then added a private method to the controller for determining the CAS login URL:

```
private

def cas_login_url
  ::Devise.cas_client.add_service_to_login_url(::Devise.cas_service_url(request.url, devise_mapping))
end
helper_method :cas_login_url
```
