#! /usr/bin/env perl6

use v6.c;

use Test;
use IP::Addr;

plan 10;

my $ip = IP::Addr.new( "2001::da:beef" );

is $ip.handler.WHO, "IP::Addr::v6", "handler class";

is ~$ip, "2001::da:beef", "stringification";
is "IP inline: $ip", "IP inline: 2001::da:beef";

$ip = IP::Addr.new( "2002::da:beef/33" );

is $ip.network, "2002::/33", "network";

is $ip, "2002::da:beef/33", "before increment";

$ip++;

is ~$ip, "2002::da:bef0/33", "after increment";

my $ip2 = $ip.first;

is ~$ip2, "2002::da:bef0/33", "first for single IP is the IP itself";

$ip2 = $ip2.next;

is ~$ip2, "2002::da:bef1/33", "next IP";

$ip2 = $ip2.prev;

is ~$ip2, "2002::da:bef0/33", "prev IP";

# Narrow the CIDR or test would take forever to complete
$ip = IP::Addr.new( "2003::da:beef/122" );
my @ips;
for $ip.first.each -> $i {
    push @ips, ~$i;
}

my @expect = (0xef..0xff).map( { "2003::da:be{$_.fmt("%x")}/122" } );

is-deeply @ips, @expect, "iterator";

done-testing;
# vim: ft=perl6 et sw=4