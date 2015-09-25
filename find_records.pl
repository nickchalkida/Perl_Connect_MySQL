#!\usr\bin\perl
############################################################
#   index.pl                                     Version 1.1
#   Copyright Intralot S.A.              All Rights Reserved
#   Nikolaos Kechris                  
############################################################

use CGI;
use DBI;
use strict;

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

my $sql_01 = "show tables from $database";
my $sth_01=$dbh->prepare($sql_01);
$sth_01->execute();

#$find_sql_query = "SELECT * FROM mathdb.$tablename";

print "Content-type:text/html\r\n\r\n";
print "<!DOCTYPE html>\n";

print "<html>\n";
print "<head>\n";
print "</head>\n";

print "<body style=\"background-color:yellow\">\n";

print "<div id=\"header\" style=\"background-color:#44FF55;text-align:center;\">\n";
print "<h1 style=\"margin-bottom:0;\">A Mathematics Database</h1>\n";
print "</div>\n";

print "<table width=\"100%\" style=\"height: 100%;\" cellpadding=\"10\" cellspacing=\"0\" border=\"0\">\n";
print "<tr>\n";

    print "<td id=\"menu\" width=\"100px\" valign=\"top\" bgcolor=\"#FFD700\">\n";
    print "</td>\n";

    print "<td id=\"content\" valign=\"top\" bgcolor=\"#EEEEEE\">\n";

    print "</td>\n";

print "</tr>\n";
print "</table>\n";

print "<div id=\"footer\" style=\"background-color:#FFA500;clear:both;text-align:center;\">\n";
print "Copyright © Intralot.com (Nikolaos L. Kechris)\n";
print "</div>\n";


print "</body>\n";
print "</html>\n";



