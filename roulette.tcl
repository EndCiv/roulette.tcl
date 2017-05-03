###Custom made Russian Roulette Script
# dopeydwerg@hotmail.com made this
# EndCiv altered it to be more stupider
# there was no copyright nor license when I got it
# If you got a problem email endciv@fucktheconspiracy.com
#list lucky comments

set pull {
    "yells FUCK \"BOB\", and quickly pulls the trigger.."
    "shakes as he slowly raises the gun and pulls it's trigger.."
    "Eternal Salvation HERE I COME!"
    "sets down the pipe and calmly smiles as he pulls the trigger"
    "puts the gun in his mouth.."
    "places the gun between his eyes.."
    "Slowly raises the gun and put it against his temple.."
}

set lucky_msg {
    "...klik"
    "....klik"
    "..klik"
}

set pinkboy {
    "not paying attention, or just a pussy? .."
}

#set vars
set player1 ""
set player2 ""
set curplayer ""
set notcurplayer ""
set timeout_timer 0
set started 0
set turns 0
set bullit [rand 5]
#file you want scores to be written
set scorefile "roulette.txt"
set kill_count 0
set last_warn ""

#binds
bind pub - .spin spin:gun
bind pub - .shoot shoot:gun
bind pub - .play challenge:player
bind pub - .reply reply:player
"scripts/kill.tcl" 402L, 13997C                  1,1           Top
bind pub - .play challenge:player
bind pub - .reply reply:player
bind pub - .accept accept
bind pub - .no chicken
bind pub - .score show_player_score
bind pub - .scores showall


proc accept {nick host handle chan arg} {
    global rrstarttimer
            if {[utimerexists started]!=""} {killutimer $rrstarttimer}
    reply:player $nick $host $handle $chan "accept"
}

proc chicken {nick host handle chan arg} {
    reply:player $nick $host $handle $chan "chicken"
}

#proc to get somebody to play with you
proc challenge:player {nick host handle chan arg} {
    global botnick player1 player2 started timeout_timer kill_count last_warn notcurplayer
    global rrstarttimer rrchannel
        if {$arg == $nick} {
            puthelp "PRIVMSG $chan :..now we're talkin"
            kill $nick $chan
            return 0
        }
        if {$player1 != ""} {
            puthelp "PRIVMSG $chan :Sorry $player1 allready challenged $player2"
            return 0
        }
        if {![onchan $arg $chan]} {
            if {$nick == $last_warn} {
                puthelp "PRIVMSG $chan :now you're starting to annoy me"
                kill $nick $chan
                return 0
            }
            puthelp "PRIVMSG $chan :$arg isn't here."
            puthelp "PRIVMSG $chan :And if you do it again I'm gonna shoot you."
            set last_warn $nick
            return 0
        }
                                                 44,1          11%
            return 0
        }
        if {$arg == ""} {
            puthelp "PRIVMSG $chan :Type .challenge <nick> to start the game"
            return 0
        }
        if {$started == 1} {
            puthelp "PRIVMSG $chan :Game allready running"
            return 0
        }
        if {$arg == $botnick} {
            puthelp "PRIVMSG $chan :Challenge accepted"
            puthelp "PRIVMSG $chan :RRRRrrrrr....."
            kill $nick $chan
            return 0
        }
        set player1 $nick
        set player2 $arg
        set rrchannel $chan
        set timeout_timer 1
        utimer 600 [list timeout $chan ]
        set rrstarttimer [utimer 50 started]
        putquick "NOTICE $player2 :$nick challenges you to play Roulette with him."
        putquick "NOTICE $player1 :Challenge sent to $player2"
        putquick "NOTICE $player2 :type .accept to play .no to chicken out"
        return 0
}

proc reply:player {nick host handle chan arg} {
    global botnick player1 player2 turns started curplayer timeout_timer notcurplayer
    global rrstarttimer rrchan
        if {$player1 == ""} {
            puthelp "NOTICE $nick :Sorry nobody challenged you yet"
            puthelp "NOTICE $nick :To Chalenge Somebody type .play <nick>"
            return 0
        }
        if {$nick != $player2} {
            puthelp "NOTICE $nick :That's not your call. $player2 was challenged by $player1"
            return 0
        }
        if {$arg == ""} {
                                                 84,13         22%
        }
        if {$arg == ""} {
            puthelp "NOTICE $nick :Type .accept to play or .no to decline"
            return 0
        }
        if {$started == 1} {
            puthelp "PRIVMSG $chan :Game allready running"
            return 0
        }
        if {$arg == "chicken"} {
            puthelp "PRIVMSG $chan :$nick Chickened out."
            set player1 ""
            set player2 ""
            return 0
        }
        if {$arg == "accept"} {
            set curplayer $player1
            set notcurplayer $player2
            set rrchan $chan
            putserv "notice $player1 :$nick accepted your challenge. $curplayer goes first."
            putserv "notice $player1 :type .shoot to fire the pistol now, or .spin to spin the cylinder first."
            putserv "notice $player2 :$curplayer goes first."
            putserv "notice $player2 :type .shoot to fire the pistol now, or .spin to spin the cylinder first."
            incr_stats $curplayer "" "" "" "" ""
            incr_stats $notcurplayer "" "" "" "" ""
            set started 1
            set timeout_timer 0
            return 0
        }
}

