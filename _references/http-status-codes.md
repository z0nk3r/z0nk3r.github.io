---
layout: reference
title: "HTTP Status Codes"
excerpt: "Table of HTTP status codes and what they actually mean."
tags: [http, lookup, web]
---

## 1xx – Informational

| Code | Description | Notes |
|------|---------|-------|
| 100 | Continue | Client should keep sending the request body. |
| 101 | Switching Protocols | Sent in response to an `Upgrade` request header (e.g. to WebSocket). |
| 102 | Processing | WebDAV — request received, still working on it. |
| 103 | Early Hints | Lets the client start preloading resources before the final response is ready. |
{: style="--table-col-1: 8%; --table-col-2: 32%; --table-col-3: 60%;"}

## 2xx – Success

| Code | Description | Notes |
|------|---------|-------|
| 200 | OK | Standard success response. |
| 201 | Created | New resource created — usually paired with a `Location` header. |
| 202 | Accepted | Request accepted for processing, but not completed yet. |
| 203 | Non-Authoritative Information | Success, but the payload came from a proxy/cache, not the origin. |
| 204 | No Content | Success, nothing to return — common on `DELETE`. |
| 205 | Reset Content | Success, and the client should reset the view/form that submitted the request. |
| 206 | Partial Content | Range request fulfilled — how video/audio seeking and resumable downloads work. |
| 207 | Multi-Status | WebDAV — a single response bundling multiple status codes for sub-requests. |
| 208 | Already Reported | WebDAV — members already listed in a previous response, not repeated. |
| 226 | IM Used | Response is the result of one or more instance-manipulations applied to the resource. |
{: style="--table-col-1: 8%; --table-col-2: 32%; --table-col-3: 60%;"}

## 3xx – Redirection

| Code | Description | Notes |
|------|---------|-------|
| 300 | Multiple Choices | More than one possible response — rarely used in practice. |
| 301 | Moved Permanently | Redirect, cacheable. |
| 302 | Found | Redirect, not cacheable — the "temporary" one everyone still uses. |
| 303 | See Other | Redirect the client via `GET` to a different URI, typically after a `POST`. |
| 304 | Not Modified | Cached version is still valid — no body returned. |
| 305 | Use Proxy | Deprecated, and disabled by most browsers for security reasons. |
| 307 | Temporary Redirect | Like 302, but guarantees the method/body aren't changed on redirect. |
| 308 | Permanent Redirect | Like 301, but guarantees the method/body aren't changed on redirect. |
{: style="--table-col-1: 8%; --table-col-2: 32%; --table-col-3: 60%;"}

## 4xx – Client Error

| Code | Description | Notes |
|------|---------|-------|
| 400 | Bad Request | Malformed request, often the first sign a param is being parsed oddly. |
| 401 | Unauthorized | Missing/invalid auth — despite the name, this is about authentication. |
| 402 | Payment Required | Reserved for future use — occasionally repurposed by APIs for billing/quota errors. |
| 403 | Forbidden | Authenticated, but not allowed — this is the authorization one. |
| 404 | Not Found | Resource doesn't exist, or the server wants you to think it doesn't. |
| 405 | Method Not Allowed | The route exists, but not for this HTTP method. |
| 406 | Not Acceptable | Server can't produce a response matching the request's `Accept` headers. |
| 407 | Proxy Authentication Required | Like 401, but for a proxy in front of the server. |
| 408 | Request Timeout | Server gave up waiting for the request. |
| 409 | Conflict | Request conflicts with the current state of the resource. |
| 410 | Gone | Resource existed once, but is permanently gone — stronger signal than 404. |
| 411 | Length Required | Request needs a `Content-Length` header. |
| 412 | Precondition Failed | A conditional header (`If-Match`, etc.) didn't match. |
| 413 | Payload Too Large | Request body exceeds the server's limit. |
| 414 | URI Too Long | The URI itself is too long for the server to process. |
| 415 | Unsupported Media Type | `Content-Type` isn't one the server can handle. |
| 416 | Range Not Satisfiable | Requested byte range doesn't exist in the resource. |
| 417 | Expectation Failed | Server can't meet the requirement of an `Expect` request header. |
| 418 | I'm a Teapot | An April Fools' RFC joke (2324) that some frameworks implement anyway. |
| 421 | Misdirected Request | Request was routed to a server that can't produce a response for it. |
| 422 | Unprocessable Entity | Syntactically valid, but semantically wrong — common on API validation errors. |
| 423 | Locked | WebDAV — the resource being accessed is locked. |
| 424 | Failed Dependency | WebDAV — request failed because a previous, related request failed. |
| 425 | Too Early | Server is unwilling to process a request that might be replayed. |
| 426 | Upgrade Required | Server wants the client to switch protocols first (see `101`). |
| 428 | Precondition Required | Server requires the request to be conditional (avoids lost-update races). |
| 429 | Too Many Requests | Rate limited. |
| 431 | Request Header Fields Too Large | Headers, individually or combined, are too large. |
| 451 | Unavailable For Legal Reasons | Blocked due to a legal demand — the name is literal. |
{: style="--table-col-1: 8%; --table-col-2: 32%; --table-col-3: 60%;"}

## 5xx – Server Error

| Code | Description | Notes |
|------|---------|-------|
| 500 | Internal Server Error | Something broke server-side — often the most interesting one to see. |
| 501 | Not Implemented | Server doesn't support the functionality required for this request. |
| 502 | Bad Gateway | Upstream server gave an invalid response. |
| 503 | Service Unavailable | Server overloaded or down for maintenance. |
| 504 | Gateway Timeout | Upstream server didn't respond in time. |
| 505 | HTTP Version Not Supported | Server doesn't support the HTTP version used in the request. |
| 506 | Variant Also Negotiates | Server has an internal content-negotiation configuration error. |
| 507 | Insufficient Storage | WebDAV — server can't store the representation needed to complete the request. |
| 508 | Loop Detected | WebDAV — server detected an infinite loop while processing the request. |
| 510 | Not Extended | Further extensions to the request are required for the server to fulfill it. |
| 511 | Network Authentication Required | Client needs to authenticate to gain network access (captive portals). |
{: style="--table-col-1: 8%; --table-col-2: 32%; --table-col-3: 60%;"}

---

### Sources

- [MDN — HTTP response status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
- [IANA HTTP Status Code Registry](https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml)
- [Wikipedia — List of HTTP status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
