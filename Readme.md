# Sourcerer

A ruby based utility to apply rules to url datasources and insert filtered results into a Sidekiq compatible Redis queue.

Sourcerer makes no assumptions about the HTTP request or response. It leaves you, the user, to determine what data to use as input. This utility allows you to perform a handful of filters and conditions on the url itself in a programatic fashion.

It will not evaluate urls in aggregate, so you should ensure input is unique and that any post-processing handles your assumptions appropriately.

### Examples

Modify the `config.yaml` file with all of the rules you wish to run. A full list of rules can be found [here](lib/rules/).

#### Extrapolate the first folder

```yaml
redis-server: 127.0.0.1:6379
matchers:
  rules:
    - rule:
      - FirstFolder
```

#### Grab all content on a non standard port without extra content

```yaml
redis-server: 127.0.0.1:6379
matchers:
  rules:
    - rule:
      - NonStandardPort

    - rule:
      - CSSExtension
      - EOTExtension
      - ICOExtension
      - JPGExtension
      - JSExtension
      - MP3Extension
      - MP4Extension
      - SVGExtension
      - TTFExtension
      - WAVExtension
      - WOFFExtension
      condition: not
  condition: and
```

Finally when you are ready to ready to filter your input you would run:

```
$ ruby sourcerer.rb --urls --file urls.txt
```

By default the program will write the matching rules to the `queue:aggregator_urls` queue in Redis. You can verify how may items were inserted by the following:

```
$ redis-cli
127.0.0.1:6379> llen queue:aggregator_urls
(integer) 1
127.0.0.1:6379> lindex queue:aggregator_urls 0
"{\"retry\":true,\"queue\":\"aggregator_urls\",\"class\":\"aggregator_urls\",\"args\":[\"https://foobar.com/example/\"],\"jid\":\"ba43fb12fa425f91939ca7fa\",\"created_at\":1627485361.3008845,\"enqueued_at\":1627485361.3009098}"
```

You can specify the class and queue with the following arguments:

```
$ ruby sourcerer.rb --urls --class=urls --queue=fuzzing_urls --file urls.txt
```

#### Recursive Folder Lookup
By default Sourcerer will perform a recursive lookup on folders and run the same rules against them. This results in the following paths being evaluated:

```
/api/v1/details/getDetails
/api/v1/details/
/api/v1/
/api/
```

To disable this behavior add the `--disable-recurse` flag.

### FAQ

**Why?**

Url filtering is a challenge to perform consistently with constantly changing needs. You may want to identify all of the urls with a query string for fuzzing. The next iteration you might want to identify all urls with '/api/' in their path and have a query string. 

**What is Sidekiq?**

Sidekiq is a ruby gem that allows for Rails applications to process jobs as workers are added. You can read about it [here](https://github.com/mperham/sidekiq).

**Why Sidekiq?**

Even if you aren't looking to learn Rails the Sidekiq syntax creates a languague interoperable syntax. This means that while this program will insert the data into Redis from Ruby you can use another language such as Python or Go to easily process the job. An example in Go is https://github.com/jrallison/go-workers/

**Do you have details on Redis?**

This program uses the queueing functionality of Redis, which allows for pushing and popping items to a queue. Redis runs in-memory, but regularly saves itself to disk so that it can be persistent across device reboots. Any client handling output from Sourcerer would likely want to use [LPOP](https://redis.io/commands/LPOP) to pop the left most item on the queue.


### Contributing

If you have made a rule that you feel is helpful or filters to "interesting" content then please make a PR or create an issue with a suggestion.