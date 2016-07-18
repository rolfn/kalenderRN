%
% Author: Rolf Niepraschk, https://github.com/rolfn/kalenderRN
%
% inspired by http://www.texample.net/tikz/examples/a-calender-for-doublesided-din-a4/
% Original author: Robert Krause
% License: Creative Commons attribution license (CC-BY-SA)

\setcounter{errorcontextlines}{100}
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{kalenderRN}[2016/07/18 v0.3a Calendar class (RN)]

\newif\ifRN@print \RN@printfalse

\DeclareOption{print}{\RN@printtrue}

\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{xcolor}}
\ProcessOptions\relax
\LoadClass[a4paper,ngerman,10pt]{article}  
\ifRN@print
  \RequirePackage{graphicx}
  \PassOptionsToPackage{portrait}{geometry}
\else
  \PassOptionsToPackage{landscape}{geometry}
\fi
\RequirePackage[a4paper,margin={0mm,0mm}]{geometry}

\newif\ifRN@XeOrLua \RN@XeOrLuafalse
\RequirePackage{ifluatex,ifxetex}
\ifxetex\RN@XeOrLuatrue\else\ifluatex\RN@XeOrLuatrue\fi\fi

\ifRN@XeOrLua
  \RequirePackage{fontspec}
  \setsansfont[Ligatures=TeX]{TeX Gyre Heros}
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage{textcomp}
  \RequirePackage{lmodern}
  \RequirePackage{tgheros}
\fi

\renewcommand*\familydefault{\sfdefault}

\RequirePackage{etoolbox}
\AtEndPreamble{% "etoolbox"
  \ifRN@XeOrLua\else
    \@ifpackageloaded{inputenc}{}{%
      \RequirePackage[utf8]{inputenc}%
    }%
  \fi
}

\RequirePackage[main=ngerman]{babel}

\RequirePackage[ngerman]{translator}

\deftranslation[to=ngerman]{January}{Januar}
\deftranslation[to=ngerman]{February}{Februar}
\deftranslation[to=ngerman]{March}{März}
\deftranslation[to=ngerman]{April}{April}
\deftranslation[to=ngerman]{May}{Mai}
\deftranslation[to=ngerman]{June}{Juni}
\deftranslation[to=ngerman]{July}{Juli}
\deftranslation[to=ngerman]{August}{August}
\deftranslation[to=ngerman]{September}{September}
\deftranslation[to=ngerman]{October}{Oktober}
\deftranslation[to=ngerman]{November}{November}
\deftranslation[to=ngerman]{December}{Dezember}
\deftranslation[to=ngerman]{Mon}{Mo}
\deftranslation[to=ngerman]{Tue}{Di}
\deftranslation[to=ngerman]{Wed}{Mi}
\deftranslation[to=ngerman]{Thu}{Do}
\deftranslation[to=ngerman]{Fri}{Fr}
\deftranslation[to=ngerman]{Sat}{Sb}
\deftranslation[to=ngerman]{Sun}{So}

\RequirePackage{tikz}
\usetikzlibrary{calc}
\usetikzlibrary{calendar}

\RequirePackage{varwidth}

\newcommand*\RN@year{}
\edef\RN@year{\the\numexpr\year}

\newsavebox\RN@pageI
\newsavebox\RN@pageII
\newsavebox\RN@tempbox
\newdimen\RN@tempdima
\newdimen\RN@tempdimb
\newcommand*\RN@events@I{}
\newcommand*\RN@events@II{}
\newcommand*\RN@backgrounds{}
\newcommand*\RN@periods{}
\newcommand*\RN@title{}
\newcounter{weeknumber}
\newif\ifRN@showweeknumbers \RN@showweeknumbersfalse

\pgfkeys{%
  /CAL/.is family, /CAL,
  showweeknumbers/.is if = RN@showweeknumbers,
  title/.estore in = \RN@title,
  year/.estore in = \RN@year,
  default/.style={eventColor=medium,monthBGcolor=dark,monthColor=white,%
    workdayColor=none,saturdayColor=bright,sundayColor=medium,titleColor=dark},
  titleColor/.estore in = \RN@titleColor,
  eventColor/.estore in = \RN@eventColor,
  monthBGcolor/.estore in = \RN@monthBGcolor,
  monthColor/.estore in = \RN@monthColor,
  workdayColor/.estore in = \RN@workdayColor,
  saturdayColor/.estore in = \RN@saturdayColor,
  sundayColor/.estore in = \RN@sundayColor
}
\pgfkeys{%
  /CAL/.is family, /CAL,
  period/.cd,
  default/.style={color=period,name={}},
  color/.estore in = \RN@period@color, 
  name/.estore in = \RN@period@name 
}
\pgfkeys{%
  /CAL/.is family, /CAL,
  event/.cd,
  color/.estore in = \RN@eventColor 
}

