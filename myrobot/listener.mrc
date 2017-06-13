; ### sockread principal
on *:sockread:myrobot: {
  sockread -f %myrobot_read | tokenize 32 %myrobot_read
  ; cloak debug
  ;if ( $2 == PRIVMSG ) { goto cloakdebug }
  if ( $1 == PING ) { goto cloakdebug }
  mybotdebug %myrobot_read 
  :cloakdebug
  ; ping-pong
  if ( $1 == PING ) { sockwrite -n $sockname PONG $2 }
  ; autojoin
  elseif ( $2 == 376 ) {
    set -l %ola $lines($scriptdircanales.txt) | set -l %cero 1
    while ( %cero <= %ola ) { set -l %canalcarga $read($scriptdircanales.txt,%cero) | mybot JOIN %canalcarga | inc %cero }
  }
  elseif ( $2 == JOIN ) {
    %nickentra = $replace($gettok($1,1,33),:,)
    if ( %nickentra == %myrobot_username ) {
      ; cuando el bot entra a un canal
      %canalreciente = $replace($3,:,)
      mybotdebug Acabo de entrar al canal %canalreciente
      mybot PRIVMSG %canalreciente :ACTION Hola! 
    }
    else {
      ; cuando entra alguien que no es el bot
      %canalreciente = $replace($3,:,)
      ; mybot NOTICE %nickentra :Hola, soy un bot Libertario, mis comandos son !libertarian, !inspirame y !bitcoin
      if ( %canalreciente == #libertarian ) { mybot NOTICE %canalreciente :Consulta las normas con /msg Liberbot !normas }
    }
  }
  elseif ( $2 == INVITE ) {
  if ( $3 == %myrobot_username ) {
  set -l %canalinvite $replace($4,:,)
  mybot JOIN %canalinvite
  }
  }
  ; por privado
  elseif ( $2 == PRIVMSG ) {
    if ( $3 == %myrobot_username ) {
      var %nickrecibe = $replace($gettok($1,1,33),:,)
      set -l %msg mybot PRIVMSG %nickrecibe : $+
      if ( $4 == :VERSION ) { mybot NOTICE %nickrecibe :VERSION %myrobot_version   }
      if ( $4 == :MENSAJE ) { mybot PRIVMSG $5 : $+ $6- }
      elseif ( $4 == :Liberbot ) { mybot PRIVMSG %nickrecibe :Que? }
      elseif ( $4 == :login ) {
        mybot PRIVMSG %nickrecibe :Login system v1
      }
      ; Normas para #libertarian
      elseif ( $4 == :.Normas) { mybot PRIVMSG %nickrecibe : $+ %normas_libertarian }
      elseif ( $4 == :.Web ) { mybot PRIVMSG %nickrecibe :7http://liberbot.bokyopinion.info/liberbot }
      elseif ( $4 == :.Comandos ) { mybot PRIVMSG %nickrecibe :!divisas !bitcoin !luna !libertarian !inspirame !web !hora !version }
      elseif ( $4 == :.version ) { mybot PRIVMSG %nickrecibe : $+ %myrobot_version  }
      elseif ( $4 == :.hora ) { mybot PRIVMSG %nickrecibe : $+ $timestamp }
      elseif ( $4 == :.libertarian ) { var %quoteliber = $read($scriptdir $+ txt/libertarian.txt) | mybot PRIVMSG %nickrecibe : $+ %quoteliber }
      elseif ( $4 == :.inspirame ) { var %quoteinsp = $read($scriptdir $+ txt/inspirame.txt) | mybot PRIVMSG %nickrecibe : $+ %quoteinsp }
      elseif ( $4 == :.divisas ) { getdivisas %nickrecibe }
      elseif ( $4 == :.divisa ) {
        if ( !$5 ) { }
        else {
          if ( $6 == nombre ) { %quenombre = $divisa_nombre($5) | mybot PRIVMSG %nickrecibe : $+ $upper($5) %quenombre }
          else { cambiodivisa $5 %nickrecibe }
        }
      }
      elseif ( $4 == :.bitcoin ) {
        if ( $5 == euros ) { getbtc euro %nickrecibe }
        ; handling de canal por error de timing
        elseif ( $5 == eur ) { getbtc euro %nickrecibe }
        ; handling de canal por error de timing       
        else { getbtc dolar %nickrecibe }
      }
    }
    ; mensajes en canal
    else {
      ; cuantos usuarios hay en el servidor
      ; raw 265 (chathispano)
      set %nickrecibe $3
      set %quenick $1
      set %quenick $remove($gettok(%quenick,1,33),:)
      set -l %msg mybot PRIVMSG %nickrecibe : $+
      if ( $4 == :!Liberbot ) { %msg Si? }
      elseif ( $4 === :HOLA ) { %msg HOLA! }
      elseif ( $4 === :Anarquía ) { %msg Y libertad! }
      elseif ( $4 == :-fiesta ) { %msg fiestón :D! }
      elseif ( $4 == :-farlopa ) { %msg farlopa! farlopa! farlopa pa la tropa }
      elseif ( sito miñanco isin $4- ) { %msg Sito Miñanco preso político! }
      elseif ( $4 == :-test ) { %msg 13test }
      elseif ( $4 == :.info ) {
        if ( $5 == uptime ) { %msg $uptimeinfo }
        elseif ( $5 == ram ) { %msg $raminfo }
        elseif ( $5 == net ) { %msg $netwinfo }
        elseif ( $5 == web ) { %msg 5http://libertarian.pe.hu/liberbot }
        elseif ( $5 == version ) { %msg %myrobot_version }
        elseif ( $5 == hora ) { %msg $timestamp }
        elseif ( $5 == server ) { %msg Servidor: %myrobot_server }
        elseif ( $5 == radio ) { %msg URL:5 https://radio.bokyopinion.info:8002  }
        elseif ( $5 $6 == que suena ) { %msg Está sonando en la radio:5 %que.cancion.suena  }
      }
      elseif ( liberbot isin $4- ) {
        if ( tienes novia isin $4- ) { %msg Mi novia es la libertad! }
        elseif ( tienes novio isin $4- ) { %msg Mi novio es el chocolate mmm }
        elseif ( saluda a isin $4- ) { %msg Saludos! }
        elseif ( eres tonto isin $4- ) { %msg no, solo lo parezco }
        elseif ( eres capitalista isin $4- ) { %msg solo soy un bot }
        elseif ( eres patriota isin $4- ) { %msg No soy patriota, mi patria es la red }
        elseif ( capullo isin $4- ) { %msg solo soy un troll }
        elseif ( hijo puta isin $4- ) { %msg no tengo madre, soy un bot }
        elseif ( que piensas de isin $4- ) {
          if ( comunismo isin $4- ) { %msg No me gusta el comunismo }
          elseif ( capitalismo isin $4- ) { %msg Es la forma más justa de organización social }
          elseif ( la droga isin $4- ) { %msg ¿qué es una droga y qué no? }
          elseif ( podemos isin $4- ) { %msg Podemos es un movimiento populista al estilo de A. Gramsci }
          elseif ( PP isin $4- ) { %msg El PP es el partido con más casos de corrupción en la política española }
          elseif ( españa isin $4- ) { %msg No me gustan los nacionalismos }
          else { }
        }
        else { %msg Si? }
      }
      elseif ( $4 == :.luna ) { getluna %nickrecibe }
      elseif ( $4 == :.frase ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( $4 == :.galleta ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( $4 = :.dimefrase ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( liberbot di algo isin $4- ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( bot dime algo isin $4- ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( bot sabe decir algo isin $4- ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( dime una frase isin $4- ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( dime otra frase isin $4- ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( otra frase please isin $4- ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( tienes más frases? isin $4- ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( puto bot isin $4- ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( Liberbot dime una frase isin $4- ) { %msg $read($scriptdir $+ txt/frases.txt) }
      elseif ( $4 == :.libertarian ) { %msg  $read($scriptdir $+ txt/libertarian.txt) }
      elseif ( $4 == :.inspirame ) { %msg  $read($scriptdir $+ txt/inspirame.txt) }
      ;elseif ( comunismo isin $4- ) { %msg El comunismo es... }
      ;dame los nombres de las divisas en el API
      elseif ( $4 == :.divisas ) { getdivisas %nickrecibe }
      elseif ( $4 == :.divisa ) {
        if ( !$5 ) { }
        else {
          if ( $6 == nombre ) { %quenombre = $divisa_nombre($5) | mybot PRIVMSG %nickrecibe : $+ $upper($5)  %quenombre }
          else { cambiodivisa $5 %nickrecibe }
        }
      }
      elseif ( $4 == :.bitcoin ) {
        if ( $5 == euros ) { getbtc euro %nickrecibe }
        elseif ( $5 == eur ) { getbtc euro %nickrecibe }
        else { getbtc dolar %nickrecibe }
      }
      elseif ( $4 == :quote ) {
        if ( $5 == add ) { bot-quotes add %nickrecibe %quenick $6- }
        elseif ( $5 isnum ) { bot-quotes dameid %nickrecibe $5 }
        elseif ( $5 == lista ) { mybot PRIVMSG %nickrecibe :http://libertarian.pe.hu/liberbot/quotes }
        elseif ( !$5 ) { bot-quotes dame %nickrecibe }
      }
      elseif ( youtu isin $4 ) {
        set -l %cuantoes $len($4-) | dec %cuantoes | set -l %mensajeyoutube $strip($right($4-,%cuantoes))
        set -l %youtube_id $remove(%mensajeyoutube,com/watch?v=,youtube.,$chr(40),$chr(41),?,m.,v=,/watch?src_vid=,https://,http://,www.,/v/,youtube.com,youtu.be,youtu.be/,/watch?v=,/watch,?v=,$chr(31),#!,/)
        getamp %youtube_id %nickrecibe
      }
    }
  }
  halt
}
