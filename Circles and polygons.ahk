#IfWinActive Народная карта — Яндекс.Карты

SetParameters:

TopPanelHeight    := 100 ;Расстояние в пикселях от верхнего края окна браузера до верхнего края карты
BottomPanelHeight := 0   ;Расстояние в пикселях от нижнего края окна браузера до нижнего края карты
LeftPanelWidth    := 0   ;Расстояние в пикселях от левого края окна браузера до левого края карты
RightPanelWidth   := 0   ;Расстояние в пикселях от правого края окна браузера до правого края карты

NoSnapping := 1 ;Переключать режим залипания во время рисования (имитирует клавишу SHIFT) (1 = да, 0 = нет)
return

/*
Приложение, необходимое для выполнения скрипта, можно скачать на www.autohotkey.com


ДОСТУПНЫЕ КОМАНДЫ:
  ALT [+ SHIFT] + R — Нарисовать окружность по трём точкам (SHIFT - указать количество узлов вручную)
  ALT [+ SHIFT] + D — Нарисовать дугу окружности по трём точкам (от 1-й до 2-й точки против часовой стрелки) (SHIFT - указать количество узлов вручную)
  ALT [+ SHIFT] + ЛКМ — Скруглить угол (удерживайте SHIFT, когда пункт «скруглить угол» находится в 4-й строке меню)
  CTRL + ЛКМ — Удалить вершину (имитация двойного нажатия)


ИСТОРИЯ ВЕРСИЙ:
* исправлено / изменено
+ добавлено

30.04.2016

  + Возможность рисования дуг окружностей.

  + Автоматическое прерывание процесса рисования, если мышь приближается к краю окна. Границы области, доступной для рисования, регулируются параметрами: TopPanelHeight, BottomPanelHeight, LeftPanelWidth, RightPanelWidth.
  
  + Автоматическое определение количества узлов при рисовании дуг и окружностей.

  + Больше не нужно каждый раз отключать режим залипания, чтобы узлы окружности не прилипали к соседним объектам. Скрипт во время рисования имитирует нажатую клавишу SHIFT. Можно отключить, установив параметр NoSnapping := 0

  * Рисование окружностей, так же, как дуг, начинается с 1-й указанной точки и выполняется против часовой стрелки.

  * Всплывающие окна позиционируются относительно окна браузера, а не 1-го монитора; Подсказки «наведите мышь на N-ю точку...» сдвинуты в левый верхний угол.

  * Заблокировано возможное случайное перемещение мыши пользователем во время выполнения команд.
  
23.04.2016

  + Возможность скругления углов в один клик.

  * Учтён изменившийся заголовок окна («Народная карта — Яндекс.Карты» вместо «Народная карта Яндекса»), из-за чего старый скрипт перестал работать.

  * Удаление вершин в один клик происходит при удержании клавиши CTRL вместо ALT.

26.10.2015

  + Возможность прервать процесс рисования окружности нажатием клавиши ПРОБЕЛ.

  * При рисовании окружности по трём точкам: на этапе указания точек вместо вывода диалоговых окон с кнопкой «ОК» скрипт ожидает нажатия клавиши ПРОБЕЛ.

*/



GetSegmentLength(x1, y1, x2, y2)
{
  return Sqrt((x1 - x2)**2 + (y1 - y2)**2)
}



GetRadius(a, b, c)
{
  p := (a+b+c)/2
  s := Sqrt(p*(p-a)*(p-b)*(p-c))
  rs := (a*b*c)/(4*s)
  return rs
}



GetCenter(x1, y1, x2, y2, x3, y3, ByRef x0, ByRef y0)
{
  A1 := x2 - x1
  B1 := y2 - y1
  C1 := (x2-x1)*(x2+x1)/2 + (y2-y1)*(y2+y1)/2
  A2 := x3 - x1
  B2 := y3 - y1
  C2 := (x3-x1)*(x3+x1)/2 + (y3-y1)*(y3+y1)/2
  x0 := (C1*B2 - C2*B1)/(A1*B2 - A2*B1)
  y0 := (A1*C2 - A2*C1)/(A1*B2 - A2*B1)
}







;Рисование окружности или дуги окружности по трём точкам
!d::
AskForN := 0
WholeRound := 0
GoTo StartDrawRound

!+d::
AskForN := -1
WholeRound := 0
GoTo StartDrawRound

!r::
AskForN := 0
WholeRound := -1
GoTo StartDrawRound

