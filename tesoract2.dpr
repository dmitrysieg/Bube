program Tesoract3;

{$APPTYPE GUI}
{ BY SIEG.....}

uses
   Windows,
   MultiMon,
   Messages,
   SysUtils;


type
   DPI_AWARENESS_CONTEXT = THandle;
   RGB = record
      b, g, r: byte;
   end;
   TArr = array [0..0] of RGB;
   vec4 = array [0..3] of Real;

const
   DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE = DPI_AWARENESS_CONTEXT(-3);
   clsName = 'TSRClass' + #0;
   wndName = '' + #0;
   bube: array [1..16] of vec4 =
   ((0,0,0,0),
    (0,0,0,1),
    (0,0,1,1),
    (0,0,1,0),
    (0,1,1,0),
    (0,1,1,1),
    (0,1,0,1),
    (0,1,0,0),
    (1,1,0,0),
    (1,1,0,1),
    (1,1,1,1),
    (1,1,1,0),
    (1,0,1,0),
    (1,0,1,1),
    (1,0,0,1),
    (1,0,0,0));
   cubeCenter: vec4 = (-0.5, -0.5, -0.5, -0.5);

var
   hInst, x, hdc, hwnd: LongWord;
   wClass: TWndClass;
   msg: tagMSG;
   junk: array [0..255] of Byte;
   bmp: ^TArr;
   hdr: BITMAPINFO;
   v00, dr, t: array [1..16] of vec4;
   e00: array [1..100, 0..1] of Word;

   mainMonitorScreenSize: TPoint;
   i, j, m, k, ec, delay, sx, sy, sz: Integer;
   a, b, c, d: Real;
   xcol: RGB;
   isPaused: Boolean;
   qrect: TRect;

procedure rotate4d(var dst: vec4;
                       src: vec4;
                       angle: real;
                       t0, t1, t2, t3: Integer);
begin
   dst[t0] := src[t0] * cos(angle) - src[t1] * sin(angle);
   dst[t1] := src[t0] * sin(angle) + src[t1] * cos(angle);
   dst[t2] := src[t2];
   dst[t3] := src[t3]
end;

procedure translate4d(var dst: vec4; src, mov: vec4);
begin
   dst[0] := src[0] + mov[0];
   dst[1] := src[1] + mov[1];
   dst[2] := src[2] + mov[2];
   dst[3] := src[3] + mov[3]
end;

procedure scale4d(var dst: vec4; src: vec4; k: real);
begin
   dst[0] := src[0] * k;
   dst[1] := src[1] * k;
   dst[2] := src[2] * k;
   dst[3] := src[3] * k
end;

procedure line(x1, y1, x2, y2: Integer);
var
   q, xe, ye, dx, dy, ix, iy, d, x, y: Integer;
begin
   xe := 0;
   ye := 0;
   dx := x2 - x1;
   dy := y2 - y1;

   if dx > 0 then ix :=  1 else
   if dx < 0 then ix := -1 else ix := 0;
   if dy > 0 then iy :=  1 else
   if dy < 0 then iy := -1 else iy := 0;

   dx := abs(dx);
   dy := abs(dy);
   if dx > dy then d := dx else d := dy;

   x := x1;
   y := y1;
   if (x >= 0) and (x <= sx - 1) and
      (y >= 0) and (y <= sy - 1) then begin
      bmp^[y * sx + x].r := xcol.r;
      bmp^[y * sx + x].g := xcol.g;
      bmp^[y * sx + x].b := xcol.b;
   end;

   for q := 1 to d do begin
      inc(xe, dx);
      inc(ye, dy);

      if xe > d then begin dec(xe, d); inc(x, ix); end;
      if ye > d then begin dec(ye, d); inc(y, iy); end;

      if (x >= 0) and (x <= sx - 1) and
         (y >= 0) and (y <= sy - 1) then begin
         bmp^[y * sx + x].r := xcol.r;
         bmp^[y * sx + x].g := xcol.g;
         bmp^[y * sx + x].b := xcol.b;
      end;
   end;
