#!\usr\bin\perl
###########################################################
#   insert_record.pl                 Version 1.1
#   Copyright Intralot S.A.            All Rights Reserved
#   Nikolaos Kechris                  
###########################################################

use CGI;
use DBI;
use Time::Local;
use Time::Piece;

# CONFIG VARIABLES
my $platform  = "mysql";
my $database  = "mathdb";
my $host      = "localhost";
my $port      = "3306";
my $user      = "root";
my $pw        = "";

#DATA SOURCE NAME
my $dsn = "DBI:$platform:$database:localhost:3306";
# PERL DBI CONNECT
my $dbh = DBI->connect($dsn, $user, $pw);
unless( $dbh ){
    print "Unable to connect to database";
    exit;
}

my $buffer    = "";
my $pair      = "";
my $ENV       = "";

my @pairs     = ();
my $pair      = "";
my $name      = "";
my $value     = "";

# Parse the QUERY_STRING
# This code creates a hash called $in
# which can be accessed like: $topic = $in{'topic'};
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "POST") {
    read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
} else {
    $buffer = $ENV{'QUERY_STRING'};
}
# Split information into name/value pairs
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
    ($name, $value) = split(/=/, $pair);
    $value =~ tr/+/ /;
    $value =~ s/%0A//g;
    $value =~ s/%(..)/pack("C", hex($1))/eg;
    $in{$name} = $value;
}
my $tablename = $in{'tablename'};

$sql_01 = "show columns from $tablename from $database";
$sth_01=$dbh->prepare($sql_01);
$sth_01->execute();

############################################################

print "Content-type:text/html\r\n\r\n";
print "<!DOCTYPE html>\n";
print "<html>\n";
print "<head>\n";
print "</head>\n";

print "<body style=\"background-color:yellow\">\n";

print "<div id=\"header\" style=\"background-color:#FFA500;text-align:center;\">\n";
print "<h2 style=\"margin-bottom:0;\">Insert $tablename Record $in{'arid'} </h2>\n";
print "</div>\n";

print "<form action=\"commit_insert.pl\" method=\"post\">\n";
print "    <table width=\"100%\" style=\"height:100%;\" cellpadding=\"10\" cellspacing=\"0\" border=\"0\">\n";

$now_string = localtime;

while (@row = $sth_01->fetchrow_array) {
print "    <tr>\n";
print "        <td id=\"$row[0]\" width=\"100px\" align=\"right\" valign=\"top\" bgcolor=\"#FFD700\">\n";
print "        <font size=\"4\">$row[0]</font>\n";
print "        </td>\n";
print "        <td id=\"val$row[0]\" valign=\"top\" bgcolor=\"#EEEEEE\">\n";
my $tmpval = $row[1];
if ($row[1] eq "text") {
print "        <textarea cols=\"60\" rows=\"5\" name=\"$row[0]\"></textarea>\n"; 
} 
elsif ($row[1] eq "longtext"){
print "        <textarea cols=\"60\" rows=\"10\" name=\"$row[0]\"></textarea>\n"; 
} 
elsif ($row[1] eq "datetime"){
print "        <input type=\"text\" size=\"50\" name=\"$row[0]\" value=\"$now_string\">\n";
} 
else {
print "        <input type=\"text\" size=\"50\" name=\"$row[0]\" value=\"\">\n";
}
print "        </td>\n";
print "    </tr>\n";
}
print "    </table>\n";

# Make a small table for the insert button
print "    <table width=\"100%\" style=\"height:100%;\" cellpadding=\"10\" cellspacing=\"0\" border=\"0\">\n";
print "    <tr>\n";
print "        <td width=\"100px\" bgcolor=\"#FFD700\">\n";
print "        </td>\n";
print "        <td valign=\"center\" bgcolor=\"#EEEEEE\">\n";
print "        <input type=\"submit\" value=\"Insert Record\">\n";
print "        </td>\n";
print "    </tr>\n";
print "    </table>\n";

print "<input type=\"hidden\" name=\"arid\" value=\"$arid\" />";
print "<input type=\"hidden\" name=\"tablename\" value=\"$tablename\" />";

print "</form>\n";

print "<div id=\"footer\" style=\"background-color:#FFA500;clear:both;text-align:center;\">\n";
print "Copyright © Intralot.com (Nikolaos L. Kechris)\n";
print "</div>\n";

print "</body>\n";
print "</html>\n";