proc spin:gun {nick host handle chan arg} {
    global botnick player1 player2 turns started bullit curplayer
    if {$nick != $curplayer} {
        puthelp "PRIVMSG $chan :It's not your turn."
        return 0
    }
    if {$started == 0} {
        shoot $nick $chan
        return 0
    }
    set bullit [rand 6]
    puthelp "PRIVMSG $chan :$curplayer spins the chamber ..rrrrrrr"
                                                 123,9         33%
    set bullit [rand 6]
    puthelp "PRIVMSG $chan :$curplayer spins the chamber ..rrrrrrr"
    incr_stats $curplayer "" "" "" "+ 1" ""
    shoot:gun $nick $host $handle $chan $started
    return 0
}

proc shoot:gun {nick host handle chan arg} {
    global botnick player1 player2 turns curplayer started bullit lucky_msg pull notcurplayer playerstat
    if {$started == 0} {
        kill $nick $chan
        return 0
    }
    if {$nick != $curplayer} {
        puthelp "PRIVMSG $chan :It's not your turn."
        return 0
    }
    set checknr1 [rand [llength $pull]]
    set temp_pull $pull
    set temp_pull [lindex $temp_pull $checknr1]
    puthelp "PRIVMSG $chan :$nick $temp_pull"
    incr_stats $curplayer "" "" "+ 1" "" ""
    #check if bullit is on position 0 if it is then your dead
    if {$bullit != 0} {
        #if not then set bullit - 1 like in a real fun
        set bullit [expr $bullit - 1]
        #increase turns taken for stats
        set turns [expr $turns + 1]
        #insert random msg
            set checknr [rand [llength $lucky_msg]]
            set temp_lol $lucky_msg
            set temp_lol [lindex $temp_lol $checknr]
            puthelp "PRIVMSG $chan :$temp_lol"
         #switch playsers so nobody can before there turn
        if {$curplayer == $player1} {
            set curplayer $player2
            set notcurplayer $player1
            } else {
                set curplayer $player1
                set notcurplayer $player2
                }
                puthelp "notice $curplayer :your turn Type .shoot or .spin"
                puthelp "notice $notcurplayer :$curplayer's Turn"
        return 0
@   
                                                 164,5         45%
                puthelp "notice $notcurplayer :$curplayer's Turn"
        return 0
    #if bullit was on position 0 kick loser from chan and reset all used variables
    } else {
        incr_stats $curplayer "" "+ 1" "" "" "+ 1"
        incr_stats $notcurplayer "+ 1" "" "" "" "+ 1"
        show_score $notcurplayer
        putlog "$playerstat"
        puthelp "PRIVMSG $chan :**BANG** You're Dead!! Winner $playerstat"
        puthelp "PRIVMSG $chan :.tip $notcurplayer 5"
        set player1 ""
        set player2 ""
        set curplayer ""
        set bullit [rand 5]
        set started 0
        return 0
    }
}

proc kill {nick chan} {
    global botnick
    set bullit [rand 5]
    for {set x 1} {$x < $bullit} {incr x} {
        puthelp "PRIVMSG $chan :klik..."
    }
    puthelp "PRIVMSG $chan :...BANG!!! "
    puthelp "KICK $chan $nick : Yep I'm still the king"
    return 0
}

proc timeout { chan } {
    global botnick player1 player2 turns curplayer started bullit lucky_msg pull timeout_timer
    if {$timeout_timer == 1} {
        puthelp "PRIVMSG $chan : $player2 is not paying attention.."
        set player1 ""
        set player2 ""
        set curplayer ""
        set bullit [rand 5]
        set timeout_timer 0
        set started 0
        return 0
    }
}
                                                 206,17        57%
    }
}