end;

function WndProc(hwnd, msg, wPar, lPar: LongWord): LongWord; stdcall;
var
   pStr: TPaintStruct;
begin
   case msg of

      WM_CREATE: WndProc := 1;

      WM_DESTROY: begin
         KillTimer(hwnd, $300);
         PostQuitMessage(0);
      end;

      WM_PAINT: begin
         BeginPaint(hwnd, pStr);

         xcol.b := round(255 * cos(a));
         xcol.g := round(255 * cos(b));
         xcol.r := round(255 * cos(c));

         FillMemory(bmp, sx * sy * 3, 0);
         for i := 1 to 16 do begin
            translate4d(t[i], v00[i], cubeCenter);
            scale4d(dr[i], t[i], sz);
            rotate4d(t[i], dr[i], a, 1, 2, 3, 0);
            rotate4d(dr[i], t[i], b, 2, 3, 0, 1);
            rotate4d(t[i], dr[i], c, 3, 0, 1, 2);
            rotate4d(dr[i], t[i], d, 0, 1, 2, 3);
            for j := 1 to ec do begin
            line(round(sx div 2 + dr[e00[j, 0]][0]),
                 round(sy div 2 + dr[e00[j, 0]][2]),
                 round(sx div 2 + dr[e00[j, 1]][0]),
                 round(sy div 2 + dr[e00[j, 1]][2]));
            end;
         end;

         xcol.b := 50;
         xcol.g := 78;
         xcol.r := 40;

         line(32, 28, 32, 51);
         line(32, 28, 46, 36);
         line(46, 36, 32, 40);
         line(32, 40, 46, 46);
         line(46, 46, 32, 51);
         //
         line(54, 28, 54, 49);
         line(54, 28, 64, 37);
         line(62, 49, 64, 28);
         //
         line(72, 28, 72, 51);
         line(72, 28, 86, 36);
         line(86, 36, 72, 40);
         line(72, 40, 86, 46);
         line(86, 46, 72, 51);
         //
         line(96, 28, 96,  50);
         line(96, 28, 108, 30);
         line(96, 50, 107, 49);
         line(95, 36, 108, 36);
         //
         line(130, 28, 130, 51);
         line(130, 51, 122, 40);
         //
         line(134, 28, 137, 28);
         line(134, 28, 134, 32);
         line(134, 32, 138, 32);
         line(138, 32, 139, 28);
         //
         line(150, 28, 148, 51);
         line(148, 51, 160, 51);
         line(160, 51, 160, 27);
         line(160, 27, 150, 28);

         StretchDIBits(pStr.hdc, 0, 0, sx, sy,
                                 0, 0, sx, sy,
                                 bmp, hdr, DIB_RGB_COLORS, SRCCOPY);

         a := a + pi / 41; if a >= 2 * pi then a := a - 2 * pi;
         b := b + pi / 53; if b >= 2 * pi then b := b - 2 * pi;
         c := c + pi / 67; if c >= 2 * pi then c := c - 2 * pi;
         d := d + pi / 79; if d >= 2 * pi then d := d - 2 * pi;

         EndPaint(hwnd, pStr);
      end;

      WM_TIMER: InvalidateRect(hwnd, @qRect, False);

      WM_KEYDOWN:
         case wPar of

            VK_ESCAPE: sendmessage(hwnd,WM_CLOSE,0,0);

            VK_PAUSE: begin
               if not isPaused then begin
                  KillTimer(hwnd, $300);
                  isPaused := True;
               end else begin
                  SetTimer(hwnd, $300, delay, nil);
                  isPaused := False;
               end
            end;

            VK_NEXT: begin
               inc(delay);
               KillTimer(hwnd, $300);
               SetTimer(hwnd, $300, delay, nil);
            end;

            VK_PRIOR: begin
               if delay > 0 then
                  dec(delay);
               KillTimer(hwnd, $300);
               SetTimer(hwnd, $300, delay, nil);
            end;
         end;

      else WndProc := DefWindowProc(hwnd, msg, wPar, lPar);
   end;
