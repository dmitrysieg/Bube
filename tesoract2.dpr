program tesoract2;

{$APPTYPE GUI}
{ BY SIEG.....}

uses
  windows,
  messages,
  sysutils;


type
   rgb = record
      b,g,r:byte;
   end;
   TArr = array [0..0] of rgb;
	vec4 = array [0..3] of real;

const
   clname = 'TSRClass'+#0;
   wname = ''+#0;
   bube : array [1..16] of vec4 =
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
    (1,0,0,0)
   );

   qrect: tRECT = (left:0;top:0;right:1023;bottom:767);

var
   hinst,x,hdc,hwnd:longword;
   wclass: tWndclass;
   mm: tagMSG;
   junk: array [0..255] of byte;
   bmp:^TArr;
   hdr:BITMAPINFO;
   v00,dr,t:array [1..16] of vec4;
   e00:array [1..100,0..1] of word;
   tr0:vec4;
   i,j,m,k,ec,del,sx,sy,sz:integer;
   a,b,c,d:real;
   xcol:rgb;
   tfl:boolean;

procedure rotat_com(var de,so:vec4;
						a:real;
						t0,t1,t2,t3:integer);
begin
   de[t0] := so[t0] * cos(a) - so[t1] * sin(a);
   de[t1] := so[t0] * sin(a) + so[t1] * cos(a);
   de[t2] := so[t2];
   de[t3] := so[t3]
end;

procedure trans_com(var de,so,mov:vec4);
begin
	de[0] := so[0] + mov[0];
   de[1] := so[1] + mov[1];
   de[2] := so[2] + mov[2];
   de[3] := so[3] + mov[3]
end;

procedure scale_com(var de,so:vec4; k:real);
begin
   de[0] := so[0] * k;
   de[1] := so[1] * k;
   de[2] := so[2] * k;
   de[3] := so[3] * k
end;

procedure line(x1,y1,x2,y2:integer);
var
   q,xe,ye,dx,dy,ix,iy,d,x,y:integer;
begin
   xe:=0; ye:=0;
   dx:=x2-x1; dy:=y2-y1;
   if dx>0 then ix:=1 else
   if dx<0 then ix:=-1 else ix:=0;
   if dy>0 then iy:=1 else
   if dy<0 then iy:=-1 else iy:=0;
   dx:=abs(dx); dy:=abs(dy);
   if dx>dy then d:=dx else d:=dy;
   x:=x1; y:=y1;
   if (x>=0)and(x<=sx-1)and(y>=0)and(y<=sy-1) then begin
      bmp^[y*sx+x].r:=xcol.r;
      bmp^[y*sx+x].g:=xcol.g;
      bmp^[y*sx+x].b:=xcol.b;
   end;
   for q:=1 to d do begin
      inc(xe,dx); inc(ye,dy);
      if xe>d then begin dec(xe,d); inc(x,ix); end;
      if ye>d then begin dec(ye,d); inc(y,iy); end;
      if (x>=0)and(x<=sx-1)and(y>=0)and(y<=sy-1) then begin
         bmp^[y*sx+x].r:=xcol.r;
         bmp^[y*sx+x].g:=xcol.g;
         bmp^[y*sx+x].b:=xcol.b;
      end;
   end;
end;

function WndProc(hwnd, msg, wpar, lpar:longword):longword; stdcall;
var
   pstr:paintstruct;
