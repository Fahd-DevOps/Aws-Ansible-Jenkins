#!/usr/bin/perl

use strict;
use warnings;

sub validate_email {
    my ($email) = @_;

    # Regular expression to validate email address
    if ($email =~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/) {
        return 1; # Valid email
    } else {
        return 0; # Invalid email
    }
}

# Main code
print "Enter your email address: ";
my $user_email = <STDIN>;
chomp $user_email;

# Validate email address
if (validate_email($user_email)) {
    print "Email address is valid.\n";
} else {
    print "Invalid email address.\n";
}