end;

function MonitorEnumProc(hm: HMONITOR; dc: LongWord; r: PRect; p: PPoint): Boolean; stdcall;
var
   monitorInfo: MultiMon.MONITORINFO;
begin
   monitorInfo.cbSize := sizeOf(monitorInfo);
   GetMonitorInfoA(hm, @monitorInfo);
   if (monitorInfo.dwFlags = MONITORINFOF_PRIMARY) then begin
      p.X := r.Right;
      p.Y := r.Bottom;
   end;
   MonitorEnumProc := True;
end;

function GetMainMonitorScreenSize: TPoint;
var
   p: TPoint;
begin
   EnumDisplayMonitors(0, nil, @MonitorEnumProc, LParam(@p));
   GetMainMonitorScreenSize := p;
end;

function SetThreadDpiAwarenessContext(context: LongWord): LongWord; stdcall; external 'user32.dll' name 'SetThreadDpiAwarenessContext';

procedure adjustDpiAwareness;
begin
   SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE);
end;

begin
   adjustDpiAwareness();

   mainMonitorScreenSize := GetMainMonitorScreenSize();

   sx := mainMonitorScreenSize.X;
   sy := mainMonitorScreenSize.Y;
   sz := sx * 3 div 10;

   qRect.Left := 0;
   qRect.Top := 0;
   qRect.Right := sx - 1;
   qRect.Bottom := sy - 1;

   for i := 1 to 16 do v00[i] := bube[i];

   for i := 1 to 16 do begin
      for j := i + 1 to 16 do
         if i <> j then begin
            m := 0;
            for k := 0 to 3 do if v00[i][k] <> v00[j][k] then inc(m);
            if m = 1 then begin
               inc(ec);
               e00[ec, 0] := i;
               e00[ec, 1] := j
            end;
         end;
   end;

   randomize;

   hInst := GetModuleHandle(nil);
   with hdr.bmiHeader do begin
      biSize         := 40;
      biWidth        := sx;
      biHeight       := sy;
      biPlanes       := 1;
      biBitCount     := 24;
      biCompression  := 0;
      biSizeImage    := sx * sy * 3
   end;

   for x := 0 to 127 do junk[x] := 255;

   bmp := Pointer(GlobalAlloc(GMEM_FIXED, 3 * sx * sy));

   with wClass do begin
      style          := CS_HREDRAW or CS_VREDRAW;
      lpfnWndProc    := @WndProc;
      cbClsExtra     := 0;
      cbWndExtra     := 0;
      hInstance      := hInst;
      hIcon          := LoadIcon(0, IDI_APPLICATION);
      hCursor        := CreateCursor(hInst, 0, 0, 32, 32, @junk, @junk[128]);
      hbrBackground  := CreateSolidBrush(0);
      lpszMenuName   := nil;
      lpszClassName  := clsName;
   end;

   RegisterClass(wClass);
   hwnd := CreateWindow(clsName, wndName, WS_POPUP, 0, 0, sx, sy, 0, 0, hInst, nil);

   delay := 20;
   settimer(hwnd, $300, delay, nil);
   isPaused := False;
   ShowWindow(hwnd, SW_SHOWNORMAL);
   UpdateWindow(hwnd);
   hdc := GetDC(hwnd);

   while GetMessage(msg, 0, 0, 0) do begin
      TranslateMessage(msg);
      DispatchMessage(msg);
   end;

   DeleteObject(wClass.hbrBackground);
   DestroyCursor(wClass.hCursor);
   releasedc(hwnd, hdc);
   GlobalFree(Cardinal(bmp));
end.
