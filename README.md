# To Replicate without ad or wrk:

1. You need to modify tcp_connection.pony in lori to use close()
   instead of shutdown or you run out of filedescriptors.

   The Makefile all: target just runs `corral run -- ponyc -d .`,
   and then runs the application after.

   It runs on port 50000

2. In the generate_load directory you will find a very simple client
   that just connects, makes a simple request, grabs the response,
   writes a single "." (so you can see when it hangs), and calls it
   again.  It explicitly does one connection at a time.

One of the sessions hangs.

You *are* able to make new connections.

So, I can probably work-around it at least initially by putting a
timeout on all connections, but it's probably something we should
try and identify *before* I add more complexity.

I do have a few working hypotheses, but I don't want to "pollute"
your approach or distract.

Just the facts as you requested.

