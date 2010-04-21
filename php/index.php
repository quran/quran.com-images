<?php
require 'credentials.inc';
mysql_pconnect($db_host, $db_username, $db_password) or
   die('could not connect: ' . mysql_error());
mysql_select_db($db_dbname) or
   die('could not select database: ' . mysql_error());
mysql_query("set names 'utf8'") or
   die('could not query: ' . mysql_error());

$page = isset($_GET['page'])? $_GET['page'] : '';
if ((!is_numeric($page)) || ($page < 1) || ($page > 604)) $page = '';
if (empty($page)) $page = 1;
$fn = ($page < 100)? (($page < 10)? "00$page" : "0$page") : $page;

$lookup = array();
$q = "select word, minx, maxx, miny, maxy from bounds where page=$page";
$res = mysql_query($q) or die('could not query: ' . mysql_error());
while ($row = mysql_fetch_assoc($res)){
   $lookup[$row['word']] = $row;
}

$map_elems = '';
$q = 'select corpus_id, sura, ayah, word, qc_code from corpus_mappings ' .
   "where page = $page";
$res = mysql_query($q) or die('could not query: ' . mysql_error());
while ($row = mysql_fetch_assoc($res)){
   $code = $row['qc_code'];
   $words = explode('+', $code);
   $coords = get_coord_str($words, $lookup);
   if (empty($coords)) continue;
   $map_elems .= '<area shape="rect" corpus_id="' . $row['corpus_id'] .
      '" coords="' . $coords . '" href="' .
      "http://corpus.quran.com/wordmorphology.jsp?location=(" .
      $row['sura'] . ':' . $row['ayah'] . ':' . $row['word'] . ')">' . "\n";
}
print "<title>quran - $fn</title>";
print '<map name="mushaf_page">';
print $map_elems;
print '</map>';

$fn = "images/$fn.png";
print '<img id="map" src="' . $fn . '" border="0" usemap="#mushaf_page">';
?>

<script type="text/javascript" 
        src="jquery-qtip/jquery-1.3.2.min.js"></script>
<script type="text/javascript" 
        src="jquery-qtip/jquery.qtip-1.0.0-rc3.min.js"></script>

<script type="text/javascript">
// Create the tooltips only when document ready
$(document).ready(function(){
   // Use the each() method to gain access to each elements attributes
   $('area').each(function(){
      $(this).qtip({
         content: '<img src="http://corpus.quran.com/wordimage?id=' + 
                  $(this).attr('corpus_id') + '">', 
         style: {
            name: 'light', // Give it the preset dark style
            border: {
               width: 0, 
               radius: 4 
            }, 
            tip: true // Apply a tip at the default tooltip corner
         }
      });
   });
});
</script>

<?php
function get_coord_str($words, $lookup){
   // returns ul_x,ul_y,lr_x,lr_y
   if (count($words)==1){
      if (!isset($lookup[$words[0]]))
         return "";
      $ref = $lookup[$words[0]];
      return $ref['minx'] . ',' . $ref['miny'] . ',' . $ref['maxx'] . ',' .
         $ref['maxy'];
   }
   else {
      $first = $words[0];
      $last = $words[count($words)-1];
      if ((!isset($lookup[$first])) || (!isset($lookup[$last]))) return "";
      $ref_f = $lookup[$first];
      $ref_l = $lookup[$last];
      if (($ref_f['miny'] == $ref_l['miny']) &&
         ($ref_f['maxy'] == $ref_l['maxy'])){
            // same line, so we can handle it.
         $minx = min($ref_f['minx'], $ref_l['minx']);
         $maxx = max($ref_f['maxx'], $ref_l['maxx']);
         return "$minx,{$ref_f['miny']},$maxx,{$ref_l['maxy']}";
      }
      else return "";  // i don't think this will happen, but just in case
   }
}
