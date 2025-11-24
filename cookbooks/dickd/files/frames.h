const char *penis_frames[] = {
"\x1b[H\x1b[2J",
// FRAME 1
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`lllllllle.\
\x1b[11;1H       .;;;`:lllll;;lle'.\
\x1b[12;1H      ; \",'`::llllllllle+\
\x1b[13;1H      ,.';`: :llllllllllle`\
\x1b[14;1H      \"'`:'\" ;eee@@ellllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.llllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*llllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*lllllle!\
\x1b[18;1H       ;;';';@@@@@@@@'#OOOOOOo\"\
\x1b[19;1H       ';';  ~@@@@@~ !OOOOOOOOo\
\x1b[20;1H                     !OOOOOOOO#\
\x1b[21;1H                     'OOOOOOOO'\
\x1b[22;1H                      \"#OOOO#'\
\x1b[23;1H                         \"~",

// FRAME 2
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`lllllllle.\
\x1b[11;1H       .;;;`:lllll;;lle'.\
\x1b[12;1H      ; \",'`::llllllllle+\
\x1b[13;1H      ,.';`: :llllllllllle`\
\x1b[14;1H      \"'`:'\" ;eee@@ellllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.llllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*llllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*lllllle!\
\x1b[18;1H       ;;';';@@@@@@@@'#OOOOOOo\"\
\x1b[19;1H       ';';  ~@@@@@~ !OOOOOOOOo\
\x1b[20;1H                     !OOOOOOOO#\
\x1b[21;1H                     'OOOOOOOO'\
\x1b[22;1H                      \"#OOOO#'\
\x1b[23;1H                         \"~",

// FRAME 3
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`lllllllle.\
\x1b[11;1H       .;;;`:lllll;;lle'.\
\x1b[12;1H      ; \",'`::lllllllllle+\
\x1b[13;1H      ,.';`: :lllllllllllle`\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.lllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*lllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*llllllle!\
\x1b[18;1H       ;;';';@@@@@@@@'#oOOOOOOo\"\
\x1b[19;1H       ';';  ~@@@@@~  !OOOOOOOOo\
\x1b[20;1H                      !OOOOOOOO#\
\x1b[21;1H                      `OOOOOOOO'\
\x1b[22;1H                       \"#OOOO#'\
\x1b[23;1H                          \"~",

// FRAME 4
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`lllllllle.\
\x1b[11;1H       .;;;`:lllll;;lle'.\
\x1b[12;1H      ; \",'`::lllllllllle+\
\x1b[13;1H      ,.';`: :lllllllllllle`\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.lllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*lllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*llllllle!\
\x1b[18;1H       ;;';';@@@@@@@@'#oOOOOOOo\"\
\x1b[19;1H       ';';  ~@@@@@~  !OOOOOOOOo\
\x1b[20;1H                      !OOOOOOOO#\
\x1b[21;1H                      `OOOOOOOO'\
\x1b[22;1H                       \"#OOOO#'\
\x1b[23;1H                          \"~",

// FRAME 5
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`lllllllle.\
\x1b[11;1H       .;;;`:lllll;;lle'.\
\x1b[12;1H      ; \",'`::lllllllllle+\
\x1b[13;1H      ,.';`: :lllllllllllle`\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.llllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*llllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*lllllllle!\
\x1b[18;1H       ;;';';@@@@@@@@@#\"oOOOOOOOo`\
\x1b[19;1H       ';';  ~@@@@@~   !OOOOOOOOO)\
\x1b[20;1H                       `OOOOOOOOO%\
\x1b[21;1H                        \"OOOOOOOO'\
\x1b[22;1H                         \"OOOOO#'\
\x1b[23;1H                            ~~",

// FRAME 6
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`lllllllle.\
\x1b[11;1H       .;;;`:lllll;;lle'.\
\x1b[12;1H      ; \",'`::lllllllllle+\
\x1b[13;1H      ,.';`: :lllllllllllle`\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.llllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*llllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*lllllllle!\
\x1b[18;1H       ;;';';@@@@@@@@@#\"oOOOOOOOo`\
\x1b[19;1H       ';';  ~@@@@@~   !OOOOOOOOO)\
\x1b[20;1H                       `OOOOOOOOO%\
\x1b[21;1H                        \"OOOOOOOO'\
\x1b[22;1H                         \"OOOOO#'\
\x1b[23;1H                            ~~",

// FRAME 7
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`llllllllle.\
\x1b[11;1H       .;;;`:llllll;;lle'.\
\x1b[12;1H      ; \",'`::lllllllllllle\
\x1b[13;1H      ,.';`: :llllllllllllle\\\
\x1b[14;1H      \"'`:'\" ;eee@@ellllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.lllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*lllllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@* !llllllLLL.\
\x1b[18;1H       ;;';';@@@@@@@@, \".oo#OOOOOO\
\x1b[19;1H       ';';  ~@@@@@~    !OOOOOOOOOO\
\x1b[20;1H                        `OOOOOOOOOO\
\x1b[21;1H                         \"OOOOOOOO'\
\x1b[22;1H                          \"OOOOO#'\
\x1b[23;1H                            ~~'` ",

// FRAME 8
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`llllllllle.\
\x1b[11;1H       .;;;`:llllll;;lle'.\
\x1b[12;1H      ; \",'`::lllllllllllle\
\x1b[13;1H      ,.';`: :llllllllllllle\\\
\x1b[14;1H      \"'`:'\" ;eee@@ellllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.lllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*lllllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@* !llllllLLL.\
\x1b[18;1H       ;;';';@@@@@@@@, \".oo#OOOOOO\
\x1b[19;1H       ';';  ~@@@@@~    !OOOOOOOOOO\
\x1b[20;1H                        `OOOOOOOOOO\
\x1b[21;1H                         \"OOOOOOOO'\
\x1b[22;1H                          \"OOOOO#'\
\x1b[23;1H                            ~~'` ",

// FRAME 9
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`llllllllle.\
\x1b[11;1H       .;;;`:llllll;;lle'.\
\x1b[12;1H      ; \",'`::llllllllllllle\
\x1b[13;1H      ,.';`: :lllllllllllllle\\\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.elllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@* elllllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*   !LLLl.***.\
\x1b[18;1H       ;;';';@@@@@@@@'    e'oOOOOOOo.\
\x1b[19;1H       ';';  ~@@@@@~      !OOOOOOOOOo.\
\x1b[20;1H                          `OOOOOOOOOO\
\x1b[21;1H                           \"OOOOOOOO'\
\x1b[22;1H                            \"OOOOO#'\
\x1b[23;1H                               ~~`  ",

// FRAME 10
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`llllllllle.\
\x1b[11;1H       .;;;`:llllll;;lle'.\
\x1b[12;1H      ; \",'`::llllllllllllle\
\x1b[13;1H      ,.';`: :lllllllllllllle\\\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.elllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@* elllllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*   !LLLl.***.\
\x1b[18;1H       ;;';';@@@@@@@@'    e'oOOOOOOo.\
\x1b[19;1H       ';';  ~@@@@@~      !OOOOOOOOOo.\
\x1b[20;1H                          `OOOOOOOOOO\
\x1b[21;1H                           \"OOOOOOOO'\
\x1b[22;1H                            \"OOOOO#'\
\x1b[23;1H                               ~~`  ",

// FRAME 11
"\x1b[8;1H      ;,,.\
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`llllllllle.\
\x1b[11;1H       .;;;`:llllll;;lle'.\
\x1b[12;1H      ; \",'`::llllllllllllle\
\x1b[13;1H      ,.';`: :lllllllllllllle\\\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.`elllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*  `ellllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*   `!LLLlloo**,  \
\x1b[18;1H       ;;';';@@@@@@@@'     `loOOOOOOOO.\
\x1b[19;1H       ';';  ~@@@@@~        `OOOOOOOOOO.\
\x1b[20;1H                             `OOOOOOOOO'\
\x1b[21;1H                              `OOOOOOOO'\
\x1b[22;1H                               `\"*OOO*'\
\x1b[23;1H                                    ",

// FRAME 12
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`llllllllle.\
\x1b[11;1H       .;;;`:llllll;;lle'.\
\x1b[12;1H      ; \",'`::llllllllllllle\
\x1b[13;1H      ,.';`: :lllllllllllllle\\\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.`elllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*  `ellllllle!\
\x1b[17;1H       ';,.@@@@@@@@@@*   `!LLLlloo**,  \
\x1b[18;1H       ;;';';@@@@@@@@'     `loOOOOOOOO.\
\x1b[19;1H       ';';  ~@@@@@~        `OOOOOOOOOO.\
\x1b[20;1H                             `OOOOOOOOO'\
\x1b[21;1H                              `OOOOOOOO'\
\x1b[22;1H                               `\"*OOO*'\
\x1b[23;1H                                    ",

// FRAME 13
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`lllllllllle.\
\x1b[11;1H       .;;;`:llllll;;lllle.\
\x1b[12;1H      ; \",'`::lllllllllllllle.\
\x1b[13;1H      ,.';`: :lllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@. `ellllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*   `ellllllllle.\
\x1b[17;1H       ';,.@@@@@@@@@@*    `ellllhoOOOOOo\
\x1b[18;1H       ;;';';@@@@@@@@'      `IToOOOOOOOOO\
\x1b[19;1H       ';';  ~@@@@@~          `OOOOOOOOOO\"\
\x1b[20;1H                               `OOOOOOOOO\"\
\x1b[21;1H                                `OOOOOOOO'\
\x1b[22;1H                                  `\"*OO*'",

// FRAME 14
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeee.\
\x1b[10;1H      .,;,,.`lllllllllle.\
\x1b[11;1H       .;;;`:llllll;;lllle.\
\x1b[12;1H      ; \",'`::lllllllllllllle.\
\x1b[13;1H      ,.';`: :lllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@. `ellllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*   `ellllllllle.\
\x1b[17;1H       ';,.@@@@@@@@@@*    `ellllhoOOOOOo\
\x1b[18;1H       ;;';';@@@@@@@@'      `IToOOOOOOOOO\
\x1b[19;1H       ';';  ~@@@@@~          `OOOOOOOOOO\"\
\x1b[20;1H                               `OOOOOOOOO\"\
\x1b[21;1H                                `OOOOOOOO'\
\x1b[22;1H                                  `\"*OO*'",

// FRAME 15
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeee:,.\
\x1b[10;1H      .,;,,.`llllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;lllle:.\
\x1b[12;1H      ; \",'`::lllllllllllllle:.\
\x1b[13;1H      ,.';`: :lllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.  `elllllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*    `ellllllllhhe.\
\x1b[17;1H       ';,.@@@@@@@@@@*      `ellllhoOOOOOo.\
\x1b[18;1H       ;;';';@@@@@@@@'        `IloOOOOOOOOOo\
\x1b[19;1H       ';';  ~@@@@@~            `oOOOOOOOOOO\
\x1b[20;1H                                 `OOOOOOOOOO\
\x1b[21;1H                                   `OOOOOOO\"\
\x1b[22;1H                                     `~*\"''",

// FRAME 16
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeee:,.\
\x1b[10;1H      .,;,,.`llllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;lllle:.\
\x1b[12;1H      ; \",'`::lllllllllllllle:.\
\x1b[13;1H      ,.';`: :lllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.  `elllllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*    `ellllllllhhe.\
\x1b[17;1H       ';,.@@@@@@@@@@*      `ellllhoOOOOOo.\
\x1b[18;1H       ;;';';@@@@@@@@'        `IloOOOOOOOOOo\
\x1b[19;1H       ';';  ~@@@@@~            `oOOOOOOOOOO\
\x1b[20;1H                                 `OOOOOOOOOO\
\x1b[21;1H                                   `OOOOOOO\"\
\x1b[22;1H                                     `~*\"''",

// FRAME 17
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeee,.\
\x1b[10;1H      .,;,,.`lllllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;llllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.  `\"elllllllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*      `ellllllleoOOOo.\
\x1b[17;1H       ';,.@@@@@@@@@@*        `ellleOOOOOOOOo \
\x1b[18;1H       ;;';';@@@@@@@@'          `IeOOOOOOOOOO'\
\x1b[19;1H       ';';  ~@@@@@~              `OOOOOOOOOO\"\
\x1b[20;1H                                   `*OOOOOOOO'\
\x1b[21;1H                                     `~*OO*\"'\
\x1b[22;1H                                                     ",

// FRAME 18
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeee,.\
\x1b[10;1H      .,;,,.`lllllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;llllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.  `\"elllllllllllle.\
\x1b[16;1H      ';,'.:%%@@@@@@@*      `ellllllleoOOOo.\
\x1b[17;1H       ';,.@@@@@@@@@@*        `ellleOOOOOOOOo \
\x1b[18;1H       ;;';';@@@@@@@@'          `IeOOOOOOOOOO'\
\x1b[19;1H       ';';  ~@@@@@~              `OOOOOOOOOO\"\
\x1b[20;1H                                   `*OOOOOOOO'\
\x1b[21;1H                                     `~*OO*\"'\
\x1b[22;1H                                                     ",

// FRAME 19
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeee,.\
\x1b[10;1H      .,;,,.`llllllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;lllllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@ellllllllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.  `\"\"ellllllllllllee.\
\x1b[16;1H      ';,'.:%%@@@@@@@*       `ellllllloOOOOOo.\
\x1b[17;1H       ';,.@@@@@@@@@@*         `ellleOOOOOOOOOo \
\x1b[18;1H       ;;';';@@@@@@@@'           `eleOOOOOOOOOO' \
\x1b[19;1H       ';';  ~@@@@@~                `OOOOOOOOOO'  \
\x1b[20;1H                                      `OOOOOOOO'  \
\x1b[21;1H                                         `\"\"\"' ",

// FRAME 20
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeee,.\
\x1b[10;1H      .,;,,.`llllllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;lllllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@ellllllllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.  `\"\"ellllllllllllee.\
\x1b[16;1H      ';,'.:%%@@@@@@@*       `ellllllloOOOOOo.\
\x1b[17;1H       ';,.@@@@@@@@@@*         `ellleOOOOOOOOOo \
\x1b[18;1H       ;;';';@@@@@@@@'           `eleOOOOOOOOOO' \
\x1b[19;1H       ';';  ~@@@@@~                `OOOOOOOOOO'  \
\x1b[20;1H                                      `OOOOOOOO'  \
\x1b[21;1H                                         `\"\"\"' ",

// FRAME 21
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeee,.\
\x1b[10;1H      .,;,,.`lllllllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;lllllllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllllllllllllle..\
\x1b[15;1H      ,;';'':%@@@@@@@.   `\"elllllllllllllooOo.\
\x1b[16;1H      ';,'.:%%@@@@@@@*        `ellllllloOOOOOOOo.\
\x1b[17;1H       ';,.@@@@@@@@@@*           `elll(OOOOOOOOOO  \
\x1b[18;1H       ;;';';@@@@@@@@'              `e\"OOOOOOOOOOO  \
\x1b[19;1H       ';';  ~@@@@@~                   `OOOOOOOOOO' \
\x1b[20;1H                                         `OOOOOOO\"\
\x1b[21;1H                                           ``~~'`",

// FRAME 22
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeee,.\
\x1b[10;1H      .,;,,.`lllllllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;lllllllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@elllllllllllllllllllle..\
\x1b[15;1H      ,;';'':%@@@@@@@.   `\"elllllllllllllooOo.\
\x1b[16;1H      ';,'.:%%@@@@@@@*        `ellllllloOOOOOOOo.\
\x1b[17;1H       ';,.@@@@@@@@@@*           `elll(OOOOOOOOOO  \
\x1b[18;1H       ;;';';@@@@@@@@'              `e\"OOOOOOOOOOO  \
\x1b[19;1H       ';';  ~@@@@@~                   `OOOOOOOOOO' \
\x1b[20;1H                                         `OOOOOOO\"\
\x1b[21;1H                                           ``~~'`",

// FRAME 23
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeee.\
\x1b[10;1H      .,;,,.`llllllllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;llllllllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@eelllllllllllllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.   ``\"elllllllllllooOOOOOo.\
\x1b[16;1H      ';,'.:%%@@@@@@@*        ``elllllloOOOOOOOOOo.\
\x1b[17;1H       ';,.@@@@@@@@@@*            `ellloOOOOOOOOOOO\
\x1b[18;1H       ;;';';@@@@@@@@'               `e\"OOOOOOOOOOO\
\x1b[19;1H       ';';  ~@@@@@~                    `(OOOOOOOOO\
\x1b[20;1H                                          `\"*OOO*'\
\x1b[21;1H                                                       ",

// FRAME 24
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeee..\
\x1b[10;1H      .,;,,.`llllllllllllle:\\\
\x1b[11;1H       .;;;`:llllll;;llllllllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllle.\
\x1b[14;1H      \"'`:'\" ;eee@@eelllllllllllllllllllllle.\
\x1b[15;1H      ,;';'':%@@@@@@@.   ``\"elllllllllllooOOOOOo.\
\x1b[16;1H      ';,'.:%%@@@@@@@*        ``elllllloOOOOOOOOOo.\
\x1b[17;1H       ';,.@@@@@@@@@@*            `ellloOOOOOOOOOOO\
\x1b[18;1H       ;;';';@@@@@@@@'               `e\"OOOOOOOOOOO\
\x1b[19;1H       ';';  ~@@@@@~                    `(OOOOOOOOO\
\x1b[20;1H                                          `\"*OOO*'\
\x1b[21;1H                                                       ",

// FRAME 25
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeeee.\
\x1b[10;1H      .,;,,.`llllllllllllllle.\
\x1b[11;1H       .;;;`:llllll;;lllllllllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllllllee.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeelllllllllllllllloOOOOOOo.\
\x1b[15;1H      ,;';'':%@@@@@@@.      `\"elllllllloOOOOOOOOOO.\
\x1b[16;1H      ';,'.:%%@@@@@@@*           `ellloOOOOOOOOOOOO'\
\x1b[17;1H       ';,.@@@@@@@@@@*               `elOOOOOOOOOOOO.\
\x1b[18;1H       ;;';';@@@@@@@@'                  `OOOOOOOOOOO.\
\x1b[19;1H       ';';  ~@@@@@~                       `\"*OOOO*'\
\x1b[20;1H                                                   ",

// FRAME 26
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeeee.\
\x1b[10;1H      .,;,,.`llllllllllllllle.\
\x1b[11;1H       .;;;`:llllll;;lllllllllllle.\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllle.\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllllllee.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeelllllllllllllllloOOOOOOo.\
\x1b[15;1H      ,;';'':%@@@@@@@.      `\"elllllllloOOOOOOOOOO.\
\x1b[16;1H      ';,'.:%%@@@@@@@*           `ellloOOOOOOOOOOOO'\
\x1b[17;1H       ';,.@@@@@@@@@@*               `elOOOOOOOOOOOO.\
\x1b[18;1H       ;;';';@@@@@@@@'                  `OOOOOOOOOOO.\
\x1b[19;1H       ';';  ~@@@@@~                       `\"*OOOO*'\
\x1b[20;1H                                                   ",

// FRAME 27
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeeeee..\
\x1b[10;1H      .,;,,.`llllllllllllllllee...\
\x1b[11;1H       .;;;`:llllll;;llllllllllllllee...\
\x1b[12;1H      ; \",'`::llllllllllllllllllllllllllle.o.\
\x1b[13;1H      ,.';`: :lllllllllllllllllllllllllloOOOOOOo.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeeelllllllllllllloOOOOOOOOOO.\
\x1b[15;1H      ,;';'':%@@@@@@@.        ``\"ellllloOOOOOOOOOOOo  \
\x1b[16;1H      ';,'.:%%@@@@@@@*             ``ellOOOOOOOOOOOO\"   \
\x1b[17;1H       ';,.@@@@@@@@@@*                 ``*OOOOOOOOOO' \
\x1b[18;1H       ;;';';@@@@@@@@'                    `\"*OOOOOO\" \
\x1b[19;1H       ';';  ~@@@@@~                           ~~    ",

// FRAME 28
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeeeee..\
\x1b[10;1H      .,;,,.`llllllllllllllllee...\
\x1b[11;1H       .;;;`:llllll;;llllllllllllllee...\
\x1b[12;1H      ; \",'`::llllllllllllllllllllllllllle.o.\
\x1b[13;1H      ,.';`: :lllllllllllllllllllllllllloOOOOOOo.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeeelllllllllllllloOOOOOOOOOO.\
\x1b[15;1H      ,;';'':%@@@@@@@.        ``\"ellllloOOOOOOOOOOOo  \
\x1b[16;1H      ';,'.:%%@@@@@@@*             ``ellOOOOOOOOOOOO\"   \
\x1b[17;1H       ';,.@@@@@@@@@@*                 ``*OOOOOOOOOO' \
\x1b[18;1H       ;;';';@@@@@@@@'                    `\"*OOOOOO\" \
\x1b[19;1H       ';';  ~@@@@@~                           ~~    \
\x1b[8;1H      ;,,.         ",

// FRAME 29
"\x1b[9;1H      .;,,:,;`eeeeeeeeeeeee...\
\x1b[10;1H      .,;,,.`llllllllllllllllllle...\
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllle..\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllllll..oo..\
\x1b[13;1H      ,.';`: :lllllllllllllllllllllllllllloOOOOOOOo.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeeeellllllllllllllloOOOOOOOOOO.\
\x1b[15;1H      ,;';'':%@@@@@@@.        ``\"elllllll*OOOOOOOOOOO.  \
\x1b[16;1H      ';,'.:%%@@@@@@@*                `\"l`OOOOOOOOOOOO\
\x1b[17;1H       ';,.@@@@@@@@@@*                    `OOOOOOOOOO\"\
\x1b[18;1H       ;;';';@@@@@@@@'                      `\"~*OOO*~' \
\x1b[19;1H       ';';  ~@@@@@~                                    ",

// FRAME 30
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeeeeeee...\
\x1b[10;1H      .,;,,.`llllllllllllllllllle...\
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllle..\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllllll..oo..\
\x1b[13;1H      ,.';`: :lllllllllllllllllllllllllllloOOOOOOOo.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeeeellllllllllllllloOOOOOOOOOO.\
\x1b[15;1H      ,;';'':%@@@@@@@.        ``\"elllllll*OOOOOOOOOOO.\
\x1b[16;1H      ';,'.:%%@@@@@@@*                `\"l`OOOOOOOOOOOO\
\x1b[17;1H       ';,.@@@@@@@@@@*                    `OOOOOOOOOO\"\
\x1b[18;1H       ;;';';@@@@@@@@'                      `\"~*OOO*~' \
\x1b[19;1H       ';';  ~@@@@@~                                    ",

// FRAME 31
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeeeeeee....\
\x1b[10;1H      .,;,,.`lllllllllllllllllllllee..\
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllllll.--.\
\x1b[12;1H      ; \",'`::llllllllllllllllllllllllllllOOOOOOo.\
\x1b[13;1H      ,.';`: :lllllllllllllllllllllllllllOOOOOOOOOOo.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeeeelllllllllllllllOOOOOOOOOOOOo\
\x1b[15;1H      ,;';'':%@@@@@@@.          ``\"~ellllOOOOOOOOOOOOO. \
\x1b[16;1H      ';,'.:%%@@@@@@@*                  `\"OOOOOOOOOOOO. \
\x1b[17;1H       ';,.@@@@@@@@@@*                     `\"~OOOOOOO~ \
\x1b[18;1H       ;;';';@@@@@@@@'                          `\"~\"   \
\x1b[19;1H       ';';  ~@@@@@~                                          ",

// FRAME 32
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeeeeeee....\
\x1b[10;1H      .,;,,.`lllllllllllllllllllllee..\
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllllll.--.\
\x1b[12;1H      ; \",'`::llllllllllllllllllllllllllllOOOOOOo.\
\x1b[13;1H      ,.';`: :lllllllllllllllllllllllllllOOOOOOOOOOo.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeeeelllllllllllllllOOOOOOOOOOOOo\
\x1b[15;1H      ,;';'':%@@@@@@@.          ``\"~ellllOOOOOOOOOOOOO. \
\x1b[16;1H      ';,'.:%%@@@@@@@*                  `\"OOOOOOOOOOOO. \
\x1b[17;1H       ';,.@@@@@@@@@@*                     `\"~OOOOOOO~ \
\x1b[18;1H       ;;';';@@@@@@@@'                          `\"~\"   \
\x1b[19;1H       ';';  ~@@@@@~                                          ",

// FRAME 33
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeeeeeeee.........\
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllleeoOOOOo.  \
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllloOOOOOOOOOo. \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllloOOOOOOOOOOOo. \
\x1b[13;1H      ,.';`: :lllllllllllllllllllllllllloOOOOOOOOOOOOo.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeeeellllllllllllllloOOOOOOOOOOOOO   \
\x1b[15;1H      ,;';'':%@@@@@@@.            ````\"\"\"\"`\"OOOOOOOOOo.    \
\x1b[16;1H      ';,'.:%%@@@@@@@*                        `\"~***\".     \
\x1b[17;1H       ';,.@@@@@@@@@@*                                     \
\x1b[18;1H       ;;';';@@@@@@@@'                                              \
\x1b[19;1H       ';';  ~@@@@@~                                          ",

// FRAME 34
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeeeeeeeeee.........\
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllleeoOOOOo.\
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllloOOOOOOOOOo.\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllloOOOOOOOOOOOo.\
\x1b[13;1H      ,.';`: :lllllllllllllllllllllllllloOOOOOOOOOOOOo.\
\x1b[14;1H      \"'`:'\" ;eee@@eeeeeeellllllllllllllloOOOOOOOOOOOOO  \
\x1b[15;1H      ,;';'':%@@@@@@@.            ````\"\"\"\"`\"OOOOOOOOOo.   \
\x1b[16;1H      ';,'.:%%@@@@@@@*                        `\"~***\".   \
\x1b[17;1H       ';,.@@@@@@@@@@*                                     \
\x1b[18;1H       ;;';';@@@@@@@@'                                              \
\x1b[19;1H       ';';  ~@@@@@~                                          ",

// FRAME 35
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeee..................   oooooo..           \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllllllloOOOOOOOOOoo.           \
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllllOOOOOOOOOOOOo.        \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllllOOOOOOOOOOOOOOo.     \
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllllllOOOOOOOOOOOOOo.   \
\x1b[14;1H      \"'`:'\" ;eee@@e~~~~~~~~~~~~~~~~~~~~~~~~*OOOOOOOOO*~     \
\x1b[15;1H      ,;';'':%@@@@@@@.                           ````          \
\x1b[16;1H      ';,'.:%%@@@@@@@*                                 \
\x1b[17;1H       ';,.@@@@@@@@@@*\
\x1b[18;1H       ;;';';@@@@@@@@'  \
\x1b[19;1H       ';';  ~@@@@@~ ",

// FRAME 36
"\x1b[8;1H      ;,,.         \
\x1b[9;1H      .;,,:,;`eeeeeee..................   oooooo..\
\x1b[10;1H      .,;,,.`llllllllllllllllllllllllllloOOOOOOOOOoo.\
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllllOOOOOOOOOOOOo.\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllllOOOOOOOOOOOOOOo.\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllllllOOOOOOOOOOOOOo.\
\x1b[14;1H      \"'`:'\" ;eee@@e~~~~~~~~~~~~~~~~~~~~~~~~*OOOOOOOOO*~ \
\x1b[15;1H      ,;';'':%@@@@@@@.                           ````          \
\x1b[16;1H      ';,'.:%%@@@@@@@* \
\x1b[17;1H       ';,.@@@@@@@@@@*\
\x1b[18;1H       ;;';';@@@@@@@@'  \
\x1b[19;1H       ';';  ~@@@@@~ ",

// FRAME 37
"\x1b[8;1H      ;,,.                                  _____\
\x1b[9;1H      .;,,:,;`eeeeeeeeeeeeeeeeeeeeeeeeee *oOOOOOOOo.\
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllll OOOOOOOOOOOOo\
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll OOOOOOOOOOOOOOo\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllll OOOOOOOOOOOOOO,\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllllll #OOOOOOOOOOOo\
\x1b[14;1H      \"'`:'\" ;eee@@ee\"\"\"~~~```                `~\"\"\"~`   \
\x1b[15;1H      ,;';'':%@@@@@@@.                                    \
\x1b[16;1H      ';,'.:%%@@@@@@@*\
\x1b[17;1H       ';,.@@@@@@@@@@*\
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~",

// FRAME 38
"\x1b[8;1H      ;,,.                                  _____\
\x1b[9;1H      .;,,:,;`eeeeeeeeeeeeeeeeeeeeeeeeee *oOOOOOOOo.\
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllll OOOOOOOOOOOOo\
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll OOOOOOOOOOOOOOo\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllll OOOOOOOOOOOOOO,\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllllll #OOOOOOOOOOOo\
\x1b[14;1H      \"'`:'\" ;eee@@ee\"\"\"~~~```                `~\"\"\"~`   \
\x1b[15;1H      ,;';'':%@@@@@@@.                                    \
\x1b[16;1H      ';,'.:%%@@@@@@@*\
\x1b[17;1H       ';,.@@@@@@@@@@*\
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~",

// FRAME 39
"\x1b[8;1H      ;,,.                            __  oooooo..\
\x1b[9;1H      .;,,:,;`eeeeeeeeeeeeelllllllllllll OOOOOOOOOOo.\
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllll OOOOOOOOOOOOOo\
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll OOOOOOOOOOOOOOO\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllll OOOOOOOOOOOOOo\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllllll *OOOOOOOO*~'   \
\x1b[14;1H      \"'`:'\" ;eee@@ee\"\"~~~```                                \
\x1b[15;1H      ,;';'':%@@@@@@@. \
\x1b[16;1H      ';,'.:%%@@@@@@@*   \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@'  \
\x1b[19;1H       ';';  ~@@@@@~    ",

// FRAME 40
"\x1b[8;1H      ;,,.                            __  oooooo..\
\x1b[9;1H      .;,,:,;`eeeeeeeeeeeeelllllllllllll OOOOOOOOOOo.\
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllll OOOOOOOOOOOOOo\
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll OOOOOOOOOOOOOOO\
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllll OOOOOOOOOOOOOo\
\x1b[13;1H      ,.';`: :llllllllllllllllllllllllllll *OOOOOOOO*~'\
\x1b[14;1H      \"'`:'\" ;eee@@ee\"\"~~~```                                \
\x1b[15;1H      ,;';'':%@@@@@@@. \
\x1b[16;1H      ';,'.:%%@@@@@@@*   \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@'  \
\x1b[19;1H       ';';  ~@@@@@~    ",

// FRAME 41
"\x1b[7;1H                                            ___          \
\x1b[8;1H      ;,,.                        ...eee oOOOOOoo.        \
\x1b[9;1H      .;,,:,;`eeeeeeelllllllllllllllllll OOOOOOOOOOo.      \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllll OOOOOOOOOOOOO.    \
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll (OOOOOOOOOOOOOo    \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllll #OOOOOOOOOOO,`     \
\x1b[13;1H      ,.';`: :llllllllllllllllllleee\"\"\"\"\"\" \"***\"\"\"\"~` \
\x1b[14;1H      \"'`:'\" ;eee@@ee\"\"~~``                                \
\x1b[15;1H      ,;';'':%@@@@@@@.\
\x1b[16;1H      ';,'.:%%@@@@@@@* \
\x1b[17;1H       ';,.@@@@@@@@@@*\
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~ ",

// FRAME 42
"\x1b[7;1H                                            ___\
\x1b[8;1H      ;,,.                        ...eee oOOOOOoo.     \
\x1b[9;1H      .;,,:,;`eeeeeeelllllllllllllllllll OOOOOOOOOOo. \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllll OOOOOOOOOOOOO. \
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll (OOOOOOOOOOOOOo \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllll #OOOOOOOOOOO,` \
\x1b[13;1H      ,.';`: :llllllllllllllllllleee\"\"\"\"\"\" \"***\"\"\"\"~` \
\x1b[14;1H      \"'`:'\" ;eee@@ee\"\"~~``                                \
\x1b[15;1H      ,;';'':%@@@@@@@.\
\x1b[16;1H      ';,'.:%%@@@@@@@* \
\x1b[17;1H       ';,.@@@@@@@@@@*\
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~ ",

// FRAME 43
"\x1b[7;1H                                     _      ...\
\x1b[8;1H      ;,,.                  ...eeeeeee  oOOOOOOOo.      \
\x1b[9;1H      .;,,:,;`eeeeeeeeellllllllllllllll OOOOOOOOOOOo.  \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllllll OOOOOOOOOOOOOO.    \
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll OOOOOOOOOOOOOO    \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllll \\OOOOOOOOOO\"      \
\x1b[13;1H      ,.';`: :lllllllllllllleeee\"\"\"\"\"\"\"``      ```         \
\x1b[14;1H      \"'`:'\" ;eee@@ee~``                                     \
\x1b[15;1H      ,;';'':%@@@@@@@. \
\x1b[16;1H      ';,'.:%%@@@@@@@*\
\x1b[17;1H       ';,.@@@@@@@@@@* \
\x1b[18;1H       ;;';';@@@@@@@@'\
\x1b[19;1H       ';';  ~@@@@@~  ",

// FRAME 44
"\x1b[7;1H                                     _      ...\
\x1b[8;1H      ;,,.                  ...eeeeeee  oOOOOOOOo.      \
\x1b[9;1H      .;,,:,;`eeeeeeeeellllllllllllllll OOOOOOOOOOOo.  \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllllll OOOOOOOOOOOOOO.  \
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll OOOOOOOOOOOOOO   \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllllll \\OOOOOOOOOO\"  \
\x1b[13;1H      ,.';`: :lllllllllllllleeee\"\"\"\"\"\"\"``      ```         \
\x1b[14;1H      \"'`:'\" ;eee@@ee~``                                     \
\x1b[15;1H      ,;';'':%@@@@@@@. \
\x1b[16;1H      ';,'.:%%@@@@@@@*\
\x1b[17;1H       ';,.@@@@@@@@@@* \
\x1b[18;1H       ;;';';@@@@@@@@'\
\x1b[19;1H       ';';  ~@@@@@~  ",

// FRAME 45
"\x1b[7;1H                                     _  .ooooo.. \
\x1b[8;1H      ;,,.                 ...eeeellll oOOOOOOOOOOo.       \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOOOOOo.   \
\x1b[10;1H     .,;,,.`llllllllllllllllllllllllll OOOOOOOOOOOOOOO   \
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll OOOOOOOOOOOOO)    \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllleel \"OOOOOO*\"\"``    \
\x1b[13;1H      ,.';`: :lllllllllleeee\"\"\"\"`                            \
\x1b[14;1H      \"'`:'\" ;eee@@el\"  \
\x1b[15;1H      ,;';'':%@@@@@@@.   \
\x1b[16;1H      ';,'.:%%@@@@@@@*              \
\x1b[17;1H       ';,.@@@@@@@@@@*   \
\x1b[18;1H       ;;';';@@@@@@@@'   \
\x1b[19;1H       ';';  ~@@@@@~   ",

// FRAME 46
"\x1b[7;1H                                     _  .ooooo.. \
\x1b[8;1H      ;,,.                 ...eeeellll oOOOOOOOOOOo.       \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOOOOOo.   \
\x1b[10;1H     .,;,,.`llllllllllllllllllllllllll OOOOOOOOOOOOOOO   \
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllllll OOOOOOOOOOOOO)    \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllleel \"OOOOOO*\"\"``    \
\x1b[13;1H      ,.';`: :lllllllllleeee\"\"\"\"`   \
\x1b[14;1H      \"'`:'\" ;eee@@el\"  \
\x1b[15;1H      ,;';'':%@@@@@@@.   \
\x1b[16;1H      ';,'.:%%@@@@@@@*              \
\x1b[17;1H       ';,.@@@@@@@@@@*   \
\x1b[18;1H       ;;';';@@@@@@@@'   \
\x1b[19;1H       ';';  ~@@@@@~   ",

// FRAME 47
"\x1b[6;1H                                          __  \
\x1b[7;1H                                   ..e  oOOOOOoooo.  \
\x1b[8;1H      ;,,.              ...eeeellllll! OOOOOOOOOOOOOo.        \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOOOOOOo    \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllll;OOOOOOOOOOOOOOOo    \
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllll`OOOOOOOOOOOO.     \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllll**e ``\"\"\"\"``       \
\x1b[13;1H      ,.';`: :lllllllleeee\"\"```\
\x1b[14;1H      \"'`:'\" ;eee@@el` \
\x1b[15;1H      ,;';'':%@@@@@@@.    \
\x1b[16;1H      ';,'.:%%@@@@@@@* \
\x1b[17;1H       ';,.@@@@@@@@@@*\
\x1b[18;1H       ;;';';@@@@@@@@'\
\x1b[19;1H       ';';  ~@@@@@~",

// FRAME 48
"\x1b[6;1H                                          __  \
\x1b[7;1H                                   ..e  oOOOOOoooo.  \
\x1b[8;1H      ;,,.              ...eeeellllll! OOOOOOOOOOOOOo.        \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOOOOOOo    \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllll;OOOOOOOOOOOOOOOo    \
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllll`OOOOOOOOOOOO.     \
\x1b[12;1H      ; \",'`::lllllllllllllllllllllllll**e ``\"\"\"\"``       \
\x1b[13;1H      ,.';`: :lllllllleeee\"\"```\
\x1b[14;1H      \"'`:'\" ;eee@@el` \
\x1b[15;1H      ,;';'':%@@@@@@@.    \
\x1b[16;1H      ';,'.:%%@@@@@@@* \
\x1b[17;1H       ';,.@@@@@@@@@@*\
\x1b[18;1H       ;;';';@@@@@@@@'\
\x1b[19;1H       ';';  ~@@@@@~",

// FRAME 49
"\x1b[6;1H                                     _   .----.    \
\x1b[7;1H                               ..eel!: oOOOOOOOOOOo.   \
\x1b[8;1H      ;,,.            ..eeeellllllllll OOOOOOOOOOOOOOo         \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOOOOOOO     \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllllll:OOOOOOOOOOOOOo\"     \
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllll\"OOOOOO**\"``      \
\x1b[12;1H      ; \",'`::llllllllllllllllllee**\"\"`                     \
\x1b[13;1H      ,.';`: :llllllllee\"\"``    \
\x1b[14;1H      \"'`:'\" ;eee@@el`  \
\x1b[15;1H      ,;';'':%@@@@@@@.       \
\x1b[16;1H      ';,'.:%%@@@@@@@*      \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~ ",

// FRAME 50
"\x1b[6;1H                                     _   .----.    \
\x1b[7;1H                               ..eel!: oOOOOOOOOOOo.   \
\x1b[8;1H      ;,,.            ..eeeellllllllll OOOOOOOOOOOOOOo         \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOOOOOOO     \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllllll:OOOOOOOOOOOOOo\"     \
\x1b[11;1H       .;;;`:llllll;;llllllllllllllllllll\"OOOOOO**\"``      \
\x1b[12;1H      ; \",'`::llllllllllllllllllee**\"\"`                     \
\x1b[13;1H      ,.';`: :llllllllee\"\"``\
\x1b[14;1H      \"'`:'\" ;eee@@el`  \
\x1b[15;1H      ,;';'':%@@@@@@@.       \
\x1b[16;1H      ';,'.:%%@@@@@@@*      \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~ ",

// FRAME 51
"\x1b[5;1H                                        ..--...    \
\x1b[6;1H                                    .e oOOOOOOOOOo,.    \
\x1b[7;1H                             ...eelll OOOOOOOOOOOOOOO.    \
\x1b[8;1H      ;,,.            ..eellllllllllllOOOOOOOOOOOOOOOo.         \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOOOO*.`     \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllllll *OOOOOOOO*\"       \
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllee\"\"  ~~``             \
\x1b[12;1H      ; \",'`::llllllllllllllle**``                         \
\x1b[13;1H      ,.';`: :llllllll**``  \
\x1b[14;1H      \"'`:'\" ;eee@@el`   \
\x1b[15;1H      ,;';'':%@@@@@@@.  \
\x1b[16;1H      ';,'.:%%@@@@@@@* \
\x1b[17;1H       ';,.@@@@@@@@@@*     \
\x1b[18;1H       ;;';';@@@@@@@@'      \
\x1b[19;1H       ';';  ~@@@@@~   ",

// FRAME 52
"\x1b[5;1H                                        ..--...    \
\x1b[6;1H                                    .e oOOOOOOOOOo,.    \
\x1b[7;1H                             ...eelll OOOOOOOOOOOOOOO.    \
\x1b[8;1H      ;,,.            ..eellllllllllllOOOOOOOOOOOOOOOo.         \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOOOO*.`     \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllllll *OOOOOOOO*\"       \
\x1b[11;1H       .;;;`:llllll;;lllllllllllllllee\"\"  ~~``             \
\x1b[12;1H      ; \",'`::llllllllllllllle**``                         \
\x1b[13;1H      ,.';`: :llllllll**``     \
\x1b[14;1H      \"'`:'\" ;eee@@el`   \
\x1b[15;1H      ,;';'':%@@@@@@@.  \
\x1b[16;1H      ';,'.:%%@@@@@@@* \
\x1b[17;1H       ';,.@@@@@@@@@@*     \
\x1b[18;1H       ;;';';@@@@@@@@'      \
\x1b[19;1H       ';';  ~@@@@@~   ",

// FRAME 53
"\x1b[5;1H                                     .  ooOOOOOoo,.\
\x1b[6;1H                                 ...el OOOOOOOOOOOOOo.\
\x1b[7;1H                           ...eelllll OOOOOOOOOOOOOOOo \
\x1b[8;1H      ;,,.          ...elllllllllllll OOOOOOOOOOOOOOO         \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOO*'      \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllll`*OOO*\"\"``     \
\x1b[11;1H       .;;;`:llllll;;llllllllllllle*\"``                   \
\x1b[12;1H      ; \",'`::llllllllllllle*\"\"`                         \
\x1b[13;1H      ,.';`: :llllllle\"\"``  \
\x1b[14;1H      \"'`:'\" ;eee@@el`   \
\x1b[15;1H      ,;';'':%@@@@@@@.  \
\x1b[16;1H      ';,'.:%%@@@@@@@*   \
\x1b[17;1H       ';,.@@@@@@@@@@*   \
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~",

// FRAME 54
"\x1b[5;1H                                     .  ooOOOOOoo,.\
\x1b[6;1H                                 ...el OOOOOOOOOOOOOo.\
\x1b[7;1H                           ...eelllll OOOOOOOOOOOOOOOo \
\x1b[8;1H      ;,,.          ...elllllllllllll OOOOOOOOOOOOOOO         \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOO*'      \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllll`*OOO*\"\"``     \
\x1b[11;1H       .;;;`:llllll;;llllllllllllle*\"``                   \
\x1b[12;1H      ; \",'`::llllllllllllle*\"\"`                         \
\x1b[13;1H      ,.';`: :llllllle\"\"``  \
\x1b[14;1H      \"'`:'\" ;eee@@el`   \
\x1b[15;1H      ,;';'':%@@@@@@@.  \
\x1b[16;1H      ';,'.:%%@@@@@@@*   \
\x1b[17;1H       ';,.@@@@@@@@@@*   \
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~",

// FRAME 55
"\x1b[4;1H                                       ..*oo**... \
\x1b[5;1H                                    e oOOOOOOOOOOOoo. \
\x1b[6;1H                               ..elll OOOOOOOOOOOOOOO \
\x1b[7;1H                          ..ellllllll OOOOOOOOOOOOOO\" \
\x1b[8;1H      ;,,.           .elllllllllllllll OOOOOOOOOOO*'         \
\x1b[9;1H      .;,,:,;`eeeeellllllllllllllllllll \"*OOO**\"'`      \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllle*``             \
\x1b[11;1H       .;;;`:llllll;;lllllllllle*\"`                     \
\x1b[12;1H      ; \",'`::llllllllllle*\"`                           \
\x1b[13;1H      ,.';`: :llllllle``  \
\x1b[14;1H      \"'`:'\" ;eee@@el`  \
\x1b[15;1H      ,;';'':%@@@@@@@. \
\x1b[16;1H      ';,'.:%%@@@@@@@*  \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@'  \
\x1b[19;1H       ';';  ~@@@@@~   ",

// FRAME 56
"\x1b[4;1H                                       ..*oo**... \
\x1b[5;1H                                    e oOOOOOOOOOOOoo. \
\x1b[6;1H                               ..elll OOOOOOOOOOOOOOO \
\x1b[7;1H                          ..ellllllll OOOOOOOOOOOOOO\" \
\x1b[8;1H      ;,,.           .elllllllllllllll OOOOOOOOOOO*'         \
\x1b[9;1H      .;,,:,;`eeeeellllllllllllllllllll \"*OOO**\"'`      \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllle*``             \
\x1b[11;1H       .;;;`:llllll;;lllllllllle*\"`                     \
\x1b[12;1H      ; \",'`::llllllllllle*\"`                           \
\x1b[13;1H      ,.';`: :llllllle``  \
\x1b[14;1H      \"'`:'\" ;eee@@el`  \
\x1b[15;1H      ,;';'':%@@@@@@@. \
\x1b[16;1H      ';,'.:%%@@@@@@@*  \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@'  \
\x1b[19;1H       ';';  ~@@@@@~   ",

// FRAME 57
"\x1b[4;1H                                       .oOOOOooo..\
\x1b[5;1H                                  ..e oOOOOOOOOOOOOo.\
\x1b[6;1H                             ..elllll OOOOOOOOOOOOOO. \
\x1b[7;1H                        ..ellllllllll OOOOOOOOOOOOOO\" \
\x1b[8;1H      ;,,.          .ellllllllllllllll OOOOOOOOO**\"         \
\x1b[9;1H      .;,,:,;`eeeeellllllllllllllllllle \"**\"\"'``         \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllle''                 \
\x1b[11;1H       .;;;`:llllll;;llllllllle''                        \
\x1b[12;1H      ; \",'`::lllllllllllle''              \
\x1b[13;1H      ,.';`: :llllllle''          \
\x1b[14;1H      \"'`:'\" ;eee@@el`       \
\x1b[15;1H      ,;';'':%@@@@@@@.     \
\x1b[16;1H      ';,'.:%%@@@@@@@*    \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~  ",

// FRAME 58
"\x1b[4;1H                                       .oOOOOooo..\
\x1b[5;1H                                  ..e oOOOOOOOOOOOOo.\
\x1b[6;1H                             ..elllll OOOOOOOOOOOOOO. \
\x1b[7;1H                        ..ellllllllll OOOOOOOOOOOOOO\" \
\x1b[8;1H      ;,,.          .ellllllllllllllll OOOOOOOOO**\"         \
\x1b[9;1H      .;,,:,;`eeeeellllllllllllllllllle \"**\"\"'``        \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllle''                \
\x1b[11;1H       .;;;`:llllll;;llllllllle''       \
\x1b[12;1H      ; \",'`::lllllllllllle''      \
\x1b[13;1H      ,.';`: :llllllle''       \
\x1b[14;1H      \"'`:'\" ;eee@@el`       \
\x1b[15;1H      ,;';'':%@@@@@@@.     \
\x1b[16;1H      ';,'.:%%@@@@@@@*    \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~  ",

// FRAME 59
"\x1b[4;1H                                       .oOOOOooo..\
\x1b[5;1H                                  ..e oOOOOOOOOOOOOo.\
\x1b[6;1H                             ..elllll OOOOOOOOOOOOOO. \
\x1b[7;1H                        ..ellllllllll OOOOOOOOOOOOOO\" \
\x1b[8;1H      ;,,.          .ellllllllllllllll OOOOOOOOO**\"         \
\x1b[9;1H      .;,,:,;`eeeeellllllllllllllllllle \"**\"\"'``         \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllle''                 \
\x1b[11;1H       .;;;`:llllll;;llllllllle''                        \
\x1b[12;1H      ; \",'`::lllllllllllle''              \
\x1b[13;1H      ,.';`: :llllllle''          \
\x1b[14;1H      \"'`:'\" ;eee@@el`       \
\x1b[15;1H      ,;';'':%@@@@@@@.     \
\x1b[16;1H      ';,'.:%%@@@@@@@*    \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~  ",

// FRAME 60
"\x1b[4;1H                                       .oOOOOooo..\
\x1b[5;1H                                  ..e oOOOOOOOOOOOOo.\
\x1b[6;1H                             ..elllll OOOOOOOOOOOOOO. \
\x1b[7;1H                        ..ellllllllll OOOOOOOOOOOOOO\" \
\x1b[8;1H      ;,,.          .ellllllllllllllll OOOOOOOOO**\"         \
\x1b[9;1H      .;,,:,;`eeeeellllllllllllllllllle \"**\"\"'``        \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllle''                \
\x1b[11;1H       .;;;`:llllll;;llllllllle''       \
\x1b[12;1H      ; \",'`::lllllllllllle''      \
\x1b[13;1H      ,.';`: :llllllle''       \
\x1b[14;1H      \"'`:'\" ;eee@@el`       \
\x1b[15;1H      ,;';'':%@@@@@@@.     \
\x1b[16;1H      ';,'.:%%@@@@@@@*    \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~  ",

// FRAME 61
"\x1b[1;1H                                                                     \
\x1b[2;1H                                       ..----..                      \
\x1b[3;1H                                    .oOOOOOOOOOOOo,                  \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~                 \
\x1b[6;1H                          .ellllllll OOOOOOOOOOOO*~                  \
\x1b[7;1H                      .ellllll;;;;lll \"OOOOOOO*~                     \
\x1b[8;1H      ;,,.        .e;;;;;;;;;;;lllllllle ~~`                         \
\x1b[9;1H      .;,,:,;`eeeellllllll;;llllllle'`                            \
\x1b[10;1H      .,;,,.`llllllllllll;;lllle'`             \
\x1b[11;1H       .;;;`:lllllllllll;;le'`              \
\x1b[12;1H      ; \",'`::llllllllle'`             \
\x1b[13;1H      ,.';`: :llllllle''       \
\x1b[14;1H      \"'`:'\" ;eee@@el`       \
\x1b[15;1H      ,;';'':%@@@@@@@.     \
\x1b[16;1H      ';,'.:%%@@@@@@@*    \
\x1b[17;1H       ';,.@@@@@@@@@@*  \
\x1b[18;1H       ;;';';@@@@@@@@' \
\x1b[19;1H       ';';  ~@@@@@~  ",

// FRAME 62
"\x1b[1;1H                                                         .*.#*\"..    \
\x1b[2;1H                                       ..----..       ..##@@*@ '     \
\x1b[3;1H                                    .oOOOOOOOOOOOo, .#@@#* '         \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*@*`              \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~                 ",

// FRAME 63
"\x1b[1;1H                                                          \
\x1b[2;1H                                       ..----..        .#@@@@#'\" .  '\
\x1b[3;1H                                    .oOOOOOOOOOOOo, .@@@#*\"' `       \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~             ",

// FRAME 64
"\x1b[1;1H                                                            \
\x1b[2;1H                                       ..----..           .#@@@@@@#'\"\
\x1b[3;1H                                    .oOOOOOOOOOOOo,  .*.#*\"' `  \"    \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*             \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~             ",

// FRAME 65
"\x1b[1;1H                                                            \
\x1b[2;1H                                       ..----..           . '* **\
\x1b[3;1H                                    .oOOOOOOOOOOOo,   .. *\"' `  \"    \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~* \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 66
"\x1b[1;1H                                                            \
\x1b[3;1H                                    .oOOOOOOOOOOOo,   ..` \"  `       \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~* \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 67
"\x1b[1;1H                                                              .  \
\x1b[2;1H                                       ..----..            .    .\
\x1b[3;1H                                    .oOOOOOOOOOOOo,    .` '          \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 68
"\x1b[1;1H                                                                . .  \
\x1b[2;1H                                       ..----..             .   .    \
\x1b[3;1H                                    .oOOOOOOOOOOOo,      .           \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 69
"\x1b[1;1H                                                                     \
\x1b[2;1H                                       ..----..                    '.\
\x1b[3;1H                                    .oOOOOOOOOOOOo,                  \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 62
"\x1b[1;1H                                                         .*.#*\"..    \
\x1b[2;1H                                       ..----..       ..##@@*@ '     \
\x1b[3;1H                                    .oOOOOOOOOOOOo, .#@@#* '         \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*@*`              \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~                 ",

// FRAME 63
"\x1b[1;1H                                                          \
\x1b[2;1H                                       ..----..        .#@@@@#'\" .  '\
\x1b[3;1H                                    .oOOOOOOOOOOOo, .@@@#*\"' `       \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~             ",

// FRAME 64
"\x1b[1;1H                                                            \
\x1b[2;1H                                       ..----..           .#@@@@@@#'\"\
\x1b[3;1H                                    .oOOOOOOOOOOOo,  .*.#*\"' `  \"    \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*             \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~             ",

// FRAME 65
"\x1b[1;1H                                                            \
\x1b[2;1H                                       ..----..           . '* **\
\x1b[3;1H                                    .oOOOOOOOOOOOo,   .. *\"' `  \"    \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~* \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 66
"\x1b[1;1H                                                            \
\x1b[3;1H                                    .oOOOOOOOOOOOo,   ..` \"  `       \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~* \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 67
"\x1b[1;1H                                                              .  \
\x1b[2;1H                                       ..----..            .    .\
\x1b[3;1H                                    .oOOOOOOOOOOOo,    .` '          \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 68
"\x1b[1;1H                                                                . .  \
\x1b[2;1H                                       ..----..             .   .    \
\x1b[3;1H                                    .oOOOOOOOOOOOo,      .           \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 69
"\x1b[1;1H                                                                     \
\x1b[2;1H                                       ..----..                    '.\
\x1b[3;1H                                    .oOOOOOOOOOOOo,                  \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 62
"\x1b[1;1H                                                         .*.#*\"..    \
\x1b[2;1H                                       ..----..       ..##@@*@ '     \
\x1b[3;1H                                    .oOOOOOOOOOOOo, .#@@#* '         \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*@*`              \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~                 ",

// FRAME 63
"\x1b[1;1H                                                          \
\x1b[2;1H                                       ..----..        .#@@@@#'\" .  '\
\x1b[3;1H                                    .oOOOOOOOOOOOo, .@@@#*\"' `       \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~             ",

// FRAME 64
"\x1b[1;1H                                                            \
\x1b[2;1H                                       ..----..           .#@@@@@@#'\"\
\x1b[3;1H                                    .oOOOOOOOOOOOo,  .*.#*\"' `  \"    \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*             \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~             ",

// FRAME 65
"\x1b[1;1H                                                            \
\x1b[2;1H                                       ..----..           . '* **\
\x1b[3;1H                                    .oOOOOOOOOOOOo,   .. *\"' `  \"    \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~* \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 66
"\x1b[1;1H                                                            \
\x1b[3;1H                                    .oOOOOOOOOOOOo,   ..` \"  `       \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~* \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 67
"\x1b[1;1H                                                              .  \
\x1b[2;1H                                       ..----..            .    .\
\x1b[3;1H                                    .oOOOOOOOOOOOo,    .` '          \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 68
"\x1b[1;1H                                                                . .  \
\x1b[2;1H                                       ..----..             .   .    \
\x1b[3;1H                                    .oOOOOOOOOOOOo,      .           \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 69
"\x1b[1;1H                                                                     \
\x1b[2;1H                                       ..----..                    '.\
\x1b[3;1H                                    .oOOOOOOOOOOOo,                  \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 62
"\x1b[1;1H                                                         .*.#*\"..    \
\x1b[2;1H                                       ..----..       ..##@@*@ '     \
\x1b[3;1H                                    .oOOOOOOOOOOOo, .#@@#* '         \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*@*`              \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~                 ",

// FRAME 63
"\x1b[1;1H                                                          \
\x1b[2;1H                                       ..----..        .#@@@@#'\" .  '\
\x1b[3;1H                                    .oOOOOOOOOOOOo, .@@@#*\"' `       \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~             ",

// FRAME 64
"\x1b[1;1H                                                            \
\x1b[2;1H                                       ..----..           .#@@@@@@#'\"\
\x1b[3;1H                                    .oOOOOOOOOOOOo,  .*.#*\"' `  \"    \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*             \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~             ",

// FRAME 65
"\x1b[1;1H                                                            \
\x1b[2;1H                                       ..----..           . '* **\
\x1b[3;1H                                    .oOOOOOOOOOOOo,   .. *\"' `  \"    \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~* \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 66
"\x1b[1;1H                                                            \
\x1b[3;1H                                    .oOOOOOOOOOOOo,   ..` \"  `       \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~* \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 67
"\x1b[1;1H                                                              .  \
\x1b[2;1H                                       ..----..            .    .\
\x1b[3;1H                                    .oOOOOOOOOOOOo,    .` '          \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 68
"\x1b[1;1H                                                                . .  \
\x1b[2;1H                                       ..----..             .   .    \
\x1b[3;1H                                    .oOOOOOOOOOOOo,      .           \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 69
"\x1b[1;1H                                                                     \
\x1b[2;1H                                       ..----..                    '.\
\x1b[3;1H                                    .oOOOOOOOOOOOo,                  \
\x1b[4;1H                                 .  OOOOOOOOOOOOO%~*                 \
\x1b[5;1H                             .ellll OOOOOOOOOOOOOOO~",

// FRAME 70
"\x1b[1;1H                                                                     \
\x1b[2;1H                                                                     \
\x1b[3;1H                                                                     \
\x1b[4;1H                                       .oOOOOooo..                   \
\x1b[5;1H                                  ..e oOOOOOOOOOOOOo.                \
\x1b[6;1H                             ..elllll OOOOOOOOOOOOOO.                \
\x1b[7;1H                        ..ellllllllll OOOOOOOOOOOOOO\"                \
\x1b[8;1H      ;,,.          .ellllllllllllllll OOOOOOOOO**\"                  \
\x1b[9;1H      .;,,:,;`eeeeellllllllllllllllllle \"**\"\"'``                     \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllle''                              \
\x1b[11;1H       .;;;`:llllll;;llllllllle''                     \
\x1b[12;1H      ; \",'`::lllllllllllle''      \
\x1b[13;1H      ,.';`: :llllllle''       ",

// FRAME 71
"\x1b[4;1H                                       ..*oo**...           \
\x1b[5;1H                                    e oOOOOOOOOOOOoo.         \
\x1b[6;1H                               ..elll OOOOOOOOOOOOOOO            \
\x1b[7;1H                          ..ellllllll OOOOOOOOOOOOOO\"        \
\x1b[8;1H      ;,,.           .elllllllllllllll OOOOOOOOOOO*'            \
\x1b[9;1H      .;,,:,;`eeeeellllllllllllllllllll \"*OOO**\"'`             \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllle*``                     \
\x1b[11;1H       .;;;`:llllll;;lllllllllle*\"`                            \
\x1b[12;1H      ; \",'`::llllllllllle*\"`                                 \
\x1b[13;1H      ,.';`: :llllllle``                  ",

// FRAME 72
"\x1b[4;1H                                                          \
\x1b[5;1H                                     .  ooOOOOOoo,. \
\x1b[6;1H                                 ...el OOOOOOOOOOOOOo. \
\x1b[7;1H                           ...eelllll OOOOOOOOOOOOOOOo \
\x1b[8;1H      ;,,.          ...elllllllllllll OOOOOOOOOOOOOOO         \
\x1b[9;1H      .;,,:,;`eeeeelllllllllllllllllll OOOOOOOOOOO*'      \
\x1b[10;1H      .,;,,.`lllllllllllllllllllllllllll`*OOO*\"\"``     \
\x1b[11;1H       .;;;`:llllll;;llllllllllllle*\"``                   \
\x1b[12;1H      ; \",'`::llllllllllllle*\"\"`                         \
\x1b[13;1H      ,.';`: :llllllle\"\"``  ",

// FRAME 73
"\x1b[4;1H                                       ..*oo**... \
\x1b[5;1H                                    e oOOOOOOOOOOOoo. \
\x1b[6;1H                               ..elll OOOOOOOOOOOOOOO \
\x1b[7;1H                          ..ellllllll OOOOOOOOOOOOOO\" \
\x1b[8;1H      ;,,.           .elllllllllllllll OOOOOOOOOOO*'         \
\x1b[9;1H      .;,,:,;`eeeeellllllllllllllllllll \"*OOO**\"'`      \
\x1b[10;1H      .,;,,.`llllllllllllllllllllllle*``             \
\x1b[11;1H       .;;;`:llllll;;lllllllllle*\"`                     \
\x1b[12;1H      ; \",'`::llllllllllle*\"`                           \
\x1b[13;1H      ,.';`: :llllllle``  ",

// FRAME 74
"\x1b[4;1H                                       .oOOOOooo..   \
\x1b[5;1H                                  ..e oOOOOOOOOOOOOo.   ",

// FRAME 75
"\x1b[23;1H"
};
