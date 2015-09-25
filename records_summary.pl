#!\usr\bin\perl
############################################################
#   records_summary.pl                           Version 1.1
#   Copyright Intralot S.A.              All Rights Reserved
#   Nikolaos Kechris                  
############################################################

use CGI;
use DBI;

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
my $sql = $in{'find_sql_query'};
my $sth=$dbh->prepare($sql);
$sth->execute();

############################################################

print "Content-type:text/html\r\n\r\n";
print "<!DOCTYPE html>\n";
print "<HTML>\n";
print "<HEAD>\n";
print "<TITLE>$tablename Records</TITLE>\n";

print "<script type=\"text/x-mathjax-config\">\n";
print  "MathJax.Hub.Config({tex2jax: {inlineMath: [['\$','\$'], ['\\\\(','\\\\)']]}})\n";
print "</script>\n";

print "<script type=\"text/javascript\" src=\"http\:\/\/cdn.mathjax.org\/mathjax\/latest\/MathJax.js\?config\=TeX-AMS_HTML-full\">\n";
print "</script>\n"; 

print "<script type=\"text/javascript\">\n";
print "    function function_mouseoverbutton(buttonname,id) {\n"; 
print "        document.getElementById(buttonname+id).src = \"IMAGES/\"+buttonname+\"_LI.png\";\n";
print "    }\n";
print "    function function_mouseoutbutton(buttonname,id) {\n"; 
print "        document.getElementById(buttonname+id).src = \"IMAGES/\"+buttonname+\"_UP.png\";\n";
print "    }\n";
print "    function function_clickbutton(buttonname,id) {\n";
print "        document.getElementById(buttonname+id).src = \"IMAGES/\"+buttonname+\"_DN.png\";\n";
print "        if (buttonname==\"back\") {\n";
print "        window.history.go(-1);\n";
print "        } else if (buttonname==\"home\") {\n";
print "        window.document.location = \"/index.pl\";\n";
print "        } else if (buttonname==\"search\") {\n";
print "        window.document.location = \"/find_records.pl?tablename=$tablename\";\n";
print "        }\n";    
print "    }\n";
print "</script>\n"; 
print "</HEAD>\n";

############################################################

print "<BODY style=\"background-color:green\">\n";

print "<div id=\"container\" style=\"background-color:#EEEEEE\">\n";

print "<div id=\"headerR\" style=\"background-color:#FFA500;\">\n";
print "<table width=\"100%\">\n";
print "<tr>\n";
print "<td width=\"200px\">\n";
print "<img id=\"back\" style=\"height:20px;width:20px;\" src=\"IMAGES/back_UP.png\" onmouseover=\"function_mouseoverbutton('back','$row[0]')\" onmouseout=\"function_mouseoutbutton('back','$row[0]')\" onclick=\"function_clickbutton('back','$row[0]')\">\n";
print "<img id=\"home\" style=\"height:20px;width:20px;\" src=\"IMAGES/home_UP.png\" onmouseover=\"function_mouseoverbutton('home','$row[0]')\" onmouseout=\"function_mouseoutbutton('home','$row[0]')\" onclick=\"function_clickbutton('home','$row[0]')\">\n";
print "<img id=\"search\" style=\"height:20px;width:20px;\" src=\"IMAGES/search_UP.png\" onmouseover=\"function_mouseoverbutton('search','$row[0]')\" onmouseout=\"function_mouseoutbutton('search','$row[0]')\" onclick=\"function_clickbutton('search','$row[0]')\">\n";
print "</td>\n";
print "<td style=\"text-align:center;\">\n";
print "<font size=\"6\">\n";
print "$tablename Records";
print "</font>\n";
print "</td>\n";
print "<td width=\"50px\">\n";
print "<form action=\"insert_record.pl\" method=\"get\"\ style=\"float:left;\">\n";
print "<input type=\"image\" id=\"insert$row[0]\" style=\"height:20px;width:20px;\" src=\"IMAGES/insert_UP.png\" onmouseover=\"function_mouseoverbutton('insert','$row[0]')\" onmouseout=\"function_mouseoutbutton('insert','$row[0]')\" onclick=\"function_clickbutton('insert','$row[0]')\">\n";
print "<input type=\"hidden\" name=\"tablename\" value=\"$tablename\" />";
print "</form>\n";
print "</td>\n";
print "</tr>\n";
print "</table>\n";
print "</div>\n";


print "<div id=\"content\" style=\"background-color:#EEEEEE;\">\n";

############################################################

    while (@row = $sth->fetchrow_array) {
    
    print "<div style=\"background-color:#cccccc;\">\n";
    print "<table>\n";
    print "<tr>\n";

    print "<td>\n";
    print "<form action=\"commit_delete.pl\" method=\"get\" style=\"float:left;\">\n";
    print "<input type=\"image\" id=\"delete$row[0]\" style=\"height:20px;width:20px;\" src=\"IMAGES/delete_UP.png\" onmouseover=\"function_mouseoverbutton('delete','$row[0]')\" onmouseout=\"function_mouseoutbutton('delete','$row[0]')\" onclick=\"function_clickbutton('delete','$row[0]')\">\n";
    print "<input type=\"hidden\" name=\"arid\" value=\"$row[0]\" />";
    print "<input type=\"hidden\" name=\"tablename\" value=\"$tablename\" />";
    print "</form>\n";
    print "</td>\n";

    print "<td>\n";
    print "<font size=\"5\" color=\"green\"> $tablename Record - $row[0]</font>\n"; 
    print "</td>\n";

    print "<td>\n";
    print "<form action=\"update_record.pl\" method=\"get\"\>\n";
    print "<input type=\"image\" id=\"update$row[0]\" style=\"height:20px;width:20px;\" src=\"IMAGES/update_UP.png\" onmouseover=\"function_mouseoverbutton('update','$row[0]')\" onmouseout=\"function_mouseoutbutton('update','$row[0]')\" onclick=\"function_clickbutton('update','$row[0]')\">\n";
    print "<input type=\"hidden\" name=\"arid\" value=\"$row[0]\" />";
    print "<input type=\"hidden\" name=\"tablename\" value=\"$tablename\" />";
    print "</form>\n";
    print "</td>\n";

    print "<td>\n";
    print "<form action=\"view_record.pl\" method=\"get\"\>\n";
    print "<input type=\"image\" id=\"view$row[0]\" style=\"height:20px;width:20px;\" src=\"IMAGES/view_UP.png\" onmouseover=\"function_mouseoverbutton('view','$row[0]')\" onmouseout=\"function_mouseoutbutton('view','$row[0]')\" onclick=\"function_clickbutton('view','$row[0]')\">\n";
    print "<input type=\"hidden\" name=\"arid\" value=\"$row[0]\" />";
    print "<input type=\"hidden\" name=\"tablename\" value=\"$tablename\" />";
    print "</form>\n";
    print "</td>\n";

    print "</tr>\n";
    print "</table>\n";
    print "</div>\n";

    print "<div style=\"background-color:#DDDDDD\">\n";
    print $row[1];
    print "<br>\n";
    print "</div>\n";
    }


############################################################

print "</div>\n";

print "<div id=\"footer\" style=\"background-color:#FFA500;clear:both;text-align:center;\">\n";
print "Copyright © Intralot.com (Nikolaos L. Kechris) </div>\n";
print "</div>\n";

print "</BODY>\n";
print "</HTML>\n";



