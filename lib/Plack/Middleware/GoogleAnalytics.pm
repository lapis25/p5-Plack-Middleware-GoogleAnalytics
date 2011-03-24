package Plack::Middleware::GoogleAnalytics;
use strict;
use warnings;
our $VERSION = '0.01';

use parent qw( Plack::Middleware );
use Plack::Util;
use Plack::Util::Accessor qw( web_propaty_id );

sub call {
    my $self = shift;

    my $res = $self->app->(@_);
    $self->response_cb($res, sub {
        my $res = shift;
        my $h = Plack::Util::headers($res->[1]);
        my $content = $self->tracking_code;

        if ($h->get('Content-Type') eq 'text/html') {
            return sub {
                my $chunk = shift;
                return unless defined $chunk;
                $chunk =~ s!(?=</body>)!$content!i;
                $h->set('Content-Length' => length($chunk));
                return $chunk;
            };
        }
        $res;
    });
}

sub tracking_code {
    my $self = shift;
    my $web_propaty_id = $self->web_propaty_id;
    my $content =<<"SCRIPT";
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl."
: "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost +
"google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("$web_propaty_id");
pageTracker._trackPageview();
} catch(err) {}</script>
SCRIPT
}

1;
__END__

=head1 NAME

Plack::Middleware::GoogleAnalytics - embed Google Analytics tracking code.

=head1 SYNOPSIS

  enable 'GoogleAnalytics', web_propaty_id => 'UA-00000-1';

=head1 DESCRIPTION

To enable the middleware, just use L<Plack::Builder> as usual in your C<.psgi>
file:

  use Plack::Builder;

  builder {
      enable 'GoogleAnalytics', web_propaty_id => 'UA-00000-1';
      $app;
  };

=head1 AUTHOR

lapis25 E<lt>lapis25@gmail.comE<gt>

=head1 SEE ALSO

L<Plack::Middleware> L<Plack::Builder>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
