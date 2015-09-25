#!\usr\bin\perl
############################################################
#   update_record.pl                             Version 1.1
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

$sql_02 = "select * FROM mathdb.$tablename where id=$in{'arid'}";
$sth_02=$dbh->prepare($sql_02);
$sth_02->execute();

@ar_rec = $sth_02->fetchrow_array;

print "Content-type:text/html\r\n\r\n";
print "<!DOCTYPE html>\n";
print "<html>\n";
print "<head>\n";

print "<script type=\"text/x-mathjax-config\">\n";
print  "MathJax.Hub.Config({tex2jax: {inlineMath: [['\$','\$'], ['\\\\(','\\\\)']]}})\n";

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

print "<script type=\"text/javascript\" src=\"http\:\/\/cdn.mathjax.org\/mathjax\/latest\/MathJax.js\?config\=TeX-AMS_HTML-full\">\n";
print "</script>\n"; 

print "</head>\n";

print "<body style=\"background-color:yellow\">\n";

#print "<div id=\"header\" style=\"background-color:#FFA500;text-align:center;\">\n";
#print "<h2 style=\"margin-bottom:0;\">View Record $in{'arid'} </h2>\n";
#print "</div>\n";

# Output first Line
print "<div id=\"headerR\" style=\"background-color:#FFA500;\">\n";
print "<table width=\"100%\">\n";
print "<tr>\n";
print "<td width=\"200px\">\n";
print "<img id=\"back\" style=\"height:20px;width:20px;\" src=\"IMAGES/back_UP.png\" onmouseover=\"function_mouseoverbutton('back','$row[0]')\" onmouseout=\"function_mouseoutbutton('back','$row[0]')\" onclick=\"function_clickbutton('back','$row[0]')\">\n";
print "<img id=\"home\" style=\"height:20px;width:20px;\" src=\"IMAGES/home_UP.png\" onmouseover=\"function_mouseoverbutton('home','$row[0]')\" onmouseout=\"function_mouseoutbutton('home','$row[0]')\" onclick=\"function_clickbutton('home','$row[0]')\">\n";
print "</td>\n";
print "<td style=\"text-align:center;\">\n";
print "<font size=\"6\">\n";
print "View Record $in{'arid'} \n";
print "</font>\n";
print "</td>\n";
print "</tr>\n";
print "</table>\n";
print "</div>\n";



print "<table width=\"100%\" style=\"height:100%;\" cellpadding=\"10\" cellspacing=\"0\" border=\"0\">\n";
    $ind = 0;
    while (@row = $sth_01->fetchrow_array) {
    print "<tr>\n";

    print "<td id=\"$row[0]\" width=\"100px\" align=\"right\" valign=\"top\" bgcolor=\"#FFD700\">\n";
    print "<font size=\"4\">$row[0]</font>\n";
    print "</td>\n";

    print "<td id=\"val$row[0]\" valign=\"top\" bgcolor=\"#EEEEEE\">\n";
    print "$ar_rec[$ind]\n";
    print "</td>\n";

    print "</tr>\n";
    $ind++;
    }
print "</table>\n";


print "<div id=\"footer\" style=\"background-color:#FFA500;clear:both;text-align:center;\">\n";
print "Copyright © Intralot.com (Nikolaos L. Kechris)\n";
print "</div>\n";

print "</body>\n";
print "</html>\n";


