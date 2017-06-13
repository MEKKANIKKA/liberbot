; idle boky on freenode 
alias freenode {
  if ( !$dialog(freenode_dialog) ) {
    dialog -m freenode_dialog freenode_dialog
  }
}
alias freenodedebug {
  if ( !$window(@freenodedebug) ) {
    freenodewindebug 
  }
  echo @freenodedebug $1-
}
dialog freenode_dialog {
  title ":freenode"
  size 0 600 110 19
  option dbu
  button "Conectar", 1, 6 2 40 15, default flat
  button "Desconectar", 2, 6 2 40 15, hide flat
  button "Debug", 3, 48 2 27 15, flat
  button "Identify", 4, 77 2 27 15, flat
}


on *:dialog:freenode_dialog:init:0: {
  if ( $sock(freenodeclon) ) {
    did -h freenode_dialog 1
    did -v freenode_dialog 2
  }
}
on *:dialog:freenode_dialog:sclick:1: {
  did -h freenode_dialog 1
  did -v freenode_dialog 2
  freenodeclon
}
on *:dialog:freenode_dialog:sclick:2: {
  sockclose freenodeclon
  did -v freenode_dialog 1
  did -h freenode_dialog 2
}
alias freenodewindebug {
  if ( !$window(@freenodedebug) ) { window -eh @freenodedebug }
}
on *:dialog:freenode_dialog:sclick:3: {
  if ( $window(@freenodedebug).state == hidden ) {
    window -a @freenodedebug

  }
  elseif ( $window(@freenodedebug).state == normal ) {
    window -h @freenodedebug
  }
  else {
    window -h @freenodedebug
  } 
}
on *:dialog:freenode_dialog:sclick:4: {
  set -l %mypass $?*="Pwd?"
  freenodewrite privmsg nickserv :identify %mypass
}
alias freenodeclon {
  if ( !$window(@freenodedebug) ) { window -eh @freenodedebug }
  log on @freenodedebug -f $+($scriptdirlogs\freenode,.txt)
  titlebar @freenodedebug Freenode clon
  if ( !$sock(freenodeclon) ) {
    sockopen freenodeclon irc.freenode.org 6667
  }
  else {
    if ( $?!="Ya hay una conexión activa, desea reinicarla?" ) {
      freenodewrite QUIT :Reset
      .timerFREENODE_RESTART 1 1 freenodeclon
    }
    else {
    }
  }
}
alias freenodewrite sockwrite -nt freenodeclon $1-
on *:sockopen:freenodeclon: {
  sockwrite -nt $sockname USER banton - - :tunel IRC
  sockwrite -nt $sockname NICK bokybanton
}
on *:sockread:freenodeclon: {
  sockread %freenodeclon
  tokenize 32 %freenodeclon
  if ( $1 == PING ) { sockwrite -nt $sockname PONG $2- }
  ;cloak debug
  if ( $2 == PRIVMSG ) { goto cloakdebug }
  freenodedebug %freenodeclon
  :cloakdebug

  halt
}
