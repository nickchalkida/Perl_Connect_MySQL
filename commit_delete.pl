#!\usr\bin\perl
############################################################
#   commit_delete.pl                             Version 1.1
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


$sql_01 = "show columns from $tablename from $database";
$sth_01=$dbh->prepare($sql_01);
$sth_01->execute();

$sql_to_commit = "DELETE FROM $tablename WHERE id = $in{'arid'}";

$sth_to_commit=$dbh->prepare($sql_to_commit);
$sth_to_commit->execute();
$result = $sth_to_commit->errstr;
if ($result eq "") {
    $result = "Success";
}
$sth_to_commit->finish();
$dbh->do("commit") or die "DBI::errstr";

print "Content-type:text/html\r\n\r\n";

print "<!DOCTYPE html>\n";
print "<HTML>\n";
print "<HEAD>\n";
print "<TITLE>Delete Record</TITLE>\n";

print "<script type=\"text/x-mathjax-config\">\n";
print "MathJax.Hub.Config({tex2jax: {inlineMath: [['\$','\$'], ['\\\\(','\\\\)']]}})\n";
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
print "        window.document.location = \"/records_summary.pl\";\n";
print "        }\n";       
print "    }\n";
print "</script>\n"; 

print "</HEAD>\n";

print "<BODY>\n";
print "<div id=\"container\" style=\"background-color:#EEEEEE\">\n";

print "<div id=\"headerR\" style=\"background-color:#FFA500;\">\n";
print "<table width=\"100%\">\n";
print "    <tr>\n";
print "    <td width=\"50px\">\n";
print "    </td>\n";
print "    <td width=\"100px\">\n";
print "    <img id=\"back\" style=\"height:20px;width:20px;\" src=\"IMAGES/back_UP.png\" onmouseover=\"function_mouseoverbutton('back','$row[0]')\" onmouseout=\"function_mouseoutbutton('back','$row[0]')\" onclick=\"function_clickbutton('back','$row[0]')\">\n";
print "    </td>\n";
print "    <td style=\"text-align:center;\">\n";
print "    <font size=\"6\">Table Delete</font>\n";
print "    </td>\n";
print "    </tr>\n";
print "</table>\n";
print "</div>\n";

print "<div id=\"content\" style=\"background-color:#EEEEEE;\">\n";
print "Delete Result: $result\n";
print "</div>\n";

print "<div id=\"footer\" style=\"background-color:#FFA500;clear:both;text-align:center;\">\n";
print "Copyright © Intralot.com (Nikolaos L. Kechris) </div>\n";
print "</div>\n";

print "</BODY>\n";
print "</HTML>\n";



