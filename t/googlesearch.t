use lib 't', 'lib';
use strict;
use warnings;
use Test::More tests => 2;
use Kwiki;

BEGIN {
    use_ok 'Kwiki::SOAP::Google';
}

SKIP: {
    skip "templates make tests hard", 1;
    my $content =<<"EOF";
=== Hello

{googlesoap chris dent}

EOF

    my $kwiki = Kwiki->new;
    my $hub = $kwiki->load_hub({plugin_classes => ['Kwiki::SOAP::Google']});
    my $registry = $hub->load_class('registry');
    $registry->update();
    $hub->load_registry();
    my $formatter = $hub->load_class('formatter');

    my $output = $formatter->text_to_html($content);
    like($output, qr/Glacial Erratics/, 'content looks okay');
}
