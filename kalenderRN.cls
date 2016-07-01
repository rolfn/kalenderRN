%
% Author: Rolf Niepraschk, https://github.com/rolfn/kalenderRN
%
% inspired by http://www.texample.net/tikz/examples/a-calender-for-doublesided-din-a4/
% Original author: Robert Krause
% License: Creative Commons attribution license (CC-BY-SA)

\setcounter{errorcontextlines}{100}
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{kalenderRN}[2016/05/15 v0.1b Calendar class (RN)]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[landscape,a4paper,ngerman,10pt]{article}
\RequirePackage[headheight=2cm,margin=.5cm,top=3.2cm,nofoot]{geometry}
\RequirePackage{fancyhdr}

\renewcommand{\headrulewidth}{0.0pt}
\setlength{\headheight}{10ex}
\newcommand*\RN@title{}
\chead{%
  \raisebox{-.3\height}[0pt][0pt]{\parbox[b]{\textwidth}{%
  \fontsize{60}{70}\selectfont\textbf{\RN@year}
  \textbf{\Huge\RN@title}\hfill
  }}%
}
\cfoot{}

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
\AtBeginDocument{\xdef\RN@year{\the\numexpr\year}}

\newcommand*\event{%
  \@ifstar{\@tempswatrue\RN@event@i}{\@tempswafalse\RN@event@i}%
}
\newcommand*\RN@events@I{}
\newcommand*\RN@events@II{}
\newcommand*\RN@backgrounds{}
\newcommand*\RN@periods{}
\newcommand*\period[2]{%
  \edef\@tempa{%
    \noexpand\ifdate{between=#1 and #2}{%
      \noexpand\tikzset{every day/.style={fill=gray!30}}}{}%
  }%
  \expandafter\g@addto@macro\expandafter\RN@periods\expandafter{\@tempa}%
}
\newcommand*\RN@event@i[2]{%
  \protected@edef\@tempa{\noexpand\@ifundefined{pgf@sh@ns@cal-#1}{}{%
    \noexpand\node[anchor=north west] at ($(cal-#1.north east)-(.6em,0em)$){%
      \noexpand\makebox[0pt][r]{\noexpand\resizebox{!}{1.15ex}{%
        \noexpand\varwidth{4.6cm}#2\noexpand\strut\noexpand\endvarwidth}}};}%
  }%
  \pgfcalendarifdate{#1}{at most=06-last}% first half-year?
  {\expandafter\g@addto@macro\expandafter\RN@events@I\expandafter{\@tempa}}%
  {\expandafter\g@addto@macro\expandafter\RN@events@II\expandafter{\@tempa}}%
  \if@tempswa
    \edef\@tempa{%
      \noexpand\ifdate{equals=#1}{\noexpand\tikzset{%
        every day/.style={fill=medium}}}{}
    }%
    \expandafter\g@addto@macro\expandafter\RN@backgrounds\expandafter{\@tempa}%
  \fi
}

\definecolor{dark}{HTML}{A57C00}
\colorlet{medium}{dark!35}
\colorlet{bright}{dark!20}
\colorlet{period}{gray!30}

\newcommand\RN@makeKalender[2]{%
  \begin{tikzpicture}[every day/.style={anchor=north}]%
    \calendar[dates=#1 to #2,name=cal,day text={\%d=},day yshift=3em,%]
      day code={%
        \node[name=\pgfcalendarsuggestedname,every day,shape=rectangle,%
          minimum height=.53cm,text width=4.4cm,draw=gray]{\tikzdaytext};%
          \draw(-1.8cm,-.1ex) node[anchor=west]{\footnotesize
            \pgfcalendarweekdayshortname{\pgfcalendarcurrentweekday}};%
      },%
      execute before day scope={%
        \ifdate{day of month=1}{%
          \pgftransformxshift{4.8cm}%
          % Print month name
          \draw (0,0)node [shape=rectangle,minimum height=.53cm,%
            text width=4.4cm,fill=dark,text=white,draw=dark,text centered]{%
              \resizebox{!}{.225cm}{\textbf{\pgfcalendarmonthname{\pgfcalendarcurrentmonth}}}};}{}%
        \ifdate{workday}{%
          \tikzset{every day/.style={fill=white}}%
          \RN@periods}{}%
        \ifdate{Saturday}{\tikzset{every day/.style={fill=bright}}}{}%
        \ifdate{Sunday}{\tikzset{every day/.style={fill=medium}}}{}%
        \RN@backgrounds
      },%
      execute at begin day scope={%
        \pgftransformyshift{-.53*\pgfcalendarcurrentday cm}%
      }%
    ];%
    \pgfcalendarifdate{#1}{at most=06-last}{\RN@events@I}{\RN@events@II}%
  \end{tikzpicture}
}

\newcommand*\makeKalender[1][]{%
  \gdef\RN@title{#1}%
  \center
    \RN@makeKalender{\RN@year-01-01}{\RN@year-06-30}%
    \pagebreak
    \RN@makeKalender{\RN@year-07-01}{\RN@year-12-31}%
  \endcenter
}
\AtBeginDocument{%
  \begingroup
    \let\year=\RN@year
    \InputIfFileExists{events\RN@year.tex}{}{}%
  \endgroup
}
\pagestyle{fancy}
\endinput