!+r::
AskForN := -1
WholeRound := -1
GoTo StartDrawRound


StartDrawRound:

GoSub SetParameters

if WholeRound
  whats := "окружности"
else
  whats := "дуги"

WinGetPos, winX, winY, winW, winH

SplashTextOn 290, 40, Рисование %whats% по трём точкам, Наведите мышь на 1-ю точку`nи нажмите пробел...
WinMove, Рисование %whats% по трём точкам, , winX + LeftPanelWidth + 30, winY + TopPanelHeight + 70
KeyWait, Space, D
MouseGetPos, x1, y1
sleep, 250

SplashTextOn 290, 40, Рисование %whats% по трём точкам, Наведите мышь на 2-ю точку`nи нажмите пробел...
WinMove, Рисование %whats% по трём точкам, , winX + LeftPanelWidth + 30, winY + TopPanelHeight + 70
KeyWait, Space, D
MouseGetPos, x2, y2
sleep, 250

SplashTextOn 290, 40, Рисование %whats% по трём точкам, Наведите мышь на 3-ю точку`nи нажмите пробел...
WinMove, Рисование %whats% по трём точкам, , winX + LeftPanelWidth + 30, winY + TopPanelHeight + 70
KeyWait, Space, D
SplashTextOff
MouseGetPos, x3, y3

x0 := 0
y0 := 0
as := GetSegmentLength(x1, y1, x2, y2)
bs := GetSegmentLength(x1, y1, x3, y3)
cs := GetSegmentLength(x3, y3, x2, y2)
r  := GetRadius(as, bs, cs)

GetCenter(x1, y1, x2, y2, x3, y3, x0, y0)

pi  := 3.1415926535898
dx1 := x1-x0
dy1 := y1-y0
dx2 := x2-x0
dy2 := y2-y0

alfa := Atan((y0-y1) / ABS(x1-x0))

if dx1 < 0
{
  alfa := pi - alfa
}

if WholeRound
{
  gamma := 2.*pi
}
else
{
  beta := Atan((y0-y2) / ABS(x2-x0))

  if dx2 < 0
    beta := pi - beta

  gamma := 2.*pi + beta - alfa

  while gamma > 2.*pi
    gamma := gamma - 2.*pi
}

if AskForN
{
  n := 0
  n0 := Ceil(r ** 0.66 * gamma / 2. / pi)
  While n <= 1
  {
    InputBox, n, Рисование %whats% по трём точкам, Введите количество узлов: (предлагаемое значение: %n0%), , 380, 125, winX + (winW - 380) / 2, winY + (winH - 125) / 2

    if not WholeRound
      n--

    if errorlevel = 1
      Goto StopScript
  }
}
else
{
  n := Ceil(r ** 0.66 * gamma / 2. / pi)
}


txt := "Чтобы прервать процесс,`nнажмите пробел."
SplashTextOn 290, 40, Рисование %whats% по трём точкам, %txt%
WinMove, Рисование %whats% по трём точкам, , winX + LeftPanelWidth + 30, winY + TopPanelHeight + 70
BlockInput, MouseMove

x := 0
gamma := gamma / n
while x < n
{
  px := x0 + cos(alfa + gamma * x) * r
  py := y0 - sin(alfa + gamma * x) * r
  x++

  if (px < winX + LeftPanelWidth + 50) || (px > winX + winW - RightPanelWidth - 425) || (py < winY + TopPanelHeight + 50) || (py > winY + winH - 50 - BottomPanelHeight)
    Goto StopScript

  if NoSnapping = 0
    click, %px%, %py%
  else
    Send +{click, %px%, %py%}

  GetKeyState, KeyPressed, Space
  if KeyPressed = D
    Goto StopScript

  sleep, 150
}

if not WholeRound
{
  if NoSnapping = 0
    click, %x2%, %y2%
  else
    Send +{click, %x2%, %y2%}
}

StopScript:
BlockInput, MouseMoveOff
SplashTextOff
Exit




;Двойной клик для удаления точки
LCtrl & LButton::
BlockInput, MouseMove
click
click
BlockInput, MouseMoveOff
return




;Скруглить угол
!LButton::
dy := 60
GoTo RoundCorner

!+LButton::
dy := 80

RoundCorner:
BlockInput, MouseMove
MouseGetPos, x1, y1
x2 := x1 + 30
y2 := y1 + dy
click
click, %x2%, %y2%
MouseMove, x1, y1
BlockInput, MouseMoveOff
return

