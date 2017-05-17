%
% Author: Rolf Niepraschk, https://github.com/rolfn/kalenderRN
%
% inspired by http://www.texample.net/tikz/examples/a-calender-for-doublesided-din-a4/
% Original author: Robert Krause
% License: Creative Commons attribution license (CC-BY-SA)

\setcounter{errorcontextlines}{100}
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{tikz-kalender}[2017/05/17 v0.4a Calendar class (RN)] 

\DeclareOption*{\OptionNotUsed}
\ProcessOptions\relax

\newcommand*\RN@events@files{}
\newcommand*\RN@titleFont{}
\newcommand*\RN@yearFont{}
\newcommand*\RN@monthFont{}
\newcommand*\RN@dayFont{}
\newcommand*\RN@dayNbFont{}
\newcommand*\RN@weekNbFont{}
\newcommand*\RN@eventFont{}
\newcommand*\RN@normalFont{}
\newcommand*\RN@title{}
\newcommand*\RN@year{}\edef\RN@year{\the\numexpr\year}
\newcommand*\RN@yearText{\RN@year}
\newcommand*\RN@period@name{}
\newcommand*\RN@xcolorOptions{}
\newcommand*\RN@events@I{}
\newcommand*\RN@events@II{}
\newcommand*\RN@backgrounds{}
\newcommand*\RN@periods{}
\newcommand*\RN@tempa{}
\newcommand*\RN@tempb{}

\newcommand*\RN@titleColor{dark}
\newcommand*\RN@eventColor{medium}
\newcommand*\RN@monthBGcolor{dark}
\newcommand*\RN@monthColor{white}
\newcommand*\RN@workdayColor{none}
\newcommand*\RN@saturdayColor{bright}
\newcommand*\RN@sundayColor{medium}
\newcommand*\RN@periodColor{period}

\newcounter{weeknumber}
\newsavebox\RN@pageI
\newsavebox\RN@pageII
\newsavebox\RN@tempbox

\newdimen\RN@xunit
\newdimen\RN@yunit
\newdimen\RN@calheight
\newdimen\RN@calwidth
\newdimen\RN@daywidth 
\newdimen\RN@daysep
\newdimen\RN@dayheight
\newdimen\RN@eventwidthL 
\newdimen\RN@eventwidthS 

\newif\ifRN@showweeknumbers \RN@showweeknumbersfalse
\newif\ifRN@print \RN@printfalse
\newif\ifRN@XeOrLua \RN@XeOrLuafalse
\RequirePackage{ifluatex,ifxetex}
\ifxetex\RN@XeOrLuatrue\else\ifluatex\RN@XeOrLuatrue\fi\fi 

\LoadClass{article}

\RequirePackage{pgfkeys,etoolbox,ragged2e}

