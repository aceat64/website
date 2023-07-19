---
status: new
description: A comical explanation of various HTTP status codes.
---

# HTTP Status Codes

Every HTTP response has a status code, which is a 3 digit number and sometimes actually conveys useful information about the status of the request. The first digit of the status code tells us the type of response. Often when talking about an entire type of status code people will replace the last two digits with `xx`, such as `5xx`. I like to do this when I don't actually care about the specific code or have forgotten what it was.

!!! info

    Mozilla has a number of articles that explain HTTP response codes "properly".
    You can find the full list of status codes here: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Status>

The list here is not complete, it is the status codes I see on a regular basis or that I find interesting. Anything not on my list is likely not used very often. This page assumes you already have a basic understanding of what an HTTP request is and how it looks.

## 1xx - Informational

These are the least used status codes. In practice, you'll probably never see these so I won't cover them here.

## 2xx - Success

Congratulations! Your request worked, *probably*. Some applications will give you a `2xx` status code, and then in the body of the response have an error message. I've often seen this as json with something like this:

``` json
{
    "success": false,
    "message": "Hah, I bet you thought your request worked. Sucker."
}
```

If you encounter an API with this behavior, you have a moral obligation to shame the developer.

### 200 - OK

Your request succeeded, also maybe here's what you requested.

### 201 - Created

You probably sent a `POST` or `PUT`, and something got created.

### 202 - Accepted

The server got your request and might do something with it later.

### 203 - Non-Authoritative Information

I think maybe some CDNs use this, it's weird and you should probably avoid it if you are designing an API.

### 204 - No Content

Like a 200, but there's nothing in the body. If there is something in the body, you should scold the developer.

## 3xx - Redirection

The thing you wanted isn't here.

### 300 - Multiple Choices

The thing you wanted is in more than one place, maybe. There's no standardized way of telling you what your choices are, only that there are multiple choices available.

### 301 - Moved Permanently

That thing you wanted is now at this new URL, check the `Location` header for where to go. Also don't bother asking again, the answer won't change.

### 302 - Found

Just like a 301, except temporary. You should probably ask again in the future, because the answer may change. Why isn't this called "Moved Temporarily"? Because that would be too easy.

### 303 - See Other

The server isn't sending you to the thing you requested, but it is sending you to another URL where you can `GET` it. Which is... kind of like a `301`/`302` I guess? But different, because we use this one when your request was a `POST` or `PUT`.

### 304 - Not Modified

You aren't getting the thing you wanted, because it hasn't changed since you last requested it. This is "redirecting" you to your own cache of the resource.

### 307 - Temporary Redirect

Wait, haven't we seen this one already? Yes, but no. A `302` is a response to a `GET` request, while a `307` is a redirection response to a `POST` or `PUT`. In this case the server is telling you to `POST`/`PUT` that same request, but at this other URL ([Tell him exactly what you told me](https://www.youtube.com/watch?v=fN-VAdAnoZ4)). Also, the URL might change next time you make this request.

### 308 - Permanent Redirect

Exactly like a `307`, but permanent.

## 4xx - Client Error

When you (the client) did something wrong, the server will typically return a `4xx` status.

### 400 - Bad Request

Your request was bad. If you're lucky the body might tell you *why* it was bad.

### 401 - Unauthorized

This actually means *unauthenticated*, as in you didn't give the server any information about who you are.

### 403 - Forbidden

You are *unauthorized*. The server knows who you are, you just aren't allowed in. Yeah, this isn't confusing at all.

<!-- ### 404 - Not Found -->

### 405 - Method Not Allowed

You used the wrong verb. Maybe you sent a `POST` but the server wanted a `PUT`, communication is hard.

### 406 - Not Acceptable

Your request probably had an `Accept` header, but whatever `Content-Types` you listed are not ones the server finds acceptable. This is almost never used, because the reasonable thing for the server to do is just send you a response in some default `Content-Type`.

### 407 - Proxy Authentication Required

I've never seen this one before, but it's just a fancier `401`. At least they called it authentication this time.

### 408 - Request Timeout

You held the connection open so long without doing anything that the server got tired of you. What about when the server takes too long to respond and the connection times out? You don't get a status code, because you didn't get a response! Duh.

### 409 - Conflict

Usually you'll see this in response to a `POST` or `PUT`. It's a useful way for the server to tell you "that thing already exists".

### 410 - Gone

Like a `404`, but the server acknowledges that the thing you wanted used to be there and is now gone forever. Very sad.

### 411 - Length Required

You forgot to put a `Content-Length` header in your request. No, I'm not going to make that joke. Grow up.

### 412 - Precondition Failed

Pretty rare, sometimes used for caching.

### 413 - Payload Too Large

The data you sent, probably via `POST` or `PUT`, was too big for the server to handle. Ok, yes, I see how that sounds.

### 414 - URI Too Long

You requested a URI that was so long the server gave up on trying to read it. That's actually kind of impressive, good job.

### 415 - Unsupported Media Type

When the site said no `.zip` files, they meant it.

### 418 - I'm a teapot

Yes, this is an [official status code](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/418). It's got an [RFC](https://www.rfc-editor.org/rfc/rfc2324#section-2.3.2) and everything.

### 422 - Unprocessable Content

Originally used for WebDAV, this status code is now used fairly widely. This error code is used when the request syntax and content is correct, but can't be processed. Most commonly this means that you are missing a required field.

### 429 - Too Many Requests

Slow down, you hit a rate limit.

### 451 - Unavailable For Legal Reasons

You get it? Because in the book Fahrenheit 451 they burned books. It's *very* clever and funny, unlike `418`.

## 5xx - Server Error

Sometimes you can do everything right and still lose, such as when the server runs into a problem that's (probably) not your fault.

### 500 - Internal Server Error

Something went wrong on the server side. Typically this will provide you with no additional details. This is done for security reasons, because detailed error messages could leak potentially sensitive information about what is going on behind the scenes.

### 502 - Bad Gateway

Your request went through a reverse proxy (load balancer) and the proxy got a bad or invalid response from the server.

### 503 - Service Unavailable

The most common reason for this is that the reverse proxy (load balancer) is up, but it has no upstream servers available.

### 504 - Gateway Timeout

Your request went through a reverse proxy (load balancer) and the proxy sent it to an upstream server, but the connection timed out. This can happen if the request is taking a long time to process but the proxy has a shorter timeout setting than the upstream server does.
