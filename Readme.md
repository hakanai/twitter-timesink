
What
====

This quickly hacked together tool will crawl your home timeline and print out
statistics of who is tweeting the most. Retweets are separated into their own
column.

This might be useful if you have limited time in the day to read tweets and
you are trying to decide who to mute.


Quick Setup
===========

* Copy `secrets-template.yml` to `secrets.yml`
* Log into Twitter
* Create a new application at https://apps.twitter.com/app/new
    * Website can be anything you want, even http://example.com
    * Callback URLs can be blank
* Click 'manage keys and access tokens'
* Copy Consumer Key, Consumer Secret from here
* Click 'Create My Access Token'
* Copy Access Token, Access Token Secret from here

I know this is annoying but the API I'm using doesn't seem to have a better
option yet.
Why can't it be like Twitter clients, where you just have to login?