proc get_scores {} {
 global botnick scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
 if {[file exists $scorefile]&&[file size $scorefile]>2} {
  set _sfile [open $scorefile r]
  set rrscores [lsort -dict -decreasing [split [gets $_sfile] " "]]
  close $_sfile
  set rrscorestotal [llength $rrscores]
 } else {
  set rrscores ""
  set rrscorestotal 0
 }
    if {[info exists rrscoresbyname]} {unset rrscoresbyname}
        if {[info exists rrranksbyname]} {unset rrranksbyname}
            if {[info exists rrranksbynum]} {unset rrranksbynum}    
 set i 0
 while {$i<[llength $rrscores]} {
  set _item [lindex $rrscores $i]
            set _nick [lindex [split $_item ,] 5]
            set _win [lindex [split $_item ,] 0]
            set _lost [lindex [split $_item ,] 1]
            set _shots [lindex [split $_item ,] 2]
            set _spins [lindex [split $_item ,] 3]
            set _played [lindex [split $_item ,] 4]
  set rrscoresbyname($_nick) $_win
  set rrranksbyname($_nick) [expr $i+1],$_win
  set rrranksbynum([expr $i+1]) $_nick,$_win
  incr i
 }
 return
}
proc incr_stats {who win loss shots spins played} {
    global botnick scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
    set who [lindex [split $who "|"] 0]
    set who [lindex [split $who "_"] 0]
    get_scores
    if {$rrscorestotal>0} {
        set i 0
        if {[lsearch $rrscores "*,*,*,*,*,$who"]==-1} {
            append _newscores "0,0,0,0,0,$who "
        }
        while {$i<[expr [llength $rrscores] - 1]} {
                                                 247,5         68%
        }
        while {$i<[expr [llength $rrscores] - 1]} {
            set _item [lindex $rrscores $i]
            set _nick [lindex [split $_item ,] 5]
            set _win [lindex [split $_item ,] 0]
            set _lost [lindex [split $_item ,] 1]
            set _shots [lindex [split $_item ,] 2]
            set _spins [lindex [split $_item ,] 3]
            set _played [lindex [split $_item ,] 4]
            if {[strlwr $who]==[strlwr $_nick]} {
                append _newscores "[expr $_win $win],[expr $_lost $loss],[expr $_shots $shots],[expr $_spins $spins],[expr $_played $played],$_nick "
            } else {
                append _newscores "$_win,$_lost,$_shots,$_spins,$_played,$_nick "
            }
            incr i
        }
    } else {
        append _newscores "0,0,0,0,0,$who "
    }
    set _sfile [open $scorefile w]
    puts $_sfile "$_newscores"
    close $_sfile
    return 0
}

proc show_score {text} {
    global rrscoresbyname rrscores playerstat
    get_scores
    set idx [lsearch -glob $rrscores "*,*,*,*,*,$text"]
    putlog "[lindex $rrscores $idx]"
    set _item [lindex $rrscores $idx]
    set _nick [lindex [split $_item ,] 5]
    set _win [lindex [split $_item ,] 0]
    set _lost [lindex [split $_item ,] 1]
    set _shots [lindex [split $_item ,] 2]
    set _played [lindex [split $_item ,] 4]
    set playerstat "$_nick played $_played games, won $_win, lost $_lost, took $_shots shots"
    return
}

proc showall {nick uhost handle chan arg} {
    global botnick scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
                                                 289,9         80%
proc showall {nick uhost handle chan arg} {
    global botnick scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
    get_scores
    set totallength 16
    if {$rrscorestotal>0} {
        putquick "PRIVMSG $nick :*****************Roulette Scores**********************"
        putquick "PRIVMSG $nick :**| NickName        | Total |  Won  | Lost | Shots |**"
        putquick "PRIVMSG $nick :**|-----------------|-------|-------|------|-------|**"
        set i 0
        while {$i<[expr [llength $rrscores] - 1]} {
            set checked 0
            set _item [lindex $rrscores $i]
            set _nick [lindex [split $_item ,] 5]
            set _win [lindex [split $_item ,] 0]
            if {$_win < 10} {
                set _win "   $_win   "
                } elseif {$_win < 100} {
                    set _win "   $_win  "
                    }
            set _lost [lindex [split $_item ,] 1]
            if {$_lost < 10} {
                set _lost "   $_lost  "
                } elseif {$_lost < 100} {
                    set _lost "  $_lost  "
                    }
            set _shots [lindex [split $_item ,] 2]
            if {$_shots < 10} {
                set _shots "   $_shots   "
                } elseif {$_shots < 100} {
                    set _shots "   $_shots  "
                    }
            set _played [lindex [split $_item ,] 4]
            if {$_played < 10} {
                set _played "   $_played   "
                } elseif {$_played < 100} {
                    set _played "   $_played  "
                    }
            set checknick [split $_nick ""]
            set who [lindex [split $nick "|"] 0]
            set who [lindex [split $who "_"] 0]
            if {[string tolower $who] == [string tolower $_nick]} {set checked 1}
            set long [llength $checknick]
                                                 329,1         91%
            if {[string tolower $who] == [string tolower $_nick]} {set checked 1}
            set long [llength $checknick]
            set spaces ""
            for {set i2 $long} {$i2 < $totallength} {incr i2} {
                append spaces " "
            }
            if {$checked == 1} {
                putquick "PRIVMSG $nick :**| $_nick$spaces|$_played|$_win|$_lost|$_shots|**"
            } else {
                putquick "PRIVMSG $nick :**| $_nick$spaces|$_played|$_win|$_lost|$_shots|**"
            }
            incr i
        }
        putquick "PRIVMSG $nick :********************End off list**********************"
    }
    return 0
}


proc show_player_score {nick host handle chan arg} {
    global rrscoresbyname rrscores playerstat
     if {$arg == ""} { set arg $nick } else { set arg [lindex [split $arg " "] 0] }
     show_score $arg
     puthelp "PRIVMSG $chan : $playerstat"
     return 1
}

proc started {} {
    putlog "starttimer ended"
}


proc tggamemsg {what} {global rrchannel;putquick "PRIVMSG $rrchannel :[tgbold]$what"}
putlog "Killer Roulette by YourMomma LOADED!!"
