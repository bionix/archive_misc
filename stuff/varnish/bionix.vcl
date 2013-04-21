backend default {
    .host = "127.0.0.1";
    .port = "8888";
}

acl purge {
    "127.0.0.1";
    "localhost";
}

sub vcl_recv {
	remove req.http.X-Forwarded-For;
set    req.http.X-Forwarded-For = client.ip;

remove req.http.X-Powered-By;

if (req.request == "POST") {
      return (pass);
  }

if ( req.http.host == "ipv4.EXAMPLE.ORG" ) {
    return( pass );
}
if ( req.http.host == "ipv6.EXAMPLE.ORG" ) {
    return( pass );
}

   if (req.request == "PURGE") {
     if (!client.ip ~ purge) {
       error 405 "Not allowed.";
     }
     return(lookup);
   }

  if (req.http.Accept-Encoding) {
#revisit this list
    if (req.url ~ "\.(gif|jpg|jpeg|swf|flv|mp3|mp4|pdf|ico|png|gz|tgz|bz2)(\?.*|)$") {
      remove req.http.Accept-Encoding;
    } elsif (req.http.Accept-Encoding ~ "gzip") {
      set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
      set req.http.Accept-Encoding = "deflate";
    } else {
      remove req.http.Accept-Encoding;
    }
  }
  if (req.url ~ "\.(gif|jpg|jpeg|swf|css|js|flv|mp3|mp4|pdf|ico|png)(\?.*|)$") {
    unset req.http.cookie;
    set req.url = regsub(req.url, "\?.*$", "");
  }
  if (req.url ~ "\?(utm_(campaign|medium|source|term)|adParams|client|cx|eid|fbid|feed|ref(id|src)?|v(er|iew))=") {
    set req.url = regsub(req.url, "\?.*$", "");
  }
  if (req.http.cookie) {
    if (req.http.cookie ~ "(wordpress_|wp-settings-)") {
      return(pass);
    } else {
      unset req.http.cookie;
    }
  }
}

sub vcl_fetch {
  if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true" || req.url ~ "xmlrpc.php") {
    return (hit_for_pass);
  }
  if ( (!(req.url ~ "(wp-(login|admin)|login)")) || (req.request == "GET") ) {
    unset beresp.http.set-cookie;
   set beresp.ttl = 1h;
  }
  if (req.url ~ "\.(gif|jpg|jpeg|swf|css|js|flv|mp3|mp4|pdf|ico|png)(\?.*|)$") {
    set beresp.ttl = 365d;
  }
    unset beresp.http.Server;
    unset beresp.http.X-Powered-By;
}

sub vcl_deliver {


    unset resp.http.Via;
    unset resp.http.X-Varnish;

# multi-server webfarm? set a variable here so you can check
# the headers to see which frontend served the request
#   set resp.http.X-Server = "server-01";
   if (obj.hits > 0) {
     set resp.http.X-Cache = "HIT";
   } else {
     set resp.http.X-Cache = "MISS";
   }
}
sub vcl_hit {
  if (req.request == "PURGE") {
    set obj.ttl = 0s;
    error 200 "OK";
  }
}

sub vcl_miss {
  if (req.request == "PURGE") {
    error 404 "Not cached";
  }
}
