# Project Chitraguptan

## Project Plan

Meaning: Hindu god/divine figure who is assigned with the task of record keeping

This is an app to develop the dynamic variable manager for Rails.

We save some values as constant in a rails model

``` rb
class RfidTag < ActiveModel
  def self.filter_weak_rssi
    where('rssi < 100')
  end
end
```

Similarly we might hard code values at different parts of the app. To make this
configurable we enter the value into the config file, env file, or store it in
a model in the DB.

So they can be used as:

```rb
  where('rssi < ?', ENV['WEAK_RSSI'])
  # or
  where('rssi < ?', Rails.configuration.custom_config.weak_rssi)
  # or
  where('rssi < ?', RfidSetting.first.weak_rssi)
```

First two required re deploying our rails app, and committing or changing files.
The last one requires you to create and maintain an extra model, but it does allow
one to change the variables on the file.

This project aim is to reduce this burden managing variables, this is especial useful in
building feature simple feature toggles.

```rb
  where('rssi < ?', Chitraguptan.get("week_rssi", default: 100))
```

Now this variable will be set as `chitraguptan:week_rssi` in your redis database and also
stored in your database inside the table: chitraguptan_variabels. The table has 3 fields
id, key, value  - (int 32, varchar, jsonb)

## Purpose of this repo

Build the whole feature inside this repo and then extract it to a gem

## Things to do

1. Connect to redis - Done
2. Configuration to add prefix to the variables used - Done
3. Define api to set data, delete data, give default if data doesn't exist - Done
4. Load existing variables and set them in redis if they don't exist (during boot) - Done
5. Admin UI to CRUD manage the variables - Done
6. Control following settings from initializer
   1. Redis URL
   2. Auto persistance of variables
   3. Auto load for variables during boot
7. Extract the code to its own gem
8. Write more API documentation
9. Release the gem to rubygems

## Nice to have

1. Load from file the list of variables (to use without the DB)
