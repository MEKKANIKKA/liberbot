; api luna
alias getluna {
  set -l %lunatoken $rand(1,500)
  set %lunatarget $+ - $+ %lunatoken $1
  sockopen getluna $+ %lunatoken localhost 80
}
on *:sockopen:getluna*: {
  set -l %lunatoken $replace($sockname,getluna,-)
  getamp_echo Obteniendo datos de luna
  sockwrite -nt $sockname GET /myrobot/moon/index.php HTTP/1.1
  sockwrite -nt $sockname Host: $+(localhost,$crlf,$crlf)
}
on *:sockread:getluna*: {
  sockread %getluna
  tokenize 32 %getluna
  set -l %lunatoken $replace($sockname,getluna,-)

  set -l %lunanickrecibe $($+(%,lunatarget,$eval(%lunatoken)),2)
  if ( $1 == MOON_DATA ) {
    tokenize 33 $2-
    ; $1 = dias
    ; $2 = % de iluminacion
    mybot PRIVMSG %lunanickrecibe :14,0Luna $1 de $2 días y $3 $+ % de iluminación
    unset $+(%,lunatarget,$eval(%lunatoken))
  }
}
