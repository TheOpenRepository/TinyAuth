#!/usr/bin/perl

use strict;
use vars qw{$VERSION};
BEGIN {
	$|       = 1;
	$^W      = 1;
	$VERSION = '0.07';
}

use Test::More tests => 7;

use File::Spec::Functions ':ALL';
use YAML::Tiny;
use t::lib::Test;
use t::lib::TinyAuth;





#####################################################################
# Normal Index Page

SCOPE: {
	my $instance = t::lib::TinyAuth->new( "02_login1.cgi" );

	# Run the instance
	is( $instance->run, 1, '->run ok' );

	# Check the output
	cgi_cmp( $instance->stdout, <<"END_HTML", '->stdout returns as expect' );
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>TinyAuth 0.07</title>
</head>

<body>
<h2>User</h2>
<p><a href="?a=f">I forgot my password</a></p>
<p><a href="?a=c">I want to change my password</a></p>
<h2>Admin</h2>
<form method="post" name="f" action="">
<p><input type="text" name="_e" size="30"> Email</p>
<p><input type="text" name="_p" size="30"> Password</p>
<p><input type="submit" name="s" value="Login"></p>
</form>
<hr>
<p><i>Powered by <a href="http://search.cpan.org/perldoc?TinyAuth">TinyAuth</a></i></p>
</body>
</html>
END_HTML
}





#####################################################################
# Login

SCOPE: {
	my $instance = t::lib::TinyAuth->new( "02_login2.cgi" );

	# Was an admin user found and set?
	ok( $instance->admin, 'Admin user set' );
	isa_ok( $instance->admin, 'Authen::Htpasswd::User' );

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
<h2>User</h2>
<p><a href="?a=f">I forgot my password</a></p>
<p><a href="?a=c">I want to change my password</a></p>
<h2>Admin</h2>
<p><a href="?a=n">I want to add a new account</a></p>
<p><a href="?a=l">I want to see all the accounts</a></p>
<p><a href="?a=d">I want to delete an account</a></p>
<p><a href="?a=m">I want to promote an account to admin</a></p>
<hr>
<p><i>Powered by <a href="http://search.cpan.org/perldoc?TinyAuth">TinyAuth</a></i></p>
</body>
</html>

END_HTML
}





#####################################################################
# Logout

SCOPE: {
	my $instance = t::lib::TinyAuth->new( "02_login3.cgi" );

	# Was an admin user found and set?
	# (This time via the cookies)
	ok( $instance->admin, 'Admin user set' );
	isa_ok( $instance->admin, 'Authen::Htpasswd::User' );

	# Run the instance
	is( $instance->run, 1, '->run ok' );

	# Check the output
	cgi_cmp( $instance->stdout, <<"END_HTML", '->stdout returns as expect' );
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>TinyAuth 0.07</title>
</head>

<body>
<h2>User</h2>
<p><a href="?a=f">I forgot my password</a></p>
<p><a href="?a=c">I want to change my password</a></p>
<h2>Admin</h2>
<form method="post" name="f" action="">
<p><input type="text" name="_e" size="30"> Email</p>
<p><input type="text" name="_p" size="30"> Password</p>
<p><input type="submit" name="s" value="Login"></p>
</form>
<hr>
<p><i>Powered by <a href="http://search.cpan.org/perldoc?TinyAuth">TinyAuth</a></i></p>
</body>
</html>
END_HTML
}