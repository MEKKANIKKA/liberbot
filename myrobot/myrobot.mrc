; ### Liberbot

; ### alias para lanzar dialogs
alias botpanel {
  if ( !$dialog(botpanel) ) {
    if ( !$dialog(mybot_joinlist) ) { dialog -m mybot_joinlist mybot_joinlist }
    if ( !$dialog(freenode_dialog) ) { dialog -m freenode_dialog freenode_dialog }
    dialog -m botpanel botpanel


  }
}
alias mybot_autojoin {
  if ( !$dialog(mybot_joinlist) ) { dialog -m mybot_joinlist mybot_joinlist }
}
alias hablabot msg %myrobot_username MENSAJE $1-
; ### dialogs
dialog botpanel {
  title ":Liberbot"
  size 0 200 60 78
  option dbu
  icon myrobot.ico, 0
  button "Conectar", 1, 1 34 58 14, default flat
  button "Debug", 2, 1 50 58 14, default flat
  edit %myrobot_server, 5, 2 4 56 12, center
  edit %myrobot_username, 9, 1 20 58 11, center
  box "", 12, 1 0 58 17
  check "guardar datos", 10, 13 67 44 10, flat left
  button "Desconectar", 13, 1 34 58 14, hide default flat
  tab "Canales", 14, 71 1 134 73
  list 15, 74 16 129 56, tab 14 size
  tab "Comandos", 16
  list 17, 74 16 129 56, tab 16 size
  menu "Menu", 3
  item "Conectar", 4, 3
  item "Autojoin", 18, 3
  item "Restaurar", 6, 3
  item break, 21, 3
  item "Nick pw", 20, 3
  item break, 19, 3
  item "Kill session", 22, 3
  item "Cerrar", 7, 3, ok
  menu "About", 8
  item "Bokybanton", 11, 8
}



dialog mybot_joinlist {
  title ":botautojoin"
  size 0 400 60 78
  option dbu
  icon myrobot.ico, 0
  list 2, 0 1 60 77, size
  menu "Acciones", 4
  item "Salir del canal", 5, 4
  item "Entrar al canal", 6, 4
  item break, 10, 4
  item "Añadir canal", 9, 4
  item "Borrar seleccionado", 8, 4
  item break, 11, 4
  item "Borrar todos", 7, 4
}

on *:dialog:botpanel:menu:7: {
  if ( $dialog(mybot_joinlist) ) { dialog -x mybot_joinlist }
  if ( $dialog(freenode_dialog) ) { dialog -x freenode_dialog }

}
on *:dialog:mybot_joinlist:menu:8: {
  set %canalesfile $scriptdircanales.txt
  set %canalaborrar $did(2).seltext
  set %quelineaborrar $read(%canalesfile,w,$+(*,%canalaborrar,*))
  set %quelineaborrar $readn
  write -dl $+ %quelineaborrar %canalesfile
  did -d mybot_joinlist 2 $did(2).sel
}
on *:dialog:mybot_joinlist:menu:6: {
  mybot JOIN $did(2).seltext
}
on *:dialog:mybot_joinlist:menu:5: {
  mybot PART $did(2).seltext
}
on *:dialog:mybot_joinlist:menu:9: {
  var %uncanal = $$?="Canal?"
  write $scriptdircanales.txt %uncanal
  did -a mybot_joinlist 2 %uncanal
}
; #### password nick
on *:dialog:botpanel:menu:20: {
  set %myrobot_pw $$?="Nueva clave?"
}
on *:dialog:botpanel:menu:22: {
  sockclose myrobot
}
on *:dialog:botpanel:menu:4: {
  mybot_conectar
}
; ### alias para autoenviar sockwrite al bot
alias mybot {
  sockwrite -n myrobot $1-
}
; ### alias para debug
alias mybotdebug {
  if ( !$window(@botdebug) ) { 
    ; titlebar
    window -eh @botdebug 
    log on @botdebug -f $+($scriptdirlogs\debug,.txt)
    titlebar @botdebug %myrobot_version 
  }
  echo @botdebug $1-
}
; ### alias para cerrar conexion
alias closemybot {
  sockclose myrobot
  did -h botpanel 13
  did -v botnel 1
}


