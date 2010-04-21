<?php
require 'credentials.inc';
mysql_pconnect($db_host, $db_username, $db_password) or
      die('could not connect: ' . mysql_error());
mysql_select_db($db_dbname) or
      die('could not select database: ' . mysql_error());
mysql_query("set names 'utf8'") or
   die('could not query: ' . mysql_error());

$autoplay = false;
if (isset($_GET['autoplay']) && ($_GET['autoplay'] == 1)) $autoplay = true;

$page = isset($_GET['page'])? $_GET['page'] : '';
if ((!is_numeric($page)) || ($page < 1) || ($page > 604)) $page = '';
if (empty($page)) $page = 1;
$fn = sprintf('%03d', $page);
$next = ($page == 604)? 1 : ($page + 1);
$prev = ($page == 1)? 604 : ($page - 1);

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
print '<link rel="stylesheet" type="text/css" href="css/styles.css" />';
print '<map name="mushaf_page">';
print $map_elems;
print '</map>';

$mp3 = "http://everyayah.com/data/Husary_128kbps/PageMp3s/Page$fn.mp3";
$fn = "images/$fn.png";

$cmd = ($autoplay? 'stop' : 'play');
print <<<CONTROLS
   <div class="playdiv">
     <a href="index.php?page=$prev">prev</a> |
     <a href="index.php?page=$next">next</a>
     <div class="play_control">
        <a id="control" href="javascript:$cmd();">$cmd</a>
     </div>
   </div>
CONTROLS;

print '<img id="map" src="' . $fn . '" border="0" usemap="#mushaf_page">';
?>

<script type="text/javascript" 
        src="jquery-qtip/jquery-1.3.2.min.js"></script>
<script type="text/javascript" 
        src="jquery-qtip/jquery.qtip-1.0.0-rc3.min.js"></script>
<script type="text/javascript"
        src="soundmanager2/script/soundmanager2-nodebug-jsmin.js"></script>

<script type="text/javascript">
var current_mp3;
soundManager.url = 'soundmanager2/swf/';
soundManager.onload = function(){
   current_mp3 = soundManager.createSound({
      id: 'page_mp3',
      url: '<?php echo $mp3; ?>',
      onfinish: function(){ 
         location.href = 'index.php?page=<?php echo $next; ?>&autoplay=1';
      }
   });
<?php if ($autoplay){ echo "play();"; } ?>
}

function update_elem(cmd, text){
   elem = $("#control")[0];
   elem.href = 'javascript:' + text + '();';
   elem.innerHTML = text;
}

function play(){
   current_mp3.play();
   update_elem('stop', 'stop');
}

function stop(){
   current_mp3.pause();
   update_elem('resume', 'play');
}

function resume(){
   current_mp3.resume();
   update_elem('stop', 'stop');
}

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
