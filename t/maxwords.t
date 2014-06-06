use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojolicious::Lite;

plugin 'TextHelpers';

get '/maxwords' => sub {
  my $self = shift;
  $self->render(text => $self->maxwords('a, b, c', 2));
};

get '/maxwords_with_omit_option' => sub {
  my $self = shift;
  $self->render(text => $self->maxwords('a, b, c', 2, ' [snip]'));
};

get '/maxwords_with_nothing_omited' => sub {
  my $self = shift;
  $self->render(text => $self->maxwords('a, b, c', 20));
};

get '/maxwords_with_negative_max' => sub {
  my $self = shift;
  $self->render(text => $self->maxwords('a, b, c', -2));
};

get '/maxwords_with_zero_max' => sub {
  my $self = shift;
  $self->render(text => $self->maxwords('a, b, c', 0));
};


my $t = Test::Mojo->new;
$t->get_ok('/maxwords')->status_is(200)->content_is('a, b...');
$t->get_ok('/maxwords_with_omit_option')->status_is(200)->content_is('a, b [snip]');
$t->get_ok('/maxwords_with_nothing_omited')->status_is(200)->content_is('a, b, c');
$t->get_ok('/maxwords_with_negative_max')->status_is(200)->content_is('a, b, c');
$t->get_ok('/maxwords_with_zero_max')->status_is(200)->content_is('a, b, c');

done_testing();