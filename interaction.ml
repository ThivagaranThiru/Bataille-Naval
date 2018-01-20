type color = Graphics.color
       
let rgb = Graphics.rgb;;
let black = Graphics.black;;
let white = Graphics.white;;
let red = Graphics.red;;
let green = Graphics.green;;
let blue = Graphics.blue;;
let yellow = Graphics.yellow;;
let cyan = Graphics.cyan;;
let magenta = Graphics.magenta;;
                
let transp = Graphics.transp;;
let background = Graphics.background;;
let foreground = Graphics.foreground;;

type image = Graphics.image;;

type event =
  | ButtonDown
  | ButtonUp
  | KeyPressed
  | MouseMotion
  | Poll
;;

let to_event evt : event =
  match evt with
  | Graphics.Button_down -> ButtonDown
  | Graphics.Button_up -> ButtonUp
  | Graphics.Key_pressed -> KeyPressed
  | Graphics.Mouse_motion -> MouseMotion
  | Graphics.Poll -> Poll
;;
  
let of_event evt : Graphics.event =
  match evt with
  | ButtonDown -> Graphics.Button_down
  | ButtonUp -> Graphics.Button_up
  | KeyPressed -> Graphics.Key_pressed
  | MouseMotion -> Graphics.Mouse_motion
  | Poll -> Graphics.Poll
;;
  
type interaction =
  | Argv of (string list -> interaction)
  | PrintString of string * (unit -> interaction)
  | ReadString of (string -> interaction)

  | RandInit of int * (unit -> interaction)
  | RandSelfInit of (unit -> interaction)
  | RandInt of int * (int -> interaction)
  | RandFloat of float * (float -> interaction)
  | RandBool of (bool -> interaction)
  (*           
  | Time of (float -> interaction)
  | Sleep of float * (unit -> interaction)
   *)
  | OpenWindow of string * (unit -> interaction)
  | CloseWindow of (unit -> interaction)
  | SetWindowTitle of string * (unit -> interaction)
  | ResizeWindow of int * int * (unit -> interaction)
  | ClearWindow of (unit -> interaction)
  | WindowSize of (int -> int -> interaction)
                      
  | AutoSynchronize of bool * (unit -> interaction)
  | Synchronize of (unit -> interaction)
  | DisplayMode of bool * (unit -> interaction)
  | RememberMode of bool * (unit -> interaction)
  | GetPixelColor of int * int * (color -> interaction)
  
  | SetColor of color * (unit -> interaction)
  | SetLineWidth of int * (unit -> interaction)
  
  | DrawPixel of int * int * (unit -> interaction)
  | DrawLines of (int * int * int * int) list * (unit -> interaction)
  | DrawJointLines of (int * int) list * (unit -> interaction)
  | DrawPolygon of (int * int) list * (unit -> interaction)
  | DrawRectangle of int * int * int * int * (unit -> interaction)
  | DrawArc of int * int * int * int * int * int * (unit -> interaction)
  | DrawEllipse of int * int * int * int * (unit -> interaction)
  | DrawCircle of int * int * int * (unit -> interaction)
  | FillPolygon of (int * int) list * (unit -> interaction)
  | FillRectangle of int * int * int * int * (unit -> interaction)
  | FillArc of int * int * int * int * int * int * (unit -> interaction)
  | FillEllipse of int * int * int * int * (unit -> interaction)
  | FillCircle of int * int * int * (unit -> interaction)
  
  | SetFont of string * (unit -> interaction)
  | SetFontSize of int * (unit -> interaction)
  | GetTextSize of string * (int -> int -> interaction)
  | DrawChar of int * int * char * (unit -> interaction)
  | DrawString of int * int * string * (unit -> interaction)
  
  | GetImage of int * int * int * int * (image -> interaction)
  | DrawImage of image * int * int * (unit -> interaction)
  
  | WaitNextEvent of event list * (int -> int -> bool -> bool -> char -> interaction)

  | Quit
;;

