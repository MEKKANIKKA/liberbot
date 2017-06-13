; apache+php+msl api

alias getamp_echo {
  if ( $window(@apache_server) ) {
    echo @apache_server > $1-
  }
  else {
    window -he @apache_server
  }
}
alias getamp {
  set -l %ytoken $rand(1,500)
  set $+(%,ytarget,-,%ytoken) $2
  sockopen getamp $+ %ytoken localhost 80
  set %videoid $1
}
on *:sockopen:getamp*: {
  getamp_echo Conectando..
  sockwrite -nt $sockname GET $+(/myrobot/index.php?idvideo=,%videoid) HTTP/1.1
  sockwrite -nt $sockname Host: $+(127.0.0.1,$crlf,$crlf)
}
on *:sockread:getamp*: {
  sockread %getamp
  tokenize 32 %getamp
  ;getamp_echo $1-
  if ( $1 == YINFO ) {
    set -l %yutub_titulo $2-
    getamp_echo Imprimiento video " %yutub_titulo "
    set -l %yqtoken $replace($sockname,getamp,-)
    set -l %ynickquerecibe $($+(%,ytarget,$eval(%yqtoken)),2)
    .speak You tube
    mybot PRIVMSG %ynickquerecibe :YouTube: %yutub_titulo
    sockclose $sockname
    unset $+(%,ytarget,$eval(%yqtoken))

  }
  unset %getamp
}



