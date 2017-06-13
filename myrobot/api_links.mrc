; api quotes
alias bot-links {
  if ( $1 == add ) {
    set -l %blinkstoken $rand(1,500)
    set %blinkstarget $+ - $+ %blinkstoken $2
    set %blinksnick $+ - $+ %blinkstoken $3
    set %blinksblinks $+ - $+ %blinkstoken $4-
    sockopen botlinks $+ %blinkstoken libertarian.pe.hu 80
  }
  elseif ( $1 == dame ) { 
    set -l %blinkstoken $rand(1,500)
    set %dblinkstarget $+ - $+ %blinkstoken $2
    sockopen damebotlinks$+ %blinkstoken libertarian.pe.hu 80
  }
  elseif ( $1 == dameid ) {
    set -l %blinkstoken $rand(1,500)
    set %didblinkstarget $+ - $+ %blinkstoken $2
    set %didblinksid $+ - $+ %blinkstoken $3
    sockopen dameidbotlinks$+ %blinkstoken libertarian.pe.hu 80
  }

}
on *:sockopen:dameidbotlinks*: {
  set -l %qttoken $replace($sockname,dameidquote,-)
  set -l %qtencanal $remove($($+(%,quotetarget,$eval(%qttoken)),2),$chr(35))
  set -l %qtid $($+(%,quoteid,$eval(%qttoken)),2)
  set -l %getget $+(/liberbot/quotes/?modo=dameid&id=,$eval(%qtid))
  getamp_echo $timestamp Listando la cita ID: %qtid en %qtencanal
  sockwrite -nt $sockname GET %getget HTTP/1.1
  sockwrite -nt $sockname Host: $+(libertarian.pe.hu,$crlf,$crlf)
}
on *:sockread:dameidbotlinks*: {

  sockread -f %damequote
  tokenize 33 %damequote
  if ( $1 == LA_QUOTE_ES ) {
    set -l %qttoken $replace($sockname,dameidquote,-)
    set -l %qtencanal $($+(%,quotetarget,$eval(%qttoken)),2)
    set -l %qtid $($+(%,quoteid,$eval(%qttoken)),2)

    mybot PRIVMSG %qtencanal $+(:,$eval($chr(35)),$eval(%qtid))  $6-  por $4
    getamp_echo Funciono $2-
    unset $+(%,quotetarget,$eval(%qttoken))
    unset $+(%,quoteid,$eval(%qttoken))
    sockclose $sockname
  }
  unset %damequote
}
on *:sockopen:damebotlinks*: {
  set -l %qttoken $replace($sockname,damebotlinks,-)
  set -l %qtencanal $remove($($+(%,quotetarget,$eval(%qttoken)),2),$chr(35))
  set -l %getget /liberbot/quotes/?modo=dame
  getamp_echo $timestamp Listando una cita en %qtencanal
  sockwrite -nt $sockname GET %getget HTTP/1.1
  sockwrite -nt $sockname Host: $+(libertarian.pe.hu,$crlf,$crlf)
}
on *:sockread:damebotlinks*: {

  sockread -f %damequote
  tokenize 33 %damequote
  if ( $1 == LA_QUOTE_ES ) {
    set -l %qttoken $replace($sockname,damebotlinks,-)
    set -l %qtencanal $($+(%,quotetarget,$eval(%qttoken)),2)
    mybot PRIVMSG %qtencanal $+(:,$eval($chr(35)),$2)  $6-  por $4
    getamp_echo Funciono $2-
    unset $+(%,quotetarget,$eval(%qttoken))
    sockclose $sockname
  }
  unset %damequote
}
on *:sockopen:botlinks*: {
  set -l %qttoken $replace($sockname,quote,-)
  set -l %qtbynick $($+(%,botlinks,$eval(%qttoken)),2)
  set -l %qtencanal $remove($($+(%,quotetarget,$eval(%qttoken)),2),$chr(35))
  set -l %qtquote $replace($($+(%,quotequote,$eval(%qttoken)),2),$chr(32),+)
  set -l %getget $+(/liberbot/quotes/?modo=add&bynick=,%qtbynick,&encanal=,%qtencanal,&quote=,%qtquote)
  getamp_echo $timestamp Añadiendo quote a la BD by nick: %qtbynick en canal: %qtencanal quote: %qtquote
  sockwrite -nt $sockname GET %getget HTTP/1.1
  sockwrite -nt $sockname Host: $+(libertarian.pe.hu,$crlf,$crlf)
}
on *:sockread:botlinks*: {
  sockread -r %quote
  tokenize 32 %quote
  if ( $1 == Content-Length: && $2 == 2 ) {
    getamp_echo $timestamp Añadido con éxito a la BD
    set -l %qttoken $replace($sockname,quote,-)
    set -l %quenickrecibe $($+(%,botlinksbotlinks,$eval(%qttoken)),2)
    mybot PRIVMSG %quenickrecibe :Añadido con éxito!
    unset $+(%,quotenick,$eval(%qttoken))
    unset $+(%,quotetarget,$eval(%qttoken))
    unset $+(%,quotequote,$eval(%qttoken))
  }
  unset %quote
}
