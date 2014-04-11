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
$next = ($page == 604)? 1 : ($page + 1);
$prev = ($page == 1)? 604 : ($page - 1);

$width = isset($_GET['width'])? $_GET['width'] : '';
if ((!is_numeric($width)) || ($width < 480) || ($width > 1920)) $width = '';
if (empty($width)) $width = 1024;

$lookup = array();
$q = "select g.glyph_code, gplb.min_x, gplb.max_x, gplb.min_y, gplb.max_y
        from glyph g, glyph_page_line gpl, glyph_page_line_bbox gplb
        where g.glyph_id = gpl.glyph_id
          and gpl.glyph_page_line_id = gplb.glyph_page_line_id
          and gpl.page_number = $page
          and gplb.img_width = $width";
$res = mysql_query($q) or die('could not query: ' . mysql_error());
while ($row = mysql_fetch_assoc($res)){
   $lookup[$row['glyph_code']] = $row;
}

$language_code = 'en'; # TODO: hack

$map_elems = array();
$words = array();
$q = "select w.word_id, w.sura_number, w.ayah_number, w.position, g.glyph_code,
             wa.value as arabic, wr.value as root, ws.value as stem,
             wl.value as lemma, wt.value as translation
        from glyph g, word w
        left join word_arabic wa on w.word_arabic_id = wa.word_arabic_id
        left join word_root wr on w.word_root_id = wr.word_root_id
        left join word_stem ws on w.word_stem_id = ws.word_stem_id
        left join word_lemma wl on w.word_lemma_id = wl.word_lemma_id
        left join (word_translation wt join language l on
            wt.language_id = l.language_id and l.language_code = '$language_code'
            and wt.strength=(select min(strength) from word_translation
              where language_id = wt.language_id
              and word_id = wt.word_id)) on w.word_id = wt.word_id
       where w.glyph_id = g.glyph_id
         and w.page_number = $page";
$res = mysql_query($q) or die('could not query: ' . mysql_error());
while ($row = mysql_fetch_assoc($res)){
   $word = array($row['glyph_code']);
   $coords = get_coord_str($word, $lookup);
   if (empty($coords)) continue;
   $elem = '<area shape="rect" id="word_id_' . $row['word_id'] .'" coords="' . $coords . '" href="' .
      "http://corpus.quran.com/wordmorphology.jsp?location=(" .
      $row['sura_number'] . ':' . $row['ayah_number'] . ':' . $row['position'] .')"/>';
   $data = $row;
   array_push($map_elems, array(
      html => $elem,
      data => $row
   ));
}

$mp3 = "http://everyayah.com/data/Husary_128kbps/PageMp3s/Page". sprintf('%03d', $page) .".mp3";
$cmd = ($autoplay? 'stop' : 'play');
?>
<!DOCTYPE html>
<html>
   <head>
      <title>quran - <? echo $page ?></title>
      <link rel="stylesheet" type="text/css" href="css/styles.css" />
      <script type="text/javascript">
         window.map_elems = {};
      <? foreach ($map_elems as $elem) { ?>
         window.map_elems[<? echo $elem[data][word_id] ?>] = <? echo json_encode($elem[data]) ?>;
      <? } ?>
      </script>
   </head>
   <body>
      <map name="mushaf_page">
      <? foreach ($map_elems as $elem) { ?>
         <? echo $elem[html] ."\n" ?>
      <? } ?>
      </map>

      <div class="playdiv" style="display: none;">
         <a href="index.php?page=<? echo $prev ?>">prev</a> |
         <a href="index.php?page=<? echo $next ?>">next</a>
         <div class="play_control">
            <a id="control" href="javascript:<? echo $cmd ?>();"><? echo $cmd ?></a>
         </div>
      </div>

      <div id="mushaf_div" style="width: <? echo $width ?>px;">
         <img id="map" src="img/page/<? echo $width ?>/<? echo $page ?>.png" border="0" usemap="#mushaf_page" alt="" />
      </div>

      <script type="text/javascript" src="jquery-qtip/jquery-1.3.2.min.js"></script>
      <script type="text/javascript" src="jquery-qtip/jquery.qtip-1.0.0-rc3.min.js"></script>
      <script type="text/javascript" src="soundmanager2/script/soundmanager2-nodebug-jsmin.js"></script>
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
               var word_id = $(this).attr('id').replace(/^word_id_/, '');
               var content = '<div style="text-align: center; padding: 6px;">'+
                     '<img src="http://corpus.quran.com/wordimage?id=' + word_id + '" alt="" />'+
                     '<br/>'+
                     '<br/>'+
                     '<div>'+
                        '<span style="padding: 6px; font-size: 16pt; font-weight: bold; font-family: sans-serif;">'+ window.map_elems[word_id]['translation'] +'</span>'+
                     '</div>'+
                  '</div>';
               $(this).qtip({
                  content: content,
                  position: {
                     corner: {
                        target: 'topMiddle',
                        tooltip: 'bottomMiddle'
                     }
                  },
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
   </body>
</html>

<?php
function get_coord_str($words, $lookup){
   // returns ul_x,ul_y,lr_x,lr_y
   if (count($words)==1){
      if (!isset($lookup[$words[0]]))
         return "";
      $ref = $lookup[$words[0]];
      return $ref['min_x'] . ',' . $ref['min_y'] . ',' . $ref['max_x'] . ',' .
         $ref['max_y'];
   }
   else {
      $first = $words[0];
      $last = $words[count($words)-1];
      if ((!isset($lookup[$first])) || (!isset($lookup[$last]))) return "";
      $ref_f = $lookup[$first];
      $ref_l = $lookup[$last];
      if (($ref_f['min_y'] == $ref_l['min_y']) &&
         ($ref_f['max_y'] == $ref_l['max_y'])){
            // same line, so we can handle it.
         $minx = min($ref_f['min_x'], $ref_l['min_x']);
         $maxx = max($ref_f['max_x'], $ref_l['max_x']);
         return "$minx,{$ref_f['min_y']},$maxx,{$ref_l['max_y']}";
      }
      else return "";  // i don't think this will happen, but just in case
   }
}
// vim: ts=3 sw=3 expandtab