let rec execute interaction =
  match interaction with
  | Argv cnt ->
     execute (cnt (Array.to_list Sys.argv))
  | PrintString (s, cnt) ->
     execute (cnt (print_string s))
  | ReadString cnt ->
     execute (cnt (read_line ()))
                    
  | RandInit (i, cnt) ->
     execute (cnt (Random.init i))
  | RandSelfInit cnt ->
     execute (cnt (Random.self_init ()))
  | RandInt (i, cnt) ->
     execute (cnt (Random.int i))
  | RandFloat (f, cnt) ->
     execute (cnt (Random.float f))
  | RandBool cnt ->
     execute (cnt (Random.bool ()))
  (*            
  | Time cnt ->
     execute (cnt (Sys.time ()))
  | Sleep (f, cnt) ->
     execute (cnt (Thread.delay f))
   *)            
  | OpenWindow (s, cnt) ->
     execute (cnt (Graphics.open_graph s))
  | CloseWindow cnt ->
     execute (cnt (Graphics.close_graph ()))
  | SetWindowTitle (s, cnt) ->
     execute (cnt (Graphics.set_window_title s))
  | ResizeWindow (w, h, cnt) ->
     execute (cnt (Graphics.resize_window w h))
  | ClearWindow (cnt) ->
     execute (cnt (Graphics.clear_graph ()))
  | WindowSize cnt ->
     execute (cnt (Graphics.size_x ()) (Graphics.size_y ()))
                      
  | AutoSynchronize (b, cnt) ->
     execute (cnt (Graphics.auto_synchronize b))
  | Synchronize cnt ->
     execute (cnt (Graphics.synchronize ()))
  | DisplayMode (b, cnt) ->
     execute (cnt (Graphics.display_mode b))
  | RememberMode (b, cnt) ->
     execute (cnt (Graphics.remember_mode b))
  | GetPixelColor (x, y, cnt) ->
     execute (cnt (Graphics.point_color x y))
  
  | SetColor (c, cnt) ->
     execute (cnt (Graphics.set_color c))
  | SetLineWidth (lw, cnt) ->
     execute (cnt (Graphics.set_line_width lw))
  
  | DrawPixel (x, y, cnt) ->
     execute (cnt (Graphics.plot x y))
  | DrawLines (ll, cnt) ->
     execute (cnt (Graphics.draw_segments (Array.of_list ll)))
  | DrawJointLines (pl, cnt) ->
     execute (cnt (Graphics.draw_poly_line (Array.of_list pl)))
  | DrawPolygon (pl, cnt) ->
     execute (cnt (Graphics.draw_poly (Array.of_list pl)))
  | DrawRectangle (x, y, w, h, cnt) ->
     execute (cnt (Graphics.draw_rect x y w h))
  | DrawArc (x, y, rx, ry, a1, a2, cnt) ->
     execute (cnt (Graphics.draw_arc x y rx ry a1 a2))
  | DrawEllipse (x, y, rx, ry, cnt) ->
     execute (cnt (Graphics.draw_ellipse x y rx ry))
  | DrawCircle (x, y, r, cnt) ->
     execute (cnt (Graphics.draw_circle x y r))
  | FillPolygon (pl, cnt) ->
     execute (cnt (Graphics.fill_poly (Array.of_list pl)))
  | FillRectangle (x, y, w, h, cnt) ->
     execute (cnt (Graphics.fill_rect x y w h))
  | FillArc (x, y, rx, ry, a1, a2, cnt) ->
     execute (cnt (Graphics.fill_arc x y rx ry a1 a2))
  | FillEllipse (x, y, rx, ry, cnt) ->
     execute (cnt (Graphics.fill_ellipse x y rx ry))
  | FillCircle (x, y, r, cnt) ->
     execute (cnt (Graphics.fill_circle x y r))
  
  | SetFont (f, cnt) ->
     execute (cnt (Graphics.set_font f))
  | SetFontSize (s, cnt) ->
     execute (cnt (Graphics.set_text_size s))
  | GetTextSize (s, cnt) ->
     let w, h = Graphics.text_size s in
     execute (cnt w h)
  | DrawChar (x, y, c, cnt) ->
     execute (cnt (Graphics.moveto x y; Graphics.draw_char c))
  | DrawString (x, y, s, cnt) ->
     execute (cnt (Graphics.moveto x y; Graphics.draw_string s))
  
  | GetImage (x, y, w, h, cnt) ->
     execute (cnt (Graphics.get_image x y w h))
  | DrawImage (img, x, y, cnt) ->
     execute (cnt (Graphics.draw_image img x y))
  
  | WaitNextEvent (el, cnt) ->
     let st = Graphics.wait_next_event (List.map of_event el) in
     execute (cnt st.Graphics.mouse_x st.Graphics.mouse_y st.Graphics.button
                  st.Graphics.keypressed st.Graphics.key)
  | Quit -> exit 0