\pgfkeys{
  /RN/.cd,
  showweeknumbers/.is if = RN@showweeknumbers,
  print/.is if = RN@print,
  events/.store in=\RN@events@files,
  titleFont/.store in=\RN@titleFont,
  yearFont/.store in=\RN@yearFont,
  monthFont/.store in=\RN@monthFont,
  dayFont/.store in=\RN@dayFont,
  dayNbFont/.store in=\RN@dayNbFont,
  weekNbFont/.store in=\RN@weekNbFont,
  eventFont/.store in=\RN@eventFont,% ???
  title/.store in=\RN@title,
  year/.store in=\RN@year,
  yearText/.store in=\RN@yearText,
  titleColor/.store in=\RN@titleColor,
  eventColor/.store in=\RN@eventColor,
  periodColor/.store in=\RN@periodColor,
  monthBGcolor/.store in=\RN@monthBGcolor,
  monthColor/.store in=\RN@monthColor,
  workdayColor/.store in=\RN@workdayColor,
  saturdayColor/.store in=\RN@saturdayColor,
  sundayColor/.store in=\RN@sundayColor,
  xcoloroptions/.code={\PassOptionsToPackage{#1}{xcolor}},
  lang/.code={\PassOptionsToPackage{#1}{babel}%
    \PassOptionsToPackage{#1}{translator}},
  paper/.code={\PassOptionsToPackage{#1paper}{geometry}}
}

\newcommand*\setup[1]{\pgfqkeys{/RN}{#1}}

\PassOptionsToPackage{english}{babel}
\PassOptionsToPackage{english}{translator}
\PassOptionsToPackage{a4paper}{geometry}
\PassOptionsToPackage{svgnames}{xcolor}

\ifRN@XeOrLua
  \RequirePackage{fontspec,unicode-math}
  \setmathfont{latinmodern-math}[%
    Extension=.otf,math-style=ISO,bold-style=ISO,
  ]
  \setsansfont{texgyreheros}[%
    Extension=.otf,Ligatures=TeX,
    UprightFont= *-regular,
    BoldFont=*-bold,
    ItalicFont=*-italic,
    BoldItalicFont=*-bolditalic
  ]
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage{textcomp}
  \RequirePackage{lmodern}
  \RequirePackage{tgheros}
\fi

\renewcommand*\familydefault{\sfdefault}

\AtEndPreamble{% "etoolbox"
  \ifRN@print
    \RequirePackage{graphicx}
    \PassOptionsToPackage{portrait}{geometry}
  \else
    \PassOptionsToPackage{landscape}{geometry}
  \fi
  \RequirePackage[margin={0mm,0mm}]{geometry}
  \ifRN@XeOrLua\else
    \@ifpackageloaded{inputenc}{}{%
      \RequirePackage[utf8]{inputenc}%
    }%
  \fi
  \RequirePackage{babel,translator,tikz}
  \input{tikz-kalender-translation.clo}
  \usetikzlibrary{calc}
  \usetikzlibrary{calendar}
}

\AtBeginDocument{%
  \definecolor{dark}{HTML}{A57C00}
  \colorlet{medium}{dark!35}
  \colorlet{bright}{dark!20}
  \colorlet{period}{gray!30}
  \RN@calwidth=\ifRN@print\paperheight\else\paperwidth\fi
  \RN@calheight=\ifRN@print\paperwidth\else\paperheight\fi 
  \@tempcnta=\RN@calwidth
  \divide\@tempcnta by \@M %
  \RN@xunit=\@tempcnta sp %                  0.0845pt (a4)
  \@tempcnta=\RN@calheight
  \divide\@tempcnta by \@M %
  \RN@yunit=\@tempcnta sp %                 0.05974pt (a4)
  \RN@daywidth=1515\RN@xunit%                    45mm (a4)
  \RN@daysep=118\RN@xunit   %                   3.5mm (a4)
  \RN@dayheight=192\RN@xunit%                   5.7mm (a4)
  \RN@setFont{RN@dayFont}{134}%                   8pt (a4)     
  \RN@setFont{RN@dayNbFont}{167}%                10pt (a4)
  \RN@setFont{RN@eventFont}{134}%                 8pt (a4)
  \RN@setFont[\normalfont]{RN@normalFont}{167}%  10pt (a4)
  \RN@setFont{RN@weekNbFont}{134}%                8pt (a4)
  \RN@setFont[\bfseries]{RN@monthFont}{167}%     10pt (a4)
  \RN@setFont[\bfseries]{RN@titleFont}{666}%     40pt (a4)
  \RN@setFont[\bfseries]{RN@yearFont}{1000}%     60pt (a4)
  \RN@normalFont
  \settowidth\@tempdima{\RN@formatDayNb{99}\RN@formatDay{0}}%
  \RN@eventwidthL=\dimexpr\RN@daywidth-\@tempdima
  \settowidth\@tempdima{\setcounter{weeknumber}{99}%
    \RN@formatWeekNb{weeknumber}%
  }
  \RN@eventwidthS=\dimexpr\RN@eventwidthL-\@tempdima
}

\pgfkeys{%
  /RN/.is family, /RN,
  period/.cd,
  color/.estore in=\RN@periodColor,
  name/.estore in=\RN@period@name
}
\pgfkeys{%
  /RN/.is family, /RN,
  event/.cd,
  color/.estore in = \RN@eventColor
}

\newcommand\RN@formatTitle[3]{%
  \raisebox{-.3\height}{\parbox[b]{#1}{%
    \color{\RN@titleColor}%
    \makebox[0pt][l]{\RN@yearFont#2}\hfill
    \RN@titleFont#3\hfill\mbox{}%
  }}%
}
\newcommand*\RN@formatDayNb[1]{%
  \RN@dayNbFont#1\hspace{50\RN@xunit}%
}
\newcommand*\RN@formatDay[1]{%
  \RN@dayFont\pgfcalendarweekdayshortname{#1}%
}
\newcommand*\RN@formatWeekNb[1]{%
  \hspace{30\RN@xunit}\RN@weekNbFont
  \raisebox{.15ex}{[\raisebox{-.15ex}{\arabic{#1}}]}%
  \hspace{20\RN@xunit}%
}
\newcommand*\RN@formatEventX[1]{%
  \varwidth{\RN@eventwidthL}#1\strut\endvarwidth% ??????
}
\newcommand*\RN@formatEventXX[1]{%
  \makebox[0pt][r]{\frame{\resizebox{\RN@eventwidthL}{!}{% ??????
    \parbox[t][\RN@dayheight]{%
    \RN@eventwidthL}{\RN@eventFont\raggedleft#1\strut}}}}%
}
\newcommand*\RN@formatEventXXX[2]{%
  \makebox[0pt][r]{\resizebox{#1}{\RN@dayheight}{% ??????
    \frame{\varwidth[t]{#1}#2\strut\endvarwidth}}}%  
}
\newcommand*\RN@formatEvent[2]{%
  \RN@eventFont
  \def\RN@tempa{\strut\hfill#2}%
  \settowidth\@tempdima{\mbox{\RN@tempa}}%
  \ifdim\@tempdima>#1 %
    \@tempdimb=\dimexpr\f@size pt %
    \@tempdimb=.8\@tempdimb%
    \def\RN@tempa{\fontsize{\@tempdimb}{1.1\@tempdimb}\selectfont#2}%
  \fi
  \makebox[-50\RN@xunit][r]{\raisebox{0.55\totalheight}[\totalheight]{%
    \parbox[c]{#1}{\RaggedLeft\nointerlineskip\RN@tempa}}}%  
}

\newcommand*\RN@setFont[3][]{%
  \@tempdima=#3\RN@yunit \@tempdimb=1.2\@tempdima %
  \expandafter\protected@edef\csname#2\endcsname{\noexpand\fontsize
    {\the\@tempdima}{\the\@tempdimb}#1\csname#2\endcsname\noexpand\selectfont}%
} 

\newcommand*\period[2]{%
  \@ifnextchar[{\RN@period@i{#1}{#2}}{\RN@period@i{#1}{#2}[]}%
}
\newcommand*\RN@period@i{}
\def\RN@period@i#1#2[#3]{%
  \begingroup
  \pgfkeys{/RN/period/.cd, #3}%
  \edef\@tempa{%
    \noexpand\ifdate{between=#1 and #2}{%
      \noexpand\tikzset{every day/.style={fill=\RN@periodColor}}}{}%
  }%
  \expandafter\g@addto@macro\expandafter\RN@periods\expandafter{\@tempa}%
  \ifx\RN@period@name\@empty\else
    \pgfcalendar{}{#1}{#2}{%
      \edef\RN@tempa{\pgfcalendarcurrentyear-\pgfcalendarcurrentmonth-%
        \pgfcalendarcurrentday}%
      \@ifundefined{event@\RN@tempa}{%
        \let\RN@event@ii=\RN@event@ii@orig% activate again
        % period name as event entry for event-less days
        \event{\RN@tempa}{\RN@period@name}%
        \edef\RN@tempb{\noexpand\expandafter\noexpand\gdef\noexpand%
          \csname event@\RN@tempa\noexpand\endcsname{\RN@period@name}}%
        \RN@tempb
      }{}%
    }%
  \fi
  \endgroup
}

\newcommand*\event{%
  \@ifstar{\@tempswatrue\RN@event@i}{\@tempswafalse\RN@event@i}%
}
\newcommand*\RN@event@i[2]{%
  \@ifnextchar[{\RN@event@ii{#1}{#2}}{\RN@event@ii{#1}{#2}[]}%
}

\newcommand*\RN@event@ii{}%
\def\RN@event@ii#1#2[#3]{%
  \begingroup
  \pgfkeys{/RN/event/.cd, #3}%
  \@ifundefined{event@#1}{%
    \@tempdima=\RN@eventwidthL
    \ifRN@showweeknumbers
      \pgfcalendarifdate{#1}{Monday}{\@tempdima=\RN@eventwidthS}{}%
    \fi
    \protected@edef\@tempa{\noexpand\@ifundefined{pgf@sh@ns@cal-#1}{}{%
      \noexpand\node[anchor=south west,inner sep=0pt] at (cal-#1.south east){%
      \noexpand\RN@formatEvent{\the\@tempdima}{#2}};}%
    }%
    \expandafter\gdef\csname event@#1\endcsname{#2}%
    \pgfcalendarifdate{#1}{at most=06-last}% first half-year?
    {\expandafter\g@addto@macro\expandafter\RN@events@I\expandafter{\@tempa}}%
    {\expandafter\g@addto@macro\expandafter\RN@events@II\expandafter{\@tempa}}%
  }{}%
  \if@tempswa
    \edef\@tempa{%
      \noexpand\ifdate{equals=#1}{\noexpand\tikzset{%
        every day/.style={fill=\RN@eventColor}}}{}%
    }%
    \expandafter\g@addto@macro\expandafter\RN@backgrounds\expandafter{\@tempa}%
  \fi
  \endgroup
}
\let\RN@event@ii@orig=\RN@event@ii

\newcommand\RN@makeKalender[2]{%
  \sbox\RN@tempbox{%
    \begin{tikzpicture}[every day/.style={anchor=north}]%
      \calendar[dates=#1 to #2,name=cal,day text={\%d=},%day yshift=3em,%  ????
        day code={%
          \node[name=\pgfcalendarsuggestedname,every day,%
          shape=rectangle,minimum height=\RN@dayheight,%
          text width=\RN@daywidth,draw=black
          ]{\RN@formatDayNb{\tikzdaytext}%
            \RN@formatDay{\pgfcalendarcurrentweekday}%
            \ifRN@showweeknumbers
              \ifdate{Monday}{\stepcounter{weeknumber}%
                \RN@formatWeekNb{weeknumber}}{}%
            \fi};
        },%
        execute before day scope={%
          \ifdate{day of month=1}{%
            \pgftransformxshift{\dimexpr\RN@daywidth+\RN@daysep}%
            % Print month name
            \draw (0,0)node [shape=rectangle,minimum height=\RN@dayheight,%
              text width=\RN@daywidth,fill=\RN@monthBGcolor,%
              draw=\RN@monthBGcolor,text=\RN@monthColor,text centered]{%
              \RN@monthFont\pgfcalendarmonthname{\pgfcalendarcurrentmonth}};
          }{}%
          \ifdate{workday}{\tikzset{every day/.style=%
            {fill=\RN@workdayColor}}}{}%
          \RN@periods
          \ifdate{Saturday}{\tikzset{every day/.style=%
            {fill=\RN@saturdayColor}}}{}%
          \ifdate{Sunday}{\tikzset{every day/.style=%
            {fill=\RN@sundayColor}}}{}%
          \RN@backgrounds
        },%
        execute at begin day scope={%
          \pgftransformyshift{-\pgfcalendarcurrentday\RN@dayheight}%
        }%
      ];%
      \pgfcalendarifdate{#1}{at most=06-last}{\RN@events@I}{\RN@events@II}%
    \end{tikzpicture}%
  }%
  \parbox[c][\RN@calheight]{\RN@calwidth}{%
    \vfill
    \centering
    \RN@formatTitle{\wd\RN@tempbox}{\RN@yearText}{\RN@title}%
    \vfill
    \usebox\RN@tempbox
    \vfill
  }%
}

\newcommand*\makeKalender{%
  \setcounter{weeknumber}{0}%
  \begingroup
    \let\year=\RN@year
    \def\RN@period@i##1##2[##3]{}% 1st loop: only the events 
    \def\do##1{\InputIfFileExists{##1.events}{}{}}%
    \expandafter\docsvlist\expandafter{\RN@events@files}%
  \endgroup
  \begingroup
    \let\year=\RN@year
    \def\RN@event@ii##1##2[##3]{}% 2nd loop: only the periods 
    \def\do##1{\InputIfFileExists{##1.events}{}{}}%
    \expandafter\docsvlist\expandafter{\RN@events@files}%
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
%%
%% End of file `tikz-kalender.cls'.




