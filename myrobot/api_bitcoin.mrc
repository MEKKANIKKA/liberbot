alias getbtc {
  ; getbtc whatkind(euro/dolar) target
  set -e %token $rand(1,500)
  set %whatkind $1
  set %target $+ - $+ %token $2
  ;set $+(%target,%token)
  sockopen $+(getbtc,%token) localhost 80
}
on *:sockopen:getbtc*: {
  getamp_echo Conectando..
  if ( %whatkind == dolar ) {
    sockwrite -nt $sockname GET /myrobot/btc/index.php HTTP/1.1

  }
  else {
    sockwrite -nt $sockname GET /myrobot/btc/euro.php HTTP/1.1

  }
  sockwrite -nt $sockname Host: $+(localhost,$crlf,$crlf)
}
on *:sockread:getbtc*: {
  var %eltoken = $replace($sockname,getbtc,-)
  set -l %nickquerecibe $($+(%,target,$eval(%eltoken)),2)
  if ( $sockerr ) {
    ;mybot PRIVMSG %nickquerecibe :Error al conectar al servidor. No hay datos
    sockclose $sockname
  }
  else {
    sockread %getbtc
    getamp_echo %getbtc

    tokenize 32 %getbtc
    if ( $1 == BTCDOLAR ) {
      %bitprice = $2
      mybot PRIVMSG %nickquerecibe :El bit1,8coin está a $ $+ %bitprice dólares
      .speak bitcoin
      unset $+(%,target,$eval(%eltoken))
      sockclose $sockname
    }
    elseif ( $1 == BTCEURO ) {
      %bitprice = $2
      mybot PRIVMSG %nickquerecibe :El bit1,8coin está a %bitprice $+ € euros
      .speak bitcoin
      unset $+(%,target,$eval(%eltoken))
      sockclose $sockname
    }
  }

}
