(** Everything you need to have a complete interacting application: console input/output, single window input/output, random numbers and time management. *)

(** {6 Declared types} *)

type color
(** Internal representation of colors. See {!Interaction.getPixelColor}. *)

type image
(** The abstract type for images. See {!Interaction.getImage} and {!Interaction.drawImage}. *)

type event =
  | ButtonDown  (** A mouse button is pressed *)
  | ButtonUp    (** A mouse buton is released *)
  | KeyPressed  (** A key is pressed *)
  | MouseMotion (** The mouse is moved *)
  | Poll         (** Don't wait, contiue immediately *)
(** To specify events to wait for. See {!Interaction.waitNextEvent} *)

type interaction
(** Type listing all possible actions.  Every constructor of this type is provided below as a function.  For example the constructor of [interaction] declared as [| PrintString of string -> (unit -> interaction)] is provided by the function [printString : string -> (unit -> interaction) -> interaction] whose code is simply [let printString s continue = PrintString (s, continue)] *)

(** {6 Console input/ouput} *)
  
val argv : (string list -> interaction) -> interaction
(** Pass the command line arguments given to the process to the continuation.
   The first element is the command name used to invoke the program.
   The following elements are the command-line arguments
   given to the program. *)

val printString : string -> (unit -> interaction) -> interaction
(** Print a string on standard output. *)

val readString : (string -> interaction) -> interaction
(** Flush standard output, then read characters from standard input until a newline character is encountered. Call the continuation with the string of all characters read, without the newline character at the end. *)

(** {6 Random numbers} *)

val randInit : int -> (unit -> interaction) -> interaction
(** Initialize the generator, using the argument as a seed.
    The same seed will always yield the same sequence of numbers. *)

val randSelfInit : (unit -> interaction) -> interaction
(** Initialize the generator with a random seed chosen
   in a system-dependent way.  If [/dev/urandom] is available on
   the host machine, it is used to provide a highly random initial
   seed.  Otherwise, a less random seed is computed from system
   parameters (current time, process IDs). *)

val randInt : int -> (int -> interaction) -> interaction
(** [randInt bound continue] calls [continue] with a random integer between 0 (inclusive)
     and [bound] (exclusive).  [bound] must be greater than 0 and less
     than 2{^30}. *)

val randFloat : float -> (float -> interaction) -> interaction
(** [randFloat bound continue] calls [continue] with a random floating-point number
   between 0 and [bound] (inclusive).  If [bound] is
   negative, the result is negative or zero.  If [bound] is 0,
   the result is 0. *)

val randBool : (bool -> interaction) -> interaction
(** [randBool continue] calls [continue] with [true] or [false] with probability 0.5 each. *)                 
(*
(** {6 Time management} *)

val time : (float -> interaction) -> interaction
(** Call the continuation with the processor time, in seconds, used by the program
   since the beginning of execution. *)

val sleep : float -> (unit -> interaction) -> interaction
(** Wait for the given number of seconds. *)
 *)

(** {6 Single window management} *)

val openWindow : string -> (unit -> interaction) -> interaction
(** Show the graphics window or switch the screen to graphic mode. The graphics window is cleared and the cursor is set to [(0,0)] which is the lower left corner or the window. The string argument is used to pass optional information on the desired graphics mode, the graphics window size, and so on. Its interpretation is implementation-dependent. If the empty string is given, a sensible default is selected. *)

val closeWindow : (unit -> interaction) -> interaction
(** Delete the graphics window or switch the screen back to text mode. *)

val setWindowTitle : string -> (unit -> interaction) -> interaction
(** Set the title of the graphics window. *)

val resizeWindow : int -> int -> (unit -> interaction) -> interaction
(** Resize and erase the graphics window. *)

val windowSize : (int -> int -> interaction) -> interaction
(** Return the size of the graphics window. Coordinates of the screen pixels range over [0 .. width-1] and [0 .. height-1] where [width] and [height] are the informations passed to the continuation. Drawings outside of this rectangle are clipped, without causing an error. The origin [(0,0)] is at the lower left corner.  *)

  (** {6 Double buffering} *)
                                        
val autoSynchronize : bool -> (unit -> interaction) -> interaction
(** By default, drawing takes place both on the window displayed on screen, and in a memory area (the 'backing store'). The backing store image is used to re-paint the on-screen window when necessary. 

To avoid flicker during animations, it is possible to turn off on-screen drawing, perform a number of drawing operations in the backing store only, then refresh the on-screen window explicitly.

[autoSynchronize false continue] turns on-screen drawing off. All subsequent drawing commands are performed on the backing store only. 

[autoSynchronize true continue] refreshes the on-screen window from the backing store (as per Synchronize), then turns on-screen drawing back on. All subsequent drawing commands are performed both on screen and in the backing store. 

The default drawing mode corresponds to auto-synchronization set to true. *)

val synchronize : (unit -> interaction) -> interaction
(** Synchronize the backing store and the on-screen window, by copying the contents of the backing store onto the graphics window. *)

val displayMode : bool -> (unit -> interaction) -> interaction
(** Set display mode on or off. When turned on, drawings are done in the graphics window; when turned off, drawings do not affect the graphics window. This occurs independently of drawing into the backing store (see {!Interaction.rememberMode} below). Default display mode is on. *)

val rememberMode : bool -> (unit -> interaction) -> interaction
(** Set remember mode on or off. When turned on, drawings are done in the backing store; when turned off, the backing store is unaffected by drawings. This occurs independently of drawing onto the graphics window (see {!Interaction.displayMode} above). Default remember mode is on. *)

val getPixelColor : int -> int -> (color -> interaction) -> interaction
(** Pass to the continuation the color of the given pixel in the backing store. *)

val rgb : int -> int -> int -> color
(** [rgb r g b] is a regular function that returns the color with red component [r], green component [g], and blue component [b]. [r], [g] and [b] are in the range [0..255]. *)

val black : color
val white : color
val red : color
val green : color
val blue : color
val yellow : color
val cyan : color
val magenta : color
                
val background : color
val foreground : color
(** Regular identifier naming the default background and foreground colors (usually, either black foreground on a white background or white foreground on a black background). The "action" {!Interaction.clearWindow} fills the screen with the background color. The initial drawing color is foreground. *)

val transp : color
(** In matrices of colors, this color represent a 'transparent' point: when drawing the corresponding image, all pixels on the screen corresponding to a transparent pixel in the image will not be modified, while other points will be set to the color of the corresponding point in the image. This allows superimposing an image over an existing background. *)

(** {6 Drawing and filling } *)

val setColor : color -> (unit -> interaction) -> interaction
(** Set the current drawing color. *)

val setLineWidth : int -> (unit -> interaction) -> interaction
(** Set the width of points and lines drawn with the functions above. Under X Windows, set_line_width 0 selects a width of 1 pixel and a faster, but less precise drawing algorithm than the one used when set_line_width 1 is specified. Raise [Invalid_argument] if the argument is negative. *)
                                                              
val clearWindow : (unit -> interaction) -> interaction
(** Erase the graphics window.  *)

val drawPixel : int -> int -> (unit -> interaction) -> interaction
(** Draw a pixel with the current drawing color. *)

val drawLines : (int * int * int * int) list -> (unit -> interaction) -> interaction
(** [drawLines lines continue] draws the lines given in the list argument. Each line is specified as a quadruple [(x0, y0, x1, y1)] where [(x0, y0)] and [(x1, y1)] are the coordinates of the end points of the lines. *)

val drawJointLines : (int * int) list -> (unit -> interaction) -> interaction
(** [drawJointLines points continue] draws the line that joins the points given by the list argument. The list contains the coordinates of the vertices of the polygonal line, which need not be closed. *)

val drawPolygon : (int * int) list -> (unit -> interaction) -> interaction
(** [drawPolygon polygon continue] draws the given polygon. The list contains the coordinates of the vertices of the polygon. *)

val drawRectangle : int -> int -> int -> int -> (unit -> interaction) -> interaction
(** [drawRect x y w h continue] draws the rectangle with lower left corner at [x],[y], width [w] and height [h]. Raise [Invalid_argument] if [w] or [h] is negative. *)

val drawArc : int -> int -> int -> int -> int -> int -> (unit -> interaction) -> interaction
(** [drawArc x y rx ry a1 a2 continue] draws an elliptical arc with center [x],[y], horizontal radius [rx], vertical radius [ry], from angle [a1] to angle [a2] (in degrees). Raise [Invalid_argument] if [rx] or [ry] is negative. *)

val drawEllipse : int -> int -> int -> int -> (unit -> interaction) -> interaction
(** [drawEllipse x y rx ry continue] draws an ellipse with center [x],[y], horizontal radius [rx] and vertical radius [ry]. Raise [Invalid_argument] if [rx] or [ry] is negative. *)

val drawCircle : int -> int -> int -> (unit -> interaction) -> interaction
(** [drawCircle x y r continue] draws a circle with center [x],[y] and radius [r]. Raise [Invalid_argument] if [r] is negative. *)

val fillPolygon : (int * int) list -> (unit -> interaction) -> interaction
val fillRectangle : int -> int -> int -> int -> (unit -> interaction) -> interaction
val fillArc : int -> int -> int -> int -> int -> int -> (unit -> interaction) -> interaction
val fillEllipse : int -> int -> int -> int -> (unit -> interaction) -> interaction
val fillCircle : int -> int -> int -> (unit -> interaction) -> interaction
(** Same as their {!Interaction.drawPolygon}, {!Interaction.drawRectangle}, {!Interaction.drawArc}, {!Interaction.drawEllipse} and {!Interaction.drawCircle} counterpart, but fills the drawn shape with the current color. *)

(** {6 Text drawing} *)
                                                            
val setFont : string -> (unit -> interaction) -> interaction
(** Set the font used for drawing text. The interpretation of the argument to [setFont] is implementation-dependent. *)

val setFontSize : int -> (unit -> interaction) -> interaction
(** Set the character size used for drawing text. The interpretation of the argument to SetTextSize is implementation-dependent. *)

val getTextSize : string -> (int -> int -> interaction) -> interaction
(** Pass to the continuation the dimensions of the given text, if it were drawn with the current font and size. *)

val drawChar : int -> int -> char -> (unit -> interaction) -> interaction
val drawString : int -> int -> string -> (unit -> interaction) -> interaction
(** Draw a character or a character string with lower left corner at specified position. *)

(** {6 Images} *)
                                                 
val getImage : int -> int -> int -> int -> (image -> interaction) -> interaction
(** Draw the given image with lower left corner at the given point. *)

val drawImage : image -> int -> int -> (unit -> interaction) -> interaction
(** Capture the contents of a rectangle on the screen as an image. The parameters are the same as for FillRectangle. *)
                                                   
(** {6 Mouse and keybord event handling } *)

val waitNextEvent : event list -> (int -> int -> bool -> bool -> char -> interaction) -> interaction
(** [waitNextEvent el continue] waits until one of the events specified in the given event list occurs, and call [continue mouse_x mouse_y button keypressed key] where [mouse_x] and [mouse_y] are the position of the mouse, [button] indicates if a mouse button is pressed, [keypressed] indicates if a key has been pressed and key is the key pressed. If [Poll] is given in the event list, the continuation is called immediately with the current status of the mouse and keyboard. If the mouse cursor is outside of the graphics window, the [mouse_x] and [mouse_y] fields of the event are outside the range [0..width-1], [0..height-1]. Keypresses are queued, and dequeued one by one when the [Key_pressed] event is specified. *)

val quit : interaction
(** Quit the application *)

(* La fonction qui fait tout fonctionner, ne peut être appeler qu'une fois *)
             
val execute : interaction -> unit