\newcommand*\period[2]{%
  \@ifnextchar[{\period@i{#1}{#2}}{\period@i{#1}{#2}[]}
}
\newcommand*\period@i{}
\def\period@i#1#2[#3]{%
  \pgfkeys{/CAL/period/.cd, default, #3}%
  \edef\@tempa{%
    \noexpand\ifdate{between=#1 and #2}{%
      \noexpand\tikzset{every day/.style={fill=\RN@period@color}}}{}%
  }%
  \expandafter\g@addto@macro\expandafter\RN@periods\expandafter{\@tempa}%
  \ifx\RN@period@name\@empty\else 
    \pgfcalendar{}{#1}{#2}{%
      \event{\pgfcalendarcurrentyear-\pgfcalendarcurrentmonth-\pgfcalendarcurrentday}%
        {\RN@period@name}%
    }%
  \fi
}
\newcommand*\event{%
  \@ifstar{\@tempswatrue\RN@event@i}{\@tempswafalse\RN@event@i}%
}
\newcommand*\RN@event@i[2]{%
  \@ifnextchar[{\RN@event@ii{#1}{#2}}{\RN@event@ii{#1}{#2}[]} 
}
\newcommand*\RN@event@ii{}%
\def\RN@event@ii#1#2[#3]{%
  \pgfkeys{/CAL/event/.cd, #3}%
  \@ifundefined{event@#1}{%
    \protected@edef\@tempa{\noexpand\@ifundefined{pgf@sh@ns@cal-#1}{}{%
      \noexpand\node[anchor=north west] at ($(cal-#1.north east)-(.6em,0em)$){%
        \noexpand\makebox[0pt][r]{\noexpand\resizebox{!}{1.15ex}{%
          \noexpand\varwidth{4.6cm}#2\noexpand\strut\noexpand\endvarwidth}}};}%
    }%
  }{}%
  \@namedef{event@#1}{#2}%
  \pgfcalendarifdate{#1}{at most=06-last}% first half-year?
  {\expandafter\g@addto@macro\expandafter\RN@events@I\expandafter{\@tempa}}%
  {\expandafter\g@addto@macro\expandafter\RN@events@II\expandafter{\@tempa}}%
  \if@tempswa
    \edef\@tempa{%
      \noexpand\ifdate{equals=#1}{\noexpand\tikzset{%
        every day/.style={fill=\RN@eventColor}}}{}
    }%
    \expandafter\g@addto@macro\expandafter\RN@backgrounds\expandafter{\@tempa}%
  \fi 
}

\definecolor{dark}{HTML}{A57C00}
\colorlet{medium}{dark!35}
\colorlet{bright}{dark!20}
\colorlet{period}{gray!30}

\newcommand\RN@@title{%
  \raisebox{-.3\height}{\parbox[b]{\wd\RN@tempbox}{%
    \fontsize{60}{70}\selectfont\color{\RN@titleColor}%
    \textbf{\RN@year}~\textbf{\Huge\RN@title}\hfill
  }}%
}

\newcommand\RN@makeKalender[2]{%
  \sbox\RN@tempbox{%
    \begin{tikzpicture}[every day/.style={anchor=north}]%
      \calendar[dates=#1 to #2,name=cal,day text={\%d=},day yshift=3em,%]%
        day code={%
          \node[name=\pgfcalendarsuggestedname,every day,shape=rectangle,%
            minimum height=.53cm,text width=4.4cm,draw=black]{\tikzdaytext};%
            \draw(-1.8cm,-.1ex) node[anchor=west]{\footnotesize
              \pgfcalendarweekdayshortname{\pgfcalendarcurrentweekday}%
              \ifRN@showweeknumbers
                \ifdate{Monday}{~~\stepcounter{weeknumber}\normalsize[%
                  \mbox{\footnotesize\arabic{weeknumber}}]}{}%
              \fi
            };%
        },%
        execute before day scope={%
          \ifdate{day of month=1}{%
            \pgftransformxshift{4.8cm}%
            % Print month name
            \draw (0,0)node [shape=rectangle,minimum height=.53cm,%
              text width=4.4cm,fill=\RN@monthBGcolor,draw=\RN@monthBGcolor,%
                text=\RN@monthColor,text centered]{%
              \textbf{\pgfcalendarmonthname{\pgfcalendarcurrentmonth}}};}{}%
          \ifdate{workday}{\tikzset{every day/.style={fill=\RN@workdayColor}}}{}% 
          \ifdate{Saturday}{\tikzset{every day/.style={fill=\RN@saturdayColor}}}{}%
          \ifdate{Sunday}{\tikzset{every day/.style={fill=\RN@sundayColor}}}{}%
          \RN@periods
          \RN@backgrounds
        },%
        execute at begin day scope={%
          \pgftransformyshift{-.53*\pgfcalendarcurrentday cm}%
        }%
      ];%
      \pgfcalendarifdate{#1}{at most=06-last}{\RN@events@I}{\RN@events@II}%
    \end{tikzpicture}%  
  }%
  \RN@tempdima=\ifRN@print\paperwidth\else\paperheight\fi
  \RN@tempdimb=\ifRN@print\paperheight\else\paperwidth\fi 
  \parbox[c][\RN@tempdima]{\RN@tempdimb}{%
    \vfill
    \centering
    \RN@@title\par
    \vfill
    \usebox\RN@tempbox\par
    \vfill
  }%  
}  

\newcommand*\makeKalender[1][]{%
  \pgfkeys{/CAL/.cd, default, #1}%
  \setcounter{weeknumber}{0}%
  \begingroup
    \let\year=\RN@year
    \InputIfFileExists{events\RN@year.tex}{}{}%
  \endgroup
  \sbox{\RN@pageI}{\RN@makeKalender{\RN@year-01-01}{\RN@year-06-30}}%  
  \sbox{\RN@pageII}{\RN@makeKalender{\RN@year-07-01}{\RN@year-12-31}}%
  \ifRN@print
    \rotatebox[origin=c]{90}{\usebox\RN@pageI}%
  \else
    \usebox\RN@pageI
  \fi
  \newpage
  \ifRN@print
    \rotatebox[origin=c]{-90}{\usebox\RN@pageII}%
  \else
    \usebox\RN@pageII
  \fi
}
\setlength\parindent{0pt}
\pagestyle{empty}
\endinput
