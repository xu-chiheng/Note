

v2.20.5    8b1a5f33d3ed427b0a6eaee595537805db6bc38c    2021-02-12
v2.24.4    06214d171b10e9474a0233dbc5187fd6b109ff2a    2021-02-12
v2.27.1    6ff7f460394745395f3eec1e414ad2300c6a402f    2021-02-12
patch_apply . ../_patch/git/backport-{a-2,b-1,c}.patch

v2.30.9    668f2d53613ac8fd373926ebe219f2c29112d93e    2023-04-14
v2.33.8    3a19048ce498d519bd564c9fd222161dca789321    2023-03-11
patch_apply . ../_patch/git/backport-{a-2,b,c}.patch

v2.35.8    7380a72f6b4da51f6db975f4a37c4ea9dadbf477    2023-03-11
patch_apply . ../_patch/git/backport-{a-1,b}.patch

v2.40.4    54a3711a9dd968a04249beef157393d64b579d64    2024-10-30
v2.46.4    47d3b506d48b7971080f09770f5b06b42569c967    2025-05-28
patch_apply . ../_patch/git/backport-{a,b}.patch


v2.48.2    fbae1f06cbb04a6592c32f465e9bc28149039358    2025-05-28
v2.51.2    bb5c624209fcaebd60b9572b2cc8c61086e39b57    2025-10-26






backport-a.patch
Fix the regression caused by commit 7d3d226e700904d6fbf3d9a1b351ebeb02f2cf04 2022-03-02, that build fails on Cygwin.
This patch is backported from commit 639cd8db63b07c958062bde4d3823dadbf469b0b 2024-11-17.
reflog.c:208:104: error: macro 'unreachable' passed 3 arguments, but takes just 0
  208 | static int unreachable(struct expire_reflog_policy_cb *cb, struct commit *commit, struct object_id *oid)
      |                                                                                                        ^
In file included from /usr/include/sys/unistd.h:14,
                 from /usr/include/unistd.h:4,
                 from git-compat-util.h:221,
                 from cache.h:4,
                 from reflog.c:1:
/cygdrive/d/_cygwin/gcc/lib/gcc/x86_64-pc-cygwin/16.0.0/include/stddef.h:468:9: note: macro 'unreachable' defined here
  468 | #define unreachable() (__builtin_unreachable ())