;;

let argv cnt = Argv (cnt);;
let printString s cnt = PrintString (s, cnt);;
let readString cnt = ReadString (cnt);;

let randInit i cnt = RandInit (i, cnt)
let randSelfInit cnt = RandSelfInit (cnt)
let randInt i cnt = RandInt (i, cnt)
let randFloat f cnt = RandFloat (f, cnt)
let randBool cnt = RandBool (cnt)
(*
let time cnt = Time (cnt)
let sleep f cnt = Sleep (f, cnt)
 *)
let openWindow s cnt = OpenWindow (s, cnt);;
let closeWindow cnt = CloseWindow (cnt);;
let setWindowTitle s cnt = SetWindowTitle (s, cnt);;
let resizeWindow w h cnt = ResizeWindow (w, h, cnt);;
let clearWindow cnt = ClearWindow (cnt);;
let windowSize cnt = WindowSize (cnt);;
                      
let autoSynchronize b cnt = AutoSynchronize (b, cnt);;
let synchronize cnt = Synchronize (cnt);;
let displayMode b cnt = DisplayMode (b, cnt);;
let rememberMode b cnt = RememberMode (b, cnt);;
let getPixelColor x y cnt = GetPixelColor (x, y, cnt);;
  
let setColor c cnt = SetColor (c, cnt);;
let setLineWidth lw cnt = SetLineWidth (lw, cnt);;
  
let drawPixel x y cnt = DrawPixel (x, y, cnt);;
let drawLines ll cnt = DrawLines (ll, cnt);;
let drawJointLines pl cnt = DrawJointLines (pl, cnt);;
let drawPolygon pl cnt = DrawPolygon (pl, cnt);;
let drawRectangle x y w h cnt = DrawRectangle (x, y, w, h, cnt);;
let drawArc x y rw ry a1 a2 cnt = DrawArc (x, y, rw, ry, a1, a2, cnt);;
let drawEllipse x y rw ry cnt = DrawEllipse (x, y, rw, ry, cnt);;
let drawCircle x y r cnt = DrawCircle (x, y, r, cnt);;
let fillPolygon pl cnt = FillPolygon (pl, cnt);;
let fillRectangle x y w h cnt = FillRectangle (x, y, w, h, cnt);;
let fillArc x y rx ry a1 a2 cnt = FillArc (x, y, rx, ry, a1, a2, cnt);;
let fillEllipse x y rx ry cnt = FillEllipse (x, y, rx, ry, cnt);;
let fillCircle x y r cnt = FillCircle (x, y, r, cnt);;
  
let setFont f cnt = SetFont (f, cnt);;
let setFontSize s cnt = SetFontSize (s, cnt);;
let getTextSize s cnt = GetTextSize (s, cnt);;
let drawChar x y c cnt = DrawChar (x, y, c, cnt);;
let drawString x y s cnt = DrawString (x, y, s, cnt);;
  
let getImage x y w h cnt = GetImage (x, y, w, h, cnt);;
let drawImage img x y cnt = DrawImage (img, x, y, cnt);;
  
let waitNextEvent el cnt = WaitNextEvent (el, cnt);;

let quit = Quit;;
