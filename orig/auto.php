<?php
$sura = 1;
$ayah = 1;
$width = 650;

$cli = false;
if (empty($_SERVER['DOCUMENT_ROOT'])){
   $cli = true;
   if ($argc < 3){
      print "usage: " . $argv[0] . " sura ayah [width]\n";
      die;
   }
   $sura = $argv[1];
   $ayah = $argv[2];

	 if ($argv[3]) {
   	$width = $argv[3];
	 }
}
else if (isset($_GET['sura']) && is_numeric($_GET['sura']) &&
   isset($_GET['ayah']) && is_numeric($_GET['ayah'])) {
   $sura = $_GET['sura'];
   $ayah = $_GET['ayah'];

	 if (isset($_GET['width']) && is_numeric($_GET['width'])) {
		 $width = $_GET['width'];
	 }
}

$db = new SQLiteDatabase('./data/sura_ayah_page_text.sqlite2.db');
if (!$db) die("died");

$q = @$db->query("select page, text from sura_ayah_page_text where sura = $sura and ayah = $ayah");
$result = $q->fetch();

$page = $result[page];
$text = $result[text];

if (($page==1) || ($page==2)) $fontSize = 32;
else $fontSize = 24;
//$fontSize = 1.6*$fontSize; // seems to overflow i.e. wrapping isn't perfect
$font = './data/fonts/QCF_P' . sprintf('%03d', $page) . '.TTF';
$words = split(';', $text);

$i = 0;
$max = count($words)-1;

$min = 7;
$ayahText = array();
$data = array();
$max_line_w = -1;
$max_line_h = -1;
$min_line_h = -1;

while ($i < $max){
   $dim = array();
   $curStr = "";

   $cap = min($i+$min, $max);
   for ($j=$i; $j<$cap; $j++)
      $curStr .= $words[$j] . ';';
   $i = $cap;
   $dim = getLength(reverseStr($curStr), $font);

   for ($i = $cap; $i < $max; $i++){
      $oldStr = $curStr;
      $curStr .= $words[$i] . ';';
      $oldDim = $dim;
      $dim = getLength(reverseStr($curStr), $font);
      if ($dim[0] > $width){
         $curStr = $oldStr;
         $dim = $oldDim;
         break;
      }
   }

   $ayahText[] = $curStr;
   $data[] = $dim;
   if ($max_line_w < $dim[0]) $max_line_w = $dim[0];
   if ($max_line_h < $dim[1]) $max_line_h = $dim[1];
   if ($min_line_h > $dim[2]) $min_line_h = $dim[2];
}

$padding = 12.5;
$lineSpacing = $fontSize / 4;
$imgHeight = 0;
$imgWidth = 2 * ($padding) + $width;
foreach ($data as $d)
   $imgHeight += $d[1];
$imgHeight += (2 * $padding) + ((count($data)-1) * $lineSpacing);

$img = imagecreatetruecolor($imgWidth, $imgHeight);

// courtesy of webmaster-talk's php forum
$bg = imagecolorallocatealpha($img,255,0,0,127);
$black = imagecolorallocate($img, 0x00, 0x00, 0x00);
imagesavealpha($img, true);
imagefill($img, 0, 0, $bg);

$ypos = $padding;
$lines = count($ayahText);
for ($i=0; $i<$lines; $i++){
   $y = $ypos + abs($data[$i][2]);
   $x = $imgWidth - $data[$i][0] - $padding;
   $line = reverseStr($ayahText[$i]);
   imagettftext($img, $fontSize, 0, $x, $y, $black, $font, $line);
   $ypos += $data[$i][1] + $lineSpacing;
}

if ($cli){
   $fn = "output/" . $sura . "_$ayah.png";
   imagepng($img, $fn, 9);
}
else {
   header('Content-Type: image/png');
   imagepng($img);
}
imagedestroy($img);

function getLength($line, $font){
   global $fontSize;
   $arr = imagettfbbox($fontSize, 0, $font, $line);
   $min_x = min($arr[0], $arr[6]);
   $max_x = max($arr[2], $arr[4]);
   $min_y = min($arr[1], $arr[3]);
   $max_y = max($arr[5], $arr[7]);

   return array($max_x-$min_x, $min_y - $max_y, $max_y);
}

function reverseStr($text){
   $arr = split(';', $text);
   $revtext = '';
   $i = count($arr) - 1;
   for (; $i >= 0; $i--){
      if (!empty($arr[$i])){
         $revtext .= $arr[$i] . ';';
      }
   }
   return $revtext;
}