; ######################################
; ### GESTIONANDO EVENTOS DEL DIALOG ###
; ######################################
; evento autojoin
on *:dialog:mybot_joinlist:sclick:2: {
  %quecanal = $did(2).seltext
  ;mybotdebug %quecanal
  mybot JOIN %quecanal
}
on *:dialog:mybot_joinlist:init:0: {
  mdx SetMircVersion   $version 
  mdx MarkDialog  $dname 
  mdx SetControlMDX $dname 2 listview grid report single infotip showsel rowselect > $scriptdir $+ dll/views.mdx
  Did -i $dname 2 1 headerdims 70 35
  Did -i $dname 2 1 headertext Canal $chr(9) Pwd
  var %ola = $lines($scriptdircanales.txt)
  var %cero = 1
  while ( %cero <= %ola ) {
    %canalcarga = $read($scriptdircanales.txt,%cero)
    did -a mybot_joinlist 2 %canalcarga
    inc %cero

  }
}
on *:dialog:botpanel:init:0: {
  if ( $sock(myrobot) ) {
    did -h botpanel 1
    did -v botpanel 13
  }
}


; ### evento para escuchar boton de debug
on *:dialog:botpanel:sclick:2: {
  if ( $window(@botdebug).state == normal ) {
    window -h @botdebug
  }
  else {
    window -ae @botdebug
  }
}
; ### evento del menu autojoin
on *:dialog:botpanel:menu:18: { mybot_autojoin }
alias mybot_conectar {
  botpanel
  if ( $dialog(botpanel) ) {
    set %myrobot_server $did(botpanel,5).text
    set %myrobot_port 6667
    set %myrobot_username $did(botpanel,9).text
    did -h botpanel 1 
    did -v botpanel 13
  }




  ; ### debugging
  mybotdebug Conectando al servidor %myrobot_server

  ; ### socklisten de servidor identd
  if ( !$sock(myrobot_identd) ) { socklisten myrobot_identd 113 }
  .speak Conecting
  ; ### sockopen a servidor especificado
  sockopen myrobot %myrobot_server %myrobot_port

}
; ### evento para conectar el bot
on *:dialog:botpanel:sclick:1: {
  mybot_conectar
}
; ## boton desconectar
on *:dialog:botpanel:sclick:13: {
  mybot QUIT : $+ %myrobot_version
  ; ### enhacement de los botones
  did -v botpanel 1
  did -h botpanel 13
  ; ### cerrando la conexion
  sockclose myrobot
}
; ## editando el dialogo cuando se cierre la conexión
; ## aunque no puedo activar estos comandos si cierro manualmente la conexión.
on *:sockclose:myrobot: {
  did -h botpanel 13
  did -v botpanel 1
}

; ###############################
; ### GESTIONANDO LA CONEXION ###
; ###############################

; ### servidor IDENTD (hostname lookup error handling)
on *:socklisten:myrobot_identd: {
  var %_r = $r(1,500)
  sockaccept myrobot_ [ $+ [ %_r ] ]
  sockclose myrobot_identd
}
on *:sockread:myrobot_*: {
  sockread &_rb
  tokenize 32 &_rb
  var &_numtoks = $numtok($1-,44)
  if ( %_numtoks == 2 && $1,$3 isnum ) {
    sockwrite -n $sockname $3 , $1 : USERID : UNIX : bot
  }
}
; ### conexion principal del bot
on *:sockopen:myrobot: {
  if ( $sockerr ) {
    mybotdebug Error al conectar bot
    did -h botpanel 1 
    did -v botpanel 13
  }
  else {

    ; enviar nickname e identidad
    mybotdebug Enviando nickname y username
    sockwrite -n $sockname NICK %myrobot_username $+ : $+ %myrobot_pw
    sockwrite -n $sockname USER bot - - : $+ %myrobot_version
  }
}
