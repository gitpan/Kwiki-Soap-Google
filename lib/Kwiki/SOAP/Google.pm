package Kwiki::SOAP::Google;
use strict;
use warnings;
use Kwiki::SOAP '-Base';
use Kwiki::Installer '-base';

# Enter your google key here
# Go to http://api.google.com/ to get yours
const key => '';
# XXX at least some of this should come from preferences
const wsdl => 'http://api.google.com/GoogleSearch.wsdl';
const method => 'doGoogleSearch';
const limit => 10;

our $VERSION = 0.01;

const class_title => 'google soap retrieval';
const class_id => 'googlesoap';
const css_file => 'googlesoap.css';

sub register {
    my $registry = shift;
    $registry->add(wafl => googlesoap => 'Kwiki::SOAP::Google::Wafl');
}

package Kwiki::SOAP::Google::Wafl;
use base 'Kwiki::SOAP::Wafl';

sub html {
    my $query = $self->arguments;
    return $self->wafl_error
        unless ($query && $self->googlesoap->key);

    $self->use_class('googlesoap');

    my $result = $self->soap(
        $self->googlesoap->wsdl,
        $self->googlesoap->method,
        [
        $self->googlesoap->key,
        $query,
        0,
        $self->googlesoap->limit,
        0, '', 0, '', 'latin1', 'latin1'
        ]
    );

    return $self->pretty($result);
}

sub pretty {
    my $result = shift;

    my $results = shift;

    $self->hub->template->process('google_soap.html',
        soap_class  => $self->googlesoap->class_id,
        google_elements => $result->{resultElements},
    );
}

package Kwiki::SOAP::Google;
1;

__DATA__

=head1 NAME 

Kwiki::SOAP::Google - Experiment with SOAP request to Google through wafl.

=head1 SYNOPSIS

  {googlesoap my search terms}

=head1 DESCRIPTION

This is a WAFL phrase for Kwiki that allows searches of google
through their SOAP API. You must have your own Google API key
to use it. If you do not have one you can get one from Google:

  http://www.google.com/apis/

After installation you must edit the Kwiki::SOAP::Google file
to add your key (this will be improved at a later time).

=head1 AUTHORS

Chris Dent

=head1 SEE ALSO

L<Kwiki>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Chris Dent

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__css/googlesoap.css__
div.googlesoap { background: #dddddd; font-family: sans-serif;}
.googlesoap dd { font-size: x-small; }
.googlesoap dt { font-size: small;
__template/tt2/google_soap.html__
<!-- BEGIN google_soap.html -->
<div class="[% soap_class %]">
<dl>
[% FOREACH google_result = google_elements %]
<dt><a href='[% google_result.URL %]' title='[% google_result.title %]'>
[% google_result.title %]
</a>
</dt>
<dd>[% google_result.snippet %]</dd>
[% END %]
</dl>
<!-- END google_soap.html -->
