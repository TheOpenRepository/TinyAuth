#!/usr/bin/perl

use strict;
use vars qw{$VERSION};
BEGIN {
	$|       = 1;
	$^W      = 1;
	$VERSION = '0.06';
}

use Test::More tests => 14;

use File::Spec::Functions ':ALL';
use YAML::Tiny;
use Email::Send::Test;
use t::lib::Test;
use t::lib::TinyAuth;

# Test files
my $cgi_file1 = rel2abs( catfile( 't', 'data', '05_change1.cgi'  ) );
my $cgi_file2 = rel2abs( catfile( 't', 'data', '05_change2.cgi'  ) );
ok( -f $cgi_file1, 'Testing cgi file exists' );
ok( -f $cgi_file2, 'Testing cgi file exists' );





#####################################################################
# Show the "I forgot my password" form

SCOPE: {
	open( CGIFILE, $cgi_file1 ) or die "open: $!";
	my $cgi = CGI->new(\*CGIFILE);
	close( CGIFILE );

	# Create the object
	my $instance = t::lib::TinyAuth->new(
		config => default_config(),
		cgi    => $cgi,
	);
	isa_ok( $instance, 't::lib::TinyAuth' );
	isa_ok( $instance, 'TinyAuth' );

	# Run the instance
	is( $instance->run, 1, '->run ok' );

	# Check the output
	cgi_cmp( $instance->stdout, <<"END_HTML", '->stdout returns as expect' );
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>TinyAuth $VERSION</title>
</head>

<body>
<h2>You want to change your password</h2>
<p>I just need to know a few things to do that</p>
<form method="post" name="f">
<input type="hidden" name="a" value="p">
<table border="0" cellpadding="0" cellspacing="0">
<tr><td>
<p>What is your email address?</p>
<p>What is your current password?</p>
<p>Type in the new password you want&nbsp;&nbsp;</p>
<p>Type it again to prevent mistakes</p>
</td><td>
<p><input type="text" name="e" size="30"></p>
<p><input type="text" name"p" size="30"></p>
<p><input type="text" name"n" size="30"></p>
<p><input type="text" name"c" size="30"></p>
</td></tr>
</table>
<p>Hit the button when you are ready to go <input type="submit" name="s" value="Change my password"></p>
</form>
<hr>
<p><a href="?a=i">Back to the main page</a></p>

<script language="JavaScript">
document.f.e.focus();
</script>
</body>
</html>

END_HTML
}





#####################################################################
# Request a bad password

SCOPE: {
	open( CGIFILE, $cgi_file2 ) or die "open: $!";
	my $cgi = CGI->new(\*CGIFILE);
	close( CGIFILE );

	# Create the object
	my $instance = t::lib::TinyAuth->new(
		config => default_config(),
		cgi    => $cgi,
	);
	isa_ok( $instance, 't::lib::TinyAuth' );
	isa_ok( $instance, 'TinyAuth' );

	# Set the password to what we want
	$instance->auth->lookup_user('adamk@cpan.org')->set(password => 'foo');

	# Run the instance
	is( $instance->run, 1, '->run ok' );

	# Check the output
	cgi_cmp( $instance->stdout, <<"END_HTML", '->stdout returns as expect' );
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>TinyAuth $VERSION</title>
</head>

<body>
<h1>Action Completed</h1>
<h2>Your password has been changed</h2>
</body>
</html>

END_HTML
}