begin
   case msg of
      WM_CREATE: WndProc:=1;
      WM_DESTROY: begin
         killtimer(hwnd, $300);
         postquitmessage(0);
      end;
      WM_PAINT: begin
         beginpaint(hwnd, pstr);

         xcol.b:=round(255*cos(a));
         xcol.g:=round(255*cos(b));
         xcol.r:=round(255*cos(c));

         fillmemory(bmp, sx*sy*3, 0);
         for i:=1 to 16 do begin
            trans_com(t[i], v00[i], tr0);
            scale_com(dr[i], t[i], sz);
            rotat_com(t[i], dr[i], a, 1,2,3,0);
            rotat_com(dr[i], t[i], b, 2,3,0,1);
            rotat_com(t[i], dr[i], c, 3,0,1,2);
            rotat_com(dr[i], t[i], d, 0,1,2,3);
            for j:=1 to ec do begin
            line(round(sx div 2+dr[e00[j,0]][0]),
                  round(sy div 2+dr[e00[j,0]][2]),
                  round(sx div 2+dr[e00[j,1]][0]),
   			      round(sy div 2+dr[e00[j,1]][2]));
            end;
         end;

         xcol.b:=50; xcol.g:=78; xcol.r:=40;
         line(32,28,32,51);
         line(32,28,46,36);
         line(46,36,32,40);
         line(32,40,46,46);
         line(46,46,32,51);
         //
         line(54,28,54,49);
         line(54,28,64,37);
         line(62,49,64,28);
         //
         line(72,28,72,51);
         line(72,28,86,36);
         line(86,36,72,40);
         line(72,40,86,46);
         line(86,46,72,51);
         //
         line(96,28,96,50);
         line(96,28,108,30);
         line(96,50,107,49);
         line(95,36,108,36);
         //
         line(130,28,130,51);
         line(130,51,122,40);
         //
         line(134,28,137,28);
         line(134,28,134,32);
         line(134,32,138,32);
         line(138,32,139,28);
         //
         line(150,28,148,51);
         line(148,51,160,51);
         line(160,51,160,27);
         line(160,27,150,28);
         stretchdibits(pstr.hdc, 0,0,sx,sy,
                                 0,0,sx,sy,
                                 bmp,hdr, DIB_RGB_COLORS, SRCCOPY);
         a:=a+pi/41; if a>=2*pi then a:=a-2*pi;
         b:=b+pi/53; if b>=2*pi then b:=b-2*pi;
         c:=c+pi/67; if c>=2*pi then c:=c-2*pi;
         d:=d+pi/79; if d>=2*pi then d:=d-2*pi;

         endpaint(hwnd,pstr);
      end;
      WM_TIMER: invalidaterect(hwnd,@qrect,false);
      WM_KEYDOWN:
         case wpar of
         VK_ESCAPE: sendmessage(hwnd,WM_CLOSE,0,0);
         VK_PAUSE: begin
            if tfl then begin
               killtimer(hwnd,$300);
               tfl:=false;
            end else begin
               settimer(hwnd,$300,del,nil);
               tfl:=true;
            end
         end;
         34: begin
            inc(del);
            killtimer(hwnd,$300);
            settimer(hwnd,$300,del,nil);
         end;
         33: begin
            if del<>0 then
               dec(del);
            killtimer(hwnd,$300);
            settimer(hwnd,$300,del,nil);
         end;
         end;

      else WndProc:=DefWindowProc(hwnd,msg, wpar, lpar);
   end;
end;

begin
   sx:=GetSystemMetrics(SM_CXSCREEN);
   sy:=GetSystemMetrics(SM_CYSCREEN);
   sz:=sx * 3 div 10;

   tr0[0]:=-0.5;
   tr0[1]:=-0.5;
   tr0[2]:=-0.5;
   tr0[3]:=-0.5;

   for i:=1 to 16 do v00[i]:=bube[i];

   for i:=1 to 16 do begin
      for j:=i+1 to 16 do
      	if i<>j then begin
         	m:=0;
         	for k:=0 to 3 do if v00[i][k]<>v00[j][k] then inc(m);
         	if m=1 then begin
            	inc(ec);
               e00[ec,0]:=i;
               e00[ec,1]:=j
            end;
         end;
   end;

   randomize;
   hinst:=GetModuleHandle(nil);
   with hdr.bmiHeader do begin
      biSize:=40;
      biWidth:=sx;
      biHeight:=sy;
      biPlanes:=1;
      biBitCount:=24;
      biCompression:=0;
      biSizeImage:=sx*sy*3
   end;
   for x:=0 to 127 do junk[x]:=255;

   bmp:=pointer(GlobalAlloc(GMEM_FIXED, 3*sx*sy));

   with wclass do begin
      style:=cs_HRedraw or cs_VRedraw;
      lpfnWndProc:=@wndproc;
      cbClsExtra:=0;
      cbWndExtra:=0;
      hInstance:=hinst;
      hIcon:=loadicon(0, IDI_APPLICATION);
      hCursor:= CreateCursor(hinst, 0, 0, 32, 32, @junk, @junk[128]);
      hbrBackground:=createSolidBrush(0);
      lpszMenuName:=nil;
      lpszClassName:=clname;
   end;

   registerclass(wclass);
   hwnd:=CreateWindow(clname, wname, ws_popup, 0, 0, sx, sy, 0, 0, hinst, nil);

   del:=20;
   settimer(hwnd, $300,del,nil);
   tfl:=true;
   ShowWindow(hwnd, SW_SHOWNORMAL);
   UpdateWindow(hwnd);
   hdc:=getdc(hwnd);

   while GetMessage(mm, 0, 0, 0) do begin
      TranslateMessage (mm);
      DispatchMessage (mm);
   end;
   DeleteObject(wclass.hbrBackground);
   DestroyCursor(wclass.hCursor);
   releasedc(hwnd,hdc);
   GlobalFree(cardinal(bmp));
end.
