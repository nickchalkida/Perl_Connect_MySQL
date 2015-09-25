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
#my $database  = "NMathDB";
my $host      = "localhost";
my $port      = "3306";
my $user      = "root";
my $pw        = "";
#my $pw        = "chalkida3,14";

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

print "<div id=\"header\" style=\"background-color:#FFA500;text-align:center;\">\n";
print "<h1 style=\"margin-bottom:0;\">A Mathematics Database</h1>\n";
print "</div>\n";

print "<table width=\"100%\" style=\"height: 100%;\" cellpadding=\"10\" cellspacing=\"0\" border=\"0\">\n";
print "<tr>\n";

    print "<td id=\"menu\" width=\"100px\" valign=\"top\" bgcolor=\"#FFD700\">\n";
    print "</td>\n";

    print "<td id=\"content\" valign=\"top\" bgcolor=\"#EEEEEE\">\n";

    while (my @row = $sth_01->fetchrow_array) {
        my $tablename = $row[0];
        print "<br>\n";
        print "<form action=\"records_summary.pl\" method=\"post\">\n";
        print "<div><input type=\"submit\" value=\"Get Records From $tablename\"></div>\n";
        print "<input type=\"hidden\" name=\"tablename\" value=\"$tablename\" />";
	print "<input type=\"hidden\" name=\"find_sql_query\" value=\"SELECT * FROM mathdb.$tablename\" />";
        print "</form>\n";
        print "<br>\n";
    } # end while
    
    print "</td>\n";

print "</tr>\n";
print "</table>\n";

print "<div id=\"footer\" style=\"background-color:#FFA500;clear:both;text-align:center;\">\n";
print "Copyright © Intralot.com (Nikolaos L. Kechris)\n";
print "</div>\n";


print "</body>\n";
print "</html>\n";