backport-b.patch
Fix the regression caused by commit b8a2486f1524947f232f657e9f2ebf44e3e7a243 2012-05-06, that build fails on Cygwin.
This patch is backported from commit e8b3bcf49120309b207b7afc25c4aa81b866ac45 2024-11-17.
builtin/index-pack.c:89:8: error: expected '{' before 'thread_local'
   89 | struct thread_local {
      |        ^~~~~~~~~~~~
builtin/index-pack.c:112:15: error: expected '{' before 'thread_local'
  112 | static struct thread_local nothread_data;
      |               ^~~~~~~~~~~~
builtin/index-pack.c:143:15: error: expected '{' before 'thread_local'
  143 | static struct thread_local *thread_data;
      |               ^~~~~~~~~~~~
In file included from ./builtin.h:4,
                 from builtin/index-pack.c:1:
builtin/index-pack.c: In function 'init_thread':
builtin/index-pack.c:189:22: error: 'thread_data' undeclared (first use in this function); did you mean 'pthread_detach'?
  189 |         CALLOC_ARRAY(thread_data, nr_threads);
      |                      ^~~~~~~~~~~
./git-compat-util.h:1107:33: note: in definition of macro 'CALLOC_ARRAY'
 1107 | #define CALLOC_ARRAY(x, alloc) (x) = xcalloc((alloc), sizeof(*(x)))
      |                                 ^
builtin/index-pack.c:189:22: note: each undeclared identifier is reported only once for each function it appears in
./git-compat-util.h:1107:33: note: in definition of macro 'CALLOC_ARRAY'
 1107 | #define CALLOC_ARRAY(x, alloc) (x) = xcalloc((alloc), sizeof(*(x)))
      |                                 ^
builtin/index-pack.c: In function 'cleanup_thread':
builtin/index-pack.c:209:23: error: 'thread_data' undeclared (first use in this function); did you mean 'pthread_detach'?
  209 |                 close(thread_data[i].pack_fd);
      |                       ^~~~~~~~~~~
      |                       pthread_detach
builtin/index-pack.c: In function 'open_pack_file':
builtin/index-pack.c:346:17: error: 'nothread_data' undeclared (first use in this function)
  346 |                 nothread_data.pack_fd = output_fd;
      |                 ^~~~~~~~~~~~~
builtin/index-pack.c: At top level:
builtin/index-pack.c:384:22: error: expected '{' before 'thread_local'
  384 | static inline struct thread_local *get_thread_data(void)
      |                      ^~~~~~~~~~~~
builtin/index-pack.c:395:36: error: expected '{' before 'thread_local'
  395 | static void set_thread_data(struct thread_local *data)
      |                                    ^~~~~~~~~~~~
builtin/index-pack.c:395:50: error: storage class specified for parameter 'data'
  395 | static void set_thread_data(struct thread_local *data)
      |                                                  ^~~~
builtin/index-pack.c: In function 'unpack_data':
builtin/index-pack.c:579:28: error: implicit declaration of function 'get_thread_data'; did you mean 'set_thread_data'? [-Wimplicit-function-declaration]
  579 |                 n = xpread(get_thread_data()->pack_fd, inbuf, n, from);
      |                            ^~~~~~~~~~~~~~~
      |                            set_thread_data
builtin/index-pack.c:579:45: error: invalid type argument of '->' (have 'int')
  579 |                 n = xpread(get_thread_data()->pack_fd, inbuf, n, from);
      |                                             ^~
builtin/index-pack.c: In function 'resolve_deltas':
builtin/index-pack.c:1246:51: error: 'thread_data' undeclared (first use in this function); did you mean 'set_thread_data'?
 1246 |                         int ret = pthread_create(&thread_data[i].thread, NULL,
      |                                                   ^~~~~~~~~~~
      |                                                   set_thread_data
builtin/index-pack.c:1257:31: error: 'nothread_data' undeclared (first use in this function); did you mean 'set_thread_data'?
 1257 |         threaded_second_pass(&nothread_data);
      |                               ^~~~~~~~~~~~~
      |                               set_thread_data
make: *** [Makefile:2719: builtin/index-pack.o] Error 1



backport-c.patch
Fix build on Cygwin, backported from unknown commit.
In file included from imap-send.c:34:
http.h:54:9: warning: 'CURLUSESSL_TRY' redefined
   54 | #define CURLUSESSL_TRY CURLFTPSSL_TRY
      |         ^~~~~~~~~~~~~~
In file included from http.h:6:
/usr/include/curl/curl.h:922:9: note: this is the location of the previous definition
  922 | #define CURLUSESSL_TRY     1L /* try using SSL, proceed anyway otherwise */
      |         ^~~~~~~~~~~~~~
In file included from http.c:2:
http.h:54:9: warning: 'CURLUSESSL_TRY' redefined
   54 | #define CURLUSESSL_TRY CURLFTPSSL_TRY
      |         ^~~~~~~~~~~~~~
In file included from http.h:6:
/usr/include/curl/curl.h:922:9: note: this is the location of the previous definition
  922 | #define CURLUSESSL_TRY     1L /* try using SSL, proceed anyway otherwise */
      |         ^~~~~~~~~~~~~~
imap-send.c: In function 'setup_curl':
http.h:54:24: error: 'CURLUSESSL_TRY' undeclared (first use in this function); did you mean 'CURLUSESSL_LAST'?
   54 | #define CURLUSESSL_TRY CURLFTPSSL_TRY
      |                        ^~~~~~~~~~~~~~
imap-send.c:1456:63: note: in expansion of macro 'CURLUSESSL_TRY'
 1456 |                 curl_easy_setopt(curl, CURLOPT_USE_SSL, (long)CURLUSESSL_TRY);
      |                                                               ^~~~~~~~~~~~~~
http.h:54:24: note: each undeclared identifier is reported only once for each function it appears in
imap-send.c:1456:63: note: in expansion of macro 'CURLUSESSL_TRY'
 1456 |                 curl_easy_setopt(curl, CURLOPT_USE_SSL, (long)CURLUSESSL_TRY);
      |                                                               ^~~~~~~~~~~~~~
In file included from http-walker.c:5:
http.h:54:9: warning: 'CURLUSESSL_TRY' redefined
   54 | #define CURLUSESSL_TRY CURLFTPSSL_TRY
      |         ^~~~~~~~~~~~~~
In file included from http.h:6:
/usr/include/curl/curl.h:922:9: note: this is the location of the previous definition
  922 | #define CURLUSESSL_TRY     1L /* try using SSL, proceed anyway otherwise */
      |         ^~~~~~~~~~~~~~
In file included from http-fetch.c:4:
http.h:54:9: warning: 'CURLUSESSL_TRY' redefined
   54 | #define CURLUSESSL_TRY CURLFTPSSL_TRY
      |         ^~~~~~~~~~~~~~
    CC version.o
In file included from http.h:6:
/usr/include/curl/curl.h:922:9: note: this is the location of the previous definition
  922 | #define CURLUSESSL_TRY     1L /* try using SSL, proceed anyway otherwise */
      |         ^~~~~~~~~~~~~~
http.c: In function 'get_curl_handle':
http.h:54:24: error: 'CURLUSESSL_TRY' undeclared (first use in this function); did you mean 'CURLUSESSL_LAST'?
   54 | #define CURLUSESSL_TRY CURLFTPSSL_TRY
      |                        ^~~~~~~~~~~~~~
http.c:1036:59: note: in expansion of macro 'CURLUSESSL_TRY'
 1036 |                 curl_easy_setopt(result, CURLOPT_USE_SSL, CURLUSESSL_TRY);
      |                                                           ^~~~~~~~~~~~~~
http.h:54:24: note: each undeclared identifier is reported only once for each function it appears in
http.c:1036:59: note: in expansion of macro 'CURLUSESSL_TRY'
 1036 |                 curl_easy_setopt(result, CURLOPT_USE_SSL, CURLUSESSL_TRY);
      |                                                           ^~~~~~~~~~~~~~
In file included from http-push.c:6:
http.h:54:9: warning: 'CURLUSESSL_TRY' redefined
   54 | #define CURLUSESSL_TRY CURLFTPSSL_TRY
      |         ^~~~~~~~~~~~~~
In file included from http.h:6:
/usr/include/curl/curl.h:922:9: note: this is the location of the previous definition
  922 | #define CURLUSESSL_TRY     1L /* try using SSL, proceed anyway otherwise */
      |         ^~~~~~~~~~~~~~
make: *** [Makefile:2505: imap-send.o] Error 1
make: *** Waiting for unfinished jobs....
In file included from remote-curl.c:7:
http.h:54:9: warning: 'CURLUSESSL_TRY' redefined
   54 | #define CURLUSESSL_TRY CURLFTPSSL_TRY
      |         ^~~~~~~~~~~~~~
In file included from http.h:6:
/usr/include/curl/curl.h:922:9: note: this is the location of the previous definition
  922 | #define CURLUSESSL_TRY     1L /* try using SSL, proceed anyway otherwise */
      |         ^~~~~~~~~~~~~~
make: *** [Makefile:2505: http.o] Error 1
In function 'probe_rpc',
    inlined from 'post_rpc' at remote-curl.c:914:10:
remote-curl.c:851:9: warning: call to 'Wcurl_easy_setopt_err_long' declared with attribute warning: curl_easy_setopt expects a long argument [-Wattribute-warning]
  851 |         curl_easy_setopt(slot->curl, CURLOPT_NOBODY, 0);
      |         ^~~~~~~~~~~~~~~~
remote-curl.c:852:9: warning: call to 'Wcurl_easy_setopt_err_long' declared with attribute warning: curl_easy_setopt expects a long argument [-Wattribute-warning]
  852 |         curl_easy_setopt(slot->curl, CURLOPT_POST, 1);
      |         ^~~~~~~~~~~~~~~~
remote-curl.c:856:9: warning: call to 'Wcurl_easy_setopt_err_long' declared with attribute warning: curl_easy_setopt expects a long argument [-Wattribute-warning]
  856 |         curl_easy_setopt(slot->curl, CURLOPT_POSTFIELDSIZE, 4);
      |         ^~~~~~~~~~~~~~~~
In function 'curl_setup_http_get',
    inlined from 'lock_remote.constprop' at http-push.c:865:3:
http-push.c:191:9: warning: call to 'Wcurl_easy_setopt_err_long' declared with attribute warning: curl_easy_setopt expects a long argument [-Wattribute-warning]
  191 |         curl_easy_setopt(curl, CURLOPT_HTTPGET, 1);
      |         ^~~~~~~~~~~~~~~~
In function 'curl_setup_http_get',
    inlined from 'refresh_lock' at http-push.c:457:2,
    inlined from 'check_locks' at http-push.c:487:9:
http-push.c:191:9: warning: call to 'Wcurl_easy_setopt_err_long' declared with attribute warning: curl_easy_setopt expects a long argument [-Wattribute-warning]
  191 |         curl_easy_setopt(curl, CURLOPT_HTTPGET, 1);
      |         ^~~~~~~~~~~~~~~~
In function 'curl_setup_http_get',
    inlined from 'unlock_remote.isra' at http-push.c:966:2:
http-push.c:191:9: warning: call to 'Wcurl_easy_setopt_err_long' declared with attribute warning: curl_easy_setopt expects a long argument [-Wattribute-warning]
  191 |         curl_easy_setopt(curl, CURLOPT_HTTPGET, 1);
      |         ^~~~~~~~~~~~~~~~
In function 'curl_setup_http_get',
    inlined from 'delete_remote_branch' at http-push.c:1668:2:
http-push.c:191:9: warning: call to 'Wcurl_easy_setopt_err_long' declared with attribute warning: curl_easy_setopt expects a long argument [-Wattribute-warning]
  191 |         curl_easy_setopt(curl, CURLOPT_HTTPGET, 1);
      |         ^~~~~~~~~~~~~~~~
In function 'curl_setup_http_get',
    inlined from 'start_mkcol' at http-push.c:291:2,
    inlined from 'fill_active_slot' at http-push.c:625:5,
    inlined from 'fill_active_slot' at http-push.c:610:12:
http-push.c:191:9: warning: call to 'Wcurl_easy_setopt_err_long' declared with attribute warning: curl_easy_setopt expects a long argument [-Wattribute-warning]
  191 |         curl_easy_setopt(curl, CURLOPT_HTTPGET, 1);
      |         ^~~~~~~~~~~~~~~~
In function 'curl_setup_http_get',
    inlined from 'start_move' at http-push.c:430:2,
    inlined from 'finish_request' at http-push.c:550:4,
    inlined from 'process_response' at http-push.c:249:2:
http-push.c:191:9: warning: call to 'Wcurl_easy_setopt_err_long' declared with attribute warning: curl_easy_setopt expects a long argument [-Wattribute-warning]
  191 |         curl_easy_setopt(curl, CURLOPT_HTTPGET, 1);


