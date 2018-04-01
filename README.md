## A LaTeX based calendar using TikZ

For usage see the example files »tikz-kalender-example1.tex«, 
»tikz-kalender-example2.tex«, and »*.events«. See also my [Git 
repository](https://github.com/rolfn/kalenderRN). The Code is inspired by this 
[document](http://www.texample.net/tikz/examples/a-calender-for-doublesided-din-a4/) 
and has the »Creative Commons attribution license (CC-BY-SA)«.

The class »tikz-kalender« requires the package »tikz« and the tkiz libraries 
»calc« and »calendar«.

### Short Description

#### Keys for the macro \setup

`\setup[key1=value1,key2=value2,..]`

##### General

* `year=`_year of the calendar_
* `yearText=`_text for the year_ (default: 4-digit current year)
* `title=`_title of the calendar_
* `events=`_list of files with events or periods_ (without the ending `.events`)
* `showweeknumbers=`_true or empty or false_ (showing the number of the week)
* `lang=`_language for marking_ (option passed to package babel)
* `paper=`_papersize abbreviation_ (understandable by package geometry;
default: a4)
* `print=`_true or empty or false_ (printer-friendly orientation for
double-side printing; default: false)
* `xcoloroptions=`_options_ (passed to package xcolor; default: svgnames)

##### Color definitions

* `titleColor=...` (default: dark)
* `eventColor=...` (default: medium)
* `periodColor=...` (default: period)
* `monthBGcolor=...` (background; default: dark)
* `monthColor=...` (default: white)
* `workdayColor=...`
* `saturdayColor=...` (default: bright)
* `sundayColor=...` (default: medium)

The default colors:

* dark: `{HTML}{A57C00}`
* medium: `dark!35`
* bright: `dark!20`
* period: `gray!30`

##### Font definitions

* `titleFont=...`
* `yearFont=...`
* `monthFont=...`
* `dayFont=...`
* `dayNbFont=...`
* `weekNbFont=...`
* `eventFont=...`

##### Examples

* `titleFont={\fontsize{1.2em}{1.2em}}`
* `yearFont={\itshape}`
* `titleColor=IndianRed3` (required `xcoloroptions={x11names}`)

#### Macros \event and \period inside of events files

##### Examples

* `\event{\year-10-09}{John Lennon (1940)}`; uncolored every year event 

* `\event*{2016-03-27}{Ostersonntag}`; event colored with the color defined
by the key `eventColor` (general holiday)

* `\event*{2016-07-10}{Fußball-EM: Endspiel}[color=DarkTurquoise]`;
colored event with a special color

* `\period{2016-12-23}{2017-01-03}`; period colored with the color defined
by the key `periodColor`

* `\period{2016-02-01}{2016-02-06}[color=LightGreen]`; period colored with a
special color

* `\period{2016-09-12}{2016-10-04}[color=red!30,name=Urlaub]`; named period
colored with a special color

Rolf Niepraschk, 2018-04-01
