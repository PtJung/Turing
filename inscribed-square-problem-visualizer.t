setscreen ("graphics:800;800")

%%%%%
%        Author:    Patrick Jung
%       Version:    2019-03-16
%   Description:    This program visualizes the inscribed square problem (aka. square peg problem, Toeplitz' conjecture), which asks if every simple 
%                   closed curve contains all four verticles of some square; it will find the first square of the user's drawing, upon pressing the 
%                   UP arrow key. The DOWN arrow key erases everything.
%
%                   This program is not made to keep up with very fast doodles; it is recommended that the user draws slowly, so that the drawing is 
%                   fully filled. The program's performance is based on how much has been drawn on the screen and the size of the shape.
%%%%%

% Declarations
const maxRadCheck := 800
const midx := maxx div 2
const midy := maxy div 2

var colourCoords : array 1 .. maxx, 1 .. maxy of boolean

% Procedure: draws a square, given the x and y coordinates of four points, and a colour
procedure drawSquare (px1 : int, py1 : int, px2 : int, py2 : int, px3 : int, py3 : int, px4 : int, py4 : int, customColour : int)
    const vertexRad := 2
    
    drawline (px1, py1, px2, py2, customColour)
    drawline (px1, py1, px3, py3, customColour)
    drawline (px2, py2, px4, py4, customColour)
    drawline (px3, py3, px4, py4, customColour)
    drawfilloval(px1, py1, vertexRad, vertexRad, black)
    drawfilloval(px2, py2, vertexRad, vertexRad, black)
    drawfilloval(px3, py3, vertexRad, vertexRad, black)
    drawfilloval(px4, py4, vertexRad, vertexRad, black)
    
end drawSquare

% Procedure: checks and draws a possible square (with side lengths from minRad to maxRad units) on the user's drawing
procedure checkDrawForSquare (minRad : int, maxRad : int)
    const rev := Math.PI * 2
    var pointOnX1, pointOnY1, pointOnX2, pointOnY2, pointOnX3, pointOnY3 : int

    % Tests with all radiuses (minRad to maxRad units) or side-lengths of the possible square, for every possible (x, y) pair
    for radius : minRad .. maxRad
	for currX : 1 .. maxx
	    for currY : 1 .. maxy
	
		% Tests if the current point is filled; if so, continue
		if colourCoords (currX, currY) = true then
	    
		    % Tests for all squares by rotating it about the current point, with some radius; if tested correctly, draws the square
		    for degree : 0 .. 359
			pointOnX1 := currX + round (cos (degree / 360 * rev) * radius)
			pointOnY1 := currY + round (sin (degree / 360 * rev) * radius)
			
			if (pointOnX1 >= 1 and pointOnX1 <= maxx) and (pointOnY1 >= 1 and pointOnY1 <= maxy) and colourCoords (pointOnX1, pointOnY1) = true then
			    pointOnX2 := currX + round (cos ((degree - 90) / 360 * rev) * radius)
			    pointOnY2 := currY + round (sin ((degree - 90) / 360 * rev) * radius)
			    
			    if (pointOnX2 >= 1 and pointOnX2 <= maxx) and (pointOnY2 >= 1 and pointOnY2 <= maxy) and colourCoords (pointOnX2, pointOnY2) = true then
				pointOnX3 := currX + round (cos ((degree - 45) / 360 * rev) * radius * sqrt (2))
				pointOnY3 := currY + round (sin ((degree - 45) / 360 * rev) * radius * sqrt (2))
				
				if (pointOnX3 >= 1 and pointOnX3 <= maxx) and (pointOnY3 >= 1 and pointOnY3 <= maxy) and colourCoords (pointOnX3, pointOnY3) = true then
				    drawSquare (currX, currY, pointOnX1, pointOnY1, pointOnX2, pointOnY2, pointOnX3, pointOnY3, 32)
				    return
				end if
			    end if
			end if
		    end for
		end if
	    end for
	end for
    end for
end checkDrawForSquare

% Procedure: reset all coloured points for the array
procedure resetColoured
    for currX : 1 .. maxx
	for currY : 1 .. maxy
	    colourCoords (currX, currY) := false
	end for
    end for
end resetColoured

% Main-line logic
procedure main
    var chars : array char of boolean
    var drawX, drawY, drawB : int

    resetColoured
    loop
	% Input via mouse
	mousewhere (drawX, drawY, drawB)
	if (drawX >= 1 and drawX <= maxx) and (drawY >= 1 and drawY <= maxy) and drawB = 1 then

	    drawdot (drawX, drawY, black)
	    colourCoords (drawX, drawY) := true
	    drawB := 0
	end if

	% Input via keyboard
	Input.KeyDown (chars)
	if chars (KEY_UP_ARROW) then
	    % Checks for a square to draw, drawing it when possible
	    put "Drawing a possible square with side lengths of up to ", maxRadCheck, " units..." ..
	    checkDrawForSquare (5, maxRadCheck)
	    put " finished."

	elsif chars (KEY_DOWN_ARROW) then
	    % Resets and clears the entire screen of all text, squares, and drawings
	    resetColoured
	    cls
	end if
    end loop
end main

% Run main
main

