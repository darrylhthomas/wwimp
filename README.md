# wwimp - World Wide Instructional Media Player

If you're like me, you'd really like to be able to watch the session videos from your favorite developers conference on your shiny new Apple TV without having to resort to something so crude as using AirPlay from your iOS device*.

My guess is our wish will be officially granted sometime in June of 2016, but in the meantime, I figured it would be fun and educational to create a basic media player app.

I give you wwimp: the world wide instructional media player that has absolutely no affiliation with Apple whatsoever. I won't be submitting wwimp to the App Store: It's just for educational, personal use.

Upon startup, wwimp will download a JSON file from a URL that you provide (more on this later). The JSON is expected to have the following structure:

```
{
	"tracks" : [
		"Track Name 1",
		"Track Name 2",
		(additonal tracks…)
	],
	"sessions" : [
		{
			"id" : 123,
			"title" : "A session title",
			"year" : 2015,
			"description" : "A description of the session",
			"focus" : [
				"Focus 1",
				"Focus 2",
				(additional focuses, foci, or whatever)
			],
			"url" : "http://example.org/streams/session123.m3u8",
			"images" : {
				"shelf" : "http://example.org/images/123_734s413.jpg",
				(additional images…)
			}
		},
		(additional sessions)
	]
}
```

If everything goes according to plan, wwimp will show you a list of sessions, tabbed by tracks. Click on a session and the video will start playing. Yay!

(I did say "basic," right?)

\* Note: AirPlay isn't crude. It's fantastic, but we can have native apps now!

## Setting The Sessions URL

If you ran wwimp without reading this, chances are you got an alert telling you to recombobulate the floodlebop with the wurzle or something like that. Here's the deal:

I'd like to believe that corporations with software platforms would encourage folks to watch their videos in the way they find most convenient, but I can't be sure.

It's entirely possible that said corporations would be unhappy if I were to distribute a project that facilitated the viewing of the corporation's content. Since we all know that corporations are people according to the U.S. Supreme Court, and we don't want unhappy people, **I have instead written a totally generic media player that will work with any URL that responds with JSON following the structure I described above.** When I consider the size of our universe, not to mention alternate dimensions, I'm guessing there are probably thousands of such URLs out there.

Thousands. Really.

So, if you want wwimp to wwork for you, you'll need to find the right one and modify the source code accordingly. Whatever URL you use is none of my business, and I'm not responsible for what you do with it.

On a completely unrelated note, I recently read a [GIST by Steven Troughton-Smith](https://gist.github.com/steventroughtonsmith/c24bb6b6a28c5b583008) that contained an interesting URL. I have no idea whether the URL would be of any use to you, but I'd like to thank Steven, regardless.

Once you do have a URL to use, you'll want to replace the empty string defined as SESSION_REQUEST_URL_STRING in WWIMPSessionTabBarController.m with the URL you have chosen. Alternatively, you can create a new scheme for the wwimp target and pass the URL as a runtime argument (eg. `-WWIMPSessionsURL https://example.org/path/to/json.json`). This way, you can easily avoid committing the URL into the source during development. You'll still need to set SESSION_REQUEST_URL_STRING if you plan on launching wwimp without the scheme.

## Upcoming Features

Again, wwimp is extremely basic, and I intend to keep it that way. That said, there are a few features I do intend to implement fairly soon, so be sure to watch this repo if you're interested in any of the following:

- Filtering by year
- Watched-state indicators to help you keep track of what you've already watched
- Favorites or a watch queue, possibly both
- Search

I'll also be cleaning up the code. Right now, I don't consider it something I'd want to use to show folks how to write Objective-C: I just cogged it up over a few hours and it shows.

Enjoy!
