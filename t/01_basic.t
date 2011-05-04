#!/usr/bin/env perl
use warnings;
use strict;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;
use Test::More;

my @content_types = ('text/html',);

for my $content_type (@content_types) {
    note "Content-Type: $content_type";
    my $app = sub {
        return [
            200,
            [ 'Content-Type' => $content_type ],
            [ '<html><body>hello world</body></html>' ]
        ];
    };

    $app = builder {
        enable 'GoogleAnalytics', web_propaty_id => 'UA-00000-1';
        $app;
    };
    test_psgi $app, sub {
        my $cb = shift;
        my $res = $cb->(GET '/');
        is $res->code, 200, 'response status 200';
        is $res->header('Content-Length'), 441;
        like $res->content,
             qr/var pageTracker = _gat._getTracker\("UA-00000-1"\)/,
             "Google Analytics Web Propaty ID: UA-00000-1";
    };
}
done_testing;
